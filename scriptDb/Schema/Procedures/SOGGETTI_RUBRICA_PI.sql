CREATE OR REPLACE procedure SOGGETTI_RUBRICA_PI
/******************************************************************************
 NOME:        SOGGETTI_RUBRICA_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table SOGGETTI_RUBRICA
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger SOGGETTI_RUBRICA_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( new_ni IN number
, new_tipo_contatto IN number
, new_progressivo IN number
, new_riferimento_tipo IN number
, new_riferimento IN number )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of InsertChildParentExist constraint for the parent "SOGGETTI_RUBRICA"
   cursor cpk1_soggetti_rubrica(var_ni number,
                   var_riferimento_tipo number,
                   var_riferimento number) is
      select 1
        from SOGGETTI_RUBRICA
       where NI = var_ni
         and TIPO_CONTATTO = var_riferimento_tipo
         and PROGRESSIVO = var_riferimento
         and var_ni is not null
         and var_riferimento_tipo is not null
         and var_riferimento is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "SOGGETTI_RUBRICA" deve esistere quando si inserisce su "SOGGETTI_RUBRICA"
      
         if NEW_NI is not null and
            NEW_RIFERIMENTO_TIPO is not null and
            NEW_RIFERIMENTO is not null
         then
            open  cpk1_soggetti_rubrica(NEW_NI,
                           NEW_RIFERIMENTO_TIPO,
                           NEW_RIFERIMENTO);
            fetch cpk1_soggetti_rubrica into dummy;
            found := cpk1_soggetti_rubrica%FOUND; /* %FOUND */
            close cpk1_soggetti_rubrica;
            if not found then
               errno  := -20002;
               errmsg := 'Non esiste riferimento su Rubrica soggetti. La registrazione Rubrica soggetti non puo'' essere inserita. (SOGGETTI_RUBRICA.SORU_SORU_FK)';
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

