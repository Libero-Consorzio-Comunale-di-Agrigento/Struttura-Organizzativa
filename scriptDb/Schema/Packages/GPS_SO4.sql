CREATE OR REPLACE package gps_so4 is
   /******************************************************************************
    NOME:        GPS_SO4
    DESCRIZIONE:
    package fake che viene sostituito in integrazione con gps
   ******************************************************************************/
   function versione return varchar2;
   function get_numero_ci(p_ni in number) return number;
   function get_dati_per_ruolo
   (
      p_ci              in number
     ,p_amministrazione in varchar2
     ,p_data            in date
   ) return afc.t_ref_cursor;
   function valore_gradazione
   (  p_data          date
     ,p_tipo_rapporto varchar2
     ,p_amministrazione in varchar2
   ) return number;
end;
/

