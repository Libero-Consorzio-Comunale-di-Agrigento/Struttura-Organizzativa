CREATE OR REPLACE TRIGGER TIPI_INCARICO_TMB
/******************************************************************************
 NOME:        TIPI_INCARICO_TMB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table TIPI_INCARICO
 ANNOTAZIONI: Richiama Procedure TIPI_INCARICO_PI e TIPI_INCARICO_PU  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before INSERT or UPDATE on TIPI_INCARICO
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
         TIPI_INCARICO_PI( :NEW.INCARICO
                        , :NEW.TIPO_INCARICO );
         null;
      end if;
      if UPDATING then
         TIPI_INCARICO_PU( :OLD.INCARICO
                        , :OLD.TIPO_INCARICO
                        , :NEW.INCARICO
                        , :NEW.TIPO_INCARICO );
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


