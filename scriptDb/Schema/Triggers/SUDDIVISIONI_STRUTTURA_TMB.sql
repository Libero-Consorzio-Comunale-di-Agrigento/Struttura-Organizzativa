CREATE OR REPLACE TRIGGER SUDDIVISIONI_STRUTTURA_TMB
/******************************************************************************
 NOME:        SUDDIVISIONI_STRUTTURA_TMB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table SUDDIVISIONI_STRUTTURA
 ANNOTAZIONI: Richiama Procedure SUDDIVISIONI_STRUTTURA_PI e SUDDIVISIONI_STRUTTURA_PU  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before INSERT or UPDATE on SUDDIVISIONI_STRUTTURA
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
         SUDDIVISIONI_STRUTTURA_PI( :NEW.ID_SUDDIVISIONE
                        , :NEW.OTTICA );
         null;
      end if;
      if UPDATING then
         SUDDIVISIONI_STRUTTURA_PU( :OLD.ID_SUDDIVISIONE
                        , :OLD.OTTICA
                        , :NEW.ID_SUDDIVISIONE
                        , :NEW.OTTICA );
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


