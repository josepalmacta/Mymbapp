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
            <h4 class="text-blue h4">GENERAR INFORMES</h4>
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
                    <a class="nav-link active" data-toggle="tab" href="#ventas" role="tab" aria-selected="true">Ventas</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-toggle="tab" href="#ventasdetallado" role="tab" aria-selected="false">Ventas Productos</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-toggle="tab" href="#perdidos" role="tab" aria-selected="false">Mascotas Perdidas</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-toggle="tab" href="#perdidosdet" role="tab" aria-selected="false">Mascotas Perdidas Det</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-toggle="tab" href="#encontrados" role="tab" aria-selected="false">Mascotas Encontradas</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-toggle="tab" href="#encontradosdet" role="tab" aria-selected="false">Mascotas Perdidas Det</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-toggle="tab" href="#adopcion" role="tab" aria-selected="false">Mascotas en Adopcion</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-toggle="tab" href="#adopciondet" role="tab" aria-selected="false">Mascotas Perdidas Det</a>
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







                <div class="tab-pane fade" id="perdidos" role="tabpanel">
                    <div class="pd-20">
                        <div class="clearfix">
                            <div class="d-flex">
                                <div class="d-block">
                                    <div class="d-flex">
                                        <div class="d-block">
                                            <label>Desde:</label>
                                            <input class="form-control" type="date" id="desdep">
                                        </div>
                                        <div class="d-block mx-5">
                                            <label>Hasta:</label>
                                            <input class="form-control" type="date" id="hastap">
                                        </div>
                                    </div>                                    
                                </div>
                                <div class="d-block">
                                    <div class="d-flex">
                                        <div class="d-block">
                                            <label >Estado:</label>
                                            <select id="estadosp" class="form-control">
                                                <option value="TODOS">TODOS</option>
                                                <option value="PERDIDO">PERDIDO</option>
                                                <option value="LOCALIZADO">LOCALIZADO</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>


                                <div class="d-block mx-5">
                                    <div class="d-flex">
                                        <div class="d-block">
                                            <label >Usuario:</label>
                                            <select id="usuariosp" class="form-control">
                                                <option value="TODOS">TODOS</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>         
                            </div>


                            <div class="d-flex my-5">
                                <div class="d-block">
                                    <div class="d-flex">
                                        <div class="d-block">
                                            <label >Departamento:</label>
                                            <select id="departamentos" class="form-control">
                                            </select>
                                        </div>
                                    </div>
                                </div>


                                <div class="d-block mx-5">
                                    <div class="d-flex">
                                        <div class="d-block">
                                            <label>Ciudad:</label>
                                            <select id="ciudades" class="form-control">
                                                <option value="-1">TODOS</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>


                                <div class="d-block">
                                    <div class="d-flex">
                                        <div class="d-block">
                                            <label>Barrios:</label>
                                            <select id="barrios" class="form-control">
                                                <option value="-1">TODOS</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div> 



                            <div class="d-flex">
                                <div class="d-block">
                                    <button class="btn btn-primary my-3" onclick="postsInforme($('#desdep').val(), $('#hastap').val(), $('#estadosp').val(), $('#usuariosp').val(), $('#departamentos').val(), $('#ciudades').val(), $('#barrios').val(), 'perdidos')"><i class="fa-regular fa-file"></i> INFORME</button>
                                </div>
                            </div>





                        </div>
                    </div>
                </div>
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                <div class="tab-pane fade" id="perdidosdet" role="tabpanel">
                    <div class="pd-20">
                        <div class="clearfix">
                            <div class="d-flex">
                                <div class="d-block">
                                    <div class="d-flex">
                                        <div class="d-block">
                                            <label>Desde:</label>
                                            <input class="form-control" type="date" id="desdepdet">
                                        </div>
                                        <div class="d-block mx-5">
                                            <label>Hasta:</label>
                                            <input class="form-control" type="date" id="hastapdet">
                                        </div>
                                    </div>                                    
                                </div>
                                


                                <div class="d-block mx-5">
                                    <div class="d-flex">
                                        <div class="d-block">
                                            <label >Especie:</label>
                                            <select id="especiep" class="form-control">
                                                <option value="TODOS">TODOS</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>         
                            </div>


                            



                            <div class="d-flex">
                                <div class="d-block">
                                    <button class="btn btn-primary my-3" onclick="postsInformeDet($('#desdepdet').val(), $('#hastapdet').val(), $('#especiep').val(),'perdidosdetallado')"><i class="fa-regular fa-file"></i> INFORME</button>
                                </div>
                            </div>





                        </div>
                    </div>
                </div>
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                <div class="tab-pane fade" id="encontrados" role="tabpanel">
                    <div class="pd-20">
                        <div class="clearfix">
                            <div class="d-flex">
                                <div class="d-block">
                                    <div class="d-flex">
                                        <div class="d-block">
                                            <label>Desde:</label>
                                            <input class="form-control" type="date" id="desdee">
                                        </div>
                                        <div class="d-block mx-5">
                                            <label>Hasta:</label>
                                            <input class="form-control" type="date" id="hastae">
                                        </div>
                                    </div>                                    
                                </div>
                                <div class="d-block">
                                    <div class="d-flex">
                                        <div class="d-block">
                                            <label >Estado:</label>
                                            <select id="estadose" class="form-control">
                                                <option value="TODOS">TODOS</option>
                                                <option value="ENCONTRADO">ENCONTRADO</option>
                                                <option value="LOCALIZADO">LOCALIZADO</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>


                                <div class="d-block mx-5">
                                    <div class="d-flex">
                                        <div class="d-block">
                                            <label >Usuario:</label>
                                            <select id="usuariose" class="form-control">
                                                <option value="TODOS">TODOS</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>         
                            </div>


                            <div class="d-flex my-5">
                                <div class="d-block">
                                    <div class="d-flex">
                                        <div class="d-block">
                                            <label >Departamento:</label>
                                            <select id="departamentose" class="form-control">
                                                <option value="-1">TODOS</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>


                                <div class="d-block mx-5">
                                    <div class="d-flex">
                                        <div class="d-block">
                                            <label>Ciudad:</label>
                                            <select id="ciudadese" class="form-control">
                                                <option value="-1">TODOS</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>


                                <div class="d-block">
                                    <div class="d-flex">
                                        <div class="d-block">
                                            <label>Barrios:</label>
                                            <select id="barriose" class="form-control">
                                                <option value="-1">TODOS</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div> 



                            <div class="d-flex">
                                <div class="d-block">
                                    <button class="btn btn-primary my-3" onclick="postsInforme($('#desdee').val(), $('#hastae').val(), $('#estadose').val(), $('#usuariose').val(), $('#departamentose').val(), $('#ciudadese').val(), $('#barriose').val(), 'encontrados')"><i class="fa-regular fa-file"></i> INFORME</button>
                                </div>
                            </div>





                        </div>
                    </div>
                </div>
                
                <div class="tab-pane fade" id="encontradosdet" role="tabpanel">
                    <div class="pd-20">
                        <div class="clearfix">
                            <div class="d-flex">
                                <div class="d-block">
                                    <div class="d-flex">
                                        <div class="d-block">
                                            <label>Desde:</label>
                                            <input class="form-control" type="date" id="desdeedet">
                                        </div>
                                        <div class="d-block mx-5">
                                            <label>Hasta:</label>
                                            <input class="form-control" type="date" id="hastaedet">
                                        </div>
                                    </div>                                    
                                </div>
                                


                                <div class="d-block mx-5">
                                    <div class="d-flex">
                                        <div class="d-block">
                                            <label >Especie:</label>
                                            <select id="especiee" class="form-control">
                                                <option value="TODOS">TODOS</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>         
                            </div>


                            



                            <div class="d-flex">
                                <div class="d-block">
                                    <button class="btn btn-primary my-3" onclick="postsInformeDet($('#desdeedet').val(), $('#hastaedet').val(), $('#especiee').val(),'encontradosdetallado')"><i class="fa-regular fa-file"></i> INFORME</button>
                                </div>
                            </div>





                        </div>
                    </div>
                </div>
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                <div class="tab-pane fade" id="adopcion" role="tabpanel">
                    <div class="pd-20">
                        <div class="clearfix">
                            <div class="d-flex">
                                <div class="d-block">
                                    <div class="d-flex">
                                        <div class="d-block">
                                            <label>Desde:</label>
                                            <input class="form-control" type="date" id="desdea">
                                        </div>
                                        <div class="d-block mx-5">
                                            <label>Hasta:</label>
                                            <input class="form-control" type="date" id="hastaa">
                                        </div>
                                    </div>                                    
                                </div>
                                <div class="d-block">
                                    <div class="d-flex">
                                        <div class="d-block">
                                            <label >Estado:</label>
                                            <select id="estadosa" class="form-control">
                                                <option value="TODOS">TODOS</option>
                                                <option value="ADOPCION">EN ADOPCION</option>
                                                <option value="ADOPTADO">ADOPTADO</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>


                                <div class="d-block mx-5">
                                    <div class="d-flex">
                                        <div class="d-block">
                                            <label >Usuario:</label>
                                            <select id="usuariosa" class="form-control">
                                                <option value="TODOS">TODOS</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>         
                            </div>


                            <div class="d-flex my-5">
                                <div class="d-block">
                                    <div class="d-flex">
                                        <div class="d-block">
                                            <label >Departamento:</label>
                                            <select id="departamentosa" class="form-control">
                                                <option value="-1">TODOS</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>


                                <div class="d-block mx-5">
                                    <div class="d-flex">
                                        <div class="d-block">
                                            <label>Ciudad:</label>
                                            <select id="ciudadesa" class="form-control">
                                                <option value="-1">TODOS</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>


                                <div class="d-block">
                                    <div class="d-flex">
                                        <div class="d-block">
                                            <label>Barrios:</label>
                                            <select id="barriosa" class="form-control">
                                                <option value="-1">TODOS</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div> 



                            <div class="d-flex">
                                <div class="d-block">
                                    <button class="btn btn-primary my-3" onclick="postsInforme($('#desdea').val(), $('#hastaa').val(), $('#estadosa').val(), $('#usuariosa').val(), $('#departamentosa').val(), $('#ciudadesa').val(), $('#barriosa').val(), 'adopciones')"><i class="fa-regular fa-file"></i> INFORME</button>
                                </div>
                            </div>





                        </div>
                    </div>
                </div>
                
                <div class="tab-pane fade" id="adopciondet" role="tabpanel">
                    <div class="pd-20">
                        <div class="clearfix">
                            <div class="d-flex">
                                <div class="d-block">
                                    <div class="d-flex">
                                        <div class="d-block">
                                            <label>Desde:</label>
                                            <input class="form-control" type="date" id="desdeadet">
                                        </div>
                                        <div class="d-block mx-5">
                                            <label>Hasta:</label>
                                            <input class="form-control" type="date" id="hastaadet">
                                        </div>
                                    </div>                                    
                                </div>
                                


                                <div class="d-block mx-5">
                                    <div class="d-flex">
                                        <div class="d-block">
                                            <label >Especie:</label>
                                            <select id="especiea" class="form-control">
                                                <option value="TODOS">TODOS</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>         
                            </div>


                            



                            <div class="d-flex">
                                <div class="d-block">
                                    <button class="btn btn-primary my-3" onclick="postsInformeDet($('#desdeadet').val(), $('#hastaadet').val(), $('#especiea').val(),'adopcionesdetallado')"><i class="fa-regular fa-file"></i> INFORME</button>
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
                                                cargarEspecies();
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
                                            
                                            function cargarEspecies() {
                                                $.ajax(
                                                        {
                                                            url: "/api/buscar/especies",
                                                            type: "post",
                                                            success: function (response) {
                                                                console.log(response);
                                                                let res = JSON.parse(response);
                                                                res.forEach(function (obj) {
                                                                    $("#especiep").append(crearOpt(obj["id"],obj["nombre"]));   
                                                                    $("#especiee").append(crearOpt(obj["id"],obj["nombre"]));
                                                                    $("#especiea").append(crearOpt(obj["id"],obj["nombre"]));
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
                                            
                                            
                                            function postsInforme(desde, hasta, estado, usuario, depar, ciu, barrio, informe) {
                                                let waurl = "/postsinforme.jsp?informe=" + informe + "&desde=" + desde + "&hasta=" + hasta + "&estado=" + estado + "&usuario=" + usuario + "&departamento=" + depar + "&ciudad=" + ciu + "&barrio=" + barrio;
                                                window.open(waurl, '_blank').focus();
                                            }
                                            
                                            function postsInformeDet(desde, hasta, especie, informe) {
                                                let waurl = "/postsinforme.jsp?informe=" + informe + "&desde=" + desde + "&hasta=" + hasta + "&especie=" + especie;
                                                window.open(waurl, '_blank').focus();
                                            }




</script>

<script>

    function cargarDep() {
        $.ajax(
                {
                    url: "/api/buscar/departamentos",
                    data: {opt: "list"},
                    type: "post",
                    success: function (response) {
                        console.log(response);
                        let res = JSON.parse(response);
                        $("#departamentos").append(crearOpt("-1", "TODOS"));
                        $("#departamentose").append(crearOpt("-1", "TODOS"));
                        $("#departamentosa").append(crearOpt("-1", "TODOS"));
                        res.forEach(function (obj) {
                            $("#departamentos").append(crearOpt(obj["id"],obj["nombre"]));
                            $("#departamentose").append(crearOpt(obj["id"],obj["nombre"]));
                            $("#departamentosa").append(crearOpt(obj["id"],obj["nombre"]));
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
                        $("#ciudades").append(crearOpt("-1", "TODOS"));
                        $("#ciudadese").append(crearOpt("-1", "TODOS"));
                        $("#ciudadesa").append(crearOpt("-1", "TODOS"));
                        res.forEach(function (obj) {
                            $("#ciudades").append(crearOpt(obj["id"],obj["nombre"]));
                            $("#ciudadese").append(crearOpt(obj["id"],obj["nombre"]));
                            $("#ciudadesa").append(crearOpt(obj["id"],obj["nombre"]));
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
                        $("#barrios").append(crearOpt("-1", "TODOS"));
                        $("#barriose").append(crearOpt("-1", "TODOS"));
                        $("#barriosa").append(crearOpt("-1", "TODOS"));
                        res.forEach(function (obj) {
                            $("#barrios").append(crearOpt(obj["id"],obj["nombre"]));
                            $("#barriose").append(crearOpt(obj["id"],obj["nombre"]));
                            $("#barriosa").append(crearOpt(obj["id"],obj["nombre"]));
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
    
    $('#departamentose').on('change', function (e) {
        cargarCiu(this.options[this.selectedIndex].value, "0");
    });

    $('#ciudadese').on('change', function (e) {
        cargarBarr(this.options[this.selectedIndex].value, "0");
    });
    
    $('#departamentosa').on('change', function (e) {
        cargarCiu(this.options[this.selectedIndex].value, "0");
    });

    $('#ciudadesa').on('change', function (e) {
        cargarBarr(this.options[this.selectedIndex].value, "0");
    });


    cargarDep();


</script>




<%@include file="../footer.jsp" %> 


