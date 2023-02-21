CREATE OR REPLACE procedure IMPUTAZIONI_BILANCIO_PI
/******************************************************************************
 NOME:        IMPUTAZIONI_BILANCIO_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table IMPUTAZIONI_BILANCIO
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger IMPUTAZIONI_BILANCIO_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( new_id_imputazione IN number
, new_id_componente IN number )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of InsertChildParentExist constraint for the parent "COMPONENTI"
   cursor cpk1_imputazioni_bilancio(var_id_componente number) is
      select 1
        from COMPONENTI
       where ID_COMPONENTE = var_id_componente
         and var_id_componente is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "COMPONENTI" deve esistere quando si inserisce su "IMPUTAZIONI_BILANCIO"
      
         if NEW_ID_COMPONENTE is not null
         then
            open  cpk1_imputazioni_bilancio(NEW_ID_COMPONENTE);
            fetch cpk1_imputazioni_bilancio into dummy;
            found := cpk1_imputazioni_bilancio%FOUND; /* %FOUND */
            close cpk1_imputazioni_bilancio;
            if not found then
               errno  := -20002;
               errmsg := 'Non esiste riferimento su Componenti. La registrazione Imputazioni bilancio non puo'' essere inserita. (IMPUTAZIONI_BILANCIO.IMBI_COMP_FK)';
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

