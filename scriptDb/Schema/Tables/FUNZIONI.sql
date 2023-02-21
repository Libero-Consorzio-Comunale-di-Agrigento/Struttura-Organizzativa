CREATE TABLE FUNZIONI
(
  ID_FUNZIONE  NUMBER(8),
  FUNZIONE     VARCHAR2(30 BYTE),
  DESCRIZIONE  VARCHAR2(120 BYTE),
  NOTE         VARCHAR2(2000 BYTE)
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

COMMENT ON COLUMN FUNZIONI.ID_FUNZIONE IS 'PK';

COMMENT ON COLUMN FUNZIONI.FUNZIONE IS 'Codice identificativo della funzione; corrisponde al nome dell''oggetto oracle';

COMMENT ON COLUMN FUNZIONI.DESCRIZIONE IS 'Descrizione della funzione';

COMMENT ON COLUMN FUNZIONI.NOTE IS 'Note descrittive delle modalita'' di utilizzo';



