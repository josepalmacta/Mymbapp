<%-- 
    Document   : postPerdidos
    Created on : 11 jun 2024, 13:48:58
    Author     : Usuario
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<% String titulo = "Crear Publicacion Mascota perdida"; %>
<%@include file="header.jsp" %>  


<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
      integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=" crossorigin="" />

<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""></script>

<style>
    #map {
        width: 100%;
        height: 400px;
    }
</style>


<div class="modal fade" id="confirmation-modal" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-body text-center font-18">
                <h4 class="padding-top-30 mb-30 weight-500">PUBLICACION CREADA PERO...</h4>
                <h6 class="padding-top-30 mb-30 weight-500">Su publicacion ha sido creada pero pasara por un proceso de revision
                    manual antes de ser visible en la plataforma.
                </h6>
                <div class="padding-bottom-30 row" style="max-width: 170px; margin: 0 auto;">
                    <div class="col-6">
                        <a href="/" class="btn btn-secondary border-radius-100 btn-block confirmation-btn" data-dismiss="modal">ENTENDIDO</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalAgregar" data-bs-backdrop="static" tabindex="-1"
     aria-labelledby="AgregarModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5" id="AgregarModalLabel">DETALLES DE LA MASCOTA</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"
                        onclick="cancelAc()"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3 mt-3">
                    <label class="form-label">NOMBRE</label>
                    <div class="input-group flex-nowrap">
                        <span class="input-group-text"><i class="fa-solid fa-dog text-primary"></i></span>
                        <input id="mdNombre" class="form-control px-3 py-2" maxlength="10"
                               placeholder="Nombre de la Mascota">
                    </div>
                </div>
                <div class="mb-3 mt-4">
                    <label class="form-label">ESPECIE</label>
                    <div class="input-group flex-nowrap">
                        <span class="input-group-text"><i class="fa-solid fa-paw text-primary"></i></span>
                        <select id="mdEspecie" class="form-select">
                        </select>
                    </div>
                </div>
                <div class="mb-3 mt-4">
                    <label class="form-label">RAZA</label>
                    <div class="input-group flex-nowrap">
                        <span class="input-group-text"><i class="fa-solid fa-paw text-primary"></i></span>
                        <select id="mdRaza" class="form-select">
                        </select>
                    </div>
                </div>
                <div class="mb-3 mt-4">
                    <label class="form-label">GENERO</label>
                    <div class="input-group flex-nowrap">
                        <span class="input-group-text"><i class="fa-solid fa-venus-mars text-primary"></i></span>
                        <select id="mdGenero" class="form-select">
                            <option value="HEMBRA">Hembra</option>
                            <option value="MACHO">Macho</option>
                        </select>
                    </div>
                </div>
                <div class="mb-3 mt-3">
                    <label class="form-label">DESCRIPCION</label>
                    <div class="input-group flex-nowrap">
                        <span class="input-group-text"><i class="fa-solid fa-info text-primary"></i></span>
                        <input maxlength="100" id="mdDescripcion" class="form-control bg-light px-3 py-2"
                               placeholder="Color blanco con manchas negras...">
                    </div>
                </div>
                <div class="mb-3 mt-3">
                    <div class="d-block">                            
                        <button id="mdAddImg" type="button" class="btn btn-primary rounded-pill">AGREGAR IMAGEN <i
                                class="fa-solid fa-plus"></i></button>
                        <label class="form-label d-block mt-3">IMAGENES</label>
                    </div>
                    <input onchange="read(this)" id="file-input" type="file" accept="image/*" name="name" style="display: none;" />
                    <div id="imgCon" class="input-group d-flex">
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary rounded-pill" data-bs-dismiss="modal"
                        onclick="cancelAc()">CANCELAR</button>
                <button type="button" class="btn btn-primary rounded-pill" onclick="addMasc()">ACEPTAR</button>
            </div>
        </div>
    </div>
</div>

