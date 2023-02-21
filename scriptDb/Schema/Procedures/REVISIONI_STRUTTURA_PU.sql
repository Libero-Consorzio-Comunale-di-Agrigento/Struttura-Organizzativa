CREATE OR REPLACE procedure REVISIONI_STRUTTURA_PU
/******************************************************************************
 NOME:        REVISIONI_STRUTTURA_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table REVISIONI_STRUTTURA
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger REVISIONI_STRUTTURA_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_ottica IN varchar
, old_revisione IN number
, new_ottica IN varchar
, new_revisione IN number )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of UpdateChildParentExist constraint for the parent "OTTICHE"
   cursor cpk1_revisioni_struttura(var_ottica varchar) is
      select 1
        from OTTICHE
       where OTTICA = var_ottica
         and var_ottica is not null
         ;
   --  Declaration of UpdateParentRestrict constraint for "UNITA_ORGANIZZATIVE"
   cursor cfk1_unita_organizzative(var_ottica varchar,
                   var_revisione number) is
      select 1
        from UNITA_ORGANIZZATIVE
       where OTTICA = var_ottica
         and REVISIONE_CESSAZIONE = var_revisione
         and var_ottica is not null
         and var_revisione is not null
         ;
   --  Declaration of UpdateParentRestrict constraint for "ANAGRAFE_UNITA_ORGANIZZATIVE"
   cursor cfk2_anagrafe_unita_organizza(var_ottica varchar,
                   var_revisione number) is
      select 1
        from ANAGRAFE_UNITA_ORGANIZZATIVE
       where OTTICA = var_ottica
         and REVISIONE_ISTITUZIONE = var_revisione
         and var_ottica is not null
         and var_revisione is not null
         ;
   --  Declaration of UpdateParentRestrict constraint for "ANAGRAFE_UNITA_ORGANIZZATIVE"
   cursor cfk3_anagrafe_unita_organizza(var_ottica varchar,
                   var_revisione number) is
      select 1
        from ANAGRAFE_UNITA_ORGANIZZATIVE
       where OTTICA = var_ottica
         and REVISIONE_CESSAZIONE = var_revisione
         and var_ottica is not null
         and var_revisione is not null
         ;
   --  Declaration of UpdateParentRestrict constraint for "COMPONENTI"
   cursor cfk4_componenti(var_ottica varchar,
                   var_revisione number) is
      select 1
        from COMPONENTI
       where OTTICA = var_ottica
         and REVISIONE_ASSEGNAZIONE = var_revisione
         and var_ottica is not null
         and var_revisione is not null
         ;
   --  Declaration of UpdateParentRestrict constraint for "COMPONENTI"
   cursor cfk5_componenti(var_ottica varchar,
                   var_revisione number) is
      select 1
        from COMPONENTI
       where OTTICA = var_ottica
         and REVISIONE_CESSAZIONE = var_revisione
         and var_ottica is not null
         and var_revisione is not null
         ;
   --  Declaration of UpdateParentRestrict constraint for "UNITA_ORGANIZZATIVE"
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
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "OTTICHE" deve esistere quando si modifica "REVISIONI_STRUTTURA"
      
         if  NEW_OTTICA is not null and ( seq = 0 )
         then
            open  cpk1_revisioni_struttura(NEW_OTTICA);
            fetch cpk1_revisioni_struttura into dummy;
            found := cpk1_revisioni_struttura%FOUND; /* %FOUND */
            close cpk1_revisioni_struttura;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Ottiche. La registrazione Revisioni Struttura non e'' modificabile. (REVISIONI_STRUTTURA.REST_OTTI_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      --  Chiave di "REVISIONI_STRUTTURA" non modificabile se esistono referenze su "UNITA_ORGANIZZATIVE"
      if NEW_OTTICA != OLD_OTTICA
      or NEW_REVISIONE != OLD_REVISIONE
      then
         open  cfk1_unita_organizzative(OLD_OTTICA,
                        OLD_REVISIONE);
         fetch cfk1_unita_organizzative into dummy;
         found := cfk1_unita_organizzative%FOUND; /* %FOUND */
         close cfk1_unita_organizzative;
         if found then
            errno  := -20005;
            errmsg := 'Esistono riferimenti su Unita Organizzative. La registrazione di Revisioni Struttura non e'' modificabile. (UNITA_ORGANIZZATIVE.UNOR_REST_2_FK)';
            raise integrity_error;
         end if;
      end if;
      --  Chiave di "REVISIONI_STRUTTURA" non modificabile se esistono referenze su "ANAGRAFE_UNITA_ORGANIZZATIVE"
      if NEW_OTTICA != OLD_OTTICA
      or NEW_REVISIONE != OLD_REVISIONE
      then
         open  cfk2_anagrafe_unita_organizza(OLD_OTTICA,
                        OLD_REVISIONE);
         fetch cfk2_anagrafe_unita_organizza into dummy;
         found := cfk2_anagrafe_unita_organizza%FOUND; /* %FOUND */
         close cfk2_anagrafe_unita_organizza;
         if found then
            errno  := -20005;
            errmsg := 'Esistono riferimenti su Anagrafe unita organizzative. La registrazione di Revisioni Struttura non e'' modificabile. (ANAGRAFE_UNITA_ORGANIZZATIVE.ANUO_REST_FK)';
            raise integrity_error;
         end if;
      end if;
      --  Chiave di "REVISIONI_STRUTTURA" non modificabile se esistono referenze su "ANAGRAFE_UNITA_ORGANIZZATIVE"
      if NEW_OTTICA != OLD_OTTICA
      or NEW_REVISIONE != OLD_REVISIONE
      then
         open  cfk3_anagrafe_unita_organizza(OLD_OTTICA,
                        OLD_REVISIONE);
         fetch cfk3_anagrafe_unita_organizza into dummy;
         found := cfk3_anagrafe_unita_organizza%FOUND; /* %FOUND */
         close cfk3_anagrafe_unita_organizza;
         if found then
            errno  := -20005;
            errmsg := 'Esistono riferimenti su Anagrafe unita organizzative. La registrazione di Revisioni Struttura non e'' modificabile. (ANAGRAFE_UNITA_ORGANIZZATIVE.ANUO_REST_2_FK)';
            raise integrity_error;
         end if;
      end if;
      --  Chiave di "REVISIONI_STRUTTURA" non modificabile se esistono referenze su "COMPONENTI"
      if NEW_OTTICA != OLD_OTTICA
      or NEW_REVISIONE != OLD_REVISIONE
      then
         open  cfk4_componenti(OLD_OTTICA,
                        OLD_REVISIONE);
         fetch cfk4_componenti into dummy;
         found := cfk4_componenti%FOUND; /* %FOUND */
         close cfk4_componenti;
         if found then
            errno  := -20005;
            errmsg := 'Esistono riferimenti su Componenti. La registrazione di Revisioni Struttura non e'' modificabile. (COMPONENTI.COMP_REST_FK)';
            raise integrity_error;
         end if;
      end if;
      --  Chiave di "REVISIONI_STRUTTURA" non modificabile se esistono referenze su "COMPONENTI"
      if NEW_OTTICA != OLD_OTTICA
      or NEW_REVISIONE != OLD_REVISIONE
      then
         open  cfk5_componenti(OLD_OTTICA,
                        OLD_REVISIONE);
         fetch cfk5_componenti into dummy;
         found := cfk5_componenti%FOUND; /* %FOUND */
         close cfk5_componenti;
         if found then
            errno  := -20005;
            errmsg := 'Esistono riferimenti su Componenti. La registrazione di Revisioni Struttura non e'' modificabile. (COMPONENTI.COMP_REST_2_FK)';
            raise integrity_error;
         end if;
      end if;
      --  Chiave di "REVISIONI_STRUTTURA" non modificabile se esistono referenze su "UNITA_ORGANIZZATIVE"
      if NEW_OTTICA != OLD_OTTICA
      or NEW_REVISIONE != OLD_REVISIONE
      then
         open  cfk6_unita_organizzative(OLD_OTTICA,
                        OLD_REVISIONE);
         fetch cfk6_unita_organizzative into dummy;
         found := cfk6_unita_organizzative%FOUND; /* %FOUND */
         close cfk6_unita_organizzative;
         if found then
            errno  := -20005;
            errmsg := 'Esistono riferimenti su Unita Organizzative. La registrazione di Revisioni Struttura non e'' modificabile. (UNITA_ORGANIZZATIVE.UNOR_REST_FK)';
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

