<%-- 
    Document   : editPerdidos
    Created on : 21 sept 2024, 10:27:20
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
    JsonObject obj = (JsonObject)request.getAttribute("dets");
    if(!obj.getBoolean("hay")){ 
        response.sendRedirect("/404");
        return;
    }
    String titulo = "Actualizar Publicacion"; 
%>
<%@include file="header.jsp" %>  



<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
      integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=" crossorigin="" />

<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""></script>

<style>
    #map {
        width: 100%;
        height: 400px;
        overflow: hidden;
    }
</style>

<div class="contain">
    <div id="mensajeconf" class="text-center d-none">
        <img class="imgrev" src="/src/imgs/revision.jfif" alt="revision"/>
        <h3 class="h3">PUBLICACION ACTUALIZADA</h3>
        <p class="h5">
            Su publicacion ha sido actualizada correctamente.
        </p>
        <a href="/perdidos/post/<% out.print(obj.getString("postid")); %>" class="btn btn-warning border-radius-100 btn-block confirmation-btn mt-2 text-primary"><i class="fa-solid fa-file-invoice me-2 text-primary"></i> Ver publicacion</a>
    </div>
    <div id="contenid">
        <div class="p-3">
            <div class="d-flex gap-1 align-items-center pt-3">
                <h3 class="fw-bold text-dark mb-0">ACTUALIZAR PUBLICACION</h3>
            </div>


            <div class="mb-3 mt-5">
                <h6>¿Ya localizaste a tu mascota?</h6>
                <h7>Si ya encontro a su mascota por favor haga clic en el boton para actualizar el estado de la publicacion a "LOCALIZADO"</h7>
                <div class="input-group flex-nowrap p-3">
                    <button onclick="mostrarConfirm()" class="btn btn-primary"><i class="fa-solid fa-check"></i> Mascota Encontrada</button>
                </div>
                <input type="hidden" id="idpost" value="<% out.print(obj.getString("postid")); %>">
            </div>


            <div class="mb-3 mt-5">
                <div id="mascl" class="row">
                </div>
            </div>


            <div class="mb-3 mt-5">
                <label class="form-label">CONTACTO</label>                
                <div class="input-group flex-nowrap">
                    <input value="<% out.print(obj.getString("contacto")); %>" id="contacto" class="form-control" type="text" placeholder="098Xxxxxxx">
                </div>
            </div>


            <div class="mb-3 mt-5">
                <label class="form-label">INFORMACION ADICIONAL</label>
                <div class="input-group flex-nowrap">
                    <textarea rows="4" id="descripcion" name="descripcion" class="form-control px-3 py-2"
                              placeholder="Ingrese aqui cualquier informacion que pueda ayudar a encontrar a su mascota."><% out.print(obj.getString("info")); %></textarea>
                </div>
            </div>


            <div class="mb-3 mt-5">
                <label class="form-label">ZONA VISTA POR ULTIMA VEZ</label>
                <div class="input-group flex-nowrap">
                    <input type="hidden" name="lat" id="laat">
                    <input type="hidden" name="long" id="loong">
                    <div class="card w-100">
                        <div class="mapaa text-center">
                            <div id="map"></div>
                        </div>
                    </div>
                </div>
            </div>





            <%
                                for (int i = 0; i < obj.getJsonArray("mascotas").size(); i++) {
                                JsonObject masco = obj.getJsonArray("mascotas").getJsonObject(i);
            %>
            <div class="mb-3 mt-5">
                <div class="card">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3 col-sm-4 col-6">
                                <div class="mb-2">
                                    <h6>Nombre:</h6>
                                    <span><% out.print(masco.getString("nombre")); %></span>
                                </div>
                            </div>
                            <div class="col-md-3 col-sm-4 col-6">
                                <div class="mb-2">
                                    <h6>Especie:</h6>
                                    <span><% out.print(masco.getString("especie")); %></span>
                                </div>
                            </div>
                            <div class="col-md-3 col-sm-4 col-6">
                                <div class="mb-2">
                                    <h6>Raza:</h6>
                                    <span><% out.print(masco.getString("raza")); %></span>
                                </div>
                            </div>
                            <div class="col-md-3 col-sm-4 col-6">
                                <div class="mb-2">
                                    <h6>Genero:</h6>
                                    <span><% out.print(masco.getString("genero")); %></span>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="my-3">
                                    <h6>Descripcion:</h6>
                                    <span><% out.print(masco.getString("descripcion")); %></span>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="my-3">
                                    <h6>Imagenes:</h6>
                                </div>
                                <div class="d-flex flex-wrap">
                                    <% for (int j = 0; j < masco.getJsonArray("imgs").size(); j++) { %>
                                    <div class="card rounded imgl position-relative m-2 imgc">
                                        <img class="imgl imgn" src="/imgs/posts/p/<% out.print(masco.getJsonArray("imgs").getString(j)); %>">
                                    </div>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <% } %>








        </div>
        <div class="px-5">
            <button class="btn btn-primary rounded-pill w-100 btn-lg" onclick="enviarDat()">ACTUALIZAR POST</button>
        </div>
    </div>
</div>


<script src="/src/vender/bootstrap/js/bootstrap.bundle.min.js" type="text/javascript"></script>

<script src="/src/vender/jquery/jquery.min.js" type="text/javascript"></script>

<script src="/resources/src/plugins/sweetalert2/sweetalert2.all.js"></script>


<script>
                var psts = [];
                var isE = -1;
                var map;
                var circ;
                var marker = null;

                function initMap(locat) {
                    let mapOptions = {
                        center: locat,
                        zoom: 12,
                        maxBounds: [[-19.3233, -62.5671], [-27.5392, -54.3054]]
                    };

                    map = new L.map('map', mapOptions);

                    let layer = new L.TileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                        attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
                        minZoom: 12,
                        bounds: [[-19.3233, -62.5671], [-27.5392, -54.3054]]
                    });
                    map.addLayer(layer);

                    marker = L.marker(locat).addTo(map);


                    /*map.on('click', (event) => {
                     
                     if (marker !== null) {
                     map.removeLayer(marker);
                     }
                     
                     marker = L.marker([event.latlng.lat, event.latlng.lng]).addTo(map);
                     
                     document.getElementById('latitude').value = event.latlng.lat;
                     document.getElementById('longitude').value = event.latlng.lng;
                     
                     });*/


                    map.on('move', (event) => {

                        marker.setLatLng(map.getCenter());

                    });

                }

