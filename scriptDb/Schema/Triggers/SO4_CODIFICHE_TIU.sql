CREATE OR REPLACE TRIGGER SO4_CODIFICHE_TIU
/******************************************************************************
 NOME:        SO4_CODIFICHE_TIU
 DESCRIZIONE: Trigger for Check / Set DATA Integrity
                          Check FUNCTIONAL Integrity
                            Set FUNCTIONAL Integrity
                       at INSERT or UPDATE or DELETE on Table SO4_CODIFICHE
******************************************************************************/
   before INSERT or UPDATE or DELETE on SO4_CODIFICHE
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
      null;
   end;
   begin  -- Check FUNCTIONAL Integrity
      begin  -- Check UNIQUE Integrity on PK of "SO4_CODIFICHE" 
         if IntegrityPackage.GetNestLevel = 0 and not DELETING then
            declare
            cursor cpk_so4_codifiche(var_ID_CODIFICA number) is
               select 1
                 from   SO4_CODIFICHE
                where  ID_CODIFICA = var_ID_CODIFICA;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin 
               if :new.ID_CODIFICA is not null then
                  open  cpk_so4_codifiche(:new.ID_CODIFICA);
                  fetch cpk_so4_codifiche into dummy;
                  found := cpk_so4_codifiche%FOUND;
                  close cpk_so4_codifiche;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.ID_CODIFICA||
                               '" gia'' presente in SO4_CODIFICHE. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when MUTATING then null;  -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
      end;
      if inserting then
         if :NEW.id_codifica is null then
            :NEW.id_codifica := si4.next_id('SO4_CODIFICHE','ID_CODIFICA');
         end if;
      end if;
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


