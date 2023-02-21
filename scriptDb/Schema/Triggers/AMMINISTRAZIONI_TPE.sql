CREATE OR REPLACE TRIGGER amministrazioni_tpe
/******************************************************************************
    NOME:        amministrazioni_TPE
    DESCRIZIONE: Trigger per pubblicazione eventi
                          at INSERT or UPDATE or DELETE on Table amministrazioni
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  14/03/2014 MM     Prima emissione.
   ******************************************************************************/
   after insert or update or delete on amministrazioni
   for each row
declare
   d_new_amministrazioni amministrazioni_b%rowtype;
   d_old_amministrazioni amministrazioni_b%rowtype;
   d_operazione          varchar2(1);
   integrity_error exception;
   errno  integer;
   errmsg char(200);
begin

   if nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO', 'PubblicazioneModifiche', 0)
         ,'NO') = 'SI' then
      begin
         if inserting or updating then
            d_new_amministrazioni.codice_amministrazione := :new.codice_amministrazione;
            d_new_amministrazioni.ni                     := :new.ni;
            d_new_amministrazioni.data_istituzione       := :new.data_istituzione;
            d_new_amministrazioni.data_soppressione      := :new.data_soppressione;
            d_new_amministrazioni.ente                   := :new.ente;
            d_new_amministrazioni.utente_aggiornamento   := :new.utente_aggiornamento;
            d_new_amministrazioni.data_aggiornamento     := :new.data_aggiornamento;
         
            if inserting then
               d_operazione := 'I';
            end if;
         end if;
         if updating or deleting then
            d_old_amministrazioni.codice_amministrazione := :old.codice_amministrazione;
            d_old_amministrazioni.ni                     := :old.ni;
            d_old_amministrazioni.data_istituzione       := :old.data_istituzione;
            d_old_amministrazioni.data_soppressione      := :old.data_soppressione;
            d_old_amministrazioni.ente                   := :old.ente;
            d_old_amministrazioni.utente_aggiornamento   := :old.utente_aggiornamento;
            d_old_amministrazioni.data_aggiornamento     := :old.data_aggiornamento;
         
            if updating then
               d_operazione := 'U';
            else
               d_operazione := 'D';
            end if;
         end if;
      
         so4_pubblicazione_modifiche.registra_amministrazione(d_new_amministrazioni
                                                             ,d_old_amministrazioni
                                                             ,d_operazione);
      
      end;
   end if;
exception
   when integrity_error then
      integritypackage.initnestlevel;
      raise_application_error(errno, errmsg);
   when others then
      integritypackage.initnestlevel;
      raise;
end;
/


