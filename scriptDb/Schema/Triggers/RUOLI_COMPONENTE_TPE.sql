CREATE OR REPLACE TRIGGER ruoli_componente_tpe
/******************************************************************************
    NOME:        ruoli_componente_TPE
    DESCRIZIONE: Trigger per pubblicazione eventi
                          at INSERT or UPDATE or DELETE on Table ruoli_componente
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  14/03/2014 MM     Prima emissione.
   ******************************************************************************/
   after insert or update or delete on ruoli_componente
   for each row
declare
   d_new_ruoli_componente ruoli_componente_b%rowtype;
   d_old_ruoli_componente ruoli_componente_b%rowtype;
   d_operazione           varchar2(1);
   integrity_error exception;
   errno  integer;
   errmsg char(200);
begin

   if nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO', 'PubblicazioneModifiche', 0)
         ,'NO') = 'SI' then
      begin
         if inserting or updating then
            d_new_ruoli_componente.id_ruolo_componente  := :new.id_ruolo_componente;
            d_new_ruoli_componente.id_componente        := :new.id_componente;
            d_new_ruoli_componente.ruolo                := :new.ruolo;
            d_new_ruoli_componente.dal                  := :new.dal;
            d_new_ruoli_componente.al                   := :new.al;
            d_new_ruoli_componente.utente_aggiornamento := :new.utente_aggiornamento;
            d_new_ruoli_componente.data_aggiornamento   := :new.data_aggiornamento;
            d_new_ruoli_componente.dal_pubb             := :new.dal_pubb;
            d_new_ruoli_componente.al_pubb              := :new.al_pubb;
            d_new_ruoli_componente.al_prec              := :new.al_prec;
         
            if inserting then
               d_operazione := 'I';
            end if;
         end if;
         if updating or deleting then
            d_old_ruoli_componente.id_ruolo_componente  := :old.id_ruolo_componente;
            d_old_ruoli_componente.id_componente        := :old.id_componente;
            d_old_ruoli_componente.ruolo                := :old.ruolo;
            d_old_ruoli_componente.dal                  := :old.dal;
            d_old_ruoli_componente.al                   := :old.al;
            d_old_ruoli_componente.utente_aggiornamento := :old.utente_aggiornamento;
            d_old_ruoli_componente.data_aggiornamento   := :old.data_aggiornamento;
            d_old_ruoli_componente.dal_pubb             := :old.dal_pubb;
            d_old_ruoli_componente.al_pubb              := :old.al_pubb;
            d_old_ruoli_componente.al_prec              := :old.al_prec;
         
            if updating then
               d_operazione := 'U';
            else
               d_operazione := 'D';
            end if;
         end if;
      
         so4_pubblicazione_modifiche.registra_ruolo_componente(d_new_ruoli_componente
                                                              ,d_old_ruoli_componente
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


