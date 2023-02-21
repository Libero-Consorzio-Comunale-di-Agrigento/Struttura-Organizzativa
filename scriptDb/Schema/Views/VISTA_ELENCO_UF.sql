CREATE OR REPLACE FORCE VIEW VISTA_ELENCO_UF
(AMMINISTRAZIONE, CODICE_UF, DENOMINAZIONE, DAL, AL, 
 PROGR_UNITA_ORGANIZZATIVA, PROGR_UNITA_FISICA, MODALITA)
BEQUEATH DEFINER
AS 
select amministrazione
      ,codice_uf
      ,denominazione
      ,dal
      ,al
      ,to_number(null) progr_unita_organizzativa
      ,progr_unita_fisica
      ,decode(registro_utility.leggi_stringa('PRODUCTS/SI4SO/MODALITAASSEGNAZIONIFISICHE/' ||
                                             a.amministrazione
                                            ,'ModalitaAssegnazioniFisiche'
                                            ,0)
             ,null
             ,registro_utility.leggi_stringa('PRODUCTS/SI4SO/MODALITAASSEGNAZIONIFISICHE/#'
                                            ,'ModalitaAssegnazioniFisiche'
                                            ,0)) modalita
  from anagrafe_unita_fisiche a
 where decode(registro_utility.leggi_stringa('PRODUCTS/SI4SO/MODALITAASSEGNAZIONIFISICHE/' ||
                                             a.amministrazione
                                            ,'ModalitaAssegnazioniFisiche'
                                            ,0)
             ,null
             ,registro_utility.leggi_stringa('PRODUCTS/SI4SO/MODALITAASSEGNAZIONIFISICHE/#'
                                            ,'ModalitaAssegnazioniFisiche'
                                            ,0)) in  ('D','M')
union
select a.amministrazione
      ,a.codice_uf
      ,a.denominazione
      ,a.dal
      ,a.al
      ,u.progr_unita_organizzativa
      ,a.progr_unita_fisica
      ,decode(registro_utility.leggi_stringa('PRODUCTS/SI4SO/MODALITAASSEGNAZIONIFISICHE/' ||
                                             a.amministrazione
                                            ,'ModalitaAssegnazioniFisiche'
                                            ,0)
             ,null
             ,registro_utility.leggi_stringa('PRODUCTS/SI4SO/MODALITAASSEGNAZIONIFISICHE/#'
                                            ,'ModalitaAssegnazioniFisiche'
                                            ,0)) modalita
  from anagrafe_unita_fisiche a
      ,ubicazioni_unita       u
 where decode(registro_utility.leggi_stringa('PRODUCTS/SI4SO/MODALITAASSEGNAZIONIFISICHE/' ||
                                             a.amministrazione
                                            ,'ModalitaAssegnazioniFisiche'
                                            ,0)
             ,null
             ,registro_utility.leggi_stringa('PRODUCTS/SI4SO/MODALITAASSEGNAZIONIFISICHE/#'
                                            ,'ModalitaAssegnazioniFisiche'
                                            ,0)) in ('M', 'L')
   and a.progr_unita_fisica = u.progr_unita_fisica
   and a.dal <= nvl(u.al,to_date(3333333,'j'))
   and nvl(a.al,to_date(3333333,'j')) >= u.dal
    order by 1
         ,2
         ,4;


