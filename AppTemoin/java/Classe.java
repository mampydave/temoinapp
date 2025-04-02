package Office;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import connection.*;
import mg.itu.prom16.etu2564.ModelView;

public class Classe {
    int idType;
    String typeClasse;
    
    public Classe() {
    }
    public Classe(int idType, String typeClasse) {
        this.idType = idType;
        this.typeClasse = typeClasse;
    }
    public int getIdType() {
        return idType;
    }
    public void setIdType(int idType) {
        this.idType = idType;
    }
    public String getTypeClasse() {
        return typeClasse;
    }
    public void setTypeClasse(String typeClasse) {
        this.typeClasse = typeClasse;
    }
    
    public static ArrayList<Classe> getAllClasse() {
        ArrayList<Classe> one = new ArrayList<>();

        String sql = "select id_type_siege,types from type_siege";

        try (Connection conn = Connect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
                
            while (rs.next()) {
                int idclasse = rs.getInt("id_type_siege");
                String nomClasse = rs.getString("types");

                Classe classrecuperer = new Classe(idclasse,nomClasse);
                one.add(classrecuperer);

            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return one;
    }

    public static boolean isBusiness(int idtype){
        if (idtype == 2) {
            return true;
        }
        return false;
    }
    
}
