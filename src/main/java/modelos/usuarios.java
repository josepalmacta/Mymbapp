/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelos;

import static java.lang.System.out;
import java.sql.ResultSet;
import java.sql.Statement;
import jakarta.json.Json;
import jakarta.json.JsonArray;
import jakarta.json.JsonArrayBuilder;
import jakarta.json.JsonObject;
import java.sql.Connection;
import java.sql.SQLException;
import utilidades.conexion;

/**
 *
 * @author Usuario
 */
public class usuarios {
    
    private String nombre, clave, id, rol, estado;
    
    Statement st;
    ResultSet rs;
    
    Connection conn;

    public usuarios(Connection connection) throws Exception {
        conn = connection;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre.toLowerCase();
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getClave() {
        return clave;
    }

    public void setClave(String clave) {
        this.clave = clave;
    }

    public String getRol() {
        return rol;
    }

    public void setRol(String rol) {
        this.rol = rol;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
    
    
    
    
    
    
    public void guardar() throws Exception{
        
        st = conn.createStatement();
        st.executeUpdate("INSERT INTO usuarios(nombre, clave, rol, estado) values('" + nombre +"', '" + clave + "', '" + rol + "', '" + estado + "')");
        st.close();
        out.println("AGREGADO CORRECTAMENTE");        
    }
    
        
    
    public void modificar() throws Exception{
        st = conn.createStatement();
        st.executeUpdate("UPDATE usuarios SET nombre='" + nombre +"', clave='" + clave + "', rol='" + rol + "', estado='" + estado + "' WHERE id='" + id + "'");
        st.close();
        out.println("MODIFICADO CORRECTAMENTE");      
    }
    
    
    public void eliminar() throws Exception{
        st = conn.createStatement();
        st.executeUpdate("DELETE FROM usuarios WHERE id='" + id + "'");
        st.close();
        out.println("ELIMINADO CORRECTAMENTE");      
    }
    
    
    public JsonArray listar() throws Exception{

        st = conn.createStatement();          
        rs = st.executeQuery("SELECT * FROM usuarios;");
        
        JsonArrayBuilder arr = Json.createArrayBuilder();
        
        while(rs.next()){ 
             JsonObject object = Json.createObjectBuilder()
                     .add("id",rs.getString(1))
                     .add("nombre",rs.getString(2))
                     .add("clave",rs.getString(3))
                     .add("rol",rs.getString(4))
                     .add("estado",rs.getString(5))
                     .build();
             arr.add(object);
        }
        st.close();
        rs.close();
        return arr.build();
    }
    
    
    public JsonArray listarID() throws Exception{

        st = conn.createStatement();          
        rs = st.executeQuery("SELECT * FROM usuarios WHERE id='" + id + "';");
        
        JsonArrayBuilder arr = Json.createArrayBuilder();
        
        while(rs.next()){ 
             JsonObject object = Json.createObjectBuilder()
                     .add("id",rs.getString(1))
                     .add("nombre",rs.getString(2))
                     .add("clave",rs.getString(3))
                     .add("rol",rs.getString(4))
                     .add("estado",rs.getString(5))
                     .build();
             arr.add(object);
        }
        st.close();
        rs.close();
        
        return arr.build();
    }
    
}
