CREATE OR REPLACE FORCE VIEW SUST_IST
(ID_SUDDIVISIONE, OTTICA, SUDDIVISIONE, DESCRIZIONE, ORDINAMENTO)
BEQUEATH DEFINER
AS 
select id_suddivisione
     , ottica
     , suddivisione
     , descrizione
     , ordinamento
  from suddivisioni_struttura
 where ottica in (select ottica 
                    from ottiche 
                   where ottica_istituzionale = 'SI');


