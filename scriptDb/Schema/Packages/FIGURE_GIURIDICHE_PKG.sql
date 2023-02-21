CREATE OR REPLACE package figure_giuridiche_pkg is
/******************************************************************************
 NOME:        figure_giuridiche_pkg
 DESCRIZIONE: Gestione tabella figure_giuridiche.
 ANNOTAZIONI: .
 REVISIONI:   Template Revision: 1.1.
 <CODE>
 Rev.  Data          Autore  Descrizione.
 00    12/10/2012    AD      Versione fake del package in caso di mancata integrazione
                             con GP4/GPS
******************************************************************************/
   -- Revisione del Package
   s_revisione constant AFC.t_revision := 'V1.00';
   function get_qualifica_between
   ( p_numero in number
   , p_data in date
   ) return number;
   function get_profilo_between
   ( p_numero in number
   , p_data in date
   ) return varchar2;
   function get_posizione_between
   ( p_numero in number
   , p_data in date
   ) return varchar2;
   function get_codice_between
   ( p_numero in number
   , p_data in date
   ) return varchar2;
   function get_descrizione_between
   ( p_numero in number
   , p_data in date
   ) return varchar2;
end figure_giuridiche_pkg;
/

