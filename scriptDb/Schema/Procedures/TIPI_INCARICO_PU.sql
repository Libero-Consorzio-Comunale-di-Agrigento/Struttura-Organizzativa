CREATE OR REPLACE procedure TIPI_INCARICO_PU
/******************************************************************************
 NOME:        TIPI_INCARICO_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table TIPI_INCARICO
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger TIPI_INCARICO_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_incarico IN varchar
, old_tipo_incarico IN varchar
, new_incarico IN varchar
, new_tipo_incarico IN varchar )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of UpdateParentRestrict constraint for "ATTRIBUTI_COMPONENTE"
   cursor cfk1_attributi_componente(var_incarico varchar) is
      select 1
        from ATTRIBUTI_COMPONENTE
       where INCARICO = var_incarico
         and var_incarico is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Colonna "TIPO_INCARICO" non modificabile
      if OLD_TIPO_INCARICO != NEW_TIPO_INCARICO then
         if IntegrityPackage.GetNestLevel = 0 then
            errno  := -20001;
            errmsg := 'L''informazione Tipo Incarico non puo'' essere modificata.';
            raise integrity_error;
         end if;
      end if;
      --  Chiave di "TIPI_INCARICO" non modificabile se esistono referenze su "ATTRIBUTI_COMPONENTE"
      if NEW_INCARICO != OLD_INCARICO
      then
         open  cfk1_attributi_componente(OLD_INCARICO);
         fetch cfk1_attributi_componente into dummy;
         found := cfk1_attributi_componente%FOUND; /* %FOUND */
         close cfk1_attributi_componente;
         if found then
            errno  := -20005;
            errmsg := 'Esistono riferimenti su Attributi componente. La registrazione di Tipi Incarico non e'' modificabile. (ATTRIBUTI_COMPONENTE.ATCO_TIIN_FK)';
            raise integrity_error;
         end if;
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

