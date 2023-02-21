CREATE OR REPLACE package body codici_ipa_tpk is
   /******************************************************************************
    NOME:        codici_ipa_tpk
    DESCRIZIONE: Gestione tabella CODICI_IPA.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore      Descrizione.
    000   16/02/2017  SO4  Generazione automatica. 
   ******************************************************************************/
   s_revisione_body constant afc.t_revision := '000 - 16/02/2017';
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
   end versione; -- codici_ipa_tpk.versione
   --------------------------------------------------------------------------------
   function pk
   (
      p_tipo_entita in codici_ipa.tipo_entita%type
     ,p_progressivo in codici_ipa.progressivo%type
   ) return t_pk is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        PK
       DESCRIZIONE: Costruttore di un t_PK dati gli attributi della chiave
      ******************************************************************************/
      d_result t_pk;
   begin
      d_result.tipo_entita := p_tipo_entita;
      d_result.progressivo := p_progressivo;
      dbc.pre(not dbc.preon or
              canhandle(p_tipo_entita => d_result.tipo_entita
                       ,p_progressivo => d_result.progressivo)
             ,'canHandle on codici_ipa_tpk.PK');
      return d_result;
   end pk; -- codici_ipa_tpk.PK
   --------------------------------------------------------------------------------
   function can_handle
   (
      p_tipo_entita in codici_ipa.tipo_entita%type
     ,p_progressivo in codici_ipa.progressivo%type
   ) return number is
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
      if d_result = 1 and (p_tipo_entita is null or p_progressivo is null) then
         d_result := 0;
      end if;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on codici_ipa_tpk.can_handle');
      return d_result;
   end can_handle; -- codici_ipa_tpk.can_handle
   --------------------------------------------------------------------------------
   function canhandle
   (
      p_tipo_entita in codici_ipa.tipo_entita%type
     ,p_progressivo in codici_ipa.progressivo%type
   ) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        canHandle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: true se la chiave e manipolabile, false altrimenti.
       NOTE:        Wrapper boolean di can_handle (cfr. can_handle).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(can_handle(p_tipo_entita => p_tipo_entita
                                                            ,p_progressivo => p_progressivo));
   begin
      return d_result;
   end canhandle; -- codici_ipa_tpk.canHandle
   --------------------------------------------------------------------------------
   function exists_id
   (
      p_tipo_entita in codici_ipa.tipo_entita%type
     ,p_progressivo in codici_ipa.progressivo%type
   ) return number is
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
      dbc.pre(not dbc.preon or
              canhandle(p_tipo_entita => p_tipo_entita, p_progressivo => p_progressivo)
             ,'canHandle on codici_ipa_tpk.exists_id');
      begin
         select 1
           into d_result
           from codici_ipa
          where tipo_entita = p_tipo_entita
            and progressivo = p_progressivo;
      exception
         when no_data_found then
            d_result := 0;
      end;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on codici_ipa_tpk.exists_id');
      return d_result;
   end exists_id; -- codici_ipa_tpk.exists_id
   --------------------------------------------------------------------------------
   function existsid
   (
      p_tipo_entita in codici_ipa.tipo_entita%type
     ,p_progressivo in codici_ipa.progressivo%type
   ) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        existsId
       DESCRIZIONE: Esistenza riga con chiave indicata.
       NOTE:        Wrapper boolean di exists_id (cfr. exists_id).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(exists_id(p_tipo_entita => p_tipo_entita
                                                           ,p_progressivo => p_progressivo));
   begin
      return d_result;
   end existsid; -- codici_ipa_tpk.existsId
   --------------------------------------------------------------------------------
   procedure ins
   (
      p_tipo_entita      in codici_ipa.tipo_entita%type
     ,p_progressivo      in codici_ipa.progressivo%type default null
     ,p_codice_originale in codici_ipa.codice_originale%type
   ) is
      /******************************************************************************
       NOME:        ins
       DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
       PARAMETRI:   Chiavi e attributi della table.
      ******************************************************************************/
   begin
      -- Check Mandatory on Insert
   
      dbc.pre(not dbc.preon or p_codice_originale is not null or /*default value*/
              '' is not null
             ,'p_codice_originale on codici_ipa_tpk.ins');
      dbc.pre(not dbc.preon or (p_tipo_entita is null and /*default value*/
              '' is not null) -- PK nullable on insert
              or (p_progressivo is null and /*default value*/
              'default null' is not null) -- PK nullable on insert
              or not
               existsid(p_tipo_entita => p_tipo_entita, p_progressivo => p_progressivo)
             ,'not existsId on codici_ipa_tpk.ins');
      insert into codici_ipa
         (tipo_entita
         ,progressivo
         ,codice_originale)
      values
         (p_tipo_entita
         ,p_progressivo
         ,p_codice_originale);
   end ins; -- codici_ipa_tpk.ins
   --------------------------------------------------------------------------------
   function ins
   (
      p_tipo_entita      in codici_ipa.tipo_entita%type
     ,p_progressivo      in codici_ipa.progressivo%type default null
     ,p_codice_originale in codici_ipa.codice_originale%type
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
   
      dbc.pre(not dbc.preon or p_codice_originale is not null or /*default value*/
              '' is not null
             ,'p_codice_originale on codici_ipa_tpk.ins');
      dbc.pre(not dbc.preon or (p_tipo_entita is null and /*default value*/
              '' is not null) -- PK nullable on insert
              or (p_progressivo is null and /*default value*/
              'default null' is not null) -- PK nullable on insert
              or not
               existsid(p_tipo_entita => p_tipo_entita, p_progressivo => p_progressivo)
             ,'not existsId on codici_ipa_tpk.ins');
      insert into codici_ipa
         (tipo_entita
         ,progressivo
         ,codice_originale)
      values
         (p_tipo_entita
         ,p_progressivo
         ,p_codice_originale);
      d_result := 0;
      return d_result;
   end ins; -- codici_ipa_tpk.ins
   --------------------------------------------------------------------------------
   procedure upd
   (
      p_check_old            in integer default 0
     ,p_new_tipo_entita      in codici_ipa.tipo_entita%type
     ,p_old_tipo_entita      in codici_ipa.tipo_entita%type default null
     ,p_new_progressivo      in codici_ipa.progressivo%type
     ,p_old_progressivo      in codici_ipa.progressivo%type default null
     ,p_new_codice_originale in codici_ipa.codice_originale%type default afc.default_null('CODICI_IPA.codice_originale')
     ,p_old_codice_originale in codici_ipa.codice_originale%type default null
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
              not ((p_old_codice_originale is not null) and (nvl(p_check_old, -1) = 0))
             ,' "OLD values" is not null on codici_ipa_tpk.upd');
      d_key := pk(nvl(p_old_tipo_entita, p_new_tipo_entita)
                 ,nvl(p_old_progressivo, p_new_progressivo));
      dbc.pre(not dbc.preon or
              existsid(p_tipo_entita => d_key.tipo_entita
                      ,p_progressivo => d_key.progressivo)
             ,'existsId on codici_ipa_tpk.upd');
      update codici_ipa
         set tipo_entita      = nvl(p_new_tipo_entita
                                   ,decode(afc.is_default_null('CODICI_IPA.tipo_entita')
                                          ,1
                                          ,tipo_entita
                                          ,decode(p_check_old
                                                 ,0
                                                 ,null
                                                 ,decode(p_old_tipo_entita
                                                        ,null
                                                        ,tipo_entita
                                                        ,null))))
            ,progressivo      = nvl(p_new_progressivo
                                   ,decode(afc.is_default_null('CODICI_IPA.progressivo')
                                          ,1
                                          ,progressivo
                                          ,decode(p_check_old
                                                 ,0
                                                 ,null
                                                 ,decode(p_old_progressivo
                                                        ,null
                                                        ,progressivo
                                                        ,null))))
            ,codice_originale = nvl(p_new_codice_originale
                                   ,decode(afc.is_default_null('CODICI_IPA.codice_originale')
                                          ,1
                                          ,codice_originale
                                          ,decode(p_check_old
                                                 ,0
                                                 ,null
                                                 ,decode(p_old_codice_originale
                                                        ,null
                                                        ,codice_originale
                                                        ,null))))
       where tipo_entita = d_key.tipo_entita
         and progressivo = d_key.progressivo
         and (p_check_old = 0 or
             (1 = 1 and (codice_originale = p_old_codice_originale or
             (p_old_codice_originale is null and
             (p_check_old is null or codice_originale is null)))));
      d_row_found := sql%rowcount;
      afc.default_null(null);
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on codici_ipa_tpk.upd');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   end upd; -- codici_ipa_tpk.upd
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_tipo_entita   in codici_ipa.tipo_entita%type
     ,p_progressivo   in codici_ipa.progressivo%type
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
      dbc.pre(not dbc.preon or
              existsid(p_tipo_entita => p_tipo_entita, p_progressivo => p_progressivo)
             ,'existsId on codici_ipa_tpk.upd_column');
      dbc.pre(not dbc.preon or p_column is not null
             ,'p_column is not null on codici_ipa_tpk.upd_column');
      dbc.pre(not dbc.preon or afc_ddl.hasattribute(s_table_name, p_column)
             ,'AFC_DDL.HasAttribute on codici_ipa_tpk.upd_column');
      dbc.pre(p_literal_value in (0, 1) or p_literal_value is null
             ,'p_literal_value on codici_ipa_tpk.upd_column; p_literal_value = ' ||
              p_literal_value);
      if p_literal_value = 1 or p_literal_value is null then
         d_literal := '''';
      end if;
      d_statement := ' declare ' || '    d_row_found number; ' || ' begin ' ||
                     '    update CODICI_IPA ' || '       set ' || p_column || ' = ' ||
                     d_literal || p_value || d_literal || '     where 1 = 1 ' ||
                     nvl(afc.get_field_condition(' and ( tipo_entita '
                                                ,p_tipo_entita
                                                ,' )'
                                                ,0
                                                ,null)
                        ,' and ( tipo_entita is null ) ') ||
                     nvl(afc.get_field_condition(' and ( progressivo '
                                                ,p_progressivo
                                                ,' )'
                                                ,0
                                                ,null)
                        ,' and ( progressivo is null ) ') || '    ; ' ||
                     '    d_row_found := SQL%ROWCOUNT; ' || '    if d_row_found < 1 ' ||
                     '    then ' ||
                     '       raise_application_error ( AFC_ERROR.modified_by_other_user_number, AFC_ERROR.modified_by_other_user_msg ); ' ||
                     '    end if; ' || ' end; ';
      afc.sql_execute(d_statement);
   end upd_column; -- codici_ipa_tpk.upd_column
   --------------------------------------------------------------------------------
   procedure del
   (
      p_check_old        in integer default 0
     ,p_tipo_entita      in codici_ipa.tipo_entita%type
     ,p_progressivo      in codici_ipa.progressivo%type
     ,p_codice_originale in codici_ipa.codice_originale%type default null
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
              not ((p_codice_originale is not null) and (nvl(p_check_old, -1) = 0))
             ,' "OLD values" is not null on codici_ipa_tpk.del');
      dbc.pre(not dbc.preon or
              existsid(p_tipo_entita => p_tipo_entita, p_progressivo => p_progressivo)
             ,'existsId on codici_ipa_tpk.del');
      delete from codici_ipa
       where tipo_entita = p_tipo_entita
         and progressivo = p_progressivo
         and (p_check_old = 0 or
             (1 = 1 and (codice_originale = p_codice_originale or
             (p_codice_originale is null and
             (p_check_old is null or codice_originale is null)))));
      d_row_found := sql%rowcount;
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on codici_ipa_tpk.del');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
      dbc.post(not dbc.poston or
               not
                existsid(p_tipo_entita => p_tipo_entita, p_progressivo => p_progressivo)
              ,'existsId on codici_ipa_tpk.del');
   end del; -- codici_ipa_tpk.del
   --------------------------------------------------------------------------------
   function get_codice_originale
   (
      p_tipo_entita in codici_ipa.tipo_entita%type
     ,p_progressivo in codici_ipa.progressivo%type
   ) return codici_ipa.codice_originale%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_codice_originale
       DESCRIZIONE: Getter per attributo codice_originale di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     CODICI_IPA.codice_originale%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result codici_ipa.codice_originale%type;
   begin
      dbc.pre(not dbc.preon or
              existsid(p_tipo_entita => p_tipo_entita, p_progressivo => p_progressivo)
             ,'existsId on codici_ipa_tpk.get_codice_originale');
      select codice_originale
        into d_result
        from codici_ipa
       where tipo_entita = p_tipo_entita
         and progressivo = p_progressivo;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on codici_ipa_tpk.get_codice_originale');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'codice_originale')
                      ,' AFC_DDL.IsNullable on codici_ipa_tpk.get_codice_originale');
      end if;
      return d_result;
   end get_codice_originale; -- codici_ipa_tpk.get_codice_originale
   --------------------------------------------------------------------------------
   procedure set_tipo_entita
   (
      p_tipo_entita in codici_ipa.tipo_entita%type
     ,p_progressivo in codici_ipa.progressivo%type
     ,p_value       in codici_ipa.tipo_entita%type default null
   ) is
      /******************************************************************************
       NOME:        set_tipo_entita
       DESCRIZIONE: Setter per attributo tipo_entita di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_tipo_entita => p_tipo_entita, p_progressivo => p_progressivo)
             ,'existsId on codici_ipa_tpk.set_tipo_entita');
      update codici_ipa
         set tipo_entita = p_value
       where tipo_entita = p_tipo_entita
         and progressivo = p_progressivo;
   end set_tipo_entita; -- codici_ipa_tpk.set_tipo_entita
   --------------------------------------------------------------------------------
   procedure set_progressivo
   (
      p_tipo_entita in codici_ipa.tipo_entita%type
     ,p_progressivo in codici_ipa.progressivo%type
     ,p_value       in codici_ipa.progressivo%type default null
   ) is
      /******************************************************************************
       NOME:        set_progressivo
       DESCRIZIONE: Setter per attributo progressivo di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_tipo_entita => p_tipo_entita, p_progressivo => p_progressivo)
             ,'existsId on codici_ipa_tpk.set_progressivo');
      update codici_ipa
         set progressivo = p_value
       where tipo_entita = p_tipo_entita
         and progressivo = p_progressivo;
   end set_progressivo; -- codici_ipa_tpk.set_progressivo
   --------------------------------------------------------------------------------
   procedure set_codice_originale
   (
      p_tipo_entita in codici_ipa.tipo_entita%type
     ,p_progressivo in codici_ipa.progressivo%type
     ,p_value       in codici_ipa.codice_originale%type default null
   ) is
      /******************************************************************************
       NOME:        set_codice_originale
       DESCRIZIONE: Setter per attributo codice_originale di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_tipo_entita => p_tipo_entita, p_progressivo => p_progressivo)
             ,'existsId on codici_ipa_tpk.set_codice_originale');
      update codici_ipa
         set codice_originale = p_value
       where tipo_entita = p_tipo_entita
         and progressivo = p_progressivo;
   end set_codice_originale; -- codici_ipa_tpk.set_codice_originale
   --------------------------------------------------------------------------------
   function where_condition /* SLAVE_COPY */
   (
      p_qbe              in number default 0
     ,p_other_condition  in varchar2 default null
     ,p_tipo_entita      in varchar2 default null
     ,p_progressivo      in varchar2 default null
     ,p_codice_originale in varchar2 default null
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
                     afc.get_field_condition(' and ( tipo_entita '
                                            ,p_tipo_entita
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( progressivo '
                                            ,p_progressivo
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( codice_originale '
                                            ,p_codice_originale
                                            ,' )'
                                            ,p_qbe
                                            ,null) || ' ) ' || p_other_condition;
      return d_statement;
   end where_condition; --- codici_ipa_tpk.where_condition
   --------------------------------------------------------------------------------
   function get_rows
   (
      p_qbe              in number default 0
     ,p_other_condition  in varchar2 default null
     ,p_order_by         in varchar2 default null
     ,p_extra_columns    in varchar2 default null
     ,p_extra_condition  in varchar2 default null
     ,p_tipo_entita      in varchar2 default null
     ,p_progressivo      in varchar2 default null
     ,p_codice_originale in varchar2 default null
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
      d_statement  := ' select CODICI_IPA.* ' ||
                      afc.decode_value(p_extra_columns
                                      ,null
                                      ,null
                                      ,' , ' || p_extra_columns) || ' from CODICI_IPA ' ||
                      where_condition(p_qbe              => p_qbe
                                     ,p_other_condition  => p_other_condition
                                     ,p_tipo_entita      => p_tipo_entita
                                     ,p_progressivo      => p_progressivo
                                     ,p_codice_originale => p_codice_originale) || ' ' ||
                      p_extra_condition ||
                      afc.decode_value(p_order_by, null, null, ' order by ' || p_order_by);
      d_ref_cursor := afc_dml.get_ref_cursor(d_statement);
      return d_ref_cursor;
   end get_rows; -- codici_ipa_tpk.get_rows
   --------------------------------------------------------------------------------
   function count_rows
   (
      p_qbe              in number default 0
     ,p_other_condition  in varchar2 default null
     ,p_tipo_entita      in varchar2 default null
     ,p_progressivo      in varchar2 default null
     ,p_codice_originale in varchar2 default null
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
      d_statement := ' select count( * ) from CODICI_IPA ' ||
                     where_condition(p_qbe              => p_qbe
                                    ,p_other_condition  => p_other_condition
                                    ,p_tipo_entita      => p_tipo_entita
                                    ,p_progressivo      => p_progressivo
                                    ,p_codice_originale => p_codice_originale);
      d_result    := afc.sql_execute(d_statement);
      return d_result;
   end count_rows; -- codici_ipa_tpk.count_rows
--------------------------------------------------------------------------------

end codici_ipa_tpk;
/

