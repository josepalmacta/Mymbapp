/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controladores;

import jakarta.json.JsonValue;
import jakarta.json.Json;
import jakarta.json.JsonArray;
import jakarta.json.JsonArrayBuilder;
import jakarta.json.JsonObject;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import javax.sql.DataSource;
import modelos.departamentos;
import org.postgresql.util.PSQLException;

/**
 *
 * @author Usuario
 */
@WebServlet(name = "Svdepartamentos", urlPatterns = {"/gestionar/departamentos"})
public class Svdepartamentos extends HttpServlet {
    
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
    
    
    
    private String getRes(String estado, String mensaje){
        
        JsonObject object = Json.createObjectBuilder()
                        .add("estado", estado)
                        .add("mensaje", mensaje)
                        .build();
        
        return object.toString();
    }
    
    
    
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet Svdepartamentos</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Svdepartamentos at " + request.getContextPath() + "</h1>");
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
        HttpSession sesion = request.getSession();        
        if(!sesion.getAttribute("rol").equals("ADMINISTRADOR")){
            response.sendRedirect("/dashboard/inicio");
            return;
        }
        response.setContentType("text/html;charset=UTF-8");
        request.getRequestDispatcher("vistas/departamentos.jsp").forward(request, response);
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

        String opt = request.getParameter("opt");

        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");

        try(Connection connection = dataSource.getConnection()) {
            departamentos dep = new departamentos(connection);
            if (opt != null && opt.equals("add")) {
                String nombre = request.getParameter("nombre");
                String code = request.getParameter("code");
                dep.setNombre(nombre);
                dep.setCodigo(code);
                dep.guardar();
                response.getWriter().write(getRes("success", "GUARDADO"));

            } else if (opt != null && opt.equals("edit")) {
                String nombre = request.getParameter("nombre");
                String code = request.getParameter("code");
                String id = request.getParameter("codigo");
                dep.setId(id);
                dep.setNombre(nombre);
                dep.setCodigo(code);
                dep.modificar();
                response.getWriter().write(getRes("success", "MODIFICADO"));
            } else if (opt != null && opt.equals("del")) {
                String id = request.getParameter("codigo");
                dep.setId(id);
                dep.eliminar();
                response.getWriter().write(getRes("success", "ELIMINADO"));
            } else if (opt != null && opt.equals("list")) {
                request.setAttribute("res", dep.listar());
                response.getWriter().write(dep.listar().toString());

            } else {
                request.setAttribute("res", dep.listar());
                request.getRequestDispatcher("/jsp/departamentos.jsp").forward(request, response);
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
