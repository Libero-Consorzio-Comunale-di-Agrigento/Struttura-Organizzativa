CREATE OR REPLACE FORCE VIEW VISTA_UBICAZIONI
(ID_ELEMENTO_FISICO, PROGR_UNITA_FISICA, CODICE_UF, DENOMINAZIONE, DAL, 
 AL, ID_UNITA_FISICA_PADRE, PROGR_UNITA_PADRE, PROGR_UNITA_ORGANIZZATIVA, DES_ABB, 
 INDIRIZZO, CAP, PROVINCIA, COMUNE, NOTA_INDIRIZZO, 
 AMMINISTRAZIONE, UTENTE_AGGIORNAMENTO, DATA_AGGIORNAMENTO, ID_SUDDIVISIONE, SUDDIVISIONE, 
 DESCR_SUDDIVISIONE, UTENTE_AGG_ANAG, DATA_AGG_ANAG, ID_UBICAZIONE_UNITA)
BEQUEATH DEFINER
AS 
select uf.id_elemento_fisico
      ,uf.progr_unita_fisica
      ,uf.codice_uf
      ,uf.denominazione
      ,greatest(uf.dal, uu.dal) dal
      ,decode(least(nvl(uf.al, to_date(3333333, 'j')), nvl(uu.al, to_date(3333333, 'j')))
             ,to_date(3333333, 'j')
             ,to_date(null)
             ,least(nvl(uf.al, to_date(3333333, 'j')), nvl(uu.al, to_date(3333333, 'j')))) al
      ,uf.id_unita_fisica_padre
      ,uf.progr_unita_padre
      ,uu.progr_unita_organizzativa
      ,uf.des_abb
      ,uf.indirizzo
      ,uf.cap
      ,uf.provincia
      ,uf.comune
      ,uf.nota_indirizzo
      ,uf.amministrazione
      ,uf.utente_aggiornamento
      ,uf.data_aggiornamento
      ,uf.id_suddivisione
      ,uf.suddivisione
      ,uf.descr_suddivisione
      ,uf.utente_agg_anag
      ,uf.data_agg_anag
      ,uu.id_ubicazione id_ubicazione_unita
  from vista_unita_fisiche uf
      ,ubicazioni_unita    uu
 where uf.dal <= nvl(uu.al, to_date(3333333, 'j'))
   and nvl(uf.al, to_date(3333333, 'j')) >= uu.dal
   and uf.progr_unita_fisica = uu.progr_unita_fisica;


