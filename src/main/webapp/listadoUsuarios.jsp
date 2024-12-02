<%-- 
    Document   : listadoUsuarios
    Created on : 13 ago 2024, 14:06:00
    Author     : Usuario
--%>

<%@ page import="net.sf.jasperreports.engine.*" %> 
<%@ page import="java.util.*" %> 
<%@ page import="java.io.*" %> 
<%@ page import="java.sql.*" %> 
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ include file="api/conexion.jsp" %>

<%
                        try
                        {
                        
                        File reportFile=new File(application.getRealPath("resportes/reporte.jasper"));

                        Map parametros=new HashMap();

                        byte [] bytes= JasperRunManager.runReportToPdf(reportFile.getPath(), parametros,conn);
                        response.setContentType("application/pdf");
                        response.setContentLength(bytes.length);

                        ServletOutputStream output=response.getOutputStream();
                        response.getOutputStream();
                        output.write(bytes,0,bytes.length);
                        output.flush();
                        output.close();
                        
                        
                        }
                        catch(java.io.FileNotFoundException ex)
                        {
                            ex.getMessage();
                        }
%>
