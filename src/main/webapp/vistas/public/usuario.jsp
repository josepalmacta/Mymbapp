<%-- 
    Document   : usuario
    Created on : 14 sept 2024, 8:34:51
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
    System.out.println(obj);
    String titulo = "Mi Cuenta";
%>
<style>

    .wdt-75{
        max-width: 90vw;
        width: 90vw;
        padding-left: 5px;
    }
    .mhw-100{
        width: 50vw;
        height: 50vw;
    }
    @media (min-width: 1280px) {
        .wdt-75{
            max-width: 75vw;
            width: 75vw;
            padding-left: 3rem;
        }
        .mhw-100{
            width: 30vw;
            height: 30vw;
        }
    }
</style>
<%@include file="header.jsp" %>
<div class="osahan-page-body vh-100 my-auto p-3">
    <h4 class="py-3 border-bottom">Informacion de la cuenta</h4>
    <div class="wdt-75 bg-white mt-sm-5">
        <div class="align-items-start pb-3 border-bottom">
            <img class="img mhw-100 border" id="imgperfil" style="object-fit: cover !important;" src="/imgs/user/<% out.print(obj.getString("imagen")); %>">
            <div class="pl-sm-4 pl-2" id="img-section">
                <b>Imagen de Perfil</b>
                <input onchange="read(this)" id="file-input" type="file" accept="image/*" name="name" style="display: none;" />
                <input type="hidden" id="nimg" name="nimg" value="default">
                <p></p>
                <button id="imgch" class="btn button btn-warning"><b><i class="fa-regular fa-image"></i> Cambiar imagen</b></button>
            </div>
        </div>
        <div  class="py-2 mw-100">
            <div class="row py-2">
                <div class="col-md-6">
                    <label for="nombre">Nombre</label>
                    <div class="input-group d-flex flex-nowrap">
                        <span class="input-group-text"><i class="fa-solid fa-user text-primary"></i></span>
                        <input name="nombre" id="nombre" type="text" class="form-control" value="<% out.print(obj.getString("nombre")); %>">
                    </div>
                </div>
                <div class="col-md-6 pt-md-0 pt-3">
                    <label for="email">Email</label>
                    <div class="input-group d-flex flex-nowrap">
                        <span class="input-group-text"><i class="fa-solid fa-at text-primary"></i></span>
                        <input name="email" id="email" type="email" class="form-control" value="<% out.print(obj.getString("email")); %>">
                    </div>
                </div>                
            </div>

            <div class="row py-2">
                <div class="col-md-4">
                    <label for="departamentos">Departamento</label>
                    <div class="input-group d-flex flex-nowrap">
                        <span class="input-group-text"><i class="fa-solid fa-city text-primary"></i></span>
                        <select name="departamento" id="departamentos" class="form-select">
                        </select>
                    </div>
                </div>
                <div class="col-md-4 pt-md-0 pt-3" id="lang">
                    <label for="ciudades">Ciudad</label>
                    <div class="arrow">
                        <div class="input-group d-flex flex-nowrap">
                            <span class="input-group-text"><i class="fa-solid fa-tree-city text-primary"></i></span>
                            <select name="ciudad" id="ciudades" class="form-select">
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 pt-md-0 pt-3" id="lang">
                    <label for="barrios">Barrio</label>
                    <div class="arrow">
                        <div class="input-group d-flex flex-nowrap">
                            <span class="input-group-text"><i class="fa-solid fa-building text-primary"></i></span>
                            <select name="barrio" id="barrios" class="form-select">
                            </select>
                        </div>
                    </div>
                </div>
            </div>


            <div class="py-3 pb-4">
                <button onclick="sendData()" class="btn btn-primary mr-3"><i class="fa-solid fa-floppy-disk"></i> Guardar cambios</button>
            </div>
            <div class="align-items-center pt-3 mt-5" id="deactivate">
                <h5 class="py-3 border-bottom">Cambiar contraseña</h5>
                <div class="row py-2 mw-100">
                    <div class="col-md-6 pt-md-0 pt-3">
                        <label for="passwn">Contraseña Nueva</label>
                        <div class="input-group d-flex flex-nowrap">
                            <span class="input-group-text"><i class="fa-solid fa-lock text-primary"></i></span>
                            <input name="passwn" id="passwn" type="password" class="form-control">
                        </div>
                    </div>
                    <div class="col-md-6 pt-md-0 pt-3">
                        <label for="passwo">Ingrese su contraseña actual</label>
                        <div class="input-group d-flex flex-nowrap">
                            <span class="input-group-text"><i class="fa-solid fa-key text-primary"></i></span>
                            <input name="passwo" id="passwo" type="password" class="form-control">
                        </div>
                    </div>
                </div>
                <div class="py-3 pb-4">
                    <button onclick="sendPassw()" class="btn btn-primary mr-3"><i class="fa-solid fa-key"></i> Cambiar contraseña</button>
                </div>
            </div>
            <!--<div class="d-sm-flex align-items-center pt-3" id="deactivate">
                <div>
                    <b>Deactivate your account</b>
                    <p>Details about your company account and password</p>
                </div>
                <div class="ml-auto">
                    <button class="btn danger">Deactivate</button>
                </div>
            </div>-->
        </div>
    </div>
</div>

<script src="/src/vender/bootstrap/js/bootstrap.bundle.min.js" type="text/javascript"></script>

<script src="/src/vender/jquery/jquery.min.js" type="text/javascript"></script>

<script src="/resources/src/plugins/sweetalert2/sweetalert2.all.js"></script>

