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
    
</head>
<body>
    <header>
        <h1>🛫 Gestion des Vols 🛬</h1>
    </header>

    <section class="add-section">
        <h2>modifier un Vol</h2>
        <form action="updateVol" method="POST">
            <input type="hidden" id="idVol" name="fly.idVol" value="<%= request.getAttribute("validation") != null ? ((ValidationResult) request.getAttribute("validation")).getFieldValue("idVol") : "" %>">
            
            <input type="text" id="numeroVol" name="fly.numeroVol" placeholder="Numéro de vol" 
                   value="<%= request.getAttribute("validation") != null ? ((ValidationResult) request.getAttribute("validation")).getFieldValue("numeroVol") : "" %>">
            <% if (request.getAttribute("validation") != null) { %>
                <% ValidationResult validation = (ValidationResult) request.getAttribute("validation"); %>
                <% if (!validation.getFieldErrors("numeroVol").isEmpty()) { %>
                    <div class="error">
                        <% for (String error : validation.getFieldErrors("numeroVol")) { %>
                            <%= error %><br>
                        <% } %>
                    </div>
                <% } %>
            <% } %>
            
            <select id="modeleAvion" name="fly.modeleAvion">
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
            
            <input type="datetime-local" id="dateHeureDepart" name="fly.dateHeureDepart" 
                   value="<%= request.getAttribute("validation") != null ? ((ValidationResult) request.getAttribute("validation")).getFieldValue("dateHeureDepart") : "" %>">
            
            <input type="datetime-local" id="dateHeureArrivee" name="fly.dateHeureArrivee" 
                   value="<%= request.getAttribute("validation") != null ? ((ValidationResult) request.getAttribute("validation")).getFieldValue("dateHeureArrivee") : "" %>">
            
            <select id="aeroportDepart" name="fly.aeroportDepart">
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
            
            <select id="aeroportArrivee" name="fly.aeroportArrivee">
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
            
            <button type="submit">Mettre à jour</button>
        </form>
    </section>

</body>
</html>