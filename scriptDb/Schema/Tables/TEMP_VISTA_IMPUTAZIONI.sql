CREATE GLOBAL TEMPORARY TABLE TEMP_VISTA_IMPUTAZIONI
(
  PROGR_UNITA_ORGANIZZATIVA  NUMBER(8),
  NUMERO                     NUMBER(6),
  SEDE                       VARCHAR2(8 BYTE),
  DESCRIZIONE                VARCHAR2(120 BYTE)
)
ON COMMIT PRESERVE ROWS;

