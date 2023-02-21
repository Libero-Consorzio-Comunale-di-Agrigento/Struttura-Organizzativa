CREATE OR REPLACE FORCE VIEW EVENTI_DETTAGLIO
(MODULO, AMMINISTRAZIONE, OTTICA, CATEGORIA, MODIFICA, 
 VALORE, DESCRIZIONE, ID_MODIFICA, OGGETTO, NOTIFICA, 
 DATO1, DATO2, DATO3, DATO4, DATO5, 
 DATO6, DATO7, DATO8, DATO9, DATO10)
BEQUEATH DEFINER
AS 
select i.modulo
      ,i.amministrazione
      ,e.ottica
      ,i.categoria
      ,i.modifica
      ,c.valore
      ,c.descrizione
      ,e.id_modifica
      ,e.oggetto
      ,i.notifica
      ,to_char(b.codice_amministrazione) dato1
      ,(select denominazione from anagrafe_soggetti where ni = b.ni) dato2
      ,b.data_istituzione dato3
      ,to_date(null) dato4
      ,to_char(null) dato5
      ,to_char(null) dato6
      ,to_char(null) dato7
      ,to_char(null) dato8
      ,to_char(null) dato9
      ,to_char(null) dato10
  from iscrizioni_pubblicazione i
      ,so4_eventi               e
      ,so4_codifiche            c
      ,amministrazioni_b        b
 where c.dominio = 'EVENTI.' || e.categoria || '.' || e.tipo
   and (e.categoria = i.categoria or i.categoria = '%')
   and (i.modifica = e.tipo or i.modifica = 0)
   and nvl(i.ottica, nvl(e.ottica, 'xxx')) = nvl(e.ottica, 'xxx')
   and nvl(i.amministrazione, nvl(e.amministrazione, 'yyy')) =
       nvl(e.amministrazione, 'yyy')
   and e.time > nvl(i.data_inizio_acquisizione, to_date(2222222, 'j'))
      --
   and e.categoria = 'STRUTTURA_LOGICA'
   and e.tipo = 1
   and b.id_backup = e.id_modifica
union
-- Nuova Ottica
select i.modulo
      ,i.amministrazione
      ,e.ottica
      ,i.categoria
      ,i.modifica
      ,c.valore
      ,c.descrizione
      ,e.id_modifica
      ,e.oggetto
      ,i.notifica
      ,to_char(b.ottica) dato1
      ,b.descrizione dato2
      ,to_date(null) dato3
      ,to_date(null) dato4
      ,b.amministrazione dato5
      ,to_char(null) dato6
      ,to_char(null) dato7
      ,to_char(null) dato8
      ,to_char(null) dato9
      ,to_char(null) dato10
  from iscrizioni_pubblicazione i
      ,so4_eventi               e
      ,so4_codifiche            c
      ,ottiche_b                b
 where c.dominio = 'EVENTI.' || e.categoria || '.' || e.tipo
   and (e.categoria = i.categoria or i.categoria = '%')
   and (i.modifica = e.tipo or i.modifica = 0)
   and nvl(i.ottica, nvl(e.ottica, 'xxx')) = nvl(e.ottica, 'xxx')
   and nvl(i.amministrazione, nvl(e.amministrazione, 'yyy')) =
       nvl(e.amministrazione, 'yyy')
   and e.time > nvl(i.data_inizio_acquisizione, to_date(2222222, 'j'))
      --
   and e.categoria = 'STRUTTURA_LOGICA'
   and e.tipo = 2
   and b.id_backup = e.id_modifica
union
-- Attivazione Revisione Struttura
select i.modulo
      ,i.amministrazione
      ,e.ottica
      ,i.categoria
      ,i.modifica
      ,c.valore
      ,c.descrizione
      ,e.id_modifica
      ,e.oggetto
      ,i.notifica
      ,to_char(b.ottica) dato1
      ,b.descrizione dato2
      ,b.dal dato3
      ,to_date(null) dato4
      ,to_char(b.revisione) dato5
      ,to_char(null) dato6
      ,to_char(null) dato7
      ,to_char(null) dato8
      ,to_char(null) dato9
      ,to_char(null) dato10
  from iscrizioni_pubblicazione i
      ,so4_eventi               e
      ,so4_codifiche            c
      ,revisioni_struttura_b    b
 where c.dominio = 'EVENTI.' || e.categoria || '.' || e.tipo
   and (e.categoria = i.categoria or i.categoria = '%')
   and (i.modifica = e.tipo or i.modifica = 0)
   and nvl(i.ottica, nvl(e.ottica, 'xxx')) = nvl(e.ottica, 'xxx')
   and nvl(i.amministrazione, nvl(e.amministrazione, 'yyy')) =
       nvl(e.amministrazione, 'yyy')
   and e.time > nvl(i.data_inizio_acquisizione, to_date(2222222, 'j'))
      --
   and e.categoria = 'STRUTTURA_LOGICA'
   and e.tipo = 3
   and b.id_backup = e.id_modifica
