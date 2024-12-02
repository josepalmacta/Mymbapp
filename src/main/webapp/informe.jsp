<%-- 
    Document   : informe
    Created on : 1 oct 2024, 15:03:27
    Author     : Usuario
--%>

<%@ page import="net.sf.jasperreports.engine.*" %> 
<%@ page import="java.util.*" %> 
<%@ page import="java.io.*" %> 
<%@ page import="java.sql.*" %> 
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ include file="api/conexion.jsp" %>

<%
                        
                        String informe = request.getParameter("informe");
                        String desde = request.getParameter("desde");
                        String hasta = request.getParameter("hasta");
                        String estado = request.getParameter("estado");
                        String param1 = " 1=1 AND NOT estado='PENDIENTE' ";
                        String param2 = "";
                        String param3 = "";
                        
                        HttpSession sesion = request.getSession();
                        if(sesion.getAttribute("logueado") == null){
                            return;
                        }
                        
                        

                        Map parametros=new HashMap();
                        try
                        {
                        
                        
                        if(desde.length() > 2){
                            if(hasta.length() > 2){
                                param1 += " AND fecha BETWEEN '" + desde + "' AND '" + hasta + "' ";
                            }
                            else{
                                param1 += " AND fecha >=  '" + desde + "' ";
                            }
                        }
                        else if(hasta.length() > 2){
                            param1 += " AND fecha <=  '" + hasta + "' ";
                        }
                        
                        if(estado != null && !estado.equals("TODOS")){
                            param1 += " AND estado='" + estado + "' ";
                        }
                        
                        if(informe.equals("ventas")){
                            if(!request.getParameter("cliente").equals("TODOS")){
                                param1 += " AND persona='" + request.getParameter("cliente") + "' ";
                                parametros.put("cliquery", "personas.id='" + request.getParameter("cliente") + "' ");
                            }
                            else{
                                parametros.put("cliente", -1);
                                parametros.put("cliquery", "1=1");
                            }
                            
                        }
                        
                        
                        if(informe.equals("ventasdetallado")){
                            if(!request.getParameter("producto").equals("TODOS")){
                                param1 += " AND producto='" + request.getParameter("producto") + "' ";
                                parametros.put("proquery", "productos.id='" + request.getParameter("producto") + "' ");
                            }
                            else{
                                parametros.put("producto", -1);
                                parametros.put("proquery", "1=1");
                            }
                            
                        }
                        
                        File reportFile=new File(application.getRealPath("informes/" + informe + ".jasper"));
                        
                        
                        
                        
                        System.out.println(param1);
                        
                        parametros.put("params", param1);
                        parametros.put("finicio", ((desde.length() < 2) ? "TODO" : desde));
                        parametros.put("ffin", ((hasta.length() < 2) ? "TODO" : hasta));
                        parametros.put("estado", estado);
                        parametros.put("autor", sesion.getAttribute("user"));

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
