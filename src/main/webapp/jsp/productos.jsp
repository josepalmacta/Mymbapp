<%-- 
    Document   : productos
    Created on : 10 ago 2024, 19:59:01
    Author     : Usuario
--%>

<%@ page language="java" contentType="text/plain" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="jakarta.json.JsonValue"%>
<%@page import="jakarta.json.Json"%>
<%@page import="jakarta.json.JsonArray"%>
<%@page import="jakarta.json.JsonArrayBuilder"%>
<%@page import="jakarta.json.JsonObject"%>
<%@page import="java.util.Base64"%>
<%
        
         JsonArray arr = (JsonArray)request.getAttribute("res");
         
         System.out.println(arr);
         
         for (int i = 0; i < arr.size(); i++) {
            JsonObject obj = arr.getJsonObject(i);
%>
<tr>
    <td class="table-plus">
        <img src='<% out.print(obj.getJsonArray("imgs").getJsonObject(0).getString("path").replace("--", "/")); %>' class="imgpr rounded">
    </td>
    <td><% out.print(obj.getString("nombre")); %></td>
    <td><% out.print(obj.getString("descripcion")); %></td>
    <td><% out.print(obj.getString("precio")); %></td>
    <td><% out.print(obj.getString("stock")); %></td>
    <td>
        <div class="dropdown">
            <a class="btn btn-link font-24 p-0 line-height-1 no-arrow dropdown-toggle" href="#" role="button" data-toggle="dropdown">
                <i class="dw dw-more"></i>
            </a>
            <div class="dropdown-menu dropdown-menu-right dropdown-menu-icon-list">
                <button class="dropdown-item" onclick="transferir('<% out.print(obj.getString("id")); %>', '<% out.print(obj.getString("nombre")); %>', '<% out.print(obj.getString("descripcion")); %>', '<% out.print(obj.getString("precio")); %>', '<% out.print(obj.getString("stock")); %>', '<% out.print(Base64.getEncoder().encodeToString(obj.getJsonArray("imgs").toString().getBytes())); %>')" data-toggle="modal" data-target="#form-modal"><i class="fa-solid fa-pen-to-square"></i> MODIFICAR</button>
                <button class="dropdown-item" onclick="$('#codigo').val('<% out.print(obj.getString("id")); %>')" data-toggle="modal" data-target="#confirmation-modal"><i class="fa-regular fa-trash-can"></i> ELIMINAR</button>
                <a target="_blank" href="/reporte.jsp?reporte=producto&codigo=<% out.print(obj.getString("id")); %>" class="dropdown-item"><i class="fa-regular fa-file"></i> REPORTE</a>
            </div>
        </div>
    </td>
</tr>
<%
    }
%>
