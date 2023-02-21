CREATE OR REPLACE package SO4_competenze_pkg is
/******************************************************************************
 NOME:        si4_competenze_pkg
 DESCRIZIONE: Gestione tabella SI4_COMPETENZE.
 ANNOTAZIONI: .
 REVISIONI:
 <CODE>
 Rev.  Data        Autore      Descrizione.
 00    07/05/2012  adadamo  Generazione automatica
******************************************************************************/
   -- Revisione del Package
   s_revisione constant AFC.t_revision := 'V1.00';
   s_table_name constant AFC.t_object_name := 'SO4_COMPETENZE';
   -- Exceptions
   impostazione_non_mod exception;
   pragma exception_init(impostazione_non_mod, -20901);
   s_impostazione_non_mod_number constant afc_error.t_error_number := -20901;
   s_impostazione_non_mod_msg    constant afc_error.t_error_msg := 'Impostazione non modificabile';
   valore_errato exception;
   pragma exception_init(valore_errato, -20902);
   s_valore_errato_number constant afc_error.t_error_number := -20902;
   s_valore_errato_msg    constant afc_error.t_error_msg := 'Valore errato';
   ogg_comp_errato exception;
   pragma exception_init(ogg_comp_errato, -20903);
   s_ogg_comp_errato_number constant afc_error.t_error_number := -20903;
   s_ogg_comp_errato_msg    constant afc_error.t_error_msg := 'Oggetto di competenza non definito';
   tipo_comp_errata exception;
   pragma exception_init(tipo_comp_errata, -20904);
   s_tipo_comp_errata_number constant afc_error.t_error_number := -20904;
   s_tipo_comp_errata_msg    constant afc_error.t_error_msg := 'Tipo competenza non definito';
   tipo_abil_errata exception;
   pragma exception_init(tipo_abil_errata, -20905);
   s_tipo_abil_errata_number constant afc_error.t_error_number := -20905;
   s_tipo_abil_errata_msg    constant afc_error.t_error_msg := 'Tipo abilitazione non definito';
   manca_comp_amm exception;
   pragma exception_init(manca_comp_amm, -20906);
   s_manca_comp_amm_number constant afc_error.t_error_number := -20906;
   s_manca_comp_amm_msg    constant afc_error.t_error_msg := 'Impossibile attribuire competenza sull''ottica, competenza su amministrazione non definita';
   manca_comp_ass_ist exception;
   pragma exception_init(manca_comp_ass_ist, -20907);
   s_manca_comp_ass_ist_number constant afc_error.t_error_number := -20907;
   s_manca_comp_ass_ist_msg    constant afc_error.t_error_msg := 'Impossibile attribuire competenza sulle assegnazioni istituzionali, competenza su ottiche istituzionali non definita';
   manca_comp_ass_gest exception;
   pragma exception_init(manca_comp_ass_gest, -20908);
   s_manca_comp_ass_gest_number constant afc_error.t_error_number := -20908;
   s_manca_comp_ass_gest_msg    constant afc_error.t_error_msg := 'Impossibile attribuire competenza in gestione su struttura logica, competenza in gestione su assegnazioni non definita';
   utente_errato exception;
   pragma exception_init(utente_errato, -20909);
   s_utente_errato_number constant afc_error.t_error_number := -20909;
   s_utente_errato_msg    constant afc_error.t_error_msg := 'Impossibile attribuire competenza su utente di tipo Gruppo o su Ruolo per Tipo Oggetto selezionato';
   date_incongruenti exception;
   pragma exception_init(date_incongruenti, -20910);
   s_date_incongruenti_number constant afc_error.t_error_number := -20910;
   s_date_incongruenti_msg    constant afc_error.t_error_msg := 'Data decorrenza successiva alla data di cessazione, impossibile salvare le informazioni';
   -- Versione e revisione
   function versione
   return varchar2;
   pragma restrict_references( versione, WNDS );
   -- Messaggio previsto per il numero di eccezione indicato
   function error_message
   ( p_error_number  in AFC_Error.t_error_number
   ) return AFC_Error.t_error_msg;
   pragma restrict_references( error_message, WNDS );
   function isCompetenzeAttive
   return boolean;
   function is_Competenze_Attive
   return number;
   function isCompetenzeDefinite
   ( p_oggetto_competenza  in varchar2
   , p_utente in ad4_utenti.utente%type default null
   )
   return boolean;
   function is_Competenze_Definite
   ( p_oggetto_competenza  in varchar2
   , p_utente in ad4_utenti.utente%type default null
   )
   return number;
   function check_comp_ins_amministrazione
   ( p_ruolo in AD4_RUOLI.RUOLO%type
   ) return number;
   function check_comp_amministrazione
   ( p_codice_amministrazione  in AMMINISTRAZIONI.CODICE_AMMINISTRAZIONE%type
   , p_tipo_abilitazione       IN varchar2
   , p_utente                  in AD4_UTENTI.UTENTE%type
   , p_ruolo                   in AD4_RUOLI.RUOLO%type
   ) return number ;
   function check_comp_ottica
   ( p_ottica                  in OTTICHE.OTTICA%type
   , p_tipo_abilitazione       IN varchar2
   , p_utente                  in AD4_UTENTI.UTENTE%type
   , p_ruolo                   in AD4_RUOLI.RUOLO%type
   ) return number;
   function check_comp_assegnazione
   ( p_id_componente           in COMPONENTI.ID_COMPONENTE%type
   , p_tipo_abilitazione       IN varchar2
   , p_utente                  in AD4_UTENTI.UTENTE%type
   , p_ruolo                   in AD4_RUOLI.RUOLO%type
   ) return number;
   function check_comp_anagrafica
   ( p_tipo_abilitazione       IN varchar2
   , p_utente                  in AD4_UTENTI.UTENTE%type
   , p_ruolo                   in AD4_RUOLI.RUOLO%type
   ) return number;
   function check_comp_COMPONENTE
   ( p_NI      in COMPONENTI.NI%type
   , p_utente                  in AD4_UTENTI.UTENTE%type
   , p_ruolo                   in AD4_RUOLI.RUOLO%type
   ) return number;
   procedure upd_impostazioni_comp
   ( p_impostazione in varchar2
   , p_valore       in varchar2
   , p_ruolo        in AD4_RUOLI.RUOLO%type
   );
   procedure ins_competenza
   ( p_ID_COMPETENZA           in SI4_COMPETENZE.ID_COMPETENZA%type
   , p_UTENTE                  in SI4_COMPETENZE.utente%type
   , p_oggetto_competenza      in varchar2
   , p_tipo_competenza         in varchar2
   , p_valore_competenza       in si4_competenze.oggetto%type
   , p_DAL                     in si4_competenze.dal%type  default sysdate
   , p_AL                      in si4_competenze.al%type   default null
   , P_UTENTE_AGGIORNAMENTO    in si4_competenze.utente_aggiornamento%type default null
   );
   procedure upd_competenza
   ( p_ID_COMPETENZA           in SI4_COMPETENZE.ID_COMPETENZA%type
   , p_UTENTE                  in SI4_COMPETENZE.utente%type
   , p_oggetto_competenza      in varchar2
   , p_tipo_competenza         in varchar2
   , p_valore_competenza       in si4_competenze.oggetto%type
   , p_DAL                     in si4_competenze.dal%type  default sysdate
   , p_AL                      in si4_competenze.al%type   default null
   , P_UTENTE_AGGIORNAMENTO    in si4_competenze.utente_aggiornamento%type default null
   );
   procedure delete_competenza
   ( p_ID_COMPETENZA           in SI4_COMPETENZE.ID_COMPETENZA%type
   );
end so4_competenze_pkg;
/

