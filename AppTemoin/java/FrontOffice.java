package Office;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;

import Office.Age;
import Office.Billet;
import Office.Siege;
import Office.Vol;
import mg.itu.prom16.etu2564.*;
import toscan.User;
import connection.*;

@ControllerAnnotation
@Roles({"user","admin"})
public class FrontOffice {
    Mysession userConnecter;
    
    @Url("/inSession")
    @Post
    public ModelView mettreSession(@Param("idVol") String idVol,@Param("idUser") String idUser,Mysession session) {
        ModelView model=new ModelView("reservation.jsp");
        ArrayList<Siege> sieges = Siege.getAllSiege(Vol.getavionUsedByvol(idVol));
        
        session.add("idVol", Integer.parseInt(idVol));
        userConnecter.add("idUser", idUser);
        userConnecter.add("dreamVol", idVol);
        model.addObject("sieges", sieges);
        // model.addObject("session", one);
        return model;
    }
    
    @Url("/processReservation")
    @Post
    public ModelView ReserveBillet(@Param("idUser") String idpassager,@Param("idVol") String idVol,@Param("dateReservation") String dateReservation,@Param("selectedSeats") String idSIege,@Param("ages") String age) {
        ModelView model = new ModelView("reservation.jsp");
    
        System.out.println("Selected Seats: " + idSIege);
        System.out.println("Ages: " + age);

        String sql = "INSERT INTO Reservation(ID_Passager,ID_Vol,ID_Siege,Date_Reservation,beneficiaire,prixbillet) VALUES(?,?,?,CAST(? AS TIMESTAMP),?,?)";
        
        // LocalDateTime now = LocalDateTime.now();

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        DateTimeFormatter formatterJava = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
        // String dateReservation = now.format(formatter);

        LocalDateTime reservationDate = LocalDateTime.parse(dateReservation,formatterJava);
        String[] siegeIds = idSIege.split(",");
        String[] ageArray = age.split(",");
        System.out.println("passager :"+idpassager+"  - "+idVol+" _ "+idSIege+" now :" +dateReservation);
        Office.Vol myvol = Office.Vol.getVolBYId(idVol);

        double prixPlaceEconomique = Double.parseDouble(myvol.getPrixEco());
        double prixPlaceBusiness = Double.parseDouble(myvol.getPrixBusiness());
        double pourcentage = Vol.getPourcentagePromo(idVol);
        String endingDate =Vol.getFinReservation(idVol);
        LocalDateTime finReservation = LocalDateTime.parse(endingDate,formatter);
        try (Connection conn = Connect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
                
            if (reservationDate.isEqual(finReservation) || reservationDate.isAfter(finReservation)) {
                model.addObject("message", "Cette vol n'est plus disponible, dernier reservation accepter fait a : "+endingDate);
            }
            else{

                for (int i = 0; i < siegeIds.length; i++) {
                    String siegeId = siegeIds[i];
                    String personneAssis = ageArray[i];
                    Age infoPersonne = Age.getAgeInfo(Integer.parseInt(personneAssis));
                    pourcentage += infoPersonne.getPromotion();
                    double prixInserer = 0.0;
                
                    int ecoOrBusi = Siege.getTypeSiegeByid(siegeId);
                    int siegeReserve = Siege.comptSiegeReserve(idVol, ecoOrBusi);
                    int usedPromo = Siege.comptPromoByType(idVol, ecoOrBusi);
                
                    stmt.setInt(1, Integer.parseInt(idpassager));
                    stmt.setInt(2, Integer.parseInt(idVol));
                    stmt.setInt(3, Integer.parseInt(siegeId));
                    stmt.setString(4, dateReservation);
                    stmt.setString(5, infoPersonne.getBeneficiaire());
                    if (siegeReserve <= usedPromo) {
                        if (Classe.isBusiness(ecoOrBusi)) {
                            prixInserer = Vol.calculerPrixavecPromo(pourcentage, prixPlaceBusiness);
                        } else {
                            prixInserer = Vol.calculerPrixavecPromo(pourcentage, prixPlaceEconomique);
                        }
                        stmt.setDouble(6, prixInserer);
                    } else {
                        if (Classe.isBusiness(ecoOrBusi)) {
                            stmt.setDouble(6, prixPlaceBusiness);
                        } else {
                            stmt.setDouble(6, prixPlaceEconomique);
                        }
                    }
                
                    stmt.executeUpdate();
                }
                    
            }    

        } catch (SQLException e) {
            e.printStackTrace();
            model.addObject("message", "Erreur lors de la création du vol.");
        }
        model.addObject("sieges", Siege.getAllSiege(Vol.getavionUsedByvol(idVol)));
        // model.addObject("avions", Avion.getAllAvion());
        // model.addObject("villes", Ville.getAllVille());
        return model;
    }

