CREATE OR REPLACE package body so4_codifica is
   /******************************************************************************
    NOME:        so4_codifiche_tpk
    DESCRIZIONE: Gestione tabella SO4_CODIFICHE.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore      Descrizione.
    000   08/06/2012  mmonari  Generazione automatica. 
   ******************************************************************************/
   s_revisione_body constant afc.t_revision := '000 - 08/06/2012';
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
   end versione; -- so4_codifiche_tpk.versione
   --------------------------------------------------------------------------------
   function pk(p_id_codifica in so4_codifiche.id_codifica%type) return t_pk is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        PK
       DESCRIZIONE: Costruttore di un t_PK dati gli attributi della chiave
      ******************************************************************************/
      d_result t_pk;
   begin
      d_result.id_codifica := p_id_codifica;
      dbc.pre(not dbc.preon or canhandle(p_id_codifica => d_result.id_codifica)
             ,'canHandle on so4_codifiche_tpk.PK');
      return d_result;
   end pk; -- so4_codifiche_tpk.PK
   --------------------------------------------------------------------------------
   function can_handle(p_id_codifica in so4_codifiche.id_codifica%type) return number is
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
      if d_result = 1 and (p_id_codifica is null) then
         d_result := 0;
      end if;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on so4_codifiche_tpk.can_handle');
      return d_result;
   end can_handle; -- so4_codifiche_tpk.can_handle
   --------------------------------------------------------------------------------
   function canhandle(p_id_codifica in so4_codifiche.id_codifica%type) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        canHandle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: true se la chiave e manipolabile, false altrimenti.
       NOTE:        Wrapper boolean di can_handle (cfr. can_handle).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(can_handle(p_id_codifica => p_id_codifica));
   begin
      return d_result;
   end canhandle; -- so4_codifiche_tpk.canHandle
   --------------------------------------------------------------------------------
   function exists_id(p_id_codifica in so4_codifiche.id_codifica%type) return number is
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
      dbc.pre(not dbc.preon or canhandle(p_id_codifica => p_id_codifica)
             ,'canHandle on so4_codifiche_tpk.exists_id');
      begin
         select 1 into d_result from so4_codifiche where id_codifica = p_id_codifica;
      exception
         when no_data_found then
            d_result := 0;
      end;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on so4_codifiche_tpk.exists_id');
      return d_result;
   end exists_id; -- so4_codifiche_tpk.exists_id
   --------------------------------------------------------------------------------
   function existsid(p_id_codifica in so4_codifiche.id_codifica%type) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        existsId
       DESCRIZIONE: Esistenza riga con chiave indicata.
       NOTE:        Wrapper boolean di exists_id (cfr. exists_id).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(exists_id(p_id_codifica => p_id_codifica));
   begin
      return d_result;
   end existsid; -- so4_codifiche_tpk.existsId
   --------------------------------------------------------------------------------
   procedure ins
   (
      p_id_codifica    in so4_codifiche.id_codifica%type default null
     ,p_dominio        in so4_codifiche.dominio%type
     ,p_valore         in so4_codifiche.valore%type
     ,p_descrizione    in so4_codifiche.descrizione%type
     ,p_valore_default in so4_codifiche.valore_default%type default 0
     ,p_sequenza       in so4_codifiche.sequenza%type default null
   ) is
      /******************************************************************************
       NOME:        ins
       DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
       PARAMETRI:   Chiavi e attributi della table.
      ******************************************************************************/
   begin
      -- Check Mandatory on Insert
   
      dbc.pre(not dbc.preon or p_dominio is not null or /*default value*/
              '' is not null
             ,'p_dominio on so4_codifiche_tpk.ins');
      dbc.pre(not dbc.preon or p_valore is not null or /*default value*/
              '' is not null
             ,'p_valore on so4_codifiche_tpk.ins');
      dbc.pre(not dbc.preon or p_descrizione is not null or /*default value*/
              '' is not null
             ,'p_descrizione on so4_codifiche_tpk.ins');
      dbc.pre(not dbc.preon or p_valore_default is not null or /*default value*/
              'default' is not null
             ,'p_valore_default on so4_codifiche_tpk.ins');
      dbc.pre(not dbc.preon or p_sequenza is not null or /*default value*/
              'default' is not null
             ,'p_sequenza on so4_codifiche_tpk.ins');
      dbc.pre(not dbc.preon or (p_id_codifica is null and /*default value*/
              'default null' is not null) -- PK nullable on insert
              or not existsid(p_id_codifica => p_id_codifica)
             ,'not existsId on so4_codifiche_tpk.ins');
      insert into so4_codifiche
         (id_codifica
         ,dominio
         ,valore
         ,descrizione
         ,valore_default
         ,sequenza)
      values
         (p_id_codifica
         ,p_dominio
         ,p_valore
         ,p_descrizione
         ,nvl(p_valore_default, 0)
         ,p_sequenza);
   end ins; -- so4_codifiche_tpk.ins
   --------------------------------------------------------------------------------
   function ins
   (
      p_id_codifica    in so4_codifiche.id_codifica%type default null
     ,p_dominio        in so4_codifiche.dominio%type
     ,p_valore         in so4_codifiche.valore%type
     ,p_descrizione    in so4_codifiche.descrizione%type
     ,p_valore_default in so4_codifiche.valore_default%type default 0
     ,p_sequenza       in so4_codifiche.sequenza%type default null
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
   
      dbc.pre(not dbc.preon or p_dominio is not null or /*default value*/
              '' is not null
             ,'p_dominio on so4_codifiche_tpk.ins');
      dbc.pre(not dbc.preon or p_valore is not null or /*default value*/
              '' is not null
             ,'p_valore on so4_codifiche_tpk.ins');
      dbc.pre(not dbc.preon or p_descrizione is not null or /*default value*/
              '' is not null
             ,'p_descrizione on so4_codifiche_tpk.ins');
      dbc.pre(not dbc.preon or p_valore_default is not null or /*default value*/
              'default' is not null
             ,'p_valore_default on so4_codifiche_tpk.ins');
      dbc.pre(not dbc.preon or p_sequenza is not null or /*default value*/
              'default' is not null
             ,'p_sequenza on so4_codifiche_tpk.ins');
      dbc.pre(not dbc.preon or (p_id_codifica is null and /*default value*/
              'default null' is not null) -- PK nullable on insert
              or not existsid(p_id_codifica => p_id_codifica)
             ,'not existsId on so4_codifiche_tpk.ins');
      insert into so4_codifiche
         (id_codifica
         ,dominio
         ,valore
         ,descrizione
         ,valore_default
         ,sequenza)
      values
         (p_id_codifica
         ,p_dominio
         ,p_valore
         ,p_descrizione
         ,nvl(p_valore_default, 0)
         ,p_sequenza)
      returning id_codifica into d_result;
      return d_result;
   end ins; -- so4_codifiche_tpk.ins
   --------------------------------------------------------------------------------
   procedure upd
   (
      p_check_old          in integer default 0
     ,p_new_id_codifica    in so4_codifiche.id_codifica%type
     ,p_old_id_codifica    in so4_codifiche.id_codifica%type default null
     ,p_new_dominio        in so4_codifiche.dominio%type default afc.default_null('SO4_CODIFICHE.dominio')
     ,p_old_dominio        in so4_codifiche.dominio%type default null
     ,p_new_valore         in so4_codifiche.valore%type default afc.default_null('SO4_CODIFICHE.valore')
     ,p_old_valore         in so4_codifiche.valore%type default null
     ,p_new_descrizione    in so4_codifiche.descrizione%type default afc.default_null('SO4_CODIFICHE.descrizione')
     ,p_old_descrizione    in so4_codifiche.descrizione%type default null
     ,p_new_valore_default in so4_codifiche.valore_default%type default afc.default_null('SO4_CODIFICHE.valore_default')
     ,p_old_valore_default in so4_codifiche.valore_default%type default null
     ,p_new_sequenza       in so4_codifiche.sequenza%type default afc.default_null('SO4_CODIFICHE.sequenza')
     ,p_old_sequenza       in so4_codifiche.sequenza%type default null
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
              not ((p_old_dominio is not null or p_old_valore is not null or
               p_old_descrizione is not null or p_old_valore_default is not null or
               p_old_sequenza is not null) and (nvl(p_check_old, -1) = 0))
             ,' "OLD values" is not null on so4_codifiche_tpk.upd');
      d_key := pk(nvl(p_old_id_codifica, p_new_id_codifica));
      dbc.pre(not dbc.preon or existsid(p_id_codifica => d_key.id_codifica)
             ,'existsId on so4_codifiche_tpk.upd');
      update so4_codifiche
         set id_codifica    = nvl(p_new_id_codifica
                                 ,decode(afc.is_default_null('SO4_CODIFICHE.id_codifica')
                                        ,1
                                        ,id_codifica
                                        ,decode(p_check_old
                                               ,0
                                               ,null
                                               ,decode(p_old_id_codifica
                                                      ,null
                                                      ,id_codifica
                                                      ,null))))
            ,dominio        = nvl(p_new_dominio
                                 ,decode(afc.is_default_null('SO4_CODIFICHE.dominio')
                                        ,1
                                        ,dominio
                                        ,decode(p_check_old
                                               ,0
                                               ,null
                                               ,decode(p_old_dominio, null, dominio, null))))
            ,valore         = nvl(p_new_valore
                                 ,decode(afc.is_default_null('SO4_CODIFICHE.valore')
                                        ,1
                                        ,valore
                                        ,decode(p_check_old
                                               ,0
                                               ,null
                                               ,decode(p_old_valore, null, valore, null))))
            ,descrizione    = nvl(p_new_descrizione
                                 ,decode(afc.is_default_null('SO4_CODIFICHE.descrizione')
                                        ,1
                                        ,descrizione
                                        ,decode(p_check_old
                                               ,0
                                               ,null
                                               ,decode(p_old_descrizione
                                                      ,null
                                                      ,descrizione
                                                      ,null))))
            ,valore_default = nvl(p_new_valore_default
                                 ,decode(afc.is_default_null('SO4_CODIFICHE.valore_default')
                                        ,1
                                        ,valore_default
                                        ,decode(p_check_old
                                               ,0
                                               ,null
                                               ,decode(p_old_valore_default
                                                      ,null
                                                      ,valore_default
                                                      ,null))))
            ,sequenza       = nvl(p_new_sequenza
                                 ,decode(afc.is_default_null('SO4_CODIFICHE.sequenza')
                                        ,1
                                        ,sequenza
                                        ,decode(p_check_old
                                               ,0
                                               ,null
                                               ,decode(p_old_sequenza
                                                      ,null
                                                      ,sequenza
                                                      ,null))))
       where id_codifica = d_key.id_codifica
         and (p_check_old = 0 or
             (1 = 1 and
             (dominio = p_old_dominio or
             (p_old_dominio is null and (p_check_old is null or dominio is null))) and
             (valore = p_old_valore or
             (p_old_valore is null and (p_check_old is null or valore is null))) and
             (descrizione = p_old_descrizione or
             (p_old_descrizione is null and
             (p_check_old is null or descrizione is null))) and
             (valore_default = p_old_valore_default or
             (p_old_valore_default is null and
             (p_check_old is null or valore_default is null))) and
             (sequenza = p_old_sequenza or
             (p_old_sequenza is null and (p_check_old is null or sequenza is null)))));
      d_row_found := sql%rowcount;
      afc.default_null(null);
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on so4_codifiche_tpk.upd');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   end upd; -- so4_codifiche_tpk.upd
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_id_codifica   in so4_codifiche.id_codifica%type
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
      dbc.pre(not dbc.preon or existsid(p_id_codifica => p_id_codifica)
             ,'existsId on so4_codifiche_tpk.upd_column');
      dbc.pre(not dbc.preon or p_column is not null
             ,'p_column is not null on so4_codifiche_tpk.upd_column');
      dbc.pre(not dbc.preon or afc_ddl.hasattribute(s_table_name, p_column)
             ,'AFC_DDL.HasAttribute on so4_codifiche_tpk.upd_column');
      dbc.pre(p_literal_value in (0, 1) or p_literal_value is null
             ,'p_literal_value on so4_codifiche_tpk.upd_column; p_literal_value = ' ||
              p_literal_value);
      if p_literal_value = 1 or p_literal_value is null then
         d_literal := '''';
      end if;
      d_statement := ' declare ' || '    d_row_found number; ' || ' begin ' ||
                     '    update SO4_CODIFICHE ' || '       set ' || p_column || ' = ' ||
                     d_literal || p_value || d_literal || '     where 1 = 1 ' ||
                     nvl(afc.get_field_condition(' and ( id_codifica '
                                                ,p_id_codifica
                                                ,' )'
                                                ,0
                                                ,null)
                        ,' and ( id_codifica is null ) ') || '    ; ' ||
                     '    d_row_found := SQL%ROWCOUNT; ' || '    if d_row_found < 1 ' ||
                     '    then ' ||
                     '       raise_application_error ( AFC_ERROR.modified_by_other_user_number, AFC_ERROR.modified_by_other_user_msg ); ' ||
                     '    end if; ' || ' end; ';
      afc.sql_execute(d_statement);
   end upd_column; -- so4_codifiche_tpk.upd_column
   --------------------------------------------------------------------------------
   procedure del
   (
      p_check_old      in integer default 0
     ,p_id_codifica    in so4_codifiche.id_codifica%type
     ,p_dominio        in so4_codifiche.dominio%type default null
     ,p_valore         in so4_codifiche.valore%type default null
     ,p_descrizione    in so4_codifiche.descrizione%type default null
     ,p_valore_default in so4_codifiche.valore_default%type default null
     ,p_sequenza       in so4_codifiche.sequenza%type default null
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
              not ((p_dominio is not null or p_valore is not null or
               p_descrizione is not null or p_valore_default is not null or
               p_sequenza is not null) and (nvl(p_check_old, -1) = 0))
             ,' "OLD values" is not null on so4_codifiche_tpk.del');
      dbc.pre(not dbc.preon or existsid(p_id_codifica => p_id_codifica)
             ,'existsId on so4_codifiche_tpk.del');
      delete from so4_codifiche
       where id_codifica = p_id_codifica
         and (p_check_old = 0 or
             (1 = 1 and
             (dominio = p_dominio or
             (p_dominio is null and (p_check_old is null or dominio is null))) and
             (valore = p_valore or
             (p_valore is null and (p_check_old is null or valore is null))) and
             (descrizione = p_descrizione or
             (p_descrizione is null and (p_check_old is null or descrizione is null))) and
             (valore_default = p_valore_default or
             (p_valore_default is null and
             (p_check_old is null or valore_default is null))) and
             (sequenza = p_sequenza or
             (p_sequenza is null and (p_check_old is null or sequenza is null)))));
      d_row_found := sql%rowcount;
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on so4_codifiche_tpk.del');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
      dbc.post(not dbc.poston or not existsid(p_id_codifica => p_id_codifica)
              ,'existsId on so4_codifiche_tpk.del');
   end del; -- so4_codifiche_tpk.del
   --------------------------------------------------------------------------------
   function get_dominio(p_id_codifica in so4_codifiche.id_codifica%type)
      return so4_codifiche.dominio%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_dominio
       DESCRIZIONE: Getter per attributo dominio di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     SO4_CODIFICHE.dominio%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result so4_codifiche.dominio%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_codifica => p_id_codifica)
             ,'existsId on so4_codifiche_tpk.get_dominio');
      select dominio into d_result from so4_codifiche where id_codifica = p_id_codifica;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on so4_codifiche_tpk.get_dominio');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'dominio')
                      ,' AFC_DDL.IsNullable on so4_codifiche_tpk.get_dominio');
      end if;
      return d_result;
   end get_dominio; -- so4_codifiche_tpk.get_dominio
   --------------------------------------------------------------------------------
   function get_valore(p_id_codifica in so4_codifiche.id_codifica%type)
      return so4_codifiche.valore%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_valore
       DESCRIZIONE: Getter per attributo valore di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     SO4_CODIFICHE.valore%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result so4_codifiche.valore%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_codifica => p_id_codifica)
             ,'existsId on so4_codifiche_tpk.get_valore');
      select valore into d_result from so4_codifiche where id_codifica = p_id_codifica;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on so4_codifiche_tpk.get_valore');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'valore')
                      ,' AFC_DDL.IsNullable on so4_codifiche_tpk.get_valore');
      end if;
      return d_result;
   end get_valore; -- so4_codifiche_tpk.get_valore
   --------------------------------------------------------------------------------
   function get_descrizione(p_id_codifica in so4_codifiche.id_codifica%type)
      return so4_codifiche.descrizione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_descrizione
       DESCRIZIONE: Getter per attributo descrizione di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     SO4_CODIFICHE.descrizione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result so4_codifiche.descrizione%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_codifica => p_id_codifica)
             ,'existsId on so4_codifiche_tpk.get_descrizione');
      select descrizione
        into d_result
        from so4_codifiche
       where id_codifica = p_id_codifica;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on so4_codifiche_tpk.get_descrizione');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'descrizione')
                      ,' AFC_DDL.IsNullable on so4_codifiche_tpk.get_descrizione');
      end if;
      return d_result;
   end get_descrizione; -- so4_codifiche_tpk.get_descrizione
   --------------------------------------------------------------------------------
   function get_descrizione
   (
      p_dominio in so4_codifiche.dominio%type
     ,p_valore  in so4_codifiche.valore%type
   ) return so4_codifiche.descrizione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_descrizione
       DESCRIZIONE: Getter per attributo descrizione di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     SO4_CODIFICHE.descrizione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result so4_codifiche.descrizione%type;
   begin
      select descrizione
        into d_result
        from so4_codifiche
       where dominio = p_dominio
         and valore = p_valore;
      -- Check Mandatory Attribute on Table
      return d_result;
   end get_descrizione; -- so4_codifiche_tpk.get_descrizione
   --------------------------------------------------------------------------------
   function get_valore_default(p_id_codifica in so4_codifiche.id_codifica%type)
      return so4_codifiche.valore_default%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_valore_default
       DESCRIZIONE: Getter per attributo valore_default di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     SO4_CODIFICHE.valore_default%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result so4_codifiche.valore_default%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_codifica => p_id_codifica)
             ,'existsId on so4_codifiche_tpk.get_valore_default');
      select valore_default
        into d_result
        from so4_codifiche
       where id_codifica = p_id_codifica;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on so4_codifiche_tpk.get_valore_default');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'valore_default')
                      ,' AFC_DDL.IsNullable on so4_codifiche_tpk.get_valore_default');
      end if;
      return d_result;
   end get_valore_default; -- so4_codifiche_tpk.get_valore_default
   --------------------------------------------------------------------------------
   function get_sequenza(p_id_codifica in so4_codifiche.id_codifica%type)
      return so4_codifiche.sequenza%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_sequenza
       DESCRIZIONE: Getter per attributo sequenza di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     SO4_CODIFICHE.sequenza%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result so4_codifiche.sequenza%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_codifica => p_id_codifica)
             ,'existsId on so4_codifiche_tpk.get_sequenza');
      select sequenza into d_result from so4_codifiche where id_codifica = p_id_codifica;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on so4_codifiche_tpk.get_sequenza');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'sequenza')
                      ,' AFC_DDL.IsNullable on so4_codifiche_tpk.get_sequenza');
      end if;
      return d_result;
   end get_sequenza; -- so4_codifiche_tpk.get_sequenza
   --------------------------------------------------------------------------------
   procedure set_id_codifica
   (
      p_id_codifica in so4_codifiche.id_codifica%type
     ,p_value       in so4_codifiche.id_codifica%type default null
   ) is
      /******************************************************************************
       NOME:        set_id_codifica
       DESCRIZIONE: Setter per attributo id_codifica di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_codifica => p_id_codifica)
             ,'existsId on so4_codifiche_tpk.set_id_codifica');
      update so4_codifiche set id_codifica = p_value where id_codifica = p_id_codifica;
   end set_id_codifica; -- so4_codifiche_tpk.set_id_codifica
   --------------------------------------------------------------------------------
   procedure set_dominio
   (
      p_id_codifica in so4_codifiche.id_codifica%type
     ,p_value       in so4_codifiche.dominio%type default null
   ) is
      /******************************************************************************
       NOME:        set_dominio
       DESCRIZIONE: Setter per attributo dominio di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_codifica => p_id_codifica)
             ,'existsId on so4_codifiche_tpk.set_dominio');
      update so4_codifiche set dominio = p_value where id_codifica = p_id_codifica;
   end set_dominio; -- so4_codifiche_tpk.set_dominio
   --------------------------------------------------------------------------------
   procedure set_valore
   (
      p_id_codifica in so4_codifiche.id_codifica%type
     ,p_value       in so4_codifiche.valore%type default null
   ) is
      /******************************************************************************
       NOME:        set_valore
       DESCRIZIONE: Setter per attributo valore di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_codifica => p_id_codifica)
             ,'existsId on so4_codifiche_tpk.set_valore');
      update so4_codifiche set valore = p_value where id_codifica = p_id_codifica;
   end set_valore; -- so4_codifiche_tpk.set_valore
   --------------------------------------------------------------------------------
   procedure set_descrizione
   (
      p_id_codifica in so4_codifiche.id_codifica%type
     ,p_value       in so4_codifiche.descrizione%type default null
   ) is
      /******************************************************************************
       NOME:        set_descrizione
       DESCRIZIONE: Setter per attributo descrizione di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_codifica => p_id_codifica)
             ,'existsId on so4_codifiche_tpk.set_descrizione');
      update so4_codifiche set descrizione = p_value where id_codifica = p_id_codifica;
   end set_descrizione; -- so4_codifiche_tpk.set_descrizione
   --------------------------------------------------------------------------------
   procedure set_valore_default
   (
      p_id_codifica in so4_codifiche.id_codifica%type
     ,p_value       in so4_codifiche.valore_default%type default null
   ) is
      /******************************************************************************
       NOME:        set_valore_default
       DESCRIZIONE: Setter per attributo valore_default di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_codifica => p_id_codifica)
             ,'existsId on so4_codifiche_tpk.set_valore_default');
      update so4_codifiche
         set valore_default = p_value
       where id_codifica = p_id_codifica;
   end set_valore_default; -- so4_codifiche_tpk.set_valore_default
   --------------------------------------------------------------------------------
   procedure set_sequenza
   (
      p_id_codifica in so4_codifiche.id_codifica%type
     ,p_value       in so4_codifiche.sequenza%type default null
   ) is
      /******************************************************************************
       NOME:        set_sequenza
       DESCRIZIONE: Setter per attributo sequenza di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_codifica => p_id_codifica)
             ,'existsId on so4_codifiche_tpk.set_sequenza');
      update so4_codifiche set sequenza = p_value where id_codifica = p_id_codifica;
   end set_sequenza; -- so4_codifiche_tpk.set_sequenza
   --------------------------------------------------------------------------------
   function where_condition /* SLAVE_COPY */
   (
      p_qbe             in number default 0
     ,p_other_condition in varchar2 default null
     ,p_id_codifica     in varchar2 default null
     ,p_dominio         in varchar2 default null
     ,p_valore          in varchar2 default null
     ,p_descrizione     in varchar2 default null
     ,p_valore_default  in varchar2 default null
     ,p_sequenza        in varchar2 default null
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
                     afc.get_field_condition(' and ( id_codifica '
                                            ,p_id_codifica
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( dominio '
                                            ,p_dominio
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( valore '
                                            ,p_valore
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( descrizione '
                                            ,p_descrizione
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( valore_default '
                                            ,p_valore_default
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( sequenza '
                                            ,p_sequenza
                                            ,' )'
                                            ,p_qbe
                                            ,null) || ' ) ' || p_other_condition;
      return d_statement;
   end where_condition; --- so4_codifiche_tpk.where_condition
   --------------------------------------------------------------------------------
   function get_rows
   (
      p_qbe             in number default 0
     ,p_other_condition in varchar2 default null
     ,p_order_by        in varchar2 default null
     ,p_extra_columns   in varchar2 default null
     ,p_extra_condition in varchar2 default null
     ,p_id_codifica     in varchar2 default null
     ,p_dominio         in varchar2 default null
     ,p_valore          in varchar2 default null
     ,p_descrizione     in varchar2 default null
     ,p_valore_default  in varchar2 default null
     ,p_sequenza        in varchar2 default null
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
      d_statement  := ' select SO4_CODIFICHE.* ' ||
                      afc.decode_value(p_extra_columns
                                      ,null
                                      ,null
                                      ,' , ' || p_extra_columns) ||
                      ' from SO4_CODIFICHE ' ||
                      where_condition(p_qbe             => p_qbe
                                     ,p_other_condition => p_other_condition
                                     ,p_id_codifica     => p_id_codifica
                                     ,p_dominio         => p_dominio
                                     ,p_valore          => p_valore
                                     ,p_descrizione     => p_descrizione
                                     ,p_valore_default  => p_valore_default
                                     ,p_sequenza        => p_sequenza) || ' ' ||
                      p_extra_condition ||
                      afc.decode_value(p_order_by, null, null, ' order by ' || p_order_by);
      d_ref_cursor := afc_dml.get_ref_cursor(d_statement);
      return d_ref_cursor;
   end get_rows; -- so4_codifiche_tpk.get_rows
   --------------------------------------------------------------------------------
   function count_rows
   (
      p_qbe             in number default 0
     ,p_other_condition in varchar2 default null
     ,p_id_codifica     in varchar2 default null
     ,p_dominio         in varchar2 default null
     ,p_valore          in varchar2 default null
     ,p_descrizione     in varchar2 default null
     ,p_valore_default  in varchar2 default null
     ,p_sequenza        in varchar2 default null
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
      d_statement := ' select count( * ) from SO4_CODIFICHE ' ||
                     where_condition(p_qbe             => p_qbe
                                    ,p_other_condition => p_other_condition
                                    ,p_id_codifica     => p_id_codifica
                                    ,p_dominio         => p_dominio
                                    ,p_valore          => p_valore
                                    ,p_descrizione     => p_descrizione
                                    ,p_valore_default  => p_valore_default
                                    ,p_sequenza        => p_sequenza);
      d_result    := afc.sql_execute(d_statement);
      return d_result;
   end count_rows; -- so4_codifiche_tpk.count_rows
--------------------------------------------------------------------------------

end so4_codifica;
/

