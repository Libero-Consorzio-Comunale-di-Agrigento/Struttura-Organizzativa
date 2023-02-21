CREATE OR REPLACE FORCE VIEW SO_ANA_UNITA_ORGANIZZATIVE
(PROGR_UNITA_ORGANIZZATIVA, CODICE_UO, DES_UNITA_ORGANIZZATIVA, AL, CENTRO, 
 AMMINISTRAZIONE, ID_SUDDIVISIONE, COD_SUDDIVISIONE, DES_SUDDIVISIONE, CONSEGNATARIO, 
 NOME_CONSEGNATARIO, OTTICA, OTTICA_ISTITUZIONALE)
BEQUEATH DEFINER
AS 
select a.progr_unita_organizzativa
     , a.codice_uo
     , a.descrizione des_unita_organizzativa
     , a.al
     , a.centro
     , a.amministrazione
     , s.id_suddivisione
     , s.suddivisione cod_suddivisione
     , s.descrizione des_suddivisione
     , NULL consegnatario
     , NULL nome_consegnatario
     , o.ottica
     , o.ottica_istituzionale
  from suddivisioni_struttura s
     , anagrafe_unita_organizzative a
     , ottiche o
 where a.ottica = o.ottica
   and a.id_suddivisione = s.id_suddivisione(+)
   and AMMINISTRAZIONE.GET_ENTE(o.amministrazione) = 'SI'
   and a.dal = (select max (b.dal)
                  from anagrafe_unita_organizzative b
                 where b.progr_unita_organizzativa = a.progr_unita_organizzativa);


