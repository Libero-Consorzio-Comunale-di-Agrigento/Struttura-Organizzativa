CREATE GLOBAL TEMPORARY TABLE TEMP_CF4_UNITA_AGG
(
  PROGR_UNITA_ORG  NUMBER(8)                    NOT NULL,
  SE_TRATTATA      VARCHAR2(1 BYTE)
)
ON COMMIT DELETE ROWS;

COMMENT ON TABLE TEMP_CF4_UNITA_AGG IS 'Tabella temporanea per function relative alla procedura CF4 - Lista unita'' aggiuntive';

COMMENT ON COLUMN TEMP_CF4_UNITA_AGG.PROGR_UNITA_ORG IS 'Progressivo dell''unita'' organizzativa da trattare';

COMMENT ON COLUMN TEMP_CF4_UNITA_AGG.SE_TRATTATA IS 'Indica se l''unita'' organizzativa e'' gia'' stata trattata';



