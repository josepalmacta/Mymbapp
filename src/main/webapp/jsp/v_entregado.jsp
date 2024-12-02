<%-- 
    Document   : v_entregado
    Created on : 1 sept 2024, 18:17:35
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
        
         JsonArray arr = (JsonArray)request.getAttribute("dets");
         
         for (int i = 0; i < arr.size(); i++) {
            JsonObject obj = arr.getJsonObject(i);
%>
<tr>
    <td><% out.print(obj.getString("id")); %></td>
    <td><% out.print(obj.getString("cliente")); %></td>
    <td><% out.print(obj.getString("fecha")); %></td>
    <td><% out.print(obj.getString("total")); %></td>
    <td><% out.print(obj.getString("estado")); %></td>
    <td>
        <div class="dropdown">
            <a class="btn btn-link font-24 p-0 line-height-1 no-arrow dropdown-toggle" href="#" role="button" data-toggle="dropdown">
                <i class="dw dw-more"></i>
            </a>
            <div class="dropdown-menu dropdown-menu-right dropdown-menu-icon-list">
                <button class="dropdown-item" onclick="transferir('<% out.print(obj.getString("id")); %>', 'anular')" data-toggle="modal" data-target="#form-modal"><i class="fa-solid fa-pen-to-square"></i> GESTIONAR</button>
                <a href="/reporte.jsp?reporte=facturaventas&codigo=<% out.print(obj.getString("id")); %>&total=<% out.print(obj.getString("total")); %>" target="_blank" class="dropdown-item"><i class="fa-solid fa-file-invoice-dollar"></i> FACTURA</a>
            </div>
        </div>
    </td>
</tr>
<%
    }
%>

