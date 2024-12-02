<%-- 
    Document   : carrito
    Created on : 18 ago 2024, 13:26:31
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
    
    if(dets.getString("total").equals("0")){
    
%>

<div id="mensajeconf" class="text-center">
    <img class="imgrev" src="/src/imgs/vacio.jfif" alt="revision"/>
    <h3 class="h3">NO TIENE PRODUCTOS EN SU CARRITO</h3>
    <p class="h5">
        ¿Y si compramos algo?
    </p>
    <a href="/tienda" class="btn btn-warning border-radius-100 btn-block confirmation-btn mt-2 text-primary"><i class="fa-solid fa-shop me-2 text-primary"></i> Ir a la tienda</a>
</div>

<% } else{ %>







<div id="wiz">
    <div class="wizard-content">
        <div class="wizard-step mt-3">
            <div class="col">
                <p><span class="h2">Carrito de Compras</span></p>
                <input type="hidden" id="venta" value="<% out.print(dets.getString("ventid")); %>"/>
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
                            <div class="col-md-2 d-flex justify-content-center">
                                <div>
                                    <p class="small text-muted mb-2">Producto</p>
                                    <p class="lead fw-normal mb-0"><% out.print(obj.getString("nombre")); %></p>
                                </div>
                            </div>
                            <div class="col-md-2 d-flex justify-content-center">
                                <div>
                                    <p class="small text-muted mb-2">Precio</p>
                                    <p class="lead fw-normal mb-0"><% out.print(obj.getString("precio")); %></p>
                                </div>
                            </div>
                            <div class="col-md-2 d-flex justify-content-center">
                                <div>
                                    <p class="small text-muted mb-2">Cantidad</p>
                                    <p class="lead fw-normal mb-0"><% out.print(obj.getString("cantidad")); %></p>
                                </div>
                            </div>
                            <div class="col-md-2 d-flex justify-content-center">
                                <div>
                                    <p class="small text-muted mb-2">SubTotal</p>
                                    <p class="lead fw-normal mb-0"><% out.print(obj.getString("subtotal")); %></p>
                                </div>
                            </div>
                            <div class="col-md-2 d-flex justify-content-center">
                                <div>
                                    <button onclick="eliminar('<% out.print(obj.getString("id")); %>')" class="btn btn-primary"><i class="fa-solid fa-trash"></i></button>
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
                                <span class="input-group-text"><i class="fa-solid fa-user text-primary"></i></span>
                                <input maxlength="20" id="nombre" class="form-control" type="text">
                            </div>
                        </div>  
                    </div>
                    <div class="col">
                        <div class="mb-3 mt-3">
                            <label class="form-label">CI o RUC</label>                
                            <div class="input-group flex-nowrap">
                                <span class="input-group-text"><i class="fa-solid fa-fingerprint text-primary"></i></span>
                                <input id="ruc" class="form-control" type="text">
                            </div>
                        </div>  
                    </div>
                </div>
                <div class="row">
                    <div class="col">
                        <div class="mb-3 mt-3">
                            <label class="form-label">Telefono</label>                
                            <div class="input-group flex-nowrap">
                                <span class="input-group-text"><i class="fa-solid fa-phone text-primary"></i></span>
                                <input id="telefono" type="number" class="form-control" type="text">
                            </div>
                        </div>  
                    </div>
                    <div class="col">
                        <div class="mb-3 mt-3">
                            <label class="form-label">Email</label>                
                            <div class="input-group flex-nowrap">
                                <span class="input-group-text"><i class="fa-solid fa-at text-primary"></i></span>
                                <input maxlength="50" id="email" type="email" class="form-control" type="text">
                            </div>
                        </div>  
                    </div>
                </div>
                <div class="row">
                    <div class="col">
                        <div class="mb-3 mt-3">
                            <label class="form-label">Direccion</label>                
                            <div class="input-group flex-nowrap">
                                <span class="input-group-text"><i class="fa-solid fa-building text-primary"></i></span>
                                <input maxlength="50" id="direccion" class="form-control" type="text">
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


<script>
    $("#wiz").wizard({
        onfinish: function () {
            finalizar();
        }
    });
    var map = null;
    var marker = null;
    function initMap(locat) {
        let mapOptions = {
            center: locat,
            zoom: 12
        }

        if (map != null) {
            map.remove();
        }

        map = new L.map('map', mapOptions);

        let layer = new L.TileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
            minZoom: 12
        });
        map.addLayer(layer);

        marker = L.marker(locat).addTo(map);

        map.on('move', (event) => {

            marker.setLatLng(map.getCenter());

        });

    }

    function getLoc() {


        $.ajax({
            url: "https://ipinfo.io/json",
            type: "GET",
            crossDomain: true,
            success: function (json) {
                const myLatLng = [parseFloat(json.loc.split(",")[0]), parseFloat(json.loc.split(",")[1])];
                initMap(myLatLng);

            },
            error: function (e) {
                console.log(e);
            }
        });
    }
    
    
    function getMetodos(){
        $.ajax(
                {
                    url: "/carrito/metodos",
                    success: function (response) {
                        $("#metodos").html(response);
                    }
                }
        );
    }





</script>

<% } %>
