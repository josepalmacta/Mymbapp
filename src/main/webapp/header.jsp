<%-- 
    Document   : header
    Created on : 30 abr 2024, 14:24:07
    Author     : Usuario
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <%
        HttpSession sesion = request.getSession();
        if(sesion.getAttribute("logueado") == null){     
    %>
    <script>location.href = "/dashboard";</script>
    <% } %>
    <head>
        <!-- Basic Page Info -->
        <meta charset="utf-8">
        <title>DASHBOARD</title>

        <!-- Site favicon -->
        <link rel="apple-touch-icon" sizes="180x180" href="/resources/vendors/images/apple-touch-icon.png">
        <link rel="icon" type="image/png" sizes="32x32" href="/resources/vendors/images/favicon-32x32.png">
        <link rel="icon" type="image/png" sizes="16x16" href="/resources/vendors/images/favicon-16x16.png">

        <!-- Mobile Specific Metas -->
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">

        <!-- Google Font -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <!-- CSS -->
        <link rel="stylesheet" type="text/css" href="/resources/vendors/styles/core.css">
        <link rel="stylesheet" type="text/css" href="/resources/vendors/styles/icon-font.min.css">
        <link rel="stylesheet" type="text/css" href="/resources/src/plugins/jvectormap/jquery-jvectormap-2.0.3.css">
        <link rel="stylesheet" type="text/css" href="/resources/vendors/styles/style.css">

        <link rel="stylesheet" href="/resources/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
        <script src="/resources/src/scripts/jquery-3.7.1.min.js"></script>
    </head>
    <style>
        .imgl {
            width: 80px !important;
            height: 80px !important;
            object-fit: cover !important;
            overflow: hidden;
        }
        .imgpr {
            width: 50px !important;
            height: 50px !important;
            object-fit: cover !important;
            overflow: hidden;
        }
        .sinicon:before{
            content: none !important;
        }
    </style>
    <body>
        <div class="pre-loader">
            <div class="pre-loader-box">
                <div class="loader-logo"><img src="/src/imgs/logo1.png" alt="" style="height: 100px;"></div>
                <div class='loader-progress' id="progress_div">
                    <div class='bar' id='bar1'></div>
                </div>
                <div class='percent' id='percent1'>0%</div>
                <div class="loading-text">
                    CARGANDO...
                </div>
            </div>
        </div>

        <div class="header">
            <div class="header-left">
                <div class="menu-icon dw dw-menu"></div>
                <div class="search-toggle-icon dw dw-search2" data-toggle="header_search"></div>
            </div>
            <div class="header-right">

                <div class="user-info-dropdown mx-3">
                    <div class="dropdown">
                        <a class="dropdown-toggle" href="#" role="button" data-toggle="dropdown">
                            <!--<span class="user-icon">
                                <img height="40px" src="/vendors/images/photo1.jpg" alt="">
                            </span>-->
                            <span class="user-name"><% out.println(sesion.getAttribute("user")); %></span>
                        </a>
                        <div class="dropdown-menu dropdown-menu-right dropdown-menu-icon-list">
                            <a class="dropdown-item" href="#"><i class="dw dw-settings2"></i> Configuracion</a>
                            <a class="dropdown-item" href="/session/logout"><i class="dw dw-logout"></i> Cerrar Sesion</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="right-sidebar">
            <div class="sidebar-title">
                <h3 class="weight-600 font-16 text-blue">
                    Layout Settings
                    <span class="btn-block font-weight-400 font-12">User Interface Settings</span>
                </h3>
                <div class="close-sidebar" data-toggle="right-sidebar-close">
                    <i class="icon-copy ion-close-round"></i>
                </div>
            </div>
            <div class="right-sidebar-body customscroll">
                <div class="right-sidebar-body-content">
                    <h4 class="weight-600 font-18 pb-10">Header Background</h4>
                    <div class="sidebar-btn-group pb-30 mb-10">
                        <a href="javascript:void(0);" class="btn btn-outline-primary header-white active">White</a>
                        <a href="javascript:void(0);" class="btn btn-outline-primary header-dark">Dark</a>
                    </div>

                    <h4 class="weight-600 font-18 pb-10">Sidebar Background</h4>
                    <div class="sidebar-btn-group pb-30 mb-10">
                        <a href="javascript:void(0);" class="btn btn-outline-primary sidebar-light ">White</a>
                        <a href="javascript:void(0);" class="btn btn-outline-primary sidebar-dark active">Dark</a>
                    </div>

                    <h4 class="weight-600 font-18 pb-10">Menu Dropdown Icon</h4>
                    <div class="sidebar-radio-group pb-10 mb-10">
                        <div class="custom-control custom-radio custom-control-inline">
                            <input type="radio" id="sidebaricon-1" name="menu-dropdown-icon" class="custom-control-input" value="icon-style-1" checked="">
                            <label class="custom-control-label" for="sidebaricon-1"><i class="fa fa-angle-down"></i></label>
                        </div>
                        <div class="custom-control custom-radio custom-control-inline">
                            <input type="radio" id="sidebaricon-2" name="menu-dropdown-icon" class="custom-control-input" value="icon-style-2">
                            <label class="custom-control-label" for="sidebaricon-2"><i class="ion-plus-round"></i></label>
                        </div>
                        <div class="custom-control custom-radio custom-control-inline">
                            <input type="radio" id="sidebaricon-3" name="menu-dropdown-icon" class="custom-control-input" value="icon-style-3">
                            <label class="custom-control-label" for="sidebaricon-3"><i class="fa fa-angle-double-right"></i></label>
                        </div>
                    </div>

                    <h4 class="weight-600 font-18 pb-10">Menu List Icon</h4>
                    <div class="sidebar-radio-group pb-30 mb-10">
                        <div class="custom-control custom-radio custom-control-inline">
                            <input type="radio" id="sidebariconlist-1" name="menu-list-icon" class="custom-control-input" value="icon-list-style-1" checked="">
                            <label class="custom-control-label" for="sidebariconlist-1"><i class="ion-minus-round"></i></label>
                        </div>
                        <div class="custom-control custom-radio custom-control-inline">
                            <input type="radio" id="sidebariconlist-2" name="menu-list-icon" class="custom-control-input" value="icon-list-style-2">
                            <label class="custom-control-label" for="sidebariconlist-2"><i class="fa fa-circle-o" aria-hidden="true"></i></label>
                        </div>
                        <div class="custom-control custom-radio custom-control-inline">
                            <input type="radio" id="sidebariconlist-3" name="menu-list-icon" class="custom-control-input" value="icon-list-style-3">
                            <label class="custom-control-label" for="sidebariconlist-3"><i class="dw dw-check"></i></label>
                        </div>
                        <div class="custom-control custom-radio custom-control-inline">
                            <input type="radio" id="sidebariconlist-4" name="menu-list-icon" class="custom-control-input" value="icon-list-style-4" checked="">
                            <label class="custom-control-label" for="sidebariconlist-4"><i class="icon-copy dw dw-next-2"></i></label>
                        </div>
                        <div class="custom-control custom-radio custom-control-inline">
                            <input type="radio" id="sidebariconlist-5" name="menu-list-icon" class="custom-control-input" value="icon-list-style-5">
                            <label class="custom-control-label" for="sidebariconlist-5"><i class="dw dw-fast-forward-1"></i></label>
                        </div>
                        <div class="custom-control custom-radio custom-control-inline">
                            <input type="radio" id="sidebariconlist-6" name="menu-list-icon" class="custom-control-input" value="icon-list-style-6">
                            <label class="custom-control-label" for="sidebariconlist-6"><i class="dw dw-next"></i></label>
                        </div>
                    </div>

                    <div class="reset-options pt-30 text-center">
                        <button class="btn btn-danger" id="reset-settings">Reset Settings</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="left-side-bar">
            <div class="brand-logo">
                <a href="/dashboard">
                    <img src="/resources/vendors/images/deskapp-logo.svg" alt="" class="dark-logo">
                    <img src="/src/imgs/logo2.png" alt="" style="height: 50px;" class="light-logo">
                    <span>DASHBOARD</span>
                </a>
                <div class="close-sidebar" data-toggle="left-sidebar-close">
                    <i class="ion-close-round"></i>
                </div>
            </div>
            <div class="menu-block customscroll">
                <div class="sidebar-menu">
                    <ul id="accordion-menu">
                        <%
                        if(sesion.getAttribute("rol").equals("ADMINISTRADOR")){     
                        %>
                        <li class="dropdown">
                            <a href="javascript:;" class="dropdown-toggle">
                                <span class="micon fa-solid fa-network-wired"></span><span class="mtext">MANTENIMIENTO</span>
                            </a>
                            <ul class="submenu">
                                <li><a href="/dashboard/departamentos">Departamentos</a></li>
                                <li><a href="/dashboard/ciudades">Ciudades</a></li>
                                <li><a href="/dashboard/barrios">Barrio</a></li>
                                <li><a href="/dashboard/especies">Especies</a></li>
                                <li><a href="/dashboard/razas">Razas</a></li>
                                <li><a href="/dashboard/usuarios">Usuarios</a></li>
                                <li><a href="/dashboard/productos">Productos</a></li>
                            </ul>
                        </li>
                        <% } %>                        



                        <li class="dropdown">
                            <a href="javascript:;" class="dropdown-toggle">
                                <span class="micon fa-solid fa-file-lines"></span><span class="mtext">PUBLICACIONES</span>
                            </a>
                            <ul class="submenu">
                                <li>
                                    <a href="/dashboard/perdidos" class="dropdown-toggle no-arrow sinicon">
                                        <span class="micon fa-solid fa-magnifying-glass"></span><span class="mtext">Perdidos</span>
                                    </a>
                                </li>

                                <li>
                                    <a href="/dashboard/encontrados" class="dropdown-toggle no-arrow sinicon">
                                        <span class="micon fa-solid fa-magnifying-glass-location"></span><span class="mtext">Encontrados</span>
                                    </a>
                                </li>

                                <li>
                                    <a href="/dashboard/adopcion" class="dropdown-toggle no-arrow sinicon">
                                        <span class="micon fa-solid fa-paw"></span><span class="mtext">En Adopcion</span>
                                    </a>
                                </li>


                            </ul>
                        </li>
                        
                        <%
                        if(sesion.getAttribute("rol").equals("ADMINISTRADOR")){     
                        %>

                        <li>
                            <a href="/dashboard/ventas" class="dropdown-toggle no-arrow">
                                <span class="micon fa fa-cart-plus"></span><span class="mtext">VENTAS</span>
                            </a>
                        </li>
                        
                        <li class="dropdown">
                            <a href="javascript:;" class="dropdown-toggle">
                                <span class="micon fa-solid fa-file"></span><span class="mtext">INFORMES</span>
                            </a>
                            <ul class="submenu">
                                <li><a href="/dashboard/informes/ventas">Ventas</a></li>
                                <li><a href="/dashboard/informes/perdidos">Mascotas Perdidas</a></li>
                                <li><a href="/dashboard/informes/encontrados">Mascotas Encontradas</a></li>
                                <li><a href="/dashboard/informes/adopcion">Mascotas en Adopcion</a></li>
                            </ul>
                        </li>
                        <% } %> 





                    </ul>
                </div>
            </div>
        </div>
        <div class="mobile-menu-overlay"></div>

        <div class="main-container">
            <div class="xs-pd-20-10 pd-ltr-20">