CREATE OR REPLACE package body tipi_rapporto_tpk is

   s_revisione_body      constant AFC.t_revision := '000 - 12/10/2012';

function versione
return varchar2 is 

begin
   return AFC.version ( s_revisione, s_revisione_body );
end versione; 

function get_sequenza
(
  p_codice  in varchar2
) return number is 

   d_result number;
begin
   return  d_result;
end get_sequenza; 

function get_descrizione
(
  p_codice  in varchar2
) return varchar2 is 

   d_result varchar2(1);
begin
   return  d_result;
end get_descrizione; 

function get_descrizione_al1
(
  p_codice  in varchar2
) return varchar2 is 

   d_result varchar2(1);
begin
   return  d_result;
end get_descrizione_al1; 

function get_descrizione_al2
(
  p_codice  in varchar2
) return varchar2 is 

   d_result varchar2(1);
begin
   return  d_result;
end get_descrizione_al2; 

function get_stampa_certificato
(
  p_codice  in varchar2
) return varchar2 is 

   d_result varchar2(1);
begin
   return  d_result;
end get_stampa_certificato; 

function get_note
(
  p_codice  in varchar2
) return varchar2 is 

   d_result varchar2(1);
begin
   return  d_result;
end get_note; 

function get_conto_annuale
(
  p_codice  in varchar2
) return number is 

   d_result number;
begin
   return  d_result;
end get_conto_annuale; 

function get_data_cessazione
(
  p_codice  in varchar2
) return date is 

   d_result date;
begin
   return  d_result;
end get_data_cessazione; 

end tipi_rapporto_tpk;
/

