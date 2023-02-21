CREATE OR REPLACE package attributi_unita_fisica_so_pkg is
   /******************************************************************************
    NOME:        attributi_unita_fisica_so_pkg
    DESCRIZIONE: Gestione tabella attributi_unita_fisica_so.
    ANNOTAZIONI: .
    REVISIONI:
    <CODE>
    Rev.  Data        Autore      Descrizione.
    00    14/08/2012  mmonari     Generazione automatica 
    01    14/05/0213  adadamo     Aggiunta funzione per get dell'attributo
   ******************************************************************************/
   -- Revisione del Package
   s_revisione  constant afc.t_revision := 'V1.01';
   s_table_name constant afc.t_object_name := 'attributi_unita_fisica_so';
   -- Exceptions
   dal_al_errato exception;
   pragma exception_init(dal_al_errato, -20901);
   s_dal_al_errato_num constant afc_error.t_error_number := -20901;
   s_dal_al_errato_msg constant afc_error.t_error_msg := 'Incongruenza date di inizio e fine validita''';
   dal_errato exception;
   pragma exception_init(dal_errato, -20902);
   s_dal_errato_num constant afc_error.t_error_number := -20902;
   s_dal_errato_msg constant afc_error.t_error_msg := 'La data di inizio validita'' non puo'' essere nulla';
   dal_sovrapposto exception;
   pragma exception_init(dal_sovrapposto, -20903);
   s_dal_sovrapposto_num constant afc_error.t_error_number := -20903;
   s_dal_sovrapposto_msg constant afc_error.t_error_msg := 'La data di inizio validita'' interseca un''altro periodo dello stesso attributo';
   al_sovrapposto exception;
   pragma exception_init(al_sovrapposto, -20904);
   s_al_sovrapposto_num constant afc_error.t_error_number := -20904;
   s_al_sovrapposto_msg constant afc_error.t_error_msg := 'La data di fine validita'' interseca un''altro periodo dello stesso attributo';
   al_maggiore exception;
   pragma exception_init(al_maggiore, -20905);
   s_al_maggiore_num constant afc_error.t_error_number := -20905;
   s_al_maggiore_msg constant afc_error.t_error_msg := 'La data di fine validita'' non puo'' essere successiva alla data di fine dell''Unita'' Fisica';
   dal_minore exception;
   pragma exception_init(dal_minore, -20906);
   s_dal_minore_num constant afc_error.t_error_number := -20906;
   s_dal_minore_msg constant afc_error.t_error_msg := 'La data di inizio validita'' non puo'' essere inferiore alla data di inizio dell''Unita'' Fisica';
   -- Versione e revisione
   function versione return varchar2;
   pragma restrict_references(versione, wnds);
   -- Messaggio previsto per il numero di eccezione indicato
   function error_message(p_error_number in afc_error.t_error_number)
      return afc_error.t_error_msg;
   pragma restrict_references(error_message, wnds);
   -- Check Data Integrity
   -- Controllo di congruenza date di inizio e fine validità
   function is_dal_al_ok
   (
      p_dal in attributi_unita_fisica_so.dal%type
     ,p_al  in attributi_unita_fisica_so.al%type
   ) return afc_error.t_error_number;
   -- function di gestione di Data Integrity
   function is_di_ok
   (
      p_dal in attributi_unita_fisica_so.dal%type
     ,p_al  in attributi_unita_fisica_so.al%type
   ) return afc_error.t_error_number;
   -- procedure di gestione di Data Integrity
   procedure chk_di
   (
      p_dal in attributi_unita_fisica_so.dal%type
     ,p_al  in attributi_unita_fisica_so.al%type
   );
   -- Check Referential Integrity
   function is_dal_ok
   (
      p_progr_uf  in attributi_unita_fisica_so.progr_unita_fisica%type
     ,p_attributo in attributi_unita_fisica_so.attributo%type
     ,p_new_dal   in attributi_unita_fisica_so.dal%type
     ,p_rowid     in rowid
     ,p_inserting in number
     ,p_updating  in number
   ) return afc_error.t_error_number;
   -- Controllo validita' al
   function is_al_ok
   (
      p_progr_uf  in attributi_unita_fisica_so.progr_unita_fisica%type
     ,p_attributo in attributi_unita_fisica_so.attributo%type
     ,p_new_al    in attributi_unita_fisica_so.al%type
     ,p_rowid     in rowid
     ,p_inserting in number
     ,p_updating  in number
   ) return afc_error.t_error_number;
   -- function di gestione di Referential Integrity
   function is_ri_ok
   (
      p_progr_uf  in attributi_unita_fisica_so.progr_unita_fisica%type
     ,p_attributo in attributi_unita_fisica_so.attributo%type
     ,p_old_dal   in attributi_unita_fisica_so.dal%type
     ,p_new_dal   in attributi_unita_fisica_so.dal%type
     ,p_old_al    in attributi_unita_fisica_so.al%type
     ,p_new_al    in attributi_unita_fisica_so.al%type
     ,p_rowid     in rowid
     ,p_inserting in number
     ,p_updating  in number
     ,p_deleting  in number
   ) return afc_error.t_error_number;
   -- Controllo integrita' referenziale
   procedure chk_ri
   (
      p_progr_uf  in attributi_unita_fisica_so.progr_unita_fisica%type
     ,p_attributo in attributi_unita_fisica_so.attributo%type
     ,p_old_dal   in attributi_unita_fisica_so.dal%type
     ,p_new_dal   in attributi_unita_fisica_so.dal%type
     ,p_old_al    in attributi_unita_fisica_so.al%type
     ,p_new_al    in attributi_unita_fisica_so.al%type
     ,p_rowid     in rowid
     ,p_inserting in number
     ,p_updating  in number
     ,p_deleting  in number
   );
   -- riporta il valore dell'attributo alla data
   function get_valore_attributo
   (
      p_progr_unita_fisica in attributi_unita_fisica_so.progr_unita_fisica%type
     ,p_attributo          in attributi_unita_fisica_so.attributo%type
     ,p_data               in date
   ) return attributi_unita_fisica_so.valore%type;

/*   >> > la sezione seguente prevede le eventuali operazioni di functional integrity
      -- Set Functional Integrity
      procedure set_fi(p_ < attributo > in attributi_unita_fisica_so. < attributo > %type
                      ,.. .);
   */
end attributi_unita_fisica_so_pkg;
/

