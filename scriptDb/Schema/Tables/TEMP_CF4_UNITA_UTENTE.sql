CREATE GLOBAL TEMPORARY TABLE TEMP_CF4_UNITA_UTENTE
(
  ID_RECORD        NUMBER(8),
  PROGR_UNITA_ORG  NUMBER(8),
  CODICE_UO        VARCHAR2(50 BYTE),
  DESCRIZIONE_UO   VARCHAR2(240 BYTE),
  PROGR_UO_PADRE   NUMBER(8),
  ICONA            VARCHAR2(200 BYTE),
  PROGR_RAMO       NUMBER(8)
)
ON COMMIT PRESERVE ROWS;

COMMENT ON TABLE TEMP_CF4_UNITA_UTENTE IS 'Tabella temporanea per function relative alla procedura CF4 - Unita'' per utente';

COMMENT ON COLUMN TEMP_CF4_UNITA_UTENTE.ID_RECORD IS 'Identificativo del record ';

COMMENT ON COLUMN TEMP_CF4_UNITA_UTENTE.PROGR_UNITA_ORG IS 'Codice numerico dell''unita'' organizzativa
';

COMMENT ON COLUMN TEMP_CF4_UNITA_UTENTE.CODICE_UO IS 'Codice alfanumerico dell''unita'' organizzativa';

COMMENT ON COLUMN TEMP_CF4_UNITA_UTENTE.DESCRIZIONE_UO IS 'Descrizione dell''unita'' organizzativa';

COMMENT ON COLUMN TEMP_CF4_UNITA_UTENTE.PROGR_UO_PADRE IS 'Codice numerico dell''unita'' padre';

COMMENT ON COLUMN TEMP_CF4_UNITA_UTENTE.ICONA IS 'Icona associata alla unita'' organizzativa';

COMMENT ON COLUMN TEMP_CF4_UNITA_UTENTE.PROGR_RAMO IS 'Progressivo del ramo che si sta trattando';



