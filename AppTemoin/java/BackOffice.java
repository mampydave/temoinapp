package Office;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import Office.Avion;
import Office.Ville;
import Office.Vol;
import connection.Connect;
import mg.itu.prom16.etu2564.*;

@ControllerAnnotation
@Roles({"admin"})
public class BackOffice {
    
    @Url("/createVol")
    @Post
    public ModelView createVol(Office.Vol fly,ValidationResult validate) {
        ModelView model = new ModelView("accueil.jsp");
    
        String sql = "INSERT INTO vol (Numero_Vol, ID_Avion, Date_Heure_Depart, Date_Heure_Arrivee, Aeroport_Depart, Aeroport_Arrivee,PrixEco,PRixBusi,parametrageReservation,annulationReservation) VALUES (?, ?, CAST(? AS TIMESTAMP), CAST(? AS TIMESTAMP), ?, ?,?,?,CAST(? AS TIME),CAST(? AS TIME))";
        
        if (validate.hasErrors()) {

            ModelView errorView = new ModelView("ajout.jsp");
            errorView.addObject("resultats", Vol.getAllVol());
            errorView.addObject("avions", Avion.getAllAvion());
            errorView.addObject("villes", Ville.getAllVille());
            errorView.setValidationResult(validate);
            
            return errorView;
        }   
        
        try (Connection conn = Connect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
    
            stmt.setString(1,fly.getNumeroVol());
            stmt.setInt(2, Integer.parseInt(fly.getModeleAvion()));
            stmt.setString(3, fly.getDateHeureDepart());
            stmt.setString(4, fly.getDateHeureArrivee());
            stmt.setInt(5, Integer.parseInt(fly.getAeroportDepart()));
            stmt.setInt(6, Integer.parseInt(fly.getAeroportArrivee()));
            stmt.setDouble(7, Double.parseDouble(fly.getPrixEco()));
            stmt.setDouble(8, Double.parseDouble(fly.getPrixBusiness()));
            stmt.setString(9, fly.getParametrageReservartion());
            stmt.setString(10, fly.getParametrageAnnulation());

            int rowsInserted = stmt.executeUpdate();
           
            if (rowsInserted > 0) {
                model.addObject("message", "Vol créé avec succès !");
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        System.out.println("next value ok");
                        int generatedId = rs.getInt(1);
                        if (fly.getPourcentage()!=null && !fly.getPourcentage().isEmpty()) {
                            if (fly.getNbSiegePromoEco()!=null && !fly.getNbSiegePromoEco().isEmpty()) {
                                this.insertPromo(generatedId, fly.getPourcentage(), fly.getNbSiegePromoEco(), "1");   
                            }
                            if (fly.getNbSiegePromoBusi()!=null && !fly.getNbSiegePromoBusi().isEmpty()) {
                                this.insertPromo(generatedId, fly.getPourcentage(), fly.getNbSiegePromoBusi(), "2");   
                            }
                        }
                        model.addObject("message", "Vol créé avec succès ! ID : " + generatedId);
                    }
                }
            }
    
        } catch (SQLException e) {
            e.printStackTrace();
            model.addObject("message", "Erreur lors de la création du vol.");
        }
        model.addObject("resultats", Vol.getAllVol());
        model.addObject("avions", Avion.getAllAvion());
        model.addObject("villes", Ville.getAllVille());
        return model;
    }

    @Url("/updateVol")
    @Post
    @Restapi
    public ModelView updateVol(Office.Vol flyaway,ValidationResult validate){
        ModelView model = new ModelView("accueil.jsp");

        String sql = "UPDATE vol SET Numero_Vol = ?,ID_Avion = ?,Date_Heure_Depart = CAST(? AS TIMESTAMP),Date_Heure_Arrivee = CAST(? AS TIMESTAMP),Aeroport_Depart = ?,Aeroport_Arrivee = ?,prixeco = ?,prixbusi =? WHERE ID_Vol = ?";
        
        if (validate.hasErrors()) {

            // ModelView errorView = new ModelView("ajout.jsp");
            model.addObject("resultats", Vol.getAllVol());
            model.addObject("avions", Avion.getAllAvion());
            model.addObject("villes", Ville.getAllVille());
            model.setValidationResult(validate);
            
            return model;
        }   
        try (Connection conn = Connect.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
                
            stmt.setString(1,flyaway.getNumeroVol());
            stmt.setInt(2, Integer.parseInt(flyaway.getModeleAvion()));
            stmt.setString(3, flyaway.getDateHeureDepart());
            stmt.setString(4, flyaway.getDateHeureArrivee());
            stmt.setInt(5, Integer.parseInt(flyaway.getAeroportDepart()));
            stmt.setInt(6, Integer.parseInt(flyaway.getAeroportArrivee()));
            
            stmt.setDouble(7, Double.parseDouble(flyaway.getPrixEco()));
            stmt.setDouble(8, Double.parseDouble(flyaway.getPrixBusiness()));
            stmt.setInt(9, flyaway.getIdVol());
            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated > 0) {
                model.addObject("message", "Vol mis à jour avec succès !");
            } else {
                model.addObject("message", "Aucune mise à jour effectuée. Vérifiez l'ID du vol.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            model.addObject("message", "Erreur lors de la mise à jour du vol.");
        }
        model.addObject("resultats", Vol.getAllVol());
        model.addObject("avions", Avion.getAllAvion());
        model.addObject("villes", Ville.getAllVille());
        
        return model;
    }

    

    @Url("/deleteVol")
    @Post
    public ModelView deleteVol(@Param("idVol") int idVol) {
        ModelView model = new ModelView("accueil.jsp");

        String sql = "DELETE FROM vol WHERE ID_Vol = ?";

        try (Connection conn = Connect.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idVol);
            int rowsDeleted = stmt.executeUpdate();
            if (rowsDeleted > 0) {
                model.addObject("message", "Vol supprimé avec succès !");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            model.addObject("message", "Erreur lors de la suppression du vol.");
        }
        model.addObject("resultats", Vol.getAllVol());
        model.addObject("avions", Avion.getAllAvion());
        model.addObject("villes", Ville.getAllVille());

        return model;
    }

    @Url("/ajout")
    public ModelView ajout(){
        ModelView model = new ModelView("ajout.jsp");
        model.addObject("resultats", Vol.getAllVol());
        model.addObject("avions", Avion.getAllAvion());
        model.addObject("villes", Ville.getAllVille());
        return model;
    }
    @Url("/update")
    public ModelView update(){
        ModelView model = new ModelView("update.jsp");
        model.addObject("resultats", Vol.getAllVol());
        model.addObject("avions", Avion.getAllAvion());
        model.addObject("villes", Ville.getAllVille());
        return model;
    }

    public void insertPromo(int idVol,String promotion,String nbSiegePromotion,String typeSiege) {

        String sql = "INSERT INTO promotion(ID_Vol,promotion,nbSiegepromotion,type_Siege) VALUES (?,?,?,?)";

        try (Connection conn = Connect.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idVol);
            stmt.setDouble(2, Double.parseDouble(promotion));
            stmt.setInt(3, Integer.parseInt(nbSiegePromotion));
            stmt.setInt(4, Integer.parseInt(typeSiege));
            stmt.executeUpdate();
            

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }
    // @Url("/detailsVol")
    // public ModelView getVolById(int idVol) {
    //     ModelView model = new ModelView("details.jsp");

    //     String sql = "SELECT ID_Vol, Numero_Vol, A.Modele, Date_Heure_Depart, Date_Heure_Arrivee, Aeroport_Depart, Aeroport_Arrivee FROM vol V JOIN avion A ON V.ID_Avion = A.ID_Avion WHERE ID_Vol = ?";

    //     try (Connection conn = Connect.getConnection();
    //         PreparedStatement stmt = conn.prepareStatement(sql)) {

    //         stmt.setInt(1, idVol);
    //         ResultSet rs = stmt.executeQuery();

    //         if (rs.next()) {
    //             String numeroVol = rs.getString("Numero_Vol");
    //             String modeleAvion = rs.getString("Modele");
    //             String dateHeureDepart = rs.getString("Date_Heure_Depart");
    //             String dateHeureArrivee = rs.getString("Date_Heure_Arrivee");
    //             String aeroportDepart = rs.getString("Aeroport_Depart");
    //             String aeroportArrivee = rs.getString("Aeroport_Arrivee");

    //             Vol vol = new Vol(idVol, numeroVol, modeleAvion, dateHeureDepart, dateHeureArrivee, aeroportDepart, aeroportArrivee);
    //             model.addObject("message", vol);
    //         }

    //     } catch (SQLException e) {
    //         e.printStackTrace();
    //     }

    //     return model;
    // }
}
