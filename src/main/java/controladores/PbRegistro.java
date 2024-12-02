/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controladores;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.json.Json;
import jakarta.json.JsonArray;
import jakarta.json.JsonArrayBuilder;
import jakarta.json.JsonObject;
import jakarta.json.JsonReader;
import jakarta.json.JsonString;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.StringReader;
import java.security.interfaces.RSAPrivateKey;
import java.security.interfaces.RSAPublicKey;
import java.sql.Connection;
import java.sql.JDBCType;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.sql.DataSource;
import modelos.personas;
import modelos.postPerdidos;
import org.postgresql.util.PSQLException;
import static utilidades.Keyz.loadPrivateKey;
import static utilidades.Keyz.loadPublicKey;

/**
 *
 * @author Usuario
 */
@WebServlet(name = "PbRegistro", urlPatterns = {"/registro/*"})
public class PbRegistro extends HttpServlet {

    DataSource dataSource;

    @Override
    public void init() throws ServletException {
        super.init();
        // Obtener el DataSource del ServletContext
        dataSource = (DataSource) getServletContext().getAttribute("dataSource");
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet PbRegistro</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet PbRegistro at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo(); // /{value}/test
        if (pathInfo == null) {
            getServletConfig().getServletContext().getRequestDispatcher("/vistas/public/registro.jsp").forward(request, response);
            return;
        }
        String[] pathParts = pathInfo.split("/");

        String action = pathParts[1];

        if (action.equals("confirmacion")) {
            String confcode = request.getParameter("codigo");
            if (confcode != null) {
                try (Connection connection = dataSource.getConnection()) {
                    personas per = new personas(connection);
                    per.setEmail(confcode);
                    String stats = "errorconf";
                    if (per.verificarCodigoReg()) {
                        stats = "confirmado";
                    }
                    request.setAttribute("tipo", stats);
                    getServletConfig().getServletContext().getRequestDispatcher("/vistas/public/confregistro.jsp").forward(request, response);
                    return;

                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            request.setAttribute("tipo", "confform");
            getServletConfig().getServletContext().getRequestDispatcher("/vistas/public/confregistro.jsp").forward(request, response);
            return;
        }

    }

    private void enviarCodigo() {
    }

    private String getRes(boolean success, String estado, String mensaje) {

        JsonObject object = Json.createObjectBuilder()
                .add("estado", estado)
                .add("success", success)
                .add("mensaje", mensaje)
                .build();

        return object.toString();
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        try (Connection connection = dataSource.getConnection()) {
            personas per = new personas(connection);
            if (pathInfo == null) {
                String nombre = request.getParameter("nombre");
                String email = request.getParameter("email");
                String clave = request.getParameter("clave");
                String barrio = request.getParameter("barrio");
                String devic = request.getParameter("device");
                per.setNombre(nombre);
                per.setEmail(email);
                per.setClave(clave);
                per.setBarrio(barrio);

                per.guardar();

                HttpSession sesion = request.getSession();

                sesion.setAttribute("login", true);
                sesion.setAttribute("persona", per.getNombre());
                sesion.setAttribute("idper", per.getId());
                sesion.setAttribute("imag", "default.jpg");

                String resp = "BIENVENIDO";
                if (devic != null && devic.equals("app")) {
                    resp = generarToken(per.getId(), per.getNombre(), "default.jpg");
                }
                response.getWriter().write(getRes(true, "success", resp));
                return;
            }
            String[] pathParts = pathInfo.split("/");
            String action = pathParts[1];
            if (action.equals("confirmacion")) {
                String email = request.getParameter("email");
                per.setEmail(email);
                if (per.verificarEmail()) {
                    response.getWriter().write(getRes(true, "success", "Enlace de confirmacion enviado"));
                    return;
                }
                response.getWriter().write(getRes(false, "error", "El email no existe o ya fue confirmado."));
                return;
            }

        } catch (PSQLException ex) {
            if (ex.getSQLState().equals("23505")) {
                response.getWriter().write(getRes(false, "error", "EL E-MAIL INGRESADO YA EXISTE."));
            } else {
                response.getWriter().write(getRes(false, "error", ex.getMessage()));
            }

        } catch (Exception ex) {
            response.getWriter().write(getRes(false, "error", ex.getMessage()));
        }

    }
    
    
    public String generarToken(String id, String persona, String img) throws Exception {
        RSAPublicKey rsaPublicKey = loadPublicKey();
        RSAPrivateKey rsaPrivateKey = loadPrivateKey();

        Algorithm algorithm = Algorithm.RSA256(rsaPublicKey, rsaPrivateKey);
        String token = JWT.create()
                .withIssuer("auth0")
                .withClaim("uid", id)
                .withClaim("unombre", persona)
                .withClaim("uimg", img)
                .sign(algorithm);
        return token;
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
