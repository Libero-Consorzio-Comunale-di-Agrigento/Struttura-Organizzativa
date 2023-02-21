CREATE OR REPLACE package so4_cf_pkg is
   /******************************************************************************
    NOME:        so4_cf_pkg.
    DESCRIZIONE: Raggruppa le funzioni di supporto per applicativi CF
    ANNOTAZIONI: 
    REVISIONI: .
    Rev.  Data        Autore    Descrizione.
    00    18/02/2014  ADADAMO   Prima emissione.
         
   ******************************************************************************/
   s_revisione constant varchar2(30) := 'V1.0';
   function versione return varchar2;
   pragma restrict_references(versione, wnds, wnps);

   function set_separatore_default
   (
      p_separatore      varchar2
     ,p_tipo_separatore number
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

   function ad4_utente_get_unita
   (
      p_utente            ad4_utenti.utente%type
     ,p_ruolo             ruoli_componente.ruolo%type default null
     ,p_ottica            componenti.ottica%type default null
     ,p_data              componenti.dal%type default null
     ,p_se_progr_unita    varchar2 default null
     ,p_se_ordinamento    number
     ,p_se_descrizione    number
     ,p_tipo_assegnazione varchar2 default null
   ) return afc.t_ref_cursor;

   function get_ascendenti
   (
      p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_data       unita_organizzative.dal%type default null
     ,p_ottica     unita_organizzative.ottica%type default null
   ) return afc.t_ref_cursor;

   function get_ascendenti_cf
   (
      p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_data       unita_organizzative.dal%type default null
     ,p_ottica     unita_organizzative.ottica%type default null
   ) return afc.t_ref_cursor;

   function get_discendenti
   (
      p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_data       unita_organizzative.dal%type default null
     ,p_ottica     unita_organizzative.ottica%type default null
   ) return afc.t_ref_cursor;

   function utente_get_utilizzo
   (
      p_utente   ad4_utenti.utente%type
     ,p_lista_uo afc.t_ref_cursor
     ,p_ottica   ottiche.ottica%type default null
   ) return afc.t_ref_cursor;

   function utente_get_gestione
   (
      p_utente   ad4_utenti.utente%type
     ,p_lista_uo afc.t_ref_cursor
     ,p_ottica   ottiche.ottica%type default null
   ) return afc.t_ref_cursor;

   function get_area_unita
   (
      p_id_suddivisione           in suddivisioni_struttura.id_suddivisione%type
     ,p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data                      in anagrafe_unita_organizzative.dal%type
     ,p_ottica                    in ottiche.ottica%type default null
   ) return anagrafe_unita_organizzative.progr_unita_organizzativa%type;

   function unita_get_responsabile
   (
      p_progr_unita     anagrafe_unita_organizzative.progr_unita_organizzativa%type default null
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;

   function unita_get_stringa_ascendenti
   (
      p_progr_unita_organizzativa anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_id_suddivisone            suddivisioni_struttura.id_suddivisione%type
     ,p_data                      anagrafe_unita_organizzative.dal%type default null
   ) return varchar2;

   function ad4_utente_get_unita_prev
   (
      p_utente ad4_utenti.utente%type
     ,p_data   componenti.dal%type
   ) return componenti.progr_unita_organizzativa%type;

   function unita_get_radice
   (
      p_progr           unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return varchar2;

   function unita_get_radice
   (
      p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return varchar2;

   function unita_get_codice_valido
   (
      p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_data       unita_organizzative.dal%type default null
   ) return varchar2;

   function unita_get_descr_valida
   (
      p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_data       unita_organizzative.dal%type default null
   ) return varchar2;

   function comp_get_responsabile
   (
      p_ni              componenti.ni%type
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ruolo           ruoli_componente.ruolo%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;

   function ruolo_get_componenti
   (
      p_ruolo           ruoli_componente.ruolo%type
     ,p_data            ruoli_componente.dal%type default null
     ,p_ottica          ottiche.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;

   function unita_get_componenti
   (
      p_progr_uo        anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_ruolo           ad4_ruoli.ruolo%type default null
     ,p_ottica          ottiche.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;

   function unita_get_componenti
   (
      p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ruolo           ad4_ruoli.ruolo%type default null
     ,p_ottica          ottiche.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;

   function unita_get_ultima_descrizione(p_progr_unor in anagrafe_unita_organizzative.progr_unita_organizzativa%type)
      return anagrafe_unita_organizzative.descrizione%type;

   function unita_get_ultima_descrizione(p_codice_uo in anagrafe_unita_organizzative.codice_uo%type)
      return anagrafe_unita_organizzative.descrizione%type;

   function get_indirizzo_web
   (
      p_ni   in as4_anagrafe_soggetti.ni%type
     ,p_data in as4_anagrafe_soggetti.dal%type
   ) return as4_anagrafe_soggetti.indirizzo_web%type;

   function get_icona_standard(p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type)
      return suddivisioni_struttura.icona_standard%type;

   function unita_get_responsabile_cf
   (
      p_progr_uo  anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_ruolo     ad4_ruoli.ruolo%type default null
     ,p_ottica    ottiche.ottica%type
     ,p_data      componenti.dal%type
     ,p_revisione revisioni_struttura.revisione%type
   ) return varchar2;

end so4_cf_pkg;
/

