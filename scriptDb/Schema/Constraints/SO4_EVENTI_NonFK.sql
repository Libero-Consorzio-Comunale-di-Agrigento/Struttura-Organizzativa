ALTER TABLE SO4_EVENTI ADD (
  CONSTRAINT EVENTI_PK
  PRIMARY KEY
  (ID_EVENTO)
  USING INDEX EVENTI_PK
  ENABLE VALIDATE);
