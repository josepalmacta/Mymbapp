<%-- 
    Document   : metodos
    Created on : 27 oct 2024, 16:10:21
    Author     : Usuario
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="jakarta.json.JsonValue"%>
<%@page import="jakarta.json.Json"%>
<%@page import="jakarta.json.JsonArray"%>
<%@page import="jakarta.json.JsonArrayBuilder"%>
<%@page import="jakarta.json.JsonObject"%>
<form id="listaMetodos">
<%
        JsonArray arr = (JsonArray)request.getAttribute("dets");
            for (int i = 0; i < arr.size(); i++) {
                JsonObject obj = arr.getJsonObject(i);
                String chkd = (i == 0) ? "checked='true'" : "";
%>
    <div class="form-check d-flex bg-white align-items-center px-3 mb-3 rounded-3 shadow-sm">
        <label class="form-check-label d-flex align-items-center py-3 gap-3 w-75" for="flexRadioDefault1">
            <img class="img-fluid cw-60 border rounded-2" src="<% out.print(obj.getString("imagen")); %>">
            <h5 class="m-0 fw-bold h6"><% out.print(obj.getString("nombre")); %></h5>
        </label>
            <input class="form-check-input ms-auto fs-5" type="radio" <% out.print(chkd); %> value="<% out.print(obj.getString("id")); %>" name="metodo">
    </div>
<% } %>
</form>