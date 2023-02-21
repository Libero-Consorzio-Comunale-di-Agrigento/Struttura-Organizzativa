CREATE OR REPLACE FORCE VIEW VISTA_MODIFICHE_REVISIONE
(OTTICA, REVISIONE, TIPO_OGGETTO, OGGETTO, EVENTO, 
 NOTE)
BEQUEATH DEFINER
AS 
SELECT a.ottica,
          a.revisione_istituzione revisione,
          'ANAGRAFE UO' tipo_oggetto,
             a.codice_uo
          || ' : '
          || a.descrizione
          || (SELECT ' (' || descrizione || ')'
                FROM suddivisioni_struttura s
               WHERE id_suddivisione = a.id_suddivisione)
             oggetto,
          'Creazione nuova UO' evento,
          ' ' note
     FROM revisioni_modifica r, anagrafe_unita_organizzative a
    WHERE     revisione_istituzione = r.revisione_modifica
          AND r.ottica = a.ottica
          AND NOT EXISTS
                     (SELECT 'x'
                        FROM anagrafe_unita_organizzative
                       WHERE     progr_unita_organizzativa =
                                    a.progr_unita_organizzativa
                             AND revisione_cessazione = r.revisione_modifica)
   UNION
   --eliminazione uo
   SELECT a.ottica,
          a.revisione_cessazione revisione,
          'ANAGRAFE UO' tipo_oggetto,
             a.codice_uo
          || ' : '
          || a.descrizione
          || (SELECT ' (' || descrizione || ')'
                FROM suddivisioni_struttura s
               WHERE id_suddivisione = a.id_suddivisione)
             oggetto,
          'Eliminazione UO' evento,
          ' ' note
     FROM revisioni_modifica r, anagrafe_unita_organizzative a
    WHERE     revisione_cessazione = r.revisione_modifica
          AND r.ottica = a.ottica
          AND NOT EXISTS
                     (SELECT 'x'
                        FROM anagrafe_unita_organizzative
                       WHERE     progr_unita_organizzativa =
                                    a.progr_unita_organizzativa
                             AND revisione_istituzione = r.revisione_modifica)
   UNION
   --modifiche uo
   SELECT a.ottica,
          r.revisione_modifica revisione,
          'ANAGRAFE UO' tipo_oggetto,
             a.codice_uo
          || ' : '
          || a.descrizione
          || (SELECT ' (' || descrizione || ')'
                FROM suddivisioni_struttura s
               WHERE id_suddivisione = a.id_suddivisione)
             oggetto,
          'Modifiche attributi UO' evento,
          DECODE (revisione_istituzione,
                  r.revisione_modifica, 'Dopo',
                  'Prima')
             note
     FROM revisioni_modifica r, anagrafe_unita_organizzative a -- UO Modificate
    WHERE     (   revisione_istituzione = r.revisione_modifica
               OR revisione_cessazione = r.revisione_modifica)
          AND r.ottica = a.ottica
          AND progr_unita_organizzativa IN
                 (SELECT progr_unita_organizzativa
                    FROM anagrafe_unita_organizzative a1,
                         revisioni_modifica r1
                   WHERE     revisione_cessazione = r1.revisione_modifica
                         AND r1.ottica = a1.ottica
                         AND EXISTS
                                (SELECT 'x'
                                   FROM anagrafe_unita_organizzative
                                  WHERE     progr_unita_organizzativa =
                                               a1.progr_unita_organizzativa
                                        AND revisione_istituzione =
                                               r1.revisione_modifica))
   UNION
   -- UO inserite in struttura in questa revisione
   SELECT u.ottica,
          u.revisione,
          'RELAZIONE STRUTTURA' tipo_oggetto,
          (SELECT descrizione || ' (' || codice_uo || ')'
             FROM anagrafe_unita_organizzative
            WHERE     progr_unita_organizzativa = u.progr_unita_organizzativa
                  AND SYSDATE BETWEEN dal
                                  AND NVL (al, TO_DATE (3333333, 'j')))
             oggetto,
          'Unita'' inserita in struttura' evento,
             'Unita'' padre : '
          || (SELECT descrizione || ' (' || codice_uo || ')'
                FROM anagrafe_unita_organizzative
               WHERE     progr_unita_organizzativa = u.id_unita_padre
                     AND SYSDATE BETWEEN dal
                                     AND NVL (al, TO_DATE (3333333, 'j')))
             note
     FROM revisioni_modifica r, unita_organizzative u
    WHERE     revisione = r.revisione_modifica
          AND r.ottica = u.ottica
          AND NOT EXISTS
                     (SELECT 'x'
                        FROM unita_organizzative
                       WHERE     progr_unita_organizzativa =
                                    u.progr_unita_organizzativa
                             AND ottica = u.ottica
                             AND revisione_cessazione = r.revisione_modifica)
   UNION
   -- UO eliminate in struttura in questa revisione
   SELECT u.ottica,
          u.revisione,
          'RELAZIONE STRUTTURA' tipo_oggetto,
          (SELECT descrizione || ' (' || codice_uo || ')'
             FROM anagrafe_unita_organizzative
            WHERE     progr_unita_organizzativa = u.progr_unita_organizzativa
                  AND SYSDATE BETWEEN dal
                                  AND NVL (al, TO_DATE (3333333, 'j')))
             oggetto,
          'Unita'' eliminata dalla struttura' evento,
             'Unita'' padre : '
          || (SELECT descrizione || ' (' || codice_uo || ')'
                FROM anagrafe_unita_organizzative
               WHERE     progr_unita_organizzativa = u.id_unita_padre
                     AND SYSDATE BETWEEN dal
                                     AND NVL (al, TO_DATE (3333333, 'j')))
             note
     FROM revisioni_modifica r, unita_organizzative u
    WHERE     revisione_cessazione = r.revisione_modifica
          AND r.ottica = u.ottica
          AND NOT EXISTS
                     (SELECT 'x'
                        FROM unita_organizzative
                       WHERE     progr_unita_organizzativa =
                                    u.progr_unita_organizzativa
                             AND revisione = r.revisione_modifica)
   UNION
   -- UOP spostate
   SELECT u.ottica,
          u.revisione,
          'RELAZIONE STRUTTURA' tipo_oggetto,
          (SELECT descrizione || ' (' || codice_uo || ')'
             FROM anagrafe_unita_organizzative
            WHERE     progr_unita_organizzativa = u.progr_unita_organizzativa
                  AND SYSDATE BETWEEN dal
                                  AND NVL (al, TO_DATE (3333333, 'j')))
             oggetto,
          'Unita'' spostata' evento,
             DECODE (
                revisione,
                revisione_struttura.get_revisione_mod (u.ottica), 'Dopo',
                'Prima')
          || ' : Unita'' padre : '
          || (SELECT descrizione || ' (' || codice_uo || ')'
                FROM anagrafe_unita_organizzative
               WHERE     progr_unita_organizzativa = u.id_unita_padre
                     AND SYSDATE BETWEEN dal
                                     AND NVL (al, TO_DATE (3333333, 'j')))
             note
     FROM revisioni_modifica r, unita_organizzative u
    WHERE     (   revisione = r.revisione_modifica
               OR revisione_cessazione = r.revisione_modifica)
          AND r.ottica = u.ottica
          AND progr_unita_organizzativa IN
                 (SELECT progr_unita_organizzativa
                    FROM unita_organizzative
                   WHERE progr_unita_organizzativa IN
                            (SELECT progr_unita_organizzativa
                               FROM unita_organizzative u1,
                                    revisioni_modifica r1
                              WHERE     revisione = r1.revisione_modifica
                                    AND r1.ottica = u1.ottica
                                    AND EXISTS
                                           (SELECT 'x'
                                              FROM unita_organizzative
                                             WHERE     progr_unita_organizzativa =
                                                          u1.progr_unita_organizzativa
                                                   AND revisione_cessazione =
                                                          r1.revisione_modifica)))
   UNION
   --componenti spostati in revisione
   SELECT c.ottica,
          c.revisione_assegnazione revisione,
          'COMPONENTE',
          (SELECT cognome || ' ' || nome
             FROM anagrafe_soggetti
            WHERE ni = c.ni)
             oggetto,
          'Spostamento Componente' evento,
             DECODE (
                revisione_assegnazione,
                revisione_struttura.get_revisione_mod (c.ottica), 'Dopo : ',
                'Prima : ')
          || (SELECT descrizione || ' (' || codice_uo || ')'
                FROM anagrafe_unita_organizzative
               WHERE     progr_unita_organizzativa =
                            c.progr_unita_organizzativa
                     AND SYSDATE BETWEEN dal
                                     AND NVL (al, TO_DATE (3333333, 'j')))
             note
     FROM revisioni_modifica r, componenti c
    WHERE     (   revisione_assegnazione = r.revisione_modifica
               OR revisione_cessazione = r.revisione_modifica)
          AND r.ottica = c.ottica
          AND ni IN
                 (SELECT ni
                    FROM componenti
                   WHERE ni IN
                            (SELECT ni
                               FROM componenti c1
                              WHERE     revisione_assegnazione =
                                           r.revisione_modifica
                                    AND ottica = c.ottica
                                    AND EXISTS
                                           (SELECT 'x'
                                              FROM componenti
                                             WHERE     ni = c1.ni
                                                   AND ottica = c1.ottica
                                                   AND revisione_cessazione =
                                                          r.revisione_modifica)))
   ORDER BY 1,
            3,
            5,
            6 DESC;


