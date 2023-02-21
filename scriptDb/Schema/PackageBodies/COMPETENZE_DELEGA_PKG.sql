CREATE OR REPLACE package body competenze_delega_pkg is
   /******************************************************************************
    NOME:        competenze_delega_pkg
    DESCRIZIONE: Gestione tabella competenze_delega.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore      Descrizione.
    000   23/11/2017  MMonari  Generazione automatica
   ******************************************************************************/
   s_revisione_body constant afc.t_revision := '000 - 23/11/2017';
   --   /* SIAPKGen: generazione automatica */
   s_error_table  afc_error.t_error_table;
   s_error_detail afc_error.t_error_table;
   s_warning      afc.t_statement;

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
   end versione; -- competenze_delega_pkg.versione

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
   end error_message; -- competenze_delega_pkg.error_message

   --------------------------------------------------------------------------------
   procedure termina_deleghe /* chiude le deleghe riferite ad una particolare competenza quando questa termina la propria validita'*/
   (
      p_id_competenza_delega in competenze_delega.id_competenza_delega%type
     ,p_fine_validita        in competenze_delega.fine_validita%type
     ,p_fine_validita_prec   in competenze_delega.fine_validita%type
   ) is
   begin
      begin
         update deleghe d
            set al = p_fine_validita
          where d.id_competenza_delega = p_id_competenza_delega
            and nvl(al, to_date(3333333, 'j')) =
                nvl(p_fine_validita_prec, to_date(3333333, 'j'))
            and dal <= nvl(p_fine_validita, to_date(3333333, 'j'));
      end;
   end;

   --------------------------------------------------------------------------------
   procedure set_fi
   (
      p_codice               in competenze_delega.codice%type
     ,p_fine_validita        in competenze_delega.fine_validita%type
     ,p_fine_validita_prec   in competenze_delega.fine_validita%type
     ,p_id_competenza_delega in competenze_delega.id_competenza_delega%type
     ,p_inserting            in number
     ,p_updating             in number
     ,p_deleting             in number
   ) is
      /******************************************************************************
       NOME:        set_FI.
       DESCRIZIONE: Gestione della Functional Integrity.
       PARAMETRI:  p_<attributo>
                   , ...
       NOTE:        --
      ******************************************************************************/
   begin
      if p_updating = 1 and nvl(p_fine_validita, to_date(3333333, 'j')) <>
         nvl(p_fine_validita_prec, to_date(3333333, 'j')) then
         begin
            termina_deleghe(p_id_competenza_delega, p_fine_validita, p_fine_validita_prec);
         exception
            when others then
               raise_application_error(-20999
                                      ,'Errore in chiusura deleghe - ' || sqlerrm);
         end;
      end if;
   end set_fi; -- competenze_delega_pkg.set_FI

--------------------------------------------------------------------------------

begin
   -- inserimento degli errori nella tabella
   s_error_table(s_chiusura_deleghe_num) := s_chiusura_deleghe_msg;
end competenze_delega_pkg;
/

