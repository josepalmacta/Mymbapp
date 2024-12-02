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
public class razas {
    
    String id, nombre, especie;
    
    Statement st;
    
    ResultSet rs;
    
    Connection conn;

    public razas(Connection connection) throws Exception {
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

    public String getEspecie() {
        return especie;
    }

    public void setEspecie(String especie) {
        this.especie = especie;
    }
    
    
    public void guardar() throws Exception{
        
        st = conn.createStatement();
        st.executeUpdate("INSERT INTO razas(nombre, especie) values('" + nombre +"', '" + especie + "')");
        st.close();
        out.println("AGREGADO CORRECTAMENTE");        
    }
    
        
    
    public void modificar() throws Exception{
        st = conn.createStatement();
        st.executeUpdate("UPDATE razas SET nombre='" + nombre + "', especie='" + especie + "' WHERE id='" + id + "'");
        st.close();
        out.println("MODIFICADO CORRECTAMENTE");      
    }
    
    
    public void eliminar() throws Exception{
        st = conn.createStatement();
        st.executeUpdate("DELETE FROM razas WHERE id='" + id + "'");
        st.close();
        out.println("ELIMINADO CORRECTAMENTE");      
    }
    
    
    public JsonArray listar() throws Exception{

        st = conn.createStatement();            
        rs = st.executeQuery("SELECT * FROM razas INNER JOIN especies ON razas.especie=especies.id;");
        
        JsonArrayBuilder arr = Json.createArrayBuilder();
        
        while(rs.next()){ 
             JsonObject object = Json.createObjectBuilder()
                     .add("id",rs.getString(1))
                     .add("nombre",rs.getString(2))
                     .add("idespecie",rs.getString(4))
                     .add("especie",rs.getString(5))
                     .build();
             arr.add(object);
        }
        st.close();
        rs.close();
        return arr.build();
    }
    
    
    public JsonArray listarID() throws Exception{

        st = conn.createStatement();           
        rs = st.executeQuery("SELECT * FROM razas WHERE id='" + id + "';");
        
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
    
    
    public JsonArray listarDep() throws Exception{

        st = conn.createStatement();           
        rs = st.executeQuery("SELECT * FROM razas WHERE especie='" + especie + "';");
        
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
    
    
    
}
