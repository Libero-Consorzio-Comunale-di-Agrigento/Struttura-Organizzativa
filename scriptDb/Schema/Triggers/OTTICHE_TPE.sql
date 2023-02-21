CREATE OR REPLACE TRIGGER ottiche_tpe
/******************************************************************************
    NOME:        ottiche_TPE
    DESCRIZIONE: Trigger per pubblicazione eventi
                          at INSERT or UPDATE or DELETE on Table ottiche
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  14/03/2014 MM     Prima emissione.
   ******************************************************************************/
   after insert or update or delete on ottiche
   for each row
declare
   d_new_ottiche ottiche_b%rowtype;
   d_old_ottiche ottiche_b%rowtype;
   d_operazione  varchar2(1);
   integrity_error exception;
   errno  integer;
   errmsg char(200);
begin

   if nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO', 'PubblicazioneModifiche', 0)
         ,'NO') = 'SI' then
      begin
         if inserting or updating then
            d_new_ottiche.ottica                   := :new.ottica;
            d_new_ottiche.descrizione              := :new.descrizione;
            d_new_ottiche.descrizione_al1          := :new.descrizione_al1;
            d_new_ottiche.descrizione_al2          := :new.descrizione_al2;
            d_new_ottiche.nota                     := :new.nota;
            d_new_ottiche.amministrazione          := :new.amministrazione;
            d_new_ottiche.ottica_istituzionale     := :new.ottica_istituzionale;
            d_new_ottiche.gestione_revisioni       := :new.gestione_revisioni;
            d_new_ottiche.utente_aggiornamento     := :new.utente_aggiornamento;
            d_new_ottiche.data_aggiornamento       := :new.data_aggiornamento;
            d_new_ottiche.ottica_origine           := :new.ottica_origine;
            d_new_ottiche.aggiornamento_componenti := :new.aggiornamento_componenti;
         
            if inserting then
               d_operazione := 'I';
            end if;
         end if;
         if updating or deleting then
            d_old_ottiche.ottica                   := :old.ottica;
            d_old_ottiche.descrizione              := :old.descrizione;
            d_old_ottiche.descrizione_al1          := :old.descrizione_al1;
            d_old_ottiche.descrizione_al2          := :old.descrizione_al2;
            d_old_ottiche.nota                     := :old.nota;
            d_old_ottiche.amministrazione          := :old.amministrazione;
            d_old_ottiche.ottica_istituzionale     := :old.ottica_istituzionale;
            d_old_ottiche.gestione_revisioni       := :old.gestione_revisioni;
            d_old_ottiche.utente_aggiornamento     := :old.utente_aggiornamento;
            d_old_ottiche.data_aggiornamento       := :old.data_aggiornamento;
            d_old_ottiche.ottica_origine           := :old.ottica_origine;
            d_old_ottiche.aggiornamento_componenti := :old.aggiornamento_componenti;
         
            if updating then
               d_operazione := 'U';
            else
               d_operazione := 'D';
            end if;
         end if;
      
         so4_pubblicazione_modifiche.registra_ottica(d_new_ottiche
                                                    ,d_old_ottiche
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


