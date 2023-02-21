CREATE TABLE WORK_ALLINEA_UO_AS4
(
  OPERAZIONE                 VARCHAR2(1 BYTE)   NOT NULL,
  NI_AS4                     NUMBER(8),
  PROGR_UNITA_ORGANIZZATIVA  NUMBER(8)          NOT NULL,
  DAL                        DATE               NOT NULL,
  OLD_DAL                    DATE,
  DESCRIZIONE                VARCHAR2(240 BYTE) NOT NULL,
  INDIRIZZO                  VARCHAR2(120 BYTE),
  PROVINCIA                  NUMBER(3),
  COMUNE                     NUMBER(3),
  CAP                        VARCHAR2(5 BYTE),
  TELEFONO                   VARCHAR2(14 BYTE),
  FAX                        VARCHAR2(14 BYTE),
  UTENTE_AGG                 VARCHAR2(14 BYTE)
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


