CREATE TABLE ATTRIBUTI_UNITA_FISICA_CI
(
  PROGR_UNITA_FISICA    NUMBER(8),
  ATTRIBUTO             VARCHAR2(240 BYTE),
  VALORE                VARCHAR2(240 BYTE),
  DAL                   DATE,
  AL                    DATE,
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

COMMENT ON TABLE ATTRIBUTI_UNITA_FISICA_CI IS 'Attributi estesi dell''unita'' fisica di competenza dell''applicativo CESPITI';



