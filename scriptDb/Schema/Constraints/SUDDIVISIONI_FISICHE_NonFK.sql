ALTER TABLE SUDDIVISIONI_FISICHE ADD (
  CONSTRAINT SUDDIVISIONI__ASSEGNABILE_CC
  CHECK (ASSEGNABILE is null or (ASSEGNABILE in ('SI','NO')))
  ENABLE VALIDATE);

ALTER TABLE SUDDIVISIONI_FISICHE ADD (
  CONSTRAINT SUDDIVISIONI_FISICHE_PK
  PRIMARY KEY
  (ID_SUDDIVISIONE)
  USING INDEX SUDDIVISIONI_FISICHE_PK
  ENABLE VALIDATE);

