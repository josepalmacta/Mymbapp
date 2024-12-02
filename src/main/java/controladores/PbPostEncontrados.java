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
import modelos.postEncontrados;
import modelos.postPerdidos;
import org.postgresql.util.PSQLException;
import utilidades.Keyz;

/**
 *
 * @author Usuario
 */
@WebServlet(name = "PbPostEncontrados", urlPatterns = {"/encontrados/*"})
public class PbPostEncontrados extends HttpServlet {

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

    private void mostrarPost(String value, String pathInfo, HttpServletRequest request, HttpServletResponse response, Connection connection) throws Exception {
        postEncontrados post = new postEncontrados(connection);
        post.setId(value);
        System.err.println(pathInfo);
        JsonObject obj = post.listarID();
        if (!obj.getBoolean("hay")) {
            response.setStatus(404);
            return;
        }
        request.setAttribute("dets", post.listarID());
        getServletConfig().getServletContext().getRequestDispatcher("/vistas/public/postEncontrado.jsp").forward(request, response);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
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

        String pathInfo = request.getPathInfo(); // /{value}/test
        if (pathInfo == null) {
            getServletConfig().getServletContext().getRequestDispatcher("/vistas/public/buscarEncontrados.jsp").forward(request, response);
            return;
        }
        String[] pathParts = pathInfo.split("/");

        String action = pathParts[1]; // test

        System.err.println(pathInfo);

        try (Connection connection = dataSource.getConnection()) {
            if (action.equals("post")) {

                String value = pathParts[2];
                if (!value.equals("vistas")) {

                    if (value.equals("add")) {
                        if (sesion.getAttribute("login") == null) {
                            response.sendRedirect("/login");
                            return;
                        }
                        getServletConfig().getServletContext().getRequestDispatcher("/vistas/public/postEncontrados.jsp").forward(request, response);
                        return;
                    } else if (esNum(value)) {
                        if (pathParts.length > 3 && pathParts[3].equals("edit")) {
                            if (sesion.getAttribute("login") == null) {
                                response.sendRedirect("/login");
                                return;
                            }
                            postEncontrados post = new postEncontrados(connection);
                            post.setId(value);
                            post.setPersona(sesion.getAttribute("idper").toString());
                            request.setAttribute("dets", post.listarID());
                            getServletConfig().getServletContext().getRequestDispatcher("/vistas/public/editEncontrados.jsp").forward(request, response);
                            return;
                        }
                        mostrarPost(value, pathInfo, request, response, connection);
                    }

                }

            }

        } catch (Exception ex) {
            System.err.println(ex.getMessage());
            response.getWriter().write(ex.getMessage());
        }

    }

    private String getRes(boolean success, String estado, String mensaje) {

        JsonObject object = Json.createObjectBuilder()
                .add("estado", estado)
                .add("success", success)
                .add("mensaje", mensaje)
                .build();

        return object.toString();
    }

    private void addPost() {
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
        String value = pathParts[1]; // {value}
        String action = pathParts[1]; // test

        HttpSession sesion = request.getSession();

        try (Connection connection = dataSource.getConnection()) {
            postEncontrados post = new postEncontrados(connection);
            if (action.equals("add")) {
                StringBuffer jb = new StringBuffer();
                String line = null;

                BufferedReader reader = request.getReader();
                while ((line = reader.readLine()) != null) {
                    jb.append(line);
                }

                JsonReader jsonReader = Json.createReader(new StringReader(jb.toString()));
                JsonObject obj = jsonReader.readObject();
                jsonReader.close();

                
                post.setImgPath(request.getSession().getServletContext().getRealPath("imgs/posts/e"));
                post.setBarrio(obj.getString("barrio"));
                post.setContacto(obj.getString("contacto"));
                post.setEstado("ENCONTRADO");
                post.setInfo(obj.getString("info"));
                post.setFecha(java.time.LocalDate.now().toString());
                post.setLatitud(obj.getString("lat"));
                post.setLongitud(obj.getString("long"));
                
                
                if (obj.containsKey("device") && obj.getString("device").equals("app")) {
                    Algorithm algorithm = Algorithm.RSA256(Keyz.loadPublicKey(), Keyz.loadPrivateKey());
                    JWTVerifier verifier = JWT.require(algorithm)
                            .withIssuer("auth0")
                            .build();
                    DecodedJWT decodedJWT = verifier.verify(obj.getString("token"));
                    post.setPersona(decodedJWT.getClaim("uid").asString());
                } else {
                    post.setPersona(sesion.getAttribute("idper").toString());
                }
                
                
                
                post.guardarCabecera(obj.getJsonArray("mascotas"));
                response.getWriter().write(getRes(true, "success", "PUBLICACION CREADA"));

            } else if (action.equals("edit")) {
                post.setContacto(request.getParameter("contacto"));
                post.setInfo(request.getParameter("info"));
                post.setId(request.getParameter("post"));
                post.setLatitud(request.getParameter("lat"));
                post.setLongitud(request.getParameter("long"));
                post.setPersona(sesion.getAttribute("idper").toString());
                post.modificarPost();
                response.getWriter().write(getRes(true, "success", "PUBLICACION ACTUALIZADA"));
                return;
            }
            else if (action.equals("finalizar")) {
                post.setId(request.getParameter("post"));
                post.setPersona(sesion.getAttribute("idper").toString());
                post.finalizarPost();
                response.getWriter().write(getRes(true, "success", "PUBLICACION FINALIZADA"));
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
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
