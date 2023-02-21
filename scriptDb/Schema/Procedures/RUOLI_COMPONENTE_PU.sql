CREATE OR REPLACE procedure RUOLI_COMPONENTE_PU
/******************************************************************************
 NOME:        RUOLI_COMPONENTE_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table RUOLI_COMPONENTE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger RUOLI_COMPONENTE_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_id_ruolo_componente IN number
, old_id_componente IN number
, old_ruolo IN varchar
, new_id_ruolo_componente IN number
, new_id_componente IN number
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
   --  Declaration of UpdateChildParentExist constraint for the parent "COMPONENTI"
   cursor cpk1_ruoli_componente(var_id_componente number) is
      select 1
        from COMPONENTI
       where ID_COMPONENTE = var_id_componente
         and var_id_componente is not null
         ;
   --  Declaration of UpdateChildParentExist constraint for the parent "AD4_RUOLI"
   cursor cpk2_ruoli_componente(var_ruolo varchar) is
      select 1
        from AD4_RUOLI
       where RUOLO = var_ruolo
         and var_ruolo is not null
         ;
   --  Declaration of UpdateParentRestrict constraint for "RUOLI_DERIVATI"
   cursor cfk1_ruoli_derivati(var_id_ruolo_componente number) is
      select 1
        from RUOLI_DERIVATI
       where ID_RUOLO_COMPONENTE = var_id_ruolo_componente
         and var_id_ruolo_componente is not null
         ;
   --  Declaration of UpdateParentRestrict constraint for "RUOLI_DERIVATI"
   cursor cfk2_ruoli_derivati(var_id_ruolo_componente number) is
      select 1
        from RUOLI_DERIVATI
       where ID_PROFILO = var_id_ruolo_componente
         and var_id_ruolo_componente is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "COMPONENTI" deve esistere quando si modifica "RUOLI_COMPONENTE"
      
         if  NEW_ID_COMPONENTE is not null and ( seq = 0 )
         then
            open  cpk1_ruoli_componente(NEW_ID_COMPONENTE);
            fetch cpk1_ruoli_componente into dummy;
            found := cpk1_ruoli_componente%FOUND; /* %FOUND */
            close cpk1_ruoli_componente;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Componenti. La registrazione Ruoli componente non e'' modificabile. (RUOLI_COMPONENTE.RUCO_COMP_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "AD4_RUOLI" deve esistere quando si modifica "RUOLI_COMPONENTE"
      
         if  NEW_RUOLO is not null and ( seq = 0 )
         then
            open  cpk2_ruoli_componente(NEW_RUOLO);
            fetch cpk2_ruoli_componente into dummy;
            found := cpk2_ruoli_componente%FOUND; /* %FOUND */
            close cpk2_ruoli_componente;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su AD4_RUOLI. La registrazione Ruoli componente non e'' modificabile. (RUOLI_COMPONENTE.RUCO_RUOL_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      --  Chiave di "RUOLI_COMPONENTE" non modificabile se esistono referenze su "RUOLI_DERIVATI"
      if NEW_ID_RUOLO_COMPONENTE != OLD_ID_RUOLO_COMPONENTE
      then
         open  cfk1_ruoli_derivati(OLD_ID_RUOLO_COMPONENTE);
         fetch cfk1_ruoli_derivati into dummy;
         found := cfk1_ruoli_derivati%FOUND; /* %FOUND */
         close cfk1_ruoli_derivati;
         if found then
            errno  := -20005;
            errmsg := 'Esistono riferimenti su RUOLI_DERIVATI. La registrazione di Ruoli componente non e'' modificabile. (RUOLI_DERIVATI.REFERENCE_51_FK)';
            raise integrity_error;
         end if;
      end if;
      --  Chiave di "RUOLI_COMPONENTE" non modificabile se esistono referenze su "RUOLI_DERIVATI"
      if NEW_ID_RUOLO_COMPONENTE != OLD_ID_RUOLO_COMPONENTE
      then
         open  cfk2_ruoli_derivati(OLD_ID_RUOLO_COMPONENTE);
         fetch cfk2_ruoli_derivati into dummy;
         found := cfk2_ruoli_derivati%FOUND; /* %FOUND */
         close cfk2_ruoli_derivati;
         if found then
            errno  := -20005;
            errmsg := 'Esistono riferimenti su RUOLI_DERIVATI. La registrazione di Ruoli componente non e'' modificabile. (RUOLI_DERIVATI.REFERENCE_52_FK)';
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

