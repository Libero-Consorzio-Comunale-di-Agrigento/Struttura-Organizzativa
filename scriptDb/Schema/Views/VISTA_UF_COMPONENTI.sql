CREATE OR REPLACE FORCE VIEW VISTA_UF_COMPONENTI
(ID_UBICAZIONE, ID_COMPONENTE, DAL, AL, PROGR_UNITA_FISICA, 
 AMMINISTRAZIONE, CODICE_UF, DENOMINAZIONE, TIPO_ASSEGNAZIONE, COLLOCAZIONE)
BEQUEATH DEFINER
AS 
select to_number(null) id_ubicazione
      ,c.id_componente
      ,c.dal
      ,c.al
      ,a.progr_unita_fisica
      ,a.amministrazione
      ,a.codice_uf
      ,a.denominazione
      ,'D' tipo_assegnazione
      ,so4_util_fis.get_stringa_solo_ascendenti(a.progr_unita_fisica
                                               ,nvl(u.al, to_date(3333333, 'j'))
                                               ,a.amministrazione) collocazione
  from componenti             c
      ,unita_fisiche          u
      ,anagrafe_unita_fisiche a
 where c.dal <= nvl(u.al, to_date(3333333, 'j'))
   and nvl(c.al, to_date(3333333, 'j')) >= u.dal
   and c.dal <= nvl(a.al, to_date(3333333, 'j'))
   and nvl(c.al, to_date(3333333, 'j')) >= a.dal
   and u.progr_unita_fisica = a.progr_unita_fisica
union
select uu.id_ubicazione
      ,c.id_componente
      ,c.dal
      ,c.al
      ,a.progr_unita_fisica
      ,a.amministrazione
      ,a.codice_uf
      ,a.denominazione
      ,'L' tipo_assegnazione
      ,so4_util_fis.get_stringa_solo_ascendenti(a.progr_unita_fisica
                                               ,nvl(u.al, to_date(3333333, 'j'))
                                               ,a.amministrazione) collocazione
  from componenti             c
      ,anagrafe_unita_fisiche a
      ,unita_fisiche          u
      ,ubicazioni_unita       uu
 where c.progr_unita_organizzativa = uu.progr_unita_organizzativa
   and c.dal <= nvl(uu.al, to_date(3333333, 'j'))
   and nvl(c.al, to_date(3333333, 'j')) >= uu.dal
   and uu.progr_unita_fisica = a.progr_unita_fisica
   and c.dal <= nvl(u.al, to_date(3333333, 'j'))
   and nvl(c.al, to_date(3333333, 'j')) >= u.dal
   and u.progr_unita_fisica = a.progr_unita_fisica;


