CREATE OR REPLACE package body P00_DIPENDENTI_SOGGETTI_tpk is

   s_revisione_body      constant AFC.t_revision := '000 - 30/10/2012';

function versione
return varchar2 is 

begin
   return AFC.version ( s_revisione, s_revisione_body );
end versione; 

function PK
(
 p_ni_gp4  in P00_DIPENDENTI_SOGGETTI.ni_gp4%type
) return t_PK is 

   d_result t_PK;
begin
   d_result.ni_gp4 := p_ni_gp4;
   DbC.PRE ( not DbC.PreOn or canHandle (
                                          p_ni_gp4 => d_result.ni_gp4
                                        )
           , 'canHandle on P00_DIPENDENTI_SOGGETTI_tpk.PK'
           );
   return  d_result;
end PK; 

function can_handle
(
 p_ni_gp4  in P00_DIPENDENTI_SOGGETTI.ni_gp4%type
) return number is 

   d_result number;
begin
   d_result := 1;
   
   if  d_result = 1
   and (
          p_ni_gp4 is null
       )
   then
      d_result := 0;
   end if;
   DbC.POST ( d_result = 1  or  d_result = 0
            , 'd_result = 1  or  d_result = 0 on P00_DIPENDENTI_SOGGETTI_tpk.can_handle'
            );
   return  d_result;
end can_handle; 

function canHandle
(
 p_ni_gp4  in P00_DIPENDENTI_SOGGETTI.ni_gp4%type
) return boolean is 

   d_result constant boolean := AFC.to_boolean ( can_handle (
                                                              p_ni_gp4 => p_ni_gp4
                                                            )
                                               );
begin
   return  d_result;
end canHandle; 

function exists_id
(
 p_ni_gp4  in P00_DIPENDENTI_SOGGETTI.ni_gp4%type
) return number is 

   d_result number;
begin
   DbC.PRE ( not DbC.PreOn or canHandle (
                                         p_ni_gp4 => p_ni_gp4
                                        )
           , 'canHandle on P00_DIPENDENTI_SOGGETTI_tpk.exists_id'
           );
   begin
      select 1
      into   d_result
      from   P00_DIPENDENTI_SOGGETTI
      where
      ni_gp4 = p_ni_gp4
      ;
   exception
      when no_data_found then
         d_result := 0;
   end;
   DbC.POST ( d_result = 1  or  d_result = 0
            , 'd_result = 1  or  d_result = 0 on P00_DIPENDENTI_SOGGETTI_tpk.exists_id'
            );
   return  d_result;
end exists_id; 

function existsId
(
 p_ni_gp4  in P00_DIPENDENTI_SOGGETTI.ni_gp4%type
) return boolean is 

   d_result constant boolean := AFC.to_boolean ( exists_id (
                                                            p_ni_gp4 => p_ni_gp4
                                                           )
                                               );
begin
   return  d_result;
end existsId; 

procedure ins
(
  p_ni_gp4  in P00_DIPENDENTI_SOGGETTI.ni_gp4%type default null
, p_ni_as4  in P00_DIPENDENTI_SOGGETTI.ni_as4%type
) is

begin
   
   DbC.PRE ( not DbC.PreOn or p_ni_as4 is not null or  '' is not null
           , 'p_ni_as4 on P00_DIPENDENTI_SOGGETTI_tpk.ins'
           );
   DbC.PRE (  not DbC.PreOn
           or (   p_ni_gp4 is null and  'default null' is not null ) 
           or not existsId (
                             p_ni_gp4 => p_ni_gp4
                           )
           , 'not existsId on P00_DIPENDENTI_SOGGETTI_tpk.ins'
           );
   insert into P00_DIPENDENTI_SOGGETTI
   (
     ni_gp4
   , ni_as4
   )
   values
   (
     p_ni_gp4
, p_ni_as4
   );
end ins; 

function ins
(
  p_ni_gp4  in P00_DIPENDENTI_SOGGETTI.ni_gp4%type default null
, p_ni_as4  in P00_DIPENDENTI_SOGGETTI.ni_as4%type
) return number

is
   d_result number;
