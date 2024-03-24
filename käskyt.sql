CREATE TABLE Omistaja ( 

    henkilötunnus TEXT PRIMARY KEY, 

    nimi TEXT 

    ); 

     

CREATE TABLE Omistaa ( 

    henkilötunnus TEXT, 

    rekisterinumero TEXT, 

    PRIMARY KEY (henkilötunnus, rekisterinumero) 

    FOREIGN KEY (henkilötunnus) REFERENCES Omistaja (henkilötunnus) 

    FOREIGN KEY (rekisterinumero) REFERENCES Auto (rekisterinumero) 

    ); 

     

CREATE TABLE Auto ( 

    rekisterinumero TEXT PRIMARY KEY, 

    kilometrit INTEGER 

    ); 

     

CREATE TABLE Asiakas ( 

    ID TEXT PRIMARY KEY, 

    puhNro TEXT, 

    sposti TEXT 

    ); 

     

CREATE TABLE Lasku ( 

    laskuNro TEXT PRIMARY KEY, 

    hinta REAL, 

    eräpäivä TEXT, 

    lähetetty INTEGER DEFAULT 0 CHECK (lähetetty IN (0, 1)), 

    maksettu INTEGER DEFAULT 0 CHECK (maksettu IN (0, 1)), 

    huollonTunniste TEXT, 

    FOREIGN KEY (huollonTunniste) REFERENCES Huolto (tunniste) 

    ); 

         

CREATE TABLE Muistutus ( 

    muistutuslaskuNro TEXT PRIMARY KEY, 

    päälaskuNro TEXT, 

    FOREIGN KEY (päälaskuNro) REFERENCES Lasku (laskuNro) 

    ); 

     

CREATE TABLE Huolto ( 

    tunniste TEXT PRIMARY KEY, 

    alkamisaika TEXT, 

    loppumisaika TEXT, 

    tyyppi TEXT, 

    autonRekNro TEXT, 

    asiakasID TEXT, 

    työntekijäID TEXT, 

    FOREIGN KEY (autonRekNro) REFERENCES Auto(rekisterinumero) 

    FOREIGN KEY (asiakasID) REFERENCES Asiakas (ID) 

    FOREIGN KEY (työntekijäID) REFERENCES Työntekijä (ID) 

    FOREIGN KEY (tyyppi) REFERENCES Huoltotyyppi (tyyppi) 

    ); 

     

CREATE TABLE TarvitseeVaraosan ( 

    huollonTunniste TEXT, 

    varaosanumero TEXT, 

    määrä INTEGER CHECK (määrä > 0), 

    PRIMARY KEY (huollonTunniste, varaosanumero) 

    FOREIGN KEY (huollonTunniste) REFERENCES Huolto (tunniste) 

    FOREIGN KEY (varaosanumero) REFERENCES Varaosa (osanumero) 

    ); 

     

CREATE TABLE TarvitseeLaitekappaleen ( 

    huollonTunniste TEXT, 

    laiteNro TEXT, 

    alkamisaika TEXT, 

    loppumisaika TEXT, 

    PRIMARY KEY (huollonTunniste, laiteNro) 

    FOREIGN KEY (huollonTunniste) REFERENCES Huolto (tunniste) 

    FOREIGN KEY (laiteNro) REFERENCES Laitekappale (laiteNro) 

    ); 

     

CREATE TABLE Laitekappale ( 

    laiteNro TEXT PRIMARY KEY, 

    laitetyyppi TEXT, 

    FOREIGN KEY (laitetyyppi) REFERENCES Laitetyyppi (tyyppi) 

    ); 

     

CREATE TABLE Huoltotyyppi (tyyppi TEXT PRIMARY KEY); 

 

CREATE TABLE Koostuu ( 

    huollonTyyppi TEXT, 

    toimenpiteenNimi TEXT, 

    PRIMARY KEY (huollonTyyppi, toimenpiteenNimi) 

    FOREIGN KEY (huollonTyyppi) REFERENCES Huoltotyyppi (tyyppi) 

    FOREIGN KEY (toimenpiteenNimi) REFERENCES Toimenpide (nimi) 

    ); 

     

CREATE TABLE Toimenpide ( 

    nimi TEXT PRIMARY KEY, 

    kesto INTEGER 

    ); 

     

CREATE TABLE TarvitseeLaitetyypin ( 

    toimenpiteenNimi TEXT, 

    laitetyyppi TEXT, 

    PRIMARY KEY (toimenpiteenNimi, laitetyyppi) 

    FOREIGN KEY (toimenpiteenNimi) REFERENCES Toimenpide (nimi) 

    FOREIGN KEY (laitetyyppi) REFERENCES Laitetyyppi (tyyppi) 

    ); 

     

