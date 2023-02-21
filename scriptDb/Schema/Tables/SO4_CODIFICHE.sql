CREATE TABLE SO4_CODIFICHE
(
  ID_CODIFICA     NUMBER(8)                     NOT NULL,
  DOMINIO         VARCHAR2(240 BYTE)            NOT NULL,
  VALORE          VARCHAR2(240 BYTE)            NOT NULL,
  DESCRIZIONE     VARCHAR2(240 BYTE)            NOT NULL,
  VALORE_DEFAULT  NUMBER(1)                     DEFAULT 0                     NOT NULL,
  SEQUENZA        NUMBER(3)
)
TABLESPACE SO4
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

COMMENT ON TABLE SO4_CODIFICHE IS 'Contiene le decodifiche delle colonne';

COMMENT ON COLUMN SO4_CODIFICHE.ID_CODIFICA IS 'Identificativo del record';

COMMENT ON COLUMN SO4_CODIFICHE.DOMINIO IS 'Campo di applicazione, nel formato <nome_table>.<nome campo>';

COMMENT ON COLUMN SO4_CODIFICHE.VALORE IS 'Valore della codifica';

COMMENT ON COLUMN SO4_CODIFICHE.DESCRIZIONE IS 'Descrizione della codifica';

COMMENT ON COLUMN SO4_CODIFICHE.VALORE_DEFAULT IS '1 : Eventuale valore di default da proporre sull''interfaccia';

COMMENT ON COLUMN SO4_CODIFICHE.SEQUENZA IS 'Sequenza di ordinamento';



