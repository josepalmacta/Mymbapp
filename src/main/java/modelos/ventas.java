/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelos;

import jakarta.json.Json;
import jakarta.json.JsonArray;
import jakarta.json.JsonArrayBuilder;
import jakarta.json.JsonObject;
import jakarta.json.JsonObjectBuilder;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import jakarta.json.Json;
import jakarta.json.JsonArray;
import jakarta.json.JsonArrayBuilder;
import jakarta.json.JsonObject;
import jakarta.json.JsonObjectBuilder;
import jakarta.xml.bind.DatatypeConverter;
import java.io.File;
import java.io.FileOutputStream;
import static java.lang.System.out;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.time.ZoneId;
import java.time.ZoneOffset;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Base64;
import java.util.logging.Level;
import java.util.logging.Logger;
import utilidades.AdamsPayAPI;
import utilidades.conexion;

/**
 *
 * @author Usuario
 */
public class ventas {

    Statement st, st2, st3, st4;
    ResultSet rs, rs2, rs3, rs4;

    String cliente, precio, cantidad, total, persona, producto, codigo, razon, ruc, telefono, direccion, email, lat, lng, metodo;

    Connection conn;

    public ventas(Connection connection) throws Exception {
        conn = connection;
    }

    public String getCliente() {
        return cliente;
    }

    public void setCliente(String cliente) {
        this.cliente = cliente;
    }

    public String getPrecio() {
        return precio;
    }

    public void setPrecio(String precio) {
        this.precio = precio;
    }

    public String getCantidad() {
        return cantidad;
    }

    public void setCantidad(String cantidad) {
        this.cantidad = cantidad;
    }

    public String getTotal() {
        return total;
    }

    public void setTotal(String total) {
        this.total = total;
    }

    public String getPersona() {
        return persona;
    }

    public void setPersona(String persona) {
        this.persona = persona;
    }

    public String getProducto() {
        return producto;
    }

