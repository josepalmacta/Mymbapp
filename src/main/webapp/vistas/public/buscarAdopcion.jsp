<%-- 
    Document   : buscarAdopcion
    Created on : 27 jul 2024, 16:04:32
    Author     : Usuario
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="jakarta.json.JsonValue"%>
<%@page import="jakarta.json.Json"%>
<%@page import="jakarta.json.JsonArray"%>
<%@page import="jakarta.json.JsonArrayBuilder"%>
<%@page import="jakarta.json.JsonObject"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="java.sql.Connection"%>


<% String titulo = "Mascotas en Adopcion"; %>

<%@include file="header.jsp" %>

<style>
    footer {
        position: fixed;
        bottom: 0;
        width: 100%;
    }

    .mapaa {
        height: 400px;
    }

    .card img,
    .card-body img {
        width: 100%;
        height: 40vw;
        object-fit: cover;
    }

    .card-body {
        padding: 0px;
    }

    .shadow-cus {
        box-shadow: 0 .125rem .25rem rgba(var(--bs-body-color-rgb), .4) !important;
    }


    .badge {
        position: absolute;
        top: 2px;
        right: 2px;
        z-index: 1;

        padding: 5px 10px;

        font-size: 12px;
        font-weight: bold;
        text-transform: uppercase;
        color: white;
        background-color: #1b00ff;
    }

    #map {
        width: 100%;
        height: 400px;
    }


    .filtrs{
        display: block;
    }

    .filtrs2{
        margin-top: 0px;
    }

    .slct{
        width: 100%;
    }


    @media (min-width: 1024px) {
        .lostlist {
            width: 20vw;
            margin: 20px;
        }

        .card img {
            height: 20vw;
            object-fit: cover;
        }

        .filtrs{
            display: flex;
        }

        .filtrs2{
            margin-top: 15px;
        }

        .slct{
            width: 33%;
        }


    }
</style>


