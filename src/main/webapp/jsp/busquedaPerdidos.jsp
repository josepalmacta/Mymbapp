<%-- 
    Document   : busquedaPerdidos
    Created on : 17 jul 2024, 17:31:58
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
        <% if(!obj.getString("recompensa").equals("0") && !obj.getString("estado").equals("LOCALIZADO")){ %>
        <div class="badge">RECOMPENSA</div>
        <% } %>
        <% if(obj.getString("estado").equals("LOCALIZADO")){ %>
        <div class="badge bg-success">LOCALIZADO</div>
        <% } %>
        <img src="/imgs/posts/p/<% out.print(obj.getString("img")); %>" class="hover-img card-img-top position-relative">
        <div class="card-body p-2">
            <h5 class="card-title mb-1 fw-bold h6"><% out.print(obj.getString("nombres")); %></h5>
            <div class="my-2 gap-2">
                <p class="d-flex align-items-center gap-1 my-2 text-secondary"><span
                        class="mdi mdi-paw text-primary fs-6"></span> <% out.print(obj.getString("especie")); %></p>

                <div class="d-flex">
                    <div class="mt-2 me-1">
                        <i class="fa-solid fa-location-dot text-primary fs-6"></i>
                    </div>
                    <div class="lugard">                                    
                        <p class="d-flex align-items-center gap-1 my-2 text-secondary"><% out.print(obj.getString("lugar")); %></p>
                    </div>
                </div>
            </div>
        </div>
        <a class="stretched-link" href="/perdidos/post/<% out.print(obj.getString("postid")); %>"></a>
    </div>
</div>


<% } %>
