ALTER TABLE SO4_AGGREGATORI ADD (
  CONSTRAINT SO4_AGGREGATORI_PK
  PRIMARY KEY
  (AGGREGATORE, DATA_INIZIO_VALIDITA)
  USING INDEX SO4_AGGREGATORI_PK
  ENABLE VALIDATE);
