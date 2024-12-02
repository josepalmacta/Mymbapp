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
import java.sql.ResultSet;
import java.sql.Statement;
import jakarta.json.JsonValue;
import java.sql.Connection;
import java.sql.SQLException;
import utilidades.conexion;

/**
 *
 * @author Usuario
 */
public class departamentos {
    
    private String nombre, codigo, id;
    
    Statement st;
    ResultSet rs;
    Connection conn;

    public departamentos(Connection connection) throws Exception {
        conn = connection;
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

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }
    
    
    
    public void guardar() throws Exception{
        
        st = conn.createStatement();
        st.executeUpdate("INSERT INTO departamentos(nombre, codigo) values('" + nombre +"', '" + codigo + "')");
        out.println("AGREGADO CORRECTAMENTE");    
        st.close();
    }
    
        
    
    public void modificar() throws Exception{
        st = conn.createStatement();
        st.executeUpdate("UPDATE departamentos SET nombre='" + nombre +"', codigo='" + codigo + "' WHERE id='" + id + "'");
        st.close();
        out.println("MODIFICADO CORRECTAMENTE");      
    }
    
    
    public void eliminar() throws Exception{
        st = conn.createStatement();
        st.executeUpdate("DELETE FROM departamentos WHERE id='" + id + "'");
        st.close();
        out.println("ELIMINADO CORRECTAMENTE");      
    }
    
    
    public JsonArray listar() throws Exception{

        st = conn.createStatement();            
        rs = st.executeQuery("SELECT * FROM departamentos;");
        
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
    
    
    public JsonArray listarID() throws Exception{

        st = conn.createStatement();          
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
    
    
}
