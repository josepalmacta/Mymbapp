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
import jakarta.json.JsonReader;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.xml.bind.DatatypeConverter;
import java.io.BufferedReader;
import java.io.StringReader;
import java.security.MessageDigest;
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
import modelos.razas;
import modelos.ventas;
import org.postgresql.util.PSQLException;

/**
 *
 * @author Usuario
 */
@WebServlet(name = "AdamsPayEndPoint", urlPatterns = {"/endpoint/adamspay/webhook"})
public class AdamsPayEndPoint extends HttpServlet {
    
    
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
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet PagoparEndPoint</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet PagoparEndPoint at " + request.getContextPath() + "</h1>");
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
        response.setStatus(403);
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

        response.setContentType("application/json; charset=utf-8");
        

        String hash = request.getHeader("x-adams-notify-hash");

        if (hash == null) {
            System.err.println("No hash header");
            return;
        }
        
        StringBuffer jb = new StringBuffer();
        String line = null;

        BufferedReader reader = request.getReader();
        while ((line = reader.readLine()) != null) {
            jb.append(line);
        }

        String content = jb.toString();

        String myHash = md5Token("adams" + content + "fbc5569660c7b1e55b69d1dfe07af25a");

        if (!hash.equals(myHash)) {
            System.err.println("Hash no coincide");
            return;
        }

        

        JsonReader jsonReader = Json.createReader(new StringReader(content));
        JsonObject obj = jsonReader.readObject();
        jsonReader.close();

        System.err.println("---------------------------------------------------");
        System.err.println(obj.toString());
        System.err.println("---------------------------------------------------");

        if (!obj.containsKey("notify")) {
            System.err.println("Formato invalido");
            return;
        }

        if (!obj.getJsonObject("notify").containsKey("type")) {
            System.err.println("Formato invalido 2");
            return;
        }

        if (obj.getJsonObject("notify").getString("type").equals("debtStatus")) {
            try (Connection connection = dataSource.getConnection()) {
                ventas venta = new ventas(connection);
                String codigo = obj.getJsonObject("debt").getString("docId");
                venta.setCodigo(codigo);
                if(obj.getJsonObject("debt").getJsonObject("payStatus").getString("status").equals("paid")){
                    venta.actualizarEstado("FINALIZADO");
                }
                else if(obj.getJsonObject("debt").getJsonObject("objStatus").getString("status").equals("canceled")){
                    venta.actualizarEstado("CANCELADO");
                }
                else if(obj.getJsonObject("debt").getJsonObject("objStatus").getString("status").equals("canceled")){
                    venta.actualizarEstado("CANCELADO");
                }
                else if(obj.getJsonObject("debt").getJsonObject("objStatus").getString("status").equals("expired")){
                    venta.actualizarEstado("EXPIRADO");
                }
                
                
            } catch (Exception ex) {
                ex.printStackTrace();
                System.err.println(ex.getMessage() + "bbb");
                response.getWriter().write(ex.getMessage());
            }
        }

        response.setStatus(200);

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

    public String md5Token(String input) {
        String md5 = "";
        try {
            MessageDigest msdDigest = MessageDigest.getInstance("MD5");
            msdDigest.update(input.getBytes("UTF-8"));
            md5 = DatatypeConverter.printHexBinary(msdDigest.digest());
        } catch (Exception e) {
            Logger.getLogger(ventas.class.getName()).log(Level.SEVERE, null, e);
        }
        return md5.toLowerCase();
    }

}
