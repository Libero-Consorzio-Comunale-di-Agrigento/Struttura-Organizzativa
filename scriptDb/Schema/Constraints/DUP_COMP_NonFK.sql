ALTER TABLE DUP_COMP ADD (
  CONSTRAINT DUP_COMP_STATO_CC
  CHECK (STATO is null or (STATO in ('P','D')))
  ENABLE VALIDATE);