CREATE TABLE Laitetyyppi (tyyppi TEXT PRIMARY KEY); 

 

CREATE TABLE Varaosa (osanumero TEXT PRIMARY KEY); 

 

CREATE TABLE Työntekijä (ID TEXT PRIMARY KEY); 

 

CREATE TABLE Poissaolo ( 

    tunniste TEXT PRIMARY KEY, 

    alkamisaika TEXT, 

    loppumisaika TEXT, 

    syy TEXT, 

    työntekijäID TEXT, 

    FOREIGN KEY (työntekijäID) REFERENCES Työntekijä (ID) 

    ); 



CREATE INDEX OmistajaIndex ON Omistaja(henkilötunnus); 

CREATE INDEX AutoIndex ON Auto(rekisterinumero); 

CREATE INDEX AsiakasIndex ON Asiakas(ID); 

CREATE INDEX LaskuIndex ON Lasku(laskuNro); 

CREATE INDEX HuoltoIndex ON Huolto(tunniste); 

CREATE INDEX LaitekappaleIndex ON Laitekappale(laiteNro); 

CREATE INDEX ToimenpideIndex ON Toimenpide(nimi); 

CREATE INDEX LaitetyyppiIndex ON Laitetyyppi(tyyppi); 

CREATE INDEX VaraosaIndex ON Varaosa(osanumero); 

CREATE INDEX TyöntekijäIndex ON Työntekijä(ID); 

CREATE INDEX PoissaoloIndex ON Poissaolo(tunniste, työntekijäID);

 

CREATE VIEW TyöntekijäVarattu AS
    SELECT ID, alkamisaika, loppumisaika
    FROM Työntekijä, Poissaolo
    WHERE ID = Poissaolo.työntekijäID
        UNION
    SELECT ID, alkamisaika, loppumisaika
    FROM Työntekijä, Huolto
    WHERE ID = Huolto.työntekijäID;



insert into Omistaja(henkilötunnus, nimi) 

values ('123456-123A', 'Erkki Esimerkki'); 

 

insert into Auto(rekisterinumero, kilometrit) 

values ('ABC-123', 100000); 

 

insert into Asiakas(ID, puhNro, sposti) 

values ('A1234', '0401234567', 'erkki.esimerkki@gmail.com'); 

 

insert into Työntekijä(ID) 

values ('T1234'); 

 

insert into Huoltotyyppi(tyyppi) 

values ('määräaikaishuolto'); 

 

insert into Huolto(tunniste, alkamisaika, loppumisaika, tyyppi, autonRekNro, asiakasID, työntekijäID) 

values ('H001', '2022-05-03', '2022-05-09', 'määräaikaishuolto', 'ABC-123', 'A1234', 'T1234'); 

 

insert into Lasku(laskuNro, hinta, eräpäivä, huollonTunniste) 

values ('123456', 400.99, '2022-06-14', 'H001'); 

 

insert into Muistutus(muistutuslaskuNro, päälaskuNro) 

values ('1234568', '123456'); 

 

insert into Lasku(laskuNro, hinta, eräpäivä, huollonTunniste)  

values('1234568', 20, '2022-06-28', 'H001');

 

insert into Laitetyyppi(tyyppi) 

values ('hallinosturi'); 

 

insert into Laitekappale(laiteNro, laitetyyppi) 

values ('L5', 'hallinosturi'); 

 

insert into Toimenpide(nimi, kesto) 

values ('öljynvaihto', 30); 

 

insert into Varaosa(osanumero) 

values ('V100'); 

 

insert into Poissaolo(tunniste, alkamisaika, loppumisaika, syy, työntekijäID) 

values ('P100', '2022-05-06', '2022-05-09', 'loma', 'T1234'); 

 

insert into TarvitseeVaraosan(huollonTunniste, varaosanumero, määrä) 

values ('H001', 'V100', 2); 

 

insert into Omistaa(henkilötunnus, rekisterinumero) 

values ('123456-123A', 'ABC-123'); 

 

insert into Koostuu(huollonTyyppi, toimenpiteenNimi) 

values ('määräaikaishuolto', 'öljynvaihto'); 

 

insert into TarvitseeLaitekappaleen(huollonTunniste, laiteNro, alkamisaika, loppumisaika) 

values ('H001', 'L5', '2022-05-04 10:00', '2022-05-04 12:00'); 

 

insert into TarvitseeLaitetyypin(toimenpiteenNimi, laitetyyppi) 

values ('öljynvaihto', 'hallinosturi'); 





