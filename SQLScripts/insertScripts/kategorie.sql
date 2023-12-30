BEGIN

START TRANSACTION;
/*Kategorie inserts*/
insert into Kategorie(id,nazev,strucnyPopis,nadKategorie) values ('0','root','root','0');

insert into Kategorie(id,nazev,strucnyPopis) values 
(UUID_TO_BIN(UUID()),'Kabely a Vodiče','Kabely a elektricke vodiče různých druhů.');



insert into Kategorie(id,nazev,strucnyPopis,nadKategorie) values 
(UUID_TO_BIN(UUID()),'Elektrické Kabely','Elektrické kabely různých druhů.',UNHEX('A077154CA6FA11EE827E8C1759ECD7D1'));

insert into Kategorie(id,nazev,strucnyPopis,nadKategorie) values 
(UUID_TO_BIN(UUID()),'Kabely CYKY','Silové instalační kabely CYKY (někdy též H05VV-U, H07VV-U) od profesionálního výrobce NKT. Oblíbené kabely s jistotou čisté mědi a kvalitního pláště.',UNHEX('9569E896A6FD11EE827E8C1759ECD7D1'));

insert into Kategorie(id,nazev,strucnyPopis,nadKategorie) values 
(UUID_TO_BIN(UUID()),'Kabely AYKY','Silové hliníkové kabely AYKY od profesionálních výrobců NKT, Draka a Prakab. Kabel s velkým průřezem a sektorovým jádrem využijete pro hlavní rozvaděč.',UNHEX('9569E896A6FD11EE827E8C1759ECD7D1'));

insert into Kategorie(id,nazev,strucnyPopis,nadKategorie) values 
(UUID_TO_BIN(UUID()),'Vodiče','Elektrické vodiče různých druhů.',UNHEX('A077154CA6FA11EE827E8C1759ECD7D1'));

insert into Kategorie(id,nazev,strucnyPopis,nadKategorie) values 
(UUID_TO_BIN(UUID()),'Ohebné vodiče CYA','Silové ohebné vodiče H05V-K a H07V-K (též CYA). Ohebné laněné jádro z čisté mědi a standardní barvy izolace. Použití například pro uzemnění dvířek.',UNHEX('D5D98F83A6FE11EE827E8C1759ECD7D1'));



insert into Kategorie(id,nazev,strucnyPopis) values 
(UUID_TO_BIN(UUID()),'Elektromateriál','Elektromateriál skladem, nízké ceny. Nejširší sortiment materiálu pro elektroinstalace doma i v průmyslu od Kopos, WAGO, Eleman, Den Braven a dalších.');

insert into Kategorie(id,nazev,strucnyPopis,nadKategorie) values 
(UUID_TO_BIN(UUID()),'Svorky a svorkovnice','Nabízíme svorky a svorkovnice skladem. Preferujete páčkové nebo šroubové? Vyberete si ze sortimentu WAGO svorek, svorkovnic značek Eleman a Elektro Bečov.',UNHEX('5CEECFDEA6FF11EE827E8C1759ECD7D1'));

insert into Kategorie(id,nazev,strucnyPopis,nadKategorie) values 
(UUID_TO_BIN(UUID()),'Bezšroubové svorky','Oblíbené rychlosvorky nabízejí moderní a profesionální řešení. Propojte vodiče ve stísněném prostoru pomocí bezšroubové svorky WAGO. Vyberte si velikost.',UNHEX('6BDBA060A70011EE827E8C1759ECD7D1'));

insert into Kategorie(id,nazev,strucnyPopis,nadKategorie) values 
(UUID_TO_BIN(UUID()),'Svorkovnice a můstky','Sortiment k propojení nulových či ochranných vodičů. Ekvipotenciální svorkovnice pro hlavní pospojování, nulové můstky na DIN a zemnící třmenové svorky.',UNHEX('6BDBA060A70011EE827E8C1759ECD7D1'));


END
