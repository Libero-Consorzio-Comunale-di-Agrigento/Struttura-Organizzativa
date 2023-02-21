CREATE GLOBAL TEMPORARY TABLE TEMP_SKEMA_VAL
(
  NI               NUMBER(8),
  NOMINATIVO       VARCHAR2(240 BYTE),
  ID_COMPONENTE    NUMBER(8),
  PROGR_UNOR       NUMBER(8),
  CODICE_UO        VARCHAR2(50 BYTE),
  DESCRIZIONE      VARCHAR2(240 BYTE),
  DAL              DATE,
  AL               DATE,
  VAL_NI           NUMBER(8),
  VAL_NOMINATIVO   VARCHAR2(240 BYTE),
  VAL_DAL          DATE,
  VAL_AL           DATE,
  VAL_CODICE_UO    VARCHAR2(50 BYTE),
  VAL_DESCRIZIONE  VARCHAR2(240 BYTE),
  VAL_LIVELLO      NUMBER(4)
)
ON COMMIT PRESERVE ROWS;

COMMENT ON TABLE TEMP_SKEMA_VAL IS 'Tabella temporanea per funzioni di ricerca valutatori per applicativo Skema.';

COMMENT ON COLUMN TEMP_SKEMA_VAL.NI IS 'Identificativo del soggetto da valutare';

COMMENT ON COLUMN TEMP_SKEMA_VAL.NOMINATIVO IS 'Nominativo del soggetto da valutare';

COMMENT ON COLUMN TEMP_SKEMA_VAL.ID_COMPONENTE IS 'Identificativo dell''assegnazione da valutare';

COMMENT ON COLUMN TEMP_SKEMA_VAL.PROGR_UNOR IS 'Progressivo dell''unita di assegnazione';

COMMENT ON COLUMN TEMP_SKEMA_VAL.CODICE_UO IS 'Codice dell''unita di assegnazione';

COMMENT ON COLUMN TEMP_SKEMA_VAL.DESCRIZIONE IS 'Descrizione dell''unita di assegnazione';

COMMENT ON COLUMN TEMP_SKEMA_VAL.DAL IS 'Data inizio assegnazione';

COMMENT ON COLUMN TEMP_SKEMA_VAL.AL IS 'Data fine assegnazione';

COMMENT ON COLUMN TEMP_SKEMA_VAL.VAL_NI IS 'Identificativo del soggetto valutatore';

COMMENT ON COLUMN TEMP_SKEMA_VAL.VAL_NOMINATIVO IS 'Nominativo del soggetto valutatore';

COMMENT ON COLUMN TEMP_SKEMA_VAL.VAL_DAL IS 'Data inizio validita valutatore';

COMMENT ON COLUMN TEMP_SKEMA_VAL.VAL_AL IS 'Data fine validita valutatore';



