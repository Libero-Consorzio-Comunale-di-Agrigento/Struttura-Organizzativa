ALTER TABLE SO4_DOCUMENTI ADD (
  CONSTRAINT SO4_DOCUMENTI_PK
  PRIMARY KEY
  (TIPO_REGISTRO, ANNO, NUMERO)
  USING INDEX SO4_DOCUMENTI_PK
  ENABLE VALIDATE);
