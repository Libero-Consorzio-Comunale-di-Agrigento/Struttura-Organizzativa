CREATE OR REPLACE FORCE VIEW VISTA_COMPETENZE_SO4
(UTENTE, OGGETTO, DAL, AL, TIPO_OGGETTO, 
 TIPO_ABILITAZIONE, ID_COMPETENZA)
BEQUEATH DEFINER
AS 
SELECT utente,
          oggetto,
          dal,
          al,
          tipo_oggetto,
          tipo_abilitazione,
          comp.id_competenza
     FROM si4_competenze comp,
          si4_abilitazioni abil,
          si4_tipi_oggetto tiog,
          si4_tipi_abilitazione tiab
    WHERE     comp.id_abilitazione = abil.id_abilitazione
          AND abil.id_tipo_oggetto = tiog.id_tipo_oggetto
          AND TIAB.ID_TIPO_ABILITAZIONE = ABIL.ID_TIPO_ABILITAZIONE
          AND tipo_oggetto LIKE 'SO4%';


