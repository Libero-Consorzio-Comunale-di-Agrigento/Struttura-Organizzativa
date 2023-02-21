CREATE OR REPLACE FORCE VIEW VISTA_BROWSER_ASS_FISICHE
(ID_ASFI, NI, DAL, AL, AMMINISTRAZIONE, 
 PROGR_UNITA_FISICA, UNITA_FISICA, TIPO_ASSEGNAZIONE, ESTERNO, NOMINATIVO, 
 CODICE_FISCALE, ID_COMPONENTE, UNITA_LOGICA, NOTE_ASSEGNAZIONE)
BEQUEATH DEFINER
AS 
select af.id_asfi
      ,af.ni
      ,af.dal
      ,af.al
      ,uf.amministrazione
      ,af.progr_unita_fisica
      ,uf.denominazione || ' (' || uf.codice_uf || ')' unita_fisica
      ,'D' tipo_assegnazione
      ,(select distinct 'SI' from componenti
         where not exists (select 'x' from componenti
                            where ni = af.ni
                              and dal <= nvl (af.al, to_date (3333333, 'j'))
                              and nvl (al, to_date (3333333, 'j')) >= af.dal)) esterno
      ,an.cognome || '  ' || an.nome nominativo
      ,an.codice_fiscale
      ,so4_pkg.get_assegnazione_logica(af.ni
                                      ,uf.amministrazione
                                      ,nvl(uf.al, to_date(3333333, 'j'))) id_componente
      ,so4_pkg.get_descr_assegnazione_logica(af.ni
                                      ,uf.amministrazione
                                      ,nvl(uf.al, to_date(3333333, 'j'))) unita_logica
      ,to_char(null) note_assegnazione
  from assegnazioni_fisiche   af
      ,anagrafe_unita_fisiche uf
      ,anagrafe_soggetti      an
 where af.ni = an.ni
   and af.id_ubicazione_componente is null
   and uf.progr_unita_fisica = af.progr_unita_fisica
   and nvl(af.al, to_date(3333333, 'j')) between uf.dal 
                                             and nvl(uf.al, to_date(3333333, 'j'))
union
select af.id_asfi
      ,af.ni
      ,af.dal
      ,af.al
      ,anagrafe_unita_fisica.get_amministrazione(af.progr_unita_fisica
                                                ,anagrafe_unita_fisica.get_dal_id(af.progr_unita_fisica
                                                                                 ,nvl(af.al
                                                                                     ,to_date(3333333
                                                                                             ,'j')))) amministrazione
      ,af.progr_unita_fisica
      ,uf.denominazione || ' (' || uf.codice_uf || ')' unita_fisica
      ,'L' tipo_assegnazione
      ,'NO' esterno
      ,an.cognome || '  ' || an.nome nominativo
      ,an.codice_fiscale
      ,uc.id_componente
      ,a.descrizione || ' (' || a.codice_uo || ')' || ' - Incarico : ' ||
               nvl(tipo_incarico.get_descrizione(attributo_componente.get_incarico_valido(uc.id_componente
                                                                                     ,nvl(af.al, to_date(3333333, 'j'))
                                                                                     ,componente.get_ottica(uc.id_componente))),'non definito')
      ,to_char(null) note_assegnazione
  from assegnazioni_fisiche   af
      ,ubicazioni_componente  uc
      ,anagrafe_unita_fisiche uf
      ,ubicazioni_unita       uu
      ,anagrafe_unita_organizzative a
      ,anagrafe_soggetti      an
 where af.ni = an.ni
   and af.id_ubicazione_componente = uc.id_ubicazione_componente
   and uc.id_ubicazione_unita = uu.id_ubicazione
   and nvl(af.al, to_date(3333333, 'j')) between uc.dal 
                                             and nvl(uc.al, to_date(3333333, 'j'))
   and a.progr_unita_organizzativa = uu.progr_unita_organizzativa
   and  nvl(af.al, to_date(3333333, 'j')) between a.dal 
                                              and nvl(a.al, to_date(3333333, 'j'))
   and uf.progr_unita_fisica = af.progr_unita_fisica
   and nvl(af.al, to_date(3333333, 'j')) between uf.dal 
                                             and nvl(uf.al, to_date(3333333, 'j'));


