CREATE OR REPLACE procedure RUOLI_COMPONENTE_PI
/******************************************************************************
 NOME:        RUOLI_COMPONENTE_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table RUOLI_COMPONENTE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger RUOLI_COMPONENTE_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( new_id_ruolo_componente IN number
, new_id_componente IN number
, new_ruolo IN varchar )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of InsertChildParentExist constraint for the parent "COMPONENTI"
   cursor cpk1_ruoli_componente(var_id_componente number) is
      select 1
        from COMPONENTI
       where ID_COMPONENTE = var_id_componente
         and var_id_componente is not null
         ;
   --  Declaration of InsertChildParentExist constraint for the parent "AD4_RUOLI"
   cursor cpk2_ruoli_componente(var_ruolo varchar) is
      select 1
        from AD4_RUOLI
       where RUOLO = var_ruolo
         and var_ruolo is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "COMPONENTI" deve esistere quando si inserisce su "RUOLI_COMPONENTE"
      
         if NEW_ID_COMPONENTE is not null
         then
            open  cpk1_ruoli_componente(NEW_ID_COMPONENTE);
            fetch cpk1_ruoli_componente into dummy;
            found := cpk1_ruoli_componente%FOUND; /* %FOUND */
            close cpk1_ruoli_componente;
            if not found then
               errno  := -20002;
               errmsg := 'Non esiste riferimento su Componenti. La registrazione Ruoli componente non puo'' essere inserita. (RUOLI_COMPONENTE.RUCO_COMP_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "AD4_RUOLI" deve esistere quando si inserisce su "RUOLI_COMPONENTE"
      
         if NEW_RUOLO is not null
         then
            open  cpk2_ruoli_componente(NEW_RUOLO);
            fetch cpk2_ruoli_componente into dummy;
            found := cpk2_ruoli_componente%FOUND; /* %FOUND */
            close cpk2_ruoli_componente;
            if not found then
               errno  := -20002;
               errmsg := 'Non esiste riferimento su AD4_RUOLI. La registrazione Ruoli componente non puo'' essere inserita. (RUOLI_COMPONENTE.RUCO_RUOL_FK)';
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

