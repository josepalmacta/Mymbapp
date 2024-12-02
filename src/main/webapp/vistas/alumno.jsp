<%-- 
    Document   : alumno
    Created on : 13 abr 2024, 9:53:28
    Author     : Usuario
--%>
<%@ page language="java" contentType="text/plain" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@include file="conexion.jsp"%>
<%
    Statement st = null;
    ResultSet rs = null;
    try{
        st = conn.createStatement();        
        String opt = request.getParameter("opt");
        if(opt != null && opt.equals("add")){
            String nombre = request.getParameter("nombre");
            String apellido = request.getParameter("apellido");
            st.executeUpdate("INSERT INTO alumnos(nombre, apellido) values('" + nombre +"', '" + apellido + "')");
            out.println("AGREGADO CORRECTAMENTE");
            return;
        }        
        if(opt != null && opt.equals("edit")){
            String nombre = request.getParameter("nombre");
            String apellido = request.getParameter("apellido");
            String codigo = request.getParameter("codigo");
            st.executeUpdate("UPDATE alumnos SET nombre='" + nombre +"', apellido='" + apellido + "' WHERE id='" + codigo + "'");
            out.println("MODIFICADO CORRECTAMENTE");
            return;
        }        
        if(opt != null && opt.equals("del")){
            String codigo = request.getParameter("codigo");
            st.executeUpdate("DELETE FROM alumnos WHERE id='" + codigo + "'");
            out.println("ELIMINADO CORRECTAMENTE");
            return;
        }                       
        rs = st.executeQuery("SELECT * FROM alumnos;");
        while(rs.next()){ 
%>
<tr>
    <td><% out.print(rs.getString(1)); %></td>
    <td><% out.print(rs.getString(2)); %></td>
    <td><% out.print(rs.getString(3)); %></td>
    <td>
        <div class="dropdown">
            <a class="btn btn-link font-24 p-0 line-height-1 no-arrow dropdown-toggle" href="#" role="button" data-toggle="dropdown">
                <i class="dw dw-more"></i>
            </a>
            <div class="dropdown-menu dropdown-menu-right dropdown-menu-icon-list">
                <button class="dropdown-item" onclick="transferir('<% out.print(rs.getString(1)); %>', '<% out.print(rs.getString(2)); %>', '<% out.print(rs.getString(3)); %>')"><i class="dw dw-edit2"></i> MODIFICAR</button>
                <button class="dropdown-item" onclick="$('#codigo').val('<% out.print(rs.getString(1)); %>')" data-toggle="modal" data-target="#confirmation-modal"><i class="dw dw-delete-3"></i> ELIMINAR</button>
            </div>
        </div>
    </td>
</tr>
<%
    }
    }
    catch(Exception ex){
        out.println(ex.getMessage());
    }
%>