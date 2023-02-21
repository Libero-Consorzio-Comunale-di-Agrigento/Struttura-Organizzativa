CREATE OR REPLACE procedure TIPI_INCARICO_PD
/******************************************************************************
 NOME:        TIPI_INCARICO_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table TIPI_INCARICO
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger TIPI_INCARICO_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_incarico IN varchar
, old_tipo_incarico IN varchar )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "ATTRIBUTI_COMPONENTE"
   cursor cfk1_attributi_componente(var_incarico varchar) is
      select 1
        from ATTRIBUTI_COMPONENTE
       where INCARICO = var_incarico
         and var_incarico is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "TIPI_INCARICO" if children still exist in "ATTRIBUTI_COMPONENTE"
      open  cfk1_attributi_componente(OLD_INCARICO);
      fetch cfk1_attributi_componente into dummy;
      found := cfk1_attributi_componente%FOUND; /* %FOUND */
      close cfk1_attributi_componente;
      if found
      then
         errno  := -20006;
         errmsg := 'Esistono riferimenti su Attributi componente. La registrazione di Tipi Incarico non e'' eliminabile. (ATTRIBUTI_COMPONENTE.ATCO_TIIN_FK)';
         raise integrity_error;
      end if;
      null;
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

