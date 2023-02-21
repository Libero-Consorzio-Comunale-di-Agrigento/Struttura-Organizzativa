CREATE TABLE UNITA_ORGANIZZATIVE
(
  ID_ELEMENTO                NUMBER(8)          NOT NULL,
  OTTICA                     VARCHAR2(18 BYTE)  NOT NULL,
  REVISIONE                  NUMBER(8),
  SEQUENZA                   NUMBER(6),
  PROGR_UNITA_ORGANIZZATIVA  NUMBER(8)          NOT NULL,
  ID_UNITA_PADRE             NUMBER(8),
  REVISIONE_CESSAZIONE       NUMBER(8),
  DAL                        DATE,
  AL                         DATE,
  UTENTE_AGGIORNAMENTO       VARCHAR2(8 BYTE),
  DATA_AGGIORNAMENTO         DATE,
  DAL_PUBB                   DATE,
  AL_PUBB                    DATE,
  AL_PREC                    DATE,
  REVISIONE_CESS_PREC        NUMBER(8)
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

COMMENT ON TABLE UNITA_ORGANIZZATIVE IS 'Relazioni tra unita'' organizzative padre / figlio';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE.ID_ELEMENTO IS 'Identificativo del record della struttura organizzativa (sequence)';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE.OTTICA IS 'Codice ottica';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE.REVISIONE IS 'Codice revisione di istituzione del legame padre/figlio';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE.SEQUENZA IS 'Sequenza legame nell''ambito della struttura / suddivisione';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE.PROGR_UNITA_ORGANIZZATIVA IS 'Codice numerico dell''anagrafica dell''unita'' organizzativa';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE.ID_UNITA_PADRE IS 'Identificativo del record della struttura relativo al padre';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE.REVISIONE_CESSAZIONE IS 'Codice revisione di cessazione del legame padre/figlio';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE.DAL IS 'Data inizio validita'' legame';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE.AL IS 'Data fine validita'' legame';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE.UTENTE_AGGIORNAMENTO IS 'Utente ultimo aggiornamento';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE.DATA_AGGIORNAMENTO IS 'Data ultimo aggiornamento';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE.DAL_PUBB IS 'Data inizio validita'' pubblicata';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE.AL_PUBB IS 'Data fine validita'' pubblicata';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE.AL_PREC IS 'Data fine validita'' memorizzata';

COMMENT ON COLUMN UNITA_ORGANIZZATIVE.REVISIONE_CESS_PREC IS 'Revisione di cessazione memorizzata';



