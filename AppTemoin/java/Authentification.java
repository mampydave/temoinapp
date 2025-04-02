package Office;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import connection.*;
import mg.itu.prom16.etu2564.*;

@ControllerAnnotation
public class Authentification {
    @Required
    @Myemail
    private String email;
    @Required
    String mdp;

    
    public String getEmail() {
        return email;
    }


    public void setEmail(String email) {
        this.email = email;
    }


    public String getMdp() {
        return mdp;
    }


    public void setMdp(String mdp) {
        this.mdp = mdp;
    }


}
