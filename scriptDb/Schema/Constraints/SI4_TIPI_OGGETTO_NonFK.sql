ALTER TABLE SI4_TIPI_OGGETTO ADD (
  CONSTRAINT SI4_TIPI_OGGETTO_PK
  PRIMARY KEY
  (ID_TIPO_OGGETTO)
  USING INDEX SI4_TIPI_OGGETTO_PK
  ENABLE VALIDATE);

ALTER TABLE SI4_TIPI_OGGETTO ADD (
  CONSTRAINT TIPO_OGGETTO_UK
  UNIQUE (TIPO_OGGETTO)
  USING INDEX TIPO_OGGETTO_UK
  ENABLE VALIDATE);

