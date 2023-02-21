CREATE OR REPLACE TRIGGER EXTERNAL_FUNCTIONS_TIU
/******************************************************************************
 NOME:        EXTERNAL_FUNCTIONS_TIU
 DESCRIZIONE: Trigger for Check / Set DATA Integrity
                          Check FUNCTIONAL Integrity
                            Set FUNCTIONAL Integrity
                       at INSERT or UPDATE or DELETE on Table EXTERNAL_FUNCTIONS
******************************************************************************/
   before INSERT or UPDATE or DELETE on EXTERNAL_FUNCTIONS
for each row
declare
   functionalNestLevel integer;
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   functionalNestLevel := IntegrityPackage.GetNestLevel;
   /***************************************************************************
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ---------------------------------------------------
    0    31/05/2007 MM     Creazione     
   ***************************************************************************/
   begin  -- Check / Set DATA Integrity
      --  Column "FUNCTION_ID" uses sequence EXFU_SQ
      if :NEW.FUNCTION_ID IS NULL and not DELETING then
         select EXFU_SQ.NEXTVAL
           into :new.FUNCTION_ID
           from dual;
      end if;
      if not deleting then
         if :new.TABLE_NAME is null then
            raise_application_error(-20999, 'Campo obbligatorio (TABLE_NAME)');
         end if;
         :new.TABLE_NAME := UPPER(:new.TABLE_NAME);
         if :new.FUNCTION_OWNER is null then
            raise_application_error(-20999, 'Campo obbligatorio (FUNCTION_OWNER)');
         end if;      
         :new.FUNCTION_OWNER := UPPER(:new.FUNCTION_OWNER);
         if :new.FIRING_FUNCTION is null then
            raise_application_error(-20999, 'Campo obbligatorio (FIRING_FUNCTION)');
         end if;      
         :new.FIRING_FUNCTION := UPPER(:new.FIRING_FUNCTION);
         if :new.FIRING_EVENT is null then
            raise_application_error(-20999, 'Campo obbligatorio (FIRING_EVENT)');
         end if;      
         :new.FIRING_EVENT := UPPER(:new.FIRING_EVENT);    
      end if;  
   end;
   begin  -- Check FUNCTIONAL Integrity
      begin  -- Check UNIQUE Integrity on PK of "EXTERNAL_FUNCTIONS"
         if IntegrityPackage.GetNestLevel = 0 and not DELETING then
            declare
            cursor cpk_external_functions(var_FUNCTION_ID number) is
               select 1
                 from   EXTERNAL_FUNCTIONS
                where  FUNCTION_ID = var_FUNCTION_ID;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin 
               if :new.FUNCTION_ID is not null then
                  open  cpk_external_functions(:new.FUNCTION_ID);
                  fetch cpk_external_functions into dummy;
                  found := cpk_external_functions%FOUND;
                  close cpk_external_functions;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.FUNCTION_ID||
                               '" gia'' presente in External Functions. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when MUTATING then null;  -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
      end;
      null;
   end;
   begin  -- Set FUNCTIONAL Integrity
      if functionalNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin  -- Global FUNCTIONAL Integrity at Level 0
            /* NONE */ null;
         end;
        IntegrityPackage.PreviousNestLevel;
      end if;
      IntegrityPackage.NextNestLevel;
      begin  -- Full FUNCTIONAL Integrity at Any Level
         /* NONE */ null;
         IF NOT DELETING THEN
            IF external_functions_pkg.is_valid_function(:new.FUNCTION_OWNER, :new.FIRING_FUNCTION) = 0 THEN
               RAISE_APPLICATION_ERROR(-20999, 'Funzione non esistente / non accessibile / non valida o numero di parametri errato.');
            END IF;
            BEGIN
               external_functions_pkg.CREA_TRIGGER_SI4EF(:new.TABLE_NAME);
            END;
         END IF;      
      end;
      IntegrityPackage.PreviousNestLevel;
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


