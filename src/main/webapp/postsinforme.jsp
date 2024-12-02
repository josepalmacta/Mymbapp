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
                        String departamento = request.getParameter("departamento");
                        String ciudad = request.getParameter("ciudad");
                        String barrio = request.getParameter("barrio");
                        String usuario = request.getParameter("usuario");
                        String param1 = " 1=1 ";
                        String param2 = "";
                        String param3 = "";
                        Map parametros=new HashMap();
                        
                        try
                        {
                        String tipo = "PERDIDAS";
                        if(informe.contains("adopciones")){
                            tipo = "EN ADOPCION";
                        }
                        if(informe.contains("encontrados")){
                            tipo = "ENCONTRADAS";
                        }
                        
                        parametros.put("tipo", tipo);
                        
                        HttpSession sesion = request.getSession();
                        if(sesion.getAttribute("logueado") == null){
                            return;
                        }
                        
                        parametros.put("autor", sesion.getAttribute("user"));
                        
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
                            param1 += " AND sis_estado='" + estado + "' ";
                        }
                        
                        if(departamento != null && !departamento.equals("-1")){
                            param1 += " AND dep.id='" + departamento + "' ";
                        }
                        
                        if(ciudad != null && !ciudad.equals("-1")){
                            param1 += " AND ciu.id='" + ciudad + "' ";
                        }
                        
                        if(barrio != null && !barrio.equals("-1")){
                            param1 += " AND barr.id='" + barrio + "' ";
                        }
                        
                        if(usuario != null && !usuario.equals("TODOS")){
                            param1 += " AND persona='" + usuario + "' ";
                            parametros.put("qusu", Integer.parseInt(usuario));
                        }
                        else{
                            parametros.put("qusu", -1);
                        }
                        
                        
                        if(informe.contains("detallado")){
                            if(!request.getParameter("especie").equals("TODOS")){
                                param1 += " AND especie='" + request.getParameter("especie") + "' ";
                                parametros.put("espquery", "especies.id='" + request.getParameter("especie") + "' ");
                            }
                            else{
                                parametros.put("especie", -1);
                                parametros.put("espquery", "1=1");
                            }                           
                        }
                        
                        
                        
                        
                        File reportFile=new File(application.getRealPath("informes/" + informe + ".jasper"));
                        
                        
                        
                        System.out.println(param1);
                        
                        parametros.put("params", param1);
                        
                        
                        parametros.put("finicio", ((desde.length() < 2) ? "TODO" : desde));
                        parametros.put("ffin", ((hasta.length() < 2) ? "TODO" : hasta));
                        
                        if(!informe.contains("detallado")){
                            parametros.put("estado", estado);                        
                            parametros.put("qdepar", Integer.parseInt(departamento));
                            parametros.put("qciu", Integer.parseInt(ciudad));
                            parametros.put("qbarr", Integer.parseInt(barrio));
                        }


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
