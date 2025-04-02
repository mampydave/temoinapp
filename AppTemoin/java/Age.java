package Office;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import connection.*;
import mg.itu.prom16.etu2564.ControllerAnnotation;

@ControllerAnnotation
public class Age {
    int idAge;
    String beneficiaire;
    double promotion;
    public Age(){}

    public Age(int idAge, String beneficiaire, double promotion) {
        this.idAge = idAge;
        setBeneficiaire(beneficiaire);
        setPromotion(promotion);

    }
    public int getIdAge() {
        return idAge;
    }
    public void setIdAge(int idAge) {
        this.idAge = idAge;
    }
    public String getBeneficiaire() {
        return beneficiaire;
    }
    public void setBeneficiaire(String beneficiaire) {
        this.beneficiaire = beneficiaire;
        if (beneficiaire == null || beneficiaire.isEmpty()) {
            this.beneficiaire = "Adulte";
        }
    }
    public double getPromotion() {
        return promotion;
    }
    public void setPromotion(double promotion) {
        this.promotion = promotion;    
    }

    public static Age getAgeInfo(int age){
        Age one = new Age();

        String sql = "SELECT id_age,beneficitaire,promo FROM ages WHERE min_age <= ? AND max_age >= ? order by id_age desc limit 1";
        double promo = 0.0;
        try (Connection conn = Connect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, age);
            stmt.setInt(2, age);
            ResultSet rs = stmt.executeQuery();
    
            while (rs.next()) {
                int id_age = rs.getInt("id_age");
                String beneficiaire = rs.getString("beneficitaire");
                promo = rs.getDouble("promo");
                one = new Age(id_age,beneficiaire,promo);

            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return one;
    }
    
}
