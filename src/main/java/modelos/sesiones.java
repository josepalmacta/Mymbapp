/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelos;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import utilidades.conexion;

/**
 *
 * @author Usuario
 */
public class sesiones {

    String usuario, clave, rol, estado, codigo, imagen;

    Statement st;

    ResultSet rs;
    
    Connection conn;

    public sesiones(Connection connection) throws Exception {
        conn = connection;
    }

    public String getUsuario() {
        return usuario;
    }

    public void setUsuario(String usuario) {
        this.usuario = usuario;
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

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public String getImagen() {
        return imagen;
    }

    public void setImagen(String imagen) {
        this.imagen = imagen;
    }
    
    
    

    public boolean login() throws Exception {

        PreparedStatement st = conn.prepareStatement("SELECT * FROM usuarios  where nombre=? and clave=?");
        
        st.setString(1, usuario);
        
        st.setString(2, clave);
        
        rs = st.executeQuery();

        rs.next();

        if (rs.getRow() == 1) {
            codigo = rs.getString(1);
            rol = rs.getString(4);
            estado = rs.getString(5);
            if(estado.equals("ACTIVO")){
                return true;
            }
        }
        
        st.close();
        rs.close();

        return false;

    }
    
    
    public boolean loginP() throws Exception {

        PreparedStatement st = conn.prepareStatement("SELECT * FROM personas  where email=? and clave=?");
        st.setString(1, usuario);
        st.setString(2, clave);
        rs = st.executeQuery();

        rs.next();

        if (rs.getRow() != 0) {
            codigo = rs.getString(1);
            usuario = rs.getString(2);
            imagen = rs.getString(6);
            return true;
        }
        
        st.close();
        rs.close();

        return false;

    }


}