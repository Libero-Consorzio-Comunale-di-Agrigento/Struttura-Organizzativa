CREATE OR REPLACE package body modifica_componente is
   /******************************************************************************
    NOME:        modifica_componente
    DESCRIZIONE: Gestione tabella MODIFICHE_COMPONENTI.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore   Descrizione.
    000   12/08/2011  mmonari  Generazione automatica.
    001   02/07/2012  mmonari  Consolidamento rel.1.4.1
    002   02/11/2012  Adadamo  Modifica alla aggiorna_ottica_derivata per gestione
                               commit
    003   18/08/2014  MMonari  Migliorate le segnalazioni di non applicabilita' in aggiorna_ottica_derivata #208
          21/08/2014  MMonari  Miglioramento della gestione delle modifiche generate da componente.sposta_componente #313
          11/08/2015  MMonari  #636
          16/09/2015  MMonari  #500 correzione di aggiorna_ottica_derivata 
   ******************************************************************************/
   s_revisione_body constant afc.t_revision := '003 - 21/08/2014';
   s_error_table afc_error.t_error_table;
   s_dummy       varchar2(1);
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
   end versione; -- modifica_componente.versione
   --------------------------------------------------------------------------------
   function pk(p_id_modifica in modifiche_componenti.id_modifica%type) return t_pk is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        PK
       DESCRIZIONE: Costruttore di un t_PK dati gli attributi della chiave
      ******************************************************************************/
      d_result t_pk;
   begin
      d_result.id_modifica := p_id_modifica;
      dbc.pre(not dbc.preon or canhandle(p_id_modifica => d_result.id_modifica)
             ,'canHandle on modifica_componente.PK');
      return d_result;
   end pk; -- modifica_componente.PK
   --------------------------------------------------------------------------------
   function can_handle(p_id_modifica in modifiche_componenti.id_modifica%type) return number is
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
      if d_result = 1 and (p_id_modifica is null) then
         d_result := 0;
      end if;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on modifica_componente.can_handle');
      return d_result;
   end can_handle; -- modifica_componente.can_handle
   --------------------------------------------------------------------------------
   function canhandle(p_id_modifica in modifiche_componenti.id_modifica%type) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        canHandle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: true se la chiave e manipolabile, false altrimenti.
       NOTE:        Wrapper boolean di can_handle (cfr. can_handle).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(can_handle(p_id_modifica => p_id_modifica));
   begin
      return d_result;
   end canhandle; -- modifica_componente.canHandle
   --------------------------------------------------------------------------------
   function exists_id(p_id_modifica in modifiche_componenti.id_modifica%type) return number is
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
      dbc.pre(not dbc.preon or canhandle(p_id_modifica => p_id_modifica)
             ,'canHandle on modifica_componente.exists_id');
      begin
         select 1
           into d_result
           from modifiche_componenti
          where id_modifica = p_id_modifica;
      exception
         when no_data_found then
            d_result := 0;
      end;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on modifica_componente.exists_id');
      return d_result;
   end exists_id; -- modifica_componente.exists_id
   --------------------------------------------------------------------------------
   function existsid(p_id_modifica in modifiche_componenti.id_modifica%type) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        existsId
       DESCRIZIONE: Esistenza riga con chiave indicata.
       NOTE:        Wrapper boolean di exists_id (cfr. exists_id).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(exists_id(p_id_modifica => p_id_modifica));
   begin
      return d_result;
   end existsid; -- modifica_componente.existsId
   --------------------------------------------------------------------------------
   procedure ins
   (
      p_id_modifica             in modifiche_componenti.id_modifica%type default null
     ,p_ottica                  in modifiche_componenti.ottica%type
     ,p_id_componente           in modifiche_componenti.id_componente%type default null
     ,p_id_attributo_componente in modifiche_componenti.id_attributo_componente%type default null
     ,p_operazione              in modifiche_componenti.operazione%type default null
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
             ,'p_ottica on modifica_componente.ins');
      dbc.pre(not dbc.preon or p_id_componente is not null or /*default value*/
              'default' is not null
             ,'p_id_componente on modifica_componente.ins');
      dbc.pre(not dbc.preon or p_id_attributo_componente is not null or /*default value*/
              'default' is not null
             ,'p_id_attributo_componente on modifica_componente.ins');
      dbc.pre(not dbc.preon or p_operazione is not null or /*default value*/
              'default' is not null
             ,'p_operazione on modifica_componente.ins');
      dbc.pre(not dbc.preon or (p_id_modifica is null and /*default value*/
              'default null' is not null) -- PK nullable on insert
              or not existsid(p_id_modifica => p_id_modifica)
             ,'not existsId on modifica_componente.ins');
      insert into modifiche_componenti
         (id_modifica
         ,ottica
         ,id_componente
         ,id_attributo_componente
         ,operazione)
      values
         (p_id_modifica
         ,p_ottica
         ,p_id_componente
         ,p_id_attributo_componente
         ,p_operazione);
   end ins; -- modifica_componente.ins
   --------------------------------------------------------------------------------
   function ins
   (
      p_id_modifica             in modifiche_componenti.id_modifica%type default null
     ,p_ottica                  in modifiche_componenti.ottica%type
     ,p_id_componente           in modifiche_componenti.id_componente%type default null
     ,p_id_attributo_componente in modifiche_componenti.id_attributo_componente%type default null
     ,p_operazione              in modifiche_componenti.operazione%type default null
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
      dbc.pre(not dbc.preon or p_ottica is not null or /*default value*/
              '' is not null
             ,'p_ottica on modifica_componente.ins');
      dbc.pre(not dbc.preon or p_id_componente is not null or /*default value*/
              'default' is not null
             ,'p_id_componente on modifica_componente.ins');
      dbc.pre(not dbc.preon or p_id_attributo_componente is not null or /*default value*/
              'default' is not null
             ,'p_id_attributo_componente on modifica_componente.ins');
      dbc.pre(not dbc.preon or p_operazione is not null or /*default value*/
              'default' is not null
             ,'p_operazione on modifica_componente.ins');
      dbc.pre(not dbc.preon or (p_id_modifica is null and /*default value*/
              'default null' is not null) -- PK nullable on insert
              or not existsid(p_id_modifica => p_id_modifica)
             ,'not existsId on modifica_componente.ins');
      insert into modifiche_componenti
         (id_modifica
         ,ottica
         ,id_componente
         ,id_attributo_componente
         ,operazione)
      values
         (p_id_modifica
         ,p_ottica
         ,p_id_componente
         ,p_id_attributo_componente
         ,p_operazione)
      returning id_modifica into d_result;
      return d_result;
   end ins; -- modifica_componente.ins
   --------------------------------------------------------------------------------
   procedure upd
   (
      p_check_old                   in integer default 0
     ,p_new_id_modifica             in modifiche_componenti.id_modifica%type
     ,p_old_id_modifica             in modifiche_componenti.id_modifica%type default null
     ,p_new_ottica                  in modifiche_componenti.ottica%type default afc.default_null('MODIFICHE_COMPONENTI.ottica')
     ,p_old_ottica                  in modifiche_componenti.ottica%type default null
     ,p_new_id_componente           in modifiche_componenti.id_componente%type default afc.default_null('MODIFICHE_COMPONENTI.id_componente')
     ,p_old_id_componente           in modifiche_componenti.id_componente%type default null
     ,p_new_id_attributo_componente in modifiche_componenti.id_attributo_componente%type default afc.default_null('MODIFICHE_COMPONENTI.id_attributo_componente')
     ,p_old_id_attributo_componente in modifiche_componenti.id_attributo_componente%type default null
     ,p_new_operazione              in modifiche_componenti.operazione%type default afc.default_null('MODIFICHE_COMPONENTI.operazione')
     ,p_old_operazione              in modifiche_componenti.operazione%type default null
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
      d_key       t_pk;
      d_row_found number;
   begin
      dbc.pre(not dbc.preon or
              not ((p_old_ottica is not null or p_old_id_componente is not null or
               p_old_id_attributo_componente is not null or
               p_old_operazione is not null) and (nvl(p_check_old, -1) = 0))
             ,' "OLD values" is not null on modifica_componente.upd');
      d_key := pk(nvl(p_old_id_modifica, p_new_id_modifica));
      dbc.pre(not dbc.preon or existsid(p_id_modifica => d_key.id_modifica)
             ,'existsId on modifica_componente.upd');
      update modifiche_componenti
         set id_modifica             = nvl(p_new_id_modifica
                                          ,decode(afc.is_default_null('MODIFICHE_COMPONENTI.id_modifica')
                                                 ,1
                                                 ,id_modifica
                                                 ,decode(p_check_old
                                                        ,0
                                                        ,null
                                                        ,decode(p_old_id_modifica
                                                               ,null
                                                               ,id_modifica
                                                               ,null))))
            ,ottica                  = nvl(p_new_ottica
                                          ,decode(afc.is_default_null('MODIFICHE_COMPONENTI.ottica')
                                                 ,1
                                                 ,ottica
                                                 ,decode(p_check_old
                                                        ,0
                                                        ,null
                                                        ,decode(p_old_ottica
                                                               ,null
                                                               ,ottica
                                                               ,null))))
            ,id_componente           = nvl(p_new_id_componente
                                          ,decode(afc.is_default_null('MODIFICHE_COMPONENTI.id_componente')
                                                 ,1
                                                 ,id_componente
                                                 ,decode(p_check_old
                                                        ,0
                                                        ,null
                                                        ,decode(p_old_id_componente
                                                               ,null
                                                               ,id_componente
                                                               ,null))))
            ,id_attributo_componente = nvl(p_new_id_attributo_componente
                                          ,decode(afc.is_default_null('MODIFICHE_COMPONENTI.id_attributo_componente')
                                                 ,1
                                                 ,id_attributo_componente
                                                 ,decode(p_check_old
                                                        ,0
                                                        ,null
                                                        ,decode(p_old_id_attributo_componente
                                                               ,null
                                                               ,id_attributo_componente
                                                               ,null))))
            ,operazione              = nvl(p_new_operazione
                                          ,decode(afc.is_default_null('MODIFICHE_COMPONENTI.operazione')
                                                 ,1
                                                 ,operazione
                                                 ,decode(p_check_old
                                                        ,0
                                                        ,null
                                                        ,decode(p_old_operazione
                                                               ,null
                                                               ,operazione
                                                               ,null))))
       where id_modifica = d_key.id_modifica
         and (p_check_old = 0 or
             (1 = 1 and
             (ottica = p_old_ottica or
             (p_old_ottica is null and (p_check_old is null or ottica is null))) and
             (id_componente = p_old_id_componente or
             (p_old_id_componente is null and
             (p_check_old is null or id_componente is null))) and
             (id_attributo_componente = p_old_id_attributo_componente or
             (p_old_id_attributo_componente is null and
             (p_check_old is null or id_attributo_componente is null))) and
             (operazione = p_old_operazione or
             (p_old_operazione is null and (p_check_old is null or operazione is null)))));
      d_row_found := sql%rowcount;
      afc.default_null(null);
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on modifica_componente.upd');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   end upd; -- modifica_componente.upd
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_id_modifica   in modifiche_componenti.id_modifica%type
     ,p_column        in varchar2
     ,p_value         in varchar2 default null
     ,p_literal_value in number default 1
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
      dbc.pre(not dbc.preon or existsid(p_id_modifica => p_id_modifica)
             ,'existsId on modifica_componente.upd_column');
      dbc.pre(not dbc.preon or p_column is not null
             ,'p_column is not null on modifica_componente.upd_column');
      dbc.pre(not dbc.preon or afc_ddl.hasattribute(s_table_name, p_column)
             ,'AFC_DDL.HasAttribute on modifica_componente.upd_column');
      dbc.pre(p_literal_value in (0, 1) or p_literal_value is null
             ,'p_literal_value on modifica_componente.upd_column; p_literal_value = ' ||
              p_literal_value);
      if p_literal_value = 1 or p_literal_value is null then
         d_literal := '''';
      end if;
      d_statement := ' declare ' || '    d_row_found number; ' || ' begin ' ||
                     '    update MODIFICHE_COMPONENTI ' || '       set ' || p_column ||
                     ' = ' || d_literal || p_value || d_literal || '     where 1 = 1 ' ||
                     nvl(afc.get_field_condition(' and ( id_modifica '
                                                ,p_id_modifica
                                                ,' )'
                                                ,0
                                                ,null)
                        ,' and ( id_modifica is null ) ') || '    ; ' ||
                     '    d_row_found := SQL%ROWCOUNT; ' || '    if d_row_found < 1 ' ||
                     '    then ' ||
                     '       raise_application_error ( AFC_ERROR.modified_by_other_user_number, AFC_ERROR.modified_by_other_user_msg ); ' ||
                     '    end if; ' || ' end; ';
      afc.sql_execute(d_statement);
   end upd_column; -- modifica_componente.upd_column
   --------------------------------------------------------------------------------
   procedure del
   (
      p_check_old               in integer default 0
     ,p_id_modifica             in modifiche_componenti.id_modifica%type
     ,p_ottica                  in modifiche_componenti.ottica%type default null
     ,p_id_componente           in modifiche_componenti.id_componente%type default null
     ,p_id_attributo_componente in modifiche_componenti.id_attributo_componente%type default null
     ,p_operazione              in modifiche_componenti.operazione%type default null
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
      dbc.pre(not dbc.preon or
              not ((p_ottica is not null or p_id_componente is not null or
               p_id_attributo_componente is not null or p_operazione is not null) and
               (nvl(p_check_old, -1) = 0))
             ,' "OLD values" is not null on modifica_componente.del');
      dbc.pre(not dbc.preon or existsid(p_id_modifica => p_id_modifica)
             ,'existsId on modifica_componente.del');
      delete from modifiche_componenti
       where id_modifica = p_id_modifica
         and (p_check_old = 0 or
             (1 = 1 and (ottica = p_ottica or
             (p_ottica is null and (p_check_old is null or ottica is null))) and
             (id_componente = p_id_componente or
             (p_id_componente is null and
             (p_check_old is null or id_componente is null))) and
             (id_attributo_componente = p_id_attributo_componente or
             (p_id_attributo_componente is null and
             (p_check_old is null or id_attributo_componente is null))) and
             (operazione = p_operazione or
             (p_operazione is null and (p_check_old is null or operazione is null)))));
      d_row_found := sql%rowcount;
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on modifica_componente.del');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
      dbc.post(not dbc.poston or not existsid(p_id_modifica => p_id_modifica)
              ,'existsId on modifica_componente.del');
   end del; -- modifica_componente.del
   --------------------------------------------------------------------------------
   function get_ottica(p_id_modifica in modifiche_componenti.id_modifica%type)
      return modifiche_componenti.ottica%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_ottica
       DESCRIZIONE: Getter per attributo ottica di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     MODIFICHE_COMPONENTI.ottica%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result modifiche_componenti.ottica%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_modifica => p_id_modifica)
             ,'existsId on modifica_componente.get_ottica');
      select ottica
        into d_result
        from modifiche_componenti
       where id_modifica = p_id_modifica;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on modifica_componente.get_ottica');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'ottica')
                      ,' AFC_DDL.IsNullable on modifica_componente.get_ottica');
      end if;
      return d_result;
   end get_ottica; -- modifica_componente.get_ottica
   --------------------------------------------------------------------------------
   function get_id_componente(p_id_modifica in modifiche_componenti.id_modifica%type)
      return modifiche_componenti.id_componente%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_id_componente
       DESCRIZIONE: Getter per attributo id_componente di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     MODIFICHE_COMPONENTI.id_componente%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result modifiche_componenti.id_componente%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_modifica => p_id_modifica)
             ,'existsId on modifica_componente.get_id_componente');
      select id_componente
        into d_result
        from modifiche_componenti
       where id_modifica = p_id_modifica;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on modifica_componente.get_id_componente');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'id_componente')
                      ,' AFC_DDL.IsNullable on modifica_componente.get_id_componente');
      end if;
      return d_result;
   end get_id_componente; -- modifica_componente.get_id_componente
   --------------------------------------------------------------------------------
   function get_id_attributo_componente(p_id_modifica in modifiche_componenti.id_modifica%type)
      return modifiche_componenti.id_attributo_componente%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_id_attributo_componente
       DESCRIZIONE: Getter per attributo id_attributo_componente di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     MODIFICHE_COMPONENTI.id_attributo_componente%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result modifiche_componenti.id_attributo_componente%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_modifica => p_id_modifica)
             ,'existsId on modifica_componente.get_id_attributo_componente');
      select id_attributo_componente
        into d_result
        from modifiche_componenti
       where id_modifica = p_id_modifica;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on modifica_componente.get_id_attributo_componente');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'id_attributo_componente')
                      ,' AFC_DDL.IsNullable on modifica_componente.get_id_attributo_componente');
      end if;
      return d_result;
   end get_id_attributo_componente; -- modifica_componente.get_id_attributo_componente
   --------------------------------------------------------------------------------
   function get_operazione(p_id_modifica in modifiche_componenti.id_modifica%type)
      return modifiche_componenti.operazione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_operazione
       DESCRIZIONE: Getter per attributo operazione di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     MODIFICHE_COMPONENTI.operazione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result modifiche_componenti.operazione%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_modifica => p_id_modifica)
             ,'existsId on modifica_componente.get_operazione');
      select operazione
        into d_result
        from modifiche_componenti
       where id_modifica = p_id_modifica;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on modifica_componente.get_operazione');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'operazione')
                      ,' AFC_DDL.IsNullable on modifica_componente.get_operazione');
      end if;
      return d_result;
   end get_operazione; -- modifica_componente.get_operazione
   --------------------------------------------------------------------------------
   procedure set_id_modifica
   (
      p_id_modifica in modifiche_componenti.id_modifica%type
     ,p_value       in modifiche_componenti.id_modifica%type default null
   ) is
      /******************************************************************************
       NOME:        set_id_modifica
       DESCRIZIONE: Setter per attributo id_modifica di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_modifica => p_id_modifica)
             ,'existsId on modifica_componente.set_id_modifica');
      update modifiche_componenti
         set id_modifica = p_value
       where id_modifica = p_id_modifica;
   end set_id_modifica; -- modifica_componente.set_id_modifica
   --------------------------------------------------------------------------------
   procedure set_ottica
   (
      p_id_modifica in modifiche_componenti.id_modifica%type
     ,p_value       in modifiche_componenti.ottica%type default null
   ) is
      /******************************************************************************
       NOME:        set_ottica
       DESCRIZIONE: Setter per attributo ottica di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_modifica => p_id_modifica)
             ,'existsId on modifica_componente.set_ottica');
      update modifiche_componenti set ottica = p_value where id_modifica = p_id_modifica;
   end set_ottica; -- modifica_componente.set_ottica
   --------------------------------------------------------------------------------
   procedure set_id_componente
   (
      p_id_modifica in modifiche_componenti.id_modifica%type
     ,p_value       in modifiche_componenti.id_componente%type default null
   ) is
      /******************************************************************************
       NOME:        set_id_componente
       DESCRIZIONE: Setter per attributo id_componente di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_modifica => p_id_modifica)
             ,'existsId on modifica_componente.set_id_componente');
      update modifiche_componenti
         set id_componente = p_value
       where id_modifica = p_id_modifica;
   end set_id_componente; -- modifica_componente.set_id_componente
   --------------------------------------------------------------------------------
   procedure set_id_attributo_componente
   (
      p_id_modifica in modifiche_componenti.id_modifica%type
     ,p_value       in modifiche_componenti.id_attributo_componente%type default null
   ) is
      /******************************************************************************
       NOME:        set_id_attributo_componente
       DESCRIZIONE: Setter per attributo id_attributo_componente di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_modifica => p_id_modifica)
             ,'existsId on modifica_componente.set_id_attributo_componente');
      update modifiche_componenti
         set id_attributo_componente = p_value
       where id_modifica = p_id_modifica;
   end set_id_attributo_componente; -- modifica_componente.set_id_attributo_componente
   --------------------------------------------------------------------------------
   procedure set_operazione
   (
      p_id_modifica in modifiche_componenti.id_modifica%type
     ,p_value       in modifiche_componenti.operazione%type default null
   ) is
      /******************************************************************************
       NOME:        set_operazione
       DESCRIZIONE: Setter per attributo operazione di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_modifica => p_id_modifica)
             ,'existsId on modifica_componente.set_operazione');
      update modifiche_componenti
         set operazione = p_value
       where id_modifica = p_id_modifica;
   end set_operazione; -- modifica_componente.set_operazione
   --------------------------------------------------------------------------------
   function where_condition /* SLAVE_COPY */
   (
      p_qbe                     in number default 0
     ,p_other_condition         in varchar2 default null
     ,p_id_modifica             in varchar2 default null
     ,p_ottica                  in varchar2 default null
     ,p_id_componente           in varchar2 default null
     ,p_id_attributo_componente in varchar2 default null
     ,p_operazione              in varchar2 default null
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
                     afc.get_field_condition(' and ( id_modifica '
                                            ,p_id_modifica
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( ottica '
                                            ,p_ottica
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( id_componente '
                                            ,p_id_componente
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( id_attributo_componente '
                                            ,p_id_attributo_componente
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( operazione '
                                            ,p_operazione
                                            ,' )'
                                            ,p_qbe
                                            ,null) || ' ) ' || p_other_condition;
      return d_statement;
   end where_condition; --- modifica_componente.where_condition
   --------------------------------------------------------------------------------
   function get_rows
   (
      p_qbe                     in number default 0
     ,p_other_condition         in varchar2 default null
     ,p_order_by                in varchar2 default null
     ,p_extra_columns           in varchar2 default null
     ,p_extra_condition         in varchar2 default null
     ,p_id_modifica             in varchar2 default null
     ,p_ottica                  in varchar2 default null
     ,p_id_componente           in varchar2 default null
     ,p_id_attributo_componente in varchar2 default null
     ,p_operazione              in varchar2 default null
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
      d_statement  := ' select MODIFICHE_COMPONENTI.* ' ||
                      afc.decode_value(p_extra_columns
                                      ,null
                                      ,null
                                      ,' , ' || p_extra_columns) ||
                      ' from MODIFICHE_COMPONENTI ' ||
                      where_condition(p_qbe                     => p_qbe
                                     ,p_other_condition         => p_other_condition
                                     ,p_id_modifica             => p_id_modifica
                                     ,p_ottica                  => p_ottica
                                     ,p_id_componente           => p_id_componente
                                     ,p_id_attributo_componente => p_id_attributo_componente
                                     ,p_operazione              => p_operazione) || ' ' ||
                      p_extra_condition ||
                      afc.decode_value(p_order_by, null, null, ' order by ' || p_order_by);
      d_ref_cursor := afc_dml.get_ref_cursor(d_statement);
      return d_ref_cursor;
   end get_rows; -- modifica_componente.get_rows
   --------------------------------------------------------------------------------
   function count_rows
   (
      p_qbe                     in number default 0
     ,p_other_condition         in varchar2 default null
     ,p_id_modifica             in varchar2 default null
     ,p_ottica                  in varchar2 default null
     ,p_id_componente           in varchar2 default null
     ,p_id_attributo_componente in varchar2 default null
     ,p_operazione              in varchar2 default null
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
      d_statement := ' select count( * ) from MODIFICHE_COMPONENTI ' ||
                     where_condition(p_qbe                     => p_qbe
                                    ,p_other_condition         => p_other_condition
                                    ,p_id_modifica             => p_id_modifica
                                    ,p_ottica                  => p_ottica
                                    ,p_id_componente           => p_id_componente
                                    ,p_id_attributo_componente => p_id_attributo_componente
                                    ,p_operazione              => p_operazione);
      d_result    := afc.sql_execute(d_statement);
      return d_result;
   end count_rows; -- modifica_componente.count_rows
   --------------------------------------------------------------------------------
   function get_id return modifiche_componenti.id_modifica%type is
      /******************************************************************************
       NOME:        get_id
       DESCRIZIONE: Attributo id per inserimento nuova modifica
       PARAMETRI:
       NOTE:
      ******************************************************************************/
      d_result modifiche_componenti.id_modifica%type;
   begin
      select nvl(max(id_modifica), 0) + 1 into d_result from modifiche_componenti;
      return d_result;
   end; -- modifica_componente.get_id
   --------------------------------------------------------------------------------
   procedure aggiorna_ottica_derivata
   (
      p_id_modifica            in modifiche_componenti.id_modifica%type
     ,p_ottica_derivata        in ottiche.ottica%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
     ,p_trigger                in number default 0
   ) is
      /******************************************************************************
       NOME:        aggiorna_ottica_derivata
       DESCRIZIONE: esegue l'operazione richiesta sull'ottica derivata
       PARAMETRI:
       NOTE:
      ******************************************************************************/
      d_modifica_applicabile boolean := false;
      d_dal                  date;
      d_al                   date;
      d_progr_uo             unita_organizzative.progr_unita_organizzativa%type;
      d_modifica             modifiche_componenti%rowtype;
      d_comp                 componenti%rowtype;
      d_id_componente        componenti.id_componente%type;
      d_dummy                varchar2(1);
      d_nominativo           varchar2(120);
      errore                   exception;
      modifica_non_applicabile exception;
      d_rev_attivazione number(1) := revisione_struttura.s_attivazione; --#500
   begin
      begin
         --determina attributi modifica
         begin
            select *
              into d_modifica
              from modifiche_componenti
             where id_modifica = p_id_modifica;
         exception
            when no_data_found then
               raise errore;
         end;
         --determino i dati dell'assegnazione dell'ottica di origine
         begin
            select *
              into d_comp
              from componenti c
             where id_componente = d_modifica.id_componente;
         exception
            when no_data_found then
               raise errore;
         end;
         select cognome || '  ' || nome
           into d_nominativo
           from anagrafe_soggetti
          where ni = d_comp.ni;
         --verifica se la modifica è applicabile nell'ottica derivata,
         --determinando al contempo l'intervallo di compatibilita'
         begin
            select greatest(u.dal, d_comp.dal)
                  ,decode(least(nvl(u.al, to_date(3333333, 'j'))
                               ,nvl(d_comp.al, to_date(3333333, 'j')))
                         ,to_date(3333333, 'j')
                         ,to_date(null)
                         ,least(nvl(u.al, to_date(3333333, 'j'))
                               ,nvl(d_comp.al, to_date(3333333, 'j'))))
              into d_dal
                  ,d_al
              from unita_organizzative u
             where ottica = p_ottica_derivata
               and progr_unita_organizzativa = d_comp.progr_unita_organizzativa
               and (dal <= nvl(d_comp.al, to_date(3333333, 'j')) or --#313
                   dal <= nvl(d_comp.al_prec, to_date(3333333, 'j')))
               and nvl(al, to_date(3333333, 'j')) >= d_comp.dal;
            d_modifica_applicabile := true;
         exception
            when no_data_found then
               raise modifica_non_applicabile;
         end;
         if d_modifica_applicabile then
            declare
               d_atco attributi_componente%rowtype;
            begin
               if d_modifica.operazione in ('N', 'S') then
                  -- nuovo individuo o nuovo periodo di assegnazione:
                  -- il componente viene assegnato all'UO corrispondente dell'ottica derivata,
                  -- limitatamente al periodo per cui è definita la UO stessa
                  begin
                     select *
                       into d_atco
                       from attributi_componente
                      where id_componente = d_comp.id_componente
                        and nvl(d_al, to_date(3333333, 'j')) between dal and
                            nvl(al, to_date(3333333, 'j'));
                     select componenti_sq.nextval into d_id_componente from dual;
                     componente.ins(p_id_componente             => d_id_componente
                                   ,p_progr_unita_organizzativa => d_comp.progr_unita_organizzativa
                                   ,p_dal                       => d_dal
                                   ,p_al                        => d_al
                                   ,p_ni                        => d_comp.ni
                                   ,p_ci                        => d_comp.ci
                                   ,p_codice_fiscale            => d_comp.codice_fiscale
                                   ,p_denominazione             => d_comp.denominazione
                                   ,p_denominazione_al1         => d_comp.denominazione_al1
                                   ,p_denominazione_al2         => d_comp.denominazione_al2
                                   ,p_stato                     => 'P'
                                   ,p_ottica                    => p_ottica_derivata
                                   ,p_revisione_assegnazione    => ''
                                   ,p_revisione_cessazione      => ''
                                   ,p_utente_aggiornamento      => 'Ott.Der'
                                   ,p_data_aggiornamento        => sysdate);
                     attributo_componente.ins(p_id_attr_componente      => ''
                                             ,p_id_componente           => d_id_componente
                                             ,p_dal                     => d_dal
                                             ,p_al                      => d_al
                                             ,p_incarico                => d_atco.incarico
                                             ,p_telefono                => d_atco.telefono
                                             ,p_fax                     => d_atco.fax
                                             ,p_e_mail                  => d_atco.e_mail
                                             ,p_assegnazione_prevalente => 88 /*d_atco.assegnazione_prevalente  + 30  #636 */
                                             ,p_tipo_assegnazione       => 'F'
                                             ,p_percentuale_impiego     => d_atco.percentuale_impiego
                                             ,p_ottica                  => p_ottica_derivata
                                             ,p_revisione_assegnazione  => ''
                                             ,p_revisione_cessazione    => ''
                                             ,p_gradazione              => d_atco.gradazione
                                             ,p_utente_aggiornamento    => 'Ott.Der'
                                             ,p_data_aggiornamento      => sysdate
                                             ,p_voto                    => d_atco.voto);
                  exception
                     when others then
                        if sqlcode between - 20999 and - 20900 then
                           p_segnalazione := s_error_table(sqlcode);
                        else
                           p_segnalazione := 'Errore eliminazione componente NI: ' || ' ' ||
                                             d_comp.ni || '; Causa: ' || sqlerrm;
                        end if;
                        raise errore;
                  end;
               elsif d_modifica.operazione = 'C' then
                  -- chiusura del periodo di assegnazione
                  -- (spostamento o cessazione definitiva)
                  begin
                     --#313
                     select c.id_componente
                       into d_id_componente
                       from componenti c
                      where c.ni = d_comp.ni
                        and c.ottica = p_ottica_derivata
                        and ((d_al between c.dal and nvl(c.al, to_date(3333333, 'j'))) or
                            (nvl(d_comp.al_prec, to_date(3333333, 'j')) between c.dal and
                            nvl(c.al, to_date(3333333, 'j'))))
                        and c.progr_unita_organizzativa =
                            d_comp.progr_unita_organizzativa;
                     revisione_struttura.s_attivazione := 1;
                     update componenti c
                        set c.al                   = d_al
                           ,c.al_pubb              = d_comp.al_pubb
                           ,c.data_aggiornamento   = sysdate
                           ,c.utente_aggiornamento = 'Ott.Der'
                      where c.id_componente = d_id_componente;
                     if d_rev_attivazione = 0 then
                        --#500
                        revisione_struttura.s_attivazione := 0;
                     end if;
                  exception
                     when no_data_found then
                        p_segnalazione := '; Il periodo chiuso non esiste nell''ottica derivata'; --#208
                        raise modifica_non_applicabile;
                     when others then
                        if sqlcode between - 20999 and - 20900 then
                           p_segnalazione := 'Errore eliminazione componente NI: ' || ' ' ||
                                             d_comp.ni || '; Causa: ' ||
                                             s_error_table(sqlcode);
                        else
                           p_segnalazione := 'Errore eliminazione componente NI: ' || ' ' ||
                                             d_comp.ni || '; Causa: ' || sqlerrm;
                        end if;
                        raise errore;
                  end;
               elsif d_modifica.operazione in ('P', 'U') then
                  -- prolungamento del periodo di assegnazione:
                  -- verifica della compatibilita' del periodo di assegnazione
                  -- con la validita' dell'uo nell'ottica derivata
                  begin
                     select c.id_componente
                       into d_id_componente
                       from componenti c
                      where c.ni = d_comp.ni
                        and c.ottica = p_ottica_derivata
                        and c.dal <= nvl(d_al, to_date(3333333, 'j'))
                        and nvl(c.al, to_date(3333333, 'j')) >= d_dal
                           /*and c.progr_unita_organizzativa =
                           d_comp.progr_unita_organizzativa*/ --#208
                        and not exists
                      (select 'x'
                               from componenti
                              where ni = d_comp.ni
                                and ottica = p_ottica_derivata
                                and progr_unita_organizzativa =
                                    d_comp.progr_unita_organizzativa
                                and id_componente <> d_id_componente
                                and nvl(d_al, to_date(3333333, 'j')) >= dal
                                and d_dal <= nvl(al, to_date(3333333, 'j')));
                     update componenti c
                        set c.al                        = d_al
                           ,c.progr_unita_organizzativa = d_comp.progr_unita_organizzativa --#208
                           ,c.data_aggiornamento        = sysdate
                           ,c.utente_aggiornamento      = 'Ott.Der'
                      where c.id_componente = d_id_componente;
                  exception
                     when no_data_found then
                        p_segnalazione := '; Il periodo da prolungare non esiste nell''ottica derivata'; --#208
                        raise modifica_non_applicabile;
                     when others then
                        if sqlcode between - 20999 and - 20900 then
                           p_segnalazione := 'Errore eliminazione componente NI: ' || ' ' ||
                                             d_comp.ni || '; Causa: ' ||
                                             s_error_table(sqlcode);
                        else
                           p_segnalazione := 'Errore eliminazione componente NI: ' || ' ' ||
                                             d_comp.ni || '; Causa: ' || sqlerrm;
                        end if;
                        raise errore;
                  end;
               elsif d_modifica.operazione = 'E' then
                  -- eliminazione del periodo di assegnazione:
                  -- verifica della compatibilita' del periodo di assegnazione
                  -- con i preesistenti periodi di assegnazione sull'ottica derivata
                  begin
                     select c.id_componente
                       into d_id_componente
                       from componenti c
                      where c.ni = d_comp.ni
                        and c.ottica = p_ottica_derivata
                        and c.dal >= d_dal
                        and nvl(c.al, to_date(3333333, 'j')) <=
                            nvl(d_al, to_date(3333333, 'j'))
                        and c.progr_unita_organizzativa =
                            d_comp.progr_unita_organizzativa;
                     componente.del(d_id_componente);
                  exception
                     when no_data_found then
                        p_segnalazione := '; Il periodo da eliminare non esiste nell''ottica derivata'; --#208
                        raise modifica_non_applicabile;
                     when others then
                        if sqlcode between - 20999 and - 20900 then
                           p_segnalazione := 'Errore eliminazione componente NI: ' || ' ' ||
                                             d_comp.ni || '; Causa: ' ||
                                             s_error_table(sqlcode);
                        else
                           p_segnalazione := 'Errore eliminazione componente NI: ' || ' ' ||
                                             d_comp.ni || '; Causa: ' || sqlerrm;
                        end if;
                        raise errore;
                  end;
               elsif d_modifica.operazione = 'A' then
                  null;
               end if;
               --aggiornamento dello stato di attuazione dell'operazione
               update operazioni_derivate
                  set esecuzione = 1
                where id_modifica = p_id_modifica
                  and ottica = p_ottica_derivata;
               if p_trigger = 0 then
                  -- commit solo se funzione è attivata da interfaccia
                  commit;
               end if;
            end;
         end if;
      exception
         when errore then
            p_segnalazione_bloccante := 'Y';
            p_segnalazione           := 'Errore su aggiornamento di ' || d_nominativo || ' ' ||
                                        p_segnalazione;
         when modifica_non_applicabile then
            p_segnalazione_bloccante := 'Y';
            p_segnalazione           := 'Modifica non applicabile per ' || d_nominativo || ' ' ||
                                        p_segnalazione;
      end;
   end aggiorna_ottica_derivata; -- modifica_componente.aggiorna_ottica_derivata
--------------------------------------------------------------------------------
begin
   -- inserimento degli errori nella tabella
   s_error_table(s_dal_al_errato_number) := s_dal_al_errato_msg;
   s_error_table(s_mod_non_applicabile_number) := s_mod_non_applicabile_msg;
end modifica_componente;
/

