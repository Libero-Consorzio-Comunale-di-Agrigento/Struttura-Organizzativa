ALTER TABLE ATTRIBUTI_ASSEGNAZIONE_FISICA ADD (
  CONSTRAINT ATAF_PK
  PRIMARY KEY
  (ID_ASFI, ATTRIBUTO, DAL)
  USING INDEX ATAF_PK
  ENABLE VALIDATE);

