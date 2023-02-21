CREATE OR REPLACE FORCE VIEW VISTA_VERIFICA_STRUTTURA_FISIC
(COLONNA_1, COLONNA_2, COLONNA_3, AMMINISTRAZIONE, INTERROGAZIONE, 
 PROGR_UO)
BEQUEATH DEFINER
AS 
SELECT Codice_UO colonna_1,
          Descrizione colonna_2,
          SUDDIVISIONE_STRUTTURA.GET_DESCRIZIONE (id_suddivisione) colonna_3,
          amministrazione,
          1 interrogazione,
          TO_NUMBER (NULL) progr_uo
     FROM Anagrafe_Unita_Organizzative
    WHERE     SYSDATE BETWEEN dal AND NVL (al, TO_DATE (3333333, 'j'))
          AND NOT EXISTS
                     (SELECT 1
                        FROM Ubicazioni_Unita
                       WHERE     Ubicazioni_Unita.Progr_Unita_Organizzativa =
                                    Anagrafe_Unita_Organizzative.Progr_Unita_Organizzativa
                             AND SYSDATE BETWEEN Ubicazioni_Unita.Dal
                                             AND NVL (Ubicazioni_Unita.Al,
                                                      TO_DATE (3333333, 'j')))
   UNION
   SELECT Codice_UF colonna_1,
          Denominazione colonna_2,
          suddivisione_fisica.get_denominazione (Id_Suddivisione) colonna_3,
          amministrazione,
          2 interrogazione,
          TO_NUMBER (NULL) progr_uo
     FROM Anagrafe_Unita_Fisiche
    WHERE     SYSDATE BETWEEN dal AND NVL (al, TO_DATE (3333333, 'j'))
          AND NOT EXISTS
                     (SELECT Id_Ubicazione
                        FROM Ubicazioni_Unita
                       WHERE     Ubicazioni_Unita.Progr_Unita_Fisica =
                                    Anagrafe_Unita_Fisiche.Progr_Unita_Fisica
                             AND SYSDATE BETWEEN Ubicazioni_Unita.Dal
                                             AND NVL (Ubicazioni_Unita.Al,
                                                      TO_DATE (3333333, 'j')))
   UNION
   SELECT    ad4_soggetto.get_denominazione (ni)
          || DECODE (Ci, NULL, NULL, ' (' || TO_CHAR (Ci) || ')')
             codice,
          ANAGRAFE_UNITA_ORGANIZZATIVA.GET_CODICE_UO (
             Progr_Unita_Organizzativa,
             SYSDATE)
             descrizione,
          ANAGRAFE_UNITA_ORGANIZZATIVA.GET_descrizione (
             Progr_Unita_Organizzativa,
             SYSDATE)
             suddivisione,
          OTTICA.GET_AMMINISTRAZIONE (ottica) amministrazione,
          3 interrogazione,
          TO_NUMBER (NULL) progr_uo
     FROM Componenti
    WHERE     SYSDATE BETWEEN Dal AND NVL (al, TO_DATE (3333333, 'j'))
          AND NOT EXISTS
                     (SELECT 'x'
                        FROM Ubicazioni_Componente
                       WHERE     Ubicazioni_Componente.Id_Componente =
                                    Componenti.Id_Componente
                             AND SYSDATE BETWEEN Dal
                                             AND NVL (al,
                                                      TO_DATE (3333333, 'j')))
   UNION
   SELECT Codice_UF colonna_1,
          Denominazione colonna_2,
          suddivisione_fisica.get_denominazione (Id_Suddivisione) colonna_3,
          amministrazione,
          4 interrogazione,
          TO_NUMBER (NULL) progr_uo
     FROM Anagrafe_Unita_Fisiche
    WHERE     SYSDATE BETWEEN dal AND NVL (al, TO_DATE (3333333, 'j'))
          AND NOT EXISTS
                     (SELECT 1
                        FROM assegnazioni_fisiche
                       WHERE     ASSEGNAZIONI_FISICHE.PROGR_UNITA_FISICA =
                                    ANAGRAFE_UNITA_FISICHE.PROGR_UNITA_FISICA
                             AND SYSDATE BETWEEN Dal
                                             AND NVL (al,
                                                      TO_DATE (3333333, 'j')))
   UNION
   SELECT Codice_UF colonna_1,
          Denominazione colonna_2,
          suddivisione_fisica.get_denominazione (Id_Suddivisione) colonna_3,
          amministrazione,
          5 interrogazione,
          ANAGRAFE_UNITA_FISICA.GET_UO_COMPETENZA (progr_unita_fisica,
                                                   amministrazione,
                                                   SYSDATE)
             progr_uo
     FROM Anagrafe_Unita_Fisiche
    WHERE     SYSDATE BETWEEN dal AND NVL (al, TO_DATE (3333333, 'j'))
          AND ANAGRAFE_UNITA_FISICA.GET_UO_COMPETENZA (progr_unita_fisica,
                                                       amministrazione,
                                                       SYSDATE)
                 IS NOT NULL
   UNION
   SELECT Codice_UF colonna_1,
          Denominazione colonna_2,
          suddivisione_fisica.get_denominazione (Id_Suddivisione) colonna_3,
          amministrazione,
          5 interrogazione,
          ubun.progr_unita_organizzativa
     FROM Anagrafe_Unita_Fisiche anuf, ubicazioni_unita ubun
    WHERE     anuf.progr_unita_fisica = ubun.progr_unita_fisica
          AND SYSDATE BETWEEN anuf.dal
                          AND NVL (anuf.al, TO_DATE (3333333, 'j'))
          AND SYSDATE BETWEEN ubun.dal
                          AND NVL (ubun.al, TO_DATE (3333333, 'j'))
   ORDER BY 2;


