package Office;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import connection.*;
import mg.itu.prom16.etu2564.*;
@ControllerAnnotation
public class Vol {
    private int idVol;
    @Required
    private String numeroVol;
    @Required
    private String modeleAvion;
    @Required
    @Mydate("yyyy-MM-dd HH:mm")
    private String dateHeureDepart;
    @Required
    @Mydate("yyyy-MM-dd HH:mm")
    private String dateHeureArrivee;
    @Required
    private String aeroportDepart;
    @Required
    private String aeroportArrivee;
    
    private String pourcentage;
    private String nbSiegePromoEco;
    private String nbSiegePromoBusi;
    @Required
    @Mydate("HH:mm")
    private String parametrageReservartion;
    @Required
    @Mydate("HH:mm")
    private String parametrageAnnulation;
    @Required
    private String prixEco;
    @Required
    private String prixBusiness;



    public Vol() {}

    public Vol(int idVol, String numeroVol, String modeleAvion, String dateHeureDepart, String dateHeureArrivee, String aeroportDepart, String aeroportArrivee) {
        this.idVol = idVol;
        this.numeroVol = numeroVol;
        this.modeleAvion = modeleAvion;
        this.dateHeureDepart = dateHeureDepart;
        this.dateHeureArrivee = dateHeureArrivee;
        this.aeroportDepart = aeroportDepart;
        this.aeroportArrivee = aeroportArrivee;
    }

    public Vol(String numeroVol, String modeleAvion, String dateHeureDepart, String dateHeureArrivee, String aeroportDepart, String aeroportArrivee) {
        this.numeroVol = numeroVol;
        this.modeleAvion = modeleAvion;
        this.dateHeureDepart = dateHeureDepart;
        this.dateHeureArrivee = dateHeureArrivee;
        this.aeroportDepart = aeroportDepart;
        this.aeroportArrivee = aeroportArrivee;
    }

    public int getIdVol() {
        return idVol;
    }

    public void setIdVol(int idVol) {
        this.idVol = idVol;
    }

    public String getNumeroVol() {
        return numeroVol;
    }

    public void setNumeroVol(String numeroVol) {
        this.numeroVol = numeroVol;
    }

    public String getModeleAvion() {
        return modeleAvion;
    }

    public void setModeleAvion(String modeleAvion) {
        this.modeleAvion = modeleAvion;
    }

    public String getDateHeureDepart() {
        return dateHeureDepart;
    }

    public void setDateHeureDepart(String dateHeureDepart) {
        this.dateHeureDepart = dateHeureDepart;
    }

    public String getDateHeureArrivee() {
        return dateHeureArrivee;
    }

    public void setDateHeureArrivee(String dateHeureArrivee) {
        this.dateHeureArrivee = dateHeureArrivee;
    }

    public String getAeroportDepart() {
        return aeroportDepart;
    }

    public void setAeroportDepart(String aeroportDepart) {
        this.aeroportDepart = aeroportDepart;
    }

    public String getAeroportArrivee() {
        return aeroportArrivee;
    }

    public void setAeroportArrivee(String aeroportArrivee) {
        this.aeroportArrivee = aeroportArrivee;
    }
    public String getPourcentage() {
        return pourcentage;
    }

    public void setPourcentage(String pourcentage) {
        this.pourcentage = pourcentage;
    }
    public String getNbSiegePromoEco() {
        return nbSiegePromoEco;
    }

    public void setNbSiegePromoEco(String nbSiegePromoEco) {
        this.nbSiegePromoEco = nbSiegePromoEco;
    }

    public String getNbSiegePromoBusi() {
        return nbSiegePromoBusi;
    }

    public void setNbSiegePromoBusi(String nbSiegePromoBusi) {
        this.nbSiegePromoBusi = nbSiegePromoBusi;
    }

    public String getParametrageReservartion() {
        return parametrageReservartion;
    }

    public void setParametrageReservartion(String parametrageReservartion) {
        this.parametrageReservartion = parametrageReservartion;
    }

    public String getParametrageAnnulation() {
        return parametrageAnnulation;
    }

    public void setParametrageAnnulation(String parametrageAnnulation) {
        this.parametrageAnnulation = parametrageAnnulation;
    }
    public String getPrixEco() {
        return prixEco;
    }

    public void setPrixEco(String prixEco) {
        this.prixEco = prixEco;
    }

    public String getPrixBusiness() {
        return prixBusiness;
    }

