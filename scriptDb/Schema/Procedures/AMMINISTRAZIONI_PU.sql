CREATE OR REPLACE procedure AMMINISTRAZIONI_PU
/******************************************************************************
 NOME:        AMMINISTRAZIONI_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table AMMINISTRAZIONI
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger AMMINISTRAZIONI_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_codice_amministrazione IN varchar
, old_ni IN number
, new_codice_amministrazione IN varchar
, new_ni IN number )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of UpdateParentRestrict constraint for "ANAGRAFE_UNITA_ORGANIZZATIVE"
   cursor cfk1_anagrafe_unita_organizza(var_codice_amministrazione varchar) is
      select 1
        from ANAGRAFE_UNITA_ORGANIZZATIVE
       where AMMINISTRAZIONE = var_codice_amministrazione
         and var_codice_amministrazione is not null
         ;
   --  Declaration of UpdateParentRestrict constraint for "INDIRIZZI_TELEMATICI"
   cursor cfk2_indirizzi_telematici(var_ni number) is
      select 1
        from INDIRIZZI_TELEMATICI
       where ID_AMMINISTRAZIONE = var_ni
         and var_ni is not null
         ;
   --  Declaration of UpdateParentRestrict constraint for "SUDDIVISIONI_FISICHE"
   cursor cfk3_suddivisioni_fisiche(var_codice_amministrazione varchar) is
      select 1
        from SUDDIVISIONI_FISICHE
       where AMMINISTRAZIONE = var_codice_amministrazione
         and var_codice_amministrazione is not null
         ;
   --  Declaration of UpdateParentRestrict constraint for "UNITA_FISICHE"
   cursor cfk4_unita_fisiche(var_codice_amministrazione varchar) is
      select 1
        from UNITA_FISICHE
       where AMMINISTRAZIONE = var_codice_amministrazione
         and var_codice_amministrazione is not null
         ;
   --  Declaration of UpdateParentRestrict constraint for "OTTICHE"
   cursor cfk5_ottiche(var_codice_amministrazione varchar) is
      select 1
        from OTTICHE
       where AMMINISTRAZIONE = var_codice_amministrazione
         and var_codice_amministrazione is not null
         ;
   --  Declaration of UpdateParentRestrict constraint for "AOO"
   cursor cfk6_aoo(var_codice_amministrazione varchar) is
      select 1
        from AOO
       where CODICE_AMMINISTRAZIONE = var_codice_amministrazione
         and var_codice_amministrazione is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Chiave di "AMMINISTRAZIONI" non modificabile se esistono referenze su "ANAGRAFE_UNITA_ORGANIZZATIVE"
      if NEW_CODICE_AMMINISTRAZIONE != OLD_CODICE_AMMINISTRAZIONE
      then
         open  cfk1_anagrafe_unita_organizza(OLD_CODICE_AMMINISTRAZIONE);
         fetch cfk1_anagrafe_unita_organizza into dummy;
         found := cfk1_anagrafe_unita_organizza%FOUND; /* %FOUND */
         close cfk1_anagrafe_unita_organizza;
         if found then
            errno  := -20005;
            errmsg := 'Esistono riferimenti su Anagrafe unita organizzative. La registrazione di Amministrazioni non e'' modificabile. (ANAGRAFE_UNITA_ORGANIZZATIVE.ANUO_AMMI_FK)';
            raise integrity_error;
         end if;
      end if;
      --  Chiave di "AMMINISTRAZIONI" non modificabile se esistono referenze su "INDIRIZZI_TELEMATICI"
      if NEW_NI != OLD_NI
      then
         open  cfk2_indirizzi_telematici(OLD_NI);
         fetch cfk2_indirizzi_telematici into dummy;
         found := cfk2_indirizzi_telematici%FOUND; /* %FOUND */
         close cfk2_indirizzi_telematici;
         if found then
            errno  := -20005;
            errmsg := 'Esistono riferimenti su Indirizzi telematici. La registrazione di Amministrazioni non e'' modificabile. (INDIRIZZI_TELEMATICI.INTE_AMMI_FK)';
            raise integrity_error;
         end if;
      end if;
      --  Chiave di "AMMINISTRAZIONI" non modificabile se esistono referenze su "SUDDIVISIONI_FISICHE"
      if NEW_CODICE_AMMINISTRAZIONE != OLD_CODICE_AMMINISTRAZIONE
      then
         open  cfk3_suddivisioni_fisiche(OLD_CODICE_AMMINISTRAZIONE);
         fetch cfk3_suddivisioni_fisiche into dummy;
         found := cfk3_suddivisioni_fisiche%FOUND; /* %FOUND */
         close cfk3_suddivisioni_fisiche;
         if found then
            errno  := -20005;
            errmsg := 'Esistono riferimenti su Suddivisioni fisiche. La registrazione di Amministrazioni non e'' modificabile. (SUDDIVISIONI_FISICHE.SUFI_AMMI_FK)';
            raise integrity_error;
         end if;
      end if;
      --  Chiave di "AMMINISTRAZIONI" non modificabile se esistono referenze su "UNITA_FISICHE"
      if NEW_CODICE_AMMINISTRAZIONE != OLD_CODICE_AMMINISTRAZIONE
      then
         open  cfk4_unita_fisiche(OLD_CODICE_AMMINISTRAZIONE);
         fetch cfk4_unita_fisiche into dummy;
         found := cfk4_unita_fisiche%FOUND; /* %FOUND */
         close cfk4_unita_fisiche;
         if found then
            errno  := -20005;
            errmsg := 'Esistono riferimenti su Unita fisiche. La registrazione di Amministrazioni non e'' modificabile. (UNITA_FISICHE.UNFI_AMMI_FK)';
            raise integrity_error;
         end if;
      end if;
      --  Chiave di "AMMINISTRAZIONI" non modificabile se esistono referenze su "OTTICHE"
      if NEW_CODICE_AMMINISTRAZIONE != OLD_CODICE_AMMINISTRAZIONE
      then
         open  cfk5_ottiche(OLD_CODICE_AMMINISTRAZIONE);
         fetch cfk5_ottiche into dummy;
         found := cfk5_ottiche%FOUND; /* %FOUND */
         close cfk5_ottiche;
         if found then
            errno  := -20005;
            errmsg := 'Esistono riferimenti su Ottiche. La registrazione di Amministrazioni non e'' modificabile. (OTTICHE.OTTI_AMMI_FK)';
            raise integrity_error;
         end if;
      end if;
      --  Chiave di "AMMINISTRAZIONI" non modificabile se esistono referenze su "AOO"
      if NEW_CODICE_AMMINISTRAZIONE != OLD_CODICE_AMMINISTRAZIONE
      then
         open  cfk6_aoo(OLD_CODICE_AMMINISTRAZIONE);
         fetch cfk6_aoo into dummy;
         found := cfk6_aoo%FOUND; /* %FOUND */
         close cfk6_aoo;
         if found then
            errno  := -20005;
            errmsg := 'Esistono riferimenti su AOO. La registrazione di Amministrazioni non e'' modificabile. (AOO.AOO_AMMI_FK)';
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

