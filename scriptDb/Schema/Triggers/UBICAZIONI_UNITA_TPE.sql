CREATE OR REPLACE TRIGGER ubicazioni_unita_tpe
/******************************************************************************
    NOME:        UBICAZIONI_UNITA_TPE
    DESCRIZIONE: Trigger per pubblicazione eventi
                          at INSERT or UPDATE or DELETE on Table UBICAZIONI_UNITA
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  14/03/2014 MM     Prima emissione.
   ******************************************************************************/
   after insert or update or delete on ubicazioni_unita
   for each row
declare
   d_new_ubicazioni_unita ubicazioni_unita_b%rowtype;
   d_old_ubicazioni_unita ubicazioni_unita_b%rowtype;
   d_operazione           varchar2(1);
   integrity_error exception;
   errno  integer;
   errmsg char(200);
begin

   if nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO', 'PubblicazioneModifiche', 0)
         ,'NO') = 'SI' then
      begin
         if inserting or updating then
            d_new_ubicazioni_unita.id_ubicazione             := :new.id_ubicazione;
            d_new_ubicazioni_unita.progr_unita_organizzativa := :new.progr_unita_organizzativa;
            d_new_ubicazioni_unita.sequenza                  := :new.sequenza;
            d_new_ubicazioni_unita.dal                       := :new.dal;
            d_new_ubicazioni_unita.al                        := :new.al;
            d_new_ubicazioni_unita.progr_unita_fisica        := :new.progr_unita_fisica;
            d_new_ubicazioni_unita.id_origine                := :new.id_origine;
            d_new_ubicazioni_unita.utente_aggiornamento      := :new.utente_aggiornamento;
            d_new_ubicazioni_unita.data_aggiornamento        := :new.data_aggiornamento;
         
            if inserting then
               d_operazione := 'I';
            end if;
         end if;
         if updating or deleting then
            d_old_ubicazioni_unita.id_ubicazione             := :old.id_ubicazione;
            d_old_ubicazioni_unita.progr_unita_organizzativa := :old.progr_unita_organizzativa;
            d_old_ubicazioni_unita.sequenza                  := :old.sequenza;
            d_old_ubicazioni_unita.dal                       := :old.dal;
            d_old_ubicazioni_unita.al                        := :old.al;
            d_old_ubicazioni_unita.progr_unita_fisica        := :old.progr_unita_fisica;
            d_old_ubicazioni_unita.id_origine                := :old.id_origine;
            d_old_ubicazioni_unita.utente_aggiornamento      := :old.utente_aggiornamento;
            d_old_ubicazioni_unita.data_aggiornamento        := :old.data_aggiornamento;
         
            if updating then
               d_operazione := 'U';
            else
               d_operazione := 'D';
            end if;
         end if;
      
         so4_pubblicazione_modifiche.registra_ubicazione_unita(d_new_ubicazioni_unita
                                                              ,d_old_ubicazioni_unita
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


