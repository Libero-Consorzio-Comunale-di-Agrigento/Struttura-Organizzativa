CREATE OR REPLACE package imputazione_bilancio is
   /******************************************************************************
    NOME:        IMPUTAZIONE_BILANCIO
    DESCRIZIONE: Gestione tabella imputazioni_bilancio.
    ANNOTAZIONI: .
    REVISIONI:   Template Revision: 1.12.
    <CODE>
    Rev.  Data        Autore    Descrizione.
    00    16/10/2008  VDAVALLI  Prima emissione.
    01    03/09/2009  VDAVALLI  Modifiche per configurazione master/slave
    02    07/09/2009  VDAVALLI  Corretto controlli per eliminazione
    03    28/04/2015  MMONARI   #596 : Nuova proc. set_periodo_successivo
    04    20/05/2015  MMONARI   #594 : Nuova variabile s_origine_gps
    </CODE>
   ******************************************************************************/
   -- Revisione del Package
   s_revisione  constant afc.t_revision := 'V1.04';
   s_table_name constant afc.t_object_name := 'imputazioni_bilancio';
   s_origine_gps number(1) := 0;
   subtype t_rowtype is imputazioni_bilancio%rowtype;
   -- Tipo del record primary key
   type t_pk is record(
       id_imputazione imputazioni_bilancio.id_imputazione%type);
   -- Exceptions
   dal_al_errato exception;
   pragma exception_init(dal_al_errato, -20901);
   s_dal_al_errato_number constant afc_error.t_error_number := -20901;
   s_dal_al_errato_msg    constant afc_error.t_error_msg := 'Incongruenza date di inizio e fine validita''';
   dal_errato exception;
   pragma exception_init(dal_errato, -20902);
   s_dal_errato_num constant afc_error.t_error_number := -20902;
   s_dal_errato_msg constant afc_error.t_error_msg := 'La data di inizio deve essere compresa nel periodo di validita'' precedente';
   dal_errato_ins exception;
   pragma exception_init(dal_errato_ins, -20903);
   s_dal_errato_ins_num constant afc_error.t_error_number := -20903;
   s_dal_errato_ins_msg constant afc_error.t_error_msg := 'La data di inizio deve essere superiore all''ultima inserita';
   dal_fuori_periodo exception;
   pragma exception_init(dal_fuori_periodo, -20904);
   s_dal_fuori_periodo_num constant afc_error.t_error_number := -20904;
   s_dal_fuori_periodo_msg constant afc_error.t_error_msg := 'La data di inizio non puo'' essere antecedente alla data di assegnazione del componente all''unita''';
   al_errato exception;
   pragma exception_init(al_errato, -20905);
   s_al_errato_num constant afc_error.t_error_number := -20905;
   s_al_errato_msg constant afc_error.t_error_msg := 'La data di fine puo'' essere modificata solo sull''ultimo periodo';
   al_errato_ins exception;
   pragma exception_init(al_errato_ins, -20906);
   s_al_errato_ins_num constant afc_error.t_error_number := -20906;
   s_al_errato_ins_msg constant afc_error.t_error_msg := 'La data di fine deve essere superiore all''ultima inserita';
   al_fuori_periodo exception;
   pragma exception_init(al_fuori_periodo, -20907);
   s_al_fuori_periodo_num constant afc_error.t_error_number := -20907;
   s_al_fuori_periodo_msg constant afc_error.t_error_msg := 'La data di fine non puo'' essere successiva alla data di fine assegnazione del componente all''unita''';
   record_storico exception;
   pragma exception_init(record_storico, -20908);
   s_record_storico_num constant afc_error.t_error_number := -20908;
   s_record_storico_msg constant afc_error.t_error_msg := 'Riga non eliminabile';
   -- Versione e revisione
   function versione /* SLAVE_COPY */
    return varchar2;
   pragma restrict_references(versione, wnds);
   -- Costruttore di record chiave
   function pk /* SLAVE_COPY */
   (p_id_imputazione in imputazioni_bilancio.id_imputazione%type) return t_pk;
   pragma restrict_references(pk, wnds);
   -- Controllo integrità chiave
   function can_handle /* SLAVE_COPY */
   (p_id_imputazione in imputazioni_bilancio.id_imputazione%type) return number;
   pragma restrict_references(can_handle, wnds);
   -- Controllo integrità chiave
   -- wrapper boolean
   function canhandle /* SLAVE_COPY */
   (p_id_imputazione in imputazioni_bilancio.id_imputazione%type) return boolean;
   pragma restrict_references(canhandle, wnds);
   -- Esistenza riga con chiave indicata
   function exists_id /* SLAVE_COPY */
   (p_id_imputazione in imputazioni_bilancio.id_imputazione%type) return number;
   pragma restrict_references(exists_id, wnds);
   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   function existsid /* SLAVE_COPY */
   (p_id_imputazione in imputazioni_bilancio.id_imputazione%type) return boolean;
   pragma restrict_references(existsid, wnds);
   -- Messaggio previsto per il numero di eccezione indicato
   function error_message /* SLAVE_COPY */
   (p_error_number in afc_error.t_error_number) return afc_error.t_error_msg;
   pragma restrict_references(error_message, wnds);
   -- Inserimento di una riga
   procedure ins
   (
      p_id_imputazione in imputazioni_bilancio.id_imputazione%type
     ,p_id_componente  in imputazioni_bilancio.id_componente%type
     ,p_numero         in imputazioni_bilancio.numero%type
     ,p_dal            in imputazioni_bilancio.dal%type
     ,p_al             in imputazioni_bilancio.al%type default null
     ,p_utente_agg     in imputazioni_bilancio.utente_agg%type default null
     ,p_data_agg       in imputazioni_bilancio.data_agg%type default null
   );
   -- Aggiornamento di una riga
   procedure upd
   (
      p_new_id_imputazione in imputazioni_bilancio.id_imputazione%type
     ,p_new_id_componente  in imputazioni_bilancio.id_componente%type
     ,p_new_numero         in imputazioni_bilancio.numero%type
     ,p_new_dal            in imputazioni_bilancio.dal%type
     ,p_new_al             in imputazioni_bilancio.al%type
     ,p_new_utente_agg     in imputazioni_bilancio.utente_agg%type
     ,p_new_data_agg       in imputazioni_bilancio.data_agg%type
     ,p_old_id_imputazione in imputazioni_bilancio.id_imputazione%type default null
     ,p_old_id_componente  in imputazioni_bilancio.id_componente%type default null
     ,p_old_numero         in imputazioni_bilancio.numero%type default null
     ,p_old_dal            in imputazioni_bilancio.dal%type default null
     ,p_old_al             in imputazioni_bilancio.al%type default null
     ,p_old_utente_agg     in imputazioni_bilancio.utente_agg%type default null
     ,p_old_data_agg       in imputazioni_bilancio.data_agg%type default null
     ,p_check_old          in integer default 0
   );
   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
      p_id_imputazione in imputazioni_bilancio.id_imputazione%type
     ,p_column         in varchar2
     ,p_value          in varchar2 default null
     ,p_literal_value  in number default 1
   );
   procedure upd_column
   (
      p_id_imputazione in imputazioni_bilancio.id_imputazione%type
     ,p_column         in varchar2
     ,p_value          in date
   );
   -- Cancellazione di una riga
   procedure del
   (
      p_id_imputazione in imputazioni_bilancio.id_imputazione%type
     ,p_id_componente  in imputazioni_bilancio.id_componente%type default null
     ,p_numero         in imputazioni_bilancio.numero%type default null
     ,p_dal            in imputazioni_bilancio.dal%type default null
     ,p_al             in imputazioni_bilancio.al%type default null
     ,p_utente_agg     in imputazioni_bilancio.utente_agg%type default null
     ,p_data_agg       in imputazioni_bilancio.data_agg%type default null
     ,p_check_old      in integer default 0
   );
   -- Attributo id_componente di riga esistente identificata da chiave
   function get_id_componente /* SLAVE_COPY */
   (p_id_imputazione in imputazioni_bilancio.id_imputazione%type)
      return imputazioni_bilancio.id_componente%type;
   pragma restrict_references(get_id_componente, wnds);
   -- Attributo numero di riga esistente identificata da chiave
   function get_numero /* SLAVE_COPY */
   (p_id_imputazione in imputazioni_bilancio.id_imputazione%type)
      return imputazioni_bilancio.numero%type;
   pragma restrict_references(get_numero, wnds);
   -- Attributo dal di riga esistente identificata da chiave
   function get_dal /* SLAVE_COPY */
   (p_id_imputazione in imputazioni_bilancio.id_imputazione%type)
      return imputazioni_bilancio.dal%type;
   pragma restrict_references(get_dal, wnds);
   -- Attributo al di riga esistente identificata da chiave
   function get_al /* SLAVE_COPY */
   (p_id_imputazione in imputazioni_bilancio.id_imputazione%type)
      return imputazioni_bilancio.al%type;
   pragma restrict_references(get_al, wnds);
   -- Attributo utente_agg di riga esistente identificata da chiave
   function get_utente_agg /* SLAVE_COPY */
   (p_id_imputazione in imputazioni_bilancio.id_imputazione%type)
      return imputazioni_bilancio.utente_agg%type;
   pragma restrict_references(get_utente_agg, wnds);
   -- Attributo data_agg di riga esistente identificata da chiave
   function get_data_agg /* SLAVE_COPY */
   (p_id_imputazione in imputazioni_bilancio.id_imputazione%type)
      return imputazioni_bilancio.data_agg%type;
   pragma restrict_references(get_data_agg, wnds);
   -- Righe corrispondenti alla selezione indicata
   function get_rows /* SLAVE_COPY */
   (
      p_id_imputazione  in varchar2 default null
     ,p_id_componente   in varchar2 default null
     ,p_numero          in varchar2 default null
     ,p_dal             in varchar2 default null
     ,p_al              in varchar2 default null
     ,p_utente_agg      in varchar2 default null
     ,p_data_agg        in varchar2 default null
     ,p_other_condition in varchar2 default null
     ,p_qbe             in number default 0
   ) return afc.t_ref_cursor;
   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   (
      p_id_imputazione  in varchar2 default null
     ,p_id_componente   in varchar2 default null
     ,p_numero          in varchar2 default null
     ,p_dal             in varchar2 default null
     ,p_al              in varchar2 default null
     ,p_utente_agg      in varchar2 default null
     ,p_data_agg        in varchar2 default null
     ,p_other_condition in varchar2 default null
     ,p_qbe             in number default 0
   ) return integer;
   -- Identificativo record per inserimento
   function get_id_imputazione return imputazioni_bilancio.id_imputazione%type;
   -- Ultimo periodo inserito per il componente
   function get_ultimo_periodo
   (
      p_id_componente in imputazioni_bilancio.id_componente%type
     ,p_rowid         in rowid
   ) return afc_periodo.t_periodo;
   -- Ricerca periodo precedente a un periodo dato
   function get_periodo_precedente
   (
      p_id_componente in imputazioni_bilancio.id_componente%type
     ,p_dal           in imputazioni_bilancio.dal%type
     ,p_rowid         in rowid
   ) return afc_periodo.t_periodo;
   -- Ricerca periodo successivo a un periodo dato
   function get_periodo_successivo
   (
      p_id_componente in imputazioni_bilancio.id_componente%type
     ,p_dal           in imputazioni_bilancio.dal%type
     ,p_rowid         in rowid
   ) return afc_periodo.t_periodo;
   -- Ricerca id_imputazione corrente per componente
   function get_id_imputazione_corrente
   (
      p_id_componente in imputazioni_bilancio.id_componente%type
     ,p_data          in imputazioni_bilancio.dal%type
   ) return imputazioni_bilancio.id_imputazione%type;
   -- Ricerca imputazione corrente per componente
   function get_imputazione_corrente
   (
      p_id_componente in imputazioni_bilancio.id_componente%type
     ,p_data          in imputazioni_bilancio.dal%type
   ) return imputazioni_bilancio.numero%type;
   -- Verifica storicizzazione periodi
   function verifica_periodi(p_id_componente in imputazioni_bilancio.id_componente%type)
      return afc_error.t_error_number;
   -- Controllo di congruenza date di inizio e fine validità
   function is_dal_al_ok
   (
      p_dal in imputazioni_bilancio.dal%type
     ,p_al  in imputazioni_bilancio.al%type
   ) return afc_error.t_error_number;
   -- function di gestione di Data Integrity
   function is_di_ok
   (
      p_dal in imputazioni_bilancio.dal%type
     ,p_al  in imputazioni_bilancio.al%type
   ) return afc_error.t_error_number;
   -- procedure di gestione di Data Integrity
   procedure chk_di
   (
      p_dal in imputazioni_bilancio.dal%type
     ,p_al  in imputazioni_bilancio.al%type
   );
   -- Controllo validita' campo dal
   function is_dal_ok
   (
      p_id_componente in imputazioni_bilancio.id_componente%type
     ,p_old_dal       in imputazioni_bilancio.dal%type
     ,p_new_dal       in imputazioni_bilancio.dal%type
     ,p_old_al        in imputazioni_bilancio.al%type
     ,p_rowid         in rowid
     ,p_inserting     in number
     ,p_updating      in number
   ) return afc_error.t_error_number;
   -- Controllo validita' campo al
   function is_al_ok
   (
      p_id_componente in imputazioni_bilancio.id_componente%type
     ,p_old_dal       in imputazioni_bilancio.dal%type
     ,p_old_al        in imputazioni_bilancio.dal%type
     ,p_new_al        in imputazioni_bilancio.dal%type
     ,p_rowid         in rowid
     ,p_inserting     in number
     ,p_updating      in number
     ,p_nest_level    in integer
   ) return afc_error.t_error_number;
   -- Si puo' eliminare solo l'ultimo record
   function is_record_eliminabile
   (
      p_id_componente in imputazioni_bilancio.id_componente%type
     ,p_old_dal       in imputazioni_bilancio.dal%type
     ,p_old_al        in imputazioni_bilancio.al%type
     ,p_deleting      in number
     ,p_nest_level    in integer
   ) return afc_error.t_error_number;
   -- Controllo integrita' referenziale
   function is_ri_ok
   (
      p_id_componente in imputazioni_bilancio.id_componente%type
     ,p_old_dal       in imputazioni_bilancio.dal%type
     ,p_new_dal       in imputazioni_bilancio.dal%type
     ,p_old_al        in imputazioni_bilancio.dal%type
     ,p_new_al        in imputazioni_bilancio.dal%type
     ,p_rowid         in rowid
     ,p_inserting     in number
     ,p_updating      in number
     ,p_deleting      in number
     ,p_nest_level    in integer
   ) return afc_error.t_error_number;
   -- Controllo integrita' referenziale
   procedure chk_ri
   (
      p_id_componente in imputazioni_bilancio.id_componente%type
     ,p_old_dal       in imputazioni_bilancio.dal%type
     ,p_new_dal       in imputazioni_bilancio.dal%type
     ,p_old_al        in imputazioni_bilancio.dal%type
     ,p_new_al        in imputazioni_bilancio.dal%type
     ,p_rowid         in rowid
     ,p_inserting     in number
     ,p_updating      in number
     ,p_deleting      in number
     ,p_nest_level    in integer
   );
   -- Aggiornamento data di fine validita' periodo precedente
   procedure set_periodo_precedente
   (
      p_id_componente        in imputazioni_bilancio.id_componente%type
     ,p_dal                  in imputazioni_bilancio.dal%type
     ,p_al                   in imputazioni_bilancio.al%type
     ,p_utente_aggiornamento in imputazioni_bilancio.utente_agg%type
   );
   -- Aggiornamento data di inizio validita' periodo successivo
   procedure set_periodo_successivo
   (
      p_id_componente        in imputazioni_bilancio.id_componente%type
     ,p_dal                  in imputazioni_bilancio.dal%type
     ,p_al                   in imputazioni_bilancio.al%type
     ,p_utente_aggiornamento in imputazioni_bilancio.utente_agg%type
   );
   -- Riapertura ultimo periodo
   procedure set_riapertura_periodo
   (
      p_id_componente        in imputazioni_bilancio.id_componente%type
     ,p_dal                  in imputazioni_bilancio.dal%type
     ,p_utente_aggiornamento in imputazioni_bilancio.utente_agg%type
   );
   -- Procedura di settaggio functional integrity
   procedure set_fi
   (
      p_id_componente        in imputazioni_bilancio.id_componente%type
     ,p_old_dal              in imputazioni_bilancio.dal%type
     ,p_dal                  in imputazioni_bilancio.dal%type
     ,p_old_al               in imputazioni_bilancio.al%type
     ,p_al                   in imputazioni_bilancio.al%type
     ,p_numero               in imputazioni_bilancio.numero%type
     ,p_utente_aggiornamento in imputazioni_bilancio.utente_agg%type
     ,p_inserting            in number
     ,p_updating             in number
     ,p_deleting             in number
   );
   -- Eliminazione imputazioni_bilancio di un componente (delete)
   procedure elimina_imputazioni
   (
      p_id_componente          in imputazioni_bilancio.id_componente%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );
   -- Annullamento imputazioni_bilancio di un componente (al)
   procedure annulla_imputazioni
   (
      p_id_componente          in imputazioni_bilancio.id_componente%type
     ,p_al                     in imputazioni_bilancio.al%type
     ,p_data_aggiornamento     in imputazioni_bilancio.data_agg%type
     ,p_utente_aggiornamento   in imputazioni_bilancio.utente_agg%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );
   -- Aggiornamento imputazioni_bilancio di un componente (dal)
   procedure aggiorna_imputazioni
   (
      p_id_componente          in imputazioni_bilancio.id_componente%type
     ,p_dal                    in imputazioni_bilancio.dal%type
     ,p_data_aggiornamento     in imputazioni_bilancio.data_agg%type
     ,p_utente_aggiornamento   in imputazioni_bilancio.utente_agg%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );
   -- Ripristino imputazioni_bilancio di un componente (al = null)
   procedure ripristina_imputazioni
   (
      p_id_componente          in imputazioni_bilancio.id_componente%type
     ,p_data_aggiornamento     in imputazioni_bilancio.data_agg%type
     ,p_utente_aggiornamento   in imputazioni_bilancio.utente_agg%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );
end imputazione_bilancio;
/

