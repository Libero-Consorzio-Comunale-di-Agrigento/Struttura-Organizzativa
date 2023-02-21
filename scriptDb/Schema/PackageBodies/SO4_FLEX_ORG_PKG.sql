CREATE OR REPLACE package body so4_flex_org_pkg is
   /******************************************************************************
   NOME:        SO4_FLEX_ORG_PKG.
   DESCRIZIONE: Procedure e Funzioni per la produzione dell'organigramma.
   ANNOTAZIONI: .
   REVISIONI:   .
   Rev.  Data        Autore  Descrizione.
   ----  ----------  ------  ---------------------------------------------------.
   000   14/04/2011  ADADAMO Prima emissione.
   001   13/09/2012  ADADAMO Modificata get_flex_ottiche per introduzione gestione
                       competenze
   002   30/05/2013  ADADAMO Predisposte modifiche per get dei componenti per
                             gestire il tipo di assegnazione
   003   13/10/2014  ADADAMO Modificato get_flex_comp per gestire correttamente
                             la chiave di registro che indica se visualizzare o
                             meno l'incarico (Bug#532)
   004   15/01/2015  MMONARI Modificato get_flex_comp per predeterminare la revisione
                             in modifica (#558)
   005   08/06/2016  ADADAMO Corretta get_flex_org per utilizzare la data di riferimento
                             come parametro delle funzioni di get (#730)
   006   08/06/2016  ADADAMO Eliminato uso della soggetti_get_descr e utilizzata
                             nuova funzionalità del so4_util.unita_get_resp_unico
                             interrogabile per date effettive (#731)                                                       
   *****************************************************************************/
   s_revisione_body constant varchar2(30) := '006 - 08/06/2016';
   ----------------------------------------------------------------------------------
   function versione return varchar2 is
      /******************************************************************************
       NOME:        versione.
       DESCRIZIONE: Restituisce versione e revisione di distribuzione del package.
       RITORNA:     varchar2 : stringa contenente versione e revisione.
       NOTE:        Primo numero  : versione compatibilità del Package.
                    Secondo numero: revisione del Package specification.
                    Terzo numero  : revisione del Package body.
      ******************************************************************************/
   begin
      return s_revisione || '.' || s_revisione_body;
   end versione; -- SO4_FLEX_ORG_PKG.versione
   ----------------------------------------------------------------------------------
   procedure get_flex_org
   (
      p_ottica      in unita_organizzative.ottica%type
     ,p_datarif     in varchar2
     ,p_progr_unita in unita_organizzative.progr_unita_organizzativa%type
     ,p_livello     in number
     ,p_revisione   in number
     ,p_list        out afc.t_ref_cursor
   ) is
      /******************************************************************************
       NOME:        get_flex_org.
       DESCRIZIONE: Restituisce il cursore contenente la struttura organizzativa
       RITORNA:     afc.t_ref_cursor : cursore contenente la struttura.
       NOTE:
      ******************************************************************************/
      d_datarif       date := to_date(p_datarif, 'dd/mm/yyyy');
      d_revisione_mod unita_organizzative.revisione%type := revisione_struttura.get_revisione_mod(p_ottica);
      errore_parametri exception;
   begin
      if p_ottica is null or (p_revisione is null and p_datarif is null) then
         raise errore_parametri;
      end if;
      if p_revisione is not null then
         select min(dal - 1)
           into d_datarif
           from revisioni_struttura
          where p_revisione < revisione
            and ottica = p_ottica
            and stato = 'A';
         if d_datarif is null then
            d_datarif := sysdate;
         end if;
      end if;
      open p_list for
         select ottica
               ,ni progr_uo
               ,id_elemento
                --
                --  Modifica per v.1.4: cambio di modalita' di ricorsione dei legami padre-figlio, MANTENUTA NOMENCLATURA CAMPI GESTITI IN INTERFACCIA
               ,id_unita_padre
               ,decode(impostazione.get_visualizza_suddivisione(1)
                      ,'SI'
                       --,suddivisione || ': '||suddivisione_struttura.get_des_abb(unor2.suddivisione ) || ' ') ||
                      ,suddivisione_struttura.get_des_abb(unor2.suddivisione) || ' ') ||
                decode(impostazione.get_visualizza_codice(1)
                      ,'SI'
                      ,anagrafe_unita_organizzativa.get_codice_uo(ni
                                                                 ,nvl(d_datarif, sysdate)) ||
                       ' - '
                      ,null) || unor2.descrizione ||
                decode(so4_util.unita_get_resp_unico(unor2.ni
                                                    ,''
                                                    ,p_ottica
                                                    ,d_datarif
                                                    ,''
                                                    ,'E')
                      ,null
                      ,null
                      ,' - ' || so4_util.unita_get_resp_unico(unor2.ni
                                                             ,''
                                                             ,p_ottica
                                                             ,d_datarif
                                                             ,''
                                                             ,'E')) descrizione_completa
               ,decode(impostazione.get_visualizza_suddivisione(1)
                      ,'SI'
                      ,suddivisione_struttura.get_des_abb(unor2.suddivisione) || ' ') ||
                decode(impostazione.get_visualizza_codice(1)
                      ,'SI'
                      ,anagrafe_unita_organizzativa.get_codice_uo(ni
                                                                 ,nvl(d_datarif, sysdate)) ||
                       ' - '
                      ,null) || unor2.descrizione descrizione_unita
               ,decode(so4_util.unita_get_resp_unico(unor2.ni
                                                    ,''
                                                    ,p_ottica
                                                    ,d_datarif
                                                    ,''
                                                    ,'E')
                      ,null
                      ,null
                      ,so4_util.unita_get_resp_unico(unor2.ni
                                                    ,''
                                                    ,p_ottica
                                                    ,d_datarif
                                                    ,''
                                                    ,'E')) descrizione_resp
               ,suddivisione_struttura.get_icona_standard(suddivisione) icona
               ,to_char(nvl(d_datarif, sysdate), 'DD/MM/YYYY') datarif
           from (select u.ottica
                       ,u.progr_unita_organizzativa ni
                       ,u.dal
                       ,decode(u.revisione_cessazione
                              ,d_revisione_mod
                              ,to_date(null)
                              ,u.al) al
                       ,u.id_elemento
                       ,anagrafe_unita_organizzativa.get_id_suddivisione(u.progr_unita_organizzativa
                                                                        ,nvl(d_datarif
                                                                            ,sysdate)) suddivisione
                       ,u.revisione_cessazione
                       ,u.ottica unor_ottica
                       ,u.id_unita_padre
                       ,u.revisione
                       ,anagrafe_unita_organizzativa.get_descrizione(u.progr_unita_organizzativa
                                                                    ,nvl(d_datarif
                                                                        ,sysdate)) descrizione
                   from unita_organizzative u
                  where nvl(u.revisione, -2) != d_revisione_mod
                    and u.ottica = p_ottica
                    and nvl(d_datarif, sysdate) between nvl(u.dal, to_date(2222222, 'j')) and
                        nvl(u.al, to_date(3333333, 'j'))) unor2
          where nvl(d_datarif, sysdate) between unor2.dal and
                nvl(decode(unor2.revisione_cessazione
                          ,d_revisione_mod
                          ,to_date(null)
                          ,unor2.al)
                   ,to_date('3333333', 'j'))
         -- start with NVL(id_unita_padre,0)=nvl(p_idElemento,0)
         --   start with (unor2.id_elemento = p_idelemento and p_idelemento is not null)
          start with (unor2.ni = p_progr_unita and p_progr_unita is not null)
                  or (unor2.id_unita_padre is null and p_progr_unita is null)
                 and nvl(d_datarif, sysdate) between
                     nvl(unor2.dal, to_date(2222222, 'j')) and
                     nvl(unor2.al, to_date(3333333, 'j'))
         --         connect by prior unor2.id_elemento = unor2.id_unita_padre
         connect by prior ni = id_unita_padre
                and nvl(d_datarif, sysdate) between unor2.dal and
                    nvl(unor2.al, to_date(3333333, 'j'))
                and level <= nvl(p_livello, level);
   exception
      when errore_parametri then
         raise_application_error(-20999
                                ,'Errore in acquisizione parametri per l''organigramma');
      when others then
         raise_application_error(-20999
                                ,'Errore in costruzione organigramma ' || ' - ' ||
                                 sqlerrm);
   end get_flex_org; --so4_flex_org_pkg.get_flex_org
   ----------------------------------------------------------------------------------
   procedure get_flex_comp
   (
      p_datarif    in varchar2
     ,p_progr_unor in unita_organizzative.progr_unita_organizzativa%type
      --  ,p_tipo_assegnazione   in attributi_componente.tipo_assegnazione%type
     ,p_list out afc.t_ref_cursor
   ) is
      /******************************************************************************
       NOME:        get_flex_comp.
       DESCRIZIONE: Restituisce il cursore contenente i componenti assegnati all'unità passata
       RITORNA:     afc.t_ref_cursor : cursore contenente la struttura.
       NOTE:
      ******************************************************************************/
      d_datarif        date := to_date(p_datarif, 'dd/mm/yyyy');
      d_visualizza_inc varchar2(2) := registro_utility.leggi_stringa('PRODUCTS/SI4SO'
                                                                    ,'Visualizzazione incarichi'
                                                                    ,0);
   begin
      open p_list for
         select anso.cognome || '  ' || anso.nome ||
                 decode(d_visualizza_inc, 'NO', null, '(' || tiin.descrizione || ')') ||
                --   decode(nvl(p_tipo_assegnazione,'%'),'I',null
                --                                      ,'F',null
                --                                      ,decode(tipo_assegnazione,'I',' Istituzionale',' Funzionale')
                --          )||
                 '' dati_componente
               ,tiin.responsabile
               ,tiin.ordinamento
               ,tiin.incarico
           from componenti            comp
               ,tipi_incarico         tiin
               ,attributi_componente  atco
               ,as4_anagrafe_soggetti anso
          where nvl(d_datarif, to_date(2222222, 'j')) between comp.dal and
                nvl(decode(comp.revisione_cessazione
                          ,revisione_struttura.get_revisione_mod(comp.ottica)
                          ,to_date(null)
                          ,comp.al)
                   ,to_date(3333333, 'j'))
            and nvl(d_datarif, to_date(2222222, 'j')) between atco.dal and
                nvl(decode(atco.revisione_cessazione
                          ,revisione_struttura.get_revisione_mod(comp.ottica)
                          ,to_date(null)
                          ,atco.al)
                   ,to_date(3333333, 'j'))
            and nvl(comp.revisione_assegnazione, -2) !=
                revisione_struttura.get_revisione_mod(comp.ottica)
            and nvl(atco.revisione_assegnazione, -2) !=
                revisione_struttura.get_revisione_mod(atco.ottica)
            and progr_unita_organizzativa = p_progr_unor
            and atco.id_componente = comp.id_componente
            and tiin.incarico = atco.incarico
               --            and atco.tipo_assegnazione like nvl(p_tipo_assegnazione,'%')
            and nvl(d_datarif, to_date(2222222, 'j')) between anso.dal and
                nvl(anso.al, to_date(3333333, 'j'))
            and anso.ni = comp.ni
          order by decode(tiin.responsabile, 'SI', 1, 2)
                   --,decode(tipo_assegnazione,'I',1,2)
                  ,nvl(tiin.ordinamento, 1000);
   exception
      when others then
         raise_application_error(-20999
                                ,'Errore in acquisizione componenti ' || ' - ' ||
                                 sqlerrm);
   end get_flex_comp; -- so4_flex_org_pkg.get_flex_comp
   ----------------------------------------------------------------------------------
   procedure get_flex_ottiche
   (
      p_utente in ad4_utenti.utente%type
     ,p_ruolo  in ad4_ruoli.ruolo%type
     ,p_list   out afc.t_ref_cursor
   ) is
      /******************************************************************************
       NOME:        get_flex_ottiche
       DESCRIZIONE: Restituisce il cursore delle ottiche dell'amministrazione
       RITORNA:     afc.t_ref_cursor : cursore contenente le ottiche.
       NOTE:
      ******************************************************************************/
   begin
      open p_list for
         select a.ottica codice_ott
               ,a.ottica || ' - ' || a.descrizione || ' ' || '(' || a.amministrazione ||
                ' - ' || anso.denominazione descrizione
           from ottiche               a
               ,amministrazioni       b
               ,as4_anagrafe_soggetti anso
          where (b.codice_amministrazione = a.amministrazione)
            and so4_competenze_pkg.check_comp_ottica(a.ottica, 'LE', p_utente, p_ruolo) = 1
            and anso.ni = b.ni
            and trunc(sysdate) between anso.dal and nvl(anso.al, to_date(3333333, 'j'))
          order by 1;
   exception
      when others then
         raise_application_error(-20999
                                ,'Errore in acquisizione ottiche ' || ' - ' || sqlerrm);
   end get_flex_ottiche; -- so4_flex_org_pkg.get_flex_ottiche
   ----------------------------------------------------------------------------------
   procedure get_flex_revisioni
   (
      p_ottica in unita_organizzative.ottica%type
     ,p_list   out afc.t_ref_cursor
   ) is
      /******************************************************************************
       NOME:        get_flex_revisioni
       DESCRIZIONE: Restituisce il cursore delle revisioni associate all'ottica passata
       RITORNA:     afc.t_ref_cursor : cursore contenente le revisioni
       NOTE:
      ******************************************************************************/
      errore_parametri exception;
   begin
      if p_ottica is null then
         raise errore_parametri;
      end if;
      open p_list for
         select a.revisione codice_rev
               ,to_char(a.revisione) || ' ' || '-' || ' ' || a.descrizione descrizione
           from revisioni_struttura a
          where (a.stato = 'A')
            and a.ottica = p_ottica
          order by a.dal;
   exception
      when errore_parametri then
         raise_application_error(-20999
                                ,'Errore in acquisizione parametri per revisione');
      when others then
         raise_application_error(-20999
                                ,'Errore in acquisizione revisioni ' || ' - ' || sqlerrm);
   end get_flex_revisioni; -- so4_flex_org_pkg.get_flex_revisioni
   ----------------------------------------------------------------------------------
   procedure get_flex_unita
   (
      p_ottica    in unita_organizzative.ottica%type
     ,p_revisione in number
     ,p_datarif   in varchar2
     ,p_descr     in varchar2
     ,p_list      out afc.t_ref_cursor
   ) is
      /******************************************************************************
       NOME:        get_flex_unita
       DESCRIZIONE: Restituisce il cursore delle unita associate all'ottica passata
       RITORNA:     afc.t_ref_cursor : cursore contenente le ottiche.
       NOTE:
      ******************************************************************************/
      data_riferimento date;
      errore_parametri exception;
   begin
      if p_ottica is null or (p_revisione is null and p_datarif is null) then
         raise errore_parametri;
      end if;
      if p_revisione is not null then
         select revisione_struttura.get_dal(p_ottica, p_revisione)
           into data_riferimento
           from dual;
      else
         data_riferimento := to_date(p_datarif, 'dd/mm/yyyy');
      end if;
      open p_list for
         select a.codice_uo                 as codice_uo
               ,a.descrizione               as descrizione
               ,a.progr_unita_organizzativa as progr_unita_organizzativa
               ,b.id_elemento               as id_elemento
           from anagrafe_unita_organizzative a
               ,unita_organizzative          b
          where (((data_riferimento between nvl(a.dal, data_riferimento) and
                nvl(decode(a.revisione_cessazione
                             ,revisione_struttura.get_revisione_mod(a.ottica)
                             ,to_date(null)
                             ,a.al)
                      ,to_date('2200-12-31', 'YYYY-MM-DD'))) and
                not ((data_riferimento is null))) or (data_riferimento is null))
            and (nvl(a.revisione_istituzione, -2) <>
                revisione_struttura.get_revisione_mod(a.ottica))
            and (a.progr_unita_organizzativa = b.progr_unita_organizzativa)
            and ((data_riferimento between nvl(b.dal, data_riferimento) and
                nvl(decode(b.revisione_cessazione
                            ,revisione_struttura.get_revisione_mod(b.ottica)
                            ,to_date(null)
                            ,b.al)
                     ,to_date('2200-12-31', 'YYYY-MM-DD'))))
            and (nvl(b.revisione, -2) <> revisione_struttura.get_revisione_mod(b.ottica))
            and (b.ottica = p_ottica)
               -- and UPPER(A.DESCRIZIONE) like UPPER(nvl(p_descr,'%'))
            and (upper(a.descrizione) like upper(nvl(p_descr, '%')) or
                upper(a.codice_uo) like upper(nvl(p_descr, '%')))
          order by 1;
   exception
      when errore_parametri then
         raise_application_error(-20999, 'Errore in acquisizione parametri');
      when others then
         raise_application_error(-20999
                                ,'Errore in acquisizione dati ' || ' - ' || sqlerrm);
   end get_flex_unita; -- so4_flex_org_pkg.get_flex_unita
end so4_flex_org_pkg;
/

