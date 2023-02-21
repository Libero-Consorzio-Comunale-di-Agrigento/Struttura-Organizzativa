CREATE OR REPLACE procedure ANAGRAFE_UNITA_ORGANIZZATIV_PU
/******************************************************************************
 NOME:        ANAGRAFE_UNITA_ORGANIZZATIV_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table ANAGRAFE_UNITA_ORGANIZZATIVE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger ANAGRAFE_UNITA_ORGANIZZATI_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_progr_unita_organizzativa IN number
, old_dal IN date
, old_id_suddivisione IN number
, old_ottica IN varchar
, old_revisione_istituzione IN number
, old_revisione_cessazione IN number
, old_amministrazione IN varchar
, old_progr_aoo IN number
, old_centro IN varchar
, new_progr_unita_organizzativa IN number
, new_dal IN date
, new_id_suddivisione IN number
, new_ottica IN varchar
, new_revisione_istituzione IN number
, new_revisione_cessazione IN number
, new_amministrazione IN varchar
, new_progr_aoo IN number
, new_centro IN varchar )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of UpdateChildParentExist constraint for the parent "AMMINISTRAZIONI"
   cursor cpk1_anagrafe_unita_organizza(var_amministrazione varchar) is
      select 1
        from AMMINISTRAZIONI
       where CODICE_AMMINISTRAZIONE = var_amministrazione
         and var_amministrazione is not null
         ;
   --  Declaration of UpdateChildParentExist constraint for the parent "SUDDIVISIONI_STRUTTURA"
   cursor cpk2_anagrafe_unita_organizza(var_id_suddivisione number) is
      select 1
        from SUDDIVISIONI_STRUTTURA
       where ID_SUDDIVISIONE = var_id_suddivisione
         and var_id_suddivisione is not null
         ;
   --  Declaration of UpdateChildParentExist constraint for the parent "REVISIONI_STRUTTURA"
   cursor cpk3_anagrafe_unita_organizza(var_ottica varchar,
                   var_revisione_istituzione number) is
      select 1
        from REVISIONI_STRUTTURA
       where OTTICA = var_ottica
         and REVISIONE = var_revisione_istituzione
         and var_ottica is not null
         and var_revisione_istituzione is not null
         ;
   --  Declaration of UpdateChildParentExist constraint for the parent "REVISIONI_STRUTTURA"
   cursor cpk4_anagrafe_unita_organizza(var_ottica varchar,
                   var_revisione_cessazione number) is
      select 1
        from REVISIONI_STRUTTURA
       where OTTICA = var_ottica
         and REVISIONE = var_revisione_cessazione
         and var_ottica is not null
         and var_revisione_cessazione is not null
         ;
   --  Declaration of UpdateChildParentExist constraint for the parent "OTTICHE"
   cursor cpk5_anagrafe_unita_organizza(var_ottica varchar) is
      select 1
        from OTTICHE
       where OTTICA = var_ottica
         and var_ottica is not null
         ;
   --  Declaration of UpdateChildParentExist constraint for the parent "CENTRI"
   cursor cpk6_anagrafe_unita_organizza(var_centro varchar) is
      select 1
        from CENTRI
       where CENTRO = var_centro
         and var_centro is not null
         ;
   --  Declaration of UpdateChildParentExist constraint for the parent "AOO"
   cursor cpk7_anagrafe_unita_organizza(var_progr_aoo number) is
      select 1
        from AOO
       where PROGR_AOO = var_progr_aoo
         and var_progr_aoo is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "AMMINISTRAZIONI" deve esistere quando si modifica "ANAGRAFE_UNITA_ORGANIZZATIVE"
      
         if  NEW_AMMINISTRAZIONE is not null and ( seq = 0 )
         then
            open  cpk1_anagrafe_unita_organizza(NEW_AMMINISTRAZIONE);
            fetch cpk1_anagrafe_unita_organizza into dummy;
            found := cpk1_anagrafe_unita_organizza%FOUND; /* %FOUND */
            close cpk1_anagrafe_unita_organizza;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Amministrazioni. La registrazione Anagrafe unita organizzative non e'' modificabile. (ANAGRAFE_UNITA_ORGANIZZATIVE.ANUO_AMMI_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "SUDDIVISIONI_STRUTTURA" deve esistere quando si modifica "ANAGRAFE_UNITA_ORGANIZZATIVE"
      
         if  NEW_ID_SUDDIVISIONE is not null and ( seq = 0 )
         then
            open  cpk2_anagrafe_unita_organizza(NEW_ID_SUDDIVISIONE);
            fetch cpk2_anagrafe_unita_organizza into dummy;
            found := cpk2_anagrafe_unita_organizza%FOUND; /* %FOUND */
            close cpk2_anagrafe_unita_organizza;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Suddivisioni Struttura. La registrazione Anagrafe unita organizzative non e'' modificabile. (ANAGRAFE_UNITA_ORGANIZZATIVE.ANUO_SUST_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "REVISIONI_STRUTTURA" deve esistere quando si modifica "ANAGRAFE_UNITA_ORGANIZZATIVE"
      
         if  NEW_OTTICA is not null and
             NEW_REVISIONE_ISTITUZIONE is not null and ( seq = 0 )
         then
            open  cpk3_anagrafe_unita_organizza(NEW_OTTICA,
                           NEW_REVISIONE_ISTITUZIONE);
            fetch cpk3_anagrafe_unita_organizza into dummy;
            found := cpk3_anagrafe_unita_organizza%FOUND; /* %FOUND */
            close cpk3_anagrafe_unita_organizza;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Revisioni Struttura. La registrazione Anagrafe unita organizzative non e'' modificabile. (ANAGRAFE_UNITA_ORGANIZZATIVE.ANUO_REST_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "REVISIONI_STRUTTURA" deve esistere quando si modifica "ANAGRAFE_UNITA_ORGANIZZATIVE"
      
         if  NEW_OTTICA is not null and
             NEW_REVISIONE_CESSAZIONE is not null and ( seq = 0 )
         then
            open  cpk4_anagrafe_unita_organizza(NEW_OTTICA,
                           NEW_REVISIONE_CESSAZIONE);
            fetch cpk4_anagrafe_unita_organizza into dummy;
            found := cpk4_anagrafe_unita_organizza%FOUND; /* %FOUND */
            close cpk4_anagrafe_unita_organizza;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Revisioni Struttura. La registrazione Anagrafe unita organizzative non e'' modificabile. (ANAGRAFE_UNITA_ORGANIZZATIVE.ANUO_REST_2_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "OTTICHE" deve esistere quando si modifica "ANAGRAFE_UNITA_ORGANIZZATIVE"
      
         if  NEW_OTTICA is not null and ( seq = 0 )
         then
            open  cpk5_anagrafe_unita_organizza(NEW_OTTICA);
            fetch cpk5_anagrafe_unita_organizza into dummy;
            found := cpk5_anagrafe_unita_organizza%FOUND; /* %FOUND */
            close cpk5_anagrafe_unita_organizza;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Ottiche. La registrazione Anagrafe unita organizzative non e'' modificabile. (ANAGRAFE_UNITA_ORGANIZZATIVE.ANUO_OTTI_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "CENTRI" deve esistere quando si modifica "ANAGRAFE_UNITA_ORGANIZZATIVE"
      
         if  NEW_CENTRO is not null and ( seq = 0 )
         then
            open  cpk6_anagrafe_unita_organizza(NEW_CENTRO);
            fetch cpk6_anagrafe_unita_organizza into dummy;
            found := cpk6_anagrafe_unita_organizza%FOUND; /* %FOUND */
            close cpk6_anagrafe_unita_organizza;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Centri. La registrazione Anagrafe unita organizzative non e'' modificabile. (ANAGRAFE_UNITA_ORGANIZZATIVE.ANUO_CENT_FK)';
               raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "AOO" deve esistere quando si modifica "ANAGRAFE_UNITA_ORGANIZZATIVE"
      
         if  NEW_PROGR_AOO is not null and ( seq = 0 )
         then
            open  cpk7_anagrafe_unita_organizza(NEW_PROGR_AOO);
            fetch cpk7_anagrafe_unita_organizza into dummy;
            found := cpk7_anagrafe_unita_organizza%FOUND; /* %FOUND */
            close cpk7_anagrafe_unita_organizza;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su AOO. La registrazione Anagrafe unita organizzative non e'' modificabile. (ANAGRAFE_UNITA_ORGANIZZATIVE.ANUO_AOO_FK)';
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

