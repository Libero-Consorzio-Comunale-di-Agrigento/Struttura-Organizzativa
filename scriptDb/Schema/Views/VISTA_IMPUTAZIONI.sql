CREATE OR REPLACE FORCE VIEW VISTA_IMPUTAZIONI
(OTTICA, NI, NOMINATIVO, CI, DAL, 
 AL, PROGR_UNITA_ORGANIZZATIVA, NUMERO, STATO, INCARICO, 
 DES_INCARICO, RESPONSABILE, ASSEGNAZIONE_PREVALENTE, TIPO_ASSEGNAZIONE, GRADAZIONE, 
 PERCENTUALE_IMPIEGO, TELEFONO, E_MAIL, FAX, REVISIONE_ASSEGNAZIONE, 
 REVISIONE_CESSAZIONE, ID_COMPONENTE, ID_ATTR_COMPONENTE, ID_IMPUTAZIONE, UTENTE_AGGIORNAMENTO, 
 DATA_AGGIORNAMENTO, UTENTE_AGG_ATTR, DATA_AGG_ATTR)
BEQUEATH DEFINER
AS 
SELECT c.ottica,
          c.ni,
          c.nominativo,
          c.ci,
          GREATEST (i.dal, c.dal) dal,
          DECODE (
             LEAST (NVL (i.al, TO_DATE (3333333, 'j')),
                    NVL (c.al, TO_DATE (3333333, 'j'))),
             TO_DATE (3333333, 'j'), TO_DATE (NULL),
             LEAST (NVL (i.al, TO_DATE (3333333, 'j')),
                    NVL (c.al, TO_DATE (3333333, 'j'))))
             al,
          c.progr_unita_organizzativa,
          i.numero,
          c.stato,
          c.incarico,
          c.des_incarico,
          c.responsabile,
          c.assegnazione_prevalente,
          NVL (c.tipo_assegnazione, 'I') tipo_assegnazione,
          c.gradazione,
          c.percentuale_impiego,
          c.telefono,
          c.e_mail,
          c.fax,
          c.revisione_assegnazione,
          c.revisione_cessazione,
          c.id_componente,
          c.id_attr_componente,
          i.id_imputazione,
          c.utente_aggiornamento utente_aggiornamento,
          c.data_aggiornamento data_aggiornamento,
          c.utente_agg_attr utente_agg_attr,
          c.data_agg_attr data_agg_attr
     FROM imputazioni_bilancio i, vista_componenti c
    WHERE     i.dal <= NVL (c.al, TO_DATE (3333333, 'j'))
          AND NVL (i.al, TO_DATE (3333333, 'j')) >= c.dal
          AND i.id_componente = c.id_componente
   UNION
   SELECT c.ottica,
          c.ni,
          c.nominativo,
          c.ci,
          c.dal,
          c.al,
          c.progr_unita_organizzativa,
          TO_NUMBER (NULL) numero,
          c.stato,
          c.incarico,
          c.des_incarico,
          c.responsabile,
          c.assegnazione_prevalente,
          NVL (c.tipo_assegnazione, 'I') tipo_assegnazione,
          c.gradazione,
          c.percentuale_impiego,
          c.telefono,
          c.e_mail,
          c.fax,
          c.revisione_assegnazione,
          c.revisione_cessazione,
          c.id_componente,
          c.id_attr_componente,
          null,
          c.utente_aggiornamento utente_aggiornamento,
          c.data_aggiornamento data_aggiornamento,
          c.utente_agg_attr utente_agg_attr,
          c.data_agg_attr data_agg_attr
     FROM vista_componenti c
    WHERE NOT EXISTS
             (SELECT 'x'
                FROM imputazioni_bilancio
               WHERE id_componente = c.id_componente);


