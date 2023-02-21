CREATE OR REPLACE procedure UBICAZIONI_UNITA_PU
/******************************************************************************
 NOME:        UBICAZIONI_UNITA_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table UBICAZIONI_UNITA
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger UBICAZIONI_UNITA_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_id_ubicazione IN number
, old_progr_unita_organizzativa IN number
, old_progr_unita_fisica IN number
, new_id_ubicazione IN number
, new_progr_unita_organizzativa IN number
, new_progr_unita_fisica IN number )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of UpdateChildParentExist constraint for the parent "ANAGRAFE_UNITA_ORGANIZZATIVE"
   cursor cpk1_ubicazioni_unita(var_progr_unita_organizzativa number) is
      select 1
        from ANAGRAFE_UNITA_ORGANIZZATIVE
       where PROGR_UNITA_ORGANIZZATIVA = var_progr_unita_organizzativa
         and var_progr_unita_organizzativa is not null
         ;
   --  Declaration of UpdateChildParentExist constraint for the parent "ANAGRAFE_UNITA_FISICHE"
   cursor cpk2_ubicazioni_unita(var_progr_unita_fisica number) is
      select 1
        from ANAGRAFE_UNITA_FISICHE
       where PROGR_UNITA_FISICA = var_progr_unita_fisica
         and var_progr_unita_fisica is not null
         ;
   --  Declaration of UpdateParentRestrict constraint for "UBICAZIONI_COMPONENTE"
   cursor cfk1_ubicazioni_componente(var_id_ubicazione number) is
      select 1
        from UBICAZIONI_COMPONENTE
       where ID_UBICAZIONE_UNITA = var_id_ubicazione
         and var_id_ubicazione is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "ANAGRAFE_UNITA_ORGANIZZATIVE" deve esistere quando si modifica "UBICAZIONI_UNITA"
      
         if  NEW_PROGR_UNITA_ORGANIZZATIVA is not null and ( seq = 0 )
         then
            open  cpk1_ubicazioni_unita(NEW_PROGR_UNITA_ORGANIZZATIVA);
            fetch cpk1_ubicazioni_unita into dummy;
            found := cpk1_ubicazioni_unita%FOUND; /* %FOUND */
            close cpk1_ubicazioni_unita;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Anagrafe unita organizzative. La registrazione Ubicazioni unita non e'' modificabile. (UBICAZIONI_UNITA.UBUN_ANUO_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "ANAGRAFE_UNITA_FISICHE" deve esistere quando si modifica "UBICAZIONI_UNITA"
      
         if  NEW_PROGR_UNITA_FISICA is not null and ( seq = 0 )
         then
            open  cpk2_ubicazioni_unita(NEW_PROGR_UNITA_FISICA);
            fetch cpk2_ubicazioni_unita into dummy;
            found := cpk2_ubicazioni_unita%FOUND; /* %FOUND */
            close cpk2_ubicazioni_unita;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Anagrafe unita fisiche. La registrazione Ubicazioni unita non e'' modificabile. (UBICAZIONI_UNITA.UBUN_ANUF_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      --  Chiave di "UBICAZIONI_UNITA" non modificabile se esistono referenze su "UBICAZIONI_COMPONENTE"
      if NEW_ID_UBICAZIONE != OLD_ID_UBICAZIONE
      then
         open  cfk1_ubicazioni_componente(OLD_ID_UBICAZIONE);
         fetch cfk1_ubicazioni_componente into dummy;
         found := cfk1_ubicazioni_componente%FOUND; /* %FOUND */
         close cfk1_ubicazioni_componente;
         if found then
            errno  := -20005;
            errmsg := 'Esistono riferimenti su Ubicazioni componente. La registrazione di Ubicazioni unita non e'' modificabile. (UBICAZIONI_COMPONENTE.UBCO_UBUN_FK)';
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

