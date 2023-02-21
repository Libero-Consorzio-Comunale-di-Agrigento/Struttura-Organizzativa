CREATE OR REPLACE procedure SUDDIVISIONI_FISICHE_PI
/******************************************************************************
 NOME:        SUDDIVISIONI_FISICHE_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table SUDDIVISIONI_FISICHE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger SUDDIVISIONI_FISICHE_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( new_id_suddivisione IN number
, new_amministrazione IN varchar )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of InsertChildParentExist constraint for the parent "AMMINISTRAZIONI"
   cursor cpk1_suddivisioni_fisiche(var_amministrazione varchar) is
      select 1
        from AMMINISTRAZIONI
       where CODICE_AMMINISTRAZIONE = var_amministrazione
         and var_amministrazione is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "AMMINISTRAZIONI" deve esistere quando si inserisce su "SUDDIVISIONI_FISICHE"
      
         if NEW_AMMINISTRAZIONE is not null
         then
            open  cpk1_suddivisioni_fisiche(NEW_AMMINISTRAZIONE);
            fetch cpk1_suddivisioni_fisiche into dummy;
            found := cpk1_suddivisioni_fisiche%FOUND; /* %FOUND */
            close cpk1_suddivisioni_fisiche;
            if not found then
               errno  := -20002;
               errmsg := 'Non esiste riferimento su Amministrazioni. La registrazione Suddivisioni fisiche non puo'' essere inserita. (SUDDIVISIONI_FISICHE.SUFI_AMMI_FK)';
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

