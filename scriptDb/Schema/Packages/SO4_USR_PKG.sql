CREATE OR REPLACE package so4_usr_pkg is
   /******************************************************************************
    NOME:        SO4_USR_PKG.
    DESCRIZIONE: Procedure e Funzioni per integrazione con Vitrociset al CRV
   
    ANNOTAZIONI: .
   
    REVISIONI: .
    <CODE>
    Rev.  Data        Autore  Descrizione.
    00    23/03/2010        Prima emissione.
    01    23/09/2010        Chiusura ruolo al giorno prima.
   
    </CODE>
   ******************************************************************************/

   -- Public function and procedure declarations
   function versione return varchar2;
   pragma restrict_references(versione, wnds, wnps);

   s_revisione constant varchar2(30) := 'V1.01';
   -- Exceptions
   err_progr_uo exception;
   pragma exception_init(err_progr_uo, -20901);
   s_err_progr_uo_number constant afc_error.t_error_number := -20901;
   s_err_progr_uo_msg    constant afc_error.t_error_msg := 'Errore nell''estrazione del progressivo dell''unità organizzativa';

   err_id_comp exception;
   pragma exception_init(err_id_comp, -20902);
   s_err_id_comp_number constant afc_error.t_error_number := -20902;
   s_err_id_comp_msg    constant afc_error.t_error_msg := 'Errore nell''estrazione dell''identificativo del componente';

   err_annulla_ruoli exception;
   pragma exception_init(err_annulla_ruoli, -20903);
   s_err_annulla_ruoli_number constant afc_error.t_error_number := -20903;
   s_err_annulla_ruoli_msg    constant afc_error.t_error_msg := 'Errore nell''annullamento dei ruoli';

   err_select_ruolo exception;
   pragma exception_init(err_select_ruolo, -20904);
   s_err_select_ruolo_number constant afc_error.t_error_number := -20904;
   s_err_select_ruolo_msg    constant afc_error.t_error_msg := 'Errore nell''estrazione del ruolo';

   err_insert_ruolo exception;
   pragma exception_init(err_insert_ruolo, -20905);
   s_err_insert_ruolo_number constant afc_error.t_error_number := -20905;
   s_err_insert_ruolo_msg    constant afc_error.t_error_msg := 'Errore nell''inserimento del ruolo';

   err_select_amm exception;
   pragma exception_init(err_select_amm, -20906);
   s_err_select_amm_number constant afc_error.t_error_number := -20906;
   s_err_select_amm_msg    constant afc_error.t_error_msg := 'Errore nell''estrazione dell''amministrazione';

   err_select_ott exception;
   pragma exception_init(err_select_ott, -20907);
   s_err_select_ott_number constant afc_error.t_error_number := -20907;
   s_err_select_ott_msg    constant afc_error.t_error_msg := 'Errore nell''estrazione dell''ottica';

   err_cancella_ruoli exception;
   pragma exception_init(err_cancella_ruoli, -20908);
   s_err_cancella_ruoli_number constant afc_error.t_error_number := -20908;
   s_err_cancella_ruoli_msg    constant afc_error.t_error_msg := 'Errore in cancellazione dei ruoli';

   --------------------------------------------------------------------------------
   procedure aggiorna_nominativo
   (
      p_ad4_utente     varchar2
     ,p_new_nominativo varchar2
   );

   function nulla return varchar2;
   --------------------------------------------------------------------------------

   procedure annulla_ruoli
   (
      p_ni        as4_anagrafe_soggetti.ni%type
     ,p_codice_uo anagrafe_unita_organizzative.codice_uo%type default null
     ,p_aoo       aoo.codice_aoo%type default null
   );

   --------------------------------------------------------------------------------

   procedure assegna_ruolo
   (
      p_ni        as4_anagrafe_soggetti.ni%type
     ,p_codice_uo anagrafe_unita_organizzative.codice_uo%type
     ,p_aoo       aoo.codice_aoo%type default null
     ,p_ruolo     ruoli_componente.ruolo%type
   );

   --------------------------------------------------------------------------------

   function get_telefono_fisso(p_ni in soggetti_rubrica.ni%type)
      return soggetti_rubrica.contatto%type;
   pragma restrict_references(get_telefono_fisso, wnds);

   --------------------------------------------------------------------------------

   function get_cellulare(p_ni in soggetti_rubrica.ni%type)
      return soggetti_rubrica.contatto%type;
   pragma restrict_references(get_cellulare, wnds);

   --------------------------------------------------------------------------------

   function get_email(p_ni in soggetti_rubrica.ni%type)
      return soggetti_rubrica.contatto%type;
   pragma restrict_references(get_email, wnds);

   --------------------------------------------------------------------------------

   function get_fax(p_ni in soggetti_rubrica.ni%type) return soggetti_rubrica.contatto%type;
   pragma restrict_references(get_fax, wnds);

   --------------------------------------------------------------------------------

   procedure set_telefono_fisso
   (
      p_ni    in soggetti_rubrica.ni%type
     ,p_value in soggetti_rubrica.contatto%type
   );

   --------------------------------------------------------------------------------

   procedure set_cellulare
   (
      p_ni    in soggetti_rubrica.ni%type
     ,p_value in soggetti_rubrica.contatto%type
   );

   --------------------------------------------------------------------------------

   procedure set_email
   (
      p_ni    in soggetti_rubrica.ni%type
     ,p_value in soggetti_rubrica.contatto%type
   );

   --------------------------------------------------------------------------------

   procedure set_fax
   (
      p_ni    in soggetti_rubrica.ni%type
     ,p_value in soggetti_rubrica.contatto%type
   );

--------------------------------------------------------------------------------

end so4_usr_pkg;
/

