CREATE OR REPLACE procedure ATTRIBUTI_ASSEGNAZIONE_FISI_PU
/******************************************************************************
 NOME:        ATTRIBUTI_ASSEGNAZIONE_FISI_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table ATTRIBUTI_ASSEGNAZIONE_FISICA
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger ATTRIBUTI_ASSEGNAZIONE_FIS_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_id_asfi IN number
, old_attributo IN varchar
, old_dal IN date
, new_id_asfi IN number
, new_attributo IN varchar
, new_dal IN date )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of UpdateChildParentExist constraint for the parent "ASSEGNAZIONI_FISICHE"
   cursor cpk1_attributi_assegnazione_f(var_id_asfi number) is
      select 1
        from ASSEGNAZIONI_FISICHE
       where ID_ASFI = var_id_asfi
         and var_id_asfi is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "ASSEGNAZIONI_FISICHE" deve esistere quando si modifica "ATTRIBUTI_ASSEGNAZIONE_FISICA"
      
         if  NEW_ID_ASFI is not null and ( seq = 0 )
         then
            open  cpk1_attributi_assegnazione_f(NEW_ID_ASFI);
            fetch cpk1_attributi_assegnazione_f into dummy;
            found := cpk1_attributi_assegnazione_f%FOUND; /* %FOUND */
            close cpk1_attributi_assegnazione_f;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Assegnazioni fisiche. La registrazione Attributi assegnazione fisica non e'' modificabile. (ATTRIBUTI_ASSEGNAZIONE_FISICA.ATAF_ASFI_FK)';
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

