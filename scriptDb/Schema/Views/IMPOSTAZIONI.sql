CREATE OR REPLACE FORCE VIEW IMPOSTAZIONI
(ID_PARAMETRI, INTEGR_CG4, INTEGR_GP4, INTEGR_GS4, ASSEGNAZIONE_DEFINITIVA, 
 PROCEDURA_NOMINATIVO, VISUALIZZA_SUDDIVISIONE, VISUALIZZA_CODICE, AGG_ANAGRAFE_DIPENDENTI, DATA_INIZIO_INTEGRAZIONE, 
 OBBLIGO_IMBI, OBBLIGO_SEFI)
BEQUEATH DEFINER
AS 
select id_parametri
      ,integr_cg4
      ,(select decode(max(instr(installazione, 'GPs')), 0, 'NO', 'SI')
          from ad4_istanze x
         where progetto = 'SI4SO') integr_gp4
      ,integr_gs4
      ,assegnazione_definitiva
      ,procedura_nominativo
      ,visualizza_suddivisione
      ,visualizza_codice
      ,agg_anagrafe_dipendenti
      ,data_inizio_integrazione
      ,obbligo_imbi
      ,obbligo_sefi
  from impostazioni_table;


