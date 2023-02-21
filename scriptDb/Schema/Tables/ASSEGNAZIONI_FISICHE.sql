CREATE TABLE ASSEGNAZIONI_FISICHE
(
  ID_ASFI                    NUMBER(8)          NOT NULL,
  ID_UBICAZIONE_COMPONENTE   NUMBER(8),
  NI                         NUMBER(8)          NOT NULL,
  PROGR_UNITA_FISICA         NUMBER(8)          NOT NULL,
  DAL                        DATE               NOT NULL,
  AL                         DATE,
  PROGR_UNITA_ORGANIZZATIVA  NUMBER(8),
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

COMMENT ON TABLE ASSEGNAZIONI_FISICHE IS 'Assegnazioni dei soggetti alla struttura fisica';



