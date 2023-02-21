ALTER TABLE AMV_RILEVANZE ADD (
  CONSTRAINT AMV_RILEVANZE_ID_RILEVANZA_CC
  CHECK (ID_RILEVANZA >= 1)
  ENABLE VALIDATE);

ALTER TABLE AMV_RILEVANZE ADD (
  CONSTRAINT AMV_RILEVANZE_IMPORTANZA_CC
  CHECK (IMPORTANZA is null or ( IMPORTANZA in ('HL','HP') ))
  ENABLE VALIDATE);

ALTER TABLE AMV_RILEVANZE ADD (
  CONSTRAINT AMV_RILEVANZE_ZONA_CC
  CHECK (ZONA is null or ( ZONA in ('S','C','D') ))
  ENABLE VALIDATE);

ALTER TABLE AMV_RILEVANZE ADD (
  CONSTRAINT AMV_RILEVANZE_ZONA_FORMATO_CC
  CHECK (ZONA_FORMATO is null or ( ZONA_FORMATO in ('T','I') ))
  ENABLE VALIDATE);

ALTER TABLE AMV_RILEVANZE ADD (
  CONSTRAINT AMV_RILEVANZE_ZONA_VISIBILI_CC
  CHECK (ZONA_VISIBILITA is null or ( ZONA_VISIBILITA in ('S','H','C') ))
  ENABLE VALIDATE);

ALTER TABLE AMV_RILEVANZE ADD (
  CONSTRAINT AMV_RILEVANZE_PK
  PRIMARY KEY
  (ID_RILEVANZA)
  USING INDEX AMV_RILEVANZE_PK
  ENABLE VALIDATE);

ALTER TABLE AMV_RILEVANZE ADD (
  CONSTRAINT AMV_RILE_NOME_AK
  UNIQUE (NOME)
  USING INDEX AMV_RILE_NOME_AK
  ENABLE VALIDATE);