union
-- Creazione/CessazioneRettifica UO
select i.modulo
      ,i.amministrazione
      ,e.ottica
      ,i.categoria
      ,i.modifica
      ,c.valore
      ,c.descrizione
      ,e.id_modifica
      ,e.oggetto
      ,i.notifica
      ,to_char(b.codice_uo) dato1
      ,b.descrizione dato2
      ,b.dal dato3
      ,to_date(null) dato4
      ,to_char(b.ottica) dato5
      ,to_char(b.progr_unita_organizzativa) dato6
      ,decode(e.tipo
             ,4
             ,to_char(b.revisione_istituzione)
             ,5
             ,to_char(b.revisione_cessazione)
             ,6
             ,to_char(null)
             ,7
             ,to_char(b.revisione_istituzione)) dato7
      ,to_char(b.aggregatore) dato8
      ,to_char(b.centro) dato9
      ,b.utente_ad4 dato10
  from iscrizioni_pubblicazione       i
      ,so4_eventi                     e
      ,so4_codifiche                  c
      ,anagrafe_unita_organizzative_b b
 where c.dominio = 'EVENTI.' || e.categoria || '.' || e.tipo
   and (e.categoria = i.categoria or i.categoria = '%')
   and (i.modifica = e.tipo or i.modifica = 0)
   and nvl(i.ottica, nvl(e.ottica, 'xxx')) = nvl(e.ottica, 'xxx')
   and nvl(i.amministrazione, nvl(e.amministrazione, 'yyy')) =
       nvl(e.amministrazione, 'yyy')
   and e.time > nvl(i.data_inizio_acquisizione, to_date(2222222, 'j'))
      --
   and e.categoria = 'STRUTTURA_LOGICA'
   and e.tipo in (4, 5, 6, 7)
   and b.id_backup = e.id_modifica
union
-- Rettifica date Anagrafe UO
select i.modulo
      ,i.amministrazione
      ,e.ottica
      ,i.categoria
      ,i.modifica
      ,c.valore
      ,c.descrizione
      ,e.id_modifica
      ,e.oggetto
      ,i.notifica
      ,to_char(b.progr_unita_organizzativa) dato1
      ,to_char(null) dato2
      ,b.dal dato3
      ,b.al dato4
      ,(select to_char(dal)
          from anagrafe_unita_organizzative_b b1
         where id_backup = b.id_backup - 1) dato5
      ,(select to_char(al)
          from anagrafe_unita_organizzative_b b1
         where id_backup = b.id_backup - 1) dato6
      ,to_char(null) dato7
      ,to_char(null) dato8
      ,to_char(null) dato9
      ,to_char(null) dato10
  from iscrizioni_pubblicazione       i
      ,so4_eventi                     e
      ,so4_codifiche                  c
      ,anagrafe_unita_organizzative_b b
 where c.dominio = 'EVENTI.' || e.categoria || '.' || e.tipo
   and (e.categoria = i.categoria or i.categoria = '%')
   and (i.modifica = e.tipo or i.modifica = 0)
   and nvl(i.ottica, nvl(e.ottica, 'xxx')) = nvl(e.ottica, 'xxx')
   and nvl(i.amministrazione, nvl(e.amministrazione, 'yyy')) =
       nvl(e.amministrazione, 'yyy')
   and e.time > nvl(i.data_inizio_acquisizione, to_date(2222222, 'j'))
      --
   and e.categoria = 'STRUTTURA_LOGICA'
   and e.tipo = 14
   and b.id_backup = e.id_modifica
union
-- Spostamento UO
select i.modulo
      ,i.amministrazione
      ,e.ottica
      ,i.categoria
      ,i.modifica
      ,c.valore
      ,c.descrizione
      ,e.id_modifica
      ,e.oggetto
      ,i.notifica
      ,to_char(b.progr_unita_organizzativa) dato1
      ,to_char(null) dato2
      ,b.dal dato3
      ,to_date(null) dato4
      ,to_char(b.ottica) dato5
      ,to_char(b.id_unita_padre) dato6
      ,to_char(b.revisione) dato7
      ,(select to_char(max(b.id_unita_padre))
          from unita_organizzative
         where ottica = b.ottica
           and progr_unita_organizzativa = b.progr_unita_organizzativa
           and al = b.dal - 1
           and dal <= nvl(al, to_date(3333333, 'j'))) dato8
      ,to_char(null) dato9
      ,to_char(null) dato10
  from iscrizioni_pubblicazione i
      ,so4_eventi               e
      ,so4_codifiche            c
      ,unita_organizzative_b    b
 where c.dominio = 'EVENTI.' || e.categoria || '.' || e.tipo
   and (e.categoria = i.categoria or i.categoria = '%')
   and (i.modifica = e.tipo or i.modifica = 0)
   and nvl(i.ottica, nvl(e.ottica, 'xxx')) = nvl(e.ottica, 'xxx')
   and nvl(i.amministrazione, nvl(e.amministrazione, 'yyy')) =
       nvl(e.amministrazione, 'yyy')
   and e.time > nvl(i.data_inizio_acquisizione, to_date(2222222, 'j'))
      --
   and e.categoria = 'STRUTTURA_LOGICA'
   and e.tipo = 8
   and b.id_backup = e.id_modifica
