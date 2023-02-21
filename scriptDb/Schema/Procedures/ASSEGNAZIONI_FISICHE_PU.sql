CREATE OR REPLACE procedure ASSEGNAZIONI_FISICHE_PU
/******************************************************************************
 NOME:        ASSEGNAZIONI_FISICHE_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table ASSEGNAZIONI_FISICHE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger ASSEGNAZIONI_FISICHE_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_id_asfi IN number
, old_id_ubicazione_componente IN number
, old_ni IN number
, old_progr_unita_fisica IN number
, old_progr_unita_organizzativa IN number
, new_id_asfi IN number
, new_id_ubicazione_componente IN number
, new_ni IN number
, new_progr_unita_fisica IN number
, new_progr_unita_organizzativa IN number )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of UpdateChildParentExist constraint for the parent "ANAGRAFE_UNITA_FISICHE"
   cursor cpk1_assegnazioni_fisiche(var_progr_unita_fisica number) is
      select 1
        from ANAGRAFE_UNITA_FISICHE
       where PROGR_UNITA_FISICA = var_progr_unita_fisica
         and var_progr_unita_fisica is not null
         ;
   --  Declaration of UpdateChildParentExist constraint for the parent "UBICAZIONI_COMPONENTE"
   cursor cpk2_assegnazioni_fisiche(var_id_ubicazione_componente number) is
      select 1
        from UBICAZIONI_COMPONENTE
       where ID_UBICAZIONE_COMPONENTE = var_id_ubicazione_componente
         and var_id_ubicazione_componente is not null
         ;
   --  Declaration of UpdateChildParentExist constraint for the parent "ANAGRAFE_UNITA_ORGANIZZATIVE"
   cursor cpk3_assegnazioni_fisiche(var_progr_unita_organizzativa number) is
      select 1
        from ANAGRAFE_UNITA_ORGANIZZATIVE
       where PROGR_UNITA_ORGANIZZATIVA = var_progr_unita_organizzativa
         and var_progr_unita_organizzativa is not null
         ;
   --  Declaration of UpdateChildParentExist constraint for the parent "ANAGRAFE_SOGGETTI"
   cursor cpk4_assegnazioni_fisiche(var_ni number) is
      select 1
        from ANAGRAFE_SOGGETTI
       where NI = var_ni
         and var_ni is not null
         ;
   --  Declaration of UpdateParentRestrict constraint for "ATTRIBUTI_ASSEGNAZIONE_FISICA"
   cursor cfk1_attributi_assegnazione_f(var_id_asfi number) is
      select 1
        from ATTRIBUTI_ASSEGNAZIONE_FISICA
       where ID_ASFI = var_id_asfi
         and var_id_asfi is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "ANAGRAFE_UNITA_FISICHE" deve esistere quando si modifica "ASSEGNAZIONI_FISICHE"
      
         if  NEW_PROGR_UNITA_FISICA is not null and ( seq = 0 )
         then
            open  cpk1_assegnazioni_fisiche(NEW_PROGR_UNITA_FISICA);
            fetch cpk1_assegnazioni_fisiche into dummy;
            found := cpk1_assegnazioni_fisiche%FOUND; /* %FOUND */
            close cpk1_assegnazioni_fisiche;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Anagrafe unita fisiche. La registrazione Assegnazioni fisiche non e'' modificabile. (ASSEGNAZIONI_FISICHE.ASFI_ANUF_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "UBICAZIONI_COMPONENTE" deve esistere quando si modifica "ASSEGNAZIONI_FISICHE"
      
         if  NEW_ID_UBICAZIONE_COMPONENTE is not null and ( seq = 0 )
         then
            open  cpk2_assegnazioni_fisiche(NEW_ID_UBICAZIONE_COMPONENTE);
            fetch cpk2_assegnazioni_fisiche into dummy;
            found := cpk2_assegnazioni_fisiche%FOUND; /* %FOUND */
            close cpk2_assegnazioni_fisiche;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Ubicazioni componente. La registrazione Assegnazioni fisiche non e'' modificabile. (ASSEGNAZIONI_FISICHE.ASFI_UBCO_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "ANAGRAFE_UNITA_ORGANIZZATIVE" deve esistere quando si modifica "ASSEGNAZIONI_FISICHE"
      
         if  NEW_PROGR_UNITA_ORGANIZZATIVA is not null and ( seq = 0 )
         then
            open  cpk3_assegnazioni_fisiche(NEW_PROGR_UNITA_ORGANIZZATIVA);
            fetch cpk3_assegnazioni_fisiche into dummy;
            found := cpk3_assegnazioni_fisiche%FOUND; /* %FOUND */
            close cpk3_assegnazioni_fisiche;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Anagrafe unita organizzative. La registrazione Assegnazioni fisiche non e'' modificabile. (ASSEGNAZIONI_FISICHE.ASFI_ANUO_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "ANAGRAFE_SOGGETTI" deve esistere quando si modifica "ASSEGNAZIONI_FISICHE"
      
         if  NEW_NI is not null and ( seq = 0 )
         then
            open  cpk4_assegnazioni_fisiche(NEW_NI);
            fetch cpk4_assegnazioni_fisiche into dummy;
            found := cpk4_assegnazioni_fisiche%FOUND; /* %FOUND */
            close cpk4_assegnazioni_fisiche;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Anagrafe Soggetti. La registrazione Assegnazioni fisiche non e'' modificabile. (ASSEGNAZIONI_FISICHE.ASFI_SOGG_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      --  Chiave di "ASSEGNAZIONI_FISICHE" non modificabile se esistono referenze su "ATTRIBUTI_ASSEGNAZIONE_FISICA"
      if NEW_ID_ASFI != OLD_ID_ASFI
      then
         open  cfk1_attributi_assegnazione_f(OLD_ID_ASFI);
         fetch cfk1_attributi_assegnazione_f into dummy;
         found := cfk1_attributi_assegnazione_f%FOUND; /* %FOUND */
         close cfk1_attributi_assegnazione_f;
         if found then
            errno  := -20005;
            errmsg := 'Esistono riferimenti su Attributi assegnazione fisica. La registrazione di Assegnazioni fisiche non e'' modificabile. (ATTRIBUTI_ASSEGNAZIONE_FISICA.ATAF_ASFI_FK)';
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

