CREATE OR REPLACE FORCE VIEW ATTRIBUTI_UNITA_FISICA
(PROGR_UNITA_FISICA, ATTRIBUTO, VALORE, DAL, AL, 
 UTENTE_AGGIORNAMENTO, DATA_AGGIORNAMENTO, ORIGINE)
BEQUEATH DEFINER
AS 
select progr_unita_fisica
     , attributo
     , valore
     , dal
     , al
     , utente_aggiornamento
     , data_aggiornamento
     , 'SO'
  from attributi_unita_fisica_so
 union
select progr_unita_fisica
     , attributo
     , valore
     , dal
     , al
     , 'CIWEB'
     , TO_DATE (NULL)
     , 'CI'
  from attributi_unita_fisica_ci;


