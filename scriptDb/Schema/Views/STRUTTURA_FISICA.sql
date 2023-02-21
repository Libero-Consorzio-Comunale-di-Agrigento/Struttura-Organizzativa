CREATE OR REPLACE FORCE VIEW STRUTTURA_FISICA
(AMMINISTRAZIONE, ORDINAMENTO, PROGR_UNITA_FISICA, CODICE_PADRE, DESCR_PADRE, 
 CODICE_FIGLIO, DESCR_FIGLIO, ID_SUDDIVISIONE, ICONA_STANDARD)
BEQUEATH DEFINER
AS 
select s.amministrazione
      ,so4_util_fis.get_ordinamento(s.progr_unita_fisica
                                   ,trunc(sysdate)
                                   ,s.amministrazione) ordinamento
      ,s.progr_unita_fisica
      ,anagrafe_unita_fisica.get_codice_uf(s.id_unita_fisica_padre, trunc(sysdate)) codice_padre
      ,anagrafe_unita_fisica.get_denominazione(s.id_unita_fisica_padre, trunc(sysdate)) descr_padre
      ,anagrafe_unita_fisica.get_codice_uf(s.progr_unita_fisica, trunc(sysdate)) codice_figlio
      ,anagrafe_unita_fisica.get_denominazione(s.progr_unita_fisica, trunc(sysdate)) descr_figlio
      ,anagrafe_unita_fisica.get_id_suddivisione(s.progr_unita_fisica, trunc(sysdate)) id_suddivisione
      ,suddivisione_struttura.get_icona_standard(anagrafe_unita_fisica.get_id_suddivisione(s.progr_unita_fisica
                                                                                          ,trunc(sysdate))) icona_standard
  from unita_fisiche s
 where trunc(sysdate) between s.dal and nvl(s.al, to_date('3333333', 'j'));


