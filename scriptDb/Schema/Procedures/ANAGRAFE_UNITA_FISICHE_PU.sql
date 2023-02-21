CREATE OR REPLACE procedure ANAGRAFE_UNITA_FISICHE_PU
/******************************************************************************
 NOME:        ANAGRAFE_UNITA_FISICHE_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table ANAGRAFE_UNITA_FISICHE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger ANAGRAFE_UNITA_FISICHE_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_progr_unita_fisica IN number
, old_dal IN date
, old_id_suddivisione IN number
, new_progr_unita_fisica IN number
, new_dal IN date
, new_id_suddivisione IN number )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of UpdateChildParentExist constraint for the parent "SUDDIVISIONI_FISICHE"
   cursor cpk1_anagrafe_unita_fisiche(var_id_suddivisione number) is
      select 1
        from SUDDIVISIONI_FISICHE
       where ID_SUDDIVISIONE = var_id_suddivisione
         and var_id_suddivisione is not null
         ;
   --  Declaration of UpdateParentRestrict constraint for "UBICAZIONI_UNITA"
   cursor cfk1_ubicazioni_unita(var_progr_unita_fisica number) is
      select 1
        from UBICAZIONI_UNITA
       where PROGR_UNITA_FISICA = var_progr_unita_fisica
         and var_progr_unita_fisica is not null
         ;
   --  Declaration of UpdateParentRestrict constraint for "UNITA_FISICHE"
   cursor cfk2_unita_fisiche(var_progr_unita_fisica number) is
      select 1
        from UNITA_FISICHE
       where PROGR_UNITA_FISICA = var_progr_unita_fisica
         and var_progr_unita_fisica is not null
         ;
   --  Declaration of UpdateParentRestrict constraint for "ASSEGNAZIONI_FISICHE"
   cursor cfk3_assegnazioni_fisiche(var_progr_unita_fisica number) is
      select 1
        from ASSEGNAZIONI_FISICHE
       where PROGR_UNITA_FISICA = var_progr_unita_fisica
         and var_progr_unita_fisica is not null
         ;
   --  Declaration of UpdateParentRestrict constraint for "ATTRIBUTI_UNITA_FISICA_SO"
   cursor cfk4_attributi_unita_fisica_s(var_progr_unita_fisica number) is
      select 1
        from ATTRIBUTI_UNITA_FISICA_SO
       where PROGR_UNITA_FISICA = var_progr_unita_fisica
         and var_progr_unita_fisica is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "SUDDIVISIONI_FISICHE" deve esistere quando si modifica "ANAGRAFE_UNITA_FISICHE"
      
         if  NEW_ID_SUDDIVISIONE is not null and ( seq = 0 )
         then
            open  cpk1_anagrafe_unita_fisiche(NEW_ID_SUDDIVISIONE);
            fetch cpk1_anagrafe_unita_fisiche into dummy;
            found := cpk1_anagrafe_unita_fisiche%FOUND; /* %FOUND */
            close cpk1_anagrafe_unita_fisiche;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Suddivisioni fisiche. La registrazione Anagrafe unita fisiche non e'' modificabile. (ANAGRAFE_UNITA_FISICHE.ANUF_SUFI_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      --  Chiave di "ANAGRAFE_UNITA_FISICHE" non modificabile se esistono referenze su "UBICAZIONI_UNITA"
      if NEW_PROGR_UNITA_FISICA != OLD_PROGR_UNITA_FISICA
      then
         open  cfk1_ubicazioni_unita(OLD_PROGR_UNITA_FISICA);
         fetch cfk1_ubicazioni_unita into dummy;
         found := cfk1_ubicazioni_unita%FOUND; /* %FOUND */
         close cfk1_ubicazioni_unita;
         if found then
            errno  := -20005;
            errmsg := 'Esistono riferimenti su Ubicazioni unita. La registrazione di Anagrafe unita fisiche non e'' modificabile. (UBICAZIONI_UNITA.UBUN_ANUF_FK)';
            raise integrity_error;
         end if;
      end if;
      --  Chiave di "ANAGRAFE_UNITA_FISICHE" non modificabile se esistono referenze su "UNITA_FISICHE"
      if NEW_PROGR_UNITA_FISICA != OLD_PROGR_UNITA_FISICA
      then
         open  cfk2_unita_fisiche(OLD_PROGR_UNITA_FISICA);
         fetch cfk2_unita_fisiche into dummy;
         found := cfk2_unita_fisiche%FOUND; /* %FOUND */
         close cfk2_unita_fisiche;
         if found then
            errno  := -20005;
            errmsg := 'Esistono riferimenti su Unita fisiche. La registrazione di Anagrafe unita fisiche non e'' modificabile. (UNITA_FISICHE.UNFI_ANUF_FK)';
            raise integrity_error;
         end if;
      end if;
      --  Chiave di "ANAGRAFE_UNITA_FISICHE" non modificabile se esistono referenze su "ASSEGNAZIONI_FISICHE"
      if NEW_PROGR_UNITA_FISICA != OLD_PROGR_UNITA_FISICA
      then
         open  cfk3_assegnazioni_fisiche(OLD_PROGR_UNITA_FISICA);
         fetch cfk3_assegnazioni_fisiche into dummy;
         found := cfk3_assegnazioni_fisiche%FOUND; /* %FOUND */
         close cfk3_assegnazioni_fisiche;
         if found then
            errno  := -20005;
            errmsg := 'Esistono riferimenti su Assegnazioni fisiche. La registrazione di Anagrafe unita fisiche non e'' modificabile. (ASSEGNAZIONI_FISICHE.ASFI_ANUF_FK)';
            raise integrity_error;
         end if;
      end if;
      --  Chiave di "ANAGRAFE_UNITA_FISICHE" non modificabile se esistono referenze su "ATTRIBUTI_UNITA_FISICA_SO"
      if NEW_PROGR_UNITA_FISICA != OLD_PROGR_UNITA_FISICA
      then
         open  cfk4_attributi_unita_fisica_s(OLD_PROGR_UNITA_FISICA);
         fetch cfk4_attributi_unita_fisica_s into dummy;
         found := cfk4_attributi_unita_fisica_s%FOUND; /* %FOUND */
         close cfk4_attributi_unita_fisica_s;
         if found then
            errno  := -20005;
            errmsg := 'Esistono riferimenti su Attributi unita fisica so. La registrazione di Anagrafe unita fisiche non e'' modificabile. (ATTRIBUTI_UNITA_FISICA_SO.AUFS_ANUF_FK)';
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