SELECT ID, alkamisaika, loppumisaika
FROM Työntekijä, Poissaolo
WHERE ID = työntekijäID AND ((alkamisaika >= '2022-05-01' AND alkamisaika <= '2022-05-31') OR (loppumisaika >= '2022-05-31' AND loppumisaika <= '2022-05-31')); 


SELECT ID, puhNro, sposti
FROM Asiakas, Huolto, Auto
WHERE ID = asiakasID AND autonRekNro = rekisterinumero AND rekisterinumero = 'ABC-123'; 


SELECT L.laitenro, laitetyyppi
FROM Huolto, TarvitseeLaitekappaleen AS T, Laitekappale AS L 
WHERE tunniste = huollonTunniste AND T.laiteNro = L.laiteNro AND tunniste = 'H001'; 


SELECT tunniste, alkamisaika, loppumisaika, tyyppi, asiakasID, työntekijäID 
FROM Auto, Huolto 
WHERE rekisterinumero = autonRekNro AND rekisterinumero = 'ABC-123'; 


SELECT Huolto.tunniste, Huolto.autonRekNro, Varaosa.osanumero, TarvitseeVaraosan.määrä
FROM Huolto, Varaosa, TarvitseeVaraosan 
WHERE TarvitseeVaraosan.huollonTunniste = Huolto.tunniste AND Varaosa.osanumero = TarvitseeVaraosan.varaosanumero;


SELECT Omistaja.henkilötunnus, Auto.rekisterinumero, MAX(Huolto.alkamisaika), Lasku.maksettu 
FROM Omistaja, Omistaa, Auto, Huolto, Lasku 
WHERE Omistaja.henkilötunnus = Omistaa.henkilötunnus AND Omistaa.rekisterinumero = Huolto.autonRekNro AND Lasku.huollonTunniste = Huolto.tunniste; 


SELECT ID, puhNro, sposti 
FROM Asiakas, Huolto, Lasku 
WHERE ID = asiakasID AND tunniste = huollonTunniste AND maksettu = 0; 


SELECT ID, puhNro, sposti 
FROM Asiakas, Huolto, (SELECT huollonTunniste, COUNT(laskuNro) 
			FROM Lasku, Muistutus 
			WHERE laskuNro = päälaskuNro AND maksettu = 0 
			GROUP BY päälaskuNro 
			HAVING COUNT(laskuNro) = 1 
			) AS L 
WHERE ID = asiakasID AND tunniste = huollonTunniste; 

SELECT nimi, kesto 
FROM Toimenpide, Koostuu, Huoltotyyppi AS H 
WHERE H.tyyppi = huollonTyyppi AND toimenpiteenNimi = nimi AND H.tyyppi = 'määräaikaishuolto'; 



UPDATE Huolto 
SET työntekijäID = 'T1234' 
WHERE tunniste = 'H200';  



SELECT DISTINCT ID 
FROM TyöntekijäVarattu 
WHERE alkamisaika > '2022-05-11' OR loppumisaika < '2022-05-10'; 


SELECT laiteNro, laitetyyppi, alkamisaika, loppumisaika 
FROM Laitekappale AS L, TarvitseeLaitekappaleen AS T 
WHERE L.laiteNro = T.laiteNro AND laitetyyppi = 'hallinosturi'; 


SELECT DISTINCT ID, puhNro, sposti 
FROM Asiakas, Huolto, Auto 
WHERE rekisterinumero = autonRekNro AND asiakasID = ID AND kilometrit > 50000; 




SELECT henkilötunnus, nimi 
FROM Omistaja, Omistaa, Auto 
WHERE Omistaja.henkilötunnus = Omistaa.henkilötunnus AND Omistaa.rekisterinumero = Auto.rekisterinumero AND Auto.rekisterinumero = 'ABC-123'; 



SELECT laiteNro, laitetyyppi 
FROM Laitekappale, Huolto, Huoltotyyppi, Koostuu, Toimenpide, TarvitseeLaitetyypin, Laitetyyppi 
WHERE Huolto.tyyppi = Huoltotyyppi.tyyppi AND huollonTyyppi = Huoltotyyppi.tyyppi AND Koostuu.toimenpiteenNimi = nimi AND TarvitseeLaitetyypin.toimenpiteenNimi = nimi AND TarvitseeLaitetyypin.laitetyyppi = Laitetyyppi.tyyppi AND laitetyyppi.tyyppi = Laitekappale.laitetyyppi AND tunniste = 'H001'; 


SELECT * 
FROM Lasku, Muistutus 
WHERE muistutuslaskuNro = laskuNro AND päälaskuNro = '123456'; 