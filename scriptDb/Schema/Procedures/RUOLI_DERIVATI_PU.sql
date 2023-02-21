CREATE OR REPLACE procedure RUOLI_DERIVATI_PU
/******************************************************************************
 NOME:        RUOLI_DERIVATI_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table RUOLI_DERIVATI
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger RUOLI_DERIVATI_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_id_ruolo_derivato IN number
, old_id_ruolo_componente IN number
, old_id_profilo IN number
, new_id_ruolo_derivato IN number
, new_id_ruolo_componente IN number
, new_id_profilo IN number )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of UpdateChildParentExist constraint for the parent "RUOLI_COMPONENTE"
   cursor cpk1_ruoli_derivati(var_id_ruolo_componente number) is
      select 1
        from RUOLI_COMPONENTE
       where ID_RUOLO_COMPONENTE = var_id_ruolo_componente
         and var_id_ruolo_componente is not null
         ;
   --  Declaration of UpdateChildParentExist constraint for the parent "RUOLI_COMPONENTE"
   cursor cpk2_ruoli_derivati(var_id_profilo number) is
      select 1
        from RUOLI_COMPONENTE
       where ID_RUOLO_COMPONENTE = var_id_profilo
         and var_id_profilo is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "RUOLI_COMPONENTE" deve esistere quando si modifica "RUOLI_DERIVATI"
      
         if  NEW_ID_RUOLO_COMPONENTE is not null and ( seq = 0 )
         then
            open  cpk1_ruoli_derivati(NEW_ID_RUOLO_COMPONENTE);
            fetch cpk1_ruoli_derivati into dummy;
            found := cpk1_ruoli_derivati%FOUND; /* %FOUND */
            close cpk1_ruoli_derivati;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Ruoli componente. La registrazione RUOLI_DERIVATI non e'' modificabile. (RUOLI_DERIVATI.REFERENCE_51_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "RUOLI_COMPONENTE" deve esistere quando si modifica "RUOLI_DERIVATI"
      
         if  NEW_ID_PROFILO is not null and ( seq = 0 )
         then
            open  cpk2_ruoli_derivati(NEW_ID_PROFILO);
            fetch cpk2_ruoli_derivati into dummy;
            found := cpk2_ruoli_derivati%FOUND; /* %FOUND */
            close cpk2_ruoli_derivati;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Ruoli componente. La registrazione RUOLI_DERIVATI non e'' modificabile. (RUOLI_DERIVATI.REFERENCE_52_FK)';
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

