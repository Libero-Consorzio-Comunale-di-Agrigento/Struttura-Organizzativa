ALTER TABLE TIPI_TITOLO ADD (
  CONSTRAINT TIPI_TITOLO_PK
  PRIMARY KEY
  (TITOLO)
  USING INDEX TIPI_TITOLO_PK
  ENABLE VALIDATE);