<div class="contain">
    <div id="mensajeconf" class="text-center d-none">
        <img class="imgrev" src="/src/imgs/revision.jfif" alt="revision"/>
        <h3 class="h3">PUBLICACION CREADA, PERO...</h3>
        <p class="h5">
            Su publicacion ha sido creada pero pasara por un proceso de revision manual antes de ser visible en la plataforma.
        </p>
        <a href="/usuario/posts" class="btn btn-warning border-radius-100 btn-block confirmation-btn mt-2 text-primary"><i class="fa-solid fa-file-contract me-2 text-primary"></i> Ver mis posts</a>
    </div>
    <div id="contenid">

        <div class="p-3">
            <div class="d-flex gap-1 align-items-center pt-3">
                <h3 class="fw-bold text-dark mb-0">REPORTAR MASCOTA PERDIDA</h3>
            </div>
        </div>






        <div class="tab">
            <ul class="nav nav-tabs customtab mb-20 d-none" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" data-bs-toggle="tab" aria-controls="pmascotas" href="#pmascotas" role="tab" aria-selected="true">VENTAS</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-bs-toggle="tab" aria-controls="plugar" href="#plugar" role="tab" aria-selected="false">Mascotas Perdidas</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-bs-toggle="tab" aria-controls="pubicacion" href="#pubicacion" role="tab" aria-selected="false">Mascotas Encontradas</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-bs-toggle="tab" aria-controls="pinfo" href="#pinfo" role="tab" aria-selected="false">Mascotas en Adopcion</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-bs-toggle="tab" aria-controls="pfina" href="#pfinal" role="tab" aria-selected="false">Mascotas en Adopcion</a>
                </li>
            </ul>
            <div class="tab-content">
                <div class="tab-pane fade show active" id="pmascotas" role="tabpanel">

                    <div class="p-2 w-100 text-end">
                        <a class="btn btn-primary next-step">Siguiente</a>
                    </div>

                    <hr>

                    <div class="p-3">

                        <div class="mb-3 mt-5 text-center">
                            <h4>AGREGUE UNA O MAS MASCOTAS A SU PUBLICACION</h4>
                            <button data-bs-toggle="modal" data-bs-target="#modalAgregar" class="btn btn-primary mt-5"><i
                                    class="fa-solid fa-plus"></i> AGREGAR MASCOTA</button>
                        </div>


                        <div class="mb-3 mt-5">
                            <div id="mascl" class="row">
                            </div>
                        </div>


                    </div>

                </div>







                <div class="tab-pane fade" id="plugar" role="tabpanel">

                    <div class="p-2 w-100 text-end">
                        <a class="btn btn-secondary prev-step">Atras</a>
                        <a class="btn btn-primary next-step">Siguiente</a>
                    </div>

                    <hr>


                    <div class="p-3">

                        <div class="mt-3 text-center">
                            <h4>¿En que barrio extravio a su mascota?</h4>
                        </div>


                        <div class="mb-3 mt-5">
                            <label class="form-label">DEPARTAMENTO</label>
                            <div class="input-group flex-nowrap">
                                <span class="input-group-text"><i class="fa-solid fa-city text-primary"></i></span>
                                <select id="departamentos" class="form-select">
                                </select>
                            </div>
                        </div>


                        <div class="mb-3 mt-5">
                            <label class="form-label">CIUDAD</label>
                            <div class="input-group flex-nowrap">
                                <span class="input-group-text"><i class="fa-solid fa-tree-city text-primary"></i></span>
                                <select id="ciudades" class="form-select">
                                </select>
                            </div>
                        </div>


                        <div class="mb-5 mt-5">
                            <label class="form-label">BARRIO</label>
                            <div class="input-group flex-nowrap">
                                <span class="input-group-text"><i class="fa-solid fa-building text-primary"></i></span>
                                <select id="barrios" class="form-select">
                                </select>
                            </div>
                        </div>



                    </div>

                </div>












                <div class="tab-pane fade" id="pubicacion" role="tabpanel">

                    <div class="p-2 w-100 text-end">
                        <a class="btn btn-secondary prev-step">Atras</a>
                        <a class="btn btn-primary next-step">Siguiente</a>
                    </div>

                    <hr>


                    <div class="p-3">

                        <div class="mt-3 text-center">
                            <h4>Ubique la zona en la que se vio por ultima vez.</h4>
                        </div>


                        <div class="mb-5 mt-5">
                            <div class="input-group flex-nowrap">
                                <input type="hidden" name="lat" id="laat">
                                <input type="hidden" name="long" id="loong">
                                <div class="card w-100">
                                    <div class="mapaa text-center">
                                        <div id="map"></div>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>



                </div>













                <div class="tab-pane fade" id="pinfo" role="tabpanel">

                    <div class="p-2 w-100 text-end">
                        <a class="btn btn-secondary prev-step">Atras</a>
                        <a class="btn btn-primary next-step">Siguiente</a>
                    </div>

                    <hr>

                    <div class="p-3">
                        <div class="mb-1 mt-5">
                            <label class="form-label">INFORMACION ADICIONAL</label>
                            <div class="input-group flex-nowrap">
                                <textarea maxlength="200" rows="4" id="descripcion" name="descripcion" class="form-control px-3 py-2"
                                          placeholder="Ingrese aqui cualquier informacion que pueda ayudar a encontrar a su mascota."></textarea>
                            </div>
                        </div>


                        <div class="mb-3 mt-5">
                            <input id="cbrecom" type="checkbox" class="form-check-input">
                            <label class="form-label">RECOMPENSA</label>                
                            <div class="input-group flex-nowrap">
                                <span class="input-group-text"><i class="fa-solid fa-gift text-primary"></i></span>
                                <input maxlength="20" id="recomp" class="form-control" type="text" disabled>
                            </div>
                        </div>


                        <div class="mb-5 mt-5">
                            <label class="form-label">CONTACTO</label>                
                            <div class="input-group flex-nowrap">
                                <span class="input-group-text"><i class="fa-solid fa-phone text-primary"></i></span>
                                <input id="contacto" class="form-control" type="number" placeholder="098Xxxxxxx">
                            </div>
                        </div>


                    </div>


                </div>









                <div class="tab-pane fade" id="pfinal" role="tabpanel">

                    <div class="p-2 w-100 text-end">
                        <a class="btn btn-secondary prev-step">Atras</a>
                    </div>

                    <hr>

                    <div class="p-3">
                        <div class="mt-3 text-center">
                            <h4>Ya tenemos la informacion necesaria. ¿Desea publicar ahora?</h4>
                        </div>


                        <div class="mb-3 mt-5 text-center">
                            <button class="btn btn-primary rounded-pill w-100 btn-lg" onclick="enviarDat()">CREAR PUBLICACION</button>
                        </div>



                    </div>


                </div>








            </div>            
        </div>


    </div>
