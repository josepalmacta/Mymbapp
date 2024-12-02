<%-- 
    Document   : ventas
    Created on : 29 ago 2024, 9:23:11
    Author     : Usuario
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@include file="../header.jsp" %>  


<style>
    .carousel-item, .carousel{
        width: 100%;
        height: 300px;
    }

    .carousel-item img{
        object-fit: cover;
    }


    .dets{
        text-align: left;
        align-items: start;
    }
    .modal-fullscreen {
        width: 100vw;
        max-width: none;
        height: 100%;
    }

</style>

<div class="modal fade" id="confirmation-modalacciones" tabindex="2" role="dialog" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-body text-center font-18">
                <h4 id="mensajee" class="padding-top-30 mb-30 weight-500">¿Desea Enviar este pedido?</h4>
                <div class="padding-bottom-30 row" style="max-width: 170px; margin: 0 auto;">
                    <div class="col-6">
                        <button type="button" class="btn btn-secondary border-radius-100 btn-block confirmation-btn" data-dismiss="modal"><i class="fa fa-times"></i></button>
                        NO
                    </div>
                    <div class="col-6">
                        <button type="button" class="btn btn-primary border-radius-100 btn-block confirmation-btn" data-dismiss="modal" onclick="acciones()"><i class="fa fa-check"></i></button>
                        SI
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>


<div class="modal fade" id="confirmation-modaldel" tabindex="1" role="dialog" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-body text-center font-18">
                <h4 class="padding-top-30 mb-30 weight-500">¿Desea eliminar esta Publicacion?</h4>
                <div class="padding-bottom-30 row" style="max-width: 170px; margin: 0 auto;">
                    <div class="col-6">
                        <button type="button" class="btn btn-secondary border-radius-100 btn-block confirmation-btn" data-dismiss="modal"><i class="fa fa-times"></i></button>
                        NO
                    </div>
                    <div class="col-6">
                        <button type="button" class="btn btn-primary border-radius-100 btn-block confirmation-btn" data-dismiss="modal" onclick="eliminar('del')"><i class="fa fa-check"></i></button>
                        SI
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>



<div class="modal fade" id="form-modal" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog modal-fullscreen modal-dialog-scrollable" role="document">
        <div class="modal-content">
            <div class="modal-body text-center font-18">
                <div id="contenid">

                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">CERRAR</button>
                <button id="btnacciones" data-toggle="modal" data-target="#confirmation-modalacciones" data-dismiss="modal" type="button" class="btn btn-primary">ENVIAR PEDIDO</button>
            </div>
        </div>
    </div> 
</div>


<div class="pd-20 card-box mb-30">
    <div class="clearfix">
        <div class="pull-left">
            <h4 class="text-blue h4">GESTIONAR VENTAS</h4>
        </div>
    </div>
</div>

<div class="card-box mb-30">  
    <div class="py-3">
        <input type="hidden" id="ventid" value="">
        <input type="hidden" id="accion" value="">
        <input type="hidden" id="currtab" value="finalizado">
        <a type="button" class="btn btn-primary" style="margin-left: 15px;" target="_blank" href="/reporte.jsp?reporte=ventas"><i class="fa-regular fa-file"></i> REPORTE</a>
    </div>
    <div class="pb-20">

        <div class="tab">
            <ul class="nav nav-tabs customtab mb-20" role="tablist">
                <li class="nav-item">
                    <a onclick="cargarTabla('finalizado')" class="nav-link active" data-toggle="tab" href="#home2" role="tab" aria-selected="true">PENDIENTE</a>
                </li>
                <li class="nav-item">
                    <a onclick="cargarTabla('enviado')" class="nav-link" data-toggle="tab" href="#home2" role="tab" aria-selected="false">ENVIADO</a>
                </li>
                <li class="nav-item">
                    <a onclick="cargarTabla('entregado')" class="nav-link" data-toggle="tab" href="#home2" role="tab" aria-selected="false">ENTREGADO</a>
                </li>
            </ul>
            <div class="tab-content">
                <div class="tab-pane fade show active" id="home2" role="tabpanel">
                    <div class="pd-20">
                        <table id="tablaa" class="data-table table stripe hover nowrap">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>CLIENTE</th>
                                    <th>FECHA</th>
                                    <th>TOTAL</th>
                                    <th>ESTADO</th>
                                    <th class="datatable-nosort">ACCION</th>
                                </tr>
                            </thead>
                            <tbody id="tablacontenido">

                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>





    </div>
