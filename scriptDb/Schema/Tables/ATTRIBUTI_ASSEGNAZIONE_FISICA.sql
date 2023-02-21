CREATE TABLE ATTRIBUTI_ASSEGNAZIONE_FISICA
(
  ID_ASFI               NUMBER(8)               NOT NULL,
  ATTRIBUTO             VARCHAR2(240 BYTE)      NOT NULL,
  DAL                   DATE                    NOT NULL,
  AL                    DATE,
  VALORE                VARCHAR2(240 BYTE)      NOT NULL,
  UTENTE_AGGIORNAMENTO  VARCHAR2(8 BYTE),
  DATA_AGGIORNAMENTO    DATE
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

COMMENT ON TABLE ATTRIBUTI_ASSEGNAZIONE_FISICA IS 'Attributi estesi delle assegnazioni fisiche';



