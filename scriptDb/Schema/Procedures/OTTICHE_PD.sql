CREATE OR REPLACE procedure OTTICHE_PD
/******************************************************************************
 NOME:        OTTICHE_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table OTTICHE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger OTTICHE_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_ottica IN varchar
, old_amministrazione IN varchar
, old_ottica_origine IN varchar )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "ANAGRAFE_UNITA_ORGANIZZATIVE"
   cursor cfk2_anagrafe_unita_organizza(var_ottica varchar) is
      select 1
        from ANAGRAFE_UNITA_ORGANIZZATIVE
       where OTTICA = var_ottica
         and var_ottica is not null
         ;
   --  Declaration of DeleteParentRestrict constraint for "UNITA_ORGANIZZATIVE"
   cursor cfk3_unita_organizzative(var_ottica varchar) is
      select 1
        from UNITA_ORGANIZZATIVE
       where OTTICA = var_ottica
         and var_ottica is not null
         ;
   --  Declaration of DeleteParentRestrict constraint for "REVISIONI_STRUTTURA"
   cursor cfk4_revisioni_struttura(var_ottica varchar) is
      select 1
        from REVISIONI_STRUTTURA
       where OTTICA = var_ottica
         and var_ottica is not null
         ;
   --  Declaration of DeleteParentRestrict constraint for "SUDDIVISIONI_STRUTTURA"
   cursor cfk5_suddivisioni_struttura(var_ottica varchar) is
      select 1
        from SUDDIVISIONI_STRUTTURA
       where OTTICA = var_ottica
         and var_ottica is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "OTTICHE" if children still exist in "ANAGRAFE_UNITA_ORGANIZZATIVE"
      open  cfk2_anagrafe_unita_organizza(OLD_OTTICA);
      fetch cfk2_anagrafe_unita_organizza into dummy;
      found := cfk2_anagrafe_unita_organizza%FOUND; /* %FOUND */
      close cfk2_anagrafe_unita_organizza;
      if found
      then
         errno  := -20006;
         errmsg := 'Esistono riferimenti su Anagrafe unita organizzative. La registrazione di Ottiche non e'' eliminabile. (ANAGRAFE_UNITA_ORGANIZZATIVE.ANUO_OTTI_FK)';
         raise integrity_error;
      end if;
      --  Cannot delete parent "OTTICHE" if children still exist in "UNITA_ORGANIZZATIVE"
      open  cfk3_unita_organizzative(OLD_OTTICA);
      fetch cfk3_unita_organizzative into dummy;
      found := cfk3_unita_organizzative%FOUND; /* %FOUND */
      close cfk3_unita_organizzative;
      if found
      then
         errno  := -20006;
         errmsg := 'Esistono riferimenti su Unita Organizzative. La registrazione di Ottiche non e'' eliminabile. (UNITA_ORGANIZZATIVE.UNOR_OTTI_FK)';
         raise integrity_error;
      end if;
      --  Cannot delete parent "OTTICHE" if children still exist in "REVISIONI_STRUTTURA"
      open  cfk4_revisioni_struttura(OLD_OTTICA);
      fetch cfk4_revisioni_struttura into dummy;
      found := cfk4_revisioni_struttura%FOUND; /* %FOUND */
      close cfk4_revisioni_struttura;
      if found
      then
         errno  := -20006;
         errmsg := 'Esistono riferimenti su Revisioni Struttura. La registrazione di Ottiche non e'' eliminabile. (REVISIONI_STRUTTURA.REST_OTTI_FK)';
         raise integrity_error;
      end if;
      --  Cannot delete parent "OTTICHE" if children still exist in "SUDDIVISIONI_STRUTTURA"
      open  cfk5_suddivisioni_struttura(OLD_OTTICA);
      fetch cfk5_suddivisioni_struttura into dummy;
      found := cfk5_suddivisioni_struttura%FOUND; /* %FOUND */
      close cfk5_suddivisioni_struttura;
      if found
      then
         errno  := -20006;
         errmsg := 'Esistono riferimenti su Suddivisioni Struttura. La registrazione di Ottiche non e'' eliminabile. (SUDDIVISIONI_STRUTTURA.SUST_OTTI_FK)';
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

