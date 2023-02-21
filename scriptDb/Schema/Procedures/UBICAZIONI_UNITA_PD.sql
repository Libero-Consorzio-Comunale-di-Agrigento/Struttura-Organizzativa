CREATE OR REPLACE procedure UBICAZIONI_UNITA_PD
/******************************************************************************
 NOME:        UBICAZIONI_UNITA_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table UBICAZIONI_UNITA
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger UBICAZIONI_UNITA_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_id_ubicazione IN number
, old_progr_unita_organizzativa IN number
, old_progr_unita_fisica IN number )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "UBICAZIONI_COMPONENTE"
   cursor cfk1_ubicazioni_componente(var_id_ubicazione number) is
      select 1
        from UBICAZIONI_COMPONENTE
       where ID_UBICAZIONE_UNITA = var_id_ubicazione
         and var_id_ubicazione is not null
         ;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "UBICAZIONI_UNITA" if children still exist in "UBICAZIONI_COMPONENTE"
      open  cfk1_ubicazioni_componente(OLD_ID_UBICAZIONE);
      fetch cfk1_ubicazioni_componente into dummy;
      found := cfk1_ubicazioni_componente%FOUND; /* %FOUND */
      close cfk1_ubicazioni_componente;
      if found
      then
         errno  := -20006;
         errmsg := 'Esistono riferimenti su Ubicazioni componente. La registrazione di Ubicazioni unita non e'' eliminabile. (UBICAZIONI_COMPONENTE.UBCO_UBUN_FK)';
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

