CREATE OR REPLACE FORCE VIEW STORICO_UBIC_COMPONENTI
(OTTICA, ENTE, ENTE_NI, ENTE_DENOMINAZIONE, NI, 
 CI, DAL, AL, PROGR_UNITA_ORGANIZZATIVA, CODICE_UO, 
 DESCR_UO, PROGR_UNITA_FISICA, CODICE_UF, DESCR_UF, UTENTE_AGG, 
 DATA_AGG, ID_COMPONENTE, ID_UBICAZIONE_COMPONENTE, ID_UBICAZIONE_UNITA)
BEQUEATH DEFINER
AS 
select u.ottica
     , substr(ottica.get_amministrazione (u.ottica),1,16) ente
     , amministrazione.get_ni(ottica.get_amministrazione (u.ottica)) ente_ni
     , substr(soggetti_get_descr(amministrazione.get_ni(ottica.get_amministrazione (u.ottica)), trunc(sysdate), 'DESCRIZIONE'),1,240) ente_denominazione
     , c.ni
     , c.ci
     , greatest(u.dal, c.dal) dal
     , decode(least(nvl(u.al,to_date(3333333,'j')),nvl(c.al,to_date(3333333,'j'))),to_date(3333333,'j'),to_date(null),
              least(nvl(u.al,to_date(3333333,'j')),nvl(c.al,to_date(3333333,'j')))) al
     , u.progr_unita_organizzativa
     , u.codice_uo
     , u.descrizione descr_uo
     , ubicazione_unita.get_progr_unita_fisica(c.id_ubicazione_unita) progr_unita_fisica
     , anagrafe_unita_fisica.get_codice_uf(ubicazione_unita.get_progr_unita_fisica(c.id_ubicazione_unita),greatest(u.dal, c.dal)) codice_uf 
     , anagrafe_unita_fisica.get_denominazione(ubicazione_unita.get_progr_unita_fisica(c.id_ubicazione_unita),greatest(u.dal, c.dal)) descr_uf
     , c.utente_agg_ubic utente_agg 
     , c.data_agg_ubic data_agg 
     , c.id_componente
     , c.id_ubicazione_componente
     , c.id_ubicazione_unita
  from vista_unita_organizzative u
     , vista_ubic_componenti c
 where u.dal <= nvl(c.al, to_date(3333333, 'j'))
   and nvl(u.al, to_date(3333333, 'j')) >= c.dal
   and u.progr_unita_organizzativa = c.progr_unita_organizzativa
   and u.ottica = c.ottica
union
select to_char(null) ottica
      ,substr(u.amministrazione, 1, 16) ente
      ,amministrazione.get_ni(u.amministrazione) ente_ni
      ,substr(soggetti_get_descr(amministrazione.get_ni(u.amministrazione)
                                ,trunc(sysdate)
                                ,'DESCRIZIONE')
             ,1
             ,240) ente_denominazione
      ,a.ni
      ,to_number(null) -- ci
      ,a.dal
      ,a.al
      ,to_number(null) -- progr. uo
      ,to_char(null)   -- codice uo
      ,to_char(null)   -- descr_uo
      ,a.progr_unita_fisica
      ,u.codice_uf
      ,u.denominazione descr_uf
      ,a.utente_aggiornamento utente_agg
      ,a.data_aggiornamento data_agg
      ,to_number(null)
      ,to_number(null)
      ,to_number(null)
  from assegnazioni_fisiche a
      ,anagrafe_unita_fisiche u
 where nvl(a.al, to_date(3333333, 'j'))between u.dal and nvl(u.al,to_date(3333333,'j')) 
   and u.progr_unita_fisica  = a.progr_unita_fisica;


