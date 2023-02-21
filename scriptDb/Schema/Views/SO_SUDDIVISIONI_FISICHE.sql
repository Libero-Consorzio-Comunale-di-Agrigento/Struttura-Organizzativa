CREATE OR REPLACE FORCE VIEW SO_SUDDIVISIONI_FISICHE
(ID_SUDDIVISIONE, AMMINISTRAZIONE, SUDDIVISIONE, DENOMINAZIONE, DES_ABB, 
 ICONA_STANDARD, ASSEGNABILE, ORDINAMENTO)
BEQUEATH DEFINER
AS 
select id_suddivisione
      ,amministrazione
      ,suddivisione
      ,denominazione
      ,des_abb
      ,icona_standard
      ,assegnabile
      ,ordinamento
  from suddivisioni_fisiche s
      ,amministrazioni      a
 where s.amministrazione = a.codice_amministrazione
   and a.ente = 'SI';


