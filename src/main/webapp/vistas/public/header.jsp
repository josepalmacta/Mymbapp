<%-- 
    Document   : header
    Created on : 11 jun 2024, 13:51:03
    Author     : Usuario
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

    <!-- Mirrored from askbootstrap.com/preview/adopet/home.html by HTTrack Website Copier/3.x [XR&CO'2014], Sun, 28 Apr 2024 17:27:07 GMT -->

    <head>

        <%
            HttpSession sesion = request.getSession();
        %>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="icon" href="/src/imgs/logo1.png" type="image/png">
        <title><% out.print(titulo); %></title>

        <link rel="stylesheet" href="/src/vender/bootstrap/css/bootstrap.min.css">

        <link rel="stylesheet" href="/src/cdn.jsdelivr.net/npm/bootstrap-icons%401.10.3/font/bootstrap-icons.css">

        <link rel="stylesheet" href="/src/vender/sidebar/demo.css">

        <link rel="stylesheet" href="/src/vender/materialdesign/css/materialdesignicons.min.css">

        <link rel="stylesheet" href="/src/vender/animate/animate.min.css">

        <link rel="stylesheet" href="/src/css/style.css">

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"
              integrity="sha512-SnH5WK+bZxgPHs44uWIX+LLJAJ9/2PkPKZ5QiAj6Ta86w+fsb2TkcmfRyVX3pBnMFcV7oQPJkl9QevSCWr3W6A=="
              crossorigin="anonymous" referrerpolicy="no-referrer" />

        <script src="/src/vender/jquery/jquery.min.js" type="text/javascript"></script>


        <style>
            .imgrev{
                height: 50vh;
                mix-blend-mode: multiply;
            }
            .badgeenc {
                top: 35px !important;
            }
            .contain {
                width: 95%;
                margin: 0 auto;
            }
            .contain-h{
                min-height: 70vh;
            }
            .marg-3{
                margin-right: 1rem;
            }
            .dnon{
                display: none;
            }
            .imgl {
                width: 80px !important;
                height: 80px !important;
                object-fit: cover !important;
                overflow: hidden;
            }
            .badge2 {
                position: absolute;
                bottom: 2px;
                right: 2px;
                z-index: 1;

                padding: 4px 6px 4px 6px;

                border-style: none;

                border-radius: 2px;

                font-size: 11px;
                font-weight: bold;
                text-transform: uppercase;
                color: white;
                background-color: #1b00ff;
            }

            .lugard{
                height: 40px;
                overflow: hidden;
            }

            .dbkfx{
                display: block;
            }



            @media (min-width: 1280px) {
                .lostlist {
                    width: 20vw;
                    margin: 20px;
                }
                .contain {
                    width: 55%;
                }
                .marg-3{
                    margin-right: 3rem;
                }
                .imgrev{
                    height: 60vh;
                }
                .lugard{
                    height: 40px;
                }
                .dbkfx{
                    display: flex;
                }
            }
        </style>
        <!--
           <style>
               footer {
                   position: fixed;
                   bottom: 0;
                   width: 100%;
               }
       
               .mapaa {
                   height: 400px;
               }
       
               .card img {
                   height: 40vw;
                   object-fit: cover;
               }
       
               .contain {
                   width: 95%;
                   margin: 0 auto;
               }
       
               .imgl {
                   width: 80px !important;
                   height: 80px !important;
                   object-fit: cover !important;
               }
       
       
               .numimg {
                   display: 100%;
                   height: 100%;
                   display: flex;
                   justify-content: center;
                   align-items: center;
                   font-size: 2rem;
                   color: grey;
               }
       
               .badge2 {
                   position: absolute;
                   bottom: 2px;
                   right: 2px;
                   z-index: 1;
       
                   padding: 4px 6px 4px 6px;
       
                   border-style: none;
       
                   border-radius: 2px;
       
                   font-size: 11px;
                   font-weight: bold;
                   text-transform: uppercase;
                   color: white;
                   background-color: #6504b5;
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
       
                   .contain {
                       width: 55%;
                   }
               }
           </style>
        -->
    </head>

    <body class="pb-5">

        <header class="d-flex align-items-center justify-content-between mb-auto p-3 bg-primary shadow-sm">
            <a href="/" class="text-decoration-none text-black d-flex"><img
                    class="img-fluid main-logo" src="/src/imgs/logo2.png"><span class="h6 mt-1 mb-0 ms-2 me-auto text-white fw-bold">MymbApp</span></a>





            <div class="d-flex align-items-center gap-3">
                <a id="btncarrito" class="dnon btn btn-secondar position-relative marg-3 animate__headShake animate__infinite infinite" href="/carrito">
                    <i class="fa-solid fa-cart-shopping"></i> Carrito
                    <span id="canti" class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger"></span>
                </a>
                <a href="#"
                   class="toggle icon fs-5 hc-nav-1"
                   role="button" aria-controls="hc-nav-1"><i class="fa-solid fa-bars text-white"></i></a>
            </div>
        </header>

        <nav id="main-nav">
            <ul class="second-nav">
                <li class="osahan-user-profile bg-primary">
                    <div class="d-flex align-items-center gap-2">
                        <img src="<% if(sesion.getAttribute("imag") != null){out.print("/imgs/user/" + sesion.getAttribute("imag"));}  %>" alt class="rounded-pill img-fluid cw-30">
                        <div class="ps-1">
                            <h6 class="fw-bold text-white mb-0"><% if(sesion.getAttribute("persona") != null){out.print(sesion.getAttribute("persona"));}else{out.print("Bienvenido");}  %></h6>
                        </div>
                    </div>
                </li>
                <% if(sesion.getAttribute("persona") == null){  %>
                <li class="bg-body-secondary"><a href="/login"><i class="fa-solid fa-right-to-bracket me-2 text-primary"></i>Iniciar Sesion</a></li>           
                    <% } else{ %>
                <li class="bg-body-secondary"><a href="/sesion/logout"><i class="fa-solid fa-right-from-bracket me-2 text-primary"></i>Cerrar Sesion</a></li>
                <li><a href="/usuario"><i class="fa-solid fa-user me-2 text-primary"></i>Mi Cuenta</a></li>                
                <li><a href="/usuario/posts"><i class="fa-solid fa-file-invoice me-2 text-primary"></i>Mis Publicaciones</a></li>
                    <% } %>
                <li>
                    <a href="#"><i class="fa-solid fa-file-pen me-2 text-primary"></i></span>Crear Publicacion</a>
                    <ul>
                        <li><a href="/perdidos/post/add"><i class="fa-solid fa-magnifying-glass me-2 text-primary"></i>Perdi a mi mascota</a></li>
                        <li><a href="/encontrados/post/add"><i class="fa-solid fa-location-dot me-2 text-primary"></i>Encontre una mascota</a></li>
                        <li><a href="/adopcion/post/add"><i class="fa-solid fa-paw me-2 text-primary"></i>Quiero dar en adopcion</a></li>
                    </ul>
                </li>
                <li><a href="/perdidos"><i class="fa-solid fa-magnifying-glass me-2 text-primary"></i>Mascotas Perdidas</a></li>
                <li><a href="/encontrados"><i class="fa-solid fa-location-dot me-2 text-primary"></i>Mascotas Encontradas</a></li>
                <li><a href="/adopcion"><i class="fa-solid fa-paw me-2 text-primary"></i>Mascotas en Adopcion</a></li>
                <li><a href="/tienda"><i class="fa fa-shop me-2 text-primary"></i>Tienda</a></li>
                    <% if(sesion.getAttribute("persona") != null){  %>
                <li><a href="/usuario/compras"><i class="fa fa-cart-shopping me-2 text-primary"></i>Mis Compras</a></li>
                    <% } %>
                <li><a href="/dashboard"><i class="fa fa-user-shield me-2 text-primary"></i>Administracion</a></li>
            </ul>
        </nav>
