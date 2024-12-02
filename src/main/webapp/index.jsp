<%-- 
    Document   : index
    Created on : 16 jun 2024, 14:06:22
    Author     : Usuario
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="modelos.postPerdidos.*"%>
<%@page import="java.util.*"%>
<%@page import="jakarta.json.JsonValue"%>
<%@page import="jakarta.json.Json"%>
<%@page import="jakarta.json.JsonArray"%>
<%@page import="jakarta.json.JsonArrayBuilder"%>
<%@page import="jakarta.json.JsonObject"%>

<%@page import="javax.sql.DataSource"%>
<%@page import="java.sql.Connection"%>

<% String titulo = "Pagina Principal"; %>

<%@include file="vistas/public/header.jsp" %>
<style>
    footer {
        position: fixed;
        bottom: 0;
        width: 100%;
    }

    .mapaa {
        height: 400px;
    }

    .card img,
    .card-body img {
        width: 100%;
        height: 40vw;
        object-fit: cover;
    }

    .card-body {
        padding: 0px;
    }

    .shadow-cus {
        box-shadow: 0 .125rem .25rem rgba(var(--bs-body-color-rgb), .4) !important;
    }


    .badge {
        position: absolute;
        top: 2px;
        right: 2px;
        z-index: 1;

        padding: 5px 10px;

        font-size: 12px;
        font-weight: bold;
        text-transform: uppercase;
        color: white;
        background-color: #1b00ff;
    }

    #map {
        width: 100%;
        height: 400px;
    }

    .card-img{
        height: 60vw !important;
    }


    .overl{
        background-color:rgba(31,148,255,0.75);
        transition:opacity 0.30s ease-in-out;
        opacity:0.4;
        color:#fff;
        text-shadow:1px 1px 1px rgba(0,0,0,0.15);
    }

    .card-tt{
        transition:opacity 0.30s ease-in-out;
        opacity:1;
        color:#fff;
        text-shadow:1px 1px 1px rgba(0,0,0,0.15);
        position: absolute;
        bottom: 0;
        margin-bottom: 20px;
        font-size: xx-large;
    }


    .card:hover .overl {
        transition:opacity 0.30s ease-in-out;
        opacity:0;
    }

    .card:hover .card-tt {
        transition:opacity 0.30s ease-in-out;
        opacity:0;
    }

    .circular-div {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        display: flex;
        justify-content: center;
        align-items: center;
        overflow: hidden;
    }

    .div-whit {
        width: 85%;
        height: 85%;
        background-color: white;
        border-radius: 50%;
        overflow: hidden;
    }

    .div-whit img {
        width: 100% !important;
        height: 100% !important;
        object-fit: cover;
    }


    @media (min-width: 1280px) {
        .lostlist {
            width: 20vw;
            margin: 20px;
        }

        .card img {
            height: 20vw;
            object-fit: cover;
        }

        .card-img{
            height: 25vw !important;
        }
    }
