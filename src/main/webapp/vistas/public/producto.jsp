<%-- 
    Document   : producto
    Created on : 11 ago 2024, 16:24:09
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
         JsonArray imgs = obj.getJsonArray("imgs");
         String titulo = obj.getString("nombre");
         
%>

<%@include file="header.jsp" %>

<style>
    .mimg {
        width: 20vw;
        height: 20vw;
        object-fit: cover;
    }

    .mainimg{
        height: 90vw;
    }

    .dnon{
        display: block;
    }

    @media (min-width: 1280px) {

        .mimg {
            height: 7vw;
            width: 7vw;
            object-fit: cover;
        }
        .mainimg{
            height: 30vw;
        }
    }
</style>
<div
    class="osahan-page-header d-flex align-items-center justify-content-between mb-auto p-3 bg-white shadow-sm">
    <a href="/tienda" class="text-black"><span class="mdi mdi-arrow-left mdi-18px"></span></a>
    <h6 class="mb-0 ms-3 me-auto text-black fw-bold">Tienda</h6>
    <div class="d-flex align-items-center gap-3">
        <a href="#"
           class="toggle d-flex align-items-center justify-content-center bg-white icon fs-5 hc-nav-trigger hc-nav-1"
           role="button" aria-controls="hc-nav-1"><i class="bi bi-list mdi-18px"></i></a>
    </div>
</div>
<section>
    <div class="container pb-5">
        <div class="row">
            <div class="col-lg-5 mt-5">
                <div class="card mb-3">
                    <img class="card-img img-fluid mainimg" src="/imgs/prod/<% out.print(imgs.getString(0)); %>" alt="Card image cap" id="product-detail">
                </div>
                <div class="row">
                    <!--Start Controls-->
                    <div class="col-1 align-self-center">
                        <a href="#multi-item-example" role="button" data-bs-slide="prev">
                            <i class="text-dark fas fa-chevron-left"></i>
                            <span class="sr-only">Previous</span>
                        </a>
                    </div>
                    <!--End Controls-->
                    <!--Start Carousel Wrapper-->
                    <div id="multi-item-example" class="col-10 carousel slide carousel-multi-item pointer-event" data-bs-ride="carousel">
                        <!--Start Slides-->
                        <div class="carousel-inner product-links-wap" role="listbox">

                            <%
                                double loop_ = imgs.size() / 2;
                                int count_ = 1;
                                int second_ = 0;
                                int third_ = 3;
                                int k = 0;
                                if(loop_ > 1){
                                count_ = (int)loop_;
                                }
                                for(int j = 0; j < count_; j++){
                            %>

                            <div class="carousel-item <% out.print((j==0) ? "active" : ""); %>">
                                <div class="row">

                                    <%
                                for(k = second_; k < third_; k++){
                                System.out.println("k: " + k);
                                if(k > imgs.size()-1){continue;}
                                    %>

                                    <div class="col-4">
                                        <a href="#">
                                            <img class="card-img img-fluid mimg" src="/imgs/prod/<% out.print(imgs.getString(k)); %>" alt="Product Image 1">
                                        </a>
                                    </div>

                                    <% } %>

                                </div>
                            </div>

                            <%
                                second_ = k;
                                third_ = second_+3;
                                }
                            %>

                            <!--/.Third slide-->
                        </div>
                        <!--End Slides-->
                    </div>
                    <!--End Carousel Wrapper-->
                    <!--Start Controls-->
                    <div class="col-1 align-self-center">
                        <a href="#multi-item-example" role="button" data-bs-slide="next">
                            <i class="text-dark fas fa-chevron-right"></i>
                            <span class="sr-only">Next</span>
                        </a>
                    </div>
                    <!--End Controls-->
                </div>
            </div>
            <!-- col end -->
            <div class="col-lg-7 mt-5">
                <div class="card">
                    <div class="card-body p-4">
                        <h1 class="h2"><% out.println(obj.getString("nombre")); %></h1>
                        <input id="producto" type="hidden" value="<% out.print(obj.getString("id")); %>">
                        <input id="precio" type="hidden" value="<% out.print(obj.getString("precio")); %>">
                        <p class="h3 py-2"><i class="fa-solid fa-guarani-sign"></i> <% out.println(obj.getString("precio")); %></p>

                        <h6>Descripcion</h6>
                        <p><% out.println(obj.getString("descripcion")); %></p>
                        <ul class="list-inline">
                            <li class="list-inline-item">
                                <h6>Disponible : </h6>
                            </li>
                            <li class="list-inline-item">
                                <p class="text-muted"><strong id="stockk"><% out.println(obj.getString("stock")); %></strong></p>
                            </li>
                        </ul>

                        <div>
                            <input type="hidden" name="product-title" value="Activewear">
                            <div class="row">
                                <div class="col-auto">
                                    <ul class="list-inline pb-3">
                                        <li class="list-inline-item text-right">
                                            Cantidad
                                            <input type="hidden" name="product-quanity" id="cantidad" value="1">
                                        </li>
                                        <li onclick="menos()" class="list-inline-item"><span class="btn btn-primary" id="btn-minus">-</span></li>
                                        <li class="list-inline-item"><span class="badge bg-secondary" id="cantidad_">1</span></li>
                                        <li onclick="mas()" class="list-inline-item"><span class="btn btn-primary" id="btn-plus">+</span></li>
                                    </ul>
                                </div>
                            </div>
                            <div class="row pb-3">
                                <div class="col d-grid">
                                    <button onclick="agregarCarrito()" class="btn btn-primary btn-lg"><i class="fa-solid fa-cart-shopping"></i> Añadir al Carrito</button>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<script>

    function getCantidad() {
        $.ajax(
                {
                    url: "/carrito/cant",
                    success: function (response) {
                        if (response !== "0") {
                            $("#btncarrito").addClass("animate__animated");
                        }
                        $("#canti").html(response);
                    }
                }
        );
    }

    function mostrarMensaje(mensaje) {
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



    function agregarCarrito() {



        let prod = $("#producto").val().trim();
        let cantidad = $("#cantidad").val();
        let precio = $("#precio").val();

        $.ajax(
                {
                    data: {producto: prod, cantidad: cantidad, precio: precio},
                    url: "/carrito/add",
                    type: "post",
                    success: function (response) {
                        let res = JSON.parse(response);
                        mostrarMensaje(res);
                        getCantidad();
                    }
                }
        );
    }


    function mas() {
        let cant = $("#cantidad_").html().trim();
        let stock = $("#stockk").html().trim();
        stock = parseInt(stock);
        cant = parseInt(cant);
        cant = cant + 1;
        if (cant <= stock) {
            $("#cantidad").val(cant);
            $("#cantidad_").html(cant);
        }
    }

    function menos() {
        let cant = $("#cantidad_").html().trim();
        cant = parseInt(cant);
        if (cant > 1) {
            cant = cant - 1;
            $("#cantidad").val(cant);
            $("#cantidad_").html(cant);
        }

    }


    getCantidad();

</script>                            

<%@include file="footer.jsp" %>
