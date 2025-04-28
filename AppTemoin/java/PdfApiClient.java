package Office;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Properties;

import mg.itu.prom16.etu2564.ControllerAnnotation;
@ControllerAnnotation
public class PdfApiClient {
    
    private final String apiBaseUrl;
    
    public PdfApiClient(String configFilePath) {
        this.apiBaseUrl = loadApiUrl(configFilePath);
    }
    
    private String loadApiUrl(String configFilePath) {
        try (InputStream input = getClass().getClassLoader().getResourceAsStream(configFilePath)) {
            Properties prop = new Properties();
            prop.load(input);
            return prop.getProperty("pdf.api.base.url");
        } catch (IOException e) {
            throw new RuntimeException("Erreur de chargement de la config API", e);
        }
    }
    
    public InputStream downloadPdf(String reservationId) throws IOException {
        String apiUrl = apiBaseUrl + "/reservations/" + reservationId + "/download";
        URL url = new URL(apiUrl);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("GET");
        
        if (connection.getResponseCode() != 200) {
            throw new IOException("Échec de l'appel API : HTTP " + connection.getResponseCode());
        }
        
        return connection.getInputStream();
    }
}