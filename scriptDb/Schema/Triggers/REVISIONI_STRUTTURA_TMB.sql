CREATE OR REPLACE TRIGGER REVISIONI_STRUTTURA_TMB
/******************************************************************************
 NOME:        REVISIONI_STRUTTURA_TMB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table REVISIONI_STRUTTURA
 ANNOTAZIONI: Richiama Procedure REVISIONI_STRUTTURA_PI e REVISIONI_STRUTTURA_PU  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before INSERT or UPDATE on REVISIONI_STRUTTURA
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
         REVISIONI_STRUTTURA_PI( :NEW.OTTICA
                        , :NEW.REVISIONE );
         null;
      end if;
      if UPDATING then
         REVISIONI_STRUTTURA_PU( :OLD.OTTICA
                        , :OLD.REVISIONE
                        , :NEW.OTTICA
                        , :NEW.REVISIONE );
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


