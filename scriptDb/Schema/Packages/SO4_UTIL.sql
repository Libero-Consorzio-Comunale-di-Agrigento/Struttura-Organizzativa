CREATE OR REPLACE package so4_util is
   /******************************************************************************
    NOME:        so4_util.
    DESCRIZIONE: Raggruppa le funzioni di supporto per altri applicativi.
    ANNOTAZIONI: ATTENZIONE !!!! Per gestione master/slave l'ultima function del
                 package NON deve restituire un ref_cursor
    REVISIONI: .
    <CODE>
    Rev.  Data        Autore  Descrizione.
    00    19/12/2006  VDAVALLI  Prima emissione.
    01    16/02/2009  VD        Aggiunte funzione get_all_radici e get_all_componenti
    02    27/02/2009  VD        Aggiunta funzione get_allinea_unita
    03    16/03/2009  VD        Aggiunta funzione get_area_unita (CF4)
    04    17/03/2009  VD        Aggiunto parametro p_se_storico in ad4_utente_get_storico_unita
    05    24/03/2009  VD        Aggiunta funzione comp_get_responsabile_gdm
    06    06/04/2009  VD        Aggiunto nvl su revisione componenti
    07    12/01/2010  VD        Aggiunta funzione get_utenti_aoo_ruolo_gruppo
    08    10/11/2009  VD        Aggiunta funzione unita_get_ramo
    09    10/01/2010  VD        Aggiunta funzione unita_get_radice
    10    21/01/2010  VD        Aggiunta funzione ruolo_get_componenti_id
    11    02/02/2010  VD        Modificata funzione codice_get_descrizione
    12    17/02/2010  SC        Aggiunte funzioni get_ascendenti_sudd e
                                                  unita_get_ascendenti_sudd
    13    15/04/2010  VD        Modificate funzione AD4_UTENTE_GET_STORICO_UNITA e
                                GET_ALLINEA_UNITA
    14    06/05/2010  VD        Aggiunte funzione AD4_GET_GRUPPO in overloading
                                con parametro progr. unita organizzativa (invece
                                di codice) e funzione DIPENDENTE_GET_APPROVATORE
                                (per gestione corsi CRV)
    15    01/07/2010  AP        Aggiunta funzione GET_ORDINAMENTO_2 per estrarre la stringa
                                di ordinamento per la Stampa Struttura Organizzativa
    16    08/07/2010  AP        Aggiunto funzione UNITA_GET_STRINGA_ASCENDENTI per
                                trovare le uo ascendenti fino ad una certa suddivisione
    17    15/10/2010  VD        Aggiunta funzione UNITA_GET_ULTIMA_DESCRIZIONE
    18    30/12/2010  VD        Aggiunta funzione RICERCA_DIPENDENTI (per Altran -
                                regione Calabria)
    19    17/01/2011  VD        Aggiunte funzioni UNITA_GET_CODICE_VALIDO e
                                UNITA_GET_DESCR_VALIDA
    20    17/01/2011  VD        Aggiunta funzione GET_ALL_RESPONSABILI
    21    17/02/2011  VD        Aggiunte funzioni unita_get_componenti
    22    16/03/2011  VD        Ridefinite funzioni COMP_GET_RUOLI e
                                UNITA_GET_COMPONENTI_NRUOLO per parametro
                                progr. UO al posto di codice UO
    23    12/04/2011  MM        Nuova funzione REVISIONE_GET_DAL: determina la data
                                di attivazione della revisione
    24    31/08/2011  VD        Nuova funzione UNITA_GET_DAL_VALIDO
    25    28/09/2011  VD        Nuova funzione GET_ASCENDENTI_CF
    26    25/10/2011  VD        Nuova funzione GET_ASCENDENZA_CF
    27    16/01/2012  VD        Nuove funzioni COMP_GET_ASS_PREV e COMP_GET_RESP_UNICO
   
    2.0   25/01/2012  VD        Nuova versione: utilizza le viste con date di
                                pubblicazione al posto delle date effettive
   
    2.1   29/02/2012  VD        Nuova funzione: IS_SOGGETTO_COMPONENTE
    2.2   19/03/2012  VD        Modificate funzioni UNITA_GET_RAMO
                                                    UNITA_GET_UNITA_PADRE
                                                    GET_LIVELLO
                                                    GET_ORDINAMENTO
                                                    GET_ORDINAMENTO_2
                                per gestione parametro tipo data e aggiunte
                                nuove funzioni UNITA_GET_RAMO_EFF
                                               UNITA_GET_UNITA_PADRE_EFF
                                               GET_LIVELLO_EFF
                                               GET_ORDINAMENTO_EFF
                                               GET_ORDINAMENTO2_EFF
     2.3  14/06/2012  VD        Aggiunti parametri ottica e amministrazione dove
                                mancanti
     2.4  09/04/2013  VD        Aggiunte funzioni (per personalizzazioni 
                                contabilita' regione Marche):
                                ANUO_GET_CENTRO_RESPONSABILITA
                                GET_UNITA_VALIDA
                                GET_CDR_UNITA
     2.5  09/09/2013  VD        Aggiunto parametro ottica (default null) nelle 
                                funzioni:
                                UTENTE_GET_UTILIZZ
                                UTENTE_GET_GERARCHIA_UNITA
                                UTENTE_GET_GESTIONE
     2.6  27/03/2014  ADADAMO   Corretto datatype dei parametri della ricerca_dipendenti                                  
     2.7  19/02/2016  MM        #521: nuove funzioni unita_get_numero_componenti e
                                unita_get_numero_assegnazioni  
                      MM        #711 - nuovi parametri su comp_get_unita_prev e 
                                dipendente_get_approvatore
     2.8  08/06/2016  AD        #731 - modifiche unita_get_resp_unico e unita_get_responsabile
                                per gestire query per date effettive 
     2.9  15/02/2018  MM        #801 - Import UO da altra ottica per CGS 
                      
   ******************************************************************************/
   s_revisione constant varchar2(30) := 'V2.9';
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
   function is_soggetto_componente(p_ni componenti.ni%type) return afc_error.t_error_number;
   function revisione_get_dal
   (
      p_revisione       revisioni_struttura.revisione%type
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return date;
   function ad4_utente_get_dati
   (
      p_utente     ad4_utenti.utente%type
     ,p_separatore varchar2
   ) return varchar2;
   function ad4_utente_get_unita_prev(p_utente ad4_utenti.utente%type) return varchar2;
   function ad4_utente_get_unita_prev
   (
      p_utente ad4_utenti.utente%type
     ,p_data   componenti.dal%type
   ) return componenti.progr_unita_organizzativa%type;
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
   function ad4_get_ruolo
   (
      p_ruolo      ad4_ruoli.ruolo%type
     ,p_separatore varchar2 default null
   ) return varchar2;
   function ad4_get_progr_unor
   (
      p_utente anagrafe_unita_organizzative.utente_ad4%type
     ,p_data   anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.progr_unita_organizzativa%type;
   function ad4_get_codiceuo
   (
      p_codice_gruppo   ad4_utenti.utente%type
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
   ) return anagrafe_unita_organizzative.codice_uo%type;
   function ad4_utente_get_ottica
   (
      p_utente ad4_utenti.utente%type
     ,p_data   componenti.dal%type default null
   ) return componenti.ottica%type;
   function ad4_utente_get_unita_partenza
   (
      p_utente ad4_utenti.utente%type
     ,p_data   componenti.dal%type default null
   ) return componenti.progr_unita_organizzativa%type;
   function ad4_utente_get_storico_unita
   (
      p_utente     ad4_utenti.utente%type
     ,p_ottica     componenti.ottica%type default null
     ,p_se_storico varchar2 default 'N'
   ) return afc.t_ref_cursor;
   function ad4_utente_get_gestioni
   (
      p_utente       ad4_utenti.utente%type
     ,p_ottica       ottiche.ottica%type
     ,p_suddivisione suddivisioni_struttura.suddivisione%type
     ,p_data         date
   ) return afc.t_ref_cursor;
   function comp_get_utente(p_ni componenti.ni%type) return varchar2;
   function comp_get_incarico
   (
      p_componente      componenti.ni%type
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_data            componenti.dal%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return varchar2;
   function comp_get_incarico
   (
      p_componente      componenti.ni%type
     ,p_progr_unor      anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data            componenti.dal%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
     ,p_se_codice       varchar2 default null
   ) return varchar2;
   function comp_get_se_resp
   (
      p_id_componente in componenti.id_componente%type
     ,p_dal           in componenti.dal%type
   ) return tipi_incarico.responsabile%type;
   function comp_get_unita_prev
   (
      p_ni              componenti.ni%type
     ,p_ottica          componenti.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
     ,p_modalita        varchar2 default 'N'
   ) return componenti.progr_unita_organizzativa%type;
   function comp_get_ass_prev
   (
      p_ni              componenti.ni%type
     ,p_ottica          componenti.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return componenti.progr_unita_organizzativa%type;
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
   function comp_get_unita
   (
      p_ni                componenti.ni%type
     ,p_ruolo             ruoli_componente.ruolo%type default null
     ,p_ottica            componenti.ottica%type default null
     ,p_data              componenti.dal%type default null
     ,p_amministrazione   amministrazioni.codice_amministrazione%type default null
     ,p_se_progr_unita    varchar2 default null
     ,p_se_ordinamento    number
     ,p_se_descrizione    number
     ,p_tipo_assegnazione varchar2 default null
   ) return afc.t_ref_cursor;
   function comp_get_ruoli_progr
   (
      p_ni              componenti.ni%type
     ,p_progr_unor      anagrafe_unita_organizzative.progr_unita_organizzativa%type default null
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
   function comp_get_responsabile
   (
      p_ni              componenti.ni%type
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ruolo           ruoli_componente.ruolo%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;
   function comp_get_responsabile_gdm
   (
      p_ni              componenti.ni%type
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ruolo           ruoli_componente.ruolo%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;
   function comp_get_resp_gerarchia
   (
      p_ni              componenti.ni%type
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ruolo           ruoli_componente.ruolo%type
     ,p_ottica          componenti.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;
   function comp_get_resp_unico
   (
      p_ni              componenti.ni%type
     ,p_ottica          componenti.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return componenti.ni%type;
   function comp_get_subordinati
   (
      p_ni              componenti.ni%type
     ,p_ruolo           ruoli_componente.ruolo%type default null
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type default null
     ,p_data            componenti.dal%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
   ) return afc.t_ref_cursor;
   function comp_get_subord_gerarchia
   (
      p_componente      componenti.ni%type
     ,p_ruolo           ruoli_componente.ruolo%type default null
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;
   function comp_get_subord_gerarchia_gdm
   (
      p_componente      componenti.ni%type
     ,p_ruolo           ruoli_componente.ruolo%type default null
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;
   function comp_get_approvatore
   (
      p_id_soggetto     componenti.ni%type
     ,p_progr_unor      componenti.progr_unita_organizzativa%type
     ,p_ruolo_appr      ruoli_componente.ruolo%type
     ,p_data            componenti.dal%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return componenti.ni%type;
   function dipendente_get_approvatore
   (
      p_id_soggetto     componenti.ni%type
     ,p_ruolo_appr      ruoli_componente.ruolo%type
     ,p_data            componenti.dal%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
     ,p_modalita        varchar2 default 'N'
   ) return componenti.ni%type;
   function resp_get_responsabile
   (
      p_ni              componenti.ni%type
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_ruolo           ruoli_componente.ruolo%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;
   function anuo_get_progr
   (
      p_ottica          ottiche.ottica%type default null
     ,p_amministrazione anagrafe_unita_organizzative.amministrazione%type default null
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
     ,p_data            anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.progr_unita_organizzativa%type;
   function anuo_get_dal_id
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.dal%type;
   function anuo_get_codice_uo
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.codice_uo%type;
   function anuo_get_descrizione
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.descrizione%type;
   function anuo_get_des_abb
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.des_abb%type;
   function anuo_get_id_suddivisione
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.id_suddivisione%type;
   function anuo_get_ottica
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.ottica%type;
   function anuo_get_amministrazione
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.amministrazione%type;
   function anuo_get_progr_aoo
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.progr_aoo%type;
   function anuo_get_ass_comp
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.assegnazione_componenti%type;
   function anuo_get_utente_ad4
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.utente_ad4%type;
   procedure registra_log_cgs --#801
   (
      p_utente   in varchar2
     ,p_testo    in varchar2
     ,p_tipo_msg in varchar2 default 'ERROR'
   );
   procedure anuo_import_uo_cgs --#801
   (
      p_progr_uo            in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica_destinazione in ottiche.ottica%type
     ,p_progr_padre         in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data                in anagrafe_unita_organizzative.dal%type default trunc(sysdate)
   );
   function codice_get_descrizione
   (
      p_ottica ottiche.ottica%type
     ,p_codice anagrafe_unita_organizzative.codice_uo%type
     ,p_data   anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.descrizione%type;
   function unita_get_descrizione
   (
      p_codice_gruppo in anagrafe_unita_organizzative.utente_ad4%type
     ,p_dal           in anagrafe_unita_organizzative.dal%type default null
   ) return anagrafe_unita_organizzative.descrizione%type;
   function unita_get_descrizione
   (
      p_codice_uo       in anagrafe_unita_organizzative.codice_uo%type
     ,p_dal             in anagrafe_unita_organizzative.dal%type default null
     ,p_amministrazione in anagrafe_unita_organizzative.amministrazione%type default null
   ) return anagrafe_unita_organizzative.descrizione%type;
   function unita_get_ultima_descrizione(p_progr_unor in anagrafe_unita_organizzative.progr_unita_organizzativa%type)
      return anagrafe_unita_organizzative.descrizione%type;
   function unita_get_ultima_descrizione(p_codice_uo in anagrafe_unita_organizzative.codice_uo%type)
      return anagrafe_unita_organizzative.descrizione%type;
   function unita_get_codice_valido
   (
      p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_data       unita_organizzative.dal%type default null
   ) return varchar2;
   function unita_get_dal_valido
   (
      p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_data       unita_organizzative.dal%type default null
   ) return unita_organizzative.dal%type;
   function unita_get_descr_valida
   (
      p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_data       unita_organizzative.dal%type default null
   ) return varchar2;

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
   function unita_get_componenti_nruolo
   (
      p_progr_unor      anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_ruolo           ad4_ruoli.ruolo%type
     ,p_ottica          ottiche.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;
   function unita_get_componenti_nruolo
   (
      p_codice_uo       anagrafe_unita_organizzative.codice_uo%type
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
   function unita_get_unita_padre_eff
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
   function unita_get_radice
   (
      p_progr           unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return varchar2;
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
   function unita_get_ruoli
   (
      p_utente_ad4 anagrafe_unita_organizzative.utente_ad4%type
     ,p_filtro     varchar2 default null
     ,p_data       anagrafe_unita_organizzative.dal%type default null
   ) return afc.t_ref_cursor;
   function unita_get_ruoli_asc
   (
      p_ruolo      ruoli_componente.ruolo%type
     ,p_progr_unor anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data       anagrafe_unita_organizzative.dal%type default null
   ) return afc.t_ref_cursor;
   function unita_get_responsabile
   (
      p_progr_unita     anagrafe_unita_organizzative.progr_unita_organizzativa%type default null
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
     ,p_tipo_data       varchar2 default 'P'
   ) return afc.t_ref_cursor;
   function unita_get_resp_unico
   (
      p_progr_unita     anagrafe_unita_organizzative.progr_unita_organizzativa%type default null
     ,p_codice_uo       anagrafe_unita_organizzative.codice_uo%type default null
     ,p_ottica          componenti.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
     ,p_tipo_data       varchar2 default 'P'
   ) return varchar2;
   function unita_get_resp_unico_descr
   (
      p_progr_unita        anagrafe_unita_organizzative.progr_unita_organizzativa%type default null
     ,p_data               componenti.dal%type default trunc(sysdate)
     ,p_revisione_modifica revisioni_struttura.revisione%type default null
   ) return varchar2;
   function unita_get_gerarchia_giuridico
   (
      p_progr           unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return unita_organizzative.id_elemento%type;
   function unita_get_padre_giuridico
   (
      p_progr           unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return unita_organizzative.progr_unita_organizzativa%type;
   function unita_get_ramo
   (
      p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica     unita_organizzative.ottica%type
     ,p_data       unita_organizzative.dal%type default null
     ,p_tipo_data  number default null
   ) return varchar2;
   function unita_get_ramo_eff
   (
      p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica     unita_organizzative.ottica%type
     ,p_data       unita_organizzative.dal%type default null
   ) return varchar2;
   function unita_get_numero_componenti
   (
      p_progr_uo        anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data            componenti.dal%type default null
     ,p_ottica          ottiche.ottica%type default null
     ,p_amministrazione ottiche.amministrazione%type default null
     ,p_tipo            varchar2 default 'E'
     ,p_ass_prev        varchar2 default 'E'
     ,p_resp            varchar2 default 'E'
   ) return number;
   function unita_get_assegnazioni
   (
      p_progr_uo        anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data            componenti.dal%type default null
     ,p_separatore      varchar2 default null
     ,p_ottica          ottiche.ottica%type default null
     ,p_amministrazione ottiche.amministrazione%type default null
   ) return varchar2;
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
   function ruolo_get_unita
   (
      p_ruolo           ruoli_componente.ruolo%type
     ,p_data            ruoli_componente.dal%type default null
     ,p_ottica          ottiche.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;
   function get_ordinamento
   (
      p_progr_unor      unita_organizzative.progr_unita_organizzativa%type
     ,p_data            unita_organizzative.dal%type default null
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
     ,p_tipo_data       number default null
   ) return varchar2;
   function get_ordinamento_eff
   (
      p_progr_unor      unita_organizzative.progr_unita_organizzativa%type
     ,p_data            unita_organizzative.dal%type default null
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return varchar2;
   function get_ordinamento_2
   (
      p_progr_unor      unita_organizzative.progr_unita_organizzativa%type
     ,p_data            unita_organizzative.dal%type default null
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
     ,p_tipo_data       number default null
   ) return varchar2;
   function get_ordinamento2_eff
   (
      p_progr_unor      unita_organizzative.progr_unita_organizzativa%type
     ,p_data            unita_organizzative.dal%type default null
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return varchar2;
   function get_livello
   (
      p_progr_unor      unita_organizzative.progr_unita_organizzativa%type
     ,p_data            unita_organizzative.dal%type default null
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
     ,p_tipo_data       number default null
   ) return number;
   function get_livello_eff
   (
      p_progr_unor      unita_organizzative.progr_unita_organizzativa%type
     ,p_data            unita_organizzative.dal%type default null
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return number;
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
   function get_ascendenza_cf
   (
      p_progr_unor      unita_organizzative.progr_unita_organizzativa%type
     ,p_data            unita_organizzative.dal%type default null
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_separatore_1    varchar2 default null
     ,p_separatore_2    varchar2 default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
     ,p_se_tipo         varchar2 default null
   ) return varchar2;
   function get_ascendenza_ad4
   (
      p_progr_unor      unita_organizzative.progr_unita_organizzativa%type
     ,p_data            unita_organizzative.dal%type default null
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_separatore_1    varchar2 default null
     ,p_separatore_2    varchar2 default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return varchar2;
   function unita_get_ascendenza
   (
      p_codice_uo    anagrafe_unita_organizzative.codice_uo%type
     ,p_data         unita_organizzative.dal%type default null
     ,p_ottica       unita_organizzative.ottica%type default null
     ,p_separatore_1 varchar2 default null
     ,p_separatore_2 varchar2 default null
   ) return varchar2;
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
   function unita_get_ascendenti
   (
      p_codice_uo anagrafe_unita_organizzative.codice_uo%type
     ,p_data      unita_organizzative.dal%type default null
     ,p_ottica    unita_organizzative.ottica%type default null
   ) return afc.t_ref_cursor;
   function get_ascendenti_sudd
   (
      p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_data       unita_organizzative.dal%type default null
     ,p_ottica     unita_organizzative.ottica%type default null
   ) return afc.t_ref_cursor;
   function unita_get_ascendenti_sudd
   (
      p_codice_uo anagrafe_unita_organizzative.codice_uo%type
     ,p_data      unita_organizzative.dal%type default null
     ,p_ottica    unita_organizzative.ottica%type default null
   ) return afc.t_ref_cursor;
   function get_discendenti
   (
      p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_data       unita_organizzative.dal%type default null
     ,p_ottica     unita_organizzative.ottica%type default null
   ) return afc.t_ref_cursor;
   function unita_get_discendenti
   (
      p_codice_uo anagrafe_unita_organizzative.codice_uo%type
     ,p_data      unita_organizzative.dal%type default null
     ,p_ottica    unita_organizzative.ottica%type default null
   ) return afc.t_ref_cursor;
   function get_struttura
   (
      p_utente          ad4_utenti.utente%type
     ,p_data            varchar2 default null
     ,p_ottica          anagrafe_unita_organizzative.ottica%type default null
     ,p_separatore_1    varchar2 default null
     ,p_separatore_2    varchar2 default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;
   function get_struttura_completa(p_ottica unita_organizzative.ottica%type default null)
      return afc.t_ref_cursor;
   function get_struttura_completa
   (
      p_ottica          unita_organizzative.ottica%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type
     ,p_data            unita_organizzative.dal%type
   ) return afc.t_ref_cursor;
   function controllo_unita_temp(p_progr_unor anagrafe_unita_organizzative.progr_unita_organizzativa%type)
      return afc_error.t_error_number;
   function utente_get_utilizzo
   (
      p_utente   ad4_utenti.utente%type
     ,p_lista_uo afc.t_ref_cursor
     ,p_ottica   ottiche.ottica%type default null
   ) return afc.t_ref_cursor;
   function utente_get_gerarchia_unita
   (
      p_utente ad4_utenti.utente%type
     ,p_ottica ottiche.ottica%type default null
   ) return afc.t_ref_cursor;
   function utente_get_gestione
   (
      p_utente   ad4_utenti.utente%type
     ,p_lista_uo afc.t_ref_cursor
     ,p_ottica   ottiche.ottica%type default null
   ) return afc.t_ref_cursor;
   function get_ascendenza_padre
   (
      p_progr_unor      unita_organizzative.progr_unita_organizzativa%type
     ,p_data            unita_organizzative.dal%type default null
     ,p_ottica          unita_organizzative.ottica%type default null
     ,p_separatore_1    varchar2 default null
     ,p_separatore_2    varchar2 default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return varchar2;
   function get_all_unita_radici
   (
      p_ottica          unita_organizzative.ottica%type
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;
   function get_all_componenti
   (
      p_ottica          unita_organizzative.ottica%type
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;
   function get_all_componenti_ni
   (
      p_ottica          unita_organizzative.ottica%type
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;
   function get_all_responsabili
   (
      p_ottica          unita_organizzative.ottica%type default null
     ,p_data            unita_organizzative.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;
   function get_allinea_unita
   (
      p_ottica          ottiche.ottica%type
     ,p_amministrazione ottiche.amministrazione%type
     ,p_data            unita_organizzative.dal%type
   ) return afc.t_ref_cursor;
   function get_area_unita
   (
      p_id_suddivisione           in suddivisioni_struttura.id_suddivisione%type
     ,p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data                      in anagrafe_unita_organizzative.dal%type
     ,p_ottica                    in ottiche.ottica%type default null
   ) return anagrafe_unita_organizzative.progr_unita_organizzativa%type;
   function get_des_amministrazione(p_amministrazione amministrazioni.codice_amministrazione%type)
      return as4_anagrafe_soggetti.denominazione%type;
   function get_des_suddivisione
   (
      p_ottica       suddivisioni_struttura.ottica%type
     ,p_suddivisione suddivisioni_struttura.suddivisione%type
   ) return suddivisioni_struttura.descrizione%type;
   function unita_get_stringa_ascendenti
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_id_suddivisone            in suddivisioni_struttura.id_suddivisione%type
     ,p_data                      in anagrafe_unita_organizzative.dal%type default null
   ) return varchar2;
   function get_unita_valida
   (
      p_progr_unor unita_organizzative.progr_unita_organizzativa%type
     ,p_data       unita_organizzative.dal%type default null
     ,p_ottica     unita_organizzative.ottica%type default null
   ) return afc.t_ref_cursor;
   function get_cdr_unita
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data                      in anagrafe_unita_organizzative.dal%type
     ,p_ottica                    in ottiche.ottica%type default null
   ) return anagrafe_unita_organizzative.progr_unita_organizzativa%type;
   function ricerca_dipendenti
   (
      p_codice_fiscale in componenti.codice_fiscale%type default null
     ,p_cognome        in varchar2 default null
     ,p_nome           in varchar2 default null
     ,p_data           in componenti.dal%type default null
   ) return afc.t_ref_cursor;
end so4_util;
/

