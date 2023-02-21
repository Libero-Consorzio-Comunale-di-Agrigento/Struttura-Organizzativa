CREATE OR REPLACE package body amministrazione is
   /******************************************************************************
    NOME:        amministrazione
    DESCRIZIONE: Gestione tabella amministrazioni.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore  Descrizione.
    000   19/07/2006  VDAVALLI  Prima emissione.
    001   06/04/2009  VDAVALLI  Modificato agg_automatico per competenza = 'SI4SO'
                                e ni anagrafe da package anagrafe_soggetti_tpk
    002   27/08/2009  VDAVALLI  Modificato per configurazione master/slave
    003   16/06/2011  VDAVALLI  Modificata funzione TROVA per lentezza: al posto
                                della function su INDIRIZZI_TELEMATICI viene usata
                                la join
   ******************************************************************************/

   s_revisione_body constant afc.t_revision := '002';

   s_table_name       constant afc.t_object_name := 'amministrazioni';
   s_desc_column_name constant afc.t_object_name := '';

   s_error_table afc_error.t_error_table;

   --------------------------------------------------------------------------------

   function versione return varchar2 is /* SLAVE_COPY */
      /******************************************************************************
       NOME:        versione
       DESCRIZIONE: Versione e revisione di distribuzione del package.
       RITORNA:     varchar2 stringa contenente versione e revisione.
       NOTE:        Primo numero  : versione compatibilità del Package.
                    Secondo numero: revisione del Package specification.
                    Terzo numero  : revisione del Package body.
      ******************************************************************************/
   begin
      return afc.version(s_revisione, s_revisione_body);
   end; -- amministrazione.versione

   --------------------------------------------------------------------------------

   function pk(p_codice_amministrazione in amministrazioni.codice_amministrazione%type)
      return t_pk is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        PK
       DESCRIZIONE: Costruttore di un t_PK dati gli attributi della chiave
      ******************************************************************************/
      d_result t_pk;
   begin
   
      d_result.codice_amministrazione := p_codice_amministrazione;
      dbc.pre(not dbc.preon or canhandle(d_result.codice_amministrazione)
             ,'canHandle on amministrazione.PK');
      return d_result;
   
   end; -- end amministrazione.PK

   --------------------------------------------------------------------------------

   function can_handle(p_codice_amministrazione in amministrazioni.codice_amministrazione%type)
      return number is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        can_handle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: 1 se la chiave è manipolabile, 0 altrimenti.
       NOTE:        cfr. canHandle per ritorno valori boolean.
      ******************************************************************************/
      d_result number;
   begin
      d_result := 1;
   
      -- nelle chiavi primarie composte da più attributi, ciascun attributo deve essere not null
      if d_result = 1 and (p_codice_amministrazione is null) then
         d_result := 0;
      end if;
   
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on amministrazione.can_handle');
   
      return d_result;
   
   end; -- amministrazione.can_handle

   --------------------------------------------------------------------------------

   function canhandle(p_codice_amministrazione in amministrazioni.codice_amministrazione%type)
      return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        canHandle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: true se la chiave è manipolabile, false altrimenti.
       NOTE:        Wrapper boolean di can_handle (cfr. can_handle).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(can_handle(p_codice_amministrazione));
   begin
      return d_result;
   end; -- amministrazione.canHandle

   --------------------------------------------------------------------------------

   function exists_id(p_codice_amministrazione in amministrazioni.codice_amministrazione%type)
      return number is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        exists_id
       DESCRIZIONE: Esistenza riga con chiave indicata.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: 1 se la riga esiste, 0 altrimenti.
       NOTE:        cfr. existsId per ritorno valori boolean.
      ******************************************************************************/
      d_result number;
   begin
   
      dbc.pre(not dbc.preon or canhandle(p_codice_amministrazione)
             ,'canHandle on amministrazione.exists_id');
   
      begin
         select 1
           into d_result
           from amministrazioni
          where codice_amministrazione = p_codice_amministrazione;
      exception
         when no_data_found then
            d_result := 0;
      end;
   
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on amministrazione.exists_id');
   
      return d_result;
   end; -- amministrazione.exists_id

   --------------------------------------------------------------------------------

   function existsid(p_codice_amministrazione in amministrazioni.codice_amministrazione%type)
      return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        existsId
       DESCRIZIONE: Esistenza riga con chiave indicata.
       NOTE:        Wrapper boolean di exists_id (cfr. exists_id).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(exists_id(p_codice_amministrazione));
   begin
      return d_result;
   end; -- amministrazione.existsId

   --------------------------------------------------------------------------------

   function error_message(p_error_number in afc_error.t_error_number)
      return afc_error.t_error_msg is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        error_message
       DESCRIZIONE: Messaggio previsto per il numero di eccezione indicato.
       NOTE:        Restituisce il messaggio abbinato al numero indicato nella tabella
                    s_error_table del Package.
      ******************************************************************************/
      d_result constant afc_error.t_error_msg := s_error_table(p_error_number);
   begin
      return d_result;
   end; -- anagrafe_unita_organizzativa.error_message

   --------------------------------------------------------------------------------

   procedure ins
   (
      p_codice_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_ni                     in amministrazioni.ni%type default null
     ,p_data_istituzione       in amministrazioni.data_istituzione%type default null
     ,p_data_soppressione      in amministrazioni.data_soppressione%type default null
     ,p_ente                   in amministrazioni.ente%type
     ,p_utente_aggiornamento   in amministrazioni.utente_aggiornamento%type default null
     ,p_data_aggiornamento     in amministrazioni.data_aggiornamento%type default null
   ) is
      /******************************************************************************
       NOME:        ins
       DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
       PARAMETRI:   Chiavi e attributi della table.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or not existsid(p_codice_amministrazione)
             ,'not existsId on amministrazione.ins');
   
      insert into amministrazioni
         (codice_amministrazione
         ,ni
         ,data_istituzione
         ,data_soppressione
         ,ente
         ,utente_aggiornamento
         ,data_aggiornamento)
      values
         (upper(p_codice_amministrazione)
         ,p_ni
         ,p_data_istituzione
         ,p_data_soppressione
         ,p_ente
         ,p_utente_aggiornamento
         ,p_data_aggiornamento);
   
   end; -- amministrazione.ins

   --------------------------------------------------------------------------------

   procedure upd
   (
      p_new_codice_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_new_ni                     in amministrazioni.ni%type
     ,p_new_data_istituzione       in amministrazioni.data_istituzione%type default null
     ,p_new_data_soppressione      in amministrazioni.data_soppressione%type default null
     ,p_new_ente                   in amministrazioni.ente%type
     ,p_new_utente_aggiornamento   in amministrazioni.utente_aggiornamento%type
     ,p_new_data_aggiornamento     in amministrazioni.data_aggiornamento%type
     ,p_old_codice_amministrazione in amministrazioni.codice_amministrazione%type default null
     ,p_old_ni                     in amministrazioni.ni%type
     ,p_old_data_istituzione       in amministrazioni.data_istituzione%type default null
     ,p_old_data_soppressione      in amministrazioni.data_soppressione%type default null
     ,p_old_ente                   in amministrazioni.ente%type default null
     ,p_old_utente_aggiornamento   in amministrazioni.utente_aggiornamento%type default null
     ,p_old_data_aggiornamento     in amministrazioni.data_aggiornamento%type default null
     ,p_check_old                  in integer default 0
   ) is
      /******************************************************************************
       NOME:        upd
       DESCRIZIONE: Aggiornamento di una riga con chiave.
       PARAMETRI:   Chiavi e attributi della table
                    p_check_OLD: 0, ricerca senza controllo su attributi precedenti
                                 1, ricerca con controllo anche su attributi precedenti.
      
       NOTE:        Nel caso in cui non venga elaborato alcun record viene lanciata
                    l'eccezione -20010 (cfr. AFC_ERROR).
                    Se p_check_old = 1, viene controllato se il record corrispondente a
                    tutti i campi passati come parametri esiste nella tabella.
      ******************************************************************************/
      d_key       t_pk;
      d_row_found number;
   begin
   
      dbc.pre(not dbc.preon or
              not ((p_old_ni is not null or p_old_utente_aggiornamento is not null or
               p_old_data_aggiornamento is not null) and p_check_old = 0)
             ,' <OLD values> is not null on amministrazione.upd');
   
      dbc.pre(not dbc.preon or p_check_old is not null
             ,'p_check_OLD is not null on amministrazione.upd');
   
      d_key := pk(nvl(p_old_codice_amministrazione, p_new_codice_amministrazione));
   
      dbc.pre(not dbc.preon or existsid(d_key.codice_amministrazione)
             ,'existsId on amministrazione.upd');
   
      update amministrazioni
         set codice_amministrazione = p_new_codice_amministrazione
            ,ni                     = p_new_ni
            ,data_istituzione       = p_new_data_istituzione
            ,data_soppressione      = p_new_data_soppressione
            ,ente                   = p_new_ente
            ,utente_aggiornamento   = p_new_utente_aggiornamento
            ,data_aggiornamento     = p_new_data_aggiornamento
       where codice_amministrazione = d_key.codice_amministrazione
         and (p_check_old = 0 or
             p_check_old = 1 and (ni = p_old_ni or ni is null and p_old_ni is null) and
             (data_istituzione = p_old_data_istituzione or
             data_istituzione is null and p_old_data_istituzione is null) and
             (data_soppressione = p_old_data_soppressione or
             data_soppressione is null and p_old_data_soppressione is null) and
             (ente = p_old_ente or ente is null and p_old_ente is null) and
             (utente_aggiornamento = p_old_utente_aggiornamento or
             utente_aggiornamento is null and p_old_utente_aggiornamento is null) and
             (data_aggiornamento = p_old_data_aggiornamento or
             data_aggiornamento is null and p_old_data_aggiornamento is null));
      d_row_found := sql%rowcount;
   
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on amministrazione.upd');
   
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   
   end; -- amministrazione.upd

   --------------------------------------------------------------------------------

   procedure upd_column
   (
      p_codice_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_column                 in varchar2
     ,p_value                  in varchar2 default null
     ,p_literal_value          in number default 1
   ) is
      /******************************************************************************
       NOME:        upd_column
       DESCRIZIONE: Aggiornamento del campo p_column col valore p_value.
       PARAMETRI:   p_column:        identificatore del campo da aggiornare.
                    p_value:         valore da modificare.
                    p_literal_value: indica se il valore è un stringa e non un numero
                                     o una funzione.
      ******************************************************************************/
      d_statement afc.t_statement;
      d_literal   varchar2(2);
   begin
   
      dbc.pre(not dbc.preon or existsid(p_codice_amministrazione)
             ,'existsId on amministrazione.upd_column');
      dbc.pre(not dbc.preon or p_column is not null
             ,'p_column is not null on amministrazione.upd_column');
      dbc.pre(not dbc.preon or afc_ddl.hasattribute(s_table_name, p_column)
             ,'AFC_DDL.HasAttribute on amministrazione.upd_column');
      dbc.pre(p_literal_value in (0, 1)
             ,'p_literal_value in ( 0, 1 ) on amministrazione.upd_column; p_literal_value = ' ||
              p_literal_value);
   
      if p_literal_value = 1 then
         d_literal := '''';
      end if;
   
      d_statement := 'begin ' || '   update amministrazioni' || '   set    ' || p_column ||
                     ' = ' || d_literal || p_value || d_literal ||
                     '   where  codice_amministrazione = ''' || p_codice_amministrazione || '''' ||
                     '   ;' || 'end;';
   
      execute immediate d_statement;
   
   end; -- amministrazione.upd_column

   --------------------------------------------------------------------------------

   procedure upd_column
   (
      p_codice_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_column                 in varchar2
     ,p_value                  in date
   ) is
      /******************************************************************************
       NOME:        upd_column
       DESCRIZIONE: Aggiornamento del campo p_column col valore p_value.
       
       NOTE:        Richiama se stessa con il parametro date convertito in stringa.
      ******************************************************************************/
      d_data varchar2(19);
   begin
      d_data := to_char(p_value, 'dd/mm/yyyy hh24:mi:ss');
      upd_column(p_codice_amministrazione
                ,p_column
                ,'to_date( ''' || d_data || ''', ''dd/mm/yyyy hh24:mi:ss'')'
                ,0);
   end; -- amministrazione.upd_column

   --------------------------------------------------------------------------------

   procedure del
   (
      p_codice_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_ni                     in amministrazioni.ni%type default null
     ,p_data_istituzione       in amministrazioni.data_istituzione%type default null
     ,p_data_soppressione      in amministrazioni.data_soppressione%type default null
     ,p_ente                   in amministrazioni.ente%type default null
     ,p_utente_aggiornamento   in amministrazioni.utente_aggiornamento%type default null
     ,p_data_aggiornamento     in amministrazioni.data_aggiornamento%type default null
     ,p_check_old              in integer default 0
   ) is
      /******************************************************************************
       NOME:        del
       DESCRIZIONE: Cancellazione della riga indicata.
       PARAMETRI:   Chiavi e attributi della table.
                    p_check_OLD: 0, ricerca senza controllo su attributi precedenti
                                 1, ricerca con controllo anche su attributi precedenti.
      
       NOTE:        Nel caso in cui non venga elaborato alcun record viene lanciata
                    l'eccezione -20010 (cfr. AFC_ERROR).
                    Se p_check_old = 1, viene controllato se il record corrispondente a
                    tutti i campi passati come parametri esiste nella tabella.
      ******************************************************************************/
      d_row_found number;
   begin
   
      dbc.pre(not dbc.preon or
              not ((p_ni is not null or p_data_istituzione is not null or
               p_data_soppressione is not null or p_ente is not null or
               p_utente_aggiornamento is not null or
               p_data_aggiornamento is not null) and p_check_old = 0)
             ,' <OLD values> is not null on amministrazione.del');
   
      dbc.pre(not dbc.preon or existsid(p_codice_amministrazione)
             ,'existsId on amministrazione.upd');
   
      delete from amministrazioni
       where codice_amministrazione = p_codice_amministrazione
         and (p_check_old = 0 or
             p_check_old = 1 and (ni = p_ni or ni is null and p_ni is null) and
             (data_istituzione = p_data_istituzione or
             data_istituzione is null and p_data_istituzione is null) and
             (data_soppressione = p_data_soppressione or
             data_soppressione is null and p_data_soppressione is null) and
             (ente = p_ente or ente is null and p_ente is null) and
             (utente_aggiornamento = p_utente_aggiornamento or
             utente_aggiornamento is null and p_utente_aggiornamento is null) and
             (data_aggiornamento = p_data_aggiornamento or
             data_aggiornamento is null and p_data_aggiornamento is null));
      d_row_found := sql%rowcount;
   
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on amministrazione.del');
   
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   
      dbc.post(not dbc.poston or not existsid(p_codice_amministrazione)
              ,'existsId on amministrazione.del');
   
   end; -- amministrazione.del

   --------------------------------------------------------------------------------

   function get_ni(p_codice_amministrazione in amministrazioni.codice_amministrazione%type)
      return amministrazioni.ni%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_ni
       DESCRIZIONE: Attributo ni di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     amministrazioni.ni%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result amministrazioni.ni%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_codice_amministrazione)
             ,'existsId on amministrazione.get_ni');
   
      select ni
        into d_result
        from amministrazioni
       where codice_amministrazione = p_codice_amministrazione;
   
      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on Amministrazione.get_ni');
      return d_result;
   end; -- amministrazione.get_ni

   --------------------------------------------------------------------------------

   function get_data_istituzione(p_codice_amministrazione in amministrazioni.codice_amministrazione%type)
      return amministrazioni.data_istituzione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_data_istituzione
       DESCRIZIONE: Attributo data_istituzione di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     amministrazioni.data_istituzione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result amministrazioni.data_istituzione%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_codice_amministrazione)
             ,'existsId on amministrazione.get_data_istituzione');
   
      select data_istituzione
        into d_result
        from amministrazioni
       where codice_amministrazione = p_codice_amministrazione;
   
      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on Amministrazione.get_data_istituzione');
      return d_result;
   end; -- amministrazione.get_data_istituzione

   --------------------------------------------------------------------------------

   function get_data_soppressione(p_codice_amministrazione in amministrazioni.codice_amministrazione%type)
      return amministrazioni.data_soppressione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_data_soppressione
       DESCRIZIONE: Attributo data_soppressione di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     amministrazioni.data_soppressione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result amministrazioni.data_soppressione%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_codice_amministrazione)
             ,'existsId on amministrazione.get_data_soppressione');
   
      select data_soppressione
        into d_result
        from amministrazioni
       where codice_amministrazione = p_codice_amministrazione;
   
      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on Amministrazione.get_data_soppressione');
      return d_result;
   end; -- amministrazione.get_data_soppressione

   --------------------------------------------------------------------------------

   function get_ente(p_codice_amministrazione in amministrazioni.codice_amministrazione%type)
      return amministrazioni.ente%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_ente
       DESCRIZIONE: Attributo ente di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     amministrazioni.ente%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result amministrazioni.ente%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_codice_amministrazione)
             ,'existsId on amministrazione.get_ente');
   
      select ente
        into d_result
        from amministrazioni
       where codice_amministrazione = p_codice_amministrazione;
   
      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on Amministrazione.get_ente');
      return d_result;
   end; -- amministrazione.get_ente

   --------------------------------------------------------------------------------

   function get_utente_aggiornamento(p_codice_amministrazione in amministrazioni.codice_amministrazione%type)
      return amministrazioni.utente_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_utente_aggiornamento
       DESCRIZIONE: Attributo utente_aggiornamento di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ammistrazioni.utente_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result amministrazioni.utente_aggiornamento%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_codice_amministrazione)
             ,'existsId on ammistrazione.get_utente_aggiornamento');
   
      select utente_aggiornamento
        into d_result
        from amministrazioni
       where codice_amministrazione = p_codice_amministrazione;
   
      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on Ammistrazione.get_utente_aggiornamento');
      return d_result;
   end; -- amministrazione.get_utente_aggiornamento

   --------------------------------------------------------------------------------

   function get_data_aggiornamento(p_codice_amministrazione in amministrazioni.codice_amministrazione%type)
      return amministrazioni.data_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_data_aggiornamento
       DESCRIZIONE: Attributo data_aggiornamento di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     amministrazione.data_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result amministrazioni.data_aggiornamento%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_codice_amministrazione)
             ,'existsId on amministrazione.get_data_aggiornamento');
   
      select data_aggiornamento
        into d_result
        from amministrazioni
       where codice_amministrazione = p_codice_amministrazione;
   
      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on Amministrazione.get_data_aggiornamento');
      return d_result;
   end; -- amministrazione.get_data_aggiornamento

   --------------------------------------------------------------------------------

   function get_rows
   (
      p_codice_amministrazione in amministrazioni.codice_amministrazione%type default null
     ,p_ni                     in amministrazioni.ni%type default null
     ,p_data_istituzione       in amministrazioni.data_istituzione%type default null
     ,p_data_soppressione      in amministrazioni.data_soppressione%type default null
     ,p_ente                   in amministrazioni.ente%type default null
     ,p_utente_aggiornamento   in amministrazioni.utente_aggiornamento%type default null
     ,p_data_aggiornamento     in amministrazioni.data_aggiornamento%type default null
     ,p_order_condition        in varchar2 default null
     ,p_qbe                    in number default 0
   ) return afc.t_ref_cursor is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_rows
       DESCRIZIONE: Ritorna il risultato di una query in base ai valori che passiamo. 
       PARAMETRI:   Chiavi e attributi della table
                    p_order_condition
                    p_QBE 0: se l'operatore da utilizzare nella where-condition è
                             quello di default ('=')
                          1: se l'operatore da utilizzare nella where-condition è
                             quello specificato per ogni attributo.
      
       RITORNA:     Un ref_cursor che punta al risultato della query.
       NOTE:        Se p_QBE = 1 , ogni parametro deve contenere, nella prima parte,
                    l'operatore da utilizzare nella where-condition.
      ******************************************************************************/
      d_statement  afc.t_statement;
      d_ref_cursor afc.t_ref_cursor;
   begin
   
      d_statement := ' select * from amministrazioni ' || ' where 1 = 1 ' ||
                     afc.get_field_condition(' and ( codice_amministrazione '
                                            ,p_codice_amministrazione
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( ni ', p_ni, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( data_istituzione '
                                            ,p_data_istituzione
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( data_soppressione '
                                            ,p_data_soppressione
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( ente ', p_ente, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( utente_aggiornamento '
                                            ,p_utente_aggiornamento
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( data_aggiornamento '
                                            ,p_data_aggiornamento
                                            ,' )'
                                            ,p_qbe) ||
                     afc.decode_value(p_order_condition
                                     ,null
                                     ,' '
                                     ,' order by ' || p_order_condition);
   
      open d_ref_cursor for d_statement;
   
      return d_ref_cursor;
   
   end; -- amministrazione.get_rows

   --------------------------------------------------------------------------------

   function count_rows
   (
      p_codice_amministrazione in amministrazioni.codice_amministrazione%type default null
     ,p_ni                     in amministrazioni.ni%type default null
     ,p_data_istituzione       in amministrazioni.data_istituzione%type default null
     ,p_data_soppressione      in amministrazioni.data_soppressione%type default null
     ,p_ente                   in amministrazioni.ente%type default null
     ,p_utente_aggiornamento   in amministrazioni.utente_aggiornamento%type default null
     ,p_data_aggiornamento     in amministrazioni.data_aggiornamento%type default null
     ,p_qbe                    in number default 0
   ) return integer is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        count_rows
       DESCRIZIONE: Ritorna il numero di righe della tabella gli attributi delle quali
                    rispettano i valori indicati.
       PARAMETRI:   Almeno uno dei parametri della tabella.
                    p_QBE
       RITORNA:     Numero di righe che rispettano la selezione indicata.
      ******************************************************************************/
      d_result    integer;
      d_statement afc.t_statement;
   begin
   
      d_statement := ' select count( * ) from amministrazioni ' || ' where 1 = 1 ' ||
                     afc.get_field_condition(' and ( codice_amministrazione '
                                            ,p_codice_amministrazione
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( ni ', p_ni, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( data_istituzione '
                                            ,p_data_istituzione
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( data_soppressione '
                                            ,p_data_soppressione
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( ente ', p_ente, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( utente_aggiornamento '
                                            ,p_utente_aggiornamento
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( data_aggiornamento '
                                            ,p_data_aggiornamento
                                            ,' )'
                                            ,p_qbe);
   
      d_result := afc.sql_execute(d_statement);
   
      return d_result;
   end; -- amministrazione.count_rows

   --------------------------------------------------------------------------------

   function trova
   (
      p_codice               in amministrazioni.codice_amministrazione%type
     ,p_ni                   in amministrazioni.ni%type
     ,p_denominazione        in as4_anagrafe_soggetti.cognome%type
     ,p_indirizzo            in as4_anagrafe_soggetti.indirizzo_res%type
     ,p_cap                  in as4_anagrafe_soggetti.cap_res%type
     ,p_citta                in varchar2
     ,p_provincia            in varchar2
     ,p_regione              in varchar2
     ,p_sito_istituzionale   in as4_anagrafe_soggetti.indirizzo_web%type
     ,p_indirizzo_telematico in indirizzi_telematici.indirizzo%type
     ,p_data_riferimento     in amministrazioni.data_istituzione%type default trunc(sysdate)
   ) return afc.t_ref_cursor is
      /* SLAVE_COPY */
      /******************************************************************************
       nome:        trova
       descrizione: trova le amministrazioni che soddisfano le condizioni di ricerca
                    passate.
                    Lavora su amministrazione valide alla data di riferimento.
       parametri:   p_codice                  in amministrazioni.codice_amministrazione%type
                    p_ni                      in as4_anagrafe_soggetti.ni%type
                    p_denominazione           in as4_anagrafe_soggetti.cognome%type
                    p_indirizzo               in as4_anagrafe_soggetti.indirizzo_res%type
                    p_cap                     in as4_anagrafe_soggetti.cap_res%type
                    p_citta                   in varchar2
                    p_provincia               in varchar2
                    p_regione               in varchar2
                    p_indirizzo_telematico    in indirizzi_telematici.indirizzo%type
                    p_data_riferimento        in amministrazioni.data_istituzione%type
                                              date dalla alla quale la registrazione
                                              deve essere valida.
       ritorna:     restituisce i record trovati in amministrazioni
       note:
       revisioni:
       rev. data        autore      descrizione
       ---- ----------  ------      ------------------------------------------------------
       0    27/02/2006   sc          a14999. per j-protocollo.
      ******************************************************************************/
      p_ammi_rc              afc.t_ref_cursor;
      ddatariferimento       date;
      ddataal                date;
      dsiglaprovincia        varchar2(32000);
      dcodiceprovincia       ad4_province.provincia%type;
      dcodiceregione         ad4_regioni.regione%type;
      dcodicecomune          ad4_comuni.comune%type;
      dcap                   ad4_comuni.cap%type;
      dtempcap               ad4_comuni.cap%type;
      ddenominazione         varchar2(32000);
      dindirizzo             varchar2(32000);
      dsitoistituzionale     varchar2(32000);
      dindirizzotelematico   varchar2(32000);
      dcodiceamministrazione varchar2(32000);
      dsql                   varchar2(32767);
      dwhere                 varchar2(32767) := 'where ';
      ddatarifdal            varchar2(100);
      ddatarifal             varchar2(100);
   begin
      ddenominazione         := upper(p_denominazione);
      dindirizzo             := upper(p_indirizzo);
      dsitoistituzionale     := upper(p_sito_istituzionale);
      dindirizzotelematico   := upper(p_indirizzo_telematico);
      dcodiceamministrazione := upper(p_codice);
      ddatariferimento       := nvl(p_data_riferimento, trunc(sysdate));
      dcap                   := p_cap;
      dsiglaprovincia        := upper(p_provincia);
      ddataal                := trunc(sysdate);
   
      if ddatariferimento > ddataal then
         ddataal := ddatariferimento;
      end if;
   
      ddatarifdal := ' to_date(''' || to_char(ddatariferimento, 'dd/mm/yyyy') ||
                     ''', ''dd/mm/yyyy'')';
      ddatarifal  := ' to_date(''' || to_char(ddataal, 'dd/mm/yyyy') ||
                     ''', ''dd/mm/yyyy'')';
      dsql        := 'select sogg.ni, sogg.dal from amministrazioni ammi, as4_storico_dati_soggetto sogg ';
      dwhere      := dwhere || ' ammi.ni = sogg.ni ' || ' and ' || ddatarifdal ||
                     ' between sogg.dal and nvl(sogg.al, ' || ddatarifal || ') ';
   
      if dcodiceamministrazione is not null then
         dcodiceamministrazione := dcodiceamministrazione || '%';
         dwhere                 := dwhere || 'and upper(codice_amministrazione) like ''' ||
                                   dcodiceamministrazione || ''' ';
      end if;
   
      if dindirizzo is not null then
         dindirizzo := dindirizzo || '%';
         dwhere     := dwhere || 'and upper(sogg.indirizzo_res) like ''' || dindirizzo ||
                       ''' ';
      end if;
   
      if dsitoistituzionale is not null then
         dsitoistituzionale := dsitoistituzionale || '%';
         dwhere             := dwhere || 'and upper(sogg.indirizzo_web) like ''' ||
                               dsitoistituzionale || ''' ';
      end if;
   
      if ddenominazione is not null then
         ddenominazione := ddenominazione || '%';
         dwhere         := dwhere || 'and sogg.cognome like ''' || ddenominazione ||
                           ''' ';
      end if;
   
      /*      IF dindirizzotelematico IS NOT NULL
      THEN
         dindirizzotelematico := dindirizzotelematico || '%';
         dwhere :=
               dwhere
            || 'and upper(INDIRIZZO_TELEMATICO.GET_INDIRIZZO'
            || '(INDIRIZZO_TELEMATICO.GET_CHIAVE(''AM'',ammi.ni,'
            || ''''','''', ''I''))) like '''
            || dindirizzotelematico
            || ''' ';
      END IF;*/
   
      if dindirizzotelematico is not null then
         dsql                 := dsql || ', indirizzi_telematici inte ';
         dindirizzotelematico := dindirizzotelematico || '%';
         dwhere               := dwhere || 'and upper(inte.INDIRIZZO) LIKE upper(''' ||
                                 dindirizzotelematico ||
                                 ''') and inte.TIPO_ENTITA = ''AM'' and inte.TIPO_INDIRIZZO = ''I'' and inte.ID_AMMINISTRAZIONE = sogg.ni ';
      end if;
   
      if p_citta is not null then
         dcodicecomune := ad4_comune.get_comune(p_denominazione   => p_citta
                                               ,p_sigla_provincia => dsiglaprovincia
                                               ,p_soppresso       => ad4_comune.is_soppresso(p_denominazione   => p_citta
                                                                                            ,p_sigla_provincia => dsiglaprovincia));
      end if;
   
      if p_regione is not null then
         dcodiceregione := ad4_regione.get_regione(p_denominazione => p_regione);
      end if;
   
      if dsiglaprovincia is not null then
         dsql := dsql || ', ad4_provincie prov ';
         dsql := dsql || dwhere;
         dsql := dsql || 'and sogg.provincia_res = prov.provincia ';
         dsql := dsql || 'and prov.sigla = ''' || dsiglaprovincia || ''' ';
      else
         dsql := dsql || dwhere;
      end if;
   
      if dcodicecomune is not null then
         dsql := dsql || 'and sogg.comune_res = ''' || dcodicecomune || ''' ';
      end if;
   
      if dcodiceprovincia is not null then
         dsql := dsql || 'and sogg.provincia_res = ''' || dcodiceprovincia || ''' ';
      end if;
   
      if dcodiceregione is not null then
         dsql := dsql || 'and sogg.regione_res = ''' || dcodiceregione || ''' ';
      
         if dsiglaprovincia is null then
            for c in (select provincia from ad4_province where regione = dcodiceregione)
            loop
               dsiglaprovincia := dsiglaprovincia || ',' || c.provincia;
            end loop;
         
            dsiglaprovincia := substr(dsiglaprovincia, 2);
            dsql            := dsql || 'and sogg.provincia_res in (' || dsiglaprovincia || ') ';
         end if;
      end if;
   
      if dcap is not null then
         dsql := dsql || 'and sogg.cap_res = ''' || dcap || ''' ';
      end if;
   
      if nvl(p_ni, 0) > 0 then
         dsql := dsql || ' and sogg.ni = ' || p_ni;
      end if;
   
      /*      DBMS_OUTPUT.put_line (SUBSTR (dsql, 1, 255));
      DBMS_OUTPUT.put_line (SUBSTR (dsql, 256, 255));
      DBMS_OUTPUT.put_line (SUBSTR (dsql, 511, 255));*/
   
      open p_ammi_rc for dsql;
   
      return p_ammi_rc;
   end trova;

   --------------------------------------------------------------------------------

   procedure agg_automatico
   (
      p_codice_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_descrizione            in as4_anagrafe_soggetti.nome%type
     ,p_indirizzo              in as4_anagrafe_soggetti.indirizzo_res%type
     ,p_cap                    in as4_anagrafe_soggetti.cap_res%type
     ,p_localita               in varchar2
     ,p_provincia              in varchar2
     ,p_telefono               in as4_anagrafe_soggetti.tel_res%type
     ,p_fax                    in as4_anagrafe_soggetti.fax_res%type
     ,p_mail_istituzionale     in indirizzi_telematici.indirizzo%type
     ,p_data_istituzione       in as4_anagrafe_soggetti.dal%type
     ,p_data_soppressione      in as4_anagrafe_soggetti.al%type
     ,p_utente_aggiornamento   in aoo.utente_aggiornamento%type
     ,p_data_aggiornamento     in aoo.data_aggiornamento%type
   ) is
      /******************************************************************************
       NOME:        agg_automatico
       DESCRIZIONE: Verifica se i dati passati sono stati modificati;
                    in caso affermativo si esegue una storicizzazione
                    altrimenti non si esegue alcuna operazione
                    Se i dati non esistevano vengono inseriti
                    - 
       RITORNA:     -
      ******************************************************************************/
      d_codice_amm        amministrazioni.codice_amministrazione%type;
      d_ni                amministrazioni.ni%type;
      d_ente              amministrazioni.ente%type;
      d_data_soppressione amministrazioni.data_soppressione%type;
      d_codice_comune     as4_anagrafe_soggetti.comune_res%type;
      d_codice_provincia  as4_anagrafe_soggetti.provincia_res%type;
      d_aggiornamento     number(1);
      uscita exception;
      pragma autonomous_transaction;
   
   begin
      begin
         select codice_amministrazione
               ,ni
               ,ente
               ,data_soppressione
           into d_codice_amm
               ,d_ni
               ,d_ente
               ,d_data_soppressione
           from amministrazioni
          where codice_amministrazione = upper(ltrim(rtrim(p_codice_amministrazione)));
      exception
         when no_data_found then
            d_codice_amm        := null;
            d_ni                := null;
            d_ente              := 'NO';
            d_data_soppressione := null;
         when others then
            raise_application_error(-20999
                                   ,'Errore in lettura amministrazione ' ||
                                    p_codice_amministrazione || ' - ' || sqlerrm);
      end;
      --
      -- Se i dati si riferiscono ad una amministrazione di un ente proprietario
      -- non si esegue nessuna operazione
      --  
      if d_ente = 'SI' then
         raise uscita;
      end if;
      --
      -- Ricerca codice comune
      --
      begin
         select comu.comune
               ,comu.provincia_stato
           into d_codice_comune
               ,d_codice_provincia
           from ad4_comuni    comu
               ,ad4_provincie prov
          where comu.denominazione = upper(rtrim(ltrim(p_localita)))
            and comu.provincia_stato = prov.provincia
            and prov.sigla = nvl(upper(rtrim(ltrim(p_provincia))), prov.sigla)
            and comu.data_soppressione is null
            and comu.provincia_fusione is null
            and comu.comune_fusione is null;
      exception
         when others then
            d_codice_comune    := null;
            d_codice_provincia := null;
      end;
      --
      -- Ricerca codice provincia
      --
      if d_codice_provincia is null then
         begin
            select prov.provincia
              into d_codice_provincia
              from ad4_provincie prov
             where prov.sigla = upper(rtrim(ltrim(p_provincia)));
         exception
            when others then
               d_codice_provincia := null;
         end;
      end if;
      --
      d_aggiornamento := 0;
      if d_codice_amm is null then
         as4_anagrafe_soggetti_pkg.init_ni(d_ni);
         as4_anagrafe_soggetti_tpk.ins(p_ni                   => d_ni
                                      ,p_dal                  => nvl(p_data_istituzione
                                                                    ,trunc(sysdate))
                                      ,p_cognome              => upper(rtrim(ltrim(p_descrizione)))
                                      ,p_indirizzo_res        => upper(rtrim(ltrim(p_indirizzo)))
                                      ,p_provincia_res        => d_codice_provincia
                                      ,p_comune_res           => d_codice_comune
                                      ,p_cap_res              => p_cap
                                      ,p_tel_res              => p_telefono
                                      ,p_fax_res              => p_fax
                                      ,p_tipo_soggetto        => 'E'
                                      ,p_utente               => p_utente_aggiornamento
                                      ,p_data_agg             => p_data_aggiornamento
                                      ,p_competenza           => 'SI4SO'
                                      ,p_competenza_esclusiva => 'E');
         amministrazione.ins(p_codice_amministrazione => upper(rtrim(ltrim(p_codice_amministrazione)))
                            ,p_ni                     => d_ni
                            ,p_data_istituzione       => nvl(p_data_istituzione
                                                            ,trunc(sysdate))
                            ,p_data_soppressione      => p_data_soppressione
                            ,p_ente                   => 'NO'
                            ,p_utente_aggiornamento   => p_utente_aggiornamento
                            ,p_data_aggiornamento     => p_data_aggiornamento);
         indirizzo_telematico.agg_automatico(p_tipo_entita          => 'AM'
                                            ,p_id_amministrazione   => d_ni
                                            ,p_tipo_indirizzo       => 'I'
                                            ,p_indirizzo            => rtrim(ltrim(p_mail_istituzionale))
                                            ,p_utente_aggiornamento => p_utente_aggiornamento
                                            ,p_data_aggiornamento   => p_data_aggiornamento);
      else
         indirizzo_telematico.agg_automatico(p_tipo_entita          => 'AM'
                                            ,p_id_amministrazione   => d_ni
                                            ,p_tipo_indirizzo       => 'I'
                                            ,p_indirizzo            => rtrim(ltrim(p_mail_istituzionale))
                                            ,p_utente_aggiornamento => p_utente_aggiornamento
                                            ,p_data_aggiornamento   => p_data_aggiornamento);
         begin
            select 1
              into d_aggiornamento
              from as4_anagrafe_soggetti
             where ni = d_ni
               and (upper(cognome) <> upper(rtrim(ltrim(p_descrizione))) or
                   upper(nvl(indirizzo_res, ' ')) <>
                   upper(nvl(rtrim(ltrim(p_indirizzo)), ' ')) or
                   nvl(provincia_res, 0) <> nvl(d_codice_provincia, 0) or
                   nvl(comune_res, 0) <> nvl(d_codice_comune, 0) or
                   nvl(cap_res, ' ') <> nvl(p_cap, ' ') or
                   nvl(tel_res, ' ') <> nvl(p_telefono, ' ') or
                   nvl(fax_res, ' ') <> nvl(p_fax, ' '));
         exception
            when others then
               d_aggiornamento := 0;
         end;
         --         
         if d_aggiornamento = 1 then
            as4_anagrafe_soggetti_tpk.ins(p_ni                   => d_ni
                                         ,p_dal                  => trunc(sysdate)
                                         ,p_cognome              => upper(rtrim(ltrim(p_descrizione)))
                                         ,p_indirizzo_res        => upper(rtrim(ltrim(p_indirizzo)))
                                         ,p_provincia_res        => d_codice_provincia
                                         ,p_comune_res           => d_codice_comune
                                         ,p_cap_res              => p_cap
                                         ,p_tel_res              => p_telefono
                                         ,p_fax_res              => p_fax
                                         ,p_tipo_soggetto        => 'E'
                                         ,p_utente               => p_utente_aggiornamento
                                         ,p_data_agg             => p_data_aggiornamento
                                         ,p_competenza           => 'SI4SO'
                                         ,p_competenza_esclusiva => 'E');
         end if;
         if nvl(d_data_soppressione, to_date('3333333', 'j')) <>
            nvl(p_data_soppressione, to_date('3333333', 'j')) then
            amministrazione.upd_column(p_codice_amministrazione => d_codice_amm
                                      ,p_column                 => 'DATA_SOPPRESSIONE'
                                      ,p_value                  => p_data_soppressione);
         end if;
      end if;
      commit;
   exception
      when uscita then
         commit;
      when others then
         rollback;
   end; -- amministrazione.agg_automatico

--------------------------------------------------------------------------------

/*begin

   -- inserimento degli errori nella tabella
   s_error_table( s_<exception_name>_number ) := s_<exception_name>_msg;
   ...
*/
end amministrazione;
/

