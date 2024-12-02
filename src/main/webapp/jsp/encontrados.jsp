<%-- 
    Document   : encontrados
    Created on : 27 sept 2024, 21:36:15
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
    
    if(request.getAttribute("tipo").equals("tabla")){
        
         JsonArray arr = (JsonArray)request.getAttribute("res");         
         
         for (int i = 0; i < arr.size(); i++) {
            JsonObject obj = arr.getJsonObject(i);
%>
<tr>
    <td><% out.print(obj.getString("id")); %></td>
    <td><% out.print(obj.getString("nombre")); %></td>
    <td><% out.print(obj.getString("fecha")); %></td>
    <td><% out.print(obj.getString("estado")); %></td>
    <td>
        <div class="dropdown">
            <a class="btn btn-link font-24 p-0 line-height-1 no-arrow dropdown-toggle" href="#" role="button" data-toggle="dropdown">
                <i class="dw dw-more"></i>
            </a>
            <div class="dropdown-menu dropdown-menu-right dropdown-menu-icon-list">
                <button class="dropdown-item" onclick="transferir('<% out.print(obj.getString("id")); %>')" data-toggle="modal" data-target="#form-modal"><i class="fa-solid fa-pen-to-square"></i> GESTIONAR</button>
                <a target="_blank" href="/reporte.jsp?reporte=encontrado&codigo=<% out.print(obj.getString("id")); %>" class="dropdown-item"><i class="fa-regular fa-file"></i> REPORTE</a>
            </div>
        </div>
    </td>
</tr>
<%
    } }

else if(request.getAttribute("tipo").equals("post")){
JsonObject obj = (JsonObject)request.getAttribute("dets");
System.out.println(obj.toString());
if(obj.getString("sis_estado").equals("APROBADO")){
%>
<script>document.getElementById("btnaprob").disabled = true;</script>
<% }else{ %>
<script>document.getElementById("btnaprob").disabled = false;</script>
<% } %>
<div class="w-100 text-center p-5">
    <h5>Publicacion #<% out.print(obj.getString("postid"));%></h5>
</div>
<div class="card">
    <div class="card-body">
        <div class="row">
            <div class="col">                
                <p class="lead"><b>Lugar: </b><span><% out.print(obj.getString("lugar"));%></span></p>
                <p class="lead"><b>Contacto: </b><span><% out.print(obj.getString("contacto"));%></span></p>            
                <p class="lead"><b>Informacion adicional:</b><br><span><% out.print(obj.getString("info"));%></span></p>
            </div>
            <div class="col text-right">
                <p class="lead"><b>Usuario: </b><span><% out.print(obj.getString("nombre"));%></span></p>
                <p class="lead"><b>Fecha: </b><span><% out.print(obj.getString("fecha"));%></span></p>
                <p class="lead"><b>Estado: </b><span><% out.print(obj.getString("sis_estado"));%></span></p>
            </div>
        </div>
    </div>
</div>
<div>
    <%
    Integer contad = 0;
    for (int i = 0; i < obj.getJsonArray("mascotas").size(); i++) {
    JsonObject masco = obj.getJsonArray("mascotas").getJsonObject(i);
    %>


    <div class="card w-100 my-5">
        <div class="card-body mb-30">
            <div class="row">                            
                <div class="col-md-3 col-sm-4 col-6">
                    <div class="mb-2">
                        <h6>Especie:</h6>
                        <span><% out.print(masco.getString("especie")); %></span>
                    </div>
                </div>
                <div class="col-md-3 col-sm-4 col-6">
                    <div class="mb-2">
                        <h6>Raza:</h6>
                        <span><% out.print(masco.getString("raza")); %></span>
                    </div>
                </div>
                <div class="col-md-3 col-sm-4 col-6">
                    <div class="mb-2">
                        <h6>Genero:</h6>
                        <span><% out.print(masco.getString("genero")); %></span>
                    </div>
                </div>
                <div class="col-12">
                    <div class="my-3">
                        <h6>Descripcion:</h6>
                        <span><% out.print(masco.getString("descripcion")); %></span>
                    </div>
                </div>
                <div class="col-12">
                    <div class="my-3">
                        <h6>Imagenes:</h6>
                    </div>
                    <div class="d-flex flex-wrap">
                        <% for (int j = 0; j < masco.getJsonArray("imgs").size(); j++) { %>
                        <div class="card rounded imgl position-relative m-2 imgc">
                            <img class="imgl imgn" src="/imgs/posts/e/<% out.print(masco.getJsonArray("imgs").getString(j)); %>">
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>

        </div>

    </div>

    <%  }} %>

</div>
