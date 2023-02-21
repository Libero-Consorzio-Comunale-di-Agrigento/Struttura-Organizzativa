CREATE OR REPLACE FORCE VIEW REVISIONI_ATTIVE
(OTTICA, REVISIONE_ATTIVA)
BEQUEATH DEFINER
AS 
select ottica
      ,(select max(revisione)
          from revisioni_struttura
         where ottica = o.ottica
           and stato = 'A') revisione_attiva
  from ottiche o;


