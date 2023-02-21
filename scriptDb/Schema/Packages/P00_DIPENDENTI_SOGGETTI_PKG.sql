CREATE OR REPLACE package p00_dipendenti_soggetti_pkg is
   /******************************************************************************
    NOME:        p00_dipendenti_soggetti_pkg
    DESCRIZIONE: Gestione tabella P00_p00_dipendenti_soggetti.
    ANNOTAZIONI: Versione sostitutiva da installare in assenza di integrazione
                 con applicativi GP4 - GPs
    REVISIONI:
    <CODE>
    Rev.  Data        Autore      Descrizione.
    00    13/01/2012  VDavalli    Generazione automatica
    </CODE>
   ******************************************************************************/
   -- Revisione del Package
   s_revisione  constant afc.t_revision := 'V1.00';
   s_table_name constant afc.t_object_name := 'P00_p00_dipendenti_soggetti';
   -- Versione e revisione
   function versione return varchar2;
   pragma restrict_references(versione, wnds);
   -- Messaggio previsto per il numero di eccezione indicato
   function error_message(p_error_number in afc_error.t_error_number)
      return afc_error.t_error_msg;
   pragma restrict_references(error_message, wnds);
   function get_ci
   (
      p_ni  in p00_dipendenti_soggetti.ni_gp4%type
     ,p_dal in date default null
   ) return varchar2;
   pragma restrict_references(get_ci, wnds);
   function get_ni_gp4(p_ni_as4 in p00_dipendenti_soggetti.ni_as4%type)
      return p00_dipendenti_soggetti.ni_gp4%type;
end p00_dipendenti_soggetti_pkg;
/

