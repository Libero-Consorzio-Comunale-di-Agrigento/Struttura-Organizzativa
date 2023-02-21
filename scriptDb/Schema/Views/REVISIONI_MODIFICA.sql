CREATE OR REPLACE FORCE VIEW REVISIONI_MODIFICA
(OTTICA, REVISIONE_MODIFICA)
BEQUEATH DEFINER
AS 
select ottica
      ,nvl((select revisione
             from revisioni_struttura
            where ottica = o.ottica
              and stato = 'M')
          ,-1) revisione_modifica
  from ottiche o;


