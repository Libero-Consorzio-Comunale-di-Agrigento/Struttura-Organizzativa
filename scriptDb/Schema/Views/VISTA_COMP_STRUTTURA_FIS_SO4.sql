CREATE OR REPLACE FORCE VIEW VISTA_COMP_STRUTTURA_FIS_SO4
(OGGETTO, UTENTE)
BEQUEATH DEFINER
AS 
SELECT TO_NUMBER (oggetto) oggetto, utente
     FROM (SELECT OGGETTO, uten.utente
             FROM SI4_competenze COMP,
                  SI4_ABILITAZIONI ABIL,
                  SI4_TIPI_OGGETTO TIOG,
                  SI4_TIPI_ABILITAZIONE TIAB,
                  AD4_UTENTI UTEN
            WHERE     COMP.utente = UTEN.UTENTE
                  AND COMP.ID_ABILITAZIONE = ABIL.ID_ABILITAZIONE
                  AND ABIL.ID_TIPO_OGGETTO = TIOG.ID_TIPO_OGGETTO
                  AND TIOG.TIPO_OGGETTO = 'SO4STRF'
                  AND TIAB.ID_TIPO_ABILITAZIONE = ABIL.ID_TIPO_ABILITAZIONE
                  AND TIAB.TIPO_ABILITAZIONE = 'LE')
    WHERE     NVL (oggetto, '%') != '%'
          AND SO4_COMPETENZE_PKG.IS_COMPETENZE_ATTIVE = 1
   UNION
   SELECT progr_unita_fisica, diac.utente
     FROM unita_fisiche, ad4_diritti_accesso diac, ad4_istanze ista
    WHERE     id_unita_fisica_padre IS NULL
          AND AD4_UTENTE.GET_TIPO_UTENTE (diac.utente) = 'U'
          AND diac.modulo = 'SI4SO'
          AND diac.istanza = ista.istanza
          AND ista.user_oracle = USER
          AND (   SO4_COMPETENZE_PKG.IS_COMPETENZE_ATTIVE = 0
               OR SO4_COMPETENZE_PKG.IS_COMPETENZE_DEFINITE ('SO4STRF') = 0
               OR SI4_COMPETENZA.VERIFICA (0,
                                           'SO4STRF',
                                           '%',
                                           'LE',
                                           diac.utente) = 1);


