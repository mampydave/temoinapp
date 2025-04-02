<%@ page contentType="text/html; charset=UTF-8" %>
<%@page import ="Office.*,java.util.*,mg.itu.prom16.etu2564.ValidationResult"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% ArrayList<Ville> villes = (ArrayList<Ville>) request.getAttribute("villes"); %>
<% ArrayList<Avion> avions = (ArrayList<Avion>) request.getAttribute("avions"); %>
<% ArrayList<Vol> resultats = (ArrayList<Vol>) request.getAttribute("resultats"); %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Vols</title>
    <link rel="stylesheet" href="assets/vol.css">
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            document.body.style.opacity = "1";
            document.body.style.filter = "none";
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
        <h1>🛫 Gestion des Vols 🛬</h1>
        <div class="profile-menu">
            <button class="profile-btn" id="profileBtn">👤More ▼</button>
            <div class="dropdown-content" id="profileDropdown">
                <% 
                    ArrayList<Object> userInfo = (ArrayList<Object>) session.getAttribute("userInfo");
        
                    if (userInfo != null) {
                        String role = (String) userInfo.get(1);
                        int idUser = (int) userInfo.get(2);
                        if(!role.equalsIgnoreCase("admin")){ %>
                            <form action="listBilletLien" method="post">
                                <input type="hidden" name="idUser" value="<%= idUser %>">
                                <button type="submit" >Mes Billets</button>
                            </form>
                        
            <%          }
                    } 
                %>
                <a href="logout">Se Déconnecter</a>
            </div>
        </div>
    </header>
    <section class="add-section">
        <h2>Ajouter un Nouveau Vol</h2>
        <form action="createVol" method="POST">
            <input type="text" name="fly.numeroVol" placeholder="Numéro de vol" value="<%= request.getAttribute("validation") != null ? ((ValidationResult) request.getAttribute("validation")).getFieldValue("numeroVol") : "" %>">
            <% if (request.getAttribute("validation") != null) { %>
                <% ValidationResult validation = (ValidationResult)request.getAttribute("validation"); %>
                <% if (!validation.getFieldErrors("numeroVol").isEmpty()) { %>
                    <div class="error">
                        <% for (String error : validation.getFieldErrors("numeroVol")) { %>
                            <%= error %><br>
                        <% } %>
                    </div>
                <% } %>
            <% } %>
            <select name="fly.modeleAvion">
                <% 
                    String selectedModele = request.getAttribute("validation") != null ? 
                        ((ValidationResult) request.getAttribute("validation")).getFieldValue("modeleAvion") : "";
                    for (Avion a : avions) { 
                %>
                    <option value="<%= a.getID_Avion() %>" <%= String.valueOf(a.getID_Avion()).equals(selectedModele) ? "selected" : "" %>>
                        <%= a.getModele() %>
                    </option>
                <% } %>
            </select>
            
            <% if (request.getAttribute("validation") != null) { %>
                <% ValidationResult validation = (ValidationResult) request.getAttribute("validation"); %>
                <% if (!validation.getFieldErrors("modeleAvion").isEmpty()) { %>
                    <div class="error">
                        <% for (String error : validation.getFieldErrors("modeleAvion")) { %>
                            <%= error %><br>
                        <% } %>
                    </div>
                <% } %>
            <% } %>
            
            <input type="text" name="fly.dateHeureDepart" placeholder="dateHeureDepart" value="<%= request.getAttribute("validation") != null ? ((ValidationResult) request.getAttribute("validation")).getFieldValue("dateHeureDepart") : "" %>">
            <% if (request.getAttribute("validation") != null) { %>
                <% ValidationResult validation = (ValidationResult)request.getAttribute("validation"); %>
                <% if (!validation.getFieldErrors("dateHeureDepart").isEmpty()) { %>
                    <div class="error">
                        <% for (String error : validation.getFieldErrors("dateHeureDepart")) { %>
                            <%= error %><br>
                        <% } %>
                    </div>
                <% } %>
            <% } %>
            <input type="text" name="fly.dateHeureArrivee" placeholder="dateHeureArrivee" value="<%= request.getAttribute("validation") != null ? ((ValidationResult) request.getAttribute("validation")).getFieldValue("dateHeureArrivee") : "" %>">
            <% if (request.getAttribute("validation") != null) { %>
                <% ValidationResult validation = (ValidationResult)request.getAttribute("validation"); %>
                <% if (!validation.getFieldErrors("dateHeureArrivee").isEmpty()) { %>
                    <div class="error">
                        <% for (String error : validation.getFieldErrors("dateHeureArrivee")) { %>
                            <%= error %><br>
                        <% } %>
                    </div>
                <% } %>
            <% } %>

            <select name="fly.aeroportDepart">
                <% 
                    String selectedDepart = request.getAttribute("validation") != null ? 
                        ((ValidationResult) request.getAttribute("validation")).getFieldValue("aeroportDepart") : "";
                    for (Ville v : villes) { 
                %>
                    <option value="<%= v.getId_ville() %>" <%= String.valueOf(v.getId_ville()).equals(selectedDepart) ? "selected" : "" %>>
                        <%= v.getNom_ville() %>
                    </option>
                <% } %>
            </select>

            <% if (request.getAttribute("validation") != null) { %>
                <% ValidationResult validation = (ValidationResult) request.getAttribute("validation"); %>
                <% if (!validation.getFieldErrors("aeroportDepart").isEmpty()) { %>
                    <div class="error">
                        <% for (String error : validation.getFieldErrors("aeroportDepart")) { %>
                            <%= error %><br>
                        <% } %>
                    </div>
                <% } %>
            <% } %>

            <select name="fly.aeroportArrivee">
                <% 
                    String selectedArrivee = request.getAttribute("validation") != null ? 
                        ((ValidationResult) request.getAttribute("validation")).getFieldValue("aeroportArrivee") : "";
                    for (Ville v : villes) { 
                %>
                    <option value="<%= v.getId_ville() %>" <%= String.valueOf(v.getId_ville()).equals(selectedArrivee) ? "selected" : "" %>>
                        <%= v.getNom_ville() %>
                    </option>
                <% } %>
            </select>

            <% if (request.getAttribute("validation") != null) { %>
                <% ValidationResult validation = (ValidationResult) request.getAttribute("validation"); %>
                <% if (!validation.getFieldErrors("aeroportArrivee").isEmpty()) { %>
                    <div class="error">
                        <% for (String error : validation.getFieldErrors("aeroportArrivee")) { %>
                            <%= error %><br>
                        <% } %>
                    </div>
                <% } %>
            <% } %>

            <input type="text" name="fly.pourcentage" placeholder="Pourcentage promotion" value="<%= request.getAttribute("validation") != null ? ((ValidationResult) request.getAttribute("validation")).getFieldValue("pourcentage") : "" %>">
            <% if (request.getAttribute("validation") != null) { %>
                <% ValidationResult validation = (ValidationResult)request.getAttribute("validation"); %>
                <% if (!validation.getFieldErrors("pourcentage").isEmpty()) { %>
                    <div class="error">
                        <% for (String error : validation.getFieldErrors("pourcentage")) { %>
                            <%= error %><br>
                        <% } %>
                    </div>
                <% } %>
            <% } %>

            <input type="text" name="fly.nbSiegePromoEco" placeholder="Nb Siege en Promotion Eco" value="<%= request.getAttribute("validation") != null ? ((ValidationResult) request.getAttribute("validation")).getFieldValue("nbSiegePromoEco") : "" %>">
            <% if (request.getAttribute("validation") != null) { %>
                <% ValidationResult validation = (ValidationResult)request.getAttribute("validation"); %>
                <% if (!validation.getFieldErrors("nbSiegePromoEco").isEmpty()) { %>
                    <div class="error">
                        <% for (String error : validation.getFieldErrors("nbSiegePromoEco")) { %>
                            <%= error %><br>
                        <% } %>
                    </div>
                <% } %>
            <% } %>

            <input type="text" name="fly.nbSiegePromoBusi" placeholder="Nb Siege en Promotion Business" value="<%= request.getAttribute("validation") != null ? ((ValidationResult) request.getAttribute("validation")).getFieldValue("nbSiegePromoBusi") : "" %>">
            <% if (request.getAttribute("validation") != null) { %>
                <% ValidationResult validation = (ValidationResult)request.getAttribute("validation"); %>
                <% if (!validation.getFieldErrors("nbSiegePromoBusi").isEmpty()) { %>
                    <div class="error">
                        <% for (String error : validation.getFieldErrors("nbSiegePromoBusi")) { %>
                            <%= error %><br>
                        <% } %>
                    </div>
                <% } %>
            <% } %>

            <input type="text" name="fly.parametrageReservartion" placeholder="heure fin avant vol" value="<%= request.getAttribute("validation") != null ? ((ValidationResult) request.getAttribute("validation")).getFieldValue("parametrageReservartion") : "" %>">
            <% if (request.getAttribute("validation") != null) { %>
                <% ValidationResult validation = (ValidationResult)request.getAttribute("validation"); %>
                <% if (!validation.getFieldErrors("parametrageReservartion").isEmpty()) { %>
                    <div class="error">
                        <% for (String error : validation.getFieldErrors("parametrageReservartion")) { %>
                            <%= error %><br>
                        <% } %>
                    </div>
                <% } %>
            <% } %>

            <input type="text" name="fly.parametrageAnnulation" placeholder="heure fin d'annulation" value="<%= request.getAttribute("validation") != null ? ((ValidationResult) request.getAttribute("validation")).getFieldValue("parametrageAnnulation") : "" %>">
            <% if (request.getAttribute("validation") != null) { %>
                <% ValidationResult validation = (ValidationResult)request.getAttribute("validation"); %>
                <% if (!validation.getFieldErrors("parametrageAnnulation").isEmpty()) { %>
                    <div class="error">
                        <% for (String error : validation.getFieldErrors("parametrageAnnulation")) { %>
                            <%= error %><br>
                        <% } %>
                    </div>
                <% } %>
            <% } %>

            <input type="text" name="fly.prixEco" placeholder="Prix classe Eco" value="<%= request.getAttribute("validation") != null ? ((ValidationResult) request.getAttribute("validation")).getFieldValue("prixEco") : "" %>">
            <% if (request.getAttribute("validation") != null) { %>
                <% ValidationResult validation = (ValidationResult)request.getAttribute("validation"); %>
                <% if (!validation.getFieldErrors("prixEco").isEmpty()) { %>
                    <div class="error">
                        <% for (String error : validation.getFieldErrors("prixEco")) { %>
                            <%= error %><br>
                        <% } %>
                    </div>
                <% } %>
            <% } %>

            <input type="text" name="fly.prixBusiness" placeholder="Prix classe Business" value="<%= request.getAttribute("validation") != null ? ((ValidationResult) request.getAttribute("validation")).getFieldValue("prixBusiness") : "" %>">
            <% if (request.getAttribute("validation") != null) { %>
                <% ValidationResult validation = (ValidationResult)request.getAttribute("validation"); %>
                <% if (!validation.getFieldErrors("prixBusiness").isEmpty()) { %>
                    <div class="error">
                        <% for (String error : validation.getFieldErrors("prixBusiness")) { %>
                            <%= error %><br>
                        <% } %>
                    </div>
                <% } %>
            <% } %>

            <button type="submit">Ajouter le Vol</button>
        </form>
    </section>

</body>
</html>