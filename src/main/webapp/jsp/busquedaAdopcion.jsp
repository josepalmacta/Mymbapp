<%-- 
    Document   : busquedaAdopcion
    Created on : 27 jul 2024, 16:11:56
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
        <% if(obj.getString("estado").equals("ADOPTADO")){ %>
        <div class="badge bg-success">ADOPTADO</div>
        <% } %>
        <img src="/imgs/posts/a/<% out.print(obj.getString("img")); %>" class="hover-img position-relative">
        <div class="card-body p-2">
            <div class="my-2 gap-2">
                <p class="d-flex align-items-center gap-1 my-2 text-secondary"><i class="fa-solid fa-paw text-primary fs-6"></i> <% out.print(obj.getString("especie")); %></p>
                <p class="d-flex align-items-center gap-1 my-2 text-secondary"><i class="fa-solid fa-venus-mars text-primary fs-6"></i> <% out.print(obj.getString("genero")); %></p>
            </div>
        </div>
        <a class="stretched-link" href="/adopcion/post/<% out.print(obj.getString("postid")); %>"></a>
    </div>
</div>


<% } %>

