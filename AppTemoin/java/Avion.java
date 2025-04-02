package Office;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import mg.itu.prom16.etu2564.ModelView;
import mg.itu.prom16.etu2564.Url;
import connection.*; 
public class Avion {
    int ID_Avion;
    String modele;
    String date_fabrication;

    public Avion() {
    }
    
    public Avion(int iD_Avion, String modele, String date_fabrication) {
        ID_Avion = iD_Avion;
        this.modele = modele;
        this.date_fabrication = date_fabrication;
    }

    public Avion(String modele, String date_fabrication) {
        this.modele = modele;
        this.date_fabrication = date_fabrication;
    }

    public int getID_Avion() {
        return ID_Avion;
    }
    public void setID_Avion(int iD_Avion) {
        ID_Avion = iD_Avion;
    }
    public String getModele() {
        return modele;
    }
    public void setModele(String modele) {
        this.modele = modele;
    }
    public String getDate_fabrication() {
        return date_fabrication;
    }
    public void setDate_fabrication(String date_fabrication) {
        this.date_fabrication = date_fabrication;
    }

    public static ArrayList<Avion> getAllAvion() {

        ArrayList<Avion> one = new ArrayList<>();

        String sql = "select id_avion,modele,date_fabrication from avion";

        try (Connection conn = Connect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
                
            while (rs.next()) {
                int id_avion = rs.getInt("id_avion");
                String modele = rs.getString("modele");
                String date_fabrication = rs.getString("date_fabrication");

                Avion avionRecuperer = new Avion(id_avion,modele,date_fabrication);
                one.add(avionRecuperer);

            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return one;
    }

}
