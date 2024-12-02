<%-- 
    Document   : departamentos
    Created on : 12 may 2024, 17:36:49
    Author     : Usuario
--%>
<%@ page language="java" contentType="text/plain" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="jakarta.json.JsonValue"%>
<%@page import="jakarta.json.Json"%>
<%@page import="jakarta.json.JsonArray"%>
<%@page import="jakarta.json.JsonArrayBuilder"%>
<%@page import="jakarta.json.JsonObject"%>
<%
        
         JsonArray arr = (JsonArray)request.getAttribute("res");
         
         for (int i = 0; i < arr.size(); i++) {
            JsonObject obj = arr.getJsonObject(i);
%>
<tr>
    <td><% out.print(obj.getString("id")); %></td>
    <td><% out.print(obj.getString("nombre")); %></td>
    <td><% out.print(obj.getString("codigo")); %></td>
    <td>
        <div class="dropdown">
            <a class="btn btn-link font-24 p-0 line-height-1 no-arrow dropdown-toggle" href="#" role="button" data-toggle="dropdown">
                <i class="dw dw-more"></i>
            </a>
            <div class="dropdown-menu dropdown-menu-right dropdown-menu-icon-list">
                <button class="dropdown-item" onclick="transferir('<% out.print(obj.getString("id")); %>', '<% out.print(obj.getString("nombre")); %>', '<% out.print(obj.getString("codigo")); %>')" data-toggle="modal" data-target="#form-modal"><i class="fa-solid fa-pen-to-square"></i> MODIFICAR</button>
                <button class="dropdown-item" onclick="$('#codigo').val('<% out.print(obj.getString("id")); %>')" data-toggle="modal" data-target="#confirmation-modal"><i class="fa-regular fa-trash-can"></i> ELIMINAR</button>
                <a target="_blank" href="/reporte.jsp?reporte=detDepartamento&codigo=<% out.print(obj.getString("id")); %>" class="dropdown-item"><i class="fa-regular fa-file"></i></i> REPORTE</a>
            </div>
        </div>
    </td>
</tr>
<%
    }
%>