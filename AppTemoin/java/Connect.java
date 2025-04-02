package connection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Connect {

    private static final String URL = "jdbc:postgresql://localhost:5432/Roplane";
    private static final String USER = "itu";
    private static final String PASSWORD = "itu16";

    public static Connection getConnection() throws SQLException {
        Connection connection = null;
        try {
            System.out.println("Chargement du driver PostgreSQL...");
            Class.forName("org.postgresql.Driver");
            System.out.println("Driver PostgreSQL chargé avec succès.");

            System.out.println("Connexion à la base de données...");
            connection = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Connexion réussie à la base de données.");

        } catch (ClassNotFoundException e) {
            // Erreur si le driver n'est pas trouvé
            System.err.println("Erreur : Le driver JDBC PostgreSQL n'a pas été trouvé.");
            e.printStackTrace();
            throw new SQLException("Erreur lors du chargement du driver JDBC.", e);

        } catch (SQLException e) {
            // Erreur de connexion
            System.err.println("Erreur : Problème de connexion à la base de données.");
            e.printStackTrace();
            throw new SQLException("Erreur lors de la connexion à la base de données : " + e.getMessage(), e);
        }
        return connection;
    }
}
