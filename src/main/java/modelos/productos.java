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
import static java.lang.System.out;
import java.sql.ResultSet;
import java.sql.Statement;
import jakarta.json.JsonValue;
import java.io.File;
import java.io.FileOutputStream;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Base64;
import utilidades.conexion;

/**
 *
 * @author Usuario
 */
public class productos {

    String codigo, nombre, descripcion, precio, stock, imgPath, pagina;

    Statement st;
    ResultSet rs;
    
    Connection conn;

    public productos(Connection connection) throws Exception {
        conn = connection;
    }
    
    

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getPrecio() {
        return precio;
    }

    public void setPrecio(String precio) {
        this.precio = precio;
    }

    public String getStock() {
        return stock;
    }

    public void setStock(String stock) {
        this.stock = stock;
    }

    public String getImgPath() {
        return imgPath;
    }

    public void setImgPath(String imgPath) {
        this.imgPath = imgPath;
    }

    public String getPagina() {
        return pagina;
    }

    public void setPagina(String pagina) {
        this.pagina = pagina;
    }

    public void guardar(JsonArray imgs) throws Exception {
        st = conn.createStatement();
        rs = st.executeQuery("SELECT coalesce(MAX(id),53883) + 1 as num from productos");
        rs.next();
        String nid = rs.getString("num");
        st = conn.createStatement();
        Integer contad = 1;
        st.executeUpdate("INSERT INTO productos(id, nombre, descripcion, precio, stock) values('" + nid + "', '" + nombre + "', '" + descripcion + "', '" + precio + "', '" + stock + "')");
        Files.createDirectory(Paths.get(imgPath + File.separator + nid));
        for (int j = 0; j < imgs.size(); j++) {
            String nomb = nid + contad.toString();

            byte dearr[] = Base64.getDecoder().decode(imgs.getString(j).split(",")[1]);
            FileOutputStream fos = new FileOutputStream(new File(imgPath + File.separator + nid + File.separator + nomb + ".jpg"));
            fos.write(dearr);
            fos.close();

            st.executeUpdate("INSERT INTO productosimg(path, nombre, producto) values('" + nid + "', '" + nomb + "', '" + nid + "')");
            contad++;
        }
        out.println("AGREGADO CORRECTAMENTE");
        rs.close();
        st.close();
    }

    public JsonArray listar() throws Exception {

        st = conn.createStatement();
        Statement st2 = null;
        st2 = conn.createStatement();
        ResultSet rs2;
        rs = st.executeQuery("SELECT * FROM productos;");

        JsonArrayBuilder arr = Json.createArrayBuilder();

        while (rs.next()) {
            rs2 = st2.executeQuery("SELECT * FROM productosimg WHERE producto='" + rs.getString(1) + "'");
            JsonObjectBuilder object = Json.createObjectBuilder()
                    .add("id", rs.getString(1))
                    .add("nombre", rs.getString(2))
                    .add("descripcion", rs.getString(3))
                    .add("precio", rs.getString(4))
                    .add("stock", rs.getString(5));
            JsonArrayBuilder imgs = Json.createArrayBuilder();

            while (rs2.next()) {
                String path = "--imgs--prod--" + rs2.getString(3) + "--" + rs2.getString(4) + ".jpg";
                JsonObject img = Json.createObjectBuilder()
                        .add("id", rs2.getString(1))
                        .add("path", path)
                        .build();
                imgs.add(img);

            }
            object.add("imgs", imgs.build());
            arr.add(object.build());
            rs2.close();
        }
        st.close();
        rs.close();
        st2.close();
        return arr.build();
    }

    public void modificar(JsonArray imgs) throws Exception {
        st = conn.createStatement();

        st.executeUpdate("UPDATE productos SET nombre='" + nombre + "', descripcion='" + descripcion + "', precio='" + precio + "', stock='" + stock + "' WHERE id='" + codigo + "'");

        st.executeUpdate("DELETE FROM productosimg WHERE producto='" + codigo + "'");
        
        File file = new File(imgPath + File.separator + codigo);

        deleteDirectory(file);
 
        file.delete();
        
        Integer contad = 1;       
        Files.createDirectory(Paths.get(imgPath + File.separator + codigo));
        for (int j = 0; j < imgs.size(); j++) {
            String nomb = codigo + contad.toString();

            byte dearr[] = Base64.getDecoder().decode(imgs.getString(j).split(",")[1]);
            FileOutputStream fos = new FileOutputStream(new File(imgPath + File.separator + codigo + File.separator + nomb + ".jpg"));
            fos.write(dearr);
            fos.close();

            st.executeUpdate("INSERT INTO productosimg(path, nombre, producto) values('" + codigo + "', '" + nomb + "', '" + codigo + "')");
            contad++;
        }

        st.close();

        out.println("MODIFICADO CORRECTAMENTE");
    }

