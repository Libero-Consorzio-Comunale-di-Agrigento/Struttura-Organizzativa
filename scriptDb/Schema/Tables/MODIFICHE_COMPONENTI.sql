CREATE TABLE MODIFICHE_COMPONENTI
(
  ID_MODIFICA              NUMBER(10)           NOT NULL,
  OTTICA                   VARCHAR2(18 BYTE)    NOT NULL,
  ID_COMPONENTE            NUMBER(10),
  ID_ATTRIBUTO_COMPONENTE  NUMBER(10),
  OPERAZIONE               VARCHAR2(1 BYTE)
)
TABLESPACE SO4
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

COMMENT ON TABLE MODIFICHE_COMPONENTI IS 'Tabella di riferimento per le operazioni eseguite sui componenti da riportare sulle ottiche derivate';

COMMENT ON COLUMN MODIFICHE_COMPONENTI.ID_MODIFICA IS 'Identificativo della riga di tabella';

COMMENT ON COLUMN MODIFICHE_COMPONENTI.OTTICA IS 'Codice dell''ottica origine delle modifiche';

COMMENT ON COLUMN MODIFICHE_COMPONENTI.ID_COMPONENTE IS 'Identificativo della riga della tabella COMPONENTI oggetto di modifica';

COMMENT ON COLUMN MODIFICHE_COMPONENTI.ID_ATTRIBUTO_COMPONENTE IS 'Identificativo della riga della tabella ATTRIBUTI_COMPONENTE oggetto di modifica';

COMMENT ON COLUMN MODIFICHE_COMPONENTI.OPERAZIONE IS 'Tipo di operazione effettuata:
N: nuovo componente (assunzione)
S: spostamento (modifica di assegnazione di un componente preesistente)
C: chiusura del periodo di assegnazione (cessazione)
P: prolungamento di un periodo di assegnazione
U: modifica della sola UO di assegnazione
A: modifica ai soli attributi';



