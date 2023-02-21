CREATE OR REPLACE procedure ASSEGNAZIONI_FISICHE_PD
/******************************************************************************
 NOME:        ASSEGNAZIONI_FISICHE_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table ASSEGNAZIONI_FISICHE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger ASSEGNAZIONI_FISICHE_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_id_asfi IN number
, old_id_ubicazione_componente IN number
, old_ni IN number
, old_progr_unita_fisica IN number
, old_progr_unita_organizzativa IN number )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "ATTRIBUTI_ASSEGNAZIONE_FISICA"
   cursor cfk1_attributi_assegnazione_f(var_id_asfi number) is
      select 1
        from ATTRIBUTI_ASSEGNAZIONE_FISICA
       where ID_ASFI = var_id_asfi
         and var_id_asfi is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "ASSEGNAZIONI_FISICHE" if children still exist in "ATTRIBUTI_ASSEGNAZIONE_FISICA"
      open  cfk1_attributi_assegnazione_f(OLD_ID_ASFI);
      fetch cfk1_attributi_assegnazione_f into dummy;
      found := cfk1_attributi_assegnazione_f%FOUND; /* %FOUND */
      close cfk1_attributi_assegnazione_f;
      if found
      then
         errno  := -20006;
         errmsg := 'Esistono riferimenti su Attributi assegnazione fisica. La registrazione di Assegnazioni fisiche non e'' eliminabile. (ATTRIBUTI_ASSEGNAZIONE_FISICA.ATAF_ASFI_FK)';
         raise integrity_error;
      end if;
      null;
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/

