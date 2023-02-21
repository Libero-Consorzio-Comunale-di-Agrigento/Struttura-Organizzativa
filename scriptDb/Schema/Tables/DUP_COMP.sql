CREATE TABLE DUP_COMP
(
  ID_COMPONENTE              NUMBER(8)          NOT NULL,
  PROGR_UNITA_ORGANIZZATIVA  NUMBER(8)          NOT NULL,
  DAL                        DATE,
  AL                         DATE,
  NI                         NUMBER(8),
  CI                         NUMBER(8),
  CODICE_FISCALE             VARCHAR2(16 BYTE),
  DENOMINAZIONE              VARCHAR2(240 BYTE),
  DENOMINAZIONE_AL1          VARCHAR2(240 BYTE),
  DENOMINAZIONE_AL2          VARCHAR2(240 BYTE),
  STATO                      VARCHAR2(1 BYTE),
  OTTICA                     VARCHAR2(18 BYTE)  NOT NULL,
  REVISIONE_ASSEGNAZIONE     NUMBER(8),
  REVISIONE_CESSAZIONE       NUMBER(8),
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

COMMENT ON TABLE DUP_COMP IS 'Tabella di appoggio per componenti aggiornati con la stessa decorrenza';

COMMENT ON COLUMN DUP_COMP.ID_COMPONENTE IS 'Identificativo della registrazione del componente (sequence)';

COMMENT ON COLUMN DUP_COMP.PROGR_UNITA_ORGANIZZATIVA IS 'Codice numerico dell''unita'' organizzativa a cui sono associati i componenti';

COMMENT ON COLUMN DUP_COMP.DAL IS 'Data inizio validita'' componente';

COMMENT ON COLUMN DUP_COMP.AL IS 'Data fine validita'' componente';

COMMENT ON COLUMN DUP_COMP.NI IS 'Identificativo dell''anagrafe soggetti del componente (solo per componenti gia'' codificati)';

COMMENT ON COLUMN DUP_COMP.CI IS 'CI per l''integrazione con la procedura GP4';

COMMENT ON COLUMN DUP_COMP.CODICE_FISCALE IS 'Codice fiscale del componente (solo per i componenti non inseriti nell''anagrafe soggetti)';

COMMENT ON COLUMN DUP_COMP.DENOMINAZIONE IS 'Denominazione del componente (solo per i componenti non inseriti nell''anagrafe soggetti)';

COMMENT ON COLUMN DUP_COMP.DENOMINAZIONE_AL1 IS 'Denominazione del componente in lingua alternativa 1 (solo per i componenti non inseriti nell''anagrafe soggetti)';

COMMENT ON COLUMN DUP_COMP.DENOMINAZIONE_AL2 IS 'Denominazione del componente in lingua alternativa 2 (solo per i componenti non inseriti nell''anagrafe soggetti)';

COMMENT ON COLUMN DUP_COMP.STATO IS 'Indica se l''assegnazione e provvisoria o definitiva';

COMMENT ON COLUMN DUP_COMP.OTTICA IS 'Ottica di istituzione del legame';

COMMENT ON COLUMN DUP_COMP.REVISIONE_ASSEGNAZIONE IS 'Revisione di istituzione del legame';

COMMENT ON COLUMN DUP_COMP.REVISIONE_CESSAZIONE IS 'Revisione di cessazione del legame';

COMMENT ON COLUMN DUP_COMP.UTENTE_AGGIORNAMENTO IS 'Utente ultimo aggiornamento';

COMMENT ON COLUMN DUP_COMP.DATA_AGGIORNAMENTO IS 'Data ultimo aggiornamento';



