INSERT INTO avion (Modele, Date_Fabrication)
VALUES ('Boeing 737', '2020-05-15 10:30:00');

INSERT INTO avion (Modele, Date_Fabrication)
VALUES ('Airbus A320', '2018-11-22 14:45:00');

INSERT INTO type_Siege (types)
VALUES ('Eco');

INSERT INTO type_Siege (types)
VALUES ('Business');


INSERT INTO sieges (ID_Avion, ID_Type_Siege, Numero_Siege, Statut)
VALUES (1, 1, 'A1', 'Disponible');


INSERT INTO sieges (ID_Avion, ID_Type_Siege, Numero_Siege, Statut)
VALUES (1, 2, 'B1', 'Disponible');

INSERT INTO sieges (ID_Avion, ID_Type_Siege, Numero_Siege, Statut)
VALUES (1, 1, 'A2', 'Disponible');

INSERT INTO sieges (ID_Avion, ID_Type_Siege, Numero_Siege, Statut)
VALUES (1, 2, 'B2', 'Disponible');

INSERT INTO sieges (ID_Avion, ID_Type_Siege, Numero_Siege, Statut)
VALUES (1, 1, 'D1', 'Disponible');

INSERT INTO sieges (ID_Avion, ID_Type_Siege, Numero_Siege, Statut)
VALUES (1, 2, 'C1', 'Disponible');

INSERT INTO sieges (ID_Avion, ID_Type_Siege, Numero_Siege, Statut)
VALUES (1, 1, 'D2', 'Disponible');

INSERT INTO sieges (ID_Avion, ID_Type_Siege, Numero_Siege, Statut)
VALUES (1, 2, 'C2', 'Disponible');


INSERT INTO sieges (ID_Avion, ID_Type_Siege, Numero_Siege, Statut)
VALUES (2, 1, 'C1', 'Disponible');

INSERT INTO sieges (ID_Avion, ID_Type_Siege, Numero_Siege, Statut)
VALUES (2, 2, 'D1', 'Disponible');

INSERT INTO sieges (ID_Avion, ID_Type_Siege, Numero_Siege, Statut)
VALUES (2, 1, 'C2', 'Disponible');

INSERT INTO sieges (ID_Avion, ID_Type_Siege, Numero_Siege, Statut)
VALUES (2, 2, 'D2', 'Disponible');

INSERT INTO sieges (ID_Avion, ID_Type_Siege, Numero_Siege, Statut)
VALUES (2, 1, 'E1', 'Disponible');

INSERT INTO sieges (ID_Avion, ID_Type_Siege, Numero_Siege, Statut)
VALUES (2, 2, 'F1', 'Disponible');
INSERT INTO sieges (ID_Avion, ID_Type_Siege, Numero_Siege, Statut)
VALUES (2, 1, 'E2', 'Disponible');

INSERT INTO sieges (ID_Avion, ID_Type_Siege, Numero_Siege, Statut)
VALUES (2, 2, 'F2', 'Disponible');



-- Vol 1 : Utilise l'avion 1 (Boeing 737)
-- INSERT INTO vol (Numero_Vol, ID_Avion, Date_Heure_Depart, Date_Heure_Arrivee, Aeroport_Depart, Aeroport_Arrivee)
-- VALUES ('AF123', 1, '2023-10-25 08:00:00', '2023-10-25 10:30:00', 'New York', 'Londres');

-- -- Vol 2 : Utilise l'avion 2 (Airbus A320)
-- INSERT INTO vol (Numero_Vol, ID_Avion, Date_Heure_Depart, Date_Heure_Arrivee, Aeroport_Depart, Aeroport_Arrivee)
-- VALUES ('BA456', 2, '2023-10-26 12:00:00', '2023-10-26 14:30:00', 'Paris', 'Amsterdam');


INSERT INTO villes (nom_ville) VALUES 
('Paris'),
('New York'),
('Londres'),
('Amsterdam');

INSERT INTO users (Nom, Prenom, Email, mdp, Telephone, roles) 
VALUES 
('Admin', 'Super', 'admin@gmail.com', 'admin', '0123456789', 'admin'),
('User', 'Normal', 'user@gmail.com', 'user', '0987654321', 'user');


SELECT 
    V.ID_Vol, 
    V.Numero_Vol, 
    A.Modele AS Modele_Avion, 
    V.Date_Heure_Depart, 
    V.Date_Heure_Arrivee, 
    VD.Nom AS Aeroport_Depart, 
    VA.Nom AS Aeroport_Arrivee
FROM vol V
LEFT JOIN avion A ON V.ID_Avion = A.ID_Avion
JOIN villes VD ON V.Aeroport_Depart = VD.ID_Ville
JOIN villes VA ON V.Aeroport_Arrivee = VA.ID_Ville;



