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
import modelos.postPerdidos;
import modelos.ventas;
import org.postgresql.util.PSQLException;

/**
 *
 * @author Usuario
 */
@WebServlet(name = "SvVentas", urlPatterns = {"/gestionar/ventas"})
public class SvVentas extends HttpServlet {
    
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
            out.println("<title>Servlet SvVentas</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SvVentas at " + request.getContextPath() + "</h1>");
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
            ventas ven = new ventas(connection);
            if (opt != null && opt.equals("add")) {
                /*String nombre = request.getParameter("nombre");
                String code = request.getParameter("code");
                dep.setNombre(nombre);
                dep.setCodigo(code);
                dep.guardar();
                response.getWriter().write(getRes("success", "GUARDADO"));*/

            } else if (opt != null && opt.equals("edit")) {
                /*String nombre = request.getParameter("nombre");
                String code = request.getParameter("code");
                String id = request.getParameter("codigo");
                dep.setId(id);
                dep.setNombre(nombre);
                dep.setCodigo(code);
                dep.modificar();
                response.getWriter().write(getRes("success", "MODIFICADO"));*/
            }
            else if (opt != null && opt.equals("finalizado")) {
                request.setAttribute("dets", ven.listar(opt.toUpperCase()));
                request.getRequestDispatcher("/jsp/v_finalizado.jsp").forward(request, response);

            }
            else if (opt != null && opt.equals("enviado")) {
                request.setAttribute("dets", ven.listar(opt.toUpperCase()));
                request.getRequestDispatcher("/jsp/v_enviado.jsp").forward(request, response);

            }
            else if (opt != null && opt.equals("entregado")) {
                request.setAttribute("dets", ven.listar(opt.toUpperCase()));
                request.getRequestDispatcher("/jsp/v_entregado.jsp").forward(request, response);

            }
            else if (opt != null && opt.equals("enviar")) {
                ven.setCodigo(request.getParameter("codigo"));
                ven.actualizarEstado("ENVIADO");
                response.getWriter().write(getRes("success", "Actualizado a Enviado"));
            }
            else if (opt != null && opt.equals("entregar")) {
                ven.setCodigo(request.getParameter("codigo"));
                ven.actualizarEstado("ENTREGADO");
                response.getWriter().write(getRes("success", "Actualizado a Entregado"));
            }
            else if (opt != null && opt.equals("anular")) {
                ven.setCodigo(request.getParameter("codigo"));
                ven.actualizarEstado("ANULADO");
                response.getWriter().write(getRes("success", "Pedido Anulado"));
            }
            else if (opt != null && opt.equals("venta")) {
                System.err.println("aaaaaaaaaaaaaaaaa");
                ven.setCodigo(request.getParameter("codigo"));
                request.setAttribute("dets", ven.listarID());
                request.getRequestDispatcher("/jsp/venta.jsp").forward(request, response);

            }
        } catch (PSQLException ex) {
            if (ex.getSQLState().equals("23505")) {
                response.getWriter().write(getRes("error", "LOS DATOS INGRESADOS YA EXISTEN."));
            }
            else{
                response.getWriter().write(getRes("error", ex.getMessage()));
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