</div>


<script src="/src/vender/bootstrap/js/bootstrap.bundle.min.js" type="text/javascript"></script>

<script src="/src/vender/jquery/jquery.min.js" type="text/javascript"></script>

<script src="/resources/src/plugins/sweetalert2/sweetalert2.all.js"></script>


<script>
                                function nextTab() {
                                    var $activeTab = $('.nav-tabs .nav-link.active');
                                    var $nextTab = $activeTab.closest('li').next('li').find('.nav-link');
                                    if ($nextTab.length) {
                                        if ($activeTab.attr("href") === "#pmascotas") {
                                            if (psts.length < 1) {
                                                mostrarMensaje({"success": false, "estado": "warning", "mensaje": "AGREGUE UNA MASCOTA"});
                                                return;
                                            }
                                        }
                                        if ($activeTab.attr("href") === "#pinfo") {
                                            if (!valido()) {
                                                return;
                                            }
                                        }
                                        $nextTab.tab('show');
                                    }
                                }

                                function prevTab() {
                                    var $activeTab = $('.nav-tabs .nav-link.active');
                                    var $prevTab = $activeTab.closest('li').prev('li').find('.nav-link');
                                    if ($prevTab.length) {
                                        $prevTab.tab('show');
                                    }
                                }


                                $('a[data-bs-toggle="tab"]').on('shown.bs.tab', function (e) {
                                    var target = $(e.target).attr("href");
                                    if (target === "#pubicacion") {
                                        setTimeout(function () {
                                            map.invalidateSize();
                                        }, 200);
                                    }
                                });


                                $(".next-step").click(function (e) {
                                    e.preventDefault();
                                    nextTab();
                                });


                                $(".prev-step").click(function (e) {
                                    e.preventDefault();
                                    prevTab();
                                });
