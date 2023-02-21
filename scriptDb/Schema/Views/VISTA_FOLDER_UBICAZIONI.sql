CREATE OR REPLACE FORCE VIEW VISTA_FOLDER_UBICAZIONI
(ID_UBICAZIONE_UNITA, ID_COMPONENTE, NI, DAL, AL, 
 UTENTE_AGGIORNAMENTO, DATA_AGGIORNAMENTO, ID_ORIGINE, ID_UBICAZIONE_COMPONENTE, NOMINATIVOAD4, 
 TIPO, ID_ASFI, PROGR_UNITA_FISICA, AMMINISTRAZIONE)
BEQUEATH DEFINER
AS 
SELECT ubco.id_ubicazione_unita,
          ubco.id_componente,
          comp.ni ni,
          ubco.dal,
          ubco.al,
          ubco.utente_aggiornamento,
          ubco.data_aggiornamento,
          ubco.id_origine,
          ubco.id_ubicazione_componente,
          '' AS nominativoad4,
          'L' tipo,
          TO_NUMBER (NULL) id_asfi,
          UBICAZIONE_UNITA.GET_PROGR_UNITA_FISICA(id_ubicazione_unita) progr_unita_fisica,
          ANAGRAFE_UNITA_FISICA.GET_AMMINISTRAZIONE(UBICAZIONE_UNITA.GET_PROGR_UNITA_FISICA(id_ubicazione_unita),ANAGRAFE_UNITA_FISICA.GET_DAL_ID(UBICAZIONE_UNITA.GET_PROGR_UNITA_FISICA(id_ubicazione_unita), UBCO.DAL)) amministrazione
     FROM ubicazioni_componente ubco, componenti comp
    WHERE ubco.id_componente = comp.id_componente
   UNION
   SELECT progr_unita_fisica id_ubicazione_unita,
          TO_NUMBER ('') id_componente,
          ni,
          dal,
          al,
          utente_aggiornamento,
          data_aggiornamento,
          TO_NUMBER ('') id_origine,
          id_ubicazione_componente,
          '' AS nominativoad4,
          'D' tipo,
          id_asfi,
          progr_unita_fisica,
          ANAGRAFE_UNITA_FISICA.GET_AMMINISTRAZIONE(PROGR_UNITA_FISICA,ANAGRAFE_UNITA_FISICA.GET_DAL_ID(PROGR_UNITA_FISICA, DAL)) amministrazione
     FROM assegnazioni_fisiche
    WHERE id_ubicazione_componente IS NULL
   ORDER BY dal DESC;


