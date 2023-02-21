CREATE OR REPLACE procedure AOO_PD
/******************************************************************************
 NOME:        AOO_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table AOO
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger AOO_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_progr_aoo IN number
, old_dal IN date
, old_codice_amministrazione IN varchar )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "ANAGRAFE_UNITA_ORGANIZZATIVE"
   cursor cfk2_anagrafe_unita_organizza(var_progr_aoo number) is
      select 1
        from ANAGRAFE_UNITA_ORGANIZZATIVE
       where PROGR_AOO = var_progr_aoo
         and var_progr_aoo is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "AOO" if children still exist in "ANAGRAFE_UNITA_ORGANIZZATIVE"
      open  cfk2_anagrafe_unita_organizza(OLD_PROGR_AOO);
      fetch cfk2_anagrafe_unita_organizza into dummy;
      found := cfk2_anagrafe_unita_organizza%FOUND; /* %FOUND */
      close cfk2_anagrafe_unita_organizza;
      if found
      then
         errno  := -20006;
         errmsg := 'Esistono riferimenti su Anagrafe unita organizzative. La registrazione di AOO non e'' eliminabile. (ANAGRAFE_UNITA_ORGANIZZATIVE.ANUO_AOO_FK)';
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

