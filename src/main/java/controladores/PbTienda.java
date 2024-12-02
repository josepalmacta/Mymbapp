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
import modelos.productos;
import org.postgresql.util.PSQLException;

/**
 *
 * @author Usuario
 */
@WebServlet(name = "PbTienda", urlPatterns = {"/tienda/*"})
public class PbTienda extends HttpServlet {
    
    DataSource dataSource;
    
    @Override
    public void init() throws ServletException {
        super.init();
        // Obtener el DataSource del ServletContext
        dataSource = (DataSource) getServletContext().getAttribute("dataSource");
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

   private void mostrarProducto(String value, String pathInfo, HttpServletRequest request, HttpServletResponse response, Connection connection) throws Exception {
        productos prod = new productos(connection);
        prod.setCodigo(value);
        System.err.println(pathInfo);
        JsonObject obj = prod.listarID();
        if (!obj.getBoolean("hay")) {
            response.setStatus(404);
            return;
        }
        request.setAttribute("dets", obj);
        getServletConfig().getServletContext().getRequestDispatcher("/vistas/public/producto.jsp").forward(request, response);
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
            out.println("<title>Servlet PbTienda</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet PbTienda at " + request.getContextPath() + "</h1>");
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

        response.setContentType("text/html;charset=UTF-8");

        HttpSession sesion = request.getSession();

        String pathInfo = request.getPathInfo(); // /{value}/test
        if (pathInfo == null) {
            getServletConfig().getServletContext().getRequestDispatcher("/vistas/public/productos.jsp").forward(request, response);
            return;
        }
        String[] pathParts = pathInfo.split("/");

        String action = pathParts[1]; // test

        System.err.println(pathInfo);

        try(Connection connection = dataSource.getConnection()) {
            String value = pathParts[1];
            if (!value.equals("vistas")) {

                if (value.equals("add")) {
                    if (sesion.getAttribute("login") == null) {
                        response.sendRedirect("/login");
                        return;
                    }
                    getServletConfig().getServletContext().getRequestDispatcher("/vistas/public/postEncontrados.jsp").forward(request, response);
                    return;
                } else if (esNum(value)) {
                    mostrarProducto(value, pathInfo, request, response,connection);
                }

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
        processRequest(request, response);
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
