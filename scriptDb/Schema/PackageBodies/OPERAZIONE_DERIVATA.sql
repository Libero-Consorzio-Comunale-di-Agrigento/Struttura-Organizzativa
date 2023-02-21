CREATE OR REPLACE package body operazione_derivata is
   /******************************************************************************
    NOME:        operazioni_derivate_tpk
    DESCRIZIONE: Gestione tabella OPERAZIONI_DERIVATE.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore      Descrizione.
    000   21/09/2011  mmonari  Generazione automatica.
    001   02/07/2012  mmonari  Consolidamento rel.1.4.1
    002   01/09/2014  mmonari  Bug #485
   ******************************************************************************/
   s_revisione_body constant afc.t_revision := '002 - 01/09/2014';
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
   end versione; -- operazioni_derivate_tpk.versione
   --------------------------------------------------------------------------------
   function pk(p_id_modifica in operazioni_derivate.id_modifica%type) return t_pk is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        PK
       DESCRIZIONE: Costruttore di un t_PK dati gli attributi della chiave
      ******************************************************************************/
      d_result t_pk;
   begin
      d_result.id_modifica := p_id_modifica;
      dbc.pre(not dbc.preon or canhandle(p_id_modifica => d_result.id_modifica)
             ,'canHandle on operazioni_derivate_tpk.PK');
      return d_result;
   end pk; -- operazioni_derivate_tpk.PK
   --------------------------------------------------------------------------------
   function can_handle(p_id_modifica in operazioni_derivate.id_modifica%type) return number is
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
              ,'d_result = 1  or  d_result = 0 on operazioni_derivate_tpk.can_handle');
      return d_result;
   end can_handle; -- operazioni_derivate_tpk.can_handle
   --------------------------------------------------------------------------------
   function canhandle(p_id_modifica in operazioni_derivate.id_modifica%type) return boolean is
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
   end canhandle; -- operazioni_derivate_tpk.canHandle
   --------------------------------------------------------------------------------
   function exists_id(p_id_modifica in operazioni_derivate.id_modifica%type) return number is
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
             ,'canHandle on operazioni_derivate_tpk.exists_id');
      begin
         select 1
           into d_result
           from operazioni_derivate
          where id_modifica = p_id_modifica;
      exception
         when no_data_found then
            d_result := 0;
      end;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on operazioni_derivate_tpk.exists_id');
      return d_result;
   end exists_id; -- operazioni_derivate_tpk.exists_id
   --------------------------------------------------------------------------------
   function existsid(p_id_modifica in operazioni_derivate.id_modifica%type) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        existsId
       DESCRIZIONE: Esistenza riga con chiave indicata.
       NOTE:        Wrapper boolean di exists_id (cfr. exists_id).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(exists_id(p_id_modifica => p_id_modifica));
   begin
      return d_result;
   end existsid; -- operazioni_derivate_tpk.existsId
   --------------------------------------------------------------------------------
   procedure ins
   (
      p_id_modifica in operazioni_derivate.id_modifica%type
     ,p_ottica      in operazioni_derivate.ottica%type
     ,p_esecuzione  in operazioni_derivate.esecuzione%type default null
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
             ,'p_ottica on operazioni_derivate_tpk.ins');
      dbc.pre(not dbc.preon or p_esecuzione is not null or /*default value*/
              'default' is not null
             ,'p_esecuzione on operazioni_derivate_tpk.ins');
      dbc.pre(not dbc.preon or (p_id_modifica is null and /*default value*/
              '' is not null) -- PK nullable on insert
              or not existsid(p_id_modifica => p_id_modifica)
             ,'not existsId on operazioni_derivate_tpk.ins');
      insert into operazioni_derivate
         (id_modifica
         ,ottica
         ,esecuzione)
      values
         (p_id_modifica
         ,p_ottica
         ,p_esecuzione);
   end ins; -- operazioni_derivate_tpk.ins
   --------------------------------------------------------------------------------
   function ins
   (
      p_id_modifica in operazioni_derivate.id_modifica%type
     ,p_ottica      in operazioni_derivate.ottica%type
     ,p_esecuzione  in operazioni_derivate.esecuzione%type default null
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
             ,'p_ottica on operazioni_derivate_tpk.ins');
      dbc.pre(not dbc.preon or p_esecuzione is not null or /*default value*/
              'default' is not null
             ,'p_esecuzione on operazioni_derivate_tpk.ins');
      dbc.pre(not dbc.preon or (p_id_modifica is null and /*default value*/
              '' is not null) -- PK nullable on insert
              or not existsid(p_id_modifica => p_id_modifica)
             ,'not existsId on operazioni_derivate_tpk.ins');
      insert into operazioni_derivate
         (id_modifica
         ,ottica
         ,esecuzione)
      values
         (p_id_modifica
         ,p_ottica
         ,p_esecuzione);
      d_result := 0;
      return d_result;
   end ins; -- operazioni_derivate_tpk.ins
   --------------------------------------------------------------------------------
   procedure upd
   (
      p_check_old       in integer default 0
     ,p_new_id_modifica in operazioni_derivate.id_modifica%type
     ,p_old_id_modifica in operazioni_derivate.id_modifica%type default null
     ,p_new_ottica      in operazioni_derivate.ottica%type default afc.default_null('OPERAZIONI_DERIVATE.ottica')
     ,p_old_ottica      in operazioni_derivate.ottica%type default null
     ,p_new_esecuzione  in operazioni_derivate.esecuzione%type default afc.default_null('OPERAZIONI_DERIVATE.esecuzione')
     ,p_old_esecuzione  in operazioni_derivate.esecuzione%type default null
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
              not ((p_old_ottica is not null or p_old_esecuzione is not null) and
               (nvl(p_check_old, -1) = 0))
             ,' "OLD values" is not null on operazioni_derivate_tpk.upd');
      d_key := pk(nvl(p_old_id_modifica, p_new_id_modifica));
      dbc.pre(not dbc.preon or existsid(p_id_modifica => d_key.id_modifica)
             ,'existsId on operazioni_derivate_tpk.upd');
      update operazioni_derivate
         set id_modifica = nvl(p_new_id_modifica
                              ,decode(afc.is_default_null('OPERAZIONI_DERIVATE.id_modifica')
                                     ,1
                                     ,id_modifica
                                     ,decode(p_check_old
                                            ,0
                                            ,null
                                            ,decode(p_old_id_modifica
                                                   ,null
                                                   ,id_modifica
                                                   ,null))))
            ,ottica      = nvl(p_new_ottica
                              ,decode(afc.is_default_null('OPERAZIONI_DERIVATE.ottica')
                                     ,1
                                     ,ottica
                                     ,decode(p_check_old
                                            ,0
                                            ,null
                                            ,decode(p_old_ottica, null, ottica, null))))
            ,esecuzione  = nvl(p_new_esecuzione
                              ,decode(afc.is_default_null('OPERAZIONI_DERIVATE.esecuzione')
                                     ,1
                                     ,esecuzione
                                     ,decode(p_check_old
                                            ,0
                                            ,null
                                            ,decode(p_old_esecuzione
                                                   ,null
                                                   ,esecuzione
                                                   ,null))))
       where id_modifica = d_key.id_modifica
         and (p_check_old = 0 or
             (1 = 1 and
             (ottica = p_old_ottica or
             (p_old_ottica is null and (p_check_old is null or ottica is null))) and
             (esecuzione = p_old_esecuzione or
             (p_old_esecuzione is null and (p_check_old is null or esecuzione is null)))));
      d_row_found := sql%rowcount;
      afc.default_null(null);
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on operazioni_derivate_tpk.upd');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   end upd; -- operazioni_derivate_tpk.upd
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_id_modifica   in operazioni_derivate.id_modifica%type
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
             ,'existsId on operazioni_derivate_tpk.upd_column');
      dbc.pre(not dbc.preon or p_column is not null
             ,'p_column is not null on operazioni_derivate_tpk.upd_column');
      dbc.pre(not dbc.preon or afc_ddl.hasattribute(s_table_name, p_column)
             ,'AFC_DDL.HasAttribute on operazioni_derivate_tpk.upd_column');
      dbc.pre(p_literal_value in (0, 1) or p_literal_value is null
             ,'p_literal_value on operazioni_derivate_tpk.upd_column; p_literal_value = ' ||
              p_literal_value);
      if p_literal_value = 1 or p_literal_value is null then
         d_literal := '''';
      end if;
      d_statement := ' declare ' || '    d_row_found number; ' || ' begin ' ||
                     '    update OPERAZIONI_DERIVATE ' || '       set ' || p_column ||
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
   end upd_column; -- operazioni_derivate_tpk.upd_column
   --------------------------------------------------------------------------------
   procedure del
   (
      p_check_old   in integer default 0
     ,p_id_modifica in operazioni_derivate.id_modifica%type
     ,p_ottica      in operazioni_derivate.ottica%type default null
     ,p_esecuzione  in operazioni_derivate.esecuzione%type default null
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
      dbc.pre(not dbc.preon or not ((p_ottica is not null or p_esecuzione is not null) and
               (nvl(p_check_old, -1) = 0))
             ,' "OLD values" is not null on operazioni_derivate_tpk.del');
      dbc.pre(not dbc.preon or existsid(p_id_modifica => p_id_modifica)
             ,'existsId on operazioni_derivate_tpk.del');
      delete from operazioni_derivate
       where id_modifica = p_id_modifica
         and (p_check_old = 0 or
             (1 = 1 and (ottica = p_ottica or
             (p_ottica is null and (p_check_old is null or ottica is null))) and
             (esecuzione = p_esecuzione or
             (p_esecuzione is null and (p_check_old is null or esecuzione is null)))));
      d_row_found := sql%rowcount;
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on operazioni_derivate_tpk.del');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
      dbc.post(not dbc.poston or not existsid(p_id_modifica => p_id_modifica)
              ,'existsId on operazioni_derivate_tpk.del');
   end del; -- operazioni_derivate_tpk.del
   --------------------------------------------------------------------------------
   function get_ottica(p_id_modifica in operazioni_derivate.id_modifica%type)
      return operazioni_derivate.ottica%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_ottica
       DESCRIZIONE: Getter per attributo ottica di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     OPERAZIONI_DERIVATE.ottica%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result operazioni_derivate.ottica%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_modifica => p_id_modifica)
             ,'existsId on operazioni_derivate_tpk.get_ottica');
      select ottica
        into d_result
        from operazioni_derivate
       where id_modifica = p_id_modifica;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on operazioni_derivate_tpk.get_ottica');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'ottica')
                      ,' AFC_DDL.IsNullable on operazioni_derivate_tpk.get_ottica');
      end if;
      return d_result;
   end get_ottica; -- operazioni_derivate_tpk.get_ottica
   --------------------------------------------------------------------------------
   function get_esecuzione(p_id_modifica in operazioni_derivate.id_modifica%type)
      return operazioni_derivate.esecuzione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_esecuzione
       DESCRIZIONE: Getter per attributo esecuzione di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     OPERAZIONI_DERIVATE.esecuzione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result operazioni_derivate.esecuzione%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_modifica => p_id_modifica)
             ,'existsId on operazioni_derivate_tpk.get_esecuzione');
      select esecuzione
        into d_result
        from operazioni_derivate
       where id_modifica = p_id_modifica;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on operazioni_derivate_tpk.get_esecuzione');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'esecuzione')
                      ,' AFC_DDL.IsNullable on operazioni_derivate_tpk.get_esecuzione');
      end if;
      return d_result;
   end get_esecuzione; -- operazioni_derivate_tpk.get_esecuzione
   --------------------------------------------------------------------------------
   procedure set_id_modifica
   (
      p_id_modifica in operazioni_derivate.id_modifica%type
     ,p_value       in operazioni_derivate.id_modifica%type default null
   ) is
      /******************************************************************************
       NOME:        set_id_modifica
       DESCRIZIONE: Setter per attributo id_modifica di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_modifica => p_id_modifica)
             ,'existsId on operazioni_derivate_tpk.set_id_modifica');
      update operazioni_derivate
         set id_modifica = p_value
       where id_modifica = p_id_modifica;
   end set_id_modifica; -- operazioni_derivate_tpk.set_id_modifica
   --------------------------------------------------------------------------------
   procedure set_ottica
   (
      p_id_modifica in operazioni_derivate.id_modifica%type
     ,p_value       in operazioni_derivate.ottica%type default null
   ) is
      /******************************************************************************
       NOME:        set_ottica
       DESCRIZIONE: Setter per attributo ottica di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_modifica => p_id_modifica)
             ,'existsId on operazioni_derivate_tpk.set_ottica');
      update operazioni_derivate set ottica = p_value where id_modifica = p_id_modifica;
   end set_ottica; -- operazioni_derivate_tpk.set_ottica
   --------------------------------------------------------------------------------
   procedure set_esecuzione
   (
      p_id_modifica in operazioni_derivate.id_modifica%type
     ,p_ottica      in operazioni_derivate.ottica%type
     ,p_value       in operazioni_derivate.esecuzione%type default null
   ) is
      /******************************************************************************
       NOME:        set_esecuzione
       DESCRIZIONE: Setter per attributo esecuzione di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_modifica => p_id_modifica)
             ,'existsId on operazioni_derivate_tpk.set_esecuzione');
      update operazioni_derivate
         set esecuzione = p_value
       where id_modifica = p_id_modifica
         and ottica = p_ottica;  --#485
   end set_esecuzione; -- operazioni_derivate_tpk.set_esecuzione
   --------------------------------------------------------------------------------
   function where_condition /* SLAVE_COPY */
   (
      p_qbe             in number default 0
     ,p_other_condition in varchar2 default null
     ,p_id_modifica     in varchar2 default null
     ,p_ottica          in varchar2 default null
     ,p_esecuzione      in varchar2 default null
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
                     afc.get_field_condition(' and ( esecuzione '
                                            ,p_esecuzione
                                            ,' )'
                                            ,p_qbe
                                            ,null) || ' ) ' || p_other_condition;
      return d_statement;
   end where_condition; --- operazioni_derivate_tpk.where_condition
   --------------------------------------------------------------------------------
   function get_rows
   (
      p_qbe             in number default 0
     ,p_other_condition in varchar2 default null
     ,p_order_by        in varchar2 default null
     ,p_extra_columns   in varchar2 default null
     ,p_extra_condition in varchar2 default null
     ,p_id_modifica     in varchar2 default null
     ,p_ottica          in varchar2 default null
     ,p_esecuzione      in varchar2 default null
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
      d_statement  := ' select OPERAZIONI_DERIVATE.* ' ||
                      afc.decode_value(p_extra_columns
                                      ,null
                                      ,null
                                      ,' , ' || p_extra_columns) ||
                      ' from OPERAZIONI_DERIVATE ' ||
                      where_condition(p_qbe             => p_qbe
                                     ,p_other_condition => p_other_condition
                                     ,p_id_modifica     => p_id_modifica
                                     ,p_ottica          => p_ottica
                                     ,p_esecuzione      => p_esecuzione) || ' ' ||
                      p_extra_condition ||
                      afc.decode_value(p_order_by, null, null, ' order by ' || p_order_by);
      d_ref_cursor := afc_dml.get_ref_cursor(d_statement);
      return d_ref_cursor;
   end get_rows; -- operazioni_derivate_tpk.get_rows
   --------------------------------------------------------------------------------
   function count_rows
   (
      p_qbe             in number default 0
     ,p_other_condition in varchar2 default null
     ,p_id_modifica     in varchar2 default null
     ,p_ottica          in varchar2 default null
     ,p_esecuzione      in varchar2 default null
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
      d_statement := ' select count( * ) from OPERAZIONI_DERIVATE ' ||
                     where_condition(p_qbe             => p_qbe
                                    ,p_other_condition => p_other_condition
                                    ,p_id_modifica     => p_id_modifica
                                    ,p_ottica          => p_ottica
                                    ,p_esecuzione      => p_esecuzione);
      d_result    := afc.sql_execute(d_statement);
      return d_result;
   end count_rows; -- operazioni_derivate_tpk.count_rows
--------------------------------------------------------------------------------

end operazione_derivata;
/

