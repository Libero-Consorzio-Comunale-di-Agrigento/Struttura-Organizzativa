CREATE OR REPLACE FORCE VIEW VISTA_UNITA_FISICHE
(ID_ELEMENTO_FISICO, PROGR_UNITA_FISICA, CODICE_UF, DENOMINAZIONE, DAL, 
 AL, ID_UNITA_FISICA_PADRE, PROGR_UNITA_PADRE, DES_ABB, INDIRIZZO, 
 CAP, PROVINCIA, COMUNE, NOTA_INDIRIZZO, AMMINISTRAZIONE, 
 UTENTE_AGGIORNAMENTO, DATA_AGGIORNAMENTO, ID_SUDDIVISIONE, SUDDIVISIONE, DESCR_SUDDIVISIONE, 
 UTENTE_AGG_ANAG, DATA_AGG_ANAG)
BEQUEATH DEFINER
AS 
select u.id_elemento_fisico
     , u.progr_unita_fisica
     , a.codice_uf
     , a.denominazione
     , greatest(u.dal, a.dal) dal
     , decode(least(nvl(u.al, to_date(3333333, 'j')), nvl(a.al, to_date(3333333, 'j')))
             ,to_date(3333333,'j'),to_date(null)
             ,least(nvl(u.al, to_date(3333333, 'j')), nvl(a.al, to_date(3333333, 'j')))) al
     , u.id_unita_fisica_padre
     , unita_fisica.get_progr_unita_fisica(u.id_unita_fisica_padre) progr_unita_padre
     , a.des_abb
     , a.indirizzo||decode(nvl(a.numero_civico,-1),-1,' ',', '||a.numero_civico) indirizzo --#45393
     , a.cap
     , a.provincia
     , a.comune
     , a.nota_indirizzo
     , a.amministrazione
     , u.utente_aggiornamento
     , u.data_aggiornamento
     , a.id_suddivisione
     , suddivisione_fisica.get_suddivisione(a.id_suddivisione) suddivisione
     , suddivisione_fisica.get_denominazione(a.id_suddivisione) descr_suddivisione
     , a.utente_aggiornamento utente_agg_anag
     , a.data_aggiornamento data_agg_anag
  from unita_fisiche          u
     , anagrafe_unita_fisiche a
 where u.dal <= nvl(a.al,to_date(3333333,'j'))
   and nvl(u.al,to_date(3333333,'j'))  >= a.dal
   and u.progr_unita_fisica = a.progr_unita_fisica;


