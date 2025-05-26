package Office;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import connection.*;
import mg.itu.prom16.etu2564.ControllerAnnotation;
import mg.itu.prom16.etu2564.ModelView;
import mg.itu.prom16.etu2564.Param;
import mg.itu.prom16.etu2564.Url;

@ControllerAnnotation
public class Siege {
    int idSiege;
    String avion;
    String classe;
    String numSiege;
    String statut;
    public Siege(){}

    
    public Siege(int idSiege, String avion, String classe, String numSiege, String statut) {
        this.idSiege = idSiege;
        this.avion = avion;
        this.classe = classe;
        this.numSiege = numSiege;
        this.statut = statut;
    }

    public int getIdSiege() {
        return idSiege;
    }
    public void setIdSiege(int idSiege) {
        this.idSiege = idSiege;
    }
    public String getAvion() {
        return avion;
    }
    public void setAvion(String avion) {
        this.avion = avion;
    }
    public String getClasse() {
        return classe;
    }
    public void setClasse(String classe) {
        this.classe = classe;
    }
    public String getStatut() {
        return statut;
    }
    public void setStatut(String statut) {
        this.statut = statut;
    }

    public String getNumSiege() {
        return numSiege;
    }
    public void setNumSiege(String numSiege) {
        this.numSiege = numSiege;
    }

    public static ArrayList<Siege> getAllSiegeDispo(String avion){
        ArrayList<Siege> one = new ArrayList<>();

        String sql = "select ID_Siege,A.modele,T.types as classe,numero_siege,statut from sieges S join avion A on S.ID_Avion=A.ID_Avion join type_siege T on S.id_type_siege = T.ID_Type_Siege where S.ID_Avion = ? and statut <> 'Reserve'";

        try (Connection conn = Connect.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, Integer.parseInt(avion));
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                int id_Siege = rs.getInt("ID_Siege");
                String avionName = rs.getString("modele");
                String classe = rs.getString("classe");
                String numSiege = rs.getString("numero_siege");
                String status = rs.getString("statut");


                Siege SiegeRecuperer = new Siege(id_Siege,avionName,classe,numSiege,status);
                one.add(SiegeRecuperer);

            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return one;
    }

    public static ArrayList<Siege> getAllSiege(String avion, String idvol){
        // ModelView model = new ModelView("reservation.jsp");
        ArrayList<Siege> one = new ArrayList<>();

        String sql = "SELECT S.ID_Siege,A.modele,T.types AS classe,S.numero_siege,R.Statut_Reservation AS statut,V.id_vol FROM sieges S JOIN avion A ON S.ID_Avion = A.ID_Avion JOIN type_siege T ON S.id_type_siege = T.ID_Type_Siege JOIN vol V ON V.ID_Avion = A.ID_Avion LEFT JOIN Reservation R ON S.id_siege = R.ID_Siege AND R.id_vol = V.id_vol WHERE S.ID_Avion = ? AND V.id_vol = ?";

        try (Connection conn = Connect.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, Integer.parseInt(avion));
            stmt.setInt(2, Integer.parseInt(idvol));
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                int id_Siege = rs.getInt("ID_Siege");
                String avionName = rs.getString("modele");
                String classe = rs.getString("classe");
                String numSiege = rs.getString("numero_siege");
                String status = rs.getString("statut");


                Siege SiegeRecuperer = new Siege(id_Siege,avionName,classe,numSiege,status);
                one.add(SiegeRecuperer);

            }


        } catch (SQLException e) {
            e.printStackTrace();
        }
        return one;
    }

    public static int comptSiegeReserve(String id_vol,int id_type){
        int one = 0;

        String sql = "select count(RE.id_siege) from reservation RE JOIN sieges S on RE.id_siege = S.id_siege where statut_reservation = 'Reserve' and S.id_type_siege = ? and id_vol = ?";

        try (Connection conn = Connect.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id_type);

            stmt.setInt(2, Integer.parseInt(id_vol));
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                one = rs.getInt("count");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return one;
    }

    public static int comptPromoByType(String id_vol,int classe){
        int one = 0;

        String sql = "select sum(nbsiegepromotion) from promotion where id_vol = ? and type_siege = ?";

        try (Connection conn = Connect.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, Integer.parseInt(id_vol));

            stmt.setInt(2, classe);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                one = rs.getInt("sum");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return one;
    }


    public static int getTypeSiegeByid(String idSiege){

        int reps = 0;
        String sql = "select id_type_siege from sieges where id_siege = ?";

        try (Connection conn = Connect.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, Integer.parseInt(idSiege));    
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                reps = rs.getInt("id_type_siege");

            }


        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reps;
    }
}
