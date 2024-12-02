/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utilidades;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;

/**
 *
 * @author Usuario
 */
public class EmailAPI {
    
    HttpClient client;

    public EmailAPI() {
        client = HttpClient.newHttpClient();
    }
    
    
    
    
    public void enviarCodReg(String nombre, String email, String codigo) throws URISyntaxException, IOException, InterruptedException {
        
        Map<String,String> params = new HashMap<>();
        
        String para = nombre + " <" + email + ">";
        String cdex = "{\"recovercode\": \"" + codigo + "\"}";
        
        params.put("from", "MymbApp <EMAIL>");
        params.put("to", para);
        params.put("subject", "Recuperar Cuenta");
        params.put("template", "recoveracc");
        params.put("h:X-Mailgun-Variables", cdex);
        
        HttpRequest request = HttpRequest.newBuilder()
            .uri(new URI("https://api.mailgun.net/v3/EMAIL/messages"))
            .POST(getParamsUrlEncoded(params))
            .headers("Authorization", "Basic APIKEY")
            .headers("Content-Type", "application/x-www-form-urlencoded")
            .build();
        System.getLogger("").log(System.Logger.Level.INFO, request.toString());
        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
        System.err.println(response.body());
    }

    private HttpRequest.BodyPublisher getParamsUrlEncoded(Map<String, String> parameters) {
        String urlEncoded = parameters.entrySet()
                            .stream()
                            .map(e -> e.getKey() + "=" + URLEncoder.encode(e.getValue(), StandardCharsets.UTF_8))
                            .collect(Collectors.joining("&"));
        return HttpRequest.BodyPublishers.ofString(urlEncoded);
    }
    
    
    
}
