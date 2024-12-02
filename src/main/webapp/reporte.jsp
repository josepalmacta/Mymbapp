<%-- 
    Document   : reporte
    Created on : 13 ago 2024, 15:47:58
    Author     : Usuario
--%>

<%@ page import="net.sf.jasperreports.engine.*" %> 
<%@ page import="java.util.*" %> 
<%@ page import="java.io.*" %> 
<%@ page import="java.sql.*" %>
<%@ page import="utilidades.NumeroALetra" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ include file="api/conexion.jsp" %>

<%
                        
                        String reporte = request.getParameter("reporte");
                        String codigo = request.getParameter("codigo");
                        String total = request.getParameter("total");
                        try
                        {
                        
                        File reportFile=new File(application.getRealPath("resportes/" + reporte + ".jasper"));
                        
                        
                        Map parametros=new HashMap();
                        
                        if(reporte.equals("facturaventas")){
                            String numfactura = "";
                            Integer ceros = 7 - codigo.length();
                            numfactura = numfactura + "0".repeat(ceros);
                            numfactura = numfactura + codigo;
                            numfactura = "001-001-" + numfactura;
                            parametros.put("numfac", numfactura);
                            parametros.put("letras", NumeroALetra.convertir(Integer.parseInt(total)));
                        }
                        
                        if(codigo != null){
                            parametros.put("codee", Integer.parseInt(codigo));
                            parametros.put("detalle", Integer.parseInt(codigo));
                        }
                        parametros.put("params", "");

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
