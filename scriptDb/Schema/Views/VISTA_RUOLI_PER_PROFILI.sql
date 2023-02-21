CREATE OR REPLACE FORCE VIEW VISTA_RUOLI_PER_PROFILI
(RUOLO, DESCRIZIONE, PROGETTO, MODULO)
BEQUEATH DEFINER
AS 
SELECT ruolo,
            descrizione,
            progetto,
            modulo
       FROM ad4_ruoli r
      WHERE     stato = 'U'
            AND gruppo_lavoro = 'S'
            AND gruppo_so = 'S'
            AND NOT EXISTS
                   (SELECT 'x'
                      FROM vista_profili
                     WHERE profilo = r.ruolo)
            AND NOT EXISTS
                   (SELECT 'x'
                      FROM ruoli_componente
                     WHERE ruolo = r.ruolo)
   ORDER BY ruolo;