</style>
<div>
    <div class="bg-primary text-white d-flex align-items-center justify-content-center ps-3 homepage-banner pb-5">
        <div class="py-4">
            <!-- comment <h3 class="card-title mb-2 fw-bold">Adopt, Love, Cherish ❤️</h3>
            <p class="card-text text-white-50">The Joy of Pet Adoption</p>
            <a class="btn btn-warning btn-sm rounded-pill px-3 py-2" href="favorite.html">Adopt Now! <span
                    class="mdi mdi-arrow-right"></span></a>-->
        </div>
        <!--<img class="img-fluid mt-auto w-220" src="img/banner.png">-->
    </div>
    <div class="p-3">
        <div class="bg-light rounded-4 shadow p-3 mb-4 position-relative homepage-cate">
            <div class="mapaa row text-center px-3">
                <div id="map"></div>
            </div>
        </div>


        <div class="py-5">
            <div class="d-flex align-items-center mb-3">
                <h5 class="fw-bold mb-0">Macotas Perdidas</h5>
                <div class="d-flex align-items-center ms-auto gap-3">
                    <a href="/perdidos" class="text-primary fw-semibold text-decoration-none">Mas publicaciones</a>
                    <span class="material-symbols-outlined text-primary">arrow_right_alt</span>
                </div>
            </div>
            <div class="row row-cols-2 row-cols-sm-2 row-cols-md-2 g-3">





                <%
                    DataSource dataSource = (DataSource) getServletContext().getAttribute("dataSource");
                    try(Connection connection = dataSource.getConnection()){
                    modelos.postPerdidos posts = new modelos.postPerdidos(connection);
                    modelos.postEncontrados posten = new modelos.postEncontrados(connection);
                    modelos.postAdopcion postadop = new modelos.postAdopcion(connection);
        
         JsonArray arr = posts.listarHome();
         JsonArray encon = posten.listarHome();
         JsonArray adop = postadop.listarHome();
         
         System.out.println(adop.toString());
         
         
         for (int i = 0; i < arr.size(); i++) {
            JsonObject obj = arr.getJsonObject(i);
                %>



                <div class="col lostlist">
                    <div class="card border-0 rounded-3 shadow overflow-hidden">
                        <% if(!obj.getString("recompensa").equals("0") && !obj.getString("estado").equals("LOCALIZADO")){ %>
                        <div class="badge">RECOMPENSA</div>
                        <% } %>
                        <% if(obj.getString("estado").equals("LOCALIZADO")){ %>
                        <div class="badge bg-success">LOCALIZADO</div>
                        <% } %>
                        <img src="/imgs/posts/p/<% out.print(obj.getString("img")); %>" class="hover-img card-img-top position-relative">
                        <div class="card-body p-2">
                            <h5 class="card-title mb-1 fw-bold h6"><% out.print(obj.getString("nombres")); %></h5>
                            <div class="my-2 gap-2">
                                <p class="d-flex align-items-center gap-1 my-2 text-secondary"><span
                                        class="mdi mdi-paw text-primary fs-6"></span> <% out.print(obj.getString("especie")); %></p>

                                <div class="d-flex">
                                    <div class="mt-2 me-1">
                                        <i class="fa-solid fa-location-dot text-primary fs-6"></i>
                                    </div>
                                    <div class="lugard">                                    
                                        <p class="d-flex align-items-center gap-1 my-2 text-secondary"><% out.print(obj.getString("lugar")); %></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <a class="stretched-link" href="/perdidos/post/<% out.print(obj.getString("postid")); %>"></a>
                    </div>
                </div>


                <% } %>

            </div>
        </div>


        <div class="py-5">
            <div class="d-flex align-items-center mb-3">
                <h5 class="fw-bold mb-0">Mascotas Encontradas</h5>
                <div class="d-flex align-items-center ms-auto gap-3">
                    <a href="/encontrados" class="text-primary fw-semibold text-decoration-none">Mas publicaciones</a>
                    <span class="material-symbols-outlined text-primary">arrow_right_alt</span>
                </div>
            </div>
            <div class="row row-cols-2 row-cols-sm-2 row-cols-md-2 g-3">

                <%
                    for (int i = 0; i < encon.size(); i++) {
            JsonObject obj = encon.getJsonObject(i);
                %>






                <div class="col lostlist">
                    <div class="card border-0 rounded-3 shadow overflow-hidden">
                        <div class="card-header text-body-secondary">
                            <i class="fa-regular fa-calendar-days me-1"></i> <% if(obj.getString("fecha").equals("0")){out.print("Hoy");}else if(obj.getString("fecha").equals("1")){out.print("Ayer");}else{out.print("Hace " + obj.getString("fecha") + " dias");} %>
                        </div>
                        <% if(obj.getString("estado").equals("LOCALIZADO")){ %>
                        <div class="badge badgeenc bg-success">LOCALIZADO</div>
                        <% } %>
                        <img src="/imgs/posts/e/<% out.print(obj.getString("img")); %>" class="hover-img position-relative">
                        <div class="card-body p-2">
                            <div class="my-2 gap-2">
                                <p class="d-flex align-items-center gap-1 my-2 text-secondary"><i class="fa-solid fa-location-dot text-primary fs-6"></i><strong> <% out.print(obj.getString("lugar")); %></strong></p>
                            </div>
                        </div>
                        <a class="stretched-link" href="/encontrados/post/<% out.print(obj.getString("postid")); %>"></a>
                    </div>
                </div>





                <% } %>

            </div>
        </div>






















        <div class="py-5">
            <div class="d-flex align-items-center mb-3">
                <h5 class="fw-bold mb-0">En Adopcion</h5>
                <div class="d-flex align-items-center ms-auto gap-3">
                    <a href="/encontrados" class="text-primary fw-semibold text-decoration-none">Mas publicaciones</a>
                    <span class="material-symbols-outlined text-primary">arrow_right_alt</span>
                </div>
            </div>
            <div class="row row-cols-2 row-cols-sm-2 row-cols-md-2 g-3">

                <%
                                    for (int i = 0; i < adop.size(); i++) {
                            JsonObject obj = adop.getJsonObject(i);
                %>




                <div class="col lostlist">
                    <div class="card border-0 rounded-3 shadow overflow-hidden">
                        <% if(obj.getString("estado").equals("ADOPTADO")){ %>
                        <div class="badge bg-danger"><span><i class="fa-regular fa-heart"></i> ADOPTADO</span></div>
                        <% } %>
                        <img src="/imgs/posts/a/<% out.print(obj.getString("img")); %>" class="hover-img position-relative">
                        <div class="card-body p-2">
                            <div class="my-2 gap-2">
                                <p class="d-flex align-items-center gap-1 my-2 text-secondary"><i class="fa-solid fa-paw text-primary fs-6"></i> <% out.print(obj.getString("especie")); %></p>
                                <p class="d-flex align-items-center gap-1 my-2 text-secondary"><i class="fa-solid fa-venus-mars text-primary fs-6"></i> <% out.print(obj.getString("genero")); %></p>
                            </div>
                        </div>
                        <a class="stretched-link" href="/adopcion/post/<% out.print(obj.getString("postid")); %>"></a>
                    </div>
                </div>

                <% } %>

            </div>
        </div>













    </div>
</div>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg==" crossorigin="anonymous" referrerpolicy="no-referrer" />                

<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
      integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=" crossorigin="" />

<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""></script>                              

<script src="/src/vender/bootstrap/js/bootstrap.bundle.min.js" type="text/javascript"></script>

<script src="/src/vender/jquery/jquery.min.js" type="text/javascript"></script>


<script src="https://unpkg.com/leaflet-control-geocoder/dist/Control.Geocoder.js"></script>

<script>

    var markers = [];
    var arr = [];
    var barrio;
    var popups = [];

    const geocoder = L.Control.Geocoder.nominatim();


    function initMap(locat) {
        let mapOptions = {
            center: locat,
            zoom: 12
        };

        map = new L.map('map', mapOptions);

        let layer = new L.TileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
            minZoom: 12
        });
        map.addLayer(layer);









        map.on('moveend', (event) => {

            geoCoded();

        });


        geoCoded();







        /*map.on('click', (event) => {
         
         if (marker !== null) {
         map.removeLayer(marker);
         }
         
         marker = L.marker([event.latlng.lat, event.latlng.lng]).addTo(map);
         
         document.getElementById('latitude').value = event.latlng.lat;
         document.getElementById('longitude').value = event.latlng.lng;
         
         });*/

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


    function addMarkers(arr) {
        console.log(arr);
        for (var i = 0; i < arr.length; i++) {
            let bg = (arr[i]["tipo"] === "perdidos") ? "bg-primary" : "bg-warning";
            markers[i] = L.marker([parseFloat(arr[i]["lat"]), parseFloat(arr[i]["long"])], {title: arr[i]["nombres"], imgg: arr[i]["img"], nomb: arr[i]["nombres"], postid: arr[i]["postid"], tipo: arr[i]["tipo"], icon: L.divIcon({className: "circular-div", html: "<div class='circular-div " + bg + "'><div class='div-whit'><img src='" + arr[i]["img"] + "' alt='Descripción de la imagen'></div></div>", iconSize: [40, 40], iconAnchor: [15, 42]})});
            markers[i].addTo(map);
        }
        let idx = 0;
        map.eachLayer(function (layer) {
            if (layer instanceof L.Marker) {
                layer.on('click', (event) => {
                    popups[i] = L.popup()
                            .setLatLng(layer.getLatLng())
                            .setContent(mostrarVentan(layer.options));
                    popups[i].openOn(map);
                });
                idx++;
            }
        });
    }


    function mostrarVentan(tipo) {
        let containr = "<div class='d-block'><child><a class='d-block my-3 btn btn-primary text-warning text-decoration-none border-radius-100 btn-block confirmation-btn' href='/" + tipo["tipo"] + "/post/" + tipo["postid"] + "'><i class='fa-solid fa-file-invoice'></i><strong class='ms-2'>VER POST</strong></a></div>";
        let contendo = "<span class='lead'><strong>" + tipo["nomb"] + "</strong></span>";
        if (tipo["tipo"] === "perdidos") {
            contendo = "<span class='lead'>Se busca a <strong>" + tipo["nomb"] + "</strong></span>";

        }
        return containr.replace("<child>", contendo);
    }



    function geoCoded() {
        geocoder.reverse(map.getCenter(), map.options.crs.scale(map.getZoom()), results => {
            var r = results[0];
            let barr = r.name.split(",");
            let idx = 0;
            if (barr.length > 4) {
                idx = 1;
            }
            if (barr[idx] !== barrio) {
                barrio = barr[idx];
                getMapa(barrio);
            }

        });
    }

    function getMapa(ciu) {


        $.ajax({
            url: "/api/buscar/mapa",
            data: {ciudad: ciu},
            type: "POST",
            crossDomain: true,
            success: function (json) {
                markers.forEach((mrkr) => {
                    map.removeLayer(mrkr);
                });
                markers = [];
                popups = [];
                addMarkers(JSON.parse(json));
            },
            error: function (e) {
                console.log(e);
            }
        });
    }

    getLoc();
</script>

<% } %>
<%@include file="vistas/public/footer.jsp" %>  