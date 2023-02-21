CREATE OR REPLACE package body ubicazione_componente is
   /******************************************************************************
    NOME:        UBICAZIONE_COMPONENTE
    DESCRIZIONE: Gestione tabella ubicazioni_componente.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore  Descrizione.
    000   13/03/2008  VDAVALLI  Prima emissione.
    001   04/09/2009  VDAVALLI  Modifiche per configurazione master/slave
    002   07/11/2012  MMONARI   Rivisitazione struttura fisica; rel. 1.4.2
    003   22/01/2014  MMONARI   Redmine #366
          14/02/2014  ADADAMO   Redmine #372 is_di_ok lanciata solo al di fuori
                                del contesto di una revisione
          22/05/2015  MMONARI   #544, Proc.get_date_ubicazione_comp
          28/09/2015  MMONARI   #649, eliminato controllo su ubicazione_unita in esiste_ubicazione
          16/10/2015  MMONARI   #642, eliminato trap degli errori in set_fi
          24/05/2016  MMONARI   #724, corretto loop in associa_componenti
   ******************************************************************************/

   s_revisione_body constant afc.t_revision := '003';
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
   end versione; -- UBICAZIONE_COMPONENTE.versione

   --------------------------------------------------------------------------------

   function pk(p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type)
      return t_pk is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        PK
       DESCRIZIONE: Costruttore di un t_PK dati gli attributi della chiave
      ******************************************************************************/
      d_result t_pk;
   begin
   
      d_result.id_ubicazione_componente := p_id_ubicazione_componente;
   
      dbc.pre(not dbc.preon or canhandle(d_result.id_ubicazione_componente)
             ,'canHandle on UBICAZIONE_COMPONENTE.PK');
      return d_result;
   
   end pk; -- end UBICAZIONE_COMPONENTE.PK

   --------------------------------------------------------------------------------

   function can_handle(p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type)
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
      if d_result = 1 and (p_id_ubicazione_componente is null) then
         d_result := 0;
      end if;
   
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on UBICAZIONE_COMPONENTE.can_handle');
   
      return d_result;
   
   end can_handle; -- UBICAZIONE_COMPONENTE.can_handle

   --------------------------------------------------------------------------------

   function canhandle(p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type)
      return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        canHandle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: true se la chiave è manipolabile, false altrimenti.
       NOTE:        Wrapper boolean di can_handle (cfr. can_handle).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(can_handle(p_id_ubicazione_componente));
   begin
      return d_result;
   end canhandle; -- UBICAZIONE_COMPONENTE.canHandle

   --------------------------------------------------------------------------------

   function exists_id(p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type)
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
   
      dbc.pre(not dbc.preon or canhandle(p_id_ubicazione_componente)
             ,'canHandle on UBICAZIONE_COMPONENTE.exists_id');
   
      begin
         select 1
           into d_result
           from ubicazioni_componente
          where id_ubicazione_componente = p_id_ubicazione_componente;
      exception
         when no_data_found then
            d_result := 0;
      end;
   
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on UBICAZIONE_COMPONENTE.exists_id');
   
      return d_result;
   end exists_id; -- UBICAZIONE_COMPONENTE.exists_id

   --------------------------------------------------------------------------------

   function existsid(p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type)
      return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        existsId
       DESCRIZIONE: Esistenza riga con chiave indicata.
       NOTE:        Wrapper boolean di exists_id (cfr. exists_id).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(exists_id(p_id_ubicazione_componente));
   begin
      return d_result;
   end existsid; -- UBICAZIONE_COMPONENTE.existsId

   --------------------------------------------------------------------------------

   procedure ins
   (
      p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type
     ,p_id_componente            in ubicazioni_componente.id_componente%type default null
     ,p_id_ubicazione_unita      in ubicazioni_componente.id_ubicazione_unita%type default null
     ,p_dal                      in ubicazioni_componente.dal%type default null
     ,p_al                       in ubicazioni_componente.al%type default null
     ,p_id_origine               in ubicazioni_componente.id_origine%type default null
     ,p_utente_aggiornamento     in ubicazioni_componente.utente_aggiornamento%type default null
     ,p_data_aggiornamento       in ubicazioni_componente.data_aggiornamento%type default null
   ) is
      /******************************************************************************
       NOME:        ins
       DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
       PARAMETRI:   Chiavi e attributi della table.
      ******************************************************************************/
   begin
      -- Check Mandatory on Insert
      dbc.pre(not dbc.preon or p_id_componente is not null or /*default value*/
              'default null' is not null
             ,'p_id_componente on UBICAZIONE_COMPONENTE.ins');
      dbc.pre(not dbc.preon or p_id_ubicazione_unita is not null or /*default value*/
              'default null' is not null
             ,'p_id_ubicazione_unita on UBICAZIONE_COMPONENTE.ins');
      dbc.pre(not dbc.preon or p_dal is not null or /*default value*/
              'default null' is not null
             ,'p_dal on UBICAZIONE_COMPONENTE.ins');
      dbc.pre(not dbc.preon or p_al is not null or /*default value*/
              'default null' is not null
             ,'p_al on UBICAZIONE_COMPONENTE.ins');
      dbc.pre(not dbc.preon or p_id_origine is not null or /*default value*/
              'default null' is not null
             ,'p_al on UBICAZIONE_COMPONENTE.ins');
      dbc.pre(not dbc.preon or p_utente_aggiornamento is not null or /*default value*/
              'default null' is not null
             ,'p_utente_aggiornamento on UBICAZIONE_COMPONENTE.ins');
      dbc.pre(not dbc.preon or p_data_aggiornamento is not null or /*default value*/
              'default null' is not null
             ,'p_data_aggiornamento on UBICAZIONE_COMPONENTE.ins');
      dbc.pre(not dbc.preon or (p_id_ubicazione_componente is null and /*default value*/
              '' is not null) -- PK nullable on insert
              or not existsid(p_id_ubicazione_componente)
             ,'not existsId on UBICAZIONE_COMPONENTE.ins');
   
      insert into ubicazioni_componente
         (id_ubicazione_componente
         ,id_componente
         ,id_ubicazione_unita
         ,dal
         ,al
         ,id_origine
         ,utente_aggiornamento
         ,data_aggiornamento)
      values
         (p_id_ubicazione_componente
         ,p_id_componente
         ,p_id_ubicazione_unita
         ,p_dal
         ,p_al
         ,p_id_origine
         ,p_utente_aggiornamento
         ,p_data_aggiornamento);
   
   end ins; -- UBICAZIONE_COMPONENTE.ins

   --------------------------------------------------------------------------------

   procedure upd
   (
      p_new_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type
     ,p_new_id_componente            in ubicazioni_componente.id_componente%type
     ,p_new_id_ubicazione_unita      in ubicazioni_componente.id_ubicazione_unita%type
     ,p_new_dal                      in ubicazioni_componente.dal%type
     ,p_new_al                       in ubicazioni_componente.al%type
     ,p_new_id_origine               in ubicazioni_componente.id_origine%type default null
     ,p_new_utente_aggiornamento     in ubicazioni_componente.utente_aggiornamento%type
     ,p_new_data_aggiornamento       in ubicazioni_componente.data_aggiornamento%type
     ,p_old_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type default null
     ,p_old_id_componente            in ubicazioni_componente.id_componente%type default null
     ,p_old_id_ubicazione_unita      in ubicazioni_componente.id_ubicazione_unita%type default null
     ,p_old_dal                      in ubicazioni_componente.dal%type default null
     ,p_old_al                       in ubicazioni_componente.al%type default null
     ,p_old_id_origine               in ubicazioni_componente.id_origine%type default null
     ,p_old_utente_aggiornamento     in ubicazioni_componente.utente_aggiornamento%type default null
     ,p_old_data_aggiornamento       in ubicazioni_componente.data_aggiornamento%type default null
     ,p_check_old                    in integer default 0
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
              not
               ((p_old_id_componente is not null or p_old_id_ubicazione_unita is not null or
               p_old_dal is not null or p_old_al is not null or
               p_old_id_origine is not null or p_old_utente_aggiornamento is not null or
               p_old_data_aggiornamento is not null) and (nvl(p_check_old, -1) = 0))
             ,' <OLD values> is not null on UBICAZIONE_COMPONENTE.upd');
   
      d_key := pk(nvl(p_old_id_ubicazione_componente, p_new_id_ubicazione_componente));
   
      dbc.pre(not dbc.preon or existsid(d_key.id_ubicazione_componente)
             ,'existsId on UBICAZIONE_COMPONENTE.upd');
   
      update ubicazioni_componente
         set id_ubicazione_componente = decode(p_check_old
                                              ,0
                                              ,p_new_id_ubicazione_componente
                                              ,decode(p_new_id_ubicazione_componente
                                                     ,p_old_id_ubicazione_componente
                                                     ,id_ubicazione_componente
                                                     ,p_new_id_ubicazione_componente))
            ,id_componente            = decode(p_check_old
                                              ,0
                                              ,p_new_id_componente
                                              ,decode(p_new_id_componente
                                                     ,p_old_id_componente
                                                     ,id_componente
                                                     ,p_new_id_componente))
            ,id_ubicazione_unita      = decode(p_check_old
                                              ,0
                                              ,p_new_id_ubicazione_unita
                                              ,decode(p_new_id_ubicazione_unita
                                                     ,p_old_id_ubicazione_unita
                                                     ,id_ubicazione_unita
                                                     ,p_new_id_ubicazione_unita))
            ,dal                      = decode(p_check_old
                                              ,0
                                              ,p_new_dal
                                              ,decode(p_new_dal
                                                     ,p_old_dal
                                                     ,dal
                                                     ,p_new_dal))
            ,al                       = decode(p_check_old
                                              ,0
                                              ,p_new_al
                                              ,decode(p_new_al, p_old_al, al, p_new_al))
            ,id_origine               = decode(p_check_old
                                              ,0
                                              ,p_new_id_origine
                                              ,decode(p_new_id_origine
                                                     ,p_old_id_origine
                                                     ,id_origine
                                                     ,p_new_id_origine))
            ,utente_aggiornamento     = decode(p_check_old
                                              ,0
                                              ,p_new_utente_aggiornamento
                                              ,decode(p_new_utente_aggiornamento
                                                     ,p_old_utente_aggiornamento
                                                     ,utente_aggiornamento
                                                     ,p_new_utente_aggiornamento))
            ,data_aggiornamento       = decode(p_check_old
                                              ,0
                                              ,p_new_data_aggiornamento
                                              ,decode(p_new_data_aggiornamento
                                                     ,p_old_data_aggiornamento
                                                     ,data_aggiornamento
                                                     ,p_new_data_aggiornamento))
       where id_ubicazione_componente = d_key.id_ubicazione_componente
         and (nvl(p_check_old, 0) = 0 or
             p_check_old = 1 and (id_componente = p_old_id_componente or
             id_componente is null and p_old_id_componente is null) and
             (id_ubicazione_unita = p_old_id_ubicazione_unita or
             id_ubicazione_unita is null and p_old_id_ubicazione_unita is null) and
             (dal = p_old_dal or dal is null and p_old_dal is null) and
             (al = p_old_al or al is null and p_old_al is null) and
             (id_origine = p_old_id_origine or
             id_origine is null and p_old_id_origine is null) and
             (utente_aggiornamento = p_old_utente_aggiornamento or
             utente_aggiornamento is null and p_old_utente_aggiornamento is null) and
             (data_aggiornamento = p_old_data_aggiornamento or
             data_aggiornamento is null and p_old_data_aggiornamento is null));
      d_row_found := sql%rowcount;
   
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on UBICAZIONE_COMPONENTE.upd');
   
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   
   end upd; -- UBICAZIONE_COMPONENTE.upd

   --------------------------------------------------------------------------------

   procedure upd_column
   (
      p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type
     ,p_column                   in varchar2
     ,p_value                    in varchar2 default null
     ,p_literal_value            in number default 1
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
   
      dbc.pre(not dbc.preon or existsid(p_id_ubicazione_componente)
             ,'existsId on UBICAZIONE_COMPONENTE.upd_column');
      dbc.pre(not dbc.preon or p_column is not null
             ,'p_column is not null on UBICAZIONE_COMPONENTE.upd_column');
      dbc.pre(not dbc.preon or afc_ddl.hasattribute(s_table_name, p_column)
             ,'AFC_DDL.HasAttribute on UBICAZIONE_COMPONENTE.upd_column');
      dbc.pre(p_literal_value in (0, 1) or p_literal_value is null
             ,'p_literal_value on UBICAZIONE_COMPONENTE.upd_column; p_literal_value = ' ||
              p_literal_value);
   
      if p_literal_value = 1 or p_literal_value is null then
         d_literal := '''';
      end if;
   
      d_statement := 'begin ' || '   update ubicazioni_componente' || '   set    ' ||
                     p_column || ' = ' || d_literal || p_value || d_literal ||
                     '   where  id_ubicazione_componente = ''' ||
                     p_id_ubicazione_componente || '''' || '   ;' || 'end;';
   
      afc.sql_execute(d_statement);
   
   end upd_column; -- UBICAZIONE_COMPONENTE.upd_column

   --------------------------------------------------------------------------------

   procedure upd_column
   (
      p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type
     ,p_column                   in varchar2
     ,p_value                    in date
   ) is
      /******************************************************************************
       NOME:        upd_column
       DESCRIZIONE: Aggiornamento del campo p_column col valore p_value.
      
       NOTE:        Richiama se stessa con il parametro date convertito in stringa.
      ******************************************************************************/
      d_data varchar2(19);
   begin
      d_data := to_char(p_value, afc.date_format);
      upd_column(p_id_ubicazione_componente
                ,p_column
                ,'to_date( ''' || d_data || ''', ''' || afc.date_format || ''' )'
                ,0);
   end upd_column; -- UBICAZIONE_COMPONENTE.upd_column

   --------------------------------------------------------------------------------

   procedure del
   (
      p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type
     ,p_id_componente            in ubicazioni_componente.id_componente%type default null
     ,p_id_ubicazione_unita      in ubicazioni_componente.id_ubicazione_unita%type default null
     ,p_dal                      in ubicazioni_componente.dal%type default null
     ,p_al                       in ubicazioni_componente.al%type default null
     ,p_id_origine               in ubicazioni_componente.id_origine%type default null
     ,p_utente_aggiornamento     in ubicazioni_componente.utente_aggiornamento%type default null
     ,p_data_aggiornamento       in ubicazioni_componente.data_aggiornamento%type default null
     ,p_check_old                in integer default 0
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
              not ((p_id_componente is not null or p_id_ubicazione_unita is not null or
               p_dal is not null or p_al is not null or p_id_origine is not null or
               p_utente_aggiornamento is not null or
               p_data_aggiornamento is not null) and (nvl(p_check_old, 0) = 0))
             ,' <OLD values> is not null on UBICAZIONE_COMPONENTE.del');
   
      dbc.pre(not dbc.preon or existsid(p_id_ubicazione_componente)
             ,'existsId on UBICAZIONE_COMPONENTE.del');
   
      delete from ubicazioni_componente
       where id_ubicazione_componente = p_id_ubicazione_componente
         and (nvl(p_check_old, 0) = 0 or
             p_check_old = 1 and (id_componente = p_id_componente or
             id_componente is null and p_id_componente is null) and
             (id_ubicazione_unita = p_id_ubicazione_unita or
             id_ubicazione_unita is null and p_id_ubicazione_unita is null) and
             (dal = p_dal or dal is null and p_dal is null) and
             (al = p_al or al is null and p_al is null) and
             (id_origine = p_id_origine or id_origine is null and p_id_origine is null) and
             (utente_aggiornamento = p_utente_aggiornamento or
             utente_aggiornamento is null and p_utente_aggiornamento is null) and
             (data_aggiornamento = p_data_aggiornamento or
             data_aggiornamento is null and p_data_aggiornamento is null));
      d_row_found := sql%rowcount;
   
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on UBICAZIONE_COMPONENTE.del');
   
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   
      dbc.post(not dbc.poston or not existsid(p_id_ubicazione_componente)
              ,'existsId on UBICAZIONE_COMPONENTE.del');
   
   end del; -- UBICAZIONE_COMPONENTE.del

   --------------------------------------------------------------------------------

   function get_id_componente(p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type)
      return ubicazioni_componente.id_componente%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_id_componente
       DESCRIZIONE: Attributo id_componente di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ubicazioni_componente.id_componente%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ubicazioni_componente.id_componente%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_ubicazione_componente)
             ,'existsId on UBICAZIONE_COMPONENTE.get_id_componente');
   
      select id_componente
        into d_result
        from ubicazioni_componente
       where id_ubicazione_componente = p_id_ubicazione_componente;
   
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on UBICAZIONE_COMPONENTE.get_id_componente');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'id_componente')
                      ,' AFC_DDL.IsNullable on UBICAZIONE_COMPONENTE.get_id_componente');
      end if;
   
      return d_result;
   end get_id_componente; -- UBICAZIONE_COMPONENTE.get_id_componente

   --------------------------------------------------------------------------------

   function get_id_ubicazione_unita(p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type)
      return ubicazioni_componente.id_ubicazione_unita%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_id_ubicazione_unita
       DESCRIZIONE: Attributo id_ubicazione_unita di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ubicazioni_componente.id_ubicazione_unita%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ubicazioni_componente.id_ubicazione_unita%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_ubicazione_componente)
             ,'existsId on UBICAZIONE_COMPONENTE.get_id_ubicazione_unita');
   
      select id_ubicazione_unita
        into d_result
        from ubicazioni_componente
       where id_ubicazione_componente = p_id_ubicazione_componente;
   
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on UBICAZIONE_COMPONENTE.get_id_ubicazione_unita');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'id_ubicazione_unita')
                      ,' AFC_DDL.IsNullable on UBICAZIONE_COMPONENTE.get_id_ubicazione_unita');
      end if;
   
      return d_result;
   end get_id_ubicazione_unita; -- UBICAZIONE_COMPONENTE.get_id_ubicazione_unita

   --------------------------------------------------------------------------------

   function get_dal(p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type)
      return ubicazioni_componente.dal%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_dal
       DESCRIZIONE: Attributo dal di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ubicazioni_componente.dal%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ubicazioni_componente.dal%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_ubicazione_componente)
             ,'existsId on UBICAZIONE_COMPONENTE.get_dal');
   
      select dal
        into d_result
        from ubicazioni_componente
       where id_ubicazione_componente = p_id_ubicazione_componente;
   
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on UBICAZIONE_COMPONENTE.get_dal');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'dal')
                      ,' AFC_DDL.IsNullable on UBICAZIONE_COMPONENTE.get_dal');
      end if;
   
      return d_result;
   end get_dal; -- UBICAZIONE_COMPONENTE.get_dal

   --------------------------------------------------------------------------------

   function get_al(p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type)
      return ubicazioni_componente.al%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_al
       DESCRIZIONE: Attributo al di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ubicazioni_componente.al%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ubicazioni_componente.al%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_ubicazione_componente)
             ,'existsId on UBICAZIONE_COMPONENTE.get_al');
   
      select al
        into d_result
        from ubicazioni_componente
       where id_ubicazione_componente = p_id_ubicazione_componente;
   
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on UBICAZIONE_COMPONENTE.get_al');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'al')
                      ,' AFC_DDL.IsNullable on UBICAZIONE_COMPONENTE.get_al');
      end if;
   
      return d_result;
   end get_al; -- UBICAZIONE_COMPONENTE.get_al

   --------------------------------------------------------------------------------

   function get_id_origine(p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type)
      return ubicazioni_componente.id_origine%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_id_origine
       DESCRIZIONE: Attributo id_origine di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ubicazioni_componente.id_origine%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ubicazioni_componente.id_origine%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_ubicazione_componente)
             ,'existsId on UBICAZIONE_COMPONENTE.get_tipo_registrazione');
   
      select id_origine
        into d_result
        from ubicazioni_componente
       where id_ubicazione_componente = p_id_ubicazione_componente;
   
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on UBICAZIONE_COMPONENTE.get_id_origine');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'id_origine')
                      ,' AFC_DDL.IsNullable on UBICAZIONE_COMPONENTE.get_id_origine');
      end if;
   
      return d_result;
   end get_id_origine; -- UBICAZIONE_COMPONENTE.get_id_origine

   --------------------------------------------------------------------------------

   function get_utente_aggiornamento(p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type)
      return ubicazioni_componente.utente_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_utente_aggiornamento
       DESCRIZIONE: Attributo utente_aggiornamento di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ubicazioni_componente.utente_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ubicazioni_componente.utente_aggiornamento%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_ubicazione_componente)
             ,'existsId on UBICAZIONE_COMPONENTE.get_utente_aggiornamento');
   
      select utente_aggiornamento
        into d_result
        from ubicazioni_componente
       where id_ubicazione_componente = p_id_ubicazione_componente;
   
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on UBICAZIONE_COMPONENTE.get_utente_aggiornamento');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'utente_aggiornamento')
                      ,' AFC_DDL.IsNullable on UBICAZIONE_COMPONENTE.get_utente_aggiornamento');
      end if;
   
      return d_result;
   end get_utente_aggiornamento; -- UBICAZIONE_COMPONENTE.get_utente_aggiornamento

   --------------------------------------------------------------------------------

   function get_data_aggiornamento(p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type)
      return ubicazioni_componente.data_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_data_aggiornamento
       DESCRIZIONE: Attributo data_aggiornamento di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ubicazioni_componente.data_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ubicazioni_componente.data_aggiornamento%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_ubicazione_componente)
             ,'existsId on UBICAZIONE_COMPONENTE.get_data_aggiornamento');
   
      select data_aggiornamento
        into d_result
        from ubicazioni_componente
       where id_ubicazione_componente = p_id_ubicazione_componente;
   
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on UBICAZIONE_COMPONENTE.get_data_aggiornamento');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'data_aggiornamento')
                      ,' AFC_DDL.IsNullable on UBICAZIONE_COMPONENTE.get_data_aggiornamento');
      end if;
   
      return d_result;
   end get_data_aggiornamento; -- UBICAZIONE_COMPONENTE.get_data_aggiornamento

   --------------------------------------------------------------------------------

   function where_condition
   (
      p_id_ubicazione_componente in varchar2 default null
     ,p_id_componente            in varchar2 default null
     ,p_id_ubicazione_unita      in varchar2 default null
     ,p_dal                      in varchar2 default null
     ,p_al                       in varchar2 default null
     ,p_id_origine               in varchar2 default null
     ,p_utente_aggiornamento     in varchar2 default null
     ,p_data_aggiornamento       in varchar2 default null
     ,p_other_condition          in varchar2 default null
     ,p_qbe                      in number default 0
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
                     afc.get_field_condition(' and ( id_ubicazione_componente '
                                            ,p_id_ubicazione_componente
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( id_componente '
                                            ,p_id_componente
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( id_ubicazione_unita '
                                            ,p_id_ubicazione_unita
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
   
   end where_condition; --- UBICAZIONE_COMPONENTE.where_condition

   --------------------------------------------------------------------------------

   function get_rows
   (
      p_id_ubicazione_componente in varchar2 default null
     ,p_id_componente            in varchar2 default null
     ,p_id_ubicazione_unita      in varchar2 default null
     ,p_dal                      in varchar2 default null
     ,p_al                       in varchar2 default null
     ,p_id_origine               in varchar2 default null
     ,p_utente_aggiornamento     in varchar2 default null
     ,p_data_aggiornamento       in varchar2 default null
     ,p_other_condition          in varchar2 default null
     ,p_qbe                      in number default 0
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
   
      d_statement := ' select * from ubicazioni_componente ' ||
                     where_condition(p_id_ubicazione_componente
                                    ,p_id_componente
                                    ,p_id_ubicazione_unita
                                    ,p_dal
                                    ,p_al
                                    ,p_id_origine
                                    ,p_utente_aggiornamento
                                    ,p_data_aggiornamento
                                    ,p_other_condition
                                    ,p_qbe);
   
      d_ref_cursor := afc_dml.get_ref_cursor(d_statement);
   
      return d_ref_cursor;
   
   end get_rows; -- UBICAZIONE_COMPONENTE.get_rows

   --------------------------------------------------------------------------------

   function count_rows
   (
      p_id_ubicazione_componente in varchar2 default null
     ,p_id_componente            in varchar2 default null
     ,p_id_ubicazione_unita      in varchar2 default null
     ,p_dal                      in varchar2 default null
     ,p_al                       in varchar2 default null
     ,p_id_origine               in varchar2 default null
     ,p_utente_aggiornamento     in varchar2 default null
     ,p_data_aggiornamento       in varchar2 default null
     ,p_other_condition          in varchar2 default null
     ,p_qbe                      in number default 0
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
   
      d_statement := ' select count( * ) from ubicazioni_componente ' ||
                     where_condition(p_id_ubicazione_componente
                                    ,p_id_componente
                                    ,p_id_ubicazione_unita
                                    ,p_dal
                                    ,p_al
                                    ,p_id_origine
                                    ,p_utente_aggiornamento
                                    ,p_data_aggiornamento
                                    ,p_other_condition
                                    ,p_qbe);
   
      d_result := afc.sql_execute(d_statement);
   
      return d_result;
   end count_rows; -- UBICAZIONE_COMPONENTE.count_rows

   --------------------------------------------------------------------------------

   function get_id_ubicazione_corrente
   (
      p_id_componente in ubicazioni_componente.id_componente%type
     ,p_data          in ubicazioni_componente.dal%type
   ) return ubicazioni_componente.id_ubicazione_componente%type is
      /******************************************************************************
       NOME:        get_id_ubicazione_corrente
       DESCRIZIONE: Restituisce l'id_ubicazione del componente alla data indicata
      
       PARAMETRI:   p_id_componente
                    p_data
       RITORNA:     ubicazioni_componente.id_ubicazione_componente%type
      ******************************************************************************/
      d_result ubicazioni_componente.id_ubicazione_componente%type;
   begin
      begin
         select id_ubicazione_componente
           into d_result
           from ubicazioni_componente
          where id_componente = p_id_componente
            and p_data between dal and nvl(al, to_date(3333333, 'j'));
      exception
         when no_data_found then
            d_result := null;
         when too_many_rows then
            d_result := null;
      end;
      --
      return d_result;
      --
   end;
   --------------------------------------------------------------------------------

   function get_ubicazione_corrente
   (
      p_id_componente in ubicazioni_componente.id_componente%type
     ,p_data          in ubicazioni_componente.dal%type
   ) return ubicazioni_unita.progr_unita_fisica%type is
      /******************************************************************************
       NOME:        get_ubicazione_corrente
       DESCRIZIONE: Restituisce il progr. dell'unita' fisica di ubicazione del
                    componente alla data indicata
      
       PARAMETRI:   p_id_componente
                    p_data
       RITORNA:     ubicazione_unita.progr_unita_fisica%type
      ******************************************************************************/
      d_id_ubun ubicazioni_componente.id_ubicazione_unita%type;
      d_result  ubicazioni_unita.progr_unita_fisica%type;
   begin
      begin
         select id_ubicazione_unita
           into d_id_ubun
           from ubicazioni_componente
          where id_componente = p_id_componente
            and p_data between dal and nvl(al, to_date(3333333, 'j'));
      exception
         when no_data_found then
            d_id_ubun := null;
         when too_many_rows then
            d_id_ubun := null;
      end;
      --
      if d_id_ubun is not null then
         d_result := ubicazione_unita.get_progr_unita_fisica(d_id_ubun);
      else
         d_result := null;
      end if;
      --
      return d_result;
   end;

   --------------------------------------------------------------------------------

   function genera_id return ubicazioni_componente.id_ubicazione_componente%type is
      /******************************************************************************
       NOME:        genera_id
       DESCRIZIONE: Restituisce l'id di ubicazioni_componente per l'inserimento
      
       PARAMETRI:
       RITORNA:     ubicazioni_componente.id_ubicazione%type
      ******************************************************************************/
   
      d_result ubicazioni_componente.id_ubicazione_componente%type;
   
   begin
      select ubco_sq.nextval into d_result from dual;
   
      return d_result;
   
   end; -- ubicazione_componente.genera_id

   --------------------------------------------------------------------------------

   function is_dal_al_ok
   (
      p_dal in ubicazioni_componente.dal%type
     ,p_al  in ubicazioni_componente.al%type
   ) return afc_error.t_error_number
   /******************************************************************************
       NOME:        is_dal_al_ok
       DESCRIZIONE: Controllo di congruenza tra data inizio e fine validità
       PARAMETRI:   p_dal
                    p_al
       NOTE:        --
      ******************************************************************************/
    is
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
   
   end; -- ubicazione_componente.is_dal_al_ok

   --------------------------------------------------------------------------------

   function is_di_ok
   (
      p_dal in ubicazioni_componente.dal%type
     ,p_al  in ubicazioni_componente.al%type
   ) return afc_error.t_error_number is
      d_result afc_error.t_error_number := afc_error.ok;
   begin
   
      -- is_dal_al_ok
      d_result := is_dal_al_ok(p_dal, p_al);
   
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on componente.is_DI_ok');
   
      return d_result;
   
   end; -- ubicazione_componente.is_DI_ok

   --------------------------------------------------------------------------------

   procedure chk_di
   (
      p_dal in ubicazioni_componente.dal%type
     ,p_al  in ubicazioni_componente.al%type
   ) is
      /******************************************************************************
       NOME:        chk_DI.
       DESCRIZIONE: controllo integrita dati:
                    - dal < al
       RITORNA:     -
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
      if revisione_struttura.s_attivazione = 0 then
         d_result := is_di_ok(p_dal, p_al);
      end if;
   
      dbc.assertion(not dbc.assertionon or d_result = afc_error.ok or d_result < 0
                   ,'d_result = AFC_Error.ok or d_result < 0 on componente.chk_DI');
   
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, s_error_table(d_result));
      end if;
   
   end; -- ubicazione_componente.chk_DI

   --------------------------------------------------------------------------------

   function esiste_ubicazione
   (
      p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type
     ,p_id_componente            in ubicazioni_componente.id_componente%type
     ,p_id_ubicazione_unita      in ubicazioni_componente.id_ubicazione_unita%type
     ,p_dal                      in ubicazioni_componente.dal%type
     ,p_al                       in ubicazioni_componente.al%type
   ) return afc_error.t_error_number
   /******************************************************************************
       NOME:        esiste_ubicazione
       DESCRIZIONE: Controlla che non esista già una relazione tra componente
                    e ubicazioni unita' per lo stesso periodo
       PARAMETRI:   p_id_ubicazione_componente
                    p_id_componente
                    p_id_ubicazione_unita
                    p_dal
                    p_al
       NOTE:        --
      ******************************************************************************/
    is
      d_contatore number;
      d_result    afc_error.t_error_number := afc_error.ok;
   begin
      begin
         select count(*)
           into d_contatore
           from ubicazioni_componente
          where id_componente = p_id_componente
               --    and id_ubicazione_unita = p_id_ubicazione_unita #649
            and dal <= nvl(p_al, to_date('3333333', 'j'))
            and nvl(al, to_date('3333333', 'j')) > p_dal
            and id_ubicazione_componente != nvl(p_id_ubicazione_componente, -1);
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
              ,'d_result = AFC_Error.ok or d_result < 0 on ubicazione_componente.esiste_ubicazione');
   
      return d_result;
   
   end; -- ubicazione_componente.esiste_ubicazione

   --------------------------------------------------------------------------------

   function is_ri_ok
   (
      p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type
     ,p_id_componente            in ubicazioni_componente.id_componente%type
     ,p_id_ubicazione_unita      in ubicazioni_componente.id_ubicazione_unita%type
     ,p_dal                      in ubicazioni_componente.dal%type
     ,p_al                       in ubicazioni_componente.al%type
     ,p_inserting                in number
     ,p_updating                 in number
   ) return afc_error.t_error_number
   /******************************************************************************
       NOME:        is_RI_ok.
       DESCRIZIONE: gestione della Referential Integrity:
                    - esiste_relazione
       PARAMETRI:   p_id_componente
                    p_id_ubicazione_unita
                    p_dal
                    p_al
                    p_inserting
                    p_updating
       RETURN:      1 se tutti i controlli danno esito positivo, l'error_code altrimenti
       NOTE:        --
      ******************************************************************************/
    is
      d_result afc_error.t_error_number := afc_error.ok;
   begin
      if p_inserting = 1 or p_updating = 1 then
         d_result := esiste_ubicazione(p_id_ubicazione_componente
                                      ,p_id_componente
                                      ,p_id_ubicazione_unita
                                      ,p_dal
                                      ,p_al);
      end if;
   
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on ubicazione_componente.is_RI_ok');
   
      return d_result;
   
   end; -- ubicazione_componente.is_RI_ok

   --------------------------------------------------------------------------------

   procedure chk_ri
   (
      p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type
     ,p_id_componente            in ubicazioni_componente.id_componente%type
     ,p_id_ubicazione_unita      in ubicazioni_componente.id_ubicazione_unita%type
     ,p_dal                      in ubicazioni_componente.dal%type
     ,p_al                       in ubicazioni_componente.al%type
     ,p_inserting                in number
     ,p_updating                 in number
   ) is
      /******************************************************************************
       NOME:        chk_RI.
       DESCRIZIONE: gestione della Referential Integrity:
                    - esiste_ubicazione
       PARAMETRI:   p_id_componente
                    p_id_ubicazione_unita
                    p_dal
                    p_al
                    p_inserting
                    p_updating
       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
   
      d_result := is_ri_ok(p_id_ubicazione_componente
                          ,p_id_componente
                          ,p_id_ubicazione_unita
                          ,p_dal
                          ,p_al
                          ,p_inserting
                          ,p_updating);
   
      dbc.assertion(not dbc.assertionon or d_result = afc_error.ok or d_result < 0
                   ,'d_result = AFC_Error.ok or d_result < 0 on ubicazione_componente.chk_RI');
   
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, s_error_table(d_result));
      end if;
   
   end; -- ubicazione_componente.chk_RI

   procedure set_fi
   (
      p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type
     ,p_id_componente            in componenti.id_componente%type
     ,p_id_ubicazione_unita      in ubicazioni_componente.id_ubicazione_unita%type
     ,p_old_dal                  in ubicazioni_componente.dal%type
     ,p_new_dal                  in ubicazioni_componente.dal%type
     ,p_old_al                   in ubicazioni_componente.al%type
     ,p_new_al                   in ubicazioni_componente.al%type
     ,p_data_aggiornamento       in ubicazioni_componente.data_aggiornamento%type
     ,p_utente_aggiornamento     in ubicazioni_componente.utente_aggiornamento%type
     ,p_inserting                in number
     ,p_updating                 in number
     ,p_deleting                 in number
   ) is
      /******************************************************************************
       NOME:        set_FI.
       DESCRIZIONE: Impostazione functional integrity
                    - gestisce il periodo su assegnazioni_fisiche
      
       NOTE:        --
      ******************************************************************************/
      d_result                   afc_error.t_error_number;
      d_utente                   ad4_utenti.utente%type;
      d_utente_agg               ad4_utenti.utente%type;
      d_id_utente                ad4_utenti.id_utente%type;
      d_ni                       componenti.ni%type;
      d_progr_uf                 anagrafe_unita_fisiche.progr_unita_fisica%type;
      d_aggiornamento_componenti ottiche.aggiornamento_componenti%type;
      d_operazione               modifiche_componenti.operazione%type;
      d_id_modifica              modifiche_componenti.id_modifica%type;
      d_dummy                    varchar2(1);
      d_segnalazione_bloccante   varchar2(2);
      d_segnalazione             varchar2(2000);
      d_contatore                number(8) := 0;
      d_integr_gp4               impostazioni.integr_gp4%type := impostazione.get_integr_gp4(1);
      d_tipo_assegnazione        attributi_componente.tipo_assegnazione%type := 'I';
      d_assegnazione_prevalente  attributi_componente.assegnazione_prevalente%type := '1';
   begin
      -- determina i nuovi valori per i campi di ASSEGNAZIONI_FISICHE
      -- #642, eliminate le when others.
      if p_deleting = 0 then
         d_ni       := componente.get_ni(p_id_componente);
         d_progr_uf := ubicazione_unita.get_progr_unita_fisica(p_id_ubicazione_unita);
      end if;
      if p_inserting = 1 then
         assegnazioni_fisiche_tpk.ins(p_id_ubicazione_componente => p_id_ubicazione_componente
                                     ,p_ni                       => d_ni
                                     ,p_progr_unita_fisica       => d_progr_uf
                                     ,p_dal                      => p_new_dal
                                     ,p_al                       => p_new_al
                                     ,p_utente_aggiornamento     => p_utente_aggiornamento
                                     ,p_data_aggiornamento       => p_data_aggiornamento);
      
      elsif p_updating = 1 then
         update assegnazioni_fisiche a
            set dal                  = p_new_dal
               ,al                   = p_new_al
               ,progr_unita_fisica   = d_progr_uf
               ,utente_aggiornamento = p_utente_aggiornamento
               ,data_aggiornamento   = p_data_aggiornamento
          where a.id_ubicazione_componente = p_id_ubicazione_componente;
      elsif p_deleting = 1 then
         delete from assegnazioni_fisiche
          where id_ubicazione_componente = p_id_ubicazione_componente;
      end if;
   
      --
   end;
   --------------------------------------------------------------------------------

   procedure elimina_ubicazioni
   (
      p_id_componente          in ubicazioni_componente.id_componente%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        elimina_ubicazioni.
       DESCRIZIONE: Elimina i record di ubicazioni_componente relativi ad un
                    id_componente
       PARAMETRI:   p_id_componente
                    p_segnalazione_bloccante
                    p_segnalazione
       NOTE:        --
      ******************************************************************************/
      d_errore exception;
   begin
      begin
         delete ubicazioni_componente where id_componente = p_id_componente;
      exception
         when others then
            if sqlcode between - 20900 and - 20999 then
               p_segnalazione := s_error_table(sqlcode);
            else
               p_segnalazione := sqlerrm;
            end if;
            raise d_errore;
      end;
   exception
      when d_errore then
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := p_segnalazione || ' (' || p_id_componente || ')';
   end; -- ubicazione_componente.annulla_ubicazioni

   --------------------------------------------------------------------------------

   procedure annulla_ubicazioni
   (
      p_id_componente          in ubicazioni_componente.id_componente%type
     ,p_al                     in ubicazioni_componente.al%type
     ,p_data_aggiornamento     in ubicazioni_componente.data_aggiornamento%type
     ,p_utente_aggiornamento   in ubicazioni_componente.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        annulla_ubicazioni.
       DESCRIZIONE: aggiorna la data di fine validità dell'ultimo record
                    di ubicazioni_componente relativo ad un id_componente
       PARAMETRI:   p_id_componente
                    p_al
                    p_data_aggiornamento
                    p_utente_aggiornamento
                    p_segnalazione_bloccante
                    p_segnalazione
       NOTE:        --
      ******************************************************************************/
      d_errore exception;
   begin
      begin
         update ubicazioni_componente u
            set u.al                   = p_al
               ,u.data_aggiornamento   = p_data_aggiornamento
               ,u.utente_aggiornamento = p_utente_aggiornamento
          where u.id_componente = p_id_componente
            and u.dal = (select max(u2.dal)
                           from ubicazioni_componente u2
                          where u2.id_componente = u.id_componente);
      exception
         when others then
            if sqlcode between - 20900 and - 20999 then
               p_segnalazione := s_error_table(sqlcode);
            else
               p_segnalazione := sqlerrm;
            end if;
            raise d_errore;
      end;
   exception
      when d_errore then
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := p_segnalazione || ' (' || p_id_componente || ')';
   end; -- ubicazione_componente.annulla_ubicazioni

   --------------------------------------------------------------------------------

   procedure aggiorna_ubicazioni
   (
      p_id_componente          in ubicazioni_componente.id_componente%type
     ,p_dal                    in ubicazioni_componente.dal%type
     ,p_data_aggiornamento     in ubicazioni_componente.data_aggiornamento%type
     ,p_utente_aggiornamento   in ubicazioni_componente.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        aggiorna_ubicazioni.
       DESCRIZIONE: aggiorna la data di inizio validità del primo record
                    di UBICAZIONI_COMPONENTE relativi ad un id_componente
       PARAMETRI:   p_id_componente
                    p_dal
                    p_data_aggiornamento
                    p_utente_aggiornamento
                    p_segnalazione_bloccante
                    p_segnalazione
       NOTE:        --
      ******************************************************************************/
      d_errore exception;
   begin
      begin
         update ubicazioni_componente u
            set u.dal                  = p_dal
               ,u.data_aggiornamento   = p_data_aggiornamento
               ,u.utente_aggiornamento = p_utente_aggiornamento
          where u.id_componente = p_id_componente
            and u.dal = (select min(u2.dal)
                           from ubicazioni_componente u2
                          where u2.id_componente = p_id_componente);
      exception
         when others then
            if sqlcode between - 20900 and - 20999 then
               p_segnalazione := s_error_table(sqlcode);
            else
               p_segnalazione := sqlerrm;
            end if;
            raise d_errore;
      end;
   exception
      when d_errore then
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := p_segnalazione || ' (' || p_id_componente || ')';
   end; -- ubicazione_componente.aggiorna_ubicazioni

   --------------------------------------------------------------------------------

   procedure ripristina_ubicazioni
   (
      p_id_componente          in ubicazioni_componente.id_componente%type
     ,p_data_aggiornamento     in ubicazioni_componente.data_aggiornamento%type
     ,p_utente_aggiornamento   in ubicazioni_componente.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        ripristina_ubicazioni.
       DESCRIZIONE: riapre i record cessati
       PARAMETRI:   p_id_componente
                    p_data_aggiornamento
                    p_utente_aggiornamento
                    p_segnalazione_bloccante
                    p_segnalazione
       NOTE:        --
      ******************************************************************************/
      d_errore exception;
   begin
      begin
         update ubicazioni_componente u1
            set u1.al                   = null
               ,u1.utente_aggiornamento = p_utente_aggiornamento
               ,u1.data_aggiornamento   = p_data_aggiornamento
          where u1.id_componente = p_id_componente
            and u1.dal = (select max(u2.dal)
                            from ubicazioni_componente u2
                           where u2.id_componente = p_id_componente);
      exception
         when others then
            if sqlcode between - 20900 and - 20999 then
               p_segnalazione := s_error_table(sqlcode);
            else
               p_segnalazione := sqlerrm;
            end if;
            raise d_errore;
      end;
   exception
      when d_errore then
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := p_segnalazione || ' (' || p_id_componente || ')';
   end; -- ubicazione_componente.ripristina_ubicazioni

   --------------------------------------------------------------------------------

   procedure associa_componenti
   (
      p_ottica                    in componenti.ottica%type
     ,p_revisione                 in componenti.revisione_assegnazione%type
     ,p_progr_unita_organizzativa in componenti.progr_unita_organizzativa%type
     ,p_id_ubicazione_unita       in ubicazioni_unita.id_ubicazione%type
     ,p_dal                       in ubicazioni_componente.dal%type
     ,p_al                        in ubicazioni_componente.al%type
     ,p_id_origine                in ubicazioni_componente.id_origine%type
     ,p_utente_aggiornamento      in ubicazioni_componente.utente_aggiornamento%type
   ) is
      /******************************************************************************
       NOME:        associa_componenti
       DESCRIZIONE: associa l'unita' fisica ai componenti dell'unita' organizzativa
       PARAMETRI:   ottica
                    revisione in modifica
                    progr_unita_organizzativa
                    id_ubicazione_unita
                    dal
                    al
                    id_origine
                    utente aggiornamento
       NOTE:        --
      ******************************************************************************/
   begin
      for comp in (select id_componente
                         ,dal
                     from componenti c
                    where ottica = p_ottica
                      and progr_unita_organizzativa = p_progr_unita_organizzativa
                      --#724
                      and nvl(revisione_assegnazione,-2) != p_revisione
                      and exists
                         (select 'x' from attributi_componente
                           where id_componente = c.id_componente
                             and p_dal between dal and nvl(al,to_date(3333333,'j')) 
                             and assegnazione_prevalente like '1%'
                             and tipo_assegnazione = 'I'
                         )
                      and (dal < p_dal or nvl(al, to_date('3333333', 'j')) >
                          nvl(p_al, to_date('3333333', 'j')) or
                          dal between p_dal and nvl(p_al, to_date('3333333', 'j')) or
                          nvl(al, to_date('3333333', 'j')) between p_dal and
                          nvl(p_al, to_date('3333333', 'j'))))
      loop
         begin
            insert into ubicazioni_componente
               (id_ubicazione_componente
               ,id_componente
               ,id_ubicazione_unita
               ,dal
               ,al
               ,id_origine
               ,utente_aggiornamento
               ,data_aggiornamento)
               select null
                     ,comp.id_componente
                     ,p_id_ubicazione_unita
                     ,greatest(p_dal, comp.dal)
                     ,p_al
                     ,p_id_origine
                     ,p_utente_aggiornamento
                     ,trunc(sysdate)
                 from dual
                where not exists (select 'x'
                         from ubicazioni_componente u2
                        where u2.id_componente = comp.id_componente
                          and u2.id_ubicazione_unita = p_id_ubicazione_unita
                          and u2.dal = greatest(p_dal, comp.dal));
         exception
            when others then
               raise_application_error(-20999
                                      ,'Errore in inserimento UBICAZIONI_COMPONENTE (' ||
                                       comp.id_componente || ') - ' || sqlerrm);
         end;
      end loop;
   end; -- ubicazione_componente.associa_componenti

   --------------------------------------------------------------------------------

   procedure rimuovi_componenti(p_id_origine in ubicazioni_unita.id_origine%type) is
      /******************************************************************************
       NOME:        rimuovi_componenti
       DESCRIZIONE: rimuove le ubicazioni ereditate dei componenti di una unita'
                    organizzativa
       PARAMETRI:   ottica
                    revisione
                    id_origine
       NOTE:        --
      ******************************************************************************/
   begin
      delete from ubicazioni_componente where id_origine = p_id_origine;
   end; -- ubicazione_componente.rimuovi_componenti

   --------------------------------------------------------------------------------
   procedure get_date_ubicazione_comp --#544
   (
      p_id_ubicazione_componente in ubicazioni_componente.id_ubicazione_componente%type
     ,p_id_componente            in ubicazioni_componente.id_componente%type
     ,p_id_ubicazione_unita      in ubicazioni_componente.id_ubicazione_unita%type
     ,p_dal_ubicazione_comp      out varchar2 -- date nel formato dd/mm/yyyy
     ,p_al_ubicazione_comp       out varchar2 -- date nel formato dd/mm/yyyy
     ,p_segnalazione             out varchar2 -- eventuale segnalazione di anomalia
   ) is
      p_dal_comp            date;
      p_al_comp             date;
      p_dal_ubun            date;
      p_al_ubun             date;
      d_dal_ubicazione_comp date;
      dummy                 varchar2(1);
      d_ni                  componenti.ni%type := componente.get_ni(p_id_componente);
   begin
      select dal
            ,al
        into p_dal_comp
            ,p_al_comp
        from componenti
       where id_componente = p_id_componente;
      select dal
            ,al
        into p_dal_ubun
            ,p_al_ubun
        from ubicazioni_unita
       where id_ubicazione = p_id_ubicazione_unita;
      begin
         select 'x'
           into dummy
           from ubicazioni_componente ubco
          where id_componente = p_id_componente
            and nvl(al, to_date(3333333, 'j')) = nvl(p_al_comp, to_date(3333333, 'j'))
            and id_ubicazione_componente != nvl(p_id_ubicazione_componente, -1);
         p_segnalazione := 'Ubicazione componente già specificata alla data di chiusura del periodo.';
      exception
         when no_data_found then
            null;
      end;
      if p_segnalazione is null then
         begin
            select max(a.al)
              into d_dal_ubicazione_comp
              from vista_folder_ubicazioni a
             where a.ni = d_ni
               and (not ((a.id_componente is null)) and a.id_componente = p_id_componente or
                   (a.id_componente is null) and a.ni = d_ni and exists
                    (select 'X'
                       from componenti b
                      where (b.ni = a.ni)
                        and (b.dal <= nvl(a.al, to_date(3333333, 'J')))
                        and (nvl(b.al, to_date(3333333, 'J')) >= a.dal)));
         end;
      
         if d_dal_ubicazione_comp is not null then
            d_dal_ubicazione_comp := d_dal_ubicazione_comp + 1;
         end if;
         p_dal_ubicazione_comp := to_char(greatest(greatest(nvl(d_dal_ubicazione_comp
                                                               ,to_date(2222222, 'j'))
                                                           ,p_dal_comp)
                                                  ,p_dal_ubun)
                                         ,'dd/mm/yyyy');
         p_al_ubicazione_comp  := to_char(least(nvl(p_al_comp, to_date(3333333, 'j'))
                                               ,nvl(p_al_ubun, to_date(3333333, 'j')))
                                         ,'dd/mm/yyyy');
         if p_al_ubicazione_comp = to_char(to_date(3333333, 'j'), 'dd/mm/yyyy') then
            p_al_ubicazione_comp := to_char(null);
         end if;
      end if;
   end;
   --------------------------------------------------------------------------------
begin

   -- inserimento degli errori nella tabella
   s_error_table(s_dal_al_errato_number) := s_dal_al_errato_msg;
   s_error_table(s_ubicazione_gia_pres_number) := s_ubicazione_gia_pres_msg;

end ubicazione_componente;
/

