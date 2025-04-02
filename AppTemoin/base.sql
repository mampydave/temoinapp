CREATE TABLE avion (
    ID_Avion SERIAL PRIMARY KEY,
    Modele VARCHAR(50),
    Date_Fabrication Timestamp
);

CREATE TABLE type_Siege (
    ID_Type_Siege SERIAL PRIMARY KEY,
    types VARCHAR(50) NOT NULL
);

-- CREATE TABLE Avion_Detail (
--     ID_Avion INT,
--     ID_Type_Siege INT,
--     Nombre_Sieges INT NOT NULL,
--     PRIMARY KEY (ID_Avion, ID_Type_Siege),
--     FOREIGN KEY (ID_Avion) REFERENCES avion(ID_Avion),
--     FOREIGN KEY (ID_Type_Siege) REFERENCES type_Siege(ID_Type_Siege)
-- );

CREATE TABLE sieges (
    ID_Siege SERIAL PRIMARY KEY,
    ID_Avion INT,
    ID_Type_Siege INT,
    Numero_Siege VARCHAR(10) NOT NULL,
    Statut VARCHAR(20) DEFAULT 'Disponible',
    FOREIGN KEY (ID_Avion) REFERENCES avion(ID_Avion),
    FOREIGN KEY (ID_Type_Siege) REFERENCES type_Siege(ID_Type_Siege)
);


CREATE TABLE vol (
    ID_Vol SERIAL PRIMARY KEY,
    Numero_Vol VARCHAR(20) NOT NULL,
    ID_Avion INT,
    Date_Heure_Depart TIMESTAMP,
    Date_Heure_Arrivee TIMESTAMP,
    Aeroport_Depart INT NOT NULL,
    Aeroport_Arrivee INT NOT NULL,
    PrixEco DECIMAL(18,2),
    PRixBusi DECIMAL(18,2),
    parametrageReservation TIME,
    annulationReservation TIME,
    FOREIGN KEY (ID_Avion) REFERENCES avion(ID_Avion),
    FOREIGN KEy (Aeroport_Depart) REFERENCES villes(id_Ville),
    FOREIGN KEY (Aeroport_Arrivee) REFERENCES villes(id_Ville)
);


CREATE TABLE promotion(
    ID_promotion SERIAL PRIMARY KEY,
    ID_Vol INT,
    promotion DECIMAL(5,2),
    nbSiegepromotion INT,
    type_Siege INT,
    FOREIGN KEY (ID_Vol) REFERENCES vol(ID_Vol),
    FOREIGN KEY (type_Siege) REFERENCES type_Siege(ID_Type_Siege)
);



CREATE TABLE villes(
    id_Ville SERIAL PRIMARY KEY,
    nom_ville VARCHAR(50) NOT NULL
);

CREATE TABLE users (
    ID_User SERIAL PRIMARY KEY,
    Nom VARCHAR(50) NOT NULL,
    Prenom VARCHAR(50) NOT NULL,
    Email VARCHAR(100),
    mdp VARCHAR(100),
    Telephone VARCHAR(20),
    roles VARCHAR(30)
);

CREATE TABLE Reservation (
    ID_Reservation SERIAL PRIMARY KEY,
    ID_Passager INT,
    ID_Vol INT,
    ID_Siege INT,
    Date_Reservation TIMESTAMP,
    Statut_Reservation VARCHAR(20) DEFAULT 'Reserve',
    prixBillet DECIMAL(18,2),
    beneficiaire VARCHAR(30),
    FOREIGN KEY (ID_Passager) REFERENCES users(ID_User),
    FOREIGN KEY (ID_Vol) REFERENCES vol(ID_Vol),
    FOREIGN KEY (ID_Siege) REFERENCES sieges(ID_Siege)
);


CREATE TABLE ages(
    id_age SERIAL PRIMARY KEY,
    min_age int,
    max_age int,
    beneficitaire VARCHAR(30),
    promo DECIMAL(5,2)
);
