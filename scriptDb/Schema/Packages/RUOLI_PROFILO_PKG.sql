CREATE OR REPLACE package ruoli_profilo_pkg is
   /******************************************************************************
    NOME:        ruoli_profilo_pkg
    DESCRIZIONE: Gestione tabella RUOLI_PROFILO.
    ANNOTAZIONI: .
    REVISIONI:
    <CODE>
    Rev.  Data        Autore      Descrizione.
    00    26/08/2014  mmonari  Generazione automatica Feature #430
    </CODE>
   ******************************************************************************/
   -- Revisione del Package
   s_revisione  constant afc.t_revision := 'V1.00';
   s_table_name constant afc.t_object_name := 'RUOLI_PROFILO';
   -- Exceptions
   dal_al_errato exception;
   pragma exception_init(dal_al_errato, -20901);
   s_dal_al_errato_number constant afc_error.t_error_number := -20901;
   s_dal_al_errato_msg    constant afc_error.t_error_msg := 'Incongruenza date di inizio e fine validita''';
   dal_errato exception;
   pragma exception_init(dal_errato, -20902);
   s_dal_errato_number constant afc_error.t_error_number := -20902;
   s_dal_errato_msg    constant afc_error.t_error_msg := 'La data di inizio deve essere compresa nel periodo di validita'' precedente';
   dal_errato_ins exception;
   pragma exception_init(dal_errato_ins, -20903);
   s_dal_errato_ins_number constant afc_error.t_error_number := -20903;
   s_dal_errato_ins_msg    constant afc_error.t_error_msg := 'La data di inizio deve essere superiore all''ultima inserita';
   al_errato exception;
   pragma exception_init(al_errato, -20904);
   s_al_errato_number constant afc_error.t_error_number := -20904;
   s_al_errato_msg    constant afc_error.t_error_msg := 'La data di fine puo'' essere modificata solo sull''ultimo periodo';
   dal_minore exception;
   pragma exception_init(dal_minore, -20905);
   s_dal_minore_num constant afc_error.t_error_number := -20905;
   s_dal_minore_msg constant afc_error.t_error_msg := 'La data di inizio validita'' non puo'' essere inferiore alla data di inizio attribuzione componente';
   al_maggiore exception;
   pragma exception_init(al_maggiore, -20906);
   s_al_maggiore_num constant afc_error.t_error_number := -20906;
   s_al_maggiore_msg constant afc_error.t_error_msg := 'La data di fine validita'' non puo'' essere superiore alla data di fine attribuzione componente';
   ruolo_presente exception;
   pragma exception_init(ruolo_presente, -20907);
   s_ruolo_presente_num constant afc_error.t_error_number := -20907;
   s_ruolo_presente_msg constant afc_error.t_error_msg := 'Ruolo gia'' previsto nel profilo per tutto o parte del periodo indicato';
   loop_relazioni exception;
   pragma exception_init(loop_relazioni, -20908);
   s_loop_relazioni_num constant afc_error.t_error_number := -20908;
   s_loop_relazioni_msg constant afc_error.t_error_msg := 'Esistono relazioni circolari nella gerarchia dei Ruoli/Profili';

   -- Versione e revisione
   function versione return varchar2;
   pragma restrict_references(versione, wnds);
   -- Messaggio previsto per il numero di eccezione indicato
   function error_message(p_error_number in afc_error.t_error_number)
      return afc_error.t_error_msg;
   pragma restrict_references(error_message, wnds);
   --determina la nuova pk
   function get_id_ruolo_profilo return number;
   --verifica se un ruolo identifica un profilo ad una certa data

   function is_profilo --#430
   (
      p_ruolo in ruoli_componente.ruolo%type
     ,p_data  in ruoli_componente.dal%type
   ) return number;

   --verifica se il profilo e' stato assegnato a componenti
   function is_profilo_in_uso
   (
      p_profilo in ruoli_profilo.ruolo_profilo%type
     ,p_data    in date default to_date(null)
   ) return boolean;
   -- Check Data Integrity
   -- Controllo di congruenza date di inizio e fine validità
   function is_dal_al_ok
   (
      p_dal in unita_organizzative.dal%type
     ,p_al  in unita_organizzative.al%type
   ) return afc_error.t_error_number;

   procedure chk_di
   (
      p_dal in ruoli_profilo.dal%type
     ,p_al  in ruoli_profilo.al%type
   );

   function is_di_ok
   (
      p_dal in ruoli_profilo.dal%type
     ,p_al  in ruoli_profilo.al%type
   ) return afc_error.t_error_number;

   procedure chk_ri
   (
      p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type
     ,p_ruolo_profilo    in ruoli_profilo.ruolo_profilo%type
     ,p_old_dal          in ruoli_profilo.dal%type
     ,p_new_dal          in ruoli_profilo.dal%type
     ,p_old_al           in ruoli_profilo.al%type
     ,p_new_al           in ruoli_profilo.al%type
     ,p_new_ruolo        in ruoli_profilo.ruolo%type
   );

   function is_ri_ok
   (
      p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type
     ,p_ruolo_profilo    in ruoli_profilo.ruolo_profilo%type
     ,p_old_dal          in ruoli_profilo.dal%type
     ,p_new_dal          in ruoli_profilo.dal%type
     ,p_old_al           in ruoli_profilo.al%type
     ,p_new_al           in ruoli_profilo.al%type
     ,p_new_ruolo        in ruoli_profilo.ruolo%type
   ) return afc_error.t_error_number;

   function is_ruolo_ok
   (
      p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type
     ,p_ruolo_profilo    in ruoli_profilo.ruolo_profilo%type
     ,p_new_dal          in ruoli_profilo.dal%type
     ,p_new_al           in ruoli_profilo.al%type
     ,p_new_ruolo        in ruoli_profilo.ruolo%type
   ) return afc_error.t_error_number;

   function is_relazione_ok
   (
      p_dal in ruoli_profilo.dal%type
     ,p_al  in ruoli_profilo.al%type
   ) return afc_error.t_error_number;

   procedure set_fi
   (
      p_id_ruolo_profilo     in ruoli_profilo.id_ruolo_profilo%type
     ,p_ruolo_profilo        in ruoli_profilo.ruolo_profilo%type
     ,p_old_dal              in ruoli_profilo.dal%type
     ,p_new_dal              in ruoli_profilo.dal%type
     ,p_old_al               in ruoli_profilo.al%type
     ,p_new_al               in ruoli_profilo.al%type
     ,p_ruolo                in ruoli_profilo.ruolo%type
     ,p_data_aggiornamento   in ruoli_profilo.data_aggiornamento%type
     ,p_utente_aggiornamento in ruoli_profilo.utente_aggiornamento%type
     ,p_inserting            in number
     ,p_updating             in number
     ,p_deleting             in number
   );

   function is_ruolo_assegnato
   (
      p_ruolo_profilo in ruoli_profilo.ruolo_profilo%type
     ,p_ruolo         in ruoli_profilo.ruolo%type
   ) return boolean;

   -- aggiunge un ruolo ad un profilo o crea nuovo profilo
   procedure inserisci_ruolo
   (
      p_ruolo_profilo          in ruoli_profilo.ruolo_profilo%type
     ,p_ruolo                  in ruoli_profilo.ruolo%type
     ,p_dal                    in ruoli_profilo.dal%type
     ,p_utente_aggiornamento   in unita_fisiche.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );

   -- elimina un ruolo da un profilo
   procedure elimina_ruolo
   (
      p_ruolo_profilo          in ruoli_profilo.ruolo_profilo%type
     ,p_ruolo                  in ruoli_profilo.ruolo%type
     ,p_utente_aggiornamento   in unita_fisiche.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );

   --conta gli utenti assegnatari del ruolo alla data
   function get_numero_utenti
   (
      p_ruolo_profilo in ruoli_profilo.ruolo_profilo%type
     ,p_data          in date default to_date(null)
   ) return number;

end ruoli_profilo_pkg;
/

