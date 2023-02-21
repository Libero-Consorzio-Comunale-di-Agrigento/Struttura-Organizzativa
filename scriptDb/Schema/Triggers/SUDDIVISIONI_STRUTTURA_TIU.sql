CREATE OR REPLACE TRIGGER SUDDIVISIONI_STRUTTURA_TIU
/******************************************************************************
 NOME:        SUDDIVISIONI_STRUTTURA_TIU
 DESCRIZIONE: Trigger for Check / Set DATA Integrity
                          Check FUNCTIONAL Integrity
                            Set FUNCTIONAL Integrity
                       at INSERT or UPDATE or DELETE on Table SUDDIVISIONI_STRUTTURA
******************************************************************************/
   before INSERT or UPDATE or DELETE on SUDDIVISIONI_STRUTTURA
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
      --  Column "ID_SUDDIVISIONE" uses sequence SUDDIVISIONI_STRUTTURA_SQ
      if :NEW.ID_SUDDIVISIONE IS NULL and not DELETING then
         select SUDDIVISIONI_STRUTTURA_SQ.NEXTVAL
           into :new.ID_SUDDIVISIONE
           from dual;
      end if;
      if :NEW.utente_aggiornamento is null and not DELETING then
         :NEW.utente_aggiornamento := user;
      end if;
      if :NEW.data_aggiornamento is null and not DELETING then
         :NEW.data_aggiornamento := trunc(sysdate);
      end if;
   end;
   begin  -- Check FUNCTIONAL Integrity
      begin  -- Check UNIQUE Integrity on PK of "SUDDIVISIONI_STRUTTURA" 
         if IntegrityPackage.GetNestLevel = 0 and not DELETING then
            declare
            cursor cpk_suddivisioni_struttura(var_ID_SUDDIVISIONE number) is
               select 1
                 from   SUDDIVISIONI_STRUTTURA
                where  ID_SUDDIVISIONE = var_ID_SUDDIVISIONE;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin 
               if :new.ID_SUDDIVISIONE is not null then
                  open  cpk_suddivisioni_struttura(:new.ID_SUDDIVISIONE);
                  fetch cpk_suddivisioni_struttura into dummy;
                  found := cpk_suddivisioni_struttura%FOUND;
                  close cpk_suddivisioni_struttura;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.ID_SUDDIVISIONE||
                               '" gia'' presente in Suddivisioni Struttura. La registrazione  non puo'' essere inserita.';
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