</script>



<script>
    let locat = [<% out.print(obj.getString("lat")); %>, <% out.print(obj.getString("lng")); %>];
    let mapOptions = {
        center: locat,
        zoom: 14
    };

    map = new L.map('map', mapOptions);

    let layer = new L.TileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
        minZoom: 12
    });
    map.addLayer(layer);

    circ = L.circle(map.getCenter(), {radius: 1000}).addTo(map);

    


    map.on('move', (event) => {
        map.removeLayer(circ);
        circ = L.circle(map.getCenter(), {radius: 1000}).addTo(map);

    });
</script>




<script>
    function mostrarMensaje(mensaje) {
        if (mensaje["success"]) {
            //location.href= "/dashboard/inicio";
            //$("#confirmation-modal").modal("show");
            $("#contenid").addClass("d-none");
            $("#mensajeconf").removeClass("d-none");
            return;
        }

        swal(
                {
                    type: mensaje["estado"],
                    position: 'center',
                    title: mensaje["mensaje"],
                    showConfirmButton: false,
                    timer: 3500
                }
        );
    }
    
    
    
    
    
    function mostrarConfirm() {
        swal(
                {
                    type: "warning",
                    text: 'Si actualiza el estado a "LOCALIZADO" se dara por finalizada la publicacion.',
                    position: 'center',
                    title: "¿Actualizar estado?",
                    showCancelButton: true,
                    showConfirmButton: true,
                    confirmButtonClass: 'btn btn-success m-3',
                    cancelButtonClass: 'btn btn-danger m-3',
                    buttonsStyling: false,
                    confirmButtonText: 'Si, actualizar',
                    cancelButtonText: 'Cancelar',
                }
        ).then((result)=>{
            if(result.value){
                updateState();
            }
        });
    }
    
    
    
    
    


    function valido() {
        if ($("#descripcion").val().trim() === "") {
            mostrarMensaje({"success": false, "estado": "warning", "mensaje": "AGREGUE INFORMACION ADICIONAL"});
            return false;
        }
        if ($("#contacto").val().trim() === "") {
            mostrarMensaje({"success": false, "estado": "warning", "mensaje": "AGREGUE SU NUMERO DE CONTACTO"});
            return false;
        }
        return true;
    }
</script>




<script>

    function enviarDat() {

        if (!valido()) {
            return;
        }

        $.ajax({
            url: "/perdidos/edit",
            data: {post: $("#idpost").val(), contacto: $("#contacto").val(), info: $("#descripcion").val(), lat: map.getCenter()["lat"].toString(), long: map.getCenter()["lng"].toString()},
            type: "POST",
            crossDomain: true,
            success: function (json) {
                let res = JSON.parse(json);
                mostrarMensaje(res);
            },
            error: function (e) {
                console.log(e);
            }
        });


    }
    
    
    function updateState(){
        $.ajax({
            url: "/perdidos/finalizar",
            data: {post: $("#idpost").val()},
            type: "POST",
            crossDomain: true,
            success: function (json) {
                let res = JSON.parse(json);
                mostrarMensaje(res);
            },
            error: function (e) {
                console.log(e);
            }
        });
    }
</script>


<%@include file="footer.jsp" %>  
