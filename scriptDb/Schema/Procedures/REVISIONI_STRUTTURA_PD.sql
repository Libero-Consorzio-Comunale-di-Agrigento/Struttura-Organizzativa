CREATE OR REPLACE procedure REVISIONI_STRUTTURA_PD
/******************************************************************************
 NOME:        REVISIONI_STRUTTURA_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table REVISIONI_STRUTTURA
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger REVISIONI_STRUTTURA_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_ottica IN varchar
, old_revisione IN number )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "UNITA_ORGANIZZATIVE"
   cursor cfk1_unita_organizzative(var_ottica varchar,
                   var_revisione number) is
      select 1
        from UNITA_ORGANIZZATIVE
       where OTTICA = var_ottica
         and REVISIONE_CESSAZIONE = var_revisione
         and var_ottica is not null
         and var_revisione is not null
         ;
   --  Declaration of DeleteParentRestrict constraint for "ANAGRAFE_UNITA_ORGANIZZATIVE"
   cursor cfk2_anagrafe_unita_organizza(var_ottica varchar,
                   var_revisione number) is
      select 1
        from ANAGRAFE_UNITA_ORGANIZZATIVE
       where OTTICA = var_ottica
         and REVISIONE_ISTITUZIONE = var_revisione
         and var_ottica is not null
         and var_revisione is not null
         ;
   --  Declaration of DeleteParentRestrict constraint for "ANAGRAFE_UNITA_ORGANIZZATIVE"
   cursor cfk3_anagrafe_unita_organizza(var_ottica varchar,
                   var_revisione number) is
      select 1
        from ANAGRAFE_UNITA_ORGANIZZATIVE
       where OTTICA = var_ottica
         and REVISIONE_CESSAZIONE = var_revisione
         and var_ottica is not null
         and var_revisione is not null
         ;
   --  Declaration of DeleteParentRestrict constraint for "COMPONENTI"
   cursor cfk4_componenti(var_ottica varchar,
                   var_revisione number) is
      select 1
        from COMPONENTI
       where OTTICA = var_ottica
         and REVISIONE_ASSEGNAZIONE = var_revisione
         and var_ottica is not null
         and var_revisione is not null
         ;
   --  Declaration of DeleteParentRestrict constraint for "COMPONENTI"
   cursor cfk5_componenti(var_ottica varchar,
                   var_revisione number) is
      select 1
        from COMPONENTI
       where OTTICA = var_ottica
         and REVISIONE_CESSAZIONE = var_revisione
         and var_ottica is not null
         and var_revisione is not null
         ;
   --  Declaration of DeleteParentRestrict constraint for "UNITA_ORGANIZZATIVE"
   cursor cfk6_unita_organizzative(var_ottica varchar,
                   var_revisione number) is
      select 1
        from UNITA_ORGANIZZATIVE
       where OTTICA = var_ottica
         and REVISIONE = var_revisione
         and var_ottica is not null
         and var_revisione is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "REVISIONI_STRUTTURA" if children still exist in "UNITA_ORGANIZZATIVE"
      open  cfk1_unita_organizzative(OLD_OTTICA,
                     OLD_REVISIONE);
      fetch cfk1_unita_organizzative into dummy;
      found := cfk1_unita_organizzative%FOUND; /* %FOUND */
      close cfk1_unita_organizzative;
      if found
      then
         errno  := -20006;
         errmsg := 'Esistono riferimenti su Unita Organizzative. La registrazione di Revisioni Struttura non e'' eliminabile. (UNITA_ORGANIZZATIVE.UNOR_REST_2_FK)';
         raise integrity_error;
      end if;
      --  Cannot delete parent "REVISIONI_STRUTTURA" if children still exist in "ANAGRAFE_UNITA_ORGANIZZATIVE"
      open  cfk2_anagrafe_unita_organizza(OLD_OTTICA,
                     OLD_REVISIONE);
      fetch cfk2_anagrafe_unita_organizza into dummy;
      found := cfk2_anagrafe_unita_organizza%FOUND; /* %FOUND */
      close cfk2_anagrafe_unita_organizza;
      if found
      then
         errno  := -20006;
         errmsg := 'Esistono riferimenti su Anagrafe unita organizzative. La registrazione di Revisioni Struttura non e'' eliminabile. (ANAGRAFE_UNITA_ORGANIZZATIVE.ANUO_REST_FK)';
         raise integrity_error;
      end if;
      --  Cannot delete parent "REVISIONI_STRUTTURA" if children still exist in "ANAGRAFE_UNITA_ORGANIZZATIVE"
      open  cfk3_anagrafe_unita_organizza(OLD_OTTICA,
                     OLD_REVISIONE);
      fetch cfk3_anagrafe_unita_organizza into dummy;
      found := cfk3_anagrafe_unita_organizza%FOUND; /* %FOUND */
      close cfk3_anagrafe_unita_organizza;
      if found
      then
         errno  := -20006;
         errmsg := 'Esistono riferimenti su Anagrafe unita organizzative. La registrazione di Revisioni Struttura non e'' eliminabile. (ANAGRAFE_UNITA_ORGANIZZATIVE.ANUO_REST_2_FK)';
         raise integrity_error;
      end if;
      --  Cannot delete parent "REVISIONI_STRUTTURA" if children still exist in "COMPONENTI"
      open  cfk4_componenti(OLD_OTTICA,
                     OLD_REVISIONE);
      fetch cfk4_componenti into dummy;
      found := cfk4_componenti%FOUND; /* %FOUND */
      close cfk4_componenti;
      if found
      then
         errno  := -20006;
         errmsg := 'Esistono riferimenti su Componenti. La registrazione di Revisioni Struttura non e'' eliminabile. (COMPONENTI.COMP_REST_FK)';
         raise integrity_error;
      end if;
      --  Cannot delete parent "REVISIONI_STRUTTURA" if children still exist in "COMPONENTI"
      open  cfk5_componenti(OLD_OTTICA,
                     OLD_REVISIONE);
      fetch cfk5_componenti into dummy;
      found := cfk5_componenti%FOUND; /* %FOUND */
      close cfk5_componenti;
      if found
      then
         errno  := -20006;
         errmsg := 'Esistono riferimenti su Componenti. La registrazione di Revisioni Struttura non e'' eliminabile. (COMPONENTI.COMP_REST_2_FK)';
         raise integrity_error;
      end if;
      --  Cannot delete parent "REVISIONI_STRUTTURA" if children still exist in "UNITA_ORGANIZZATIVE"
      open  cfk6_unita_organizzative(OLD_OTTICA,
                     OLD_REVISIONE);
      fetch cfk6_unita_organizzative into dummy;
      found := cfk6_unita_organizzative%FOUND; /* %FOUND */
      close cfk6_unita_organizzative;
      if found
      then
         errno  := -20006;
         errmsg := 'Esistono riferimenti su Unita Organizzative. La registrazione di Revisioni Struttura non e'' eliminabile. (UNITA_ORGANIZZATIVE.UNOR_REST_FK)';
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

