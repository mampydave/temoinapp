<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*,Office.*" %>

<html>
    <head>
        <title>Mes Billets Réservés</title>
        <link rel="stylesheet" href="assets/billet.css">
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const profileBtn = document.querySelector(".profile-btn");
                const dropdown = document.querySelector(".dropdown-content");
            
                profileBtn.addEventListener("click", function () {
                    dropdown.style.display = (dropdown.style.display === "block") ? "none" : "block";
                });
            
                // Cacher le menu si on clique en dehors
                document.addEventListener("click", function (event) {
                    if (!profileBtn.contains(event.target) && !dropdown.contains(event.target)) {
                        dropdown.style.display = "none";
                    }
                });
            });
        </script>
            
    </head>
    <body>
        <header>
            <h1>🛫 Mes Billets Réservés 🛬</h1>
            <div class="profile-menu">
                <button class="profile-btn" id="profileBtn">👤More ▼</button>
                <div class="dropdown-content" id="profileDropdown">
                    <a href="interfaceVol">Accueil</a>
                    <a href="logout">Se Déconnecter</a>
                </div>
            </div>
        </header>

        <table>
            <tr>
                <th>Numéro de Vol</th>
                <th>Ville de Départ</th>
                <th>Ville d'Arrivée</th>
                <th>Numéro de Siège</th>
                <th>Date de Départ</th>
                <th>Heure de Départ</th>
                <th>Prix</th>
                <th>Classe</th>
                <th>Beneficiaire</th>
                <th>Action</th>
            </tr>

            <%
                ArrayList<Billet> billets = (ArrayList<Billet>) request.getAttribute("billets");

                if (billets != null && !billets.isEmpty()) {
                    for (Billet res : billets) {
            %>
                        <tr>
                            <td><%= res.getNumero_Vol() %></td>
                            <td><%= res.getVille_depart() %></td>
                            <td><%= res.getVille_arrivee() %></td>
                            <td><%= res.getNumero_siege() %></td>
                            <td><%= res.getDate_depart() %></td>
                            <td><%= res.getHeure_depart() %></td>
                            <td><%= res.getPrixBillet() %></td>
                            <td><%= res.getClasseEcoOrBusi() %></td>
                            <td><%= res.getBeneficiaire() %></td>

                            <td>
                                <form action="annuler" method="post">
                                    <input type="hidden" name="idreservation" value="<%= res.getIdreservation() %>">
                                    <input type="datetime-local" name="dateAnnulation" required>
                                    <button type="submit" class="annuler-btn">Annuler</button>
                                </form>
                            </td>
                        </tr>
            <%
                    }
                } else {
                    out.println("<tr><td colspan='7' style='text-align:center;'>Aucune réservation fait.</td></tr>");
                }
            %>

        </table>
        <% 
            String message = (String) request.getAttribute("message");
            if (message != null && !message.isEmpty()) { 
        %>
            <script>
                alert("<%= message %>");
            </script>
        <% } %>
    </body>
</html>
