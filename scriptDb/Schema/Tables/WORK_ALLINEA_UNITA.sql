CREATE TABLE WORK_ALLINEA_UNITA
(
  OTTICA         VARCHAR2(18 BYTE),
  PROGR_FIGLIO   NUMBER(8),
  CODICE_FIGLIO  VARCHAR2(50 BYTE),
  DESCR_FIGLIO   VARCHAR2(240 BYTE),
  DAL            DATE,
  AL             DATE,
  PROGR_PADRE    NUMBER(8),
  CODICE_PADRE   VARCHAR2(50 BYTE),
  DAL_PADRE      DATE,
  LIVELLO        NUMBER(2)
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

COMMENT ON TABLE WORK_ALLINEA_UNITA IS 'Tabella di lavoro per allinea unita'' protocollo';

COMMENT ON COLUMN WORK_ALLINEA_UNITA.OTTICA IS 'Ottica di riferimento';

COMMENT ON COLUMN WORK_ALLINEA_UNITA.PROGR_FIGLIO IS 'Progressivo unita'' organizzativa figlio';

COMMENT ON COLUMN WORK_ALLINEA_UNITA.CODICE_FIGLIO IS 'Codice dell''unita'' organizzativa figlio';

COMMENT ON COLUMN WORK_ALLINEA_UNITA.DESCR_FIGLIO IS 'Descrizione dell''unita'' organizzativa figlio';

COMMENT ON COLUMN WORK_ALLINEA_UNITA.DAL IS 'Data inizio validita'' legame';

COMMENT ON COLUMN WORK_ALLINEA_UNITA.AL IS 'Data fine validita'' legame';

COMMENT ON COLUMN WORK_ALLINEA_UNITA.PROGR_PADRE IS 'Progressivo unita'' organizzativa padre';

COMMENT ON COLUMN WORK_ALLINEA_UNITA.CODICE_PADRE IS 'Codice dell''unita'' organizzativa padre';

COMMENT ON COLUMN WORK_ALLINEA_UNITA.DAL_PADRE IS 'Data inizio validita'' codice padre';

COMMENT ON COLUMN WORK_ALLINEA_UNITA.LIVELLO IS 'Livello di nesting dell''unita'' figlio';



