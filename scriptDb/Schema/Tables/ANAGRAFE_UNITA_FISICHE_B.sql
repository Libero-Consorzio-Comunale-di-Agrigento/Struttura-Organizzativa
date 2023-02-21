CREATE TABLE ANAGRAFE_UNITA_FISICHE_B
(
  PROGR_UNITA_FISICA    NUMBER(8)               NOT NULL,
  DAL                   DATE                    NOT NULL,
  CODICE_UF             VARCHAR2(50 BYTE)       NOT NULL,
  DENOMINAZIONE         VARCHAR2(240 BYTE)      NOT NULL,
  DENOMINAZIONE_AL1     VARCHAR2(240 BYTE),
  DENOMINAZIONE_AL2     VARCHAR2(240 BYTE),
  DES_ABB               VARCHAR2(20 BYTE),
  DES_ABB_AL1           VARCHAR2(20 BYTE),
  DES_ABB_AL2           VARCHAR2(20 BYTE),
  INDIRIZZO             VARCHAR2(40 BYTE),
  CAP                   VARCHAR2(5 BYTE),
  PROVINCIA             NUMBER(3),
  COMUNE                NUMBER(3),
  NOTA_INDIRIZZO        VARCHAR2(2000 BYTE),
  NOTA_INDIRIZZO_AL1    VARCHAR2(2000 BYTE),
  NOTA_INDIRIZZO_AL2    VARCHAR2(2000 BYTE),
  AMMINISTRAZIONE       VARCHAR2(50 BYTE)       NOT NULL,
  ID_SUDDIVISIONE       NUMBER(8),
  GENERICO              VARCHAR2(2 BYTE),
  AL                    DATE,
  UTENTE_AGGIORNAMENTO  VARCHAR2(8 BYTE),
  DATA_AGGIORNAMENTO    DATE,
  CAPIENZA              NUMBER(4),
  ASSEGNABILE           VARCHAR2(2 BYTE),
  NOTE                  VARCHAR2(4000 BYTE),
  NUMERO_CIVICO         NUMBER(6),
  ESPONENTE_CIVICO_1    VARCHAR2(10 BYTE),
  ESPONENTE_CIVICO_2    VARCHAR2(10 BYTE),
  TIPO_CIVICO           VARCHAR2(30 BYTE),
  ID_DOCUMENTO          NUMBER(10),
  LINK_PLANIMETRIA      VARCHAR2(2000 BYTE),
  IMMAGINE_PLANIMETRIA  BLOB,
  OPERAZIONE            VARCHAR2(2 BYTE),
  NOTE_SESSIONE         VARCHAR2(200 BYTE),
  DATA_OPERAZIONE       TIMESTAMP(6),
  ID_BACKUP             NUMBER(10)              NOT NULL,
  CONTESTO              VARCHAR2(1 BYTE)
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

COMMENT ON TABLE ANAGRAFE_UNITA_FISICHE_B IS 'Anagrafica elementi della struttura fisica: Backup per pubblicazione eventi';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.PROGR_UNITA_FISICA IS 'Codice numerico dell''unita'' fisica';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.DAL IS 'Data inizio validita'' anagrafica unita'' fisica';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.CODICE_UF IS 'Codice unita'' fisica';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.DENOMINAZIONE IS 'Denominazione unita'' fisica';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.DENOMINAZIONE_AL1 IS 'Denominazione unita'' fisica in lingua alternativa 1';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.DENOMINAZIONE_AL2 IS 'Denominazione unita'' fisica in lingua alternativa 2';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.DES_ABB IS 'Descrizione abbreviata unita'' fisica';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.DES_ABB_AL1 IS 'Descrizione abbreviata unita'' fisica in lingua alternativa 1';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.DES_ABB_AL2 IS 'Descrizione abbreviata unita'' fisica in lingua alternativa 2';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.INDIRIZZO IS 'Indirizzo unita'' fisica';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.CAP IS 'Cap unita'' fisica';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.PROVINCIA IS 'Provincia unita'' fisica (codice)';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.COMUNE IS 'Comune unita'' fisica (codice)';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.NOTA_INDIRIZZO IS 'Nota indirizzo';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.NOTA_INDIRIZZO_AL1 IS 'Nota indirizzo in lingua alternativa 1';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.NOTA_INDIRIZZO_AL2 IS 'Nota indirizzo in lingua alternativa 2';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.AMMINISTRAZIONE IS 'Amministrazione di riferimento';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.ID_SUDDIVISIONE IS 'Identificativo della suddivisione';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.GENERICO IS 'Indica se l''unita fisica e'' generica e quindi puo'' essere inserita piui volte nella struttura oppure e'' univoca';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.AL IS 'Data fine validita''';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.UTENTE_AGGIORNAMENTO IS 'Utente ultimo aggiornamento';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.DATA_AGGIORNAMENTO IS 'Data ultimo aggiornamento';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.CAPIENZA IS 'Numero postazioni';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.ASSEGNABILE IS 'Indica la possibilita'' di assegnare individui/componenti alla unita'' fisica';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.NOTE IS 'Note descrittive';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.NUMERO_CIVICO IS 'Numero civico';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.ESPONENTE_CIVICO_1 IS 'Prima parte dell''esponente del numero civico (per georeferenziazione)';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.ESPONENTE_CIVICO_2 IS 'Seconda parte dell''esponente del numero civico (per georeferenziazione)';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.TIPO_CIVICO IS 'Tipologia numero civico (per georeferenziazione)';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.ID_DOCUMENTO IS 'Identificativo del documento relativo alla UF in ambito GDM (planimetria, altri doc., ecc.)';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.LINK_PLANIMETRIA IS 'Nome del file dell''immagine della planimetria se registrato su filesystem';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.IMMAGINE_PLANIMETRIA IS 'Immagine della planimetria se registrata sul db';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.OPERAZIONE IS 'Tipologia di operazione I: Insert; D: Delete; BU: Before Update; AU: After Update';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.NOTE_SESSIONE IS 'Eventuale modifica extra interfaccia';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.DATA_OPERAZIONE IS 'Data di esecuzione della modifica';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.ID_BACKUP IS 'Identificativo della modifica';

COMMENT ON COLUMN ANAGRAFE_UNITA_FISICHE_B.CONTESTO IS 'R: modifica in revisione; X: modifica extrarevisione; T: modifica temporanea (in revisione pre attivazione)';