    public void eliminar() throws Exception {
        st = conn.createStatement();
        st.executeUpdate("DELETE FROM productosimg WHERE producto='" + codigo + "'");
        st.executeUpdate("DELETE FROM productos WHERE id='" + codigo + "'");
        st.close();
        File file = new File(imgPath + File.separator + codigo);

        deleteDirectory(file);
 
        file.delete();
        out.println("ELIMINADO CORRECTAMENTE");
    }

    public JsonArray listarHome() throws Exception {

        st = conn.createStatement();
        Statement st3 = null;
        st3 = conn.createStatement();
        //String sql = "SELECT p.id, p.latitud, p.longitud, b.nombre, c.nombre, p.info, p.recompensa, p.fecha, p.contacto FROM perdidos p INNER JOIN barrios b ON p.barrio=b.id INNER JOIN ciudades c ON b.ciudad=c.id WHERE p.sis_estado='APROBADO' order by p.id desc limit 2 OFFSET " + pagina + ";";

        String sql = "SELECT * FROM productos WHERE stock > 0";

        sql += " order by id desc limit 8 OFFSET " + pagina + ";";

        System.out.println(sql);
        rs = st.executeQuery(sql);

        ResultSet pk;

        JsonObjectBuilder respJ = Json.createObjectBuilder();

        JsonArrayBuilder prodsL = Json.createArrayBuilder();

        while (rs.next()) {

            JsonObjectBuilder jb = Json.createObjectBuilder();

            String prodid = rs.getString(1);

            String nombre = rs.getString(2);

            String descripcion = rs.getString(3);

            String precio = rs.getString(4);

            String stock = rs.getString(5);

            jb.add("prodid", prodid);

            jb.add("nombre", nombre);
            jb.add("descripcion", descripcion);
            jb.add("precio", precio);
            jb.add("stock", stock);

            pk = st3.executeQuery("SELECT path, nombre FROM productosimg WHERE producto='" + prodid + "'");

            pk.next();

            String imggg = pk.getString(1) + "/" + pk.getString(2) + ".jpg";

            pk.close();

            jb.add("img", imggg);

            prodsL.add(jb.build());

        }

        st3.close();
        rs.close();
        st.close();

        return prodsL.build();
    }

    public JsonObject listarID() throws Exception {

        st = conn.createStatement();
        String sql = "SELECT * FROM productos WHERE id='" + codigo + "';";
        System.out.println(sql);
        Statement st2 = null;
        st2 = conn.createStatement();
        rs = st.executeQuery(sql);

        rs.next();

        JsonObjectBuilder jb = Json.createObjectBuilder();

        if (rs.getRow() == 0) {
            return jb.add("hay", false)
                    .build();
        }

        String s = "s";

        jb.add("hay", true);

        String prodid = rs.getString(1);

        String nombre = rs.getString(2);

        String descripcion = rs.getString(3);

        String precio = rs.getString(4);

        String stock = rs.getString(5);

        JsonArrayBuilder imgs = Json.createArrayBuilder();

        jb.add("id", prodid);
        jb.add("nombre", nombre);
        jb.add("descripcion", descripcion);
        jb.add("precio", precio);
        jb.add("stock", stock);

        rs.close();
        st.close();

        ResultSet pk;

        pk = st2.executeQuery("SELECT path, nombre FROM productosimg WHERE producto='" + prodid + "'");

        while (pk.next()) {
            imgs.add(pk.getString(1) + "/" + pk.getString(2) + ".jpg");
        }
        
        jb.add("imgs", imgs.build());
        
        
        pk.close();
        st2.close();

        return jb.build();
    }
    
    public static void deleteDirectory(File file)
    {

        for (File subfile : file.listFiles()) {
 
            if (subfile.isDirectory()) {
                deleteDirectory(subfile);
            }
 
            subfile.delete();
        }
    }

    /*
    
    
    
    
    
    
    
    
    
    public JsonArray listarID() throws Exception{

        st = utilidades.conexion.sta(st);            
        rs = st.executeQuery("SELECT * FROM departamentos WHERE id='" + id + "';");
        
        JsonArrayBuilder arr = Json.createArrayBuilder();
        
        while(rs.next()){ 
             JsonObject object = Json.createObjectBuilder()
                     .add("id",rs.getString(1))
                     .add("nombre",rs.getString(2))
                     .add("codigo",rs.getString(3))
                     .build();
             arr.add(object);
        }
        
        st.close();
        rs.close();
        
        return arr.build();
    }
     */
}
