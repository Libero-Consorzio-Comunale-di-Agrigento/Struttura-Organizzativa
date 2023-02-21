CREATE OR REPLACE FORCE VIEW ANAGRAFE_STRUTTURA
(PROGR_UNITA_ORGANIZZATIVA, DAL, AL, CODICE_UO, DESCRIZIONE, 
 DESCRIZIONE_AL1, DESCRIZIONE_AL2, DES_ABB, DES_ABB_AL1, DES_ABB_AL2, 
 ID_SUDDIVISIONE, SUDDIVISIONE, DESCRIZIONE_SUDDIVISIONE, OTTICA, REVISIONE_ISTITUZIONE, 
 REVISIONE_CESSAZIONE, TIPOLOGIA_UNITA, SE_GIURIDICO, ASSEGNAZIONE_COMPONENTI, AMMINISTRAZIONE, 
 PROGR_AOO, UTENTE_AD4, NOTE, TIPO_UNITA, AL_PREC)
BEQUEATH DEFINER
AS 
select a.progr_unita_organizzativa
      ,a.dal
      ,a.al
      ,a.codice_uo
      ,a.descrizione
      ,a.descrizione_al1
      ,a.descrizione_al2
      ,a.des_abb
      ,a.des_abb_al1
      ,a.des_abb_al2
      ,a.id_suddivisione
      ,suddivisione_struttura.get_suddivisione(a.id_suddivisione)
      ,suddivisione_struttura.get_descrizione(a.id_suddivisione)
      ,o.ottica
      ,a.revisione_istituzione
      ,a.revisione_cessazione
      ,a.tipologia_unita
      ,a.se_giuridico
      ,a.assegnazione_componenti
      ,a.amministrazione
      ,a.progr_aoo
      ,a.utente_ad4
      ,a.note
      ,a.tipo_unita
      ,a.al_prec
  from anagrafe_unita_organizzative a
      ,(select distinct a.ottica ottica_a
                       ,u.ottica ottica
          from anagrafe_unita_organizzative a
              ,unita_organizzative          u
         where a.progr_unita_organizzativa = u.progr_unita_organizzativa
           and u.dal <= nvl(u.al, to_date(3333333, 'j'))
           and a.dal <= nvl(a.al, to_date(3333333, 'j'))
        union
        select distinct ottica
                       ,ottica
          from anagrafe_unita_organizzative a
         where a.dal <= nvl(a.al, to_date(3333333, 'j'))
           and not exists
         (select 'x'
                  from unita_organizzative
                 where progr_unita_organizzativa = a.progr_unita_organizzativa
                 and dal <= nvl(al,to_date(3333333,'j')) )) o
  where a.ottica = o.ottica_a
    and a.dal <= nvl(a.al,to_date(3333333,'j'));


