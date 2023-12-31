# Praktická maturitní zkouška - Databázové systémy

## **Střední průmyslová škola elektrotechnická, Praha 2, Ječná 30**
## **Školní rok 2022/2023**
---
Jméno a příjimeni: **Samuel Kuta**
Třída: **C4b**
---

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
př:
** Návrh obsahuje několik cizích klíčů, které jsou uvedeny níže
- 'fk_ucet_zamestnanec1' ON DELETE NO ACTION ON UPDATE NO ACTION
...

## Indexy 
- Databáze má pro každou entitu pouze indexy vytvořené pro primární klíče, 
další indexy ...

## Pohledy
- Návrh obsahuje pohledy ...

## Triggery
- Databáze obsahuje triggery ...

## Uložené procedury a funkce
- Databáze obsahuje procedury  ... a funkce ...

## Přístupové údaje do databáze
př:
- Přístupové údaje jsou volně konfigurovatelné v souboru /config/... .doc
pro vývoj byly použity tyto:
host		: localhost
uživatel	: sa
heslo		: student
databáze	: ...

## Import struktury databáze a dat od zadavatele
př:
Nejprve je nutno si vytvořit novou databázi, čistou, bez jakýchkoliv dat...
Poté do této databáze nahrát soubor, který se nachází v /sql/structure.sql ...
Pokud si přejete načíst do databáze testovací data, je nutno nahrát ještě soubor /sql/data.sql ...

## Klientská aplikace
- Databáze obsahuje/neobsahuje klientskou aplikaci ...

## Požadavky na spuštění
př:
- Oracle DataModeler, rok vydání 2014 a více ... 
- MSSQL Server, rok vydání 2014 a více ... 
- připojení k internetu alespoň 2Mb/s ...
...

## Návod na instalaci a ovládání aplikace
př:
Uživatel by si měl vytvořit databázi a nahrát do ní strukturu, dle kroku "Import struktury databáze 
a dat od zadavatele" ...
Poté se přihlásit předdefinovaným uživatelem, nebo si vytvořit vlastního pomocí SQL příkazů ...
Měl by upravit konfigurační soubor klientské aplikace, aby odpovídal jeho podmínkám ...
Dále nahrát obsah složky src na server a navštívit adresu serveru ... 
Přihlásit se a může začít pracovat ... 

## Závěr
př:
Tento systém by po menších úpravách mohl být převeden na jiný databázový systém, 
klientská aplikace není zabezpečená, 
počítá se s tím, že klient byl proškolen o používání této aplikace ...
Nepodařilo se dořešit ...
Pro další vývoj aplikace by bylo vhodné ...