begin
   
   DbC.PRE ( not DbC.PreOn or p_ni_as4 is not null or  '' is not null
           , 'p_ni_as4 on P00_DIPENDENTI_SOGGETTI_tpk.ins'
           );
   DbC.PRE (  not DbC.PreOn
           or (   p_ni_gp4 is null and  'default null' is not null ) 
           or not existsId (
                             p_ni_gp4 => p_ni_gp4
                           )
           , 'not existsId on P00_DIPENDENTI_SOGGETTI_tpk.ins'
           );
   insert into P00_DIPENDENTI_SOGGETTI
   (
     ni_gp4
   , ni_as4
   )
   values
   (
     p_ni_gp4
, p_ni_as4
   ) returning ni_gp4
   into d_result;
   return d_result;
end ins; 

procedure upd
(
  p_check_OLD  in integer default 0
, p_NEW_ni_gp4  in P00_DIPENDENTI_SOGGETTI.ni_gp4%type
, p_OLD_ni_gp4  in P00_DIPENDENTI_SOGGETTI.ni_gp4%type default null
, p_NEW_ni_as4  in P00_DIPENDENTI_SOGGETTI.ni_as4%type default afc.default_null('P00_DIPENDENTI_SOGGETTI.ni_as4')
, p_OLD_ni_as4  in P00_DIPENDENTI_SOGGETTI.ni_as4%type default null
) is

   d_key t_PK;
   d_row_found number;
begin
   DbC.PRE (  not DbC.PreOn
           or not ( (
p_OLD_ni_as4 is not null
                    )
                    and (  nvl( p_check_OLD, -1 ) = 0
                        )
                  )
           , ' "OLD values" is not null on P00_DIPENDENTI_SOGGETTI_tpk.upd'
           );
   d_key := PK (
                nvl( p_OLD_ni_gp4, p_NEW_ni_gp4 )
               );
   DbC.PRE ( not DbC.PreOn or existsId (
                                         p_ni_gp4 => d_key.ni_gp4
                                       )
           , 'existsId on P00_DIPENDENTI_SOGGETTI_tpk.upd'
           );
   update P00_DIPENDENTI_SOGGETTI
   set
       ni_gp4 = NVL( p_NEW_ni_gp4, DECODE( AFC.IS_DEFAULT_NULL( 'P00_DIPENDENTI_SOGGETTI.ni_gp4' ), 1, ni_gp4,
                 DECODE( p_CHECK_OLD, 0, null, DECODE( p_OLD_ni_gp4, null, ni_gp4, null ) ) ) )
     , ni_as4 = NVL( p_NEW_ni_as4, DECODE( AFC.IS_DEFAULT_NULL( 'P00_DIPENDENTI_SOGGETTI.ni_as4' ), 1, ni_as4,
                 DECODE( p_CHECK_OLD, 0, null, DECODE( p_OLD_ni_as4, null, ni_as4, null ) ) ) )
   where
     ni_gp4 = d_key.ni_gp4
   and (   p_check_OLD = 0
        or (   1 = 1
           and ( ni_as4 = p_OLD_ni_as4 or ( p_OLD_ni_as4 is null and ( p_check_OLD is null or ni_as4 is null ) ) )
           )
       )
   ;
   d_row_found := SQL%ROWCOUNT;
   afc.default_null(NULL);
   DbC.ASSERTION ( not DbC.AssertionOn or d_row_found <= 1
                 , 'd_row_found <= 1 on P00_DIPENDENTI_SOGGETTI_tpk.upd'
                 );
   if d_row_found < 1
   then
      raise_application_error ( AFC_ERROR.modified_by_other_user_number
                              , AFC_ERROR.modified_by_other_user_msg
                              );
   end if;
end upd; 

procedure upd_column
(
  p_ni_gp4  in P00_DIPENDENTI_SOGGETTI.ni_gp4%type
, p_column         in varchar2
, p_value          in varchar2 default null
, p_literal_value  in number   default 1
) is

   d_statement AFC.t_statement;
   d_literal   varchar2(2);
