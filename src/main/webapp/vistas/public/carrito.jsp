<%-- 
    Document   : carrito
    Created on : 11 ago 2024, 19:18:25
    Author     : Usuario
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="jakarta.json.JsonValue"%>
<%@page import="jakarta.json.Json"%>
<%@page import="jakarta.json.JsonArray"%>
<%@page import="jakarta.json.JsonArrayBuilder"%>
<%@page import="jakarta.json.JsonObject"%>



<% String titulo = "Mi carrito de Compras"; %>
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

<section class="p-3 py-5">
    <div class="container h-100">
        <div id="carrito" class="row d-flex justify-content-center align-items-center h-100">

        </div>
    </div>
</section>
<link rel="stylesheet" href="/src/vender/wizard/easyWizard.css">
<script src="/src/vender/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/src/vender/bootstrap/js/bootstrap.bundle.min.js" type="text/javascript"></script> 
<script src="/src/vender/wizard/easyWizard.js" type="text/javascript"></script>
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
      integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=" crossorigin="" />

<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""></script>
<script>

    $(document).ready(function () {

        cargarCarrito();
    });


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


    function cargarCarrito() {

        $.ajax(
                {
                    url: "/carrito/list",
                    success: function (response) {
                        $("#carrito").html(response);
                    }
                }
        );
    }



    function eliminar(prod) {

        $.ajax(
                {
                    data: {prod: prod},
                    url: "/carrito/del",
                    type: "post",
                    success: function (response) {
                        cargarCarrito();
                    }
                }
        );
    }


    function cancelar() {

        let codigo = $("#venta").val();

        $.ajax(
                {
                    data: {codigo: codigo},
                    url: "/carrito/cancel",
                    type: "post",
                    success: function (response) {
                        let res = JSON.parse(response);
                        mostrarMensaje(res);
                        cargarCarrito();
                    }
                }
        );
    }



    function finalizar() {

        let lat = marker.getLatLng()["lat"].toString();
        let lng = marker.getLatLng()["lng"].toString();

        $('#form-modal').modal('hide');

        let nombre = $("#nombre").val().trim();
        let ruc = $("#ruc").val();
        let telefono = $("#telefono").val();
        let email = $("#email").val();
        let direccion = $("#direccion").val();
        let codigo = $("#venta").val();

        const metodoS = $('input[name="metodo"]:checked').val();

        $.ajax(
                {
                    data: {codigo: metodoS, nombre: nombre, ruc: ruc, telefono: telefono, direccion: direccion, email: email, lat: lat, lng: lng},
                    url: "/carrito/pagar",
                    type: "post",
                    success: function (response) {
                        let res = JSON.parse(response);
                        if (res["success"]) {
                            location.href = res["mensaje"];
                        }
                    }
                }
        );
    }



    function validarFact() {
        if ($("#nombre").val().trim() === "" || $("#ruc").val().trim() === "" || $("#telefono").val().trim() === "" || $("#email").val().trim() === "" || $("#direccion").val().trim() === "") {
            mostrarMensaje({"success": false, "estado": "warning", "mensaje": "Complete los campos obligatorios."});
            return false;
        }
        return validar();
    }

    function validar() {
        if ($("#nombre").val().trim().length < 4) {
            mostrarMensaje({"estado": "warning", "mensaje": "INGRESE UN NOMBRE VALIDO"});
            return false;
        }
        if ($("#direccion").val().trim().length < 5) {
            mostrarMensaje({"estado": "warning", "mensaje": "INGRESE UNA DIRECCION VALIDA"});
            return false;
        }
        const re = /^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/g;
        if (!re.test($("#email").val().trim())) {
            mostrarMensaje({"estado": "warning", "mensaje": "INGRESE UN E-MAIL VALIDO"});
            return false;
        }
        const re_tel = /^09[6-9][1-6][0-9]{6}$/g;
        if (!re_tel.test($("#telefono").val().trim())) {
            mostrarMensaje({"estado": "warning", "mensaje": "INGRESE UN TELEFONO VALIDO"});
            return false;
        }
        const re_ruc = /^[0-9]{7,8}\-[0-9]{1}$/g;
        const re_ruc_2 = /^[0-9]{6,7}$/g;
        if (!re_ruc.test($("#ruc").val().trim()) && !re_ruc_2.test($("#ruc").val().trim())) {
            mostrarMensaje({"estado": "warning", "mensaje": "INGRESE UN RUC o CI VALIDO"});
            return false;
        }
        return true;
    }





</script>


<%@include file="footer.jsp" %>
