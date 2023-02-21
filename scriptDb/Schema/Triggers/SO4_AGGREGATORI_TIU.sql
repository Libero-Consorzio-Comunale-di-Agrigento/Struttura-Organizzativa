CREATE OR REPLACE TRIGGER SO4_AGGREGATORI_TIU
/******************************************************************************
 NOME:        SO4_AGGREGATORI_TIU
 DESCRIZIONE: Trigger for Check / Set DATA Integrity
                          Check FUNCTIONAL Integrity
                            Set FUNCTIONAL Integrity
                       at INSERT or UPDATE or DELETE on Table SO4_AGGREGATORI
******************************************************************************/
   before INSERT or UPDATE or DELETE on SO4_AGGREGATORI
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
      if inserting or updating then
         if :new.data_inizio_validita is null then 
            :new.data_inizio_validita := sysdate; 
         end if;
         if :new.data_inizio_validita > nvl(:new.data_fine_validita,to_date(3333333,'j')) then
            raise_application_error(-20901,'Incongruenza date di inizio e fine validita''');
         end if;
      end if;
   end;
   begin  -- Check FUNCTIONAL Integrity
      begin  -- Check UNIQUE Integrity on PK of "SO4_AGGREGATORI" 
         if IntegrityPackage.GetNestLevel = 0 and not DELETING then
            declare
            cursor cpk_so4_aggregatori(var_AGGREGATORE varchar,
                            var_DATA_INIZIO_VALIDITA date) is
               select 1
                 from   SO4_AGGREGATORI
                where  AGGREGATORE = var_AGGREGATORE and
                       DATA_INIZIO_VALIDITA = var_DATA_INIZIO_VALIDITA;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin 
               if :new.AGGREGATORE is not null and
                  :new.DATA_INIZIO_VALIDITA is not null then
                  open  cpk_so4_aggregatori(:new.AGGREGATORE,
                                 :new.DATA_INIZIO_VALIDITA);
                  fetch cpk_so4_aggregatori into dummy;
                  found := cpk_so4_aggregatori%FOUND;
                  close cpk_so4_aggregatori;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.AGGREGATORE||' '||
                               :new.DATA_INIZIO_VALIDITA||
                               '" gia'' presente in Aggregatori per CGS. La registrazione  non puo'' essere inserita.';
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


