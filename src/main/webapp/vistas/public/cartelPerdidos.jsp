<%-- 
    Document   : cartelPerdidos
    Created on : 3 nov 2024, 23:02:55
    Author     : Usuario
--%>

<%@ page import="net.sf.jasperreports.engine.*" %> 
<%@ page import="java.util.*" %> 
<%@ page import="java.io.*" %> 
<%@ page import="java.sql.*" %> 
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ include file="../../jsp/conexion.jsp" %>

<%
                        
                        try
                        {
                        
                        String postid = (String)request.getAttribute("postid");
                        
                        File reportFile=new File(application.getRealPath("resportes/cartelperdido.jasper"));
                        
                        
                        Map parametros=new HashMap();
                        
                        parametros.put("detalle", Integer.parseInt(postid));

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