</div>

<script src="/src/vender/bootstrap/js/bootstrap.bundle.min.js" type="text/javascript"></script>

<script src="/src/vender/jquery/jquery.min.js" type="text/javascript"></script>

<script type="text/javascript">
                        var tablee = null;
                        $(document).ready(function () {
                            cargarTabla($("#currtab").val());
                        });



                        function rsetTabl() {
                            if (tablee) {
                                $("#tablacontenido").html("");
                                tablee.clear();
                                tablee.destroy();
                                tablee = null;
                            }
                        }




                        function cargarTabla(estado) {
                            $("#codigo").val("");
                            $("#currtab").val(estado);
                            rsetTabl();
                            $.ajax(
                                    {
                                        url: "/gestionar/ventas",
                                        data: {opt: estado},
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
                            $("#codigo").val("");
                            $("#nombre").val("");
                            $("#code").val("");
                        }



                        function dataTab() {
                            tablee = $('#tablaa').DataTable({
                                destroy: true,
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

                            tablee.draw();
                        }





                        function transferir(id, accion) {
                            $("#ventid").val(id);
                            $("#accion").val(accion);
                            if (accion === 'enviar') {
                                $("#btnacciones").html("ENVIAR PEDIDO");
                                $("#mensajee").html("¿Desea enviar este pedido?<br>El estado cambiara a ENVIADO.");
                            }
                            if (accion === 'entregar') {
                                $("#btnacciones").html("ENTREGADO");
                                $("#mensajee").html("¿Desea cambiar el estado de este pedido a ENTREGADO?");
                            }
                            if (accion === 'anular') {
                                $("#btnacciones").html("ANULAR");
                                $("#mensajee").html("¿Desea anular este pedido?");
                            }
                            $.ajax(
                                    {
                                        data: {opt: "venta", codigo: id},
                                        url: "/gestionar/ventas",
                                        type: "post",
                                        success: function (response) {
                                            $("#contenid").html(response);
                                        }
                                    }
                            );
                        }

                        function acciones() {
                            let accion = $("#accion").val();
                            let id = $("#ventid").val();
                            $.ajax(
                                    {
                                        data: {opt: accion, codigo: id},
                                        url: "/gestionar/ventas",
                                        type: "post",
                                        success: function (response) {
                                            $("#confirmation-modalacciones").modal('hide');
                                            let res = JSON.parse(response);
                                            mostrarMensaje(res);
                                            cargarTabla($("#currtab").val());
                                        }
                                    }
                            );
                        }







                        function eliminar(accion) {
                            let id = $("#ventid").val();
                            $.ajax(
                                    {
                                        data: {opt: accion, codigo: id},
                                        url: "/gestionar/perdidos",
                                        type: "post",
                                        success: function (response) {
                                            let mdl = '#confirmation-modal' + accion;
                                            console.log(mdl);
                                            $(mdl).modal('hide');
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
                            let code = $("#code").val().trim();
                            let codigo = $("#codigo").val();
                            let opt = "edit";

                            if (codigo === "") {
                                opt = "add";
                            }

                            $.ajax(
                                    {
                                        data: {opt: opt, nombre: nombre, code: code, codigo: codigo},
                                        url: "/gestionar/departamentos",
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
                            if ($("#code").val().trim() === "") {
                                return false;
                            }
                            return true;
                        }





</script>




<%@include file="../footer.jsp" %> 

