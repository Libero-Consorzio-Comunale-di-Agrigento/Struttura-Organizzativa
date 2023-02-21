CREATE OR REPLACE procedure SOGGETTI_RUBRICA_PU
/******************************************************************************
 NOME:        SOGGETTI_RUBRICA_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table SOGGETTI_RUBRICA
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger SOGGETTI_RUBRICA_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_ni IN number
, old_tipo_contatto IN number
, old_progressivo IN number
, old_riferimento_tipo IN number
, old_riferimento IN number
, new_ni IN number
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
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of UpdateChildParentExist constraint for the parent "SOGGETTI_RUBRICA"
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
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "SOGGETTI_RUBRICA" deve esistere quando si modifica "SOGGETTI_RUBRICA"
      
         if  NEW_NI is not null and
             NEW_RIFERIMENTO_TIPO is not null and
             NEW_RIFERIMENTO is not null and ( seq = 0 )
         then
            open  cpk1_soggetti_rubrica(NEW_NI,
                           NEW_RIFERIMENTO_TIPO,
                           NEW_RIFERIMENTO);
            fetch cpk1_soggetti_rubrica into dummy;
            found := cpk1_soggetti_rubrica%FOUND; /* %FOUND */
            close cpk1_soggetti_rubrica;
            if not found then
               errno  := -20003;
               errmsg := 'Non esiste riferimento su Rubrica soggetti. La registrazione Rubrica soggetti non e'' modificabile. (SOGGETTI_RUBRICA.SORU_SORU_FK)';
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