</script>


<script>
    var psts = [];
    var isE = -1;
    var map;
    var circ = null;
    const addModal = new bootstrap.Modal('#modalAgregar');

    $('#mdAddImg').on('click', function () {
        $('#file-input').trigger('click');
    });


    $('#cbrecom').change(function () {
        if ($("#cbrecom").is(":checked")) {
            $("#recomp").prop("disabled", false);
            return;
        }
        $("#recomp").val("");
        $("#recomp").prop("disabled", true);
    });


    function read(val) {
        const reader = new FileReader();
        let d = document.createElement("div");
        $(d).addClass("card imgl position-relative m-2 imgc");
        let del = document.createElement("button");
        $(del).addClass("badge2");
        $(del).attr("onclick", "delImg(this);");
        let ic = document.createElement("i");
        $(ic).addClass("fa-solid fa-trash");
        $(del).append(ic);
        let im = document.createElement("img");
        $(im).addClass("imgl imgm");
        reader.onload = (event) => {
            im.src = event.target.result;
            $(d).append(del);
            $(d).append(im);
            $("#imgCon").append(d);
        }
        reader.readAsDataURL(val.files[0]);

    }

    function addMasc() {



        if (!validoMasc()) {
            return;
        }





        let det = {
            "nombre": $("#mdNombre").val(),
            "idesp": $("#mdEspecie option:selected").val(),
            "especie": $("#mdEspecie option:selected").html(),
            "idraza": $("#mdRaza option:selected").val(),
            "raza": $("#mdRaza option:selected").html(),
            "genero": $("#mdGenero option:selected").val(),
            "descripcion": $("#mdDescripcion").val()
        }

        let ims = [];
        Array.from(document.getElementsByClassName("imgm")).forEach(element => {
            ims.push(element.src);
        });

        det["imgs"] = ims;

        if (isE === -1) {
            psts.push(det);
        } else {
            psts[isE] = det;
        }




        isE = -1;


        agregarMascota();

    }

    function borrarMasc(idx) {
        psts.splice(idx, 1);
        agregarMascota();
    }

    function agregarMascota() {

        $("#mascl").html("");

        Array.from(psts).forEach(function (element, i) {
            let d1 = document.createElement("div");
            $(d1).addClass("col-sm-6 mb-4");
            let d2 = document.createElement("div");
            $(d2).addClass("card");
            let d3 = document.createElement("div");
            $(d3).addClass("card-body");
            let tt = document.createElement("h5");
            $(tt).addClass("card-title");
            let pp = document.createElement("p");
            $(pp).addClass("card-text");
            let pp2 = document.createElement("p");
            $(pp2).addClass("card-text");
            let pp3 = document.createElement("p");
            $(pp3).addClass("card-text");
            let pp4 = document.createElement("p");
            $(pp4).addClass("card-text");
            let bte = document.createElement("a");
            $(bte).html("Modificar");
            $(bte).addClass("btn btn-primary");
            $(bte).attr('onClick', 'modificarMasc(' + i + ')');
            let btd = document.createElement("a");
            $(btd).html("Eliminar");
            $(btd).addClass("btn btn-primary mx-2");
            $(btd).attr('onClick', 'borrarMasc(' + i + ')');
            let d4 = document.createElement("div");
            $(d4).addClass("mb-3 mt-3 d-flex flex-wrap");


            $(tt).html(element.nombre);
            $(pp).html(element.especie);
            $(pp2).html(element.raza);
            $(pp3).html(element.genero);
            $(pp4).html(element.color);

            Array.from(element.imgs).forEach(function (imag, j) {

                let d = document.createElement("div");
                $(d).addClass("card imgl position-relative m-2 imgc");

                if (j < 2) {
                    let im = document.createElement("img");
                    $(im).addClass("imgl imgn");
                    im.src = imag;
                    $(d).append(im);
                    $(d4).append(d);
                } else if (j === 2) {
                    let num = document.createElement("span");
                    $(num).addClass("numimg");
                    $(num).html("+" + (element.imgs.length - 2));
                    $(d).append(num);
                    $(d4).append(d);
                }





                //$(d4).append($(element).removeClass("imgc").addClass("imga"));
            });

            $(d3).append(tt);
            $(d3).append(pp);
            $(d3).append(pp2);
            $(d3).append(pp3);
            $(d3).append(pp4);
            $(d3).append(d4);
            $(d3).append(bte);
            $(d3).append(btd);

            $(d2).append(d3);
            $(d1).append(d2);

            $("#mascl").append(d1);

        });

        addModal.hide();

        $("#modalAgregar .btn-close").click();

        limpiarModal();

    }



    function limpiarModal() {
        $("#mdNombre").val("");
        $("#mdDescripcion").val("");
        $('#mdEspecie option')[0].selected = true;
        cargarRazas(document.getElementById("mdEspecie").options[document.getElementById("mdEspecie").selectedIndex].value, "0");
        $('#mdRaza option')[0].selected = true;
        $('#mdGenero option')[0].selected = true;
        $("#imgCon").html("");
    }


    function cancelAc() {
        limpiarModal();
        isE = -1;
    }


    function modificarMasc(idx) {
        limpiarModal();
        $("#mdNombre").val(psts[idx].nombre);
        $("#mdDescripcion").val(psts[idx].descripcion);
        $("#mdEspecie").val(psts[idx].idesp);
        cargarRazas(document.getElementById("mdEspecie").options[document.getElementById("mdEspecie").selectedIndex].value, psts[idx].idraza);
        //$("#mdRaza").val(psts[idx].idraza);
        $("#mdGenero").val(psts[idx].genero);

        Array.from(psts[idx].imgs).forEach(imag => {

            let d = document.createElement("div");
            $(d).addClass("card imgl position-relative m-2 imgc");
            let del = document.createElement("button");
            $(del).addClass("badge2");
            $(del).attr("onclick", "delImg(this);");
            let ic = document.createElement("i");
            $(ic).addClass("fa-solid fa-trash");
            $(del).append(ic);
            let im = document.createElement("img");
            $(im).addClass("imgl imgm");
            im.src = imag;
            $(d).append(del);
            $(d).append(im);

            $("#imgCon").append(d);

            //$(d4).append($(element).removeClass("imgc").addClass("imga"));
        });

        isE = idx;

        addModal.show();


    }

    function initMap(locat) {
        let mapOptions = {
            center: locat,
            zoom: 12,
            maxBounds: [[-19.3233, -62.5671], [-27.5392, -54.3054]]
        };

        map = new L.map('map', mapOptions);

        let layer = new L.TileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
            minZoom: 12,
            bounds: [[-19.3233, -62.5671], [-27.5392, -54.3054]]
        });
        map.addLayer(layer);

        circ = L.circle(map.getCenter(), {radius: 1000}).addTo(map);


        /*map.on('click', (event) => {
         
         if (marker !== null) {
         map.removeLayer(marker);
         }
         
         marker = L.marker([event.latlng.lat, event.latlng.lng]).addTo(map);
         
         document.getElementById('latitude').value = event.latlng.lat;
         document.getElementById('longitude').value = event.latlng.lng;
         
         });*/


        map.on('move', (event) => {

            map.removeLayer(circ);
            circ = L.circle(map.getCenter(), {radius: 1000}).addTo(map);

        });

    }



    function delImg(elem) {
        $(elem).parent().remove();
    }




    function cargarEsp() {
        $.ajax(
                {
                    url: "/api/buscar/especies",
                    data: {opt: "list"},
                    type: "post",
                    success: function (response) {
                        let res = JSON.parse(response);
                        res.forEach(function (obj) {
                            let op = document.createElement("option");
                            op.value = obj["id"];
                            op.innerHTML = obj["nombre"];
                            $("#mdEspecie").append(op);
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
                        $("#mdRaza").html("");
                        res.forEach(function (obj) {
                            let op = document.createElement("option");
                            op.value = obj["id"];
                            op.innerHTML = obj["nombre"];
                            $("#mdRaza").append(op);
                        });

                        if (ciu != "0") {
                            $("#mdRaza").val(ciu);
                        }

                    }
                }
        );
    }



    $('#mdEspecie').on('change', function (e) {
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




    function getLoc() {


        $.ajax({
            url: "https://ipinfo.io/json",
            type: "GET",
            crossDomain: true,
            success: function (json) {
                const myLatLng = [parseFloat(json.loc.split(",")[0]), parseFloat(json.loc.split(",")[1])];
                initMap(myLatLng);

            },
            error: function (e) {
                console.log(e);
            }
        });
    }









    cargarEsp();
    cargarRazas("1", "0");
    cargarDep();
    getLoc();
    //cargarCiu("1", "0");
    //cargarBarr("1", "0");



</script>




<script>
    function mostrarMensaje(mensaje) {
        if (mensaje["success"]) {
            //location.href= "/dashboard/inicio";
            //$("#confirmation-modal").modal("show");
            $("#contenid").addClass("d-none");
            $("#mensajeconf").removeClass("d-none");
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


    function valido() {
        if ($("#descripcion").val().trim() === "") {
            mostrarMensaje({"success": false, "estado": "warning", "mensaje": "AGREGUE INFORMACION ADICIONAL"});
            return false;
        }
        if ($("#contacto").val().trim() === "") {
            mostrarMensaje({"success": false, "estado": "warning", "mensaje": "AGREGUE SU NUMERO DE CONTACTO"});
            return false;
        }
        if ($("#cbrecom").is(":checked")) {
            if ($("#recomp").val().trim() === "") {
                mostrarMensaje({"success": false, "estado": "warning", "mensaje": "AGREGUE LA RECOMPENSA"});
                return false;
            }
        }
        if (psts.length < 1) {
            mostrarMensaje({"success": false, "estado": "warning", "mensaje": "AGREGUE UNA MASCOTA"});
            return false;
        }
        return true;
    }


    function validar() {
        const re = /^09[6-9][1-6][0-9]{6}$/g;
        if (!re.test($("#contacto").val().trim())) {
            mostrarMensaje({"estado": "warning", "mensaje": "INGRESE UN TELEFONO VALIDO"});
            return false;
        }
        return true;
    }





    function validoMasc() {
        if ($("#mdNombre").val().trim() === "") {
            mostrarMensaje({"success": false, "estado": "warning", "mensaje": "AGREGUE NOMBRE DE LA MASCOTA"});
            return false;
        }
        if ($("#mdDescripcion").val().trim() === "") {
            mostrarMensaje({"success": false, "estado": "warning", "mensaje": "AGREGUE DESCRIPCION DE LA MASCOTA"});
            return false;
        }
        if (Array.from(document.getElementsByClassName("imgm")).length < 1) {
            mostrarMensaje({"success": false, "estado": "warning", "mensaje": "AGREGUE UNA FOTO DE LA MASCOTA"});
            return false;
        }
        return true;
    }
</script>




<script>

    function enviarDat() {

        if (!valido()) {
            return;
        }
        if (!validar()) {
            return;
        }

        let sPost = {
            departamento: $("#departamentos").val(),
            ciudad: $("#ciudades").val(),
            barrio: $("#barrios").val(),
            info: $("#descripcion").val(),
            contacto: $("#contacto").val(),
            lat: map.getCenter()["lat"].toString(),
            long: map.getCenter()["lng"].toString(),
            recomp: false
        };
        sPost["mascotas"] = psts;
        if ($("#cbrecom").is(":checked")) {
            sPost["recomp"] = true;
            sPost["recompensa"] = $("#recomp").val();
        }

        $.ajax({
            url: "/perdidos/add",
            data: JSON.stringify(sPost),
            contentType: "application/json; charset=utf-8",
            type: "POST",
            crossDomain: true,
            success: function (json) {
                let res = JSON.parse(json);
                mostrarMensaje(res);
            },
            error: function (e) {
                console.log(e);
            }
        });


    }
</script>


<%@include file="footer.jsp" %>  