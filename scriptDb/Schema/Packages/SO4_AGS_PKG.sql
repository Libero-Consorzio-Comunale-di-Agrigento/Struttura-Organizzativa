CREATE OR REPLACE package so4_ags_pkg is
   /******************************************************************************
    NOME:        so4_ags_pkg.
    DESCRIZIONE: Raggruppa le funzioni di supporto per applicativi AGS.
    ANNOTAZIONI: 
    REVISIONI: .
    <CODE>
    Rev.  Data        Autore    Descrizione.
    00    19/08/2013  VDAVALLI  Prima emissione.
         
   ******************************************************************************/
   s_revisione constant varchar2(30) := 'V1.0';
   -- Public type declarations
   --   type s_<TypeName>_type is <Datatype>;
   -- Public constant declarations
   --   <CONSTANTNAME> constant <Datatype> := <Value>;
   -- Public variable declarations
   --   s_<VariableName> <Datatype>;
   -- Public function and procedure declarations
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
   function ad4_get_codiceuo
   (
      p_codice_gruppo   ad4_utenti.utente%type
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
   ) return anagrafe_unita_organizzative.codice_uo%type;
   function ad4_get_gruppo
   (
      p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
   ) return ad4_utenti.utente%type;
   function ad4_get_gruppo
   (
      p_progr_unor      anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
   ) return ad4_utenti.utente%type;
   function ad4_get_progr_unor
   (
      p_utente anagrafe_unita_organizzative.utente_ad4%type
     ,p_data   anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.progr_unita_organizzativa%type;
   function ad4_utente_get_dati
   (
      p_utente     ad4_utenti.utente%type
     ,p_separatore varchar2
   ) return varchar2;
   function ad4_utente_get_ruoli
   (
      p_utente          ad4_utenti.utente%type
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type default null
     ,p_data            componenti.dal%type default null
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
   ) return afc.t_ref_cursor;
   function ad4_utente_get_ruoli
   (
      p_utente          ad4_utenti.utente%type
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type default null
     ,p_data            componenti.dal%type default null
     ,p_se_ordinamento  number
     ,p_se_descrizione  number
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
   ) return afc.t_ref_cursor;
   function ad4_utente_get_storico_unita
   (
      p_utente     ad4_utenti.utente%type
     ,p_ottica     componenti.ottica%type default null
     ,p_se_storico varchar2 default 'N'
   ) return afc.t_ref_cursor;
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
   function anuo_get_progr
   (
      p_ottica          ottiche.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_data            anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.progr_unita_organizzativa%type;
   function anuo_get_descrizione
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.descrizione%type;
   function comp_get_responsabile
   (
      p_ni              componenti.ni%type
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ruolo           ruoli_componente.ruolo%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;
   function comp_get_ruoli
   (
      p_ni              componenti.ni%type
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type default null
     ,p_data            componenti.dal%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;
   function comp_get_ruoli
   (
      p_ni              componenti.ni%type
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type default null
     ,p_data            componenti.dal%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
     ,p_se_ordinamento  number
     ,p_se_descrizione  number
   ) return afc.t_ref_cursor;
   function comp_get_utente(p_ni componenti.ni%type) return varchar2;
   function get_all_unita_radici
   (
      p_ottica          unita_organizzative.ottica%type
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;

   function get_ascendenza
   (
      p_progr_unor      unita_organizzative.progr_unita_organizzativa%type
     ,p_data            unita_organizzative.dal%type default null
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_separatore_1    varchar2 default null
     ,p_separatore_2    varchar2 default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
     ,p_se_tipo         varchar2 default null
   ) return varchar2;
   function get_ascendenza_padre
   (
      p_progr_unor      unita_organizzative.progr_unita_organizzativa%type
     ,p_data            unita_organizzative.dal%type default null
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_separatore_1    varchar2 default null
     ,p_separatore_2    varchar2 default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return varchar2;
   function get_discendenti
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
   function unita_get_codice_valido
   (
      p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_data       unita_organizzative.dal%type default null
   ) return anagrafe_unita_organizzative.codice_uo%type;
   function unita_get_ascendenti
   (
      p_codice_uo anagrafe_unita_organizzative.codice_uo%type
     ,p_data      unita_organizzative.dal%type default null
     ,p_ottica    unita_organizzative.ottica%type default null
   ) return afc.t_ref_cursor;
   function unita_get_ascendenti_sudd
   (
      p_codice_uo anagrafe_unita_organizzative.codice_uo%type
     ,p_data      unita_organizzative.dal%type default null
     ,p_ottica    unita_organizzative.ottica%type default null
   ) return afc.t_ref_cursor;
   function unita_get_ascendenza
   (
      p_codice_uo    anagrafe_unita_organizzative.codice_uo%type
     ,p_data         unita_organizzative.dal%type default null
     ,p_ottica       unita_organizzative.ottica%type default null
     ,p_separatore_1 varchar2 default null
     ,p_separatore_2 varchar2 default null
   ) return varchar2;
   function unita_get_discendenti
   (
      p_codice_uo anagrafe_unita_organizzative.codice_uo%type
     ,p_data      unita_organizzative.dal%type default null
     ,p_ottica    unita_organizzative.ottica%type default null
   ) return afc.t_ref_cursor;
   function unita_get_radice
   (
      p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return varchar2;
   function unita_get_radice
   (
      p_progr           unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return varchar2;
   function unita_get_unita_padre
   (
      p_progr           unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
     ,p_tipo_data       number default null
   ) return varchar2;
   function unita_get_unita_padre
   (
      p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return varchar2;
   function unita_get_unita_padri
   (
      p_progr           unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;
   function unita_get_unita_padri
   (
      p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;
   function unita_get_unita_figlie
   (
      p_progr           unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;
   function unita_get_unita_figlie
   (
      p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;
   function unita_get_unita_figlie_ord
   (
      p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;
   function unita_get_pari_livello
   (
      p_progr_uo        anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data            anagrafe_unita_organizzative.dal%type default null
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
   ) return afc.t_ref_cursor;
   function unita_get_pari_livello
   (
      p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_data            anagrafe_unita_organizzative.dal%type default null
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
   ) return afc.t_ref_cursor;
   function unita_get_storico_figlie
   (
      p_progr_uo        anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
   ) return afc.t_ref_cursor;
   function unita_get_storico_figlie
   (
      p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
   ) return afc.t_ref_cursor;
   function unita_get_storico_discendenti
   (
      p_progr_uo        anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
   ) return afc.t_ref_cursor;
   function unita_get_storico_discendenti
   (
      p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
   ) return afc.t_ref_cursor;
   function unita_get_storico_pari_livello
   (
      p_progr_uo        anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
   ) return afc.t_ref_cursor;
   function unita_get_storico_pari_livello
   (
      p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
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
   function unita_get_componenti_ord
   (
      p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ruolo           ad4_ruoli.ruolo%type default null
     ,p_ottica          ottiche.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;
   function unita_get_responsabile
   (
      p_progr_unita     anagrafe_unita_organizzative.progr_unita_organizzativa%type default null
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;
   function get_allinea_unita
   (
      p_ottica          ottiche.ottica%type
     ,p_amministrazione ottiche.amministrazione%type
     ,p_data            unita_organizzative.dal%type
   ) return afc.t_ref_cursor;
   function anuo_get_storico_codici --#790
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data_rif                  in date
   ) return afc.t_ref_cursor;
end so4_ags_pkg;
/

