ALTER TABLE SLAVES ADD (
  CONSTRAINT SLAVES_STATO_CC
  CHECK (STATO in ('A','D'))
  ENABLE VALIDATE);

ALTER TABLE SLAVES ADD (
  CONSTRAINT SLAVES_PK
  PRIMARY KEY
  (DB_LINK)
  USING INDEX SLAVES_PK
  ENABLE VALIDATE);