union
-- Rettifiche Anagrafe UO
select i.modulo
      ,i.amministrazione
      ,e.ottica
      ,i.categoria
      ,i.modifica
      ,c.valore
      ,c.descrizione
      ,e.id_modifica
      ,e.oggetto
      ,i.notifica
      ,to_char(b.progr_unita_organizzativa) dato1
      ,decode(e.tipo
             ,9
             ,to_char(b.codice_uo)
             ,10
             ,to_char(b.descrizione)
             ,11
             ,to_char(b.centro)
             ,12
             ,to_char(b.aggregatore)
             ,13
             ,to_char(b.centro_responsabilita)) dato2
      ,b.dal dato3
      ,to_date(null) dato4
      ,to_char(b.ottica) dato5
      ,(select decode(e.tipo
                     ,9
                     ,to_char(b1.codice_uo)
                     ,10
                     ,to_char(b1.descrizione)
                     ,11
                     ,to_char(b1.centro)
                     ,12
                     ,to_char(b1.aggregatore)
                     ,13
                     ,to_char(b1.centro_responsabilita))
          from anagrafe_unita_organizzative_b b1
         where id_backup = b.id_backup - 1) dato6
      ,to_char(null) dato7
      ,to_char(null) dato8
      ,to_char(null) dato9
      ,to_char(null) dato10
  from iscrizioni_pubblicazione       i
      ,so4_eventi                     e
      ,so4_codifiche                  c
      ,anagrafe_unita_organizzative_b b
 where c.dominio = 'EVENTI.' || e.categoria || '.' || e.tipo
   and (e.categoria = i.categoria or i.categoria = '%')
   and (i.modifica = e.tipo or i.modifica = 0)
   and nvl(i.ottica, nvl(e.ottica, 'xxx')) = nvl(e.ottica, 'xxx')
   and nvl(i.amministrazione, nvl(e.amministrazione, 'yyy')) =
       nvl(e.amministrazione, 'yyy')
   and e.time > nvl(i.data_inizio_acquisizione, to_date(2222222, 'j'))
      --
   and e.categoria = 'STRUTTURA_LOGICA'
   and e.tipo in (9, 10, 11, 12, 13)
   and b.id_backup = e.id_modifica
union
--Creazione e cessazione Componenti
select i.modulo
      ,i.amministrazione
      ,e.ottica
      ,i.categoria
      ,i.modifica
      ,c.valore
      ,c.descrizione
      ,e.id_modifica
      ,e.oggetto
      ,i.notifica
      ,to_char(b.ni) dato1
      ,to_char(b.progr_unita_organizzativa) dato2
      ,b.dal_pubb dato3
      ,b.al_pubb dato4
      ,to_char(null) dato5
      ,to_char(null) dato6
      ,to_char(null) dato7
      ,to_char(null) dato8
      ,to_char(null) dato9
      ,to_char(null) dato10
  from iscrizioni_pubblicazione i
      ,so4_eventi               e
      ,so4_codifiche            c
      ,componenti_b             b
 where c.dominio = 'EVENTI.' || e.categoria || '.' || e.tipo
   and (e.categoria = i.categoria or i.categoria = '%')
   and (i.modifica = e.tipo or i.modifica = 0)
   and nvl(i.ottica, nvl(e.ottica, 'xxx')) = nvl(e.ottica, 'xxx')
   and nvl(i.amministrazione, nvl(e.amministrazione, 'yyy')) =
       nvl(e.amministrazione, 'yyy')
   and e.time > nvl(i.data_inizio_acquisizione, to_date(2222222, 'j'))
      --
   and e.categoria = 'COMPONENTI'
   and e.tipo in (1, 2, 3, 4)
   and b.id_backup = e.id_modifica
