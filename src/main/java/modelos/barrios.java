/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelos;

import jakarta.json.Json;
import jakarta.json.JsonArray;
import jakarta.json.JsonArrayBuilder;
import jakarta.json.JsonObject;
import static java.lang.System.out;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import utilidades.conexion;

/**
 *
 * @author Usuario
 */
public class barrios {
    
    String id, nombre, codigo, ciudad;
    
    Statement st;
    
    ResultSet rs;
    
    Connection conn;

    public barrios(Connection connection) throws Exception {
        conn = connection;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }
    
    
    

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre.toUpperCase();
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public String getCiudad() {
        return ciudad;
    }

    public void setCiudad(String ciudad) {
        this.ciudad = ciudad;
    }
    
    
    public void guardar() throws Exception{
        
        Statement st2 = null;
        st2 = conn.createStatement();
        
        ResultSet rs2 = null;
        
        rs2 = st2.executeQuery("SELECT * FROM barrios b WHERE b.nombre='" + nombre.toUpperCase() + "' AND b.ciudad='" + ciudad + "'");
        rs2.next();
        if(rs2.getRow() == 1){
            st2.close();
            rs2.close();
            throw new UnsupportedOperationException("EL BARRIO YA EXISTE EN ESTA CIUDAD");
        }
        st2.close();
        rs2.close();
        st = conn.createStatement();       
        st.executeUpdate("INSERT INTO barrios(nombre, codigo, ciudad) values('" + nombre +"', '" + codigo + "', '" + ciudad + "')");
        st.close();
        out.println("AGREGADO CORRECTAMENTE");        
    }
    
        
    
    public void modificar() throws Exception{
        st = conn.createStatement();
        st.executeUpdate("UPDATE barrios SET nombre='" + nombre +"', codigo='" + codigo + "', ciudad='" + ciudad + "' WHERE id='" + id + "'");
        st.close();
        out.println("MODIFICADO CORRECTAMENTE");      
    }
    
    
    public void eliminar() throws Exception{
        st = conn.createStatement();
        st.executeUpdate("DELETE FROM barrios WHERE id='" + id + "'");
        st.close();
        out.println("ELIMINADO CORRECTAMENTE");      
    }
    
    
    public JsonArray listar() throws Exception{

        st = conn.createStatement();          
        rs = st.executeQuery("SELECT * FROM barrios INNER JOIN ciudades ON barrios.ciudad=ciudades.id INNER JOIN departamentos ON ciudades.departamento=departamentos.id;");
        
        JsonArrayBuilder arr = Json.createArrayBuilder();
        
        while(rs.next()){ 
             JsonObject object = Json.createObjectBuilder()
                     .add("id",rs.getString(1))
                     .add("nombre",rs.getString(2))
                     .add("codigo",rs.getString(3))
                     .add("idciudad",rs.getString(4))
                     .add("ciudad",rs.getString(6))
                     .add("iddep",rs.getString(8))
                     .add("departamento",rs.getString(10))
                     .build();
             arr.add(object);
        }
        st.close();
        rs.close();
        return arr.build();
    }
    
    public JsonArray listarCiu() throws Exception{

        st = conn.createStatement();           
        rs = st.executeQuery("SELECT * FROM barrios WHERE ciudad='" + ciudad + "';");
        
        JsonArrayBuilder arr = Json.createArrayBuilder();
        
        while(rs.next()){ 
             JsonObject object = Json.createObjectBuilder()
                     .add("id",rs.getString(1))
                     .add("nombre",rs.getString(2))
                     .build();
             arr.add(object);
        }
        
        st.close();
        rs.close();
        
        return arr.build();
    }
    
    
    public JsonArray listarID() throws Exception{

        st = conn.createStatement();        
        rs = st.executeQuery("SELECT * FROM barrios WHERE id='" + id + "';");
        
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

    
}
