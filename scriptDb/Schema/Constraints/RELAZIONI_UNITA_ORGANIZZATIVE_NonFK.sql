ALTER TABLE RELAZIONI_UNITA_ORGANIZZATIVE ADD (
  CONSTRAINT RELAZIONI_UO_PK
  PRIMARY KEY
  (ID_RELAZIONI_STRUTTURA)
  USING INDEX RELAZIONI_UO_PK
  ENABLE VALIDATE);

