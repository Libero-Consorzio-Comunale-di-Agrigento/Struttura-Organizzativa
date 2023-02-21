CREATE OR REPLACE package periodi_giuridici_pkg is
/******************************************************************************
 NOME:        periodi_giuridici_pkg
 DESCRIZIONE: Gestione tabella periodi_giuridici.
 ANNOTAZIONI: .
 REVISIONI:   Template Revision: 1.1.
 <CODE>
 Rev.  Data        Autore  Descrizione.
 00    12/10/2012  ADADAMO Versione fake del pkg in caso di mancata integrazione
                           con GP4/GPS
******************************************************************************/
   -- Revisione del Package
   s_revisione constant AFC.t_revision := 'V1.00';
   s_table_name constant AFC.t_object_name := 'periodi_giuridici';
    -- Versione e revisione
   function versione
   return varchar2;
   pragma restrict_references( versione, WNDS );
   function get_tipo_part_time_between
   ( p_ci in number
   , p_rilevanza in varchar2
   , p_data in date
   ) return varchar2;
   function get_ore_between
   ( p_ci in number
   , p_rilevanza in varchar2
   , p_data in date
   ) return number;
   function get_sede_between
   ( p_ci in number
   , p_rilevanza in varchar2
   , p_data in date
   ) return number;
   function get_qualifica_between
   ( p_ci in number
   , p_rilevanza in varchar2
   , p_data in date
   ) return number;
   function get_dal_between
   ( p_ci in number
   , p_rilevanza in varchar2
   , p_data in date
   ) return date;
   function get_al_between
   ( p_ci in number
   , p_rilevanza in varchar2
   , p_data in date
   ) return date;
   function get_figura_between
   ( p_ci in number
   , p_rilevanza in varchar2
   , p_data in date
   ) return number;
   function get_settore_between
   ( p_ci in number
   , p_rilevanza in varchar2
   , p_data in date
   ) return number;
   function get_posizione_between
   ( p_ci in number
   , p_rilevanza in varchar2
   , p_data in date
   ) return varchar2;
   function get_gestione_between
   ( p_ci in number
   , p_rilevanza in varchar2
   , p_data in date
   ) return varchar2;
   function get_attivita_between
   ( p_ci in number
   , p_rilevanza in varchar2
   , p_data in date
   ) return varchar2;
   function get_assenza_between
   ( p_ci in number
   , p_data in date
   ) return varchar2;
   function get_incarico_between
   ( p_ci in number
   , p_data in date
   ) return varchar2;
   function get_tipo_rapporto_between
   ( p_ci in number
   , p_rilevanza in varchar2
   , p_data in date
   ) return varchar2;
   function get_utente_between
   ( p_ci in number
   , p_rilevanza in varchar2
   , p_data in date
   ) return varchar2;
end periodi_giuridici_pkg;
/

