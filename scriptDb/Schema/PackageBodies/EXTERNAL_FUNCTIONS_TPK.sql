CREATE OR REPLACE PACKAGE BODY external_functions_tpk is
/******************************************************************************
 NOME:        external_functions_tpk
 DESCRIZIONE: Gestione tabella EXTERNAL_FUNCTIONS.
 ANNOTAZIONI: .
 REVISIONI:   .
 Rev.  Data        Autore  Descrizione.
 000   11/05/2009  mmalferrari  Prima emissione.
******************************************************************************/
   s_revisione_body      constant AFC.t_revision := '000';
--------------------------------------------------------------------------------
function versione
return varchar2 is /* SLAVE_COPY */
/******************************************************************************
 NOME:        versione
 DESCRIZIONE: Versione e revisione di distribuzione del package.
 RITORNA:     varchar2 stringa contenente versione e revisione.
 NOTE:        Primo numero  : versione compatibilità del Package.
              Secondo numero: revisione del Package specification.
              Terzo numero  : revisione del Package body.
******************************************************************************/
begin
   return AFC.version ( s_revisione, s_revisione_body );
end versione; -- external_functions_tpk.versione
--------------------------------------------------------------------------------
function PK
(
 p_function_id  in EXTERNAL_FUNCTIONS.function_id%type
) return t_PK is /* SLAVE_COPY */
/******************************************************************************
 NOME:        PK
 DESCRIZIONE: Costruttore di un t_PK dati gli attributi della chiave
******************************************************************************/
   d_result t_PK;
begin
   d_result.function_id := p_function_id;
   DbC.PRE ( not DbC.PreOn or canHandle (
                                          p_function_id => d_result.function_id
                                        )
           , 'canHandle on external_functions_tpk.PK'
           );
   return  d_result;
end PK; -- external_functions_tpk.PK
--------------------------------------------------------------------------------
function can_handle
(
 p_function_id  in EXTERNAL_FUNCTIONS.function_id%type
) return number is /* SLAVE_COPY */
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
   if  d_result = 1
   and (
          p_function_id is null
       )
   then
      d_result := 0;
   end if;
   DbC.POST ( d_result = 1  or  d_result = 0
            , 'd_result = 1  or  d_result = 0 on external_functions_tpk.can_handle'
            );
   return  d_result;
end can_handle; -- external_functions_tpk.can_handle
--------------------------------------------------------------------------------
function canHandle
(
 p_function_id  in EXTERNAL_FUNCTIONS.function_id%type
) return boolean is /* SLAVE_COPY */
/******************************************************************************
 NOME:        canHandle
 DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
 PARAMETRI:   Attributi chiave.
 RITORNA:     number: true se la chiave è manipolabile, false altrimenti.
 NOTE:        Wrapper boolean di can_handle (cfr. can_handle).
******************************************************************************/
   d_result constant boolean := AFC.to_boolean ( can_handle (
                                                              p_function_id => p_function_id
                                                            )
                                               );
begin
   return  d_result;
end canHandle; -- external_functions_tpk.canHandle
--------------------------------------------------------------------------------
function exists_id
(
 p_function_id  in EXTERNAL_FUNCTIONS.function_id%type
) return number is /* SLAVE_COPY */
/******************************************************************************
 NOME:        exists_id
 DESCRIZIONE: Esistenza riga con chiave indicata.
 PARAMETRI:   Attributi chiave.
 RITORNA:     number: 1 se la riga esiste, 0 altrimenti.
 NOTE:        cfr. existsId per ritorno valori boolean.
******************************************************************************/
   d_result number;
begin
   DbC.PRE ( not DbC.PreOn or canHandle (
                                         p_function_id => p_function_id
                                        )
           , 'canHandle on external_functions_tpk.exists_id'
           );
   begin
      select 1
      into   d_result
      from   EXTERNAL_FUNCTIONS
      where
      function_id = p_function_id
      ;
   exception
      when no_data_found then
         d_result := 0;
   end;
   DbC.POST ( d_result = 1  or  d_result = 0
            , 'd_result = 1  or  d_result = 0 on external_functions_tpk.exists_id'
            );
   return  d_result;
