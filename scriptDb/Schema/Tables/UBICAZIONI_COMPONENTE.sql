CREATE TABLE UBICAZIONI_COMPONENTE
(
  ID_UBICAZIONE_COMPONENTE  NUMBER(8)           NOT NULL,
  ID_COMPONENTE             NUMBER(8)           NOT NULL,
  ID_UBICAZIONE_UNITA       NUMBER(8)           NOT NULL,
  DAL                       DATE,
  AL                        DATE,
  ID_ORIGINE                NUMBER(8),
  UTENTE_AGGIORNAMENTO      VARCHAR2(8 BYTE),
  DATA_AGGIORNAMENTO        DATE
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

COMMENT ON TABLE UBICAZIONI_COMPONENTE IS 'Associazione componente/sede fisica';

COMMENT ON COLUMN UBICAZIONI_COMPONENTE.ID_UBICAZIONE_COMPONENTE IS 'Identificativo del record';

COMMENT ON COLUMN UBICAZIONI_COMPONENTE.ID_COMPONENTE IS 'Identificativo del record di COMPONENTI';

COMMENT ON COLUMN UBICAZIONI_COMPONENTE.ID_UBICAZIONE_UNITA IS 'Identificativo del record di UBICAZIONI_UNITA';

COMMENT ON COLUMN UBICAZIONI_COMPONENTE.DAL IS 'Data di inizio assegnazione del componente all''unita fisica';

COMMENT ON COLUMN UBICAZIONI_COMPONENTE.AL IS 'Data di fine assegnazione del componente all''unita fisica';

COMMENT ON COLUMN UBICAZIONI_COMPONENTE.ID_ORIGINE IS 'In caso di registrazione ereditata, identificativo del record che ha generato la registrazione';

COMMENT ON COLUMN UBICAZIONI_COMPONENTE.UTENTE_AGGIORNAMENTO IS 'Utente dell''ultimo aggiornamento';

COMMENT ON COLUMN UBICAZIONI_COMPONENTE.DATA_AGGIORNAMENTO IS 'Data dell''ultimo aggiornamento';



