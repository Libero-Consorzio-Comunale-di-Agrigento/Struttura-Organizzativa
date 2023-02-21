CREATE TABLE STILI_VISUALI
(
  STILE        VARCHAR2(18 BYTE)                NOT NULL,
  DESCRIZIONE  VARCHAR2(120 BYTE)
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

COMMENT ON TABLE STILI_VISUALI IS 'Elenco stili visuali utilizzati per la stampa struttura (Regione Marche)';

COMMENT ON COLUMN STILI_VISUALI.STILE IS 'Codice stile visuale';

COMMENT ON COLUMN STILI_VISUALI.DESCRIZIONE IS 'Descrizione stile visuale';