<script>

                        var barrr = "<% out.print(obj.getString("idbarrio")); %>";

                        function read(val) {
                            const reader = new FileReader();
                            reader.onload = (event) => {
                                $("#imgperfil").attr('src', event.target.result);
                                $("#nimg").val(event.target.result);
                            }
                            reader.readAsDataURL(val.files[0]);

                        }


                        $('#imgch').on('click', function () {
                            $('#file-input').trigger('click');
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
                            setTimeout(() => {
                                location.reload();
                            }, "1000");

                        }


                        function sendData() {

                            if (!valido()) {
                                mostrarMensaje({"estado": "warning", "mensaje": "COMPLETE TODOS CAMPOS!"});
                                return;
                            }
                            
                            if(!validar()){
                                return;
                            }

                            let nombre = $("#nombre").val();
                            let email = $("#email").val();
                            let ciudad = $("#ciudades").val();
                            let departamento = $("#departamentos").val();
                            let barrio = $("#barrios").val();
                            let img = $("#nimg").val();

                            $.ajax(
                                    {
                                        data: {nombre: nombre, email: email, departamento: departamento, ciudad: ciudad, barrio: barrio, img: img},
                                        url: "/usuario/edit",
                                        type: "post",
                                        success: function (response) {
                                            let res = JSON.parse(response);
                                            mostrarMensaje(res);
                                        }
                                    }
                            );
                        }


                        function sendPassw() {

                            if (!validoP()) {
                                mostrarMensaje({"estado": "warning", "mensaje": "COMPLETE LOS CAMPOS NECESARIOS!"});
                                return;
                            }
                            
                            if(!validar()){
                                return;
                            }

                            let npassw = $("#passwn").val();
                            let opassw = $("#passwo").val();

                            $.ajax(
                                    {
                                        data: {npassw: npassw, opassw: opassw},
                                        url: "/usuario/chpassw",
                                        type: "post",
                                        success: function (response) {
                                            let res = JSON.parse(response);
                                            mostrarMensaje(res);
                                        }
                                    }
                            );
                        }



                        function valido() {
                            if ($("#nombre").val().trim() === "") {
                                return false;
                            }
                            if ($("#email").val().trim() === "") {
                                return false;
                            }
                            return true;
                        }

                        function validoP() {
                            if ($("#passwo").val().trim() === "") {
                                return false;
                            }
                            if ($("#passwn").val().trim() === "") {
                                return false;
                            }
                            return true;
                        }

                        function validar() {
                            if ($("#passwn").val().trim().length < 8) {
                                mostrarMensaje({"estado": "warning", "mensaje": "LA CONTRASEÑA DEBE SER DE POR LO MENOS 8 CARACTERES"});
                                return false;
                            }
                            const re = /^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/g;
                            if (!re.test($("#email").val().trim())) {
                                mostrarMensaje({"estado": "warning", "mensaje": "INGRESE UN E-MAIL VALIDO"});
                                return false;
                            }
                            return true;
                        }



                        function cargarDep(idd) {
                            $.ajax(
                                    {
                                        url: "/api/buscar/departamentos",
                                        data: {opt: "list"},
                                        type: "post",
                                        success: function (response) {
                                            console.log(response);
                                            let res = JSON.parse(response);
                                            res.forEach(function (obj) {
                                                let op = document.createElement("option");
                                                op.value = obj["id"];
                                                op.innerHTML = obj["nombre"];
                                                $("#departamentos").append(op);
                                            });
                                            $("#departamentos").val(idd);
                                            cargarCiu(idd,<% out.print(obj.getString("idciudad")); %>);

                                        }
                                    }
                            );
                        }

                        function cargarCiu(idd, ciu) {
                            $.ajax(
                                    {
                                        url: "/api/buscar/ciudades",
                                        data: {opt: "depar", departamento: idd},
                                        type: "post",
                                        success: function (response) {
                                            console.log(response);
                                            let res = JSON.parse(response);
                                            $("#ciudades").html("");
                                            res.forEach(function (obj) {
                                                let op = document.createElement("option");
                                                op.value = obj["id"];
                                                op.innerHTML = obj["nombre"];
                                                $("#ciudades").append(op);
                                            });

                                            if (ciu != "0") {
                                                $("#ciudades").val(ciu);
                                            }
                                            console.log("idciu->" + $("#ciudades").val());
                                            cargarBarr($("#ciudades").val(), barrr);
                                            barrr = "0";
                                        }
                                    }
                            );
                        }


                        function cargarBarr(idd, barr) {
                            $.ajax(
                                    {
                                        url: "/api/buscar/barrios",
                                        data: {opt: "ciu", ciudad: idd},
                                        type: "post",
                                        success: function (response) {
                                            console.log(response);
                                            let res = JSON.parse(response);
                                            $("#barrios").html("");
                                            res.forEach(function (obj) {
                                                let op = document.createElement("option");
                                                op.value = obj["id"];
                                                op.innerHTML = obj["nombre"];
                                                $("#barrios").append(op);
                                            });

                                            if (barr != "0") {
                                                $("#barrios").val(barr);
                                            }



                                        }
                                    }
                            );
                        }



                        $('#departamentos').on('change', function (e) {
                            cargarCiu(this.options[this.selectedIndex].value, "0");
                        });

                        $('#ciudades').on('change', function (e) {
                            cargarBarr(this.options[this.selectedIndex].value, "0");
                        });

                        cargarDep(<% out.print(obj.getString("iddep")); %>);
</script>



<%@include file="footer.jsp" %>