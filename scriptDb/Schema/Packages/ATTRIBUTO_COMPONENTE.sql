CREATE OR REPLACE package attributo_componente is
   /* MASTER_LINK */
   /******************************************************************************
    NOME:        attributo_componente
    DESCRIZIONE: Gestione tabella attributi_componente.
    ANNOTAZIONI: .
    REVISIONI:   .
    <CODE>
    Rev.  Data       Autore       Descrizione.
    00    18/09/2006  VDAVALLI    Prima emissione.
    01    03/09/2009  VDAVALLI    Modifiche per configurazione master/slave
    02    07/09/2009  VDAVALLI    Nuovo campo: tipo_assegnazione
    03    29/04/2010  APASSUELLO  Modifica per aggiunta di controlli sulla congruenza delle revisioni
    04    05/07/2010  APASSUELLO  Modifiche per gestione del campo Voto
    05    16/08/2011  MMONARI     Att.45288
    06    07/11/2011  MMONARI     Dati storici
    07    02/07/2011  MMONARI     Consolidamento rel. 1.4.1
    08    29/01/2013  MMONARI     Redmine Bug#148
    09    19/03/2013  VDAVALLI    Aggiunta  get_tipo_ass_corrente per determinare icona Bug#214
          22/03/2013  ADADAMO     Aggiunto controllo su congruenza assegnazione_prevalente Bug#184
    10    11/02/2014  MMONARI     Aggiunto nuovo parametro a DUPLICA_ATTRIBUTI Bug#380
    11    12/05/2014  MMONARI     Issue #440
    12    16/07/2014  ADADAMO     Modificata chiamata chk_ri e gestito controllo is_last_record
                                  solo su delete dirette su attributi_componente Bug#474
    13    11/08/2015  MMONARI     #634, nuovi parametri su set_fi per attribuzione ruoli automatici
          19/10/2015  MMONARI     #644, nuovi parametri su chk_ri per controllo univocita' assegnazione prev.
          21/10/2015  MMONARI     #550, nuova eccezione -20921
   ******************************************************************************/
   -- Revisione del Package
   s_revisione  constant afc.t_revision := 'V1.13';
   s_table_name constant afc.t_object_name := 'attributi_componente';
   s_eccezione number(1) := 0; --#440
   subtype t_rowtype is attributi_componente%rowtype;
   -- Tipo del record primary key
   type t_pk is record(
       id_attr_componente attributi_componente.id_attr_componente%type);
   /*
      -- Exceptions
      <exception_name> exception;
      pragma exception_init( <exception_name>, <error_code> );
      s_<exception_name>_number constant AFC_Error.t_error_number := <error_code>;
      s_<exception_name>_msg    constant AFC_Error.t_error_msg := <error_message>;
   */
   -- Exceptions
   dal_al_errato exception;
   pragma exception_init(dal_al_errato, -20901);
   s_dal_al_errato_num constant afc_error.t_error_number := -20901;
   s_dal_al_errato_msg constant afc_error.t_error_msg := 'Incongruenza date di inizio e fine validita''';
   dal_errato exception;
   pragma exception_init(dal_errato, -20902);
   s_dal_errato_num constant afc_error.t_error_number := -20902;
   s_dal_errato_msg constant afc_error.t_error_msg := 'La data di inizio deve essere compresa nel periodo di validita'' precedente';
   dal_errato_ins exception;
   pragma exception_init(dal_errato_ins, -20903);
   s_dal_errato_ins_num constant afc_error.t_error_number := -20903;
   s_dal_errato_ins_msg constant afc_error.t_error_msg := 'La data di inizio deve essere superiore all''ultima inserita';
   al_errato exception;
   pragma exception_init(al_errato, -20904);
   s_al_errato_num constant afc_error.t_error_number := -20904;
   s_al_errato_msg constant afc_error.t_error_msg := 'La data di fine puo'' essere modificata solo sull''ultimo periodo';
   dal_minore exception;
   pragma exception_init(dal_minore, -20905);
   s_dal_minore_num constant afc_error.t_error_number := -20905;
   s_dal_minore_msg constant afc_error.t_error_msg := 'La data di inizio validita'' non puo'' essere inferiore alla data di inizio attribuzione componente';
   al_maggiore exception;
   pragma exception_init(al_maggiore, -20906);
   s_al_maggiore_num constant afc_error.t_error_number := -20906;
   s_al_maggiore_msg constant afc_error.t_error_msg := 'La data di fine validita'' non puo'' essere superiore alla data di fine attribuzione componente';
   ass_prev_assente exception;
   pragma exception_init(ass_prev_assente, -20907);
   s_ass_prev_assente_num constant afc_error.t_error_number := -20907;
   s_ass_prev_assente_msg constant afc_error.t_error_msg := 'Componente privo di assegnazione prevalente per il periodo indicato';
   ass_prev_multiple exception;
   pragma exception_init(ass_prev_multiple, -20908);
   s_ass_prev_multiple_num constant afc_error.t_error_number := -20908;
   s_ass_prev_multiple_msg constant afc_error.t_error_msg := 'Componente con più assegnazioni prevalenti per il periodo indicato';
   perc_impiego_errata exception;
   pragma exception_init(perc_impiego_errata, -20909);
   s_perc_impiego_errata_num constant afc_error.t_error_number := -20909;
   s_perc_impiego_errata_msg constant afc_error.t_error_msg := 'Il totale percentuali impiego del componente e'' diverso da 100';
   attr_non_eliminabile exception;
   pragma exception_init(attr_non_eliminabile, -20910);
   s_attr_non_eliminabile_num constant afc_error.t_error_number := -20910;
   s_attr_non_eliminabile_msg constant afc_error.t_error_msg := 'Il componente deve avere almeno un attributo valido';
   attributi_istituiti exception;
   pragma exception_init(attributi_istituiti, -20911);
   s_attributi_istituiti_num constant afc_error.t_error_number := -20911;
   s_attributi_istituiti_msg constant afc_error.t_error_msg := 'Esistono attributi per la revisione istituiti con data antecedente alla data indicata';
   attributi_cessati exception;
   pragma exception_init(attributi_cessati, -20912);
   s_attributi_cessati_num constant afc_error.t_error_number := -20912;
   s_attributi_cessati_msg constant afc_error.t_error_msg := 'Esistono attributi per la revisione cessati con data successiva alla data indicata';
   dal_gia_presente exception;
   pragma exception_init(dal_gia_presente, -20913);
   s_dal_gia_presente_num constant afc_error.t_error_number := -20913;
   s_dal_gia_presente_msg constant afc_error.t_error_msg := 'Incarico gia'' presente per la data indicata';
   assegnazione_errata exception;
   pragma exception_init(dal_gia_presente, -20914);
   s_assegnazione_errata_num constant afc_error.t_error_number := -20914;
   s_assegnazione_errata_msg constant afc_error.t_error_msg := 'Incongruenza assegnazione prevalente / tipo assegnazione';
   revisioni_errate exception;
   pragma exception_init(revisioni_errate, -20915);
   s_revisioni_errate_num constant afc_error.t_error_number := -20915;
   s_revisioni_errate_msg constant afc_error.t_error_msg := 'Incongruenza nell''inserimento delle revisioni';
   componente_gia_presente exception;
   pragma exception_init(componente_gia_presente, -20916);
   s_componente_gia_pres_number constant afc_error.t_error_number := -20916;
   s_componente_gia_pres_msg    constant afc_error.t_error_msg := 'Il componente  e'' gia'' assegnato all''unita'' organizzativa selezionata';
   tipo_ass_errato exception;
   pragma exception_init(tipo_ass_errato, -20917);
   s_tipo_ass_errato_number constant afc_error.t_error_number := -20917;
   s_tipo_ass_errato_msg    constant afc_error.t_error_msg := 'Tipo assegnazione non ammesso per questo componente';
   data_inizio_mancante exception;
   pragma exception_init(data_inizio_mancante, -20918);
   s_data_inizio_mancante_num constant afc_error.t_error_number := -20918;
   s_data_inizio_mancante_msg constant afc_error.t_error_msg := 'Dati incompleti: indicare la data di inizio o la revisione di assegnazione';
   ass_prev_errata exception;
   pragma exception_init(ass_prev_errata, -20919);
   s_ass_prev_errata_num constant afc_error.t_error_number := -20919;
   s_ass_prev_errata_msg constant afc_error.t_error_msg := 'Assegnazione prevalente incompatibile con situazione componente';
   assegnazione_ripetuta exception;
   pragma exception_init(assegnazione_ripetuta, -20920);
   s_assegnazione_ripetuta_num constant afc_error.t_error_number := -20920;
   s_assegnazione_ripetuta_msg constant afc_error.t_error_msg := 'Assegnazione gia'' esistente sulla stessa unita'' organizzativa';
   date_non_modificabili exception;
   pragma exception_init(date_non_modificabili, -20921);
   s_date_non_modificabili_num constant afc_error.t_error_number := -20921;
   s_date_non_modificabili_msg constant afc_error.t_error_msg := 'Assegnazione di origine giuridica. Le date non sono modificabili';
   -- Versione e revisione
   function versione /* SLAVE_COPY */
    return varchar2;
   pragma restrict_references(versione, wnds);
   -- Costruttore di record chiave
   function pk /* SLAVE_COPY */
   (p_id_attr_componente in attributi_componente.id_attr_componente%type) return t_pk;
   pragma restrict_references(pk, wnds);
   -- Controllo integrità chiave
   function can_handle /* SLAVE_COPY */
   (p_id_attr_componente in attributi_componente.id_attr_componente%type) return number;
   pragma restrict_references(can_handle, wnds);
   -- Controllo integrità chiave
   -- wrapper boolean
   function canhandle /* SLAVE_COPY */
   (p_id_attr_componente in attributi_componente.id_attr_componente%type) return boolean;
   pragma restrict_references(canhandle, wnds);
   -- Esistenza riga con chiave indicata
   function exists_id /* SLAVE_COPY */
   (p_id_attr_componente in attributi_componente.id_attr_componente%type) return number;
   pragma restrict_references(exists_id, wnds);
   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   function existsid /* SLAVE_COPY */
   (p_id_attr_componente in attributi_componente.id_attr_componente%type) return boolean;
   pragma restrict_references(existsid, wnds);
   -- Messaggio previsto per il numero di eccezione indicato
   function error_message /* SLAVE_COPY */
   (p_error_number in afc_error.t_error_number) return afc_error.t_error_msg;
   pragma restrict_references(error_message, wnds);
   -- Inserimento di una riga
   procedure ins
   (
      p_id_attr_componente      in attributi_componente.id_attr_componente%type default null
     ,p_id_componente           in attributi_componente.id_componente%type default null
     ,p_dal                     in attributi_componente.dal%type default null
     ,p_al                      in attributi_componente.al%type default null
     ,p_incarico                in attributi_componente.incarico%type default null
     ,p_telefono                in attributi_componente.telefono%type default null
     ,p_fax                     in attributi_componente.fax%type default null
     ,p_e_mail                  in attributi_componente.e_mail%type default null
     ,p_assegnazione_prevalente in attributi_componente.assegnazione_prevalente%type default null
     ,p_tipo_assegnazione       in attributi_componente.tipo_assegnazione%type default null
     ,p_percentuale_impiego     in attributi_componente.percentuale_impiego%type default null
     ,p_ottica                  in attributi_componente.ottica%type default null
     ,p_revisione_assegnazione  in attributi_componente.revisione_assegnazione%type default null
     ,p_revisione_cessazione    in attributi_componente.revisione_cessazione%type default null
     ,p_gradazione              in attributi_componente.gradazione%type default null
     ,p_utente_aggiornamento    in attributi_componente.utente_aggiornamento%type default null
     ,p_data_aggiornamento      in attributi_componente.data_aggiornamento%type default null
     ,p_voto                    in attributi_componente.voto%type default null
     ,p_dal_pubb                in attributi_componente.dal_pubb%type default null
     ,p_al_pubb                 in attributi_componente.al_pubb%type default null
   );
   -- Aggiornamento di una riga
   procedure upd
   (
      p_new_id_attr_componente      in attributi_componente.id_attr_componente%type
     ,p_new_id_componente           in attributi_componente.id_componente%type
     ,p_new_dal                     in attributi_componente.dal%type
     ,p_new_al                      in attributi_componente.al%type
     ,p_new_dal_pubb                in attributi_componente.dal_pubb%type
     ,p_new_al_pubb                 in attributi_componente.al_pubb%type
     ,p_new_incarico                in attributi_componente.incarico%type
     ,p_new_telefono                in attributi_componente.telefono%type
     ,p_new_fax                     in attributi_componente.fax%type
     ,p_new_e_mail                  in attributi_componente.e_mail%type
     ,p_new_assegnazione_prevalente in attributi_componente.assegnazione_prevalente%type
     ,p_new_tipo_assegnazione       in attributi_componente.tipo_assegnazione%type
     ,p_new_percentuale_impiego     in attributi_componente.percentuale_impiego%type
     ,p_new_ottica                  in attributi_componente.ottica%type
     ,p_new_revisione_assegnazione  in attributi_componente.revisione_assegnazione%type
     ,p_new_revisione_cessazione    in attributi_componente.revisione_cessazione%type
     ,p_new_gradazione              in attributi_componente.gradazione%type
     ,p_new_utente_aggiornamento    in attributi_componente.utente_aggiornamento%type
     ,p_new_data_aggiornamento      in attributi_componente.data_aggiornamento%type
     ,p_new_voto                    in attributi_componente.voto%type
     ,p_old_id_attr_componente      in attributi_componente.id_attr_componente%type default null
     ,p_old_id_componente           in attributi_componente.id_componente%type default null
     ,p_old_dal                     in attributi_componente.dal%type default null
     ,p_old_al                      in attributi_componente.al%type default null
     ,p_old_dal_pubb                in attributi_componente.dal_pubb%type default null
     ,p_old_al_pubb                 in attributi_componente.al_pubb%type default null
     ,p_old_incarico                in attributi_componente.incarico%type default null
     ,p_old_telefono                in attributi_componente.telefono%type default null
     ,p_old_fax                     in attributi_componente.fax%type default null
     ,p_old_e_mail                  in attributi_componente.e_mail%type default null
     ,p_old_assegnazione_prevalente in attributi_componente.assegnazione_prevalente%type default null
     ,p_old_tipo_assegnazione       in attributi_componente.tipo_assegnazione%type default null
     ,p_old_percentuale_impiego     in attributi_componente.percentuale_impiego%type default null
     ,p_old_ottica                  in attributi_componente.ottica%type default null
     ,p_old_revisione_assegnazione  in attributi_componente.revisione_assegnazione%type default null
     ,p_old_revisione_cessazione    in attributi_componente.revisione_cessazione%type default null
     ,p_old_gradazione              in attributi_componente.gradazione%type default null
     ,p_old_utente_aggiornamento    in attributi_componente.utente_aggiornamento%type default null
     ,p_old_data_aggiornamento      in attributi_componente.data_aggiornamento%type default null
     ,p_old_voto                    in attributi_componente.voto%type default null
     ,p_check_old                   in integer default 0
   );
   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
      p_id_attr_componente in attributi_componente.id_attr_componente%type
     ,p_column             in varchar2
     ,p_value              in varchar2 default null
     ,p_literal_value      in number default 1
   );
   procedure upd_column
   (
      p_id_attr_componente in attributi_componente.id_attr_componente%type
     ,p_column             in varchar2
     ,p_value              in date
   );
   -- Cancellazione di una riga
   procedure del
   (
      p_id_attr_componente      in attributi_componente.id_attr_componente%type
     ,p_id_componente           in attributi_componente.id_componente%type default null
     ,p_dal                     in attributi_componente.dal%type default null
     ,p_al                      in attributi_componente.al%type default null
     ,p_incarico                in attributi_componente.incarico%type default null
     ,p_telefono                in attributi_componente.telefono%type default null
     ,p_fax                     in attributi_componente.fax%type default null
     ,p_e_mail                  in attributi_componente.e_mail%type default null
     ,p_assegnazione_prevalente in attributi_componente.assegnazione_prevalente%type default null
     ,p_tipo_assegnazione       in attributi_componente.tipo_assegnazione%type default null
     ,p_percentuale_impiego     in attributi_componente.percentuale_impiego%type default null
     ,p_ottica                  in attributi_componente.ottica%type default null
     ,p_revisione_assegnazione  in attributi_componente.revisione_assegnazione%type default null
     ,p_revisione_cessazione    in attributi_componente.revisione_cessazione%type default null
     ,p_gradazione              in attributi_componente.gradazione%type default null
     ,p_utente_aggiornamento    in attributi_componente.utente_aggiornamento%type default null
     ,p_data_aggiornamento      in attributi_componente.data_aggiornamento%type default null
     ,p_voto                    in attributi_componente.voto%type default null
     ,p_dal_pubb                in attributi_componente.dal_pubb%type default null
     ,p_al_pubb                 in attributi_componente.al_pubb%type default null
     ,p_check_old               in integer default 0
   );
   -- Attributo id_componente di riga esistente identificata da chiave
   function get_id_componente /* SLAVE_COPY */
   (p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.id_componente%type;
   pragma restrict_references(get_id_componente, wnds);
   -- Attributo dal di riga esistente identificata da chiave
   function get_dal /* SLAVE_COPY */
   (p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.dal%type;
   pragma restrict_references(get_dal, wnds);
   -- Attributo al di riga esistente identificata da chiave
   function get_al /* SLAVE_COPY */
   (p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.al%type;
   pragma restrict_references(get_al, wnds);
   -- Attributo dal_pubb di riga esistente identificata da chiave
   function get_dal_pubb /* SLAVE_COPY */
   (p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.dal_pubb%type;
   pragma restrict_references(get_dal_pubb, wnds);
   -- Attributo al_pubb di riga esistente identificata da chiave
   function get_al_pubb /* SLAVE_COPY */
   (p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.al_pubb%type;
   pragma restrict_references(get_al_pubb, wnds);
   -- Attributo al_prec di riga esistente identificata da chiave
   function get_al_prec /* SLAVE_COPY */
   (p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.al_prec%type;
   pragma restrict_references(get_al_prec, wnds);
   -- Attributo incarico di riga esistente identificata da chiave
   function get_incarico /* SLAVE_COPY */
   (p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.incarico%type;
   pragma restrict_references(get_incarico, wnds);
   -- Attributo telefono di riga esistente identificata da chiave
   function get_telefono /* SLAVE_COPY */
   (p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.telefono%type;
   pragma restrict_references(get_telefono, wnds);
   -- Attributo fax di riga esistente identificata da chiave
   function get_fax /* SLAVE_COPY */
   (p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.fax%type;
   pragma restrict_references(get_fax, wnds);
   -- Attributo e_mail di riga esistente identificata da chiave
   function get_e_mail /* SLAVE_COPY */
   (p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.e_mail%type;
   pragma restrict_references(get_e_mail, wnds);
   -- Attributo assegnazione_prevalente di riga esistente identificata da chiave
   function get_assegnazione_prevalente /* SLAVE_COPY */
   (p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.assegnazione_prevalente%type;
   pragma restrict_references(get_assegnazione_prevalente, wnds);
   -- Attributo tipo_assegnazione di riga esistente identificata da chiave
   function get_tipo_assegnazione /* SLAVE_COPY */
   (p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.tipo_assegnazione%type;
   pragma restrict_references(get_tipo_assegnazione, wnds);
   -- Attributo percentuale_impiego di riga esistente identificata da chiave
   function get_percentuale_impiego /* SLAVE_COPY */
   (p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.percentuale_impiego%type;
   pragma restrict_references(get_percentuale_impiego, wnds);
   -- Attributo gradazione di riga esistente identificata da chiave
   function get_gradazione /* SLAVE_COPY */
   (p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.gradazione%type;
   pragma restrict_references(get_gradazione, wnds);
   -- Attributo voto di riga esistente identificata da
   -- id_componente e valido alla data indicata
   function get_voto /* SLAVE_COPY */
   (p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.voto%type;
   pragma restrict_references(get_voto, wnds);
   -- Attributo utente_aggiornamento di riga esistente identificata da
   -- id_componente e valido alla data indicata
   function get_utente_aggiornamento /* SLAVE_COPY */
   (p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.utente_aggiornamento%type;
   pragma restrict_references(get_utente_aggiornamento, wnds);
   -- Attributo data_aggiornamento di riga esistente identificata da
   -- id_componente e valido alla data indicata
   function get_data_aggiornamento /* SLAVE_COPY */
   (p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.data_aggiornamento%type;
   pragma restrict_references(get_data_aggiornamento, wnds);
   -- Attributo id_attr_componente di riga esistente identificata da
   -- id_componente e dal
   function get_id_attr_componente /* SLAVE_COPY */
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_dal           in attributi_componente.dal%type
   ) return attributi_componente.id_attr_componente%type;
   pragma restrict_references(get_id_attr_componente, wnds);
   -- Attributo id_attr_componente di riga esistente identificata da
   -- id_componente e valido alla data indicata considerando anche la
   -- revisione in modifica
   function get_id_corrente /* SLAVE_COPY */
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_data          in attributi_componente.dal%type
     ,p_ottica        in attributi_componente.ottica%type
   ) return attributi_componente.id_attr_componente%type;
   pragma restrict_references(get_id_corrente, wnds);
   -- Attributo incarico di riga esistente identificata da
   -- id_componente e valido alla data indicata
   function get_incarico_corrente /* SLAVE_COPY */
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_data          in attributi_componente.dal%type
     ,p_ottica        in attributi_componente.ottica%type
   ) return attributi_componente.incarico%type;
   pragma restrict_references(get_incarico_corrente, wnds);
   -- Attributo assegnazione di riga esistente identificata da
   -- id_componente e valido alla data indicata
   function get_assegnazione_corrente /* SLAVE_COPY */
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_data          in attributi_componente.dal%type
     ,p_ottica        in attributi_componente.ottica%type
   ) return attributi_componente.assegnazione_prevalente%type;
   pragma restrict_references(get_assegnazione_corrente, wnds);
   -- Attributo gradazione di riga esistente identificata da
   -- id_componente e valido alla data indicata
   function get_gradazione_corrente /* SLAVE_COPY */
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_data          in attributi_componente.dal%type
     ,p_ottica        in attributi_componente.ottica%type
   ) return attributi_componente.gradazione%type;
   pragma restrict_references(get_gradazione_corrente, wnds);
   -- Attributo tipo_assegnazione di riga esistente identificata da
   -- id_componente e valido alla data indicata
   function get_tipo_ass_corrente /* SLAVE_COPY */
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_data          in attributi_componente.dal%type
     ,p_ottica        in attributi_componente.ottica%type
   ) return attributi_componente.tipo_assegnazione%type;
   pragma restrict_references(get_tipo_ass_corrente, wnds);
   -- Attributo id_attr_componente di riga esistente identificata da
   -- id_componente e valido alla data indicata senza considerare
   -- la revisione in modifica
   function get_id_valido /* SLAVE_COPY */
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_data          in attributi_componente.dal%type
     ,p_ottica        in attributi_componente.ottica%type
   ) return attributi_componente.id_attr_componente%type;
   pragma restrict_references(get_id_valido, wnds);
   -- Attributo incarico di riga esistente identificata da
   -- id_componente e valido alla data indicata
   function get_incarico_valido /* SLAVE_COPY */
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_data          in attributi_componente.dal%type
     ,p_ottica        in attributi_componente.ottica%type
   ) return attributi_componente.incarico%type;
   pragma restrict_references(get_incarico_valido, wnds);
   -- Attributo assegnazione prevalente di riga esistente identificata da
   -- id_componente e valido alla data indicata
   function get_assegnazione_valida /* SLAVE_COPY */
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_data          in attributi_componente.dal%type
     ,p_ottica        in attributi_componente.ottica%type
   ) return attributi_componente.assegnazione_prevalente%type;
   pragma restrict_references(get_assegnazione_valida, wnds);
   -- Attributo gradazione di riga esistente identificata da
   -- id_componente e valido alla data indicata
   function get_gradazione_valida /* SLAVE_COPY */
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_data          in attributi_componente.dal%type
     ,p_ottica        in attributi_componente.ottica%type
   ) return attributi_componente.gradazione%type;
   pragma restrict_references(get_gradazione_valida, wnds);
   -- Attributo gradazione di riga esistente identificata da
   -- id_componente e valido alla data indicata
   function get_tipo_ass_valido /* SLAVE_COPY */
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_data          in attributi_componente.dal%type
     ,p_ottica        in attributi_componente.ottica%type
   ) return attributi_componente.tipo_assegnazione%type;
   pragma restrict_references(get_tipo_ass_valido, wnds);
   -- Righe corrispondenti alla selezione indicata
   function get_rows /* SLAVE_COPY */
   (
      p_id_attr_componente      in varchar2 default null
     ,p_id_componente           in varchar2 default null
     ,p_dal                     in varchar2 default null
     ,p_al                      in varchar2 default null
     ,p_incarico                in varchar2 default null
     ,p_telefono                in varchar2 default null
     ,p_fax                     in varchar2 default null
     ,p_e_mail                  in varchar2 default null
     ,p_assegnazione_prevalente in varchar2 default null
     ,p_tipo_assegnazione       in varchar2 default null
     ,p_percentuale_impiego     in varchar2 default null
     ,p_ottica                  in varchar2 default null
     ,p_revisione_assegnazione  in varchar2 default null
     ,p_revisione_cessazione    in varchar2 default null
     ,p_gradazione              in varchar2 default null
     ,p_utente_aggiornamento    in varchar2 default null
     ,p_data_aggiornamento      in varchar2 default null
     ,p_other_condition         in varchar2 default null
     ,p_dal_pubb                in varchar2 default null
     ,p_al_pubb                 in varchar2 default null
     ,p_al_prec                 in varchar2 default null
     ,p_qbe                     in number default 0
   ) return afc.t_ref_cursor;
   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   (
      p_id_attr_componente      in varchar2 default null
     ,p_id_componente           in varchar2 default null
     ,p_dal                     in varchar2 default null
     ,p_al                      in varchar2 default null
     ,p_incarico                in varchar2 default null
     ,p_telefono                in varchar2 default null
     ,p_fax                     in varchar2 default null
     ,p_e_mail                  in varchar2 default null
     ,p_assegnazione_prevalente in varchar2 default null
     ,p_tipo_assegnazione       in varchar2 default null
     ,p_percentuale_impiego     in varchar2 default null
     ,p_ottica                  in varchar2 default null
     ,p_revisione_assegnazione  in varchar2 default null
     ,p_revisione_cessazione    in varchar2 default null
     ,p_gradazione              in varchar2 default null
     ,p_utente_aggiornamento    in varchar2 default null
     ,p_data_aggiornamento      in varchar2 default null
     ,p_other_condition         in varchar2 default null
     ,p_dal_pubb                in varchar2 default null
     ,p_al_pubb                 in varchar2 default null
     ,p_al_prec                 in varchar2 default null
     ,p_qbe                     in number default 0
   ) return integer;
   -- Ultimo periodo (dal / al) per il componente
   function get_ultimo_periodo
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_rowid         in rowid
   ) return afc_periodo.t_periodo;
   -- Controlla che il periodo indicato sia l'ultimo per il componente
   function is_ultimo_periodo
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_dal           in attributi_componente.dal%type
   ) return afc_error.t_error_number;
   -- Controllo di congruenza date di inizio e fine validità
   function is_dal_al_ok
   (
      p_dal in attributi_componente.dal%type
     ,p_al  in attributi_componente.al%type
   ) return afc_error.t_error_number;
   -- Controllo di congruenza tipo_assegnazione
   function is_tipo_assegnazione_ok
   (
      p_assegnazione_prevalente in attributi_componente.assegnazione_prevalente%type
     ,p_tipo_assegnazione       in attributi_componente.tipo_assegnazione%type
   ) return afc_error.t_error_number;
   -- controllo congruenza revisioni
   function is_revisioni_ok
   (
      p_revisione_assegnazione in attributi_componente.revisione_assegnazione%type
     ,p_revisione_cessazione   in attributi_componente.revisione_cessazione%type
   ) return afc_error.t_error_number;
   -- function di gestione di Data Integrity
   function is_di_ok
   (
      p_dal                     in attributi_componente.dal%type
     ,p_al                      in attributi_componente.al%type
     ,p_ottica                  in attributi_componente.ottica%type
     ,p_assegnazione_prevalente in attributi_componente.assegnazione_prevalente%type
     ,p_tipo_assegnazione       in attributi_componente.tipo_assegnazione%type
     ,p_revisione_assegnazione  in attributi_componente.revisione_assegnazione%type default null
     ,p_revisione_cessazione    in attributi_componente.revisione_cessazione%type default null
   ) return afc_error.t_error_number;
   -- procedure di gestione di Data Integrity
   procedure chk_di
   (
      p_dal                     in attributi_componente.dal%type
     ,p_al                      in attributi_componente.al%type
     ,p_ottica                  in attributi_componente.ottica%type
     ,p_assegnazione_prevalente in attributi_componente.assegnazione_prevalente%type
     ,p_tipo_assegnazione       in attributi_componente.tipo_assegnazione%type
     ,p_revisione_assegnazione  in attributi_componente.revisione_assegnazione%type default null
     ,p_revisione_cessazione    in attributi_componente.revisione_cessazione%type default null
   );
   -- Controllo validita' dal
   function is_dal_ok
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_old_dal       in attributi_componente.dal%type
     ,p_new_dal       in attributi_componente.dal%type
     ,p_old_al        in attributi_componente.al%type
     ,p_rowid         in rowid
     ,p_inserting     in number
     ,p_updating      in number
   ) return afc_error.t_error_number;
   -- Controllo validita' al
   function is_al_ok
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_old_dal       in attributi_componente.dal%type
     ,p_old_al        in attributi_componente.al%type
     ,p_new_al        in attributi_componente.al%type
     ,p_rowid         in rowid
     ,p_inserting     in number
     ,p_updating      in number
   ) return afc_error.t_error_number;
   -- Controllo validita' assegnazione prevalente
   function is_assegnazione_prevalente_ok
   (
      p_ottica in componenti.ottica%type
     ,p_ni     in componenti.ni%type
     ,p_ci     in componenti.ci%type
     ,p_dal    in attributi_componente.dal%type
     ,p_al     in attributi_componente.al%type
     ,p_data   in attributi_componente.dal%type default null
   ) return afc_error.t_error_number;
   -- Controllo compatibilita assegnazione prevalente
   function is_ass_prev_compatibile
   (
      p_id_componente               in componenti.id_componente%type
     ,p_dal                         in attributi_componente.dal%type
     ,p_assegnazione_prevalente     in attributi_componente.assegnazione_prevalente%type
     ,p_old_assegnazione_prevalente in attributi_componente.assegnazione_prevalente%type
     ,p_inserting                   in number
     ,p_updating                    in number
   ) return afc_error.t_error_number;
   -- Controllo validita' percentuale impiego
   function is_percentuale_impiego_ok
   (
      p_ottica in componenti.ottica%type
     ,p_ni     in componenti.ni%type
     ,p_ci     in componenti.ci%type
     ,p_dal    in attributi_componente.dal%type
     ,p_al     in attributi_componente.al%type
     ,p_data   in attributi_componente.dal%type default null
   ) return afc_error.t_error_number;
   -- Controllo ultimo record
   function is_last_record(p_id_componente in attributi_componente.id_componente%type)
      return afc_error.t_error_number;
   -- function di gestione di Referential Integrity
   function is_ri_ok
   (
      p_id_componente               in attributi_componente.id_componente%type
     ,p_old_dal                     in attributi_componente.dal%type
     ,p_new_dal                     in attributi_componente.dal%type
     ,p_old_al                      in attributi_componente.al%type
     ,p_new_al                      in attributi_componente.al%type
     ,p_rowid                       in rowid
     ,p_inserting                   in number
     ,p_updating                    in number
     ,p_deleting                    in number
     ,p_assegnazione_prevalente     in attributi_componente.assegnazione_prevalente%type
     ,p_old_assegnazione_prevalente in attributi_componente.assegnazione_prevalente%type
     ,p_id_attr_componente          in attributi_componente.id_attr_componente%type
     ,p_tipo_assegnazione           in attributi_componente.tipo_assegnazione%type
     ,p_livello                     in number
   ) return afc_error.t_error_number;
   -- Controllo integrita' referenziale
   procedure chk_ri
   (
      p_id_componente               in attributi_componente.id_componente%type
     ,p_old_dal                     in attributi_componente.dal%type
     ,p_new_dal                     in attributi_componente.dal%type
     ,p_old_al                      in attributi_componente.al%type
     ,p_new_al                      in attributi_componente.al%type
     ,p_rowid                       in rowid
     ,p_inserting                   in number
     ,p_updating                    in number
     ,p_deleting                    in number
     ,p_assegnazione_prevalente     in attributi_componente.assegnazione_prevalente%type
     ,p_old_assegnazione_prevalente in attributi_componente.assegnazione_prevalente%type
     ,p_id_attr_componente          in attributi_componente.id_attr_componente%type
     ,p_tipo_assegnazione           in attributi_componente.tipo_assegnazione%type
     ,p_ottica                      in attributi_componente.ottica%type
     ,p_revisione_assegnazione      in attributi_componente.revisione_assegnazione%type
     ,p_old_revisione_assegnazione  in attributi_componente.revisione_assegnazione%type --#644
     ,p_livello                     in number
   );
   -- Controlla che il componente non abbia gia' un'assegnazione
   -- prevalente nella stessa UO
   function esiste_componente
   (
      p_id_componente             in componenti.id_componente%type
     ,p_ottica                    in componenti.ottica%type
     ,p_progr_unita_organizzativa in componenti.progr_unita_organizzativa%type
     ,p_ni                        in componenti.ni%type
     ,p_ci                        in componenti.ci%type
     ,p_dal                       in componenti.dal%type
     ,p_al                        in componenti.al%type
     ,p_revisione_cessazione      in componenti.revisione_cessazione%type
   ) return afc_error.t_error_number;
   -- Controlla che il componente non periodi di attributi
   -- con tipo_assegnazione diversi
   function is_tipo_assegnazione_ok
   (
      p_id_componente      in componenti.id_componente%type
     ,p_id_attr_componente in attributi_componente.id_attr_componente%type
     ,p_tipo_assegnazione  in attributi_componente.tipo_assegnazione%type
   ) return afc_error.t_error_number;
   -- Controlla che non esistano attributi istituiti o cessati con la
   -- revisione indicata aventi data inizio o fine validità non congruente
   -- con la data della revisione
   function is_attributi_revisione_ok
   (
      p_ottica         in componenti.ottica%type
     ,p_revisione      in componenti.revisione_assegnazione%type
     ,p_data           in componenti.dal%type
     ,p_tipo_controllo in number default 0
   ) return afc_error.t_error_number;
   -- Eliminazione attributi di un componente
   procedure elimina_attributi
   (
      p_id_componente          in attributi_componente.id_componente%type
     ,p_ni                     in componenti.ni%type
     ,p_denominazione          in componenti.denominazione%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );
   -- Annullamento attributi di un componente (revisione_cessazione)
   procedure annulla_attributi
   (
      p_id_componente          in attributi_componente.id_componente%type
     ,p_revisione_cessazione   in attributi_componente.revisione_cessazione%type
     ,p_al                     in attributi_componente.al%type
     ,p_al_pubb                in attributi_componente.al_pubb%type
     ,p_al_prec                in attributi_componente.al_prec%type
     ,p_data_aggiornamento     in attributi_componente.data_aggiornamento%type
     ,p_utente_aggiornamento   in attributi_componente.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );
   -- Aggiornamento attributi di un componente (revisione_cessazione)
   procedure aggiorna_attributi
   (
      p_id_componente          in attributi_componente.id_componente%type
     ,p_revisione_assegnazione in attributi_componente.revisione_cessazione%type
     ,p_dal                    in attributi_componente.dal%type
     ,p_dal_pubb               in attributi_componente.dal_pubb%type
     ,p_data_aggiornamento     in attributi_componente.data_aggiornamento%type
     ,p_utente_aggiornamento   in attributi_componente.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );
   -- Duplica attributi di un componente
   procedure duplica_attributi
   (
      p_old_id_componente      in attributi_componente.id_componente%type
     ,p_new_id_componente      in attributi_componente.id_componente%type
     ,p_revisione              in attributi_componente.revisione_cessazione%type
     ,p_revisione_cessazione   in attributi_componente.revisione_cessazione%type
     ,p_dal                    in attributi_componente.dal%type
     ,p_al                     in attributi_componente.al%type
     ,p_data_aggiornamento     in attributi_componente.data_aggiornamento%type
     ,p_utente_aggiornamento   in attributi_componente.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );
   -- Ripristino attributi di un componente
   procedure ripristina_attributi
   (
      p_id_componente          in attributi_componente.id_componente%type
     ,p_revisione              in attributi_componente.revisione_cessazione%type
     ,p_ni                     in componenti.ni%type
     ,p_denominazione          in componenti.denominazione%type
     ,p_data_aggiornamento     in attributi_componente.data_aggiornamento%type
     ,p_utente_aggiornamento   in attributi_componente.utente_aggiornamento%type
     ,p_rev_cessazione         in number
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   );
   -- Determinazione della data AL
   procedure set_data_al
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_dal           in attributi_componente.dal%type
   );
   -- Aggiornamento data di fine validita' periodo precedente
   procedure set_periodo_precedente
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_revisione     in attributi_componente.revisione_assegnazione%type
     ,p_dal           in attributi_componente.dal%type
     ,p_al            in attributi_componente.al%type
   );
   -- Riapertura ultimo periodo
   procedure set_riapertura_periodo
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_revisione     in attributi_componente.revisione_assegnazione%type
     ,p_dal           in attributi_componente.dal%type
     ,p_al            in attributi_componente.al%type
   );
   -- procedure di settaggio di Functional Integrity
   procedure set_fi
   (
      p_id_componente            in attributi_componente.id_componente%type
     ,p_revisione                in attributi_componente.revisione_assegnazione%type
     ,p_old_revisione            in attributi_componente.revisione_assegnazione%type
     ,p_revisione_cessazione     in attributi_componente.revisione_cessazione%type
     ,p_old_revisione_cessazione in attributi_componente.revisione_cessazione%type
     ,p_old_dal                  in attributi_componente.dal%type
     ,p_dal                      in attributi_componente.dal%type
     ,p_old_al                   in attributi_componente.al%type
     ,p_al                       in attributi_componente.al%type
     ,p_tipo_assegnazione        in attributi_componente.tipo_assegnazione%type
     ,p_assegnazione_prevalente  in attributi_componente.assegnazione_prevalente%type
     ,p_old_incarico             in attributi_componente.incarico%type --#634
     ,p_incarico                 in attributi_componente.incarico%type
     ,p_inserting                in number
     ,p_updating                 in number
     ,p_deleting                 in number
   );
   -- Aggiornamento revisione e date su attributi_componente
   procedure update_atco
   (
      p_ottica    in attributi_componente.ottica%type
     ,p_revisione in attributi_componente.revisione_assegnazione%type
     ,p_data      in attributi_componente.dal%type
   );
   -- valorizza la variabile s_tipo_revisione
   procedure set_tipo_revisione
   (
      p_ottica    in unita_organizzative.ottica%type
     ,p_revisione in unita_organizzative.revisione%type
   );
end attributo_componente;
/

