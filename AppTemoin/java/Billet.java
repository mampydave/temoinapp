package Office;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import mg.itu.prom16.etu2564.ControllerAnnotation;
import mg.itu.prom16.etu2564.ModelView;
import mg.itu.prom16.etu2564.Param;
import mg.itu.prom16.etu2564.Post;
import mg.itu.prom16.etu2564.Url;
import connection.*;
@ControllerAnnotation
public class Billet {
    int idreservation;
    String numero_Vol;
    String ville_depart;
    String ville_arrivee;
    String numero_siege;
    String date_depart;
    String heure_depart;
    double prixBillet;
    String classeEcoOrBusi;
    String beneficiaire;

    public Billet() {}
    
    public Billet(int idreservation, String numero_Vol, String ville_depart, String ville_arrivee, String numero_siege,String date_depart, String heure_depart,double prixBillet) {
        this.idreservation = idreservation;
        this.numero_Vol = numero_Vol;
        this.ville_depart = ville_depart;
        this.ville_arrivee = ville_arrivee;
        this.numero_siege = numero_siege;
        this.date_depart = date_depart;
        this.heure_depart = heure_depart;
        this.prixBillet = prixBillet;
    }

    public int getIdreservation() {
        return idreservation;
    }
    
    public void setIdreservation(int idreservation) {
        this.idreservation = idreservation;
    }
    public String getNumero_Vol() {
        return numero_Vol;
    }
    public void setNumero_Vol(String numero_Vol) {
        this.numero_Vol = numero_Vol;
    }
    public String getVille_depart() {
        return ville_depart;
    }
    public void setVille_depart(String ville_depart) {
        this.ville_depart = ville_depart;
    }
    public String getVille_arrivee() {
        return ville_arrivee;
    }
    public void setVille_arrivee(String ville_arrivee) {
        this.ville_arrivee = ville_arrivee;
    }
    public String getNumero_siege() {
        return numero_siege;
    }
    public void setNumero_siege(String numero_siege) {
        this.numero_siege = numero_siege;
    }
    public String getDate_depart() {
        return date_depart;
    }
    public void setDate_depart(String date_depart) {
        this.date_depart = date_depart;
    }
    public String getHeure_depart() {
        return heure_depart;
    }
    public void setHeure_depart(String heure_depart) {
        this.heure_depart = heure_depart;
    }

    public double getPrixBillet() {
        return prixBillet;
    }

    public void setPrixBillet(double prixBillet) {
        this.prixBillet = prixBillet;
    }
    public String getClasseEcoOrBusi() {
        return classeEcoOrBusi;
    }

    public void setClasseEcoOrBusi(String classeEcoOrBusi) {
        this.classeEcoOrBusi = classeEcoOrBusi;
    }

    public static ArrayList<Billet> billetOfUser(String idUser) {

        String sql = "SELECT id_reservation, id_passager, v.id_vol, v.date_heure_depart::DATE as date_depart,v.date_heure_depart::TIME as heure_depart, v.numero_vol, ville_depart.nom_ville AS ville_depart, ville_arrivee.nom_ville AS ville_arrivee, Si.Numero_Siege, date_reservation, statut_reservation, prixBillet,TY.types,RE.beneficiaire FROM reservation RE JOIN vol v ON RE.id_vol = v.id_vol JOIN sieges Si ON Si.id_siege = RE.id_siege JOIN villes ville_depart ON v.aeroport_depart = ville_depart.id_ville JOIN villes ville_arrivee ON v.aeroport_arrivee = ville_arrivee.id_ville JOIN type_siege TY ON Si.id_type_siege = TY.id_type_siege WHERE id_passager = ? and statut_reservation = 'Reserve'";
        ArrayList<Billet> billets = new ArrayList<>();
    
        try (Connection conn = Connect.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, Integer.parseInt(idUser));

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                int id_reservation = rs.getInt("id_reservation");
                String date_depart = rs.getString("date_depart");
                String heure_depart = rs.getString("heure_depart");
                String numero_vol = rs.getString("numero_vol");
                String ville_dep = rs.getString("ville_depart");
                String ville_destin = rs.getString("ville_arrivee");
                String numeroSiege = rs.getString("numero_siege");
                double prixBillet = rs.getDouble("prixbillet");
                String types = rs.getString("types");
                String benef = rs.getString("beneficiaire");

                Billet billet = new Billet(id_reservation, numero_vol, ville_dep, ville_destin, numeroSiege, date_depart, heure_depart, prixBillet);
                billet.setClasseEcoOrBusi(types);
                billet.setBeneficiaire(benef);
                billets.add(billet);
            }

        } catch (SQLException e) {
            e.printStackTrace();

        }


        return billets;
    }

    public String getBeneficiaire() {
        return beneficiaire;
    }

    public void setBeneficiaire(String beneficiaire) {
        this.beneficiaire = beneficiaire;
    }


}