union
-- Spostamento Componenti
select i.modulo
      ,i.amministrazione
      ,e.ottica
      ,i.categoria
      ,i.modifica
      ,c.valore
      ,c.descrizione
      ,e.id_modifica
      ,e.oggetto
      ,i.notifica
      ,to_char(b.ni) dato1
      ,to_char(b.progr_unita_organizzativa) dato2
      ,b.dal_pubb dato3
      ,b.al_pubb dato4
      ,(select to_char(max(progr_unita_organizzativa))
          from componenti
         where ottica = b.ottica
           and ni = b.ni
           and al = b.dal - 1) dato5
      ,to_char(null) dato6
      ,to_char(null) dato7
      ,to_char(null) dato8
      ,to_char(null) dato9
      ,to_char(null) dato10
  from iscrizioni_pubblicazione i
      ,so4_eventi               e
      ,so4_codifiche            c
      ,componenti_b             b
 where c.dominio = 'EVENTI.' || e.categoria || '.' || e.tipo
   and (e.categoria = i.categoria or i.categoria = '%')
   and (i.modifica = e.tipo or i.modifica = 0)
   and nvl(i.ottica, nvl(e.ottica, 'xxx')) = nvl(e.ottica, 'xxx')
   and nvl(i.amministrazione, nvl(e.amministrazione, 'yyy')) =
       nvl(e.amministrazione, 'yyy')
   and e.time > nvl(i.data_inizio_acquisizione, to_date(2222222, 'j'))
      --
   and e.categoria = 'COMPONENTI'
   and e.tipo = 5
   and b.id_backup = e.id_modifica
union
-- Rettifiche su Attributi Componente
select i.modulo
      ,i.amministrazione
      ,e.ottica
      ,i.categoria
      ,i.modifica
      ,c.valore
      ,c.descrizione
      ,e.id_modifica
      ,e.oggetto
      ,i.notifica
      ,to_char(comp.ni) dato1
      ,decode(e.tipo
             ,6
             ,b.incarico
             ,7
             ,to_char(b.tipo_assegnazione)
             ,8
             ,to_char(b.assegnazione_prevalente)) dato2
      ,b.dal_pubb dato3
      ,b.al_pubb dato4
      ,(select decode(e.tipo
                     ,6
                     ,incarico
                     ,7
                     ,tipo_assegnazione
                     ,8
                     ,to_char(assegnazione_prevalente))
          from attributi_componente_b
         where id_backup = b.id_backup - 1) dato5
      ,to_char(null) dato6
      ,to_char(null) dato7
      ,to_char(null) dato8
      ,to_char(null) dato9
      ,to_char(null) dato10
  from iscrizioni_pubblicazione i
      ,so4_eventi               e
      ,so4_codifiche            c
      ,componenti               comp
      ,attributi_componente_b   b
 where c.dominio = 'EVENTI.' || e.categoria || '.' || e.tipo
   and (e.categoria = i.categoria or i.categoria = '%')
   and (i.modifica = e.tipo or i.modifica = 0)
   and nvl(i.ottica, nvl(e.ottica, 'xxx')) = nvl(e.ottica, 'xxx')
   and nvl(i.amministrazione, nvl(e.amministrazione, 'yyy')) =
       nvl(e.amministrazione, 'yyy')
   and e.time > nvl(i.data_inizio_acquisizione, to_date(2222222, 'j'))
      --
   and e.categoria = 'COMPONENTI'
   and e.tipo in (6, 7, 8)
   and b.id_backup = e.id_modifica
   and comp.id_componente = b.id_componente
union
-- Modifiche ai ruoli
select i.modulo
      ,i.amministrazione
      ,e.ottica
      ,i.categoria
      ,i.modifica
      ,c.valore
      ,c.descrizione
      ,e.id_modifica
      ,e.oggetto
      ,i.notifica
      ,to_char(comp.ni) dato1
      ,b.ruolo dato2
      ,b.dal_pubb dato3
      ,b.al_pubb dato4
      ,(select decode(e.tipo, 16, ruolo, to_char(null))
          from ruoli_componente_b
         where id_backup = b.id_backup - 1) dato5
      ,to_char(null) dato6
      ,to_char(null) dato7
      ,to_char(null) dato8
      ,to_char(null) dato9
      ,to_char(null) dato10
  from iscrizioni_pubblicazione i
      ,so4_eventi               e
      ,so4_codifiche            c
      ,componenti               comp
      ,ruoli_componente_b       b
 where c.dominio = 'EVENTI.' || e.categoria || '.' || e.tipo
   and (e.categoria = i.categoria or i.categoria = '%')
   and (i.modifica = e.tipo or i.modifica = 0)
   and nvl(i.ottica, nvl(e.ottica, 'xxx')) = nvl(e.ottica, 'xxx')
   and nvl(i.amministrazione, nvl(e.amministrazione, 'yyy')) =
       nvl(e.amministrazione, 'yyy')
   and e.time > nvl(i.data_inizio_acquisizione, to_date(2222222, 'j'))
      --
   and e.categoria = 'COMPONENTI'
   and e.tipo in (9, 10, 11, 16)
   and b.id_backup = e.id_modifica
   and comp.id_componente = b.id_componente
 order by 1
         ,4
         ,2
         ,3
         ,7;


