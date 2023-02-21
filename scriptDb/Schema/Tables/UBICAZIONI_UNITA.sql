CREATE TABLE UBICAZIONI_UNITA
(
  ID_UBICAZIONE              NUMBER(8)          NOT NULL,
  PROGR_UNITA_ORGANIZZATIVA  NUMBER(8)          NOT NULL,
  SEQUENZA                   NUMBER(6)          NOT NULL,
  DAL                        DATE               NOT NULL,
  AL                         DATE,
  PROGR_UNITA_FISICA         NUMBER(8)          NOT NULL,
  ID_ORIGINE                 NUMBER(8),
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

COMMENT ON TABLE UBICAZIONI_UNITA IS 'Ubicazioni unita'' organizzative';

COMMENT ON COLUMN UBICAZIONI_UNITA.ID_UBICAZIONE IS 'Identificativo delle registrazione dell''ubicazione (sequence)';

COMMENT ON COLUMN UBICAZIONI_UNITA.PROGR_UNITA_ORGANIZZATIVA IS 'Identificativo dell''unita'' organizzativa da mettere in relazione con l''unita'' fisica';

COMMENT ON COLUMN UBICAZIONI_UNITA.SEQUENZA IS 'Sequenza dell''unita'' organizzativa nell''ambito dell''ubicazione';

COMMENT ON COLUMN UBICAZIONI_UNITA.DAL IS 'Data inizio validita'' dell''ubicazione';

COMMENT ON COLUMN UBICAZIONI_UNITA.AL IS 'Data fine validita'' dell''ubicazione';

COMMENT ON COLUMN UBICAZIONI_UNITA.PROGR_UNITA_FISICA IS 'Identificativo dell''unita'' fisica da mettere in relazione con l''unita'' organizzativa';

COMMENT ON COLUMN UBICAZIONI_UNITA.ID_ORIGINE IS 'In caso di registrazione ereditata, identificativo del record che ha generato la registrazione';



