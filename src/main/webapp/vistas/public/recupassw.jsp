<%-- 
    Document   : confregistro
    Created on : 15 oct 2024, 15:20:43
    Author     : Usuario
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>


<% String titulo = "Registro"; %>
<%@include file="header.jsp" %>




<div class="contain">
    <div id="confirmacion" class="contain-h d-flex gap-1 align-items-center justify-content-center text-center pt-3">
        <div  class="p-3">
            <div class="align-items-center pt-3">

                <% 
                    String tipo = (String)request.getAttribute("tipo");
    
                    if(tipo.equals("codxok")){
                    String rcode = (String)request.getAttribute("rcode");
    
                %>

                <h3 class="fw-bold text-dark mb-0">Reestablecer contraseña</h3>
                <p class="fs-6 mt-3">Ingrese su nueva contraseña</p>
                <div class="mt-4 d-flex w-100 flex-wrap gap-3 justify-content-center">
                    <div class="input-group flex-nowrap">
                        <span class="input-group-text"><i class="fa-solid fa-key text-primary"></i></span>
                        <input id="nclave" type="password" class="form-control bg-light px-3 py-2" placeholder="Contraseña" required>
                        <input type="hidden" id="rcode" value="<% out.print(rcode); %>">
                    </div>
                    <button class="btn btn-primary" onclick="resetPassw()">Cambiar contraseña</button>
                </div>


                <% } else if(tipo.equals("errorcodx")) { %>

                <h3 class="fw-bold text-dark mb-0">El enlace no es valido.</h3>
                <p class="fs-6 mt-3">Puede que el enlace ya haya sido utilizado o haya expirado. Puedes solicitar que te enviemos otro.</p>
                <div class="mt-4 d-flex w-100 flex-wrap gap-3 justify-content-center">
                    <a href="/login/recuperacion" class="btn btn-secondary">Reestablecer contraseña</a>
                    <a href="/login" class="btn btn-primary">Iniciar Sesion</a>
                </div>

                <% } else if(tipo.equals("emailform")) { %>


                <div id="formulario">
                    <h3 class="fw-bold text-dark mb-0">Solicitar reestablecimiento de contraseña</h3>
                    <p class="fs-6 mt-3">Ingrese la direccion de email asociada a su cuenta.</p>
                    <div class="mt-4 d-flex w-100 flex-wrap gap-3 justify-content-center">
                        <div class="input-group flex-nowrap">
                            <span class="input-group-text"><i class="fa-solid fa-at text-primary"></i></span>
                            <input id="email" type="email" class="form-control bg-light px-3 py-2" placeholder="e-mail" required>
                        </div>
                        <button class="btn btn-primary" onclick="sendData()">Enviar</button>
                    </div>
                </div>

                <div id="enviado" class="d-none">
                    <h3 class="fw-bold text-dark mb-0">Enlace de reestablecimiento de contraseña enviado</h3>
                    <p class="fs-6 mt-3">Enviamos un correo a <strong id="emailconf"></strong></p>
                    <p class="fs-6">Si no encuentras el mensaje en tu bandeja de correo revisa la seccion <strong>Correo no deseado</strong> o <strong>Spam</strong></p>
                    <p class="fs-6">Si no recibiste el correo de reestablecimiento puedes solicitar que te enviemos otro.</p>
                    <div class="mt-4 d-flex w-100 flex-wrap gap-3 justify-content-center">
                        <a href="/login/recuperacion" class="btn btn-secondary">Reestablecer contraseña</a>
                        <a href="/login" class="btn btn-primary">Iniciar Sesion</a>
                    </div>
                </div>

                <% } %>
            </div>
        </div>
    </div>

</div>


<script src="/src/vender/bootstrap/js/bootstrap.bundle.min.js" type="text/javascript"></script>

<script src="/src/vender/jquery/jquery.min.js" type="text/javascript"></script>

<script src="/resources/src/plugins/sweetalert2/sweetalert2.all.js"></script>


<script>


                            function mostrarMensaje(mensaje) {
                                if (mensaje["success"]) {
                                    $("#emailconf").html($("#email").val());
                                    $("#formulario").addClass("d-none");
                                    $("#enviado").removeClass("d-none");
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


                            function resetMensaje(mensaje) {

                                swal(
                                        {
                                            type: mensaje["estado"],
                                            position: 'center',
                                            title: mensaje["mensaje"],
                                            showConfirmButton: false,
                                            timer: 3500
                                        }
                                );

                                if (mensaje["success"]) {
                                    location.href = "/login";
                                    return;
                                }


                            }


                            function sendData() {

                                if (!valido()) {
                                    mostrarMensaje({"estado": "warning", "mensaje": "INGRESE SU EMAIL!"});
                                    return;
                                }

                                let email = $("#email").val();

                                $.ajax(
                                        {
                                            data: {email: email},
                                            url: "/login/recuperacion",
                                            type: "post",
                                            success: function (response) {
                                                let res = JSON.parse(response);
                                                mostrarMensaje(res);
                                            }
                                        }
                                );
                            }



                            function resetPassw() {

                                if ($("#nclave").val().trim() === "") {
                                    mostrarMensaje({"estado": "warning", "mensaje": "INGRESE SU NUEVA CONTRASEÑA!"});
                                    return;
                                }

                                let passw = $("#nclave").val();
                                let rcode = $("#rcode").val();

                                $.ajax(
                                        {
                                            data: {clave: passw, codigo: rcode},
                                            url: "/login/reset",
                                            type: "post",
                                            success: function (response) {
                                                let res = JSON.parse(response);
                                                resetMensaje(res);
                                            }
                                        }
                                );
                            }



                            function valido() {
                                if ($("#email").val().trim() === "") {
                                    return false;
                                }
                                return true;
                            }
</script>

<%@include file="footer.jsp" %>  
