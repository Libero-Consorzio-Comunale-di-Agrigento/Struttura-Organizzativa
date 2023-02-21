CREATE OR REPLACE package body ruoli_profilo_tpk is
   /******************************************************************************
    NOME:        ruoli_profilo_tpk
    DESCRIZIONE: Gestione tabella RUOLI_PROFILO.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore      Descrizione.
    000   07/07/2014  mmonari  Generazione automatica. 
   ******************************************************************************/
   s_revisione_body constant afc.t_revision := '000 - 07/07/2014';
   --------------------------------------------------------------------------------
   function versione return varchar2 is /* SLAVE_COPY */
      /******************************************************************************
       NOME:        versione
       DESCRIZIONE: Versione e revisione di distribuzione del package.
       RITORNA:     varchar2 stringa contenente versione e revisione.
       NOTE:        Primo numero  : versione compatibilita del Package.
                    Secondo numero: revisione del Package specification.
                    Terzo numero  : revisione del Package body.
      ******************************************************************************/
   begin
      return afc.version(s_revisione, s_revisione_body);
   end versione; -- ruoli_profilo_tpk.versione
   --------------------------------------------------------------------------------
   function pk(p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type) return t_pk is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        PK
       DESCRIZIONE: Costruttore di un t_PK dati gli attributi della chiave
      ******************************************************************************/
      d_result t_pk;
   begin
      d_result.id_ruolo_profilo := p_id_ruolo_profilo;
      dbc.pre(not dbc.preon or
              canhandle(p_id_ruolo_profilo => d_result.id_ruolo_profilo)
             ,'canHandle on ruoli_profilo_tpk.PK');
      return d_result;
   end pk; -- ruoli_profilo_tpk.PK
   --------------------------------------------------------------------------------
   function can_handle(p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type)
      return number is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        can_handle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: 1 se la chiave e manipolabile, 0 altrimenti.
       NOTE:        cfr. canHandle per ritorno valori boolean.
      ******************************************************************************/
      d_result number;
   begin
      d_result := 1;
      -- nelle chiavi primarie composte da piu attributi, ciascun attributo deve essere not null
      if d_result = 1 and (p_id_ruolo_profilo is null) then
         d_result := 0;
      end if;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on ruoli_profilo_tpk.can_handle');
      return d_result;
   end can_handle; -- ruoli_profilo_tpk.can_handle
   --------------------------------------------------------------------------------
   function canhandle(p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type)
      return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        canHandle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: true se la chiave e manipolabile, false altrimenti.
       NOTE:        Wrapper boolean di can_handle (cfr. can_handle).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(can_handle(p_id_ruolo_profilo => p_id_ruolo_profilo));
   begin
      return d_result;
   end canhandle; -- ruoli_profilo_tpk.canHandle
   --------------------------------------------------------------------------------
   function exists_id(p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type)
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
      dbc.pre(not dbc.preon or canhandle(p_id_ruolo_profilo => p_id_ruolo_profilo)
             ,'canHandle on ruoli_profilo_tpk.exists_id');
      begin
         select 1
           into d_result
           from ruoli_profilo
          where id_ruolo_profilo = p_id_ruolo_profilo;
      exception
         when no_data_found then
            d_result := 0;
      end;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on ruoli_profilo_tpk.exists_id');
      return d_result;
   end exists_id; -- ruoli_profilo_tpk.exists_id
   --------------------------------------------------------------------------------
   function existsid(p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type)
      return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        existsId
       DESCRIZIONE: Esistenza riga con chiave indicata.
       NOTE:        Wrapper boolean di exists_id (cfr. exists_id).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(exists_id(p_id_ruolo_profilo => p_id_ruolo_profilo));
   begin
      return d_result;
   end existsid; -- ruoli_profilo_tpk.existsId
   --------------------------------------------------------------------------------
   procedure ins
   (
      p_id_ruolo_profilo     in ruoli_profilo.id_ruolo_profilo%type default null
     ,p_ruolo_profilo        in ruoli_profilo.ruolo_profilo%type default null
     ,p_ruolo                in ruoli_profilo.ruolo%type default null
     ,p_dal                  in ruoli_profilo.dal%type default null
     ,p_al                   in ruoli_profilo.al%type default null
     ,p_utente_aggiornamento in ruoli_profilo.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in ruoli_profilo.data_aggiornamento%type default null
   ) is
      /******************************************************************************
       NOME:        ins
       DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
       PARAMETRI:   Chiavi e attributi della table.
      ******************************************************************************/
   begin
      insert into ruoli_profilo
         (id_ruolo_profilo
         ,ruolo_profilo
         ,ruolo
         ,dal
         ,al
         ,utente_aggiornamento
         ,data_aggiornamento)
      values
         (p_id_ruolo_profilo
         ,p_ruolo_profilo
         ,p_ruolo
         ,p_dal
         ,p_al
         ,p_utente_aggiornamento
         ,p_data_aggiornamento);
   end ins; -- ruoli_profilo_tpk.ins
   --------------------------------------------------------------------------------
   function ins
   (
      p_id_ruolo_profilo     in ruoli_profilo.id_ruolo_profilo%type default null
     ,p_ruolo_profilo        in ruoli_profilo.ruolo_profilo%type default null
     ,p_ruolo                in ruoli_profilo.ruolo%type default null
     ,p_dal                  in ruoli_profilo.dal%type default null
     ,p_al                   in ruoli_profilo.al%type default null
     ,p_utente_aggiornamento in ruoli_profilo.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in ruoli_profilo.data_aggiornamento%type default null
   ) return number
   /******************************************************************************
       NOME:        ins
       DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
       PARAMETRI:   Chiavi e attributi della table.
       RITORNA:     In caso di PK formata da colonna numerica, ritorna il valore della PK
                    (se positivo), in tutti gli altri casi ritorna 0; in caso di errore,
                    ritorna il codice di errore
      ******************************************************************************/
    is
      d_result number;
   begin
      -- Check Mandatory on Insert
   
      insert into ruoli_profilo
         (id_ruolo_profilo
         ,ruolo_profilo
         ,ruolo
         ,dal
         ,al
         ,utente_aggiornamento
         ,data_aggiornamento)
      values
         (p_id_ruolo_profilo
         ,p_ruolo_profilo
         ,p_ruolo
         ,p_dal
         ,p_al
         ,p_utente_aggiornamento
         ,p_data_aggiornamento)
      returning id_ruolo_profilo into d_result;
      return d_result;
   end ins; -- ruoli_profilo_tpk.ins
   --------------------------------------------------------------------------------
   procedure upd
   (
      p_check_old                in integer default 0
     ,p_new_id_ruolo_profilo     in ruoli_profilo.id_ruolo_profilo%type
     ,p_old_id_ruolo_profilo     in ruoli_profilo.id_ruolo_profilo%type default null
     ,p_new_ruolo_profilo        in ruoli_profilo.ruolo_profilo%type default afc.default_null('RUOLI_PROFILO.id_profilo')
     ,p_old_ruolo_profilo        in ruoli_profilo.ruolo_profilo%type default null
     ,p_new_ruolo                in ruoli_profilo.ruolo%type default afc.default_null('RUOLI_PROFILO.ruolo')
     ,p_old_ruolo                in ruoli_profilo.ruolo%type default null
     ,p_new_dal                  in ruoli_profilo.dal%type default afc.default_null('RUOLI_PROFILO.dal')
     ,p_old_dal                  in ruoli_profilo.dal%type default null
     ,p_new_al                   in ruoli_profilo.al%type default afc.default_null('RUOLI_PROFILO.al')
     ,p_old_al                   in ruoli_profilo.al%type default null
     ,p_new_utente_aggiornamento in ruoli_profilo.utente_aggiornamento%type default afc.default_null('RUOLI_PROFILO.utente_aggiornamento')
     ,p_old_utente_aggiornamento in ruoli_profilo.utente_aggiornamento%type default null
     ,p_new_data_aggiornamento   in ruoli_profilo.data_aggiornamento%type default afc.default_null('RUOLI_PROFILO.data_aggiornamento')
     ,p_old_data_aggiornamento   in ruoli_profilo.data_aggiornamento%type default null
   ) is
      /******************************************************************************
       NOME:        upd
       DESCRIZIONE: Aggiornamento di una riga con chiave.
       PARAMETRI:   Chiavi e attributi della table
                    p_check_OLD: 0    , ricerca senza controllo su attributi precedenti
                                 1    , ricerca con controllo su tutti gli attributi precedenti.
                                 null , ricerca con controllo sui soli attributi precedenti passati.
       NOTE:        Nel caso in cui non venga elaborato alcun record viene lanciata
                    l'eccezione -20010 (cfr. AFC_ERROR).
                    Se p_check_old e NULL, gli attributi vengono annullati solo se viene
                    indicato anche il relativo attributo OLD.
                    Se p_check_old = 1, viene controllato se il record corrispondente a
                    tutti i campi passati come parametri esiste nella tabella.
                    Se p_check_old e NULL, viene controllato se il record corrispondente
                    ai soli campi passati come parametri esiste nella tabella.
      ******************************************************************************/
      d_key       t_pk ;
      d_row_found number;
   begin
      d_key := pk(nvl(p_old_id_ruolo_profilo, p_new_id_ruolo_profilo));
      update ruoli_profilo
         set id_ruolo_profilo     = nvl(p_new_id_ruolo_profilo
                                       ,decode(afc.is_default_null('RUOLI_PROFILO.id_ruolo_profilo')
                                              ,1
                                              ,id_ruolo_profilo
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_id_ruolo_profilo
                                                            ,null
                                                            ,id_ruolo_profilo
                                                            ,null))))
            ,ruolo_profilo        = nvl(p_new_ruolo_profilo
                                       ,decode(afc.is_default_null('RUOLI_PROFILO.id_profilo')
                                              ,1
                                              ,ruolo_profilo
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_ruolo_profilo
                                                            ,null
                                                            ,ruolo_profilo
                                                            ,null))))
            ,ruolo                = nvl(p_new_ruolo
                                       ,decode(afc.is_default_null('RUOLI_PROFILO.ruolo')
                                              ,1
                                              ,ruolo
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_ruolo
                                                            ,null
                                                            ,ruolo
                                                            ,null))))
            ,dal                  = nvl(p_new_dal
                                       ,decode(afc.is_default_null('RUOLI_PROFILO.dal')
                                              ,1
                                              ,dal
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_dal, null, dal, null))))
            ,al                   = nvl(p_new_al
                                       ,decode(afc.is_default_null('RUOLI_PROFILO.al')
                                              ,1
                                              ,al
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_al, null, al, null))))
            ,utente_aggiornamento = nvl(p_new_utente_aggiornamento
                                       ,decode(afc.is_default_null('RUOLI_PROFILO.utente_aggiornamento')
                                              ,1
                                              ,utente_aggiornamento
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_utente_aggiornamento
                                                            ,null
                                                            ,utente_aggiornamento
                                                            ,null))))
            ,data_aggiornamento   = nvl(p_new_data_aggiornamento
                                       ,decode(afc.is_default_null('RUOLI_PROFILO.data_aggiornamento')
                                              ,1
                                              ,data_aggiornamento
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_data_aggiornamento
                                                            ,null
                                                            ,data_aggiornamento
                                                            ,null))))
       where id_ruolo_profilo = d_key.id_ruolo_profilo
         and (p_check_old = 0 or
             (1 = 1 and (ruolo_profilo = p_old_ruolo_profilo or
             (p_old_ruolo_profilo is null and
             (p_check_old is null or ruolo_profilo is null))) and
             (ruolo = p_old_ruolo or
             (p_old_ruolo is null and (p_check_old is null or ruolo is null))) and
             (dal = p_old_dal or
             (p_old_dal is null and (p_check_old is null or dal is null))) and
             (al = p_old_al or
             (p_old_al is null and (p_check_old is null or al is null))) and
             (utente_aggiornamento = p_old_utente_aggiornamento or
             (p_old_utente_aggiornamento is null and
             (p_check_old is null or utente_aggiornamento is null))) and
             (data_aggiornamento = p_old_data_aggiornamento or
             (p_old_data_aggiornamento is null and
             (p_check_old is null or data_aggiornamento is null)))));
      d_row_found := sql%rowcount;
      afc.default_null(null);
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on ruoli_profilo_tpk.upd');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   end upd; -- ruoli_profilo_tpk.upd
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type
     ,p_column           in varchar2
     ,p_value            in varchar2 default null
     ,p_literal_value    in number default 1
   ) is
      /******************************************************************************
       NOME:        upd_column
       DESCRIZIONE: Aggiornamento del campo p_column col valore p_value.
       PARAMETRI:   p_column:        identificatore del campo da aggiornare.
                    p_value:         valore da modificare.
                    p_literal_value: indica se il valore e un stringa e non un numero
                                     o una funzione.
      ******************************************************************************/
      d_statement afc.t_statement;
      d_literal   varchar2(2);
   begin
      dbc.pre(not dbc.preon or existsid(p_id_ruolo_profilo => p_id_ruolo_profilo)
             ,'existsId on ruoli_profilo_tpk.upd_column');
      dbc.pre(not dbc.preon or p_column is not null
             ,'p_column is not null on ruoli_profilo_tpk.upd_column');
      dbc.pre(not dbc.preon or afc_ddl.hasattribute(s_table_name, p_column)
             ,'AFC_DDL.HasAttribute on ruoli_profilo_tpk.upd_column');
      dbc.pre(p_literal_value in (0, 1) or p_literal_value is null
             ,'p_literal_value on ruoli_profilo_tpk.upd_column; p_literal_value = ' ||
              p_literal_value);
      if p_literal_value = 1 or p_literal_value is null then
         d_literal := '''';
      end if;
      d_statement := ' declare ' || '    d_row_found number; ' || ' begin ' ||
                     '    update RUOLI_PROFILO ' || '       set ' || p_column || ' = ' ||
                     d_literal || p_value || d_literal || '     where 1 = 1 ' ||
                     nvl(afc.get_field_condition(' and ( id_ruolo_profilo '
                                                ,p_id_ruolo_profilo
                                                ,' )'
                                                ,0
                                                ,null)
                        ,' and ( id_ruolo_profilo is null ) ') || '    ; ' ||
                     '    d_row_found := SQL%ROWCOUNT; ' || '    if d_row_found < 1 ' ||
                     '    then ' ||
                     '       raise_application_error ( AFC_ERROR.modified_by_other_user_number, AFC_ERROR.modified_by_other_user_msg ); ' ||
                     '    end if; ' || ' end; ';
      afc.sql_execute(d_statement);
   end upd_column; -- ruoli_profilo_tpk.upd_column
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type
     ,p_column           in varchar2
     ,p_value            in date
   ) is
      /******************************************************************************
       NOME:        upd_column
       DESCRIZIONE: Aggiornamento del campo p_column col valore p_value.
       NOTE:        Richiama se stessa con il parametro date convertito in stringa.
      ******************************************************************************/
      d_data varchar2(19);
   begin
      d_data := to_char(p_value, afc.date_format);
      upd_column(p_id_ruolo_profilo => p_id_ruolo_profilo
                ,p_column           => p_column
                ,p_value            => 'to_date( ''' || d_data || ''', ''' ||
                                       afc.date_format || ''' )'
                ,p_literal_value    => 0);
   end upd_column; -- ruoli_profilo_tpk.upd_column
   --------------------------------------------------------------------------------
   procedure del
   (
      p_check_old            in integer default 0
     ,p_id_ruolo_profilo     in ruoli_profilo.id_ruolo_profilo%type
     ,p_ruolo_profilo        in ruoli_profilo.ruolo_profilo%type default null
     ,p_ruolo                in ruoli_profilo.ruolo%type default null
     ,p_dal                  in ruoli_profilo.dal%type default null
     ,p_al                   in ruoli_profilo.al%type default null
     ,p_utente_aggiornamento in ruoli_profilo.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in ruoli_profilo.data_aggiornamento%type default null
   ) is
      /******************************************************************************
       NOME:        del
       DESCRIZIONE: Cancellazione della riga indicata.
       PARAMETRI:   Chiavi e attributi della table
                    p_check_OLD: 0    , ricerca senza controllo su attributi precedenti
                                 1    , ricerca con controllo su tutti gli attributi precedenti.
                                 null , ricerca con controllo sui soli attributi precedenti passati.
       NOTE:        Nel caso in cui non venga elaborato alcun record viene lanciata
                    l'eccezione -20010 (cfr. AFC_ERROR).
                    Se p_check_old = 1, viene controllato se il record corrispondente a
                    tutti i campi passati come parametri esiste nella tabella.
                    Se p_check_old e NULL, viene controllato se il record corrispondente
                    ai soli campi passati come parametri esiste nella tabella.
      ******************************************************************************/
      d_row_found number;
   begin
      delete from ruoli_profilo
       where id_ruolo_profilo = p_id_ruolo_profilo
         and (p_check_old = 0 or
             (1 = 1 and (ruolo_profilo = p_ruolo_profilo or
             (p_ruolo_profilo is null and
             (p_check_old is null or ruolo_profilo is null))) and
             (ruolo = p_ruolo or
             (p_ruolo is null and (p_check_old is null or ruolo is null))) and
             (dal = p_dal or (p_dal is null and (p_check_old is null or dal is null))) and
             (al = p_al or (p_al is null and (p_check_old is null or al is null))) and
             (utente_aggiornamento = p_utente_aggiornamento or
             (p_utente_aggiornamento is null and
             (p_check_old is null or utente_aggiornamento is null))) and
             (data_aggiornamento = p_data_aggiornamento or
             (p_data_aggiornamento is null and
             (p_check_old is null or data_aggiornamento is null)))));
      d_row_found := sql%rowcount;
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   end del; -- ruoli_profilo_tpk.del
   --------------------------------------------------------------------------------
   function get_ruolo_profilo(p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type)
      return ruoli_profilo.ruolo_profilo%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_id_profilo
       DESCRIZIONE: Getter per attributo id_profilo di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     RUOLI_PROFILO.id_profilo%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ruoli_profilo.ruolo_profilo%type;
   begin
      select ruolo_profilo
        into d_result
        from ruoli_profilo
       where id_ruolo_profilo = p_id_ruolo_profilo;
      return d_result;
   end get_ruolo_profilo; -- ruoli_profilo_tpk.get_id_profilo
   --------------------------------------------------------------------------------
   function get_ruolo(p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type)
      return ruoli_profilo.ruolo%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_ruolo
       DESCRIZIONE: Getter per attributo ruolo di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     RUOLI_PROFILO.ruolo%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ruoli_profilo.ruolo%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_ruolo_profilo => p_id_ruolo_profilo)
             ,'existsId on ruoli_profilo_tpk.get_ruolo');
      select ruolo
        into d_result
        from ruoli_profilo
       where id_ruolo_profilo = p_id_ruolo_profilo;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on ruoli_profilo_tpk.get_ruolo');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'ruolo')
                      ,' AFC_DDL.IsNullable on ruoli_profilo_tpk.get_ruolo');
      end if;
      return d_result;
   end get_ruolo; -- ruoli_profilo_tpk.get_ruolo
   --------------------------------------------------------------------------------
   function get_dal(p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type)
      return ruoli_profilo.dal%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_dal
       DESCRIZIONE: Getter per attributo dal di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     RUOLI_PROFILO.dal%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ruoli_profilo.dal%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_ruolo_profilo => p_id_ruolo_profilo)
             ,'existsId on ruoli_profilo_tpk.get_dal');
      select dal
        into d_result
        from ruoli_profilo
       where id_ruolo_profilo = p_id_ruolo_profilo;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on ruoli_profilo_tpk.get_dal');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'dal')
                      ,' AFC_DDL.IsNullable on ruoli_profilo_tpk.get_dal');
      end if;
      return d_result;
   end get_dal; -- ruoli_profilo_tpk.get_dal
   --------------------------------------------------------------------------------
   function get_al(p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type)
      return ruoli_profilo.al%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_al
       DESCRIZIONE: Getter per attributo al di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     RUOLI_PROFILO.al%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ruoli_profilo.al%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_ruolo_profilo => p_id_ruolo_profilo)
             ,'existsId on ruoli_profilo_tpk.get_al');
      select al
        into d_result
        from ruoli_profilo
       where id_ruolo_profilo = p_id_ruolo_profilo;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on ruoli_profilo_tpk.get_al');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'al')
                      ,' AFC_DDL.IsNullable on ruoli_profilo_tpk.get_al');
      end if;
      return d_result;
   end get_al; -- ruoli_profilo_tpk.get_al
   --------------------------------------------------------------------------------
   function get_utente_aggiornamento(p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type)
      return ruoli_profilo.utente_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_utente_aggiornamento
       DESCRIZIONE: Getter per attributo utente_aggiornamento di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     RUOLI_PROFILO.utente_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ruoli_profilo.utente_aggiornamento%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_ruolo_profilo => p_id_ruolo_profilo)
             ,'existsId on ruoli_profilo_tpk.get_utente_aggiornamento');
      select utente_aggiornamento
        into d_result
        from ruoli_profilo
       where id_ruolo_profilo = p_id_ruolo_profilo;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on ruoli_profilo_tpk.get_utente_aggiornamento');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'utente_aggiornamento')
                      ,' AFC_DDL.IsNullable on ruoli_profilo_tpk.get_utente_aggiornamento');
      end if;
      return d_result;
   end get_utente_aggiornamento; -- ruoli_profilo_tpk.get_utente_aggiornamento
   --------------------------------------------------------------------------------
   function get_data_aggiornamento(p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type)
      return ruoli_profilo.data_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_data_aggiornamento
       DESCRIZIONE: Getter per attributo data_aggiornamento di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     RUOLI_PROFILO.data_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ruoli_profilo.data_aggiornamento%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_ruolo_profilo => p_id_ruolo_profilo)
             ,'existsId on ruoli_profilo_tpk.get_data_aggiornamento');
      select data_aggiornamento
        into d_result
        from ruoli_profilo
       where id_ruolo_profilo = p_id_ruolo_profilo;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on ruoli_profilo_tpk.get_data_aggiornamento');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'data_aggiornamento')
                      ,' AFC_DDL.IsNullable on ruoli_profilo_tpk.get_data_aggiornamento');
      end if;
      return d_result;
   end get_data_aggiornamento; -- ruoli_profilo_tpk.get_data_aggiornamento
   --------------------------------------------------------------------------------
   procedure set_id_ruolo_profilo
   (
      p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type
     ,p_value            in ruoli_profilo.id_ruolo_profilo%type default null
   ) is
      /******************************************************************************
       NOME:        set_id_ruolo_profilo
       DESCRIZIONE: Setter per attributo id_ruolo_profilo di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_ruolo_profilo => p_id_ruolo_profilo)
             ,'existsId on ruoli_profilo_tpk.set_id_ruolo_profilo');
      update ruoli_profilo
         set id_ruolo_profilo = p_value
       where id_ruolo_profilo = p_id_ruolo_profilo;
   end set_id_ruolo_profilo; -- ruoli_profilo_tpk.set_id_ruolo_profilo
   --------------------------------------------------------------------------------
   procedure set_id_profilo
   (
      p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type
     ,p_value            in ruoli_profilo.ruolo_profilo%type default null
   ) is
      /******************************************************************************
       NOME:        set_id_profilo
       DESCRIZIONE: Setter per attributo id_profilo di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      update ruoli_profilo
         set ruolo_profilo = p_value
       where id_ruolo_profilo = p_id_ruolo_profilo;
   end set_id_profilo; -- ruoli_profilo_tpk.set_id_profilo
   --------------------------------------------------------------------------------
   procedure set_ruolo
   (
      p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type
     ,p_value            in ruoli_profilo.ruolo%type default null
   ) is
      /******************************************************************************
       NOME:        set_ruolo
       DESCRIZIONE: Setter per attributo ruolo di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_ruolo_profilo => p_id_ruolo_profilo)
             ,'existsId on ruoli_profilo_tpk.set_ruolo');
      update ruoli_profilo
         set ruolo = p_value
       where id_ruolo_profilo = p_id_ruolo_profilo;
   end set_ruolo; -- ruoli_profilo_tpk.set_ruolo
   --------------------------------------------------------------------------------
   procedure set_dal
   (
      p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type
     ,p_value            in ruoli_profilo.dal%type default null
   ) is
      /******************************************************************************
       NOME:        set_dal
       DESCRIZIONE: Setter per attributo dal di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_ruolo_profilo => p_id_ruolo_profilo)
             ,'existsId on ruoli_profilo_tpk.set_dal');
      update ruoli_profilo set dal = p_value where id_ruolo_profilo = p_id_ruolo_profilo;
   end set_dal; -- ruoli_profilo_tpk.set_dal
   --------------------------------------------------------------------------------
   procedure set_al
   (
      p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type
     ,p_value            in ruoli_profilo.al%type default null
   ) is
      /******************************************************************************
       NOME:        set_al
       DESCRIZIONE: Setter per attributo al di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_ruolo_profilo => p_id_ruolo_profilo)
             ,'existsId on ruoli_profilo_tpk.set_al');
      update ruoli_profilo set al = p_value where id_ruolo_profilo = p_id_ruolo_profilo;
   end set_al; -- ruoli_profilo_tpk.set_al
   --------------------------------------------------------------------------------
   procedure set_utente_aggiornamento
   (
      p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type
     ,p_value            in ruoli_profilo.utente_aggiornamento%type default null
   ) is
      /******************************************************************************
       NOME:        set_utente_aggiornamento
       DESCRIZIONE: Setter per attributo utente_aggiornamento di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_ruolo_profilo => p_id_ruolo_profilo)
             ,'existsId on ruoli_profilo_tpk.set_utente_aggiornamento');
      update ruoli_profilo
         set utente_aggiornamento = p_value
       where id_ruolo_profilo = p_id_ruolo_profilo;
   end set_utente_aggiornamento; -- ruoli_profilo_tpk.set_utente_aggiornamento
   --------------------------------------------------------------------------------
   procedure set_data_aggiornamento
   (
      p_id_ruolo_profilo in ruoli_profilo.id_ruolo_profilo%type
     ,p_value            in ruoli_profilo.data_aggiornamento%type default null
   ) is
      /******************************************************************************
       NOME:        set_data_aggiornamento
       DESCRIZIONE: Setter per attributo data_aggiornamento di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_ruolo_profilo => p_id_ruolo_profilo)
             ,'existsId on ruoli_profilo_tpk.set_data_aggiornamento');
      update ruoli_profilo
         set data_aggiornamento = p_value
       where id_ruolo_profilo = p_id_ruolo_profilo;
   end set_data_aggiornamento; -- ruoli_profilo_tpk.set_data_aggiornamento
   --------------------------------------------------------------------------------
   function where_condition /* SLAVE_COPY */
   (
      p_qbe                  in number default 0
     ,p_other_condition      in varchar2 default null
     ,p_id_ruolo_profilo     in varchar2 default null
     ,p_id_profilo           in varchar2 default null
     ,p_ruolo                in varchar2 default null
     ,p_dal                  in varchar2 default null
     ,p_al                   in varchar2 default null
     ,p_utente_aggiornamento in varchar2 default null
     ,p_data_aggiornamento   in varchar2 default null
   ) return afc.t_statement is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        where_condition
       DESCRIZIONE: Ritorna la where_condition per lo statement di select di get_rows e count_rows. 
       PARAMETRI:   p_QBE 0: viene controllato se all'inizio di ogni attributo e presente
                             un operatore, altrimenti viene usato quello di default ('=')
                          1: viene utilizzato l'operatore specificato all'inizio di ogni
                             attributo.
                    p_other_condition: condizioni aggiuntive di base
                    Chiavi e attributi della table
       RITORNA:     AFC.t_statement.
       NOTE:        Se p_QBE = 1 , ogni parametro deve contenere, nella prima parte,
                    l'operatore da utilizzare nella where-condition.
      ******************************************************************************/
      d_statement afc.t_statement;
   begin
      d_statement := ' where ( 1 = 1 ' ||
                     afc.get_field_condition(' and ( id_ruolo_profilo '
                                            ,p_id_ruolo_profilo
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( id_profilo '
                                            ,p_id_profilo
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( ruolo ', p_ruolo, ' )', p_qbe, null) ||
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
   end where_condition; --- ruoli_profilo_tpk.where_condition
   --------------------------------------------------------------------------------
   function get_rows
   (
      p_qbe                  in number default 0
     ,p_other_condition      in varchar2 default null
     ,p_order_by             in varchar2 default null
     ,p_extra_columns        in varchar2 default null
     ,p_extra_condition      in varchar2 default null
     ,p_id_ruolo_profilo     in varchar2 default null
     ,p_id_profilo           in varchar2 default null
     ,p_ruolo                in varchar2 default null
     ,p_dal                  in varchar2 default null
     ,p_al                   in varchar2 default null
     ,p_utente_aggiornamento in varchar2 default null
     ,p_data_aggiornamento   in varchar2 default null
   ) return afc.t_ref_cursor is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_rows
       DESCRIZIONE: Ritorna il risultato di una query in base ai valori che passiamo. 
       PARAMETRI:   p_QBE 0: viene controllato se all'inizio di ogni attributo e presente
                             un operatore, altrimenti viene usato quello di default ('=')
                          1: viene utilizzato l'operatore specificato all'inizio di ogni
                             attributo.
                    p_other_condition: condizioni aggiuntive di base
                    p_order_by: condizioni di ordinamento
                    p_extra_columns: colonne da aggiungere alla select
                    p_extra_condition: condizioni aggiuntive 
                    Chiavi e attributi della table
       RITORNA:     Un ref_cursor che punta al risultato della query.
       NOTE:        Se p_QBE = 1 , ogni parametro deve contenere, nella prima parte,
                    l'operatore da utilizzare nella where-condition.
                    In p_extra_columns e p_order_by non devono essere passati anche la
                    virgola iniziale (per p_extra_columns) e la stringa 'order by' (per
                    p_order_by)
      ******************************************************************************/
      d_statement  afc.t_statement;
      d_ref_cursor afc.t_ref_cursor;
   begin
      d_statement  := ' select RUOLI_PROFILO.* ' ||
                      afc.decode_value(p_extra_columns
                                      ,null
                                      ,null
                                      ,' , ' || p_extra_columns) ||
                      ' from RUOLI_PROFILO ' ||
                      where_condition(p_qbe                  => p_qbe
                                     ,p_other_condition      => p_other_condition
                                     ,p_id_ruolo_profilo     => p_id_ruolo_profilo
                                     ,p_id_profilo           => p_id_profilo
                                     ,p_ruolo                => p_ruolo
                                     ,p_dal                  => p_dal
                                     ,p_al                   => p_al
                                     ,p_utente_aggiornamento => p_utente_aggiornamento
                                     ,p_data_aggiornamento   => p_data_aggiornamento) || ' ' ||
                      p_extra_condition ||
                      afc.decode_value(p_order_by, null, null, ' order by ' || p_order_by);
      d_ref_cursor := afc_dml.get_ref_cursor(d_statement);
      return d_ref_cursor;
   end get_rows; -- ruoli_profilo_tpk.get_rows
   --------------------------------------------------------------------------------
   function count_rows
   (
      p_qbe                  in number default 0
     ,p_other_condition      in varchar2 default null
     ,p_id_ruolo_profilo     in varchar2 default null
     ,p_id_profilo           in varchar2 default null
     ,p_ruolo                in varchar2 default null
     ,p_dal                  in varchar2 default null
     ,p_al                   in varchar2 default null
     ,p_utente_aggiornamento in varchar2 default null
     ,p_data_aggiornamento   in varchar2 default null
   ) return integer is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        count_rows
       DESCRIZIONE: Ritorna il numero di righe della tabella gli attributi delle quali
                    rispettano i valori indicati.
       PARAMETRI:   p_QBE 0: viene controllato se all'inizio di ogni attributo e presente
                             un operatore, altrimenti viene usato quello di default ('=')
                          1: viene utilizzato l'operatore specificato all'inizio di ogni
                             attributo.
                    p_other_condition: condizioni aggiuntive di base
                    Chiavi e attributi della table
       RITORNA:     Numero di righe che rispettano la selezione indicata.
      ******************************************************************************/
      d_result    integer;
      d_statement afc.t_statement;
   begin
      d_statement := ' select count( * ) from RUOLI_PROFILO ' ||
                     where_condition(p_qbe                  => p_qbe
                                    ,p_other_condition      => p_other_condition
                                    ,p_id_ruolo_profilo     => p_id_ruolo_profilo
                                    ,p_id_profilo           => p_id_profilo
                                    ,p_ruolo                => p_ruolo
                                    ,p_dal                  => p_dal
                                    ,p_al                   => p_al
                                    ,p_utente_aggiornamento => p_utente_aggiornamento
                                    ,p_data_aggiornamento   => p_data_aggiornamento);
      d_result    := afc.sql_execute(d_statement);
      return d_result;
   end count_rows; -- ruoli_profilo_tpk.count_rows
--------------------------------------------------------------------------------

end ruoli_profilo_tpk;
/

