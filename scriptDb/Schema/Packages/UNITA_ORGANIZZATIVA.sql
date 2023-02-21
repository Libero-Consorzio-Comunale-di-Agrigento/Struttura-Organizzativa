CREATE OR REPLACE package unita_organizzativa is
   /* MASTER_LINK */
   /******************************************************************************
    NOME:        unita_organizzativa
    DESCRIZIONE: Gestione tabella unita_organizzative.
    ANNOTAZIONI: .
    REVISIONI:   .
    <CODE>
    Rev.  Data       Autore       Descrizione.
    00    01/08/2006  VDAVALLI    Prima emissione.
    01    04/09/2009  VDAVALLI    Modifiche per configurazione master/slave
    02    29/04/2010  APASSUELLO  Modifica per aggiunta di controlli sulla congruenza delle revisioni
    03    22/09/2010  APASSUELLO  Modificato function esistono_componenti
    04    19/11/2010  APASSUELLO  Aggiunto procedure duplica_struttura
    05    01/08/2011  MMONARI     Modifiche per ottiche non istituzionali derivate
    06    24/11/2011  VDAVALLI    Modifiche alla procedure spostamento componenti
    07    01/08/2011  MMONARI     Modifiche per revisioni retroattive (Dati Storici)
    08    02/07/2012  MMONARI     Consolidamento rel.1.4.1
    09    16/11/2012  MMONARI     Redmine bug #109
    </CODE>
   ******************************************************************************/
   -- Revisione del Package
   s_revisione constant afc.t_revision := 'V1.07';
   -- Tipo del record primary key
   type t_pk is record(
       id_elemento unita_organizzative.id_elemento%type);
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
   legami_istituiti exception;
   pragma exception_init(legami_istituiti, -20905);
   s_legami_istituiti_number constant afc_error.t_error_number := -20905;
   s_legami_istituiti_msg    constant afc_error.t_error_msg := 'Esistono legami per la revisione istituiti con data antecedente alla data indicata';
   legami_cessati exception;
   pragma exception_init(legami_cessati, -20906);
   s_legami_cessati_number constant afc_error.t_error_number := -20906;
   s_legami_cessati_msg    constant afc_error.t_error_msg := 'Esistono legami per la revisione cessati con data successivo alla data indicata';
   componenti_non_ass exception;
   pragma exception_init(componenti_non_ass, -20907);
   s_componenti_non_ass_number constant afc_error.t_error_number := -20907;
   s_componenti_non_ass_msg    constant afc_error.t_error_msg := 'Esistono componenti per la revisione cessati con data successiva alla data indicata';
   unita_presente exception;
   pragma exception_init(unita_presente, -20908);
   s_unita_presente_number constant afc_error.t_error_number := -20908;
   s_unita_presente_msg    constant afc_error.t_error_msg := 'Unita'' organizzativa gia'' presente nella struttura';
   errore_lettura_unor exception;
   pragma exception_init(errore_lettura_unor, -20909);
   s_errore_lettura_unor_number constant afc_error.t_error_number := -20909;
   s_errore_lettura_unor_msg    constant afc_error.t_error_msg := 'Elemento non presente in unita'' organizzative';
   sequenza_non_disp exception;
   pragma exception_init(sequenza_non_disp, -20910);
   s_sequenza_non_disp_number constant afc_error.t_error_number := -20910;
   s_sequenza_non_disp_msg    constant afc_error.t_error_msg := 'Sequenza non disponibile - Eseguire la fase di riattribuzione sequenze';
   date_non_congruenti exception;
   pragma exception_init(date_non_congruenti, -20911);
   s_date_non_congruenti_number constant afc_error.t_error_number := -20911;
   s_date_non_congruenti_msg    constant afc_error.t_error_msg := 'Date periodo non congruenti';
   esiste_periodo_succ exception;
   pragma exception_init(esiste_periodo_succ, -20912);
   s_esiste_periodo_succ_number constant afc_error.t_error_number := -20912;
   s_esiste_periodo_succ_msg    constant afc_error.t_error_msg := 'Date periodo non congruenti';
   incongr_periodo_prec exception;
   pragma exception_init(incongr_periodo_prec, -20913);
   s_incongr_periodo_prec_number constant afc_error.t_error_number := -20913;
   s_incongr_periodo_prec_msg    constant afc_error.t_error_msg := 'Data di inizio validita'' non compresa nel periodo precedente';
   incongr_periodo_succ exception;
   pragma exception_init(incongr_periodo_succ, -20914);
   s_incongr_periodo_succ_number constant afc_error.t_error_number := -20914;
   s_incongr_periodo_succ_msg    constant afc_error.t_error_msg := 'Data di fine validita'' non compresa nel periodo successivo';
   esistono_unita_figlie exception;
   pragma exception_init(esistono_unita_figlie, -20915);
   s_esistono_unita_figlie_number constant afc_error.t_error_number := -20915;
   s_esistono_unita_figlie_msg    constant afc_error.t_error_msg := 'Legame non eliminabile - Esistono unita'' a livello inferiore';
   esistono_componenti_attivi exception;
   pragma exception_init(esistono_componenti_attivi, -20916);
   s_esistono_componenti_number constant afc_error.t_error_number := -20916;
   s_esistono_componenti_msg    constant afc_error.t_error_msg := 'Legame non eliminabile - Esistono componenti associati all''unita''';
   revisioni_errate exception;
   pragma exception_init(revisioni_errate, -20917);
   s_revisioni_errate_num constant afc_error.t_error_number := -20917;
   s_revisioni_errate_msg constant afc_error.t_error_msg := 'Incongruenza nell''inserimento delle revisioni';
   estrazione_puo exception;
   pragma exception_init(estrazione_puo, -20918);
   s_estrazione_puo_num constant afc_error.t_error_number := -20918;
   s_estrazione_puo_msg constant afc_error.t_error_msg := 'Errore nell''estrazione del progressivo per l''id_elemento';
   estrazione_id_elemento exception;
   pragma exception_init(estrazione_id_elemento, -20919);
   s_estrazione_id_elemento_num constant afc_error.t_error_number := -20919;
   s_estrazione_id_elemento_msg constant afc_error.t_error_msg := 'Errore nell''estrazione dell''id_elemento per il progressivo unità';
   duplicazione_errore exception;
   pragma exception_init(duplicazione_errore, -20920);
   s_duplicazione_errore_num constant afc_error.t_error_number := -20920;
   s_duplicazione_errore_msg constant afc_error.t_error_msg := 'E'' permessa solamente la duplicazione verso un''ottica NON istituzionale o tra ottiche appartenenti allo stesso ente';
   -- Versione e revisione
   function versione /* SLAVE_COPY */
    return varchar2;
   pragma restrict_references(versione, wnds);
   -- Costruttore di record chiave
   function pk /* SLAVE_COPY */
   (p_id_elemento in unita_organizzative.id_elemento%type) return t_pk;
   pragma restrict_references(pk, wnds);
   -- Controllo integrità chiave
   function can_handle /* SLAVE_COPY */
   (p_id_elemento in unita_organizzative.id_elemento%type) return number;
   pragma restrict_references(can_handle, wnds);
   -- Controllo integrità chiave
   -- wrapper boolean
   function canhandle /* SLAVE_COPY */
   (p_id_elemento in unita_organizzative.id_elemento%type) return boolean;
   pragma restrict_references(canhandle, wnds);
   -- Esistenza riga con chiave indicata
   function exists_id /* SLAVE_COPY */
   (p_id_elemento in unita_organizzative.id_elemento%type) return number;
   pragma restrict_references(exists_id, wnds);
   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   function existsid /* SLAVE_COPY */
   (p_id_elemento in unita_organizzative.id_elemento%type) return boolean;
   pragma restrict_references(existsid, wnds);
   -- Messaggio previsto per il numero di eccezione indicato
   function error_message /* SLAVE_COPY */
   (p_error_number in afc_error.t_error_number) return afc_error.t_error_msg;
   pragma restrict_references(error_message, wnds);
   -- Inserimento di una riga
   procedure ins
   (
      p_id_elemento               in unita_organizzative.id_elemento%type default null
     ,p_ottica                    in unita_organizzative.ottica%type
     ,p_revisione                 in unita_organizzative.revisione%type default null
     ,p_sequenza                  in unita_organizzative.sequenza%type default null
     ,p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type default null
     ,p_id_unita_padre            in unita_organizzative.id_unita_padre%type default null
     ,p_revisione_cessazione      in unita_organizzative.revisione_cessazione%type default null
     ,p_dal                       in unita_organizzative.dal%type default null
     ,p_al                        in unita_organizzative.al%type default null
     ,p_utente_aggiornamento      in unita_organizzative.utente_aggiornamento%type default null
     ,p_data_aggiornamento        in unita_organizzative.data_aggiornamento%type default null
     ,p_dal_pubb                  in unita_organizzative.dal_pubb%type default null
     ,p_al_pubb                   in unita_organizzative.al_pubb%type default null
     ,p_al_prec                   in unita_organizzative.al_prec%type default null
     ,p_revisione_cess_prec       in unita_organizzative.revisione_cess_prec%type default null
   );
   -- Aggiornamento di una riga
   procedure upd
   (
      p_new_id_elemento          in unita_organizzative.id_elemento%type
     ,p_new_ottica               in unita_organizzative.ottica%type
     ,p_new_revisione            in unita_organizzative.revisione%type
     ,p_new_sequenza             in unita_organizzative.sequenza%type
     ,p_new_progr_unita_org      in unita_organizzative.progr_unita_organizzativa%type
     ,p_new_id_unita_padre       in unita_organizzative.id_unita_padre%type
     ,p_new_revisione_cessazione in unita_organizzative.revisione_cessazione%type
     ,p_new_dal                  in unita_organizzative.dal%type
     ,p_new_al                   in unita_organizzative.al%type
     ,p_new_dal_pubb             in unita_organizzative.dal_pubb%type default null
     ,p_new_al_pubb              in unita_organizzative.al_pubb%type default null
     ,p_new_al_prec              in unita_organizzative.al_prec%type default null
     ,p_new_revisione_cess_prec  in unita_organizzative.revisione_cess_prec%type default null
     ,p_new_utente_aggiornamento in unita_organizzative.utente_aggiornamento%type
     ,p_new_data_aggiornamento   in unita_organizzative.data_aggiornamento%type
     ,p_old_id_elemento          in unita_organizzative.id_elemento%type default null
     ,p_old_ottica               in unita_organizzative.ottica%type default null
     ,p_old_revisione            in unita_organizzative.revisione%type default null
     ,p_old_sequenza             in unita_organizzative.sequenza%type default null
     ,p_old_progr_unita_org      in unita_organizzative.progr_unita_organizzativa%type default null
     ,p_old_id_unita_padre       in unita_organizzative.id_unita_padre%type default null
     ,p_old_revisione_cessazione in unita_organizzative.revisione_cessazione%type default null
     ,p_old_dal                  in unita_organizzative.dal%type default null
     ,p_old_al                   in unita_organizzative.al%type default null
     ,p_old_dal_pubb             in unita_organizzative.dal_pubb%type default null
     ,p_old_al_pubb              in unita_organizzative.al_pubb%type default null
     ,p_old_al_prec              in unita_organizzative.al_prec%type default null
     ,p_old_revisione_cess_prec  in unita_organizzative.revisione_cess_prec%type default null
     ,p_old_utente_aggiornamento in unita_organizzative.utente_aggiornamento%type default null
     ,p_old_data_aggiornamento   in unita_organizzative.data_aggiornamento%type default null
     ,p_check_old                in integer default 0
   );
   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
      p_id_elemento   in unita_organizzative.id_elemento%type
     ,p_column        in varchar2
     ,p_value         in varchar2 default null
     ,p_literal_value in number default 1
   );
   procedure upd_column
   (
      p_id_elemento in unita_organizzative.id_elemento%type
     ,p_column      in varchar2
     ,p_value       in date
   );
   -- Cancellazione di una riga
   procedure del
   (
      p_id_elemento               in unita_organizzative.id_elemento%type
     ,p_ottica                    in unita_organizzative.ottica%type default null
     ,p_revisione                 in unita_organizzative.revisione%type default null
     ,p_sequenza                  in unita_organizzative.sequenza%type default null
     ,p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type default null
     ,p_id_unita_padre            in unita_organizzative.id_unita_padre%type default null
     ,p_revisione_cessazione      in unita_organizzative.revisione_cessazione%type default null
     ,p_dal                       in unita_organizzative.dal%type default null
     ,p_al                        in unita_organizzative.al%type default null
     ,p_dal_pubb                  in unita_organizzative.dal_pubb%type default null
     ,p_al_pubb                   in unita_organizzative.al_pubb%type default null
     ,p_al_prec                   in unita_organizzative.al_prec%type default null
     ,p_revisione_cess_prec       in unita_organizzative.revisione_cess_prec%type default null
     ,p_utente_aggiornamento      in unita_organizzative.utente_aggiornamento%type default null
     ,p_data_aggiornamento        in unita_organizzative.data_aggiornamento%type default null
     ,p_check_old                 in integer default 0
   );
   -- Attributo ottica di riga esistente identificata da chiave
   function get_ottica /* SLAVE_COPY */
   (p_id_elemento in unita_organizzative.id_elemento%type)
      return unita_organizzative.ottica%type;
   pragma restrict_references(get_ottica, wnds);
   -- Attributo revisione di riga esistente identificata da chiave
   function get_revisione /* SLAVE_COPY */
   (p_id_elemento in unita_organizzative.id_elemento%type)
      return unita_organizzative.revisione%type;
   pragma restrict_references(get_revisione, wnds);
   -- Attributo sequenza di riga esistente identificata da chiave
   function get_sequenza /* SLAVE_COPY */
   (p_id_elemento in unita_organizzative.id_elemento%type)
      return unita_organizzative.sequenza%type;
   pragma restrict_references(get_sequenza, wnds);
   -- Attributo progr_unita_organizzativa di riga esistente identificata da chiave
   function get_progr_unita /* SLAVE_COPY */
   (p_id_elemento in unita_organizzative.id_elemento%type)
      return unita_organizzative.progr_unita_organizzativa%type;
   pragma restrict_references(get_progr_unita, wnds);
   -- Attributo id_unita_padre di riga esistente identificata da chiave
   function get_id_unita_padre /* SLAVE_COPY */
   (p_id_elemento in unita_organizzative.id_elemento%type)
      return unita_organizzative.id_unita_padre%type;
   pragma restrict_references(get_id_unita_padre, wnds);
   -- Attributo revisione_cessazione di riga esistente identificata da chiave
   function get_revisione_cessazione /* SLAVE_COPY */
   (p_id_elemento in unita_organizzative.id_elemento%type)
      return unita_organizzative.revisione_cessazione%type;
   pragma restrict_references(get_revisione_cessazione, wnds);
   -- Attributo dal di riga esistente identificata da chiave
   function get_dal /* SLAVE_COPY */
   (p_id_elemento in unita_organizzative.id_elemento%type)
      return unita_organizzative.dal%type;
   pragma restrict_references(get_dal, wnds);
   -- Attributo al di riga esistente identificata da chiave
   function get_al /* SLAVE_COPY */
   (p_id_elemento in unita_organizzative.id_elemento%type)
      return unita_organizzative.al%type;
   pragma restrict_references(get_al, wnds);
   -- Attributo dal_pubb di riga esistente identificata da chiave
   function get_dal_pubb /* SLAVE_COPY */
   (p_id_elemento in unita_organizzative.id_elemento%type)
      return unita_organizzative.dal_pubb%type;
   pragma restrict_references(get_dal_pubb, wnds);
   -- Attributo al_pubb di riga esistente identificata da chiave
   function get_al_pubb /* SLAVE_COPY */
   (p_id_elemento in unita_organizzative.id_elemento%type)
      return unita_organizzative.al_pubb%type;
   pragma restrict_references(get_al_pubb, wnds);
   -- Attributo al_prec di riga esistente identificata da chiave
   function get_al_prec /* SLAVE_COPY */
   (p_id_elemento in unita_organizzative.id_elemento%type)
      return unita_organizzative.al_prec%type;
   pragma restrict_references(get_al_prec, wnds);
   -- Attributo revisione_cess_prec di riga esistente identificata da chiave
   function get_revisione_cess_prec /* SLAVE_COPY */
   (p_id_elemento in unita_organizzative.id_elemento%type)
      return unita_organizzative.revisione_cess_prec%type;
   pragma restrict_references(get_revisione_cess_prec, wnds);
   -- Attributo utente_aggiornamento di riga esistente identificata da chiave
   function get_utente_aggiornamento /* SLAVE_COPY */
   (p_id_elemento in unita_organizzative.id_elemento%type)
      return unita_organizzative.utente_aggiornamento%type;
   pragma restrict_references(get_utente_aggiornamento, wnds);
   -- Attributo data_aggiornamento di riga esistente identificata da chiave
   function get_data_aggiornamento /* SLAVE_COPY */
   (p_id_elemento in unita_organizzative.id_elemento%type)
      return unita_organizzative.data_aggiornamento%type;
   pragma restrict_references(get_data_aggiornamento, wnds);
   -- righe corrispondenti alla selezione indicata
   function get_rows /* SLAVE_COPY */
   (
      p_id_elemento               in varchar2 default null
     ,p_ottica                    in varchar2 default null
     ,p_revisione                 in varchar2 default null
     ,p_sequenza                  in varchar2 default null
     ,p_progr_unita_organizzativa in varchar2 default null
     ,p_id_unita_padre            in varchar2 default null
     ,p_revisione_cessazione      in varchar2 default null
     ,p_dal                       in varchar2 default null
     ,p_al                        in varchar2 default null
     ,p_dal_pubb                  in varchar2 default null
     ,p_al_pubb                   in varchar2 default null
     ,p_al_prec                   in varchar2 default null
     ,p_revisione_cess_prec       in varchar2 default null
     ,p_utente_aggiornamento      in varchar2 default null
     ,p_data_aggiornamento        in varchar2 default null
     ,p_other_condition           in varchar2 default null
     ,p_qbe                       in number default 0
   ) return afc.t_ref_cursor;
   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   (
      p_id_elemento               in varchar2 default null
     ,p_ottica                    in varchar2 default null
     ,p_revisione                 in varchar2 default null
     ,p_sequenza                  in varchar2 default null
     ,p_progr_unita_organizzativa in varchar2 default null
     ,p_id_unita_padre            in varchar2 default null
     ,p_revisione_cessazione      in varchar2 default null
     ,p_dal                       in varchar2 default null
     ,p_al                        in varchar2 default null
     ,p_dal_pubb                  in varchar2 default null
     ,p_al_pubb                   in varchar2 default null
     ,p_al_prec                   in varchar2 default null
     ,p_revisione_cess_prec       in varchar2 default null
     ,p_utente_aggiornamento      in varchar2 default null
     ,p_data_aggiornamento        in varchar2 default null
     ,p_other_condition           in varchar2 default null
     ,p_qbe                       in number default 0
   ) return integer;
   -- Restituisce la sequence del nuovo record da inserire
   function get_id_elemento return unita_organizzative.id_elemento%type;
   pragma restrict_references(get_id_elemento, wnds);
   -- Restituisce il progr. unita' padre dell'id elemento passato
   function get_progr_unita_padre /* SLAVE_COPY */
   (p_id_elemento in unita_organizzative.id_elemento%type)
      return unita_organizzative.progr_unita_organizzativa%type;
   pragma restrict_references(get_progr_unita_padre, wnds);
   -- Restituisce l'id del record dove è presente l'unita' indicata
   function get_id_progr_unita /* SLAVE_COPY */
   (
      p_progr_unita in unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica      in unita_organizzative.ottica%type
     ,p_data        in unita_organizzative.dal%type
   ) return unita_organizzative.id_elemento%type;
   -- Determina la sequenza di inserimento di un nuovo legame di struttura
   function get_nuova_sequenza
   (
      p_ottica         unita_organizzative.ottica%type
     ,p_id_unita_padre unita_organizzative.id_unita_padre%type
     ,p_data           unita_organizzative.dal%type
   ) return unita_organizzative.sequenza%type;
   -- Conta le righe contenenti l'unita' indicata ancora valide alla data
   -- (per aggiornamento data fine validita' anagrafica)
   function conta_righe
   (
      p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_data                      in unita_organizzative.dal%type
   ) return number;
   -- Restituisce le date dell'ultimo periodo dell'unita' organizzativa
   function get_ultimo_periodo
   (
      p_ottica                    in unita_organizzative.ottica%type
     ,p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_rowid                     in rowid
   ) return afc_periodo.t_periodo;
   -- Controlla che il periodo indicato sia l'ultimo per l'unita' organizzativa
   function is_ultimo_periodo
   (
      p_ottica                    in unita_organizzative.ottica%type
     ,p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in unita_organizzative.dal%type
   ) return afc_error.t_error_number;
   -- Verifica che l'unita' organizzativa che si vuole inserire o
   -- ripristinare non sia gia' presente nella struttura
   function esiste_unita
   (
      p_ottica                    in unita_organizzative.ottica%type
     ,p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_data                      in unita_organizzative.dal%type
   ) return afc_error.t_error_number;
   -- Verifica che l'unita' organizzativa che si vuole inserire o
   -- ripristinare non sia gia' presente nella struttura per lo
   -- stesso padre
   function esiste_unita_figlia
   (
      p_ottica                    in unita_organizzative.ottica%type
     ,p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_id_unita_padre            in unita_organizzative.id_unita_padre%type
     ,p_revisione                 in unita_organizzative.revisione%type
   ) return afc_error.t_error_number;
   -- Verifica se l'unita' organizzativa ha dei componenti associati
   function esistono_componenti
   (
      p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica                    in unita_organizzative.ottica%type
     ,p_data                      in unita_organizzative.dal%type
     ,p_revisione                 in unita_organizzative.revisione%type default null
     ,p_sposta_componenti         in number default 0
   ) return varchar2;
   -- Controlla che non esistano legami istituiti o cessati con la
   -- revisione indicata aventi data inizio o fine validità non congruente
   -- con la data della revisione
   function is_legami_revisione_ok
   (
      p_ottica         in unita_organizzative.ottica%type
     ,p_revisione      in unita_organizzative.revisione%type
     ,p_data           in unita_organizzative.dal%type
     ,p_tipo_controllo in number default 0
   ) return afc_error.t_error_number;
   -- procedure di aggiornamento della data di inizio e fine validità
   -- al momento dell'attivazione della revisione
   procedure update_unor
   (
      p_ottica    in unita_organizzative.ottica%type
     ,p_revisione in unita_organizzative.revisione%type
     ,p_data      in unita_organizzative.dal%type
   );
   -- valorizza la variabile s_tipo_revisione
   procedure set_tipo_revisione
   (
      p_ottica    in unita_organizzative.ottica%type
     ,p_revisione in unita_organizzative.revisione%type
   );
   -- function di controllo di un nuovo periodo di validita'
   function is_nuovo_periodo_ok
   (
      p_id_elemento in unita_organizzative.id_elemento%type
     ,p_dal         in unita_organizzative.dal%type
     ,p_al          in unita_organizzative.al%type
   ) return afc_error.t_error_number;
   -- Controllo di congruenza date di inizio e fine validità
   function is_dal_al_ok
   (
      p_dal in unita_organizzative.dal%type
     ,p_al  in unita_organizzative.al%type
   ) return afc_error.t_error_number;
   -- controllo congruenza revisioni
   function is_revisioni_ok
   (
      p_revisione            in unita_organizzative.revisione%type
     ,p_revisione_cessazione in unita_organizzative.revisione_cessazione%type
   ) return afc_error.t_error_number;
   -- function di gestione di Data Integrity
   function is_di_ok
   (
      p_dal                  in unita_organizzative.dal%type
     ,p_al                   in unita_organizzative.al%type
     ,p_revisione            in unita_organizzative.revisione%type default null
     ,p_revisione_cessazione in unita_organizzative.revisione_cessazione%type default null
   ) return afc_error.t_error_number;
   -- procedure di gestione di Data Integrity
   procedure chk_di
   (
      p_dal                  in unita_organizzative.dal%type
     ,p_al                   in unita_organizzative.al%type
     ,p_ottica               in unita_organizzative.ottica%type
     ,p_revisione            in unita_organizzative.revisione%type default null
     ,p_revisione_cessazione in unita_organizzative.revisione_cessazione%type default null
   );
   function is_dal_ok
   (
      p_ottica                    in unita_organizzative.ottica%type
     ,p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_old_dal                   in unita_organizzative.dal%type
     ,p_new_dal                   in unita_organizzative.dal%type
     ,p_old_al                    in unita_organizzative.al%type
     ,p_id_elemento               in unita_organizzative.id_elemento%type
     ,p_rowid                     in rowid
     ,p_inserting                 in number
     ,p_updating                  in number
   ) return afc_error.t_error_number;
   function is_al_ok
   (
      p_ottica                    in unita_organizzative.ottica%type
     ,p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_old_dal                   in unita_organizzative.dal%type
     ,p_old_al                    in unita_organizzative.al%type
     ,p_new_al                    in unita_organizzative.al%type
     ,p_id_elemento               in unita_organizzative.id_elemento%type
     ,p_rowid                     in rowid
     ,p_inserting                 in number
     ,p_updating                  in number
   ) return afc_error.t_error_number;
   function is_unita_figlie_ok
   (
      p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica                    unita_organizzative.ottica%type
     ,p_dal                       in unita_organizzative.dal%type
   ) return afc_error.t_error_number;
   function is_componenti_ok
   (
      p_ottica                    in unita_organizzative.ottica%type
     ,p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in unita_organizzative.dal%type
   ) return afc_error.t_error_number;
   function is_ri_ok
   (
      p_ottica                    in unita_organizzative.ottica%type
     ,p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_old_dal                   in unita_organizzative.dal%type
     ,p_new_dal                   in unita_organizzative.dal%type
     ,p_old_al                    in unita_organizzative.al%type
     ,p_new_al                    in unita_organizzative.al%type
     ,p_id_elemento               in unita_organizzative.id_elemento%type
     ,p_old_revisione_cessazione  in unita_organizzative.revisione_cessazione%type
     ,p_new_revisione_cessazione  in unita_organizzative.revisione_cessazione%type
     ,p_rowid                     in rowid
     ,p_inserting                 in number
     ,p_updating                  in number
     ,p_deleting                  in number
   ) return afc_error.t_error_number;
   -- Controllo integrita' referenziale
   procedure chk_ri
   (
      p_ottica                    in unita_organizzative.ottica%type
     ,p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_old_dal                   in unita_organizzative.dal%type
     ,p_new_dal                   in unita_organizzative.dal%type
     ,p_old_al                    in unita_organizzative.al%type
     ,p_new_al                    in unita_organizzative.al%type
     ,p_id_elemento               in unita_organizzative.id_elemento%type
     ,p_old_revisione_cessazione  in unita_organizzative.revisione_cessazione%type
     ,p_new_revisione_cessazione  in unita_organizzative.revisione_cessazione%type
     ,p_rowid                     in rowid
     ,p_inserting                 in number
     ,p_updating                  in number
     ,p_deleting                  in number
   );
   -- Eliminazione unita' organizzativa
   procedure elimina_legame
   (
      p_id_elemento            in unita_organizzative.id_elemento%type
     ,p_revisione              in unita_organizzative.revisione_cessazione%type
     ,p_al                     in unita_organizzative.al%type
     ,p_data_aggiornamento     in unita_organizzative.data_aggiornamento%type
     ,p_utente_aggiornamento   in unita_organizzative.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );
   -- Ripristino unita' organizzativa eliminata
   procedure ripristina_legame
   (
      p_id_elemento            in unita_organizzative.id_elemento%type
     ,p_revisione              in unita_organizzative.revisione_cessazione%type
     ,p_al                     in unita_organizzative.al%type
     ,p_data_aggiornamento     in unita_organizzative.data_aggiornamento%type
     ,p_utente_aggiornamento   in unita_organizzative.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );
   -- Spostamento unita' organizzativa
   procedure sposta_legame
   (
      p_id_elemento_partenza   in unita_organizzative.id_elemento%type
     ,p_id_elemento_arrivo     in unita_organizzative.id_elemento%type
     ,p_revisione              in unita_organizzative.revisione_cessazione%type
     ,p_dal                    in unita_organizzative.dal%type
     ,p_al                     in unita_organizzative.al%type
     ,p_data_aggiornamento     in unita_organizzative.data_aggiornamento%type
     ,p_utente_aggiornamento   in unita_organizzative.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
      /*     ,p_dal_pubb               in unita_organizzative.dal_pubb%type                                                                                                                                                                                                                                                                                                                                                                                                                                                                */
   );
   -- Determinazione della data AL
   procedure set_data_al
   (
      p_ottica                    in unita_organizzative.ottica%type
     ,p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in unita_organizzative.dal%type
   );
   -- Aggiornamento data di fine validita' periodo precedente
   procedure set_periodo_precedente
   (
      p_ottica                    in unita_organizzative.ottica%type
     ,p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in unita_organizzative.dal%type
     ,p_al                        in unita_organizzative.al%type
   );
   -- Aggiornamento revisione su anagrafe unita' organizzative
   procedure set_revisione_istituzione
   (
      p_ottica                    in unita_organizzative.ottica%type
     ,p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_revisione                 in unita_organizzative.revisione%type
   );
   -- Aggiornamento revisione su anagrafe unita' organizzative
   procedure set_revisione_cessazione
   (
      p_ottica                    in unita_organizzative.ottica%type
     ,p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_revisione_cessazione      in unita_organizzative.revisione_cessazione%type
     ,p_dal                       in unita_organizzative.dal%type
   );
   -- procedure di settaggio di Functional Integrity
   procedure set_fi
   (
      p_ottica                    in unita_organizzative.ottica%type
     ,p_old_progr_unor            in unita_organizzative.progr_unita_organizzativa%type
     ,p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_revisione                 in unita_organizzative.revisione%type
     ,p_revisione_cessazione      in unita_organizzative.revisione_cessazione%type
     ,p_old_dal                   in unita_organizzative.dal%type
     ,p_dal                       in unita_organizzative.dal%type
     ,p_old_al                    in unita_organizzative.al%type
     ,p_al                        in unita_organizzative.al%type
     ,p_inserting                 in number
     ,p_updating                  in number
     ,p_deleting                  in number
   );
   -- Verifica che l'unita' organizzativa che si vuole spostare
   -- non faccia parte dell'ascendenza dell'unita' di destinazione
   function contiene_unita
   (
      p_ottica          in unita_organizzative.ottica%type
     ,p_id_provenienza  in unita_organizzative.id_elemento%type
     ,p_id_destinazione in unita_organizzative.id_elemento%type
     ,p_data            in unita_organizzative.dal%type
   ) return integer;
   -- Duplica la struttura esistente associata ad un'ottica di partenza
   -- in un'ottica destinazione
   procedure duplica_struttura
   (
      p_ottica_partenza        in unita_organizzative.ottica%type
     ,p_ottica_destinazione    in unita_organizzative.ottica%type
     ,p_data                   in unita_organizzative.dal%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );
   -- Duplica la struttura esistente ed eventualmente le
   -- assegnazioni associate ad un'ottica modello
   -- in un'ottica derivata
   procedure duplica_ottica
   (
      p_ottica_origine         in unita_organizzative.ottica%type
     ,p_ottica_derivata        in unita_organizzative.ottica%type
     ,p_data                   in unita_organizzative.dal%type
     ,p_duplica_assegnazioni   in varchar2 default 'NO'
     ,p_aggiornamento          in varchar2 default 'NO'
     ,p_tipo_agg_componenti    in varchar2 default 'N'
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );
   -- Elimina le assegnazioni relative all'ottica data
   -- istituite con la revisione in modifica
   procedure elimina_assegnazioni
   (
      p_ottica                 in unita_organizzative.ottica%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );
   -- Elimina la struttura relativa all'ottica data
   -- istituita con la revisione in modifica
   procedure elimina_struttura
   (
      p_ottica                 in unita_organizzative.ottica%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );
end unita_organizzativa;
/

