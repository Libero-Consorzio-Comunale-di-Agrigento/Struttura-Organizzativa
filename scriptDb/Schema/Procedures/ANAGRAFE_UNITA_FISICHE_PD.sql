CREATE OR REPLACE procedure ANAGRAFE_UNITA_FISICHE_PD
/******************************************************************************
 NOME:        ANAGRAFE_UNITA_FISICHE_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table ANAGRAFE_UNITA_FISICHE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger ANAGRAFE_UNITA_FISICHE_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_progr_unita_fisica IN number
, old_dal IN date
, old_id_suddivisione IN number )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "UBICAZIONI_UNITA"
   cursor cfk1_ubicazioni_unita(var_progr_unita_fisica number) is
      select 1
        from UBICAZIONI_UNITA
       where PROGR_UNITA_FISICA = var_progr_unita_fisica
         and var_progr_unita_fisica is not null
         ;
   --  Declaration of DeleteParentRestrict constraint for "UNITA_FISICHE"
   cursor cfk2_unita_fisiche(var_progr_unita_fisica number) is
      select 1
        from UNITA_FISICHE
       where PROGR_UNITA_FISICA = var_progr_unita_fisica
         and var_progr_unita_fisica is not null
         ;
   --  Declaration of DeleteParentRestrict constraint for "ASSEGNAZIONI_FISICHE"
   cursor cfk3_assegnazioni_fisiche(var_progr_unita_fisica number) is
      select 1
        from ASSEGNAZIONI_FISICHE
       where PROGR_UNITA_FISICA = var_progr_unita_fisica
         and var_progr_unita_fisica is not null
         ;
   --  Declaration of DeleteParentRestrict constraint for "ATTRIBUTI_UNITA_FISICA_SO"
   cursor cfk4_attributi_unita_fisica_s(var_progr_unita_fisica number) is
      select 1
        from ATTRIBUTI_UNITA_FISICA_SO
       where PROGR_UNITA_FISICA = var_progr_unita_fisica
         and var_progr_unita_fisica is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "ANAGRAFE_UNITA_FISICHE" if children still exist in "UBICAZIONI_UNITA"
      open  cfk1_ubicazioni_unita(OLD_PROGR_UNITA_FISICA);
      fetch cfk1_ubicazioni_unita into dummy;
      found := cfk1_ubicazioni_unita%FOUND; /* %FOUND */
      close cfk1_ubicazioni_unita;
      if found
      then
         errno  := -20006;
         errmsg := 'Esistono riferimenti su Ubicazioni unita. La registrazione di Anagrafe unita fisiche non e'' eliminabile. (UBICAZIONI_UNITA.UBUN_ANUF_FK)';
         raise integrity_error;
      end if;
      --  Cannot delete parent "ANAGRAFE_UNITA_FISICHE" if children still exist in "UNITA_FISICHE"
      open  cfk2_unita_fisiche(OLD_PROGR_UNITA_FISICA);
      fetch cfk2_unita_fisiche into dummy;
      found := cfk2_unita_fisiche%FOUND; /* %FOUND */
      close cfk2_unita_fisiche;
      if found
      then
         errno  := -20006;
         errmsg := 'Esistono riferimenti su Unita fisiche. La registrazione di Anagrafe unita fisiche non e'' eliminabile. (UNITA_FISICHE.UNFI_ANUF_FK)';
         raise integrity_error;
      end if;
      --  Cannot delete parent "ANAGRAFE_UNITA_FISICHE" if children still exist in "ASSEGNAZIONI_FISICHE"
      open  cfk3_assegnazioni_fisiche(OLD_PROGR_UNITA_FISICA);
      fetch cfk3_assegnazioni_fisiche into dummy;
      found := cfk3_assegnazioni_fisiche%FOUND; /* %FOUND */
      close cfk3_assegnazioni_fisiche;
      if found
      then
         errno  := -20006;
         errmsg := 'Esistono riferimenti su Assegnazioni fisiche. La registrazione di Anagrafe unita fisiche non e'' eliminabile. (ASSEGNAZIONI_FISICHE.ASFI_ANUF_FK)';
         raise integrity_error;
      end if;
      --  Cannot delete parent "ANAGRAFE_UNITA_FISICHE" if children still exist in "ATTRIBUTI_UNITA_FISICA_SO"
      open  cfk4_attributi_unita_fisica_s(OLD_PROGR_UNITA_FISICA);
      fetch cfk4_attributi_unita_fisica_s into dummy;
      found := cfk4_attributi_unita_fisica_s%FOUND; /* %FOUND */
      close cfk4_attributi_unita_fisica_s;
      if found
      then
         errno  := -20006;
         errmsg := 'Esistono riferimenti su Attributi unita fisica so. La registrazione di Anagrafe unita fisiche non e'' eliminabile. (ATTRIBUTI_UNITA_FISICA_SO.AUFS_ANUF_FK)';
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

