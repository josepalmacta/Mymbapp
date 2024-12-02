<%-- 
    Document   : productos
    Created on : 10 ago 2024, 18:14:41
    Author     : Usuario
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@include file="../header.jsp" %>  

<style>
    .imgl {
        width: 80px !important;
        height: 80px !important;
        object-fit: cover !important;
    }
    .badge2 {
        position: absolute;
        bottom: 2px;
        right: 2px;
        z-index: 1;

        padding: 1px 6px 1px 6px;

        border-style: none;

        border-radius: 2px;

        font-size: 11px;
        font-weight: bold;
        text-transform: uppercase;
        color: white;
        background-color: #1b00ff;
    }
    .ms-1{
        margin-left: 15px;
    }
</style>

<div class="modal fade" id="confirmation-modal" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-body text-center font-18">
                <h4 class="padding-top-30 mb-30 weight-500">¿Desea eliminar este registro?</h4>
                <div class="padding-bottom-30 row" style="max-width: 170px; margin: 0 auto;">
                    <div class="col-6">
                        <button type="button" class="btn btn-secondary border-radius-100 btn-block confirmation-btn" data-dismiss="modal"><i class="fa fa-times"></i></button>
                        NO
                    </div>
                    <div class="col-6">
                        <button type="button" class="btn btn-primary border-radius-100 btn-block confirmation-btn" onclick="eliminar()"><i class="fa fa-check"></i></button>
                        SI
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>



<div class="modal fade" id="form-modal" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-body text-center font-18">
                <h4 class="padding-top-30 mb-30 weight-500">PRODUCTO</h4>
                <div>
                    <input type="hidden" id="codigo">
                    <div class="form-group row">
                        <label class="col-sm-12 col-md-2 col-form-label">NOMBRE</label>
                        <div class="col-sm-12 col-md-10">
                            <input id="nombre" class="form-control" type="text" maxlength="20" placeholder="NOMBRE">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-12 col-md-2 col-form-label">DESCRIPCION</label>
                        <div class="col-sm-12 col-md-10">
                            <textarea id="descripcion" rows="3" class="form-control" type="text" placeholder="DESCRIPCION DEL PRODUCTO"></textarea>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-12 col-md-2 col-form-label">PRECIO</label>
                        <div class="col-sm-12 col-md-10">
                            <input id="precio" class="form-control" maxlength="8" placeholder="PRECIO" type="number">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-12 col-md-2 col-form-label">STOCK</label>
                        <div class="col-sm-12 col-md-10">
                            <input id="stock" maxlength="5" class="form-control" placeholder="STOCK" type="number">
                        </div>
                    </div>

                    <div class="form-group row">
                        <label class="col-sm-12 col-md-2 col-form-label">IMAGENES</label>
                    </div>

                    <div class="form-group row">                     
                        <button id="mdAddImg" type="button" class="btn btn-primary rounded-pill ms-1">AGREGAR IMAGEN <i
                                class="fa-solid fa-plus"></i></button>
                    </div>

                    <div class="form-group row">
                        <div class="col-sm-12 col-md-10">
                            <input onchange="read(this)" id="file-input" type="file" accept="image/*" name="name" style="display: none;" />
                            <div id="imgCon" class="input-group d-flex">
                            </div>
                        </div>
                    </div>

                    <div class="form-group p-3">
                        <button type="button" class="btn btn-primary" onclick="addProducto()">GUARDAR</button>
                        <button type="button" class="btn btn-secondary" data-toggle="modal" data-target="#form-modal" onclick="limpiar()"><i class="fa-solid fa-xmark"></i> CANCELAR</button>
                    </div>
                </div>
            </div>
        </div>
    </div> 
</div>


<div class="pd-20 card-box mb-30">
    <div class="clearfix">
        <div class="pull-left">
            <h4 class="text-blue h4">GESTIONAR DEPARTAMENTOS</h4>
        </div>
    </div>
</div>

<div class="card-box mb-30">  
    <div class="p-3">
        <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#form-modal" onclick="limpiar()"><i class="fa-solid fa-plus"></i> NUEVO</button>
        <a type="button" class="btn btn-primary" style="margin-left: 15px;" target="_blank" href="/reporte.jsp?reporte=prodductos"><i class="fa-regular fa-file"></i> REPORTE</a>
    </div>
    <div class="pb-20">
        <table class="data-table table stripe hover nowrap">
            <thead>
                <tr>
                    <th class="datatable-nosort"><i class="fa-solid fa-camera"></i></th>
                    <th>NOMBRE</th>
                    <th>DESCRIPCION</th>
                    <th>PRECIO</th>
                    <th>STOCK</th>
                    <th class="datatable-nosort">ACCION</th>
                </tr>
            </thead>
            <tbody id="tablacontenido">

            </tbody>
        </table>
    </div>
