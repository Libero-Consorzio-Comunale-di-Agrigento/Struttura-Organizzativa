CREATE TABLE AOO
(
  PROGR_AOO               NUMBER(8)             NOT NULL,
  DAL                     DATE                  NOT NULL,
  CODICE_AMMINISTRAZIONE  VARCHAR2(50 BYTE)     NOT NULL,
  CODICE_AOO              VARCHAR2(100 BYTE)    NOT NULL,
  DESCRIZIONE             VARCHAR2(1000 BYTE)   NOT NULL,
  DESCRIZIONE_AL1         VARCHAR2(240 BYTE),
  DESCRIZIONE_AL2         VARCHAR2(240 BYTE),
  DES_ABB                 VARCHAR2(20 BYTE),
  DES_ABB_AL1             VARCHAR2(20 BYTE),
  DES_ABB_AL2             VARCHAR2(20 BYTE),
  INDIRIZZO               VARCHAR2(120 BYTE),
  CAP                     VARCHAR2(5 BYTE),
  PROVINCIA               NUMBER(3),
  COMUNE                  NUMBER(3),
  TELEFONO                VARCHAR2(14 BYTE),
  FAX                     VARCHAR2(14 BYTE),
  AL                      DATE,
  UTENTE_AGGIORNAMENTO    VARCHAR2(8 BYTE),
  DATA_AGGIORNAMENTO      DATE,
  CODICE_IPA              VARCHAR2(100 BYTE)
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

COMMENT ON TABLE AOO IS 'Anagrafica Aree Organizzative Omogenee
';

COMMENT ON COLUMN AOO.PROGR_AOO IS 'Codice numerico dell''area organizzativa omogenea';

COMMENT ON COLUMN AOO.DAL IS 'Data inizio validita'' dell''area organizzativa omogenea';

COMMENT ON COLUMN AOO.CODICE_AMMINISTRAZIONE IS 'Codice dell''amministrazione a cui appartiene l''area organizzativa omogenea
';

COMMENT ON COLUMN AOO.CODICE_AOO IS 'Codice dell''area organizzativa omogenea';

COMMENT ON COLUMN AOO.DESCRIZIONE IS 'Descrizione dell''area organizzativa omogenea';

COMMENT ON COLUMN AOO.DESCRIZIONE_AL1 IS 'Descrizione dell''area organizzativa omogenea in lingua alternativa 1
';

COMMENT ON COLUMN AOO.DESCRIZIONE_AL2 IS 'Descrizione dell''area organizzativa omogenea in lingua alternativa 2';

COMMENT ON COLUMN AOO.DES_ABB IS 'Descrizione abbreviata';

COMMENT ON COLUMN AOO.DES_ABB_AL1 IS 'Descrizione abbreviata in lingua alternativa 1';

COMMENT ON COLUMN AOO.DES_ABB_AL2 IS 'Descrizione abbreviata in lingua alternativa 2';

COMMENT ON COLUMN AOO.INDIRIZZO IS 'Indirizzo';

COMMENT ON COLUMN AOO.CAP IS 'Cap';

COMMENT ON COLUMN AOO.PROVINCIA IS 'Codice provincia';

COMMENT ON COLUMN AOO.COMUNE IS 'Codice comune';

COMMENT ON COLUMN AOO.TELEFONO IS 'Numero di telefono';

COMMENT ON COLUMN AOO.FAX IS 'Numero di fax';

COMMENT ON COLUMN AOO.AL IS 'Data fine validita'' area organizzativa omogenea';

COMMENT ON COLUMN AOO.UTENTE_AGGIORNAMENTO IS 'Utente che ha effettuato l''ultimo aggiornamento';

COMMENT ON COLUMN AOO.DATA_AGGIORNAMENTO IS 'Data dell''ultimo aggiornamento effettuato
';

COMMENT ON COLUMN AOO.CODICE_IPA IS 'Codice Univoco da IPA';



