ALTER TABLE ASSEGNAZIONI_FISICHE ADD (
  CONSTRAINT ASSEGNAZIONI_FISICHE_PK
  PRIMARY KEY
  (ID_ASFI)
  USING INDEX ASSEGNAZIONI_FISICHE_PK
  ENABLE VALIDATE);
