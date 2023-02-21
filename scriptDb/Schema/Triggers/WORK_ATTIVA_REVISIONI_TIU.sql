CREATE OR REPLACE TRIGGER WORK_ATTIVA_REVISIONI_TIU
/******************************************************************************
 NOME:        WORK_ATTIVA_REVISIONI_TIU
 DESCRIZIONE: Trigger for Check / Set DATA Integrity
                          Check FUNCTIONAL Integrity
                            Set FUNCTIONAL Integrity
                       at INSERT or UPDATE or DELETE on Table WORK_REVISIONI
******************************************************************************/
   before INSERT or UPDATE or DELETE on WORK_REVISIONI
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
    0    __/__/____ __
   ***************************************************************************/
   begin  -- Check / Set DATA Integrity
      --  Column "ID_WORK_REVISIONE" uses sequence WORK_ATTIVA_REV_SQ
      if :NEW.ID_WORK_REVISIONE IS NULL and not DELETING then
         select WORK_ATTIVA_REV_SQ.NEXTVAL
           into :new.ID_WORK_REVISIONE
           from dual;
      end if;
      null;
   end;
   begin  -- Check FUNCTIONAL Integrity
      begin  -- Check UNIQUE Integrity on PK of "WORK_REVISIONI"
         if IntegrityPackage.GetNestLevel = 0 and not DELETING then
            declare
            cursor cpk_work_revisioni(var_ID_WORK_REVISIONE number) is
               select 1
                 from   WORK_REVISIONI
                where  ID_WORK_REVISIONE = var_ID_WORK_REVISIONE;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin
               if :new.ID_WORK_REVISIONE is not null then
                  open  cpk_work_revisioni(:new.ID_WORK_REVISIONE);
                  fetch cpk_work_revisioni into dummy;
                  found := cpk_work_revisioni%FOUND;
                  close cpk_work_revisioni;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.ID_WORK_REVISIONE||
                               '" gia'' presente in Work revisioni. La registrazione  non puo'' essere inserita.';
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


