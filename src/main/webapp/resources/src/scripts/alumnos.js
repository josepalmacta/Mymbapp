$(document).ready(function () {
    $("#nombre").on("blur", function () {
        $("#msgNombre").hide();
        $("#nombre").css("border", "none");
        if ($("#nombre").val() === "") {
            $("#msgNombre").show();
            $("#nombre").css("border", "1px solid red");
            $("#nombre").focus();
        }
    });


    $("#apellido").on("blur", function () {
        $("#msgApellido").hide();
        $("#apellido").css("border", "none");
        if ($("#apellido").val() === "") {
            $("#msgApellido").show();
            $("#apellido").css("border", "1px solid red");
            $("#apellido").focus();
        }
    });

    cargarTabla();


    $("btnprocesar").on("click", function () {
        agregarAlumno();
    });
});




function cargarTabla() {
    $("#codigo").val("");
    $.ajax(
            {
                url: "jsp/alumno.jsp",
                type: "get",
                success: function (response) {
                    $("#tablacontenido").html(response);
                }
            }
    );
    limpiar();
}



function limpiar() {
    $("#codigo").val("");
    $("#nombre").val("");
    $("#apellido").val("");
}





function transferir(id, nombre, apellido) {
    $("#codigo").val(id);
    $("#nombre").val(nombre);
    $("#apellido").val(apellido);

}



function mostrarMensaje() {
    $("#mensaje").fadeIn(1000);
    setTimeout(function () {
        $("#mensaje").fadeOut(1000);
    }, 2000);
}



function eliminar() {
    let id = $("#codigo").val();
    $.ajax(
            {
                data: {opt: "del", codigo: id},
                url: "jsp/alumno.jsp",
                type: "post",
                success: function (response) {
                    $('#confirmation-modal').modal('hide');
                    $("#mensaje").html(response);
                    mostrarMensaje(response);
                    cargarTabla();
                }
            }
    );
}


function mostrarMensaje(mensaje) {
    alert(mensaje);
    swal(
            {
                type: 'success',
                position: 'center',
                title: mensaje,
                showConfirmButton: false,
                timer: 1500
            }
    );
}


function modificarAlumno() {
    let nombre = $("#nombre").val();
    let apellido = $("#apellido").val();
    let codigo = $("#codigo").val();
    let opt = "edit";

    if (codigo === "") {
        opt = "add";
    }

    $.ajax(
            {
                data: {opt: opt, nombre: nombre, apellido: apellido, codigo: codigo},
                url: "jsp/alumno.jsp",
                type: "post",
                success: function (response) {
                    $("#mensaje").html(response);
                    mostrarMensaje(response);
                    cargarTabla();
                }
            }
    );
}