<%-- 
    Document   : conexion
    Created on : 13 abr 2024, 8:29:02
    Author     : Usuario
--%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/plain" pageEncoding="UTF-8"%>
<%
    Connection conn = null;
    Class.forName("org.postgresql.Driver");
    conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/proyectoTT", "postgres", "1");    
%>