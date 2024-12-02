<%-- 
    Document   : login
    Created on : 12 jul 2024, 17:51:22
    Author     : Usuario
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>


<% String titulo = "Iniciar Sesion"; %>
<%@include file="header.jsp" %>  
<div class="contain">
    <div class="p-3">
        <form>
            <div class="d-flex gap-1 align-items-center pt-3">
                <h3 class="fw-bold text-dark mb-0">INICIAR SESION</h3>
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
            <div class="form-check align-items-center mb-2 d-flex justify-content-between">
                <div>
                    <a href="/login/recuperacion" class="text-primary fs-6 text-decoration-none">Olvide mi contraseña</a>
                </div>
            </div>
        </form>
    </div>
    <div class="px-5 mt-3">
        <input onclick="sendData()" type="button" value="Iniciar Sesion" class="btn btn-primary rounded-pill w-100 btn-lg">
    </div>
    <hr>
    <div class="px-5 mt-3">
        <a href="/registro" class="btn btn-secondary rounded-pill w-100 btn-lg">Registrarse</a>
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
                    }, "1000");
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


            function sendData() {

                if (!valido()) {
                    mostrarMensaje({"estado": "warning", "mensaje": "COMPLETE TODOS CAMPOS!"});
                    return;
                }
                
                if (!validar()) {                    
                    return;
                }

                $('#form-modal').modal('hide');
                let clave = $("#clave").val();
                let email = $("#email").val();

                $.ajax(
                        {
                            data: {clave: clave, email: email},
                            url: "/sesion/login",
                            type: "post",
                            success: function (response) {
                                let res = JSON.parse(response);
                                mostrarMensaje(res);
                            }
                        }
                );
            }



            function valido() {
                if ($("#clave").val().trim() === "") {
                    return false;
                }
                if ($("#email").val().trim() === "") {
                    return false;
                }
                return true;
            }
            
            
            function validar() {
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
</script>
<%@include file="footer.jsp" %>  
