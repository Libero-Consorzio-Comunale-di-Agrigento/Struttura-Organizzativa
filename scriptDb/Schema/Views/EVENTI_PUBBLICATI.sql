CREATE OR REPLACE FORCE VIEW EVENTI_PUBBLICATI
(MODULO, AMMINISTRAZIONE, OTTICA, CATEGORIA, MODIFICA, 
 VALORE, DESCRIZIONE, ID_MODIFICA, OGGETTO, NOTIFICA, 
 URL_NOTIFICA, ID_ISCRIZIONE, ID_EVENTO)
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
      ,i.url_notifica
      ,i.id_iscrizione
      ,e.id_evento
  from iscrizioni_pubblicazione i
      ,so4_eventi               e
      ,so4_codifiche            c
 where c.dominio = 'EVENTI.' || e.categoria || '.' || e.tipo
   and e.categoria like i.categoria
   and (i.modifica = e.tipo or i.modifica = 0)
   and nvl(i.ottica, nvl(e.ottica, 'xxx')) = nvl(e.ottica, 'xxx')
   and nvl(i.amministrazione, nvl(e.amministrazione, 'yyy')) =
       nvl(e.amministrazione, 'yyy')
   and e.time > nvl(i.data_inizio_acquisizione, to_date(2222222, 'j'))
 order by i.modulo
         ,i.categoria
         ,valore;


