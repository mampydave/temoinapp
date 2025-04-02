<%@ page contentType="text/html; charset=UTF-8" %>
<%@page import ="Office.*,java.util.*,mg.itu.prom16.etu2564.ValidationResult,com.google.gson.Gson"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<% ArrayList<Ville> villes = (ArrayList<Ville>) request.getAttribute("villes"); %>
<% ArrayList<Avion> avions = (ArrayList<Avion>) request.getAttribute("avions"); %>
<% ArrayList<Vol> resultats = (ArrayList<Vol>) request.getAttribute("resultats"); %>

<% 
    Gson gson = new Gson();
    String villesJson = gson.toJson(villes);
    
    String avionsJson = gson.toJson(avions);
    
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Vols</title>
    <link rel="stylesheet" href="assets/vol.css">
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // Effet d'entrée après chargement de la page
            setTimeout(() => {
                document.body.style.opacity = "1";
                document.body.style.filter = "blur(0px)";
            }, 100);

            // Gérer la navigation des liens (effet de transition)
            document.querySelectorAll("a").forEach(element => {
                element.addEventListener("click", function (event) {
                    event.preventDefault(); // Bloque la navigation instantanée
                    let targetUrl = this.getAttribute("href");
                    
                    if (targetUrl) {
                        document.body.classList.add("fade-out"); // Active l'effet
                        setTimeout(() => {
                            window.location.href = targetUrl; // Redirection après l'animation
                        }, 1000); // Correspond à la durée de la transition CSS
                    }
                });
            });

            // Gérer les formulaires (évite la soumission instantanée)
            document.querySelectorAll("form").forEach(form => {
                form.addEventListener("submit", function (event) {
                    event.preventDefault(); // Bloque l'envoi immédiat
                    
                    document.body.classList.add("fade-out"); // Applique l'effet
                    
                    setTimeout(() => {
                        form.submit(); // Envoi après l'animation
                    }, 1000); // Correspond à la durée de la transition CSS
                });
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
    
    <section class="search-section">
        <h2>Recherche de Vols</h2>
        <form action="searchVolMultiCritere" method="GET">
            <input type="text" name="numeroVol" placeholder="Numéro de vol">
            <select name="modeleAvion">
                <option value="">Selectionner Modele Avion</option>
                <% 
                    if(avions!= null && !avions.isEmpty()){
                        for (Avion a : avions) { %>
                        <option value="<%= a.getID_Avion() %>"><%= a.getModele() %></option>
                <%      } 
                    }%>
            </select>
            <input type="datetime-local" name="dateHeureDepart">
            <input type="datetime-local" name="dateHeureArrivee">
            <select name="aeroportDepart">
                <option value="">Aéroport de départ</option>
                <% 
                    if(villes!=null && !villes.isEmpty()){
                        for (Ville v : villes) { %>
                            <option value="<%= v.getId_ville() %>"><%= v.getNom_ville() %></option>
                <%      } 
                    }   %>
            </select>

            <select name="aeroportArrivee">
                <option value="">Aéroport d'arrivée</option>
                <%
                    if(villes!=null && !villes.isEmpty()){
                        for (Ville v : villes) { %>
                            <option value="<%= v.getId_ville() %>"><%= v.getNom_ville() %></option>    
                <%      } 
                    }%>
            </select>
            <button type="submit">Rechercher</button>
        </form>
    </section>

    <section class="flights-list">
        <h2>Liste des Vols</h2>
        <% 

            if (userInfo != null) {
                String role = (String) userInfo.get(1);

                if(role.equalsIgnoreCase("admin")){ %>
                    <a href="ajout" class="btn-ajouter">➕ Ajouter un Vol</a>
            <%  }
            }
        %>
        <table>
            <thead>
                <tr>
                    <th>ID Vol</th>
                    <th>Numéro</th>
                    <th>Modèle Avion</th>
                    <th>Départ</th>
                    <th>Arrivée</th>
                    <th>Aéroport Départ</th>
                    <th>Aéroport Arrivée</th>
                    <th>Prix Eco</th>
                    <th>Prix Business</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% 

                    if (resultats != null && !resultats.isEmpty()) {
                        for (Vol vol : resultats) {
                %>
                <tr>
                    <td><%= vol.getIdVol() %></td>
                    <td><%= vol.getNumeroVol() %></td>
                    <td><%= vol.getModeleAvion() %></td>
                    <td><%= vol.getDateHeureDepart() %></td>
                    <td><%= vol.getDateHeureArrivee() %></td>
                    <td><%= vol.getAeroportDepart() %></td>
                    <td><%= vol.getAeroportArrivee() %></td>
                    <td><%= vol.getPrixEco() %></td>
                    <td><%= vol.getPrixBusiness() %></td>
                    <td>
                        <% if (userInfo != null) {
                            String role = (String) userInfo.get(1);
                            int idUser = (int) userInfo.get(2);
                            if(role.equalsIgnoreCase("admin")){ %>
                        
                                <button class="btn-modifier" 
                                        onclick='openUpdateForm(
                                        "<%= vol.getIdVol() %>", 
                                        "<%= vol.getNumeroVol() %>", 
                                        "<%= vol.getModeleAvion() %>", 
                                        "<%= vol.getDateHeureDepart() %>", 
                                        "<%= vol.getDateHeureArrivee() %>", 
                                        "<%= vol.getAeroportDepart() %>", 
                                        "<%= vol.getAeroportArrivee() %>",
                                        "<%= vol.getPrixEco() %>", 
                                        "<%= vol.getPrixBusiness() %>",  
                                        JSON.parse(`<%= villesJson.replace("'", "\\'") %>`), 
                                        JSON.parse(`<%= avionsJson.replace("'", "\\'") %>`)
                                    )'>
                                    ✏️ Modifier
                                </button>
                            
                                <form action="deleteVol" method="POST" style="display: inline;">
                                    <input type="hidden" name="idVol" value="<%= vol.getIdVol() %>">
                                    <button type="submit" class="btn-supprimer" onclick="return confirm('Supprimer le vol <%= vol.getIdVol() %> ?')">🗑️ Supprimer</button>
                                </form>
                        <%  }else{ %>
                            <form action="inSession" method="POST" style="display: inline;">
                                <input type="hidden" name="idVol" value="<%= vol.getIdVol() %>">
                                <input type="hidden" id="idUser" name="idUser" value="<%= idUser %>">
                                <button type="submit" class="btn-ajouter" >✔ Reserver</button>
                            </form>
                        <%} 
                    
                    } %>
                    </td>
                </tr>
                <% } } %>
            </tbody>
        </table>
    </section>

            
<!-- Fenêtre modale -->
<div class="modal-overlay" id="modal-overlay"></div>
<div class="modal" id="update-modal">
    <div class="modal-header">
        <h2>Modifier un Vol</h2>
        <button class="close" onclick="closeUpdateForm()">✖</button>
    </div>
    <form id="form-update-vol">
        <input type="hidden" id="idVol" name="fly.idVol" 
               value="<%= request.getAttribute("validation") != null ? ((ValidationResult) request.getAttribute("validation")).getFieldValue("idVol") : "" %>">

        <!-- Numéro de vol -->
        <input type="text" id="numeroVol" name="fly.numeroVol" placeholder="Numéro de vol" 
               value="<%= request.getAttribute("validation") != null ? ((ValidationResult) request.getAttribute("validation")).getFieldValue("numeroVol") : "" %>">
        <div id="error-numeroVol" class="error" style="color: red;">
            <% if (request.getAttribute("validation") != null) {
                for (String error : ((ValidationResult) request.getAttribute("validation")).getFieldErrors("numeroVol")) { %>
                    <%= error %><br>
            <% } } %>
        </div>

        <!-- Modèle d'avion -->
        <select id="modeleAvion" name="fly.modeleAvion">
            <% 
                // Récupérer la valeur sélectionnée pour modeleAvion
                String selectedModele = request.getAttribute("validation") != null ? 
                    ((ValidationResult) request.getAttribute("validation")).getFieldValue("modeleAvion") : "";
                for (Avion a : avions) { 
                    if (selectedModele != null && !selectedModele.isEmpty()) {
            %>
                        <option value="<%= a.getID_Avion() %>" 
                                <%= String.valueOf(a.getID_Avion()).equals(selectedModele) ? "selected" : "" %>>
                            <%= a.getModele() %>
                        </option>
                    <% } else { 
                        %>
                       
                        <option value="<%= a.getID_Avion() %>">
                            <%= a.getModele() %>
                        </option>
                    <% } 
                } %>
        </select>


        <!-- Date et Heure de départ -->
        <input type="text" id="dateHeureDepart" name="fly.dateHeureDepart"
               value="<%= request.getAttribute("validation") != null ? ((ValidationResult) request.getAttribute("validation")).getFieldValue("dateHeureDepart") : "" %>">
        <div id="error-dateHeureDepart" class="error" style="color: red;">
            <% if (request.getAttribute("validation") != null) {
                for (String error : ((ValidationResult) request.getAttribute("validation")).getFieldErrors("dateHeureDepart")) { %>
                    <%= error %><br>
            <% } } %>
        </div>

        <!-- Date et Heure d'arrivée -->
        <input type="text" id="dateHeureArrivee" name="fly.dateHeureArrivee"
               value="<%= request.getAttribute("validation") != null ? ((ValidationResult) request.getAttribute("validation")).getFieldValue("dateHeureArrivee") : "" %>">
        <div id="error-dateHeureArrivee" class="error" style="color: red;">
            <% if (request.getAttribute("validation") != null) {
                for (String error : ((ValidationResult) request.getAttribute("validation")).getFieldErrors("dateHeureArrivee")) { %>
                    <%= error %><br>
            <% } } %>
        </div>

        <!-- Aéroport de départ -->
        <select id="aeroportDepart" name="fly.aeroportDepart">
            <% 
                // Récupérer la valeur sélectionnée pour aeroportDepart
                String selectedDepart = request.getAttribute("validation") != null ? 
                    ((ValidationResult) request.getAttribute("validation")).getFieldValue("aeroportDepart") : "";
                for (Ville v : villes) { 
                    if (selectedDepart != null && !selectedDepart.isEmpty()) {
            %>
                        <option value="<%= v.getId_ville() %>" 
                                <%= String.valueOf(v.getId_ville()).equals(selectedDepart) ? "selected" : "" %>>
                            <%= v.getNom_ville() %>
                        </option>
                    <% } else { 
                        
                        %>
                            <option value="<%= v.getId_ville() %>">
                                <%= v.getNom_ville() %>
                            </option>
                    <% } 
                } %>
        </select>

        <!-- Aéroport d'arrivée -->
        <select id="aeroportArrivee" name="fly.aeroportArrivee">
            <% 
                // Récupérer la valeur sélectionnée pour aeroportArrivee
                String selectedArrivee = request.getAttribute("validation") != null ? 
                    ((ValidationResult) request.getAttribute("validation")).getFieldValue("aeroportArrivee") : "";
                for (Ville v : villes) { 
                    if (selectedArrivee != null && !selectedArrivee.isEmpty()) {
            %>
                        <option value="<%= v.getId_ville() %>" 
                                <%= String.valueOf(v.getId_ville()).equals(selectedArrivee) ? "selected" : "" %>>
                            <%= v.getNom_ville() %>
                        </option>
                    <% } else {                       
                        %>
                            <option value="<%= v.getId_ville() %>">
                                <%= v.getNom_ville() %>
                            </option>
                    <% } 
                } %>
        </select>

        <input type="text" id="prixEco" name="fly.prixEco" placeholder="Prix classe Eco" value="<%= request.getAttribute("validation") != null ? ((ValidationResult) request.getAttribute("validation")).getFieldValue("prixEco") : "" %>">
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

        <input type="text" id="prixBusi" name="fly.prixBusiness" placeholder="Prix classe Business" value="<%= request.getAttribute("validation") != null ? ((ValidationResult) request.getAttribute("validation")).getFieldValue("prixBusiness") : "" %>">
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

        <button type="submit">Mettre à jour</button>
    </form>
</div>


<script>
    function openUpdateForm(id, numero, modele, depart, arrivee, aeroportDepart, aeroportArrivee, prixEco,prixBusi,villes,avions) {
        
        // Remplir les autres champs du formulaire
        document.getElementById('idVol').value = id;
        document.getElementById('numeroVol').value = numero;
        const modeleAvionId = findavionId(modele,avions);

        setSelectedValue("modeleAvion", modeleAvionId);

        document.getElementById('dateHeureDepart').value = depart;
        document.getElementById('dateHeureArrivee').value = arrivee;
        
        document.getElementById('prixEco').value = prixEco;
        document.getElementById('prixBusi').value = prixBusi;

        // Trouver l'ID correspondant à l'aéroport de départ et d'arrivée
        const aeroportDepartId = findVilleId(aeroportDepart, villes);
        const aeroportArriveeId = findVilleId(aeroportArrivee, villes);

        // Affecter la value des select avec l'ID trouvé
        setSelectedValue("aeroportDepart", aeroportDepartId);
        setSelectedValue("aeroportArrivee", aeroportArriveeId);
        
        document.getElementById('modal-overlay').style.display = 'block';
        document.getElementById('update-modal').style.display = 'block';
    }

    // Fonction pour définir la valeur d'un select
    function setSelectedValue(selectId, valueToSelect) {
        let selectElement = document.getElementById(selectId);
        if (selectElement) {
            for (let option of selectElement.options) {
                if (option.value == valueToSelect) {
                    option.selected = true;
                    return;
                }
            }
        }
    }

    // Fonction pour trouver l'ID de la ville à partir du nom
    function findVilleId(nom_ville, villes) {
        
        
        for (let i = 0; i < villes.length; i++) {
            if (villes[i].nom_ville === nom_ville) {
                return villes[i].id_ville; // Retourner l'ID correspondant
            }
        }
        return null; 
    }

    function findavionId(nom_avion, avions) {
        
        
        for (let i = 0; i < avions.length; i++) {
            if (avions[i].modele === nom_avion) {
                return avions[i].ID_Avion; // Retourner l'ID correspondant
            }
        }
        return null; // Si pas trouvé, retourner null
    }

    function closeUpdateForm() {
        document.getElementById('modal-overlay').style.display = 'none';
        document.getElementById('update-modal').style.display = 'none';
    }

    document.addEventListener("DOMContentLoaded", function () {
        document.getElementById('modal-overlay').addEventListener('click', closeUpdateForm);
        
        document.getElementById("form-update-vol").addEventListener("submit", function (event) {
            event.preventDefault();

            let formData = new FormData(this);
            for (let pair of formData.entries()) {
                console.log(pair[0] + ": " + pair[1]);
            }

            fetch("updateVol", {
                method: "POST",
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                // Effacer les messages d'erreur précédents
                document.querySelectorAll('.error').forEach(el => el.innerHTML = '');

                if (data.validation) {
                    console.log(data);
                    for (let key in data.validation.errors) {
                        let errorDiv = document.getElementById("error-" + key);
                        if (errorDiv) {
                            errorDiv.innerHTML = data.validation.errors[key].join("<br>");
                        }
                    }
                    document.getElementById('modal-overlay').style.display = 'block';
                    document.getElementById('update-modal').style.display = 'block';
                } else {
                    closeUpdateForm();
                    alert("Mise à jour réussie !");
                    location.reload();
                }
            })
            .catch(error => console.error("Erreur:", error));
        });
    });
    document.addEventListener("DOMContentLoaded", function () {
        const profileBtn = document.getElementById("profileBtn");
        const profileDropdown = document.getElementById("profileDropdown");

        profileBtn.addEventListener("click", function (event) {
            event.stopPropagation(); // Empêche la propagation pour éviter la fermeture immédiate
            profileDropdown.style.display = profileDropdown.style.display === "block" ? "none" : "block";
        });

        document.addEventListener("click", function (event) {
            if (!profileBtn.contains(event.target) && !profileDropdown.contains(event.target)) {
                profileDropdown.style.display = "none";
            }
        });
    });
</script>

</body>
</html>
