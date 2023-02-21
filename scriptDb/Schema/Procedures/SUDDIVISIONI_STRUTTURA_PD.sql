CREATE OR REPLACE procedure SUDDIVISIONI_STRUTTURA_PD
/******************************************************************************
 NOME:        SUDDIVISIONI_STRUTTURA_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table SUDDIVISIONI_STRUTTURA
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger SUDDIVISIONI_STRUTTURA_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_id_suddivisione IN number
, old_ottica IN varchar )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "ANAGRAFE_UNITA_ORGANIZZATIVE"
   cursor cfk1_anagrafe_unita_organizza(var_id_suddivisione number) is
      select 1
        from ANAGRAFE_UNITA_ORGANIZZATIVE
       where ID_SUDDIVISIONE = var_id_suddivisione
         and var_id_suddivisione is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "SUDDIVISIONI_STRUTTURA" if children still exist in "ANAGRAFE_UNITA_ORGANIZZATIVE"
      open  cfk1_anagrafe_unita_organizza(OLD_ID_SUDDIVISIONE);
      fetch cfk1_anagrafe_unita_organizza into dummy;
      found := cfk1_anagrafe_unita_organizza%FOUND; /* %FOUND */
      close cfk1_anagrafe_unita_organizza;
      if found
      then
         errno  := -20006;
         errmsg := 'Esistono riferimenti su Anagrafe unita organizzative. La registrazione di Suddivisioni Struttura non e'' eliminabile. (ANAGRAFE_UNITA_ORGANIZZATIVE.ANUO_SUST_FK)';
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

