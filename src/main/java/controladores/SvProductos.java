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
import javax.sql.DataSource;
import modelos.productos;
import org.postgresql.util.PSQLException;

/**
 *
 * @author Usuario
 */
@WebServlet(name = "SvProductos", urlPatterns = {"/gestionar/productos/*"})
public class SvProductos extends HttpServlet {
    
    DataSource dataSource;
    
    @Override
    public void init() throws ServletException {
        super.init();
        // Obtener el DataSource del ServletContext
        dataSource = (DataSource) getServletContext().getAttribute("dataSource");
    }

    private String getRes(String estado, String mensaje) {

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
            out.println("<title>Servlet SvProductos</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SvProductos at " + request.getContextPath() + "</h1>");
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
        request.getRequestDispatcher("vistas/productos.jsp").forward(request, response);
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

        String[] pathParts = pathInfo.split("/");

        String action = pathParts[1];

        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");

        StringBuffer jb = new StringBuffer();
        String line = null;
        BufferedReader reader = request.getReader();
        while ((line = reader.readLine()) != null) {
            jb.append(line);
        }

        JsonReader jsonReader = Json.createReader(new StringReader(jb.toString()));
        JsonObject obj;

        try(Connection connection = dataSource.getConnection()) {
            productos prod = new productos(connection);
            if (action != null && action.equals("add")) {
                obj = jsonReader.readObject();
                jsonReader.close();
                prod.setNombre(obj.getString("nombre"));
                prod.setDescripcion(obj.getString("descripcion"));
                prod.setPrecio(obj.getString("precio"));
                prod.setStock(obj.getString("stock"));
                prod.setImgPath(request.getSession().getServletContext().getRealPath("imgs/prod"));
                prod.guardar(obj.getJsonArray("imgs"));
                response.getWriter().write(getRes("success", "GUARDADO"));
            } else if (action != null && action.equals("edit")) {
                obj = jsonReader.readObject();
                jsonReader.close();
                prod.setNombre(obj.getString("nombre"));
                prod.setCodigo(obj.getString("codigo"));
                prod.setDescripcion(obj.getString("descripcion"));
                prod.setPrecio(obj.getString("precio"));
                prod.setStock(obj.getString("stock"));
                prod.setImgPath(request.getSession().getServletContext().getRealPath("imgs/prod"));
                prod.modificar(obj.getJsonArray("imgs"));
                response.getWriter().write(getRes("success", "MODIFICADO"));
            }
            else if (action != null && action.equals("del")) {
                obj = jsonReader.readObject();
                jsonReader.close();
                prod.setCodigo(obj.getString("codigo"));
                prod.setImgPath(request.getSession().getServletContext().getRealPath("imgs/prod"));
                prod.eliminar();
                response.getWriter().write(getRes("success", "ELIMINADO"));
            }
            else if (action != null && action.equals("list")) {
                request.setAttribute("res", prod.listar());
                request.getSession().getServletContext().getRequestDispatcher("/jsp/productos.jsp").forward(request, response);
            }

        } catch (PSQLException ex) {
            if (ex.getSQLState().equals("23505")) {
                response.getWriter().write(getRes("error", "LOS DATOS INGRESADOS YA EXISTEN."));
            }
            else{
            response.getWriter().write(getRes("error", ex.getMessage()));}
            ex.printStackTrace();

        } catch (Exception e) {
            response.getWriter().write(getRes("error", e.getMessage()));
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
