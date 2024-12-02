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
            <h4 class="text-blue h4">GENERAR INFORME DE MASCOTAS EN ADOPCION</h4>
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
                    <a class="nav-link active" data-toggle="tab" href="#adopcion" role="tab" aria-selected="true">Informe General</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-toggle="tab" href="#adopciondet" role="tab" aria-selected="false">Informe Detallado</a>
                </li>            
            </ul>
            <div class="tab-content">

                <div class="tab-pane fade show active" id="adopcion" role="tabpanel">
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
                                                <option value="PENDIENTE">PENDIENTE</option>
                                                <option value="APROBADO">APROBADO</option>
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
                                                cargarEspecies();
                                                cargarClientes();
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
                                                                    $("#especiea").append(crearOpt(obj["id"],obj["nombre"]));                                                               
                                                                });
                                                            }
                                                        }
                                                );
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
                        res.forEach(function (obj) {
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
                        $("#ciudadesa").html("");
                        $("#ciudadesa").append(crearOpt("-1", "TODOS"));
                        res.forEach(function (obj) {
                            $("#ciudadesa").append(crearOpt(obj["id"],obj["nombre"]));
                        });

                        if (ciu != "0") {
                            $("#ciudadesa").val(ciu);
                        }

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
                        $("#barriosa").html("");
                        $("#barriosa").append(crearOpt("-1", "TODOS"));
                        res.forEach(function (obj) {
                            $("#barriosa").append(crearOpt(obj["id"],obj["nombre"]));
                        });

                        if (barr != "0") {
                            $("#barriosa").val(barr);
                        }



                    }
                }
        );
    }




    
    $('#departamentosa').on('change', function (e) {
        cargarCiu(this.options[this.selectedIndex].value, "0");
    });

    $('#ciudadesa').on('change', function (e) {
        cargarBarr(this.options[this.selectedIndex].value, "0");
    });


    cargarDep();


</script>




<%@include file="../footer.jsp" %> 


