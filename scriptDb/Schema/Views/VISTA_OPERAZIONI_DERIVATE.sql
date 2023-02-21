CREATE OR REPLACE FORCE VIEW VISTA_OPERAZIONI_DERIVATE
(ID_MODIFICA, OTTICA_ORIGINE, OTTICA_DERIVATA, ID_COMPONENTE, NI, 
 CI, NOMINATIVO, DAL, AL, CODICE_UO, 
 OPERAZIONE, ESECUZIONE, DATA_AGG_COMPONENTE, DATA_AGG_ATTRIBUTO)
BEQUEATH DEFINER
AS 
select m.id_modifica
         ,m.ottica ottica_origine
         ,o.ottica ottica_derivata
         ,m.id_componente
         ,ni
         ,ci
         ,c.nominativo
         ,c.dal
         ,c.al
         ,anagrafe_unita_organizzativa.get_codice_uo(c.progr_unita_organizzativa
                                                    ,nvl(c.al, to_date(3333333, 'j'))) codice_uo
         ,decode(m.operazione
                ,'N'
                ,'Nuovo componente (assunzione)'
                ,'S'
                ,'Spostamento'
                ,'C'
                ,'Chiusura assegnazione (cessazione)'
                ,'P'
                ,'Prolungamento assegnazione'
                ,'U'
                ,'Modifica della UO'
                ,'E'
                ,'Eliminazione del periodo'
                ,'A'
                ,'Modifica agli attributi') operazione
         ,o.esecuzione
         ,c.data_aggiornamento data_agg_componente
         ,c.data_agg_attr data_agg_attributo
     from vista_componenti     c
         ,operazioni_derivate  o
         ,modifiche_componenti m
    where o.id_modifica = m.id_modifica
      and c.id_componente = m.id_componente
    order by o.ottica
            ,m.id_modifica;


