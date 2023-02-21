CREATE OR REPLACE FORCE VIEW VISTA_ASSEGNAZIONI_FISICHE
(ID_ASFI, ID_COMPONENTE, DAL, AL, CODICE_UF, 
 DENOMINAZIONE_UNITA_FISICA, PROGR_UNITA_FISICA, NI, CI, NOMINATIVO, 
 STATO, OTTICA, ID_UBICAZIONE_COMPONENTE, ID_UBICAZIONE_UNITA, ID_UNITA_FISICA_PADRE, 
 ID_ELEMENTO_FISICO, PROGR_UNITA_PADRE, PROGR_UNITA_ORGANIZZATIVA, DES_ABB, INDIRIZZO, 
 CAP, PROVINCIA, COMUNE, NOTA_INDIRIZZO, AMMINISTRAZIONE, 
 UTENTE_AGGIORNAMENTO, DATA_AGGIORNAMENTO, ID_SUDDIVISIONE, SUDDIVISIONE, DESCR_SUDDIVISIONE, 
 REVISIONE_ASSEGNAZIONE, REVISIONE_CESSAZIONE, CODICE_FISCALE, UNITA_LOGICA, TIPO_ASSEGNAZIONE)
BEQUEATH DEFINER
AS 
select uc.id_asfi
     , uc.id_componente
     , greatest (uc.dal, uu.dal) dal
     , DECODE(LEAST(NVL (uc.al, TO_DATE (3333333, 'j'))
                   ,NVL (uu.al, TO_DATE (3333333, 'j')))
                   ,TO_DATE (3333333, 'j'), TO_DATE (NULL)
                   ,LEAST (NVL (uc.al, TO_DATE (3333333, 'j'))
                   ,NVL (uu.al, TO_DATE (3333333, 'j')))) al
     , uu.codice_uf
     , uu.denominazione denominazione_unita_fisica
     , uu.progr_unita_fisica
     , uc.ni
     , uc.ci
     , a.cognome || '  ' || a.nome nominativo
     , uc.stato
     , uc.ottica
     , uc.id_ubicazione_componente
     , uc.id_ubicazione_unita
     , uu.id_unita_fisica_padre
     , uu.id_elemento_fisico
     , uu.progr_unita_padre
     , uu.progr_unita_organizzativa
     , uu.des_abb
     , uu.indirizzo
     , uu.cap
     , uu.provincia
     , uu.comune
     , uu.nota_indirizzo
     , uu.amministrazione
     , uu.utente_aggiornamento
     , uu.data_aggiornamento
     , uu.id_suddivisione
     , uu.suddivisione
     , uu.descr_suddivisione
     , uc.revisione_assegnazione
     , uc.revisione_cessazione
     , a.codice_fiscale
     , (SELECT MAX (descrizione || decode(IMPOSTAZIONE.GET_VISUALIZZA_CODICE(1),'SI',' (' || codice_uo || ')',null))
          FROM anagrafe_unita_organizzative a
         WHERE progr_unita_organizzativa = uc.progr_unita_organizzativa
           AND LEAST(NVL(uu.al, TO_DATE (3333333, 'j')),NVL(uc.al, TO_DATE (3333333, 'j'))) 
               BETWEEN dal AND NVL( a.al, TO_DATE (3333333,'j'))) unita_logica
     , 'L' tipo_assegnazione
  FROM vista_ubic_componenti uc
     , anagrafe_soggetti a
     , vista_ubicazioni uu
 WHERE uu.id_ubicazione_unita = uc.id_ubicazione_unita
   AND uc.dal <= NVL (uu.al, TO_DATE (3333333, 'j'))
   AND NVL (uc.al, TO_DATE (3333333, 'j')) >= uu.dal
   AND a.ni = uc.ni
 UNION
SELECT af.id_asfi
     , so4_pkg.get_assegnazione_logica ( af.ni
                                       , uf.amministrazione
                                       , NVL (af.al, TO_DATE (3333333, 'j'))) id_componente
     , GREATEST (af.dal, uf.dal) dal
     , DECODE(LEAST(NVL(af.al,TO_DATE(3333333, 'j')),NVL (uf.al, TO_DATE (3333333, 'j')))
             ,TO_DATE(3333333, 'j'),TO_DATE (NULL)
                                   ,LEAST(NVL(af.al, TO_DATE (3333333, 'j')),NVL(uf.al, TO_DATE (3333333, 'j')))) al
     , uf.codice_uf
     , uf.denominazione denominazione_unita_fisica
     , uf.progr_unita_fisica
     , af.ni
     , TO_NUMBER ('') ci
     , a.cognome || '  ' || a.nome nominativo
     , TO_CHAR (NULL) stato
     , TO_CHAR ('') ottica
     , TO_NUMBER ('') id_ubicazione_componente
     , TO_NUMBER ('') id_ubicazione_unita
     , uf.id_unita_fisica_padre
     , uf.id_elemento_fisico
     , uf.progr_unita_padre
     , TO_NUMBER (NULL) progr_unita_organizzativa
     , uf.des_abb
     , uf.indirizzo
     , uf.cap
     , uf.provincia
     , uf.comune
     , uf.nota_indirizzo
     , uf.amministrazione
     , uf.utente_aggiornamento
     , uf.data_aggiornamento
     , uf.id_suddivisione
     , uf.suddivisione
     , uf.descr_suddivisione
     , TO_NUMBER ('') revisione_assegnazione
     , TO_NUMBER ('') revisione_cessazione
     , a.codice_fiscale
     , (SELECT MAX (descrizione || decode(IMPOSTAZIONE.GET_VISUALIZZA_CODICE(1),'SI',' (' || codice_uo || ')',null))
          FROM anagrafe_unita_organizzative a
         WHERE progr_unita_organizzativa = componente.get_progr_unita_organizzativa (
                                           so4_pkg.get_assegnazione_logica ( af.ni
                                                                           , uf.amministrazione
                                                                           , NVL (af.al, TO_DATE (3333333, 'j'))))
           AND LEAST(NVL(af.al, TO_DATE (3333333, 'j')),NVL(uf.al, TO_DATE (3333333, 'j'))) 
               BETWEEN dal AND NVL(a.al,TO_DATE(3333333,'j'))) unita_logica
      , 'D' tipo_assegnazione
  FROM assegnazioni_fisiche af
     , anagrafe_soggetti a
     , vista_unita_fisiche uf
 WHERE uf.progr_unita_fisica = af.progr_unita_fisica
   AND af.id_ubicazione_componente IS NULL
   AND af.dal <= NVL (uf.al, TO_DATE (3333333, 'j'))
   AND NVL (af.al, TO_DATE (3333333, 'j')) >= uf.dal
   AND a.ni = af.ni;


