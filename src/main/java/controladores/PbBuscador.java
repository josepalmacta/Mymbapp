/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controladores;

import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.JWTVerificationException;
import com.auth0.jwt.interfaces.DecodedJWT;
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
@WebServlet(name = "PbBuscador", urlPatterns = {"/api/buscar/*"})
public class PbBuscador extends HttpServlet {

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
            out.println("<title>Servlet PbBuscador</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet PbBuscador at " + request.getContextPath() + "</h1>");
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

        try (Connection connection = dataSource.getConnection()) {
            response.setContentType("text/html;charset=UTF-8");

            String pathInfo = request.getPathInfo(); // /{value}/test
            if (pathInfo == null) {
                response.setStatus(404);
                return;
            }
            
            String perid = "";

            if (request.getParameter("token") != null) {
                DecodedJWT decodedJWT;
                try {
                    Algorithm algorithm = Algorithm.RSA256(Keyz.loadPublicKey(), Keyz.loadPrivateKey());
                    JWTVerifier verifier = JWT.require(algorithm)
                            // specify any specific claim validations
                            .withIssuer("auth0")
                            // reusable verifier instance
                            .build();

                    decodedJWT = verifier.verify(request.getParameter("token"));
                    
                    perid = decodedJWT.getClaim("uid").asString();

                } catch (JWTVerificationException exception) {
                    response.setStatus(403);
                    return;
                }
            }

            String[] pathParts = pathInfo.split("/");

            String action = pathParts[1];

            String pagina;
            String depar;
            String ciud;
            String barri;
            String espec;
            String raza;

            switch (action) {
                case "departamentos":
                    departamentos dep = new departamentos(connection);
                    response.getWriter().write(dep.listar().toString());
                    break;
                case "ciudades":
                    ciudades ciu = new ciudades(connection);
                    String departamento = request.getParameter("departamento");
                    ciu.setDepartamento(departamento);
                    response.getWriter().write(ciu.listarDep().toString());
                    break;
                case "barrios":
                    barrios barr = new barrios(connection);
                    String ciudad = request.getParameter("ciudad");
                    barr.setCiudad(ciudad);
                    response.getWriter().write(barr.listarCiu().toString());
                    break;
                case "especies":
                    especies esp = new especies(connection);
                    response.getWriter().write(esp.listar().toString());
                    break;
                case "razas":
                    razas raz = new razas(connection);
                    String especie = request.getParameter("especie");
                    raz.setEspecie(especie);
                    response.getWriter().write(raz.listarDep().toString());
                    break;
                case "clientes":
                    personas cli = new personas(connection);
                    response.getWriter().write(cli.listar().toString());
                    break;
                case "productos":
                    productos prods = new productos(connection);
                    response.getWriter().write(prods.listar().toString());
                    break;
                case "perdidos":
                    postPerdidos post = new postPerdidos(connection);
                    pagina = request.getParameter("pagina");
                    depar = request.getParameter("departamento");
                    ciud = request.getParameter("ciudad");
                    barri = request.getParameter("barrio");
                    espec = request.getParameter("especie");
                    raza = request.getParameter("raza");
                    post.setPagina(pagina);
                    post.setDepartamento(depar);
                    post.setCiudad(ciud);
                    post.setBarrio(barri);
                    post.setEspecie(espec);
                    post.setRaza(raza);
                    request.setAttribute("dets", post.listarBusqueda());
                    getServletConfig().getServletContext().getRequestDispatcher("/jsp/busquedaPerdidos.jsp").forward(request, response);
                    break;
                case "mperdidos":
                    postPerdidos mpost = new postPerdidos(connection);
                    response.getWriter().write(mpost.listarHome().toString());
                    break;
                case "mencontrados":
                    postEncontrados mepost = new postEncontrados(connection);
                    response.getWriter().write(mepost.listarHome().toString());
                    break;
                case "madopciones":
                    postAdopcion mapost = new postAdopcion(connection);
                    response.getWriter().write(mapost.listarHome().toString());
                    break;
                case "mpostperdido":
                    postPerdidos ppost = new postPerdidos(connection);
                    pagina = request.getParameter("post");
                    ppost.setId(pagina);
                    response.getWriter().write(ppost.listarID().toString());
                    break;
                case "lpostsperdidos":
                    postPerdidos lpostp = new postPerdidos(connection);
                    pagina = request.getParameter("pagina");
                    depar = request.getParameter("departamento");
                    ciud = request.getParameter("ciudad");
                    barri = request.getParameter("barrio");
                    espec = request.getParameter("especie");
                    raza = request.getParameter("raza");
                    lpostp.setPagina(pagina);
                    lpostp.setDepartamento(depar);
                    lpostp.setCiudad(ciud);
                    lpostp.setBarrio(barri);
                    lpostp.setEspecie(espec);
                    lpostp.setRaza(raza);
                    lpostp.setId(pagina);
                    response.getWriter().write(lpostp.listarBusqueda().toString());
                    break;
                case "lpostsencontrados":
                    postEncontrados lposte = new postEncontrados(connection);
                    pagina = request.getParameter("pagina");
                    depar = request.getParameter("departamento");
                    ciud = request.getParameter("ciudad");
                    barri = request.getParameter("barrio");
                    espec = request.getParameter("especie");
                    raza = request.getParameter("raza");
                    lposte.setPagina(pagina);
                    lposte.setDepartamento(depar);
                    lposte.setCiudad(ciud);
                    lposte.setBarrio(barri);
                    lposte.setEspecie(espec);
                    lposte.setRaza(raza);
                    lposte.setId(pagina);
                    response.getWriter().write(lposte.listarBusqueda().toString());
                    break;
                case "lpostsadopcion":
                    postAdopcion lposta = new postAdopcion(connection);
                    pagina = request.getParameter("pagina");
                    depar = request.getParameter("departamento");
                    ciud = request.getParameter("ciudad");
                    barri = request.getParameter("barrio");
                    espec = request.getParameter("especie");
                    raza = request.getParameter("raza");
                    lposta.setPagina(pagina);
                    lposta.setDepartamento(depar);
                    lposta.setCiudad(ciud);
                    lposta.setBarrio(barri);
                    lposta.setEspecie(espec);
                    lposta.setRaza(raza);
                    lposta.setId(pagina);
                    response.getWriter().write(lposta.listarBusqueda().toString());
                    break;
                case "mpostencontrado":
                    postEncontrados epost = new postEncontrados(connection);
                    pagina = request.getParameter("post");
                    epost.setId(pagina);
                    response.getWriter().write(epost.listarID().toString());
                    break;
                case "mpostadopcion":
                    postAdopcion apost = new postAdopcion(connection);
                    pagina = request.getParameter("post");
                    apost.setId(pagina);
                    response.getWriter().write(apost.listarID().toString());
                    break;
                case "mapa":
                    postPerdidos busc = new postPerdidos(connection);
                    ciud = request.getParameter("ciudad");
                    busc.setCiudad(ciud.toUpperCase());
                    response.getWriter().write(busc.listarMapa().toString());
                    break;
                case "encontrados":
                    postEncontrados encon = new postEncontrados(connection);
                    pagina = request.getParameter("pagina");
                    depar = request.getParameter("departamento");
                    ciud = request.getParameter("ciudad");
                    barri = request.getParameter("barrio");
                    espec = request.getParameter("especie");
                    raza = request.getParameter("raza");
                    encon.setPagina(pagina);
                    encon.setDepartamento(depar);
                    encon.setCiudad(ciud);
                    encon.setBarrio(barri);
                    encon.setEspecie(espec);
                    encon.setRaza(raza);
                    request.setAttribute("dets", encon.listarBusqueda());
                    getServletConfig().getServletContext().getRequestDispatcher("/jsp/busquedaEncontrados.jsp").forward(request, response);
                    break;
                case "adopcion":
                    postAdopcion ado = new postAdopcion(connection);
                    pagina = request.getParameter("pagina");
                    depar = request.getParameter("departamento");
                    ciud = request.getParameter("ciudad");
                    barri = request.getParameter("barrio");
                    espec = request.getParameter("especie");
                    raza = request.getParameter("raza");
                    ado.setPagina(pagina);
                    ado.setDepartamento(depar);
                    ado.setCiudad(ciud);
                    ado.setBarrio(barri);
                    ado.setEspecie(espec);
                    ado.setRaza(raza);
                    request.setAttribute("dets", ado.listarBusqueda());
                    getServletConfig().getServletContext().getRequestDispatcher("/jsp/busquedaAdopcion.jsp").forward(request, response);
                    break;
                case "tienda":
                    productos ltienda = new productos(connection);
                    pagina = request.getParameter("pagina");
                    ltienda.setPagina(pagina);
                    response.getWriter().write(ltienda.listarHome().toString());
                    break;
                case "producto":
                    productos mprod = new productos(connection);
                    pagina = request.getParameter("producto");
                    mprod.setCodigo(pagina);
                    response.getWriter().write(mprod.listarID().toString());
                    break;
                case "misposts":
                    postPerdidos misposts = new postPerdidos(connection);
                    misposts.setPersona(perid);
                    response.getWriter().write(misposts.listarUsuario().toString());
                    break;
                case "miscompras":
                    ventas ven = new ventas(connection);
                    ven.setPersona(perid);   
                    System.err.println(perid);
                    response.getWriter().write(ven.listarUsuario().toString());
                    break;
                case "compra":
                    ventas com = new ventas(connection);
                    com.setPersona(perid);   
                    com.setProducto(request.getParameter("cid"));
                    response.getWriter().write(com.listarCompra().toString());
                    break;
                default:
                    response.setStatus(404);
                    break;
            }
        } catch (Exception ex) {
            Logger.getLogger(PbBuscador.class.getName()).log(Level.SEVERE, null, ex);
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
