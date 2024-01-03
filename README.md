# Praktická maturitní zkouška - Databázové systémy

## **Střední průmyslová škola elektrotechnická, Praha 2, Ječná 30**
## **Školní rok 2022/2023**

## Jméno a příjimeni: **Samuel Kuta**

## Třída: **C4b**

## Úvod

### Zadání: Databáze podporující eshop v oblasti elektrotechnika,mikroelektronika.
### Použitý vzor pro E-shop : [iElektra.cz](https://www.ielektra.cz/)

- Problém jsem řešil v MySQL Server, jako návrhové prostředí jsem 
  využil Oracle SQL DataModeler.

## E-R model
- Konceptuální model databáze se nachází v adresáři /img/
- Naleznete LogickéSchema.png, RelacniSchema.png, a popis už vytvořených entit vytvořený pomocí SQL příkazu DESC. 

## Entitní integrita
- Každá entita obsahuje uměle vytvořený primární klíč, označený jako `id`.
- Primární klíč je uložený jako 16ti byteova binární reprezentace `UUID` - generovaného klíče, který je unikátně generovaný serverem. 
- PK se automaticky generuje pro každou entitu.

## Stručný popis entit
- **Zakaznik** - Informace o zakaznicich
- **ZpusobPlatby** - Informace o ruznych zpusobech platby
- **ZpusobDoruceni** - Informace o ruznych zpusobech doruceni zbozi.
- **Kategorie** - Kategorie do kterych patri polozky, vyuziva self-reference vytvoreni hierarchie kategorii.
- **Polozka** - Informace o polozce v prodeji.
- **PolozkaNaObjednavce** - Vazebni tabulka, reprezentuje polozku na objednavce, pocet ks atd.
- **Objednavka** - Informace o objednavkach.

## Doménová integrita
### Popis všech atributů entit a jejich integritních omezení
**Zakaznik**
- `jmeno` - libovolné znaky, maximálně však 255 znaků, not null
- `prijmeni` - libovolné znaky, maximálně však 255 znaků, not null, min délka 3znaky
- `email` - libovolné znaky, maximálně však 255,not null, unique, musi obsahovat znak '@'
- `telefon` - telefoni cislo, maximalne 20 znaku, muze byt null

**ZpusobPlatby**
- `nazev` - libovolne znaky, maximálně však 255, not null, unique
- `poplatek` - kladne cislo nebo 0, int, defaultne 0 

**ZpusobDoruceni**
- `nazev` - libovolne znaky, maximálně však 255, not null
- `cena` - kladne cislo nebo 0, int, not null
- `dnyDoDoruceni` - průměrný počet dnů do doručení, kladné číslo, not null

**Kategorie**
- `nazev` - libovolne znaky, maximálně však 255, not null, unique
- `strucnyPopis`- libovolne znaky, maximálně však 500
- `nadKategorie` - ID kategorie která je této nadřazená, fk, not null, default 0

**Polozka**
- `kategorie_id` - ID kategorie, do které položka patří, fk, not null
- `nazev` - libovolne znaky, maximálně však 255, not null
- `cena_ks` - cena za kus polozky, kladne cislo nebo nula, int, not null
- `strucny_popis` - libovolne znaky, maximálně však 400, not null,
- `detail_popis` - libovolné znaky,
- `slevaProcenta` - kladne cislo 0-100,not null, int

**PolozkaNaObjednavce**
- `objednavka_id` - ID objednavky ke které položka patří, not null
- `polozka_id` - ID položky kterou záznam reprezentuje,
not null
- `pocet_ks` - kladné číslo, int not null
- `cena` - vypočítá se automaticky, kladné číslo nebo 0, int, not null

