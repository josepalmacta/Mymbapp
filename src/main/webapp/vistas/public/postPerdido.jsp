<%-- 
    Document   : postPerdido
    Created on : 7 jul 2024, 16:30:32
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
         
         System.out.println(obj.toString());
         
         String titulo = "Mascota perdida en " + obj.getString("lugar");
         
%>

<%@include file="header.jsp" %>





<style>


    footer {
        position: fixed;
        bottom: 0;
        width: 100%;
    }

    .mapaa {
        width: 100%;
        height: 400px;
    }
    #map {
        width: 100%;
        height: 400px;
    }
    .lostdet{
        display: block;
    }
    .lostdet1{
        width: 100%;
    }
    .lostdet2{
        width: 100%;
        padding: 0px !important;
    }

    .info-item{
        margin-bottom: 25px;
    }

    .carousel-item{
        height: 50vh;
    }

    .carr-img{
        width: 100%;
        height: 100%;
        object-fit: cover;
    }






    @media (min-width: 1280px) {
        .lostlist {
            width: 20%;
            margin: 20px;
        }
        .carruContainer{
            max-width: 80%;
        }
        .lostdet{
            display: flex;
            justify-content: space-between;
        }
        .lostdet1{
            width: 65%;
        }
        .lostdet2{
            width: 30%;
            padding: 1rem !important;
        }
        .contenedor1{
            padding-left: 2rem;
            padding-right: 2rem;
        }
        .font1{
            font-size: large;
        }

        .centered-element {
            margin: 0;
            position: relative;
            top: 50%;
            transform: translateY(-50%);
        }

        .carousel-item{
            height: 70vh;
        }
    }







</style>

<div class="contenedor1">
    <div class="p-3">
        <div class="p-4">
            <div class="dbkfx align-items-center">
                <% if(obj.getString("p_estado").equals("LOCALIZADO")){ %>
                <div class="badge bg-success p-2 me-3"><span class="fs-5">LOCALIZADO</span></div>
                <% } %>
                <h1 class="card-title mb-0 fw-semibold">Se busca a <% out.println(obj.getString("nombres")); %> <small class="small fs-2 fw-normal">en <% out.println(obj.getString("lugar")); %></small></h1>
            </div>
        </div>

        <div>
            <div class="lostdet justify-content-between">
                <div class="lostdet1">
                    <div class="rounded-4 shadow p-3 mb-4">
                        <div class="card-body">
                            <div class="overflow-hidden rounded-3 mb-4">
                                <div id="carouselExampleIndicators" class="carousel slide">
                                    <div class="carousel-indicators">
                                        <%
                                Integer contad = 0;
                                for (int i = 0; i < obj.getJsonArray("mascotas").size(); i++) {
                                JsonObject masco = obj.getJsonArray("mascotas").getJsonObject(i);
                                
                                for (int j = 0; j < masco.getJsonArray("imgs").size(); j++) {
                                
                                    
                                        %>
                                        <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="<%out.print(contad);%>"
                                                <% if(contad == 0){ %> class="active" aria-current="true" <% } %> aria-label="<%out.print(masco.getString("nombre"));%>"></button>
                                        <% contad++; }}%>
                                    </div>
                                    <div class="carousel-inner">
                                        <%
                                contad = 0;
                                for (int i = 0; i < obj.getJsonArray("mascotas").size(); i++) {
                                JsonObject masco = obj.getJsonArray("mascotas").getJsonObject(i);
                                
                                for (int j = 0; j < masco.getJsonArray("imgs").size(); j++) {
                                    String act = "";
                                    if(contad == 0){
                                    act = " active";
                                            }
                                        %>



                                        <div class="carousel-item<%out.print(act);%>">
                                            <img class="carr-img" src="/imgs/posts/p/<% out.print(masco.getJsonArray("imgs").getString(j)); %>" class="d-block w-100" alt="...">
                                        </div>


                                        <% contad++; }} %>
                                    </div>
                                    <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleIndicators"
                                            data-bs-slide="prev">
                                        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                        <span class="visually-hidden">Previous</span>
                                    </button>
                                    <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleIndicators"
                                            data-bs-slide="next">
                                        <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                        <span class="visually-hidden">Next</span>
                                    </button>
                                </div>
                            </div>






                            <div class="breeder-dog-info p-3">
                                <h5 class="title">Detalles</h5>

                                <%
                                for (int i = 0; i < obj.getJsonArray("mascotas").size(); i++) {
                                JsonObject masco = obj.getJsonArray("mascotas").getJsonObject(i);
                                %>
                                <div class="row">
                                    <hr>
                                    <div class="col-md-3 col-sm-4 col-6">
                                        <div class="info-item">
                                            <h6>Nombre:</h6>
                                            <span><% out.println(masco.getString("nombre")); %></span>
                                        </div>
                                    </div>
                                    <div class="col-md-3 col-sm-4 col-6">
                                        <div class="info-item">
                                            <h6>Especie:</h6>
                                            <span><% out.println(masco.getString("especie")); %></span>
                                        </div>
                                    </div>
                                    <div class="col-md-3 col-sm-4 col-6">
                                        <div class="info-item">
                                            <h6>Raza:</h6>
                                            <span><% out.println(masco.getString("raza")); %></span>
                                        </div>
                                    </div>
                                    <div class="col-md-3 col-sm-4 col-6">
                                        <div class="info-item">
                                            <h6>Genero:</h6>
                                            <span><% out.println(masco.getString("genero")); %></span>
                                        </div>
                                    </div>
                                    <div class="col-12">
                                        <div class="info-item">
                                            <h6>Descripcion:</h6>
                                            <span><% out.println(masco.getString("descripcion")); %></span>
                                        </div>
                                    </div>
                                </div>

                                <% } %>

                            </div>




                            <div class="gap-1 py-4">


                                <h5 class="title">
                                    Informacion adicional
                                </h5>

                                <p>
                                    <% out.println(obj.getString("info")); %>
                                </p>                                    
                            </div>


                            <div class="gap-1 py-4">
                                <h5 class="title">
                                    Zona vista por ultima vez
                                </h5>
                                <div class="card">
                                    <div class="mapaa text-center">
                                        <div id="map"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="p-3 lostdet2">

                    <div class="card rounded-4 shadow p-3 mb-4 border-0">
                        <div class="card-body">
                            <div class="d-block align-items-center justify-content-between p-3">
                                <div class="d-flex align-items-center gap-3">
                                    <img class="img-fluid rounded-pill cw-50" src="/imgs/user/<% out.println(obj.getString("per_imagen")); %>">
                                    <div>
                                        <h6 class="text-dark mb-1 fw-bold"><% out.println(obj.getString("nombre")); %></h6>  
                                        <span class="text-secondary m-0 fs-7"><i class="fa-solid fa-location-dot text-primary mx-1"></i><% out.println(obj.getString("per_ciudad")); %></span>                                
                                    </div>
                                </div>
                                <div class="py-3 d-block">
                                    <h6 class="h7">Contactar</h6>
                                    <button onclick="openwa()" class="btn btn-success text-white text-decoration-none mt-2"><i class="fa-brands fa-whatsapp text-white fs-5"></i> Whatsapp</button>
                                    <button id="btncontact" onclick="showcont()" class="btn btn-primary text-decoration-none mt-2"><i class="fa-solid fa-mobile-screen text-white fs-5"></i> Mostrar contacto</button>
                                    <span class="d-block mt-2 d-none" id="contactar"><i class="fa-solid fa-mobile-screen text-primary fs-5"></i> <span id="numer" class="fs-5 text-primary"></span></span>
                                </div>
                            </div>
                        </div>

                        <div class="card-footer p-3 d-flex bg-body">
                            <iframe id="fbshare" width="80" height="20" style="border:none;overflow:hidden" scrolling="no" frameborder="0" allowfullscreen="true" allow="autoplay; clipboard-write; encrypted-media; picture-in-picture; web-share"></iframe>
                            <a id="washare" target="_blank" href="https://wa.me/?text=Mascota%20perdida%20en%20<% out.println(obj.getString("lugar")); %>%20" class="text-success text-decoration-none mx-4"><i class="fa-brands fa-square-whatsapp text-success fs-6"></i> Compartir</a>
                            <a class="twitter-share-button ms-2" href="https://twitter.com/intent/tweet?text=Hello%20world&url=https://google.com">Compartir</a>
                        </div>
                    </div>


                </div>
            </div>

        </div>
    </div>
