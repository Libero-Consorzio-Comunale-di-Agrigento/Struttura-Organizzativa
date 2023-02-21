CREATE OR REPLACE package body ubicazione_unita is
   /******************************************************************************
    NOME:        ubicazione_unita
    DESCRIZIONE: Gestione tabella ubicazioni_unita.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore  Descrizione.
    000   12/03/2008  VDAVALLI  Prima emissione.
    001   04/09/2009  VDAVALLI  Modifiche per configurazione master/slave
    002   16/02/2012  VDAVALLI  Modificata integrita' referenziale ricorsiva su
                                tabella UNITA_ORGANIZZATIVE
    003   07/11/2012  MMONARI   modifiche a esiste_ubicazione: allineamento 1.4.2
    004   02/01/2013  ADADAMO   Aggiunta get_uo_competenza
    005   28/02/2013  MMONARI   modificata esiste_associazione (Redmine #199)
   ******************************************************************************/

   s_revisione_body constant afc.t_revision := '005';
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
   end versione; -- ubicazione_unita.versione

   --------------------------------------------------------------------------------

   function pk(p_id_ubicazione in ubicazioni_unita.id_ubicazione%type) return t_pk is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        PK
       DESCRIZIONE: Costruttore di un t_PK dati gli attributi della chiave
      ******************************************************************************/
      d_result t_pk;
   begin
   
      d_result.id_ubicazione_unita := p_id_ubicazione;
   
      dbc.pre(not dbc.preon or canhandle(d_result.id_ubicazione_unita)
             ,'canHandle on ubicazione_unita.PK');
      return d_result;
   
   end pk; -- end ubicazione_unita.PK

   --------------------------------------------------------------------------------

   function can_handle(p_id_ubicazione in ubicazioni_unita.id_ubicazione%type) return number is
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
      if d_result = 1 and (p_id_ubicazione is null) then
         d_result := 0;
      end if;
   
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on ubicazione_unita.can_handle');
   
      return d_result;
   
   end can_handle; -- ubicazione_unita.can_handle

   --------------------------------------------------------------------------------

   function canhandle(p_id_ubicazione in ubicazioni_unita.id_ubicazione%type) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        canHandle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: true se la chiave è manipolabile, false altrimenti.
       NOTE:        Wrapper boolean di can_handle (cfr. can_handle).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(can_handle(p_id_ubicazione));
   begin
      return d_result;
   end canhandle; -- ubicazione_unita.canHandle

   --------------------------------------------------------------------------------

   function exists_id(p_id_ubicazione in ubicazioni_unita.id_ubicazione%type) return number is
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
   
      dbc.pre(not dbc.preon or canhandle(p_id_ubicazione)
             ,'canHandle on ubicazione_unita.exists_id');
   
      begin
         select 1
           into d_result
           from ubicazioni_unita
          where id_ubicazione = p_id_ubicazione;
      exception
         when no_data_found then
            d_result := 0;
      end;
   
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on ubicazione_unita.exists_id');
   
      return d_result;
   end exists_id; -- ubicazione_unita.exists_id

   --------------------------------------------------------------------------------

   function existsid(p_id_ubicazione in ubicazioni_unita.id_ubicazione%type) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        existsId
       DESCRIZIONE: Esistenza riga con chiave indicata.
       NOTE:        Wrapper boolean di exists_id (cfr. exists_id).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(exists_id(p_id_ubicazione));
   begin
      return d_result;
   end existsid; -- ubicazione_unita.existsId

   --------------------------------------------------------------------------------

   procedure ins
   (
      p_id_ubicazione             in ubicazioni_unita.id_ubicazione%type
     ,p_progr_unita_organizzativa in ubicazioni_unita.progr_unita_organizzativa%type default null
     ,p_sequenza                  in ubicazioni_unita.sequenza%type default null
     ,p_dal                       in ubicazioni_unita.dal%type default null
     ,p_al                        in ubicazioni_unita.al%type default null
     ,p_progr_unita_fisica        in ubicazioni_unita.progr_unita_fisica%type default null
     ,p_id_origine                in ubicazioni_unita.id_origine%type default null
     ,p_utente_aggiornamento      in ubicazioni_unita.utente_aggiornamento%type default null
     ,p_data_aggiornamento        in ubicazioni_unita.data_aggiornamento%type default null
   ) is
      /******************************************************************************
       NOME:        ins
       DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
       PARAMETRI:   Chiavi e attributi della table.
      ******************************************************************************/
   begin
   
      -- Check Mandatory on Insert
      dbc.pre(not dbc.preon or p_progr_unita_organizzativa is not null or /*default value*/
              'default null' is not null
             ,'p_progr_unita_organizzativa on ubicazione_unita.ins');
      dbc.pre(not dbc.preon or p_sequenza is not null or /*default value*/
              'default null' is not null
             ,'p_sequenza on ubicazione_unita.ins');
      dbc.pre(not dbc.preon or p_dal is not null or /*default value*/
              'default null' is not null
             ,'p_dal on ubicazione_unita.ins');
      dbc.pre(not dbc.preon or p_al is not null or /*default value*/
              'default null' is not null
             ,'p_al on ubicazione_unita.ins');
      dbc.pre(not dbc.preon or p_progr_unita_fisica is not null or /*default value*/
              'default null' is not null
             ,'p_progr_unita_fisica on ubicazione_unita.ins');
      dbc.pre(not dbc.preon or p_id_origine is not null or /*default value*/
              'default null' is not null
             ,'p_id_origine on ubicazione_unita.ins');
      dbc.pre(not dbc.preon or p_utente_aggiornamento is not null or /*default value*/
              'default null' is not null
             ,'p_utente_aggiornamento on ubicazione_unita.ins');
      dbc.pre(not dbc.preon or p_data_aggiornamento is not null or /*default value*/
              'default null' is not null
             ,'p_data_aggiornamento on ubicazione_unita.ins');
      dbc.pre(not dbc.preon or (p_id_ubicazione is null and /*default value*/
              '' is not null) -- PK nullable on insert
              or not existsid(p_id_ubicazione)
             ,'not existsId on ubicazione_unita.ins');
   
      insert into ubicazioni_unita
         (id_ubicazione
         ,progr_unita_organizzativa
         ,sequenza
         ,dal
         ,al
         ,progr_unita_fisica
         ,id_origine
         ,utente_aggiornamento
         ,data_aggiornamento)
      values
         (p_id_ubicazione
         ,p_progr_unita_organizzativa
         ,p_sequenza
         ,p_dal
         ,p_al
         ,p_progr_unita_fisica
         ,p_id_origine
         ,p_utente_aggiornamento
         ,p_data_aggiornamento);
   
   end ins; -- ubicazione_unita.ins

   --------------------------------------------------------------------------------

   procedure upd
   (
      p_new_id_ubicazione_unita  in ubicazioni_unita.id_ubicazione%type
     ,p_new_progr_unor           in ubicazioni_unita.progr_unita_organizzativa%type
     ,p_new_sequenza             in ubicazioni_unita.sequenza%type
     ,p_new_dal                  in ubicazioni_unita.dal%type
     ,p_new_al                   in ubicazioni_unita.al%type
     ,p_new_progr_unita_fisica   in ubicazioni_unita.progr_unita_fisica%type
     ,p_new_id_origine           in ubicazioni_unita.id_origine%type default null
     ,p_new_utente_aggiornamento in ubicazioni_unita.utente_aggiornamento%type
     ,p_new_data_aggiornamento   in ubicazioni_unita.data_aggiornamento%type
     ,p_old_id_ubicazione_unita  in ubicazioni_unita.id_ubicazione%type default null
     ,p_old_progr_unor           in ubicazioni_unita.progr_unita_organizzativa%type default null
     ,p_old_sequenza             in ubicazioni_unita.sequenza%type default null
     ,p_old_dal                  in ubicazioni_unita.dal%type default null
     ,p_old_al                   in ubicazioni_unita.al%type default null
     ,p_old_progr_unita_fisica   in ubicazioni_unita.progr_unita_fisica%type default null
     ,p_old_id_origine           in ubicazioni_unita.id_origine%type default null
     ,p_old_utente_aggiornamento in ubicazioni_unita.utente_aggiornamento%type default null
     ,p_old_data_aggiornamento   in ubicazioni_unita.data_aggiornamento%type default null
     ,p_check_old                in integer default 0
   ) is
      /******************************************************************************
       NOME:        upd
       DESCRIZIONE: Aggiornamento di una riga con chiave.
       PARAMETRI:   Chiavi e attributi della table
                    p_check_OLD: 0 e null, ricerca senza controllo su attributi precedenti
                                 1       , ricerca con controllo anche su attributi precedenti.
      
       NOTE:        Nel caso in cui non venga elaborato alcun record viene lanciata
                    l'eccezione -20010 (cfr. AFC_ERROR).
                    Se p_check_old è NULL, gli attributi vengono annullati solo se viene
                    indicato anche il relativo attributo OLD.
                    Se p_check_old = 1, viene controllato se il record corrispondente a
                    tutti i campi passati come parametri esiste nella tabella.
      ******************************************************************************/
      d_key       t_pk;
      d_row_found number;
   begin
   
      dbc.pre(not dbc.preon or
              not ((p_old_progr_unor is not null or p_old_sequenza is not null or
               p_old_dal is not null or p_old_al is not null or
               p_old_progr_unita_fisica is not null or p_old_id_origine is not null or
               p_old_utente_aggiornamento is not null or
               p_old_data_aggiornamento is not null) and (nvl(p_check_old, -1) = 0))
             ,' <OLD values> is not null on ubicazione_unita.upd');
   
      d_key := pk(nvl(p_old_id_ubicazione_unita, p_new_id_ubicazione_unita));
   
      dbc.pre(not dbc.preon or existsid(d_key.id_ubicazione_unita)
             ,'existsId on ubicazione_unita.upd');
   
      update ubicazioni_unita
         set id_ubicazione             = decode(p_check_old
                                               ,0
                                               ,p_new_id_ubicazione_unita
                                               ,decode(p_new_id_ubicazione_unita
                                                      ,p_old_id_ubicazione_unita
                                                      ,id_ubicazione
                                                      ,p_new_id_ubicazione_unita))
            ,progr_unita_organizzativa = decode(p_check_old
                                               ,0
                                               ,p_new_progr_unor
                                               ,decode(p_new_progr_unor
                                                      ,p_old_progr_unor
                                                      ,progr_unita_organizzativa
                                                      ,p_new_progr_unor))
            ,sequenza                  = decode(p_check_old
                                               ,0
                                               ,p_new_sequenza
                                               ,decode(p_new_sequenza
                                                      ,p_old_sequenza
                                                      ,sequenza
                                                      ,p_new_sequenza))
            ,dal                       = decode(p_check_old
                                               ,0
                                               ,p_new_dal
                                               ,decode(p_new_dal
                                                      ,p_old_dal
                                                      ,dal
                                                      ,p_new_dal))
            ,al                        = decode(p_check_old
                                               ,0
                                               ,p_new_al
                                               ,decode(p_new_al, p_old_al, al, p_new_al))
            ,progr_unita_fisica        = decode(p_check_old
                                               ,0
                                               ,p_new_progr_unita_fisica
                                               ,decode(p_new_progr_unita_fisica
                                                      ,p_old_progr_unita_fisica
                                                      ,progr_unita_fisica
                                                      ,p_new_progr_unita_fisica))
            ,id_origine                = decode(p_check_old
                                               ,0
                                               ,p_new_id_origine
                                               ,decode(p_new_id_origine
                                                      ,p_old_id_origine
                                                      ,id_origine
                                                      ,p_new_id_origine))
            ,utente_aggiornamento      = decode(p_check_old
                                               ,0
                                               ,p_new_utente_aggiornamento
                                               ,decode(p_new_utente_aggiornamento
                                                      ,p_old_utente_aggiornamento
                                                      ,utente_aggiornamento
                                                      ,p_new_utente_aggiornamento))
            ,data_aggiornamento        = decode(p_check_old
                                               ,0
                                               ,p_new_data_aggiornamento
                                               ,decode(p_new_data_aggiornamento
                                                      ,p_old_data_aggiornamento
                                                      ,data_aggiornamento
                                                      ,p_new_data_aggiornamento))
       where id_ubicazione = d_key.id_ubicazione_unita
         and (nvl(p_check_old, 0) = 0 or
             p_check_old = 1 and
             (progr_unita_organizzativa = p_old_progr_unor or
             progr_unita_organizzativa is null and p_old_progr_unor is null) and
             (sequenza = p_old_sequenza or sequenza is null and p_old_sequenza is null) and
             (dal = p_old_dal or dal is null and p_old_dal is null) and
             (al = p_old_al or al is null and p_old_al is null) and
             (progr_unita_fisica = p_old_progr_unita_fisica or
             progr_unita_fisica is null and p_old_progr_unita_fisica is null) and
             (id_origine = p_old_id_origine or
             id_origine is null and p_old_id_origine is null) and
             (utente_aggiornamento = p_old_utente_aggiornamento or
             utente_aggiornamento is null and p_old_utente_aggiornamento is null) and
             (data_aggiornamento = p_old_data_aggiornamento or
             data_aggiornamento is null and p_old_data_aggiornamento is null));
      d_row_found := sql%rowcount;
   
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on ubicazione_unita.upd');
   
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   
   end upd; -- ubicazione_unita.upd

   --------------------------------------------------------------------------------

   procedure upd_column
   (
      p_id_ubicazione in ubicazioni_unita.id_ubicazione%type
     ,p_column        in varchar2
     ,p_value         in varchar2 default null
     ,p_literal_value in number default 1
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
   
      dbc.pre(not dbc.preon or existsid(p_id_ubicazione)
             ,'existsId on ubicazione_unita.upd_column');
      dbc.pre(not dbc.preon or p_column is not null
             ,'p_column is not null on ubicazione_unita.upd_column');
      dbc.pre(not dbc.preon or afc_ddl.hasattribute(s_table_name, p_column)
             ,'AFC_DDL.HasAttribute on ubicazione_unita.upd_column');
      dbc.pre(p_literal_value in (0, 1) or p_literal_value is null
             ,'p_literal_value on ubicazione_unita.upd_column; p_literal_value = ' ||
              p_literal_value);
   
      if p_literal_value = 1 or p_literal_value is null then
         d_literal := '''';
      end if;
   
      d_statement := 'begin ' || '   update ubicazioni_unita' || '   set    ' || p_column ||
                     ' = ' || d_literal || p_value || d_literal ||
                     '   where  id_ubicazione_unita = ''' || p_id_ubicazione || '''' ||
                     '   ;' || 'end;';
   
      afc.sql_execute(d_statement);
   
   end upd_column; -- ubicazione_unita.upd_column

   --------------------------------------------------------------------------------

   procedure upd_column
   (
      p_id_ubicazione in ubicazioni_unita.id_ubicazione%type
     ,p_column        in varchar2
     ,p_value         in date
   ) is
      /******************************************************************************
       NOME:        upd_column
       DESCRIZIONE: Aggiornamento del campo p_column col valore p_value.
       
       NOTE:        Richiama se stessa con il parametro date convertito in stringa.
      ******************************************************************************/
      d_data varchar2(19);
   begin
      d_data := to_char(p_value, afc.date_format);
      upd_column(p_id_ubicazione
                ,p_column
                ,'to_date( ''' || d_data || ''', ''' || afc.date_format || ''' )'
                ,0);
   end upd_column; -- ubicazione_unita.upd_column

   --------------------------------------------------------------------------------

   procedure del
   (
      p_id_ubicazione             in ubicazioni_unita.id_ubicazione%type
     ,p_progr_unita_organizzativa in ubicazioni_unita.progr_unita_organizzativa%type default null
     ,p_sequenza                  in ubicazioni_unita.sequenza%type default null
     ,p_dal                       in ubicazioni_unita.dal%type default null
     ,p_al                        in ubicazioni_unita.al%type default null
     ,p_progr_unita_fisica        in ubicazioni_unita.progr_unita_fisica%type default null
     ,p_id_origine                in ubicazioni_unita.id_origine%type default null
     ,p_utente_aggiornamento      in ubicazioni_unita.utente_aggiornamento%type default null
     ,p_data_aggiornamento        in ubicazioni_unita.data_aggiornamento%type default null
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
              not ((p_progr_unita_organizzativa is not null or p_sequenza is not null or
               p_dal is not null or p_al is not null or
               p_progr_unita_fisica is not null or p_id_origine is not null or
               p_utente_aggiornamento is not null or
               p_data_aggiornamento is not null) and (nvl(p_check_old, 0) = 0))
             ,' <OLD values> is not null on ubicazione_unita.del');
   
      dbc.pre(not dbc.preon or existsid(p_id_ubicazione)
             ,'existsId on ubicazione_unita.del');
   
      delete from ubicazioni_unita
       where id_ubicazione = p_id_ubicazione
         and (nvl(p_check_old, 0) = 0 or
             p_check_old = 1 and
             (progr_unita_organizzativa = p_progr_unita_organizzativa or
             progr_unita_organizzativa is null and p_progr_unita_organizzativa is null) and
             (sequenza = p_sequenza or sequenza is null and p_sequenza is null) and
             (dal = p_dal or dal is null and p_dal is null) and
             (al = p_al or al is null and p_al is null) and
             (progr_unita_fisica = p_progr_unita_fisica or
             progr_unita_fisica is null and p_progr_unita_fisica is null) and
             (id_origine = p_id_origine or id_origine is null and p_id_origine is null) and
             (utente_aggiornamento = p_utente_aggiornamento or
             utente_aggiornamento is null and p_utente_aggiornamento is null) and
             (data_aggiornamento = p_data_aggiornamento or
             data_aggiornamento is null and p_data_aggiornamento is null));
      d_row_found := sql%rowcount;
   
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on ubicazione_unita.del');
   
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   
      dbc.post(not dbc.poston or not existsid(p_id_ubicazione)
              ,'existsId on ubicazione_unita.del');
   
   end del; -- ubicazione_unita.del

   --------------------------------------------------------------------------------

   function get_progr_unita_organizzativa(p_id_ubicazione in ubicazioni_unita.id_ubicazione%type)
      return ubicazioni_unita.progr_unita_organizzativa%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_progr_unita_organizzativa
       DESCRIZIONE: Attributo progr_unita_organizzativa di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ubicazioni_unita.progr_unita_organizzativa%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ubicazioni_unita.progr_unita_organizzativa%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_ubicazione)
             ,'existsId on ubicazione_unita.get_progr_unita_organizzativa');
   
      select progr_unita_organizzativa
        into d_result
        from ubicazioni_unita
       where id_ubicazione = p_id_ubicazione;
   
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on ubicazione_unita.get_progr_unita_organizzativa');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'progr_unita_organizzativa')
                      ,' AFC_DDL.IsNullable on ubicazione_unita.get_progr_unita_organizzativa');
      end if;
   
      return d_result;
   end get_progr_unita_organizzativa; -- ubicazione_unita.get_progr_unita_organizzativa

   --------------------------------------------------------------------------------

   function get_sequenza(p_id_ubicazione in ubicazioni_unita.id_ubicazione%type)
      return ubicazioni_unita.sequenza%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_sequenza
       DESCRIZIONE: Attributo sequenza di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ubicazioni_unita.sequenza%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ubicazioni_unita.sequenza%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_ubicazione)
             ,'existsId on ubicazione_unita.get_sequenza');
   
      select sequenza
        into d_result
        from ubicazioni_unita
       where id_ubicazione = p_id_ubicazione;
   
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on ubicazione_unita.get_sequenza');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'sequenza')
                      ,' AFC_DDL.IsNullable on ubicazione_unita.get_sequenza');
      end if;
   
      return d_result;
   end get_sequenza; -- ubicazione_unita.get_sequenza

   --------------------------------------------------------------------------------

   function get_dal(p_id_ubicazione in ubicazioni_unita.id_ubicazione%type)
      return ubicazioni_unita.dal%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_dal
       DESCRIZIONE: Attributo dal di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ubicazioni_unita.dal%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ubicazioni_unita.dal%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_ubicazione)
             ,'existsId on ubicazione_unita.get_dal');
   
      select dal
        into d_result
        from ubicazioni_unita
       where id_ubicazione = p_id_ubicazione;
   
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on ubicazione_unita.get_dal');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'dal')
                      ,' AFC_DDL.IsNullable on ubicazione_unita.get_dal');
      end if;
   
      return d_result;
   end get_dal; -- ubicazione_unita.get_dal

   --------------------------------------------------------------------------------

   function get_al(p_id_ubicazione in ubicazioni_unita.id_ubicazione%type)
      return ubicazioni_unita.al%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_al
       DESCRIZIONE: Attributo al di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ubicazioni_unita.al%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ubicazioni_unita.al%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_ubicazione)
             ,'existsId on ubicazione_unita.get_al');
   
      select al
        into d_result
        from ubicazioni_unita
       where id_ubicazione = p_id_ubicazione;
   
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on ubicazione_unita.get_al');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'al')
                      ,' AFC_DDL.IsNullable on ubicazione_unita.get_al');
      end if;
   
      return d_result;
   end get_al; -- ubicazione_unita.get_al

   --------------------------------------------------------------------------------

   function get_progr_unita_fisica(p_id_ubicazione in ubicazioni_unita.id_ubicazione%type)
      return ubicazioni_unita.progr_unita_fisica%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_progr_unita_fisica
       DESCRIZIONE: Attributo progr_unita_fisica di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ubicazioni_unita.progr_unita_fisica%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ubicazioni_unita.progr_unita_fisica%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_ubicazione)
             ,'existsId on ubicazione_unita.get_progr_unita_fisica');
   
      select progr_unita_fisica
        into d_result
        from ubicazioni_unita
       where id_ubicazione = p_id_ubicazione;
   
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on ubicazione_unita.get_progr_unita_fisica');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'progr_unita_fisica')
                      ,' AFC_DDL.IsNullable on ubicazione_unita.get_progr_unita_fisica');
      end if;
   
      return d_result;
   end get_progr_unita_fisica; -- ubicazione_unita.get_progr_unita_fisica

   --------------------------------------------------------------------------------

   function get_id_origine(p_id_ubicazione in ubicazioni_unita.id_ubicazione%type)
      return ubicazioni_unita.id_origine%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_id_origine
       DESCRIZIONE: Attributo id_origine di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ubicazioni_unita.id_origine%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ubicazioni_unita.id_origine%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_ubicazione)
             ,'existsId on ubicazione_unita.get_progr_id_origine');
   
      select id_origine
        into d_result
        from ubicazioni_unita
       where id_ubicazione = p_id_ubicazione;
   
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on ubicazione_unita.get_id_origine');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'id_origine')
                      ,' AFC_DDL.IsNullable on ubicazione_unita.get_id_origine');
      end if;
   
      return d_result;
   end get_id_origine; -- ubicazione_unita.get_id_origine

   --------------------------------------------------------------------------------

   function get_utente_aggiornamento(p_id_ubicazione in ubicazioni_unita.id_ubicazione%type)
      return ubicazioni_unita.utente_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_utente_aggiornamento
       DESCRIZIONE: Attributo utente_aggiornamento di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ubicazioni_unita.utente_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ubicazioni_unita.utente_aggiornamento%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_ubicazione)
             ,'existsId on ubicazione_unita.get_utente_aggiornamento');
   
      select utente_aggiornamento
        into d_result
        from ubicazioni_unita
       where id_ubicazione = p_id_ubicazione;
   
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on ubicazione_unita.get_utente_aggiornamento');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'utente_aggiornamento')
                      ,' AFC_DDL.IsNullable on ubicazione_unita.get_utente_aggiornamento');
      end if;
   
      return d_result;
   end get_utente_aggiornamento; -- ubicazione_unita.get_utente_aggiornamento

   --------------------------------------------------------------------------------

   function get_data_aggiornamento(p_id_ubicazione in ubicazioni_unita.id_ubicazione%type)
      return ubicazioni_unita.data_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_data_aggiornamento
       DESCRIZIONE: Attributo data_aggiornamento di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ubicazioni_unita.data_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ubicazioni_unita.data_aggiornamento%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_ubicazione)
             ,'existsId on ubicazione_unita.get_data_aggiornamento');
   
      select data_aggiornamento
        into d_result
        from ubicazioni_unita
       where id_ubicazione = p_id_ubicazione;
   
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on ubicazione_unita.get_data_aggiornamento');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'data_aggiornamento')
                      ,' AFC_DDL.IsNullable on ubicazione_unita.get_data_aggiornamento');
      end if;
   
      return d_result;
   end get_data_aggiornamento; -- ubicazione_unita.get_data_aggiornamento

   --------------------------------------------------------------------------------

   function get_id_ubicazione
   (
      p_progr_unita_organizzativa in ubicazioni_unita.progr_unita_organizzativa%type
     ,p_progr_unita_fisica        in ubicazioni_unita.progr_unita_fisica%type
     ,p_dal                       in ubicazioni_unita.dal%type
   ) return ubicazioni_unita.id_ubicazione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_id_ubicazione
       DESCRIZIONE: Attributo id_ubicazione di riga esistente 
       PARAMETRI:   progr. unita' organizzativa
                    progr. unita' fisica
                    dal
       RITORNA:     ubicazioni_unita.id_ubicazione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ubicazioni_unita.id_ubicazione%type;
   begin
   
      select id_ubicazione
        into d_result
        from ubicazioni_unita
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on ubicazione_unita.get_data_aggiornamento');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'data_aggiornamento')
                      ,' AFC_DDL.IsNullable on ubicazione_unita.get_data_aggiornamento');
      end if;
   
      return d_result;
   end get_id_ubicazione; -- ubicazione_unita.get_id_ubicazione

   --------------------------------------------------------------------------------

   function where_condition
   (
      p_id_ubicazione             in varchar2 default null
     ,p_progr_unita_organizzativa in varchar2 default null
     ,p_sequenza                  in varchar2 default null
     ,p_dal                       in varchar2 default null
     ,p_al                        in varchar2 default null
     ,p_progr_unita_fisica        in varchar2 default null
     ,p_id_origine                in varchar2 default null
     ,p_utente_aggiornamento      in varchar2 default null
     ,p_data_aggiornamento        in varchar2 default null
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
                     afc.get_field_condition(' and ( id_ubicazione_unita '
                                            ,p_id_ubicazione
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( progr_unita_organizzativa '
                                            ,p_progr_unita_organizzativa
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( sequenza '
                                            ,p_sequenza
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( dal '
                                            ,p_dal
                                            ,' )'
                                            ,p_qbe
                                            ,afc.date_format) ||
                     afc.get_field_condition(' and ( al '
                                            ,p_al
                                            ,' )'
                                            ,p_qbe
                                            ,afc.date_format) ||
                     afc.get_field_condition(' and ( progr_unita_fisica '
                                            ,p_progr_unita_fisica
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( id_origine '
                                            ,p_id_origine
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( utente_aggiornamento '
                                            ,p_utente_aggiornamento
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( data_aggiornamento '
                                            ,p_data_aggiornamento
                                            ,' )'
                                            ,p_qbe
                                            ,afc.date_format) || ' ) ' ||
                     p_other_condition;
   
      return d_statement;
   
   end where_condition; --- ubicazione_unita.where_condition

   --------------------------------------------------------------------------------

   function get_rows
   (
      p_id_ubicazione             in varchar2 default null
     ,p_progr_unita_organizzativa in varchar2 default null
     ,p_sequenza                  in varchar2 default null
     ,p_dal                       in varchar2 default null
     ,p_al                        in varchar2 default null
     ,p_progr_unita_fisica        in varchar2 default null
     ,p_id_origine                in varchar2 default null
     ,p_utente_aggiornamento      in varchar2 default null
     ,p_data_aggiornamento        in varchar2 default null
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
   
      d_statement := ' select * from ubicazioni_unita ' ||
                     where_condition(p_id_ubicazione
                                    ,p_progr_unita_organizzativa
                                    ,p_sequenza
                                    ,p_dal
                                    ,p_al
                                    ,p_progr_unita_fisica
                                    ,p_id_origine
                                    ,p_utente_aggiornamento
                                    ,p_data_aggiornamento
                                    ,p_other_condition
                                    ,p_qbe);
   
      d_ref_cursor := afc_dml.get_ref_cursor(d_statement);
   
      return d_ref_cursor;
   
   end get_rows; -- ubicazione_unita.get_rows

   --------------------------------------------------------------------------------

   function count_rows
   (
      p_id_ubicazione             in varchar2 default null
     ,p_progr_unita_organizzativa in varchar2 default null
     ,p_sequenza                  in varchar2 default null
     ,p_dal                       in varchar2 default null
     ,p_al                        in varchar2 default null
     ,p_progr_unita_fisica        in varchar2 default null
     ,p_id_origine                in varchar2 default null
     ,p_utente_aggiornamento      in varchar2 default null
     ,p_data_aggiornamento        in varchar2 default null
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
   
      d_statement := ' select count( * ) from ubicazioni_unita ' ||
                     where_condition(p_id_ubicazione
                                    ,p_progr_unita_organizzativa
                                    ,p_sequenza
                                    ,p_dal
                                    ,p_al
                                    ,p_progr_unita_fisica
                                    ,p_id_origine
                                    ,p_utente_aggiornamento
                                    ,p_data_aggiornamento
                                    ,p_other_condition
                                    ,p_qbe);
   
      d_result := afc.sql_execute(d_statement);
   
      return d_result;
   end count_rows; -- ubicazione_unita.count_rows

   --------------------------------------------------------------------------------

   function genera_id return ubicazioni_unita.id_ubicazione%type is
      /******************************************************************************
       NOME:        genera_id
       DESCRIZIONE: Restituisce l'id di ubicazioni_unita per l'inserimento
      
       PARAMETRI:   
       RITORNA:     ubicazioni_unita.id_ubicazione%type
      ******************************************************************************/
   
      d_result ubicazioni_unita.id_ubicazione%type;
   
   begin
      select ubicazioni_unita_sq.nextval into d_result from dual;
   
      return d_result;
   
   end; -- ubicazione_unita.genera_id

   --------------------------------------------------------------------------------

   function is_dal_al_ok
   (
      p_dal in ubicazioni_unita.dal%type
     ,p_al  in ubicazioni_unita.al%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_dal_al_ok
       DESCRIZIONE: Controllo di congruenza tra data inizio e fine validità
       PARAMETRI:   p_dal
                    p_al
       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
   
      if nvl(p_dal, to_date('01011800', 'ddmmyyyy')) >
         nvl(p_al, to_date('31122200', 'ddmmyyyy')) then
         d_result := s_dal_al_errato_number;
      else
         d_result := afc_error.ok;
      end if;
   
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on area_org_om.is_dal_al_ok');
   
      return d_result;
   
   end; -- ubicazione_unita.is_dal_al_ok

   --------------------------------------------------------------------------------

   function is_di_ok
   (
      p_dal in ubicazioni_unita.dal%type
     ,p_al  in ubicazioni_unita.al%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_DI_ok.
       DESCRIZIONE: controllo integrita dati:
                    - dal < al
       RITORNA:     Afc_error.t_error_number
      ******************************************************************************/
      d_result afc_error.t_error_number := afc_error.ok;
   begin
   
      -- is_dal_al_ok
      d_result := is_dal_al_ok(p_dal, p_al);
   
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on componente.is_DI_ok');
   
      return d_result;
   
   end; -- ubicazione_unita.is_DI_ok

   --------------------------------------------------------------------------------

   procedure chk_di
   (
      p_dal in ubicazioni_unita.dal%type
     ,p_al  in ubicazioni_unita.al%type
   ) is
      /******************************************************************************
       NOME:        chk_DI.
       DESCRIZIONE: controllo integrita dati:
                    - dal < al
       RITORNA:     -
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
   
      d_result := is_di_ok(p_dal, p_al);
   
      dbc.assertion(not dbc.assertionon or d_result = afc_error.ok or d_result < 0
                   ,'d_result = AFC_Error.ok or d_result < 0 on componente.chk_DI');
   
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, s_error_table(d_result));
      end if;
   
   end; -- ubicazione_unita.chk_DI

   --------------------------------------------------------------------------------

   function esiste_ubicazione
   (
      p_id_ubicazione             in ubicazioni_unita.id_ubicazione%type
     ,p_progr_unita_organizzativa in ubicazioni_unita.progr_unita_organizzativa%type
     ,p_progr_unita_fisica        in ubicazioni_unita.progr_unita_fisica%type
     ,p_dal                       in ubicazioni_unita.dal%type
     ,p_al                        in ubicazioni_unita.al%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        esiste_ubicazione
       DESCRIZIONE: Controlla che non esista già una relazione tra unita organizzativa
                    e unita fisica per lo stesso periodo
       PARAMETRI:   p_id_ubicazione
                    p_progr_unita_organizzativa
                    p_progr_unita_fisica
                    p_dal
                    p_al
       NOTE:        --
      ******************************************************************************/
      d_contatore number;
      d_result    afc_error.t_error_number := afc_error.ok;
   begin
      begin
         select count(*)
           into d_contatore
           from ubicazioni_unita
          where progr_unita_organizzativa = p_progr_unita_organizzativa
            and progr_unita_fisica = p_progr_unita_fisica
            and dal <= nvl(p_al, to_date('3333333', 'j'))
            and nvl(al, to_date('3333333', 'j')) >= p_dal
            and id_ubicazione != nvl(p_id_ubicazione, -1);
      exception
         when others then
            d_contatore := 0;
      end;
   
      if d_contatore <> 0 then
         d_result := s_ubicazione_gia_pres_number;
      else
         d_result := afc_error.ok;
      end if;
   
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on ubicazione_unita.esiste_ubicazione');
   
      return d_result;
   
   end; -- ubicazione_unita.esiste_ubicazione

   --------------------------------------------------------------------------------

   function is_ri_ok
   (
      p_id_ubicazione             in ubicazioni_unita.id_ubicazione%type
     ,p_progr_unita_organizzativa in ubicazioni_unita.progr_unita_organizzativa%type
     ,p_progr_unita_fisica        in ubicazioni_unita.progr_unita_fisica%type
     ,p_dal                       in ubicazioni_unita.dal%type
     ,p_al                        in ubicazioni_unita.al%type
     ,p_inserting                 in number
     ,p_updating                  in number
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_RI_ok.
       DESCRIZIONE: gestione della Referential Integrity:
                    - esiste_relazione
       PARAMETRI:   p_progr_unita_organizzativa
                    p_progr_unita_fisica
                    p_dal
                    p_al
                    p_inserting
                    p_updating
       RETURN:      1 se tutti i controlli danno esito positivo, l'error_code altrimenti
       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number := afc_error.ok;
   begin
      if p_inserting = 1 or p_updating = 1 then
         d_result := esiste_ubicazione(p_id_ubicazione
                                      ,p_progr_unita_organizzativa
                                      ,p_progr_unita_fisica
                                      ,p_dal
                                      ,p_al);
      end if;
   
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on ubicazione_unita.is_RI_ok');
   
      return d_result;
   
   end; -- ubicazione_unita.is_RI_ok

   --------------------------------------------------------------------------------

   procedure chk_ri
   (
      p_id_ubicazione             in ubicazioni_unita.id_ubicazione%type
     ,p_progr_unita_organizzativa in ubicazioni_unita.progr_unita_organizzativa%type
     ,p_progr_unita_fisica        in ubicazioni_unita.progr_unita_fisica%type
     ,p_dal                       in ubicazioni_unita.dal%type
     ,p_al                        in ubicazioni_unita.al%type
     ,p_inserting                 in number
     ,p_updating                  in number
   ) is
      /******************************************************************************
       NOME:        chk_RI.
       DESCRIZIONE: gestione della Referential Integrity:
                    - esiste_ubicazione
       PARAMETRI:   p_progr_unita_organizzativa
                    p_progr_unita_fisica
                    p_dal
                    p_al
                    p_inserting
                    p_updating
       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
   
      d_result := is_ri_ok(p_id_ubicazione
                          ,p_progr_unita_organizzativa
                          ,p_progr_unita_fisica
                          ,p_dal
                          ,p_al
                          ,p_inserting
                          ,p_updating);
   
      dbc.assertion(not dbc.assertionon or d_result = afc_error.ok or d_result < 0
                   ,'d_result = AFC_Error.ok or d_result < 0 on ubicazione_unita.chk_RI');
   
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, s_error_table(d_result));
      end if;
   
   end; -- ubicazione_unita.chk_RI

   --------------------------------------------------------------------------------

   function esiste_associazione
   (
      p_progr_unita_organizzativa in ubicazioni_unita.progr_unita_organizzativa%type default null
     ,p_progr_unita_fisica        in ubicazioni_unita.progr_unita_fisica%type default null
     ,p_data                      in ubicazioni_unita.dal%type
     ,p_al                        in ubicazioni_unita.al%type
   ) return integer is
      /******************************************************************************
       NOME:        esiste_associazione
       DESCRIZIONE: Restituisce ok se esiste un'associazione tra unita' organizzativa
                    e unita' fisica nel periodo avente estremi quelli passati come
                    parametri
       PARAMETRI:   Almeno uno tra p_progr_unita_organizzativa e
                    p_progr_unita_fisica
                    p_dal
                    p_al
       RITORNA:     1 se esiste l'associazione, altrimenti 0
      ******************************************************************************/
      d_result afc_error.t_error_number := afc_error.ok;
   begin
      if p_progr_unita_organizzativa is null and p_progr_unita_fisica is null then
         d_result := 0;
         return d_result;
      end if;
      --
      begin
         select afc_error.ok
           into d_result
           from ubicazioni_unita
          where progr_unita_organizzativa =
                nvl(p_progr_unita_organizzativa, progr_unita_organizzativa)
            and progr_unita_fisica = nvl(p_progr_unita_fisica, progr_unita_fisica)
            and nvl(p_data, to_date(2222222, 'j')) <= nvl(al, to_date('3333333', 'j'))
            and nvl(p_al, to_date(3333333, 'j')) >= dal;
      exception
         when no_data_found then
            d_result := 0;
         when too_many_rows then
            d_result := 1;
         when others then
            d_result := 0;
      end;
      --
      return d_result;
   end; -- ubicazione_unita.esiste_associazione

   --------------------------------------------------------------------------------

   function get_ubicazione_unica
   (
      p_progr_unita_organizzativa in ubicazioni_unita.progr_unita_organizzativa%type
     ,p_data                      in ubicazioni_unita.dal%type
   ) return ubicazioni_unita.id_ubicazione%type is
      /******************************************************************************
       NOME:        get_ubicazione_unica
       DESCRIZIONE: Se l'unita' organizzativa data e' associata ad una sola unita'
                    fisica restituisce la chiave dell'associazione, altrimenti null
       PARAMETRI:   p_progr_unita_organizzativa 
                    p_data
       RITORNA:     ubicazioni_unita.id_ubicazione%type
      ******************************************************************************/
      d_result ubicazioni_unita.id_ubicazione%type;
   begin
      begin
         select id_ubicazione
           into d_result
           from ubicazioni_unita
          where progr_unita_organizzativa = p_progr_unita_organizzativa
            and p_data between dal and nvl(al, to_date('3333333', 'j'));
      exception
         when others then
            d_result := null;
      end;
      --
      return d_result;
   end; -- ubicazione_unita.get_ubicazione_unica

   --------------------------------------------------------------------------------

   procedure propaga_unita
   (
      p_ottica                    in anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione           in amministrazioni.codice_amministrazione%type default null
     ,p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_progr_unita_fisica        in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                       in ubicazioni_unita.dal%type
     ,p_al                        in ubicazioni_unita.al%type
     ,p_utente_aggiornamento      in ubicazioni_unita.utente_aggiornamento%type
   ) is
      /******************************************************************************
       NOME:        propaga_unita.
       DESCRIZIONE: inserisce l'associazione all'unita' fisica per tutte le unita'
                    organizzative figlie dell'unita' scelta
       PARAMETRI:   p_ottica
                    p_amministrazione
                    p_progr_unita_organizzativa
                    p_progr_unita_fisica
                    p_dal
                    p_al
                    p_utente_aggiornamento
       NOTE:        --
      ******************************************************************************/
      d_contatore     number(8);
      d_ottica        ottiche.ottica%type;
      d_revisione     revisioni_struttura.revisione%type;
      d_id_ubicazione ubicazioni_unita.id_ubicazione%type;
      d_id_origine    ubicazioni_unita.id_ubicazione%type;
      d_sequenza      ubicazioni_unita.sequenza%type;
   begin
      d_id_origine := ubicazione_unita.get_id_ubicazione(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                                                        ,p_progr_unita_fisica        => p_progr_unita_fisica
                                                        ,p_dal                       => p_dal);
      select count(*)
        into d_contatore
        from ubicazioni_unita
       where id_origine = d_id_origine;
      --  
      if d_contatore = 0 then
         if p_ottica is null and p_amministrazione is null then
            raise_application_error(-20999
                                   ,'Impostare almeno uno dei parametri ottica/amministrazione');
         end if;
         --
         d_ottica    := so4_util.set_ottica_default(p_ottica          => p_ottica
                                                   ,p_amministrazione => p_amministrazione);
         d_revisione := revisione_struttura.get_revisione_mod(p_ottica => d_ottica);
         --
         for unita in (select progr_unita_organizzativa
                             ,dal
                         from unita_organizzative
                        where ottica = d_ottica
                          and revisione != d_revisione
                          and p_dal between dal and
                              nvl(decode(revisione_cessazione
                                        ,d_revisione
                                        ,to_date(null)
                                        ,al)
                                 ,to_date('3333333', 'j'))
                          and nvl(decode(revisione_cessazione
                                        ,d_revisione
                                        ,to_date(null)
                                        ,al)
                                 ,to_date('3333333', 'j')) > trunc(sysdate)
                       connect by prior progr_unita_organizzativa = id_unita_padre
                              and ottica = d_ottica
                              and p_dal between dal and nvl(al, to_date('3333333', 'j'))
                        start with ottica = d_ottica
                               and progr_unita_organizzativa = p_progr_unita_organizzativa
                               and p_dal between dal and nvl(al, to_date(3333333, 'j')))
         loop
            d_sequenza := 0;
            if unita.progr_unita_organizzativa = p_progr_unita_organizzativa then
               ubicazione_componente.associa_componenti(p_ottica                    => d_ottica
                                                       ,p_revisione                 => d_revisione
                                                       ,p_progr_unita_organizzativa => unita.progr_unita_organizzativa
                                                       ,p_id_ubicazione_unita       => d_id_origine
                                                       ,p_dal                       => p_dal
                                                       ,p_al                        => p_al
                                                       ,p_id_origine                => d_id_origine
                                                       ,p_utente_aggiornamento      => p_utente_aggiornamento);
            else
               d_id_ubicazione := ubicazione_unita.genera_id;
               d_sequenza      := d_sequenza + 100;
               begin
                  insert into ubicazioni_unita
                     (id_ubicazione
                     ,progr_unita_organizzativa
                     ,sequenza
                     ,dal
                     ,al
                     ,progr_unita_fisica
                     ,id_origine
                     ,utente_aggiornamento
                     ,data_aggiornamento)
                     select d_id_ubicazione
                           ,unita.progr_unita_organizzativa
                           ,d_sequenza
                           ,greatest(p_dal, unita.dal)
                           ,p_al
                           ,p_progr_unita_fisica
                           ,d_id_origine
                           ,p_utente_aggiornamento
                           ,trunc(sysdate)
                       from dual
                      where not exists
                      (select 'x'
                               from ubicazioni_unita f2
                              where f2.progr_unita_organizzativa =
                                    unita.progr_unita_organizzativa
                                and f2.progr_unita_fisica = p_progr_unita_fisica
                                and f2.dal = p_dal);
               exception
                  when others then
                     raise_application_error(-20999
                                            ,'Errore in inserimento UBICAZIONI_UNITA - ' ||
                                             sqlerrm);
               end;
               --
               -- Associazione dei componenti
               --
               ubicazione_componente.associa_componenti(p_ottica                    => d_ottica
                                                       ,p_revisione                 => d_revisione
                                                       ,p_progr_unita_organizzativa => unita.progr_unita_organizzativa
                                                       ,p_id_ubicazione_unita       => d_id_ubicazione
                                                       ,p_dal                       => p_dal
                                                       ,p_al                        => p_al
                                                       ,p_id_origine                => d_id_origine
                                                       ,p_utente_aggiornamento      => p_utente_aggiornamento);
            end if;
         end loop;
      else
         ubicazione_unita.aggiorna_unita(p_id_origine           => d_id_origine
                                        ,p_progr_unita_fisica   => p_progr_unita_fisica
                                        ,p_dal                  => p_dal
                                        ,p_al                   => p_al
                                        ,p_utente_aggiornamento => p_utente_aggiornamento);
      end if;
   
   end; -- ubicazione_unita.propaga_unita

   --------------------------------------------------------------------------------

   procedure aggiorna_unita
   (
      p_id_origine           in ubicazioni_unita.id_origine%type
     ,p_progr_unita_fisica   in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                  in ubicazioni_unita.dal%type
     ,p_al                   in ubicazioni_unita.al%type
     ,p_utente_aggiornamento in ubicazioni_unita.utente_aggiornamento%type
   ) is
      /******************************************************************************
       NOME:        aggiorna_unita.
       DESCRIZIONE: inserisce l'associazione all'unita' fisica per tutte le unita'
                    organizzative figlie dell'unita' scelta
       PARAMETRI:   p_id_origine
                    p_progr_unita_organizzativa
                    p_progr_unita_fisica
                    p_dal
                    p_al
                    p_utente_aggiornamento
       NOTE:        --
      ******************************************************************************/
   begin
      update ubicazioni_unita
         set progr_unita_fisica   = p_progr_unita_fisica
            ,dal                  = p_dal
            ,al                   = p_al
            ,utente_aggiornamento = p_utente_aggiornamento
       where id_origine = p_id_origine;
   end; -- ubicazione_unita.aggiorna_unita
   --------------------------------------------------------------------------------

   procedure rimuovi_unita(p_id_origine in ubicazioni_unita.id_origine%type) is
      /******************************************************************************
       NOME:        rimuovi_unita.
       DESCRIZIONE: inserisce l'associazione all'unita' fisica per tutte le unita'
                    organizzative figlie dell'unita' scelta
       PARAMETRI:   p_id_origine
       NOTE:        --
      ******************************************************************************/
   begin
      ubicazione_componente.rimuovi_componenti(p_id_origine => p_id_origine);
      -- 
      delete from ubicazioni_unita where id_origine = p_id_origine;
   
   end; -- ubicazione_unita.rimuovi_unita

   --------------------------------------------------------------------------------

   function get_uo_competenza
   (
      p_progr_unita_fisica in ubicazioni_unita.progr_unita_fisica%type
     ,p_data_rif           in date
   ) return ubicazioni_unita.progr_unita_organizzativa%type is
      /******************************************************************************
       NOME:        get_uo_competenza
       DESCRIZIONE: determina la UO di competenza per la UF alla data indicata
       PARAMETRI:   p_progr_unita_fisica
                    p_data_rif
       NOTE:        --
      ******************************************************************************/
      d_result ubicazioni_unita.progr_unita_organizzativa%type := null;
   begin
      begin
         select progr_unita_organizzativa
           into d_result
           from ubicazioni_unita
          where progr_unita_fisica = p_progr_unita_fisica
            and nvl(p_data_rif, sysdate) between dal and nvl(al, to_date(3333333, 'j'));
      exception
         when too_many_rows then
            d_result := -1;
         when no_data_found then
            d_result := -2;
      end;
      return d_result;
   end; -- ubicazione_unita.get_uo_competenza

--------------------------------------------------------------------------------
begin

   -- inserimento degli errori nella tabella
   s_error_table(s_dal_al_errato_number) := s_dal_al_errato_msg;
   s_error_table(s_ubicazione_gia_pres_number) := s_ubicazione_gia_pres_msg;

end ubicazione_unita;
/

