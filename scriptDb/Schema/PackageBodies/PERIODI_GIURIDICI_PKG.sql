CREATE OR REPLACE package body periodi_giuridici_pkg is

   s_revisione_body      constant AFC.t_revision := '000 - 12/10/2012';
   s_error_table AFC_Error.t_error_table;
   s_error_detail AFC_Error.t_error_table;
   s_warning afc.t_statement;
   s_information afc.t_statement;

function versione
return varchar2 is

begin
   return AFC.version ( s_revisione, s_revisione_body );
end versione; 

function get_tipo_part_time_between
( p_ci in number
, p_rilevanza in varchar2
, p_data in date
) return varchar2
is
    d_result    varchar2(1);
begin
    return d_result;
end;
function get_ore_between
( p_ci in number
, p_rilevanza in varchar2
, p_data in date
) return number
is
    d_result    number;
begin
    return d_result;
end;
function get_sede_between
( p_ci in number
, p_rilevanza in varchar2
, p_data in date
) return number
is
    d_result    number;
begin
    return d_result;
end;
function get_qualifica_between
( p_ci in number
, p_rilevanza in varchar2
, p_data in date
) return number
is
    d_result    number;
begin
    return d_result;
end;
function get_dal_between
( p_ci in number
, p_rilevanza in varchar2
, p_data in date
) return date
is
    d_result    date;
begin
    return d_result;
end;
function get_al_between
( p_ci in number
, p_rilevanza in varchar2
, p_data in date
) return date
is
    d_result    date;
begin
    return d_result;
end;
function get_figura_between
( p_ci in number
, p_rilevanza in varchar2
, p_data in date
) return number
is
    d_result    number;
begin
    return d_result;
end;
function get_settore_between
( p_ci in number
, p_rilevanza in varchar2
, p_data in date
) return number
is
    d_result    number;
begin
    return d_result;
end;
function get_posizione_between
( p_ci in number
, p_rilevanza in varchar2
, p_data in date
) return varchar2
is
    d_result    varchar2(1);
begin
    return d_result;
end;
function get_gestione_between
( p_ci in number
, p_rilevanza in varchar2
, p_data in date
) return varchar2
is
    d_result    varchar2(1);
begin
    return d_result;
end;
function get_attivita_between
( p_ci in number
, p_rilevanza in varchar2
, p_data in date
) return varchar2
is
    d_result    varchar2(1);
begin
    return d_result;
end;
function get_assenza_between
( p_ci in number
, p_data in date
) return varchar2
is
    d_result    varchar2(1);
begin
    return d_result;
end;
function get_incarico_between
( p_ci in number
, p_data in date
) return varchar2
is
    d_result    varchar2(1);
begin
    return d_result;
end;
function get_tipo_rapporto_between
( p_ci in number
, p_rilevanza in varchar2
, p_data in date
) return varchar2
is
    d_result    varchar2(1);
begin
    return d_result;
end;
function get_utente_between
( p_ci in number
, p_rilevanza in varchar2
, p_data in date
) return varchar2
is
    d_result    varchar2(1);
begin
    return d_result;
end;
end periodi_giuridici_pkg;
/

