CREATE OR REPLACE TRIGGER imputazioni_bilancio_tpe
/******************************************************************************
    NOME:        imputazioni_bilancio_TPE
    DESCRIZIONE: Trigger per pubblicazione eventi
                          at INSERT or UPDATE or DELETE on Table imputazioni_bilancio
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  14/03/2014 MM     Prima emissione.
   ******************************************************************************/
   after insert or update or delete on imputazioni_bilancio
   for each row
declare
   d_new_imputazioni_bilancio imputazioni_bilancio_b%rowtype;
   d_old_imputazioni_bilancio imputazioni_bilancio_b%rowtype;
   d_operazione               varchar2(1);
   integrity_error exception;
   errno  integer;
   errmsg char(200);
begin

   if nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO', 'PubblicazioneModifiche', 0)
         ,'NO') = 'SI' then
      begin
         if inserting or updating then
            d_new_imputazioni_bilancio.id_imputazione := :new.id_imputazione;
            d_new_imputazioni_bilancio.id_componente  := :new.id_componente;
            d_new_imputazioni_bilancio.numero         := :new.numero;
            d_new_imputazioni_bilancio.dal            := :new.dal;
            d_new_imputazioni_bilancio.al             := :new.al;
            d_new_imputazioni_bilancio.utente_agg     := :new.utente_agg;
            d_new_imputazioni_bilancio.data_agg       := :new.data_agg;
         
            if inserting then
               d_operazione := 'I';
            end if;
         end if;
         if updating or deleting then
            d_old_imputazioni_bilancio.id_imputazione := :old.id_imputazione;
            d_old_imputazioni_bilancio.id_componente  := :old.id_componente;
            d_old_imputazioni_bilancio.numero         := :old.numero;
            d_old_imputazioni_bilancio.dal            := :old.dal;
            d_old_imputazioni_bilancio.al             := :old.al;
            d_old_imputazioni_bilancio.utente_agg     := :old.utente_agg;
            d_old_imputazioni_bilancio.data_agg       := :old.data_agg;
         
            if updating then
               d_operazione := 'U';
            else
               d_operazione := 'D';
            end if;
         end if;
      
         so4_pubblicazione_modifiche.registra_imputazione_bilancio(d_new_imputazioni_bilancio
                                                                  ,d_old_imputazioni_bilancio
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


