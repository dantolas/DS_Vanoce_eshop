use  eshop;

/*Tables*/
create table IF NOT EXISTS Zakaznik(
	id BINARY(16) primary key  default (UUID_TO_BIN(UUID())),
	jmeno varchar(255) not null,
	prijmeni varchar(255) not null,
	email varchar(255) not null unique,
	telefon varchar(20) 
);


create table IF NOT EXISTS ZpusobPlatby(
	id BINARY(16) primary key  default (UUID_TO_BIN(UUID())),
	nazev varchar(255) not null unique,
	poplatek int not null default 0
);


create table IF NOT EXISTS ZpusobDoruceni(
	id BINARY(16) primary key  default (UUID_TO_BIN(UUID())),
	nazev varchar(255) not null,
	cena int not null,
	dnyDoDoruceni int not null
);


create table IF NOT EXISTS Objednavka(
	id BINARY(16) primary key  default (UUID_TO_BIN(UUID())),
	zakaznik_id BINARY(16) not null,
	constraint fk_zakaznik foreign key(zakaznik_id) references Zakaznik(id),
	zpusobPlatby_id BINARY(16) not null,
	constraint fk_zpusobPlatby foreign key(zpusobPLatby_id) references ZpusobPlatby(id),
	zpusobDoruceni_id BINARY(16) not null,
	constraint fk_zpusobDoruceni foreign key(zpusobDoruceni_id) references ZpusobDoruceni(id),
	celkovaCena int not null default 0,
	adresa varchar(255) not null,
	mesto varchar(255) not null,
	psc int not null,
	datum datetime not null default (NOW()),
	zaplaceno bit(1) default 0
);


create table IF NOT EXISTS Kategorie(
	id BINARY(16) primary key  default (UUID_TO_BIN(UUID())),
	nazev varchar(255) unique not null,
	strucnyPopis varchar(500),
	nadKategorie BINARY(16) not null,
	constraint fk_nadKategorie foreign key (nadKategorie) references Kategorie(id)
);


create table IF NOT EXISTS Polozka(
	id BINARY(16) primary key  default (UUID_TO_BIN(UUID())),
	kategorie_id BINARY(16),
	constraint fk_kategorie foreign key(kategorie_id) references Kategorie(id),
	nazev varchar(255) not null,
	cena_ks int not null,
	strucny_popis varchar(400) not null,
	detail_popis text not null,
	slevaProcenta int not null
);


create table IF NOT EXISTS PolozkaNaObjednavce(
	id BINARY(16) primary key  default (UUID_TO_BIN(UUID())),
	objednavka_id BINARY(16) not null,
	constraint fk_objednavka foreign key(objednavka_id) references Objednavka(id),
	polozka_id BINARY(16) not null,
	constraint fk_polozka foreign key(polozka_id) references Polozka(id),
	pocet_ks int not null,
	cena int not null
);

/*Views*/
 create view KategorieHex as select HEX(id) as hexID,nazev,HEX(nadKategorie) as nadHexId from Kategorie;

 create view ObjednavkaInfo as select Objednavka.id,CONCAT(Zakaznik.jmeno,' ',Zakaznik.prijmeni) as 'jmeno Zakaznika',ZpusobPlatby.nazev as Platba,ZpusobDoruceni.nazev as Doruceni,CONCAT(Objednavka.adresa,' ',Objednavka.mesto,' ',Objednavka.psc) as 'Uplna Adresa',Objednavka.datum as 'Datum Vytvoreni',Objednavka.celkovaCena as 'Cena',Objednavka.zaplaceno
 from Objednavka inner join Zakaznik
 on Objednavka.zakaznik_id = Zakaznik.id
 inner join ZpusobPlatby
 on Objednavka.zpusobPLatby_id = ZpusobPlatby.id
 inner join ZpusobDoruceni
 on Objednavka.zpusobDoruceni_id = ZpusobDoruceni.id
 order by datum desc;

 /*Procedures*/

 /*
 Procedura na pridani nove objednavky.
 Params:
 email zakaznika kteremu objednavka patri,
 nazev zpusobu doruceni podle tabulky ZpusobDoruceni,
 nazev zpusobu platby podle tabulky ZpusobPlatby,
 adresovy radek 1 pro doruceni,
 mesto pro doruceni,
 postovni smerovaci cislo, bez mezer jako cislo 12800
 */
