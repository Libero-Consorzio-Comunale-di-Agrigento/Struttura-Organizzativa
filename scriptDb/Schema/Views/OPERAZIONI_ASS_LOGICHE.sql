CREATE OR REPLACE FORCE VIEW OPERAZIONI_ASS_LOGICHE
(ID_COMPONENTE, NI, NOMINATIVO, OTTICA, AMMINISTRAZIONE, 
 UNITA_LOGICA, INCARICO, DES_INCARICO, TIPO_ASSEGNAZIONE, ASSEGNAZIONE_PREVALENTE, 
 DAL, AL, DATA_AGGIORNAMENTO, COD_OPERAZIONE, DESCR_OPERAZIONE)
BEQUEATH DEFINER
AS 
select id_componente
     , ni
     , nominativo
     , ottica
     , ottica.get_amministrazione(ottica) amministrazione
     , (select descrizione || ' (' || codice_uo || ')'
          from anagrafe_unita_organizzative a
         where a.progr_unita_organizzativa = c.progr_unita_organizzativa
           and nvl(c.al, to_date(3333333, 'j')) between a.dal and
               nvl(a.al, to_date(3333333, 'j'))) unita_logica
     , c.incarico
     , c.des_incarico
     , decode(nvl(tipo_assegnazione, 'I'), 'I', 'Istituzionale', 'Funzionale') tipo_assegnazione
     , assegnazione_prevalente
     , dal
     , al
     , data_aggiornamento
     , 'N' cod_operazione
     , 'Nuova assegnazione nell''ottica' descr_operazione
  from vista_componenti c
 where not exists (select 'x'
                     from componenti
                    where ni = c.ni
                      and ottica = c.ottica
                      and dal < c.dal)
 union
select id_componente
     , ni
     , nominativo
     , ottica
     , ottica.get_amministrazione(ottica) amministrazione
     , (select descrizione || ' (' || codice_uo || ')'
          from anagrafe_unita_organizzative a
         where a.progr_unita_organizzativa = c.progr_unita_organizzativa
           and nvl(c.al, to_date(3333333, 'j')) between a.dal and
               nvl(a.al, to_date(3333333, 'j'))) unita_logica
     , c.incarico
     , c.des_incarico
     , decode(nvl(tipo_assegnazione, 'I'), 'I', 'Istituzionale', 'Funzionale') tipo_assegnazione
     , assegnazione_prevalente
     , dal
     , al
     , data_aggiornamento
     , 'T' cod_operazione
     , 'Termine assegnazione nell''ottica' descr_operazione
  from vista_componenti c
 where al is not null
   and not exists (select 'x'
                     from componenti
                    where ni = c.ni
                      and ottica = c.ottica
                      and dal > c.al)
 union
select id_componente
     , ni
     , nominativo
     , ottica
     , ottica.get_amministrazione(ottica) amministrazione
     , (select descrizione || ' (' || codice_uo || ')'
          from anagrafe_unita_organizzative a
         where a.progr_unita_organizzativa = c.progr_unita_organizzativa
           and nvl(c.al, to_date(3333333, 'j')) between a.dal and
               nvl(a.al, to_date(3333333, 'j'))) unita_logica
     , c.incarico
     , c.des_incarico
     , decode(nvl(tipo_assegnazione, 'I'), 'I', 'Istituzionale', 'Funzionale') tipo_assegnazione
     , assegnazione_prevalente
     , dal
     , al
     , data_aggiornamento
     , 'R' cod_operazione
     , 'Rettifica dell''assegnazione nell''ottica' descr_operazione
  from vista_componenti c
 where exists (select 'x'
                 from componenti
                where ni = c.ni
                  and ottica = c.ottica
                  and al = c.dal - 1
                  and progr_unita_organizzativa <> c.progr_unita_organizzativa);