</div>

<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
      integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=" crossorigin="" />

<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""></script>                                    

<script src="/src/vender/bootstrap/js/bootstrap.bundle.min.js" type="text/javascript"></script>

<script src="/src/vender/jquery/jquery.min.js" type="text/javascript"></script>


<script>
                                        let locat = [<% out.println(obj.getString("lat")); %>, <% out.println(obj.getString("lng")); %>];
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

                                        let circ = L.circle(locat, {radius: 1000}).addTo(map);

                                        $("#fbshare").attr('src', "https://www.facebook.com/plugins/share_button.php?href=" + location.href + "&layout&size&width=80&height=20&appId");
                                        $("#washare").attr('href', $("#washare").attr('href') + location.href);
</script>
<script>
    let hddn = "<% out.print(Base64.getEncoder().encodeToString(obj.getString("contacto").substring(1).getBytes())); %>";
    function openwa() {
        let waurl = "https://wa.me/595" + atob(hddn) + "?text=Hola!%20Tengo%20informacion%20sobre%20tu%20mascota.";
        window.open(waurl, '_blank').focus();
    }

    function showcont() {
        $("#btncontact").hide();
        $("#numer").html("0" + atob(hddn));
        $("#contactar").removeClass("d-none");
    }
</script>
<script>window.twttr = (function (d, s, id) {
        var js, fjs = d.getElementsByTagName(s)[0],
                t = window.twttr || {};
        if (d.getElementById(id))
            return t;
        js = d.createElement(s);
        js.id = id;
        js.src = "https://platform.twitter.com/widgets.js";
        fjs.parentNode.insertBefore(js, fjs);

        t._e = [];
        t.ready = function (f) {
            t._e.push(f);
        };

        return t;
    }(document, "script", "twitter-wjs"));</script>


<%@include file="footer.jsp" %>