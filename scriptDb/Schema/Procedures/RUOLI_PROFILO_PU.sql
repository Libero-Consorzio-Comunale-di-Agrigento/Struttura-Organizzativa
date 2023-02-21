CREATE OR REPLACE procedure RUOLI_PROFILO_PU
/******************************************************************************
 NOME:        RUOLI_PROFILO_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table RUOLI_PROFILO
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger RUOLI_PROFILO_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_id_ruolo_profilo IN number
, old_ruolo_profilo IN varchar
, old_ruolo IN varchar
, new_id_ruolo_profilo IN number
, new_ruolo_profilo IN varchar
, new_ruolo IN varchar )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of UpdateChildParentExist constraint for the parent "AD4_RUOLI"
   cursor cpk1_ruoli_profilo(var_ruolo_profilo varchar) is
      select 1
        from AD4_RUOLI
       where RUOLO = var_ruolo_profilo
         and var_ruolo_profilo is not null
         ;
   --  Declaration of UpdateChildParentExist constraint for the parent "AD4_RUOLI"
   cursor cpk2_ruoli_profilo(var_ruolo varchar) is
      select 1
        from AD4_RUOLI
       where RUOLO = var_ruolo
         and var_ruolo is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "AD4_RUOLI" deve esistere quando si modifica "RUOLI_PROFILO"
      
         if  NEW_RUOLO_PROFILO is not null and ( seq = 0 )
         then
            open  cpk1_ruoli_profilo(NEW_RUOLO_PROFILO);
            fetch cpk1_ruoli_profilo into dummy;
            found := cpk1_ruoli_profilo%FOUND; /* %FOUND */
            close cpk1_ruoli_profilo;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su AD4_RUOLI. La registrazione RUOLI_PROFILO non e'' modificabile. (RUOLI_PROFILO.REFERENCE_49_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "AD4_RUOLI" deve esistere quando si modifica "RUOLI_PROFILO"
      
         if  NEW_RUOLO is not null and ( seq = 0 )
         then
            open  cpk2_ruoli_profilo(NEW_RUOLO);
            fetch cpk2_ruoli_profilo into dummy;
            found := cpk2_ruoli_profilo%FOUND; /* %FOUND */
            close cpk2_ruoli_profilo;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su AD4_RUOLI. La registrazione RUOLI_PROFILO non e'' modificabile. (RUOLI_PROFILO.REFERENCE_50_FK)';
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

