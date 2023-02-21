CREATE TABLE AMMINISTRAZIONI
(
  CODICE_AMMINISTRAZIONE  VARCHAR2(50 BYTE)     NOT NULL,
  NI                      NUMBER(8)             NOT NULL,
  DATA_ISTITUZIONE        DATE,
  DATA_SOPPRESSIONE       DATE,
  ENTE                    VARCHAR2(2 BYTE)      NOT NULL,
  UTENTE_AGGIORNAMENTO    VARCHAR2(8 BYTE),
  DATA_AGGIORNAMENTO      DATE
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

COMMENT ON TABLE AMMINISTRAZIONI IS 'Contiene i dati dell''amministrazione dell''ente proprietario e quelli delle amministrazioni esterne (per GS4)';

COMMENT ON COLUMN AMMINISTRAZIONI.CODICE_AMMINISTRAZIONE IS 'Codice amministrazione';

COMMENT ON COLUMN AMMINISTRAZIONI.NI IS 'Identificativo dell''anagrafe soggetti relativo all''amministrazione';

COMMENT ON COLUMN AMMINISTRAZIONI.DATA_ISTITUZIONE IS 'Data istituzione amministrazione';

COMMENT ON COLUMN AMMINISTRAZIONI.DATA_SOPPRESSIONE IS 'Data soppressione amministrazione';

COMMENT ON COLUMN AMMINISTRAZIONI.ENTE IS 'Indica se l''amministrazione e'' di proprieta'' (gestito in SO4)';

COMMENT ON COLUMN AMMINISTRAZIONI.UTENTE_AGGIORNAMENTO IS 'Utente ultimo aggiornamento';

COMMENT ON COLUMN AMMINISTRAZIONI.DATA_AGGIORNAMENTO IS 'Data ultimo aggiornamento';