    public void setProducto(String producto) {
        this.producto = producto;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public String getRazon() {
        return razon;
    }

    public void setRazon(String razon) {
        this.razon = razon;
    }

    public String getRuc() {
        return ruc;
    }

    public void setRuc(String ruc) {
        this.ruc = ruc;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getLat() {
        return lat;
    }

    public void setLat(String lat) {
        this.lat = lat;
    }

    public String getLng() {
        return lng;
    }

    public void setLng(String lng) {
        this.lng = lng;
    }

    public String getMetodo() {
        return metodo;
    }

    public void setMetodo(String metodo) {
        this.metodo = metodo;
    }

    public void guardarDetalle() throws Exception {
        st = conn.createStatement();
        st2 = conn.createStatement();
        String ventid = "";
        rs = st.executeQuery("SELECT * FROM ventas WHERE persona='" + persona + "' AND estado='PENDIENTE'");
        rs.next();
        Integer stotal = Integer.parseInt(cantidad) * Integer.parseInt(precio);
        if (rs.getRow() == 1) {
            st3 = conn.createStatement();
            ventid = rs.getString(1);
            rs3 = st3.executeQuery("SELECT * FROM ventasdetalle WHERE venta='" + ventid + "' AND producto='" + producto + "'");
            rs3.next();
            if (rs3.getRow() != 0) {
                st3.close();
                rs3.close();
                throw new UnsupportedOperationException("repeatprod");
            }
            stotal += Integer.parseInt(rs.getString(5));
            st.executeUpdate("INSERT INTO ventasdetalle (venta, producto, cantidad, precio) values('" + ventid + "', '" + producto + "', '" + cantidad + "', '" + precio + "')");
            st.executeUpdate("UPDATE ventas SET total='" + stotal.toString() + "' WHERE id='" + ventid + "'");
        } else {
            rs2 = st2.executeQuery("SELECT coalesce(MAX(id),9233) + 1 as num from ventas");
            rs2.next();
            ventid = rs2.getString("num");
            st.executeUpdate("INSERT INTO ventas(id, persona, fecha) values('" + ventid + "' ,'" + persona + "', '" + java.time.LocalDate.now().toString() + "')");
            st.executeUpdate("INSERT INTO ventasdetalle (venta, producto, cantidad, precio) values('" + ventid + "', '" + producto + "', '" + cantidad + "', '" + precio + "')");
            st.executeUpdate("UPDATE ventas SET total='" + stotal.toString() + "' WHERE id='" + ventid + "'");
            rs2.close();
        }
        st.close();
        rs.close();
        st2.close();

    }

    public JsonObject listarCarrito() throws Exception {
        JsonObjectBuilder obj = Json.createObjectBuilder();
        JsonArrayBuilder prods = Json.createArrayBuilder();
        st = conn.createStatement();
        st2 = conn.createStatement();
        st3 = conn.createStatement();
        st4 = conn.createStatement();
        rs = st.executeQuery("SELECT * FROM ventas WHERE persona='" + persona + "' AND estado='PENDIENTE'");
        rs.next();
        if (rs.getRow() == 0) {
            obj.add("ventid", "");
            obj.add("total", "0");
            obj.add("detalle", prods.build());
            return obj.build();
        }
        String ventid = rs.getString(1);
        obj.add("ventid", ventid);
        obj.add("total", rs.getString(5));
        rs2 = st2.executeQuery("SELECT * FROM ventasdetalle WHERE venta='" + ventid + "'");
        while (rs2.next()) {
            JsonObjectBuilder prod = Json.createObjectBuilder();
            String prodid = rs2.getString(3);
            prod.add("id", rs2.getString(1));
            prod.add("prodid", prodid);
            prod.add("cantidad", rs2.getString(4));
            prod.add("precio", rs2.getString(5));
            Integer subtotal = Integer.parseInt(rs2.getString(4)) * Integer.parseInt(rs2.getString(5));
            prod.add("subtotal", subtotal.toString());
            rs3 = st3.executeQuery("SELECT * FROM productos WHERE id='" + prodid + "'");
            rs3.next();
            prod.add("nombre", rs3.getString(2));
            rs4 = st4.executeQuery("SELECT * FROM productosimg WHERE producto='" + prodid + "'");
            rs4.next();
            String imgpath = "/imgs/prod/" + rs4.getString(3) + "/" + rs4.getString(4) + ".jpg";
            prod.add("img", imgpath);
            prods.add(prod.build());
            rs3.close();
            rs4.close();

        }
        obj.add("detalle", prods.build());
        rs.close();
        rs2.close();
        st.close();
        st2.close();
        st3.close();
        st4.close();
        return obj.build();

    }

    public void eliminarDeatlle() throws Exception {
        st = conn.createStatement();
        st2 = conn.createStatement();
        rs = st2.executeQuery("SELECT * FROM ventasdetalle det WHERE det.id='" + producto + "'");
        rs.next();
        String venid = rs.getString(2);
        Integer stotal = Integer.parseInt(rs.getString(4)) * Integer.parseInt(rs.getString(5));
        System.err.print("Ventas: " + "DELETE FROM ventasdetalle WHERE id='" + producto + "' AND producto='" + producto + "'");
        st.executeUpdate("DELETE FROM ventasdetalle WHERE id='" + producto + "'");
        st.executeUpdate("UPDATE ventas SET total=total-" + stotal.toString() + " WHERE id='" + venid + "'");
        st.close();
        rs.close();
        st2.close();
    }

    public void cancelarCompra() throws Exception {
        st = conn.createStatement();
        st.executeUpdate("UPDATE ventas SET estado='CANCELADO' WHERE id='" + codigo + "'");
        st.close();
    }

    public void confirmarCompra() throws Exception {
        st = conn.createStatement();
        st.executeUpdate("UPDATE ventas SET estado='FINALIZADO', razon_social='" + razon + "', ruc='" + ruc + "', email='" + email + "', telefono='" + telefono + "', direccion='" + direccion + "', latitud='" + lat + "', longitud='" + lng + "' WHERE id='" + codigo + "'");
        st.close();
    }

    public String listarCantidad() throws Exception {
        String cantidad = "0";
        st = conn.createStatement();
        rs = st.executeQuery("SELECT id FROM ventas WHERE estado='PENDIENTE' AND persona='" + persona + "'");
        rs.next();
        if (rs.getRow() == 0) {
            return cantidad;
        }
        String ventid = rs.getString(1);
        rs.close();
        rs2 = st.executeQuery("SELECT COUNT(*) FROM ventasdetalle WHERE venta='" + ventid + "'");
        rs2.next();
        cantidad = rs2.getString(1);
        rs2.close();
        st.close();
        return cantidad;
    }

    public void actualizarEstado(String estado) throws Exception {
        st = conn.createStatement();
        st.executeUpdate("UPDATE ventas SET estado='" + estado + "' WHERE id='" + codigo + "'");
        st.close();
        if(estado.equals("FINALIZADO")){
            disminuirStock(codigo);
        }
        else if(estado.equals("ANULADO")){
            aumentarStock(codigo);
        }
    }
    
    
    public void disminuirStock(String code) throws Exception{
        st = conn.createStatement();
        st2 = conn.createStatement();
        rs = st.executeQuery("SELECT producto, cantidad FROM ventasdetalle WHERE venta='" + code + "'");
        while(rs.next()){
            st2.executeUpdate("UPDATE productos SET stock=stock-" + rs.getString(2) + " WHERE id='" + rs.getString(1) + "'");
        }
        st2.close();
        rs.close();
        st.close();
    };
    
    public void aumentarStock(String code) throws Exception{
        st = conn.createStatement();
        st2 = conn.createStatement();
        rs = st.executeQuery("SELECT producto, cantidad FROM ventasdetalle WHERE venta='" + code + "'");
        while(rs.next()){
            st2.executeUpdate("UPDATE productos SET stock=stock+" + rs.getString(2) + " WHERE id='" + rs.getString(1) + "'");
        }
        st2.close();
        rs.close();
        st.close();
        
    };

    public JsonArray listar(String estado) throws Exception {
        st = conn.createStatement();
        rs = st.executeQuery("SELECT v.id, fecha, total, estado, p.nombre FROM ventas v JOIN personas p ON v.persona=p.id WHERE estado='" + estado + "';");

        JsonArrayBuilder arr = Json.createArrayBuilder();

        while (rs.next()) {
            JsonObject object = Json.createObjectBuilder()
                    .add("id", rs.getString(1))
                    .add("fecha", rs.getString(2))
                    .add("total", rs.getString(3))
                    .add("estado", rs.getString(4))
                    .add("cliente", rs.getString(5))
                    .build();
            arr.add(object);
        }
        st.close();
        rs.close();
        return arr.build();
    }

    public JsonObject listarID() throws Exception {
        JsonObjectBuilder obj = Json.createObjectBuilder();
        JsonArrayBuilder prods = Json.createArrayBuilder();
        st = conn.createStatement();
        st2 = conn.createStatement();
        st3 = conn.createStatement();
        st4 = conn.createStatement();
        rs = st.executeQuery("SELECT * FROM ventas INNER JOIN personas ON ventas.persona=personas.id WHERE ventas.id='" + codigo + "'");
        rs.next();
        if (rs.getRow() == 0) {
            obj.add("ventid", "");
            obj.add("total", "0");
            obj.add("detalle", prods.build());
            return obj.build();
        }
        String ventid = rs.getString(1);
        obj.add("ventid", ventid);
        obj.add("total", rs.getString(5));
        obj.add("fecha", rs.getString(3));
        obj.add("estado", rs.getString(4));
        obj.add("razon", rs.getString(6));
        obj.add("ruc", rs.getString(7));
        obj.add("telefono", rs.getString(8));
        obj.add("email", rs.getString(9));
        obj.add("direccion", rs.getString(10));
        obj.add("perid", rs.getString(13));
        obj.add("persona", rs.getString(14));
        rs2 = st2.executeQuery("SELECT * FROM ventasdetalle WHERE venta='" + ventid + "'");
        while (rs2.next()) {
            JsonObjectBuilder prod = Json.createObjectBuilder();
            String prodid = rs2.getString(3);
            prod.add("id", rs2.getString(1));
            prod.add("prodid", prodid);
            prod.add("cantidad", rs2.getString(4));
            prod.add("precio", rs2.getString(5));
            Integer subtotal = Integer.parseInt(rs2.getString(4)) * Integer.parseInt(rs2.getString(5));
            prod.add("subtotal", subtotal.toString());
            rs3 = st3.executeQuery("SELECT * FROM productos WHERE id='" + prodid + "'");
            rs3.next();
            prod.add("nombre", rs3.getString(2));
            rs4 = st4.executeQuery("SELECT * FROM productosimg WHERE producto='" + prodid + "'");
            rs4.next();
            String imgpath = "/imgs/prod/" + rs4.getString(3) + "/" + rs4.getString(4) + ".jpg";
            prod.add("img", imgpath);
            prods.add(prod.build());
            rs3.close();
            rs4.close();

        }
        obj.add("detalle", prods.build());
        rs.close();
        rs2.close();
        st.close();
        st2.close();
        st3.close();
        st4.close();
        return obj.build();

    }

    public JsonArray listarUsuario() throws Exception {
        JsonArrayBuilder arr = Json.createArrayBuilder();
        st = conn.createStatement();
        rs = st.executeQuery("SELECT * FROM ventas INNER JOIN personas ON ventas.persona=personas.id WHERE ventas.persona='" + persona + "' AND NOT ventas.estado='PENDIENTE' AND NOT ventas.estado='CANCELADO'");
        while (rs.next()) {
            JsonObjectBuilder obj = Json.createObjectBuilder();
            obj.add("ventid", rs.getString(1));
            obj.add("total", rs.getString(5));
            obj.add("fecha", rs.getString(3));
            obj.add("estado", rs.getString(4));
            obj.add("razon", rs.getString(6));
            obj.add("ruc", rs.getString(7));
            obj.add("telefono", rs.getString(8));
            obj.add("email", rs.getString(9));
            obj.add("direccion", rs.getString(10));
            obj.add("perid", rs.getString(13));
            obj.add("persona", rs.getString(14));
            arr.add(obj.build());
        }
        rs.close();
        st.close();
        return arr.build();

    }

    public JsonObject listarCompra() throws Exception {
        JsonObjectBuilder obj = Json.createObjectBuilder();
        JsonArrayBuilder prods = Json.createArrayBuilder();
        st = conn.createStatement();
        st2 = conn.createStatement();
        st3 = conn.createStatement();
        st4 = conn.createStatement();
        rs = st.executeQuery("SELECT * FROM ventas WHERE persona='" + persona + "' AND id='" + producto + "'");
        rs.next();
        if (rs.getRow() == 0) {
            obj.add("ventid", "");
            obj.add("total", "0");
            obj.add("detalle", prods.build());
            return obj.build();
        }
        String ventid = rs.getString(1);
        obj.add("ventid", ventid);
        obj.add("estado", rs.getString(4));
        obj.add("razon", rs.getString(6));
        obj.add("ruc", rs.getString(7));
        obj.add("telefono", rs.getString(8));
        obj.add("email", rs.getString(9));
        obj.add("direccion", rs.getString(10));
        obj.add("lat", rs.getString(11));
        obj.add("lng", rs.getString(12));
        obj.add("total", rs.getString(5));
        rs2 = st2.executeQuery("SELECT * FROM ventasdetalle WHERE venta='" + ventid + "'");
        while (rs2.next()) {
            JsonObjectBuilder prod = Json.createObjectBuilder();
            String prodid = rs2.getString(3);
            prod.add("id", rs2.getString(1));
            prod.add("prodid", prodid);
            prod.add("cantidad", rs2.getString(4));
            prod.add("precio", rs2.getString(5));
            Integer subtotal = Integer.parseInt(rs2.getString(4)) * Integer.parseInt(rs2.getString(5));
            prod.add("subtotal", subtotal.toString());
            rs3 = st3.executeQuery("SELECT * FROM productos WHERE id='" + prodid + "'");
            rs3.next();
            prod.add("nombre", rs3.getString(2));
            rs4 = st4.executeQuery("SELECT * FROM productosimg WHERE producto='" + prodid + "'");
            rs4.next();
            String imgpath = "/imgs/prod/" + rs4.getString(3) + "/" + rs4.getString(4) + ".jpg";
            prod.add("img", imgpath);
            prods.add(prod.build());
            rs3.close();
            rs4.close();

        }
        obj.add("detalle", prods.build());
        rs.close();
        rs2.close();
        st.close();
        st2.close();
        st3.close();
        st4.close();
        return obj.build();

    }
    
    

    public String pagarVenta() throws Exception {

        
        String siExiste = "update";
        String apiKey = "tu-api-key";
        String host = "staging.adamspay.com";
        String path = "/api/v1/debts";
        

        st = conn.createStatement();
        String ventid = "";
        rs = st.executeQuery("SELECT * FROM ventas WHERE persona='" + persona + "' AND estado='PENDIENTE'");
        rs.next();
        if (rs.getRow() == 0) {
            rs.close();
            st.close();
            return "error";
        }

        ventid = rs.getString(1);
        
        String idDeuda = ventid;
        
        JsonObjectBuilder jsonDeuda = Json.createObjectBuilder();
        JsonObjectBuilder amount = Json.createObjectBuilder();
        amount.add("currency", "PYG");
        amount.add("value", rs.getString(5));
        JsonObjectBuilder validPeriod = Json.createObjectBuilder();
        String fechas = tiempoLimite();
        validPeriod.add("start", fechas.split("==")[0]);
        validPeriod.add("end", fechas.split("==")[1]);
        
        jsonDeuda.add("docId", idDeuda);
        jsonDeuda.add("amount", amount.build());
        jsonDeuda.add("validPeriod", validPeriod.build());
        jsonDeuda.add("label", "Pedido #" + ventid);
        
        
        JsonObjectBuilder data = Json.createObjectBuilder();
        data.add("debt", jsonDeuda.build());
        
        rs.close();
        
        AdamsPayAPI adamsPay = new AdamsPayAPI();
        
        
        JsonObject res = adamsPay.iniciarPago(data.build());
        
        if (res.containsKey("debt")) {
            st.executeUpdate("UPDATE ventas SET estado='PAGO PENDIENTE', razon_social='" + razon + "', ruc='" + ruc + "', email='" + email + "', telefono='" + telefono + "', direccion='" + direccion + "', latitud='" + lat + "', longitud='" + lng + "' WHERE id='" + ventid + "'");
            st.close();
            return res.getJsonObject("debt").getString("payUrl");
        }
        st.close();
        return "error";

    }

    public String sha1Token(String input) {
        String sha1 = "";
        try {
            MessageDigest msdDigest = MessageDigest.getInstance("SHA-1");
            msdDigest.update(input.getBytes("UTF-8"));
            sha1 = DatatypeConverter.printHexBinary(msdDigest.digest());
        } catch (Exception e) {
            Logger.getLogger(ventas.class.getName()).log(Level.SEVERE, null, e);
        }
        return sha1.toLowerCase();
    }

    private String tiempoLimite() {
        ZonedDateTime utcNow = ZonedDateTime.now(ZoneOffset.UTC);

        ZonedDateTime utcPlus24Hours = utcNow.plusHours(24);

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss");
        
        String fechaLimite = utcNow.format(formatter) + "==" + utcPlus24Hours.format(formatter);

        return fechaLimite;
    }

    public JsonArray listarMetodos() throws Exception {
        st = conn.createStatement();
        rs = st.executeQuery("SELECT * FROM medios_de_pago;");

        JsonArrayBuilder arr = Json.createArrayBuilder();

        while (rs.next()) {
            JsonObject object = Json.createObjectBuilder()
                    .add("id", rs.getString(1))
                    .add("nombre", rs.getString(2))
                    .add("imagen", rs.getString(3))
                    .build();
            arr.add(object);
        }
        st.close();
        rs.close();
        return arr.build();
    }

}
