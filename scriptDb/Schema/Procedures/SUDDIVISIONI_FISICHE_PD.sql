CREATE OR REPLACE procedure SUDDIVISIONI_FISICHE_PD
/******************************************************************************
 NOME:        SUDDIVISIONI_FISICHE_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table SUDDIVISIONI_FISICHE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger SUDDIVISIONI_FISICHE_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_id_suddivisione IN number
, old_amministrazione IN varchar )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "ANAGRAFE_UNITA_FISICHE"
   cursor cfk1_anagrafe_unita_fisiche(var_id_suddivisione number) is
      select 1
        from ANAGRAFE_UNITA_FISICHE
       where ID_SUDDIVISIONE = var_id_suddivisione
         and var_id_suddivisione is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "SUDDIVISIONI_FISICHE" if children still exist in "ANAGRAFE_UNITA_FISICHE"
      open  cfk1_anagrafe_unita_fisiche(OLD_ID_SUDDIVISIONE);
      fetch cfk1_anagrafe_unita_fisiche into dummy;
      found := cfk1_anagrafe_unita_fisiche%FOUND; /* %FOUND */
      close cfk1_anagrafe_unita_fisiche;
      if found
      then
         errno  := -20006;
         errmsg := 'Esistono riferimenti su Anagrafe unita fisiche. La registrazione di Suddivisioni fisiche non e'' eliminabile. (ANAGRAFE_UNITA_FISICHE.ANUF_SUFI_FK)';
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