    @Url("/annuler")
    @Post
    public ModelView annulerVol(@Param("idreservation") String reservationId,@Param("dateAnnulation") String annulationDate) {
        ModelView model = new ModelView("listBillet");

        String sql = "update reservation set statut_reservation = 'annule' where id_passager = ? and id_reservation = ?";
        String idUser = null;

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        DateTimeFormatter formatterJava = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
        
        String annulateEnd = Vol.getFinAnnulation((String) userConnecter.get("dreamVol"));

        LocalDateTime annuleBillet = LocalDateTime.parse(annulationDate,formatterJava);
        LocalDateTime endingDateTime = LocalDateTime.parse(annulateEnd,formatter);
        
        try (Connection conn = Connect.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
           
            if (annuleBillet.isEqual(endingDateTime) || annuleBillet.isAfter(endingDateTime)) {
                model.addObject("message", "annulation non reussi , date fin accepter : "+annulateEnd+" qui est deja depasser");
            }else{
                if (userConnecter != null) {
                    idUser = (String) userConnecter.get("idUser");
                }

                stmt.setInt(1, Integer.parseInt(idUser));
                stmt.setInt(2, Integer.parseInt(reservationId));
    
                int rowsDeleted = stmt.executeUpdate();
                if (rowsDeleted > 0) {
                    model.addObject("message", "Vol annuler avec succès !");
                }
            }


        } catch (SQLException e) {
            e.printStackTrace();
            model.addObject("message", "Erreur lors de l'annulation du billet.");
        }


        return model;
    }

    @Url("/listBilletLien")
    @Post
    public ModelView billetOfUserlien(@Param("idUser") String idUser) {
        ModelView model = new ModelView("billet.jsp");

    
        model.addObject("billets", Billet.billetOfUser(idUser));
        // if (userConnecter == null) {
            userConnecter.add("idUser", idUser);
            // System.out.println("insert user in session");
        // }

        return model;
    }

    @Url("/listBillet")
    public ModelView billetOfUser() {
        ModelView model = new ModelView("billet.jsp");
        
        if (userConnecter != null) {
            model.addObject("billets", Billet.billetOfUser((String)userConnecter.get("idUser")));            
        }

        return model;
    }

    @Url("/telechargerBillet")
    public ModelView telechargerBillet(@Param("idreservation") String idReservation) {
        ModelView mv = new ModelView("listBillet");

        try {
            PdfApiClient apiClient = new PdfApiClient("api-config.properties");
            byte[] pdfBytes = apiClient.downloadPdf(idReservation).readAllBytes();
            
            mv.addObject("__isBinary", true); 
            mv.addObject("contentType", "application/pdf");
            mv.addObject("contentDisposition", 
                        "attachment; filename=billet-" + idReservation + ".pdf");
            mv.addObject("data", pdfBytes);
        } catch (Exception e) {
            
            mv.addObject("message", "Erreur PDF: " + e.getMessage());
            
        }
        return mv;

    }

    
}
