CREATE OR REPLACE TRIGGER UBICAZIONI_COMPONENTE_TMB
/******************************************************************************
 NOME:        UBICAZIONI_COMPONENTE_TMB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table UBICAZIONI_COMPONENTE
 ANNOTAZIONI: Richiama Procedure UBICAZIONI_COMPONENTE_PI e UBICAZIONI_COMPONENTE_PU  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
   before INSERT or UPDATE on UBICAZIONI_COMPONENTE
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
         UBICAZIONI_COMPONENTE_PI( :NEW.ID_UBICAZIONE_COMPONENTE
                        , :NEW.ID_COMPONENTE
                        , :NEW.ID_UBICAZIONE_UNITA );
         null;
      end if;
      if UPDATING then
         UBICAZIONI_COMPONENTE_PU( :OLD.ID_UBICAZIONE_COMPONENTE
                        , :OLD.ID_COMPONENTE
                        , :OLD.ID_UBICAZIONE_UNITA
                        , :NEW.ID_UBICAZIONE_COMPONENTE
                        , :NEW.ID_COMPONENTE
                        , :NEW.ID_UBICAZIONE_UNITA );
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


