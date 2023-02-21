CREATE OR REPLACE FORCE VIEW SUST_ENTI
(OTTICA, ID_SUDDIVISIONE, SUDDIVISIONE, DESCRIZIONE, ICONA_STANDARD, 
 ORDINAMENTO)
BEQUEATH DEFINER
AS 
select s.ottica
     , s.id_suddivisione
     , s.suddivisione
     , s.descrizione
     , s.icona_standard
     , s.ordinamento
  from suddivisioni_struttura s
     , ottiche o
     , amministrazioni a
 where s.ottica = o.ottica
   and o.amministrazione = a.codice_amministrazione
   and a.ente = 'SI';


