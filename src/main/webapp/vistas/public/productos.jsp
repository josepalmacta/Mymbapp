<%-- 
    Document   : productos
    Created on : 10 ago 2024, 17:07:53
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


<% String titulo = "Tienda Online"; %>
<%@include file="header.jsp" %>

<style>
    .card {
        position: relative;
        display: -ms-flexbox;
        display: flex;
        -ms-flex-direction: column;
        flex-direction: column;
        min-width: 0;
        word-wrap: break-word;
        background-color: #fff;
        background-clip: border-box;
        border: 1px solid rgba(0,0,0,.125);
        border-radius: .1875rem;
        width: 40vw;
    }

    .card-img-actions {
        position: relative;
    }
    .card-body {
        -ms-flex: 1 1 auto;
        flex: 1 1 auto;
        padding: 1.25rem;
        text-align: center;
    }

    .star{
        color: red;
    }

    .bg-cart {
        background-color:orange;
        color:#fff;
    }

    .bg-cart:hover {

        color:#fff;
    }

    .bg-buy {
        background-color:green;
        color:#fff;
        padding-right: 29px;
    }
    .bg-buy:hover {

        color:#fff;
    }

    a{

        text-decoration: none !important;
    }

    .card img {
        width: 20vw;
        height: 20vw;
        object-fit: cover;
    }

    .dnon{
        display: block;
    }

    .ppx-3{
        padding-right: 0rem !important;
        padding-left: 1rem !important;
    }

    @media (min-width: 1280px) {

        .card img {
            height: 15vw;
            width: 15vw;
            object-fit: cover;
        }
        .card{
            width: auto;
        }

        .ppx-3{
            padding-right: 1rem !important;
            padding-left: 1rem !important;
        }
    }
</style>

<div class="py-5">

    <div class="d-flex flex-wrap mb-50 px-3 g-3">



        <%
                DataSource dataSource = (DataSource) getServletContext().getAttribute("dataSource");
                try(Connection connection = dataSource.getConnection()){
                modelos.productos prod = new modelos.productos(connection);
        
     JsonArray arr = prod.listarHome();
         
     for (int i = 0; i < arr.size(); i++) {
        JsonObject obj = arr.getJsonObject(i);
        %>



        <div class="mt-3 ppx-3">


            <div class="card">
                <div class="card-body">
                    <div class="card-img-actions">

                        <img src="/imgs/prod/<% out.print(obj.getString("img")); %>" class="card-img img-fluid" width="96px" height="96px" alt="">


                    </div>
                </div>

                <div class="card-body bg-light text-center">
                    <div class="mb-2">
                        <h6 class="font-weight-semibold mb-2">
                            <a href="/tienda/<% out.print(obj.getString("prodid")); %>" class="text-primary mb-2" data-abc="true"><% out.print(obj.getString("nombre")); %></a>
                        </h6>

                        <!--<a href="#" class="text-muted" data-abc="true"><% out.print(obj.getString("descripcion")); %></a> -->
                    </div>

                    <h5 class="mb-0 font-weight-semibold"><% out.print(obj.getString("precio")); %></h5>

                    <div class="text-muted mb-3"><% out.print(obj.getString("stock") + " en stock"); %></div>

                    <a href="/tienda/<% out.print(obj.getString("prodid")); %>" class="btn btn-primary"><i class="fa fa-cart-plus mr-2"></i> Ver Producto</a>


                </div>
            </div>

        </div>

        <% } %>

    </div>
</div>

<script>
    function cantidad() {
        $.ajax(
                {
                    url: "/carrito/cant",
                    success: function (response) {
                        if (response !== "0") {
                            $("#btncarrito").addClass("animate__animated");
                        }
                        $("#canti").html(response);
                    }
                }
        );
    }
    cantidad();
</script>        
<% } %>
<%@include file="footer.jsp" %>