**Objednavka**
- `zakaznik_id` - ID zakaznika kteremu objednavka patri, not null
- `zpusobPlatny_id` - ID zpusobu platby, not null
- `zpusobDoruceni_id` - ID zpusobu doruceni, not null
- `celkovaCena` - kladne cislo nebo 0, int, not null
- `adresa` - libovolne znaky, maximalne 255, not null
- `mesto` - libovolne znaky, maximalne 255, not null
- `datum` - generuje se automaticky, datetime, not null
- `zaplaceno` - 0 nebo 1, not null, default 0
## Referenční integrita
Návrh obsahuje několik cizích klíčů, které jsou uvedeny níže
- **PolozkaNaObjednavce**
  - `fk_polozka_id`
    - Odkaz na Polozka.id
    - ON DELETE : NOT ALLOWED
    - ON UPDATE :  NOT ALLOWED
- **Kategorie**
  - `fk_nadKategorie`
    - Odkaz na Kategorie.id
    - ON DELETE : NO ACTION
    - ON UPDATE : NO ACTION
- **Objednavka**
  - `fk_zakaznik_id`
    - Odkaz na Zakaznik.id
    - ON DELETE : NOT ALLOWED
    - ON UPDATE : NOT ALLOWED
  - `fk_zpusobPlatby_id`
    - Odkaz na ZpusobPlatby.id
    - ON DELETE : NOT ALLOWED
    - ON UPDATE : NOT ALLOWED
  - `fk_zpusobDoruceni_id`
    - Odkaz na ZpusobDoruceni.id
    - ON DELETE : NOT ALLOWED
    - ON UPDATE : NOT ALLOWED


## Indexy 
- Databáze má pro každou entitu pouze indexy vytvořené pro primární klíče, 

## Pohledy
**KategorieHex**
- Obsahuje jmena kategorii, a hex reprezentaci jejich ID, a nadKategore ID

**ObjednavkaInfo**
- Pristupne obsahuje dulezite informace o objednavkach.

**PolozkaInfo**
- Pristupne obsahuje dulezite informace o polozkach.

## Triggery
**kontrola_ceny_polozky**
- ON `Polozka`
- Kontroluje aby cena polozky nemohla byt negativni
- BEFORE INSERT

**kontrola_slevy_polozky**
- ON `Polozka`
- Kontroluje aby sleva musela byt nastavena v intervalu 0-100
- BEFORE INSERT

**pridani_ceny_polozkyNaObjednavce**
- ON `PolozkaNaObjednavce`
- Prida cenu polozce, podle poctu kusu, a ceny za kus v Polozka.
- BEFORE INSERT

**aktualizace_ceny_objednavky**
- ON `PolozkaNaObjednavce`
- Aktualizuje cenu objednavky po pridani polozky.
- AFTER INSERT

**kontrola_aktualizace_ceny**
- ON `Objednavka`
- Kontroluje jestli nova cena neni negativni.
- BEFORE EUPDATE

**kontrola_delky_prijmeni**
- ON `Zakaznik`
- Kontroluje minimalni delku prijmeni -3 znaky
- BEFORE INSERT

**kontrola_zavinace_email**
- ON `Zakaznik`
- Kontroluje jestli je v zadanem emailu znak @
- BEFORE INSERT

**kontrola_poplatku_ZpusobPlatby**
- ON `ZpusobPlatby`
- Kontroluje aby poplatek nebyl zaporny.
- BEFORE INSERT

**kontrola_zpusobDoruceni**
- ON `ZpusobDoruceni`
- Kontroluje nezaporne vstupy.
- BEFORE INSERT

**zakaz_update_polozkaNaObjednavce**
- ON `PolozkaNaObjednavce`
- Zakazuje upraveni polozka_id.
- BEFORE UPDATE

**zakaz_delete_PolozkaNaObjednavce**
- ON `PolozkaNaObjednavce`
- Zakazuje delete na tabulku.
- BEFORE DELETE

**zakaz_delete_Objednavka**
- ON `Objednavka`
- Zakazuje delete na tabulku.
- BEFORE DELETE

**zakaz_update_fk_Objednavka**
- ON `Objednavka`
- Zakazuje update na cizich klicich v objednavce.
- BEFORE UPDATE

**update_ceny_pridaniKusu**
- ON `PolozkaNaObjednavce`
- Aktualizuje cenu polozky i objednavky po update na pocet_ks
- AFTER UPDATE



