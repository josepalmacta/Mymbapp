/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controladores;

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
import modelos.postAdopcion;
import modelos.postPerdidos;
import org.postgresql.util.PSQLException;

/**
 *
 * @author Usuario
 */
@WebServlet(name = "SvAdopciones", urlPatterns = {"/gestionar/adopciones"})
public class SvAdopciones extends HttpServlet {
    
    
    DataSource dataSource;
    
    @Override
    public void init() throws ServletException {
        super.init();
        // Obtener el DataSource del ServletContext
        dataSource = (DataSource) getServletContext().getAttribute("dataSource");
    }
    
    
    private String getRes(String estado, String mensaje){
        
        JsonObject object = Json.createObjectBuilder()
                        .add("estado", estado)
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
            out.println("<title>Servlet SvAdopciones</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SvAdopciones at " + request.getContextPath() + "</h1>");
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
        processRequest(request, response);
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
        
        
        
        String opt = request.getParameter("opt");
        response.setCharacterEncoding("UTF-8");

        try(Connection connection = dataSource.getConnection()) {
            postAdopcion post = new postAdopcion(connection);
             if (opt != null && opt.equals("del")) {
                String id = request.getParameter("codigo");
                post.setImgPath(request.getSession().getServletContext().getRealPath("imgs/posts/a"));
                post.setId(id);
                post.elim();
                response.getWriter().write(getRes("success", "PUBLICACION ELIMINADA"));
            } else if (opt != null && opt.equals("aprobar")) {
                String id = request.getParameter("codigo");
                post.setId(id);
                post.aprobar();
                response.getWriter().write(getRes("success", "PUBLICACION APROBADA"));
            
            } else if (opt != null && opt.equals("post")) {
                String id = request.getParameter("codigo");
                post.setId(id);
                request.setAttribute("dets", post.listarID());
                request.setAttribute("tipo", "post");
                request.getRequestDispatcher("/jsp/adopciones.jsp").forward(request, response);

            } else {
                request.setAttribute("res", post.listar());
                request.setAttribute("tipo", "tabla");
                request.getRequestDispatcher("/jsp/adopciones.jsp").forward(request, response);
            }
        } catch (PSQLException ex) {
            if (ex.getSQLState().equals("23505")) {
                response.getWriter().write(getRes("error", "LOS DATOS INGRESADOS YA EXISTEN."));
            }

        } catch (Exception e) {
            response.getWriter().write(getRes("error", e.getMessage()));
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