end exists_id; -- external_functions_tpk.exists_id
--------------------------------------------------------------------------------
function existsId
(
 p_function_id  in EXTERNAL_FUNCTIONS.function_id%type
) return boolean is /* SLAVE_COPY */
/******************************************************************************
 NOME:        existsId
 DESCRIZIONE: Esistenza riga con chiave indicata.
 NOTE:        Wrapper boolean di exists_id (cfr. exists_id).
******************************************************************************/
   d_result constant boolean := AFC.to_boolean ( exists_id (
                                                            p_function_id => p_function_id
                                                           )
                                               );
begin
   return  d_result;
end existsId; -- external_functions_tpk.existsId
--------------------------------------------------------------------------------
procedure ins
(
  p_function_id  in EXTERNAL_FUNCTIONS.function_id%type default null
, p_table_name  in EXTERNAL_FUNCTIONS.table_name%type
, p_function_owner  in EXTERNAL_FUNCTIONS.function_owner%type
, p_firing_function  in EXTERNAL_FUNCTIONS.firing_function%type
, p_firing_event  in EXTERNAL_FUNCTIONS.firing_event%type
) is
/******************************************************************************
 NOME:        ins
 DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
 PARAMETRI:   Chiavi e attributi della table.
******************************************************************************/
begin
   -- Check Mandatory on Insert
   DbC.PRE ( not DbC.PreOn or p_table_name is not null or /*default value*/ '' is not null
           , 'p_table_name on external_functions_tpk.ins'
           );
   DbC.PRE ( not DbC.PreOn or p_function_owner is not null or /*default value*/ '' is not null
           , 'p_function_owner on external_functions_tpk.ins'
           );
   DbC.PRE ( not DbC.PreOn or p_firing_function is not null or /*default value*/ '' is not null
           , 'p_firing_function on external_functions_tpk.ins'
           );
   DbC.PRE ( not DbC.PreOn or p_firing_event is not null or /*default value*/ '' is not null
           , 'p_firing_event on external_functions_tpk.ins'
           );
   DbC.PRE (  not DbC.PreOn
           or (   p_function_id is null and /*default value*/ 'default null' is not null ) -- PK nullable on insert
           or not existsId (
                             p_function_id => p_function_id
                           )
           , 'not existsId on external_functions_tpk.ins'
           );
   insert into EXTERNAL_FUNCTIONS
   (
     function_id
   , table_name
   , function_owner
   , firing_function
   , firing_event
   )
   values
   (
     p_function_id
   , p_table_name
   , p_function_owner
   , p_firing_function
   , p_firing_event
   );
end ins; -- external_functions_tpk.ins
--------------------------------------------------------------------------------
function ins  /*+ SOA  */
(
  p_function_id  in EXTERNAL_FUNCTIONS.function_id%type default null
, p_table_name  in EXTERNAL_FUNCTIONS.table_name%type
, p_function_owner  in EXTERNAL_FUNCTIONS.function_owner%type
, p_firing_function  in EXTERNAL_FUNCTIONS.firing_function%type
, p_firing_event  in EXTERNAL_FUNCTIONS.firing_event%type
) return integer
/******************************************************************************
 NOME:        ins
 DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
 PARAMETRI:   Chiavi e attributi della table.
 RITORNA:     In caso di PK formata da colonna numerica, ritorna il valore della PK
              (se positivo), in tutti gli altri casi ritorna 0; in caso di errore,
              ritorna il codice di errore
******************************************************************************/
is
   d_result integer;
begin
   -- Check Mandatory on Insert
   DbC.PRE ( not DbC.PreOn or p_table_name is not null or /*default value*/ '' is not null
           , 'p_table_name on external_functions_tpk.ins'
           );
   DbC.PRE ( not DbC.PreOn or p_function_owner is not null or /*default value*/ '' is not null
           , 'p_function_owner on external_functions_tpk.ins'
           );
   DbC.PRE ( not DbC.PreOn or p_firing_function is not null or /*default value*/ '' is not null
           , 'p_firing_function on external_functions_tpk.ins'
           );
   DbC.PRE ( not DbC.PreOn or p_firing_event is not null or /*default value*/ '' is not null
           , 'p_firing_event on external_functions_tpk.ins'
           );
   DbC.PRE (  not DbC.PreOn
           or (   p_function_id is null and /*default value*/ 'default null' is not null ) -- PK nullable on insert
           or not existsId (
                             p_function_id => p_function_id
                           )
           , 'not existsId on external_functions_tpk.ins'
           );
   begin
      insert into EXTERNAL_FUNCTIONS
      (
        function_id
      , table_name
      , function_owner
      , firing_function
      , firing_event
      )
      values
      (
        p_function_id
      , p_table_name
      , p_function_owner
      , p_firing_function
      , p_firing_event
      ) returning function_id
      into d_result;
      if d_result < 0
      then
         d_result := 0;
      end if;
   exception
      when others then
         d_result := sqlcode;
   end;
   return d_result;
