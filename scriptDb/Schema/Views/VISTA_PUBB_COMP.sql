CREATE OR REPLACE FORCE VIEW VISTA_PUBB_COMP
(ID_COMPONENTE, PROGR_UNITA_ORGANIZZATIVA, DAL, AL, NI, 
 CI, DENOMINAZIONE, DENOMINAZIONE_AL1, DENOMINAZIONE_AL2, STATO, 
 OTTICA, REVISIONE_ASSEGNAZIONE, REVISIONE_CESSAZIONE, UTENTE_AGGIORNAMENTO, DATA_AGGIORNAMENTO, 
 CODICE_FISCALE)
BEQUEATH DEFINER
AS 
select id_componente
     , progr_unita_organizzativa
     , dal_pubb dal
     , al_pubb al
     , ni
     , ci
     , denominazione
     , denominazione_al1
     , denominazione_al2
     , stato
     , ottica
     , revisione_assegnazione
     , revisione_cessazione
     , utente_aggiornamento
     , data_aggiornamento
     , codice_fiscale
  from componenti
 where dal_pubb is not null;


