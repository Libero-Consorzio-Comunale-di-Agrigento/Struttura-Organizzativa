CREATE OR REPLACE package ruolo_componente is
   /* MASTER_LINK */
   /******************************************************************************
    NOME:        ruolo_componente
    DESCRIZIONE: Gestione tabella ruoli_componente.
    ANNOTAZIONI: .
    REVISIONI:   .
    <CODE>
    Rev.  Data       Autore  Descrizione.
    00    06/11/2006  VDAVALLI  Prima emissione.
    01    04/09/2009  VDAVALLI  Modifiche per configurazione master/slave
    02    06/12/2011  MMONARI   Dati Storici
    03    31/01/2013  MMONARI   Redmine Feature #166
    04    10/04/2013  ADADAMO   Aggiunta procedure inserimento_logico_ruolo per
                                gestione della eliminazione logica dei ruoli
                                Bug #235
    05    07/07/2014  MMONARI   Ruoli di Ruoli #430
          19/09/2014  MMONARI   #499 gestione storica dei ruoli in ripristina_componente
    06    19/08/2015  MMONARI   Ruoli automatici #634
          27/10/2015  MMONARI   #281 gestione dei ruoli unici per UO
   ******************************************************************************/

   -- Revisione del Package
   s_revisione constant afc.t_revision := 'V1.06';

   s_table_name constant afc.t_object_name := 'ruoli_componente';

   s_eliminazione_logica number(1) := 0;

   s_gestione_profili number(1) := 0; --#430

   s_ruoli_automatici number(1) := 0; --#634

   subtype t_rowtype is ruoli_componente%rowtype;

   -- Tipo del record primary key
   type t_pk is record(
       id_ruolo_componente ruoli_componente.id_ruolo_componente%type);

   -- Exceptions
   dal_al_errato exception;
   pragma exception_init(dal_al_errato, -20901);
   s_dal_al_errato_num constant afc_error.t_error_number := -20901;
   s_dal_al_errato_msg constant afc_error.t_error_msg := 'Incongruenza date di inizio e fine validita''';

   dal_minore exception;
   pragma exception_init(dal_minore, -20902);
   s_dal_minore_num constant afc_error.t_error_number := -20902;
   s_dal_minore_msg constant afc_error.t_error_msg := 'La data di inizio validita'' non puo'' essere inferiore alla data di inizio attribuzione componente';

   al_maggiore exception;
   pragma exception_init(al_maggiore, -20903);
   s_al_maggiore_num constant afc_error.t_error_number := -20903;
   s_al_maggiore_msg constant afc_error.t_error_msg := 'La data di fine validita'' non puo'' essere superiore alla data di fine attribuzione componente';

   ruolo_presente exception;
   pragma exception_init(ruolo_presente, -20904);
   s_ruolo_presente_num constant afc_error.t_error_number := -20904;
   s_ruolo_presente_msg constant afc_error.t_error_msg := 'Ruolo gia'' assegnato al componente per tutto o parte del periodo indicato';

   errore_eliminazione exception;
   pragma exception_init(errore_eliminazione, -20905);
   s_errore_eliminazione_num constant afc_error.t_error_number := -20905;
   s_errore_eliminazione_msg constant afc_error.t_error_msg := 'Errore in eliminazione del preesistente profilo dello stesso progetto';

   ruolo_unico_per_uo exception;
   pragma exception_init(ruolo_unico_per_uo, -20906);
   s_ruolo_unico_per_uo_num constant afc_error.t_error_number := -20906;
   s_ruolo_unico_per_uo_msg constant afc_error.t_error_msg := 'Ruolo unico gia'' assegnato nella stessa UO';

   riattribuzione_fallita exception; --#762
   pragma exception_init(riattribuzione_fallita, -20907);
   s_riattribuzione_fallita_num constant afc_error.t_error_number := -20907;
   s_riattribuzione_fallita_msg constant afc_error.t_error_msg := 'Riattribuzione ruolo fallita';

   agg_dds_fallito exception; --#39939 DDS
   pragma exception_init(agg_dds_fallito, -20908);
   s_agg_dds_fallito_num constant afc_error.t_error_number := -20908;
   s_agg_dds_fallito_msg constant afc_error.t_error_msg := 'Aggiornamento DDS fallito (ruoli)';

   -- Versione e revisione
   function versione /* SLAVE_COPY */
    return varchar2;
   pragma restrict_references(versione, wnds);

   -- Costruttore di record chiave
   function pk /* SLAVE_COPY */
   (p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type) return t_pk;
   pragma restrict_references(pk, wnds);

   -- Controllo integrità chiave
   function can_handle /* SLAVE_COPY */
   (p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type) return number;
   pragma restrict_references(can_handle, wnds);

   -- Controllo integrità chiave
   -- wrapper boolean
   function canhandle /* SLAVE_COPY */
   (p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type) return boolean;
   pragma restrict_references(canhandle, wnds);

   -- Esistenza riga con chiave indicata
   function exists_id /* SLAVE_COPY */
   (p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type) return number;
   pragma restrict_references(exists_id, wnds);

   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   function existsid /* SLAVE_COPY */
   (p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type) return boolean;
   pragma restrict_references(existsid, wnds);

   -- Messaggio previsto per il numero di eccezione indicato
   function error_message /* SLAVE_COPY */
   (p_error_number in afc_error.t_error_number) return afc_error.t_error_msg;
   pragma restrict_references(error_message, wnds);

   -- Inserimento di una riga
   procedure ins
   (
      p_id_ruolo_componente  in ruoli_componente.id_ruolo_componente%type default null
     ,p_id_componente        in ruoli_componente.id_componente%type
     ,p_ruolo                in ruoli_componente.ruolo%type
     ,p_dal                  in ruoli_componente.dal%type
     ,p_al                   in ruoli_componente.al%type default null
     ,p_dal_pubb             in ruoli_componente.dal_pubb%type default null
     ,p_al_pubb              in ruoli_componente.al_pubb%type default null
     ,p_al_prec              in ruoli_componente.al_pubb%type default null
     ,p_utente_aggiornamento in ruoli_componente.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in ruoli_componente.data_aggiornamento%type default null
   );

   -- Aggiornamento di una riga
   procedure upd
   (
      p_new_id_ruolo_componente  in ruoli_componente.id_ruolo_componente%type
     ,p_new_id_componente        in ruoli_componente.id_componente%type
     ,p_new_ruolo                in ruoli_componente.ruolo%type
     ,p_new_dal                  in ruoli_componente.dal%type
     ,p_new_al                   in ruoli_componente.al%type
     ,p_new_dal_pubb             in ruoli_componente.dal_pubb%type
     ,p_new_al_pubb              in ruoli_componente.al_pubb%type
     ,p_new_al_prec              in ruoli_componente.al_prec%type
     ,p_new_utente_aggiornamento in ruoli_componente.utente_aggiornamento%type default null
     ,p_new_data_aggiornamento   in ruoli_componente.data_aggiornamento%type
     ,p_old_id_ruolo_componente  in ruoli_componente.id_ruolo_componente%type default null
     ,p_old_id_componente        in ruoli_componente.id_componente%type default null
     ,p_old_ruolo                in ruoli_componente.ruolo%type default null
     ,p_old_dal                  in ruoli_componente.dal%type default null
     ,p_old_al                   in ruoli_componente.al%type default null
     ,p_old_dal_pubb             in ruoli_componente.dal_pubb%type
     ,p_old_al_pubb              in ruoli_componente.al_pubb%type
     ,p_old_al_prec              in ruoli_componente.al_prec%type
     ,p_old_utente_aggiornamento in ruoli_componente.utente_aggiornamento%type default null
     ,p_old_data_aggiornamento   in ruoli_componente.data_aggiornamento%type
     ,p_check_old                in integer default 0
   );

   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
      p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type
     ,p_column              in varchar2
     ,p_value               in varchar2 default null
     ,p_literal_value       in number default 1
   );

   procedure upd_column
   (
      p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type
     ,p_column              in varchar2
     ,p_value               in date
   );

   -- Cancellazione di una riga
   procedure del
   (
      p_id_ruolo_componente  in ruoli_componente.id_ruolo_componente%type
     ,p_id_componente        in ruoli_componente.id_componente%type default null
     ,p_ruolo                in ruoli_componente.ruolo%type default null
     ,p_dal                  in ruoli_componente.dal%type default null
     ,p_al                   in ruoli_componente.al%type default null
     ,p_dal_pubb             in ruoli_componente.dal_pubb%type default null
     ,p_al_pubb              in ruoli_componente.al_pubb%type default null
     ,p_al_prec              in ruoli_componente.al_prec%type default null
     ,p_utente_aggiornamento in ruoli_componente.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in ruoli_componente.data_aggiornamento%type
     ,p_check_old            in integer default 0
   );

   -- Attributo id_componente di riga esistente identificata da chiave
   function get_id_componente /* SLAVE_COPY */
   (p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type)
      return ruoli_componente.id_componente%type;
   pragma restrict_references(get_id_componente, wnds);

   -- Attributo ruolo di riga esistente identificata da chiave
   function get_ruolo /* SLAVE_COPY */
   (p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type)
      return ruoli_componente.ruolo%type;
   pragma restrict_references(get_ruolo, wnds);

   -- Attributo dal di riga esistente identificata da chiave
   function get_dal /* SLAVE_COPY */
   (p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type)
      return ruoli_componente.dal%type;
   pragma restrict_references(get_dal, wnds);

   -- Attributo al di riga esistente identificata da chiave
   function get_al /* SLAVE_COPY */
   (p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type)
      return ruoli_componente.al%type;
   pragma restrict_references(get_al, wnds);

   -- Attributo dal_pubb di riga esistente identificata da chiave
   function get_dal_pubb /* SLAVE_COPY */
   (p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type)
      return ruoli_componente.dal_pubb%type;
   pragma restrict_references(get_dal_pubb, wnds);

   -- Attributo al_pubb di riga esistente identificata da chiave
   function get_al_pubb /* SLAVE_COPY */
   (p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type)
      return ruoli_componente.al_pubb%type;
   pragma restrict_references(get_al_pubb, wnds);

   -- Attributo al_prec di riga esistente identificata da chiave
   function get_al_prec /* SLAVE_COPY */
   (p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type)
      return ruoli_componente.al_prec%type;
   pragma restrict_references(get_al_prec, wnds);

   -- Righe corrispondenti alla selezione indicata
   function get_rows /* SLAVE_COPY */
   (
      p_id_ruolo_componente in varchar2 default null
     ,p_id_componente       in varchar2 default null
     ,p_ruolo               in varchar2 default null
     ,p_dal                 in varchar2 default null
     ,p_al                  in varchar2 default null
     ,p_dal_pubb            in varchar2 default null
     ,p_al_pubb             in varchar2 default null
     ,p_al_prec             in varchar2 default null
     ,p_other_condition     in varchar2 default null
     ,p_qbe                 in number default 0
   ) return afc.t_ref_cursor;

   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   (
      p_id_ruolo_componente in varchar2 default null
     ,p_id_componente       in varchar2 default null
     ,p_ruolo               in varchar2 default null
     ,p_dal                 in varchar2 default null
     ,p_al                  in varchar2 default null
     ,p_dal_pubb            in varchar2 default null
     ,p_al_pubb             in varchar2 default null
     ,p_al_prec             in varchar2 default null
     ,p_other_condition     in varchar2 default null
     ,p_qbe                 in number default 0
   ) return integer;

   -- Controlla l'esistenza di un ruolo per un componente
   function exists_ruolo /* SLAVE_COPY */
   (
      p_id_componente in ruoli_componente.id_componente%type
     ,p_ruolo         in ruoli_componente.ruolo%type
     ,p_data          in ruoli_componente.dal%type
   ) return afc_error.t_error_number;

   -- Controllo di congruenza date di inizio e fine validità
   function is_dal_al_ok
   (
      p_dal in ruoli_componente.dal%type
     ,p_al  in ruoli_componente.al%type
   ) return afc_error.t_error_number;

   -- function di gestione di Data Integrity
   function is_di_ok
   (
      p_dal in ruoli_componente.dal%type
     ,p_al  in ruoli_componente.al%type
   ) return afc_error.t_error_number;

   -- procedure di gestione di Data Integrity
   procedure chk_di
   (
      p_dal in ruoli_componente.dal%type
     ,p_al  in ruoli_componente.al%type
   );

   function is_dal_ok
   (
      p_id_componente in ruoli_componente.id_componente%type
     ,p_new_dal       in ruoli_componente.dal%type
   ) return afc_error.t_error_number;

   function is_al_ok
   (
      p_id_componente in ruoli_componente.id_componente%type
     ,p_new_al        in ruoli_componente.al%type
   ) return afc_error.t_error_number;

   function is_ruolo_ok
   (
      p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type
     ,p_id_componente       in ruoli_componente.id_componente%type
     ,p_new_dal             in ruoli_componente.dal%type
     ,p_new_al              in ruoli_componente.al%type
     ,p_new_ruolo           in ruoli_componente.ruolo%type
   ) return afc_error.t_error_number;

   function is_ri_ok
   (
      p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type
     ,p_id_componente       in ruoli_componente.id_componente%type
     ,p_old_dal             in ruoli_componente.dal%type
     ,p_new_dal             in ruoli_componente.dal%type
     ,p_old_al              in ruoli_componente.al%type
     ,p_new_al              in ruoli_componente.al%type
     ,p_new_ruolo           in ruoli_componente.ruolo%type
   ) return afc_error.t_error_number;

   -- Controllo integrita' referenziale
   procedure chk_ri
   (
      p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type
     ,p_id_componente       in ruoli_componente.id_componente%type
     ,p_old_dal             in ruoli_componente.dal%type
     ,p_new_dal             in ruoli_componente.dal%type
     ,p_old_al              in ruoli_componente.al%type
     ,p_new_al              in ruoli_componente.al%type
     ,p_new_ruolo           in ruoli_componente.ruolo%type
   );

   procedure set_fi
   (
      p_id_ruolo_componente  in ruoli_componente.id_ruolo_componente%type
     ,p_id_componente        in ruoli_componente.id_componente%type
     ,p_old_dal              in ruoli_componente.dal%type
     ,p_new_dal              in ruoli_componente.dal%type
     ,p_old_al               in ruoli_componente.al%type
     ,p_new_al               in ruoli_componente.al%type
     ,p_new_ruolo            in ruoli_componente.ruolo%type
     ,p_new_dal_pubb         in ruoli_componente.dal_pubb%type
     ,p_new_al_pubb          in ruoli_componente.al_pubb%type
     ,p_data_aggiornamento   in ruoli_componente.data_aggiornamento%type
     ,p_utente_aggiornamento in ruoli_componente.utente_aggiornamento%type
     ,p_inserting            in number
     ,p_updating             in number
     ,p_deleting             in number
   );

   -- Eliminazione ruoli di un componente
   procedure elimina_ruoli
   (
      p_id_componente          in ruoli_componente.id_componente%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );

   -- Annullamento ruoli di un componente (al)
   procedure annulla_ruoli
   (
      p_id_componente          in ruoli_componente.id_componente%type
     ,p_old_al                 in ruoli_componente.al%type
     ,p_new_al                 in ruoli_componente.al%type
     ,p_new_al_pubb            in ruoli_componente.al_pubb%type
     ,p_new_al_prec            in ruoli_componente.al_prec%type
     ,p_data_aggiornamento     in ruoli_componente.data_aggiornamento%type
     ,p_utente_aggiornamento   in ruoli_componente.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );

   -- Aggiornamento ruoli di un componente (dal)
   procedure aggiorna_ruoli
   (
      p_id_componente          in ruoli_componente.id_componente%type
     ,p_dal                    in ruoli_componente.dal%type
     ,p_dal_pubb               in ruoli_componente.dal_pubb%type
     ,p_data_aggiornamento     in ruoli_componente.data_aggiornamento%type
     ,p_utente_aggiornamento   in ruoli_componente.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );

   -- Duplica ruoli di un componente
   procedure duplica_ruoli
   (
      p_old_id_componente      in ruoli_componente.id_componente%type
     ,p_new_id_componente      in ruoli_componente.id_componente%type
     ,p_dal                    in ruoli_componente.dal%type
     ,p_al                     in ruoli_componente.al%type
     ,p_data_aggiornamento     in ruoli_componente.data_aggiornamento%type
     ,p_utente_aggiornamento   in ruoli_componente.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );

   procedure inserisci_ruoli
   (
      p_ottica                 in ottiche.ottica%type
     ,p_progr_unor             in componenti.progr_unita_organizzativa%type
     ,p_id_componente          in ruoli_componente.id_componente%type
     ,p_ruolo                  in ruoli_componente.ruolo%type
     ,p_dal                    in ruoli_componente.dal%type
     ,p_al                     in ruoli_componente.al%type default null
     ,p_utente_aggiornamento   in ruoli_componente.utente_aggiornamento%type default null
     ,p_data_aggiornamento     in ruoli_componente.data_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );

   -- Ripristino ruoli di un componente (al = null)
   procedure ripristina_ruoli
   (
      p_id_componente          in ruoli_componente.id_componente%type
     ,p_old_al                 in ruoli_componente.al%type
     ,p_storico_ruoli          in number
     ,p_data_aggiornamento     in ruoli_componente.data_aggiornamento%type
     ,p_utente_aggiornamento   in ruoli_componente.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );

   -- Eredita ruoli di un componente
   procedure eredita_ruoli
   (
      p_new_id_componente      in ruoli_componente.id_componente%type
     ,p_dal                    in ruoli_componente.dal%type
     ,p_al                     in ruoli_componente.al%type
     ,p_data_aggiornamento     in ruoli_componente.data_aggiornamento%type
     ,p_utente_aggiornamento   in ruoli_componente.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );

   -- Elimina logicamente un Ruolo
   procedure eliminazione_logica_ruolo
   (
      p_id_ruolo_componente    in ruoli_componente.id_ruolo_componente%type
     ,p_data_aggiornamento     in ruoli_componente.data_aggiornamento%type default null
     ,p_utente_aggiornamento   in ruoli_componente.utente_aggiornamento%type default null
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );

   procedure inserimento_logico_ruolo
   (
      p_id_ruolo_componente  in ruoli_componente.id_ruolo_componente%type default null
     ,p_id_componente        in ruoli_componente.id_componente%type
     ,p_ruolo                in ruoli_componente.ruolo%type
     ,p_dal                  in ruoli_componente.dal%type
     ,p_al                   in ruoli_componente.al%type default null
     ,p_dal_pubb             in ruoli_componente.dal_pubb%type default null
     ,p_al_pubb              in ruoli_componente.al_pubb%type default null
     ,p_al_prec              in ruoli_componente.al_pubb%type default null
     ,p_utente_aggiornamento in ruoli_componente.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in ruoli_componente.data_aggiornamento%type default null
   );

   function is_profilo --#430
   (
      p_ruolo in ruoli_componente.ruolo%type
     ,p_data  in ruoli_componente.dal%type
   ) return boolean;

   function is_ruolo_progetto --#430
   (p_ruolo in ruoli_componente.ruolo%type) return boolean;

   function get_id_profilo_origine --#430
   (p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type) return integer;

   function get_id_relazione_origine --#634
   (p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type) return integer;

   function get_ruolo_profilo_origine --#430
   (p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type) return varchar2;

   function get_ordinamento --#430
   (p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type) return varchar2;

   function get_origine --#430
   (p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type) return varchar2;

   function get_id_ruco_profilo --#430
   (
      p_ruolo         in ruoli_componente.ruolo%type
     ,p_id_componente in ruoli_componente.id_componente%type
     ,p_data          in ruoli_componente.dal%type
   ) return ruoli_componente.id_ruolo_componente%type;

   procedure attribuzione_ruoli_profilo --#430
   (
      p_id_componente        in ruoli_componente.id_componente%type
     ,p_ruolo                in ruoli_componente.ruolo%type
     ,p_data                 in ruoli_componente.dal%type
     ,p_dal                  in ruoli_componente.dal%type
     ,p_al                   in ruoli_componente.al%type default null
     ,p_dal_pubb             in ruoli_componente.dal_pubb%type default null
     ,p_al_pubb              in ruoli_componente.al_pubb%type default null
     ,p_utente_aggiornamento in ruoli_componente.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in ruoli_componente.data_aggiornamento%type default null
   );

   procedure eliminazione_ruoli_profilo --#430
   (
      p_id_ruolo_componente  in ruoli_componente.id_ruolo_componente%type
     ,p_utente_aggiornamento in ruoli_componente.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in ruoli_componente.data_aggiornamento%type default null
   );

   procedure aggiornamento_ruoli_profilo --#430
   (
      p_id_ruolo_componente  in ruoli_componente.id_ruolo_componente%type
     ,p_dal                  in ruoli_componente.dal%type
     ,p_al                   in ruoli_componente.al%type default null
     ,p_dal_pubb             in ruoli_componente.dal_pubb%type default null
     ,p_al_pubb              in ruoli_componente.al_pubb%type default null
     ,p_utente_aggiornamento in ruoli_componente.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in ruoli_componente.data_aggiornamento%type default null
   );
end ruolo_componente;
/

