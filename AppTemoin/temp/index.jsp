<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page language="java" %>
<%@page import="mg.itu.prom16.etu2564.ValidationResult" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - Aéroport</title>
    <link rel="stylesheet" href="assets/style.css"> 
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
                        }, 800);
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
                    }, 800);
                });
            });
        });
    </script>
    
        
</head>
<body>

    <div class="login-container">
        <div class="login-header">
            <!-- <img src="images/airport-logo.png" alt="Logo Aéroport" class="logo"> -->
            <h2>Connexion Aéroport</h2>
        </div>
        
        <form action="login" method="post">
            <div class="input-group">
                <label for="user.email">✉️ Email</label>
                <input id="user.email" name="user.email" type="text"  value="<%= request.getAttribute("validation") != null ? ((ValidationResult) request.getAttribute("validation")).getFieldValue("email") : "" %>">
                <% if (request.getAttribute("validation") != null) { %>
                    <% ValidationResult validation = (ValidationResult)request.getAttribute("validation"); %>
                    <% if (!validation.getFieldErrors("email").isEmpty()) { %>
                        <div class="error">
                            <% for (String error : validation.getFieldErrors("email")) { %>
                                <%= error %><br>
                            <% } %>
                        </div>
                    <% } %>
                <% } %>
            </div>

            <div class="input-group">
                <label for="user.mdp">🔒 Mot de passe</label>
                <input id="user.mdp" name="user.mdp" type="password"  value="<%= request.getAttribute("validation") != null ? ((ValidationResult) request.getAttribute("validation")).getFieldValue("mdp") : "" %>">
                <% if (request.getAttribute("validation") != null) { %>
                    <% ValidationResult validation = (ValidationResult)request.getAttribute("validation"); %>
                    <% if (!validation.getFieldErrors("mdp").isEmpty()) { %>
                        <div class="error">
                            <% for (String error : validation.getFieldErrors("mdp")) { %>
                                <%= error %><br>
                            <% } %>
                        </div>
                    <% } %>
                <% } %>
            
            </div>

            <button type="submit" class="btn-login">Se Connecter</button>

            <!-- <p class="register-link">Pas encore de compte ? <a href="register.jsp">Inscrivez-vous</a></p> -->
        </form>
    </div>

</body>
</html>
