package Office;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import mg.itu.prom16.etu2564.ModelView;
import mg.itu.prom16.etu2564.Url;
import connection.*;
public class Ville {
    int id_ville;
    String nom_ville;
    
    public Ville() {
    }
    
    public Ville(int id_ville, String nom_ville) {
        this.id_ville = id_ville;
        this.nom_ville = nom_ville;
    }

    public int getId_ville() {
        return id_ville;
    }
    public void setId_ville(int id_ville) {
        this.id_ville = id_ville;
    }
    public String getNom_ville() {
        return nom_ville;
    }
    public void setNom_ville(String nom_ville) {
        this.nom_ville = nom_ville;
    }

    public static ArrayList<Ville> getAllVille(){
        ArrayList<Ville> one = new ArrayList<>();

        String sql = "select id_ville,nom_ville from villes";

        try (Connection conn = Connect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
                
            while (rs.next()) {
                int id_ville = rs.getInt("id_ville");
                String nom_ville = rs.getString("nom_ville");


                Ville villeRecuperer = new Ville(id_ville,nom_ville);
                one.add(villeRecuperer);

            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return one;
    }
}
