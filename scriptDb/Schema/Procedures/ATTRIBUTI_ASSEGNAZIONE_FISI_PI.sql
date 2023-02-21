CREATE OR REPLACE procedure ATTRIBUTI_ASSEGNAZIONE_FISI_PI
/******************************************************************************
 NOME:        ATTRIBUTI_ASSEGNAZIONE_FISI_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table ATTRIBUTI_ASSEGNAZIONE_FISICA
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger ATTRIBUTI_ASSEGNAZIONE_FIS_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( new_id_asfi IN number
, new_attributo IN varchar
, new_dal IN date )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of InsertChildParentExist constraint for the parent "ASSEGNAZIONI_FISICHE"
   cursor cpk1_attributi_assegnazione_f(var_id_asfi number) is
      select 1
        from ASSEGNAZIONI_FISICHE
       where ID_ASFI = var_id_asfi
         and var_id_asfi is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "ASSEGNAZIONI_FISICHE" deve esistere quando si inserisce su "ATTRIBUTI_ASSEGNAZIONE_FISICA"
      
         if NEW_ID_ASFI is not null
         then
            open  cpk1_attributi_assegnazione_f(NEW_ID_ASFI);
            fetch cpk1_attributi_assegnazione_f into dummy;
            found := cpk1_attributi_assegnazione_f%FOUND; /* %FOUND */
            close cpk1_attributi_assegnazione_f;
            if not found then
               errno  := -20002;
               errmsg := 'Non esiste riferimento su Assegnazioni fisiche. La registrazione Attributi assegnazione fisica non puo'' essere inserita. (ATTRIBUTI_ASSEGNAZIONE_FISICA.ATAF_ASFI_FK)';
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

