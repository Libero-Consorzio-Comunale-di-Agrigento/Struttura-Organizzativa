CREATE OR REPLACE package relazioni_ruoli_pkg is
   /******************************************************************************
    NOME:        relazioni_ruoli_pkg
    DESCRIZIONE: Gestione tabella RELAZIONI_RUOLI.
    ANNOTAZIONI: .
    REVISIONI:
    <CODE>
    Rev.  Data        Autore      Descrizione.
    00    18/08/2015  mmonari  Generazione automatica 
    </CODE>
   ******************************************************************************/
   -- Revisione del Package
   s_revisione  constant afc.t_revision := 'V1.00';
   s_table_name constant afc.t_object_name := 'RELAZIONI_RUOLI';
   -- Exceptions
   errori_attr_ruoli exception;
   pragma exception_init(errori_attr_ruoli, -20901);
   s_errori_attr_ruoli_num constant afc_error.t_error_number := -20901;
   s_errori_attr_ruoli_msg constant afc_error.t_error_msg := 'Rilevati errori nell''attribuzione dei ruoli automatici';
   ottica_non_presente exception;
   pragma exception_init(ottica_non_presente, -20902);
   s_ottica_non_presente_num constant afc_error.t_error_number := -20902;
   s_ottica_non_presente_msg constant afc_error.t_error_msg := 'Ottica non presente';
   sudd_non_presente exception;
   pragma exception_init(sudd_non_presente, -20903);
   s_sudd_non_presente_num constant afc_error.t_error_number := -20903;
   s_sudd_non_presente_msg constant afc_error.t_error_msg := 'Suddivisione struttura non presente';
   uo_non_presente exception;
   pragma exception_init(uo_non_presente, -20904);
   s_uo_non_presente_num constant afc_error.t_error_number := -20904;
   s_uo_non_presente_msg constant afc_error.t_error_msg := 'Codice Unita'' Organizzativa non presente';
   incarico_non_presente exception;
   pragma exception_init(incarico_non_presente, -20905);
   s_incarico_non_presente_num constant afc_error.t_error_number := -20905;
   s_incarico_non_presente_msg constant afc_error.t_error_msg := 'Incarico non presente';
   incarico_responsabile exception;
   pragma exception_init(incarico_responsabile, -20906);
   s_incarico_responsabile_num constant afc_error.t_error_number := -20906;
   s_incarico_responsabile_msg constant afc_error.t_error_msg := 'Incarico e Responsabile inconguenti';
   unita_suddivisione exception;
   pragma exception_init(unita_suddivisione, -20907);
   s_unita_suddivisione_num constant afc_error.t_error_number := -20907;
   s_unita_suddivisione_msg constant afc_error.t_error_msg := 'Unita'' Organizzativa e Suddivisione incongruenti';
   -- Versione e revisione
   function versione return varchar2;
   pragma restrict_references(versione, wnds);
   -- Messaggio previsto per il numero di eccezione indicato
   function error_message(p_error_number in afc_error.t_error_number)
      return afc_error.t_error_msg;
   pragma restrict_references(error_message, wnds);
   /*   >>> La sezione seguente prevede gli eventuali controlli di Data Integrity
   >>> Per ciascun controllo, creare un opportuno is_<chk name>_ok, da richiamare in is_DI_ok
   -- Check Data Integrity
   function is_<chk name>_ok
   ( p_<attributo> in RELAZIONI_RUOLI.<attributo>%type
   , ...
   ) return AFC_Error.t_error_number;
   >>> La sezione precedente può essere ripetuta per ogni controllo di Data Integrity
   function is_DI_ok
   ( p_<attributo> in RELAZIONI_RUOLI.<attributo>%type
   , ...
   ) return AFC_Error.t_error_number;
   procedure chk_DI
   ( p_<attributo> in RELAZIONI_RUOLI.<attributo>%type
   , ...
   );
   >>> La sezione seguente prevede gli eventuali controlli di Referential Integrity
   >>> Per ciascun controllo, creare un opportuno is_<chk name>_ok, da richiamare in is_RI_ok
   -- Check Referential Integrity
   function is_<chk name>_ok
   ( p_<attributo> in RELAZIONI_RUOLI.<attributo>%type
   , ...
   ) return AFC_Error.t_error_number;
   >>> La sezione precedente può essere ripetuta per ogni controllo di Referential Integrity
   function is_RI_ok
   ( p_<attributo> in RELAZIONI_RUOLI.<attributo>%type
   , ...
   ) return AFC_Error.t_error_number;
   procedure chk_RI
   ( p_<attributo> in RELAZIONI_RUOLI.<attributo>%type
   , ...
   );*/
   function get_numero_assegnazioni(p_id_relazione in relazioni_ruoli.id_relazione%type)
      return number;
   -- Set Functional Integrity
   procedure set_fi
   (
      p_id_relazione       in relazioni_ruoli.id_relazione%type
     ,p_old_ottica         in relazioni_ruoli.ottica%type
     ,p_new_ottica         in relazioni_ruoli.ottica%type
     ,p_old_codice_uo      in relazioni_ruoli.codice_uo%type
     ,p_new_codice_uo      in relazioni_ruoli.codice_uo%type
     ,p_old_uo_discendenti in relazioni_ruoli.codice_uo%type
     ,p_new_uo_discendenti in relazioni_ruoli.codice_uo%type
     ,p_old_suddivisione   in relazioni_ruoli.suddivisione%type
     ,p_new_suddivisione   in relazioni_ruoli.suddivisione%type
     ,p_old_incarico       in relazioni_ruoli.incarico%type
     ,p_new_incarico       in relazioni_ruoli.incarico%type
     ,p_old_responsabile   in relazioni_ruoli.responsabile%type
     ,p_new_responsabile   in relazioni_ruoli.responsabile%type
     ,p_old_dipendente     in relazioni_ruoli.dipendente%type
     ,p_new_dipendente     in relazioni_ruoli.dipendente%type
     ,p_old_ruolo          in relazioni_ruoli.ruolo%type
     ,p_new_ruolo          in relazioni_ruoli.ruolo%type
     ,p_inserting          in number
     ,p_updating           in number
     ,p_deleting           in number
   );
   procedure chk_ri
   (
      p_id_relazione       in relazioni_ruoli.id_relazione%type
     ,p_old_ottica         in relazioni_ruoli.ottica%type
     ,p_new_ottica         in relazioni_ruoli.ottica%type
     ,p_old_codice_uo      in relazioni_ruoli.codice_uo%type
     ,p_new_codice_uo      in relazioni_ruoli.codice_uo%type
     ,p_old_uo_discendenti in relazioni_ruoli.uo_discendenti%type
     ,p_new_uo_discendenti in relazioni_ruoli.uo_discendenti%type
     ,p_old_suddivisione   in relazioni_ruoli.suddivisione%type
     ,p_new_suddivisione   in relazioni_ruoli.suddivisione%type
     ,p_old_incarico       in relazioni_ruoli.incarico%type
     ,p_new_incarico       in relazioni_ruoli.incarico%type
     ,p_old_responsabile   in relazioni_ruoli.responsabile%type
     ,p_new_responsabile   in relazioni_ruoli.responsabile%type
     ,p_old_dipendente     in relazioni_ruoli.dipendente%type
     ,p_new_dipendente     in relazioni_ruoli.dipendente%type
     ,p_old_ruolo          in relazioni_ruoli.ruolo%type
     ,p_new_ruolo          in relazioni_ruoli.ruolo%type
     ,p_inserting          in number
     ,p_updating           in number
     ,p_deleting           in number
   );
end relazioni_ruoli_pkg;
/