## Uložené procedury a funkce
**novaObjednavka**
- `PROCEDURE`
- Pridani nove objednavky do databaze
- **Params**:
  - email zakaznika kteremu objednavka patri,
  - nazev zpusobu doruceni podle tabulky ZpusobDoruceni,
  - nazev zpusobu platby podle tabulky ZpusobPlatby,
  - adresovy radek 1 pro doruceni,
  - mesto pro doruceni,
  - postovni smerovaci cislo, bez mezer jako cislo 12800

**novaPolozkaNaObjednavce**
- `PROCEDURE`
- Pridani nove polozky k objednavce do databaze
- **Params**:
  - id_objednavky
  - id_polozky
  - pocet_kusu
**objednavkaaplacena**
- `PROCEDURE`
- Oznaceni objednavky jako zaplacene.
- **Params**:
  - id objednavky

**pridatKategoriiHex**
- `PROCEDURE`
- Pridani nove kategorie.
- **Params**:
  - nazev nove kategorie,
  - strucny popis nove kategorie,
  - HEX reprezentaci ID nadKategorie, naleznete bud zavolanim procedury ukazHexKategorii(), a nebo v pohledu KategorieHex;

**pridatKategoriiNazev**
- `PROCEDURE`
- Pridani nove kategorie
- **Params**:
  - nazev nove kategorie
  - strucny popis nove kategorie
  - nazev nadKategorie

**pridatZakaznika**
- `PROCEDURE`
- Pridani noveho zakaznika.
- **Params**:
  - jmeno zakaznika
  - prijmeni zakaznika
  - email zakaznika
  - telefoni cislo zakaznika

**pridatZpusobDoruceni**
- `PROCEDUER`
- Pridani noveho zpusobu doruceni.
- **Params**:
  - nazev zpusobu doruceni
  - cena zpusobu doruceni
  - prumerny pocet dni do doruceni

**pridatZpusobPlatby**
- `PROCEDURE`
- Pridani noveho zpusobu platby.
- **Params**:
  - nazev zpusobu platby
  - poplatek za zpusob platby

**aktualizovatCenuObjednavky**
- `PROCEDURE`
- Aktualizuje celkovouCenu objednavky
sectenim ceny vsech polozek na objednavce
a zpusobu platby a doruceni;
- **Params**:
  - id objednavky

**pridatPolozkuHex**
- `PROCEDURE`
- Pridani nove polozky.
- **Params**:
nazev polozky,
  - hex reprezentace ID kategorie do ktere polozka patri (naleznete zavolanim procedury ukazHexKategorii)
  - strucny popis
  - detailni popis
  - sleva v procentech 0-100

**pridatPolozkuNazev**
- `PROCEDURE`
- Pridani nove polozky.
- **Params**:
nazev polozky,
  - nazev kategorie do ktere polozka patri
  - strucny popis
  - detailni popis
  - sleva v procentech 0-100
## Přístupové údaje do databáze
př:
- Přístupové údaje jsou volně konfigurovatelné v souboru /config/... .doc
pro vývoj byly použity tyto:
- `host`		: localhost
- `uživatel`	: sa
- `heslo`		: student
- `databáze`	: eshop

## Import struktury databáze a dat od zadavatele
### |1|
Nejprve je nutno si vytvořit novou databázi, čistou, bez jakýchkoliv dat.
### |2|
Poté do této databáze nahrát soubor, který se nachází v /sql/structure.sql.
### |3|
Pokud si přejete načíst do databáze testovací data, je nutno nahrát ještě soubor /sql/data.sql ...

## Klientská aplikace
- Databáze **NEOBSAHUJE** klientskou aplikaci. 

## Zálohování databáze
- MySQL nepodporuje bez použití 3rd party softwaru differenciální ani incrementální zálohování.
- Je proto nejjednodušší udělat plnou zálohu databáze. 
- Zálohu celé databáze nebo jednotlivých stolů lze udělat následujícími příkazy, 
pokud už má uživatel přístup k databázi, nebo v programu MySQL Workbench:

