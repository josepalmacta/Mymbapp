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
public class ciudades {
    
    private String id, nombre, codigo, departamento;
    
    Statement st;
    ResultSet rs;
    
    Connection conn;

    public ciudades(Connection connection) throws Exception {
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

    public String getDepartamento() {
        return departamento;
    }

    public void setDepartamento(String departamento) {
        this.departamento = departamento;
    }
    
    
    public void guardar() throws Exception{
        
        Statement st2 = null;
        st2 = conn.createStatement();
        
        ResultSet rs2 = null;
        
        rs2 = st2.executeQuery("SELECT * FROM ciudades b WHERE b.nombre='" + nombre.toUpperCase() + "' AND b.departamento='" + departamento + "'");
        rs2.next();
        if(rs2.getRow() == 1){
            st2.close();
            rs2.close();
            throw new UnsupportedOperationException("EL BARRIO YA EXISTE EN ESTA CIUDAD");
        }
        st2.close();
        rs2.close();
        
        st = conn.createStatement();
        st.executeUpdate("INSERT INTO ciudades(nombre, codigo, departamento) values('" + nombre +"', '" + codigo + "', '" + departamento + "')");
        out.println("AGREGADO CORRECTAMENTE"); 
        st.close();
        
    }
    
        
    
    public void modificar() throws Exception{
        st = conn.createStatement();
        st.executeUpdate("UPDATE ciudades SET nombre='" + nombre +"', codigo='" + codigo + "', departamento='" + departamento + "' WHERE id='" + id + "'");
        st.close();
        out.println("MODIFICADO CORRECTAMENTE");      
    }
    
    
    public void eliminar() throws Exception{
        st = conn.createStatement();
        st.executeUpdate("DELETE FROM ciudades WHERE id='" + id + "'");
        out.println("ELIMINADO CORRECTAMENTE");     
        st.close();
    }
    
    
    public JsonArray listar() throws Exception{

        st = conn.createStatement();            
        rs = st.executeQuery("SELECT * FROM ciudades INNER JOIN departamentos ON ciudades.departamento=departamentos.id;");
        
        JsonArrayBuilder arr = Json.createArrayBuilder();
        
        while(rs.next()){ 
             JsonObject object = Json.createObjectBuilder()
                     .add("id",rs.getString(1))
                     .add("nombre",rs.getString(2))
                     .add("codigo",rs.getString(3))
                     .add("departamento",rs.getString(4))
                     .add("dep",rs.getString(6))
                     .build();
             arr.add(object);
        }
        st.close();
        rs.close();
        return arr.build();
    }
    
    
    public JsonArray listarID() throws Exception{

        st = conn.createStatement();          
        rs = st.executeQuery("SELECT * FROM ciudades WHERE id='" + id + "';");
        
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
    
    
    public JsonArray listarDep() throws Exception{

        st = conn.createStatement();           
        rs = st.executeQuery("SELECT * FROM ciudades WHERE departamento='" + departamento + "';");
        
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
