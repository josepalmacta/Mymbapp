<%-- 
    Document   : index
    Created on : 16 jun 2024, 14:06:22
    Author     : Usuario
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <!-- Basic Page Info -->
        <meta charset="utf-8">
        <title>INGRESO AL SISTEMA</title>

        <!-- Site favicon -->
        <link rel="apple-touch-icon" sizes="180x180" href="resources/vendors/images/apple-touch-icon.png">
        <link rel="icon" type="image/png" sizes="32x32" href="resources/vendors/images/favicon-32x32.png">
        <link rel="icon" type="image/png" sizes="16x16" href="resources/vendors/images/favicon-16x16.png">

        <!-- Mobile Specific Metas -->
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">

        <!-- Google Font -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <!-- CSS -->
        <link rel="stylesheet" type="text/css" href="resources/vendors/styles/core.css">
        <link rel="stylesheet" type="text/css" href="resources/vendors/styles/icon-font.min.css">
        <link rel="stylesheet" type="text/css" href="resources/vendors/styles/style.css">

    </head>
    <body class="login-page">

        <div class="h-100 d-flex align-items-center flex-wrap justify-content-center">
            <div class="container">
                <div class="align-items-center">
                    <div>
                        <div class="login-box bg-white box-shadow border-radius-10">
                            <div class="login-title">
                                <h2 class="text-center text-primary">INGRESAR AL SISTEMA</h2>
                            </div>
                            <form id="loginform">	
                                <div class="input-group custom">
                                    <input maxlength="15" type="text"  name="user" class="form-control form-control-lg" placeholder="Usuario">
                                    <div class="input-group-append custom">
                                        <span class="input-group-text"><i class="icon-copy dw dw-user1"></i></span>
                                    </div>
                                </div>
                                <div class="input-group custom">
                                    <input maxlength="50" type="password" name="pass" class="form-control form-control-lg" placeholder="**********">
                                    <div class="input-group-append custom">
                                        <span class="input-group-text"><i class="dw dw-padlock1"></i></span>
                                    </div>
                                </div>
                           
                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="input-group mb-0">
                                            <!--
                                                    use code for form submit
                                                    <input class="btn btn-primary btn-lg btn-block" type="submit" value="Sign In">
                                            -->
                                            <input value="INGRESAR" type="button" onclick="login()" class="btn btn-primary btn-lg btn-block">
                                        </div>
                                        
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                </div>
            </div>
        </div>
        <!-- js -->
        <script src="resources/src/scripts/jquery-3.7.1.min.js"></script>
        <script src="resources/src/plugins/sweetalert2/sweetalert2.all.js"></script>
        <script src="resources/vendors/scripts/core.js"></script>
        <script src="resources/vendors/scripts/script.min.js"></script>
        <script src="resources/vendors/scripts/process.js"></script>
        <script src="resources/vendors/scripts/layout-settings.js"></script>


        <script>
            
            
            function mostrarMensaje(mensaje) {
                if(mensaje["success"]){
                    location.href= "/dashboard/inicio";
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
            
            
            
            function login() {
                let dataform = $("#loginform").serialize();
                $.ajax(
                        {
                            data:dataform,
                            url: "/session/login",
                            type: "post",
                            success: function (response) {
                                let res = JSON.parse(response);
                                mostrarMensaje(res);
                            }
                        }
                );
                
            }
        </script>
    </body>
</html>

