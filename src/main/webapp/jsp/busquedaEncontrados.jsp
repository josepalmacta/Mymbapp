<%-- 
    Document   : busquedaEncontrados
    Created on : 24 jul 2024, 17:57:44
    Author     : Usuario
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="jakarta.json.JsonValue"%>
<%@page import="jakarta.json.Json"%>
<%@page import="jakarta.json.JsonArray"%>
<%@page import="jakarta.json.JsonArrayBuilder"%>
<%@page import="jakarta.json.JsonObject"%>
<%
                    
        
         JsonArray arr = (JsonArray)request.getAttribute("dets");
         
         for (int i = 0; i < arr.size(); i++) {
            JsonObject obj = arr.getJsonObject(i);
%>




<div class="col lostlist">
    <div class="card border-0 rounded-3 shadow overflow-hidden">
        <div class="card-header text-body-secondary">
            <i class="fa-regular fa-calendar-days me-1"></i> <% if(obj.getString("fecha").equals("0")){out.print("Hoy");}else if(obj.getString("fecha").equals("1")){out.print("Ayer");}else{out.print("Hace " + obj.getString("fecha") + " dias");} %>
        </div>
        <% if(obj.getString("estado").equals("LOCALIZADO")){ %>
        <div class="badge badgeenc bg-success">LOCALIZADO</div>
        <% } %>
        <img src="/imgs/posts/e/<% out.print(obj.getString("img")); %>" class="hover-img position-relative">
        <div class="card-body p-2">
            <div class="my-2 gap-2">
                <p class="d-flex align-items-center gap-1 my-2 text-secondary"><i class="fa-solid fa-location-dot text-primary fs-6"></i><strong> <% out.print(obj.getString("lugar")); %></strong></p>
            </div>
        </div>
        <a class="stretched-link" href="/encontrados/post/<% out.print(obj.getString("postid")); %>"></a>
    </div>
</div>


<% } %>
