CREATE OR REPLACE FORCE VIEW SO_AMMINISTRAZIONI
(CODICE_AMMINISTRAZIONE, DENOMINAZIONE)
BEQUEATH DEFINER
AS 
select a.codice_amministrazione codice_amministrazione
     , soggetti_get_descr(a.ni,trunc(sysdate),'DESCRIZIONE') denominazione
  from amministrazioni a
 where ente = 'SI';


