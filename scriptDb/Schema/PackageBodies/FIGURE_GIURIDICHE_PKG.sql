CREATE OR REPLACE package body figure_giuridiche_pkg is

   s_revisione_body      constant AFC.t_revision := '000 - 12/10/2012';
   s_error_table AFC_Error.t_error_table;
   s_error_detail AFC_Error.t_error_table;
   s_warning afc.t_statement;

function versione
return varchar2 is

begin
   return AFC.version ( s_revisione, s_revisione_body );
end versione; 

function get_qualifica_between
( p_numero in number
, p_data in date
) return number
is
    d_result number;
begin
    return d_result;
end;
function get_profilo_between
( p_numero in number
, p_data in date
) return varchar2
is
    d_result  varchar2(1);
begin
    return d_result;
end;
function get_posizione_between
( p_numero in number
, p_data in date
) return varchar2
is
    d_result  varchar2(1);
begin
    return d_result;
end;
function get_codice_between
( p_numero in number
, p_data in date
) return varchar2
is
    d_result  varchar2(1);
begin
    return d_result;
end;
function get_descrizione_between
( p_numero in number
, p_data in date
) return varchar2
is
    d_result varchar2(1);
begin
    return d_result;
end;
end figure_giuridiche_pkg;
/

