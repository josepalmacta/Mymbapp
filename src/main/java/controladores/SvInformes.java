/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controladores;

import jakarta.jms.Session;
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
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.sql.DataSource;
import modelos.barrios;
import modelos.ciudades;
import modelos.departamentos;
import modelos.especies;
import modelos.personas;
import modelos.postAdopcion;
import modelos.postEncontrados;
import modelos.postPerdidos;
import modelos.productos;
import modelos.razas;
import modelos.ventas;
import org.postgresql.util.PSQLException;
import utilidades.Keyz;

/**
 *
 * @author Usuario
 */
@WebServlet(name = "SvInformes", urlPatterns = {"/informe/*"})
public class SvInformes extends HttpServlet {

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
            out.println("<title>Servlet SvInformes</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SvInformes at " + request.getContextPath() + "</h1>");
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
            response.setStatus(404);
            return;
        }

        String[] pathParts = pathInfo.split("/");

        String action = pathParts[1];

        switch (action) {
            case "ventas":
                getServletConfig().getServletContext().getRequestDispatcher("/vistas/informesVentas.jsp").forward(request, response);
                break;
            case "perdidos":
                getServletConfig().getServletContext().getRequestDispatcher("/vistas/informesPerdidos.jsp").forward(request, response);
                break;
            case "encontrados":
                getServletConfig().getServletContext().getRequestDispatcher("/vistas/informesEncontrados.jsp").forward(request, response);
                break;
            case "adopcion":
                getServletConfig().getServletContext().getRequestDispatcher("/vistas/informesAdopcion.jsp").forward(request, response);
                break;
            default:
                response.setStatus(404);
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
