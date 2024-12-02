/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controladores;

import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;
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
import java.sql.Connection;
import java.sql.JDBCType;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.sql.DataSource;
import modelos.personas;
import modelos.postPerdidos;
import modelos.ventas;
import net.sf.jasperreports.engine.JRRenderable;
import org.postgresql.util.PSQLException;
import utilidades.AdamsPayAPI;
import utilidades.Keyz;

/**
 *
 * @author Usuario
 */
@WebServlet(name = "PbCuenta", urlPatterns = {"/usuario/*"})
public class PbCuenta extends HttpServlet {
    
    DataSource dataSource;
    
    @Override
    public void init() throws ServletException {
        super.init();
        // Obtener el DataSource del ServletContext
        dataSource = (DataSource) getServletContext().getAttribute("dataSource");
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
            out.println("<title>Servlet PbCuenta</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet PbCuenta at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    public static boolean esNum(String num) {
        if (num == null) {
            return false;
        }
        try {
            double d = Double.parseDouble(num);
        } catch (NumberFormatException nfe) {
            return false;
        }
        return true;
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

        response.setContentType("text/html;charset=UTF-8");

        HttpSession sesion = request.getSession();
        if (sesion.getAttribute("login") == null) {
            response.sendRedirect("/login");
            return;
        }

        try(Connection connection = dataSource.getConnection()) {
            String pathInfo = request.getPathInfo(); // /{value}/test
            if (pathInfo == null) {
                personas per = new personas(connection);
                per.setId(sesion.getAttribute("idper").toString());
                try {
                    request.setAttribute("dets", per.listarIDD());
                } catch (Exception ex) {
                    System.err.println(ex.getMessage());
                }
                getServletConfig().getServletContext().getRequestDispatcher("/vistas/public/usuario.jsp").forward(request, response);
                return;
            }
            String[] pathParts = pathInfo.split("/");

            String action = pathParts[1]; // test

            System.err.println(pathInfo);
            if (action.equals("posts")) {

                //String value = pathParts[2];
                postPerdidos post = new postPerdidos(connection);
                post.setPersona(sesion.getAttribute("idper").toString());
                request.setAttribute("dets", post.listarUsuario());
                getServletConfig().getServletContext().getRequestDispatcher("/vistas/public/postsCreados.jsp").forward(request, response);
                return;

            }
            if (action.equals("compras")) {
                if (pathParts.length > 2 && esNum(pathParts[2])) {
                    ventas ven = new ventas(connection);
                    ven.setPersona(sesion.getAttribute("idper").toString());
                    ven.setProducto(pathParts[2]);
                    AdamsPayAPI adamsPay = new AdamsPayAPI();
                    request.setAttribute("adams", adamsPay.consultarPago(pathParts[2]));
                    request.setAttribute("dets", ven.listarCompra());
                    System.err.println(ven.listarCompra());
                    getServletConfig().getServletContext().getRequestDispatcher("/vistas/public/compra.jsp").forward(request, response);
                    return;
                }

                //String value = pathParts[2];
                ventas ven = new ventas(connection);
                ven.setPersona(sesion.getAttribute("idper").toString());                
                request.setAttribute("dets", ven.listarUsuario());
                getServletConfig().getServletContext().getRequestDispatcher("/vistas/public/pedidosCreados.jsp").forward(request, response);
                return;

            }

        } catch (Exception ex) {
            System.err.println(ex.getMessage());
            response.getWriter().write(ex.getMessage());
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

        response.setContentType("text/html;charset=UTF-8");

        HttpSession sesion = request.getSession();
        if (sesion.getAttribute("login") == null && request.getParameter("device") == null) {
            response.sendRedirect("/login");
            return;
        }

        String pathInfo = request.getPathInfo();

        String[] pathParts = pathInfo.split("/");

        String action = pathParts[1];
        

        try(Connection connection = dataSource.getConnection()) {
            personas per = new personas(connection);
            if (request.getParameter("device") != null) {
                Algorithm algorithm = Algorithm.RSA256(Keyz.loadPublicKey(), Keyz.loadPrivateKey());
                JWTVerifier verifier = JWT.require(algorithm)
                        .withIssuer("auth0")
                        .build();
                DecodedJWT decodedJWT = verifier.verify(request.getParameter("token"));
                per.setId(decodedJWT.getClaim("uid").asString());
            } else {
                per.setId(sesion.getAttribute("idper").toString());
            }
            
            if (action.equals("edit")) {

                //String value = pathParts[2];
                per.setNombre(request.getParameter("nombre"));
                per.setEmail(request.getParameter("email"));
                per.setBarrio(request.getParameter("barrio"));
                per.setImg(request.getParameter("img"));
                per.setImgPath(request.getSession().getServletContext().getRealPath("imgs/user"));
                per.modificarInfo();
                if(!per.getImg().equals("default")){
                    sesion.removeAttribute("imag");
                    sesion.setAttribute("imag", per.getImg());
                }
                response.getWriter().write(getRes(true, "success", "CAMBIOS GUARDADOS"));
                return;

            }

            if (action.equals("chpassw")) {

                
                per.setClave(request.getParameter("opassw"));
                per.setNClave(request.getParameter("npassw"));
                if (!per.modificarPassw()) {
                    response.getWriter().write(getRes(true, "error", "CONTRASEÑA ACTUAL INCORRECTA"));
                    return;
                }
                sesion.invalidate();
                response.getWriter().write(getRes(true, "success", "CONTRASEÑA ACTUALIZADA"));
                return;

            }
        } catch (Exception e) {
            System.err.println(e.getMessage());
            response.getWriter().write(e.getMessage());
        }
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
