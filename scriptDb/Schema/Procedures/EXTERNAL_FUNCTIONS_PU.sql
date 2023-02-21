CREATE OR REPLACE procedure EXTERNAL_FUNCTIONS_PU
/******************************************************************************
 NOME:        EXTERNAL_FUNCTIONS_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table EXTERNAL_FUNCTIONS
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger EXTERNAL_FUNCTIONS_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_function_id IN number
, old_table_name IN varchar
, old_function_owner IN varchar
, new_function_id IN number
, new_table_name IN varchar
, new_function_owner IN varchar
, new_firing_function in varchar2 )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of UpdateChildParentExist constraint for the parent "USER_TABLES"
   cursor cpk1_external_functions(var_table_name varchar) is
      select 1
        from USER_TABLES
       where TABLE_NAME = var_table_name
         and var_table_name is not null
         ;
   --  Declaration of UpdateChildParentExist constraint for the parent "ALL_USERS"
   cursor cpk2_external_functions(var_function_owner varchar) is
      select 1
        from ALL_USERS
       where (USERNAME = var_function_owner
         and var_function_owner is not null)
         or instr(new_firing_function, '@') > 0
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "USER_TABLES" deve esistere quando si modifica "EXTERNAL_FUNCTIONS"
         if  NEW_TABLE_NAME is not null and ( seq = 0 )
         then
            open  cpk1_external_functions(NEW_TABLE_NAME);
            fetch cpk1_external_functions into dummy;
            found := cpk1_external_functions%FOUND; /* %FOUND */
            close cpk1_external_functions;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su USER_TABLES. La registrazione External Functions non e'' modificabile. (EXTERNAL_FUNCTIONS.EXFU_USTA_FK_FK)';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "ALL_USERS" deve esistere quando si modifica "EXTERNAL_FUNCTIONS"
         if  NEW_FUNCTION_OWNER is not null and ( seq = 0 )
         then
            open  cpk2_external_functions(NEW_FUNCTION_OWNER);
            fetch cpk2_external_functions into dummy;
            found := cpk2_external_functions%FOUND; /* %FOUND */
            close cpk2_external_functions;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su All Users. La registrazione External Functions non e'' modificabile. (EXTERNAL_FUNCTIONS.EXFU_ALUS_FK_FK)';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      --  Chiave di "USER_TABLES" non modificabile sul figlio: "EXTERNAL_FUNCTIONS"
      if (OLD_TABLE_NAME != NEW_TABLE_NAME) then
         if IntegrityPackage.GetNestLevel = 0 then
          errno  := -20004;
          errmsg := 'L''identificazione di USER_TABLES non e'' modificabile su External Functions. (EXTERNAL_FUNCTIONS.EXFU_USTA_FK_FK)';
          raise integrity_error;
         end if;
      end if;
      --  Chiave di "ALL_USERS" non modificabile sul figlio: "EXTERNAL_FUNCTIONS"
      if (OLD_FUNCTION_OWNER != NEW_FUNCTION_OWNER) then
         if IntegrityPackage.GetNestLevel = 0 then
          errno  := -20004;
          errmsg := 'L''identificazione di All Users non e'' modificabile su External Functions. (EXTERNAL_FUNCTIONS.EXFU_ALUS_FK_FK)';
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

