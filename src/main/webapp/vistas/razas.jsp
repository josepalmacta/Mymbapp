<%-- 
    Document   : razas
    Created on : 4 jun 2024, 14:04:57
    Author     : Usuario
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@include file="../header.jsp" %>  




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
                <h4 class="padding-top-30 mb-30 weight-500">RAZA</h4>
                <form>
                    <input type="hidden" id="codigo">
                    <div class="form-group row">
                        <label class="col-sm-12 col-md-2 col-form-label">NOMBRE</label>
                        <div class="col-sm-12 col-md-10">
                            <input id="nombre" class="form-control" type="text" maxlength="15" placeholder="NOMBRE">
                        </div>
                    </div>

                    <div class="form-group row">
                        <label class="col-sm-12 col-md-2 col-form-label">ESPECIE</label>
                        <div class="col-sm-12 col-md-10">
                            <select class="custom-select" id="especies" name="especie">                    
                            </select>
                        </div>
                    </div>

                    <div class="form-group p-3">
                        <button type="button" class="btn btn-primary" onclick="sendData()"><i class="fa-solid fa-check"></i> GUARDAR</button>
                        <button type="button" class="btn btn-secondary" data-toggle="modal" data-target="#form-modal" onclick="limpiar()"><i class="fa-solid fa-xmark"></i> CANCELAR</button>
                    </div>

                </form>
            </div>
        </div>
    </div> 
</div>


<div class="pd-20 card-box mb-30">
    <div class="clearfix">
        <div class="pull-left">
            <h4 class="text-blue h4">GESTIONAR RAZAS</h4>
        </div>
    </div>
</div>


<div class="card-box mb-30">
    <div class="pd-20">
        <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#form-modal" onclick="limpiar()"><i class="fa-solid fa-plus"></i> NUEVO</button>
        <a type="button" class="btn btn-primary" style="margin-left: 15px;" target="_blank" href="/reporte.jsp?reporte=razas"><i class="fa-regular fa-file"></i> REPORTE</a>
    </div>
    <div class="pb-20">
        <table class="data-table table stripe hover nowrap">
            <thead>
                <tr>
                    <th>#</th>
                    <th>NOMBRE</th>
                    <th>ESPECIE</th>
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

        cargarEsp();

    });




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






    function cargarTabla() {
        $("#codigo").val("");
        $.ajax(
                {
                    url: "/gestionar/razas",
                    type: "post",
                    success: function (response) {
                        $("#tablacontenido").html(response);
                        dataTab();
                    }
                }
        );
        limpiar();
    }



    function cargarEsp() {
        $.ajax(
                {
                    url: "/gestionar/especies",
                    data: {opt: "list"},
                    type: "post",
                    success: function (response) {
                        console.log(response);
                        let res = JSON.parse(response);
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



    function limpiar() {
        $("#codigo").val("");
        $("#nombre").val("");
    }





    function transferir(id, nombre, espe) {
        $("#codigo").val(id);
        $("#nombre").val(nombre);
        $("#especies").val(espe);
        $("#nombre").focus();
    }



    function eliminar() {
        let id = $("#codigo").val();
        $.ajax(
                {
                    data: {opt: "del", codigo: id},
                    url: "/gestionar/razas",
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
            mostrarMensaje({"estado": "warning", "mensaje": "COMPLETE TODOS CAMPOS!"});
            return;
        }

        $('#form-modal').modal('hide');



        let nombre = $("#nombre").val().trim();
        let codigo = $("#codigo").val();
        let especie = $("#especies").val();
        let opt = "edit";

        if (codigo === "") {
            opt = "add";
        }

        $.ajax(
                {
                    data: {opt: opt, nombre: nombre, codigo: codigo, especie: especie},
                    url: "/gestionar/razas",
                    type: "post",
                    success: function (response) {
                        let res = JSON.parse(response);
                        mostrarMensaje(res);
                        cargarTabla();
                    }
                }
        );
    }



    function valido() {
        if ($("#nombre").val().trim() === "") {
            return false;
        }
        return true;
    }



</script>




<%@include file="../footer.jsp" %> 


