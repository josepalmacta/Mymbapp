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
import modelos.productos;
import modelos.ventas;
import org.postgresql.util.PSQLException;
import utilidades.Keyz;

/**
 *
 * @author Usuario
 */
@WebServlet(name = "PbCarrito", urlPatterns = {"/carrito/*"})
public class PbCarrito extends HttpServlet {

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
            out.println("<title>Servlet PbCarrito</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet PbCarrito at " + request.getContextPath() + "</h1>");
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

        try (Connection connection = dataSource.getConnection()) {

            ventas venta = new ventas(connection);

            String pathInfo = request.getPathInfo(); // /{value}/test
            if (pathInfo == null) {
                if (sesion.getAttribute("login") == null) {
                    response.sendRedirect("/login");
                    return;
                }
                venta.setPersona(sesion.getAttribute("idper").toString());
                getServletConfig().getServletContext().getRequestDispatcher("/vistas/public/carrito.jsp").forward(request, response);
                return;
            }
            String[] pathParts = pathInfo.split("/");

            String action = pathParts[1]; // test

            System.err.println(pathInfo);

            String value = pathParts[1];
            if (!value.equals("vistas")) {

                if (value.equals("list")) {
                    if (sesion.getAttribute("login") == null) {
                        response.sendRedirect("/login");
                        return;
                    }
                    venta.setPersona(sesion.getAttribute("idper").toString());
                    request.setAttribute("dets", venta.listarCarrito());
                    getServletConfig().getServletContext().getRequestDispatcher("/jsp/carrito.jsp").forward(request, response);
                    return;
                } else if (value.equals("cant")) {
                    Object perid = sesion.getAttribute("idper");
                    String cantidad = "0";
                    if (perid != null) {
                        venta.setPersona(perid.toString());
                        cantidad = venta.listarCantidad();
                    }
                    response.getWriter().write(cantidad);
                    return;
                } else if (value.equals("metodos")) {
                    request.setAttribute("dets", venta.listarMetodos());
                    getServletConfig().getServletContext().getRequestDispatcher("/jsp/metodos.jsp").forward(request, response);
                } else if (value.equals("retorno")) {
                    String type = request.getParameter("type");
                    String ventid = request.getParameter("doc_id");
                    if (type == null || ventid == null) {
                        System.err.println("URL invalida");
                        response.sendError(401);
                        return;
                    }
                    String url = "/usuario/compras/" + ventid;
                    response.sendRedirect(url);
                    return;
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
            throws ServletException, IOException, UnsupportedOperationException {

        response.setContentType("text/html;charset=UTF-8");

        HttpSession sesion = request.getSession();

        if (sesion.getAttribute("login") == null && request.getParameter("device") == null) {
            response.setStatus(403);
            return;
        }

        String pathInfo = request.getPathInfo(); // /{value}/test
        if (pathInfo == null) {
            response.setStatus(403);
            return;
        }
        String[] pathParts = pathInfo.split("/");

        String action = pathParts[1]; // test

        System.err.println(pathInfo);

        try (Connection connection = dataSource.getConnection()) {
            ventas venta = new ventas(connection);
            if (request.getParameter("device") != null) {
                Algorithm algorithm = Algorithm.RSA256(Keyz.loadPublicKey(), Keyz.loadPrivateKey());
                JWTVerifier verifier = JWT.require(algorithm)
                        .withIssuer("auth0")
                        .build();
                DecodedJWT decodedJWT = verifier.verify(request.getParameter("token"));
                venta.setPersona(decodedJWT.getClaim("uid").asString());
            } else {
                venta.setPersona(sesion.getAttribute("idper").toString());
            }
            String value = pathParts[1];
            if (!value.equals("vistas")) {

                if (value.equals("add")) {
                    venta.setProducto(request.getParameter("producto"));
                    venta.setCantidad(request.getParameter("cantidad"));
                    venta.setPrecio(request.getParameter("precio"));
                    venta.guardarDetalle();
                    response.getWriter().write(getRes(true, "success", "AGREGADO A SU CARRITO"));
                    return;
                } else if (value.equals("del")) {
                    venta.setProducto(request.getParameter("prod"));
                    venta.eliminarDeatlle();
                    response.getWriter().write(getRes(true, "success", "ELIMINADO"));
                    return;
                } else if (value.equals("cancel")) {
                    venta.setCodigo(request.getParameter("codigo"));
                    venta.cancelarCompra();
                    response.getWriter().write(getRes(true, "success", "COMPRA CANCELADA"));
                    return;
                } else if (value.equals("finalizar")) {
                    venta.setCodigo(request.getParameter("codigo"));
                    venta.setRazon(request.getParameter("nombre"));
                    venta.setRuc(request.getParameter("ruc"));
                    venta.setTelefono(request.getParameter("telefono"));
                    venta.setEmail(request.getParameter("email"));
                    venta.setDireccion(request.getParameter("direccion"));
                    venta.setLat(request.getParameter("lat"));
                    venta.setLng(request.getParameter("lng"));
                    venta.confirmarCompra();
                    response.getWriter().write(getRes(true, "success", "COMPRA CONFIRMADA"));
                    return;
                } else if (value.equals("pagar")) {
                    venta.setMetodo(request.getParameter("codigo"));
                    venta.setRazon(request.getParameter("nombre"));
                    venta.setRuc(request.getParameter("ruc"));
                    venta.setTelefono(request.getParameter("telefono"));
                    venta.setEmail(request.getParameter("email"));
                    venta.setDireccion(request.getParameter("direccion"));
                    venta.setLat(request.getParameter("lat"));
                    venta.setLng(request.getParameter("lng"));
                    String pago = venta.pagarVenta();
                    if (pago.equals("error")) {
                        response.getWriter().write(getRes(false, "error", "HUBO UN ERROR"));
                        return;
                    }
                    response.getWriter().write(getRes(true, "success", pago));
                    return;
                }
                else if (value.equals("cant")) {
                    String cantidad = "0";
                    cantidad = venta.listarCantidad();
                    response.getWriter().write(cantidad);
                    return;
                }
                else if (value.equals("list")) {
                    response.getWriter().write(venta.listarCarrito().toString());
                    return;
                }

            }
        } catch (UnsupportedOperationException unex) {
            response.getWriter().write(getRes(true, "error", "ESTE PRODUCTO YA ESTA EN SU CARRITO"));
            return;
        } catch (Exception ex) {
            ex.printStackTrace();
            System.err.println(ex.getMessage() + "aaa");
            response.getWriter().write(ex.getMessage());
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
