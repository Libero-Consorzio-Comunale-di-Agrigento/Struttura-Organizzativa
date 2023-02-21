CREATE OR REPLACE procedure UNITA_FISICHE_PU
/******************************************************************************
 NOME:        UNITA_FISICHE_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table UNITA_FISICHE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger UNITA_FISICHE_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_id_elemento_fisico IN number
, old_amministrazione IN varchar
, old_progr_unita_fisica IN number
, old_id_unita_fisica_padre IN number
, new_id_elemento_fisico IN number
, new_amministrazione IN varchar
, new_progr_unita_fisica IN number
, new_id_unita_fisica_padre IN number )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of UpdateChildParentExist constraint for the parent "UNITA_FISICHE"
   cursor cpk1_unita_fisiche(var_id_unita_fisica_padre number) is
      select 1
        from UNITA_FISICHE
       where PROGR_UNITA_FISICA = var_id_unita_fisica_padre
         and var_id_unita_fisica_padre is not null
         ;
   --  Declaration of UpdateChildParentExist constraint for the parent "AMMINISTRAZIONI"
   cursor cpk2_unita_fisiche(var_amministrazione varchar) is
      select 1
        from AMMINISTRAZIONI
       where CODICE_AMMINISTRAZIONE = var_amministrazione
         and var_amministrazione is not null
         ;
   --  Declaration of UpdateChildParentExist constraint for the parent "ANAGRAFE_UNITA_FISICHE"
   cursor cpk3_unita_fisiche(var_progr_unita_fisica number) is
      select 1
        from ANAGRAFE_UNITA_FISICHE
       where PROGR_UNITA_FISICA = var_progr_unita_fisica
         and var_progr_unita_fisica is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "UNITA_FISICHE" deve esistere quando si modifica "UNITA_FISICHE"
      
         if  NEW_ID_UNITA_FISICA_PADRE is not null and ( seq = 0 )
         then
            open  cpk1_unita_fisiche(NEW_ID_UNITA_FISICA_PADRE);
            fetch cpk1_unita_fisiche into dummy;
            found := cpk1_unita_fisiche%FOUND; /* %FOUND */
            close cpk1_unita_fisiche;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Unita fisiche. La registrazione Unita fisiche non e'' modificabile. (UNITA_FISICHE.UNFI_UNFI_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "AMMINISTRAZIONI" deve esistere quando si modifica "UNITA_FISICHE"
      
         if  NEW_AMMINISTRAZIONE is not null and ( seq = 0 )
         then
            open  cpk2_unita_fisiche(NEW_AMMINISTRAZIONE);
            fetch cpk2_unita_fisiche into dummy;
            found := cpk2_unita_fisiche%FOUND; /* %FOUND */
            close cpk2_unita_fisiche;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Amministrazioni. La registrazione Unita fisiche non e'' modificabile. (UNITA_FISICHE.UNFI_AMMI_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "ANAGRAFE_UNITA_FISICHE" deve esistere quando si modifica "UNITA_FISICHE"
      
         if  NEW_PROGR_UNITA_FISICA is not null and ( seq = 0 )
         then
            open  cpk3_unita_fisiche(NEW_PROGR_UNITA_FISICA);
            fetch cpk3_unita_fisiche into dummy;
            found := cpk3_unita_fisiche%FOUND; /* %FOUND */
            close cpk3_unita_fisiche;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Anagrafe unita fisiche. La registrazione Unita fisiche non e'' modificabile. (UNITA_FISICHE.UNFI_ANUF_FK)';
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

