<%-- 
    Document   : register
    Created on : 10 jul 2024, 12:12:59
    Author     : Usuario
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>


<% String titulo = "Registro"; %>
<%@include file="header.jsp" %>  
<div class="contain">
    <div class="p-3">
        <form>
            <div class="d-flex gap-1 align-items-center pt-3">
                <h3 class="fw-bold text-dark mb-0">CREA UNA CUENTA EN PATITAS PERDIDAS</h3>
            </div>
            <div class="mb-3 mt-5">
                <label class="form-label">Nombre</label>
                <div class="input-group flex-nowrap">
                    <span class="input-group-text"><i class="fa-solid fa-user text-primary"></i></span>
                    <input maxlength="20" id="nombre" type="text" class="form-control bg-light px-3 py-2" placeholder="Juan Perez..." required>
                </div>
            </div>
            <div class="mb-3 mt-3">
                <label class="form-label">Email</label>
                <div class="input-group flex-nowrap">
                    <span class="input-group-text"><i class="fa-solid fa-at text-primary"></i></span>
                    <input maxlength="50" id="email" type="email" class="form-control bg-light px-3 py-2" placeholder="e-mail" required>
                </div>
            </div>
            <div class="mb-2 mt-3">
                <label class="form-label">Contraseña</label>
                <div class="input-group flex-nowrap">
                    <span class="input-group-text"><i class="fa-solid fa-key text-primary"></i></span>
                    <input maxlength="50" id="clave" type="password" class="form-control bg-light px-3 py-2" placeholder="Contraseña" required>
                </div>
            </div>
            <div class="mb-2 mt-3">
                <label class="form-label">Departamento</label>
                <div class="input-group flex-nowrap">
                    <span class="input-group-text"><i class="fa-solid fa-city text-primary"></i></span>
                    <select id="departamentos" class="form-select">
                    </select>
                </div>
            </div>
            <div class="mb-2 mt-3">
                <label class="form-label">Ciudad</label>
                <div class="input-group flex-nowrap">
                    <span class="input-group-text"><i class="fa-solid fa-tree-city text-primary"></i></span>
                    <select id="ciudades" class="form-select">
                    </select>
                </div>
            </div>
            <div class="mb-2 mt-3">
                <label class="form-label">Barrio</label>
                <div class="input-group flex-nowrap">
                    <span class="input-group-text"><i class="fa-solid fa-building text-primary"></i></span>
                    <select id="barrios" class="form-select">
                    </select>
                </div>
            </div>
        </form>
    </div>
    <div class="px-5 mt-3">
        <input onclick="sendData()" type="button" value="Crear cuenta" class="btn btn-primary rounded-pill w-100 btn-lg">
    </div>

</div>


<script src="/src/vender/bootstrap/js/bootstrap.bundle.min.js" type="text/javascript"></script>

<script src="/src/vender/jquery/jquery.min.js" type="text/javascript"></script>

<script src="/resources/src/plugins/sweetalert2/sweetalert2.all.js"></script>

<script>


            function mostrarMensaje(mensaje) {
                
                if (mensaje["success"]) {
                    setTimeout(() => {
                        location.href = "/";
                    }, "1500");
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


            function sendData() {

                if (!valido()) {
                    mostrarMensaje({"estado": "warning", "mensaje": "COMPLETE TODOS CAMPOS!"});
                    return;
                }
                
                if(!validar()){
                    return;
                }

                $('#form-modal').modal('hide');

                let nombre = $("#nombre").val().trim();
                let clave = $("#clave").val();
                let email = $("#email").val();
                let ciudad = $("#ciudades").val();
                let departamento = $("#departamentos").val();
                let barrio = $("#barrios").val();

                $.ajax(
                        {
                            data: {nombre: nombre, clave: clave, email: email, departamento: departamento, ciudad: ciudad, barrio: barrio},
                            url: "/registro",
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
                if ($("#clave").val().trim() === "") {
                    return false;
                }
                if ($("#email").val().trim() === "") {
                    return false;
                }
                return true;
            }
            
            
            
            function validar() {
                if ($("#nombre").val().trim().length < 3) {
                    mostrarMensaje({"estado": "warning", "mensaje": "INGRESE UN NOMBRE VALIDO"});
                    return false;
                }
                if ($("#clave").val().trim().length < 8) {
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



            function cargarDep() {
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
                                cargarCiu($("#departamentos").val(), "0");
                                //$("#departamentos").val("4");
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
                                cargarBarr($("#ciudades").val(), "0");

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

            cargarDep();
</script>
<%@include file="footer.jsp" %>  