/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utilidades;

import jakarta.json.Json;
import jakarta.json.JsonObject;
import jakarta.json.JsonReader;
import java.io.StringReader;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

/**
 *
 * @author Usuario
 */
public class AdamsPayAPI {
    
    HttpClient client;

    public AdamsPayAPI() {
        client = HttpClient.newHttpClient();
    }
    
    public JsonObject iniciarPago(JsonObject obj) throws Exception{
        System.err.println(obj.toString());
        HttpRequest request = HttpRequest.newBuilder()
            .uri(new URI("https://staging.adamspay.com/api/v1/debts"))
            .POST(HttpRequest.BodyPublishers.ofString(obj.toString()))
            .headers("apikey", "APIKEY")
            .headers("x-if-exists", "update")
            .headers("Content-Type", "application/json")
            .build();
        System.getLogger("===============================").log(System.Logger.Level.INFO, request.toString());
        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
        System.err.println(response.body());
        
        JsonReader jsonReader = Json.createReader(new StringReader(response.body()));
        JsonObject res = jsonReader.readObject();
        jsonReader.close();
        
        return res;
    }
    
    
    
    public JsonObject consultarPago(String id) throws Exception{
        String url = "https://staging.adamspay.com/api/v1/debts/" + id;
        HttpRequest request = HttpRequest.newBuilder()
            .uri(new URI(url))
            .GET()
            .headers("apikey", "APIKEY")
            .build();
        System.getLogger("=============================").log(System.Logger.Level.INFO, request.toString());
        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
        System.err.println(response.body());
        
        JsonReader jsonReader = Json.createReader(new StringReader(response.body()));
        JsonObject res = jsonReader.readObject();
        jsonReader.close();
        
        return res;
    }
    
}
