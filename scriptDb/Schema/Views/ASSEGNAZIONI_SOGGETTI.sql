CREATE OR REPLACE FORCE VIEW ASSEGNAZIONI_SOGGETTI
(OTTICA, ENTE, NI, NOMINATIVO, CI, 
 DAL, AL, PROGR_UNITA_ORGANIZZATIVA, CODICE_UO, DESCRIZIONE, 
 SUDDIVISIONE, DESCR_SUDDIVISIONE, PROGR_UNITA_PADRE, CENTRO, INCARICO, 
 DES_INCARICO, RESPONSABILE, ASSEGNAZIONE_PREVALENTE, TIPO_ASSEGNAZIONE, ID_COMPONENTE, 
 ID_ATTR_COMPONENTE)
BEQUEATH DEFINER
AS 
select comp.ottica
      ,unor.amministrazione ente
      ,comp.ni
      ,comp.nominativo
      ,comp.ci
      ,greatest(unor.dal, comp.dal) dal
      ,decode(least(nvl(unor.al, to_date(3333333, 'j'))
                   ,nvl(comp.al, to_date(3333333, 'j')))
             ,to_date(3333333, 'j')
             ,to_date(null)
             ,least(nvl(unor.al, to_date(3333333, 'j'))
                   ,nvl(comp.al, to_date(3333333, 'j')))) al
      ,unor.progr_unita_organizzativa
      ,unor.codice_uo
      ,unor.descrizione
      ,unor.suddivisione
      ,unor.descr_suddivisione
      ,unor.progr_unita_padre
      ,unor.centro
      ,comp.incarico
      ,comp.des_incarico
      ,nvl(comp.responsabile,'NO') responsabile
      ,comp.assegnazione_prevalente
      ,nvl(comp.tipo_assegnazione, 'I') tipo_assegnazione
      ,comp.id_componente
      ,comp.id_attr_componente
  from -- Componenti ----------------------------------------------------
        (select c.id_componente
               ,c.progr_unita_organizzativa
               ,greatest(c.dal, a.dal) dal
               ,decode(least(nvl(decode(nvl(c.revisione_cessazione, -2)
                                       ,nvl(r.revisione, -1)
                                       ,c.al_prec
                                       ,c.al)
                                ,to_date(3333333, 'j'))
                            ,nvl(decode(nvl(a.revisione_cessazione, -2)
                                       ,nvl(r.revisione, -1)
                                       ,a.al_prec
                                       ,a.al)
                                ,to_date(3333333, 'j')))
                      ,to_date(3333333, 'j')
                      ,to_date(null)
                      ,least(nvl(decode(nvl(c.revisione_cessazione, -2)
                                       ,nvl(r.revisione, -1)
                                       ,c.al_prec
                                       ,c.al)
                                ,to_date(3333333, 'j'))
                            ,nvl(decode(nvl(a.revisione_cessazione, -2)
                                       ,nvl(r.revisione, -1)
                                       ,a.al_prec
                                       ,a.al)
                                ,to_date(3333333, 'j')))) al
               ,c.ni
               ,soggetti_get_descr(c.ni, trunc(sysdate), 'COGNOME E NOME') nominativo
               ,c.ci
               ,c.ottica
               ,a.id_attr_componente
               ,a.incarico
               ,i.descrizione des_incarico
               ,i.responsabile responsabile
               ,a.assegnazione_prevalente
               ,a.tipo_assegnazione
           from componenti           c
               ,attributi_componente a
               ,tipi_incarico        i
               ,revisioni_struttura  r
          where nvl(c.revisione_assegnazione, -2) != nvl(r.revisione, -1)
            and nvl(a.revisione_assegnazione, -2) != nvl(r.revisione, -1)
            and a.dal <= nvl(decode(nvl(c.revisione_cessazione, -2)
                                   ,nvl(r.revisione, -1)
                                   ,c.al_prec
                                   ,c.al)
                            ,to_date(3333333, 'j'))
            and nvl(decode(nvl(a.revisione_cessazione, -2)
                          ,nvl(r.revisione, -1)
                          ,a.al_prec
                          ,a.al)
                   ,to_date(3333333, 'j')) >= c.dal
            and c.id_componente = a.id_componente
            and i.incarico(+) = a.incarico
            and r.stato(+) = 'M'
            and r.ottica(+) = c.ottica
            and c.dal <= nvl(c.al, to_date(3333333, 'j'))
            and a.dal <= nvl(a.al, to_date(3333333, 'j'))) comp
       --UO------------------------------------------------------------
      ,(select u.ottica
              ,u.progr_unita_organizzativa
              ,greatest(u.dal, a.dal) dal
              ,decode(least(nvl(decode(nvl(u.revisione_cessazione, -2)
                                      ,nvl(ru.revisione, -1)
                                      ,u.al_prec --#547
                                      ,u.al)
                               ,to_date(3333333, 'j'))
                           ,nvl(decode(nvl(a.revisione_cessazione, -2)
                                      ,nvl(ra.revisione, -1)
                                      ,a.al_prec --#547
                                      ,a.al)
                               ,to_date(3333333, 'j')))
                     ,to_date(3333333, 'j')
                     ,to_date(null)
                     ,least(nvl(decode(nvl(u.revisione_cessazione, -2)
                                      ,nvl(ru.revisione, -1)
                                      ,u.al_prec --#547
                                      ,u.al)
                               ,to_date(3333333, 'j'))
                           ,nvl(decode(nvl(a.revisione_cessazione, -2)
                                      ,nvl(ra.revisione, -1)
                                      ,a.al_prec --#547
                                      ,a.al)
                               ,to_date(3333333, 'j')))) al
              ,u.id_unita_padre progr_unita_padre
              ,a.codice_uo
              ,a.descrizione
              ,s.suddivisione
              ,s.descrizione descr_suddivisione
              ,a.amministrazione
              ,a.centro
          from unita_organizzative          u
              ,anagrafe_unita_organizzative a
              ,suddivisioni_struttura       s
              ,revisioni_struttura          ru
              ,revisioni_struttura          ra
         where u.revisione != nvl(ru.revisione, -1)
           and a.revisione_istituzione != nvl(ra.revisione, -1)
           and ra.ottica(+) = a.ottica
           and ra.stato(+) = 'M'
           and ru.stato(+) = 'M'
           and ru.ottica(+) = u.ottica
           and u.dal <= nvl(decode(nvl(a.revisione_cessazione, -2)
                                  ,nvl(ra.revisione, -1)
                                  ,a.al_prec
                                  ,a.al)
                           ,to_date(3333333, 'j'))
           and nvl(decode(nvl(u.revisione_cessazione, -2)
                         ,nvl(ru.revisione, -1)
                         ,u.al_prec
                         ,u.al)
                  ,to_date(3333333, 'j')) >= a.dal
           and u.progr_unita_organizzativa = a.progr_unita_organizzativa
           and s.id_suddivisione(+) = a.id_suddivisione
           and u.dal <= nvl(u.al, to_date(3333333, 'j'))
           and a.dal <= nvl(a.al, to_date(3333333, 'j'))) unor
----------------------------------------------------------
 where unor.dal <= nvl(comp.al, to_date(3333333, 'j'))
   and nvl(unor.al, to_date(3333333, 'j')) >= comp.dal
   and unor.progr_unita_organizzativa = comp.progr_unita_organizzativa
   and unor.ottica = comp.ottica;


