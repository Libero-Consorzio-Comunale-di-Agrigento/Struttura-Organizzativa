ALTER TABLE ANAGRAFE_UNITA_FISICHE ADD (
  CONSTRAINT ANAGRAFE_UNIT_ASSEGNABILE_CC
  CHECK (ASSEGNABILE is null or (ASSEGNABILE in ('SI','NO')))
  ENABLE VALIDATE);

ALTER TABLE ANAGRAFE_UNITA_FISICHE ADD (
  CONSTRAINT ANAGRAFE_UNITA_FISICHE_PK
  PRIMARY KEY
  (PROGR_UNITA_FISICA, DAL)
  USING INDEX ANAGRAFE_UNITA_FISICHE_PK
  ENABLE VALIDATE);

