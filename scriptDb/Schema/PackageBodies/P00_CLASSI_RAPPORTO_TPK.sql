CREATE OR REPLACE package body p00_classi_rapporto_tpk is

   s_revisione_body      constant AFC.t_revision := '000 - 13/01/2012';

function versione
return varchar2 is 

begin
   return AFC.version ( s_revisione, s_revisione_body );
end versione; 

function get_componente
(
  p_codice  in varchar2
) return varchar2 is 

   d_result varchar2(2);
begin
   d_result := 'NO';
   return  d_result;
end get_componente; 

end p00_classi_rapporto_tpk;
/

