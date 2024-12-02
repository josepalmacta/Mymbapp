<%-- 
    Document   : encontrados
    Created on : 10 sept 2024, 14:02:46
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
        
</style>

<div class="modal fade" id="confirmation-modalaprobar" tabindex="2" role="dialog" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-body text-center font-18">
                <h4 class="padding-top-30 mb-30 weight-500">¿Desea Aprobar esta Publicacion?</h4>
                <div class="padding-bottom-30 row" style="max-width: 170px; margin: 0 auto;">
                    <div class="col-6">
                        <button type="button" class="btn btn-secondary border-radius-100 btn-block confirmation-btn" data-dismiss="modal"><i class="fa fa-times"></i></button>
                        NO
                    </div>
                    <div class="col-6">
                        <button type="button" class="btn btn-primary border-radius-100 btn-block confirmation-btn" data-dismiss="modal" onclick="eliminar('aprobar')"><i class="fa fa-check"></i></button>
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
    <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable" role="document">
        <div class="modal-content">
            <div class="modal-body">
                <div id="contenid">
                    
                </div>
            </div>
            <div class="modal-footer">
                <button data-toggle="modal" data-target="#confirmation-modaldel" type="button" class="btn btn-secondary" data-dismiss="modal">ELIMINAR</button>
                <button id="btnaprob" data-toggle="modal" data-target="#confirmation-modalaprobar" data-dismiss="modal" type="button" class="btn btn-primary">APROBAR</button>
            </div>
        </div>
    </div> 
</div>


<div class="pd-20 card-box mb-30">
    <div class="clearfix">
        <div class="pull-left">
            <h4 class="text-blue h4">GESTIONAR PUBLICACIONES DE MASCOTAS ENCONTRADAS</h4>
        </div>      
    </div>
</div>

<div class="card-box mb-30">  
    <div class="py-3">
        <input type="hidden" id="postid" value="">
        <a type="button" class="btn btn-primary" style="margin-left: 15px;" target="_blank" href="/reporte.jsp?reporte=encontrados"><i class="fa-regular fa-file"></i> REPORTE</a>
    </div>
    <div class="pb-20">
        <table class="data-table table stripe hover nowrap">
            <thead>
                <tr>
                    <th>#</th>
                    <th>USUARIO</th>
                    <th>FECHA</th>
                    <th>ESTADO</th>
                    <th class="datatable-nosort">ACCION</th>
                </tr>
            </thead>
            <tbody id="tablacontenido">

            </tbody>
        </table>
    </div>
</div>

<script src="/src/vender/bootstrap/js/bootstrap.bundle.min.js" type="text/javascript"></script>

<script src="/src/vender/jquery/jquery.min.js" type="text/javascript"></script>

<script type="text/javascript">
    $(document).ready(function () {

        cargarTabla();
    });




    function cargarTabla() {
        $("#codigo").val("");
        $.ajax(
                {
                    url: "/gestionar/encontrados",
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





    function transferir(id) {
        $("#postid").val(id);
        $.ajax(
                {
                    data: {opt: "post", codigo: id},
                    url: "/gestionar/encontrados",
                    type: "post",
                    success: function (response) {
                        $("#contenid").html(response);
                    }
                }
        );
    }



    function eliminar(accion) {
        let id = $("#postid").val();
        $.ajax(
                {
                    data: {opt: accion, codigo: id},
                    url: "/gestionar/encontrados",
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

