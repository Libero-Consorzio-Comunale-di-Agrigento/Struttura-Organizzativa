CREATE OR REPLACE procedure SUDDIVISIONI_FISICHE_PU
/******************************************************************************
 NOME:        SUDDIVISIONI_FISICHE_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table SUDDIVISIONI_FISICHE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger SUDDIVISIONI_FISICHE_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_id_suddivisione IN number
, old_amministrazione IN varchar
, new_id_suddivisione IN number
, new_amministrazione IN varchar )
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
   cursor cpk1_suddivisioni_fisiche(var_amministrazione varchar) is
      select 1
        from AMMINISTRAZIONI
       where CODICE_AMMINISTRAZIONE = var_amministrazione
         and var_amministrazione is not null
         ;
   --  Declaration of UpdateParentRestrict constraint for "ANAGRAFE_UNITA_FISICHE"
   cursor cfk1_anagrafe_unita_fisiche(var_id_suddivisione number) is
      select 1
        from ANAGRAFE_UNITA_FISICHE
       where ID_SUDDIVISIONE = var_id_suddivisione
         and var_id_suddivisione is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "AMMINISTRAZIONI" deve esistere quando si modifica "SUDDIVISIONI_FISICHE"
      
         if  NEW_AMMINISTRAZIONE is not null and ( seq = 0 )
         then
            open  cpk1_suddivisioni_fisiche(NEW_AMMINISTRAZIONE);
            fetch cpk1_suddivisioni_fisiche into dummy;
            found := cpk1_suddivisioni_fisiche%FOUND; /* %FOUND */
            close cpk1_suddivisioni_fisiche;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Amministrazioni. La registrazione Suddivisioni fisiche non e'' modificabile. (SUDDIVISIONI_FISICHE.SUFI_AMMI_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      --  Chiave di "SUDDIVISIONI_FISICHE" non modificabile se esistono referenze su "ANAGRAFE_UNITA_FISICHE"
      if NEW_ID_SUDDIVISIONE != OLD_ID_SUDDIVISIONE
      then
         open  cfk1_anagrafe_unita_fisiche(OLD_ID_SUDDIVISIONE);
         fetch cfk1_anagrafe_unita_fisiche into dummy;
         found := cfk1_anagrafe_unita_fisiche%FOUND; /* %FOUND */
         close cfk1_anagrafe_unita_fisiche;
         if found then
            errno  := -20005;
            errmsg := 'Esistono riferimenti su Anagrafe unita fisiche. La registrazione di Suddivisioni fisiche non e'' modificabile. (ANAGRAFE_UNITA_FISICHE.ANUF_SUFI_FK)';
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

