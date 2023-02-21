ALTER TABLE AMV_DOCUMENTI_BLOB ADD (
  CONSTRAINT AMV_DOBL_BLOB_FK 
  FOREIGN KEY (ID_BLOB) 
  REFERENCES AMV_BLOB (ID_BLOB)
  ENABLE VALIDATE);

ALTER TABLE AMV_DOCUMENTI_BLOB ADD (
  CONSTRAINT AMV_DOBL_DORE_FK 
  FOREIGN KEY (ID_DOCUMENTO, REVISIONE) 
  REFERENCES AMV_DOCUMENTI_REVISIONI (ID_DOCUMENTO,REVISIONE)
  ENABLE VALIDATE);