DELIMITER //
 create procedure novaObjednavka(
	IN _emailZakaznika VARCHAR(50),
	IN _nazevDoruceni VARCHAR(50),
	IN _nazevPlatby VARCHAR(50),
	IN _adresa VARCHAR(50),
	IN _mesto VARCHAR(50),
	IN _psc int
)
BEGIN

START TRANSACTION;
	insert into Objednavka(zakaznik_id,zpusobPlatby_id,zpusobDoruceni_id,adresa,mesto,psc) 
	select Zakaznik.id,ZpusobPlatby.id,ZpusobDoruceni.id,_adresa,_mesto,_psc
	from Zakaznik,ZpusobPlatby,ZpusobDoruceni
	where Zakaznik.email = _emailZakaznika && ZpusobDoruceni.nazev = _nazevDoruceni && ZpusobPlatby.nazev = _nazevPlatby;
END //
DELIMITER ;

DELIMITER //
 create procedure novaPolozkaNaObjednavce(
	in _objednavka_id binary(16),
    in _polozka_id binary(16),
    in _pocet_ks int
)
BEGIN

START TRANSACTION;
	insert into PolozkaNaObjednavce(objednavka_id,polozka_id,pocet_ks) 
    values (_objednavka_id,_polozka_id,_pocet_ks);
END //
DELIMITER ;

/*
Procedura oznaci objednavku jako zaplacenou
Params: zkopirovane ID objednavky, ktera ma byt oznacena za zaplacenou.
*/
DELIMITER //
create procedure objednavkaZaplacena(
    in _idObjednavky binary(16) 
)
BEGIN

START TRANSACTION;
    
	update  Objednavka set Objednavka.zaplaceno = 1 
    where id = _idObjednavky; 
END //
DELIMITER ;



/*
Procedura na pridani nove kategorie.
Params:
nazev nove kategorie,
strucny popis nove kategorie,
HEX reprezentaci ID nadKategorie, naleznete bud zavolanim procedury ukazHexKategorii(), a nebo v pohledu KategorieHex;
*/
DELIMITER //
 create procedure pridatKategoriiHex(
	in _nazev varchar(255),
	in _strucnyPopis varchar(500),
	in _nadKategorieHex VARCHAR(60)
)
BEGIN

START TRANSACTION;
	insert into Kategorie(nazev,strucnyPopis,nadKategorie)
	select _nazev,_strucnyPopis,Kategorie.id
	where Kategorie.nadKategorie = (UNHEX(_nadKategorieHex));
END //
DELIMITER ;

/*
Procedura ktera vypise obsah pohledu KategorieHex.
Muzete takto zjistit hexadecimalni reprezentaci ID kategorii a nad kategorii, kterou pak pouzijete v jinych procedurach.
*/
DELIMITER //
 create procedure ukazInfoObjednavky(
)
BEGIN

START TRANSACTION;
	select * from ObjednavkaInfo;
END //
DELIMITER ;

/*
Procedura ktera vypise obsah pohledu KategorieHex.
Muzete takto zjistit hexadecimalni reprezentaci ID kategorii a nad kategorii, kterou pak pouzijete v jinych procedurach.
*/
DELIMITER //
 create procedure ukazHexKategorii(
)
BEGIN

START TRANSACTION;
	select * from KategorieHex;
END //
DELIMITER ;

DELIMITER //
 create procedure pridatKategoriiNazev(
	in _nazev varchar(255),
	in _strucnyPopis varchar(500),
	in _nadKategorieNazev VARCHAR(255)
)
BEGIN

START TRANSACTION;
	insert into Kategorie(nazev,strucnyPopis,nadKategorie)
	select _nazev,_strucnyPopis,Kategorie.id
	where Kategorie.nazev = _nadKategorieNazev;
END //
DELIMITER ;
/*
Procedura na pridani noveho zakaznika.
Params:
jmeno zakaznika,
prijmeni zakaznika,
email zakaznika,
telefoni cislo zakaznika
*/
DELIMITER //
 create procedure pridatZakaznika(
	in _jmeno varchar(255),
	in _prijmeni varchar(255),
	in _email VARCHAR(255)
	in _telefon varchar(20)
)
BEGIN

