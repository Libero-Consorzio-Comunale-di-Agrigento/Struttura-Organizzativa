CREATE OR REPLACE TRIGGER ubicazioni_componente_tpe
/******************************************************************************
    NOME:        UBICAZIONI_COMPONENTE_TPE
    DESCRIZIONE: Trigger for Set REFERENTIAL Integrity
                          at INSERT or UPDATE on Table UBICAZIONI_COMPONENTE
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  14/03/2014 MM     Prima emissione.
   ******************************************************************************/
   after insert or update or delete on ubicazioni_componente
   for each row
declare
   d_new_ubicazioni_componente ubicazioni_componente_b%rowtype;
   d_old_ubicazioni_componente ubicazioni_componente_b%rowtype;
   d_operazione                varchar2(1);
   integrity_error exception;
   errno  integer;
   errmsg char(200);
begin

   if nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO', 'PubblicazioneModifiche', 0)
         ,'NO') = 'SI' then
      begin
         if inserting or updating then
            d_new_ubicazioni_componente.id_ubicazione_componente := :new.id_ubicazione_componente;
            d_new_ubicazioni_componente.id_componente            := :new.id_componente;
            d_new_ubicazioni_componente.id_ubicazione_unita      := :new.id_ubicazione_unita;
            d_new_ubicazioni_componente.dal                      := :new.dal;
            d_new_ubicazioni_componente.al                       := :new.al;
            d_new_ubicazioni_componente.id_origine               := :new.id_origine;
            d_new_ubicazioni_componente.utente_aggiornamento     := :new.utente_aggiornamento;
            d_new_ubicazioni_componente.data_aggiornamento       := :new.data_aggiornamento;
         
            if inserting then
               d_operazione := 'I';
            end if;
         end if;
         if updating or deleting then
            d_old_ubicazioni_componente.id_ubicazione_componente := :old.id_ubicazione_componente;
            d_old_ubicazioni_componente.id_componente            := :old.id_componente;
            d_old_ubicazioni_componente.id_ubicazione_unita      := :old.id_ubicazione_unita;
            d_old_ubicazioni_componente.dal                      := :old.dal;
            d_old_ubicazioni_componente.al                       := :old.al;
            d_old_ubicazioni_componente.id_origine               := :old.id_origine;
            d_old_ubicazioni_componente.utente_aggiornamento     := :old.utente_aggiornamento;
            d_old_ubicazioni_componente.data_aggiornamento       := :old.data_aggiornamento;
         
            if updating then
               d_operazione := 'U';
            else
               d_operazione := 'D';
            end if;
         end if;
      
         so4_pubblicazione_modifiche.registra_ubicazione_componente(d_new_ubicazioni_componente
                                                                   ,d_old_ubicazioni_componente
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


