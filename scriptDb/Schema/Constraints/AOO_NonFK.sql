ALTER TABLE AOO ADD (
  CONSTRAINT AOO_PK
  PRIMARY KEY
  (PROGR_AOO, DAL)
  USING INDEX AOO_PK
  ENABLE VALIDATE);

