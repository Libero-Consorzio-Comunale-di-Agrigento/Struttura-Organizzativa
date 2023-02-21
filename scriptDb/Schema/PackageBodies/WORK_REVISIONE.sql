CREATE OR REPLACE package body work_revisione is
   /******************************************************************************
    NOME:        work_revisione
    DESCRIZIONE: Gestione tabella work_revisioni.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore  Descrizione.
    000   17/11/2006  VDAVALLI  Prima emissione.
    001   04/09/2009  VDAVALLI  Modifiche per configurazione master/slave
    002   28/12/2009  VDAVALLI  Gestione nuovi campi e nuova funzione
                                get_id_errore
   ******************************************************************************/

   s_revisione_body constant afc.t_revision := '002';

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
   end; -- work_revisione.versione

   --------------------------------------------------------------------------------

   function pk(p_id_work_revisione in work_revisioni.id_work_revisione%type) return t_pk is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        PK
       DESCRIZIONE: Costruttore di un t_PK dati gli attributi della chiave
      ******************************************************************************/
      d_result t_pk;
   begin
   
      d_result.id_work_revisione := p_id_work_revisione;
   
      dbc.pre(not dbc.preon or canhandle(d_result.id_work_revisione)
             ,'canHandle on work_revisione.PK');
      return d_result;
   
   end; -- end work_revisione.PK

   --------------------------------------------------------------------------------

   function can_handle(p_id_work_revisione in work_revisioni.id_work_revisione%type)
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
      if d_result = 1 and (p_id_work_revisione is null) then
         d_result := 0;
      end if;
   
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on work_revisione.can_handle');
   
      return d_result;
   
   end; -- work_revisione.can_handle

   --------------------------------------------------------------------------------

   function canhandle(p_id_work_revisione in work_revisioni.id_work_revisione%type)
      return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        canHandle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: true se la chiave è manipolabile, false altrimenti.
       NOTE:        Wrapper boolean di can_handle (cfr. can_handle).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(can_handle(p_id_work_revisione));
   begin
      return d_result;
   end; -- work_revisione.canHandle

   --------------------------------------------------------------------------------

   function exists_id(p_id_work_revisione in work_revisioni.id_work_revisione%type)
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
   
      dbc.pre(not dbc.preon or canhandle(p_id_work_revisione)
             ,'canHandle on work_revisione.exists_id');
   
      begin
         select 1
           into d_result
           from work_revisioni
          where id_work_revisione = p_id_work_revisione;
      exception
         when no_data_found then
            d_result := 0;
      end;
   
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on work_revisione.exists_id');
   
      return d_result;
   end; -- work_revisione.exists_id

   --------------------------------------------------------------------------------

   function existsid(p_id_work_revisione in work_revisioni.id_work_revisione%type)
      return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        existsId
       DESCRIZIONE: Esistenza riga con chiave indicata.
       NOTE:        Wrapper boolean di exists_id (cfr. exists_id).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(exists_id(p_id_work_revisione));
   begin
      return d_result;
   end; -- work_revisione.existsId

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
   end; -- work_revisione.error_message

   --------------------------------------------------------------------------------

   procedure ins
   (
      p_id_work_revisione         in work_revisioni.id_work_revisione%type
     ,p_ottica                    in work_revisioni.ottica%type
     ,p_revisione                 in work_revisioni.revisione%type
     ,p_data                      in work_revisioni.data%type
     ,p_messaggio                 in work_revisioni.messaggio%type
     ,p_errore_bloccante          in work_revisioni.errore_bloccante%type
     ,p_progr_unita_organizzativa in work_revisioni.progr_unita_organizzativa%type
     ,p_codice_uo                 in work_revisioni.codice_uo%type
     ,p_descr_uo                  in work_revisioni.descr_uo%type
     ,p_ni                        in work_revisioni.ni%type
     ,p_nominativo                in work_revisioni.nominativo%type
   ) is
      /******************************************************************************
       NOME:        ins
       DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
       PARAMETRI:   Chiavi e attributi della table.
      ******************************************************************************/
   begin
   
      -- Check Mandatory on Insert
      dbc.pre(not dbc.preon or p_ottica is not null or /*default value*/
              '' is not null
             ,'p_ottica on work_revisione.ins');
      dbc.pre(not dbc.preon or p_revisione is not null or /*default value*/
              '' is not null
             ,'p_revisione on work_revisione.ins');
      dbc.pre(not dbc.preon or p_data is not null or /*default value*/
              '' is not null
             ,'p_data on work_revisione.ins');
      dbc.pre(not dbc.preon or p_messaggio is not null or /*default value*/
              '' is not null
             ,'p_messaggio on work_revisione.ins');
      dbc.pre(not dbc.preon or p_errore_bloccante is not null or /*default value*/
              '' is not null
             ,'p_errore_bloccante on work_revisione.ins');
      dbc.pre(not dbc.preon or p_progr_unita_organizzativa is not null or /*default value*/
              '' is not null
             ,'p_progr_unita_organizzativa on work_revisione.ins');
      dbc.pre(not dbc.preon or p_codice_uo is not null or /*default value*/
              '' is not null
             ,'p_codice_uo on work_revisione.ins');
      dbc.pre(not dbc.preon or p_descr_uo is not null or /*default value*/
              '' is not null
             ,'p_descr_uo on work_revisione.ins');
      dbc.pre(not dbc.preon or p_ni is not null or /*default value*/
              '' is not null
             ,'p_ni on work_revisione.ins');
      dbc.pre(not dbc.preon or p_nominativo is not null or /*default value*/
              '' is not null
             ,'p_nominativo on work_revisione.ins');
      dbc.pre(not dbc.preon or (p_id_work_revisione is null and /*default value*/
              '' is not null) -- PK nullable on insert
              or not existsid(p_id_work_revisione)
             ,'not existsId on work_revisione.ins');
   
      insert into work_revisioni
         (id_work_revisione
         ,ottica
         ,revisione
         ,data
         ,messaggio
         ,errore_bloccante
         ,progr_unita_organizzativa
         ,codice_uo
         ,descr_uo
         ,ni
         ,nominativo)
      values
         (p_id_work_revisione
         ,p_ottica
         ,p_revisione
         ,p_data
         ,p_messaggio
         ,p_errore_bloccante
         ,p_progr_unita_organizzativa
         ,p_codice_uo
         ,p_descr_uo
         ,p_ni
         ,p_nominativo);
   
   end; -- work_revisione.ins

   --------------------------------------------------------------------------------

   procedure upd
   (
      p_new_id_work_revisione in work_revisioni.id_work_revisione%type
     ,p_new_ottica            in work_revisioni.ottica%type
     ,p_new_revisione         in work_revisioni.revisione%type
     ,p_new_data              in work_revisioni.data%type
     ,p_new_messaggio         in work_revisioni.messaggio%type
     ,p_new_errore_bloccante  in work_revisioni.errore_bloccante%type
     ,p_new_progr_unor        in work_revisioni.progr_unita_organizzativa%type
     ,p_new_codice_uo         in work_revisioni.codice_uo%type
     ,p_new_descr_uo          in work_revisioni.descr_uo%type
     ,p_new_ni                in work_revisioni.ni%type
     ,p_new_nominativo        in work_revisioni.nominativo%type
     ,p_old_id_work_revisione in work_revisioni.id_work_revisione%type default null
     ,p_old_ottica            in work_revisioni.ottica%type default null
     ,p_old_revisione         in work_revisioni.revisione%type default null
     ,p_old_data              in work_revisioni.data%type default null
     ,p_old_messaggio         in work_revisioni.messaggio%type default null
     ,p_old_errore_bloccante  in work_revisioni.errore_bloccante%type default null
     ,p_old_progr_unor        in work_revisioni.progr_unita_organizzativa%type
     ,p_old_codice_uo         in work_revisioni.codice_uo%type
     ,p_old_descr_uo          in work_revisioni.descr_uo%type
     ,p_old_ni                in work_revisioni.ni%type
     ,p_old_nominativo        in work_revisioni.nominativo%type
     ,p_check_old             in integer default 0
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
              not
               ((p_old_ottica is not null or p_old_revisione is not null or
               p_old_data is not null or p_old_messaggio is not null or
               p_old_errore_bloccante is not null or p_old_progr_unor is not null or
               p_old_codice_uo is not null or p_old_descr_uo is not null or
               p_old_ni is not null or p_old_nominativo is not null) and p_check_old = 0)
             ,' <OLD values> is not null on work_revisione.upd');
   
      dbc.pre(not dbc.preon or p_check_old is not null
             ,'p_check_OLD is not null on work_revisione.upd');
   
      d_key := pk(nvl(p_old_id_work_revisione, p_new_id_work_revisione));
   
      dbc.pre(not dbc.preon or existsid(d_key.id_work_revisione)
             ,'existsId on work_revisione.upd');
   
      update work_revisioni
         set id_work_revisione         = p_new_id_work_revisione
            ,ottica                    = p_new_ottica
            ,revisione                 = p_new_revisione
            ,data                      = p_new_data
            ,messaggio                 = p_new_messaggio
            ,errore_bloccante          = p_new_errore_bloccante
            ,progr_unita_organizzativa = p_new_progr_unor
            ,codice_uo                 = p_new_codice_uo
            ,descr_uo                  = p_new_descr_uo
            ,ni                        = p_new_ni
            ,nominativo                = p_new_nominativo
       where id_work_revisione = d_key.id_work_revisione
         and (p_check_old = 0 or
             p_check_old = 1 and
             (ottica = p_old_ottica or ottica is null and p_old_ottica is null) and
             (revisione = p_old_revisione or
             revisione is null and p_old_revisione is null) and
             (data = p_old_data or data is null and p_old_data is null) and
             (messaggio = p_old_messaggio or
             messaggio is null and p_old_messaggio is null) and
             (errore_bloccante = p_old_errore_bloccante or
             errore_bloccante is null and p_old_errore_bloccante is null) and
             (progr_unita_organizzativa = p_old_progr_unor or
             progr_unita_organizzativa is null and p_old_progr_unor is null) and
             (codice_uo = p_old_codice_uo or
             codice_uo is null and p_old_codice_uo is null) and
             (descr_uo = p_old_descr_uo or descr_uo is null and p_old_descr_uo is null) and
             (ni = p_old_ni or ni is null and p_old_ni is null) and
             (nominativo = p_old_nominativo or
             nominativo is null and p_old_nominativo is null));
      d_row_found := sql%rowcount;
   
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on work_revisione.upd');
   
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   
   end; -- work_revisione.upd

   --------------------------------------------------------------------------------

   procedure upd_column
   (
      p_id_work_revisione in work_revisioni.id_work_revisione%type
     ,p_column            in varchar2
     ,p_value             in varchar2 default null
     ,p_literal_value     in number default 1
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
   
      dbc.pre(not dbc.preon or existsid(p_id_work_revisione)
             ,'existsId on work_revisione.upd_column');
      dbc.pre(not dbc.preon or p_column is not null
             ,'p_column is not null on work_revisione.upd_column');
      dbc.pre(not dbc.preon or afc_ddl.hasattribute(s_table_name, p_column)
             ,'AFC_DDL.HasAttribute on work_revisione.upd_column');
      dbc.pre(p_literal_value in (0, 1)
             ,'p_literal_value in ( 0, 1 ) on work_revisione.upd_column; p_literal_value = ' ||
              p_literal_value);
   
      if p_literal_value = 1 then
         d_literal := '''';
      end if;
   
      d_statement := 'begin ' || '   update work_revisioni' || '   set    ' || p_column ||
                     ' = ' || d_literal || p_value || d_literal ||
                     '   where  id_work_revisione = ''' || p_id_work_revisione || '''' ||
                     '   ;' || 'end;';
   
      afc.sql_execute(d_statement);
   
   end; -- work_revisione.upd_column

   --------------------------------------------------------------------------------

   procedure upd_column
   (
      p_id_work_revisione in work_revisioni.id_work_revisione%type
     ,p_column            in varchar2
     ,p_value             in date
   ) is
      /******************************************************************************
       NOME:        upd_column
       DESCRIZIONE: Aggiornamento del campo p_column col valore p_value.
       
       NOTE:        Richiama se stessa con il parametro date convertito in stringa.
      ******************************************************************************/
      d_data varchar2(19);
   begin
      d_data := to_char(p_value, afc.date_format);
      upd_column(p_id_work_revisione
                ,p_column
                ,'to_date( ''' || d_data || ''', ''' || afc.date_format || ''' )'
                ,0);
   end; -- work_revisione.upd_column

   --------------------------------------------------------------------------------

   procedure del
   (
      p_id_work_revisione         in work_revisioni.id_work_revisione%type
     ,p_ottica                    in work_revisioni.ottica%type default null
     ,p_revisione                 in work_revisioni.revisione%type default null
     ,p_data                      in work_revisioni.data%type default null
     ,p_messaggio                 in work_revisioni.messaggio%type default null
     ,p_errore_bloccante          in work_revisioni.errore_bloccante%type default null
     ,p_progr_unita_organizzativa in work_revisioni.progr_unita_organizzativa%type
     ,p_codice_uo                 in work_revisioni.codice_uo%type
     ,p_descr_uo                  in work_revisioni.descr_uo%type
     ,p_ni                        in work_revisioni.ni%type
     ,p_nominativo                in work_revisioni.nominativo%type
     ,p_check_old                 in integer default 0
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
              not ((p_ottica is not null or p_revisione is not null or p_data is not null or
               p_messaggio is not null or p_errore_bloccante is not null or
               p_progr_unita_organizzativa is not null or p_codice_uo is not null or
               p_descr_uo is not null or p_ni is not null or
               p_nominativo is not null) and p_check_old = 0)
             ,' <OLD values> is not null on work_revisione.del');
   
      dbc.pre(not dbc.preon or existsid(p_id_work_revisione)
             ,'existsId on work_revisione.del');
   
      delete from work_revisioni
       where id_work_revisione = p_id_work_revisione
         and (p_check_old = 0 or
             p_check_old = 1 and
             (ottica = p_ottica or ottica is null and p_ottica is null) and
             (revisione = p_revisione or revisione is null and p_revisione is null) and
             (data = p_data or data is null and p_data is null) and
             (messaggio = p_messaggio or messaggio is null and p_messaggio is null) and
             (errore_bloccante = p_errore_bloccante or
             errore_bloccante is null and p_errore_bloccante is null) and
             (progr_unita_organizzativa = p_progr_unita_organizzativa or
             progr_unita_organizzativa is null and p_progr_unita_organizzativa is null) and
             (codice_uo = p_codice_uo or codice_uo is null and p_codice_uo is null) and
             (descr_uo = p_descr_uo or descr_uo is null and p_descr_uo is null) and
             (ni = p_ni or ni is null and p_ni is null) and
             (nominativo = p_nominativo or nominativo is null and p_nominativo is null));
      d_row_found := sql%rowcount;
   
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on work_revisione.del');
   
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   
      dbc.post(not dbc.poston or not existsid(p_id_work_revisione)
              ,'existsId on work_revisione.del');
   
   end; -- work_revisione.del

   --------------------------------------------------------------------------------

   function get_ottica(p_id_work_revisione in work_revisioni.id_work_revisione%type)
      return work_revisioni.ottica%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_ottica
       DESCRIZIONE: Attributo ottica di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     work_revisioni.ottica%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result work_revisioni.ottica%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_work_revisione)
             ,'existsId on work_revisione.get_ottica');
   
      select ottica
        into d_result
        from work_revisioni
       where id_work_revisione = p_id_work_revisione;
   
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on work_revisione.get_ottica');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'ottica')
                      ,' AFC_DDL.IsNullable on work_revisione.get_ottica');
      end if;
   
      return d_result;
   end; -- work_revisione.get_ottica

   --------------------------------------------------------------------------------

   function get_revisione(p_id_work_revisione in work_revisioni.id_work_revisione%type)
      return work_revisioni.revisione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_revisione
       DESCRIZIONE: Attributo revisione di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     work_revisioni.revisione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result work_revisioni.revisione%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_work_revisione)
             ,'existsId on work_revisione.get_revisione');
   
      select revisione
        into d_result
        from work_revisioni
       where id_work_revisione = p_id_work_revisione;
   
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on work_revisione.get_revisione');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'revisione')
                      ,' AFC_DDL.IsNullable on work_revisione.get_revisione');
      end if;
   
      return d_result;
   end; -- work_revisione.get_revisione

   --------------------------------------------------------------------------------

   function get_data(p_id_work_revisione in work_revisioni.id_work_revisione%type)
      return work_revisioni.data%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_data
       DESCRIZIONE: Attributo data di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     work_revisioni.data%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result work_revisioni.data%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_work_revisione)
             ,'existsId on work_revisione.get_data');
   
      select data
        into d_result
        from work_revisioni
       where id_work_revisione = p_id_work_revisione;
   
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on work_revisione.get_data');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'data')
                      ,' AFC_DDL.IsNullable on work_revisione.get_data');
      end if;
   
      return d_result;
   end; -- work_revisione.get_data

   --------------------------------------------------------------------------------

   function get_messaggio(p_id_work_revisione in work_revisioni.id_work_revisione%type)
      return work_revisioni.messaggio%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_messaggio
       DESCRIZIONE: Attributo messaggio di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     work_revisioni.messaggio%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result work_revisioni.messaggio%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_work_revisione)
             ,'existsId on work_revisione.get_messaggio');
   
      select messaggio
        into d_result
        from work_revisioni
       where id_work_revisione = p_id_work_revisione;
   
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on work_revisione.get_messaggio');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'messaggio')
                      ,' AFC_DDL.IsNullable on work_revisione.get_messaggio');
      end if;
   
      return d_result;
   end; -- work_revisione.get_messaggio

   --------------------------------------------------------------------------------

   function get_errore_bloccante(p_id_work_revisione in work_revisioni.id_work_revisione%type)
      return work_revisioni.errore_bloccante%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_errore_bloccante
       DESCRIZIONE: Attributo errore_bloccante di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     work_revisioni.errore_bloccante%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result work_revisioni.errore_bloccante%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_work_revisione)
             ,'existsId on work_revisione.get_errore_bloccante');
   
      select errore_bloccante
        into d_result
        from work_revisioni
       where id_work_revisione = p_id_work_revisione;
   
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on work_revisione.get_errore_bloccante');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'errore_bloccante')
                      ,' AFC_DDL.IsNullable on work_revisione.get_errore_bloccante');
      end if;
   
      return d_result;
   end; -- work_revisione.get_errore_bloccante

   --------------------------------------------------------------------------------

   function get_progr_unita_organizzativa(p_id_work_revisione in work_revisioni.id_work_revisione%type)
      return work_revisioni.progr_unita_organizzativa%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_progr_unita_organizzativa
       DESCRIZIONE: Attributo progr_unita_organizzativa di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     work_revisioni.progr_unita_organizzativa%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result work_revisioni.progr_unita_organizzativa%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_work_revisione)
             ,'existsId on work_revisione.get_progr_unita_organizzativa');
   
      select progr_unita_organizzativa
        into d_result
        from work_revisioni
       where id_work_revisione = p_id_work_revisione;
   
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on work_revisione.get_progr_unita_organizzativa');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'progr_unita_organizzativa')
                      ,' AFC_DDL.IsNullable on work_revisione.get_progr_unita_organizzativa');
      end if;
   
      return d_result;
   end; -- work_revisione.get_progr_unita_organizzativa

   --------------------------------------------------------------------------------

   function get_codice_uo(p_id_work_revisione in work_revisioni.id_work_revisione%type)
      return work_revisioni.codice_uo%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_codice_uo
       DESCRIZIONE: Attributo codice_uo di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     work_revisioni.codice_uo%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result work_revisioni.codice_uo%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_work_revisione)
             ,'existsId on work_revisione.get_codice_uo');
   
      select codice_uo
        into d_result
        from work_revisioni
       where id_work_revisione = p_id_work_revisione;
   
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on work_revisione.get_codice_uo');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'codice_uo')
                      ,' AFC_DDL.IsNullable on work_revisione.get_codice_uo');
      end if;
   
      return d_result;
   end; -- work_revisione.get_codice_uo

   --------------------------------------------------------------------------------

   function get_descr_uo(p_id_work_revisione in work_revisioni.id_work_revisione%type)
      return work_revisioni.descr_uo%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_descr_uo
       DESCRIZIONE: Attributo descr_uo di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     work_revisioni.descr_uo%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result work_revisioni.descr_uo%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_work_revisione)
             ,'existsId on work_revisione.get_descr_uo');
   
      select descr_uo
        into d_result
        from work_revisioni
       where id_work_revisione = p_id_work_revisione;
   
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on work_revisione.get_descr_uo');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'descr_uo')
                      ,' AFC_DDL.IsNullable on work_revisione.get_descr_uo');
      end if;
   
      return d_result;
   end; -- work_revisione.get_descr_uo

   --------------------------------------------------------------------------------

   function get_ni(p_id_work_revisione in work_revisioni.id_work_revisione%type)
      return work_revisioni.ni%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_ni
       DESCRIZIONE: Attributo ni di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     work_revisioni.ni%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result work_revisioni.ni%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_work_revisione)
             ,'existsId on work_revisione.get_ni');
   
      select ni
        into d_result
        from work_revisioni
       where id_work_revisione = p_id_work_revisione;
   
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on work_revisione.get_ni');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'ni')
                      ,' AFC_DDL.IsNullable on work_revisione.get_ni');
      end if;
   
      return d_result;
   end; -- work_revisione.get_ni

   --------------------------------------------------------------------------------

   function get_nominativo(p_id_work_revisione in work_revisioni.id_work_revisione%type)
      return work_revisioni.nominativo%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_nominativo
       DESCRIZIONE: Attributo nominativo di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     work_revisioni.nominativo%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result work_revisioni.nominativo%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_work_revisione)
             ,'existsId on work_revisione.get_nominativo');
   
      select nominativo
        into d_result
        from work_revisioni
       where id_work_revisione = p_id_work_revisione;
   
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on work_revisione.get_nominativo');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'nominativo')
                      ,' AFC_DDL.IsNullable on work_revisione.get_nominativo');
      end if;
   
      return d_result;
   end; -- work_revisione.get_nominativo

   --------------------------------------------------------------------------------

   function where_condition
   (
      p_id_work_revisione         in varchar2 default null
     ,p_ottica                    in varchar2 default null
     ,p_revisione                 in varchar2 default null
     ,p_data                      in varchar2 default null
     ,p_messaggio                 in varchar2 default null
     ,p_errore_bloccante          in varchar2 default null
     ,p_progr_unita_organizzativa in varchar2 default null
     ,p_codice_uo                 in varchar2 default null
     ,p_descr_uo                  in varchar2 default null
     ,p_ni                        in varchar2 default null
     ,p_nominativo                in varchar2 default null
     ,p_other_condition           in varchar2 default null
     ,p_qbe                       in number default 0
   ) return afc.t_statement is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        where_condition
       DESCRIZIONE: Ritorna la where_condition per lo statement di select di get_rows e count_rows. 
       PARAMETRI:   p_other_condition
                    p_QBE 0: se l'operatore da utilizzare nella where-condition è
                             quello di default ('=')
                          1: se l'operatore da utilizzare nella where-condition è
                             quello specificato per ogni attributo.
      
       RITORNA:     AFC.t_statement.
       NOTE:        Se p_QBE = 1 , ogni parametro deve contenere, nella prima parte,
                    l'operatore da utilizzare nella where-condition.
      ******************************************************************************/
      d_statement afc.t_statement;
   begin
   
      d_statement := ' where ( 1 = 1 ' ||
                     afc.get_field_condition(' and ( id_work_revisione '
                                            ,p_id_work_revisione
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( ottica ', p_ottica, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( revisione '
                                            ,p_revisione
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( data ', p_data, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( messaggio '
                                            ,p_messaggio
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( errore_bloccante '
                                            ,p_errore_bloccante
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( progr_unita_organizzativa '
                                            ,p_progr_unita_organizzativa
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( codice_uo '
                                            ,p_codice_uo
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( descr_uo ', p_descr_uo, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( ni ', p_ni, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( nominativo '
                                            ,p_nominativo
                                            ,' )'
                                            ,p_qbe) || ' ) ' || p_other_condition;
   
      return d_statement;
   
   end; --- work_revisione.where_condition

   --------------------------------------------------------------------------------

   function get_rows
   (
      p_id_work_revisione         in varchar2 default null
     ,p_ottica                    in varchar2 default null
     ,p_revisione                 in varchar2 default null
     ,p_data                      in varchar2 default null
     ,p_messaggio                 in varchar2 default null
     ,p_errore_bloccante          in varchar2 default null
     ,p_progr_unita_organizzativa in varchar2 default null
     ,p_codice_uo                 in varchar2 default null
     ,p_descr_uo                  in varchar2 default null
     ,p_ni                        in varchar2 default null
     ,p_nominativo                in varchar2 default null
     ,p_other_condition           in varchar2 default null
     ,p_qbe                       in number default 0
   ) return afc.t_ref_cursor is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_rows
       DESCRIZIONE: Ritorna il risultato di una query in base ai valori che passiamo. 
       PARAMETRI:   Chiavi e attributi della table
                    p_other_condition
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
   
      dbc.pre(not dbc.preon or p_qbe in (0, 1), 'check p_QBE on work_revisione.get_rows');
   
      d_statement := ' select * from work_revisioni ' ||
                     where_condition(p_id_work_revisione
                                    ,p_ottica
                                    ,p_revisione
                                    ,p_data
                                    ,p_messaggio
                                    ,p_errore_bloccante
                                    ,p_progr_unita_organizzativa
                                    ,p_codice_uo
                                    ,p_descr_uo
                                    ,p_ni
                                    ,p_nominativo
                                    ,p_other_condition
                                    ,p_qbe);
   
      d_ref_cursor := afc_dml.get_ref_cursor(d_statement);
   
      return d_ref_cursor;
   
   end; -- work_revisione.get_rows

   --------------------------------------------------------------------------------

   function count_rows
   (
      p_id_work_revisione         in varchar2 default null
     ,p_ottica                    in varchar2 default null
     ,p_revisione                 in varchar2 default null
     ,p_data                      in varchar2 default null
     ,p_messaggio                 in varchar2 default null
     ,p_errore_bloccante          in varchar2 default null
     ,p_progr_unita_organizzativa in varchar2 default null
     ,p_codice_uo                 in varchar2 default null
     ,p_descr_uo                  in varchar2 default null
     ,p_ni                        in varchar2 default null
     ,p_nominativo                in varchar2 default null
     ,p_other_condition           in varchar2 default null
     ,p_qbe                       in number default 0
   ) return integer is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        count_rows
       DESCRIZIONE: Ritorna il numero di righe della tabella gli attributi delle quali
                    rispettano i valori indicati.
       PARAMETRI:   Almeno uno dei parametri della tabella.
                    p_other_condition
                    p_QBE
       RITORNA:     Numero di righe che rispettano la selezione indicata.
      ******************************************************************************/
      d_result    integer;
      d_statement afc.t_statement;
   begin
   
      dbc.pre(not dbc.preon or p_qbe in (0, 1)
             ,'check p_QBE on work_revisione.count_rows');
   
      d_statement := ' select count( * ) from work_revisioni ' ||
                     where_condition(p_id_work_revisione
                                    ,p_ottica
                                    ,p_revisione
                                    ,p_data
                                    ,p_messaggio
                                    ,p_errore_bloccante
                                    ,p_progr_unita_organizzativa
                                    ,p_codice_uo
                                    ,p_descr_uo
                                    ,p_ni
                                    ,p_nominativo
                                    ,p_other_condition
                                    ,p_qbe);
   
      d_result := afc.sql_execute(d_statement);
   
      return d_result;
   end; -- work_revisione.count_rows

   --------------------------------------------------------------------------------

   function get_id_errore
   (
      p_ottica                    in work_revisioni.ottica%type
     ,p_revisione                 in work_revisioni.revisione%type
     ,p_progr_unita_organizzativa in work_revisioni.progr_unita_organizzativa%type default null
     ,p_ni                        in work_revisioni.ni%type default null
     ,p_errore_bloccante          in work_revisioni.errore_bloccante%type
   ) return work_revisioni.id_work_revisione%type is
      /******************************************************************************
       NOME:        count_rows
       DESCRIZIONE: Ritorna il numero di righe della tabella gli attributi delle quali
                    rispettano i valori indicati.
       PARAMETRI:   Almeno uno dei parametri della tabella.
                    p_other_condition
                    p_QBE
       RITORNA:     Numero di righe che rispettano la selezione indicata.
      ******************************************************************************/
      d_result work_revisioni.id_work_revisione%type;
   
   begin
      begin
         select id_work_revisione
           into d_result
           from work_revisioni
          where ottica = p_ottica
            and revisione = p_revisione
            and nvl(progr_unita_organizzativa, 0) = nvl(p_progr_unita_organizzativa, 0)
            and nvl(ni, 0) = nvl(p_ni, 0)
            and errore_bloccante = p_errore_bloccante;
      exception
         when others then
            d_result := null;
      end;
      --
      return d_result;
      --
   end; -- work_revisione.get_id_errore
--------------------------------------------------------------------------------

/*begin

   -- inserimento degli errori nella tabella
   s_error_table( s_<exception_name>_number ) := s_<exception_name>_msg;
*/
end work_revisione;
/

