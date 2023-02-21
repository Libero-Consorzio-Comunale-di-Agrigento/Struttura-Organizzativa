CREATE OR REPLACE TRIGGER soggetti_rubrica_tpe
/******************************************************************************
    NOME:        SOGGETTI_RUBRICA_TPE
    DESCRIZIONE: Trigger per pubblicazione eventi
                          at INSERT or UPDATE or DELETE on Table SOGGETTI_RUBRICA
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  14/03/2014 MM     Prima emissione.
   ******************************************************************************/
   after insert or update or delete on soggetti_rubrica
   for each row
declare
   d_new_soggetti_rubrica soggetti_rubrica_b%rowtype;
   d_old_soggetti_rubrica soggetti_rubrica_b%rowtype;
   d_operazione           varchar2(1);
   integrity_error exception;
   errno  integer;
   errmsg char(200);
begin

   if nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO', 'PubblicazioneModifiche', 0)
         ,'NO') = 'SI' then
      begin
         if inserting or updating then
            d_new_soggetti_rubrica.ni                   := :new.ni;
            d_new_soggetti_rubrica.tipo_contatto        := :new.tipo_contatto;
            d_new_soggetti_rubrica.progressivo          := :new.progressivo;
            d_new_soggetti_rubrica.contatto             := :new.contatto;
            d_new_soggetti_rubrica.riferimento_tipo     := :new.riferimento_tipo;
            d_new_soggetti_rubrica.riferimento          := :new.riferimento;
            d_new_soggetti_rubrica.pubblicabile         := :new.pubblicabile;
            d_new_soggetti_rubrica.utente_agg           := :new.utente_agg;
            d_new_soggetti_rubrica.data_agg             := :new.data_agg;
            d_new_soggetti_rubrica.descrizione_contatto := :new.descrizione_contatto;
         
            if inserting then
               d_operazione := 'I';
            end if;
         end if;
         if updating or deleting then
            d_old_soggetti_rubrica.ni                   := :old.ni;
            d_old_soggetti_rubrica.tipo_contatto        := :old.tipo_contatto;
            d_old_soggetti_rubrica.progressivo          := :old.progressivo;
            d_old_soggetti_rubrica.contatto             := :old.contatto;
            d_old_soggetti_rubrica.riferimento_tipo     := :old.riferimento_tipo;
            d_old_soggetti_rubrica.riferimento          := :old.riferimento;
            d_old_soggetti_rubrica.pubblicabile         := :old.pubblicabile;
            d_old_soggetti_rubrica.utente_agg           := :old.utente_agg;
            d_old_soggetti_rubrica.data_agg             := :old.data_agg;
            d_old_soggetti_rubrica.descrizione_contatto := :old.descrizione_contatto;
         
            if updating then
               d_operazione := 'U';
            else
               d_operazione := 'D';
            end if;
         end if;
      
         so4_pubblicazione_modifiche.registra_soggetto_rubrica(d_new_soggetti_rubrica
                                                              ,d_old_soggetti_rubrica
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