begin
   DbC.PRE ( not DbC.PreOn or existsId (
                                        p_ni_gp4 => p_ni_gp4
                                       )
           , 'existsId on P00_DIPENDENTI_SOGGETTI_tpk.upd_column'
           );
   DbC.PRE ( not DbC.PreOn or p_column is not null
           , 'p_column is not null on P00_DIPENDENTI_SOGGETTI_tpk.upd_column'
           );
   DbC.PRE ( not DbC.PreOn or AFC_DDL.HasAttribute( s_table_name, p_column )
           , 'AFC_DDL.HasAttribute on P00_DIPENDENTI_SOGGETTI_tpk.upd_column'
           );
   DbC.PRE ( p_literal_value in ( 0, 1 ) or p_literal_value is null
           , 'p_literal_value on P00_DIPENDENTI_SOGGETTI_tpk.upd_column; p_literal_value = ' || p_literal_value
           );
   if p_literal_value = 1
   or p_literal_value is null
   then
      d_literal := '''';
   end if;
   d_statement := ' declare '
               || '    d_row_found number; '
               || ' begin '
               || '    update P00_DIPENDENTI_SOGGETTI '
               || '       set ' || p_column || ' = ' || d_literal || p_value || d_literal
               || '     where 1 = 1 '
               || nvl( AFC.get_field_condition( ' and ( ni_gp4 ', p_ni_gp4, ' )', 0, null ), ' and ( ni_gp4 is null ) ' )
               || '    ; '
               || '    d_row_found := SQL%ROWCOUNT; '
               || '    if d_row_found < 1 '
               || '    then '
               || '       raise_application_error ( AFC_ERROR.modified_by_other_user_number, AFC_ERROR.modified_by_other_user_msg ); '
               || '    end if; '
               || ' end; ';
   AFC.SQL_execute( d_statement );
end upd_column; 

procedure del
(
  p_check_old  in integer default 0
, p_ni_gp4  in P00_DIPENDENTI_SOGGETTI.ni_gp4%type
, p_ni_as4  in P00_DIPENDENTI_SOGGETTI.ni_as4%type default null
) is

   d_row_found number;
begin
   DbC.PRE (  not DbC.PreOn
           or not ( (
p_ni_as4 is not null
                    )
                    and (  nvl( p_check_OLD, -1 ) = 0
                        )
                  )
           , ' "OLD values" is not null on P00_DIPENDENTI_SOGGETTI_tpk.del'
           );
   DbC.PRE ( not DbC.PreOn or existsId (
                                         p_ni_gp4 => p_ni_gp4
                                       )
           , 'existsId on P00_DIPENDENTI_SOGGETTI_tpk.del'
           );
   delete from P00_DIPENDENTI_SOGGETTI
   where
     ni_gp4 = p_ni_gp4
   and (   p_check_OLD = 0
        or (   1 = 1
           and ( ni_as4 = p_ni_as4 or ( p_ni_as4 is null and ( p_check_OLD is null or ni_as4 is null ) ) )
           )
       )
   ;
   d_row_found := SQL%ROWCOUNT;
   DbC.ASSERTION ( not DbC.AssertionOn or d_row_found <= 1
                 , 'd_row_found <= 1 on P00_DIPENDENTI_SOGGETTI_tpk.del'
                 );
   if d_row_found < 1
   then
      raise_application_error ( AFC_ERROR.modified_by_other_user_number
                              , AFC_ERROR.modified_by_other_user_msg
                              );
   end if;
   DbC.POST ( not DbC.PostOn or not existsId (
                                               p_ni_gp4 => p_ni_gp4
                                             )
            , 'existsId on P00_DIPENDENTI_SOGGETTI_tpk.del'
            );
end del; 

function get_ni_as4
(
  p_ni_gp4  in P00_DIPENDENTI_SOGGETTI.ni_gp4%type
) return P00_DIPENDENTI_SOGGETTI.ni_as4%type is 

   d_result P00_DIPENDENTI_SOGGETTI.ni_as4%type;
begin
   DbC.PRE ( not DbC.PreOn or  existsId (
                                          p_ni_gp4 => p_ni_gp4
                                        )
           , 'existsId on P00_DIPENDENTI_SOGGETTI_tpk.get_ni_as4'
           );
   select ni_as4
   into   d_result
   from   P00_DIPENDENTI_SOGGETTI
   where
   ni_gp4 = p_ni_gp4
   ;
  
  if (true)  
  then 
      DbC.POST ( not DbC.PostOn  or  d_result is not null
               , 'd_result is not null on P00_DIPENDENTI_SOGGETTI_tpk.get_ni_as4'
               );
   else 
      DbC.ASSERTION ( not DbC.AssertionOn  or  AFC_DDL.IsNullable ( s_table_name, 'ni_as4')
                    , ' AFC_DDL.IsNullable on P00_DIPENDENTI_SOGGETTI_tpk.get_ni_as4'
                    );
   end if;
   return  d_result;
end get_ni_as4; 

procedure set_ni_gp4
(
  p_ni_gp4  in P00_DIPENDENTI_SOGGETTI.ni_gp4%type
, p_value  in P00_DIPENDENTI_SOGGETTI.ni_gp4%type default null
) is

begin
   DbC.PRE ( not DbC.PreOn or  existsId (
                                          p_ni_gp4 => p_ni_gp4
                                        )
           , 'existsId on P00_DIPENDENTI_SOGGETTI_tpk.set_ni_gp4'
           );
   update P00_DIPENDENTI_SOGGETTI
   set ni_gp4 = p_value
   where
   ni_gp4 = p_ni_gp4
   ;
end set_ni_gp4; 

procedure set_ni_as4
(
  p_ni_gp4  in P00_DIPENDENTI_SOGGETTI.ni_gp4%type
, p_value  in P00_DIPENDENTI_SOGGETTI.ni_as4%type default null
) is

begin
   DbC.PRE ( not DbC.PreOn or  existsId (
                                          p_ni_gp4 => p_ni_gp4
                                        )
           , 'existsId on P00_DIPENDENTI_SOGGETTI_tpk.set_ni_as4'
           );
   update P00_DIPENDENTI_SOGGETTI
   set ni_as4 = p_value
   where
   ni_gp4 = p_ni_gp4
   ;
end set_ni_as4; 

function where_condition 
( p_QBE  in number default 0
, p_other_condition in varchar2 default null
, p_ni_gp4  in varchar2 default null
, p_ni_as4  in varchar2 default null
) return AFC.t_statement is 

   d_statement AFC.t_statement;
begin
   d_statement := ' where ( 1 = 1 '
               || AFC.get_field_condition( ' and ( ni_gp4 ', p_ni_gp4, ' )', p_QBE, null )
               || AFC.get_field_condition( ' and ( ni_as4 ', p_ni_as4 , ' )', p_QBE, null )
               || ' ) ' || p_other_condition
               ;
   return d_statement;
end where_condition; 

function get_rows
( p_QBE  in number default 0
, p_other_condition in varchar2 default null
, p_order_by in varchar2 default null
, p_extra_columns in varchar2 default null
, p_extra_condition in varchar2 default null
, p_ni_gp4  in varchar2 default null
, p_ni_as4  in varchar2 default null
) return AFC.t_ref_cursor is 

   d_statement       AFC.t_statement;
   d_ref_cursor      AFC.t_ref_cursor;
begin
   d_statement := ' select P00_DIPENDENTI_SOGGETTI.* '
               || afc.decode_value( p_extra_columns, null, null, ' , ' || p_extra_columns )
               || ' from P00_DIPENDENTI_SOGGETTI '
               || where_condition(
                                   p_QBE => p_QBE
                                 , p_other_condition => p_other_condition
                                 , p_ni_gp4 => p_ni_gp4
                                 , p_ni_as4 => p_ni_as4
                                 )
               || ' ' || p_extra_condition
               || afc.decode_value( p_order_by, null, null, ' order by ' || p_order_by )
               ;
   d_ref_cursor := AFC_DML.get_ref_cursor( d_statement );
   return d_ref_cursor;
end get_rows; 

function count_rows
( p_QBE  in number default 0
, p_other_condition in varchar2 default null
, p_ni_gp4  in varchar2 default null
, p_ni_as4  in varchar2 default null
) return integer is 

   d_result          integer;
   d_statement       AFC.t_statement;
begin
   d_statement := ' select count( * ) from P00_DIPENDENTI_SOGGETTI '
               || where_condition(
                                   p_QBE => p_QBE
                                 , p_other_condition => p_other_condition
                                 , p_ni_gp4 => p_ni_gp4
                                 , p_ni_as4 => p_ni_as4
                                 );
   d_result := AFC.SQL_execute( d_statement );
   return d_result;
end count_rows; 

end P00_DIPENDENTI_SOGGETTI_tpk;
/

