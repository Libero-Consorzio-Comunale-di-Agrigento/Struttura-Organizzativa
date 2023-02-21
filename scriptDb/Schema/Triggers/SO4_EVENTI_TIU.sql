CREATE OR REPLACE TRIGGER SO4_EVENTI_TIU
/******************************************************************************
 NOME:        SO4_EVENTI_TIU
 DESCRIZIONE: Trigger for Check / Set DATA Integrity
                          Check FUNCTIONAL Integrity
                            Set FUNCTIONAL Integrity
                       at INSERT or UPDATE or DELETE on Table SO4_EVENTI
******************************************************************************/
   before INSERT or UPDATE or DELETE on SO4_EVENTI
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
      --  Column "ID_EVENTO" uses sequence MODIFICHE_SQ
      if :NEW.ID_EVENTO IS NULL and not DELETING then
         select MODIFICHE_SQ.NEXTVAL
           into :new.ID_EVENTO
           from dual;
      end if;
      null;
   end;
   begin  -- Check FUNCTIONAL Integrity
      begin  -- Check UNIQUE Integrity on PK of "SO4_EVENTI" 
         if IntegrityPackage.GetNestLevel = 0 and not DELETING then
            declare
            cursor cpk_so4_eventi(var_ID_EVENTO number) is
               select 1
                 from   SO4_EVENTI
                where  ID_EVENTO = var_ID_EVENTO;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin 
               if :new.ID_EVENTO is not null then
                  open  cpk_so4_eventi(:new.ID_EVENTO);
                  fetch cpk_so4_eventi into dummy;
                  found := cpk_so4_eventi%FOUND;
                  close cpk_so4_eventi;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.ID_EVENTO||
                               '" gia'' presente in SO4_EVENTI. La registrazione  non puo'' essere inserita.';
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


