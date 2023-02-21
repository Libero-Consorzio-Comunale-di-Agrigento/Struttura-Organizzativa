ALTER TABLE SOGGETTI_RUBRICA ADD (
  CONSTRAINT SOGGETTI_RUBR_PUBBLICABILE_CC
  CHECK (PUBBLICABILE is null or (PUBBLICABILE in ('S','N') and PUBBLICABILE = upper(PUBBLICABILE)))
  ENABLE VALIDATE);

ALTER TABLE SOGGETTI_RUBRICA ADD (
  CONSTRAINT SOGGETTI_RUBRICA_PK
  PRIMARY KEY
  (NI, TIPO_CONTATTO, PROGRESSIVO)
  USING INDEX SOGGETTI_RUBRICA_PK
  ENABLE VALIDATE);

