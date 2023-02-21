CREATE TABLE UNITA_FISICHE
(
  ID_ELEMENTO_FISICO     NUMBER(8)              NOT NULL,
  AMMINISTRAZIONE        VARCHAR2(50 BYTE)      NOT NULL,
  PROGR_UNITA_FISICA     NUMBER(8)              NOT NULL,
  ID_UNITA_FISICA_PADRE  NUMBER(8),
  SEQUENZA               NUMBER(6),
  DAL                    DATE                   NOT NULL,
  AL                     DATE,
  UTENTE_AGGIORNAMENTO   VARCHAR2(8 BYTE),
  DATA_AGGIORNAMENTO     DATE
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

COMMENT ON TABLE UNITA_FISICHE IS 'Tabella relazioni tra unita fisiche';

COMMENT ON COLUMN UNITA_FISICHE.ID_ELEMENTO_FISICO IS 'Identificativo del record della struttura fisica (sequence)';

COMMENT ON COLUMN UNITA_FISICHE.AMMINISTRAZIONE IS 'Amministrazione di riferimento';

COMMENT ON COLUMN UNITA_FISICHE.PROGR_UNITA_FISICA IS 'Codice numerico dell''unita'' fisica (figlia)';

COMMENT ON COLUMN UNITA_FISICHE.ID_UNITA_FISICA_PADRE IS 'Identificativo del record della struttura relativo al padre';

COMMENT ON COLUMN UNITA_FISICHE.SEQUENZA IS 'Sequenza del legame nell''ambito della suddivisione';

COMMENT ON COLUMN UNITA_FISICHE.DAL IS 'Data inizio validita'' legame';

COMMENT ON COLUMN UNITA_FISICHE.AL IS 'Data fine validita'' legame';

COMMENT ON COLUMN UNITA_FISICHE.UTENTE_AGGIORNAMENTO IS 'Utente dell''ultimo aggiornamento';

COMMENT ON COLUMN UNITA_FISICHE.DATA_AGGIORNAMENTO IS 'Data dell''ultimo aggiornamento';



