CREATE TABLE PARAMETRI_FUNZIONE
(
  ID_PARAMETRO_FUNZIONE  NUMBER(8)              NOT NULL,
  ID_FUNZIONE            NUMBER(8)              NOT NULL,
  SEQUENZA               NUMBER(2)              NOT NULL,
  LABEL                  VARCHAR2(30 BYTE)      NOT NULL,
  TIPO                   VARCHAR2(1 BYTE)       DEFAULT 'C'                   NOT NULL,
  DIMENSIONE             NUMBER(2),
  VALORE_MIN             VARCHAR2(99 BYTE),
  VALORE_MAX             VARCHAR2(99 BYTE),
  VALORE_DEFAULT         VARCHAR2(99 BYTE),
  OBBLIGATORIO           VARCHAR2(2 BYTE)       DEFAULT 'NO'                  NOT NULL,
  NOTE                   VARCHAR2(2000 BYTE)
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

COMMENT ON COLUMN PARAMETRI_FUNZIONE.ID_PARAMETRO_FUNZIONE IS 'pk parametro';

COMMENT ON COLUMN PARAMETRI_FUNZIONE.ID_FUNZIONE IS 'Identificativo della funzione';

COMMENT ON COLUMN PARAMETRI_FUNZIONE.SEQUENZA IS 'Ordinale del parametro nel contesto della funzione. Valori da 1 a 15';

COMMENT ON COLUMN PARAMETRI_FUNZIONE.LABEL IS 'Descrittore del parametro sull''interfaccia';

COMMENT ON COLUMN PARAMETRI_FUNZIONE.TIPO IS 'Tipo di dato del parametro. Valori ammessi: ''C'' (char),''D'' (date),''N'' (number)';

COMMENT ON COLUMN PARAMETRI_FUNZIONE.DIMENSIONE IS 'Dimensione massima del valore assegnabile al parametro (per tipi C)';

COMMENT ON COLUMN PARAMETRI_FUNZIONE.VALORE_MIN IS 'Valore minimo assegnabile al parametro';

COMMENT ON COLUMN PARAMETRI_FUNZIONE.VALORE_MAX IS 'Valore massimo assegnabile al parametro';

COMMENT ON COLUMN PARAMETRI_FUNZIONE.VALORE_DEFAULT IS 'Eventuale valore di default assegnabile al parametro';

COMMENT ON COLUMN PARAMETRI_FUNZIONE.OBBLIGATORIO IS 'Obbligatorieta'' del parametro: SI/NO';

COMMENT ON COLUMN PARAMETRI_FUNZIONE.NOTE IS 'Informazioni aggiuntive su parametro';



