CREATE OR REPLACE package revisione_struttura is
   /* MASTER_LINK */
   /******************************************************************************
    NOME:        Revisione_struttura
    DESCRIZIONE: Gestione tabella revisioni_struttura.
    ANNOTAZIONI: .
    REVISIONI:   .
    <CODE>
    Rev.  Data       Autore       Descrizione.
    00    31/07/2006  VDAVALLI    Prima emissione.
    01    04/09/2009  VDAVALLI    Modifiche per configurazione master/slave
    02    19/05/2010  APASSUELLO  Aggiunto function is_data_ok per controllo sulla congruenza delle date
    03    09/05/2011  MMONARI     Modifiche per ottiche alternative
    04    18/10/2011  MMONARI     Funzione get_al
    05    01/12/2011  MMONARI     Revisioni Retroattive
    06    02/07/2012  MMONARI     Consolidamento rel.1.4.1
    07    15/04/2013  MMONARI     Redmine Bug#239
    08    08/01/2014  MMONARI     Redmine Bug#316 - Verifica revisione ad personam
   ******************************************************************************/
   -- Revisione del Package
   s_revisione constant afc.t_revision := 'V1.08';
   s_attivazione              number(1) := 0;
   s_revisione_in_attivazione revisioni_struttura.revisione%type := -1;
   s_ottica_in_attivazione    revisioni_struttura.ottica%type;
   s_data_pubb_in_attivazione revisioni_struttura.data_pubblicazione%type := '';
   -- Tipo del record primary key
   type t_pk is record(
       ottica    revisioni_struttura.ottica%type
      ,revisione revisioni_struttura.revisione%type);
   -- Exceptions
   legami_istituiti exception;
   pragma exception_init(legami_istituiti, -20901);
   s_legami_istituiti_number constant afc_error.t_error_number := -20901;
   s_legami_istituiti_msg    constant afc_error.t_error_msg := 'Esistono legami per la revisione istituiti con data antecedente alla data indicata';
   legami_cessati exception;
   pragma exception_init(legami_cessati, -20902);
   s_legami_cessati_number constant afc_error.t_error_number := -20902;
   s_legami_cessati_msg    constant afc_error.t_error_msg := 'Esistono legami per la revisione cessati con data successiva alla data indicata';
   componenti_istituiti exception;
   pragma exception_init(componenti_istituiti, -20903);
   s_componenti_istituiti_number constant afc_error.t_error_number := -20903;
   s_componenti_istituiti_msg    constant afc_error.t_error_msg := 'Esistono componenti per la revisione istituiti con data antecedente alla data indicata';
   componenti_cessati exception;
   pragma exception_init(componenti_cessati, -20904);
   s_componenti_cessati_number constant afc_error.t_error_number := -20904;
   s_componenti_cessati_msg    constant afc_error.t_error_msg := 'Esistono componenti per la revisione cessati con data successiva alla data indicata';
   data_revisione_errata exception;
   pragma exception_init(data_revisione_errata, -20905);
   s_data_revisione_errata_number constant afc_error.t_error_number := -20905;
   s_data_revisione_errata_msg    constant afc_error.t_error_msg := 'La revisione che si sta tentando di inserire ha data antecedente rispetto alle revisioni gia'' presenti';
   revisione_non_modificabile exception;
   pragma exception_init(data_revisione_errata, -20906);
   s_rev_non_modificabile_number constant afc_error.t_error_number := -20906;
   s_rev_non_modificabile_msg    constant afc_error.t_error_msg := 'Tipo Revisione non modificabile: esistono gia'' legami correlati';
   esiste_rev_modifica exception;
   pragma exception_init(data_revisione_errata, -20907);
   s_esiste_rev_modifica_number constant afc_error.t_error_number := -20907;
   s_esiste_rev_modifica_msg    constant afc_error.t_error_msg := 'Esiste gia'' una revisione in modifica in questa ottica';
   data_pubb_errata exception;
   pragma exception_init(data_pubb_errata, -20908);
   s_data_pubb_errata_number constant afc_error.t_error_number := -20908;
   s_data_pubb_errata_msg    constant afc_error.t_error_msg := 'La data di pubblicazione e'' precedente la decorrenza della revisione';
   -- Versione e revisione
   function versione /* SLAVE_COPY */
    return varchar2;
   pragma restrict_references(versione, wnds);
   -- Costruttore di record chiave
   function pk /* SLAVE_COPY */
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return t_pk;
   pragma restrict_references(pk, wnds);
   -- Controllo integrita chiave
   function can_handle /* SLAVE_COPY */
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return number;
   pragma restrict_references(can_handle, wnds);
   -- Controllo integrita chiave
   -- wrapper boolean
   function canhandle /* SLAVE_COPY */
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return boolean;
   pragma restrict_references(canhandle, wnds);
   -- Esistenza riga con chiave indicata
   function exists_id /* SLAVE_COPY */
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return number;
   pragma restrict_references(exists_id, wnds);
   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   function existsid /* SLAVE_COPY */
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return boolean;
   pragma restrict_references(existsid, wnds);
   -- Messaggio previsto per il numero di eccezione indicato
   function error_message /* SLAVE_COPY */
   (p_error_number in afc_error.t_error_number) return afc_error.t_error_msg;
   pragma restrict_references(error_message, wnds);
   -- Inserimento di una riga
   procedure ins
   (
      p_ottica               in revisioni_struttura.ottica%type
     ,p_revisione            in revisioni_struttura.revisione%type default null
     ,p_descrizione          in revisioni_struttura.descrizione%type
     ,p_tipo_registro        in revisioni_struttura.tipo_registro%type default null
     ,p_anno                 in revisioni_struttura.anno%type default null
     ,p_numero               in revisioni_struttura.numero%type default null
     ,p_data                 in revisioni_struttura.data%type default null
     ,p_descrizione_al1      in revisioni_struttura.descrizione_al1%type default null
     ,p_descrizione_al2      in revisioni_struttura.descrizione_al2%type default null
     ,p_dal                  in revisioni_struttura.dal%type default null
     ,p_data_pubblicazione   in revisioni_struttura.data_pubblicazione%type default null
     ,p_data_termine         in revisioni_struttura.data_termine%type default null
     ,p_tipo_revisione       in revisioni_struttura.tipo_revisione%type default null
     ,p_nota                 in revisioni_struttura.nota%type default null
     ,p_stato                in revisioni_struttura.stato%type default null
     ,p_provenienza          in revisioni_struttura.provenienza%type default null
     ,p_utente_aggiornamento in revisioni_struttura.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in revisioni_struttura.data_aggiornamento%type default null
   );
   -- Aggiornamento di una riga
   procedure upd
   (
      p_new_ottica               in revisioni_struttura.ottica%type
     ,p_new_revisione            in revisioni_struttura.revisione%type
     ,p_new_tipo_registro        in revisioni_struttura.tipo_registro%type
     ,p_new_anno                 in revisioni_struttura.anno%type
     ,p_new_numero               in revisioni_struttura.numero%type
     ,p_new_data                 in revisioni_struttura.data%type
     ,p_new_descrizione          in revisioni_struttura.descrizione%type
     ,p_new_descrizione_al1      in revisioni_struttura.descrizione_al1%type
     ,p_new_descrizione_al2      in revisioni_struttura.descrizione_al2%type
     ,p_new_dal                  in revisioni_struttura.dal%type
     ,p_new_data_pubblicazione   in revisioni_struttura.data_pubblicazione%type
     ,p_new_data_termine         in revisioni_struttura.data_termine%type default null
     ,p_new_tipo_revisione       in revisioni_struttura.tipo_revisione%type
     ,p_new_nota                 in revisioni_struttura.nota%type
     ,p_new_stato                in revisioni_struttura.stato%type
     ,p_new_provenienza          in revisioni_struttura.provenienza%type
     ,p_new_utente_aggiornamento in revisioni_struttura.utente_aggiornamento%type
     ,p_new_data_aggiornamento   in revisioni_struttura.data_aggiornamento%type
     ,p_old_ottica               in revisioni_struttura.ottica%type default null
     ,p_old_revisione            in revisioni_struttura.revisione%type default null
     ,p_old_tipo_registro        in revisioni_struttura.tipo_registro%type default null
     ,p_old_anno                 in revisioni_struttura.anno%type default null
     ,p_old_numero               in revisioni_struttura.numero%type default null
     ,p_old_data                 in revisioni_struttura.data%type default null
     ,p_old_descrizione          in revisioni_struttura.descrizione%type default null
     ,p_old_descrizione_al1      in revisioni_struttura.descrizione_al1%type default null
     ,p_old_descrizione_al2      in revisioni_struttura.descrizione_al2%type default null
     ,p_old_dal                  in revisioni_struttura.dal%type default null
     ,p_old_data_pubblicazione   in revisioni_struttura.data_pubblicazione%type default null
     ,p_old_data_termine         in revisioni_struttura.data_termine%type default null
     ,p_old_tipo_revisione       in revisioni_struttura.tipo_revisione%type default null
     ,p_old_nota                 in revisioni_struttura.nota%type default null
     ,p_old_stato                in revisioni_struttura.stato%type default null
     ,p_old_provenienza          in revisioni_struttura.provenienza%type default null
     ,p_old_utente_aggiornamento in revisioni_struttura.utente_aggiornamento%type default null
     ,p_old_data_aggiornamento   in revisioni_struttura.data_aggiornamento%type default null
     ,p_check_old                in integer default 0
   );
   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
      p_ottica        in revisioni_struttura.ottica%type
     ,p_revisione     in revisioni_struttura.revisione%type
     ,p_column        in varchar2
     ,p_value         in varchar2 default null
     ,p_literal_value in number default 1
   );
   procedure upd_column
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
     ,p_column    in varchar2
     ,p_value     in date
   );
   -- Cancellazione di una riga
   procedure del
   (
      p_ottica               in revisioni_struttura.ottica%type
     ,p_revisione            in revisioni_struttura.revisione%type
     ,p_tipo_registro        in revisioni_struttura.tipo_registro%type default null
     ,p_anno                 in revisioni_struttura.anno%type default null
     ,p_numero               in revisioni_struttura.numero%type default null
     ,p_data                 in revisioni_struttura.data%type default null
     ,p_descrizione          in revisioni_struttura.descrizione%type default null
     ,p_descrizione_al1      in revisioni_struttura.descrizione_al1%type default null
     ,p_descrizione_al2      in revisioni_struttura.descrizione_al2%type default null
     ,p_dal                  in revisioni_struttura.dal%type default null
     ,p_data_pubblicazione   in revisioni_struttura.data_pubblicazione%type default null
     ,p_data_termine         in revisioni_struttura.data_termine%type default null
     ,p_tipo_revisione       in revisioni_struttura.tipo_revisione%type default null
     ,p_nota                 in revisioni_struttura.nota%type default null
     ,p_stato                in revisioni_struttura.stato%type default null
     ,p_provenienza          in revisioni_struttura.provenienza%type default null
     ,p_utente_aggiornamento in revisioni_struttura.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in revisioni_struttura.data_aggiornamento%type default null
     ,p_check_old            in integer default 0
   );
   -- Attributo descrizione di riga esistente identificata da chiave
   function get_descrizione /* SLAVE_COPY */
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return revisioni_struttura.descrizione%type;
   pragma restrict_references(get_descrizione, wnds);
   -- Attributo tipo_registro di riga esistente identificata da chiave
   function get_tipo_registro /* SLAVE_COPY */
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return revisioni_struttura.tipo_registro%type;
   pragma restrict_references(get_tipo_registro, wnds);
   -- Attributo anno di riga esistente identificata da chiave
   function get_anno /* SLAVE_COPY */
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return revisioni_struttura.anno%type;
   pragma restrict_references(get_anno, wnds);
   -- Attributo numero di riga esistente identificata da chiave
   function get_numero /* SLAVE_COPY */
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return revisioni_struttura.numero%type;
   pragma restrict_references(get_numero, wnds);
   -- Attributo data di riga esistente identificata da chiave
   function get_data /* SLAVE_COPY */
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return revisioni_struttura.data%type;
   pragma restrict_references(get_data, wnds);
   -- Attributo dal di riga esistente identificata da chiave
   function get_dal /* SLAVE_COPY */
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return revisioni_struttura.dal%type;
   pragma restrict_references(get_dal, wnds);
   -- Attributo data_pubblicazione di riga esistente identificata da chiave
   function get_data_pubblicazione /* SLAVE_COPY */
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return revisioni_struttura.data_pubblicazione%type;
   pragma restrict_references(get_data_pubblicazione, wnds);
   -- Attributo data_termine di riga esistente identificata da chiave
   function get_data_termine /* SLAVE_COPY */
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return revisioni_struttura.data_termine%type;
   pragma restrict_references(get_data_termine, wnds);
   -- Attributo tipo_revisione di riga esistente identificata da chiave
   function get_tipo_revisione /* SLAVE_COPY */
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return revisioni_struttura.tipo_revisione%type;
   pragma restrict_references(get_tipo_revisione, wnds);
   -- Attributo nota di riga esistente identificata da chiave
   function get_nota /* SLAVE_COPY */
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return revisioni_struttura.nota%type;
   pragma restrict_references(get_nota, wnds);
   -- Attributo stato di riga esistente identificata da chiave
   function get_stato /* SLAVE_COPY */
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return revisioni_struttura.stato%type;
   pragma restrict_references(get_stato, wnds);
   -- Attributo provenienza di riga esistente identificata da chiave
   function get_provenienza /* SLAVE_COPY */
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return revisioni_struttura.provenienza%type;
   pragma restrict_references(get_provenienza, wnds);
   -- Attributo utente_aggiornamento di riga esistente identificata da chiave
   function get_utente_aggiornamento /* SLAVE_COPY */
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return revisioni_struttura.utente_aggiornamento%type;
   pragma restrict_references(get_utente_aggiornamento, wnds);
   -- Attributo data_aggiornamento di riga esistente identificata da chiave
   function get_data_aggiornamento /* SLAVE_COPY */
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return revisioni_struttura.data_aggiornamento%type;
   pragma restrict_references(get_data_aggiornamento, wnds);
   -- Determinazione del progressivo in inserimento di una nuova
   -- revisione nell'ambito dell'ottica
   function get_id_revisione(p_ottica in revisioni_struttura.ottica%type)
      return revisioni_struttura.revisione%type;
   -- righe corrispondenti alla selezione indicata
   function get_rows /* SLAVE_COPY */
   (
      p_ottica               in varchar2 default null
     ,p_revisione            in varchar2 default null
     ,p_tipo_registro        in varchar2 default null
     ,p_anno                 in varchar2 default null
     ,p_numero               in varchar2 default null
     ,p_data                 in varchar2 default null
     ,p_descrizione          in varchar2 default null
     ,p_descrizione_al1      in varchar2 default null
     ,p_descrizione_al2      in varchar2 default null
     ,p_dal                  in varchar2 default null
     ,p_data_pubblicazione   in varchar2 default null
     ,p_data_termine         in varchar2 default null
     ,p_tipo_revisione       in varchar2 default null
     ,p_nota                 in varchar2 default null
     ,p_stato                in varchar2 default null
     ,p_provenienza          in varchar2 default null
     ,p_utente_aggiornamento in varchar2 default null
     ,p_data_aggiornamento   in varchar2 default null
     ,p_order_condition      in varchar2 default null
     ,p_qbe                  in number default 0
   ) return afc.t_ref_cursor;
   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   (
      p_ottica               in varchar2 default null
     ,p_revisione            in varchar2 default null
     ,p_tipo_registro        in varchar2 default null
     ,p_anno                 in varchar2 default null
     ,p_numero               in varchar2 default null
     ,p_data                 in varchar2 default null
     ,p_descrizione          in varchar2 default null
     ,p_descrizione_al1      in varchar2 default null
     ,p_descrizione_al2      in varchar2 default null
     ,p_dal                  in varchar2 default null
     ,p_data_pubblicazione   in varchar2 default null
     ,p_data_termine         in varchar2 default null
     ,p_tipo_revisione       in varchar2 default null
     ,p_nota                 in varchar2 default null
     ,p_stato                in varchar2 default null
     ,p_provenienza          in varchar2 default null
     ,p_utente_aggiornamento in varchar2 default null
     ,p_data_aggiornamento   in varchar2 default null
     ,p_qbe                  in number default 0
   ) return integer;
   -- Verifica che la revisione sia in modifica per l'ottica
   function esiste_revisione_mod /* SLAVE_COPY */
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return number;
   -- Restituisce la revisione in modifica per ottica
   function get_revisione_mod /* SLAVE_COPY */
   (p_ottica in revisioni_struttura.ottica%type) return revisioni_struttura.revisione%type;
   pragma restrict_references(get_revisione_mod, wnds);
   -- Restituisce l'ultima revisione per ottica
   function get_ultima_revisione /* SLAVE_COPY */
   (p_ottica in revisioni_struttura.ottica%type) return revisioni_struttura.revisione%type;
   -- Esistenza delibera su revisione per ottica
   function esiste_delibera /* SLAVE_COPY */
   (
      p_ottica        in revisioni_struttura.ottica%type
     ,p_revisione     in revisioni_struttura.revisione%type default null
     ,p_tipo_registro in revisioni_struttura.tipo_registro%type default null
     ,p_anno          in revisioni_struttura.anno%type default null
     ,p_numero        in revisioni_struttura.numero%type default null
     ,p_data          in revisioni_struttura.data%type default null
   ) return number;
   -- Controllo di congruenza sulle date delle revisioni
   function is_data_ok
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
     ,p_data      in revisioni_struttura.data%type
   ) return afc_error.t_error_number;
   -- function di gestione di Referential Integrity
   function is_ri_ok
   (
      p_ottica             in revisioni_struttura.ottica%type
     ,p_revisione          in revisioni_struttura.revisione%type
     ,p_data               in revisioni_struttura.data%type
     ,p_new_stato          in revisioni_struttura.stato%type
     ,p_old_stato          in revisioni_struttura.stato%type
     ,p_new_tipo_revisione in revisioni_struttura.stato%type default null
     ,p_old_tipo_revisione in revisioni_struttura.stato%type default null
   ) return afc_error.t_error_number;
   -- procedure di gestione di Referential Integrity
   procedure chk_ri
   (
      p_ottica             in revisioni_struttura.ottica%type
     ,p_revisione          in revisioni_struttura.revisione%type
     ,p_data               in revisioni_struttura.data%type
     ,p_new_stato          in revisioni_struttura.stato%type
     ,p_old_stato          in revisioni_struttura.stato%type
     ,p_new_tipo_revisione in revisioni_struttura.stato%type default null
     ,p_old_tipo_revisione in revisioni_struttura.stato%type default null
   );
   -- procedure di verifica dei dati da modificare al momento della
   -- attivazione della revisione
   procedure verifica_revisione
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
     ,p_data      in revisioni_struttura.dal%type
     ,p_ni        in componenti.ni%type default null
   );
   -- crea una nuova revisione in modifica per l'ottica data
   -- acquisendo le modifiche apportate sull'ottica di origine
   -- alla data indicata
   procedure aggiorna_ottica
   (
      p_ottica_derivata        in revisioni_struttura.ottica%type
     ,p_ottica_origine         in revisioni_struttura.ottica%type
     ,p_data                   in revisioni_struttura.dal%type
     ,p_aggiornamento          in varchar2 default 'NO'
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );
   -- procedure di attivazione della revisione
   procedure attivazione_revisione
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
     ,p_data      in revisioni_struttura.dal%type
   );
   -- procedure di aggiornamento della data di fine validità
   -- delle anagrafiche U.O. al momento dell'attivazione della revisione
   procedure update_anuo
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
     ,p_data      in revisioni_struttura.dal%type
   );
   -- procedure di settaggio di Functional Integrity
   procedure set_fi
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
     ,p_data      in revisioni_struttura.data%type
     ,p_new_stato in revisioni_struttura.stato%type
     ,p_old_stato in revisioni_struttura.stato%type
     ,p_inserting in number
     ,p_updating  in number
     ,p_deleting  in number
   );
   -- function di determinazione della data di jfine validita' della revisione
   function get_al
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return date;
   -- valorizza la variabile s_tipo_revisione
   procedure set_tipo_revisione
   (
      p_ottica    in unita_organizzative.ottica%type
     ,p_revisione in unita_organizzative.revisione%type
   );
   -- Modifica il dal della revisione e aggiorna le date
   -- delle registrazioni di componenti e UO ad essa correlate
   -- se sono uguali alla precedente decorrenza
   procedure modifica_decorrenza
   (
      p_ottica                 in revisioni_struttura.ottica%type
     ,p_revisione              in revisioni_struttura.revisione%type
     ,p_dal                    in date
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );
   -- Verifica se la revisione e' gia' stata istanziata
   function is_revisione_modificabile
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return afc_error.t_error_number;
   -- Valuta le modifiche eseguite nella revisione
   function get_motivo_revisione
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return varchar2;
end revisione_struttura;
/

