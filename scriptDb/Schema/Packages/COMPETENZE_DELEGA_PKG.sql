CREATE OR REPLACE package competenze_delega_pkg is
   /******************************************************************************
    NOME:        competenze_delega_pkg
    DESCRIZIONE: Gestione tabella competenze_delega.
    ANNOTAZIONI: .
    REVISIONI:
    <CODE>
    Rev.  Data        Autore      Descrizione.
    00    23/11/2017  MMonari  Generazione automatica
    </CODE>
   ******************************************************************************/
   -- Revisione del Package
   s_revisione  constant afc.t_revision := 'V1.00';
   s_table_name constant afc.t_object_name := 'competenze_delega';
   -- Exceptions
   errore_chiusura_deleghe exception;
   pragma exception_init(errore_chiusura_deleghe, -20901);
   s_chiusura_deleghe_num constant afc_error.t_error_number := -20901;
   s_chiusura_deleghe_msg constant afc_error.t_error_msg := 'Errore duranta la chiusura delle deleghe relative alla competenza terminata';

   function versione return varchar2;

   pragma restrict_references(versione, wnds);

   -- Messaggio previsto per il numero di eccezione indicato
   function error_message(p_error_number in afc_error.t_error_number)
      return afc_error.t_error_msg;

   pragma restrict_references(error_message, wnds);

   procedure termina_deleghe /* chiude le deleghe riferite ad una particolare competenza quando questa termina la propria validita'*/
   (
      p_id_competenza_delega in competenze_delega.id_competenza_delega%type
     ,p_fine_validita        in competenze_delega.fine_validita%type
     ,p_fine_validita_prec   in competenze_delega.fine_validita%type
   );

   procedure set_fi
   (
      p_codice               in competenze_delega.codice%type
     ,p_fine_validita        in competenze_delega.fine_validita%type
     ,p_fine_validita_prec   in competenze_delega.fine_validita%type
     ,p_id_competenza_delega in competenze_delega.id_competenza_delega%type
     ,p_inserting            in number
     ,p_updating             in number
     ,p_deleting             in number
   );
  
end competenze_delega_pkg;
/

