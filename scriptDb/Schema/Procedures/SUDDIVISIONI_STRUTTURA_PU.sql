CREATE OR REPLACE procedure SUDDIVISIONI_STRUTTURA_PU
/******************************************************************************
 NOME:        SUDDIVISIONI_STRUTTURA_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table SUDDIVISIONI_STRUTTURA
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger SUDDIVISIONI_STRUTTURA_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_id_suddivisione IN number
, old_ottica IN varchar
, new_id_suddivisione IN number
, new_ottica IN varchar )
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
   cursor cpk1_suddivisioni_struttura(var_ottica varchar) is
      select 1
        from OTTICHE
       where OTTICA = var_ottica
         and var_ottica is not null
         ;
   --  Declaration of UpdateParentRestrict constraint for "ANAGRAFE_UNITA_ORGANIZZATIVE"
   cursor cfk1_anagrafe_unita_organizza(var_id_suddivisione number) is
      select 1
        from ANAGRAFE_UNITA_ORGANIZZATIVE
       where ID_SUDDIVISIONE = var_id_suddivisione
         and var_id_suddivisione is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "OTTICHE" deve esistere quando si modifica "SUDDIVISIONI_STRUTTURA"
      
         if  NEW_OTTICA is not null and ( seq = 0 )
         then
            open  cpk1_suddivisioni_struttura(NEW_OTTICA);
            fetch cpk1_suddivisioni_struttura into dummy;
            found := cpk1_suddivisioni_struttura%FOUND; /* %FOUND */
            close cpk1_suddivisioni_struttura;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Ottiche. La registrazione Suddivisioni Struttura non e'' modificabile. (SUDDIVISIONI_STRUTTURA.SUST_OTTI_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      --  Chiave di "SUDDIVISIONI_STRUTTURA" non modificabile se esistono referenze su "ANAGRAFE_UNITA_ORGANIZZATIVE"
      if NEW_ID_SUDDIVISIONE != OLD_ID_SUDDIVISIONE
      then
         open  cfk1_anagrafe_unita_organizza(OLD_ID_SUDDIVISIONE);
         fetch cfk1_anagrafe_unita_organizza into dummy;
         found := cfk1_anagrafe_unita_organizza%FOUND; /* %FOUND */
         close cfk1_anagrafe_unita_organizza;
         if found then
            errno  := -20005;
            errmsg := 'Esistono riferimenti su Anagrafe unita organizzative. La registrazione di Suddivisioni Struttura non e'' modificabile. (ANAGRAFE_UNITA_ORGANIZZATIVE.ANUO_SUST_FK)';
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

