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
	nazev varchar(255) not null,
	poplatek int not null
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

 create view ObjednavkaInfo as select Objednavka.id,CONCAT(Zakaznik.jmeno,' ',Zakaznik.prijmeni) as jmenoZakaznika,ZpusobPlatby.nazev as Platba,ZpusobDoruceni.nazev as Doruceni,CONCAT(Objednavka.adresa,' ',Objednavka.mesto,' ',Objednavka.psc) as UplnaAdresa,Objednavka.datum,Objednavka.zaplaceno
 from Objednavka inner join Zakaznik
 on Objednavka.zakaznik_id = Zakaznik.id
 inner join ZpusobPlatby
 on Objednavka.zpusobPLatby_id = ZpusobPlatby.id
 inner join ZpusobDoruceni
 on Objednavka.zpusobDoruceni_id = ZpusobDoruceni.id
 order by datum desc;

 /*Procedures*/
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
DELIMITER;


 /*Triggers*/

delimiter //
CREATE TRIGGER aktualizace_ceny_objednavky AFTER INSERT
ON PolozkaNaObjednavce
FOR EACH ROW

END IF; //
delimiter ;
