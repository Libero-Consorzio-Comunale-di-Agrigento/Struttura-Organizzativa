CREATE OR REPLACE package body ruoli_derivati_tpk is
   /******************************************************************************
    NOME:        ruoli_derivati_tpk
    DESCRIZIONE: Gestione tabella RUOLI_DERIVATI.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore      Descrizione.
    000   07/07/2014  mmonari  Generazione automatica.  Feature #430
    001   07/08/2015  mmonari  #634
   ******************************************************************************/
   s_revisione_body constant afc.t_revision := '001 - 07/08/2015';
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
   end versione; -- ruoli_derivati_tpk.versione
   --------------------------------------------------------------------------------
   function pk(p_id_ruolo_derivato in ruoli_derivati.id_ruolo_derivato%type) return t_pk is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        PK
       DESCRIZIONE: Costruttore di un t_PK dati gli attributi della chiave
      ******************************************************************************/
      d_result t_pk;
   begin
      d_result.id_ruolo_derivato := p_id_ruolo_derivato;
      dbc.pre(not dbc.preon or
              canhandle(p_id_ruolo_derivato => d_result.id_ruolo_derivato)
             ,'canHandle on ruoli_derivati_tpk.PK');
      return d_result;
   end pk; -- ruoli_derivati_tpk.PK
   --------------------------------------------------------------------------------
   function can_handle(p_id_ruolo_derivato in ruoli_derivati.id_ruolo_derivato%type)
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
      if d_result = 1 and (p_id_ruolo_derivato is null) then
         d_result := 0;
      end if;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on ruoli_derivati_tpk.can_handle');
      return d_result;
   end can_handle; -- ruoli_derivati_tpk.can_handle
   --------------------------------------------------------------------------------
   function canhandle(p_id_ruolo_derivato in ruoli_derivati.id_ruolo_derivato%type)
      return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        canHandle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: true se la chiave e manipolabile, false altrimenti.
       NOTE:        Wrapper boolean di can_handle (cfr. can_handle).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(can_handle(p_id_ruolo_derivato => p_id_ruolo_derivato));
   begin
      return d_result;
   end canhandle; -- ruoli_derivati_tpk.canHandle
   --------------------------------------------------------------------------------
   function exists_id(p_id_ruolo_derivato in ruoli_derivati.id_ruolo_derivato%type)
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
      dbc.pre(not dbc.preon or canhandle(p_id_ruolo_derivato => p_id_ruolo_derivato)
             ,'canHandle on ruoli_derivati_tpk.exists_id');
      begin
         select 1
           into d_result
           from ruoli_derivati
          where id_ruolo_derivato = p_id_ruolo_derivato;
      exception
         when no_data_found then
            d_result := 0;
      end;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on ruoli_derivati_tpk.exists_id');
      return d_result;
   end exists_id; -- ruoli_derivati_tpk.exists_id
   --------------------------------------------------------------------------------
   function existsid(p_id_ruolo_derivato in ruoli_derivati.id_ruolo_derivato%type)
      return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        existsId
       DESCRIZIONE: Esistenza riga con chiave indicata.
       NOTE:        Wrapper boolean di exists_id (cfr. exists_id).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(exists_id(p_id_ruolo_derivato => p_id_ruolo_derivato));
   begin
      return d_result;
   end existsid; -- ruoli_derivati_tpk.existsId
   --------------------------------------------------------------------------------
   procedure ins
   (
      p_id_ruolo_derivato   in ruoli_derivati.id_ruolo_derivato%type default null
     ,p_id_ruolo_componente in ruoli_derivati.id_ruolo_componente%type default null
     ,p_id_profilo          in ruoli_derivati.id_profilo%type default null
     ,p_id_relazione        in ruoli_derivati.id_relazione%type default null
   ) is
      /******************************************************************************
       NOME:        ins
       DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
       PARAMETRI:   Chiavi e attributi della table.
      ******************************************************************************/
   begin
      -- Check Mandatory on Insert
   
      insert into ruoli_derivati
         (id_ruolo_derivato
         ,id_ruolo_componente
         ,id_profilo
         ,id_relazione)
      values
         (p_id_ruolo_derivato
         ,p_id_ruolo_componente
         ,p_id_profilo
         ,p_id_relazione);
   end ins; -- ruoli_derivati_tpk.ins
   --------------------------------------------------------------------------------
   function ins
   (
      p_id_ruolo_derivato   in ruoli_derivati.id_ruolo_derivato%type default null
     ,p_id_ruolo_componente in ruoli_derivati.id_ruolo_componente%type default null
     ,p_id_profilo          in ruoli_derivati.id_profilo%type default null
     ,p_id_relazione        in ruoli_derivati.id_relazione%type default null
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
      insert into ruoli_derivati
         (id_ruolo_derivato
         ,id_ruolo_componente
         ,id_profilo
         ,id_relazione)
      values
         (p_id_ruolo_derivato
         ,p_id_ruolo_componente
         ,p_id_profilo
         ,p_id_relazione)
      returning id_ruolo_derivato into d_result;
      return d_result;
   end ins; -- ruoli_derivati_tpk.ins
   --------------------------------------------------------------------------------
   procedure upd
   (
      p_check_old               in integer default 0
     ,p_new_id_ruolo_derivato   in ruoli_derivati.id_ruolo_derivato%type
     ,p_old_id_ruolo_derivato   in ruoli_derivati.id_ruolo_derivato%type default null
     ,p_new_id_ruolo_componente in ruoli_derivati.id_ruolo_componente%type default afc.default_null('RUOLI_DERIVATI.id_ruolo_componente')
     ,p_old_id_ruolo_componente in ruoli_derivati.id_ruolo_componente%type default null
     ,p_new_id_profilo          in ruoli_derivati.id_profilo%type default afc.default_null('RUOLI_DERIVATI.id_profilo')
     ,p_old_id_profilo          in ruoli_derivati.id_profilo%type default null
     ,p_new_id_relazione        in ruoli_derivati.id_relazione%type default afc.default_null('RUOLI_DERIVATI.id_relazione')
     ,p_old_id_relazione        in ruoli_derivati.id_relazione%type default null
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
      d_key := pk(nvl(p_old_id_ruolo_derivato, p_new_id_ruolo_derivato));
      update ruoli_derivati
         set id_ruolo_derivato   = nvl(p_new_id_ruolo_derivato
                                      ,decode(afc.is_default_null('RUOLI_DERIVATI.id_ruolo_derivato')
                                             ,1
                                             ,id_ruolo_derivato
                                             ,decode(p_check_old
                                                    ,0
                                                    ,null
                                                    ,decode(p_old_id_ruolo_derivato
                                                           ,null
                                                           ,id_ruolo_derivato
                                                           ,null))))
            ,id_ruolo_componente = nvl(p_new_id_ruolo_componente
                                      ,decode(afc.is_default_null('RUOLI_DERIVATI.id_ruolo_componente')
                                             ,1
                                             ,id_ruolo_componente
                                             ,decode(p_check_old
                                                    ,0
                                                    ,null
                                                    ,decode(p_old_id_ruolo_componente
                                                           ,null
                                                           ,id_ruolo_componente
                                                           ,null))))
            ,id_profilo          = nvl(p_new_id_profilo
                                      ,decode(afc.is_default_null('RUOLI_DERIVATI.id_profilo')
                                             ,1
                                             ,id_profilo
                                             ,decode(p_check_old
                                                    ,0
                                                    ,null
                                                    ,decode(p_old_id_profilo
                                                           ,null
                                                           ,id_profilo
                                                           ,null))))
            ,id_relazione        = nvl(p_new_id_relazione
                                      ,decode(afc.is_default_null('RUOLI_DERIVATI.id_relazione')
                                             ,1
                                             ,id_relazione
                                             ,decode(p_check_old
                                                    ,0
                                                    ,null
                                                    ,decode(p_old_id_relazione
                                                           ,null
                                                           ,id_relazione
                                                           ,null))))
       where id_ruolo_derivato = d_key.id_ruolo_derivato
         and (p_check_old = 0 or
             (1 = 1 and (id_ruolo_componente = p_old_id_ruolo_componente or
             (p_old_id_ruolo_componente is null and
             (p_check_old is null or id_ruolo_componente is null))) and
             (id_profilo = p_old_id_profilo or
             (p_old_id_profilo is null and (p_check_old is null or id_profilo is null)))) and
             (id_relazione = p_old_id_relazione or
             (p_old_id_relazione is null and
             (p_check_old is null or id_relazione is null))));
      d_row_found := sql%rowcount;
      afc.default_null(null);
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on ruoli_derivati_tpk.upd');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   end upd; -- ruoli_derivati_tpk.upd
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_id_ruolo_derivato in ruoli_derivati.id_ruolo_derivato%type
     ,p_column            in varchar2
     ,p_value             in varchar2 default null
     ,p_literal_value     in number default 1
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
      dbc.pre(not dbc.preon or existsid(p_id_ruolo_derivato => p_id_ruolo_derivato)
             ,'existsId on ruoli_derivati_tpk.upd_column');
      dbc.pre(not dbc.preon or p_column is not null
             ,'p_column is not null on ruoli_derivati_tpk.upd_column');
      dbc.pre(not dbc.preon or afc_ddl.hasattribute(s_table_name, p_column)
             ,'AFC_DDL.HasAttribute on ruoli_derivati_tpk.upd_column');
      dbc.pre(p_literal_value in (0, 1) or p_literal_value is null
             ,'p_literal_value on ruoli_derivati_tpk.upd_column; p_literal_value = ' ||
              p_literal_value);
      if p_literal_value = 1 or p_literal_value is null then
         d_literal := '''';
      end if;
      d_statement := ' declare ' || '    d_row_found number; ' || ' begin ' ||
                     '    update RUOLI_DERIVATI ' || '       set ' || p_column || ' = ' ||
                     d_literal || p_value || d_literal || '     where 1 = 1 ' ||
                     nvl(afc.get_field_condition(' and ( id_ruolo_derivato '
                                                ,p_id_ruolo_derivato
                                                ,' )'
                                                ,0
                                                ,null)
                        ,' and ( id_ruolo_derivato is null ) ') || '    ; ' ||
                     '    d_row_found := SQL%ROWCOUNT; ' || '    if d_row_found < 1 ' ||
                     '    then ' ||
                     '       raise_application_error ( AFC_ERROR.modified_by_other_user_number, AFC_ERROR.modified_by_other_user_msg ); ' ||
                     '    end if; ' || ' end; ';
      afc.sql_execute(d_statement);
   end upd_column; -- ruoli_derivati_tpk.upd_column
   --------------------------------------------------------------------------------
   procedure del
   (
      p_check_old           in integer default 0
     ,p_id_ruolo_derivato   in ruoli_derivati.id_ruolo_derivato%type
     ,p_id_ruolo_componente in ruoli_derivati.id_ruolo_componente%type default null
     ,p_id_profilo          in ruoli_derivati.id_profilo%type default null
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
              not ((p_id_ruolo_componente is not null or p_id_profilo is not null) and
               (nvl(p_check_old, -1) = 0))
             ,' "OLD values" is not null on ruoli_derivati_tpk.del');
      dbc.pre(not dbc.preon or existsid(p_id_ruolo_derivato => p_id_ruolo_derivato)
             ,'existsId on ruoli_derivati_tpk.del');
      delete from ruoli_derivati
       where id_ruolo_derivato = p_id_ruolo_derivato
         and (p_check_old = 0 or
             (1 = 1 and (id_ruolo_componente = p_id_ruolo_componente or
             (p_id_ruolo_componente is null and
             (p_check_old is null or id_ruolo_componente is null))) and
             (id_profilo = p_id_profilo or
             (p_id_profilo is null and (p_check_old is null or id_profilo is null)))));
      d_row_found := sql%rowcount;
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on ruoli_derivati_tpk.del');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
      dbc.post(not dbc.poston or
               not existsid(p_id_ruolo_derivato => p_id_ruolo_derivato)
              ,'existsId on ruoli_derivati_tpk.del');
   end del; -- ruoli_derivati_tpk.del
   --------------------------------------------------------------------------------
   function get_id_ruolo_componente(p_id_ruolo_derivato in ruoli_derivati.id_ruolo_derivato%type)
      return ruoli_derivati.id_ruolo_componente%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_id_ruolo_componente
       DESCRIZIONE: Getter per attributo id_ruolo_componente di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     RUOLI_DERIVATI.id_ruolo_componente%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ruoli_derivati.id_ruolo_componente%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_ruolo_derivato => p_id_ruolo_derivato)
             ,'existsId on ruoli_derivati_tpk.get_id_ruolo_componente');
      select id_ruolo_componente
        into d_result
        from ruoli_derivati
       where id_ruolo_derivato = p_id_ruolo_derivato;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on ruoli_derivati_tpk.get_id_ruolo_componente');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'id_ruolo_componente')
                      ,' AFC_DDL.IsNullable on ruoli_derivati_tpk.get_id_ruolo_componente');
      end if;
      return d_result;
   end get_id_ruolo_componente; -- ruoli_derivati_tpk.get_id_ruolo_componente
   --------------------------------------------------------------------------------
   function get_id_profilo(p_id_ruolo_derivato in ruoli_derivati.id_ruolo_derivato%type)
      return ruoli_derivati.id_profilo%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_id_profilo
       DESCRIZIONE: Getter per attributo id_profilo di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     RUOLI_DERIVATI.id_profilo%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ruoli_derivati.id_profilo%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_ruolo_derivato => p_id_ruolo_derivato)
             ,'existsId on ruoli_derivati_tpk.get_id_profilo');
      select id_profilo
        into d_result
        from ruoli_derivati
       where id_ruolo_derivato = p_id_ruolo_derivato;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on ruoli_derivati_tpk.get_id_profilo');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'id_profilo')
                      ,' AFC_DDL.IsNullable on ruoli_derivati_tpk.get_id_profilo');
      end if;
      return d_result;
   end get_id_profilo; -- ruoli_derivati_tpk.get_id_profilo
   --------------------------------------------------------------------------------
   function get_id_relazione(p_id_ruolo_derivato in ruoli_derivati.id_ruolo_derivato%type)
      return ruoli_derivati.id_relazione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_id_relazione
       DESCRIZIONE: Getter per attributo id_relazione di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     RUOLI_DERIVATI.id_relazione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ruoli_derivati.id_relazione%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_ruolo_derivato => p_id_ruolo_derivato)
             ,'existsId on ruoli_derivati_tpk.get_id_relazione');
      select id_relazione
        into d_result
        from ruoli_derivati
       where id_ruolo_derivato = p_id_ruolo_derivato;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on ruoli_derivati_tpk.get_id_relazione');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'id_relazione')
                      ,' AFC_DDL.IsNullable on ruoli_derivati_tpk.get_id_relazione');
      end if;
      return d_result;
   end get_id_relazione; -- ruoli_derivati_tpk.get_id_profilo
   --------------------------------------------------------------------------------
   procedure set_id_ruolo_derivato
   (
      p_id_ruolo_derivato in ruoli_derivati.id_ruolo_derivato%type
     ,p_value             in ruoli_derivati.id_ruolo_derivato%type default null
   ) is
      /******************************************************************************
       NOME:        set_id_ruolo_derivato
       DESCRIZIONE: Setter per attributo id_ruolo_derivato di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_ruolo_derivato => p_id_ruolo_derivato)
             ,'existsId on ruoli_derivati_tpk.set_id_ruolo_derivato');
      update ruoli_derivati
         set id_ruolo_derivato = p_value
       where id_ruolo_derivato = p_id_ruolo_derivato;
   end set_id_ruolo_derivato; -- ruoli_derivati_tpk.set_id_ruolo_derivato
   --------------------------------------------------------------------------------
   procedure set_id_ruolo_componente
   (
      p_id_ruolo_derivato in ruoli_derivati.id_ruolo_derivato%type
     ,p_value             in ruoli_derivati.id_ruolo_componente%type default null
   ) is
      /******************************************************************************
       NOME:        set_id_ruolo_componente
       DESCRIZIONE: Setter per attributo id_ruolo_componente di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_ruolo_derivato => p_id_ruolo_derivato)
             ,'existsId on ruoli_derivati_tpk.set_id_ruolo_componente');
      update ruoli_derivati
         set id_ruolo_componente = p_value
       where id_ruolo_derivato = p_id_ruolo_derivato;
   end set_id_ruolo_componente; -- ruoli_derivati_tpk.set_id_ruolo_componente
   --------------------------------------------------------------------------------
   procedure set_id_profilo
   (
      p_id_ruolo_derivato in ruoli_derivati.id_ruolo_derivato%type
     ,p_value             in ruoli_derivati.id_profilo%type default null
   ) is
      /******************************************************************************
       NOME:        set_id_profilo
       DESCRIZIONE: Setter per attributo id_profilo di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_ruolo_derivato => p_id_ruolo_derivato)
             ,'existsId on ruoli_derivati_tpk.set_id_profilo');
      update ruoli_derivati
         set id_profilo = p_value
       where id_ruolo_derivato = p_id_ruolo_derivato;
   end set_id_profilo; -- ruoli_derivati_tpk.set_id_profilo
   --------------------------------------------------------------------------------
   function where_condition /* SLAVE_COPY */
   (
      p_qbe                 in number default 0
     ,p_other_condition     in varchar2 default null
     ,p_id_ruolo_derivato   in varchar2 default null
     ,p_id_ruolo_componente in varchar2 default null
     ,p_id_profilo          in varchar2 default null
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
                     afc.get_field_condition(' and ( id_ruolo_derivato '
                                            ,p_id_ruolo_derivato
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( id_ruolo_componente '
                                            ,p_id_ruolo_componente
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( id_profilo '
                                            ,p_id_profilo
                                            ,' )'
                                            ,p_qbe
                                            ,null) || ' ) ' || p_other_condition;
      return d_statement;
   end where_condition; --- ruoli_derivati_tpk.where_condition
   --------------------------------------------------------------------------------
   function get_rows
   (
      p_qbe                 in number default 0
     ,p_other_condition     in varchar2 default null
     ,p_order_by            in varchar2 default null
     ,p_extra_columns       in varchar2 default null
     ,p_extra_condition     in varchar2 default null
     ,p_id_ruolo_derivato   in varchar2 default null
     ,p_id_ruolo_componente in varchar2 default null
     ,p_id_profilo          in varchar2 default null
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
      d_statement  := ' select RUOLI_DERIVATI.* ' ||
                      afc.decode_value(p_extra_columns
                                      ,null
                                      ,null
                                      ,' , ' || p_extra_columns) ||
                      ' from RUOLI_DERIVATI ' ||
                      where_condition(p_qbe                 => p_qbe
                                     ,p_other_condition     => p_other_condition
                                     ,p_id_ruolo_derivato   => p_id_ruolo_derivato
                                     ,p_id_ruolo_componente => p_id_ruolo_componente
                                     ,p_id_profilo          => p_id_profilo) || ' ' ||
                      p_extra_condition ||
                      afc.decode_value(p_order_by, null, null, ' order by ' || p_order_by);
      d_ref_cursor := afc_dml.get_ref_cursor(d_statement);
      return d_ref_cursor;
   end get_rows; -- ruoli_derivati_tpk.get_rows
   --------------------------------------------------------------------------------
   function count_rows
   (
      p_qbe                 in number default 0
     ,p_other_condition     in varchar2 default null
     ,p_id_ruolo_derivato   in varchar2 default null
     ,p_id_ruolo_componente in varchar2 default null
     ,p_id_profilo          in varchar2 default null
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
      d_statement := ' select count( * ) from RUOLI_DERIVATI ' ||
                     where_condition(p_qbe                 => p_qbe
                                    ,p_other_condition     => p_other_condition
                                    ,p_id_ruolo_derivato   => p_id_ruolo_derivato
                                    ,p_id_ruolo_componente => p_id_ruolo_componente
                                    ,p_id_profilo          => p_id_profilo);
      d_result    := afc.sql_execute(d_statement);
      return d_result;
   end count_rows; -- ruoli_derivati_tpk.count_rows
--------------------------------------------------------------------------------

end ruoli_derivati_tpk;
/

