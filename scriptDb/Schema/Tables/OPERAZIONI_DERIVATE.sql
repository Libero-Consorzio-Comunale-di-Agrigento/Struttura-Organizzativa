CREATE TABLE OPERAZIONI_DERIVATE
(
  ID_MODIFICA  NUMBER(10)                       NOT NULL,
  OTTICA       VARCHAR2(18 BYTE)                NOT NULL,
  ESECUZIONE   NUMBER(1)
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

COMMENT ON TABLE OPERAZIONI_DERIVATE IS 'Tabella ';

COMMENT ON COLUMN OPERAZIONI_DERIVATE.ID_MODIFICA IS 'Identificativo della riga';

COMMENT ON COLUMN OPERAZIONI_DERIVATE.OTTICA IS 'Ottica di riferimento';

COMMENT ON COLUMN OPERAZIONI_DERIVATE.ESECUZIONE IS 'Indicatore di operazione eseguita:
1: l''operazione è già stata applicata sull''ottica derivata
0: l''operazione deve essere ancora applicata
-1: l''operazione NON deve essere eseguita (annullata)';



