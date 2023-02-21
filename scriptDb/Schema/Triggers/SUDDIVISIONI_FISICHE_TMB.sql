CREATE OR REPLACE TRIGGER SUDDIVISIONI_FISICHE_TMB
/******************************************************************************
 NOME:        SUDDIVISIONI_FISICHE_TMB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table SUDDIVISIONI_FISICHE
 ANNOTAZIONI: Richiama Procedure SUDDIVISIONI_FISICHE_PI e SUDDIVISIONI_FISICHE_PU  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before INSERT or UPDATE on SUDDIVISIONI_FISICHE
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      if INSERTING then
         SUDDIVISIONI_FISICHE_PI( :NEW.ID_SUDDIVISIONE
                        , :NEW.AMMINISTRAZIONE );
         null;
      end if;
      if UPDATING then
         SUDDIVISIONI_FISICHE_PU( :OLD.ID_SUDDIVISIONE
                        , :OLD.AMMINISTRAZIONE
                        , :NEW.ID_SUDDIVISIONE
                        , :NEW.AMMINISTRAZIONE );
         null;
      end if;
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