<div>
    <div class="p-3">
        <div class="accordion" id="accordionExample">
            <div class="accordion-item">
                <h2 class="accordion-header">
                    <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne" aria-expanded="false" aria-controls="collapseOne">
                        Filtros de busqueda
                    </button>
                </h2>
                <div id="collapseOne" class="accordion-collapse collapse" data-bs-parent="#accordionExample">
                    <div class="accordion-body">
                        <form class="p-3 w-100" id="busqueda">
                            <div class="filtrs justify-content-between w-100" style="gap: 10px">
                                <div class="d-block mt-3 slct">
                                    <label class="form-label">Departamento</label>
                                    <div class="input-group d-flex flex-nowrap">
                                        <span class="input-group-text"><i class="fa-solid fa-city text-primary"></i></span>
                                        <select id="departamentos" name="departamento" class="form-select"></select>
                                    </div>
                                </div>
                                <div class="d-block mt-3 slct">
                                    <label class="form-label">Ciudad</label>
                                    <div class="input-group d-flex flex-nowrap">
                                        <span class="input-group-text"><i class="fa-solid fa-tree-city text-primary"></i></span>
                                        <select id="ciudades" name="ciudad" class="form-select">
                                            <option value="-1">SELECCIONAR</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="d-block mt-3 slct">
                                    <label class="form-label">Barrio</label>
                                    <div class="input-group d-flex flex-nowrap">
                                        <span class="input-group-text"><i class="fa-solid fa-building text-primary"></i></span>
                                        <select id="barrios" name="barrio" class="form-select">
                                            <option value="-1">SELECCIONAR</option>
                                        </select>   
                                    </div>
                                </div>
                            </div>
                            <div class="filtrs filtrs2" style="gap: 10px">
                                <div class="d-block mt-3 slct">
                                    <label class="form-label">Especie</label>
                                    <div class="input-group d-flex flex-nowrap">
                                        <span class="input-group-text"><i class="fa-solid fa-paw text-primary"></i></span>
                                        <select id="especies" name="especie" class="form-select"></select>
                                    </div>
                                </div>

                                <div class="d-block mt-3 slct">
                                    <label class="form-label">Raza</label>
                                    <div class="input-group d-flex flex-nowrap">
                                        <span class="input-group-text"><i class="fa-solid fa-paw text-primary"></i></span>
                                        <select id="razas" name="raza" class="form-select">
                                            <option value="-1">SELECCIONAR</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex justify-content-between mt-3">
                                <a class="btn btn-primary rounded-pill btn-lg" onclick="cargarPosts()"><i class="fa-solid fa-magnifying-glass"></i> Buscar</a>
                            </div>

                        </form>
                    </div>
                </div>
            </div>
        </div>







        <input type="hidden" id="pagina" value="8">

        <div id="resultads" class="row row-cols-2 row-cols-sm-2 row-cols-md-2 g-3 py-5">
            <%
                DataSource dataSource = (DataSource) getServletContext().getAttribute("dataSource");
                try(Connection connection = dataSource.getConnection()){
                    
                    modelos.postAdopcion posts = new modelos.postAdopcion(connection);
        
         JsonArray arr = posts.listarHome();
         
         for (int i = 0; i < arr.size(); i++) {
            JsonObject obj = arr.getJsonObject(i);
            %>



            <div class="col lostlist">
                <div class="card border-0 rounded-3 shadow overflow-hidden">
                    <% if(obj.getString("estado").equals("ADOPTADO")){ %>
                    <div class="badge bg-success">ADOPTADO</div>
                    <% } %>
                    <img src="/imgs/posts/a/<% out.print(obj.getString("img")); %>" class="hover-img position-relative">
                    <div class="card-body p-2">
                        <div class="my-2 gap-2">
                            <p class="d-flex align-items-center gap-1 my-2 text-secondary"><i class="fa-solid fa-paw text-primary fs-6"></i> <% out.print(obj.getString("especie")); %></p>
                            <p class="d-flex align-items-center gap-1 my-2 text-secondary"><i class="fa-solid fa-venus-mars text-primary fs-6"></i> <% out.print(obj.getString("genero")); %></p>
                        </div>
                    </div>
                    <a class="stretched-link" href="/adopcion/post/<% out.print(obj.getString("postid")); %>"></a>
                </div>
            </div>


            <% } %>
        </div>
        <div class="d-flex align-items-center justify-content-center mb-auto px-5">
            <button class="btn btn-primary rounded-pill btn-lg" onclick="cargarPagina()">MOTRAR MAS PUBLICACIONES</button>
        </div>
    </div>
</div>

<script src="/src/vender/bootstrap/js/bootstrap.bundle.min.js" type="text/javascript"></script>

<script src="/src/vender/jquery/jquery.min.js" type="text/javascript"></script>

<script src="/resources/src/plugins/sweetalert2/sweetalert2.all.js"></script>

<script>
    function mostrarMensaje(mensaje) {
        swal(
                {
                    position: 'bottom-end',
                    text: mensaje["mensaje"],
                    showConfirmButton: false,
                    timer: 1500,
                    width: '90%',
                    background: '#e7dcf2',
                    backdrop: false
                    
                }
        );
    }
</script>

<script>
                function cargarPagina() {
                    let dataform = $("#busqueda").serialize();
                    let datos = dataform + '&pagina=' + $("#pagina").val();
                    $.ajax(
                            {
                                url: "/api/buscar/adopcion",
                                data: datos,
                                type: "post",
                                success: function (response) {
                                    
                                    if(response.trim().length < 5){
                                        let objj = {estado: "success", mensaje: "Ya no hay publicaciones"};
                                        mostrarMensaje(objj);
                                        return;
                                    }
                                    $("#pagina").val(parseInt($("#pagina").val()) + 8);
                                    $("#resultads").html($("#resultads").html() + response);
                                }
                            }
                    );
                }


                function cargarPosts() {
                    $("#pagina").val("0");
                    let dataform = $("#busqueda").serialize();
                    let datos = dataform + '&pagina=' + $("#pagina").val();
                    $.ajax(
                            {
                                url: "/api/buscar/adopcion",
                                data: datos,
                                type: "post",
                                success: function (response) {
                                    $("#pagina").val("8");
                                    $("#resultads").html(response);
                                }
                            }
                    );
                }
</script>

<script>
    function cargarEsp() {
        $.ajax(
                {
                    url: "/api/buscar/especies",
                    data: {opt: "list"},
                    type: "post",
                    success: function (response) {
                        let res = JSON.parse(response);
                        let def = document.createElement("option");
                        def.value = "-1";
                        def.innerHTML = "SELECCIONAR";
                        $("#especies").append(def);
                        res.forEach(function (obj) {
                            let op = document.createElement("option");
                            op.value = obj["id"];
                            op.innerHTML = obj["nombre"];
                            $("#especies").append(op);
                        });
                    }
                }
        );
    }


    function cargarRazas(idd, ciu) {
        $.ajax(
                {
                    url: "/api/buscar/razas",
                    data: {opt: "esp", especie: idd},
                    type: "post",
                    success: function (response) {
                        let res = JSON.parse(response);
                        $("#razas").html("");
                        let def = document.createElement("option");
                        def.value = "-1";
                        def.innerHTML = "SELECCIONAR";
                        $("#razas").append(def);
                        res.forEach(function (obj) {
                            let op = document.createElement("option");
                            op.value = obj["id"];
                            op.innerHTML = obj["nombre"];
                            $("#razas").append(op);
                        });

                        if (ciu != "0") {
                            $("#razas").val(ciu);
                        }

                    }
                }
        );
    }



    $('#especies').on('change', function (e) {
        cargarRazas(this.options[this.selectedIndex].value, "0");
    });












    function cargarDep() {
        $.ajax(
                {
                    url: "/api/buscar/departamentos",
                    data: {opt: "list"},
                    type: "post",
                    success: function (response) {
                        console.log(response);
                        let res = JSON.parse(response);
                        let def = document.createElement("option");
                        def.value = "-1";
                        def.innerHTML = "SELECCIONAR";
                        $("#departamentos").append(def);
                        res.forEach(function (obj) {
                            let op = document.createElement("option");
                            op.value = obj["id"];
                            op.innerHTML = obj["nombre"];
                            $("#departamentos").append(op);
                        });
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
                        let def = document.createElement("option");
                        def.value = "-1";
                        def.innerHTML = "SELECCIONAR";
                        $("#ciudades").append(def);
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
                        let def = document.createElement("option");
                        def.value = "-1";
                        def.innerHTML = "SELECCIONAR";
                        $("#barrios").append(def);
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





    cargarEsp();
    cargarDep();


</script>
<% } %>
<%@include file="footer.jsp" %>
