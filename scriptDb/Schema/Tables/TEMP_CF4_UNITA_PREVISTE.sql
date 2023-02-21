CREATE GLOBAL TEMPORARY TABLE TEMP_CF4_UNITA_PREVISTE
(
  PROGR_UNITA_ORG  NUMBER(8)                    NOT NULL
)
ON COMMIT DELETE ROWS;

COMMENT ON TABLE TEMP_CF4_UNITA_PREVISTE IS 'Tabella temporanea per function relative alla procedura CF4: lista unita'' previste';

COMMENT ON COLUMN TEMP_CF4_UNITA_PREVISTE.PROGR_UNITA_ORG IS 'Progressivo dell''unita'' organizzativa da trattare';



