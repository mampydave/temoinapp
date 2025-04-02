<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,Office.*" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Réservation de sièges</title>
    <link rel="stylesheet" href="assets/reserve.css">
    <script>
        function toggleSeat(seatId) {
            const seat = document.getElementById(seatId);
            const seatNumber = seatId.replace("seat-", "");

            // Empêcher la sélection d'un siège réservé
            if (seat.classList.contains("reserved")) {
                return; 
            }

            // Si le siège est sélectionné
            if (seat.classList.contains("selected")) {
                seat.classList.remove("selected");
                seat.textContent = seatNumber;

                // Supprimer le champ d'âge associé
                const ageInput = document.getElementById("age-input-" + seatId);
                if (ageInput) {
                    ageInput.remove();
                }
            } else {
                seat.classList.add("selected");
                seat.textContent = "✔";

                // Créer un champ d'âge pour ce siège sélectionné
                const ageInput = document.createElement("input");
                ageInput.type = "number";
                ageInput.name = "age-" + seatId;  // Nom unique pour chaque siège
                ageInput.placeholder = "Âge";
                ageInput.id = "age-input-" + seatId; // ID unique pour chaque champ
                ageInput.required = true;

                // Ajouter l'input d'âge après le siège
                seat.insertAdjacentElement('afterend', ageInput);
            }
        }

        function submitReservation(event) {
            const selectedSeats = [];
            const ages = [];

            // Récupérer les sièges sélectionnés et leurs âges
            document.querySelectorAll(".seat.selected").forEach(seat => {
                const seatId = seat.id.replace("seat-", "");
                selectedSeats.push(seatId);
                const ageInput = document.getElementById("age-input-" + seat.id);
                if (ageInput) {
                    if (ageInput.value === "") {
                        alert("Veuillez entrer l'âge pour le siège " + seatId);
                        event.preventDefault(); // Empêche l'envoi du formulaire
                        return;
                    }
                    ages.push(ageInput.value);  // Récupérer l'âge pour chaque siège
                }
            });

            // Affichage dans la console pour vérifier les valeurs des sièges sélectionnés
            console.log("Sièges sélectionnés:", selectedSeats);
            console.log("Âges:", ages);

            if (selectedSeats.length === 0) {
                alert("Veuillez sélectionner au moins un siège.");
                event.preventDefault(); // Empêche l'envoi du formulaire
                return;
            }

            // Associer les sièges et les âges dans un tableau à envoyer
            document.getElementById("selectedSeats").value = selectedSeats.join(",");
            document.getElementById("ages").value = ages.join(",");

            // Supprimer les champs d'âge individuels du DOM avant la soumission
            document.querySelectorAll('input[name^="age-"]').forEach(input => {
                input.remove();
            });

            // Afficher dans la console les valeurs envoyées
            console.log("Valeur de selectedSeats:", selectedSeats.join(","));
            console.log("Valeur de ages:", ages.join(","));
        }

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
        <h1>🛫 Réservation de sièges 🛬</h1>
        <div class="profile-menu">
            <button class="profile-btn" id="profileBtn">👤More ▼</button>
            <div class="dropdown-content" id="profileDropdown">
                <a href="interfaceVol">Accueil</a>
                <a href="listBillet">Mes Billets</a>
                <a href="logout">Se Déconnecter</a>
            </div>
        </div>
    </header>

    <div class="reservation-container">
        
        <form id="reservationForm" action="processReservation" method="POST" class="reservation-form" onsubmit="submitReservation(event)">
            <% 
                ArrayList<Object> userInfo = (ArrayList<Object>) session.getAttribute("userInfo");

                int idVol = (int) session.getAttribute("idVol");    
                if (userInfo != null) {
                    int idUser = (int) userInfo.get(2); %>
                        <input type="hidden" id="idUser" name="idUser" value="<%= idUser %>">
                <%  
                }
            %>

            <br><br>
             
            <input type="hidden" id="idVol" name="idVol" value="<%= idVol %>">
            <input type="datetime-local" name="dateReservation" required>
            
            <!-- Grille des sièges -->
            <div class="seat-grid">
                <%
                    ArrayList<Siege> sieges = (ArrayList<Siege>) request.getAttribute("sieges");
                    if (sieges != null) {
                        for (Siege siege : sieges) {
                            String seatId = "seat-" + siege.getIdSiege();
                            String statut = siege.getStatut(); // Récupérer le statut
                            String seatClass = (statut != null && statut.equalsIgnoreCase("Reserve")) ? "seat reserved" : "seat";
                %>
                <div id="<%= seatId %>" class="<%= seatClass %>" 
                     onclick="toggleSeat('<%= seatId %>')">
                    <%= (statut != null && statut.equalsIgnoreCase("Reserve")) ? "✔" : siege.getNumSiege() %>
                    <%= siege.getClasse() %>
                </div>
                <%
                        }
                    }
                %>
            </div>

            <!-- Champs cachés pour les sièges et les âges -->
            <input type="hidden" id="selectedSeats" name="selectedSeats">
            <input type="hidden" id="ages" name="ages">

            <button type="submit">Réserver</button>
        </form>

        <% 
            String message = (String) request.getAttribute("message");
            if (message != null && !message.isEmpty()) { 
        %>
            <script>
                alert("<%= message %>");
            </script>
        <% } %>

    </div>
</body>
</html>
