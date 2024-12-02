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
import modelos.personas;
import modelos.postPerdidos;
import org.postgresql.util.PSQLException;

/**
 *
 * @author Usuario
 */
@WebServlet(name = "PbLogin", urlPatterns = {"/login/*"})
public class PbLogin extends HttpServlet {
    
    
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
        getServletConfig().getServletContext().getRequestDispatcher("/vistas/public/login.jsp").forward(request, response);
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
            getServletConfig().getServletContext().getRequestDispatcher("/vistas/public/login.jsp").forward(request, response);
            return;
        }
        String[] pathParts = pathInfo.split("/");

        String action = pathParts[1];

        if (action.equals("recuperacion")) {
            String confcode = request.getParameter("codigo");
            if (confcode != null) {
                try (Connection connection = dataSource.getConnection()) {
                    personas per = new personas(connection);
                    per.setNClave(confcode);
                    String stats = "errorcodx";
                    String codx = "";
                    if (per.verificarCodigo()) {
                        stats = "codxok";
                        codx = confcode;
                    }
                    request.setAttribute("rcode", codx);
                    request.setAttribute("tipo", stats);
                    getServletConfig().getServletContext().getRequestDispatcher("/vistas/public/recupassw.jsp").forward(request, response);
                    return;

                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            request.setAttribute("tipo", "emailform");
            getServletConfig().getServletContext().getRequestDispatcher("/vistas/public/recupassw.jsp").forward(request, response);
            return;
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
            String[] pathParts = pathInfo.split("/");
            String action = pathParts[1];
            if (action.equals("reset")) {
                String clave = request.getParameter("clave");
                String rcode = request.getParameter("codigo");
                per.setClave(clave);
                per.setNClave(rcode);
                if (per.verificarCodigoReg()) {
                    response.getWriter().write(getRes(true, "success", "Contraseña cambiada"));
                    return;
                }
                response.getWriter().write(getRes(false, "error", "El codigo no es valido."));
                return;
            }
            if (action.equals("recuperacion")) {
                String email = request.getParameter("email");
                per.setEmail(email);
                if (per.verificarEmail()) {
                    response.getWriter().write(getRes(true, "success", "Enlace de reestablecimiento enviado."));
                    return;
                }
                response.getWriter().write(getRes(false, "error", "El email no pertenece a ninguna cuenta"));
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
