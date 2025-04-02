package Office;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import Office.Authentification;
import mg.itu.prom16.etu2564.*;
import connection.*;
@ControllerAnnotation
public class Fonction {
 

    @Url("/login")
    @Post
    public ModelView login(Authentification user,ValidationResult validate,Mysession request) {
        ModelView model = new ModelView("interfaceVol");
        String message = "Login error";
        String role = null;
        int idUser = 0;
        String sql = "select ID_User,roles from users where Email = ? and mdp = ?";
        if (validate.hasErrors()) {
            ModelView errorView = new ModelView("index.jsp");
            errorView.setValidationResult(validate);
            return errorView;
        }   
        try (Connection conn = Connect.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, user.getEmail());
            stmt.setString(2, user.getMdp());
            
            try (ResultSet resultat = stmt.executeQuery()) { 

                while (resultat.next()) {
                    role = resultat.getString("roles");
                    idUser = resultat.getInt("ID_User");
                }

                if (role != null && !role.isEmpty()) {
                    ArrayList<Object> one = new ArrayList<>();
                    one.add(true); 
                    one.add(role); 
                    one.add(idUser);
            
                    request.add("userInfo", one);
                    message = "Login successful";               
                }
        
                model.addObject("message", message);   
            }         
        } catch (Exception e) {
            e.printStackTrace();
        }


        return model;
    }

    @Url("/logout")
    public ModelView logout() {
        ModelView model=new ModelView("index.jsp");
        
        return model;
    }


}
