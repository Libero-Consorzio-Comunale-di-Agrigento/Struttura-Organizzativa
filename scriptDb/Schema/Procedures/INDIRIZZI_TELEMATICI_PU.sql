CREATE OR REPLACE procedure INDIRIZZI_TELEMATICI_PU
/******************************************************************************
 NOME:        INDIRIZZI_TELEMATICI_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table INDIRIZZI_TELEMATICI
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger INDIRIZZI_TELEMATICI_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_tipo_entita IN varchar
, old_id_indirizzo IN number
, old_id_amministrazione IN number
, old_id_aoo IN number
, old_id_unita_organizzativa IN number
, new_tipo_entita IN varchar
, new_id_indirizzo IN number
, new_id_amministrazione IN number
, new_id_aoo IN number
, new_id_unita_organizzativa IN number )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of UpdateChildParentExist constraint for the parent "AOO"
   cursor cpk1_indirizzi_telematici(var_id_aoo number) is
      select 1
        from AOO
       where PROGR_AOO = var_id_aoo
         and var_id_aoo is not null
         ;
   --  Declaration of UpdateChildParentExist constraint for the parent "AMMINISTRAZIONI"
   cursor cpk2_indirizzi_telematici(var_id_amministrazione number) is
      select 1
        from AMMINISTRAZIONI
       where NI = var_id_amministrazione
         and var_id_amministrazione is not null
         ;
   --  Declaration of UpdateChildParentExist constraint for the parent "ANAGRAFE_UNITA_ORGANIZZATIVE"
   cursor cpk3_indirizzi_telematici(var_id_unita_organizzativa number) is
      select 1
        from ANAGRAFE_UNITA_ORGANIZZATIVE
       where PROGR_UNITA_ORGANIZZATIVA = var_id_unita_organizzativa
         and var_id_unita_organizzativa is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Colonna "TIPO_ENTITA" non modificabile
      if OLD_TIPO_ENTITA != NEW_TIPO_ENTITA then
         if IntegrityPackage.GetNestLevel = 0 then
            errno  := -20001;
            errmsg := 'L''informazione Tipo entita non puo'' essere modificata.';
            raise integrity_error;
         end if;
      end if;
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "AOO" deve esistere quando si modifica "INDIRIZZI_TELEMATICI"
      
         if  NEW_ID_AOO is not null and ( seq = 0 )
         then
            open  cpk1_indirizzi_telematici(NEW_ID_AOO);
            fetch cpk1_indirizzi_telematici into dummy;
            found := cpk1_indirizzi_telematici%FOUND; /* %FOUND */
            close cpk1_indirizzi_telematici;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su AOO. La registrazione Indirizzi telematici non e'' modificabile. (INDIRIZZI_TELEMATICI.INTE_AOO_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "AMMINISTRAZIONI" deve esistere quando si modifica "INDIRIZZI_TELEMATICI"
      
         if  NEW_ID_AMMINISTRAZIONE is not null and ( seq = 0 )
         then
            open  cpk2_indirizzi_telematici(NEW_ID_AMMINISTRAZIONE);
            fetch cpk2_indirizzi_telematici into dummy;
            found := cpk2_indirizzi_telematici%FOUND; /* %FOUND */
            close cpk2_indirizzi_telematici;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Amministrazioni. La registrazione Indirizzi telematici non e'' modificabile. (INDIRIZZI_TELEMATICI.INTE_AMMI_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "ANAGRAFE_UNITA_ORGANIZZATIVE" deve esistere quando si modifica "INDIRIZZI_TELEMATICI"
      
         if  NEW_ID_UNITA_ORGANIZZATIVA is not null and ( seq = 0 )
         then
            open  cpk3_indirizzi_telematici(NEW_ID_UNITA_ORGANIZZATIVA);
            fetch cpk3_indirizzi_telematici into dummy;
            found := cpk3_indirizzi_telematici%FOUND; /* %FOUND */
            close cpk3_indirizzi_telematici;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Anagrafe unita organizzative. La registrazione Indirizzi telematici non e'' modificabile. (INDIRIZZI_TELEMATICI.INTE_ANUO_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
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

