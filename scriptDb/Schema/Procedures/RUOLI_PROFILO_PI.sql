CREATE OR REPLACE procedure RUOLI_PROFILO_PI
/******************************************************************************
 NOME:        RUOLI_PROFILO_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table RUOLI_PROFILO
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger RUOLI_PROFILO_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( new_id_ruolo_profilo IN number
, new_ruolo_profilo IN varchar
, new_ruolo IN varchar )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of InsertChildParentExist constraint for the parent "AD4_RUOLI"
   cursor cpk1_ruoli_profilo(var_ruolo_profilo varchar) is
      select 1
        from AD4_RUOLI
       where RUOLO = var_ruolo_profilo
         and var_ruolo_profilo is not null
         ;
   --  Declaration of InsertChildParentExist constraint for the parent "AD4_RUOLI"
   cursor cpk2_ruoli_profilo(var_ruolo varchar) is
      select 1
        from AD4_RUOLI
       where RUOLO = var_ruolo
         and var_ruolo is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "AD4_RUOLI" deve esistere quando si inserisce su "RUOLI_PROFILO"
      
         if NEW_RUOLO_PROFILO is not null
         then
            open  cpk1_ruoli_profilo(NEW_RUOLO_PROFILO);
            fetch cpk1_ruoli_profilo into dummy;
            found := cpk1_ruoli_profilo%FOUND; /* %FOUND */
            close cpk1_ruoli_profilo;
            if not found then
               errno  := -20002;
               errmsg := 'Non esiste riferimento su AD4_RUOLI. La registrazione RUOLI_PROFILO non puo'' essere inserita. (RUOLI_PROFILO.REFERENCE_49_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "AD4_RUOLI" deve esistere quando si inserisce su "RUOLI_PROFILO"
      
         if NEW_RUOLO is not null
         then
            open  cpk2_ruoli_profilo(NEW_RUOLO);
            fetch cpk2_ruoli_profilo into dummy;
            found := cpk2_ruoli_profilo%FOUND; /* %FOUND */
            close cpk2_ruoli_profilo;
            if not found then
               errno  := -20002;
               errmsg := 'Non esiste riferimento su AD4_RUOLI. La registrazione RUOLI_PROFILO non puo'' essere inserita. (RUOLI_PROFILO.REFERENCE_50_FK)';
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

