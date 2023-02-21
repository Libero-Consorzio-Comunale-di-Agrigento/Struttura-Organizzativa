CREATE OR REPLACE TRIGGER impostazioni_tiu
/******************************************************************************
    NOME:        IMPOSTAZIONI_TIU
    DESCRIZIONE: Trigger for Set DATA Integrity
                             Set FUNCTIONAL Integrity
                          on view IMPOSTAZIONI
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
       0 27/03/2019 MM     Creazione #34049
   ******************************************************************************/
   instead of update on impostazioni
   for each row
declare
   integrity_error exception;
   errno         integer;
   errmsg        char(200);
   found         boolean;
   d_user_oracle ad4_istanze.user_oracle%type;
begin
   update impostazioni_table
      set id_parametri             = :new.id_parametri
         ,integr_cg4               = :new.integr_cg4
         ,integr_gp4               = :old.integr_gp4
         ,integr_gs4               = :new.integr_gs4
         ,assegnazione_definitiva  = :new.assegnazione_definitiva
         ,procedura_nominativo     = :old.procedura_nominativo
         ,visualizza_suddivisione  = :new.visualizza_suddivisione
         ,visualizza_codice        = :new.visualizza_codice
         ,agg_anagrafe_dipendenti  = :new.agg_anagrafe_dipendenti
         ,data_inizio_integrazione = :new.data_inizio_integrazione
         ,obbligo_imbi             = :new.obbligo_imbi
         ,obbligo_sefi             = :new.obbligo_sefi;
exception
   when integrity_error then
      integritypackage.initnestlevel;
      raise_application_error(errno, errmsg);
   when others then
      integritypackage.initnestlevel;
      raise;
end;
/


