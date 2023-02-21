CREATE TABLE RELAZIONI_RUOLI
(
  ID_RELAZIONE          NUMBER(10)              DEFAULT 0                     NOT NULL,
  OTTICA                VARCHAR2(18 BYTE)       DEFAULT '%'                   NOT NULL,
  CODICE_UO             VARCHAR2(50 BYTE)       DEFAULT '%'                   NOT NULL,
  UO_DISCENDENTI        VARCHAR2(2 BYTE)        DEFAULT 'NO'                  NOT NULL,
  SUDDIVISIONE          VARCHAR2(8 BYTE)        DEFAULT '%'                   NOT NULL,
  INCARICO              VARCHAR2(8 BYTE)        DEFAULT '%'                   NOT NULL,
  RESPONSABILE          VARCHAR2(2 BYTE)        DEFAULT '%'                   NOT NULL,
  DIPENDENTE            VARCHAR2(2 BYTE)        DEFAULT '%'                   NOT NULL,
  NOTE                  VARCHAR2(2000 BYTE),
  RUOLO                 VARCHAR2(8 BYTE)        NOT NULL,
  UTENTE_AGGIORNAMENTO  VARCHAR2(8 BYTE),
  DATA_AGGIORNAMENTO    DATE,
  DATA_ELIMINAZIONE     DATE
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

COMMENT ON COLUMN RELAZIONI_RUOLI.ID_RELAZIONE IS 'PK numerica progressiva';

COMMENT ON COLUMN RELAZIONI_RUOLI.OTTICA IS 'Codice dell''ottica';

COMMENT ON COLUMN RELAZIONI_RUOLI.CODICE_UO IS 'Codice dell''unita'' organizzativa di assegnazione del componente';

COMMENT ON COLUMN RELAZIONI_RUOLI.UO_DISCENDENTI IS 'Se SI, la condizione sara'' soddisfatta anche per i componenti assegnati alle UO del ramo di struttura al di sotto dell''UO indicata ';

COMMENT ON COLUMN RELAZIONI_RUOLI.SUDDIVISIONE IS 'Codice della suddivisione struttura dell''UO di assegnazione del componente';

COMMENT ON COLUMN RELAZIONI_RUOLI.INCARICO IS 'Codice dell''incarico attribuito al componente';

COMMENT ON COLUMN RELAZIONI_RUOLI.RESPONSABILE IS 'Valori SI, NO, % ; attributo dell''incarico attribuito al componente';

COMMENT ON COLUMN RELAZIONI_RUOLI.DIPENDENTE IS 'La condizione e'' soddisfatta se il componente e'' di origine HCM ';

COMMENT ON COLUMN RELAZIONI_RUOLI.NOTE IS 'Note descrittive della relazione';

COMMENT ON COLUMN RELAZIONI_RUOLI.RUOLO IS 'Ruolo applicativo che verra'' assegnato ai componenti che soddisfano tutte le condizioni indicate nella regola';

COMMENT ON COLUMN RELAZIONI_RUOLI.UTENTE_AGGIORNAMENTO IS 'Codice dell''utente reponsabile del record';

COMMENT ON COLUMN RELAZIONI_RUOLI.DATA_AGGIORNAMENTO IS 'Data dell''ultimo aggiornemento';



