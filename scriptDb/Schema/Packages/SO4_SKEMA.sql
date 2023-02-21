CREATE OR REPLACE package so4_skema is
   /******************************************************************************
    NOME:        SO4_SKEMA.
    DESCRIZIONE: Raggruppa le funzioni di supporto per l'applicativo SKEMA
    ANNOTAZIONI: Contiene la replica di alcuni metodi del package SO4_UTIL che
                 devono accedere ai dati mediante data effettiva di validita'
                 (e non data di pubblicazione). Versione minima SO4: 1.4.2
    REVISIONI: .
    <CODE>
    Rev.  Data        Autore    Descrizione.
    00    04/01/2013  VDAVALLI  Prima emissione.
    01    07/11/2016  MMONARI   #744 Nuovi metodi 
    </CODE>
   ******************************************************************************/
   s_revisione constant varchar2(30) := 'V1.0';
   function versione return varchar2;
   pragma restrict_references(versione, wnds, wnps);
   function set_ottica_default
   (
      p_ottica          ottiche.ottica%type default null
     ,p_amministrazione ottiche.amministrazione%type default null
   ) return ottiche.ottica%type;
   function set_data_default(p_data unita_organizzative.dal%type)
      return unita_organizzative.dal%type;
   function set_data_default(p_data varchar2) return unita_organizzative.dal%type;
   function set_separatore_default
   (
      p_separatore      varchar2
     ,p_tipo_separatore number
   ) return varchar2;
   function exists_reference
   (
      p_utente          ad4_utenti.utente%type
     ,p_codice_uo       anagrafe_unita_organizzative.utente_ad4%type
     ,p_ruolo           ruoli_componente.ruolo%type
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_data            anagrafe_unita_organizzative.dal%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
   ) return number;
   function ad4_utente_get_dati
   (
      p_utente     ad4_utenti.utente%type
     ,p_separatore varchar2
   ) return varchar2;
   function ad4_utente_get_unita
   (
      p_utente            ad4_utenti.utente%type
     ,p_ruolo             ruoli_componente.ruolo%type default null
     ,p_ottica            componenti.ottica%type default null
     ,p_data              componenti.dal%type default null
     ,p_se_progr_unita    varchar2 default null
     ,p_tipo_assegnazione varchar2 default null
   ) return afc.t_ref_cursor;
   function ad4_get_progr_unor
   (
      p_utente anagrafe_unita_organizzative.utente_ad4%type
     ,p_data   anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.progr_unita_organizzativa%type;
   function unita_get_componenti
   (
      p_progr_uo        anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_ruolo           ad4_ruoli.ruolo%type default null
     ,p_ottica          ottiche.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;
   function unita_get_componenti_nruolo
   (
      p_progr_unor      anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_ruolo           ad4_ruoli.ruolo%type
     ,p_ottica          ottiche.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;
   function unita_get_unita_figlie
   (
      p_progr           unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;
   function unita_get_codice_valido
   (
      p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_data       unita_organizzative.dal%type default null
   ) return varchar2;
   function unita_get_progressivo --#744
   (
      p_codice_uo       in anagrafe_unita_organizzative.codice_uo%type
     ,p_dal             in anagrafe_unita_organizzative.dal%type default null
     ,p_amministrazione in anagrafe_unita_organizzative.amministrazione%type default null
   ) return anagrafe_unita_organizzative.progr_unita_organizzativa%type;
   function unita_get_descrizione
   (
      p_codice_uo       in anagrafe_unita_organizzative.codice_uo%type
     ,p_dal             in anagrafe_unita_organizzative.dal%type default null
     ,p_amministrazione in anagrafe_unita_organizzative.amministrazione%type default null
   ) return anagrafe_unita_organizzative.descrizione%type;
   function unita_get_ultima_descrizione(p_codice_uo in anagrafe_unita_organizzative.codice_uo%type)
      return anagrafe_unita_organizzative.descrizione%type;
   function unita_get_ultima_descrizione(p_progr_unor in anagrafe_unita_organizzative.progr_unita_organizzativa%type)
      return anagrafe_unita_organizzative.descrizione%type;
   function unita_get_descr_valida
   (
      p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_data       unita_organizzative.dal%type default null
   ) return varchar2;
   function get_ascendenti
   (
      p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_data       unita_organizzative.dal%type default null
     ,p_ottica     unita_organizzative.ottica%type default null
   ) return afc.t_ref_cursor;
   function ruolo_get_componenti
   (
      p_ruolo           ruoli_componente.ruolo%type
     ,p_data            ruoli_componente.dal%type default null
     ,p_ottica          ottiche.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;
   function ruolo_get_componenti_id
   (
      p_ruolo           ruoli_componente.ruolo%type
     ,p_data            ruoli_componente.dal%type default null
     ,p_ottica          ottiche.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
     ,p_progr_unor      unita_organizzative.progr_unita_organizzativa%type default null
   ) return afc.t_ref_cursor;
   function comp_get_utente(p_ni componenti.ni%type) return varchar2;
   function comp_get_unita
   (
      p_ni                componenti.ni%type
     ,p_ruolo             ruoli_componente.ruolo%type default null
     ,p_ottica            componenti.ottica%type default null
     ,p_data              componenti.dal%type default null
     ,p_amministrazione   amministrazioni.codice_amministrazione%type default null
     ,p_se_progr_unita    varchar2 default null
     ,p_tipo_assegnazione varchar2 default null
   ) return afc.t_ref_cursor;
   function get_revisione_data
   (
      p_ottica ottiche.ottica%type
     ,p_data   revisioni_struttura.dal%type
   ) return revisioni_struttura.revisione%type;
   function get_all_componenti_ni
   (
      p_ottica          unita_organizzative.ottica%type
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;
   function ruolo_get_all_periodi
   (
      p_ruolo           ruoli_componente.ruolo%type
     ,p_data_dal        ruoli_componente.dal%type
     ,p_data_al         ruoli_componente.al%type
     ,p_ottica          ottiche.ottica%type
     ,p_amministrazione ottiche.amministrazione%type
     ,p_ruolo_val       ruoli_componente.ruolo%type
   ) return afc.t_ref_cursor;
   function get_codice_uo_ni --#744
   (
      p_ruolo           ruoli_componente.ruolo%type
     ,p_data_dal        ruoli_componente.dal%type
     ,p_data_al         ruoli_componente.al%type
     ,p_ottica          ottiche.ottica%type
     ,p_amministrazione ottiche.amministrazione%type
     ,p_ruolo_val       ruoli_componente.ruolo%type
     ,p_ni              anagrafe_soggetti.ni%type
   ) return varchar2;
   function get_progressivo_uo_ni --#744
   (
      p_ruolo           ruoli_componente.ruolo%type
     ,p_data_dal        ruoli_componente.dal%type
     ,p_data_al         ruoli_componente.al%type
     ,p_ottica          ottiche.ottica%type
     ,p_amministrazione ottiche.amministrazione%type
     ,p_ruolo_val       ruoli_componente.ruolo%type
     ,p_ni              anagrafe_soggetti.ni%type
   ) return afc.t_ref_cursor;
   function get_discendenti --#744
   (
      p_tipo        varchar2
     ,p_ni_padre    anagrafe_soggetti.ni%type
     ,p_ruolo_padre ruoli_componente.ruolo%type
     ,p_data        unita_organizzative.dal%type default null
     ,p_ottica      unita_organizzative.ottica%type default null
   ) return afc.t_ref_cursor;
   function comp_get_ni_ruolo_asc --#744
   (
      p_ni     in componenti.ni%type
     ,p_ruolo  ruoli_componente.ruolo%type
     ,p_ottica componenti.ottica%type
     ,p_data   in date default null
   ) return number;
   function get_ascendenti_suddivisione --#789
   (
      p_progr_unor   unita_organizzative.progr_unita_organizzativa%type
     ,p_suddivisione suddivisioni_struttura.suddivisione%type default null
     ,p_ordinamento  suddivisioni_struttura.ordinamento%type default null
     ,p_data         unita_organizzative.dal%type default null
     ,p_ottica       unita_organizzative.ottica%type default null
   ) return afc.t_ref_cursor;
   function get_uo_discendenti --#744
   (
      p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_data       unita_organizzative.dal%type default null
     ,p_ottica     unita_organizzative.ottica%type default null
   ) return afc.t_ref_cursor;
   function get_struttura --#35534
   (
      p_amministrazione amministrazioni.codice_amministrazione%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
   ) return afc.t_ref_cursor;
   function get_componenti --#35534
   (
      p_amministrazione amministrazioni.codice_amministrazione%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_progr_unor      unita_organizzative.progr_unita_organizzativa%type default null
     ,p_data            unita_organizzative.dal%type default null
   ) return afc.t_ref_cursor;
   function rigenera_ruoli_skema
   (
      p_amministrazione in ottiche.amministrazione%type
     ,p_rilevanza       in varchar default 'S'
   ) return varchar2;
   procedure rigenera_ruoli_skema
   (
      p_amministrazione        in ottiche.amministrazione%type
     ,p_rilevanza              in varchar default 'S'
     ,p_sessione               in out key_error_log.error_session%type
     ,p_segnalazione_bloccante in out varchar2
     ,p_segnalazione           in out varchar2
   );
end so4_skema;
/

