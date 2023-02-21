CREATE OR REPLACE procedure AOO_PI
/******************************************************************************
 NOME:        AOO_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table AOO
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger AOO_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( new_progr_aoo IN number
, new_dal IN date
, new_codice_amministrazione IN varchar )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of InsertChildParentExist constraint for the parent "AMMINISTRAZIONI"
   cursor cpk1_aoo(var_codice_amministrazione varchar) is
      select 1
        from AMMINISTRAZIONI
       where CODICE_AMMINISTRAZIONE = var_codice_amministrazione
         and var_codice_amministrazione is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "AMMINISTRAZIONI" deve esistere quando si inserisce su "AOO"
      
         if NEW_CODICE_AMMINISTRAZIONE is not null
         then
            open  cpk1_aoo(NEW_CODICE_AMMINISTRAZIONE);
            fetch cpk1_aoo into dummy;
            found := cpk1_aoo%FOUND; /* %FOUND */
            close cpk1_aoo;
            if not found then
               errno  := -20002;
               errmsg := 'Non esiste riferimento su Amministrazioni. La registrazione AOO non puo'' essere inserita. (AOO.AOO_AMMI_FK)';
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

