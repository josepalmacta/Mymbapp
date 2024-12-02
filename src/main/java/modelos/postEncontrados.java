/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelos;

/**
 *
 * @author Usuario
 */
import jakarta.json.Json;
import jakarta.json.JsonArray;
import jakarta.json.JsonArrayBuilder;
import jakarta.json.JsonObject;
import jakarta.json.JsonObjectBuilder;
import java.io.File;
import java.io.FileOutputStream;
import static java.lang.System.out;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.Base64;
import utilidades.conexion;

/**
 *
 * @author Usuario
 */
public class postEncontrados {

    private String id, estado, latitud, longitud, contacto, fecha, persona, barrio, info, iddetalle, imgPath, pagina, departamento, especie, raza, ciudad;

    Statement st, st2, st3;

    ResultSet rs;
    
    Connection conn;

    public postEncontrados(Connection connection) throws Exception {
        conn = connection;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getLatitud() {
        return latitud;
    }

    public void setLatitud(String latitud) {
        this.latitud = latitud;
    }

    public String getLongitud() {
        return longitud;
    }

    public void setLongitud(String longitud) {
        this.longitud = longitud;
    }

    public String getContacto() {
        return contacto;
    }

    public void setContacto(String contacto) {
        this.contacto = contacto;
    }

    public String getFecha() {
        return fecha;
    }

    public void setFecha(String fecha) {
        this.fecha = fecha;
    }

    public String getPersona() {
        return persona;
    }

    public void setPersona(String persona) {
        this.persona = persona;
    }

    public String getBarrio() {
        return barrio;
    }

    public void setBarrio(String barrio) {
        this.barrio = barrio;
    }

    public String getImgPath() {
        return imgPath;
    }

    public void setImgPath(String imgPath) {
        this.imgPath = imgPath;
    }

    public String getInfo() {
        return info;
    }

    public void setInfo(String info) {
        this.info = info;
    }

    public String getPagina() {
        return pagina;
    }

    public void setPagina(String pagina) {
        this.pagina = pagina;
    }

    public String getEspecie() {
        return especie;
    }

    public void setEspecie(String especie) {
        this.especie = especie;
    }

    public String getRaza() {
        return raza;
    }

    public void setRaza(String raza) {
        this.raza = raza;
    }

    public String getCiudad() {
        return ciudad;
    }

    public void setCiudad(String ciudad) {
        this.ciudad = ciudad;
    }

    public String getDepartamento() {
        return departamento;
    }

    public void setDepartamento(String departamento) {
        this.departamento = departamento;
    }
    
    
    
    

    public void guardarCabecera(JsonArray arr) throws Exception {
        st = conn.createStatement();
        rs = st.executeQuery("SELECT coalesce(MAX(id),1678419) + 1 as num from encontrados");
        rs.next();
        String nid = rs.getString("num");
        st.executeUpdate("INSERT INTO encontrados(id, sis_estado, estado, latitud, longitud, contacto, fecha, persona, barrio, info) values('" + nid + "', 'PENDIENTE', 'ENCONTRADO', '" + latitud + "', '" + longitud + "', '" + contacto + "', '" + fecha + "', '" + persona + "', '" + barrio + "', '" + info + "')");
        out.println("AGREGADO CORRECTAMENTE");
        rs.close();
        st.close();
        guardarDetalle(nid, arr);
    }

    public void guardarDetalle(String encon, JsonArray arr) throws Exception {
        st = conn.createStatement();
        ResultSet pk;
        for (int i = 0; i < arr.size(); i++) {
            pk = st.executeQuery("SELECT coalesce(MAX(id),4331) + 1 as num from animales");
            pk.next();
            String aid = pk.getString("num");
            st.executeUpdate("INSERT INTO animales(id, descripcion, raza, genero) values('" + aid + "', '" + arr.getJsonObject(i).getString("descripcion") + "', '" + arr.getJsonObject(i).getString("idraza") + "', '" + arr.getJsonObject(i).getString("genero") + "')");
            Integer contad = 1;
            Files.createDirectory(Paths.get(imgPath + File.separator + aid));
            for (int j = 0; j < arr.getJsonObject(i).getJsonArray("imgs").size(); j++) {
                String nomb = aid + contad.toString();

                byte dearr[] = Base64.getDecoder().decode(arr.getJsonObject(i).getJsonArray("imgs").getString(j).split(",")[1]);
                FileOutputStream fos = new FileOutputStream(new File(imgPath + File.separator + aid + File.separator + nomb + ".jpg"));
                fos.write(dearr);
                fos.close();

                st.executeUpdate("INSERT INTO imagenes(path, nombre, idanimal) values('" + aid + "', '" + nomb + "', '" + aid + "')");
                contad++;
            }
            st.executeUpdate("INSERT INTO detalleencontrado(idencontrados, idanimal) values('" + encon + "', '" + aid + "')");
            pk.close();
        }
        st.close();
        
        out.println("AGREGADO CORRECTAMENTE 2");
    }

    public void modificar() throws Exception {
        /*st = utilidades.conexion.sta(st);
        st.executeUpdate("UPDATE departamentos SET nombre='" + nombre +"', codigo='" + codigo + "' WHERE id='" + id + "'");
        st.close();*/
        out.println("MODIFICADO CORRECTAMENTE");
    }
    
    
    public void modificarPost() throws Exception {
        st = conn.createStatement();
        st.executeUpdate("UPDATE encontrados SET contacto='" + contacto + "', info='" + info + "', latitud='" + latitud + "', longitud='" + longitud + "' WHERE id='" + id + "' AND persona='" +  persona + "'");
        st.close();
        out.println("MODIFICADO CORRECTAMENTE");
    }
    
    public void finalizarPost() throws Exception {
        st = conn.createStatement();
        st.executeUpdate("UPDATE encontrados SET estado='LOCALIZADO' WHERE id='" + id + "' AND persona='" + persona + "'");
        st.close();
        out.println("MODIFICADO CORRECTAMENTE");
    }
    
    public void elim() throws Exception {
        JsonArrayBuilder anis = Json.createArrayBuilder();
        st = conn.createStatement();
        st2 = conn.createStatement();

        rs = st2.executeQuery("SELECT idanimal FROM detalleencontrado WHERE idencontrados='" + id + "'");
        while (rs.next()) {
            anis.add(rs.getString(1));                
        }       
        rs.close();
        st2.close();
                
        JsonArray arr = anis.build();
        
        st.executeUpdate("DELETE FROM detalleencontrado WHERE idencontrados='" + id + "'");
        st.executeUpdate("DELETE FROM encontrados WHERE id='" + id + "'");
        
        for (int i = 0; i < arr.size(); i++) {
            st.executeUpdate("DELETE FROM imagenes WHERE idanimal='" + arr.getString(i) + "'");
            st.executeUpdate("DELETE FROM animales WHERE id='" + arr.getString(i) + "'");
            eliminarAn(arr.getString(i));
        }
                
        st.close();
                        
        out.println("ELIMINADO CORRECTAMENTE");
    }
     
     
      public void aprobar() throws Exception {
        st = conn.createStatement();
        st.executeUpdate("UPDATE encontrados SET sis_estado='APROBADO' WHERE id='" + id + "'");
        st.close();
        out.println("MODIFICADO CORRECTAMENTE");
    }

    public void eliminar() throws Exception {
        st = conn.createStatement();
        st.executeUpdate("DELETE FROM departamentos WHERE id='" + id + "'");
        st.close();
        out.println("ELIMINADO CORRECTAMENTE");
    }

    public JsonArray listar() throws Exception {

        st = conn.createStatement();
        rs = st.executeQuery("SELECT p.id, p.fecha, p.sis_estado, per.nombre FROM encontrados p INNER JOIN personas per ON p.persona=per.id WHERE NOT p.sis_estado='ELIMINADO';");

        JsonArrayBuilder arr = Json.createArrayBuilder();

        while (rs.next()) {
            JsonObject object = Json.createObjectBuilder()
                    .add("id", rs.getString(1))
                    .add("nombre", rs.getString(4))
                    .add("fecha", rs.getString(2))
                    .add("estado", rs.getString(3))
                    .build();
            arr.add(object);
        }
        st.close();
        rs.close();
        return arr.build();
    }
    
    
    
    
    
    
    
    
    
     public JsonArray listarUsuario() throws Exception {

        st = conn.createStatement();
        //String sql = "SELECT p.id, p.latitud, p.longitud, b.nombre, c.nombre, p.info, p.recompensa, p.fecha, p.contacto FROM perdidos p INNER JOIN barrios b ON p.barrio=b.id INNER JOIN ciudades c ON b.ciudad=c.id WHERE p.sis_estado='APROBADO' order by p.id desc limit 2 OFFSET " + pagina + ";";
        
        
        String sql = "SELECT p.id, p.latitud, p.longitud, b.nombre, c.nombre, p.info, p.recompensa, p.fecha, p.contacto, p.sis_estado FROM perdidos p INNER JOIN barrios b ON p.barrio=b.id INNER JOIN ciudades c ON b.ciudad=c.id WHERE p.persona='" + persona + "';";

        System.out.println(sql);
        rs = st.executeQuery(sql);
        
        ResultSet rr;
        ResultSet pk;
        
        JsonObjectBuilder respJ = Json.createObjectBuilder();

        JsonArrayBuilder postsL = Json.createArrayBuilder();

        while (rs.next()) {
            JsonObjectBuilder jb = Json.createObjectBuilder();


            String s = "s";            

            String postid = rs.getString(1);

            String lugar = rs.getString(4) + ", " + rs.getString(5);

            String lat = rs.getString(2);

            String lng = rs.getString(3);

            String recomp = rs.getString(7);

            String fechaa = rs.getString(8);
            
            String sis_es = rs.getString(10);
            
            jb.add("postid", postid);

            jb.add("lugar", lugar);
            jb.add("lat", lat);
            jb.add("lng", lng);
            jb.add("recompensa", recomp);
            jb.add("fecha", fechaa);
            jb.add("sis_estado", sis_es);

            

            st2 = conn.createStatement();
            
            
            String ssq = "SELECT det.idanimal, a.nombre, a.descripcion, a.genero, r.nombre, e.nombre FROM detalleperdidos det INNER JOIN animales a ON det.idanimal=a.id INNER JOIN razas r ON a.raza=r.id INNER JOIN especies e ON r.especie=e.id WHERE idperdidos='" + postid + "';";
            
            System.err.println(ssq);
            
            
            rr = st2.executeQuery("SELECT det.idanimal, a.nombre, a.descripcion, a.genero, r.nombre, e.nombre FROM detalleperdidos det INNER JOIN animales a ON det.idanimal=a.id INNER JOIN razas r ON a.raza=r.id INNER JOIN especies e ON r.especie=e.id WHERE idperdidos='" + postid + "';");
            
            Integer contad = 1;
            
            String nombress = "";
            
            String especieee = "";
            
            String idani = "";

            while (rr.next()) {
                
                if(contad > 1){
                    if(rr.isLast()){
                        nombress += " y " + rr.getString(2);
                    }
                    else{
                        nombress += ", " + rr.getString(2);
                    }     
                    if(!especieee.contains(rr.getString(6))){
                        especieee += ", " + rr.getString(6);
                    }
                }
                else{
                    nombress = rr.getString(2);
                    especieee = rr.getString(6);
                }
                

                idani = rr.getString(1);
                
                contad++;
            }

            rr.close();
            st2.close();
            
            st3 = conn.createStatement();
            

            pk = st3.executeQuery("SELECT path, nombre FROM imagenes WHERE idanimal='" + idani + "'");

            pk.next();
            
            String imggg = pk.getString(1) + "/" + pk.getString(2) + ".jpg";
            
            st3.close();
            pk.close();
            
            jb.add("nombres", nombress);
            jb.add("especie", especieee);
            jb.add("img", imggg);
            
            postsL.add(jb.build());
            

        }
        
        rs.close();
        st.close();

        return postsL.build();
    }
    
    
    
    
    
    
    
    
    
    
    
    public JsonArray listarBusqueda() throws Exception {

        st = conn.createStatement();
        //String sql = "SELECT p.id, p.latitud, p.longitud, b.nombre, c.nombre, p.info, p.recompensa, p.fecha, p.contacto FROM perdidos p INNER JOIN barrios b ON p.barrio=b.id INNER JOIN ciudades c ON b.ciudad=c.id WHERE p.sis_estado='APROBADO' order by p.id desc limit 2 OFFSET " + pagina + ";";
        
        
        String sql = "SELECT DISTINCT p.id, p.latitud, p.longitud, b.nombre, c.nombre, p.info, p.fecha, p.contacto, p.estado FROM  public.encontrados p JOIN  public.detalleencontrado dp ON p.id = dp.idencontrados JOIN  public.animales a ON dp.idanimal = a.id JOIN  public.razas r ON a.raza = r.id JOIN  public.especies e ON r.especie = e.id JOIN  public.barrios b ON p.barrio = b.id JOIN public.ciudades c ON b.ciudad = c.id JOIN public.departamentos d ON c.departamento = d.id WHERE p.sis_estado='APROBADO'";
        
        
        
        if(!departamento.equals("-1")){
            sql += " AND d.id='" + departamento + "'";
        }
        if(!ciudad.equals("-1")){
            sql += " AND c.id='" + ciudad + "'";
        }
        if(!barrio.equals("-1")){
            sql += " AND b.id='" + barrio + "'";
        }
        
        if(!especie.equals("-1")){
            sql += " AND e.id='" + especie + "'";
        }
        
        if(!raza.equals("-1")){
            sql += " AND r.id='" + raza + "'";
        }
        
        sql += " order by p.id desc limit 8 OFFSET " + pagina + ";";
        
        
        System.out.println(sql);
        rs = st.executeQuery(sql);
        
        ResultSet rr;
        ResultSet pk;
        
        
        JsonObjectBuilder respJ = Json.createObjectBuilder();

        JsonArrayBuilder postsL = Json.createArrayBuilder();

        while (rs.next()) {
            JsonObjectBuilder jb = Json.createObjectBuilder();


            String s = "s";            

            String postid = rs.getString(1);

            String lugar = rs.getString(5);

            String lat = rs.getString(2);

            String lng = rs.getString(3);

            String fechaa = rs.getString(7);
            
            String eestado = rs.getString(9);
            
            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate d1 = LocalDate.parse(fechaa, dtf);
            LocalDate d2 = LocalDate.parse(LocalDate.now().toString(), dtf);
            long dife = ChronoUnit.DAYS.between(d1, d2);
            fechaa = String.valueOf(dife);
            
            
            jb.add("postid", postid);

            jb.add("lugar", lugar);
            jb.add("lat", lat);
            jb.add("lng", lng);
            jb.add("fecha", fechaa);
            jb.add("estado", eestado);

            

            st2 = conn.createStatement();
            
            
            String ssq = "SELECT det.idanimal, a.nombre, a.descripcion, a.genero, r.nombre, e.nombre FROM detalleperdidos det INNER JOIN animales a ON det.idanimal=a.id INNER JOIN razas r ON a.raza=r.id INNER JOIN especies e ON r.especie=e.id WHERE idperdidos='" + postid + "';";
            
            System.err.println(ssq);
            
            
            rr = st2.executeQuery("SELECT det.idanimal, a.descripcion, a.genero, r.nombre, e.nombre FROM detalleencontrado det INNER JOIN animales a ON det.idanimal=a.id INNER JOIN razas r ON a.raza=r.id INNER JOIN especies e ON r.especie=e.id WHERE idencontrados='" + postid + "';");
            
            Integer contad = 1;
            
            String nombress = "";
            
            String especieee = "";
            
            String idani = "";

            while (rr.next()) {
                
                if(contad > 1){   
                    nombress = "Encontrados";
                    if(!especieee.contains(rr.getString(5))){
                        especieee += ", " + rr.getString(5);
                    }
                }
                else{
                    especieee = rr.getString(5);
                    nombress = "Encontrado";
                }
                

                idani = rr.getString(1);
                
                contad++;
            }

            rr.close();
            st2.close();
            
            st3 = conn.createStatement();
            

            pk = st3.executeQuery("SELECT path, nombre FROM imagenes WHERE idanimal='" + idani + "'");

            pk.next();
            
            String imggg = pk.getString(1) + "/" + pk.getString(2) + ".jpg";
            
            st3.close();
            pk.close();
            
            jb.add("encont", nombress);
            jb.add("especie", especieee);
            jb.add("img", imggg);
            
            postsL.add(jb.build());
            

        }
        
        rs.close();
        st.close();

        return postsL.build();
    }

    
    
    
    
    
    

    public JsonArray listarHome() throws Exception {

        st = conn.createStatement();
        String sql = "SELECT p.id, p.latitud, p.longitud, b.nombre, c.nombre, p.info, p.fecha, p.contacto, p.estado FROM encontrados p INNER JOIN barrios b ON p.barrio=b.id INNER JOIN ciudades c ON b.ciudad=c.id WHERE p.sis_estado='APROBADO' order by p.id desc limit 8;";
        System.out.println(sql);
        rs = st.executeQuery(sql);
        
        ResultSet rr;
        ResultSet pk;
        
        
        JsonObjectBuilder respJ = Json.createObjectBuilder();

        JsonArrayBuilder postsL = Json.createArrayBuilder();

        while (rs.next()) {
            JsonObjectBuilder jb = Json.createObjectBuilder();


            String s = "s";            

            String postid = rs.getString(1);

            String lugar = rs.getString(5);

            String lat = rs.getString(2);

            String lng = rs.getString(3);

            String fechaa = rs.getString(7);
            
            String eestado = rs.getString(9);
            
            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate d1 = LocalDate.parse(fechaa, dtf);
            LocalDate d2 = LocalDate.parse(LocalDate.now().toString(), dtf);
            long dife = ChronoUnit.DAYS.between(d1, d2);
            fechaa = String.valueOf(dife);
            
            
            jb.add("postid", postid);

            jb.add("lugar", lugar);
            jb.add("lat", lat);
            jb.add("lng", lng);
            jb.add("fecha", fechaa);
            jb.add("estado", eestado);

            

            st2 = conn.createStatement();
            
            
            String ssq = "SELECT det.idanimal, a.nombre, a.descripcion, a.genero, r.nombre, e.nombre FROM detalleperdidos det INNER JOIN animales a ON det.idanimal=a.id INNER JOIN razas r ON a.raza=r.id INNER JOIN especies e ON r.especie=e.id WHERE idperdidos='" + postid + "';";
            
            System.err.println(ssq);
            
            
            rr = st2.executeQuery("SELECT det.idanimal, a.descripcion, a.genero, r.nombre, e.nombre FROM detalleencontrado det INNER JOIN animales a ON det.idanimal=a.id INNER JOIN razas r ON a.raza=r.id INNER JOIN especies e ON r.especie=e.id WHERE idencontrados='" + postid + "';");
            
            Integer contad = 1;
            
            String nombress = "";
            
            String especieee = "";
            
            String idani = "";

            while (rr.next()) {
                
                if(contad > 1){   
                    nombress = "Encontrados";
                    if(!especieee.contains(rr.getString(5))){
                        especieee += ", " + rr.getString(5);
                    }
                }
                else{
                    especieee = rr.getString(5);
                    nombress = "Encontrado";
                }
                

                idani = rr.getString(1);
                
                contad++;
            }

            rr.close();
            st2.close();
            
            st3 = conn.createStatement();
            

            pk = st3.executeQuery("SELECT path, nombre FROM imagenes WHERE idanimal='" + idani + "'");

            pk.next();
            
            String imggg = pk.getString(1) + "/" + pk.getString(2) + ".jpg";
            
            st3.close();
            pk.close();
            
            jb.add("encont", nombress);
            jb.add("especie", especieee);
            jb.add("img", imggg);
            
            postsL.add(jb.build());
            

        }
        
        rs.close();
        st.close();

        return postsL.build();
    }

    public JsonObject listarID() throws Exception {

        st = conn.createStatement();
        String sql = "SELECT b.nombre, c.nombre, per.nombre, p.latitud, p.longitud, p.info, p.fecha, p.contacto, p.sis_estado, per.imagen, p.id, per.barrio, p.estado FROM encontrados p INNER JOIN personas per ON p.persona=per.id INNER JOIN barrios b ON p.barrio=b.id INNER JOIN ciudades c ON b.ciudad=c.id  WHERE p.id='" + id + "'";
        if(persona != null){
            sql += " AND p.persona='" + persona + "' AND p.estado='ENCONTRADO'";
        }
        rs = st.executeQuery(sql);

        rs.next();

        JsonObjectBuilder jb = Json.createObjectBuilder();

        if (rs.getRow() == 0) {
            return jb.add("hay", false)
                    .build();
        }

        String s = "s";

        jb.add("hay", true);

        String nombre = rs.getString(3);

        String lugar = rs.getString(1) + ", " + rs.getString(2);

        String lat = rs.getString(4);

        String lng = rs.getString(5);

        String infoo = rs.getString(6);

        String fechaa = rs.getString(7);

        String contac = rs.getString(8);
        
        String sis_estado = rs.getString(9);
        
        String per_img = rs.getString(10);
        
        String postid = rs.getString(11);
        
        String perbarr = rs.getString(12);
        
        String pestado = rs.getString(13);

        jb.add("nombre", nombre);
        jb.add("postid", postid);
        jb.add("lugar", lugar);
        jb.add("lat", lat);
        jb.add("lng", lng);
        jb.add("info", infoo);
        jb.add("fecha", fechaa);
        jb.add("contacto", contac);
        jb.add("sis_estado", sis_estado);
        jb.add("per_imagen", per_img);
        jb.add("p_estado", pestado);

        rs.close();
        
        rs = st.executeQuery("SELECT c.nombre from barrios b inner join ciudades c on b.ciudad=c.id WHERE b.id='" + perbarr + "';");
        
        rs.next();
        
        String perciu = rs.getString(1);
        
        rs.close();
        
        jb.add("per_ciudad", perciu);
        
        
        st.close();

        st2 = conn.createStatement();
        ResultSet rr;
        
        ResultSet pk;

        rr = st2.executeQuery("SELECT det.idanimal, a.descripcion, a.genero, r.nombre, e.nombre FROM detalleencontrado det INNER JOIN animales a ON det.idanimal=a.id INNER JOIN razas r ON a.raza=r.id INNER JOIN especies e ON r.especie=e.id WHERE idencontrados='" + id + "';");

        JsonArrayBuilder ani = Json.createArrayBuilder();

        while (rr.next()) {
            String ida = rr.getString(1);
            JsonObjectBuilder object = Json.createObjectBuilder()
                    .add("descripcion", rr.getString(2))
                    .add("raza", rr.getString(4))
                    .add("especie", rr.getString(5))
                    .add("genero", rr.getString(3));

            st3 = conn.createStatement();
            

            pk = st3.executeQuery("SELECT path, nombre FROM imagenes WHERE idanimal='" + ida + "'");

            JsonArrayBuilder imgs = Json.createArrayBuilder();

            while (pk.next()) {
                imgs.add(pk.getString(1) + "/" + pk.getString(2) + ".jpg");
            }

            pk.close();
            st3.close();

            object.add("imgs", imgs.build());

            ani.add(object.build());
        }

        rr.close();
        st2.close();

        jb.add("mascotas", ani.build());

        return jb.build();
    }
    
    
    
    public void eliminarAn(String codigo){
        File file = new File(imgPath + File.separator + codigo);

        deleteDirectory(file);
 
        file.delete();
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

}
