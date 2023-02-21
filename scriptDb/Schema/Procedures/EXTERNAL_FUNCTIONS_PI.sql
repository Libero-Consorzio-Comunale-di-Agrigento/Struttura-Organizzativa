CREATE OR REPLACE procedure EXTERNAL_FUNCTIONS_PI
/******************************************************************************
 NOME:        EXTERNAL_FUNCTIONS_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table EXTERNAL_FUNCTIONS
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger EXTERNAL_FUNCTIONS_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( new_function_id IN number
, new_table_name IN varchar
, new_function_owner IN varchar
, new_firing_function in varchar2)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   cardinality      integer;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of InsertChildParentExist constraint for the parent "USER_TABLES"
   cursor cpk1_external_functions(var_table_name varchar) is
      select 1
        from USER_TABLES
       where TABLE_NAME = var_table_name
         and var_table_name is not null
         ;
   --  Declaration of InsertChildParentExist constraint for the parent "ALL_USERS"
   cursor cpk2_external_functions(var_function_owner varchar) is
      select 1
        from ALL_USERS
       where (USERNAME = var_function_owner
         and var_function_owner is not null)
         or instr(new_firing_function, '@') > 0
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "USER_TABLES" deve esistere quando si inserisce su "EXTERNAL_FUNCTIONS"
         if NEW_TABLE_NAME is not null
         then
            open  cpk1_external_functions(NEW_TABLE_NAME);
            fetch cpk1_external_functions into dummy;
            found := cpk1_external_functions%FOUND; /* %FOUND */
            close cpk1_external_functions;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su USER_TABLES. La registrazione External Functions non puo'' essere inserita. (EXTERNAL_FUNCTIONS.EXFU_USTA_FK_FK)';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "ALL_USERS" deve esistere quando si inserisce su "EXTERNAL_FUNCTIONS"
         if NEW_FUNCTION_OWNER is not null
         then
            open  cpk2_external_functions(NEW_FUNCTION_OWNER);
            fetch cpk2_external_functions into dummy;
            found := cpk2_external_functions%FOUND; /* %FOUND */
            close cpk2_external_functions;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su All Users. La registrazione External Functions non puo'' essere inserita. (EXTERNAL_FUNCTIONS.EXFU_ALUS_FK_FK)';
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

