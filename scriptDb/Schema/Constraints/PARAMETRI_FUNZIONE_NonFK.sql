ALTER TABLE PARAMETRI_FUNZIONE ADD (
  CONSTRAINT PARAMETRI_OBBLIGATORIO_CC
  CHECK (OBBLIGATORIO in ('SI','NO'))
  ENABLE VALIDATE);

ALTER TABLE PARAMETRI_FUNZIONE ADD (
  CONSTRAINT PARAMETRI_TIPO_CC
  CHECK (TIPO in ('C','D','N'))
  ENABLE VALIDATE);

ALTER TABLE PARAMETRI_FUNZIONE ADD (
  CONSTRAINT PAFU_PK
  PRIMARY KEY
  (ID_PARAMETRO_FUNZIONE)
  USING INDEX PAFU_PK
  ENABLE VALIDATE);