</div>


<script type="text/javascript">
    $(document).ready(function () {

        cargarTabla();
    });

    var isE = -1;

    var det = null;



    $('#mdAddImg').on('click', function () {
        $('#file-input').trigger('click');
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

    function readEdit(val) {
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
        reader.readAsDataURL(val);

    }



    function addProducto() {



        /*if (!validoProd()) {
         return;
         }*/





        det = {
            "nombre": $("#nombre").val(),
            "descripcion": $("#descripcion").val(),
            "precio": $("#precio").val(),
            "stock": $("#stock").val()
        };

        let ims = [];
        Array.from(document.getElementsByClassName("imgm")).forEach(element => {
            ims.push(element.src);
        });

        det["imgs"] = ims;

        if (isE !== -1) {
            det["codigo"] = $("#codigo").val();
        }
        
        console.log(det);


        sendData();

    }












    function cargarTabla() {
        $("#codigo").val("");
        $.ajax(
                {
                    url: "/gestionar/productos/list",
                    type: "post",
                    success: function (response) {
                        $("#tablacontenido").html(response);
                        dataTab();
                    }
                }
        );
        limpiar();
    }



    function limpiar() {
        isE = -1;
        $("#codigo").val("");
        $("#nombre").val("");
        $("#descripcion").val("");
        $("#precio").val("");
        $("#stock").val("");
        $("#imgCon").html("");
    }
    
    function delImg(elem) {
        $(elem).parent().remove();
    }



    function dataTab() {
        if ($.fn.dataTable.isDataTable('.data-table')) {
            $('.data-table').destroy();
        }
        $('.data-table').DataTable({
            scrollCollapse: true,
            autoWidth: false,
            responsive: true,
            columnDefs: [{
                    targets: "datatable-nosort",
                    orderable: false
                }],
            "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
            "language": {
                "info": "_START_ a _END_ de _TOTAL_ registros",
                searchPlaceholder: "Filtro",
                paginate: {
                    next: '<i class="ion-chevron-right"></i>',
                    previous: '<i class="ion-chevron-left"></i>'
                }
            }
        });
    }





    function transferir(id, nombre, descripcion, precio, stock, imgs) {
        $("#codigo").val(id);
        $("#nombre").val(nombre);
        $("#descripcion").val(descripcion);
        $("#precio").val(precio);
        $("#stock").val(stock);
        $("#nombre").focus();
        isE = 2;
        let lst = JSON.parse(atob(imgs));
        lst.forEach((element) => {
            let url = element["path"];
            url = url.replaceAll("--", "/");
            console.log(url);
            $.ajax(
                    {
                        url: url,
                        xhrFields: {
                            responseType: 'blob'
                        },
                        success: function (response) {
                            readEdit(response);
                        }
                    }
            );
        });
    }



    function eliminar() {
        let id = $("#codigo").val();
        $.ajax(
                {
                    data: JSON.stringify({"codigo": id}),
                    url: "/gestionar/productos/del",
                    contentType: "application/json; charset=utf-8",
                    type: "post",
                    success: function (response) {
                        $('#confirmation-modal').modal('hide');
                        let res = JSON.parse(response);
                        mostrarMensaje(res);
                        cargarTabla();
                    }
                }
        );
    }


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


    function sendData() {


        if (!valido()) {
         return;
        }

        $('#form-modal').modal('hide');



        let codigo = $("#codigo").val();
        let opt = "edit";

        if (codigo === "") {
            opt = "add";
        }

        let url = "/gestionar/productos/" + opt;

        $.ajax({
            url: url,
            data: JSON.stringify(det),
            contentType: "application/json; charset=utf-8",
            type: "POST",
            crossDomain: true,
            success: function (json) {
                let res = JSON.parse(json);
                mostrarMensaje(res);
                cargarTabla();
            },
            error: function (e) {
                console.log(e);
            }
        });
    }





    function valido() {
        if ($("#nombre").val().trim() === "" || $("#descripcion").val().trim() === "" || $("#precio").val().trim() === "" || $("#stock").val().trim() === "") {
            mostrarMensaje({"estado": "warning", "mensaje": "COMPLETE TODOS CAMPOS!"});
            return false;
        }
        if (det["imgs"].length < 1) {
            mostrarMensaje({"estado": "warning", "mensaje": "AGREGUE UNA IMAGEN!"});
            return false;
        }
        return true;
    }





</script>

<%@include file="../footer.jsp" %> 