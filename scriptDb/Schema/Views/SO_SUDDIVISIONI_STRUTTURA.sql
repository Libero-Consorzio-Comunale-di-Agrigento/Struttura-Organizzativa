CREATE OR REPLACE FORCE VIEW SO_SUDDIVISIONI_STRUTTURA
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
  from suddivisioni_struttura s, ottiche o
 where s.ottica = o.ottica
   and o.ottica_istituzionale = 'SI';


