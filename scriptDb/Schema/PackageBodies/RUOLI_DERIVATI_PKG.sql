CREATE OR REPLACE package body ruoli_derivati_pkg is
   /******************************************************************************
    NOME:        ruoli_derivati_pkg
    DESCRIZIONE: Gestione tabella RUOLI_DERIVATI.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore      Descrizione.
    000   27/08/2014  mmonari  Generazione automatica Feature #430
    001   07/08/2018  mmonari  Modifiche a is_origine_profilo #634
    002   27/02/2017  mmonari  Nuova funzione esiste_relazione #762
   ******************************************************************************/
   s_revisione_body constant afc.t_revision := '002 - 27/02/2017';
   s_error_table  afc_error.t_error_table;
   s_error_detail afc_error.t_error_table;
   --------------------------------------------------------------------------------
   function versione return varchar2 is
      /******************************************************************************
       NOME:        versione
       DESCRIZIONE: Versione e revisione di distribuzione del package.
       RITORNA:     varchar2 stringa contenente versione e revisione.
       NOTE:        Primo numero  : versione compatibilita del Package.
                    Secondo numero: revisione del Package specification.
                    Terzo numero  : revisione del Package body.
      ******************************************************************************/
   begin
      return afc.version(s_revisione, s_revisione_body);
   end versione; -- ruoli_derivati_pkg.versione
   --------------------------------------------------------------------------------
   function error_message(p_error_number in afc_error.t_error_number)
      return afc_error.t_error_msg is
      /******************************************************************************
       NOME:        error_message
       DESCRIZIONE: Messaggio previsto per il numero di eccezione indicato.
       NOTE:        Restituisce il messaggio abbinato al numero indicato nella tabella
                    s_error_table del Package. Se p_error_number non e presente nella
                    tabella s_error_table viene lanciata l'exception -20011 (vedi AFC_Error)
      ******************************************************************************/
      d_result afc_error.t_error_msg;
      d_detail afc_error.t_error_msg;
   begin
      if s_error_detail.exists(p_error_number) then
         d_detail := s_error_detail(p_error_number);
      end if;
      if s_error_table.exists(p_error_number) then
         d_result := s_error_table(p_error_number) || d_detail;
         s_error_detail(p_error_number) := '';
      else
         raise_application_error(afc_error.exception_not_in_table_number
                                ,afc_error.exception_not_in_table_msg);
      end if;
      return d_result;
   end error_message; -- ruoli_derivati_pkg.error_message

   --------------------------------------------------------------------------------

   function is_origine_profilo(p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type)
      return boolean is
      /******************************************************************************
       NOME:        is_origine_profilo
       DESCRIZIONE: verifica se l'id_ruolo_componente dato deriva da un profilo
       PARAMETRI:   p_id_ruolo_componente
      ******************************************************************************/
      d_result    boolean := false;
      d_contatore number(10) := 0;
   begin
   
      if p_id_ruolo_componente is not null then
         select count(*)
           into d_contatore
           from ruoli_derivati r
          where r.id_ruolo_componente = p_id_ruolo_componente
            and r.id_profilo is not null;
      
         if d_contatore > 0 then
            d_result := true;
         end if;
      end if;
   
      return d_result;
   
   end;

   --------------------------------------------------------------------------------

   function is_origine_automatica(p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type)
      return boolean is
      /******************************************************************************
       NOME:        is_origine_automatica
       DESCRIZIONE: verifica se l'id_ruolo_componente dato deriva da una regola di attribuzione automatica
       PARAMETRI:   p_id_ruolo_componente
      ******************************************************************************/
      d_result    boolean := false;
      d_contatore number(10) := 0;
   begin
   
      if p_id_ruolo_componente is not null then
         select count(*)
           into d_contatore
           from ruoli_derivati r
          where r.id_ruolo_componente = p_id_ruolo_componente
            and r.id_relazione is not null;
      
         if d_contatore > 0 then
            d_result := true;
         end if;
      end if;
   
      return d_result;
   
   end;

   --------------------------------------------------------------------------------

   function esiste_relazione
   (
      p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type
     ,p_id_profilo          ruoli_derivati.id_profilo%type
   ) return boolean is
      /******************************************************************************
       NOME:        esiste_relazione
       DESCRIZIONE: verifica se su RUOLI_DERIVATI esiste già la relazione ruolo-profilo
       PARAMETRI:   p_id_ruolo_componente, p_id_profilo
      ******************************************************************************/
      d_result    boolean := false;
      d_contatore number(10) := 0;
   begin
   
      if p_id_ruolo_componente is not null and p_id_profilo is not null then
         select count(*)
           into d_contatore
           from ruoli_derivati r
          where r.id_ruolo_componente = p_id_ruolo_componente
            and r.id_profilo = p_id_profilo;
      
         if d_contatore > 0 then
            d_result := true;
         end if;
      end if;
   
      return d_result;
   
   end;

   --------------------------------------------------------------------------------

   function get_origine(p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type)
      return varchar2 is
      /******************************************************************************
       NOME:        get_origine
       DESCRIZIONE: verifica l'origine del ruolo componente dato; valori possibili
                    P : ruolo derivante da profilo
                    A : ruolo automatico (da relazioni ruoli)
                    C : ruolo attribuito sia per profilo che per relazione
                    S : ruolo singolarmente attribuito al componente
       PARAMETRI:   p_id_ruolo_componente
      ******************************************************************************/
      d_result    varchar2(1) := 'S';
      d_profili   number(10) := 0;
      d_relazioni number(10) := 0;
   begin
   
      if p_id_ruolo_componente is not null then
         select count(distinct id_relazione)
               ,count(distinct id_profilo)
           into d_relazioni
               ,d_profili
           from ruoli_derivati
          where id_ruolo_componente = p_id_ruolo_componente;
         if d_profili > 0 and d_relazioni > 0 then
            d_result := 'C';
         elsif d_profili > 0 then
            d_result := 'P';
         elsif d_relazioni > 0 then
            d_result := 'A';
         end if;
      end if;
   
      return d_result;
   
   end;

--------------------------------------------------------------------------------
--begin
-- inserimento degli errori nella tabella
--s_error_table(s_ < exception_name > _num) := s_ < exception_name > _msg;
end ruoli_derivati_pkg;
/

