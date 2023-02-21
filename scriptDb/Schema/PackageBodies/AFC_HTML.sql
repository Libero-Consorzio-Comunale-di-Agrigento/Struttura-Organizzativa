CREATE OR REPLACE PACKAGE BODY AFC_HTML IS
/******************************************************************************
NOME:        AFC_HTML
DESCRIZIONE: Generazione html di tabella visualizzata ad albero
ANNOTAZIONI: -
REVISIONI:
Rev. Data       Autore Descrizione
---- ---------- ------ ------------------------------------------------------
000  03/12/2004 SN     Prima emissione.
001  04/03/2005 SN     Riorganizzazione codice.
002  14/06/2005 SN     Passaggio anche del nome dell'immagine e link da usare
003  22/06/2005 SN     Funzione che genera html per visualizzare la mappa.
004  12/07/2005 SM     Sistemato errore per html in caso di mappa su piu colonne
005  27/07/2005 SN     Modificato per consentire di passare con la pagina anche
                                    eventuali parametri.
006  05/09/2005 SN     Sistemazioni varie
007  28/09/2005 MF     Introduzione Revisione differenziata tra Specification e Body.
008  23/09/2005 SN     Previsto parametro per le where condition per la mappa.
009  06/10/2005 SN     Previsto parametro per le where condition per gli alberi.
010  06/10/2005 SN     Sistemata dimensione variabile D_NVL_P_STRUTTURA_ID.
011  14/10/2005 SN     Merge tra modifiche di SN e di MF
012  15/11/2005 SN     Inserimento GETBLANKLINK
013  31/01/2006 SN     Errore in caso di uso where condition nella function TROVA_TUTTI
014  06/02/2006 SN     Aggiunta possibilit� di indicare che non si vuole il link
                                    per certi nodi, occorre passare il valore 'NULLO' nella colonna link
015  13/02/2006 SN     Modificata la funzione tab_folder togliendo gli spazi inutili dentro i td.
016  14/02/2006 SN     Migliorie di performance in DISEGNA_ALBERO e DISEGNA_ALBERO_ESPLOSO
017  30/05/2006 SN     Stringa piccola portata a 200 caratteri per costruzione link.
018  23/10/2009 MM     Modificata funzione GET_BLANK_LINK spezzando la stringa
                       '//--' in '//-'||'-' per facilitare il parse del package.
019  04/11/2009 SNeg    Corretto per riposizionamento nell'albero
******************************************************************************/
   s_revisione_body t_revision := '019';
   subtype STRINGA_MEDIA   IS VARCHAR2 (1000);
   subtype STRINGA_PICCOLA IS VARCHAR2 (200);
   subtype T_UNO           IS VARCHAR2 (1);
   FUNCTION LEGGI_REGISTRO (P_CHIAVE VARCHAR2, P_STRINGA VARCHAR2)
      RETURN VARCHAR2;
   PROCEDURE IMPOSTA_DA_REGISTRO (
      P_VARIABILE       OUT      VARCHAR2,
      P_CHIAVE          IN       VARCHAR2,
      P_VOCE_REGISTRO   IN       VARCHAR2,
      P_DEFAULT         IN       VARCHAR2 DEFAULT NULL
   );
   D_ESPANDI_AL_LIVELLO        NUMBER          := 0;
   D_VISUALIZZA_DA             NUMBER          := 0;
   D_VISUALIZZA_A              NUMBER          := 0;
   D_TROVATI                   NUMBER          := 0;
   D_SCRITTI                   NUMBER          := 0;
   -- immagini
   D_DIRECTORY                 STRINGA_GRANDE  := '../common/images/AMV/';
   D_INIZIO_IMMAGINE           STRINGA_PICCOLA := '<img border="0" src="';
   D_FINE_IMMAGINE             STRINGA_PICCOLA := '" align="AbsMiddle">';
   D_FLD_CLOSE                 STRINGA_MEDIA
      :=    D_INIZIO_IMMAGINE
         || D_DIRECTORY
         || 'cmsfolderclosed.gif'
         || D_FINE_IMMAGINE;
   D_FOGLIA                    STRINGA_MEDIA
        := D_INIZIO_IMMAGINE || D_DIRECTORY || 'cmsdoc.gif' || D_FINE_IMMAGINE;
   D_LINE_FOGLIA               STRINGA_MEDIA
       := D_INIZIO_IMMAGINE || D_DIRECTORY || 'cmsnode.gif' || D_FINE_IMMAGINE;
   D_LAST_LINE_FOGLIA          STRINGA_MEDIA
      := D_INIZIO_IMMAGINE || D_DIRECTORY || 'cmslastnode.gif'
         || D_FINE_IMMAGINE;
   D_FLD_OPEN                  STRINGA_MEDIA
      :=    D_INIZIO_IMMAGINE
         || D_DIRECTORY
         || 'cmsfolderopen.gif'
         || D_FINE_IMMAGINE;
   D_LAST_FLD_OPEN             STRINGA_MEDIA
      :=    D_INIZIO_IMMAGINE
         || D_DIRECTORY
         || 'cmslastfolderopen.gif'
         || D_FINE_IMMAGINE;
   D_PLUS_NODE                 STRINGA_MEDIA
      := D_INIZIO_IMMAGINE || D_DIRECTORY || 'cmspnode.gif' || D_FINE_IMMAGINE;
   D_LAST_PLUS_NODE            STRINGA_MEDIA
      :=    D_INIZIO_IMMAGINE
         || D_DIRECTORY
         || 'cmsplastnode.gif'
         || D_FINE_IMMAGINE;
   D_MINUS_NODE                STRINGA_MEDIA
      := D_INIZIO_IMMAGINE || D_DIRECTORY || 'cmsmnode.gif' || D_FINE_IMMAGINE;
   D_LAST_MINUS_NODE           STRINGA_MEDIA
      :=    D_INIZIO_IMMAGINE
         || D_DIRECTORY
         || 'cmsmlastnode.gif'
         || D_FINE_IMMAGINE;
   D_IMG_LINE                  STRINGA_MEDIA
      := D_INIZIO_IMMAGINE || D_DIRECTORY || 'cmsvertline.gif'
         || D_FINE_IMMAGINE;
   D_BLANK                     STRINGA_MEDIA
      := D_INIZIO_IMMAGINE || D_DIRECTORY || 'cmsblank.gif' || D_FINE_IMMAGINE;
   -- visualizzazione foglie
   D_FUNCTION_TABELLA          STRINGA_MEDIA;
   D_IMG_TABELLA               STRINGA_MEDIA;
   D_ULT_IMG_TABELLA           STRINGA_MEDIA;
   D_TROVATO_TABELLA           NUMBER (1)      := 0;
   D_LIVELLO_TABELLA           NUMBER (1)      := 0;
   D_TABELLA_CLOB              CLOB            := EMPTY_CLOB ();
   D_IMG_OPEN                  STRINGA_MEDIA;
   D_IMG_NODE                  STRINGA_MEDIA;
   D_IMG_NODE_OPEN             STRINGA_MEDIA;
   D_IMG                       STRINGA_MEDIA   := D_FLD_CLOSE;
   D_COLONNA                   STRINGA_PICCOLA;
   D_COLONNA_PADRE             STRINGA_PICCOLA;
   D_COLONNA_ORDINAMENTO       STRINGA_PICCOLA;
   D_COLONNA_NOME              STRINGA_PICCOLA;
   D_COLONNA_IMMAGINE          STRINGA_PICCOLA;
   D_COLONNA_IMMAGINE_OPEN     STRINGA_PICCOLA;
   D_COLONNA_LINK              STRINGA_PICCOLA;
   --d_colonna_titolo          stringa_piccola;
   D_COLONNA_CLASS             STRINGA_PICCOLA;
   D_TABELLA                   STRINGA_PICCOLA;
   D_SOLO_UN_FOLDER_APERTO     T_UNO;
   D_PAGINA                    STRINGA_PICCOLA;
   D_INCLUSIONE                T_UNO;
   D_PARAMETRO_INCLUSIONE      STRINGA_PICCOLA;
   D_INSERIRE_POSIZIONAMENTO   T_UNO;
   D_POSIZIONAMENTO            STRINGA_GRANDE;
   D_PAGINA_URL                STRINGA_MEDIA;
   D_PARAMETRO_URL             STRINGA_PICCOLA;
   D_SEPARATORE                T_UNO;
   D_PARAMETRO_HREF_FIGLIO     STRINGA_GRANDE;
   D_PARAMETRO_HREF_PADRE      STRINGA_GRANDE;
   D_VISUALIZZA_FOGLIE         T_UNO;
   D_ULTIMO                    STRINGA_GRANDE;
   D_SOLO_UNA_FOGLIA_APERTA    T_UNO;
   D_MOSTRA_TUTTE_FOGLIE       T_UNO;
   D_WHERE                     STRINGA_GRANDE;
   function versione return t_revision is
   /******************************************************************************
    NOME:        VERSIONE
    DESCRIZIONE: Restituisce versione e revisione di distribuzione del package.
    RITORNA:     stringa VARCHAR2 contenente versione e revisione.
    NOTE:        Primo numero  : versione compatibilita del Package.
                 Secondo numero: revisione del Package specification.
                 Terzo numero  : revisione del Package body.
   ******************************************************************************/
   begin
      return s_revisione||'.'||s_revisione_body;
   end versione;
   procedure IMPOSTA_DA_REGISTRO (
      P_VARIABILE       OUT      VARCHAR2,
      P_CHIAVE          IN       VARCHAR2,
      P_VOCE_REGISTRO   IN       VARCHAR2,
      P_DEFAULT         IN       VARCHAR2 DEFAULT NULL
   ) is
   /******************************************************************************
    PROCEDURE:   IMPOSTA_DA_REGISTRO
    DESCRIZIONE:
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  03/12/2004 SN     Prima emissione.
   ******************************************************************************/
   BEGIN
      P_VARIABILE :=
            '<img border="0" src="'
         || D_DIRECTORY
         || NVL (LEGGI_REGISTRO (P_CHIAVE, P_VOCE_REGISTRO), P_DEFAULT)
         || '" align="AbsMiddle">';
   END;
   procedure INIZIA_TABELLA (
      P_LIVELLO              NUMBER,
      P_FRATELLI             NUMBER,
      P_NUMERO_FIGLI_PADRE   NUMBER
   ) is
   /******************************************************************************
    PROCEDURE:   INIZIA_TABELLA
    DESCRIZIONE: Predispone codice html per apertura tabella
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  03/12/2004 SN     Prima emissione.
   ******************************************************************************/
      D_INIZIO_TABELLA   STRINGA_GRANDE;
   BEGIN
      IF P_FRATELLI = 1
      THEN
         D_IMG_TABELLA := D_BLANK;
      ELSE
         D_IMG_TABELLA := D_IMG_LINE;
      END IF;
      IF P_NUMERO_FIGLI_PADRE = 0
      THEN
         D_ULT_IMG_TABELLA := D_BLANK;
      ELSE
         D_ULT_IMG_TABELLA := D_IMG_LINE;
      END IF;
      DBMS_LOB.CREATETEMPORARY (D_TABELLA_CLOB, TRUE, DBMS_LOB.SESSION);
      D_INIZIO_TABELLA := '<table BORDER="0" CELLPADDING="0" CELLSPACING="0">';
      DBMS_LOB.WRITEAPPEND (D_TABELLA_CLOB,
                            LENGTH (D_INIZIO_TABELLA),
                            D_INIZIO_TABELLA
                           );
      D_TROVATO_TABELLA := 0;
      D_LIVELLO_TABELLA := P_LIVELLO;
   END;
   procedure INIZIA_RIGA
   is
   /******************************************************************************
    PROCEDURE:   INIZIA_RIGA
    DESCRIZIONE: Predispone codice html per inziare una riga
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  03/12/2004 SN     Prima emissione.
   ******************************************************************************/
      D_ROW   STRINGA_GRANDE;
   BEGIN
      D_ROW := '<tr>';
      FOR I IN 1 .. D_LIVELLO_TABELLA - 1
      LOOP
         D_ROW := D_ROW || '<td>' || D_IMG_LINE || '</td>';
      END LOOP;
      D_ROW := D_ROW || '<td>' || D_IMG_TABELLA || '</td>';
      D_ROW := D_ROW || '<td>' || D_ULT_IMG_TABELLA || '</td>';
      D_ROW := D_ROW || '<td>' || D_BLANK || '</td>';
      DBMS_LOB.WRITEAPPEND (D_TABELLA_CLOB, LENGTH (D_ROW), D_ROW);
   END;
   function AGGIUNGI_DATO
   ( D_COLONNA varchar2
   ) return varchar2 is
   /******************************************************************************
    FUNCTION:    AGGIUNGI_DATO
    DESCRIZIONE:
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  03/12/2004 SN     Prima emissione.
   ******************************************************************************/
   BEGIN
      RETURN ('<TD>' || D_COLONNA || '&'||'nbsp;</td>');
   END;
   procedure METTI_INTESTAZIONE
   ( P_STRINGA varchar2
   ) is
   /******************************************************************************
    PROCEDURE:   PROCEDURE METTI_INTESTAZIONE
    DESCRIZIONE: Predispone codice html per intestazione tabella
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  03/12/2004 SN     Prima emissione.
   ******************************************************************************/
      D_INTESTAZIONE   STRINGA_GRANDE := AGGIUNGI_DATO (P_STRINGA);
   BEGIN
      DBMS_LOB.WRITEAPPEND (D_TABELLA_CLOB,
                            LENGTH (D_INTESTAZIONE),
                            D_INTESTAZIONE
                           );
   END;
   procedure CHIUDI_RIGA
   is
   /******************************************************************************
    PROCEDURE:   CHIUDI_RIGA
    DESCRIZIONE: Predispone codice html per terminare una riga
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  03/12/2004 SN     Prima emissione.
   ******************************************************************************/
   BEGIN
      DBMS_LOB.WRITEAPPEND (D_TABELLA_CLOB, LENGTH ('</tr>'), '</tr>');
   END;
   procedure SCRIVI_COLONNA
   ( P_STRINGA varchar2
   ) is
   /******************************************************************************
    PROCEDURE:   SCRIVI_COLONNA
    DESCRIZIONE: Predispone codice html per scrivere una intestazione
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  03/12/2004 SN     Prima emissione.
   ******************************************************************************/
      D_RIGA   STRINGA_GRANDE := AGGIUNGI_DATO (P_STRINGA);
   BEGIN
      D_TROVATO_TABELLA := 1;
      DBMS_LOB.WRITEAPPEND (D_TABELLA_CLOB, LENGTH (D_RIGA), D_RIGA);
   END SCRIVI_COLONNA;
   procedure TREE_IMPOSTA
   (  P_ALBERO                   VARCHAR2,
      P_MODULO                   VARCHAR2,
      P_TABELLA                  VARCHAR2,
      P_COLONNA_PADRE            VARCHAR2,
      P_COLONNA_FIGLIO           VARCHAR2,
      P_COLONNA_NOME             VARCHAR2,
      P_EXPR_ORDINAMENTO         VARCHAR2,
      P_DISLOC_IMMAGINI          VARCHAR2 DEFAULT NULL,
      P_FUNC_FOGLIA              VARCHAR2 DEFAULT NULL,
      P_MOSTRA_FOGLIA            VARCHAR2 DEFAULT 'N',
      P_RIPOSIZIONA              VARCHAR2 DEFAULT 'N',
      P_UN_FOLDER_APERTO         VARCHAR2 DEFAULT 'S',
      P_INCLUSIONE               VARCHAR2 DEFAULT 'N',
      P_PAGINA_HREF              VARCHAR2 DEFAULT NULL,
      P_PARAMETRO_INCLUSIONE     VARCHAR2 DEFAULT NULL,
      P_PARAMETRO_URL            VARCHAR2 DEFAULT 'ST',
      P_SEPARATORE               VARCHAR2 DEFAULT '|',
      P_FLD_CLOSE                VARCHAR2 DEFAULT NULL,
      P_FLD_OPEN                 VARCHAR2 DEFAULT NULL,
      P_LAST_FLD_OPEN            VARCHAR2 DEFAULT NULL,
      P_PLUS_NODE                VARCHAR2 DEFAULT NULL,
      P_LAST_PLUS_NODE           VARCHAR2 DEFAULT NULL,
      P_MINUS_NODE               VARCHAR2 DEFAULT NULL,
      P_LAST_MINUS_NODE          VARCHAR2 DEFAULT NULL,
      P_IMG_LINE                 VARCHAR2 DEFAULT NULL,
      P_BLANK                    VARCHAR2 DEFAULT NULL,
      P_FOGLIA                   VARCHAR2 DEFAULT NULL,
      P_COLONNA_IMMAGINE         VARCHAR2 DEFAULT NULL,
      P_COLONNA_IMMAGINE_OPEN    VARCHAR2 DEFAULT NULL,
      P_COLONNA_LINK             VARCHAR2 DEFAULT NULL,
      P_SOLO_UNA_FOGLIA_APERTA   VARCHAR2 DEFAULT 'S',
      P_MOSTRA_TUTTE_FOGLIE      VARCHAR2 DEFAULT 'N',
      P_WHERE                    VARCHAR2 DEFAULT ''
   ) is
   /******************************************************************************
    PROCEDURE:   TREE_IMPOSTA
    DESCRIZIONE:
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  03/12/2004 SN     Prima emissione.
   ******************************************************************************/
      D_CHIAVE               STRINGA_GRANDE
         :=    'PRODUCTS/'
            || UPPER (P_MODULO)
            || '/AFC_HTML.TREE/'
            || UPPER (P_ALBERO);
      D_CHIAVE_DEFINIZIONE   STRINGA_GRANDE := D_CHIAVE || '/DEFINIZIONE';
   BEGIN
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE_DEFINIZIONE,
                                       'Colonna Figlio',
                                       P_COLONNA_FIGLIO
                                      );
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE_DEFINIZIONE,
                                       'Colonna Nome',
                                       P_COLONNA_NOME
                                      );
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE_DEFINIZIONE,
                                       'Colonna Ordinamento',
                                       P_EXPR_ORDINAMENTO
                                      );
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE_DEFINIZIONE,
                                       'Colonna Padre',
                                       P_COLONNA_PADRE
                                      );
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE_DEFINIZIONE,
                                       'Dati foglia',
                                       P_FUNC_FOGLIA
                                      );
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE_DEFINIZIONE,
                                       'Inclusione',
                                       P_INCLUSIONE
                                      );
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE_DEFINIZIONE,
                                       'Pagina href',
                                       P_PAGINA_HREF
                                      );
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE_DEFINIZIONE,
                                       'Parametro Inclusione',
                                       P_PARAMETRO_INCLUSIONE
                                      );
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE_DEFINIZIONE,
                                       'Parametro url',
                                       P_PARAMETRO_URL
                                      );
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE_DEFINIZIONE,
                                       'Separatore',
                                       NVL (P_SEPARATORE, '|')
                                      );
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE_DEFINIZIONE,
                                       'Tabella',
                                       P_TABELLA
                                      );
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE_DEFINIZIONE,
                                       'fld_close',
                                       NVL (P_FLD_CLOSE,
                                            'cmsfolderclosed.gif')
                                      );
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE_DEFINIZIONE,
                                       'fld_open',
                                       NVL (P_FLD_OPEN, 'cmsfolderopen.gif')
                                      );
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE_DEFINIZIONE,
                                       'last_fld_open',
                                       NVL (P_LAST_FLD_OPEN,
                                            'cmslastfolderopen.gif'
                                           )
                                      );
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE_DEFINIZIONE,
                                       'plus_node',
                                       NVL (P_PLUS_NODE, 'cmspnode.gif')
                                      );
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE_DEFINIZIONE,
                                       'last_plus_node',
                                       NVL (P_LAST_PLUS_NODE,
                                            'cmsplastnode.gif'
                                           )
                                      );
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE_DEFINIZIONE,
                                       'minus_node',
                                       NVL (P_MINUS_NODE, 'cmsmnode.gif')
                                      );
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE_DEFINIZIONE,
                                       'last_minus_node',
                                       NVL (P_LAST_MINUS_NODE,
                                            'cmsmlastnode.gif'
                                           )
                                      );
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE_DEFINIZIONE,
                                       'img_line',
                                       NVL (P_IMG_LINE, 'cmsvertline.gif')
                                      );
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE_DEFINIZIONE,
                                       'blank',
                                       NVL (P_BLANK, 'cmsblank.gif')
                                      );
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE,
                                       'Path_immagini',
                                       NVL (P_DISLOC_IMMAGINI,
                                            '../common/images/AMV/'
                                           )
                                      );
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE,
                                       'Visualizzazione dati foglia',
                                       P_MOSTRA_FOGLIA
                                      );
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE,
                                       'Riposizionamento',
                                       P_RIPOSIZIONA
                                      );
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE,
                                       'Un solo folder aperto',
                                       P_UN_FOLDER_APERTO
                                      );
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE,
                                       'Immagine Foglia',
                                       NVL (P_FOGLIA, 'cmsdoc.gif')
                                      );
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE,
                                       'Colonna con nome immagine',
                                       P_COLONNA_IMMAGINE
                                      );
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE,
                                       'Colonna con link',
                                       P_COLONNA_LINK
                                      );
      REGISTRO_UTILITY.SCRIVI_STRINGA
                                   (D_CHIAVE,
                                    'Colonna con nome immagine folder aperto',
                                    P_COLONNA_IMMAGINE_OPEN
                                   );
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE,
                                       'Solo una foglia aperta',
                                       P_SOLO_UNA_FOGLIA_APERTA
                                      );
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE,
                                       'Mostra tutte le foglie',
                                       P_MOSTRA_TUTTE_FOGLIE
                                      );
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE,
                                       'Condizioni sui record',
                                       P_WHERE
                                      );
   END;
   procedure TREE_IMPOSTA_PREFERENZE
   (  P_ALBERO          VARCHAR2,
      P_MODULO          VARCHAR2,
      P_IMMAGINI        VARCHAR2,
      P_MOSTRA_FOGLIA   VARCHAR2,
      P_RIPOSIZIONA     VARCHAR2,
      P_UNO_APERTO      VARCHAR2
   ) is
   /******************************************************************************
    PROCEDURE:   TREE_IMPOSTA_PREFERENZE
    DESCRIZIONE: Scrive nei registri le preferenze di visualizzazione dell'albero
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  03/12/2004 SN     Prima emissione.
   ******************************************************************************/
      D_CHIAVE   STRINGA_GRANDE
         :=    'PRODUCTS/'
            || UPPER (P_MODULO)
            || '/AFC_HTML.TREE/'
            || UPPER (P_ALBERO);
   BEGIN
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE,
                                       'Path_immagini',
                                       P_IMMAGINI,
                                       NULL,
                                       FALSE
                                      );
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE,
                                       'Visualizzazione dati foglia',
                                       P_MOSTRA_FOGLIA,
                                       NULL,
                                       FALSE
                                      );
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE,
                                       'Riposizionamento',
                                       P_RIPOSIZIONA,
                                       NULL,
                                       FALSE
                                      );
      REGISTRO_UTILITY.SCRIVI_STRINGA (D_CHIAVE,
                                       'Un solo folder aperto',
                                       P_UNO_APERTO,
                                       NULL,
                                       FALSE
                                      );
   END;
   function LEGGI_REGISTRO
   ( P_CHIAVE varchar2
   , P_STRINGA varchar2
   ) return varchar2 is
   /******************************************************************************
    FUNCTION:    LEGGI_REGISTRO
    DESCRIZIONE: Restituisce il valore della stringa del registro indicato.
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  03/12/2004 SN     Prima emissione.
   ******************************************************************************/
      D_VALORE   STRINGA_GRANDE;
   BEGIN
      REGISTRO_UTILITY.LEGGI_STRINGA (P_CHIAVE, P_STRINGA, D_VALORE);
      RETURN D_VALORE;
   END;
   procedure INIZIALIZZA_PARAMETRI
   ( P_MODULO varchar2
   , P_ALBERO varchar2
   ) is
   /******************************************************************************
    PROCEDURE:   INIZIALIZZA_PARAMETRI
    DESCRIZIONE: Legge dai registri le preferenze di visualizzazione dell'albero
                 per il modulo e per l'albero indicati
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  03/12/2004 SN     Prima emissione.
   ******************************************************************************/
      D_CHIAVE               STRINGA_GRANDE
         :=    'PRODUCTS/'
            || UPPER (P_MODULO)
            || '/AFC_HTML.TREE/'
            || UPPER (P_ALBERO);
      D_CHIAVE_DEFINIZIONE   STRINGA_GRANDE := D_CHIAVE || '/DEFINIZIONE';
   BEGIN
      -- parametrizzabili dall'utente
      D_VISUALIZZA_FOGLIE :=
          NVL (LEGGI_REGISTRO (D_CHIAVE, 'Visualizzazione dati foglia'), 'N');
      D_SOLO_UN_FOLDER_APERTO :=
                NVL (LEGGI_REGISTRO (D_CHIAVE, 'Un solo folder aperto'), 'S');
      D_INSERIRE_POSIZIONAMENTO :=
                     NVL (LEGGI_REGISTRO (D_CHIAVE, 'Riposizionamento'), 'N');
      D_DIRECTORY :=
         NVL (LEGGI_REGISTRO (D_CHIAVE, 'Path_immagini'),
              '../common/images/AMV/'
             );
      -- impostazioni albero
      D_COLONNA :=
           NVL (LEGGI_REGISTRO (D_CHIAVE_DEFINIZIONE, 'Colonna Figlio'), 'id');
      D_COLONNA_NOME :=
           NVL (LEGGI_REGISTRO (D_CHIAVE_DEFINIZIONE, 'Colonna Nome'), 'nome');
      D_COLONNA_ORDINAMENTO :=
         NVL (LEGGI_REGISTRO (D_CHIAVE_DEFINIZIONE, 'Colonna Ordinamento'),
              'nome'
             );
      D_COLONNA_PADRE :=
         NVL (LEGGI_REGISTRO (D_CHIAVE_DEFINIZIONE, 'Colonna Padre'),
              'padre_id'
             );
      D_FUNCTION_TABELLA :=
                NVL (LEGGI_REGISTRO (D_CHIAVE_DEFINIZIONE, 'Dati foglia'), '');
      D_INCLUSIONE :=
                NVL (LEGGI_REGISTRO (D_CHIAVE_DEFINIZIONE, 'Inclusione'), 'N');
      D_PAGINA :=
         NVL (LEGGI_REGISTRO (D_CHIAVE_DEFINIZIONE, 'Pagina href'), 'Main.do');
      D_PARAMETRO_INCLUSIONE :=
         NVL (LEGGI_REGISTRO (D_CHIAVE_DEFINIZIONE, 'Parametro Inclusione'),
              'MVPG'
             );
      D_PARAMETRO_URL :=
            NVL (LEGGI_REGISTRO (D_CHIAVE_DEFINIZIONE, 'Parametro url'), 'ST')
         || '=';
      D_SEPARATORE :=
                NVL (LEGGI_REGISTRO (D_CHIAVE_DEFINIZIONE, 'Separatore'), '|');
      D_TABELLA :=
             NVL (LEGGI_REGISTRO (D_CHIAVE_DEFINIZIONE, 'Tabella'), 'tabella');
      IMPOSTA_DA_REGISTRO (D_COLONNA_IMMAGINE,
                           D_CHIAVE_DEFINIZIONE,
                           'Colonna con nome immagine',
                           NULL
                          );
      IMPOSTA_DA_REGISTRO (D_COLONNA_IMMAGINE_OPEN,
                           D_CHIAVE_DEFINIZIONE,
                           'Colonna con nome immagine folder aperto',
                           NULL
                          );
      IMPOSTA_DA_REGISTRO (D_COLONNA_LINK,
                           D_CHIAVE_DEFINIZIONE,
                           'Colonna con link',
                           NULL
                          );
      IMPOSTA_DA_REGISTRO (D_FLD_CLOSE,
                           D_CHIAVE_DEFINIZIONE,
                           'fld_close',
                           'cmsfolderclosed.gif'
                          );
      IMPOSTA_DA_REGISTRO (D_FLD_OPEN,
                           D_CHIAVE_DEFINIZIONE,
                           'fld_open',
                           'cmsfolderopen.gif'
                          );
      IMPOSTA_DA_REGISTRO (D_LAST_FLD_OPEN,
                           D_CHIAVE_DEFINIZIONE,
                           'last_fld_open',
                           'cmslastfolderopen.gif'
                          );
      IMPOSTA_DA_REGISTRO (D_PLUS_NODE,
                           D_CHIAVE_DEFINIZIONE,
                           'plus_node',
                           'cmspnode.gif'
                          );
      IMPOSTA_DA_REGISTRO (D_LAST_PLUS_NODE,
                           D_CHIAVE_DEFINIZIONE,
                           'last_plus_node',
                           'cmsplastnode.gif'
                          );
      IMPOSTA_DA_REGISTRO (D_MINUS_NODE,
                           D_CHIAVE_DEFINIZIONE,
                           'minus_node',
                           'cmsmnode.gif'
                          );
      IMPOSTA_DA_REGISTRO (D_LAST_MINUS_NODE,
                           D_CHIAVE_DEFINIZIONE,
                           'last_minus_node',
                           'cmsmlastnode.gif'
                          );
      IMPOSTA_DA_REGISTRO (D_IMG_LINE,
                           D_CHIAVE_DEFINIZIONE,
                           'img_line',
                           'cmsvertline.gif'
                          );
      IMPOSTA_DA_REGISTRO (D_BLANK,
                           D_CHIAVE_DEFINIZIONE,
                           'blank',
                           'cmsblank.gif'
                          );
      IMPOSTA_DA_REGISTRO (D_FOGLIA,
                           D_CHIAVE_DEFINIZIONE,
                           'Immagine Foglia',
                           'cmsdoc.gif'
                          );
      IMPOSTA_DA_REGISTRO (D_SOLO_UNA_FOGLIA_APERTA,
                           D_CHIAVE_DEFINIZIONE,
                           'Solo una foglia aperta',
                           'S'
                          );
      IMPOSTA_DA_REGISTRO (D_MOSTRA_TUTTE_FOGLIE,
                           D_CHIAVE_DEFINIZIONE,
                           'Mostra tutte le foglie',
                           'N'
                          );
      IMPOSTA_DA_REGISTRO (D_WHERE,
                           D_CHIAVE_DEFINIZIONE,
                           'Condizioni sui record',
                           ''
                          );
   END;
   function CHIUDI_TABELLA
   return clob is
   /******************************************************************************
    FUNCTION:    CHIUDI_TABELLA
    DESCRIZIONE: Restituisce il codice html di visualizzazione dei dati
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  03/12/2004 SN     Prima emissione.
   ******************************************************************************/
   BEGIN
      DBMS_LOB.WRITEAPPEND (D_TABELLA_CLOB, LENGTH ('</table>'), '</table>');
      IF D_TROVATO_TABELLA = 1
      THEN
         RETURN D_TABELLA_CLOB;
      ELSE
         RETURN NULL;
      END IF;
   END;
   procedure APRI_CURSORE
   ( P_NOME_CURSORE varchar2
   , P_ID varchar2
   ) is
   /******************************************************************************
    PROCEDURE:   APRI_CURSORE
    DESCRIZIONE: Esegue open del cursore indicato come fonte dei dati foglia
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  03/12/2004 SN     Prima emissione.
   ******************************************************************************/
   BEGIN
      Si4.SQL_Execute (   'begin open '
                       || P_NOME_CURSORE
                       || '('''
                       || P_ID
                       || '''); end;'
                      );
   END;
   procedure LEGGI_FOGLIA
   ( P_NOME_CURSORE varchar2
   ) is
   /******************************************************************************
    PROCEDURE:   LEGGI_FOGLIA
    DESCRIZIONE: Fa la fetch dal cursore che fornisce le informazioni delle foglie
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  03/12/2004 SN     Prima emissione.
   ******************************************************************************/
   BEGIN
      Si4.SQL_Execute (   'begin fetch '
                       || P_NOME_CURSORE
                       || ' into afc_html.stringa;'
                       || ' if '
                       || P_NOME_CURSORE
                       || '%FOUND then afc_html.trovato := 1;'
                       || ' else afc_html.trovato := 0; end if; end;'
                      );
   END;
   procedure CHIUDI_CURSORE
   ( P_NOME_CURSORE varchar2
   ) is
   /******************************************************************************
    PROCEDURE:   CHIUDI_CURSORE
    DESCRIZIONE: Chiude il cursore che fornisce le informazioni delle foglie
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  03/12/2004 SN     Prima emissione.
   ******************************************************************************/
   BEGIN
      si4.SQL_Execute ('begin close ' || P_NOME_CURSORE || '; end;');
   END;
   procedure EVIDENZIA
   ( P_CAMPO IN OUT varchar2
   , P_STRINGA_RICERCA varchar2
   ) is
   /******************************************************************************
    PROCEDURE:   EVIDENZIA
    DESCRIZIONE: Mette lo sfondo di colore diverso (giallo) per la stringa
                 ricercata all'interno del campo indicato.
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  03/12/2004 SN     Prima emissione.
   ******************************************************************************/
   BEGIN
      P_CAMPO :=
            SUBSTR (P_CAMPO,
                    1,
                    INSTR (UPPER (P_CAMPO), UPPER (P_STRINGA_RICERCA)) - 1
                   )
         || '<span style="background-color: #FFFF00">'
         || SUBSTR (P_CAMPO,
                    INSTR (UPPER (P_CAMPO), UPPER (P_STRINGA_RICERCA)),
                    LENGTH (P_STRINGA_RICERCA)
                   )
         || '</span>'
         || SUBSTR (P_CAMPO,
                      INSTR (UPPER (P_CAMPO), UPPER (P_STRINGA_RICERCA))
                    + LENGTH (P_STRINGA_RICERCA)
                   );
   END EVIDENZIA;
   function SCRIVI_FOGLIE
   (  P_ID                   VARCHAR2,
      P_LIVELLO              NUMBER,
      P_FRATELLI             NUMBER,
      P_NUMERO_FIGLI_PADRE   NUMBER,
      P_NOME_CURSORE         VARCHAR2,
      P_STRINGA_RICERCA      VARCHAR2
   ) return clob is
   /******************************************************************************
    PROCEDURE:   SCRIVI_FOGLIE
    DESCRIZIONE: Predispone codice html per scrivere le foglie
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  03/12/2004 SN     Prima emissione.
   ******************************************************************************/
      D_CLOB   CLOB;
   BEGIN
      INIZIA_TABELLA (P_LIVELLO, P_FRATELLI, P_NUMERO_FIGLI_PADRE);
      APRI_CURSORE (P_NOME_CURSORE, P_ID);
      TROVATO := 1;
      WHILE TROVATO = 1
      LOOP
         LEGGI_FOGLIA (P_NOME_CURSORE);
         IF TROVATO = 1
         THEN
            INIZIA_RIGA;
            IF     P_STRINGA_RICERCA IS NOT NULL
               AND INSTR (UPPER (STRINGA), UPPER (P_STRINGA_RICERCA)) > 0
            THEN
               EVIDENZIA (STRINGA, P_STRINGA_RICERCA);
            END IF;
            SCRIVI_COLONNA (STRINGA);
            CHIUDI_RIGA;
         END IF;
      END LOOP;
      CHIUDI_CURSORE (P_NOME_CURSORE);
      D_CLOB := CHIUDI_TABELLA;
      RETURN D_CLOB;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_LOB.WRITEAPPEND (D_CLOB, LENGTH (SQLERRM), SQLERRM);
         si4.SQL_Execute (   'begin if '
                          || P_NOME_CURSORE
                          || '%ISOPEN THEN close '
                          || P_NOME_CURSORE
                          || '; END IF; end;'
                         );
   END;
   procedure DISEGNA_ALBERO
   (  P_ID_STRUTTURA                           VARCHAR2,
      P_LIVELLO                                NUMBER,
      P_PATH                                   VARCHAR2,
      P_PAGE                                   VARCHAR2,
      P_IMMAGINI_LIVELLI_PRECEDENTI            VARCHAR2,
      P_CLOB                          IN OUT   CLOB,
      P_RICERCA                                VARCHAR2 DEFAULT NULL
   ) is
   /******************************************************************************
    PROCEDURE:   DISEGNA_ALBERO
    DESCRIZIONE: Ricorsivamente disegna l'albero aggiungendo i tag html necessari
                 per la visualizzazione.
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  03/12/2004 SN     Prima emissione.
   014  06/02/2006 SN     Aggiunta possibilit� di indicare che non si vuole il link
                           per certi nodi, occorre passare il valore 'NULLO' nella
                      colonna link
    016  14/02/2006 SN     Migliorie di performance, tolte order by e controllo solo
                           su esistenza di un figlio senza fare count dove non serve.
   ******************************************************************************/
      D_POS                           INTEGER         := 0;
      D_NUMERO_FIGLI_RIMANENTI        NUMBER          := 0;
      D_NUMERO_FIGLI                  NUMBER          := 0;
      D_ROW                           STRINGA_GRANDE;
      D_LEN                           NUMBER;
      D_SOTTOALBERO_CLOB              CLOB;
      D_FOGLIE_CLOB                   CLOB;
      D_STRUTTURA                     T_REF;
      D_CONTA                         T_REF;
      D_FIGLIO_ID                     STRINGA_PICCOLA;
      D_PADRE_ID                      STRINGA_PICCOLA;
      D_DENOMINAZIONE                 STRINGA_GRANDE;
      D_IMMAGINE                      STRINGA_PICCOLA;
      D_IMMAGINE_OPEN                 STRINGA_PICCOLA;
      D_LINK                          STRINGA_PICCOLA;
      D_N_FIGLI                       NUMBER          := 0;
      D_IMMAGINI_LIVELLI_PRECEDENTI   STRINGA_GRANDE  := NULL;
      D_IMMAGINE_ATTUALE              STRINGA_GRANDE  := NULL;
   BEGIN
      D_IMMAGINI_LIVELLI_PRECEDENTI := P_IMMAGINI_LIVELLI_PRECEDENTI;
      IF D_INCLUSIONE = 'S'
      THEN
         IF INSTR (D_PAGINA, '?') > 0
         THEN
            D_PAGINA_URL :=
                  RTRIM (D_PAGINA, '&')
               || '&'
               || D_PARAMETRO_INCLUSIONE
               || '='
               || P_PAGE
               || '&';
         ELSE
            D_PAGINA_URL :=
               D_PAGINA || '?' || D_PARAMETRO_INCLUSIONE || '=' || P_PAGE
               || '&';
         END IF;
      ELSE
         IF INSTR (P_PAGE, '?') > 0
         THEN
            D_PAGINA_URL := RTRIM (P_PAGE, '&') || '&';
         ELSE
            D_PAGINA_URL := P_PAGE || '?';
         END IF;
      END IF;
      DBMS_LOB.CREATETEMPORARY (D_SOTTOALBERO_CLOB, TRUE, DBMS_LOB.SESSION);
      OPEN D_CONTA FOR    'select  nvl(count('
                       || D_COLONNA
                       || '),0) '
                       || ' from '
                       || D_TABELLA
                       || ' where '
                       || D_COLONNA_PADRE
                       || ' = '''
                       || P_ID_STRUTTURA
                       || ''''
                       || ' and '
                       || D_COLONNA_PADRE
                       || ' <> '
                       || D_COLONNA
                       || D_WHERE
                       ;
      FETCH D_CONTA
       INTO D_NUMERO_FIGLI_RIMANENTI;
      CLOSE D_CONTA;
      OPEN D_STRUTTURA FOR    'select '
                           || D_COLONNA
                           || ' figlio_id, '
                           || D_COLONNA_PADRE
                           || ' padre_id, '
                           || D_COLONNA_NOME
                           || ' denominazione ,'
                           || NVL (D_COLONNA_IMMAGINE, ' null ')
                           || ' immagine, '
                           || NVL (D_COLONNA_IMMAGINE_OPEN, ' null ')
                           || ' immagine_open ,'
                           || NVL (D_COLONNA_LINK, ' null ')
                           || ' collegamento '
                           || ' from '
                           || D_TABELLA
                           || ' where '
                           || D_COLONNA_PADRE
                           || ' = '''
                           || P_ID_STRUTTURA
                           || ''''
                           || ' and '
                           || D_COLONNA_PADRE
                           || ' <> '
                           || D_COLONNA
                           || D_WHERE
                           || ' order by '
                           || D_COLONNA_ORDINAMENTO;
      LOOP
         FETCH D_STRUTTURA
          INTO D_FIGLIO_ID, D_PADRE_ID, D_DENOMINAZIONE, D_IMMAGINE,
               D_IMMAGINE_OPEN, D_LINK;
         EXIT WHEN D_STRUTTURA%NOTFOUND;
         D_POS := INSTR (P_PATH, D_SEPARATORE || D_FIGLIO_ID || D_SEPARATORE);
         IF     P_RICERCA IS NOT NULL
            AND INSTR (UPPER (D_DENOMINAZIONE), UPPER (P_RICERCA)) > 0
         THEN
            EVIDENZIA (D_DENOMINAZIONE, P_RICERCA);
         END IF;
         IF D_IMMAGINE IS NOT NULL
         THEN
            D_IMMAGINE := D_INIZIO_IMMAGINE || D_IMMAGINE || D_FINE_IMMAGINE;
         END IF;
         IF D_IMMAGINE_OPEN IS NOT NULL
         THEN
            D_IMMAGINE_OPEN :=
                      D_INIZIO_IMMAGINE || D_IMMAGINE_OPEN || D_FINE_IMMAGINE;
         END IF;
         OPEN D_CONTA FOR    'select  nvl(count('
                          || D_COLONNA
                          || '),0) '
                          || ' from '
                          || D_TABELLA
                          || ' where '
                          || D_COLONNA_PADRE
                          || ' = '''
                          || D_FIGLIO_ID
                          || ''''
                          || ' and '
                          || D_COLONNA_PADRE
                          || ' <> '
                          || D_COLONNA
                          || D_WHERE
                          ;
         FETCH D_CONTA
          INTO D_NUMERO_FIGLI;
         CLOSE D_CONTA;
         IF D_NUMERO_FIGLI_RIMANENTI < 2
         THEN
            D_IMMAGINE_ATTUALE := D_BLANK;
            D_IMG_NODE := D_LAST_PLUS_NODE;
            D_IMG_NODE_OPEN := D_LAST_MINUS_NODE;
         ELSE
            D_IMMAGINE_ATTUALE := D_IMG_LINE;
            D_IMG_NODE := D_PLUS_NODE;
            D_IMG_NODE_OPEN := D_MINUS_NODE;
         END IF;
         -- per cartella senza sottocartelle img cartella terminale
         IF (D_NUMERO_FIGLI = 0)
         THEN
            IF D_SOLO_UNA_FOGLIA_APERTA = 'S'
            THEN
               IF D_FIGLIO_ID =
                     D_ULTIMO
                             -- controllare se solouna foglia aperta concessa
               THEN
                  D_IMG_OPEN :=
                            NVL (NVL (D_IMMAGINE_OPEN, D_IMMAGINE), D_FOGLIA);
                  D_IMG := NVL (NVL (D_IMMAGINE_OPEN, D_IMMAGINE), D_FOGLIA);
               ELSE
                  D_IMG_OPEN := NVL (D_IMMAGINE, D_FOGLIA);
                  D_IMG := NVL (D_IMMAGINE, D_FOGLIA);
               END IF;
            ELSE
               -- piu foglie apribili contemporaneamente
               D_IMG_OPEN :=
                            NVL (NVL (D_IMMAGINE_OPEN, D_IMMAGINE), D_FOGLIA);
               D_IMG := NVL (D_IMMAGINE, D_FOGLIA);
            END IF;
            IF D_NUMERO_FIGLI_RIMANENTI < 2
            THEN
               D_IMG_NODE := D_LAST_LINE_FOGLIA;
            ELSE
               D_IMG_NODE := D_LINE_FOGLIA;
            END IF;
         ELSE
            D_IMG_OPEN := NVL (NVL (D_IMMAGINE_OPEN, D_IMMAGINE), D_FLD_OPEN);
            D_IMG := NVL (D_IMMAGINE, D_FLD_CLOSE);
         END IF;
         IF D_INSERIRE_POSIZIONAMENTO = 'S'
         THEN
            D_POSIZIONAMENTO := '#' || D_FIGLIO_ID;
         ELSE
            D_POSIZIONAMENTO := NULL;
         END IF;
         -- link dipende dal numero di rami contemporanei aperti che voglio
         IF D_SOLO_UN_FOLDER_APERTO = 'S'
         THEN
            D_PARAMETRO_HREF_FIGLIO := D_FIGLIO_ID;
            D_PARAMETRO_HREF_PADRE := D_PADRE_ID;
         ELSE
            D_PARAMETRO_HREF_FIGLIO :=
                  LTRIM (P_PATH, D_SEPARATORE || '0' || D_SEPARATORE)
               || D_FIGLIO_ID;
            D_PARAMETRO_HREF_PADRE :=
                  LTRIM (P_PATH, D_SEPARATORE || '0' || D_SEPARATORE)
               || D_FIGLIO_ID;
         END IF;
         IF D_POS > 0
         THEN
            -- la sezione e un padre
            -- prepara disegno del figlio
            -- per ultimo record img nodo terminale
            -- per cartella senza sottocartelle img cartella terminale
            IF (D_NUMERO_FIGLI != 0)
            THEN
               IF D_NUMERO_FIGLI_RIMANENTI < 2
               THEN
                  D_IMMAGINE_ATTUALE := D_BLANK;
                  D_IMG_NODE := D_LAST_PLUS_NODE;
                  D_IMG_NODE_OPEN := D_LAST_MINUS_NODE;
               ELSE
                  D_IMMAGINE_ATTUALE := D_IMG_LINE;
                  D_IMG_NODE := D_PLUS_NODE;
                  D_IMG_NODE_OPEN := D_MINUS_NODE;
               END IF;
            ELSE
               -- non ci sono figli
               D_IMG_NODE := '';
               IF D_NUMERO_FIGLI_RIMANENTI < 2
               THEN
                  D_IMG_NODE_OPEN := D_LAST_LINE_FOGLIA;
               ELSE
                  D_IMG_NODE_OPEN := D_LINE_FOGLIA;
               END IF;
               D_IMMAGINE_ATTUALE := D_BLANK;
            END IF;
            IF nvl(d_link,' ') != 'NULLO'
            THEN
               -- non ho indicato la colonna oppure ho un link
               D_ROW :=
                     '<a href="'
                  || D_PAGINA_URL
                  || D_PARAMETRO_URL
                  || D_PARAMETRO_HREF_PADRE
                  || '">'
                  || D_IMG_NODE_OPEN
                  || '</a>'
                  || D_IMG_OPEN
                  || '&'||'nbsp;'
                  || '<a href="';
               IF D_LINK IS NULL
               THEN
                  D_ROW :=
                        D_ROW
                     || D_PAGINA_URL
                     || D_PARAMETRO_URL
                     || D_PARAMETRO_HREF_FIGLIO
                     || '&'||'ID='
                     || D_FIGLIO_ID
                     || D_POSIZIONAMENTO;
               ELSE
                  -- d_link specificato
                  D_ROW := D_ROW || D_LINK || D_POSIZIONAMENTO;
               END IF;
               D_ROW := D_ROW || '">' || D_DENOMINAZIONE || '</a>';
            ELSIF nvl(d_link,' ' )  = 'NULLO'
            THEN
               D_ROW :=
                     '<a href="'
                     || D_PAGINA_URL
                     || D_PARAMETRO_URL
                     || D_PARAMETRO_HREF_PADRE
                     || D_POSIZIONAMENTO
                     || '">'
                     || D_IMG_NODE_OPEN
                     || '</a>'
                     || D_IMG_OPEN
                     || '&'||'nbsp;'
                     || '<a name="'
                     || D_FIGLIO_ID
                     || '"></a>'
                     ;
              D_ROW := D_ROW ||  D_DENOMINAZIONE ;
            END IF;
            -- visualizzazione dipendenti della struttura
            IF     D_FUNCTION_TABELLA IS NOT NULL
               AND D_VISUALIZZA_FOGLIE = 'S'
               AND (   INSTR (P_PATH, '|' || D_FIGLIO_ID || '|') > 0
                    OR D_MOSTRA_TUTTE_FOGLIE = 'S'
                   )                                        -- da visualizzare
            THEN
               D_FOGLIE_CLOB :=
                  SCRIVI_FOGLIE (D_FIGLIO_ID,
                                 P_LIVELLO,
                                 D_NUMERO_FIGLI_RIMANENTI,
                                 D_NUMERO_FIGLI,
                                 D_FUNCTION_TABELLA,
                                 P_RICERCA
                                );
            END IF;
            --disegno sottoalbero solo se ho figli
            OPEN D_CONTA FOR 'select  1 from dual where exists ( select 1 from '
                             || D_TABELLA
                             || ' where '
                             || D_COLONNA_PADRE
                             || ' = '''
                             || D_FIGLIO_ID
                             || ''''
                             || ' and '
                             || D_COLONNA_PADRE
                             || ' <> '
                             || D_COLONNA
                             || D_WHERE
                             || ')';
            FETCH D_CONTA
             INTO D_N_FIGLI;
            if d_conta%NOTFOUND then
               d_n_figli := 0;
            end if;
            CLOSE D_CONTA;
            IF D_N_FIGLI != 0
            THEN
               D_LEN := DBMS_LOB.GETLENGTH (D_SOTTOALBERO_CLOB);
               IF D_LEN > 0
               THEN
                  DBMS_LOB.TRIM (D_SOTTOALBERO_CLOB, 0);
               END IF;
               DISEGNA_ALBERO (D_FIGLIO_ID,
                               P_LIVELLO + 1,
                               P_PATH,
                               P_PAGE,
                                  D_IMMAGINI_LIVELLI_PRECEDENTI
                               || D_IMMAGINE_ATTUALE,
                               D_SOTTOALBERO_CLOB,
                               P_RICERCA
                              );
            END IF;
            IF P_LIVELLO != 1
            THEN
               D_ROW := D_IMMAGINI_LIVELLI_PRECEDENTI || D_ROW;
            END IF;
         ELSE
            -- non e padre
            IF  NVL(D_LINK,' ') != 'NULLO'
         THEN
              -- non ho indicato la colonna oppure ho un link
               D_ROW :=
                     '<a href="'
                  || D_PAGINA_URL
                  || D_PARAMETRO_URL
                  || D_PARAMETRO_HREF_FIGLIO
                  || '&'||'ID=0'
                  || D_POSIZIONAMENTO
                  || '">'
                  || D_IMG_NODE
                  || '</a>'
                  || D_IMG
                  || '&'||'nbsp;'
                  || '<a href="';
               IF D_LINK IS NULL
               THEN
                  D_ROW :=
                        D_ROW
                     || D_PAGINA_URL
                     || D_PARAMETRO_URL
                     || D_PARAMETRO_HREF_FIGLIO
                     || '&'||'ID='
                     || D_FIGLIO_ID
                     || D_POSIZIONAMENTO;
               ELSE
                  -- select fornisce anche il link
                  D_ROW := D_ROW || D_LINK;
               END IF;
               D_ROW := D_ROW || '">' || D_DENOMINAZIONE || '</a>'
               || '<a name="'
               || D_FIGLIO_ID
               || '"></a>';
            ELSIF NVL(D_LINK,' ')  = 'NULLO'
         THEN
               D_ROW :=
                      '<a href="'
                   || D_PAGINA_URL
                   || D_PARAMETRO_URL
                   || D_PARAMETRO_HREF_PADRE
                   || D_POSIZIONAMENTO
                   || '">'
                   || D_IMG_NODE
                   || '</a>'
                   || D_IMG
                   || '&'||'nbsp;';
             D_ROW := D_ROW ||  D_DENOMINAZIONE
                  || '<a name="'
                  || D_FIGLIO_ID
                  || '"></a>';
            END IF;
            IF (D_NUMERO_FIGLI = 0)
            THEN
               -- visualizzazione dipendenti della struttura
               IF     D_FUNCTION_TABELLA IS NOT NULL
                  AND D_VISUALIZZA_FOGLIE = 'S'
                  AND (   INSTR (P_PATH, '|' || D_FIGLIO_ID || '|') > 0
                       OR D_MOSTRA_TUTTE_FOGLIE = 'S'
                      )
               THEN
                  D_FOGLIE_CLOB :=
                     SCRIVI_FOGLIE (D_FIGLIO_ID,
                                    P_LIVELLO,
                                    D_NUMERO_FIGLI_RIMANENTI,
                                    D_NUMERO_FIGLI,
                                    D_FUNCTION_TABELLA,
                                    P_RICERCA
                                   );
               END IF;
            END IF;
            IF P_LIVELLO != 1
            THEN
               D_ROW := D_IMMAGINI_LIVELLI_PRECEDENTI || D_ROW;
            END IF;
         END IF;
         D_ROW := D_ROW || '<br>';
         D_LEN := LENGTH (D_ROW);
         DBMS_LOB.WRITEAPPEND (P_CLOB, D_LEN, D_ROW);
         IF DBMS_LOB.GETLENGTH (D_FOGLIE_CLOB) > 0
         THEN
            DBMS_LOB.APPEND (P_CLOB, D_FOGLIE_CLOB);
         END IF;
         IF D_POS > 0
         THEN
            IF D_N_FIGLI != 0
            THEN
               DBMS_LOB.APPEND (P_CLOB, D_SOTTOALBERO_CLOB);
            END IF;
            D_LEN := DBMS_LOB.GETLENGTH (D_SOTTOALBERO_CLOB);
            IF D_LEN > 0
            THEN
               DBMS_LOB.TRIM (D_SOTTOALBERO_CLOB, 0);
            END IF;
         END IF;
         D_LEN := DBMS_LOB.GETLENGTH (D_FOGLIE_CLOB);
         IF D_LEN > 0
         THEN
            DBMS_LOB.TRIM (D_FOGLIE_CLOB, 0);
         END IF;
         D_ROW := NULL;
         D_NUMERO_FIGLI_RIMANENTI := D_NUMERO_FIGLI_RIMANENTI - 1;
      END LOOP;
      CLOSE D_STRUTTURA;
   EXCEPTION
      WHEN OTHERS
      THEN
         IF D_STRUTTURA%ISOPEN
         THEN
            CLOSE D_STRUTTURA;
         END IF;
         RAISE;
   END DISEGNA_ALBERO;
   function GET_PATH_STRUTTURA
   (  P_ID_STRUTTURA   VARCHAR2,
      P_PATH           VARCHAR2 DEFAULT NULL
   ) return varchar2 is
   /******************************************************************************
    FUNCTION:    GET_PATH_STRUTTURA
    DESCRIZIONE: Se solo una foglia aperta cerca la strada da seguire per arrivare
                 all'id cercato in modo da visualizzare anche i padri aperti.
                 Ricorsivamente quindi percorre la strada e riempie la variabile
                 d_path usata poi per disegnare l'albero.
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  03/12/2004 SN     Prima emissione.
   ******************************************************************************/
      D_PATH        STRINGA_GRANDE;
      D_PADRE       STRINGA_GRANDE;
      D_STRUTTURA   T_REF;
   BEGIN
      OPEN D_STRUTTURA FOR    'select '
                           || D_COLONNA_PADRE
                           || ' from '
                           || D_TABELLA
                           || ' where '
                           || D_COLONNA
                           || ' = '''
                           || P_ID_STRUTTURA
                           || ''' and '
                           || D_COLONNA_PADRE
                           || ' <> '
                           || D_COLONNA
                           || D_WHERE;
      FETCH D_STRUTTURA
       INTO D_PADRE;
      IF D_STRUTTURA%NOTFOUND
      THEN
         IF P_ID_STRUTTURA IS NOT NULL AND P_ID_STRUTTURA != '0'
         THEN
            D_PATH := P_ID_STRUTTURA || D_SEPARATORE;
         ELSE
            D_PATH := D_SEPARATORE || '0' || D_SEPARATORE;
         END IF;
      ELSE                                                          -- trovato
         D_PATH :=
               GET_PATH_STRUTTURA (D_PADRE, P_PATH)
            || P_ID_STRUTTURA
            || D_SEPARATORE;
      END IF;
      CLOSE D_STRUTTURA;
      RETURN D_PATH;
   END GET_PATH_STRUTTURA;
   function TROVA_TUTTI
   ( P_RICERCA varchar2
   ) return varchar2 is
   /******************************************************************************
    FUNCTION:    TROVA_TUTTI
    DESCRIZIONE: Se si sta facendo una ricerca mette nella variabile d_path l'elenco
                 dei nodi che devono essere aperti, quelli cioe in cui la ricerca
                 viene soddisfatta. La variabile d_path verra poi utilizzata per
                 disegnare l'albero.
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  03/12/2004 SN     Prima emissione.
    013  31/01/2006 SN     Errore in caso di uso where condition
   ******************************************************************************/
      D_ELENCO        T_REF;
      D_ID            STRINGA_GRANDE;
      D_DESCRIZIONE   STRINGA_GRANDE;
      D_TUTTI         STRINGA_GRANDE;
   --   d_inserito    VARCHAR2(1);
   BEGIN
      OPEN D_ELENCO FOR    'select '
                        || D_COLONNA
                        || ' figlio_id,'
                        || D_COLONNA_NOME
                        || ' descrizione'
                        || ' from '
                        || D_TABELLA
                        || ' where 1 = 1 '
                        || D_WHERE;
      LOOP
         FETCH D_ELENCO
          INTO D_ID, D_DESCRIZIONE;
         IF INSTR (UPPER (D_DESCRIZIONE), UPPER (P_RICERCA)) > 0
         THEN
            D_TUTTI := D_TUTTI || GET_PATH_STRUTTURA (D_ID);
         END IF;
         IF     D_FUNCTION_TABELLA IS NOT NULL
            AND D_VISUALIZZA_FOGLIE = 'S'
            AND NVL (INSTR (D_TUTTI, '|' || D_ID || '|'), 0) = 0
         THEN
            APRI_CURSORE (D_FUNCTION_TABELLA, D_ID);
            TROVATO := 1;
            WHILE TROVATO = 1
             AND NOT (NVL (INSTR (D_TUTTI, '|' || D_ID || '|'), 0) > 0)
            LOOP
               LEGGI_FOGLIA (D_FUNCTION_TABELLA);
               IF TROVATO = 1
               THEN
                  IF NVL (INSTR (UPPER (STRINGA), UPPER (P_RICERCA)), 0) > 0
                  THEN
                     D_TUTTI := D_TUTTI || GET_PATH_STRUTTURA (D_ID);
                  END IF;
               END IF;
            -- EXIT WHEN NVL(INSTR(d_tutti, '|' || d_id || '|'), 0) > 0;
            END LOOP;
            CHIUDI_CURSORE (D_FUNCTION_TABELLA);
         END IF;
         EXIT WHEN D_ELENCO%NOTFOUND;
      END LOOP;
      RETURN D_TUTTI;
   END;
   function CREA_TREE
   (  PP_STRUTTURA_ID   VARCHAR2,
      P_MODULO          VARCHAR2,
      P_ALBERO          VARCHAR2,
      P_PAGE            VARCHAR2,
      P_INIZIALIZZA     VARCHAR2,
      P_RICERCA         VARCHAR2 DEFAULT NULL
   ) return clob is
   /******************************************************************************
    FUNCTION:    CREA_TREE
    DESCRIZIONE: Predispone i parametri e in base ai parametri decide come
                 riempire la variabile d_path usata per disegnare l'albero.
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  03/12/2004 SN     Prima emissione.
   ******************************************************************************/
      D_PATH                 STRINGA_GRANDE;
      D_ROW_START            STRINGA_GRANDE;
      D_ROW_END              STRINGA_GRANDE;
      D_PAGE                 STRINGA_PICCOLA;
      -- gestione tramite clob
      D_AMOUNT               BINARY_INTEGER  := 32767;
      D_CLOB                 CLOB            := EMPTY_CLOB ();
      D_CLOB1                CLOB            := EMPTY_CLOB ();
      D_LIVELLO              NUMBER          := 1;
      D_ID_STRUTTURA         VARCHAR2 (2000);
      D_NVL_P_STRUTTURA_ID   STRINGA_GRANDE  := NVL (PP_STRUTTURA_ID, 0);
      D_POS                  NUMBER          := 0;
      --      D_ULTIMO               stringa_grande;
      D_SENZA_ULTIMO         STRINGA_GRANDE;
      P_STRUTTURA_ID         STRINGA_GRANDE  := PP_STRUTTURA_ID;
   BEGIN
      IF NVL (P_INIZIALIZZA, 'NO') = 'SI'
      THEN
         INIZIALIZZA_PARAMETRI (P_MODULO, P_ALBERO);
      END IF;
      IF INSTR (P_PAGE, '/') = 1
      THEN
         D_PAGE := '..' || P_PAGE;
      ELSE
         D_PAGE := P_PAGE;
      END IF;
--     IF INSTR(d_page, '.') > 0 THEN
--       d_page := SUBSTR(d_page, 1, INSTR(d_page, '.') - 1);
--     END IF;
      -- inizializzazione CLOB
      DBMS_LOB.CREATETEMPORARY (D_CLOB, TRUE, DBMS_LOB.SESSION);
      DBMS_LOB.CREATETEMPORARY (D_CLOB1, TRUE, DBMS_LOB.SESSION);
      -- riga di intestazione albero
      D_ROW_START :=
         '<table width="100%" height="100%"><tr><td width="100%" valign="top" nowrap>';
      D_ROW_END := '</td></tr></table>';
      IF P_RICERCA IS NOT NULL
      THEN
         P_STRUTTURA_ID := TROVA_TUTTI (P_RICERCA);
      END IF;
      -- nodo corrente selezionato
      IF D_SOLO_UN_FOLDER_APERTO = 'S'
      THEN
         D_PATH := GET_PATH_STRUTTURA (D_NVL_P_STRUTTURA_ID);
      ELSE
         IF P_STRUTTURA_ID IS NOT NULL
         THEN
            D_PATH := '';
            D_POS := 1;
            D_ULTIMO :=
               SUBSTR (P_STRUTTURA_ID,
                       INSTR (P_STRUTTURA_ID, D_SEPARATORE, -1, 1) + 1
                      );
            D_SENZA_ULTIMO :=
               SUBSTR (P_STRUTTURA_ID,
                       1,
                       INSTR (P_STRUTTURA_ID, D_SEPARATORE, -1, 1) - 1
                      );
            IF INSTR (D_SEPARATORE || D_SENZA_ULTIMO || D_SEPARATORE,
                      D_SEPARATORE || D_ULTIMO || D_SEPARATORE
                     ) > 0
            THEN
               D_NVL_P_STRUTTURA_ID :=
                  REPLACE (D_SEPARATORE || D_SENZA_ULTIMO || D_SEPARATORE,
                           D_SEPARATORE || D_ULTIMO || D_SEPARATORE,
                           D_SEPARATORE
                          );
            END IF;
            D_PATH :=
                  D_SEPARATORE
               || '0'
               || D_SEPARATORE
               || RTRIM (SUBSTR (D_NVL_P_STRUTTURA_ID, D_POS), D_SEPARATORE)
               || D_SEPARATORE;
         ELSE
            D_PATH := D_SEPARATORE || '0' || D_SEPARATORE;
         END IF;
      END IF;
      D_LIVELLO := 1;
      D_ID_STRUTTURA :=
                     SUBSTR (D_PATH, 2, INSTR (D_PATH, D_SEPARATORE, 1, 2) - 2);
      -- albero per il nodo selezionato
      D_AMOUNT := LENGTH (D_ROW_START);
      DBMS_LOB.WRITEAPPEND (D_CLOB, D_AMOUNT, D_ROW_START);
      DISEGNA_ALBERO (D_ID_STRUTTURA,
                      D_LIVELLO,
                      D_PATH,
                      D_PAGE,
                      '',
                      D_CLOB1,
                      P_RICERCA
                     );
      DBMS_LOB.APPEND (D_CLOB, D_CLOB1);
      D_AMOUNT := LENGTH (D_ROW_END);
      DBMS_LOB.WRITEAPPEND (D_CLOB, D_AMOUNT, D_ROW_END);
      RETURN D_CLOB;
   END CREA_TREE;
   function TREE
   (  P_STRUTTURA_ID             VARCHAR2,
      P_MODULO                   VARCHAR2,
      P_ALBERO                   VARCHAR2,
      P_PAGE                     VARCHAR2,
      P_TABELLA                  VARCHAR2,
      P_COLONNA_PADRE            VARCHAR2,
      P_COLONNA                  VARCHAR2,
      P_COLONNA_NOME             VARCHAR2,
      P_EXPR_ORDINAMENTO         VARCHAR2,
      P_FUNC_FOGLIA              VARCHAR2 DEFAULT NULL,
      P_MOSTRA_FOGLIA            VARCHAR2 DEFAULT 'N',
      P_RIPOSIZIONA              VARCHAR2 DEFAULT 'N',
      P_UN_FOLDER_APERTO         VARCHAR2 DEFAULT 'S',
      P_INCLUSIONE               VARCHAR2 DEFAULT 'N',
      P_PAGINA_HREF              VARCHAR2 DEFAULT NULL,
      P_PARAMETRO_INCLUSIONE     VARCHAR2 DEFAULT NULL,
      P_PARAMETRO_URL            VARCHAR2 DEFAULT 'ST',
      P_SEPARATORE               VARCHAR2 DEFAULT '|',
      P_DISLOC_IMMAGINI          VARCHAR2 DEFAULT NULL,
      P_FLD_CLOSE                VARCHAR2 DEFAULT NULL,
      P_FLD_OPEN                 VARCHAR2 DEFAULT NULL,
      P_LAST_FLD_OPEN            VARCHAR2 DEFAULT NULL,
      P_PLUS_NODE                VARCHAR2 DEFAULT NULL,
      P_LAST_PLUS_NODE           VARCHAR2 DEFAULT NULL,
      P_MINUS_NODE               VARCHAR2 DEFAULT NULL,
      P_LAST_MINUS_NODE          VARCHAR2 DEFAULT NULL,
      P_IMG_LINE                 VARCHAR2 DEFAULT NULL,
      P_BLANK                    VARCHAR2 DEFAULT NULL,
      P_FOGLIA                   VARCHAR2 DEFAULT NULL,
      P_COLONNA_IMMAGINE         VARCHAR2 DEFAULT '',
      P_COLONNA_LINK             VARCHAR2 DEFAULT '',
      P_RICERCA                  VARCHAR2 DEFAULT NULL,
      P_COLONNA_IMMAGINE_OPEN    VARCHAR2 DEFAULT '',
      P_SOLO_UNA_FOGLIA_APERTA   VARCHAR2 DEFAULT 'S',
      P_MOSTRA_TUTTE_FOGLIE      VARCHAR2 DEFAULT 'S',
      P_WHERE                    VARCHAR2 DEFAULT ''
   ) return  clob is
   /******************************************************************************
    FUNCTION:    TREE
    DESCRIZIONE: Richiamata dall'esterno serve a fornire i parametri necessari per
                 l'albero.
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  03/12/2004 SN     Prima emissione.
   ******************************************************************************/
   BEGIN
      D_VISUALIZZA_FOGLIE := NVL (P_MOSTRA_FOGLIA, 'N');
      D_SOLO_UN_FOLDER_APERTO := NVL (P_UN_FOLDER_APERTO, 'S');
      D_INSERIRE_POSIZIONAMENTO := NVL (P_RIPOSIZIONA, 'N');
      D_DIRECTORY := NVL (P_DISLOC_IMMAGINI, '../common/images/AMV/');
      -- impostazioni albero
      D_TABELLA := NVL (P_TABELLA, 'tabella');
      D_COLONNA := NVL (P_COLONNA, 'id');
      D_COLONNA_NOME := NVL (P_COLONNA_NOME, 'nome');
      D_COLONNA_ORDINAMENTO := NVL (P_EXPR_ORDINAMENTO, 'nome');
      D_COLONNA_PADRE := NVL (P_COLONNA_PADRE, 'padre_id');
      D_COLONNA_IMMAGINE := P_COLONNA_IMMAGINE;
      D_COLONNA_IMMAGINE_OPEN := P_COLONNA_IMMAGINE_OPEN;
      D_COLONNA_LINK := P_COLONNA_LINK;
      D_FUNCTION_TABELLA := NVL (P_FUNC_FOGLIA, '');
      D_INCLUSIONE := NVL (P_INCLUSIONE, 'N');
      D_SOLO_UNA_FOGLIA_APERTA := NVL (P_SOLO_UNA_FOGLIA_APERTA, 'S');
      D_MOSTRA_TUTTE_FOGLIE := NVL (P_MOSTRA_TUTTE_FOGLIE, 'S');
      D_PAGINA := NVL (P_PAGINA_HREF, 'Main.do');
      D_PARAMETRO_INCLUSIONE := NVL (P_PARAMETRO_INCLUSIONE, 'MVPG');
      D_PARAMETRO_URL := NVL (P_PARAMETRO_URL, 'ST') || '=';
      D_SEPARATORE := NVL (P_SEPARATORE, '|');
      D_FLD_CLOSE :=
            D_INIZIO_IMMAGINE
         || D_DIRECTORY
         || NVL (P_FLD_CLOSE, 'cmsfolderclosed.gif')
         || D_FINE_IMMAGINE;
      D_FLD_OPEN :=
            D_INIZIO_IMMAGINE
         || D_DIRECTORY
         || NVL (P_FLD_OPEN, 'cmsfolderopen.gif')
         || D_FINE_IMMAGINE;
      D_LAST_FLD_OPEN :=
            D_INIZIO_IMMAGINE
         || D_DIRECTORY
         || NVL (P_LAST_FLD_OPEN, 'cmslastfolderopen.gif')
         || D_FINE_IMMAGINE;
      D_PLUS_NODE :=
            D_INIZIO_IMMAGINE
         || D_DIRECTORY
         || NVL (P_PLUS_NODE, 'cmspnode.gif')
         || D_FINE_IMMAGINE;
      D_LAST_PLUS_NODE :=
            D_INIZIO_IMMAGINE
         || D_DIRECTORY
         || NVL (P_LAST_PLUS_NODE, 'cmsplastnode.gif')
         || D_FINE_IMMAGINE;
      D_MINUS_NODE :=
            D_INIZIO_IMMAGINE
         || D_DIRECTORY
         || NVL (P_MINUS_NODE, 'cmsmnode.gif')
         || D_FINE_IMMAGINE;
      D_LAST_MINUS_NODE :=
            D_INIZIO_IMMAGINE
         || D_DIRECTORY
         || NVL (P_LAST_MINUS_NODE, 'cmsmlastnode.gif')
         || D_FINE_IMMAGINE;
      D_IMG_LINE :=
            D_INIZIO_IMMAGINE
         || D_DIRECTORY
         || NVL (P_IMG_LINE, 'cmsvertline.gif')
         || D_FINE_IMMAGINE;
      D_BLANK :=
            D_INIZIO_IMMAGINE
         || D_DIRECTORY
         || NVL (P_BLANK, 'cmsblank.gif')
         || D_FINE_IMMAGINE;
      D_FOGLIA :=
            D_INIZIO_IMMAGINE
         || D_DIRECTORY
         || NVL (P_FOGLIA, 'cmsdoc.gif')
         || D_FINE_IMMAGINE;
      IF P_WHERE IS NULL
      THEN
         D_WHERE := '';
      ELSE
         D_WHERE := ' and ' || P_WHERE;
      END IF;
      RETURN CREA_TREE (P_STRUTTURA_ID,
                        P_MODULO,
                        P_ALBERO,
                        P_PAGE,
                        'NO',
                        P_RICERCA
                       );
   END;
   function TREE
   (  P_STRUTTURA_ID   VARCHAR2,
      P_MODULO         VARCHAR2,
      P_ALBERO         VARCHAR2,
      P_PAGE           VARCHAR2
   ) return clob is
   /******************************************************************************
    FUNCTION:    TREE
    DESCRIZIONE: Richiamata dall'esterno ricava i parametri per l'albero dai registri.
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  03/12/2004 SN     Prima emissione.
   ******************************************************************************/
   BEGIN
      RETURN CREA_TREE (P_STRUTTURA_ID, P_MODULO, P_ALBERO, P_PAGE, 'SI');
   END;
   function TAB_FOLDER
   (  IN_LINK     IN   VARCHAR2,
      IN_HREF     IN   VARCHAR2,
      IN_ACTIVE   IN   VARCHAR2 DEFAULT 'N'
   ) return STRINGA_GRANDE is
   /******************************************************************************
    FUNCTION:    TAB_FOLDER
    DESCRIZIONE: Ritorna il codice html per rappresentare i tabfolder.
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  03/12/2004 SN     Prima emissione.
    014  13/12/2006 SB     Tolti gli spazi dentro i td nella determinazione di out_html.
   ******************************************************************************/
      CLASS_BEGIN   STRINGA_GRANDE;
      CLASS_BODY    STRINGA_GRANDE := 'AFCGuida';
      CLASS_END     STRINGA_GRANDE;
      CLASS_LINK    STRINGA_GRANDE;
      IMAGE         STRINGA_GRANDE := '../Themes/AFC/GuidaBlank.gif';
      OUT_HTML      STRINGA_GRANDE := NULL;
      D_TITOLO      STRINGA_GRANDE
                                 := SUBSTR (IN_LINK, INSTR (IN_LINK, ',') + 1);
      D_LINK        STRINGA_GRANDE := IN_LINK;
   BEGIN
      IF D_TITOLO != IN_LINK
      THEN
         D_LINK := SUBSTR (IN_LINK, 1, INSTR (IN_LINK, ',') - 1);
      END IF;
      D_TITOLO := ' title="' || D_TITOLO || '"';
      IF IN_ACTIVE = 'S'
      THEN
         CLASS_BODY := CLASS_BODY || 'Sel';
      END IF;
      CLASS_BEGIN := CLASS_BODY || 'L';
      CLASS_END := CLASS_BODY || 'R';
      CLASS_LINK := CLASS_BODY || 'Link';
      OUT_HTML :=
            OUT_HTML
         || ' <table cellpadding="0" cellspacing="0" border="0"><tr> '
         || ' <td align="left" valign="top" class="'
         || CLASS_BEGIN
         || '"><img src="'
         || IMAGE
         || '" ></td><td align="left" valign="center" nowrap class="'
         || CLASS_BODY
         || '"><a class="'
         || CLASS_LINK
         || '"'
         || D_TITOLO
         || ' href="'
         || IN_HREF
         || '">'
         || D_LINK
         || '</a></td><td align="left" valign="top" class="'
         || CLASS_END
         || '"><img src="'
         || IMAGE
         || '" ></td></tr></table>';
      RETURN OUT_HTML;
   END;
   function GUIDA_BAR
   (  IN_LINK            IN   VARCHAR2,
      IN_HREF            IN   VARCHAR2,
      IN_SEPARATORE_SN   IN   VARCHAR2 DEFAULT 'S',
      IN_CLASSE          IN   VARCHAR2 DEFAULT NULL
   ) return STRINGA_GRANDE is
   /******************************************************************************
    FUNCTION:    GUIDA_BAR
    DESCRIZIONE: Genera codice html per il menu.
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  03/12/2004 SN     Prima emissione.
   ******************************************************************************/
      OUT_HTML       STRINGA_GRANDE := NULL;
      D_SEPARATORE   STRINGA_GRANDE;
      D_TITOLO       STRINGA_GRANDE
                                 := SUBSTR (IN_LINK, INSTR (IN_LINK, ',') + 1);
      D_LINK         STRINGA_GRANDE := IN_LINK;
      D_CLASSE       STRINGA_GRANDE := IN_CLASSE;
   BEGIN
      IF     INSTR (IN_CLASSE, 'Link') != 0
         AND INSTR (IN_CLASSE, 'Link') + 4 != LENGTH (IN_CLASSE)
      THEN
         D_CLASSE := IN_CLASSE || 'Link';
      END IF;
      IF IN_SEPARATORE_SN = 'S'
      THEN
         D_SEPARATORE := '<td> &'||'nbsp;|&'||'nbsp; </td>';
      END IF;
      IF D_TITOLO != IN_LINK
      THEN
         D_LINK := SUBSTR (IN_LINK, 1, INSTR (IN_LINK, ',') - 1);
      END IF;
      D_TITOLO := ' title="' || D_TITOLO || '"';
      IF IN_CLASSE IS NOT NULL
      THEN
         D_CLASSE := ' class="' || D_CLASSE || '"';
      END IF;
      OUT_HTML :=
            OUT_HTML
         || ' <table cellpadding="0" cellspacing="0" border="0"><tr> '
         || D_SEPARATORE
         || ' <td align="left" valign="center" nowrap> '
         || ' <a '
         || D_CLASSE
         || D_TITOLO
         || ' href="'
         || IN_HREF
         || '">'
         || D_LINK
         || '</a> </td> '
         || ' </tr></table>';
      RETURN OUT_HTML;
   END;
   FUNCTION FILTER_SEARCH (IN_FILTER_VALUE IN VARCHAR2)
      RETURN STRINGA_GRANDE
   IS
      IMAGE      VARCHAR2 (512);
      TITLE      VARCHAR2 (512);
      OUT_HTML   STRINGA_GRANDE := NULL;
   BEGIN
      IF IN_FILTER_VALUE IS NULL
      THEN
         IMAGE := '../images/filtro_off.gif';
         TITLE := 'Filtro non attivo';
      ELSE
         IMAGE := '../images/filtro_on.gif';
         TITLE := 'Filtro attivo';
      END IF;
      OUT_HTML :=
            OUT_HTML
         || '<img src="'
         || IMAGE
         || '" width="18" height="18" border="0" alt="'
         || TITLE
         || '">';
      RETURN OUT_HTML;
   END;
   function DA_VISUALIZZARE
   ( P_LIVELLO number
   ) return boolean is
   /******************************************************************************
    FUNCTION:    DA_VISUALIZZARE
    DESCRIZIONE: Utilizzata nel caso di preparazione della mappa per capire se il
                nodo su cui si e posizionati e da visualizzare o meno in base a
                caratteristiche complesse.
    RITORNO : true se da visualizzare
              false non da visualizzare
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  03/12/2004 SN     Prima emissione.
   ******************************************************************************/
      V_RITORNO   BOOLEAN := FALSE;
   BEGIN
      IF    (D_VISUALIZZA_DA IS NULL AND D_VISUALIZZA_A IS NULL)
         OR (    (D_VISUALIZZA_DA IS NOT NULL OR D_VISUALIZZA_A IS NOT NULL)
             AND D_TROVATI >= NVL (D_VISUALIZZA_DA, 1)
             AND D_TROVATI <= NVL (D_VISUALIZZA_A, 99999999)
             AND (D_SCRITTI > 0 OR (D_SCRITTI = 0 AND P_LIVELLO = 1))
            )
      THEN
         V_RITORNO := TRUE;
      END IF;
      RETURN V_RITORNO;
   END;
   function SOTTOMAPPA_DA_FINIRE
   ( P_LIVELLO number
   ) return boolean is
   /******************************************************************************
    FUNCTION:    SOTTOMAPPA_DA_FINIRE
    DESCRIZIONE: Se si vogliono visualizzare solo i primi n nodi della mappa o dal
                 n+1 nodo si deve comunque iniziare o finire a livello 1 quindi
                 questa funzione serve a capire se anche avendo superato il numero
                 dei record richiesti si deve continuare a scrivere, o aspettare
                 a farlo.
    RITORNO: true: la sottomappa e ancora da finire
             false: la sottomappa e finita.
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  03/12/2004 SN     Prima emissione.
   ******************************************************************************/
       V_RITORNO   BOOLEAN := FALSE;
   BEGIN
      IF (    D_VISUALIZZA_A IS NOT NULL
          AND D_TROVATI > D_VISUALIZZA_A
          AND P_LIVELLO > 1
         )
      THEN
         V_RITORNO := TRUE;
      END IF;
      RETURN V_RITORNO;
   END;
   function GIA_SCRITTI_I_RICHIESTI
   ( P_LIVELLO number
   ) return boolean is
   /******************************************************************************
    FUNCTION:    gia_scritti_i_richiesti
    DESCRIZIONE: Utilizzata nel caso di preparazione della mappa per capire se
                 si puo terminare la scrittura dell'albero.
    RITORNO : true = i nodi richiesti sono gia stati scritti
              false = ci sono ancora nodi da scrivere.
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  03/12/2004 SN     Prima emissione.
   ******************************************************************************/
      V_RITORNO   BOOLEAN := FALSE;
   BEGIN
      IF (    D_VISUALIZZA_A IS NOT NULL
          AND D_TROVATI > D_VISUALIZZA_A
          AND P_LIVELLO = 1
         )
      THEN
         V_RITORNO := TRUE;
      END IF;
      RETURN V_RITORNO;
   END;
   procedure DISEGNA_ALBERO_ESPLOSO
   (  P_ID_STRUTTURA            VARCHAR2,
      P_LIVELLO                 NUMBER,
      P_CLOB           IN OUT   CLOB,
      P_CLASSE_START   IN       VARCHAR2,
      P_WHERE          IN       VARCHAR2
   ) is
   /******************************************************************************
    PROCEDURE:   DISEGNA_ALBERO_ESPLOSO
    DESCRIZIONE: Crea il codice html per la visualizzazione della mappa, qui
                indicata come albero esploso per dire che non si naviga ma
                la tecnica usata e simile a quella per disegnare l'albero
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  03/12/2004 SN     Prima emissione.
    016  14/02/2006 SN     Migliorie di performance, controllo solo
                           su esistenza di un figlio senza fare count dove non serve.
    019 04/11/2009 SNeg    Corretto per riposizionamento nell'albero
   ******************************************************************************/
      D_ROW                STRINGA_GRANDE;
      D_LEN                NUMBER;
      D_SOTTOALBERO_CLOB   CLOB;
      D_STRUTTURA          T_REF;
      D_CONTA              T_REF;
      D_FIGLIO_ID          STRINGA_PICCOLA;
      D_PADRE_ID           STRINGA_PICCOLA;
      D_DENOMINAZIONE      STRINGA_GRANDE;
      D_LINK               STRINGA_PICCOLA;
      D_N_FIGLI            NUMBER          := 0;
      D_CLASS              STRINGA_PICCOLA;
   BEGIN
      DBMS_LOB.CREATETEMPORARY (D_SOTTOALBERO_CLOB, TRUE, DBMS_LOB.SESSION);
      OPEN D_STRUTTURA FOR    'select '
                           || D_COLONNA
                           || ' figlio_id, '
                           || D_COLONNA_PADRE
                           || ' padre_id, '
                           || D_COLONNA_NOME
                           || ' denominazione ,'
                           || NVL (D_COLONNA_CLASS, ' null ')
                           || ' immagine, '
                           || NVL (D_COLONNA_LINK, ' null ')
                           || ' collegamento '
                           || ' from '
                           || D_TABELLA
                           || ' where '
                           || D_COLONNA_PADRE
                           || ' = '''
                           || P_ID_STRUTTURA
                           || ''''
                           || ' and '
                           || D_COLONNA_PADRE
                           || ' <> '
                           || D_COLONNA
                           || P_WHERE
                           || ' order by '
                           || D_COLONNA_ORDINAMENTO;
      LOOP
         FETCH D_STRUTTURA
          INTO D_FIGLIO_ID, D_PADRE_ID, D_DENOMINAZIONE, D_CLASS, D_LINK;
         EXIT WHEN D_STRUTTURA%NOTFOUND;
         EXIT WHEN GIA_SCRITTI_I_RICHIESTI (P_LIVELLO);
         D_TROVATI := D_TROVATI + 1;
         IF DA_VISUALIZZARE (P_LIVELLO) OR SOTTOMAPPA_DA_FINIRE (P_LIVELLO)
         THEN
            D_SCRITTI := D_SCRITTI + 1;
            D_ROW := '<li class="' || D_CLASS || '">';
            IF D_COLONNA_LINK IS NOT NULL
            THEN
               D_ROW :=
                     D_ROW
                  || '<a href="'
                  || D_LINK
                  || '" title="'
                  || D_DENOMINAZIONE
                  || '" class="AFCDataLink">';
            END IF;
            D_ROW := D_ROW || D_DENOMINAZIONE;
            IF D_COLONNA_LINK IS NOT NULL
            THEN
               D_ROW := D_ROW || '</a>';
            END IF;
            D_ROW := D_ROW || '</li>';
         END IF; -- controllo se devo scrivere
         OPEN D_CONTA FOR 'select  1 from dual where exists ( select 1 from '
                          || D_TABELLA
                          || ' where '
                          || D_COLONNA_PADRE
                          || ' = '''
                          || D_FIGLIO_ID
                          || ''''
                          || ' and '
                          || D_COLONNA_PADRE
                          || ' <> '
                          || D_COLONNA
                          || P_WHERE
                          || ')';
            FETCH D_CONTA
             INTO D_N_FIGLI;
            if d_conta%NOTFOUND then
               d_n_figli := 0;
            end if;
         CLOSE D_CONTA;
         IF D_N_FIGLI != 0
         THEN
            IF DA_VISUALIZZARE (P_LIVELLO)
               OR SOTTOMAPPA_DA_FINIRE (P_LIVELLO)
            THEN
               D_ROW :=
                     D_ROW
                  || '<li class="AFCHiddenLI"><ul class="'
                  || P_CLASSE_START
                  || '">';
               D_LEN := DBMS_LOB.GETLENGTH (D_SOTTOALBERO_CLOB);
               IF D_LEN > 0
               THEN
                  DBMS_LOB.TRIM (D_SOTTOALBERO_CLOB, 0);
               END IF;
            END IF;                                  -- controllo per scrivere
            IF    D_ESPANDI_AL_LIVELLO IS NULL
               OR D_ESPANDI_AL_LIVELLO >= P_LIVELLO + 1
            THEN
               DISEGNA_ALBERO_ESPLOSO (D_FIGLIO_ID,
                                       P_LIVELLO + 1,
                                       D_SOTTOALBERO_CLOB,
                                       P_CLASSE_START,
                                       P_WHERE
                                      );
            END IF;
         END IF;
         IF DA_VISUALIZZARE (P_LIVELLO)
            OR SOTTOMAPPA_DA_FINIRE (P_LIVELLO + 1)
         THEN
            D_LEN := LENGTH (D_ROW);
            IF D_LEN > 0
            THEN
               DBMS_LOB.WRITEAPPEND (P_CLOB, D_LEN, D_ROW);
            END IF;
            IF D_N_FIGLI != 0
            THEN
               D_ROW := '</ul></li>';
               DBMS_LOB.APPEND (P_CLOB, D_SOTTOALBERO_CLOB);
            ELSE
               D_ROW := NULL;
            END IF;
            D_LEN := DBMS_LOB.GETLENGTH (D_SOTTOALBERO_CLOB);
            IF D_LEN > 0
            THEN
               DBMS_LOB.TRIM (D_SOTTOALBERO_CLOB, 0);
            END IF;
            IF D_N_FIGLI != 0
            THEN
               IF DBMS_LOB.GETLENGTH (P_CLOB) > 0
               THEN
                  -- per evitare chiusure sbagliate in caso
                  -- di albero che inizia non dal primo record
                  DBMS_LOB.WRITEAPPEND (P_CLOB, LENGTH (D_ROW), D_ROW);
               END IF;
            END IF;
            D_ROW := NULL;
         END IF;                                 -- controllo se devo scrivere
      END LOOP;
      CLOSE D_STRUTTURA;
   EXCEPTION
      WHEN OTHERS
      THEN
         IF D_STRUTTURA%ISOPEN
         THEN
            CLOSE D_STRUTTURA;
         END IF;
         RAISE;
   END DISEGNA_ALBERO_ESPLOSO;
   function MAPPA
   (  P_MODULO               VARCHAR2,
      P_PAGE                 VARCHAR2,
      P_TABELLA              VARCHAR2,
      P_COLONNA_PADRE        VARCHAR2,
      P_COLONNA              VARCHAR2,
      P_COLONNA_NOME         VARCHAR2,
      P_EXPR_ORDINAMENTO     VARCHAR2,
      P_COLONNA_CLASS        VARCHAR2 DEFAULT '',
      P_COLONNA_LINK         VARCHAR2 DEFAULT '',
      P_ESPANDI_AL_LIVELLO   NUMBER DEFAULT TO_NUMBER (NULL),
      P_VISUALIZZA_DA        NUMBER DEFAULT TO_NUMBER (NULL),
      P_VISUALIZZA_A         NUMBER DEFAULT TO_NUMBER (NULL),
      P_CLASSE_START         VARCHAR2 DEFAULT 'AFCMappaSitoUL',
      P_WHERE                VARCHAR2 DEFAULT ''
   ) return clob is
   /******************************************************************************
    FUNCTION:    MAPPA
    DESCRIZIONE: Riceve i parametri dall'esterno necessari per disegnare la mappa
    RITORNO : html che rappresenta la mappa.
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  03/12/2004 SN     Prima emissione.
   ******************************************************************************/
      D_CLOB        CLOB            := EMPTY_CLOB ();
      D_CLOB1       CLOB            := EMPTY_CLOB ();
      D_ROW_START   STRINGA_PICCOLA;
      D_ROW_END     STRINGA_PICCOLA;
      D_WHERE       STRINGA_GRANDE;
   BEGIN
      D_SCRITTI := 0;
      D_ESPANDI_AL_LIVELLO := P_ESPANDI_AL_LIVELLO;
      D_VISUALIZZA_DA := P_VISUALIZZA_DA;
      D_VISUALIZZA_A := P_VISUALIZZA_A;
      D_COLONNA_CLASS := P_COLONNA_CLASS;
      D_COLONNA_LINK := P_COLONNA_LINK;
      D_TABELLA := NVL (P_TABELLA, 'tabella');
      D_COLONNA := NVL (P_COLONNA, 'id');
      D_COLONNA_NOME := NVL (P_COLONNA_NOME, 'nome');
      D_COLONNA_ORDINAMENTO := NVL (P_EXPR_ORDINAMENTO, 'nome');
      D_COLONNA_PADRE := NVL (P_COLONNA_PADRE, 'padre_id');
      D_COLONNA_LINK := P_COLONNA_LINK;
      DBMS_LOB.CREATETEMPORARY (D_CLOB, TRUE, DBMS_LOB.SESSION);
      DBMS_LOB.CREATETEMPORARY (D_CLOB1, TRUE, DBMS_LOB.SESSION);
      D_TROVATI := 0;
      IF P_WHERE IS NULL
      THEN
         D_WHERE := '';
      ELSE
         D_WHERE := ' and ' || P_WHERE;
      END IF;
      DISEGNA_ALBERO_ESPLOSO ('0', 1, D_CLOB1, P_CLASSE_START, D_WHERE);
      IF DBMS_LOB.GETLENGTH (D_CLOB1) > 0
      THEN
         D_ROW_START := '<ul class="' || P_CLASSE_START || '">';
         D_ROW_END := '</ul>';
         DBMS_LOB.WRITEAPPEND (D_CLOB, LENGTH (D_ROW_START), D_ROW_START);
         DBMS_LOB.APPEND (D_CLOB, D_CLOB1);
         DBMS_LOB.WRITEAPPEND (D_CLOB, LENGTH (D_ROW_END), D_ROW_END);
      END IF;                                         -- nessun record trovato
      RETURN D_CLOB;
   END;
   /******************************************************************************
   FUNCTION GETBLANKLINK
   DESCRIZIONE: Genera un link accessibile
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    000  15/11/2005        Prima emissione.
    013  31/01/2006        Sistemato default gi� presente nella declaration
    018  23/10/2009 MM     Modificata funzione spezzando la stringa '//--' in
                           '//-'||'-' per facilitare il parse del package.
   ******************************************************************************/
   FUNCTION GET_BLANK_LINK(
    P_URL                 VARCHAR2,
     P_TITLE               VARCHAR2,
     P_CLASS               VARCHAR2 DEFAULT 'AFCDataLink'
     )
     RETURN VARCHAR2
   IS
      P_BLANKLINK     VARCHAR2(1000);
   BEGIN
     P_BLANKLINK := '<script type="text/javascript">'||chr(13)||
                   '<!-'||'- document.write(''<a class="'||P_CLASS||'" href="#" title="'||P_TITLE||'"'||
                      ' onkeypress="window.open(\'''||P_URL||'\'', \'''||P_TITLE||'\'');" '||
                   ' onclick="window.open(\'''||P_URL||'\'', \'''||P_TITLE||'\'');">'||
                      ''||P_TITLE||'</a>'');'||chr(13)||'//-'||'-'||'>'||chr(13)||'</script>'||
                      '<noscript><p><a class="'||P_CLASS||'" href="'||P_URL||
                      '"title="'||P_TITLE||'">'||P_TITLE||'</a></p></noscript>';
    RETURN P_BLANKLINK;
   END GET_BLANK_LINK;
END;
/

