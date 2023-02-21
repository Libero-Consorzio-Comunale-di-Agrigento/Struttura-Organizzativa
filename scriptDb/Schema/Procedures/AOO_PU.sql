CREATE OR REPLACE procedure AOO_PU
/******************************************************************************
 NOME:        AOO_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table AOO
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger AOO_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_progr_aoo IN number
, old_dal IN date
, old_codice_amministrazione IN varchar
, new_progr_aoo IN number
, new_dal IN date
, new_codice_amministrazione IN varchar )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of UpdateChildParentExist constraint for the parent "AMMINISTRAZIONI"
   cursor cpk1_aoo(var_codice_amministrazione varchar) is
      select 1
        from AMMINISTRAZIONI
       where CODICE_AMMINISTRAZIONE = var_codice_amministrazione
         and var_codice_amministrazione is not null
         ;
   --  Declaration of UpdateParentRestrict constraint for "ANAGRAFE_UNITA_ORGANIZZATIVE"
   cursor cfk2_anagrafe_unita_organizza(var_progr_aoo number) is
      select 1
        from ANAGRAFE_UNITA_ORGANIZZATIVE
       where PROGR_AOO = var_progr_aoo
         and var_progr_aoo is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "AMMINISTRAZIONI" deve esistere quando si modifica "AOO"
      
         if  NEW_CODICE_AMMINISTRAZIONE is not null and ( seq = 0 )
         then
            open  cpk1_aoo(NEW_CODICE_AMMINISTRAZIONE);
            fetch cpk1_aoo into dummy;
            found := cpk1_aoo%FOUND; /* %FOUND */
            close cpk1_aoo;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Amministrazioni. La registrazione AOO non e'' modificabile. (AOO.AOO_AMMI_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      --  Chiave di "AOO" non modificabile se esistono referenze su "ANAGRAFE_UNITA_ORGANIZZATIVE"
      if NEW_PROGR_AOO != OLD_PROGR_AOO
      then
         open  cfk2_anagrafe_unita_organizza(OLD_PROGR_AOO);
         fetch cfk2_anagrafe_unita_organizza into dummy;
         found := cfk2_anagrafe_unita_organizza%FOUND; /* %FOUND */
         close cfk2_anagrafe_unita_organizza;
         if found then
            errno  := -20005;
            errmsg := 'Esistono riferimenti su Anagrafe unita organizzative. La registrazione di AOO non e'' modificabile. (ANAGRAFE_UNITA_ORGANIZZATIVE.ANUO_AOO_FK)';
            raise integrity_error;
         end if;
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

