CREATE OR REPLACE package so4ad4_pkg is
   /******************************************************************************
    NOME:        SO4AD4_PKG.
    DESCRIZIONE: Procedure e Funzioni di utilita' utilizzate dallo user oracle
                 AD4 ma che lavorano sui dati di SO4
    ANNOTAZIONI: .
    REVISIONI: .
    Rev.  Data        Autore  Descrizione.
    00    23/08/2012  AD      Prima emissione.
    01    31/01/2012  AD      Aggiunta is_soggetto_componente per compatibilita
                              con nuove versioni di AD4
    02    18/06/2015  AD      Aggiunta funzione ad4_utente_get_ruoli (Feature#609)                               
   ******************************************************************************/
   s_revisione constant varchar2(30) := 'V1.02';
   -- Public function and procedure declarations
   function versione return varchar2;
   pragma restrict_references(versione, wnds, wnps);
   function get_ascendenza_ad4
   (
      p_progr_unor      unita_organizzative.progr_unita_organizzativa%type
     ,p_data            unita_organizzative.dal%type default null
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_separatore_1    varchar2 default null
     ,p_separatore_2    varchar2 default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return varchar2;
   function ad4_get_ruolo
   (
      p_ruolo      ad4_ruoli.ruolo%type
     ,p_separatore varchar2 default null
   ) return varchar2;
   function is_soggetto_componente(p_ni componenti.ni%type) return afc_error.t_error_number;
   function ad4_utente_get_unita_prev(p_utente ad4_utenti.utente%type) return varchar2;
   function get_struttura
   (
      p_utente          ad4_utenti.utente%type
     ,p_data            varchar2 default null
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_separatore_1    varchar2 default null
     ,p_separatore_2    varchar2 default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;
   
   function ad4_utente_get_ruoli
   (  p_utente          ad4_utenti.utente%type
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type default null
     ,p_data            varchar2 default null
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
     ,p_progetto        ad4_ruoli.progetto%type default null
   ) return afc.t_ref_cursor ;
   
   function ad4_utente_get_ruoli
   (  p_utente          ad4_utenti.utente%type
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type default null
     ,p_data            anagrafe_unita_organizzative.al%type default null
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
     ,p_progetto        ad4_ruoli.progetto%type default null
   ) return afc.t_ref_cursor   ;
end so4ad4_pkg;
/

