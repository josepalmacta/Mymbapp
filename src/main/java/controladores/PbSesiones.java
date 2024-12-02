/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controladores;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import jakarta.jms.Session;
import jakarta.json.Json;
import jakarta.json.JsonObject;
import java.io.IOException;
import java.io.PrintWriter;
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
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.sql.DataSource;
import modelos.sesiones;
import org.postgresql.util.PSQLException;
import utilidades.Keyz;
import static utilidades.Keyz.loadPrivateKey;
import static utilidades.Keyz.loadPublicKey;

/**
 *
 * @author Usuario
 */
@WebServlet(name = "PbSesiones", urlPatterns = {"/sesion/*"})
public class PbSesiones extends HttpServlet {
    
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

    }

    private String getRes(boolean success, String estado, String mensaje) {

        JsonObject object = Json.createObjectBuilder()
                .add("estado", estado)
                .add("success", success)
                .add("mensaje", mensaje)
                .build();

        return object.toString();
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
        String[] pathParts = pathInfo.split("/");
        String actio = pathParts[1];

        if (actio.toLowerCase().equals("logout")) {
            HttpSession sesion = request.getSession();
            sesion.invalidate();
            response.sendRedirect("/");
        }

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

        String pathInfo = request.getPathInfo(); // /{value}/test
        String[] pathParts = pathInfo.split("/");
        String actio = pathParts[1];

        if (actio.toLowerCase().equals("login")) {
            String usr = request.getParameter("email");
            String passw = request.getParameter("clave");
            String devic = request.getParameter("device");
            HttpSession sesion = request.getSession();

            try(Connection connection = dataSource.getConnection()) {
                sesiones login = new sesiones(connection);

                login.setUsuario(usr);
                login.setClave(passw);
                if (login.loginP()) {
                    sesion.setAttribute("login", true);
                    sesion.setAttribute("persona", login.getUsuario());
                    sesion.setAttribute("idper", login.getCodigo());
                    sesion.setAttribute("imag", login.getImagen());
                    String resp = "BIENVENIDO";
                    if(devic != null && devic.equals("app")){
                        resp = generarToken(login.getCodigo(), login.getUsuario(), login.getImagen());
                    }
                    response.getWriter().write(getRes(true, "success", resp));
                } else {
                    response.getWriter().write(getRes(false, "error", "CREDENCIALES INVALIDAS"));
                }
            } catch (Exception ex) {
                Logger.getLogger(Svsesiones.class.getName()).log(Level.SEVERE, null, ex);
            }

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
