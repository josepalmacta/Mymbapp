<%-- 
    Document   : informes
    Created on : 10 oct 2024, 19:46:07
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
            <h4 class="text-blue h4">GENERAR INFORME DE VENTAS</h4>
        </div>
    </div>
</div>

<div class="card-box mb-30">  
    <div class="p-3">
        <input type="hidden" id="ventid" value="">
        <input type="hidden" id="accion" value="">
        <input type="hidden" id="currtab" value="finalizado">
    </div>
    <div class="pb-20">

        <div class="tab">
            <ul class="nav nav-tabs customtab mb-20" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" data-toggle="tab" href="#ventas" role="tab" aria-selected="true">Informe General</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-toggle="tab" href="#ventasdetallado" role="tab" aria-selected="false">Informe Detallado</a>
                </li>                
            </ul>
            <div class="tab-content">
                <div class="tab-pane fade show active" id="ventas" role="tabpanel">
                    <div class="pd-20">
                        <div class="clearfix">
                            <div class="d-flex">
                                <div class="d-block">
                                    <div class="d-flex">
                                        <div class="d-block">
                                            <label>Desde:</label>
                                            <input class="form-control" type="date" id="desde">
                                        </div>
                                        <div class="d-block mx-5">
                                            <label>Hasta:</label>
                                            <input class="form-control" type="date" id="hasta">
                                        </div>
                                    </div>
                                    <div class="d-block">
                                        <button class="btn btn-primary my-3" onclick="genInforme($('#desde').val(), $('#hasta').val(), $('#estados').val(), $('#clientes').val())"><i class="fa-regular fa-file"></i> INFORME</button>
                                    </div>
                                </div>
                                <div class="d-block">
                                    <div class="d-flex">
                                        <div class="d-block">
                                            <label >Estado:</label>
                                            <select id="estados" class="form-control">
                                                <option value="TODOS">TODOS</option>
                                                <option value="FINALIZADO">FINALIZADO</option>
                                                <option value="ENVIADO">ENVIADO</option>
                                                <option value="ENTREGADO">ENTREGADO</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>


                                <div class="d-block mx-5">
                                    <div class="d-flex">
                                        <div class="d-block">
                                            <label >Cliente:</label>
                                            <select id="clientes" class="form-control">
                                                <option value="TODOS">TODOS</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                
                
                
                
                
                
                
                <div class="tab-pane fade" id="ventasdetallado" role="tabpanel">
                    <div class="pd-20">
                        <div class="clearfix">
                            <div class="d-flex">
                                <div class="d-block">
                                    <div class="d-flex">
                                        <div class="d-block">
                                            <label>Desde:</label>
                                            <input class="form-control" type="date" id="desdedet">
                                        </div>
                                        <div class="d-block mx-5">
                                            <label>Hasta:</label>
                                            <input class="form-control" type="date" id="hastadet">
                                        </div>
                                    </div>
                                    <div class="d-block">
                                        <button class="btn btn-primary my-3" onclick="genDetInforme($('#desdedet').val(), $('#hastadet').val(), $('#productos').val())"><i class="fa-regular fa-file"></i> INFORME</button>
                                    </div>
                                </div>
                                
                                <div class="d-block mx-5">
                                    <div class="d-flex">
                                        <div class="d-block">
                                            <label >Producto:</label>
                                            <select id="productos" class="form-control">
                                                <option value="TODOS">TODOS</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>            
        </div>





    </div>
</div>

<script src="/src/vender/bootstrap/js/bootstrap.bundle.min.js" type="text/javascript"></script>

<script src="/src/vender/jquery/jquery.min.js" type="text/javascript"></script>

<script type="text/javascript">
                                            $(document).ready(function () {
                                                cargarClientes();
                                                cargarProductos();
                                            });
                                            
                                            
                                            function crearOpt(value, text){
                                                let op = document.createElement("option");
                                                op.value = value;
                                                op.innerHTML = text;
                                                return op;
                                            }

                                            function cargarClientes() {
                                                $.ajax(
                                                        {
                                                            url: "/api/buscar/clientes",
                                                            type: "post",
                                                            success: function (response) {
                                                                console.log(response);
                                                                let res = JSON.parse(response);
                                                                res.forEach(function (obj) {
                                                                    $("#clientes").append(crearOpt(obj["id"],obj["nombre"]));
                                                                    $("#usuariosp").append(crearOpt(obj["id"],obj["nombre"]));
                                                                    $("#usuariose").append(crearOpt(obj["id"],obj["nombre"]));
                                                                    $("#usuariosa").append(crearOpt(obj["id"],obj["nombre"]));
                                                                });
                                                            }
                                                        }
                                                );
                                            }
                                            
                                            
                                            function cargarProductos() {
                                                $.ajax(
                                                        {
                                                            url: "/api/buscar/productos",
                                                            type: "post",
                                                            success: function (response) {
                                                                console.log(response);
                                                                let res = JSON.parse(response);
                                                                res.forEach(function (obj) {
                                                                    $("#productos").append(crearOpt(obj["id"],obj["nombre"]));                           
                                                                });
                                                            }
                                                        }
                                                );
                                            }

                                            function genInforme(desde, hasta, estado, cliente) {
                                                let waurl = "/informe.jsp?informe=ventas&desde=" + desde + "&hasta=" + hasta + "&estado=" + estado + "&cliente=" + cliente;
                                                window.open(waurl, '_blank').focus();
                                            }
                                            
                                            function genDetInforme(desde, hasta, cliente) {
                                                let waurl = "/informe.jsp?informe=ventasdetallado&desde=" + desde + "&hasta=" + hasta + "&producto=" + cliente;
                                                window.open(waurl, '_blank').focus();
                                            }




</script>

<%@include file="../footer.jsp" %> 


