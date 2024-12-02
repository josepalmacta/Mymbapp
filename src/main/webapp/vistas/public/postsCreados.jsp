<%-- 
    Document   : postsCreados
    Created on : 21 jul 2024, 10:29:55
    Author     : Usuario
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="jakarta.json.JsonValue"%>
<%@page import="jakarta.json.Json"%>
<%@page import="jakarta.json.JsonArray"%>
<%@page import="jakarta.json.JsonArrayBuilder"%>
<%@page import="jakarta.json.JsonObject"%>


<% String titulo = "Mis Publicaciones"; %>
<%@include file="header.jsp" %>

<div class="osahan-page-body vh-100 my-auto p-3">

    <div class="d-block mb-4">
        <span class="fw-bold text-black text-uppercase">Publicaciones creadas</span>
        <div class="border-top w-100 mt-3"></div>
    </div>
    <%
                    
        
        JsonArray arr = (JsonArray)request.getAttribute("dets");
        for (int i = 0; i < arr.size(); i++) {
           JsonObject obj = arr.getJsonObject(i);
           String url_ = "/" + obj.getString("tipo") + "/post/" + obj.getString("postid");
           String urle_ = "/" + obj.getString("tipo") + "/post/" + obj.getString("postid") + "/edit";
           String urlc_ = "/" + obj.getString("tipo") + "/post/" + obj.getString("postid") + "/cartel";
           String disab = "";
           String disb = "";
           String primari = "primary";
           if(!obj.getString("sis_estado").equals("APROBADO")){primari="secondary";url_ = "#"; disab="d-none"; urle_="#";}
    %>
    <div class="d-flex pb-4 text-black text-decoration-none">
        <div>
            <div
                class="border border-secondary-50 rounded-circle d-flex align-items-center justify-content-center w-round">
                <span class="material-symbols-outlined fs-1 text-black">lock</span>
            </div>
        </div>
        <div class="ms-3">
            <div class="d-flex gap-2 mb-1">
                <h6 class="mb-0 fw-bold text-black"><% out.print(obj.getString("nombres")); %></h6>
            </div>
            <p class="mb-1 lh-base text-muted">Fecha: <% out.print(obj.getString("fecha")); %></p>
            <div class="text-decoration-none text-secondary small"><span class="badge text-bg-<% out.print(primari); %>"><% out.print(obj.getString("sis_estado")); %></span></div>
        </div>
        <div class="ms-auto">
            <div class="dropdown <% out.print(disab); %>">
                <button class="btn btn-primary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                <i class="fa-solid fa-gear"></i>
                </button>
                <ul class="dropdown-menu">
                    <li><a class="dropdown-item" href="<% out.print(url_); %>"><i class="fa-solid fa-eye"></i> Ver Publicacion</a></li>
                    <li class="<% if(obj.getString("estado").equals("LOCALIZADO") || obj.getString("estado").equals("ADOPTADO")){ out.print("d-none"); urle_="#"; }%>"><a class="dropdown-item" href="<% out.print(urle_); %>"><i class="fa-solid fa-pen-to-square"></i> Editar Publicacion</a></li>
                    <% if(obj.getString("tipo").equals("perdidos")){ %><li><a class="dropdown-item" target="_blank" href="<% out.print(urlc_); %>"><i class="fa-solid fa-print"></i> Imprimir Cartel</a></li><% } %>
                </ul>
            </div>
        </div>
    </div>
    <% } %>
</div>

<%@include file="footer.jsp" %>