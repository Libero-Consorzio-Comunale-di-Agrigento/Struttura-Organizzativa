ALTER TABLE AMV_DOCUMENTI_REVISIONI ADD (
  CONSTRAINT AMV_DORE_DOCU_FK 
  FOREIGN KEY (ID_DOCUMENTO, REVISIONE) 
  REFERENCES AMV_DOCUMENTI (ID_DOCUMENTO,REVISIONE)
  ENABLE VALIDATE);

