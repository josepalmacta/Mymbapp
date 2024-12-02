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
import java.util.logging.Level;
import java.util.logging.Logger;
import modelos.postPerdidos;
import org.postgresql.util.PSQLException;

/**
 *
 * @author Usuario
 */
@WebServlet(name = "Svdashboard", urlPatterns = {"/dashboard/*"})
public class Svdashboard extends HttpServlet {

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

        String pathInfo = request.getPathInfo(); // /{value}/test
        if (pathInfo == null) {
            getServletConfig().getServletContext().getRequestDispatcher("/vistas/login.jsp").forward(request, response);
            return;
        }

        String[] pathParts = pathInfo.split("/");

        String action = pathParts[1];

        boolean adm = true;

        HttpSession sesion = request.getSession();
        if (sesion.getAttribute("rol") == null) {
            response.sendRedirect("/dashboard");
            return;
        }
        if (!sesion.getAttribute("rol").equals("ADMINISTRADOR")) {
            adm = false;
        }

        switch (action) {
            case "inicio":
                getServletConfig().getServletContext().getRequestDispatcher("/vistas/dashboard.jsp").forward(request, response);
                break;
            case "departamentos":
                if (!adm) {
                    response.sendRedirect("/dashboard/inicio");
                    return;
                }
                getServletConfig().getServletContext().getRequestDispatcher("/vistas/departamentos.jsp").forward(request, response);
                break;
            case "ciudades":
                if (!adm) {
                    response.sendRedirect("/dashboard/inicio");
                    return;
                }
                getServletConfig().getServletContext().getRequestDispatcher("/vistas/ciudades.jsp").forward(request, response);
                break;
            case "barrios":
                if (!adm) {
                    response.sendRedirect("/dashboard/inicio");
                    return;
                }
                getServletConfig().getServletContext().getRequestDispatcher("/vistas/barrios.jsp").forward(request, response);
                break;
            case "especies":
                if (!adm) {
                    response.sendRedirect("/dashboard/inicio");
                    return;
                }
                getServletConfig().getServletContext().getRequestDispatcher("/vistas/especies.jsp").forward(request, response);
                break;
            case "razas":
                if (!adm) {
                    response.sendRedirect("/dashboard/inicio");
                    return;
                }
                getServletConfig().getServletContext().getRequestDispatcher("/vistas/razas.jsp").forward(request, response);
                break;
            case "usuarios":
                if (!adm) {
                    response.sendRedirect("/dashboard/inicio");
                    return;
                }
                getServletConfig().getServletContext().getRequestDispatcher("/vistas/usuarios.jsp").forward(request, response);
                break;
            case "perdidos":
                getServletConfig().getServletContext().getRequestDispatcher("/vistas/perdidos.jsp").forward(request, response);
                break;

            case "encontrados":
                getServletConfig().getServletContext().getRequestDispatcher("/vistas/encontrados.jsp").forward(request, response);
                break;
            case "adopcion":
                getServletConfig().getServletContext().getRequestDispatcher("/vistas/adopcion.jsp").forward(request, response);
                break;
            case "productos":
                if (!adm) {
                    response.sendRedirect("/dashboard/inicio");
                    return;
                }
                getServletConfig().getServletContext().getRequestDispatcher("/vistas/productos.jsp").forward(request, response);
                break;
            case "ventas":
                if (!adm) {
                    response.sendRedirect("/dashboard/inicio");
                    return;
                }
                getServletConfig().getServletContext().getRequestDispatcher("/vistas/ventas.jsp").forward(request, response);
                break;
            case "informes":
                if (!adm) {
                    response.sendRedirect("/dashboard/inicio");
                    return;
                }
                switch (pathParts[2]) {
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
                        getServletConfig().getServletContext().getRequestDispatcher("/vistas/informesAdopciones.jsp").forward(request, response);
                        break;
                    default:
                        response.setStatus(404);
                        break;
                }
                break;
            default:
                response.setStatus(404);
                break;
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
