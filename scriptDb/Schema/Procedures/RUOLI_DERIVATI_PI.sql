CREATE OR REPLACE procedure RUOLI_DERIVATI_PI
/******************************************************************************
 NOME:        RUOLI_DERIVATI_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table RUOLI_DERIVATI
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger RUOLI_DERIVATI_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( new_id_ruolo_derivato IN number
, new_id_ruolo_componente IN number
, new_id_profilo IN number )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of InsertChildParentExist constraint for the parent "RUOLI_COMPONENTE"
   cursor cpk1_ruoli_derivati(var_id_ruolo_componente number) is
      select 1
        from RUOLI_COMPONENTE
       where ID_RUOLO_COMPONENTE = var_id_ruolo_componente
         and var_id_ruolo_componente is not null
         ;
   --  Declaration of InsertChildParentExist constraint for the parent "RUOLI_COMPONENTE"
   cursor cpk2_ruoli_derivati(var_id_profilo number) is
      select 1
        from RUOLI_COMPONENTE
       where ID_RUOLO_COMPONENTE = var_id_profilo
         and var_id_profilo is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "RUOLI_COMPONENTE" deve esistere quando si inserisce su "RUOLI_DERIVATI"
      
         if NEW_ID_RUOLO_COMPONENTE is not null
         then
            open  cpk1_ruoli_derivati(NEW_ID_RUOLO_COMPONENTE);
            fetch cpk1_ruoli_derivati into dummy;
            found := cpk1_ruoli_derivati%FOUND; /* %FOUND */
            close cpk1_ruoli_derivati;
            if not found then
               errno  := -20002;
               errmsg := 'Non esiste riferimento su Ruoli componente. La registrazione RUOLI_DERIVATI non puo'' essere inserita. (RUOLI_DERIVATI.REFERENCE_51_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "RUOLI_COMPONENTE" deve esistere quando si inserisce su "RUOLI_DERIVATI"
      
         if NEW_ID_PROFILO is not null
         then
            open  cpk2_ruoli_derivati(NEW_ID_PROFILO);
            fetch cpk2_ruoli_derivati into dummy;
            found := cpk2_ruoli_derivati%FOUND; /* %FOUND */
            close cpk2_ruoli_derivati;
            if not found then
               errno  := -20002;
               errmsg := 'Non esiste riferimento su Ruoli componente. La registrazione RUOLI_DERIVATI non puo'' essere inserita. (RUOLI_DERIVATI.REFERENCE_52_FK)';
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

