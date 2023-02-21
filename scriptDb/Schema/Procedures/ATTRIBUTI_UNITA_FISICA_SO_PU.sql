CREATE OR REPLACE procedure ATTRIBUTI_UNITA_FISICA_SO_PU
/******************************************************************************
 NOME:        ATTRIBUTI_UNITA_FISICA_SO_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table ATTRIBUTI_UNITA_FISICA_SO
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger ATTRIBUTI_UNITA_FISICA_SO_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_progr_unita_fisica IN number
, old_attributo IN varchar
, old_dal IN date
, new_progr_unita_fisica IN number
, new_attributo IN varchar
, new_dal IN date )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of UpdateChildParentExist constraint for the parent "ANAGRAFE_UNITA_FISICHE"
   cursor cpk1_attributi_unita_fisica_s(var_progr_unita_fisica number) is
      select 1
        from ANAGRAFE_UNITA_FISICHE
       where PROGR_UNITA_FISICA = var_progr_unita_fisica
         and var_progr_unita_fisica is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "ANAGRAFE_UNITA_FISICHE" deve esistere quando si modifica "ATTRIBUTI_UNITA_FISICA_SO"
      
         if  NEW_PROGR_UNITA_FISICA is not null and ( seq = 0 )
         then
            open  cpk1_attributi_unita_fisica_s(NEW_PROGR_UNITA_FISICA);
            fetch cpk1_attributi_unita_fisica_s into dummy;
            found := cpk1_attributi_unita_fisica_s%FOUND; /* %FOUND */
            close cpk1_attributi_unita_fisica_s;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Anagrafe unita fisiche. La registrazione Attributi unita fisica so non e'' modificabile. (ATTRIBUTI_UNITA_FISICA_SO.AUFS_ANUF_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
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

