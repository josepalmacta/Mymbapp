<%-- 
    Document   : venta
    Created on : 31 ago 2024, 11:20:12
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
        
         JsonObject vent = (JsonObject)request.getAttribute("dets");
         JsonArray arr = vent.getJsonArray("detalle");         
%>
<div class="invoice-wrap">
    <div class="invoice-box">
        <div class="invoice-header">
            <div class="logo text-center">
                <img src="vendors/images/deskapp-logo.png" alt="">
            </div>
        </div>
        <h4 class="text-center mb-30 weight-600">PEDIDO #<% out.print(vent.getString("ventid")); %></h4>
        <div class="row pb-30">
            <div class="col-md-6">
                <h5 class="mb-15">Datos de Facturacion</h5>
                <p class="font-14 mb-5">Razon Social: <strong class="weight-600"><% out.print(vent.getString("razon")); %></strong></p>
                <p class="font-14 mb-5">RUC: <strong class="weight-600"><% out.print(vent.getString("ruc")); %></strong></p>
                <p class="font-14 mb-5">Telefono: <strong class="weight-600"><% out.print(vent.getString("telefono")); %></strong></p>
                <p class="font-14 mb-5">Email: <strong class="weight-600"><% out.print(vent.getString("email")); %></strong></p>
                <p class="font-14 mb-5">Direccion: <strong class="weight-600"><% out.print(vent.getString("direccion")); %></strong></p>
            </div>
            <div class="col-md-6">
                <div class="text-right">
                    <p class="font-14 mb-5">Usuario: <strong class="weight-600"><% out.print(vent.getString("persona")); %></strong></p>
                    <p class="font-14 mb-5">Cod. Usuario: <strong class="weight-600"><% out.print(vent.getString("perid")); %></strong></p>
                    <p class="font-14 mb-5">Fecha: <strong class="weight-600"><% out.print(vent.getString("fecha")); %></strong></p>
                </div>
            </div>
        </div>
        <div class="invoice-desc pb-30">
            <div class="invoice-desc-head clearfix">
                <div class="invoice-sub">PRODUCTO</div>
                <div class="invoice-rate">PRECIO</div>
                <div class="invoice-hours">CANT.</div>
                <div class="invoice-subtotal">SUBTOTAL</div>
            </div>
            <div class="invoice-desc-body">
                <ul>
                    <%
                        for (int i = 0; i < arr.size(); i++) {
                        JsonObject obj = arr.getJsonObject(i);
                    %>
                    <li class="clearfix">
                        <div class="invoice-sub"><% out.print(obj.getString("nombre")); %></div>
                        <div class="invoice-rate"><% out.print(obj.getString("precio")); %></div>
                        <div class="invoice-hours"><% out.print(obj.getString("cantidad")); %></div>
                        <div class="invoice-subtotal"><span class="weight-600"><% out.print(obj.getString("subtotal")); %></span></div>
                    </li>
                    <% } %>
                </ul>
            </div>
            <div class="invoice-desc-footer">
                <div class="invoice-desc-head clearfix">
                    <div class="invoice-sub">TOTAL</div>
                    <div class="invoice-rate"></div>
                    <div class="invoice-subtotal"><span class="weight-600 font-24 text-danger"><% out.print(vent.getString("total")); %></span></div>
                </div>
            </div>
        </div>
        <h4 class="text-center pb-20"><% if(vent.getString("estado").equals("FINALIZADO")){out.print("PENDIENTE DE ENVIO");}else if(vent.getString("estado").equals("ENVIADO")){out.print("PEDIDO ENVIADO");}else{out.print("PEDIDO ENTREGADO");} %></h4>
    </div>
</div>

