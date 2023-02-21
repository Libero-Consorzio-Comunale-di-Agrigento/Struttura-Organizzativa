CREATE OR REPLACE FORCE VIEW COMPONENTI_ATTUALI
(ID_COMPONENTE, PROGR_UNITA_ORGANIZZATIVA, DAL, AL, NI, 
 CI, STATO, OTTICA, REVISIONE_ASSEGNAZIONE, REVISIONE_CESSAZIONE, 
 UTENTE_AGGIORNAMENTO, DATA_AGGIORNAMENTO)
BEQUEATH DEFINER
AS 
SELECT   c.id_componente,
            c.progr_unita_organizzativa,
            c.dal dal,
            DECODE (NVL (c.revisione_cessazione, -2),
                    r.revisione_modifica, al_prec,
                    c.al)
               al,
            c.ni,
            c.ci,
            c.stato,
            c.ottica,
            c.revisione_assegnazione,
            c.revisione_cessazione,
            c.utente_aggiornamento,
            c.data_aggiornamento
     FROM   componenti c, revisioni_modifica r                           
    WHERE   c.dal <= NVL (c.al, TO_DATE (3333333, 'j'))
            AND TRUNC (SYSDATE) BETWEEN c.dal
                                    AND  NVL (
                                            DECODE (
                                               NVL (c.revisione_cessazione,
                                                    -2),
                                               r.revisione_modifica,
                                               al_prec,
                                               c.al
                                            ),
                                            TO_DATE (3333333, 'j')
                                         )
            AND NVL (c.revisione_assegnazione, -2) != r.revisione_modifica
            AND r.ottica = c.ottica;


