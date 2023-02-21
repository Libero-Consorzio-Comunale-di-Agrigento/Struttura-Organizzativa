ALTER TABLE TIPI_INCARICO ADD (
  CONSTRAINT TIPI_INCARICO_RESPONSABILE_CC
  CHECK (RESPONSABILE is null or (RESPONSABILE in ('SI','NO') and RESPONSABILE = upper(RESPONSABILE)))
  ENABLE VALIDATE);

ALTER TABLE TIPI_INCARICO ADD (
  CONSTRAINT TIPI_INCARICO_SE_ASPETTATIV_CC
  CHECK (SE_ASPETTATIVA is null or (SE_ASPETTATIVA in ('SI','NO') and SE_ASPETTATIVA = upper(SE_ASPETTATIVA)))
  ENABLE VALIDATE);

ALTER TABLE TIPI_INCARICO ADD (
  CONSTRAINT TIPI_INCARICO_TIPO_INCARICO_CC
  CHECK (TIPO_INCARICO is null or (TIPO_INCARICO in ('A','P','S','E') and TIPO_INCARICO = upper(TIPO_INCARICO)))
  ENABLE VALIDATE);

ALTER TABLE TIPI_INCARICO ADD (
  CONSTRAINT TIPI_INCARICO_PK
  PRIMARY KEY
  (INCARICO)
  USING INDEX TIPI_INCARICO_PK
  ENABLE VALIDATE);