    public void setPrixBusiness(String prixBusiness) {
        this.prixBusiness = prixBusiness;
    }
    @Override
    public String toString() {
        return "Vol{" +
                "idVol=" + idVol +
                ", numeroVol='" + numeroVol + '\'' +
                ", modeleAvion='" + modeleAvion + '\'' +
                ", dateHeureDepart='" + dateHeureDepart + '\'' +
                ", dateHeureArrivee='" + dateHeureArrivee + '\'' +
                ", aeroportDepart='" + aeroportDepart + '\'' +
                ", aeroportArrivee='" + aeroportArrivee + '\'' +
                '}';
    }
    @Url("/interfaceVol")
    public ModelView interfaceVol(){
        ModelView model = new ModelView("accueil.jsp");
        model.addObject("resultats", Vol.getAllVol());
        model.addObject("avions", Avion.getAllAvion());
        model.addObject("villes", Ville.getAllVille());
        return model;
    }

    public static ArrayList<Vol> getAllVol() {
        ModelView model = new ModelView("accueil.jsp");
        ArrayList<Vol> one = new ArrayList<>();

        String sql = "SELECT V.ID_Vol, V.Numero_Vol, A.Modele AS Modele_Avion, V.Date_Heure_Depart, V.Date_Heure_Arrivee, VD.nom_ville AS Aeroport_Depart, VA.nom_ville AS Aeroport_Arrivee,prixeco,prixbusi FROM vol V LEFT JOIN avion A ON V.ID_Avion = A.ID_Avion JOIN villes VD ON V.Aeroport_Depart = VD.ID_Ville JOIN villes VA ON V.Aeroport_Arrivee = VA.ID_Ville";

        try (Connection conn = Connect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
                
            while (rs.next()) {
                int idvol = rs.getInt("ID_Vol");
                String volNum = rs.getString("Numero_Vol");
                String avionName = rs.getString("Modele_Avion");
                String heureDep = rs.getString("Date_Heure_Depart");
                String heureArr = rs.getString("Date_Heure_Arrivee");
                String villeDep = rs.getString("Aeroport_Depart");
                String villeArr = rs.getString("Aeroport_Arrivee");
                String prixEco = rs.getString("prixeco");
                String busi = rs.getString("prixbusi");
                Vol volrecuperer = new Vol(idvol,volNum,avionName,heureDep,heureArr,villeDep,villeArr);
                volrecuperer.setPrixEco(prixEco);
                volrecuperer.setPrixBusiness(busi);
                one.add(volrecuperer);

            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return one;
    }




    @Url("/searchVolMultiCritere")
    public ModelView searchVols(@Param("numeroVol") String numeroVol,@Param("modeleAvion") String modeleAvion,@Param("dateHeureDepart") String dateHeureDepart,@Param("dateHeureArrivee") String dateHeureArrivee,@Param("aeroportDepart") String aeroportDepart,@Param("aeroportArrivee") String aeroportArrivee) {
        ModelView model = new ModelView("accueil.jsp");

        StringBuilder sql = new StringBuilder("SELECT v.ID_Vol, v.Numero_Vol, a.modele AS Modele_Avion, v.Date_Heure_Depart, v.Date_Heure_Arrivee, VD.nom_ville AS Aeroport_Depart, VA.nom_ville AS Aeroport_Arrivee ,prixeco,prixbusi ");
        sql.append("FROM vol v JOIN avion a ON v.ID_Avion = a.ID_Avion JOIN villes VD ON v.Aeroport_Depart = VD.ID_Ville JOIN villes VA ON v.Aeroport_Arrivee = VA.ID_Ville WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (numeroVol != null && !numeroVol.isEmpty()) {
            sql.append("AND v.Numero_Vol = ? ");
            params.add(numeroVol);
        }
        if (modeleAvion != null && !modeleAvion.isEmpty()) {
            sql.append("AND v.ID_Avion = ? ");
            params.add(Integer.parseInt(modeleAvion));
        }
        if (dateHeureDepart != null && !dateHeureDepart.isEmpty()) {
            sql.append("AND v.Date_Heure_Depart = CAST(? AS timestamp)");
            params.add(dateHeureDepart);
        }
        if (dateHeureArrivee != null && !dateHeureArrivee.isEmpty()) {
            sql.append("AND v.Date_Heure_Arrivee = CAST(? AS timestamp)");
            params.add(dateHeureArrivee);
        }
        if (aeroportDepart != null && !aeroportDepart.isEmpty()) {
            sql.append("AND v.Aeroport_Depart = ? ");
            params.add(Integer.parseInt(aeroportDepart));
        }
        if (aeroportArrivee != null && !aeroportArrivee.isEmpty()) {
            sql.append("AND v.Aeroport_Arrivee = ? ");
            params.add(Integer.parseInt(aeroportArrivee));
        }

        ArrayList<Vol> allbycriteria = new ArrayList<>();
        try (Connection conn = Connect.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            System.out.println(stmt);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    int idvol = rs.getInt("ID_Vol");
                    String volNum = rs.getString("Numero_Vol");
                    String avionName = rs.getString("Modele_Avion");
                    String heureDep = String.valueOf(rs.getTimestamp("Date_Heure_Depart")) ;
                    String heureArr = String.valueOf(rs.getTimestamp("Date_Heure_Arrivee"));
                    String villeDep = rs.getString("Aeroport_Depart");
                    String villeArr = rs.getString("Aeroport_Arrivee");
                    String prixEco = rs.getString("prixeco");
                    String busi = rs.getString("prixbusi");
                    Vol volrecuperer = new Vol(idvol,volNum,avionName,heureDep,heureArr,villeDep,villeArr);
                    volrecuperer.setPrixEco(prixEco);
                    volrecuperer.setPrixBusiness(busi);
                    allbycriteria.add(volrecuperer);
                }
            }
            
            model.addObject("resultats", allbycriteria);
            
        } catch (SQLException e) {
            e.printStackTrace();
            model.addObject("message", "Erreur lors de la recherche des vols.");
        }
        model.addObject("avions", Avion.getAllAvion());
        model.addObject("villes", Ville.getAllVille());
        return model;
    }

    
    public static String getavionUsedByvol(String idVol) {

        String sql = "select id_avion from vol where id_vol = ?";
        String idavion = "0";
        try (Connection conn = Connect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             stmt.setInt(1, Integer.parseInt(idVol));
             ResultSet rs = stmt.executeQuery();
                
            while (rs.next()) {
                idavion = rs.getString("id_avion");

            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return idavion;
    }


    public static Vol getVolBYId(String id_vol) {
        Vol one = new Vol();

        String sql = "SELECT V.ID_Vol, V.Numero_Vol, A.Modele AS Modele_Avion, V.Date_Heure_Depart, V.Date_Heure_Arrivee, VD.nom_ville AS Aeroport_Depart, VA.nom_ville AS Aeroport_Arrivee,prixeco,prixbusi FROM vol V LEFT JOIN avion A ON V.ID_Avion = A.ID_Avion JOIN villes VD ON V.Aeroport_Depart = VD.ID_Ville JOIN villes VA ON V.Aeroport_Arrivee = VA.ID_Ville where id_vol = ?";

        try (Connection conn = Connect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, Integer.parseInt(id_vol));
             ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                int idvol = rs.getInt("ID_Vol");
                String volNum = rs.getString("Numero_Vol");
                String avionName = rs.getString("Modele_Avion");
                String heureDep = rs.getString("Date_Heure_Depart");
                String heureArr = rs.getString("Date_Heure_Arrivee");
                String villeDep = rs.getString("Aeroport_Depart");
                String villeArr = rs.getString("Aeroport_Arrivee");
                String prixEco = rs.getString("prixeco");
                String busi = rs.getString("prixbusi");
                one = new Vol(idvol,volNum,avionName,heureDep,heureArr,villeDep,villeArr);
                one.setPrixEco(prixEco);
                one.setPrixBusiness(busi);

            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return one;
    }

    public static double getPourcentagePromo(String id_vol) {
        double pourcentage = 0.0;

        String sql = "select promotion from promotion where id_vol = ? limit 1";

        try (Connection conn = Connect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, Integer.parseInt(id_vol));
             ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                pourcentage = rs.getDouble("promotion");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return pourcentage;
    }

    public static String getFinReservation(String id_vol) {
        String finreservation=null;

        String sql = "select date_heure_depart - parametragereservation as finReservation from vol where id_vol = ?";

        try (Connection conn = Connect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, Integer.parseInt(id_vol));
             ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                finreservation = rs.getString("finReservation");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return finreservation;
    }

    public static String getFinAnnulation(String id_vol) {
        String finreservation=null;

        String sql = "SELECT date_heure_depart - CASE WHEN annulationreservation = '00:00' THEN INTERVAL '1 DAY' ELSE annulationreservation::INTERVAL END AS finAnnulation FROM vol WHERE id_vol = ?";

        try (Connection conn = Connect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, Integer.parseInt(id_vol));
             ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                finreservation = rs.getString("finAnnulation");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return finreservation;
    }

    public static double calculerPrixavecPromo(double promo,double prix){
        double reponse = 0.0;
        double ecart = (prix * promo) / 100;
        reponse = prix - ecart;
        return reponse;
    } 
}
