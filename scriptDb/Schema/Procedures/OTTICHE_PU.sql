CREATE OR REPLACE procedure OTTICHE_PU
/******************************************************************************
 NOME:        OTTICHE_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table OTTICHE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger OTTICHE_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_ottica IN varchar
, old_amministrazione IN varchar
, old_ottica_origine IN varchar
, new_ottica IN varchar
, new_amministrazione IN varchar
, new_ottica_origine IN varchar )
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
   cursor cpk1_ottiche(var_ottica_origine varchar) is
      select 1
        from OTTICHE
       where OTTICA = var_ottica_origine
         and var_ottica_origine is not null
         ;
   --  Declaration of UpdateChildParentExist constraint for the parent "AMMINISTRAZIONI"
   cursor cpk2_ottiche(var_amministrazione varchar) is
      select 1
        from AMMINISTRAZIONI
       where CODICE_AMMINISTRAZIONE = var_amministrazione
         and var_amministrazione is not null
         ;
   --  Declaration of UpdateParentRestrict constraint for "ANAGRAFE_UNITA_ORGANIZZATIVE"
   cursor cfk2_anagrafe_unita_organizza(var_ottica varchar) is
      select 1
        from ANAGRAFE_UNITA_ORGANIZZATIVE
       where OTTICA = var_ottica
         and var_ottica is not null
         ;
   --  Declaration of UpdateParentRestrict constraint for "UNITA_ORGANIZZATIVE"
   cursor cfk3_unita_organizzative(var_ottica varchar) is
      select 1
        from UNITA_ORGANIZZATIVE
       where OTTICA = var_ottica
         and var_ottica is not null
         ;
   --  Declaration of UpdateParentRestrict constraint for "REVISIONI_STRUTTURA"
   cursor cfk4_revisioni_struttura(var_ottica varchar) is
      select 1
        from REVISIONI_STRUTTURA
       where OTTICA = var_ottica
         and var_ottica is not null
         ;
   --  Declaration of UpdateParentRestrict constraint for "SUDDIVISIONI_STRUTTURA"
   cursor cfk5_suddivisioni_struttura(var_ottica varchar) is
      select 1
        from SUDDIVISIONI_STRUTTURA
       where OTTICA = var_ottica
         and var_ottica is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "OTTICHE" deve esistere quando si modifica "OTTICHE"
      
         if  NEW_OTTICA_ORIGINE is not null and ( seq = 0 )
         then
            open  cpk1_ottiche(NEW_OTTICA_ORIGINE);
            fetch cpk1_ottiche into dummy;
            found := cpk1_ottiche%FOUND; /* %FOUND */
            close cpk1_ottiche;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Ottiche. La registrazione Ottiche non e'' modificabile. (OTTICHE.OTTI_OTTI_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "AMMINISTRAZIONI" deve esistere quando si modifica "OTTICHE"
      
         if  NEW_AMMINISTRAZIONE is not null and ( seq = 0 )
         then
            open  cpk2_ottiche(NEW_AMMINISTRAZIONE);
            fetch cpk2_ottiche into dummy;
            found := cpk2_ottiche%FOUND; /* %FOUND */
            close cpk2_ottiche;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Amministrazioni. La registrazione Ottiche non e'' modificabile. (OTTICHE.OTTI_AMMI_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      --  Chiave di "OTTICHE" non modificabile se esistono referenze su "ANAGRAFE_UNITA_ORGANIZZATIVE"
      if NEW_OTTICA != OLD_OTTICA
      then
         open  cfk2_anagrafe_unita_organizza(OLD_OTTICA);
         fetch cfk2_anagrafe_unita_organizza into dummy;
         found := cfk2_anagrafe_unita_organizza%FOUND; /* %FOUND */
         close cfk2_anagrafe_unita_organizza;
         if found then
            errno  := -20005;
            errmsg := 'Esistono riferimenti su Anagrafe unita organizzative. La registrazione di Ottiche non e'' modificabile. (ANAGRAFE_UNITA_ORGANIZZATIVE.ANUO_OTTI_FK)';
            raise integrity_error;
         end if;
      end if;
      --  Chiave di "OTTICHE" non modificabile se esistono referenze su "UNITA_ORGANIZZATIVE"
      if NEW_OTTICA != OLD_OTTICA
      then
         open  cfk3_unita_organizzative(OLD_OTTICA);
         fetch cfk3_unita_organizzative into dummy;
         found := cfk3_unita_organizzative%FOUND; /* %FOUND */
         close cfk3_unita_organizzative;
         if found then
            errno  := -20005;
            errmsg := 'Esistono riferimenti su Unita Organizzative. La registrazione di Ottiche non e'' modificabile. (UNITA_ORGANIZZATIVE.UNOR_OTTI_FK)';
            raise integrity_error;
         end if;
      end if;
      --  Chiave di "OTTICHE" non modificabile se esistono referenze su "REVISIONI_STRUTTURA"
      if NEW_OTTICA != OLD_OTTICA
      then
         open  cfk4_revisioni_struttura(OLD_OTTICA);
         fetch cfk4_revisioni_struttura into dummy;
         found := cfk4_revisioni_struttura%FOUND; /* %FOUND */
         close cfk4_revisioni_struttura;
         if found then
            errno  := -20005;
            errmsg := 'Esistono riferimenti su Revisioni Struttura. La registrazione di Ottiche non e'' modificabile. (REVISIONI_STRUTTURA.REST_OTTI_FK)';
            raise integrity_error;
         end if;
      end if;
      --  Chiave di "OTTICHE" non modificabile se esistono referenze su "SUDDIVISIONI_STRUTTURA"
      if NEW_OTTICA != OLD_OTTICA
      then
         open  cfk5_suddivisioni_struttura(OLD_OTTICA);
         fetch cfk5_suddivisioni_struttura into dummy;
         found := cfk5_suddivisioni_struttura%FOUND; /* %FOUND */
         close cfk5_suddivisioni_struttura;
         if found then
            errno  := -20005;
            errmsg := 'Esistono riferimenti su Suddivisioni Struttura. La registrazione di Ottiche non e'' modificabile. (SUDDIVISIONI_STRUTTURA.SUST_OTTI_FK)';
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

