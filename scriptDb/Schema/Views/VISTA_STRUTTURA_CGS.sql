CREATE OR REPLACE FORCE VIEW VISTA_STRUTTURA_CGS
(OTTICA, CODICE_UO, DESCRIZIONE, CODICE_PADRE, DESCRIZIONE_PADRE, 
 SEQUENZA, LIVELLO, NOTE, DATA_INIZIO_VALIDITA, DATA_FINE_VALIDITA)
BEQUEATH DEFINER
AS 
select u.ottica
      ,u.codice_uo
      ,u.descrizione
      ,(select codice_uo
          from anagrafe_unita_organizzative
         where progr_unita_organizzativa = u.progr_unita_padre
           and sysdate between dal and nvl(al, to_date(3333333, 'j'))) codice_padre
      ,(select descrizione
          from anagrafe_unita_organizzative
         where progr_unita_organizzativa = u.progr_unita_padre
           and sysdate between dal and nvl(al, to_date(3333333, 'j'))) descrizione_padre
      ,u.sequenza
      ,level livello
      ,u.note
      ,u.dal data_inizio_validita
      ,(select al
          from vista_unita_organizzative
         where progr_unita_organizzativa = u.progr_unita_organizzativa
           and ottica = u.ottica
           and dal = (select max(dal)
                        from vista_unita_organizzative
                       where progr_unita_organizzativa = u.progr_unita_organizzativa
                         and ottica = u.ottica)) data_fine_validita
  from vista_unita_organizzative u
 where dal = (select max(dal)
                from vista_unita_organizzative
               where progr_unita_organizzativa = u.progr_unita_organizzativa
                 and ottica = u.ottica)
connect by prior progr_unita_organizzativa = progr_unita_padre
       and dal = (select max(dal)
                    from vista_unita_organizzative
                   where progr_unita_organizzativa = u.progr_unita_organizzativa
                     and ottica = u.ottica)
 start with progr_unita_padre is null
        and dal = (select max(dal)
                     from vista_unita_organizzative
                    where progr_unita_organizzativa = u.progr_unita_organizzativa
                      and ottica = u.ottica);