START TRANSACTION;
	insert into Zakaznik(jmeno,prijmeni,email,telefon)
	values(_jmeno,_prijmeni,_email,_telefon);
END //
DELIMITER ;

/*
Procedura na pridani noveho zpusobu dorucovani.
Params:
nazev zpusobu doruceni,
cena zpusobu doruceni,
prumerny pocet dnu do doruceni
*/
DELIMITER //
create procedure pridatZpusobDoruceni(
	in _nazev varchar(255),
	in _cena int,
	in _dnyDoDoruceni int
)
BEGIN

START TRANSACTION;
	insert into ZpusobDoruceni(nazev,cena,dnyDoDoruceni) values(_nazev,_cena,_dnyDoDoruceni);
END //
DELIMITER ;

/*
Procedura na pridani noveho zpusobu platby.
Params:
nazev zpusobu platby,
poplatek za zpusob platby
*/
DELIMITER //
create procedure pridatZpusobPlatby(
	in _nazev varchar(255),
	in _poplatek int
)
BEGIN

START TRANSACTION;
	insert into ZpusobPlatby(nazev,poplatek) values(_nazev,_poplatek);
END //
DELIMITER ;

/*
Aktualizuje celkovouCenu objednavky
sectenim ceny vsech polozek na objednavce
a zpusobu platby a doruceni;
*/
DELIMITER //
create procedure aktualizovatCenuObjednavky(
    in _idObjednavky BINARY(16)
)
BEGIN

START TRANSACTION;
    update Objednavka
    set celkovaCena = (select SUM(cena) from Polozka where objednavka_id = _idObjednavky)
    where id = _idObjednavky;
END //
DELIMITER ; 

/*
Procedura na pridani nove polozky.
Pouziva HEX reprezentaci ID kategorie do ktere patri.
Params:
nazev polozky,
hex reprezentace ID kategorie do ktere polozka patri (naleznete zavolanim procedury ukazHexKategorii),
strucny popis,
detailni popis,
sleva v procentech 0-100
*/
DELIMITER //
create procedure pridatPolozkuHex(
	in _nazev varchar(255),
	in _kategorieHex varchar(32),
	in _cena_ks int,
	in _strucny_popis varchar(400),
	in _detail_popis text,
	in _slevaProcenta int

)
BEGIN

START TRANSACTION;
	insert into Polozka(kategorie_id,nazev,cena_ks,strucny_popis,detail_popis,slevaProcenta)
	select Kategorie.id,_nazev,_cena_ks,_strucny_popis,_detail_popis,_slevaProcenta
	from Kategorie
	where Kategorie.id = (UNHEX(_kategorieHex));
END //
DELIMITER ;

/*
Procedura na pridani nove polozky.
Pouziva nazev kategorie do ktere patri.
Params:
nazev polozky,
nazev kategorie do ktere polozka patri,
strucny popis,
detailni popis,
sleva v procentech 0-100
*/
DELIMITER //
create procedure pridatPolozkuNazev(
	in _nazev varchar(255),
	in _kategorieNazev varchar(255),
	in _cena_ks int,
	in _strucny_popis varchar(400),
	in _detail_popis text,
	in _slevaProcenta int

)
BEGIN

START TRANSACTION;
	insert into Polozka(kategorie_id,nazev,cena_ks,strucny_popis,detail_popis,slevaProcenta)
	select Kategorie.id,_nazev,_cena_ks,_strucny_popis,_detail_popis,_slevaProcenta
	from Kategorie
	where Kategorie.nazev = _kategorieNazev;
END //
DELIMITER ;

 /*Triggers*/
delimiter //
CREATE TRIGGER kontrola_ceny_polozky BEFORE INSERT
ON Polozka
FOR EACH ROW
BEGIN
if new.cena_ks < 0 THEN
SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Cena polozky nemuze byt mensi nez 0.';
end if;
END //
delimiter ;

