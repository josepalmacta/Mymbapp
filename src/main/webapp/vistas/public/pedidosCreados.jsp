<%-- 
    Document   : pedidosCreados
    Created on : 3 sept 2024, 13:35:29
    Author     : Usuario
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="jakarta.json.JsonValue"%>
<%@page import="jakarta.json.Json"%>
<%@page import="jakarta.json.JsonArray"%>
<%@page import="jakarta.json.JsonArrayBuilder"%>
<%@page import="jakarta.json.JsonObject"%>

<% String titulo = "Mis Compras"; %>
<%@include file="header.jsp" %>

<div class="osahan-page-body vh-100 my-auto p-3">

    <div class="d-block mb-4">
        <span class="fw-bold text-black text-uppercase">Mis Compras</span>
        <div class="border-top w-100 mt-3"></div>
    </div>
    <%
                    
        JsonArray arr = (JsonArray)request.getAttribute("dets");
        String primari = "primary";
        for (int i = 0; i < arr.size(); i++) {
           JsonObject obj = arr.getJsonObject(i);
           String estado = obj.getString("estado");
           String ventd = "/usuario/compras/" + obj.getString("ventid");
           if(estado.equals("FINALIZADO")){primari="secondary"; estado="PENDIENTE";}else if(estado.equals("ENTREGADO")){primari="success";}else{primari="warning";}
    %>

    <a href="<% out.print(ventd); %>"
       class="text-decoration-none text-black input-group justify-content-sm-start bg-white rounded-3 py-3 d-flex px-4 align-items-center shadow-sm">
        <span class="mdi mdi-google text-primary fs-2"></span>
        <div>
            <h5 class="ms-4 fw-bold m-0 h6">Pedido #<% out.print(obj.getString("ventid")); %></h5>
            <p class="ms-4 mb-1 lh-base text-muted">Fecha: <% out.print(obj.getString("fecha")); %></p>
        </div>
        <div class="fw-semibold text-<% out.print(primari); %> text-decoration-none ms-auto"><% out.print(estado); %></div>
    </a>        

    <% } %>

</div>

<%@include file="footer.jsp" %>
