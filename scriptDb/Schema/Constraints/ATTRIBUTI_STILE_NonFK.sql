ALTER TABLE ATTRIBUTI_STILE ADD (
  CONSTRAINT ATTRIBUTI_STILE_PK
  PRIMARY KEY
  (STILE, ATTRIBUTO)
  USING INDEX ATTRIBUTI_STILE_PK
  ENABLE VALIDATE);

