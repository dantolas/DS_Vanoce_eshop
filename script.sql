use  eshop;


create table IF NOT EXISTS Zakaznik(
	id BINARY(16) primary key,
	jmeno varchar(255) not null,
	prijmeni varchar(255) not null,
	email varchar(255) not null unique,
	telefon int 
);


create table IF NOT EXISTS ZpusobPlatby(
	id BINARY(16) primary key,
	nazev varchar(255) not null,
	poplatek int not null,
);


create table IF NOT EXISTS ZpusobDoruceni(
	id BINARY(16) primary key,
	nazev varchar(255) not null,
	cena int not null,
	dnyDoDoruceni int not null
);


create table IF NOT EXISTS Objednavka(
	id BINARY(16) primary key,
	zakaznik_id BINARY(16) not null,
	constraint fk_zakaznik foreign key(zakaznik_id) references Zakaznik(id),
	zpusobPlatby_id BINARY(16) not null,
	constraint fk_zpusobPlatby foreign key(zpusobPLatby_id) references ZpusobPlatby(id);
	zpusobDoruceni_id BINARY(16) not null,
	constraint fk_zpusobDoruceni foreign key(zpusobDoruceni_id) references ZpusobDoruceni(id),
	celkovaCena int not null,
	adresa varchar(255) not null,
	mesto varchar(255) not null,
	psc int not null,
	datum datetime not null,
	zaplaceno bit(1)
);


create table IF NOT EXISTS Kategorie(
	id BINARY(16) primary key,
	nazev varchar(255) unique not null,
	strucnyPopis varchar(500),
	nadKategorie BINARY(16) not null,
	constraint fk_nadKategorie foreign key (nadKategorie) references Kategorie(id)
);


create table IF NOT EXISTS Polozka(
	id BINARY(16) primary key,
	kategorie_id BINARY(16),
	constraint fk_kategorie foreign key(kategorie_id) references Kategorie(id),
	nazev varchar(255) not null,
	cena_ks int not null,
	strucny_popis varchar(400) not null,
	detail_popis text not null,
	slevaProcenta int not null,
);


create table IF NOT EXISTS PolozkaNaObjednavce(
	id BINARY(16) primary key,
	objednavka_id BINARY(16) not null,
	constraint fk_objednavka foreign key(objednavka_id) references Objednavka(id),
	polozka_id BINARY(16) not null,
	constraint fk_polozka foreign key(polozka_id) references Polozka(id),
	pocet_ks int not null,
	cena int not null
);