delimiter //
CREATE TRIGGER kontrola_slevy_polozky BEFORE INSERT
ON Polozka
FOR EACH ROW
BEGIN
if new.slevaProcenta < 0 OR new.slevaProcenta > 100 THEN
SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Sleva musi byt v procentech od 0-100';
end if;
END //
delimiter ;


delimiter //
CREATE TRIGGER pridani_ceny_polozkyNaObjednavce BEFORE INSERT
ON PolozkaNaObjednavce
FOR EACH ROW
BEGIN
set new.cena = (new.pocet_ks * (select cena_ks from Polozka where Polozka.id = new.polozka_id));
end//
delimiter ;

delimiter //
CREATE TRIGGER aktualizace_ceny_objednavky AFTER INSERT
ON PolozkaNaObjednavce
FOR EACH ROW
BEGIN
update Objednavka set celkovaCena = celkovaCena + new.cena
where Objednavka.id = new.objednavka_id;
end //
delimiter ;


delimiter //
CREATE TRIGGER kontrola_aktualizace_ceny BEFORE UPDATE 
ON Objednavka
FOR EACH ROW
BEGIN
if new.celkovaCena < 0 THEN
SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Cena objednavky nemuze byt mensi nez 0.';
end if;
END//
delimiter ;

DELIMITER //
create trigger kontrola_delky_prijmeni before insert
on Zakaznik
FOR EACH ROW
BEGIN
if (length(new.prijmeni) < 3) THEN
    SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Zakaznikovo prijmeni musi byt alespon 3 znaky dlouhe';
end if;
END //
DELIMITER ;

DELIMITER //
create trigger kontrola_zavinace_email before insert
on Zakaznik
FOR EACH ROW
BEGIN
if (LOCATE('@',new.email) = 0) THEN
    SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Zakaznikuv email musi obsahovat "@"';
end if;
END //
DELIMITER ;

DELIMITER //
create trigger kontrola_poplatku_ZpusobPlatby before insert
on ZpusobPlatby
FOR EACH ROW
BEGIN
if (new.poplatek < 0) THEN
    SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Poplatek nemuze byt mensi nez 0';
end if;
END //
DELIMITER ;

DELIMITER //
create trigger kontrola_zpusobDoruceni before insert
on ZpusobDoruceni
FOR EACH ROW
BEGIN
if (new.cena < 0 OR new.dnyDoDoruceni < 0) THEN
    SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Cena ani dnyDoDoruceni nemohou by mensi nez 0.';
end if;
END //
DELIMITER ;

delimiter //
CREATE TRIGGER zakaz_update_PolozkaNaObjednavce BEFORE UPDATE
ON PolozkaNaObjednavce
FOR EACH ROW
BEGIN
if new.polozka_id != old.polozka_id THEN
SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Neni povoleno updatovat polozka_id.';
end if;
END //
delimiter ;

delimiter //
CREATE TRIGGER zakaz_delete_PolozkaNaObjednavce BEFORE DELETE
ON PolozkaNaObjednavce
FOR EACH ROW
BEGIN
SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Neni povoleno delete.';
END //
delimiter ;

delimiter //
CREATE TRIGGER zakaz_delete_Objednavka BEFORE DELETE
ON Objednavka
FOR EACH ROW
BEGIN
SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Neni povoleno delete.';
END //
delimiter ;

delimiter //
CREATE TRIGGER zakaz_update_fk_Objednavka BEFORE UPDATE
ON Objednavka
FOR EACH ROW
BEGIN
if new.zakaznik_id != old.zakaznik_id OR new.zpusobPLatby_id != old.zpusobPLatby_id OR new.zpusobDoruceni_id != old.zpusobDoruceni_id then
SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Neni povoleno updatovat cizi klice.';
end if;
END //
delimiter ;

delimiter //
CREATE TRIGGER update_ceny_pridaniKusu AFTER UPDATE
ON PolozkaNaObjednavce
FOR EACH ROW
BEGIN
if new.pocet_ks != old.pocet_ks then
update PolozkaNaObjednavce inner join Polozka
on PolozkaNaObjednavce.polozka_id = Polozka.id
set cena = (pocet_ks * Polozka.cena_ks)
where PolozkaNaObjednavce.id = new.id;
call aktualizovatCenuObjednavky();
end if;
END //
delimiter ;