end ins; -- external_functions_tpk.ins
--------------------------------------------------------------------------------
procedure upd
(
  p_check_OLD  in integer default 0
, p_NEW_function_id  in EXTERNAL_FUNCTIONS.function_id%type
, p_OLD_function_id  in EXTERNAL_FUNCTIONS.function_id%type default null
, p_NEW_table_name  in EXTERNAL_FUNCTIONS.table_name%type default null
, p_OLD_table_name  in EXTERNAL_FUNCTIONS.table_name%type default null
, p_NEW_function_owner  in EXTERNAL_FUNCTIONS.function_owner%type default null
, p_OLD_function_owner  in EXTERNAL_FUNCTIONS.function_owner%type default null
, p_NEW_firing_function  in EXTERNAL_FUNCTIONS.firing_function%type default null
, p_OLD_firing_function  in EXTERNAL_FUNCTIONS.firing_function%type default null
, p_NEW_firing_event  in EXTERNAL_FUNCTIONS.firing_event%type default null
, p_OLD_firing_event  in EXTERNAL_FUNCTIONS.firing_event%type default null
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
   d_key t_PK;
   d_row_found number;
begin
   DbC.PRE (  not DbC.PreOn
           or not ( (
p_OLD_table_name is not null or
p_OLD_function_owner is not null or
p_OLD_firing_function is not null or
p_OLD_firing_event is not null
                    )
                    and (  nvl( p_check_OLD, -1 ) = 0
                        )
                  )
           , ' "OLD values" is not null on external_functions_tpk.upd'
           );
   d_key := PK (
                nvl( p_OLD_function_id, p_NEW_function_id )
               );
   DbC.PRE ( not DbC.PreOn or existsId (
                                         p_function_id => d_key.function_id
                                       )
           , 'existsId on external_functions_tpk.upd'
           );
   update EXTERNAL_FUNCTIONS
   set
       function_id = decode( p_check_OLD, 0,p_NEW_function_id, decode(p_NEW_function_id, p_OLD_function_id,function_id,p_NEW_function_id))
     , table_name = decode( p_check_OLD, 0,p_NEW_table_name, decode(p_NEW_table_name, p_OLD_table_name,table_name,p_NEW_table_name))
     , function_owner = decode( p_check_OLD, 0,p_NEW_function_owner, decode(p_NEW_function_owner, p_OLD_function_owner,function_owner,p_NEW_function_owner))
     , firing_function = decode( p_check_OLD, 0,p_NEW_firing_function, decode(p_NEW_firing_function, p_OLD_firing_function,firing_function,p_NEW_firing_function))
     , firing_event = decode( p_check_OLD, 0,p_NEW_firing_event, decode(p_NEW_firing_event, p_OLD_firing_event,firing_event,p_NEW_firing_event))
   where
     function_id = d_key.function_id
   and (   p_check_OLD = 0
        or (   1 = 1
           and ( table_name = p_OLD_table_name or ( p_OLD_table_name is null and ( p_check_OLD is null or table_name is null ) ) )
           and ( function_owner = p_OLD_function_owner or ( p_OLD_function_owner is null and ( p_check_OLD is null or function_owner is null ) ) )
           and ( firing_function = p_OLD_firing_function or ( p_OLD_firing_function is null and ( p_check_OLD is null or firing_function is null ) ) )
           and ( firing_event = p_OLD_firing_event or ( p_OLD_firing_event is null and ( p_check_OLD is null or firing_event is null ) ) )
           )
       )
   ;
   d_row_found := SQL%ROWCOUNT;
   DbC.ASSERTION ( not DbC.AssertionOn or d_row_found <= 1
                 , 'd_row_found <= 1 on external_functions_tpk.upd'
                 );
   if d_row_found < 1
   then
      raise_application_error ( AFC_ERROR.modified_by_other_user_number
                              , AFC_ERROR.modified_by_other_user_msg
                              );
   end if;
end upd; -- external_functions_tpk.upd
--------------------------------------------------------------------------------
procedure upd_column
(
  p_function_id  in EXTERNAL_FUNCTIONS.function_id%type
, p_column         in varchar2
, p_value          in varchar2 default null
, p_literal_value  in number   default 1
) is
/******************************************************************************
 NOME:        upd_column
 DESCRIZIONE: Aggiornamento del campo p_column col valore p_value.
 PARAMETRI:   p_column:        identificatore del campo da aggiornare.
              p_value:         valore da modificare.
              p_literal_value: indica se il valore è un stringa e non un numero
                               o una funzione.
******************************************************************************/
   d_statement AFC.t_statement;
   d_literal   varchar2(2);
begin
   DbC.PRE ( not DbC.PreOn or existsId (
                                        p_function_id => p_function_id
                                       )
           , 'existsId on external_functions_tpk.upd_column'
           );
   DbC.PRE ( not DbC.PreOn or p_column is not null
           , 'p_column is not null on external_functions_tpk.upd_column'
           );
   DbC.PRE ( not DbC.PreOn or AFC_DDL.HasAttribute( s_table_name, p_column )
           , 'AFC_DDL.HasAttribute on external_functions_tpk.upd_column'
           );
   DbC.PRE ( p_literal_value in ( 0, 1 ) or p_literal_value is null
           , 'p_literal_value on external_functions_tpk.upd_column; p_literal_value = ' || p_literal_value
           );
   if p_literal_value = 1
   or p_literal_value is null
   then
      d_literal := '''';
   end if;
   d_statement := ' declare '
               || '    d_row_found number; '
               || ' begin '
               || '    update EXTERNAL_FUNCTIONS '
               || '       set ' || p_column || ' = ' || d_literal || p_value || d_literal
               || '     where 1 = 1 '
               || nvl( AFC.get_field_condition( ' and ( function_id ', p_function_id, ' )', 0, null ), ' and ( function_id is null ) ' )
               || '    ; '
               || '    d_row_found := SQL%ROWCOUNT; '
               || '    if d_row_found < 1 '
               || '    then '
               || '       raise_application_error ( AFC_ERROR.modified_by_other_user_number, AFC_ERROR.modified_by_other_user_msg ); '
               || '    end if; '
               || ' end; ';
   AFC.SQL_execute( d_statement );
end upd_column; -- external_functions_tpk.upd_column
--------------------------------------------------------------------------------
procedure del
(
  p_check_old  in integer default 0
, p_function_id  in EXTERNAL_FUNCTIONS.function_id%type
, p_table_name  in EXTERNAL_FUNCTIONS.table_name%type default null
, p_function_owner  in EXTERNAL_FUNCTIONS.function_owner%type default null
, p_firing_function  in EXTERNAL_FUNCTIONS.firing_function%type default null
, p_firing_event  in EXTERNAL_FUNCTIONS.firing_event%type default null
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
   DbC.PRE (  not DbC.PreOn
           or not ( (
p_table_name is not null or
p_function_owner is not null or
p_firing_function is not null or
p_firing_event is not null
                    )
                    and (  nvl( p_check_OLD, -1 ) = 0
                        )
                  )
           , ' "OLD values" is not null on external_functions_tpk.del'
           );
   DbC.PRE ( not DbC.PreOn or existsId (
                                         p_function_id => p_function_id
                                       )
           , 'existsId on external_functions_tpk.del'
           );
   delete from EXTERNAL_FUNCTIONS
   where
     function_id = p_function_id
   and (   p_check_OLD = 0
        or (   1 = 1
           and ( table_name = p_table_name or ( p_table_name is null and ( p_check_OLD is null or table_name is null ) ) )
           and ( function_owner = p_function_owner or ( p_function_owner is null and ( p_check_OLD is null or function_owner is null ) ) )
           and ( firing_function = p_firing_function or ( p_firing_function is null and ( p_check_OLD is null or firing_function is null ) ) )
           and ( firing_event = p_firing_event or ( p_firing_event is null and ( p_check_OLD is null or firing_event is null ) ) )
           )
       )
   ;
   d_row_found := SQL%ROWCOUNT;
   DbC.ASSERTION ( not DbC.AssertionOn or d_row_found <= 1
                 , 'd_row_found <= 1 on external_functions_tpk.del'
                 );
   if d_row_found < 1
   then
      raise_application_error ( AFC_ERROR.modified_by_other_user_number
                              , AFC_ERROR.modified_by_other_user_msg
                              );
   end if;
   DbC.POST ( not DbC.PostOn or not existsId (
                                               p_function_id => p_function_id
                                             )
            , 'existsId on external_functions_tpk.del'
            );
end del; -- external_functions_tpk.del
--------------------------------------------------------------------------------
function get_table_name
(
  p_function_id  in EXTERNAL_FUNCTIONS.function_id%type
) return EXTERNAL_FUNCTIONS.table_name%type is /* SLAVE_COPY */
/******************************************************************************
 NOME:        get_table_name
 DESCRIZIONE: Getter per attributo table_name di riga identificata dalla chiave.
 PARAMETRI:   Attributi chiave.
 RITORNA:     EXTERNAL_FUNCTIONS.table_name%type.
 NOTE:        La riga identificata deve essere presente.
******************************************************************************/
   d_result EXTERNAL_FUNCTIONS.table_name%type;
begin
   DbC.PRE ( not DbC.PreOn or  existsId (
                                          p_function_id => p_function_id
                                        )
           , 'existsId on external_functions_tpk.get_table_name'
           );
   select table_name
   into   d_result
   from   EXTERNAL_FUNCTIONS
   where
   function_id = p_function_id
   ;
  -- Check Mandatory Attribute on Table
  if (true)  -- is Mandatory on Table ?
  then -- Result must be not null
      DbC.POST ( not DbC.PostOn  or  d_result is not null
               , 'd_result is not null on external_functions_tpk.get_table_name'
               );
   else -- Column must nullable on table
      DbC.ASSERTION ( not DbC.AssertionOn  or  AFC_DDL.IsNullable ( s_table_name, 'table_name')
                    , ' AFC_DDL.IsNullable on external_functions_tpk.get_table_name'
                    );
   end if;
   return  d_result;
end get_table_name; -- external_functions_tpk.get_table_name
--------------------------------------------------------------------------------
function get_function_owner
(
  p_function_id  in EXTERNAL_FUNCTIONS.function_id%type
) return EXTERNAL_FUNCTIONS.function_owner%type is /* SLAVE_COPY */
/******************************************************************************
 NOME:        get_function_owner
 DESCRIZIONE: Getter per attributo function_owner di riga identificata dalla chiave.
 PARAMETRI:   Attributi chiave.
 RITORNA:     EXTERNAL_FUNCTIONS.function_owner%type.
 NOTE:        La riga identificata deve essere presente.
******************************************************************************/
   d_result EXTERNAL_FUNCTIONS.function_owner%type;
begin
   DbC.PRE ( not DbC.PreOn or  existsId (
                                          p_function_id => p_function_id
                                        )
           , 'existsId on external_functions_tpk.get_function_owner'
           );
   select function_owner
   into   d_result
   from   EXTERNAL_FUNCTIONS
   where
   function_id = p_function_id
   ;
  -- Check Mandatory Attribute on Table
  if (true)  -- is Mandatory on Table ?
  then -- Result must be not null
      DbC.POST ( not DbC.PostOn  or  d_result is not null
               , 'd_result is not null on external_functions_tpk.get_function_owner'
               );
   else -- Column must nullable on table
      DbC.ASSERTION ( not DbC.AssertionOn  or  AFC_DDL.IsNullable ( s_table_name, 'function_owner')
                    , ' AFC_DDL.IsNullable on external_functions_tpk.get_function_owner'
                    );
   end if;
   return  d_result;
end get_function_owner; -- external_functions_tpk.get_function_owner
--------------------------------------------------------------------------------
function get_firing_function
(
  p_function_id  in EXTERNAL_FUNCTIONS.function_id%type
) return EXTERNAL_FUNCTIONS.firing_function%type is /* SLAVE_COPY */
/******************************************************************************
 NOME:        get_firing_function
 DESCRIZIONE: Getter per attributo firing_function di riga identificata dalla chiave.
 PARAMETRI:   Attributi chiave.
 RITORNA:     EXTERNAL_FUNCTIONS.firing_function%type.
 NOTE:        La riga identificata deve essere presente.
******************************************************************************/
   d_result EXTERNAL_FUNCTIONS.firing_function%type;
begin
   DbC.PRE ( not DbC.PreOn or  existsId (
                                          p_function_id => p_function_id
                                        )
           , 'existsId on external_functions_tpk.get_firing_function'
           );
   select firing_function
   into   d_result
   from   EXTERNAL_FUNCTIONS
   where
   function_id = p_function_id
   ;
  -- Check Mandatory Attribute on Table
  if (true)  -- is Mandatory on Table ?
  then -- Result must be not null
      DbC.POST ( not DbC.PostOn  or  d_result is not null
               , 'd_result is not null on external_functions_tpk.get_firing_function'
               );
   else -- Column must nullable on table
      DbC.ASSERTION ( not DbC.AssertionOn  or  AFC_DDL.IsNullable ( s_table_name, 'firing_function')
                    , ' AFC_DDL.IsNullable on external_functions_tpk.get_firing_function'
                    );
   end if;
   return  d_result;
end get_firing_function; -- external_functions_tpk.get_firing_function
--------------------------------------------------------------------------------
function get_firing_event
(
  p_function_id  in EXTERNAL_FUNCTIONS.function_id%type
) return EXTERNAL_FUNCTIONS.firing_event%type is /* SLAVE_COPY */
/******************************************************************************
 NOME:        get_firing_event
 DESCRIZIONE: Getter per attributo firing_event di riga identificata dalla chiave.
 PARAMETRI:   Attributi chiave.
 RITORNA:     EXTERNAL_FUNCTIONS.firing_event%type.
 NOTE:        La riga identificata deve essere presente.
******************************************************************************/
   d_result EXTERNAL_FUNCTIONS.firing_event%type;
begin
   DbC.PRE ( not DbC.PreOn or  existsId (
                                          p_function_id => p_function_id
                                        )
           , 'existsId on external_functions_tpk.get_firing_event'
           );
   select firing_event
   into   d_result
   from   EXTERNAL_FUNCTIONS
   where
   function_id = p_function_id
   ;
  -- Check Mandatory Attribute on Table
  if (true)  -- is Mandatory on Table ?
  then -- Result must be not null
      DbC.POST ( not DbC.PostOn  or  d_result is not null
               , 'd_result is not null on external_functions_tpk.get_firing_event'
               );
   else -- Column must nullable on table
      DbC.ASSERTION ( not DbC.AssertionOn  or  AFC_DDL.IsNullable ( s_table_name, 'firing_event')
                    , ' AFC_DDL.IsNullable on external_functions_tpk.get_firing_event'
                    );
   end if;
   return  d_result;
end get_firing_event; -- external_functions_tpk.get_firing_event
--------------------------------------------------------------------------------
procedure set_function_id
(
  p_function_id  in EXTERNAL_FUNCTIONS.function_id%type
, p_value  in EXTERNAL_FUNCTIONS.function_id%type default null
) is
/******************************************************************************
 NOME:        set_function_id
 DESCRIZIONE: Setter per attributo function_id di riga identificata dalla chiave.
 PARAMETRI:   Attributi chiave.
 NOTE:        La riga identificata deve essere presente.
******************************************************************************/
begin
   DbC.PRE ( not DbC.PreOn or  existsId (
                                          p_function_id => p_function_id
                                        )
           , 'existsId on external_functions_tpk.set_function_id'
           );
   update EXTERNAL_FUNCTIONS
   set function_id = p_value
   where
   function_id = p_function_id
   ;
end set_function_id; -- external_functions_tpk.set_function_id
--------------------------------------------------------------------------------
procedure set_table_name
(
  p_function_id  in EXTERNAL_FUNCTIONS.function_id%type
, p_value  in EXTERNAL_FUNCTIONS.table_name%type default null
) is
/******************************************************************************
 NOME:        set_table_name
 DESCRIZIONE: Setter per attributo table_name di riga identificata dalla chiave.
 PARAMETRI:   Attributi chiave.
 NOTE:        La riga identificata deve essere presente.
******************************************************************************/
begin
   DbC.PRE ( not DbC.PreOn or  existsId (
                                          p_function_id => p_function_id
                                        )
           , 'existsId on external_functions_tpk.set_table_name'
           );
   update EXTERNAL_FUNCTIONS
   set table_name = p_value
   where
   function_id = p_function_id
   ;
end set_table_name; -- external_functions_tpk.set_table_name
--------------------------------------------------------------------------------
procedure set_function_owner
(
  p_function_id  in EXTERNAL_FUNCTIONS.function_id%type
, p_value  in EXTERNAL_FUNCTIONS.function_owner%type default null
) is
/******************************************************************************
 NOME:        set_function_owner
 DESCRIZIONE: Setter per attributo function_owner di riga identificata dalla chiave.
 PARAMETRI:   Attributi chiave.
 NOTE:        La riga identificata deve essere presente.
******************************************************************************/
begin
   DbC.PRE ( not DbC.PreOn or  existsId (
                                          p_function_id => p_function_id
                                        )
           , 'existsId on external_functions_tpk.set_function_owner'
           );
   update EXTERNAL_FUNCTIONS
   set function_owner = p_value
   where
   function_id = p_function_id
   ;
end set_function_owner; -- external_functions_tpk.set_function_owner
--------------------------------------------------------------------------------
procedure set_firing_function
(
  p_function_id  in EXTERNAL_FUNCTIONS.function_id%type
, p_value  in EXTERNAL_FUNCTIONS.firing_function%type default null
) is
/******************************************************************************
 NOME:        set_firing_function
 DESCRIZIONE: Setter per attributo firing_function di riga identificata dalla chiave.
 PARAMETRI:   Attributi chiave.
 NOTE:        La riga identificata deve essere presente.
******************************************************************************/
begin
   DbC.PRE ( not DbC.PreOn or  existsId (
                                          p_function_id => p_function_id
                                        )
           , 'existsId on external_functions_tpk.set_firing_function'
           );
   update EXTERNAL_FUNCTIONS
   set firing_function = p_value
   where
   function_id = p_function_id
   ;
end set_firing_function; -- external_functions_tpk.set_firing_function
--------------------------------------------------------------------------------
procedure set_firing_event
(
  p_function_id  in EXTERNAL_FUNCTIONS.function_id%type
, p_value  in EXTERNAL_FUNCTIONS.firing_event%type default null
) is
/******************************************************************************
 NOME:        set_firing_event
 DESCRIZIONE: Setter per attributo firing_event di riga identificata dalla chiave.
 PARAMETRI:   Attributi chiave.
 NOTE:        La riga identificata deve essere presente.
******************************************************************************/
begin
   DbC.PRE ( not DbC.PreOn or  existsId (
                                          p_function_id => p_function_id
                                        )
           , 'existsId on external_functions_tpk.set_firing_event'
           );
   update EXTERNAL_FUNCTIONS
   set firing_event = p_value
   where
   function_id = p_function_id
   ;
end set_firing_event; -- external_functions_tpk.set_firing_event
--------------------------------------------------------------------------------
function where_condition /* SLAVE_COPY */
( p_QBE  in number default 0
, p_other_condition in varchar2 default null
, p_function_id  in varchar2 default null
, p_table_name  in varchar2 default null
, p_function_owner  in varchar2 default null
, p_firing_function  in varchar2 default null
, p_firing_event  in varchar2 default null
) return AFC.t_statement is /* SLAVE_COPY */
/******************************************************************************
 NOME:        where_condition
 DESCRIZIONE: Ritorna la where_condition per lo statement di select di get_rows e count_rows.
 PARAMETRI:   p_other_condition
              p_QBE 0: se l'operatore da utilizzare nella where-condition è
                       quello di default ('=')
                    1: se l'operatore da utilizzare nella where-condition è
                       quello specificato per ogni attributo.
              Chiavi e attributi della table
 RITORNA:     AFC.t_statement.
 NOTE:        Se p_QBE = 1 , ogni parametro deve contenere, nella prima parte,
              l'operatore da utilizzare nella where-condition.
******************************************************************************/
   d_statement AFC.t_statement;
begin
   d_statement := ' where ( 1 = 1 '
               || AFC.get_field_condition( ' and ( function_id ', p_function_id, ' )', p_QBE, null )
               || AFC.get_field_condition( ' and ( table_name ', p_table_name , ' )', p_QBE, null )
               || AFC.get_field_condition( ' and ( function_owner ', p_function_owner , ' )', p_QBE, null )
               || AFC.get_field_condition( ' and ( firing_function ', p_firing_function , ' )', p_QBE, null )
               || AFC.get_field_condition( ' and ( firing_event ', p_firing_event , ' )', p_QBE, null )
               || ' ) ' || p_other_condition
               ;
   return d_statement;
end where_condition; --- external_functions_tpk.where_condition
--------------------------------------------------------------------------------
function get_rows
( p_QBE  in number default 0
, p_other_condition in varchar2 default null
, p_order_by in varchar2 default null
, p_extra_columns in varchar2 default null
, p_extra_condition in varchar2 default null
, p_function_id  in varchar2 default null
, p_table_name  in varchar2 default null
, p_function_owner  in varchar2 default null
, p_firing_function  in varchar2 default null
, p_firing_event  in varchar2 default null
) return AFC.t_ref_cursor is /* SLAVE_COPY */
/******************************************************************************
 NOME:        get_rows
 DESCRIZIONE: Ritorna il risultato di una query in base ai valori che passiamo.
 PARAMETRI:   p_QBE 0: se l'operatore da utilizzare nella where-condition è
                       quello di default ('=')
                    1: se l'operatore da utilizzare nella where-condition è
                       quello specificato per ogni attributo.
              p_other_condition: condizioni aggiuntive di base
              p_order_by: condizioni di ordinamento
              p_extra_columns: colonne aggiungere alla select
              p_extra_condition: condizioni aggiuntive
              Chiavi e attributi della table
 RITORNA:     Un ref_cursor che punta al risultato della query.
 NOTE:        Se p_QBE = 1 , ogni parametro deve contenere, nella prima parte,
              l'operatore da utilizzare nella where-condition.
              In p_extra_columns e p_order_by non devono essere passati anche la
              virgola iniziale (per p_extra_columns) e la stringa 'order by' (per
              p_order_by)
******************************************************************************/
   d_statement       AFC.t_statement;
   d_ref_cursor      AFC.t_ref_cursor;
begin
   d_statement := ' select EXTERNAL_FUNCTIONS.* '
               || afc.decode_value( p_extra_columns, null, null, ' , ' || p_extra_columns )
               || ' from EXTERNAL_FUNCTIONS '
               || where_condition(
                                   p_QBE => p_QBE
                                 , p_other_condition => p_other_condition
                                 , p_function_id => p_function_id
                                 , p_table_name => p_table_name
                                 , p_function_owner => p_function_owner
                                 , p_firing_function => p_firing_function
                                 , p_firing_event => p_firing_event
                                 )
               || ' ' || p_extra_condition
               || afc.decode_value( p_order_by, null, null, ' order by ' || p_order_by )
               ;
   d_ref_cursor := AFC_DML.get_ref_cursor( d_statement );
   return d_ref_cursor;
end get_rows; -- external_functions_tpk.get_rows
--------------------------------------------------------------------------------
function count_rows
( p_QBE  in number default 0
, p_other_condition in varchar2 default null
, p_function_id  in varchar2 default null
, p_table_name  in varchar2 default null
, p_function_owner  in varchar2 default null
, p_firing_function  in varchar2 default null
, p_firing_event  in varchar2 default null
) return integer is /* SLAVE_COPY */
/******************************************************************************
 NOME:        count_rows
 DESCRIZIONE: Ritorna il numero di righe della tabella gli attributi delle quali
              rispettano i valori indicati.
 PARAMETRI:   p_other_condition
              p_QBE 0: se l'operatore da utilizzare nella where-condition è
                       quello di default ('=')
                    1: se l'operatore da utilizzare nella where-condition è
                       quello specificato per ogni attributo.
              Chiavi e attributi della table
 RITORNA:     Numero di righe che rispettano la selezione indicata.
******************************************************************************/
   d_result          integer;
   d_statement       AFC.t_statement;
begin
   d_statement := ' select count( * ) from EXTERNAL_FUNCTIONS '
               || where_condition(
                                   p_QBE => p_QBE
                                 , p_other_condition => p_other_condition
                                 , p_function_id => p_function_id
                                 , p_table_name => p_table_name
                                 , p_function_owner => p_function_owner
                                 , p_firing_function => p_firing_function
                                 , p_firing_event => p_firing_event
                                 );
   d_result := AFC.SQL_execute( d_statement );
   return d_result;
end count_rows; -- external_functions_tpk.count_rows
--------------------------------------------------------------------------------
end external_functions_tpk;
/

