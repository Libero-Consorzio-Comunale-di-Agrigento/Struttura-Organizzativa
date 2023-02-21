CREATE OR REPLACE TRIGGER SOGGETTI_RUBRICA_TIU
/******************************************************************************
 NOME:        SOGGETTI_RUBRICA_TIU
 DESCRIZIONE: Trigger for Check / Set DATA Integrity
                          Check FUNCTIONAL Integrity
                            Set FUNCTIONAL Integrity
                       at INSERT or UPDATE or DELETE on Table SOGGETTI_RUBRICA
******************************************************************************/
   before INSERT or UPDATE or DELETE on SOGGETTI_RUBRICA
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
      begin  -- Check UNIQUE Integrity on PK of "SOGGETTI_RUBRICA" 
         if IntegrityPackage.GetNestLevel = 0 and not DELETING then
            declare
            cursor cpk_soggetti_rubrica(var_NI number,
                            var_TIPO_CONTATTO number,
                            var_PROGRESSIVO number) is
               select 1
                 from   SOGGETTI_RUBRICA
                where  NI = var_NI and
                       TIPO_CONTATTO = var_TIPO_CONTATTO and
                       PROGRESSIVO = var_PROGRESSIVO;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin 
               if :new.NI is not null and
                  :new.TIPO_CONTATTO is not null and
                  :new.PROGRESSIVO is not null then
                  open  cpk_soggetti_rubrica(:new.NI,
                                 :new.TIPO_CONTATTO,
                                 :new.PROGRESSIVO);
                  fetch cpk_soggetti_rubrica into dummy;
                  found := cpk_soggetti_rubrica%FOUND;
                  close cpk_soggetti_rubrica;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.NI||' '||
                               :new.TIPO_CONTATTO||' '||
                               :new.PROGRESSIVO||
                               '" gia'' presente in Rubrica soggetti. La registrazione  non puo'' essere inserita.';
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