**Příkazy se používají v příkazovém řádku PC kde je server instalován, ne v klientském připojení k mysql serveru.**
  - **Full backup databaze**
  
  `
  mysqldump -u [username] -p [nazevDatabaze]  > ./full_$(date "+%b_%d_%Y_%H_%M_%S").sql
  `
  
  - **Backup pro jednotlive stoly**
  
  ` 
  mysqldump -u [username] -p [nazevDatabaze] Zakaznik > ./full_Zakaznik_$(date "+%b_%d_%Y_%H_%M_%S").sql
  `
 
  `
  mysqldump -u [username] -p [nazevDatabaze] Objednavka > ./full_Objednavka_$(date "+%b_%d_%Y_%H_%M_%S").sql
  `

  `
  mysqldump -u [username] -p [nazevDatabaze] Polozka > ./full_Polozka_$(date "+%b_%d_%Y_%H_%M_%S").sql
  `
  `
  mysqldump -u [username] -p [nazevDatabaze] PolozkaNaObjednavce > ./full_PolNaObj_$(date "+%b_%d_%Y_%H_%M_%S").sql
  `

  `
  mysqldump -u [username] -p [nazevDatabaze] Kategorie > ./full_Kategorie_$(date "+%b_%d_%Y_%H_%M_%S").sql
  `

  `
  mysqldump -u [username] -p [nazevDatabaze] ZpusobPlatby > ./full_ZpusobPlatby_$(date "+%b_%d_%Y_%H_%M_%S").sql
  `

  `
  mysqldump -u [username] -p [nazevDatabaze] ZpusobDoruceni > ./full_ZpusobDoruceni_$(date "+%b_%d_%Y_%H_%M_%S").sql
  `  

## Archivace dat
### Data databáze lze archivovat do souboru .csv pomocí následujících **SQL** dotazů:

### !!
**MySQL musí mít přístup k těmto složkám, což se dá nastavit buď v /etc/mysql/my.cnf, nebo nastavení práv složky do které chcete zapisovat**

**Zakaznik**

`select * from Zakaznik
into outfile ['cesta']
fields terminated by ','
enclosed by '"'
lines terminated by '\n';`

**Zpusob Doruceni**

`select * from ZpusobDoruceni
into outfile ['cesta']
fields terminated by ','
enclosed by '"'
lines terminated by '\n';`

**Zpusob Platby**

`select * from ZpusobPlatby 
into outfile ['cesta']
fields terminated by ','
enclosed by '"'
lines terminated by '\n';`

**Kategorie**

`select * from Kategorie
into outfile ['cesta']
fields terminated by ','
enclosed by '"'
lines terminated by '\n';`

**Polozka**

`select * from Polozka
into outfile ['cesta']
fields terminated by ','
enclosed by '"'
lines terminated by '\n';`

**Objednavka**

`select * from Objednavka
into outfile ['cesta']
fields terminated by ','
enclosed by '"'
lines terminated by '\n';`




## Požadavky na spuštění
- `MySQL Server` - verze 8.0 a novejsi 
- připojení k internetu o minimální rychlosti 2Mb/s

## Návod na instalaci a ovládání aplikace
Uživatel by si měl vytvořit databázi a nahrát do ní strukturu, dle kroku: [Import struktury databáze 
a dat od zadavatele](#Import-struktury-databáze-a-dat-od-zadavatele). 

Poté se přihlásit předdefinovaným uživatelem, nebo si vytvořit vlastního pomocí SQL příkazů.

Po přihlášení může uživatel začít pracovat s databází.

## Závěr
`|Flexibilita|`

Tato struktura databáze by mohla fungovat i pro eshop jiných potřeb po menších úpravách.

`|Přístupnost|`

Počítá se s tím, že klient byl proškolen o používání této aplikace.

`|Nedostatky|`

Nepodařilo se dořešit.

`|Budoucí vývoj|`

Pro další vývoj by bylo vhodné vyvinout klientskou aplikaci, udělat důkladněji práva a přístupy pro uživatele. 
