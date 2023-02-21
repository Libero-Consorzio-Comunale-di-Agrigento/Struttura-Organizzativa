CREATE OR REPLACE PACKAGE AFC_HTML is
/******************************************************************************
NOME:        AFC_HTML
DESCRIZIONE: generazione html di tabella visualizzata ad albero
ANNOTAZIONI: -
REVISIONI:
Rev. Data       Autore Descrizione
---- ---------- ------ ------------------------------------------------------
00   03/12/2004 SN     Prima emissione.
01   04/03/2005 SN     Riorganizzazione codice.
02   14/06/2005 SN     Passaggio anche del nome dell'immagine e link da usare
03   22/06/2005 SN     Funzione che genera html per visualizzare la mappa.
04   12/07/2005 SM     Sistemato errore per html in caso di mappa su piu colonne
05   27/07/2005 SN     Modificato per consentire di passare con la pagina anche
                       eventuali parametri.
06   05/09/2005 SN     Sistemazioni varie
07   28/09/2005 MF     Introduzione Revisione differenziata tra Specification e Body.
08   23/09/2005 SN     Previsto parametro per le where condition per la mappa.
09   06/10/2005 SN     Previsto parametro per le where condition per gli alberi.
10   06/10/2005 SN     Sistemata dimensione variabile D_NVL_P_STRUTTURA_ID.
11   14/10/2005 SN     Merge tra modifiche di SN e di MF
12   15/11/2005 SN     Inserimento GETBLANKLINK
13   31/01/2006 SN     Errore in caso di uso where condition nella function
                       TROVA_TUTTI. Sistemato default nella declaration di
                  GET_BLANK_LINK.
14   06/02/2006 SN     Aggiunta possibilità di indicare che non si vuole il link
                       per certi nodi, occorre passare il valore 'NULLO' nella
                  colonna link. Modificata la disegna albero.
******************************************************************************/
  subtype stringa_grande IS VARCHAR2(32767);
  subtype t_revision is varchar2(30);
  s_revisione t_revision := 'V1.14';
  stringa stringa_grande;
  trovato NUMBER(1);
  function versione RETURN t_revision;
  type t_array IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
  type t_ref IS REF CURSOR;
  PROCEDURE tree_imposta_preferenze
  ( p_albero        VARCHAR2,
    p_modulo        VARCHAR2,
    p_immagini      VARCHAR2,
    p_mostra_foglia VARCHAR2,
    p_riposiziona   VARCHAR2,
    p_uno_aperto    VARCHAR2
  );
  /******************************************************************************
   PROCEDURE TREE_IMPOSTA_PREFERENZE
   DESCRIZIONE: Imposta nei registri alcune delle preferenze di visualizzazione
               dell'albero ci sono quelle che presumibilmente potrebbero essere
               piu frequentemente da variare
   ARGOMENTI:
        p_albero        VARCHAR2 nome dell'albero
        p_modulo        VARCHAR2 modulo
        p_immagini      VARCHAR2 directory dove si trovano le immagini
        p_foglia        VARCHAR2 (S/N) se visualizzare le foglie
        p_riposiziona   VARCHAR2 (S/N) se riposizionarsi dopo esplorazione albero
        p_uno_aperto    VARCHAR2 (S/N) S= solo un folder aperto
  ******************************************************************************/
  PROCEDURE tree_imposta
  ( p_albero                 VARCHAR2,
    p_modulo                 VARCHAR2,
    p_tabella                VARCHAR2,
    p_colonna_padre          VARCHAR2,
    p_colonna_figlio         VARCHAR2,
    p_colonna_nome           VARCHAR2,
    p_expr_ordinamento       VARCHAR2,
    p_disloc_immagini        VARCHAR2 DEFAULT NULL,
    p_func_foglia            VARCHAR2 DEFAULT NULL,
    p_mostra_foglia          VARCHAR2 DEFAULT 'N',
    p_riposiziona            VARCHAR2 DEFAULT 'N',
    p_un_folder_aperto       VARCHAR2 DEFAULT 'S',
    p_inclusione             VARCHAR2 DEFAULT 'N',
    p_pagina_href            VARCHAR2 DEFAULT NULL,
    p_parametro_inclusione   VARCHAR2 DEFAULT NULL,
    p_parametro_url          VARCHAR2 DEFAULT 'ST',
    p_separatore             VARCHAR2 DEFAULT '|',
    p_fld_close              VARCHAR2 DEFAULT NULL,
    p_fld_open               VARCHAR2 DEFAULT NULL,
    p_last_fld_open          VARCHAR2 DEFAULT NULL,
    p_plus_node              VARCHAR2 DEFAULT NULL,
    p_last_plus_node         VARCHAR2 DEFAULT NULL,
    p_minus_node             VARCHAR2 DEFAULT NULL,
    p_last_minus_node        VARCHAR2 DEFAULT NULL,
    p_img_line               VARCHAR2 DEFAULT NULL,
    p_blank                  VARCHAR2 DEFAULT NULL,
    p_foglia                 VARCHAR2 DEFAULT NULL,
    p_colonna_immagine       VARCHAR2 DEFAULT NULL,
    p_colonna_immagine_open  VARCHAR2 DEFAULT NULL,
    p_colonna_link           VARCHAR2 DEFAULT NULL,
    p_solo_una_foglia_aperta VARCHAR2 DEFAULT 'S',
    p_mostra_tutte_foglie    VARCHAR2 DEFAULT 'N',
    p_where                  VARCHAR2 DEFAULT ''
  );
  /******************************************************************************
  PROCEDURE TREE_IMPOSTA
  DESCRIZIONE: Imposta nei registri TUTTE le informazioni necessarie per la struttura
  dell'albero e la sua visualizzazione
  ARGOMENTI:
    p_albero                 VARCHAR2 nome dell'albero
    p_modulo                 VARCHAR2 modulo
    p_tabella                VARCHAR2 tabella contenente i dati gerarchici
    p_colonna_padre          VARCHAR2 colonna padre
    p_colonna_figlio         VARCHAR2 colonna
    p_colonna_nome           VARCHAR2 descrizione da visualizzare
    p_expr_ordinamento       VARCHAR2 espressione usata per l'ordinamento
    p_disloc_immagini        VARCHAR2 directory dove si trovano le immagini
    p_func_foglia            VARCHAR2 cursore che estrae i dati "foglia"
    p_mostra_foglia          VARCHAR2 (S/N) S= visualizza i dati foglia
    p_riposiziona            VARCHAR2 (S/N) se riposizionarsi dopo esplorazione albero
    p_un_folder_aperto       VARCHAR2 (S/N) S= solo un folder aperto
    p_inclusione             VARCHAR2 (S/N) N=non e pagina inclusa (in CCS)
    p_pagina_href            VARCHAR2 nome pagina da visualizzare (in CCS)
    p_parametro_inclusione   VARCHAR2 parametro da usare in CCS per inclusione
    p_parametro_url          VARCHAR2 parametro in CCS da usare per visualizzazione
                                      informazioni in una struttura separata
  ******************************************************************************/
  FUNCTION tree
  ( p_struttura_id VARCHAR2,
    p_modulo       VARCHAR2,
    p_albero       VARCHAR2,
    p_page         VARCHAR2
  ) RETURN CLOB;
  /******************************************************************************
   FUNCTION TREE
   DESCRIZIONE: Generazione albero -- funzione da richiamare da CCS
   Viene utilizzata indicando il nome dell'albero da rappresentare, le informazioni
   sulla struttura dell'albero sono nei registri
   PARAMETRI:
        p_struttura_id   VARCHAR2 struttura da visualizzare nell'albero
        p_modulo         VARCHAR2 modulo
        p_albero         VARCHAR2 nome dell'albero da rappresentare
        p_page           VARCHAR2 pagina in cui visualizzare l'albero
   RITORNA:     CLOB  Contiene html per rappresentazione dell'albero
  ******************************************************************************/
  FUNCTION tree
  ( p_struttura_id           VARCHAR2,
    p_modulo                 VARCHAR2,
    p_albero                 VARCHAR2,
    p_page                   VARCHAR2,
    p_tabella                VARCHAR2,
    p_colonna_padre          VARCHAR2,
    p_colonna                VARCHAR2,
    p_colonna_nome           VARCHAR2,
    p_expr_ordinamento       VARCHAR2,
    p_func_foglia            VARCHAR2 DEFAULT NULL,
    p_mostra_foglia          VARCHAR2 DEFAULT 'N',
    p_riposiziona            VARCHAR2 DEFAULT 'N',
    p_un_folder_aperto       VARCHAR2 DEFAULT 'S',
    p_inclusione             VARCHAR2 DEFAULT 'N',
    p_pagina_href            VARCHAR2 DEFAULT NULL,
    p_parametro_inclusione   VARCHAR2 DEFAULT NULL,
    p_parametro_url          VARCHAR2 DEFAULT 'ST',
    p_separatore             VARCHAR2 DEFAULT '|',
    p_disloc_immagini        VARCHAR2 DEFAULT NULL,
    p_fld_close              VARCHAR2 DEFAULT NULL,
    p_fld_open               VARCHAR2 DEFAULT NULL,
    p_last_fld_open          VARCHAR2 DEFAULT NULL,
    p_plus_node              VARCHAR2 DEFAULT NULL,
    p_last_plus_node         VARCHAR2 DEFAULT NULL,
    p_minus_node             VARCHAR2 DEFAULT NULL,
    p_last_minus_node        VARCHAR2 DEFAULT NULL,
    p_img_line               VARCHAR2 DEFAULT NULL,
    p_blank                  VARCHAR2 DEFAULT NULL,
    p_foglia                 VARCHAR2 DEFAULT NULL,
    p_colonna_immagine       VARCHAR2 DEFAULT '',
    p_colonna_link           VARCHAR2 DEFAULT '',
    p_ricerca                VARCHAR2 DEFAULT NULL,
    p_colonna_immagine_open  VARCHAR2 DEFAULT '',
    p_solo_una_foglia_aperta VARCHAR2 DEFAULT 'S',
    p_mostra_tutte_foglie    VARCHAR2 DEFAULT 'S',
    p_where                  VARCHAR2 DEFAULT ''
  ) RETURN CLOB;
  /******************************************************************************
   FUNCTION TREE
   DESCRIZIONE: Generazione html per albero -- funzione da richiamare da CCS
   Viene utilizzata indicando tutte le caratteristiche dell'albero da rappresentare
   ARGOMENTI:
     p_id_struttura           VARCHAR2 identificativo struttura da visualizzare
     p_modulo                 VARCHAR2 modulo
     p_albero                 VARCHAR2 nome dell'albero
     p_page                   VARCHAR2 nome pagina da visualizzare (in CCS)
     p_tabella                VARCHAR2 tabella contenente i dati gerarchici
     p_colonna_padre          VARCHAR2 nome colonna padre
     p_colonna                VARCHAR2 nome colonna figlio
     p_colonna_nome           VARCHAR2 nome colonna con descrizione da visualizzare
     p_expr_ordinamento       VARCHAR2 espressione usata per l'ordinamento
     p_func_foglia            VARCHAR2 cursore che estrae i dati "foglia"
     p_mostra_foglia          VARCHAR2 (S/N) S= visualizza i dati foglia
     p_riposiziona            VARCHAR2 (S/N) se riposizionarsi dopo esplorazione albero
     p_un_folder_aperto       VARCHAR2 (S/N) S= solo un folder aperto
     p_inclusione             VARCHAR2 (S/N) N=non e pagina inclusa (in CCS)
     p_parametro_inclusione   VARCHAR2 parametro da usare in CCS per inclusione
     p_parametro_url          VARCHAR2 parametro in CCS da usare per visualizzazione
                                       informazioni in una struttura separata
     p_separatore             VARCHAR2 carattere di separazione per gli id nell'url
     p_disloc_immagini        VARCHAR2 directory dove si trovano le immagini
     p_fld_close              VARCHAR2 nome immagine folder chiuso
     p_fld_open               VARCHAR2 nome immagine folder aperto
     p_last_fld_open          VARCHAR2 nome immagine ultimo folder aperto
     p_plus_node              VARCHAR2 nome immagine nodo da esplodere
     p_last_plus_node         VARCHAR2 nome immagine ultimo nodo da esplodere
     p_minus_node             VARCHAR2 nome immagine nodo gia esploso
     p_last_minus_node        VARCHAR2 nome immagine ultimo nodo gia esploso
     p_img_line               VARCHAR2 nome immagine linea
     p_blank                  VARCHAR2 nome immagine bianca
     P_FOGLIA                 VARCHAR2 immagine da usare per le foglie,
     P_COLONNA_IMMAGINE       VARCHAR2 colonna della query che indica l'immagine da usare,
     P_COLONNA_LINK           VARCHAR2 colonna della query che indica il link da usare,
     p_ricerca                varchar2 stringa per cui si effettua la ricerca,
     P_COLONNA_IMMAGINE_OPEN  VARCHAR2 colonna della query che indica l'immagine da usare
                                       per il folder aperto,
     P_SOLO_UNA_FOGLIA_APERTA VARCHAR2 'S'= solo una foglia aperta per volta oppure 'N',
     P_MOSTRA_TUTTE_FOGLIE    varchar2 'S'= se mostro le foglie visualizzarle subito tutte senza
                                       aspettare il posizionamento sul ramo padre oppure 'N'
     P_WHERE                  varchar2 Eventuale filtro da aggiungere alle query per la
                                       rappresentazione dell'albero
   RITORNA:     CLOB  Contiene html per rappresentazione dell'albero
  ******************************************************************************/
  FUNCTION mappa
  (
    p_modulo             VARCHAR2,
    p_page               VARCHAR2,
    p_tabella            VARCHAR2,
    p_colonna_padre      VARCHAR2,
    p_colonna            VARCHAR2,
    p_colonna_nome       VARCHAR2,
    p_expr_ordinamento   VARCHAR2,
    p_colonna_class      VARCHAR2 DEFAULT '',
    p_colonna_link       VARCHAR2 DEFAULT '',
    p_espandi_al_livello NUMBER DEFAULT TO_NUMBER(NULL),
    p_visualizza_da      NUMBER DEFAULT TO_NUMBER(NULL),
    p_visualizza_a       NUMBER DEFAULT TO_NUMBER(NULL),
    p_classe_start       VARCHAR2 DEFAULT 'AFCMappaSitoUL',
    p_where              VARCHAR2 DEFAULT ''
  ) RETURN CLOB;
  /******************************************************************************
   FUNCTION MAPPA
   DESCRIZIONE: Generazione html per MAPPA -- funzione da richiamare da CCS
   Viene utilizzata indicando le caratteristiche della mappa da rappresentare.
   La mappa e intesa come rappresentazione "statica" dei padri e dei figli.
   Ci si basa su una tabella che in realta puo anche essere una vista.
   ARGOMENTI:
     p_modulo              VARCHAR2 modulo
     p_page                VARCHAR2 nome pagina da visualizzare (in CCS)
     p_tabella             VARCHAR2 tabella contenente i dati gerarchici
     p_colonna_padre       VARCHAR2 nome colonna padre
     p_colonna             VARCHAR2 nome colonna figlio
     p_colonna_nome        VARCHAR2 nome colonna con descrizione da visualizzare
     p_expr_ordinamento    VARCHAR2 espressione usata per l'ordinamento
     p_colonna_class       VARCHAR2 nome colonna con la classe da usare
     p_colonna_link        VARCHAR2 nome colonna con il link da usare
     P_ESPANDI_AL_LIVELLO  NUMBER   livello al quale visualizzare le informazioni
     P_VISUALIZZA_DA       number   nodo dal quale iniziare la visualizzazione
     P_VISUALIZZA_A        number   nodo fino al quale visualizzare
     P_CLASSE_START        varchar2 classe da usare per i tag ul (con sottonodi)
     P_WHERE                  varchar2 Eventuale filtro da aggiungere alle query per la
                                       rappresentazione dell'albero
   RITORNA:     CLOB  Contiene html per rappresentazione della mappa
  ******************************************************************************/
  FUNCTION tab_folder
  (
    in_link   IN VARCHAR2,
    in_href   IN VARCHAR2,
    in_active IN VARCHAR2 DEFAULT 'N'
  ) RETURN stringa_grande;
  /******************************************************************************
  FUNCTION TAB_FOLDER
  DESCRIZIONE: Generazione html per folder-- funzione da richiamare da CCS
  ARGOMENTI:
    in_link      VARCHAR2 Nome del link eventuale titolo separato da virgola
    in_href      VARCHAR2 Collegamento da attribuire al link
    in_active    VARCHAR2 S/N se e la pagina selezionata o meno
  ESEMPIO:
  da code charge creo un sql che torna tante colonne quanti sono i possibili
  folder.
  select afc_html.tab_folder
        ('Risorse',
         'AspMain.do?MVPG=AmbRisorseGruppo&'|| 'GRUPPO_ID='||'{GRUPPO_ID}',
         decode('{MVPG}','AmbRisorseGruppo','S','N')
        ) folder1
        ... (altri folder...)
   from dual
  RITORNA:     varchar2  Contiene html per rappresentazione dei folder
  ******************************************************************************/
  FUNCTION guida_bar
  (
    in_link          IN VARCHAR2,
    in_href          IN VARCHAR2,
    in_separatore_sn IN VARCHAR2 DEFAULT 'S',
    in_classe        IN VARCHAR2 DEFAULT NULL
  ) RETURN stringa_grande;
  /******************************************************************************
   FUNCTION GUIDA_BAR
   DESCRIZIONE: Generazione html per menu-- funzione da richiamare da CCS
   ARGOMENTI:
     in_link           VARCHAR2 Nome del link eventuale titolo separato da virgola
     in_href           VARCHAR2 Collegamento da attribuire al link
     in_separatore_SN  VARCHAR2 S/N se aggiungere in coda il separatore
     in_classe         VARCHAR2 Nome della classe, viene accodato Link
   ESEMPIO:
   da code charge creo un sql che torna tante colonne quanti sono i possibili
   folder.
   select afc_html.guida_bar
      ('Accesso,Informazioni per accesso al Luogo',
'PsaMain.do?MVPG=PsaLuogoPrestazioneAcce&'||'LUOGO_ID='||'{LUOGO_ID}'||'&'||'PRESTAZIONE_ID='||'{PRESTAZIONE_
ID}'
                                               ||'&'||'PRES_LUOG_ID='||'{PRES_LUOG_ID}',
       'S'
      ) menu1,
         ... (altri menu...)
    from dual
   RITORNA:     varchar2  Contiene html per rappresentazione del menu
  ******************************************************************************/
  FUNCTION filter_search(in_filter_value IN VARCHAR2) RETURN stringa_grande;
  /******************************************************************************
   FUNCTION FILTER_SEARCH
   DESCRIZIONE: Generazione html per immagine filtro-- funzione da richiamare da CCS
   ARGOMENTI:
     in_filter_value      VARCHAR2 Valore del filtro
   ESEMPIO:
   da code charge basta mettere un link che richiama questa funzione passando
   il valore del filtro, in realta interessa se e nullo o no.
   RITORNA:     varchar2  Contiene html per rappresentazione del filtro
  ******************************************************************************/
  FUNCTION GET_BLANK_LINK(
      P_URL             VARCHAR2,
     P_TITLE            VARCHAR2,
     P_CLASS            VARCHAR2 DEFAULT 'AFCDataLink'
   ) RETURN VARCHAR2;
   /******************************************************************************
    FUNCTION GETBLANKLINK
    DESCRIZIONE: genera il codice html accessibile per gestire il link in una nuova finestra
   sia nel caso in cui sia abilitato javascript che nel caso in cui non lo sia
   PARAMETRI:
         p_url               VARCHAR2 l'indirizzo cui punta il link
         p_title             VARCHAR2 valore dell'attributo title del link
         p_class            VARCHAR2 la classe del link
    RITORNA:     VARCHAR2 , il link accessibile
   ******************************************************************************/
END;
/

