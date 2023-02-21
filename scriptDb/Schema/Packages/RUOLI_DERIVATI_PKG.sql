CREATE OR REPLACE package ruoli_derivati_pkg is
   /******************************************************************************
    NOME:        ruoli_derivati_pkg
    DESCRIZIONE: Gestione tabella RUOLI_DERIVATI.
    ANNOTAZIONI: .
    REVISIONI:
    <CODE>
    Rev.  Data        Autore      Descrizione.
    00    27/08/2014  mmonari  Generazione automatica Feature #430
    01    07/08/2016  mmonari  Nuova funzione is_origine_automatica #634
    02    27/02/2017  mmonari  Nuova funzione esiste_relazione #762
    </CODE>
   ******************************************************************************/
   -- Revisione del Package
   s_revisione  constant afc.t_revision := 'V1.02';
   s_table_name constant afc.t_object_name := 'RUOLI_DERIVATI';
   -- Exceptions
   /*   < exception_name > exception;
      pragma exception_init(< exception_name >, < error_code >);
      s_ < exception_name > _num constant afc_error.t_error_number := < error_code >;
      s_ < exception_name > _msg constant afc_error.t_error_msg := < error_message >;
   */ -- Versione e revisione
   function versione return varchar2;
   pragma restrict_references(versione, wnds);
   -- Messaggio previsto per il numero di eccezione indicato
   function error_message(p_error_number in afc_error.t_error_number)
      return afc_error.t_error_msg;
   pragma restrict_references(error_message, wnds);
   function is_origine_profilo(p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type)
      return boolean;
   function is_origine_automatica(p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type)
      return boolean;
   function esiste_relazione --#762
   (
      p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type
     ,p_id_profilo          ruoli_derivati.id_profilo%type
   ) return boolean;
   function get_origine(p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type)
      return varchar2;
end ruoli_derivati_pkg;
/

