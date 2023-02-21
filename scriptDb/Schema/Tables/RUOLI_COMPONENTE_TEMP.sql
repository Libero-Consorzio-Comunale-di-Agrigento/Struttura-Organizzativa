CREATE GLOBAL TEMPORARY TABLE RUOLI_COMPONENTE_TEMP
(
  ID_COMPONENTE              NUMBER(8),
  NI                         NUMBER(10),
  CI                         NUMBER(8),
  DAL                        DATE,
  AL                         DATE,
  PROGR_UNITA_ORGANIZZATIVA  NUMBER(8),
  RUOLO                      VARCHAR2(8 BYTE),
  OTTICA                     VARCHAR2(18 BYTE),
  DAL_PUBB                   DATE,
  AL_PUBB                    DATE
)
ON COMMIT DELETE ROWS;

COMMENT ON TABLE RUOLI_COMPONENTE_TEMP IS 'Tabella temporanea di appoggio ruoli per assegnazioni da GPS';

COMMENT ON COLUMN RUOLI_COMPONENTE_TEMP.ID_COMPONENTE IS 'Identificativo del componente';

COMMENT ON COLUMN RUOLI_COMPONENTE_TEMP.NI IS 'Identificativo del soggetto';

COMMENT ON COLUMN RUOLI_COMPONENTE_TEMP.CI IS 'Codice Individuale del soggetto (per gestione paghe)';

COMMENT ON COLUMN RUOLI_COMPONENTE_TEMP.DAL IS 'Data inizio validita';

COMMENT ON COLUMN RUOLI_COMPONENTE_TEMP.AL IS 'Data fine validita';

COMMENT ON COLUMN RUOLI_COMPONENTE_TEMP.PROGR_UNITA_ORGANIZZATIVA IS 'Progressivo dell''unita organizzativa';

COMMENT ON COLUMN RUOLI_COMPONENTE_TEMP.RUOLO IS 'Codice ruolo';

COMMENT ON COLUMN RUOLI_COMPONENTE_TEMP.OTTICA IS 'Codice ottica';

COMMENT ON COLUMN RUOLI_COMPONENTE_TEMP.DAL_PUBB IS 'Data inizio validita pubblicata';

COMMENT ON COLUMN RUOLI_COMPONENTE_TEMP.AL_PUBB IS 'Data fine validita pubblicata';



