CREATE OR REPLACE TRIGGER competenze_delega_tdb
/******************************************************************************
    NOME:        competenze_delega_tdb
    DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                          at DELETE on Table competenze_deleghe_1
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
                           Generato in automatico.
   ******************************************************************************/
   before delete on competenze_delega
   for each row
declare
   integrity_error exception;
   errno  integer;
   errmsg char(200);
   dummy  integer;
   found  boolean;

   --  Declaration of DeleteParentRestrict constraint for "DELEGHE"
   cursor cfk1_deleghe(var_competenza number) is
      select 1
        from deleghe
       where id_competenza_delega = var_competenza
         and var_competenza is not null;
begin
   begin
      -- Check REFERENTIAL Integrity
      open cfk1_deleghe(:old.id_competenza_delega);
   
      fetch cfk1_deleghe
         into dummy;
   
      found := cfk1_deleghe%found; /* %FOUND */
   
      close cfk1_deleghe;
   
      if found then
         errno  := -20006;
         errmsg := 'Esistono riferimenti su Deleghe. La registrazione di Competenze Delega non e'' eliminabile.';
         raise integrity_error;
      end if;
   
      null;
   end;
exception
   when integrity_error then
      integritypackage.initnestlevel;
      raise_application_error(errno, errmsg);
   when others then
      integritypackage.initnestlevel;
      raise;
end;
/


