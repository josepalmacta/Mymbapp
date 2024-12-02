<%-- 
    Document   : compra
    Created on : 7 sept 2024, 11:04:31
    Author     : Usuario
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="jakarta.json.JsonValue"%>
<%@page import="jakarta.json.Json"%>
<%@page import="jakarta.json.JsonArray"%>
<%@page import="jakarta.json.JsonArrayBuilder"%>
<%@page import="jakarta.json.JsonObject"%>



<% 
    JsonObject dets = (JsonObject)request.getAttribute("dets");
    JsonObject adams = (JsonObject)request.getAttribute("adams");
    String titulo = "Mi compra #" + dets.getString("ventid"); 
%>
<%@include file="header.jsp" %>

<style>
    .img-fl {
        max-width: 25vw;
        height: 25vw;
    }

    @media (min-width: 1280px) {
        .img-fl {
            max-width: 6vw;
            height: 6vw;
        }
    }
</style>

<style>
    #map {
        width: 100%;
        height: 400px;
    }
</style>
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
      integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=" crossorigin="" />

<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""></script>



<section class="p-3 py-5">
    <div class="container h-100">
        <div id="carrito" class="row d-flex justify-content-center align-items-center h-100">
            <div id="wiz">
                <div class="wizard-content">
                    <div class="wizard-step mt-3">
                        <div class="col">
                            <p><span class="h2">Compra #<% out.print(dets.getString("ventid")); %></span></p>
                            <input type="hidden" id="venta" value="<% out.print(dets.getString("ventid")); %>"/>
                            
                            <p><span class="h3">Estado: </span><span class="h4"> <% out.print(dets.getString("estado")); %></span></p>
                            
                            <% if(dets.getString("estado").equals("PAGO PENDIENTE")){ %>
                            <div class="my-2">
                                <a href="<% if(adams.getJsonObject("debt").getJsonObject("objStatus").getString("status").equals("active")){ out.print(adams.getJsonObject("debt").getString("payUrl")); } %>" class="btn btn-primary"><i class="fa-solid fa-cart-shopping"></i> Pagar</a>
                            </div>
                            <% } %>
                            
                            
                            <div class="card mb-4">
                                <div class="card-body p-4">

                                    <%
                                        JsonArray arr = dets.getJsonArray("detalle");
                                        for (int i = 0; i < arr.size(); i++) {
                                            JsonObject obj = arr.getJsonObject(i);
                                    %>

                                    <div class="row align-items-center mb-3">
                                        <div class="col-md-2 text-center">
                                            <img src="<% out.print(obj.getString("img")); %>"
                                                 class="img-fl rounded" alt="Generic placeholder image">
                                        </div>
                                        <div class="col-md-4 d-flex justify-content-center">
                                            <div>
                                                <p class="lead fw-normal mb-0"><% out.print(obj.getString("nombre")); %></p>
                                            </div>
                                        </div>
                                        <div class="col-md-2 d-flex justify-content-center">
                                            <div>
                                                <p class="lead fw-normal mb-0"><% out.print(obj.getString("precio")); %></p>
                                            </div>
                                        </div>
                                        <div class="col-md-2 d-flex justify-content-center">
                                            <div>
                                                <p class="lead fw-normal mb-0"><% out.print(obj.getString("cantidad")); %></p>
                                            </div>
                                        </div>
                                        <div class="col-md-2 d-flex justify-content-center">
                                            <div>
                                                <p class="lead fw-normal mb-0"><% out.print(obj.getString("subtotal")); %></p>
                                            </div>
                                        </div>
                                    </div>

                                    <% } %>

                                </div>
                            </div>

                            <div class="card mb-5">
                                <div class="card-body p-4">

                                    <div class="float-end">
                                        <p class="mb-0 me-5 d-flex align-items-center">
                                            <span class="small text-muted me-2">Total:</span> <span
                                                class="lead fw-normal"><% out.print(dets.getString("total")); %></span>
                                        </p>
                                    </div>

                                </div>
                            </div>

                        </div>
                    </div>

                    <div class="wizard-step mt-3">
                        <p><span class="h2">Datos de Facturacion</span></p>
                        <div class="card p-5 mb-5">
                            <div class="row">
                                <div class="col">
                                    <div class="mb-3 mt-3">
                                        <label class="form-label">Nombre o Razon Social</label>                
                                        <div class="input-group flex-nowrap">
                                            <input value="<% out.print(dets.getString("razon")); %>" disabled id="nombre" class="form-control" type="text">
                                        </div>
                                    </div>  
                                </div>
                                <div class="col">
                                    <div class="mb-3 mt-3">
                                        <label class="form-label">CI o RUC</label>                
                                        <div class="input-group flex-nowrap">
                                            <input value="<% out.print(dets.getString("ruc")); %>" disabled id="ruc" class="form-control" type="text">
                                        </div>
                                    </div>  
                                </div>
                            </div>
                            <div class="row">
                                <div class="col">
                                    <div class="mb-3 mt-3">
                                        <label class="form-label">Telefono</label>                
                                        <div class="input-group flex-nowrap">
                                            <input value="<% out.print(dets.getString("telefono")); %>" disabled id="telefono" type="number" class="form-control" type="text">
                                        </div>
                                    </div>  
                                </div>
                                <div class="col">
                                    <div class="mb-3 mt-3">
                                        <label class="form-label">Email</label>                
                                        <div class="input-group flex-nowrap">
                                            <input value="<% out.print(dets.getString("email")); %>" disabled id="email" type="email" class="form-control" type="text">
                                        </div>
                                    </div>  
                                </div>
                            </div>
                            <div class="row">
                                <div class="col">
                                    <div class="mb-3 mt-3">
                                        <label class="form-label">Direccion</label>                
                                        <div class="input-group flex-nowrap">
                                            <input value="<% out.print(dets.getString("direccion")); %>" disabled id="direccion" class="form-control" type="text">
                                        </div>
                                    </div>  
                                </div>
                            </div>
                        </div>



                    </div>

                    <div class="wizard-step mt-3">
                        <p><span class="h2">Ubicacion de entrega</span></p>
                        <div class="card p-3 mb-5">
                            <div class="mapaa text-center">
                                <div id="map"></div>
                            </div>
                        </div>



                    </div>

                </div>

                <div class="modal-footer wizard-buttons">
                    <!-- The wizard button will be inserted here. -->
                </div>
            </div>

        </div>
    </div>
</section>

<script>
    let locat = [<% out.println(dets.getString("lat")); %>, <% out.println(dets.getString("lng")); %>];
    let mapOptions = {
            center: locat,
            zoom: 12
        }

        map = new L.map('map', mapOptions);

        let layer = new L.TileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
            minZoom: 12
        });
        map.addLayer(layer);

        marker = L.marker(locat).addTo(map);
</script>

<%@include file="footer.jsp" %>
