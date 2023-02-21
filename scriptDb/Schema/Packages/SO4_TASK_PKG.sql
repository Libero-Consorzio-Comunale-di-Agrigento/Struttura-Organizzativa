CREATE OR REPLACE package so4_task_pkg is
   /******************************************************************************
   NOME:        so4_task_pkg
   DESCRIZIONE: Procedure e Funzioni di utilita' per la gestione dei tasks di so4
   ANNOTAZIONI: .
   REVISIONI: .
   Rev.  Data        Autore  Descrizione.
   00    08/07/2015  MM      Prima emissione.
   
   ******************************************************************************/
   s_revisione constant varchar2(30) := 'V1.00';
   type t_periodo is record(
       dal date
      ,al  date);
   v_testo varchar2(32000);
   --
   function versione return varchar2;
   pragma restrict_references(versione, wnds, wnps);
   function get_task_id return task_funzioni.id_task%type;
   function get_tipo_parametro(p_id_parametro in parametri_funzione.id_parametro_funzione%type)
      return parametri_funzione.tipo%type;
   function is_valore_ok
   (
      p_id_parametro in parametri_funzione.id_parametro_funzione%type
     ,p_valore       in parametri_funzione.valore_default%type
   ) return number;
   procedure esegui_task(p_id_task in task_funzioni.id_task%type);
end so4_task_pkg;
/

