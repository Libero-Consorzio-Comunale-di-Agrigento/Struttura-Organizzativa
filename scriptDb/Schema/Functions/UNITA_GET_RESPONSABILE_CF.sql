CREATE OR REPLACE function UNITA_GET_RESPONSABILE_CF
( p_progr_uo        anagrafe_unita_organizzative.progr_unita_organizzativa%type
, p_ruolo           ad4_ruoli.ruolo%type default null
, p_ottica          ottiche.ottica%type
, p_data            componenti.dal%type
, p_revisione       revisioni_struttura.revisione%type) 
return varchar2 as
/******************************************************************************
  NOME:        unita_get_responsabile_cf.
  DESCRIZIONE: Dati progr. U.O., ottica e data restituisce i dati del componente
               avente il ruolo indicato
               NOTA: trattandosi di ruolo di responsabile per la contabilita'
                     finanziaria, ci si aspetta che ce ne sia solo uno.
                     In caso di responsabili multipli, si tratta quello che
                     ha il ruolo da più tempo
  PARAMETRI:   p_progr_uo           progressivo dell'unita organizzativa
               p_ruolo              ruolo da selezionare (facoltativo)
               p_ottica             ottica da trattare
               p_data               data di confronto
               p_amministrazione    amministrazione di ricerca nella struttura
                                    (facoltativa - alternativa all'ottica per la
                                    definizione dell'ottica istituzionale
  RITORNA:
  REVISIONI:
  Rev.  Data        Autore    Descrizione
  ----  ----------  ------    --------------------------------------------------
  000   24/05/2013  VD        Prima emissione.
******************************************************************************/
  d_result                    varchar2(2000);
  d_data_ruolo                ruoli_componente.dal%type;
  s_data_limite               date := to_date(3333333,'j');
begin
--
  if p_ruolo is null then
     begin
       select min(soggetti_get_descr(ni, p_data, 'COGNOME E NOME'))
         into d_result
         from vista_pubb_comp c
        where c.progr_unita_organizzativa = p_progr_uo
          and c.ottica = p_ottica
          and nvl(c.revisione_assegnazione, -2) != p_revisione
          and p_data between c.dal and nvl(decode(nvl(c.revisione_cessazione, -2)
                                                 ,p_revisione
                                                 ,to_date(null)
                                                 ,c.al)
                                          ,s_data_limite);
     exception
       when others then
         d_result := null;
     end;  
  else
--
-- Si seleziona la data minima di assegnazione per il ruolo
-- e per l unita indicati
--
     begin
       select min(dal)
         into d_data_ruolo
         from vista_pubb_ruco r
        where p_data between r.dal and nvl(r.al,s_data_limite)
          and r.ruolo = p_ruolo
          and r.id_componente in (select c.id_componente
                                    from vista_pubb_comp c
                                   where c.ottica = p_ottica
                                     and c.progr_unita_organizzativa = p_progr_uo
                                     and nvl(c.revisione_assegnazione, -2) != p_revisione
                                     and p_data between c.dal and nvl(decode(nvl(c.revisione_cessazione, -2)
                                                                            ,p_revisione
                                                                            ,to_date(null)
                                                                            ,c.al)
                                                                     ,s_data_limite));
     exception
       when others then
         d_data_ruolo := to_date(null);
     end;
--
     if d_data_ruolo is null then
        d_result := null;
     else
        begin
          select soggetti_get_descr(ni, p_data, 'COGNOME E NOME')
            into d_result
            from vista_pubb_comp c
                ,vista_pubb_ruco r
           where c.ottica = p_ottica
             and c.progr_unita_organizzativa = p_progr_uo
             and nvl(c.revisione_assegnazione, -2) != p_revisione
             and p_data between c.dal and nvl(decode(nvl(c.revisione_cessazione, -2)
                                                    ,p_revisione
                                                    ,to_date(null)
                                                    ,c.al)
                                             ,s_data_limite)
             and c.id_componente = r.id_componente
             and r.ruolo = p_ruolo
             and r.dal = d_data_ruolo;
        exception
          when others then
            null;
        end;
     end if;
  end if;
--
  return d_result;
--
end;
/

