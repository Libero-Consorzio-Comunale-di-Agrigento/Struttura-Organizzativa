CREATE OR REPLACE TRIGGER OTTICHE_TMB
/******************************************************************************
 NOME:        OTTICHE_TMB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table OTTICHE
 ANNOTAZIONI: Richiama Procedure OTTICHE_PI e OTTICHE_PU  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before INSERT or UPDATE on OTTICHE
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
         OTTICHE_PI( :NEW.OTTICA
                        , :NEW.AMMINISTRAZIONE
                        , :NEW.OTTICA_ORIGINE );
         null;
      end if;
      if UPDATING then
         OTTICHE_PU( :OLD.OTTICA
                        , :OLD.AMMINISTRAZIONE
                        , :OLD.OTTICA_ORIGINE
                        , :NEW.OTTICA
                        , :NEW.AMMINISTRAZIONE
                        , :NEW.OTTICA_ORIGINE );
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


