CREATE TABLE DELEGHE
(
  ID_DELEGA                  NUMBER(10)         NOT NULL,
  DELEGANTE                  NUMBER(8)          NOT NULL,
  DELEGATO                   NUMBER(8)          NOT NULL,
  OTTICA                     VARCHAR2(18 BYTE),
  PROGR_UNITA_ORGANIZZATIVA  NUMBER(8),
  RUOLO                      VARCHAR2(8 BYTE),
  ID_COMPETENZA_DELEGA       NUMBER,
  DAL                        DATE               NOT NULL,
  AL                         DATE,
  UTENTE_AGGIORNAMENTO       VARCHAR2(8 BYTE),
  DATA_AGGIORNAMENTO         DATE
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


