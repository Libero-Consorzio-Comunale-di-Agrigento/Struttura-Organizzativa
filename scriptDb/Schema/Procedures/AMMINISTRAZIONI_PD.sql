CREATE OR REPLACE procedure AMMINISTRAZIONI_PD
/******************************************************************************
 NOME:        AMMINISTRAZIONI_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table AMMINISTRAZIONI
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger AMMINISTRAZIONI_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_codice_amministrazione IN varchar
, old_ni IN number )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "ANAGRAFE_UNITA_ORGANIZZATIVE"
   cursor cfk1_anagrafe_unita_organizza(var_codice_amministrazione varchar) is
      select 1
        from ANAGRAFE_UNITA_ORGANIZZATIVE
       where AMMINISTRAZIONE = var_codice_amministrazione
         and var_codice_amministrazione is not null
         ;
   --  Declaration of DeleteParentRestrict constraint for "INDIRIZZI_TELEMATICI"
   cursor cfk2_indirizzi_telematici(var_ni number) is
      select 1
        from INDIRIZZI_TELEMATICI
       where ID_AMMINISTRAZIONE = var_ni
         and var_ni is not null
         ;
   --  Declaration of DeleteParentRestrict constraint for "SUDDIVISIONI_FISICHE"
   cursor cfk3_suddivisioni_fisiche(var_codice_amministrazione varchar) is
      select 1
        from SUDDIVISIONI_FISICHE
       where AMMINISTRAZIONE = var_codice_amministrazione
         and var_codice_amministrazione is not null
         ;
   --  Declaration of DeleteParentRestrict constraint for "UNITA_FISICHE"
   cursor cfk4_unita_fisiche(var_codice_amministrazione varchar) is
      select 1
        from UNITA_FISICHE
       where AMMINISTRAZIONE = var_codice_amministrazione
         and var_codice_amministrazione is not null
         ;
   --  Declaration of DeleteParentRestrict constraint for "OTTICHE"
   cursor cfk5_ottiche(var_codice_amministrazione varchar) is
      select 1
        from OTTICHE
       where AMMINISTRAZIONE = var_codice_amministrazione
         and var_codice_amministrazione is not null
         ;
   --  Declaration of DeleteParentRestrict constraint for "AOO"
   cursor cfk6_aoo(var_codice_amministrazione varchar) is
      select 1
        from AOO
       where CODICE_AMMINISTRAZIONE = var_codice_amministrazione
         and var_codice_amministrazione is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "AMMINISTRAZIONI" if children still exist in "ANAGRAFE_UNITA_ORGANIZZATIVE"
      open  cfk1_anagrafe_unita_organizza(OLD_CODICE_AMMINISTRAZIONE);
      fetch cfk1_anagrafe_unita_organizza into dummy;
      found := cfk1_anagrafe_unita_organizza%FOUND; /* %FOUND */
      close cfk1_anagrafe_unita_organizza;
      if found
      then
         errno  := -20006;
         errmsg := 'Esistono riferimenti su Anagrafe unita organizzative. La registrazione di Amministrazioni non e'' eliminabile. (ANAGRAFE_UNITA_ORGANIZZATIVE.ANUO_AMMI_FK)';
         raise integrity_error;
      end if;
      --  Cannot delete parent "AMMINISTRAZIONI" if children still exist in "INDIRIZZI_TELEMATICI"
      open  cfk2_indirizzi_telematici(OLD_NI);
      fetch cfk2_indirizzi_telematici into dummy;
      found := cfk2_indirizzi_telematici%FOUND; /* %FOUND */
      close cfk2_indirizzi_telematici;
      if found
      then
         errno  := -20006;
         errmsg := 'Esistono riferimenti su Indirizzi telematici. La registrazione di Amministrazioni non e'' eliminabile. (INDIRIZZI_TELEMATICI.INTE_AMMI_FK)';
         raise integrity_error;
      end if;
      --  Cannot delete parent "AMMINISTRAZIONI" if children still exist in "SUDDIVISIONI_FISICHE"
      open  cfk3_suddivisioni_fisiche(OLD_CODICE_AMMINISTRAZIONE);
      fetch cfk3_suddivisioni_fisiche into dummy;
      found := cfk3_suddivisioni_fisiche%FOUND; /* %FOUND */
      close cfk3_suddivisioni_fisiche;
      if found
      then
         errno  := -20006;
         errmsg := 'Esistono riferimenti su Suddivisioni fisiche. La registrazione di Amministrazioni non e'' eliminabile. (SUDDIVISIONI_FISICHE.SUFI_AMMI_FK)';
         raise integrity_error;
      end if;
      --  Cannot delete parent "AMMINISTRAZIONI" if children still exist in "UNITA_FISICHE"
      open  cfk4_unita_fisiche(OLD_CODICE_AMMINISTRAZIONE);
      fetch cfk4_unita_fisiche into dummy;
      found := cfk4_unita_fisiche%FOUND; /* %FOUND */
      close cfk4_unita_fisiche;
      if found
      then
         errno  := -20006;
         errmsg := 'Esistono riferimenti su Unita fisiche. La registrazione di Amministrazioni non e'' eliminabile. (UNITA_FISICHE.UNFI_AMMI_FK)';
         raise integrity_error;
      end if;
      --  Cannot delete parent "AMMINISTRAZIONI" if children still exist in "OTTICHE"
      open  cfk5_ottiche(OLD_CODICE_AMMINISTRAZIONE);
      fetch cfk5_ottiche into dummy;
      found := cfk5_ottiche%FOUND; /* %FOUND */
      close cfk5_ottiche;
      if found
      then
         errno  := -20006;
         errmsg := 'Esistono riferimenti su Ottiche. La registrazione di Amministrazioni non e'' eliminabile. (OTTICHE.OTTI_AMMI_FK)';
         raise integrity_error;
      end if;
      --  Cannot delete parent "AMMINISTRAZIONI" if children still exist in "AOO"
      open  cfk6_aoo(OLD_CODICE_AMMINISTRAZIONE);
      fetch cfk6_aoo into dummy;
      found := cfk6_aoo%FOUND; /* %FOUND */
      close cfk6_aoo;
      if found
      then
         errno  := -20006;
         errmsg := 'Esistono riferimenti su AOO. La registrazione di Amministrazioni non e'' eliminabile. (AOO.AOO_AMMI_FK)';
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

