CREATE OR REPLACE package AFC_Periodo is
/******************************************************************************
 NOME:        AFC_Periodo
 DESCRIZIONE: Consente di verificare se esistono periodi legati a quello
              passato come parametro che rispettano le condizioni volute
              determinate in base ai campi da controllare passati come parametro.
              Si analizzano i record che hanno nei campi i medesimi valori
              del record in analisi e le date sono contigue ed si puo' ottenere:
              - l'ultima data per i valori indicati
              - il valore 1 se il record analizzato e' il primo con i valori
                indicati.
              Il nome del campo che rappresenta la data di inizio (dal) e il
              nome di quello di fine (al) devono essere passati come parametro.
 ANNOTAZIONI: I campi e i valori da controllare sono passati in una stringa
              delimitati da '#'; nel parametro P_VALORI_CONTROLLARE puo essere
              specificato l'operatore da utilizzare nella ricerca dei record
              (da inserire tra il '#' e il valore; vedi esempio 1). I possibili
              operatori da utilizzare sono:
              >            maggiore
              <            minore
              =  o ==      uguale
              >= o =>      maggiore o uguale
              <= o =<      minore o uguale
              != o <>      diverso
              =%           like
 ESEMPI:
    chiamata: <nome_metodo>( 'myTable'
                           , 'DAL'
                           , 'AL'
                           , to_date( '15011981', 'ddmmyyyy' )
                           , to_date( '07042006', 'ddmmyyyy' )
                           , '#' || 'field1' || '#' || 'field2' || '#'
                           , '#value1#value2#'
                           );
    - is_tutto_incluso( P_PERIODO ) = true
                        |-----P_PERIODO-----|
         |----P1----||-----------P2-----------||---P3---||---P4---||-----P5-----|
       |-----------------------------------asse_temporale----------------------------------|
    - is_contiguo_incluso( P_PERIODO ) = true
                        |--------P_PERIODO--------|
         |----P1----||------P2------||-------P3-------||-----P4-----||-------P5-------|
       |-----------------------------------asse_temporale----------------------------------|
    - is_escluso( P_PERIODO ) = false
            |-----P_PERIODO-----|
                                  |---------P1---------||---P2---||-----P3-----|
       |-----------------------------------asse_temporale----------------------------------|
    - is_intersecato( P_PERIODO ) = false
                        |--------P_PERIODO--------|
         |----P1----||------P2------|                 |-----P3-----||-------P4-------|
       |-----------------------------------asse_temporale----------------------------------|
                        |--------P_PERIODO--------|
         |----P1----|                    |------P2------||-----P3-----||-------P4-------|
       |-----------------------------------asse_temporale----------------------------------|
    - is_contiguo( P_PERIODO ) = false
           |----P1----||-----P_PERIODO-----|   |-----P3-----||---P4---||-----P5-----|
       |-----------------------------------asse_temporale----------------------------------|
           |----P1----|   |-----P_PERIODO-----||-----P3-----||---P4---||-----P5-----|
       |-----------------------------------asse_temporale----------------------------------|
    - is_tutto_contiguo( P_PERIODO ) = false
           |----P1----||-----P_PERIODO-----||-----P3-----||---P4---||-----P5-----|
       |-----------------------------------asse_temporale----------------------------------|
    - is_estremi_inclusi( P_PERIODO ) = true
                        |--------P_PERIODO--------|
         |----P1----||------P2------|   |-------P3-------||-----P4-----||-------P5-------|
       |-----------------------------------asse_temporale----------------------------------|
    - is_contenitore( P_PERIODO ) = false
                          |-----------P_PERIODO-----------|
           |----P1----||---------P2---------||---P3---||---P4---||-----P5-----|
       |-----------------------------------asse_temporale----------------------------------|
    - set_contigui (con buchi)
       situazione iniziale:
                         |-----------P_PERIODO-----------|
          |---1---|                |---2---|                    |---3---|
                    |---4---|                         |---5---|
                   |----------------------6----------------------|
                         |---7---|             |----8----|
              |---9---|                                      |---10---|
          |-----------------------------asse_temporale-----------------------------|
       risultato:
                         |-----------P_PERIODO-----------|
          |---1---|                                            |---3---|
                    |-4--|                               |-5-|
                   |--6--|
              |---9---|
          |-----------------------------asse_temporale-----------------------------|
    - set_contigui (senza buchi)
       situazione iniziale:
                         |-----------P_PERIODO-----------|
          |---1---|                |---2---|                    |---3---|
                    |---4---|                         |---5---|
                   |----------------------6----------------------|
                         |---7---|             |----8----|
              |---9---|                                      |---10---|
          |-----------------------------asse_temporale-----------------------------|
       risultato:
                         |-----------P_PERIODO-----------|
          |---1---|                                            |---3---|
                    |-4--|                               |-5-|
                   |--6--|
                 |---9---|
          |-----------------------------asse_temporale-----------------------------|
    - set_finale
       situazione iniziale:
                         |-----------P_PERIODO-----------|
          |---1---|                |---2---|                    |---3---|
                    |---4---|                         |---5---|
                   |----------------------6----------------------|
                         |---7---|             |----8----|
          |-----------------------------asse_temporale-----------------------------|
       risultato:
                         |-----------P_PERIODO-----------|
          |---1---|
                    |-4--|
                   |--6--|
          |-----------------------------asse_temporale-----------------------------|
    - reset_contigui
       situazione iniziale:
                                        |---X---|
             |---1---||---2---||---3---|         |---4---||---5---||---6---|
          |-----------------------------asse_temporale--------------------------|
       risultato:
             |---1---||---2---||--------3-------||---4---||---5---||---6---|
          |-----------------------------asse_temporale--------------------------|
    - exists and get
                   |-----------P_PERIODO-----------|
    |----P1----||------P2------||-------P3-------||-----P4-----||-------P5-------|
    |-----------------------------asse_temporale----------------------------|
    existsPrecedenti( P_PERIODO ) = true   =>   get_precedente( P_PERIODO ) = P1
    existsSeguenti( P_PERIODO ) = true   =>   get_seguente( P_PERIODO ) = P5
    existsContenuti( P_PERIODO ) = true   =>   get_contenuto( P_PERIODO ) = P3
    existsIntersecati( P_PERIODO ) = true   =>   get_intersecato( P_PERIODO ) =  P2
    existsNonInclusi( P_PERIODO ) = true   =>   get_non_incluso( P_PERIODO ) =  P1
 REVISIONI:
 Rev.  Data       Autore     Descrizione
 ----  ---------- ---------- ------------------------------------------------------
 00    07/04/2005 SN         Prima emissione.
 01    16/06/2005 FTASSINARI aggiunta dei metodi set_contigui, set_finale,
                             get_seguente e get_precedente
 02    23/06/2005 FTASSINARI aggiunta dei metodi reset_contigui, exists_precedente,
                             exists_seguente e exists_contenuto
 03    30/06/2005 FTASSINARI aggiunta dei metodi get_contenuto, is_tutto_contiguo,
                             get_intersecato_sx, get_intersecato_dx, exists_intersecati,
                             get_periodo_contiguo
                             modifica dei metodi EZTRAZIONE_CONDIZIONE
 04    16/08/2005 FTASSINARI aggiunta dei metodi is_contenitore e modifica di
                             get_contiguo
 05    23/09/2005 FTASSINARI aggiunta dei metodi get_inizio_periodo, get_fine_periodo
                             get_primo, get_ultimo, is_primo, is_ultimo
 06    27/09/2005 FTASSINARI modifica: get_inizio_periodo => get_data_inizio;
                             get_fine_periodo => get_data_fine; get_intersecato_sx => get_intersecante_inizio;
                             get_intersecato_dx => get_intersecante_fine;
                             aggiunta: get_primo_dal; get_ultimo_al;
                             get_precedente_dal; get_seguente_al;
 07    28/09/2005 FTASSINARI modifica in get_primo, get_ultimo, get_primo_dal
                             get_primo_al; utilizzo di estrazione_val in vari metodi e
                             aggiunta di to_char(...) nella select
 08    30/09/2005 FTASSINARI eliminata dipendenza da AFC_ERROR
 09    06/04/2006 FTASSINARI aggiunti metodi exists_non_inclusi e get_non_incluso; aggiunti i
                             commenti ai metodi; modifiche di impaginazione
 10    18/04/2006 FTASSINARI modifica: get_intersecante_inizio => get_intersecato_inizio,
                             get_intersecante_fine => get_intersecato_fine,
                             aggiunto metodo get_intersecato
 11    28/09/2006 FTASSINARI Aggiunta rowid in alcuni metodi
 12    13/12/2006 FTASSINARI Sostituito carattere ampersand con 'and' per problemi
                             in esecuzione su SQL*Plus; aggiunta la WHEN ERROR IGNORE
 13    16/05/2007 FTASSINARI Aggiunta rowid in alcuni metodi
******************************************************************************/
   s_revisione constant varchar2(30) := 'v1.13';
   -- exceptions
   dal_not_found exception;
   pragma exception_init( dal_not_found, -20901 );
   dal_not_found_number constant binary_integer := -20901;
   al_not_found exception;
   pragma exception_init( al_not_found, -20902 );
   al_not_found_number constant binary_integer := -20902;
   pre_not_cont exception;
   pragma exception_init( pre_not_cont, -20903 );
   suc_not_cont exception;
   pragma exception_init( suc_not_cont, -20904 );
   pre_suc_not_cont exception;
   pragma exception_init( pre_suc_not_cont, -20905 );
   type t_periodo is record
   ( dal       date
   , al        date
   );
   -- versione e revisione
   function versione
   return varchar2;
   pragma restrict_references( versione, wnds );
   -- ritorna la data di inizio del periodo passato come parametro
   function get_data_inizio
   ( p_periodo            in t_periodo
   ) return date;
   -- ritorna la data di fine del periodo passato come parametro
   function get_data_fine
   ( p_periodo            in t_periodo
   ) return date;
   -- indica se il periodo indicato è incluso in un periodo di p_tabella
   function is_tutto_incluso
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   ) return number;
   -- indica se il periodo indicato è incluso in 2 periodi contigui di p_tabella
   function is_contigui_incluso
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   ) return number;
   -- indica se il periodo indicato è non incluso nei periodi di p_tabella
   function is_escluso
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   ) return number;
   -- indica se il periodo indicato interseca dei periodi di p_tabella
   function is_intersecato
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   ) return number;
   -- indica se il periodo indicato è contiguo su un estremo a un periodo di p_tabella
   function is_contiguo
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   ) return number;
   -- indica se il periodo indicato è contiguo su entrambi gli estremi a un periodo di p_tabella
   function is_tutto_contiguo
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   ) return number;
   -- indica se il periodo indicato ha gli estremi inclusi in periodi (di p_tabella) non contigui
   function is_estremi_inclusi
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   ) return number;
   -- controlla se i periodi di P_TABELLA che erano contenuti o intersecavano il periodo
   -- P_DAL_OLD-P_AL_OLD, sono contenuti nel periodo P_DAL_NEW-P_AL_NEW
   function is_contenitore
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal_old            in date
   , p_al_old             in date
   , p_dal_new            in date
   , p_al_new             in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   ) return number;
   --- controlla che i periodi nella tabella P_TABELLA non intersechino il periodo P_DAL-P_AL
   function is_contenitore
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   ) return number;
   -- predispone le registrazioni facendo in modo che le righe esistenti lascino il posto al DAL - AL
   -- indicato. Regista AL del periodo precedente = DAL-1 e DAL del periodo seguente = AL+1. Eventuali
   -- periodi inclusi vengono eliminati. Le operazioni devono essere eseguite sempre solamente sulle
   -- registrazioni relative ai "campi da controllare".
   procedure set_contigui
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   , p_con_buchi            in boolean default false
   );
   -- predispone le registrazione in modo che il periodo indicato sia l'ultimo: registrare AL del periodo
   -- precedente = DAL-1. Eventuali periodi inclusi vengono eliminati.
   procedure set_finale
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   );
   -- ripristina una condizione di continuita tra periodi contigui al periodo indicato
   procedure reset_contigui
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   );
   -- controlla se esistono periodi precedenti a quello passato come parametro
   function exists_precedenti
   ( p_tabella            in     varchar2
   , p_nome_dal           in     varchar2
   , p_nome_al            in     varchar2
   , p_dal                in     date
   , p_al                 in     date
   , p_campi_controllare  in     varchar2
   , p_valori_controllare in     varchar2
   , p_rowid              in     rowid default null
   ) return number;
   -- controlla se esistono periodi precedenti a quello passato come parametro (versione booleana)
   function existsPrecedenti
   ( p_tabella            in     varchar2
   , p_nome_dal           in     varchar2
   , p_nome_al            in     varchar2
   , p_dal                in     date
   , p_al                 in     date
   , p_campi_controllare  in     varchar2
   , p_valori_controllare in     varchar2
   , p_rowid              in     rowid default null
   ) return boolean;
   -- controlla se esistono periodi seguenti a quello passato come parametro
   function exists_seguenti
   ( p_tabella            in     varchar2
   , p_nome_dal           in     varchar2
   , p_nome_al            in     varchar2
   , p_dal                in     date
   , p_al                 in     date
   , p_campi_controllare  in     varchar2
   , p_valori_controllare in     varchar2
   , p_rowid              in     rowid default null
   ) return number;
   -- controlla se esistono periodi seguenti a quello passato come parametro (versione booleana)
   function existsSeguenti
   ( p_tabella            in     varchar2
   , p_nome_dal           in     varchar2
   , p_nome_al            in     varchar2
   , p_dal                in     date
   , p_al                 in     date
   , p_campi_controllare  in     varchar2
   , p_valori_controllare in     varchar2
   , p_rowid              in     rowid default null
   ) return boolean;
   -- controlla se esistono periodi contenuti a quello passato come parametro
   function exists_contenuti
   ( p_tabella            in     varchar2
   , p_nome_dal           in     varchar2
   , p_nome_al            in     varchar2
   , p_dal                in     date
   , p_al                 in     date
   , p_campi_controllare  in     varchar2
   , p_valori_controllare in     varchar2
   , p_rowid              in     rowid default null
   ) return number;
   -- controlla se esistono periodi contenuti a quello passato come parametro (versione booleana)
   function existsContenuti
   ( p_tabella            in     varchar2
   , p_nome_dal           in     varchar2
   , p_nome_al            in     varchar2
   , p_dal                in     date
   , p_al                 in     date
   , p_campi_controllare  in     varchar2
   , p_valori_controllare in     varchar2
   , p_rowid              in     rowid default null
   ) return boolean;
   -- controlla se esistono periodi intersecano quello passato come parametro
   function exists_intersecati
   ( p_tabella            in     varchar2
   , p_nome_dal           in     varchar2
   , p_nome_al            in     varchar2
   , p_dal                in     date
   , p_al                 in     date
   , p_campi_controllare  in     varchar2
   , p_valori_controllare in     varchar2
   , p_rowid              in     rowid default null
   ) return number;
   -- controlla se esistono periodi intersecano quello passato come parametro (versione booleana)
   function existsIntersecati
   ( p_tabella            in     varchar2
   , p_nome_dal           in     varchar2
   , p_nome_al            in     varchar2
   , p_dal                in     date
   , p_al                 in     date
   , p_campi_controllare  in     varchar2
   , p_valori_controllare in     varchar2
   , p_rowid              in     rowid default null
   ) return boolean;
   -- controlla se esistono periodi che non sono inclusi in quello passato come parametro
   function exists_non_inclusi
   ( p_tabella            in     varchar2
   , p_nome_dal           in     varchar2
   , p_nome_al            in     varchar2
   , p_dal                in     date
   , p_al                 in     date
   , p_campi_controllare  in     varchar2
   , p_valori_controllare in     varchar2
   , p_rowid              in     rowid default null
   ) return number;
   -- controlla se esistono periodi che non sono inclusi in quello passato come parametro (versione booleana)
   function existsNonInclusi
   ( p_tabella            in     varchar2
   , p_nome_dal           in     varchar2
   , p_nome_al            in     varchar2
   , p_dal                in     date
   , p_al                 in     date
   , p_campi_controllare  in     varchar2
   , p_valori_controllare in     varchar2
   , p_rowid              in     rowid default null
   ) return boolean;
   -- restituisce il primo periodo, tra i periodi contigui al periodo indicato,
   function get_primo
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date default null
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   , p_rowid              in varchar2 default null
   ) return t_periodo;
   -- restituisce la data di inizio del primo periodo, tra i periodi contigui al periodo indicato
   function get_primo_dal
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date default null
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   , p_rowid              in varchar2 default null
   ) return date;
   -- restituisce l'ultimo periodo, tra i periodi contigui al periodo indicato
   function get_ultimo
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_al                 in date default null
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   , p_rowid              in varchar2 default null
   ) return t_periodo;
   -- Restituisce la data di fine dell'ultimo periodo, tra i periodi contigui al periodo indicato
   function get_ultimo_al
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_al                 in date default null
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   , p_rowid              in varchar2 default null
   ) return date;
   -- indica se il periodo è il primo record, cercando tra i periodi contigui al periodo indicato
   function is_primo
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   ) return number;
   -- indica se il periodo è il primo record, cercando tra i periodi contigui al periodo indicato
   -- (versione booleana)
   function isPrimo
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   ) return boolean;
   -- indica se il periodo è l'ultimo record , cercando tra i periodi contigui al periodo indicato
   function is_ultimo
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   ) return number;
   -- indica se il periodo è l'ultimo record , cercando tra i periodi contigui al periodo indicato
   -- (versione booleana)
   function isUltimo
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   ) return boolean;
   -- ritorna il periodo precedente a quello passato come parametro
   function get_precedente
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   , p_rowid              in rowid default null
   ) return t_periodo;
   -- ritorna la data di inizio del periodo precedente a quello passato come parametro
   function get_precedente_dal
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   , p_rowid              in rowid default null
   ) return date;
   -- ritorna il periodo successivo a quello passato come parametro
   function get_seguente
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   , p_rowid              in rowid default null
   ) return t_periodo;
   -- ritorna la data di fine del periodo seguente a quello passato come parametro
   function get_seguente_al
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   , p_rowid              in rowid default null
   ) return date;
   -- ritorna il periodo contenuto a quello passato come parametro, con DAL piu vicino
   -- al DAL del periodo in esame
   function get_contenuto
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   , p_rowid              in rowid default null
   ) return t_periodo;
   -- ritorna il periodo intersecato nell'estremo di sx a quello passato come parametro,
   -- con DAL piu lontano al DAL del periodo in esame
   function get_intersecato_inizio
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   , p_rowid              in rowid default null
   ) return t_periodo;
   -- ritorna il periodo intersecato nell'estremo di dx a quello passato come parametro,
   --- con DAL piu vicino al DAL del periodo in esame
   function get_intersecato_fine
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   , p_rowid              in rowid default null
   ) return t_periodo;
   -- ritorna il periodo che interseca il periodo indicato
   function get_intersecato
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   , p_rowid              in rowid default null
   ) return t_periodo;
   -- ritorna il primo periodo non incluso in quello passato come parametro,
   -- con DAL piu vicino al DAL del periodo in esame
   function get_non_incluso
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   , p_rowid              in rowid default null
   ) return t_periodo;
   -- ritorna il periodo totale composto dai periodi contigui a quello passato come parametro
   function get_contiguo
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   , p_rowid              in varchar2 default null
   ) return t_periodo;
end AFC_Periodo;
/

