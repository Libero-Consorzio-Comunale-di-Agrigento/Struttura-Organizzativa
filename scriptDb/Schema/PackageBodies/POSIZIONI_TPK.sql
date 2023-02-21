CREATE OR REPLACE package body posizioni_tpk is

   s_revisione_body      constant AFC.t_revision := '004 - 20/05/2010';

function versione
return varchar2 is 

begin
   return AFC.version ( s_revisione, s_revisione_body );
end versione; 

function get_descrizione
(
  p_codice  in varchar2
) return varchar2 is 

   d_result varchar2(100);
begin
   return  d_result;
end get_descrizione; 

function get_descrizione_al1
(
  p_codice  in varchar2
) return varchar2 is 

   d_result varchar2(100);
begin
   return  d_result;
end get_descrizione_al1; 

function get_descrizione_al2
(
  p_codice  in varchar2
) return varchar2 is 

   d_result varchar2(100);
begin
   return  d_result;
end get_descrizione_al2; 

function get_sequenza
(
  p_codice  in varchar2
) return number is 

   d_result number;
begin
   return  d_result;
end get_sequenza; 

function get_posizione
(
  p_codice  in varchar2
) return varchar2 is 

   d_result varchar2(100);
begin
   return  d_result;
end get_posizione; 

function get_ruolo
(
  p_codice  in varchar2
) return varchar2 is 

   d_result varchar2(100);
begin
   return  d_result;
end get_ruolo; 

function get_stagionale
(
  p_codice  in varchar2
) return varchar2 is 

   d_result varchar2(100);
begin
   return  d_result;
end get_stagionale; 

function get_contratto_formazione
(
  p_codice  in varchar2
) return varchar2 is 

   d_result varchar2(100);
begin
   return  d_result;
end get_contratto_formazione; 

function get_tempo_determinato
(
  p_codice  in varchar2
) return VARCHAR2 is 

   d_result varchar2(100);
begin
   return  d_result;
end get_tempo_determinato; 

function get_part_time
(
  p_codice  in varchar2
) return VARCHAR2 is 

   d_result varchar2(100);
begin
   return  d_result;
end get_part_time; 

function get_copertura_part_time
(
  p_codice  in varchar2
) return VARCHAR2 is 

   d_result varchar2(100);
begin
   return  d_result;
end get_copertura_part_time; 

function get_tipo_part_time
(
  p_codice  in varchar2
) return VARCHAR2 is 

   d_result varchar2(100);
begin
   return  d_result;
end get_tipo_part_time; 

function get_di_ruolo
(
  p_codice  in varchar2
) return VARCHAR2 is 

   d_result varchar2(100);
begin
   return  d_result;
end get_di_ruolo; 

function get_tipo_formazione
(
  p_codice  in varchar2
) return VARCHAR2 is 

   d_result varchar2(100);
begin
   return  d_result;
end get_tipo_formazione; 

function get_tipo_determinato
(
  p_codice  in varchar2
) return VARCHAR2 is 

   d_result varchar2(100);
begin
   return  d_result;
end get_tipo_determinato; 

function get_universitario
(
  p_codice  in varchar2
) return VARCHAR2 is 

   d_result varchar2(100);
begin
   return  d_result;
end get_universitario; 

function get_collaboratore
(
  p_codice  in varchar2
) return varchar2 is 

   d_result varchar2(100);
begin
   return  d_result;
end get_collaboratore; 

function get_lsu
(
  p_codice  in varchar2
) return varchar2 is 

   d_result varchar2(100);
begin
   return  d_result;
end get_lsu; 

function get_ruolo_do
(
  p_codice  in varchar2
) return varchar2 is 

   d_result varchar2(100);
begin
   return  d_result;
end get_ruolo_do; 

function get_contratto_opera
(
  p_codice  in varchar2
) return varchar2 is 

   d_result varchar2(100);
begin
   return  d_result;
end get_contratto_opera; 

function get_sovrannumero
(
  p_codice  in varchar2
) return varchar2 is 

   d_result varchar2(100);
begin
   return  d_result;
end get_sovrannumero; 

function get_amm_cons
(
  p_codice  in varchar2
) return varchar2 is 

   d_result varchar2(100);
begin
   return  d_result;
end get_amm_cons; 

function get_tipologia_contrattuale
(
  p_codice  in varchar2
) return varchar2 is 

   d_result varchar2(100);
begin
   return  d_result;
end get_tipologia_contrattuale; 

function get_vortale
(
  p_codice  in varchar2
) return varchar2 is 

   d_result varchar2(100);
begin
   return  d_result;
end get_vortale; 

function get_interinale
(
  p_codice  in varchar2
) return varchar2 is 

   d_result varchar2(100);
begin
   return  d_result;
end get_interinale; 

end posizioni_tpk;
/

