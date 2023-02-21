CREATE OR REPLACE package so4_ciweb is
   /******************************************************************************
    NOME:        SO4_CIWEB
    DESCRIZIONE: Contiene procedure e function fatti per ciweb
    REVISIONI:
    Rev. Data        Autore  Descrizione
    ---- ----------  ------  ----------------------------------------------------
    0                        Prima emissione
    1    05/08/2008  SM      Inserimento commento
    2    04/03/2010  VD      Nuove funzioni per gestione consegnatario
    3    01/09/2010  VD      Nuove funzioni per gestione sub-consegnatario
    4    10/12/2010  VD      Correzione per gestione cursori aperti
    5    14/03/2011  VD      Aggiunte funzioni INS_ANA_UNOR e INS_ANA_UNFI per
                             trascodifiche da CI4 con SO4 non popolato
    6    23/03/2011  VD      Aggiunta procedura INS_CENTRI per trascodifiche
                             da CI4 con SO4 non popolato
    7    24/05/2011  MM      Aggiunta parametro p_id_suddivisione a INS_ANA_UNOR
    8    10/10/2011  VD      Modifica funzione GET_ANA_UNITA_FISICA_CAMPI:
                             default null per il parametro data
    9    08/03/2013  VD      Nuova funzione: reperimento id_soggetto abbinato a
                             matricola (ci)
   10    28/05/2013  VD      Nuova funzione: reperimento ci abbinato a id_soggetto
   11    02/04/2013  VD      Modifica funzione SE_ESISTE_RELAZIONE e nuove funzioni
                             GET_UNITA_SOGGETTO e SE_COMBINAZIONE_VALIDA
   11    09/02/2016  MM      #683 Nuova function get_storico_consegnatari
         13/06/2019  MM      #35474 Nuova function get_ascendenti
   ******************************************************************************/
   s_revisione   constant varchar2(30) := 'V1.12';
   s_data_limite constant date := to_date(3333333, 'j');
   --
   function versione return varchar2;
   --
   function get_amministrazioni_denom(p_codice_amm so_amministrazioni.codice_amministrazione%type)
      return so_amministrazioni.denominazione%type;
   --
   function get_ana_unita_org_campi
   (
      p_progr_unita_organizzativa anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data                      date
     ,p_campo                     varchar2
   ) return varchar2;
   --
   function get_ana_unita_fisica_campi
   (
      p_progr_unita_fisica anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_data               date default null
     ,p_campo              varchar2
   ) return varchar2;
   --
   function get_area_unita
   (
      p_id_suddivisione           suddivisioni_struttura.id_suddivisione%type
     ,p_progr_unita_organizzativa anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data                      anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.progr_unita_organizzativa%type;
   --
   function se_componente_unita
   (
      p_ottica     ottiche.ottica%type
     ,p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_ni         componenti.ni%type
     ,p_revisione  revisioni_struttura.revisione%type
     ,p_data       date
   ) return varchar2;
   --
   function se_competenza_unita_org
   (
      p_progr_unor anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_utente     ad4_utenti.utente%type
     ,p_data       date
   ) return varchar2;
   --
   function get_id_consegnatario
   (
      p_ruolo      ruoli_componente.ruolo%type
     ,p_progr_unor componenti.progr_unita_organizzativa%type
     ,p_data       componenti.dal%type
   ) return componenti.ni%type;
   --
   function get_consegnatari
   (
      p_ruolo      ruoli_componente.ruolo%type
     ,p_progr_unor componenti.progr_unita_organizzativa%type
     ,p_dal        componenti.dal%type
     ,p_al         componenti.al%type
   ) return afc.t_ref_cursor;
   --
   function get_storico_consegnatari
   (
      p_ruolo      ruoli_componente.ruolo%type
     ,p_progr_unor componenti.progr_unita_organizzativa%type
     ,p_dal        componenti.dal%type
     ,p_al         componenti.al%type
   ) return afc.t_ref_cursor;
   --
   function get_dati_consegnatario
   (
      p_ni    componenti.ni%type
     ,p_campo varchar2
   ) return varchar2;
   --
   function get_id_sub_consegnatario
   (
      p_ruolo      ruoli_componente.ruolo%type
     ,p_progr_unor componenti.progr_unita_organizzativa%type
     ,p_progr_unfi unita_fisiche.progr_unita_fisica%type
     ,p_data       componenti.dal%type
   ) return componenti.ni%type;
   --
   function se_esiste_relazione
   (
      p_progr_unor componenti.progr_unita_organizzativa%type
     ,p_progr_unfi unita_fisiche.progr_unita_fisica%type
     ,p_data       componenti.dal%type
     ,p_ottica     ottiche.ottica%type default null
     ,p_ni         componenti.ni%type default null
   ) return varchar2;
   --
   function se_combinazione_valida
   (
      p_ottica     ottiche.ottica%type
     ,p_data       componenti.dal%type
     ,p_progr_unor componenti.progr_unita_organizzativa%type
     ,p_progr_unfi unita_fisiche.progr_unita_fisica%type default null
     ,p_ni         componenti.ni%type default null
   ) return varchar2;
   --
   function get_unita_soggetto
   (
      p_ottica ottiche.ottica%type
     ,p_data   componenti.dal%type
     ,p_ni     componenti.ni%type
   ) return varchar2;
   --
   function get_soggetto_matricola
   (
      p_ci              componenti.ci%type
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return componenti.ni%type;
   --
   function get_matricola_soggetto
   (
      p_amministrazione amministrazioni.codice_amministrazione%type
     ,p_data            componenti.dal%type
     ,p_ni              componenti.ni%type
   ) return componenti.ci%type;
   --
   function ins_ana_unor
   (
      p_amministrazione amministrazioni.codice_amministrazione%type
     ,p_ottica          ottiche.ottica%type
     ,p_codice          anagrafe_unita_organizzative.codice_uo%type
     ,p_descrizione     anagrafe_unita_organizzative.descrizione%type
     ,p_centro_costo    anagrafe_unita_organizzative.centro%type
     ,p_dal             anagrafe_unita_organizzative.dal%type
     ,p_al              anagrafe_unita_organizzative.al%type
     ,p_id_suddivisione anagrafe_unita_organizzative.id_suddivisione%type
   ) return anagrafe_unita_organizzative.progr_unita_organizzativa%type;
   --
   function ins_ana_unfi
   (
      p_amministrazione amministrazioni.codice_amministrazione%type
     ,p_codice          anagrafe_unita_fisiche.codice_uf%type
     ,p_descrizione     anagrafe_unita_fisiche.denominazione%type
     ,p_dal             anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.progr_unita_fisica%type;
   --
   procedure ins_centri
   (
      p_centro        centri.centro%type
     ,p_descrizione   centri.descrizione%type
     ,p_fine_validita centri.data_validita%type
   );
   function get_ascendenti
   (
      p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_data       unita_organizzative.dal%type default null
     ,p_ottica     unita_organizzative.ottica%type default null
   ) return afc.t_ref_cursor;
end so4_ciweb;
/

