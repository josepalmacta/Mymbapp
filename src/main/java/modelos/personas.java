/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelos;

import jakarta.json.Json;
import jakarta.json.JsonArray;
import jakarta.json.JsonArrayBuilder;
import jakarta.json.JsonObject;
import java.io.File;
import java.io.FileOutputStream;
import static java.lang.System.out;
import java.net.URISyntaxException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Base64;
import java.util.UUID;
import utilidades.EmailAPI;
import utilidades.conexion;

/**
 *
 * @author Usuario
 */
public class personas {

    String id, nombre, clave, email, barrio, img, imgPath, NClave;

    Statement st, st2;

    ResultSet rs;

    Connection conn;

    public personas(Connection connection) throws Exception {
        conn = connection;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getClave() {
        return clave;
    }

    public void setClave(String clave) {
        this.clave = clave;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getBarrio() {
        return barrio;
    }

    public void setBarrio(String barrio) {
        this.barrio = barrio;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getImg() {
        return img;
    }

    public void setImg(String img) {
        this.img = img;
    }

    public String getImgPath() {
        return imgPath;
    }

    public void setImgPath(String imgPath) {
        this.imgPath = imgPath;
    }

    public String getNClave() {
        return NClave;
    }

    public void setNClave(String NClave) {
        this.NClave = NClave;
    }

    public void guardar() throws Exception {

        st = conn.createStatement();
        rs = st.executeQuery("SELECT coalesce(MAX(id),6912) + 1 as num from personas");
        rs.next();
        id = rs.getString("num");
        rs.close();
        st.executeUpdate("INSERT INTO personas(id, nombre, clave, email, barrio) values('" + id + "' ,'" + nombre + "', '" + clave + "', '" + email + "', '" + barrio + "')");
        st.close();
        out.println("AGREGADO CORRECTAMENTE");
    }

    public void modificar() throws Exception {
        st = conn.createStatement();
        st.executeUpdate("UPDATE personas SET clave='" + clave + "' WHERE id='" + id + "'");
        st.close();
        out.println("MODIFICADO CORRECTAMENTE");
    }

    public void modificarInfo() throws Exception {
        String query = "";
        String imgname = "default";
        if (img.length() > 10) {
            byte dearr[] = Base64.getDecoder().decode(img.split(",")[1]);
            imgname = "pic-" + id + ".jpg";
            FileOutputStream fos = new FileOutputStream(new File(imgPath + File.separator + imgname));
            fos.write(dearr);
            fos.close();
            query = ", imagen='" + imgname + "'";
        }
        st = conn.createStatement();
        st.executeUpdate("UPDATE personas SET nombre='" + nombre + "', email='" + email + "', barrio='" + barrio + "'" + query + " WHERE id='" + id + "'");
        st.close();
        img = imgname;
    }

    public boolean modificarPassw() throws Exception {
        st = conn.createStatement();
        rs = st.executeQuery("SELECT * FROM personas WHERE id='" + id + "' AND clave='" + clave + "'");
        rs.next();
        if (rs.getRow() == 0) {
            return false;
        }
        st.executeUpdate("UPDATE personas SET clave='" + NClave + "' WHERE id='" + id + "'");
        st.close();
        return true;
    }

    public void eliminar() throws Exception {
        st = conn.createStatement();
        st.executeUpdate("DELETE FROM personas WHERE id='" + id + "'");
        st.close();
        out.println("ELIMINADO CORRECTAMENTE");
    }

    public JsonArray listar() throws Exception {

        st = conn.createStatement();
        rs = st.executeQuery("SELECT * FROM personas INNER JOIN barrios ON personas.barrio=barrios.id INNER JOIN ciudades ON barrios.ciudad=ciudades.id INNER JOIN departamentos ON ciudades.departamento=departamentos.id;");

        JsonArrayBuilder arr = Json.createArrayBuilder();

        while (rs.next()) {
            JsonObject object = Json.createObjectBuilder()
                    .add("id", rs.getString(1))
                    .add("nombre", rs.getString(2))
                    .add("codigo", rs.getString(3))
                    .add("idbarrio", rs.getString(7))
                    .add("barrio", rs.getString(8))
                    .add("idciudad", rs.getString(10))
                    .add("ciudad", rs.getString(12))
                    .add("iddep", rs.getString(15))
                    .add("departamento", rs.getString(16))
                    .add("imagen", rs.getString(6))
                    .build();
            arr.add(object);
        }
        st.close();
        rs.close();
        return arr.build();
    }

    public JsonObject listarIDD() throws Exception {

        st = conn.createStatement();
        rs = st.executeQuery("SELECT * FROM personas INNER JOIN barrios ON personas.barrio=barrios.id INNER JOIN ciudades ON barrios.ciudad=ciudades.id INNER JOIN departamentos ON ciudades.departamento=departamentos.id WHERE personas.id='" + id + "';");
        rs.next();
        JsonObject object = Json.createObjectBuilder()
                .add("id", rs.getString(1))
                .add("nombre", rs.getString(2))
                .add("email", rs.getString(4))
                .add("codigo", rs.getString(3))
                .add("idbarrio", rs.getString(7))
                .add("barrio", rs.getString(8))
                .add("idciudad", rs.getString(10))
                .add("ciudad", rs.getString(12))
                .add("iddep", rs.getString(15))
                .add("departamento", rs.getString(16))
                .add("imagen", rs.getString(6))
                .build();
        st.close();
        rs.close();
        return object;
    }

    public JsonArray listarID() throws Exception {

        st = conn.createStatement();
        rs = st.executeQuery("SELECT * FROM personas WHERE id='" + id + "';");

        JsonArrayBuilder arr = Json.createArrayBuilder();

        while (rs.next()) {
            JsonObject object = Json.createObjectBuilder()
                    .add("id", rs.getString(1))
                    .add("nombre", rs.getString(2))
                    .add("codigo", rs.getString(3))
                    .build();
            arr.add(object);
        }
        st.close();
        rs.close();

        return arr.build();
    }

    private void generarCodReg() throws Exception {
        String codigo = UUID.randomUUID().toString();
        EmailAPI api = new EmailAPI();
        api.enviarCodReg(nombre, email, codigo);
        st2 = conn.createStatement();
        st2.executeUpdate("INSERT INTO codigos_reset_clave(codigo, persona) values ('" + codigo + "', '" + id + "')");
        st2.close();
    }

    public boolean verificarEmail() throws Exception {
        st = conn.createStatement();
        rs = st.executeQuery("SELECT id, nombre FROM personas WHERE email='" + email + "';");
        rs.next();
        boolean res = false;
        if (rs.getRow() != 0) {
            res = true;
            id = rs.getString(1);
            nombre = rs.getString(2);
        }
        rs.close();
        st.close();
        if (res) {
            generarCodReg();
        }
        return res;
    }
    
    
    public boolean verificarCodigo() throws Exception {
        st = conn.createStatement();
        rs = st.executeQuery("SELECT persona FROM codigos_reset_clave WHERE codigo='" + NClave + "';");
        rs.next();
        boolean res = false;
        if (rs.getRow() != 0) {
            res = true;
        }
        rs.close();
        st.close();
        return res;
    }

    public boolean verificarCodigoReg() throws Exception {
        st = conn.createStatement();
        rs = st.executeQuery("SELECT persona FROM codigos_reset_clave WHERE codigo='" + NClave + "';");
        rs.next();
        boolean res = false;
        if (rs.getRow() != 0) {
            id = rs.getString(1);
            st2 = conn.createStatement();
            st2.executeUpdate("UPDATE personas SET clave='" + clave + "' WHERE id='" + id + "'");
            st2.executeUpdate("DELETE FROM codigos_reset_clave WHERE persona='" + id + "'");
            st2.close();
            res = true;
        }
        rs.close();
        st.close();
        return res;
    }

}
