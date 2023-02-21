CREATE OR REPLACE package body AFC_Periodo is
/******************************************************************************
 NOME:        AFC_Periodo.
 DESCRIZIONE: Gestione tabelle con periodi.
 ANNOTAZIONI: .
 REVISIONI:   .
 Rev.  Data       Autore     Descrizione.
 ----  ---------- ---------- ------------------------------------------------------
 000   07/04/2005 SN         Prima emissione.
 001   16/06/2005 FTASSINARI aggiunta dei metodi set_contigui, set_finale,
                             get_seguente e get_precedente
 002   23/06/2005 FTASSINARI aggiunta dei metodi reset_contigui, exists_precedente,
                             exists_seguente e exists_contenuto
 003   30/06/2005 FTASSINARI aggiunta dei metodi get_contenuto, is_tutto_contiguo,
                             get_intersecato_sx, get_intersecato_dx, exists_intersecati,
                             get_periodo_contiguo
                             modifica dei metodi EZTRAZIONE_CONDIZIONE
 004   16/08/2005 FTASSINARI aggiunta dei metodi is_contenitore e modifica di
                             get_contiguo
 005   23/09/2005 FTASSINARI aggiunta dei metodi get_inizio_periodo, get_fine_periodo
                             get_primo, get_ultimo, is_primo, is_ultimo
 006   27/09/2005 FTASSINARI modifica: get_inizio_periodo => get_data_inizio;
                             get_fine_periodo => get_data_fine; get_intersecato_sx => get_intersecante_inizio;
                             get_intersecato_dx => get_intersecante_fine;
                             aggiunta: get_primo_dal; get_ultimo_al;
                             get_precedente_dal; get_seguente_al; modifica dimensioni
                             identificatori
 007   28/09/2005 FTASSINARI modifica in get_primo, get_ultimo, get_primo_dal
                             get_primo_al; utilizzo di estrazione_val in vari metodi e
                             aggiunta di to_char(...) nella select
 008   30/09/2005 FTASSINARI eliminata dipendenza da AFC
 009   06/04/2006 FTASSINARI aggiunti metodi exists_non_inclusi e get_non_incluso, sostituiti
                             data_type e costanti con oggetti standard di AFC e AFC_Error,
                             modifiche di impaginazione
 010   06/04/2006 FTASSINARI modifica: get_intersecante_inizio => get_intersecato_inizio,
                             get_intersecante_fine => get_intersecato_fine,
                             aggiunto metodo get_intersecato
 011   19/04/2006 FTASSINARI modifica in get_precedente e get_seguente: controllo spostato sulla
                             data di inizio del periodo periodo
 012   28/04/2006 FTASSINARI modifica in get_primo, get_ultimo e get_non_incluso per problemi
                             con periodi aperti
 013   28/09/2006 FTASSINARI Aggiunta rowid in alcuni metodi
 014   16/05/2007 FTASSINARI Aggiunto nvl e conversione corretta su parametri p_dal e p_al in
                             alcuni; aggiunta rowid in alcuni metodi; aggiunto
 015   14/08/2007 FTASSINARI Aggiunto controllo integrita sui parametri in input (check_parametri)
 016   17/10/2008 MM         Modificata funzione get_non_incluso.
 017   25/11/2009 FTASSINARI Tolto controllo su p_campi_controllare in check_parametri
 018   17/12/2009 FTASSINARI Reso utilizzabile i metodi anche per viste e sinonimi
******************************************************************************/
   s_revisione_body           constant varchar2(30) := '018';
   type parametri is record
   ( nome_dal       varchar2 (30)
   , nome_al        varchar2 (30)
   , frase_select   varchar2 (32000)
   , in_dal         varchar2 (10)
   , in_al          varchar2 (10)
   , out_dal        varchar2 (10)
   , out_al         varchar2 (10)
   );
----------------------------------------------------------------------------------
   function versione
   return varchar2 is
   /******************************************************************************
    NOME:        versione.
    DESCRIZIONE: Versione e revisione di distribuzione del package.
    RITORNA:     varchar2 stringa contenente versione e revisione.
    NOTE:        Primo numero  : versione compatibilit� del Package.
                 Secondo numero: revisione del Package specification.
                 Terzo numero  : revisione del Package body.
   ******************************************************************************/
      d_result varchar2(10);
   begin
      d_result := s_revisione||'.'||s_revisione_body;
      return d_result;
   end; -- AFC_PERIODO.versione
----------------------------------------------------------------------------------
   function check_parametri
   ( p_tabella in varchar2
   , p_nome_dal in varchar2
   , p_nome_al in varchar2
   ) return integer
   /******************************************************************************
    NOME:        check_parametri
    DESCRIZIONE: Controlla la correttezza delle informazioni
                 relative alla tabella, passate come parametro
    PARAMETRI:   p_tabella            IN VARCHAR2: nome tavola da analizzare
                 p_nome_dal           IN VARCHAR2: nome colonna inizio periodo
                 p_nome_al            IN VARCHAR2: nome colonna fine periodo
    ECCEZIONI:   --
    ANNOTAZIONI: --
    RITORNO:     1: i parametri sono ok
                 0: i parametri non sono ok
    REVISIONI:
    Rev. Data       Autore     Descrizione
    ---- ---------- ---------- ------------------------------------------------------
    0    13/08/2007 FTASSINARI Prima emissione.
    017  25/11/2009 FTASSINARI Tolto controllo su p_campi_controllare
    018  17/12/2009 FTASSINARI Reso utilizzabile i metodi anche per viste e sinonimi
   ********************************************************************************/
   is
      d_result afc_error.t_error_number := afc_error.ok;
   begin
      -- controllo nome table
      if afc_ddl.IsTable( p_table_name => p_tabella )
      or afc_ddl.IsView( p_view_name => p_tabella )
      or afc_ddl.IsSynonym( p_synonym_name => p_tabella )
      then
         d_result := afc_error.ok;
      else
         d_result := 0;
      end if;
      -- controllo nome campo inizio periodo
      if  d_result = afc_error.ok
      and afc_ddl.HasAttribute( p_object_name => p_tabella
                              , p_attribute_name => p_nome_dal
                              )
      then
         d_result := afc_error.ok;
      else
         d_result := 0;
      end if;
      -- controllo nome campo fine periodo
      if d_result = afc_error.ok
      and afc_ddl.HasAttribute( p_object_name => p_tabella
                              , p_attribute_name => p_nome_al
                              )
      then
         d_result := afc_error.ok;
      else
         d_result := 0;
      end if;
      return d_result;
   end;
----------------------------------------------------------------------------------
   procedure crea_select
   ( p_nome_dal in     varchar2
   , p_nome_al  in     varchar2
   , p_tabella  in     varchar2
   , p_select   in out varchar2
   ) is
   /******************************************************************************
   NOME:        crea_select
   DESCRIZIONE: Compone la frase di select
   PARAMETRI:   P_NOME_DAL:           nome della colonna nella quale cercare il
                                      valore P_DAL
                P_NOME_AL:            nome della colonna nella quale cercare il
                                      valore P_AL
                P_TABELLA:            nome della tabella sulla quale eseguire la
                                      ricerca
                P_SELECT:             parametro di output nel quale viene memorizzata
                                      la frase di select
   RITORNA:     --
   ECCEZIONI:   --
   ANNOTAZIONI: --
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    21/06/2005 FT         Creazione.
   ******************************************************************************/
   begin
      p_select := 'select to_char(nvl('
               || p_nome_dal
               || ',to_date(''2222222'',''j'')),''ddmmyyyy''), to_char(nvl('
               || p_nome_al
               || ',to_date(''3333333'',''j'')),''ddmmyyyy'')'
               || ' from '
               || p_tabella;
   end;
----------------------------------------------------------------------------------
   procedure crea_statement
   ( tipo        in     integer
   , p_campo_1   in     varchar2
   , p_campo_2   in     varchar2
   , p_val_1     in     varchar2
   , p_val_2     in     varchar2
   , p_tabella   in     varchar2
   , p_statement in out varchar2
   ) is
   /******************************************************************************
      NOME:        crea_statement
      DESCRIZIONE: crea lo statement da eseguire (update o delete)
      ARGOMENTI:   TIPO:       definisce lo statement che si vuole eseguire:
                               - 0: update P_TABELLA
                                    set P_CAMPO_2 = ( to_date( P_VAL_1, 'ddmmyyyy' ) - 1 )
                               - 1: update P_TABELLA
                                    set P_CAMPO_1 = ( to_date( P_VAL_2, 'ddmmyyyy' ) + 1 )
                               - 2: delete from P_TABELLA
                   p_campo_1:  nome dell'attributo relativo al primo estremo del
                               periodo
                   p_campo_2:  nome dell'attributo relativo al secondo estremo del
                               periodo
                   p_val_1:    valore del primo estremo del periodo
                   p_val_2:    valore del secondo estremo del periodo
                   p_tabella:  nome della tabella nella quale devo operare
                   P_campi:    viene valorizzata con la stringa che contiene le
                               condizioni da controllare.
      ECCEZIONI:   --
      ANNOTAZIONI: --
      REVISIONI:
      Rev. Data       Autore     Descrizione
      ---- ---------- ---------- ------------------------------------------------------
      0    16/06/2005 FTassinari Prima emissione.
   ********************************************************************************/
   begin
      if tipo = 0 then -- caso 0:
         p_statement := 'update '|| p_tabella
                     || ' set ' || p_campo_2 || ' = ( nvl( to_date( ''' || p_val_1 || ''', ''ddmmyyyy'' ), to_date( ''3333333'',''j'' ) )  - 1 )';
      else if tipo = 1 then -- caso 1:
              p_statement := 'update '|| p_tabella
                          || ' set ' || p_campo_1 || ' = ( nvl( to_date( ''' || p_val_2 || ''', ''ddmmyyyy'' ), to_date( ''2222222'', ''j'' ) ) + 1 )';
           else if tipo = 2 then -- caso 2:
                   p_statement := 'delete from '|| p_tabella;
                end if;
           end if;
       end if;
   end;
----------------------------------------------------------------------------------
   procedure estrazione_condizioni_periodo
   ( tipo           in     integer
   , con_buchi      in     boolean
   , p_tabella      in     varchar2
   , p_nome_dal     in     varchar2
   , p_nome_al      in     varchar2
   , p_dal          in     varchar2
   , p_al           in     varchar2
   , p_statement    in out varchar2
   ) is
   /******************************************************************************
   NOME:        estrazione_condizioni_periodo
   DESCRIZIONE: estrazione condizioni da verificare sul record,
                crea le stringhe per lo statement successivo
   ARGOMENTI:   TIPO:        definisce le condizioni di ricerca relative agli
                             estremi dei periodi:
                             - 0: cerco i record in cui il periodo ha DAL < P_DAL
                                  e AL > P_DAL (intersecati a sx)
                             - 1: cerco i record in cui il periodo ha DAL > P_DAL
                                  e AL > P_AL (intersecati a dx)
                             - 2: cerco i record in cui il periodo ha DAL > P_DAL
                                  e AL < P_DAL (contenuti)
                             - 3: cerco i record in cui il periodo ha DAL > P_AL
                                  e AL > P_AL (esclusi a dx)
                con_buchi:            indica se vogliamo che vengano resi contigui
                                      anche l'eventuale periodo precedenti (o
                                      successivo) piu vicino al periodo in esame (caso
                                      FALSE, default) oppure solo i periodi
                                      intersecati al periodo in esame (caso TRUE)
                p_tabella:  nome della tabella nella quale devo operare
                p_nome_dal:  nome dell'attributo relativo al primo estremo del
                             periodo
                p_nome_al:   nome dell'attributo relativo al secondo estremo del
                             periodo
                p_dal:       valore del primo estremo del periodo
                p_al:        valore del secondo estremo del periodo
                P_statement: viene valorizzata con la stringa che contiene le
                             condizioni da controllare.
   ECCEZIONI:   --
   ANNOTAZIONI: --
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ------------------------------------------------------
   0    16/06/2005 FTassinari Prima emissione.
   1    30/06/2005 FTassinari aggiunta nelle condizioni dell'elaborazione di
                              periodi "aperti"
   ********************************************************************************/
   begin
      if tipo = 0 then -- caso tipo = 0
         p_statement := p_statement || ' nvl( ' || p_nome_dal || ', to_date(''2222222'',''j'')) '
                     || ' < to_date( ''' || p_dal || ''', afc.date_format ) and '
                     || ' nvl( ' || p_nome_al || ' ,to_date(''3333333'',''j''))'
                     || ' > to_date( ''' || p_dal || ''', afc.date_format )';
         if not con_buchi then
            p_statement := p_statement || ' or nvl( ' || p_nome_al || ' ,to_date(''3333333'',''j''))'
                        || ' = (select max( nvl( ' || p_nome_al || ' ,to_date(''3333333'',''j'')))'
                        || ' from ' || p_tabella
                        || ' where nvl( ' || p_nome_al || ' ,to_date(''3333333'',''j'')) '
                        || ' < to_date( ''' || p_dal || ''', afc.date_format ) )';
         end if;
      else if tipo = 1 then -- caso tipo = 1
              p_statement := p_statement || ' nvl( ' || p_nome_dal || ', to_date(''2222222'',''j'')) '
                          || ' > to_date( ''' || p_dal || ''', afc.date_format ) and '
                          || ' nvl( ' || p_nome_dal || ', to_date(''2222222'',''j'')) '
                          || ' < to_date( ''' || p_al || ''', afc.date_format ) and '
                          || ' nvl( ' || p_nome_al ||  ', to_date(''3333333'',''j'')) '
                          ||' > to_date( ''' || p_al || ''', afc.date_format )';
              if not con_buchi then
                 p_statement := p_statement || ' or nvl( ' || p_nome_dal || ' ,to_date(''3333333'',''j''))'
                             || ' = (select min( nvl( ' || p_nome_dal || ' ,to_date(''2222222'',''j'')))'
                             || ' from ' || p_tabella
                             || ' where nvl( ' || p_nome_dal || ' ,to_date(''2222222'',''j'')) '
                             || ' > to_date( ''' || p_al || ''', afc.date_format ) )';
              end if;
           else if tipo = 2 then -- caso tipo = 2
                   p_statement := p_statement || ' nvl( ' || p_nome_dal || ', to_date(''2222222'',''j'')) '
                               || ' >= to_date( ''' || p_dal || ''', afc.date_format ) and '
                               || ' nvl( ' || p_nome_al || ', to_date(''2222222'', ''j'')) '
                               || ' <= to_date( ''' || p_al || ''', afc.date_format )';
                else if tipo = 3 then -- caso tipo = 3
                        p_statement := p_statement || ' nvl( ' || p_nome_dal || ', to_date( ''2222222'', ''j'')) '
                                    || ' > to_date( ''' || p_al || ''', afc.date_format ) and '
                                    || ' nvl( ' || p_nome_al || ', to_date(''2222222'', ''j'')) '
                                    || ' > to_date( ''' || p_al || ''', afc.date_format ) ';
                     end if;
                end if;
           end if;
      end if;
   end; -- AFC_Periodo.estrazione_condizioni_periodo;
----------------------------------------------------------------------------------
   procedure estrazione_condizioni
   ( p_campi_controllare  in     varchar2
   , p_valori_controllare in     varchar2
   , p_campi              in out varchar2
   ) is
   /******************************************************************************
      NOME:        estrazione_condizioni
      DESCRIZIONE: estrazione condizioni da verificare sul record,
                   crea le stringhe per lo statement successivo
      ARGOMENTI:   p_campi_controllare  IN VARCHAR2: elenco campi da controllare
                   p_valori_controllare IN VARCHAR2: elenco valori da controllare
                   P_campi          IN OUT VARCHAR2: viene valorizzata con la
                                                     stringa che contiene le
                                                     condizioni da controllare.
      ECCEZIONI:
      ANNOTAZIONI: Gli elenchi sono separati dal carattere '#'
      REVISIONI:
      Rev. Data       Autore Descrizione
      ---- ---------- ------ ------------------------------------------------------
      0    02/12/2002 SN     Prima emissione.
   ********************************************************************************/
      i           number          := 0;
      n           number          := 0;
      d_dato      varchar2 (2000);
      d_campo     varchar2 (2000) := to_char (null);
      d_operatore varchar2 (6);
   begin
      i := 2;
      p_campi := ' where ';
      while instr( p_campi_controllare, '#', 1, i ) != 0
      loop
         -- fin quando ci sono campi da controllare
         d_campo := substr( p_campi_controllare
                          , instr (p_campi_controllare, '#', 1, i - 1) + 1
                          , instr (p_campi_controllare, '#', 1, i) - 1
                          - instr (p_campi_controllare, '#', 1, i - 1)
                          );
         -- controllo l'operatore da utilizzare
         if substr( p_valori_controllare
                  , instr( p_valori_controllare, '#', 1, i - 1 ) + 1
                  , 2
                  ) = '>=' then
            d_operatore := ' >= ';
            n := 2;
         elsif substr( p_valori_controllare
                     , instr( p_valori_controllare, '#', 1, i - 1 ) + 1
                     , 2
                     ) = '=>' then
            d_operatore := ' >= ';
            n := 2;
         elsif substr( p_valori_controllare
                     , instr( p_valori_controllare, '#', 1, i - 1 ) + 1
                     , 2
                     ) = '<=' then
            d_operatore := ' <= ';
            n := 2;
         elsif substr( p_valori_controllare
                     , instr( p_valori_controllare, '#', 1, i - 1 ) + 1
                     , 2
                     ) = '=<' then
            d_operatore := ' <= ';
            n := 2;
         elsif substr( p_valori_controllare
                     , instr( p_valori_controllare, '#', 1, i - 1 ) + 1
                     , 2
                     ) = '<>' then
            d_operatore := ' <> ';
            n := 2;
         elsif substr( p_valori_controllare
                     , instr( p_valori_controllare, '#', 1, i - 1 ) + 1
                     , 2
                     ) = '!=' then
            d_operatore := ' != ';
            n := 2;
         elsif substr( p_valori_controllare
                     , instr( p_valori_controllare, '#', 1, i - 1 ) + 1
                     , 2
                     ) = '==' then
            d_operatore := ' = ';
            n := 2;
         elsif substr( p_valori_controllare
                     , instr( p_valori_controllare, '#', 1, i - 1 ) + 1
                     , 2
                     ) = '=%' then
            d_operatore := ' like ';
            n := 2;
         elsif substr( p_valori_controllare
                     , instr( p_valori_controllare, '#', 1, i - 1 ) + 1
                     , 1
                     ) = '<' then
            d_operatore := ' < ';
            n := 1;
         elsif substr( p_valori_controllare
                     , instr( p_valori_controllare, '#', 1, i - 1 ) + 1
                     , 1
                     ) = '>' then
            d_operatore := ' > ';
            n := 1;
         elsif substr( p_valori_controllare
                     , instr( p_valori_controllare, '#', 1, i - 1 ) + 1
                     , 1
                     ) = '=' then
            d_operatore := ' = ';
            n := 1;
         else
            d_operatore := ' = ';
            n := 0;
         end if;
         d_dato := substr( p_valori_controllare
                         , instr( p_valori_controllare, '#', 1, i - 1 ) + 1 + n
                         , instr( p_valori_controllare, '#', 1, i ) - 1
                         - instr (p_valori_controllare, '#', 1, i - 1 ) - n
                         );
         if d_dato is null
         then
            p_campi := p_campi || d_campo || ' is null and ';
         else
            -- valore non nullo
            p_campi := p_campi
                    || d_campo
                    || d_operatore || ''''
                    || replace (d_dato, '''', '''''')
                    || ''' and ';
         end if;
         i := i + 1;
      end loop;
   end estrazione_condizioni;
----------------------------------------------------------------------------------
   function estrazione_val
   ( p_stringa in     varchar2
   , p_out_dal in out varchar2
   , p_out_al  in out varchar2
   ) return number
   /******************************************************************************
      NOME:        estrazione_val
      DESCRIZIONE: esecuzione sql dinamico con estrazione del valore trovato
      ARGOMENTI:   p_stringa IN VARCHAR2: statement da eseguire
      ECCEZIONI:
      ANNOTAZIONI: In caso di errore ritorna -1 che viene controllato dal chiamante
      REVISIONI:
      Rev. Data       Autore Descrizione
      ---- ---------- ------ ------------------------------------------------------
      0    05/04/2005 SN     Prima emissione.
   ******************************************************************************/
   is
      trovato          number;
      cursor_name      integer;
      rows_processed   integer;
   begin
      trovato := 0;
      cursor_name := dbms_sql.open_cursor;
      dbms_sql.parse (cursor_name, p_stringa, dbms_sql.native);
      dbms_sql.define_column (cursor_name, 1, p_out_dal, 10);
      dbms_sql.define_column (cursor_name, 2, p_out_al, 10);
      rows_processed := dbms_sql.execute (cursor_name);
      if dbms_sql.fetch_rows (cursor_name) > 0
      then
         dbms_sql.column_value (cursor_name, 1, p_out_dal);
         dbms_sql.column_value (cursor_name, 2, p_out_al);
         trovato := AFC_Error.ok;
      else
         trovato := 0;
      end if;
      dbms_sql.close_cursor (cursor_name);
      return trovato;
   exception
      when others then
         dbms_sql.close_cursor (cursor_name);
         return -1;
         raise;
   end estrazione_val;
----------------------------------------------------------------------------------
   function controlla_inclusione
   ( v_parametri       in out parametri
   , p_tipo_inclusione in     varchar2
   ) return number
   /******************************************************************************
   NOME:        controlla_inclusione
   DESCRIZIONE: Compone la frase di select per la parte di inclusione
   PARAMETRI:   V_PARAMETRI:          contiene le informazioni della frase di select
                P_TIPO_INCLUCIONE:    tipo di inclusione
   RITORNA:     La frase di select
   ECCEZIONI:   --
   ANNOTAZIONI: --
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    21/06/2005 FT         Creazione.
   ******************************************************************************/
   is
      d_data_controllare   varchar2 (10);
      d_statement          varchar2 (32000);
   begin
      if p_tipo_inclusione = 'dal'
      then
         d_data_controllare := v_parametri.in_dal;
      else
         d_data_controllare := v_parametri.in_al;
      end if;
      d_statement := v_parametri.frase_select
                  || ' to_date('''
                  || d_data_controllare
                  || ''',''ddmmyyyy'') between nvl('
                  || v_parametri.nome_dal
                  || ',to_date(''2222222'',''j'')) and nvl('
                  || v_parametri.nome_al
                  || ',to_date(''3333333'',''j''))';
      return estrazione_val( d_statement
                           , v_parametri.out_dal
                           , v_parametri.out_al
                           );
   end;
----------------------------------------------------------------------------------
   function controlla_inclusione_al
   ( v_parametri in out parametri
   ) return number
   /******************************************************************************
   NOME:        controlla_inclusione_al
   DESCRIZIONE: Compone la frase di select per la parte di inclusione sul campo AL
   PARAMETRI:   V_PARAMETRI:          contiene le informazioni della frase di select
   RITORNA:     La frase di select
   ECCEZIONI:   --
   ANNOTAZIONI: --
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    21/06/2005 FT         Creazione.
   ******************************************************************************/
   is
   begin
      return controlla_inclusione( v_parametri, 'al' );
   end;
----------------------------------------------------------------------------------
   function controlla_inclusione_dal
   ( v_parametri in out parametri
   ) return number
   /******************************************************************************
   NOME:        controlla_inclusione_dal
   DESCRIZIONE: Compone la frase di select per la parte di inclusione sul campo DAL
   PARAMETRI:   V_PARAMETRI:          contiene le informazioni della frase di select
   RITORNA:     La frase di select
   ECCEZIONI:   --
   ANNOTAZIONI: --
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    21/06/2005 FT         Creazione.
   ******************************************************************************/
   is
   begin
      return controlla_inclusione( v_parametri, 'dal' );
   end;
----------------------------------------------------------------------------------
   function get_data_inizio
   ( p_periodo            in t_periodo
   ) return date
   /******************************************************************************
      NOME:        get_data_inizio
      DESCRIZIONE: ritorna la data di inizio del periodo passato come parametro
      ARGOMENTI:   P_PERIODO: periodo in esame
      ECCEZIONI:
      ANNOTAZIONI: --
      REVISIONI:
      Rev. Data       Autore     Descrizione
      ---- ---------- ---------- ------------------------------------------------------
      0    23/09/2005 FTASSINARI Prima emissione.
   ******************************************************************************/
   is
      d_data date;
   begin
      d_data := p_periodo.dal;
      return d_data;
   end; -- AFC_Periodo.get_data_inizio
----------------------------------------------------------------------------------
   function get_data_fine
   ( p_periodo            in t_periodo
   ) return date
   /******************************************************************************
      NOME:        get_data_fine
      DESCRIZIONE: ritorna la data di fine del periodo passato come parametro
      ARGOMENTI:   P_PERIODO: periodo in esame
      ECCEZIONI:
      ANNOTAZIONI: --
      REVISIONI:
      Rev. Data       Autore     Descrizione
      ---- ---------- ---------- ------------------------------------------------------
      0    23/09/2005 FTASSINARI Prima emissione.
   ******************************************************************************/
   is
      d_data date;
   begin
      d_data := p_periodo.al;
      return d_data;
   end; -- AFC_Periodo.get_data_fine
----------------------------------------------------------------------------------
   procedure is_incluso
   ( p_tabella            in     varchar2
   , p_nome_dal           in     varchar2
   , p_nome_al            in     varchar2
   , p_dal                in     date
   , p_al                 in     date
   , p_campi_controllare  in     varchar2
   , p_valori_controllare in     varchar2
   , p_parametri          in out parametri
   )
   /******************************************************************************
   NOME:        is_incluso
   DESCRIZIONE: is_incluso
   PARAMETRI:   p_tabella IN VARCHAR2: nome tavola da analizzare
                p_nome_dal IN VARCHAR2: nome colonna fine periodo
                p_nome_al IN VARCHAR2: nome colonna inizio periodo
                p_dal IN DATE: data di confronto
                p_campi_controllare IN VARCHAR2: elenco campi da controllare
                p_valori_controllare IN VARCHAR2: elenco valori da controllare
                p_parametri IN VARCHAR2: contiene le informazizoni della frase di select
   RITORNA:     --
   ECCEZIONI:   --
   ANNOTAZIONI: --
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    21/06/2005 FT         Creazione.
   ******************************************************************************/
   is
      d_select  varchar2 (32000);
      d_campi   varchar2 (32000);
   begin
      p_parametri.in_dal := to_char( nvl( p_dal, to_date ('2222222', 'j') ), 'ddmmyyyy' );
      p_parametri.in_al :=  to_char( nvl( p_al, to_date ('3333333', 'j') ), 'ddmmyyyy' );
      estrazione_condizioni( p_campi_controllare
                           , p_valori_controllare
                           , d_campi
                           );
      crea_select( p_nome_dal
                 , p_nome_al
                 , p_tabella
                 , d_select
                 );
      d_select := d_select || d_campi;
      p_parametri.nome_dal := p_nome_dal;
      p_parametri.nome_al := p_nome_al;
      p_parametri.frase_select := d_select;
 --     p_parametri.out_dal := v_parametri.out_dal;
 --     p_parametri.out_al := v_parametri.out_al;
  end is_incluso;
----------------------------------------------------------------------------------
   function is_intersecato
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   ) return number
   /******************************************************************************
   NOME:        is_intersecato
   DESCRIZIONE: Controlla se il periodo � intersecato con altri periodi della tabella,
                in base alle condizioni passate
   PARAMETRI:   p_tabella IN VARCHAR2: nome tavola da analizzare
                p_nome_dal IN VARCHAR2: nome colonna fine periodo
                p_nome_al IN VARCHAR2: nome colonna inizio periodo
                p_dal IN DATE: data di confronto
                p_campi_controllare IN VARCHAR2: elenco campi da controllare
                p_valori_controllare IN VARCHAR2: elenco valori da controllare
   RITORNA:     --
   ECCEZIONI:   --
   ANNOTAZIONI: --
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    21/06/2005 FT         Creazione.
   15   16/07/2007 FT         Aggiunto controllo integrita sui parametri in input (check_parametri)
   17   25/11/2009 FT         Tolto controllo su p_campi_controllare in check_parametri
   ******************************************************************************/
   is
      v_parametri  parametri;
      v_ritorno number;
   begin
      DbC.PRE( not DbC.PreOn or afc.to_boolean( check_parametri( p_tabella
                                                               , p_nome_dal
                                                               , p_nome_al
                                                               )
                                              )
             , ' check_parametri on AFC_PERIODO.is_intersecato'
             );
      is_incluso( p_tabella
                , p_nome_dal
                , p_nome_al
                , p_dal
                , p_al
                , p_campi_controllare
                , p_valori_controllare
                , v_parametri
                );
      v_ritorno := controlla_inclusione_dal (v_parametri);
      if v_ritorno = 1
      then
        if to_date (v_parametri.in_al, 'ddmmyyyy')
                between to_date (v_parametri.out_dal, 'ddmmyyyy')
                    and to_date (v_parametri.out_al, 'ddmmyyyy')
        then
           v_ritorno := 0;
        end if;
      else
         v_ritorno := controlla_inclusione_al (v_parametri);
         if v_ritorno = 1
            and to_date (v_parametri.in_dal, 'ddmmyyyy')
                between to_date (v_parametri.out_dal, 'ddmmyyyy')
                    and to_date (v_parametri.out_al, 'ddmmyyyy')
         then
            v_ritorno := 0;
         end if;
      end if;
      return v_ritorno;
   end;
----------------------------------------------------------------------------------
   function is_contiguo
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   ) return number
   /******************************************************************************
   NOME:        is_contiguo
   DESCRIZIONE: Controlla se il periodo � contiguo ad altri periodi della tabella,
                in base alle condizioni passate
   PARAMETRI:   p_tabella IN VARCHAR2: nome tavola da analizzare
                p_nome_dal IN VARCHAR2: nome colonna fine periodo
                p_nome_al IN VARCHAR2: nome colonna inizio periodo
                p_dal IN DATE: data di confronto
                p_campi_controllare IN VARCHAR2: elenco campi da controllare
                p_valori_controllare IN VARCHAR2: elenco valori da controllare
   RITORNA:     --
   ECCEZIONI:   --
   ANNOTAZIONI: --
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    21/06/2005 FT         Creazione.
   15   16/07/2007 FT         Aggiunto controllo integrita sui parametri in input (check_parametri)
   17   25/11/2009 FT         Tolto controllo su p_campi_controllare in check_parametri
   ******************************************************************************/
   is
      v_parametri  parametri;
      v_ritorno number;
   begin
      DbC.PRE( not DbC.PreOn or afc.to_boolean( check_parametri( p_tabella
                                                               , p_nome_dal
                                                               , p_nome_al
                                                               )
                                              )
             , ' check_parametri on AFC_PERIODO.is_contiguo'
             );
      is_incluso( p_tabella
                , p_nome_dal
                , p_nome_al
                , p_dal
                , p_al
                , p_campi_controllare
                , p_valori_controllare
                , v_parametri
                );
      v_parametri.in_dal := to_char( to_date (v_parametri.in_dal, 'ddmmyyyy') - 1
                                   , 'ddmmyyyy'
                                   );
      v_ritorno := controlla_inclusione_dal( v_parametri );
      if v_ritorno = 1
      then
         if v_parametri.in_dal != v_parametri.out_al
         then
            v_ritorno := 0;
            v_parametri.in_al := to_char( to_date( v_parametri.in_al
                                                 , 'ddmmyyyy'
                                                 ) + 1
                                        , 'ddmmyyyy'
                                        );
            v_ritorno := controlla_inclusione_al( v_parametri );
            if v_ritorno = 1
            then
               if v_parametri.in_al != v_parametri.out_dal
               then
                  v_ritorno := 0;
               end if;
            end if;
         end if;
      end if;
      return v_ritorno;
   end;
----------------------------------------------------------------------------------
   function is_tutto_contiguo
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   ) return number
   /******************************************************************************
    NOME:        is_tutto_contiguo
    DESCRIZIONE: controlla il periodo passato come parametro e contiguo sia a sx
                 che a dx
    PARAMETRI:   P_TABELLA:            nome della tabella sulla quale eseguire la
                                       ricerca
                 P_NOME_DAL:           nome della colonna nella quale cercare il
                                       valore P_DAL
                 P_NOME_AL:            nome della colonna nella quale cercare il
                                       valore P_AL
                 P_DAL:                valore da cercare nella colonna P_NOME_DAL
                 P_AL:                 valore da cercare nella colonna P_NOME_AL
                 P_CAMPI_CONTROLLARE:  nomi delle colonne sulle quali cercare i
                                       valore VALORI_CONTROLLARE
                 P_VALORI_CONTROLLARE: valori da controllare nelle colonne
                                       P_CAMPI_CONTROLLARE
    RITORNA:     AFC_Error.ok se contiguo, o altrimenti
    ECCEZIONI:   --
    ANNOTAZIONI: --
    REVISIONI:
    Rev. Data       Autore     Descrizione
    ---- ---------- ---------- ---------------------------------------------------
    0    04/07/2005 FTASSINARI Creazione.
    15   16/07/2007 FT         Aggiunto controllo integrita sui parametri in input (check_parametri)
    17   25/11/2009 FT         Tolto controllo su p_campi_controllare in check_parametri
    ******************************************************************************/
   is
      v_parametri  parametri;
      v_ritorno number;
   begin
      DbC.PRE( not DbC.PreOn or afc.to_boolean( check_parametri( p_tabella
                                                               , p_nome_dal
                                                               , p_nome_al
                                                               )
                                              )
             , ' check_parametri on AFC_PERIODO.is_tutto_contiguo'
             );
      is_incluso( p_tabella
                , p_nome_dal
                , p_nome_al
                , p_dal
                , p_al
                , p_campi_controllare
                , p_valori_controllare
                , v_parametri
                );
      -- controllo la contiguita sull'estremo sx
      v_parametri.in_dal := to_char( to_date (v_parametri.in_dal, 'ddmmyyyy') - 1
                                   , 'ddmmyyyy'
                                   );
      v_ritorno := controlla_inclusione_dal( v_parametri );
      if v_ritorno = AFC_Error.ok
      then
         if v_parametri.in_dal = v_parametri.out_al
         then
            -- controllo la contiguita sull'estremo dx
            v_parametri.in_al := to_char( to_date (v_parametri.in_al, 'ddmmyyyy') + 1
                                        , 'ddmmyyyy'
                                        );
            v_ritorno := controlla_inclusione_al( v_parametri );
            if v_ritorno = AFC_Error.ok
            then
               if v_parametri.in_al != v_parametri.out_dal
               then
                  v_ritorno := 0;
               end if;
            end if;
         else
            v_ritorno := 0;
         end if;
      end if;
      return v_ritorno;
   end;
----------------------------------------------------------------------------------
   function is_escluso
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   ) return number
   /******************************************************************************
   NOME:        is_escluso
   DESCRIZIONE: Controlla se il periodo � escluso da altri periodi della tabella,
                in base alle condizioni passate
   PARAMETRI:   p_tabella IN VARCHAR2: nome tavola da analizzare
                p_nome_dal IN VARCHAR2: nome colonna fine periodo
                p_nome_al IN VARCHAR2: nome colonna inizio periodo
                p_dal IN DATE: data di confronto
                p_campi_controllare IN VARCHAR2: elenco campi da controllare
                p_valori_controllare IN VARCHAR2: elenco valori da controllare
   RITORNA:     --
   ECCEZIONI:   --
   ANNOTAZIONI: --
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    21/06/2005 FT         Creazione.
   15   16/07/2007 FT         Aggiunto controllo integrita sui parametri in input (check_parametri)
   17   25/11/2009 FT         Tolto controllo su p_campi_controllare in check_parametri
   ******************************************************************************/
   is
      v_parametri  parametri;
      v_ritorno number;
   begin
      DbC.PRE( not DbC.PreOn or afc.to_boolean( check_parametri( p_tabella
                                                               , p_nome_dal
                                                               , p_nome_al
                                                               )
                                              )
             , ' check_parametri on AFC_PERIODO.is_escluso'
             );
      is_incluso( p_tabella
                , p_nome_dal
                , p_nome_al
                , p_dal
                , p_al
                , p_campi_controllare
                , p_valori_controllare
                , v_parametri
                );
      v_ritorno := controlla_inclusione_dal (v_parametri);
      if v_ritorno = 0
      then
         v_ritorno := AFC_Error.ok;
      elsif v_ritorno = AFC_Error.ok
         then
            v_ritorno := 0;
         end if;
      return v_ritorno;
   end;
----------------------------------------------------------------------------------
   function is_tutto_incluso
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   ) return number
   /******************************************************************************
   NOME:        is_tutto_incluso
   DESCRIZIONE: Controlla se il periodo � incluso ad altri periodi della tabella,
                in base alle condizioni passate
   PARAMETRI:   p_tabella IN VARCHAR2: nome tavola da analizzare
                p_nome_dal IN VARCHAR2: nome colonna fine periodo
                p_nome_al IN VARCHAR2: nome colonna inizio periodo
                p_dal IN DATE: data di confronto
                p_campi_controllare IN VARCHAR2: elenco campi da controllare
                p_valori_controllare IN VARCHAR2: elenco valori da controllare
   RITORNA:     --
   ECCEZIONI:   --
   ANNOTAZIONI: --
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    21/06/2005 FT         Creazione.
   15   16/07/2007 FT         Aggiunto controllo integrita sui parametri in input (check_parametri)
   17   25/11/2009 FT         Tolto controllo su p_campi_controllare in check_parametri
   ******************************************************************************/
   is
      v_parametri parametri;
      v_ritorno number;
   begin
      DbC.PRE( not DbC.PreOn or afc.to_boolean( check_parametri( p_tabella
                                                               , p_nome_dal
                                                               , p_nome_al
                                                               )
                                              )
             , ' check_parametri on AFC_PERIODO.is_tutto_incluso'
             );
      is_incluso( p_tabella
                , p_nome_dal
                , p_nome_al
                , p_dal
                , p_al
                , p_campi_controllare
                , p_valori_controllare
                , v_parametri
                );
      v_ritorno := controlla_inclusione_dal( v_parametri );
      if v_ritorno = AFC_Error.ok
      then
         if to_date (v_parametri.in_al, 'ddmmyyyy')
               between to_date (v_parametri.out_dal, 'ddmmyyyy')
                   and to_date (v_parametri.out_al, 'ddmmyyyy')
         then
            v_ritorno := AFC_Error.ok;
         else
            v_ritorno := 0;
         end if;
      end if;
      return v_ritorno;
   end;
----------------------------------------------------------------------------------
   function is_estremi_inclusi
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   ) return number
   /******************************************************************************
   NOME:        is_estremi_inclusi
   DESCRIZIONE: Controlla se il periodo ha gli estremi inclusi in altri periodi
                della tabella, in base alle condizioni passate
   PARAMETRI:   p_tabella IN VARCHAR2: nome tavola da analizzare
                p_nome_dal IN VARCHAR2: nome colonna fine periodo
                p_nome_al IN VARCHAR2: nome colonna inizio periodo
                p_dal IN DATE: data di confronto
                p_campi_controllare IN VARCHAR2: elenco campi da controllare
                p_valori_controllare IN VARCHAR2: elenco valori da controllare
   RITORNA:     --
   ECCEZIONI:   --
   ANNOTAZIONI: --
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    21/06/2005 FT         Creazione.
   15   16/07/2007 FT         Aggiunto controllo integrita sui parametri in input (check_parametri)
   17   25/11/2009 FT         Tolto controllo su p_campi_controllare in check_parametri
   ******************************************************************************/
   is
      v_parametri  parametri;
      v_ritorno number;
      dep_dal varchar2 (10);
      dep_al  varchar2 (10);
   begin
      DbC.PRE( not DbC.PreOn or afc.to_boolean( check_parametri( p_tabella
                                                               , p_nome_dal
                                                               , p_nome_al
                                                               )
                                              )
             , ' check_parametri on AFC_PERIODO.is_estremi_inclusi'
             );
      is_incluso( p_tabella
                , p_nome_dal
                , p_nome_al
                , p_dal
                , p_al
                , p_campi_controllare
                , p_valori_controllare
                , v_parametri
                );
      v_ritorno := controlla_inclusione_dal (v_parametri);
      if v_ritorno = AFC_Error.ok
      then
         v_ritorno := 0;
         if to_date (v_parametri.in_al, 'ddmmyyyy') not
                  between to_date (v_parametri.out_dal, 'ddmmyyyy')
                      and to_date (v_parametri.out_al, 'ddmmyyyy')
         then
            dep_dal := v_parametri.out_dal;
            dep_al := v_parametri.out_al;
            if controlla_inclusione_al (v_parametri) = 1
            then
               v_ritorno := 0;
               if   dep_dal != v_parametri.out_dal
                 and dep_al != v_parametri.out_al
               then
                  v_ritorno := AFC_Error.ok;
               end if;
            end if;
         end if;
      end if;
      return v_ritorno;
   end;
----------------------------------------------------------------------------------
   function is_contigui_incluso
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   ) return number
   /******************************************************************************
   NOME:        is_contigui_incluso
   DESCRIZIONE: Controlla se il periodo � incluso in periodi contigui
                della tabella, in base alle condizioni passate
   PARAMETRI:   p_tabella IN VARCHAR2: nome tavola da analizzare
                p_nome_dal IN VARCHAR2: nome colonna fine periodo
                p_nome_al IN VARCHAR2: nome colonna inizio periodo
                p_dal IN DATE: data di confronto
                p_campi_controllare IN VARCHAR2: elenco campi da controllare
                p_valori_controllare IN VARCHAR2: elenco valori da controllare
   RITORNA:     --
   ECCEZIONI:   --
   ANNOTAZIONI: --
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    21/06/2005 FT         Creazione.
   15   16/07/2007 FT         Aggiunto controllo integrita sui parametri in input (check_parametri)
   17   25/11/2009 FT         Tolto controllo su p_campi_controllare in check_parametri
   ******************************************************************************/
   is
      v_parametri parametri;
      v_ritorno number;
      dep_dal varchar2 (10);
      dep_al  varchar2 (10);
   begin
      DbC.PRE( not DbC.PreOn or afc.to_boolean( check_parametri( p_tabella
                                                               , p_nome_dal
                                                               , p_nome_al
                                                               )
                                              )
             , ' check_parametri on AFC_PERIODO.is_contigui_incluso'
             );
      is_incluso( p_tabella
                , p_nome_dal
                , p_nome_al
                , p_dal
                , p_al
                , p_campi_controllare
                , p_valori_controllare
                , v_parametri
                );
      v_ritorno := controlla_inclusione_dal (v_parametri);
      if v_ritorno = AFC_Error.ok
      then
         v_ritorno := 0;
         if to_date (v_parametri.in_al, 'ddmmyyyy') not
            between to_date (v_parametri.out_dal, 'ddmmyyyy')
                and to_date (v_parametri.out_al, 'ddmmyyyy')
         then
            dep_dal := v_parametri.out_dal;
            dep_al := v_parametri.out_al;
            if controlla_inclusione_al (v_parametri) = AFC_Error.ok
            then
               v_ritorno := 0;
               if to_char (to_date (dep_al, 'ddmmyyyy') + 1, 'ddmmyyyy') =
                                              trunc (v_parametri.out_dal)
               then
                  v_ritorno := AFC_Error.ok;
               end if;
            end if;
         end if;
      end if;
      return v_ritorno;
   end;
----------------------------------------------------------------------------------
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
   ) return number
   /******************************************************************************
   NOME:        is_contenitore
   DESCRIZIONE: controlla se i periodi nella tabella P_TABELLA (che soddisfano i
                criteri stabiliti in base a P_VALORI_CONTROLLARE), che erano
                contenuti o intersecavano il periodo P_DAL_OLD-P_AL_OLD, sono
                contenuti nel periodo P_DAL_NEW-P_AL_NEW
   PARAMETRI:   P_TABELLA:            nome della tabella sulla quale eseguire i calcoli
                P_NOME_DAL:           nome della colonna nella quale cercare il valore P_DAL
                P_NOME_AL:            nome della colonna nella quale cercare il valore P_AL
                P_DAL_OLD:            valore di inizio del periodo, prima della modifica
                P_AL_OLD:             valore di fine del periodo, prima della modifica
                P_DAL_NEW:            valore di inizio del periodo, dopo la modifica
                P_AL_NEW:             valore di fine del periodo, dopo la modifica
                P_CAMPI_CONTROLLARE:  nomi delle colonne sulle quali cercare i
                                      valore VALORI_CONTROLLARE
                P_VALORI_CONTROLLARE: valori da controllare nelle colonne
                                      P_CAMPI_CONTROLLARE
   RITORNA:     AFC_Error.ok se il controllo ha avuto esito positivo, 0 altrimenti
   ECCEZIONI:   --
   ANNOTAZIONI: --
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    16/08/2005 FTASSINARI Creazione.
   15   16/07/2007 FT         Aggiunto controllo integrita sui parametri in input (check_parametri)
   17   25/11/2009 FT         Tolto controllo su p_campi_controllare in check_parametri
   ******************************************************************************/
   is
      cursor_name       integer;
      rows_processed    integer;
      d_statement       varchar2 (32000);
      d_where_condition varchar2 (32000);
      d_out_dal         varchar2(10);
      d_out_al          varchar2(10);
      d_result          number;
   begin
      DbC.PRE( not DbC.PreOn or afc.to_boolean( check_parametri( p_tabella
                                                               , p_nome_dal
                                                               , p_nome_al
                                                               )
                                              )
             , ' check_parametri on AFC_PERIODO.is_contenitore'
             );
      -- statement per la ricerca dei periodi contenuti o intersecanti il
      -- periodo p_dal_old-p_al_old
      d_statement := 'select to_char( nvl(' || p_nome_dal || ', to_date( ''2222222'', ''j'' ) ), ''ddmmyyyy'' )'
                  || '     , to_char( nvl(' || p_nome_al || ', to_date( ''3333333'', ''j'' ) ), ''ddmmyyyy'' )'
                  || 'from ' || p_tabella || ' ';
      -- compongo la where-condition relativa a p_campi_controllare
      estrazione_condizioni( p_campi_controllare
                           , p_valori_controllare
                           , d_where_condition
                           );
      d_statement := d_statement
                  || d_where_condition
                  -- tutto incluso
                  || ' nvl( ' || p_nome_dal || ', to_date( ''2222222'', ''j'' ) ) > ''' || p_dal_old || ''''
                  || ' and nvl( ' || p_nome_al || ', to_date( ''3333333'', ''j'' ) ) < ''' || p_al_old || ''''
                  -- intersecato a sx
                  || ' or nvl( ' || p_nome_dal || ', to_date( ''2222222'', ''j'' ) ) < ''' || p_dal_old || ''''
                  || ' and nvl( ' || p_nome_al || ', to_date( ''3333333'', ''j'' ) ) between ''' || p_dal_old || ''' and ''' || p_al_old || ''''
                  -- intersecato a dx
                  || ' or nvl( ' || p_nome_dal || ', to_date( ''2222222'', ''j'' ) ) between ''' || p_dal_old || ''' and ''' || p_al_old || ''''
                  || ' and nvl( ' || p_nome_al || ', to_date( ''3333333'', ''j'' ) ) > ''' || p_al_old || '''';
      cursor_name := dbms_sql.open_cursor;
      dbms_sql.parse( cursor_name
                    , d_statement
                    , dbms_sql.native
                    );
      dbms_sql.define_column( cursor_name
                            , 1
                            , d_out_dal
                            , 10
                            );
      dbms_sql.define_column( cursor_name
                            , 2
                            , d_out_al
                            , 10
                            );
      rows_processed := dbms_sql.execute( cursor_name );
      d_result := AFC_Error.ok;
      while ( dbms_sql.fetch_rows( cursor_name ) > 0 )
        and d_result = AFC_Error.ok
      loop
         dbms_sql.column_value( cursor_name
                              , 1
                              , d_out_dal
                              );
         dbms_sql.column_value( cursor_name
                              , 2
                              , d_out_al
                              );
         if ( to_date( d_out_dal, 'ddmmyyyy' ) < P_DAL_NEW )
         or ( to_date( d_out_al, 'ddmmyyyy' ) > P_AL_NEW )
         then
            d_result := 0;
         end if;
      end loop;
      return d_result;
   end; --AFC_Periodo.is_contenitore
----------------------------------------------------------------------------------
   function is_contenitore
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   ) return number
   /******************************************************************************
   NOME:        is_contenitore
   DESCRIZIONE: controlla che i periodi nella tabella P_TABELLA (che soddisfano i
                criteri stabiliti in base a P_VALORI_CONTROLLARE), non
                intersechino il periodo P_DAL-P_AL
   PARAMETRI:   P_TABELLA:            nome della tabella sulla quale eseguire i calcoli
                P_NOME_DAL:           nome della colonna nella quale cercare il valore P_DAL
                P_NOME_AL:            nome della colonna nella quale cercare il valore P_AL
                P_DAL:                valore di inizio del periodo
                P_AL:                 valore di fine del periodo
                P_CAMPI_CONTROLLARE:  nomi delle colonne sulle quali cercare i
                                      valore VALORI_CONTROLLARE
                P_VALORI_CONTROLLARE: valori da controllare nelle colonne
                                      P_CAMPI_CONTROLLARE
   RITORNA:     1 se il controllo ha avuto esito positivo, 0 altrimenti
   ECCEZIONI:   --
   ANNOTAZIONI: --
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    16/08/2005 FTASSINARI Creazione.
   15   16/07/2007 FT         Aggiunto controllo integrita sui parametri in input (check_parametri)
   17   25/11/2009 FT         Tolto controllo su p_campi_controllare in check_parametri
   ******************************************************************************/
   is
      d_result number;
   begin
      DbC.PRE( not DbC.PreOn or afc.to_boolean( check_parametri( p_tabella
                                                               , p_nome_dal
                                                               , p_nome_al
                                                               )
                                              )
             , ' check_parametri on AFC_PERIODO.is_contenitore'
             );
      if exists_intersecati( p_tabella
                           , p_nome_dal
                           , p_nome_al
                           , p_dal
                           , p_al
                           , p_campi_controllare
                           , p_valori_controllare
                           ) = 1
      then
         d_result := 0;
      else
         d_result := AFC_Error.ok;
      end if;
      return d_result;
   end; --AFC_Periodo.is_contenitore
----------------------------------------------------------------------------------
   procedure set_contigui_make_statement
   ( p_tabella              in     varchar2
   , p_nome_dal             in     varchar2
   , p_nome_al              in     varchar2
   , p_dal                  in     date
   , p_al                   in     date
   , p_campi_controllare    in     varchar2
   , p_valori_controllare   in     varchar2
   , p_tipo_s               in     integer
   , p_tipo_c               in     integer
   , p_con_buchi            in     boolean
   , p_statement            in out varchar2
   )
   /******************************************************************************
   NOME:        set_contigui_make_statement
   DESCRIZIONE: crea lo statement completo per effettuare il set_contigui
   PARAMETRI:   P_TABELLA:            nome della tabella sulla quale eseguire i calcoli
                P_NOME_DAL:           nome della colonna nella quale cercare il valore P_DAL
                P_NOME_AL:            nome della colonna nella quale cercare il valore P_AL
                P_DAL:                valore da cercare nella colonna P_NOME_DAL
                P_AL:                 valore da cercare nella colonna P_NOME_AL
                P_CAMPI_CONTROLLARE:  nomi delle colonne sulle quali cercare i
                                      valore VALORI_CONTROLLARE
                P_VALORI_CONTROLLARE: valori da controllare nelle colonne
                                      P_CAMPI_CONTROLLARE
                P_tipo_s:               definisce lo statement che si vuole eseguire:
                                      - 0: update P_TABELLA
                                           set P_NOME_AL = ( to_date( P_DAL, 'ddmmyyyy' ) - 1 )
                                      - 1: update P_TABELLA
                                           set P_NOME_DAL = ( to_date( P_AL, 'ddmmyyyy' ) + 1 )
                                      - 2: delete from P_TABELLATIPO:                 definisce il tipo di ricerca che si sta
                                           eseguondo:
                P_tipo_c:               definisce le condizioni di ricerca relative agli
                                      estremi dei periodi:
                                      - 0: cerco i record in cui il periodo ha DAL < P_DAL
                                           e AL > P_DAL
                                      - 1: cerco i record in cui il periodo ha DAL > P_DAL
                                           e AL > P_AL
                                      - 2: cerco i record in cui il periodo ha DAL > P_DAL
                                           e AL < P_DAL
                P_con_buchi:            indica se vogliamo che vengano resi contigui
                                      anche gli eventuali periodi precedente e
                                      successivo) piu vicino al periodo in esame (caso
                                      FALSE, default) oppure solo i periodi
                                      intersecati al periodo in esame (caso TRUE)
                P_STATEMENT:          lo statement da eseguire
   RITORNA:     --
   ECCEZIONI:   --
   ANNOTAZIONI: --
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    20/06/2005 FTASSINARI Creazione.
   ******************************************************************************/
   is
      d_campi varchar2 (32000);
   begin
      -- creo lo statement di update per elaborare i record esistenti
      crea_statement( p_tipo_s
                    , p_nome_dal
                    , p_nome_al
                    , to_char( p_dal, 'ddmmyyyy' )
                    , to_char( p_al, 'ddmmyyyy' )
                    , p_tabella
                    , p_statement
                    );
      -- compongo le condizioni di ricerca dei record (relative a campi da controllare)
      -- e le memorizzo nella stringa d_campi
      estrazione_condizioni( p_campi_controllare
                           , p_valori_controllare
                           , d_campi
                           );
      -- in d_statement ho la stringa sql update ... set ... where <campi_da_controllare>
      p_statement := p_statement || d_campi;
      -- compongo le condizioni di ricerca dei record (relative al valore dei periodi)
      -- e le memorizzo nella stringa p_statement
      estrazione_condizioni_periodo( p_tipo_c
                                   , p_con_buchi
                                   , p_tabella
                                   , p_nome_dal
                                   , p_nome_al
                                   , to_char( p_dal, 'ddmmyyyy' )
                                   , to_char( p_al, 'ddmmyyyy' )
                                   , p_statement
                                   );
      -- in d_statement ho la stringa sql da eseguire
   end; --AFC_Periodo.set_contigui_make_statement
----------------------------------------------------------------------------------
   procedure set_contigui
   ( p_tabella              in   varchar2
   , p_nome_dal             in   varchar2
   , p_nome_al              in   varchar2
   , p_dal                  in   date
   , p_al                   in   date
   , p_campi_controllare    in   varchar2
   , p_valori_controllare   in   varchar2
   , p_con_buchi            in   boolean default false
   )
   /******************************************************************************
   NOME:        set_contigui
   DESCRIZIONE: predispone le registrazioni facendo in modo che le righe esistenti
                lascino il posto al DAL - AL indicato. Regista AL del periodo
                precedente = DAL-1 e DAL del periodo seguente = AL+1.
                Eventuali periodi inclusi vengono eliminati.
                Le operazioni devono essere eseguite sempre solamente sulle
                registrazioni relative ai "campi da controllare".
   PARAMETRI:   P_TABELLA:            nome della tabella sulla quale eseguire i
                                      calcoli
                P_NOME_DAL:           nome della colonna nella quale cercare il
                                      valore P_DAL
                P_NOME_AL:            nome della colonna nella quale cercare il
                                      valore P_AL
                P_DAL:                valore da cercare nella colonna P_NOME_DAL
                P_AL:                 valore da cercare nella colonna P_NOME_AL
                P_CAMPI_CONTROLLARE:  nomi delle colonne sulle quali cercare i
                                      valore VALORI_CONTROLLARE
                P_VALORI_CONTROLLARE: valori da controllare nelle colonne
                                      P_CAMPI_CONTROLLARE
                P_con_buchi:          indica se vogliamo che vengano resi contigui
                                      anche gli eventuali periodi precedente e
                                      successivo) piu vicino al periodo in esame (caso
                                      FALSE, default) oppure solo i periodi
                                      intersecati al periodo in esame (caso TRUE)
   RITORNA:     --
   ECCEZIONI:   --
   ANNOTAZIONI: vedere ESEMPIO 2 nel .pks
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    16/06/2005 FTASSINARI Creazione.
   1    30/06/2005 FTASSINARI aggiunta del parametro P_con_buchi per elaborare
                              anche i periodi precedente/successivo piu vicini
                              al periodo in esame
   15   16/07/2007 FT         Aggiunto controllo integrita sui parametri in input (check_parametri)
   17   25/11/2009 FT         Tolto controllo su p_campi_controllare in check_parametri
   ******************************************************************************/
   is
      d_statement    varchar2 (32000);
      cursor_name    integer;
      rows_processed integer;
   begin
      DbC.PRE( not DbC.PreOn or afc.to_boolean( check_parametri( p_tabella
                                                               , p_nome_dal
                                                               , p_nome_al
                                                               )
                                              )
             , ' check_parametri on AFC_PERIODO.set_contigui'
             );
      -- cerco i periodi che hanno dal < p_dal e al > p_dal e aggiorno il loro
      -- al = p_dal - 1
      set_contigui_make_statement( p_tabella
                                 , p_nome_dal
                                 , p_nome_al
                                 , p_dal
                                 , p_al
                                 , p_campi_controllare
                                 , p_valori_controllare
                                 , 0
                                 , 0
                                 , p_con_buchi
                                 , d_statement
                                 );
      -- eseguo lo statement
      begin
         cursor_name := dbms_sql.open_cursor;
         dbms_sql.parse (cursor_name, d_statement, dbms_sql.native);
         rows_processed := dbms_sql.execute (cursor_name);
         dbms_sql.close_cursor (cursor_name);
      exception
         when others then
            dbms_sql.close_cursor (cursor_name);
            raise;
      end;
      -- ho elaborato i periodi che avevano dal < p_dal e al > p_dal
      -- cerco i periodi che hanno p_dal < dal > p_al e al > p_al e aggiorno il
      -- loro al = p_dal + 1
      set_contigui_make_statement( p_tabella
                                 , p_nome_dal
                                 , p_nome_al
                                 , p_dal
                                 , p_al
                                 , p_campi_controllare
                                 , p_valori_controllare
                                 , 1
                                 , 1
                                 , p_con_buchi
                                 , d_statement
                                 );
      -- eseguo lo statement
      begin
         cursor_name := dbms_sql.open_cursor;
         dbms_sql.parse (cursor_name, d_statement, dbms_sql.native);
         rows_processed := dbms_sql.execute (cursor_name);
         dbms_sql.close_cursor (cursor_name);
      exception
         when others then
            dbms_sql.close_cursor (cursor_name);
            raise;
      end;
      -- ho elaborato i periodi che avevano p_dal < dal > p_al e al > p_dal
      -- cerco i periodi che hanno dal >= p_dal e al <= p_al e li elimino
      set_contigui_make_statement( p_tabella
                                 , p_nome_dal
                                 , p_nome_al
                                 , p_dal
                                 , p_al
                                 , p_campi_controllare
                                 , p_valori_controllare
                                 , 2
                                 , 2
                                 , p_con_buchi
                                 , d_statement
                                 );
      -- eseguo lo statement
      begin
         cursor_name := dbms_sql.open_cursor;
         dbms_sql.parse (cursor_name, d_statement, dbms_sql.native);
         rows_processed := dbms_sql.execute (cursor_name);
         dbms_sql.close_cursor (cursor_name);
      exception
         when others then
            dbms_sql.close_cursor (cursor_name);
            raise;
      end;
      -- ho elaborato i periodi che avevano dal >= p_dal e al <= p_dal
   end; -- AFC_Periodo.set_contigui
----------------------------------------------------------------------------------
   procedure set_finale
   ( p_tabella              in   varchar2
   , p_nome_dal             in   varchar2
   , p_nome_al              in   varchar2
   , p_dal                  in   date
   , p_al                   in   date
   , p_campi_controllare    in   varchar2
   , p_valori_controllare   in   varchar2
   )
   /******************************************************************************
   NOME:        set_finale
   DESCRIZIONE: aggiunge una riga facendo in modo che le righe esistenti lascino
                il posto al DAL - AL indicato. Registrare AL del periodo
                precedente = DAL-1. Se esiste un periodo seguente deve essere
                segnalato Errore. Eventuali periodi inclusi vengono eliminati.
                Le operazioni devono essere eseguite sempre solamente sulle
                registrazioni relative ai "campi da controllare".
   PARAMETRI:   P_TABELLA:            nome della tabella sulla quale eseguire i
                                      calcoli
                P_NOME_DAL:           nome della colonna nella quale cercare il
                                      valore P_DAL
                P_NOME_AL:            nome della colonna nella quale cercare il
                                      valore P_AL
                P_DAL:                valore da cercare nella colonna P_NOME_DAL
                P_AL:                 valore da cercare nella colonna P_NOME_AL
                P_CAMPI_CONTROLLARE:  nomi delle colonne sulle quali cercare i
                                      valore VALORI_CONTROLLARE
                P_VALORI_CONTROLLARE: valori da controllare nelle colonne
                                      P_CAMPI_CONTROLLARE
   RITORNA:     --
   ECCEZIONI:   --
   ANNOTAZIONI: vedere ESEMPIO 3 nel .pks
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    21/06/2005 FTASSINARI Creazione.
   15   16/07/2007 FT         Aggiunto controllo integrita sui parametri in input (check_parametri)
   17   25/11/2009 FT         Tolto controllo su p_campi_controllare in check_parametri
   ******************************************************************************/
   is
      d_statement    varchar2 (32000);
      cursor_name    integer;
      rows_processed integer;
   begin
      DbC.PRE( not DbC.PreOn or afc.to_boolean( check_parametri( p_tabella
                                                               , p_nome_dal
                                                               , p_nome_al
                                                               )
                                              )
             , ' check_parametri on AFC_PERIODO.set_finale'
             );
      -- cerco i periodi che hanno dal < p_dal e al > p_dal e aggiorno il loro
      -- al = p_dal - 1
      set_contigui_make_statement( p_tabella
                                 , p_nome_dal
                                 , p_nome_al
                                 , p_dal
                                 , p_al
                                 , p_campi_controllare
                                 , p_valori_controllare
                                 , 0
                                 , 0
                                 , true
                                 , d_statement
                                 );
      -- eseguo lo statement
      begin
         cursor_name := dbms_sql.open_cursor;
         dbms_sql.parse (cursor_name, d_statement, dbms_sql.native);
         rows_processed := dbms_sql.execute (cursor_name);
         dbms_sql.close_cursor (cursor_name);
      exception
         when others then
            dbms_sql.close_cursor (cursor_name);
            raise;
      end;
      -- ho elaborato i periodi che avevano dal < p_dal e al > p_dal
      -- cerco i periodi che hanno p_dal < dal > p_al e al > p_al e li elimino
      set_contigui_make_statement( p_tabella
                                 , p_nome_dal
                                 , p_nome_al
                                 , p_dal
                                 , p_al
                                 , p_campi_controllare
                                 , p_valori_controllare
                                 , 2
                                 , 1
                                 , true
                                 , d_statement
                                 );
      -- eseguo lo statement
      begin
         cursor_name := dbms_sql.open_cursor;
         dbms_sql.parse (cursor_name, d_statement, dbms_sql.native);
         rows_processed := dbms_sql.execute (cursor_name);
         dbms_sql.close_cursor (cursor_name);
      exception
         when others then
            dbms_sql.close_cursor (cursor_name);
            raise;
      end;
      -- ho elaborato i periodi che avevano p_dal < dal > p_al e al > p_dal
      -- cerco i periodi che hanno dal >= p_dal e al <= p_al e li elimino
      set_contigui_make_statement( p_tabella
                                 , p_nome_dal
                                 , p_nome_al
                                 , p_dal
                                 , p_al
                                 , p_campi_controllare
                                 , p_valori_controllare
                                 , 2
                                 , 2
                                 , true
                                 , d_statement
                                 );
      -- eseguo lo statement
      begin
         cursor_name := dbms_sql.open_cursor;
         dbms_sql.parse (cursor_name, d_statement, dbms_sql.native);
         rows_processed := dbms_sql.execute (cursor_name);
         dbms_sql.close_cursor (cursor_name);
      exception
         when others then
            dbms_sql.close_cursor (cursor_name);
            raise;
      end;
      -- ho elaborato i periodi che avevano dal >= p_dal e al <= p_dal
      -- cerco i periodi che hanno dal > p_al e al > p_al e li elimino
      set_contigui_make_statement( p_tabella
                                 , p_nome_dal
                                 , p_nome_al
                                 , p_dal
                                 , p_al
                                 , p_campi_controllare
                                 , p_valori_controllare
                                 , 2
                                 , 3
                                 , true
                                 , d_statement
                                 );
      -- eseguo lo statement
      begin
         cursor_name := dbms_sql.open_cursor;
         dbms_sql.parse (cursor_name, d_statement, dbms_sql.native);
         rows_processed := dbms_sql.execute (cursor_name);
         dbms_sql.close_cursor (cursor_name);
      exception
         when others then
            dbms_sql.close_cursor (cursor_name);
            raise;
      end;
      -- ho elaborato i periodi che avevano dal > p_al e al > p_al
   end; -- AFC_Periodo.set_finale
----------------------------------------------------------------------------------
   procedure reset_contigui
   ( p_tabella              in varchar2
   , p_nome_dal             in varchar2
   , p_nome_al              in varchar2
   , p_dal                  in date
   , p_al                   in date
   , p_campi_controllare    in varchar2
   , p_valori_controllare   in varchar2
   )
   /******************************************************************************
   NOME:        reset_contigui
   DESCRIZIONE: ripristina una condizione di continuita tra periodi dopo
                che e stato eliminato un periodo (che viene passato come parametro)
   PARAMETRI:   P_TABELLA:            nome della tabella sulla quale eseguire i
                                      calcoli
                P_NOME_DAL:           nome della colonna nella quale cercare il
                                      valore P_DAL
                P_NOME_AL:            nome della colonna nella quale cercare il
                                      valore P_AL
                P_DAL:                valore da cercare nella colonna P_NOME_DAL
                P_AL:                 valore da cercare nella colonna P_NOME_AL
                P_CAMPI_CONTROLLARE:  nomi delle colonne sulle quali cercare i
                                      valore VALORI_CONTROLLARE
                P_VALORI_CONTROLLARE: valori da controllare nelle colonne
                                      P_CAMPI_CONTROLLARE
   RITORNA:     --
   ECCEZIONI:   -20101 se il periodo precedente non e contiguo
                -20102 se il periodo successivo non e contiguo
                -20103 se sia il periodo precedente che quello successivo
                       non sono contigui
   ANNOTAZIONI: vedere ESEMPIO 4 nel .pks
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    23/06/2005 FTASSINARI Creazione.
   15   16/07/2007 FT         Aggiunto controllo integrita sui parametri in input (check_parametri)
   17   25/11/2009 FT         Tolto controllo su p_campi_controllare in check_parametri
   ******************************************************************************/
   is
      cursor_name    integer;
      rows_processed integer;
      v_periodo_pre t_periodo;
      v_periodo_seg t_periodo;
      v_statement varchar2 (32000);
      v_campi varchar2(32000);
   begin
      DbC.PRE( not DbC.PreOn or afc.to_boolean( check_parametri( p_tabella
                                                               , p_nome_dal
                                                               , p_nome_al
                                                               )
                                              )
             , ' check_parametri on AFC_PERIODO.reset_contigui'
             );
      v_periodo_pre := get_precedente( p_tabella
                                     , p_nome_dal
                                     , p_nome_al
                                     , p_dal
                                     , p_al
                                     , p_campi_controllare
                                     , p_valori_controllare
                                     );
      v_periodo_seg := get_seguente( p_tabella
                                   , p_nome_dal
                                   , p_nome_al
                                   , p_dal
                                   , p_al
                                   , p_campi_controllare
                                   , p_valori_controllare
                                   );
      if v_periodo_seg.dal = ( p_al + 1 )
      and v_periodo_pre.al = ( p_dal - 1 )
      then
         -- il periodo passato come parametro e contiguo al periodo successivo
         -- e precedente (in relazione ai campi da controllare)
         crea_statement( 0
                       , null
                       , p_nome_al
                       , to_char( v_periodo_seg.dal, 'ddmmyyyy' )
                       , null
                       , p_tabella
                       , v_statement
                       );
         estrazione_condizioni( p_campi_controllare
                              , p_valori_controllare
                              , v_campi
                              );
         v_statement := v_statement
                     || v_campi
                     || p_nome_dal || ' = ''' || v_periodo_pre.dal || ''' and '
                     || p_nome_al || ' = ''' || v_periodo_pre.al || ''' ';
         -- eseguo lo statement
         begin
            cursor_name := dbms_sql.open_cursor;
            dbms_sql.parse (cursor_name, v_statement, dbms_sql.native);
            rows_processed := dbms_sql.execute (cursor_name);
            dbms_sql.close_cursor (cursor_name);
         exception
            when others then
               dbms_sql.close_cursor (cursor_name);
               raise;
         end;
      else if v_periodo_seg.dal <> ( p_al + 1 )
           and v_periodo_pre.al <> ( p_dal - 1 ) then
              -- il periodo passato come parametro non e contiguo ne al periodo
              -- precedente ne al periodo successivo (in relazione ai campi da
              -- controllare)
              raise pre_suc_not_cont;
           else if v_periodo_seg.dal = ( p_al + 1 ) then
                   -- il periodo passato come parametro non e contiguo al periodo
                   -- precedente (in relazione ai campi da controllare)
                   raise pre_not_cont;
                else if v_periodo_pre.al = ( p_dal - 1 ) then
                        -- il periodo passato come parametro non e contiguo al periodo
                        -- successivo (in relazione ai campi da controllare)
                        raise suc_not_cont;
                     end if;
                end if;
           end if;
      end if;
   end; --AFC_Periodo.reset_contigui
----------------------------------------------------------------------------------
   function exists_precedenti
   ( p_tabella            in     varchar2
   , p_nome_dal           in     varchar2
   , p_nome_al            in     varchar2
   , p_dal                in     date
   , p_al                 in     date
   , p_campi_controllare  in     varchar2
   , p_valori_controllare in     varchar2
   , p_rowid              in     rowid default null
   ) return number
   /******************************************************************************
   NOME:        exists_precedenti
   DESCRIZIONE: controlla se esistono periodi precedenti a quello passato come
                parametro, in relazione ai CAMPI_CONTROLLARE
   PARAMETRI:   P_TABELLA:            nome della tabella sulla quale eseguire la
                                      ricerca
                P_NOME_DAL:           nome della colonna nella quale cercare il
                                      valore P_DAL
                P_NOME_AL:            nome della colonna nella quale cercare il
                                      valore P_AL
                P_DAL:                valore da cercare nella colonna P_NOME_DAL
                P_AL:                 valore da cercare nella colonna P_NOME_AL
                P_CAMPI_CONTROLLARE:  nomi delle colonne sulle quali cercare i
                                      valore VALORI_CONTROLLARE
                P_VALORI_CONTROLLARE: valori da controllare nelle colonne
                                      P_CAMPI_CONTROLLARE
   RITORNA:     AFC_Error.ok se esistono periodi precedenti, 0 altrimenti
   ECCEZIONI:   --
   ANNOTAZIONI: --
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    23/06/2005 FTASSINARI Creazione.
   14   16/05/2007 FTASSINARI Aggiunto rowid
   15   16/07/2007 FT         Aggiunto controllo integrita sui parametri in input (check_parametri)
   17   25/11/2009 FT         Tolto controllo su p_campi_controllare in check_parametri
   ******************************************************************************/
   is
      v_result number;
      v_periodo t_periodo;
   begin
      DbC.PRE( not DbC.PreOn or afc.to_boolean( check_parametri( p_tabella
                                                               , p_nome_dal
                                                               , p_nome_al
                                                               )
                                              )
             , ' check_parametri on AFC_PERIODO.exists_precedenti'
             );
      -- chiamo la function get_precedente sul periodo in considerazione
      v_periodo := get_precedente( p_tabella
                                 , p_nome_dal
                                 , p_nome_al
                                 , p_dal
                                 , p_al
                                 , p_campi_controllare
                                 , p_valori_controllare
                                 , p_rowid
                                 );
      if ( v_periodo.DAL is null ) and ( v_periodo.AL is null )
      then
         v_result := 0;
      else
         v_result := AFC_Error.ok;
      end if;
      return v_result;
   end; -- AFC_Periodo.exists_precedenti
----------------------------------------------------------------------------------
   function existsPrecedenti
   ( p_tabella            in     varchar2
   , p_nome_dal           in     varchar2
   , p_nome_al            in     varchar2
   , p_dal                in     date
   , p_al                 in     date
   , p_campi_controllare  in     varchar2
   , p_valori_controllare in     varchar2
   , p_rowid              in     rowid default null
   ) return boolean
   /******************************************************************************
   NOME:        existsPrecedenti
   DESCRIZIONE: controlla se esistono periodi precedenti a quello passato come
                parametro, in relazione ai CAMPI_CONTROLLARE
   PARAMETRI:   P_TABELLA:            nome della tabella sulla quale eseguire la
                                      ricerca
                P_NOME_DAL:           nome della colonna nella quale cercare il
                                      valore P_DAL
                P_NOME_AL:            nome della colonna nella quale cercare il
                                      valore P_AL
                P_DAL:                valore da cercare nella colonna P_NOME_DAL
                P_AL:                 valore da cercare nella colonna P_NOME_AL
                P_CAMPI_CONTROLLARE:  nomi delle colonne sulle quali cercare i
                                      valore VALORI_CONTROLLARE
                P_VALORI_CONTROLLARE: valori da controllare nelle colonne
                                      P_CAMPI_CONTROLLARE
   RITORNA:     true se esistono periodi precedenti, false altrimenti
   ECCEZIONI:   --
   ANNOTAZIONI: (versione booleana di exists_precedenti)
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    23/06/2005 FTASSINARI Creazione.
   1    30/09/2005 FTASSINARI Eliminata dipendenza da AFC
   14   16/05/2007 FTASSINARI Aggiunto rowid
   ******************************************************************************/
   is
      v_result_number number;
      v_result boolean;
   begin
      v_result_number := exists_precedenti( P_TABELLA
                                          , P_NOME_DAL
                                          , P_NOME_AL
                                          , P_DAL
                                          , P_AL
                                          , P_CAMPI_CONTROLLARE
                                          , P_VALORI_CONTROLLARE
                                          , P_ROWID
                                          );
      if v_result_number = AFC_Error.ok
      then
         v_result := true;
      else
         v_result := false;
      end if;
      return v_result;
   end; --AFC_Periodo.existsPrecedenti
----------------------------------------------------------------------------------
   function exists_seguenti
   ( p_tabella            in     varchar2
   , p_nome_dal           in     varchar2
   , p_nome_al            in     varchar2
   , p_dal                in     date
   , p_al                 in     date
   , p_campi_controllare  in     varchar2
   , p_valori_controllare in     varchar2
   , p_rowid              in     rowid default null
   ) return number
   /******************************************************************************
   NOME:        exists_seguenti
   DESCRIZIONE: controlla se esistono periodi seguenti a quello passato come
                parametro, in relazione ai CAMPI_CONTROLLARE
   PARAMETRI:   P_TABELLA:            nome della tabella sulla quale eseguire la
                                      ricerca
                P_NOME_DAL:           nome della colonna nella quale cercare il
                                      valore P_DAL
                P_NOME_AL:            nome della colonna nella quale cercare il
                                      valore P_AL
                P_DAL:                valore da cercare nella colonna P_NOME_DAL
                P_AL:                 valore da cercare nella colonna P_NOME_AL
                P_CAMPI_CONTROLLARE:  nomi delle colonne sulle quali cercare i
                                      valore VALORI_CONTROLLARE
                P_VALORI_CONTROLLARE: valori da controllare nelle colonne
                                      P_CAMPI_CONTROLLARE
   RITORNA:     AFC_Error.ok se esistono periodi seguenti, 0 altrimenti
   ECCEZIONI:   --
   ANNOTAZIONI: --
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    23/06/2005 FTASSINARI Creazione.
   14   16/05/2007 FTASSINARI Aggiunto rowid
   15   16/07/2007 FT         Aggiunto controllo integrita sui parametri in input (check_parametri)
   17   25/11/2009 FT         Tolto controllo su p_campi_controllare in check_parametri
   ******************************************************************************/
   is
      v_result number;
      v_periodo t_periodo;
   begin
      DbC.PRE( not DbC.PreOn or afc.to_boolean( check_parametri( p_tabella
                                                               , p_nome_dal
                                                               , p_nome_al
                                                               )
                                              )
             , ' check_parametri on AFC_PERIODO.exists_seguenti'
             );
      -- chiamo la function get_seguente sul periodo in considerazione
      v_periodo := get_seguente( p_tabella
                               , p_nome_dal
                               , p_nome_al
                               , p_dal
                               , p_al
                               , p_campi_controllare
                               , p_valori_controllare
                               , p_rowid
                               );
      if ( v_periodo.DAL is null ) and ( v_periodo.AL is null )
      then
         v_result := 0;
      else
         v_result := AFC_Error.ok;
      end if;
      return v_result;
   end; -- AFC_Periodo.exists_seguenti
----------------------------------------------------------------------------------
   function existsSeguenti
   ( p_tabella            in     varchar2
   , p_nome_dal           in     varchar2
   , p_nome_al            in     varchar2
   , p_dal                in     date
   , p_al                 in     date
   , p_campi_controllare  in     varchar2
   , p_valori_controllare in     varchar2
   , p_rowid              in     rowid default null
   ) return boolean
   /******************************************************************************
   NOME:        existsSeguenti
   DESCRIZIONE: controlla se esistono periodi seguenti a quello passato come
                parametro, in relazione ai CAMPI_CONTROLLARE
   PARAMETRI:   P_TABELLA:            nome della tabella sulla quale eseguire la
                                      ricerca
                P_NOME_DAL:           nome della colonna nella quale cercare il
                                      valore P_DAL
                P_NOME_AL:            nome della colonna nella quale cercare il
                                      valore P_AL
                P_DAL:                valore da cercare nella colonna P_NOME_DAL
                P_AL:                 valore da cercare nella colonna P_NOME_AL
                P_CAMPI_CONTROLLARE:  nomi delle colonne sulle quali cercare i
                                      valore VALORI_CONTROLLARE
                P_VALORI_CONTROLLARE: valori da controllare nelle colonne
                                      P_CAMPI_CONTROLLARE
   RITORNA:     true se esistono periodi seguenti, false altrimenti
   ECCEZIONI:   --
   ANNOTAZIONI: (versione booleana di exists_seguenti)
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    23/06/2005 FTASSINARI Creazione.
   1    30/09/2005 FTASSINARI Eliminata dipendenza da AFC
   14   16/05/2007 FTASSINARI Aggiunto rowid
   ******************************************************************************/
   is
      v_result_number number;
      v_result boolean;
   begin
      v_result_number := exists_seguenti( p_tabella
                                        , p_nome_dal
                                        , p_nome_al
                                        , p_dal
                                        , p_al
                                        , p_campi_controllare
                                        , p_valori_controllare
                                        , p_rowid
                                        );
      if v_result_number = AFC_Error.ok
      then
         v_result := true;
      else
         v_result := false;
      end if;
      return v_result;
   end; -- AFC_Periodo.existsSeguenti
----------------------------------------------------------------------------------
   function exists_contenuti
   ( p_tabella            in     varchar2
   , p_nome_dal           in     varchar2
   , p_nome_al            in     varchar2
   , p_dal                in     date
   , p_al                 in     date
   , p_campi_controllare  in     varchar2
   , p_valori_controllare in     varchar2
   , p_rowid              in     rowid default null
   ) return number
   /******************************************************************************
   NOME:        exists_contenuti
   DESCRIZIONE: controlla se esistono periodi contenuti a quello passato come
                parametro, in relazione ai CAMPI_CONTROLLARE
   PARAMETRI:   P_TABELLA:            nome della tabella sulla quale eseguire la
                                      ricerca
                P_NOME_DAL:           nome della colonna nella quale cercare il
                                      valore P_DAL
                P_NOME_AL:            nome della colonna nella quale cercare il
                                      valore P_AL
                P_DAL:                valore da cercare nella colonna P_NOME_DAL
                P_AL:                 valore da cercare nella colonna P_NOME_AL
                P_CAMPI_CONTROLLARE:  nomi delle colonne sulle quali cercare i
                                      valore VALORI_CONTROLLARE
                P_VALORI_CONTROLLARE: valori da controllare nelle colonne
                                      P_CAMPI_CONTROLLARE
   RITORNA:     AFC_Error.ok se esistono periodi contenuti, 0 altrimenti
   ECCEZIONI:   --
   ANNOTAZIONI: --
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    23/06/2005 FTASSINARI Creazione.
   14   16/05/2007 FTASSINARI Aggiunto rowid
   15   16/07/2007 FT         Aggiunto controllo integrita sui parametri in input (check_parametri)
   17   25/11/2009 FT         Tolto controllo su p_campi_controllare in check_parametri
   ******************************************************************************/
   is
      v_result number;
      v_periodo t_periodo;
   begin
      DbC.PRE( not DbC.PreOn or afc.to_boolean( check_parametri( p_tabella
                                                               , p_nome_dal
                                                               , p_nome_al
                                                               )
                                              )
             , ' check_parametri on AFC_PERIODO.exists_contenuti'
             );
      -- chiamo la function get_contenuto sul periodo in considerazione
      v_periodo := get_contenuto( p_tabella
                                , p_nome_dal
                                , p_nome_al
                                , p_dal
                                , p_al
                                , p_campi_controllare
                                , p_valori_controllare
                                , p_rowid
                                );
      if ( v_periodo.DAL is null ) and ( v_periodo.AL is null )
      then
         v_result := 0;
      else
         v_result := AFC_Error.ok;
      end if;
      return v_result;
   end; -- AFC_Periodo.exists_contenuti
----------------------------------------------------------------------------------
   function existsContenuti
   ( p_tabella            in     varchar2
   , p_nome_dal           in     varchar2
   , p_nome_al            in     varchar2
   , p_dal                in     date
   , p_al                 in     date
   , p_campi_controllare  in     varchar2
   , p_valori_controllare in     varchar2
   , p_rowid              in     rowid default null
   ) return boolean
   /******************************************************************************
   NOME:        existsContenuti
   DESCRIZIONE: controlla se esistono periodi contenuti in quello passato come
                parametro, in relazione ai CAMPI_CONTROLLARE
   PARAMETRI:   P_TABELLA:            nome della tabella sulla quale eseguire la
                                      ricerca
                P_NOME_DAL:           nome della colonna nella quale cercare il
                                      valore P_DAL
                P_NOME_AL:            nome della colonna nella quale cercare il
                                      valore P_AL
                P_DAL:                valore da cercare nella colonna P_NOME_DAL
                P_AL:                 valore da cercare nella colonna P_NOME_AL
                P_CAMPI_CONTROLLARE:  nomi delle colonne sulle quali cercare i
                                      valore VALORI_CONTROLLARE
                P_VALORI_CONTROLLARE: valori da controllare nelle colonne
                                      P_CAMPI_CONTROLLARE
   RITORNA:     true se esistono periodi contenuti, false altrimenti
   ECCEZIONI:   --
   ANNOTAZIONI: (versione booleana di exists_contenuti)
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    23/06/2005 FTASSINARI Creazione.
   1    30/09/2005 FTASSINARI Eliminata dipendenza da AFC
   14   16/05/2007 FTASSINARI Aggiunto rowid
   ******************************************************************************/
   is
      v_result_number number;
      v_result boolean;
   begin
      v_result_number := exists_contenuti( p_tabella
                                         , p_nome_dal
                                         , p_nome_al
                                         , p_dal
                                         , p_al
                                         , p_campi_controllare
                                         , p_valori_controllare
                                         , p_rowid
                                         );
      if v_result_number = AFC_Error.ok
      then
         v_result := true;
      else
         v_result := false;
      end if;
      return v_result;
   end; -- AFC_Periodo.existsContenuti
----------------------------------------------------------------------------------
   function exists_intersecati
   ( p_tabella            in     varchar2
   , p_nome_dal           in     varchar2
   , p_nome_al            in     varchar2
   , p_dal                in     date
   , p_al                 in     date
   , p_campi_controllare  in     varchar2
   , p_valori_controllare in     varchar2
   , p_rowid              in     rowid default null
   ) return number
   /******************************************************************************
   NOME:        exists_intersecati
   DESCRIZIONE: controlla se esistono periodi intersecano quello passato come
                parametro, in relazione ai CAMPI_CONTROLLARE
   PARAMETRI:   P_TABELLA:            nome della tabella sulla quale eseguire la
                                      ricerca
                P_NOME_DAL:           nome della colonna nella quale cercare il
                                      valore P_DAL
                P_NOME_AL:            nome della colonna nella quale cercare il
                                      valore P_AL
                P_DAL:                valore da cercare nella colonna P_NOME_DAL
                P_AL:                 valore da cercare nella colonna P_NOME_AL
                P_CAMPI_CONTROLLARE:  nomi delle colonne sulle quali cercare i
                                      valore VALORI_CONTROLLARE
                P_VALORI_CONTROLLARE: valori da controllare nelle colonne
                                      P_CAMPI_CONTROLLARE
   RITORNA:     AFC_Error.ok se esistono periodi intersecanti, 0 altrimenti
   ECCEZIONI:   --
   ANNOTAZIONI: --
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    23/06/2005 FTASSINARI Creazione.
   14   16/05/2007 FTASSINARI Aggiunto rowid
   15   16/07/2007 FT         Aggiunto controllo integrita sui parametri in input (check_parametri)
   17   25/11/2009 FT         Tolto controllo su p_campi_controllare in check_parametri
   ******************************************************************************/
   is
      v_result number;
      v_periodo t_periodo;
   begin
      DbC.PRE( not DbC.PreOn or afc.to_boolean( check_parametri( p_tabella
                                                               , p_nome_dal
                                                               , p_nome_al
                                                               )
                                              )
             , ' check_parametri on AFC_PERIODO.exists_intersecati'
             );
      -- chiamo la function get_intersecato_sx sul periodo in considerazione
      v_periodo := get_intersecato_inizio( p_tabella
                                         , p_nome_dal
                                         , p_nome_al
                                         , p_dal
                                         , p_al
                                         , p_campi_controllare
                                         , p_valori_controllare
                                         , p_rowid
                                         );
      if ( v_periodo.dal is null ) and ( v_periodo.al is null )
      then
         -- controllo che non ci siano periodi intersecanti sull'estremo dx
         v_periodo := get_intersecato_fine( p_tabella
                                          , p_nome_dal
                                          , p_nome_al
                                          , p_dal
                                          , p_al
                                          , p_campi_controllare
                                          , p_valori_controllare
                                          , p_rowid
                                          );
         if ( v_periodo.dal is null ) and ( v_periodo.al is null )
         then
            v_result := 0;
         else
            v_result := AFC_Error.ok;
         end if;
      else
         v_result := AFC_Error.ok;
      end if;
      return v_result;
   end; -- AFC_Periodo.exists_intersecati
----------------------------------------------------------------------------------
   function existsIntersecati
   ( p_tabella            in     varchar2
   , p_nome_dal           in     varchar2
   , p_nome_al            in     varchar2
   , p_dal                in     date
   , p_al                 in     date
   , p_campi_controllare  in     varchar2
   , p_valori_controllare in     varchar2
   , p_rowid              in     rowid default null
   ) return boolean
   /******************************************************************************
   NOME:        existsIntersecati
   DESCRIZIONE: controlla se esistono periodi che intersecano quello passato come
                parametro, in relazione ai CAMPI_CONTROLLARE
   PARAMETRI:   P_TABELLA:            nome della tabella sulla quale eseguire la
                                      ricerca
                P_NOME_DAL:           nome della colonna nella quale cercare il
                                      valore P_DAL
                P_NOME_AL:            nome della colonna nella quale cercare il
                                      valore P_AL
                P_DAL:                valore da cercare nella colonna P_NOME_DAL
                P_AL:                 valore da cercare nella colonna P_NOME_AL
                P_CAMPI_CONTROLLARE:  nomi delle colonne sulle quali cercare i
                                      valore VALORI_CONTROLLARE
                P_VALORI_CONTROLLARE: valori da controllare nelle colonne
                                      P_CAMPI_CONTROLLARE
   RITORNA:     true se esistono periodi intersecanti, false altrimenti
   ECCEZIONI:   --
   ANNOTAZIONI: (versione booleana di exists_contenuti)
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    23/06/2005 FTASSINARI Creazione.
   1    30/09/2005 FTASSINARI Eliminata dipendenza da AFC
   14   16/05/2007 FTASSINARI Aggiunto rowid
   ******************************************************************************/
   is
      v_result_number number;
      v_result boolean;
   begin
      v_result_number := exists_intersecati( p_tabella
                                           , p_nome_dal
                                           , p_nome_al
                                           , p_dal
                                           , p_al
                                           , p_campi_controllare
                                           , p_valori_controllare
                                           , p_rowid
                                           );
      if v_result_number = AFC_Error.ok
      then
         v_result := true;
      else
         v_result := false;
      end if;
      return v_result;
   end; -- AFC_Periodo.existsIntersecati
----------------------------------------------------------------------------------
   function exists_non_inclusi
   ( p_tabella            in     varchar2
   , p_nome_dal           in     varchar2
   , p_nome_al            in     varchar2
   , p_dal                in     date
   , p_al                 in     date
   , p_campi_controllare  in     varchar2
   , p_valori_controllare in     varchar2
   , p_rowid              in     rowid default null
   ) return number
   /******************************************************************************
   NOME:        exists_non_inclusi
   DESCRIZIONE: controlla se esistono periodi che non sono inclusi in quello passato
                come parametro, in relazione ai CAMPI_CONTROLLARE
   PARAMETRI:   P_TABELLA:            nome della tabella sulla quale eseguire la
                                      ricerca
                P_NOME_DAL:           nome della colonna nella quale cercare il
                                      valore P_DAL
                P_NOME_AL:            nome della colonna nella quale cercare il
                                      valore P_AL
                P_DAL:                valore da cercare nella colonna P_NOME_DAL
                P_AL:                 valore da cercare nella colonna P_NOME_AL
                P_CAMPI_CONTROLLARE:  nomi delle colonne sulle quali cercare i
                                      valore VALORI_CONTROLLARE
                P_VALORI_CONTROLLARE: valori da controllare nelle colonne
                                      P_CAMPI_CONTROLLARE
   RITORNA:     AFC_Error.ok se esistono periodi non inclusi, 0 altrimenti
   ECCEZIONI:   --
   ANNOTAZIONI: --
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    06/04/2006 FTASSINARI Creazione.
   1    19/04/2006 FTASSINARI utilizzo di get_non_incluso al posto di get_precedente,
                              get_intersecato e get_seguente
   14   16/05/2007 FTASSINARI Aggiunto rowid
   15   16/07/2007 FT         Aggiunto controllo integrita sui parametri in input (check_parametri)
   17   25/11/2009 FT         Tolto controllo su p_campi_controllare in check_parametri
   ******************************************************************************/
   is
      d_periodo t_periodo;
      d_result number;
   begin
      DbC.PRE( not DbC.PreOn or afc.to_boolean( check_parametri( p_tabella
                                                               , p_nome_dal
                                                               , p_nome_al
                                                               )
                                              )
             , ' check_parametri on AFC_PERIODO.exists_non_inclusi'
             );
      d_periodo := get_non_incluso( p_tabella => p_tabella
                                  , p_nome_dal => p_nome_dal
                                  , p_nome_al => p_nome_al
                                  , p_dal => p_dal
                                  , p_al => p_al
                                  , p_campi_controllare => p_campi_controllare
                                  , p_valori_controllare => p_valori_controllare
                                  , p_rowid => p_rowid
                                  );
      if  d_periodo.dal is null
      and d_periodo.al is null
      then
         d_result := 0;
      else
         d_result := AFC_Error.ok;
      end if;
      return d_result;
   end; -- AFC_Periodo.exists_non_inclusi
----------------------------------------------------------------------------------
   function existsNonInclusi
   ( p_tabella            in     varchar2
   , p_nome_dal           in     varchar2
   , p_nome_al            in     varchar2
   , p_dal                in     date
   , p_al                 in     date
   , p_campi_controllare  in     varchar2
   , p_valori_controllare in     varchar2
   , p_rowid              in     rowid default null
   ) return boolean
   /******************************************************************************
   NOME:        existsNonInclusi
   DESCRIZIONE: controlla se esistono periodi che non sono inclusi in quello passato
                come parametro, in relazione ai CAMPI_CONTROLLARE
   PARAMETRI:   P_TABELLA:            nome della tabella sulla quale eseguire la
                                      ricerca
                P_NOME_DAL:           nome della colonna nella quale cercare il
                                      valore P_DAL
                P_NOME_AL:            nome della colonna nella quale cercare il
                                      valore P_AL
                P_DAL:                valore da cercare nella colonna P_NOME_DAL
                P_AL:                 valore da cercare nella colonna P_NOME_AL
                P_CAMPI_CONTROLLARE:  nomi delle colonne sulle quali cercare i
                                      valore VALORI_CONTROLLARE
                P_VALORI_CONTROLLARE: valori da controllare nelle colonne
                                      P_CAMPI_CONTROLLARE
   RITORNA:     true se esistono periodi non inclusi, false altrimenti
   ECCEZIONI:   --
   ANNOTAZIONI: (versione booleana di exists_contenuti)
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    06/04/2006 FTASSINARI Creazione.
   14   16/05/2007 FTASSINARI Aggiunto rowid
   ******************************************************************************/
   is
      v_result_number number;
      v_result boolean;
   begin
      v_result_number := exists_non_inclusi( p_tabella => p_tabella
                                           , p_nome_dal => p_nome_dal
                                           , p_nome_al => p_nome_al
                                           , p_dal => p_dal
                                           , p_al => p_al
                                           , p_campi_controllare => p_campi_controllare
                                           , p_valori_controllare => p_valori_controllare
                                           , p_rowid => p_rowid
                                           );
      if v_result_number = AFC_Error.ok
      then
         v_result := true;
      else
         v_result := false;
      end if;
      return v_result;
   end; -- AFC_Periodo.existsNonInclusi
----------------------------------------------------------------------------------
   function get_primo
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date default null
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   , p_rowid              in varchar2 default null
   ) return t_periodo
   /******************************************************************************
    NOME:        get_primo
    DESCRIZIONE: Restituisce il primo periodo, tra i periodi contigui al periodo indicato,
                 cercando i record che hanno lo stesso valore indicato per i campi elencati.
    PARAMETRI:   p_tabella            IN VARCHAR2: nome tavola da analizzare
                 p_nome_dal           IN VARCHAR2: nome colonna fine periodo
                 p_nome_al            IN VARCHAR2: nome colonna inizio periodo
                 p_dal                IN DATE: data di confronto
                 p_campi_controllare  IN VARCHAR2: elenco campi da controllare
                 p_valori_controllare IN VARCHAR2: elenco valori da controllare
                 P_ROWID              IN VARCHAR2: rowid del record passato come parametro
                                                   (di default e null)
    RITORNA:     t_periodo: il primo periodo per uguaglianza dei valori nei campi indicati
    ECCEZIONI:   --
    ANNOTAZIONI: se p_dal is not null, restituisce il primo periodo considerando periodi
                 contigui; se p_dal is null restituisce il primo periodo in assoluto
    REVISIONI:
    Rev. Data       Autore     Descrizione
    ---- ---------- ---------- ------------------------------------------------------
    0    23/09/2005 FTASSINARI Prima emissione.
    1    28/09/2005 FTASSINARI utilizzo di estrazione_val e rowid, aggiunta di to_char(...)
                               nella select
    2    28/04/2006 FTASSINARI in caso p_dal null, modificata condizione di where per
                               considerare anche periodi aperti
    15   16/07/2007 FT         Aggiunto controllo integrita sui parametri in input (check_parametri)
    17   25/11/2009 FT         Tolto controllo su p_campi_controllare in check_parametri
   ******************************************************************************/
   is
      go boolean;
      v_periodo t_periodo;
      v_result number;
      v_statement varchar2 (32000);
      v_campi_controllare varchar2(32000);
      d_dal varchar2(10);
      d_al varchar2(10);
   begin
      DbC.PRE( not DbC.PreOn or afc.to_boolean( check_parametri( p_tabella
                                                               , p_nome_dal
                                                               , p_nome_al
                                                               )
                                              )
             , ' check_parametri on AFC_PERIODO.get_primo'
             );
      if p_dal is not null
      then
         -- devo restituire il primo periodo considerando periodi contigui
         go := true;
         v_periodo.DAL := p_dal;
         d_dal := to_char ( p_dal, 'ddmmyyyy' );
         while go loop
            -- compongo le condizioni di ricerca relative a campi_controllare
            estrazione_condizioni( p_campi_controllare
                                 , p_valori_controllare
                                 , v_campi_controllare
                                 );
            crea_select( p_nome_dal
                       , p_nome_al
                       , p_tabella
                       , v_statement
                       );
            -- compongo la stringa di select che devo eseguire
            v_statement := v_statement
                        || v_campi_controllare
                        || ' nvl(' || p_nome_al || ', to_date(''3333333'',''j'')) '
                        || ' = to_date( ''' || d_dal || ''', ''ddmmyyyy'' ) - 1 '
                        || ' and rowid != nvl( ''' || p_rowid || ''', ''0'' )';
            v_result := estrazione_val( v_statement
                                      , d_dal
                                      , d_al
                                      );
            if v_result = AFC_Error.ok
            then
               go := true;
               v_periodo.DAL := to_date( d_dal, 'ddmmyyyy' );
               v_periodo.AL := to_date( d_al, 'ddmmyyyy' );
            else
               go := false;
            end if;
         end loop;
         if v_periodo.DAL = p_dal
         then
            -- il periodo passato � il primo
            -- compongo le condizioni di ricerca relative a campi_controllare
            estrazione_condizioni( p_campi_controllare
                                 , p_valori_controllare
                                 , v_campi_controllare
                                 );
            crea_select( p_nome_dal
                       , p_nome_al
                       , p_tabella
                       , v_statement
                       );
            -- compongo la stringa di select che devo eseguire
            v_statement := v_statement
                        || v_campi_controllare
                        || ' nvl(' || p_nome_dal || ', to_date(''3333333'',''j'')) '
                        || ' = to_date( ''' || to_char( p_dal, 'ddmmyyyy' ) || ''', ''ddmmyyyy'' ) '
                        || ' order by ' || p_nome_al || ' asc';
            v_result := estrazione_val( v_statement
                                      , d_dal
                                      , d_al
                                      );
            if v_result = AFC_Error.ok
            then
               v_periodo.DAL := to_date( d_dal, 'ddmmyyyy' );
               v_periodo.AL := to_date( d_al, 'ddmmyyyy' );
            else
               raise_application_error( dal_not_found_number, 'Dal non presente nella table' );
            end if;
         end if;
      else
         -- restituisco il primo periodo in assoluto
         -- compongo le condizioni di ricerca relative a campi_controllare
         estrazione_condizioni( p_campi_controllare
                              , p_valori_controllare
                              , v_campi_controllare
                              );
         crea_select( p_nome_dal
                    , p_nome_al
                    , p_tabella
                    , v_statement
                    );
         -- compongo la stringa di select che devo eseguire
         v_statement := v_statement
                     || v_campi_controllare
                     || ' 1 = 1 '
                     || ' order by ' || p_nome_dal || ' asc';
         v_result := estrazione_val( v_statement
                                   , d_dal
                                   , d_al
                                   );
         if v_result = AFC_Error.ok
         then
            v_periodo.DAL := to_date( d_dal, 'ddmmyyyy' );
            v_periodo.AL := to_date( d_al, 'ddmmyyyy' );
         else
            v_periodo.DAL := null;
            v_periodo.AL := null;
         end if;
      end if;
      return v_periodo;
   end; -- AFC_Periodo.get_primo;
----------------------------------------------------------------------------------
   function get_primo_dal
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date default null
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   , p_rowid              in varchar2 default null
   ) return date
   /******************************************************************************
    NOME:        get_primo_dal
    DESCRIZIONE: Restituisce la data di inizio del primo periodo, tra i periodi contigui al
                 periodo indicato, cercando i record che hanno lo stesso valore indicato per
                 i campi elencati.
    PARAMETRI:   p_tabella            IN VARCHAR2: nome tavola da analizzare
                 p_nome_dal           IN VARCHAR2: nome colonna fine periodo
                 p_nome_al            IN VARCHAR2: nome colonna inizio periodo
                 p_dal                IN DATE: data di confronto
                 p_campi_controllare  IN VARCHAR2: elenco campi da controllare
                 p_valori_controllare IN VARCHAR2: elenco valori da controllare
                 P_ROWID              IN VARCHAR2: rowid del record passato come parametro
                                                   (di default e null)
    RITORNA:     date: la data di inizio del primo periodo per uguaglianza dei valori
                 nei campi indicati
    ECCEZIONI:   --
    ANNOTAZIONI: se p_dal is not null, restituisce il primo periodo considerando periodi
                 contigui; se p_dal is null restituisce il primo periodo in assoluto
    REVISIONI:
    Rev. Data       Autore     Descrizione
    ---- ---------- ---------- ------------------------------------------------------
    0    26/09/2005 FTASSINARI Prima emissione.
    1    28/09/2005 FTASSINARI utilizzo della rowid
   ******************************************************************************/
   is
      d_periodo t_periodo;
      d_dal date;
   begin
      d_periodo := get_primo( p_tabella
                            , p_nome_dal
                            , p_nome_al
                            , p_dal
                            , p_campi_controllare
                            , p_valori_controllare
                            , p_rowid
                            );
      d_dal := d_periodo.DAL;
      return d_dal;
   end; -- AFC_Periodo.get_primo;
----------------------------------------------------------------------------------
   function get_ultimo
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_al                 in date default null
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   , p_rowid              in varchar2 default null
   ) return t_periodo
   /******************************************************************************
    NOME:        get_ultimo
    DESCRIZIONE: Restituisce l'ultimo periodo, tra i periodi contigui al
                 periodo indicato, cercando i record che hanno lo stesso
                 valore indicato per i campi elencati.
    PARAMETRI:   p_tabella            IN VARCHAR2: nome tavola da analizzare
                 p_nome_dal           IN VARCHAR2: nome colonna fine periodo
                 p_nome_al            IN VARCHAR2: nome colonna inizio periodo
                 p_al                 IN DATE: data di confronto
                 p_campi_controllare  IN VARCHAR2: elenco campi da controllare
                 p_valori_controllare IN VARCHAR2: elenco valori da controllare
                 P_ROWID              IN VARCHAR2: rowid del record passato come parametro
                                                   (di default e null)
    RITORNA:     t_periodo: l'ultimo periodo per uguaglianza dei valori nei campi indicati
    ECCEZIONI:   --
    ANNOTAZIONI: se p_al is not null, restituisce il primo periodo considerando periodi
                 contigui; se p_dal is null restituisce il primo periodo in assoluto
    REVISIONI:
    Rev. Data       Autore     Descrizione
    ---- ---------- ---------- ------------------------------------------------------
    0    23/09/2005 FTASSINARI Prima emissione.
    1    28/09/2005 FTASSINARI utilizzo di estrazione_val e rowid, aggiunta di to_char(...)
                               nella select
    2    28/04/2006 FTASSINARI in caso p_al null, modificata condizione di where per
                               considerare anche periodi aperti
    15   16/07/2007 FT         Aggiunto controllo integrita sui parametri in input (check_parametri)
    17   25/11/2009 FT         Tolto controllo su p_campi_controllare in check_parametri
   ******************************************************************************/
   is
      go boolean;
      v_periodo t_periodo;
      d_dal varchar2(10);
      d_al varchar2(10);
      v_result number;
      v_statement varchar2 (32000);
      v_campi_controllare varchar2(32000);
   begin
      DbC.PRE( not DbC.PreOn or afc.to_boolean( check_parametri( p_tabella
                                                               , p_nome_dal
                                                               , p_nome_al
                                                               )
                                              )
             , ' check_parametri on AFC_PERIODO.get_ultimo'
             );
      if p_al is not null
      then
         -- devo restituire il primo periodo considerando periodi contigui
         go := true;
         v_periodo.AL := p_al;
         d_al := to_char ( p_al, 'ddmmyyyy' );
         while go loop
            -- compongo le condizioni di ricerca relative a campi_controllare
            estrazione_condizioni( p_campi_controllare
                                 , p_valori_controllare
                                 , v_campi_controllare
                                 );
            crea_select( p_nome_dal
                       , p_nome_al
                       , p_tabella
                       , v_statement
                       );
            -- compongo la stringa di select che devo eseguire
            v_statement := v_statement
                        || v_campi_controllare
                        || ' nvl(' || p_nome_dal || ', to_date(''3333333'',''j'')) '
                        || ' = to_date( ''' || d_al || ''', ''ddmmyyyy'' ) + 1 '
                        || ' and rowid != nvl( ''' || p_rowid || ''', ''0'' )';
            v_result := estrazione_val( v_statement
                                      , d_dal
                                      , d_al
                                      );
            if v_result = AFC_Error.ok
            then
               go := true;
               v_periodo.DAL := to_date( d_dal, 'ddmmyyyy' );
               v_periodo.AL := to_date( d_al, 'ddmmyyyy' );
            else
               go := false;
            end if;
         end loop;
         if v_periodo.AL = p_al
         then
            -- il periodo passato � il primo
            -- compongo le condizioni di ricerca relative a campi_controllare
            estrazione_condizioni( p_campi_controllare
                                 , p_valori_controllare
                                 , v_campi_controllare
                                 );
            crea_select( p_nome_dal
                       , p_nome_al
                       , p_tabella
                       , v_statement
                       );
            -- compongo la stringa di select che devo eseguire
            v_statement := v_statement
                        || v_campi_controllare
                        || ' nvl(' || p_nome_al || ', to_date(''3333333'',''j'')) '
                        || ' = to_date( ''' || to_char( p_al, 'ddmmyyyy' ) || ''', ''ddmmyyyy'' ) '
                        || ' order by ' || p_nome_dal || ' desc';
            v_result := estrazione_val( v_statement
                                      , d_dal
                                      , d_al
                                      );
            if v_result = AFC_Error.ok
            then
               v_periodo.DAL := to_date( d_dal, 'ddmmyyyy' );
               v_periodo.AL := to_date( d_al, 'ddmmyyyy' );
            else
               raise_application_error( al_not_found_number, 'Al non presente nella table' );
            end if;
         end if;
      else
         -- restituisco il primo periodo in assoluto
         -- compongo le condizioni di ricerca relative a campi_controllare
         estrazione_condizioni( p_campi_controllare
                              , p_valori_controllare
                              , v_campi_controllare
                              );
         crea_select( p_nome_dal
                    , p_nome_al
                    , p_tabella
                    , v_statement
                    );
         -- compingo la stringa di select che devo eseguire
         v_statement := v_statement
                     || v_campi_controllare
                     || ' 1 = 1 '
                     || ' order by ' || p_nome_al || ' desc';
         v_result := estrazione_val( v_statement
                                   , d_dal
                                   , d_al
                                   );
         if v_result = AFC_Error.ok
         then
            v_periodo.dal := to_date( d_dal, 'ddmmyyyy' );
            v_periodo.al := to_date( d_al, 'ddmmyyyy' );
         else
            v_periodo.dal := null;
            v_periodo.al := null;
         end if;
      end if;
      return v_periodo;
   end; -- AFC_Periodo.get_ultimo
----------------------------------------------------------------------------------
   function get_ultimo_al
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_al                 in date default null
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   , p_rowid              in varchar2 default null
   ) return date
   /******************************************************************************
    NOME:        get_ultimo_al
    DESCRIZIONE: Restituisce la data di fine dell'ultimo periodo, tra i periodi contigui al
                 periodo indicato, cercando i record
                 che hanno lo stesso valore indicato per i campi elencati.
    PARAMETRI:   p_tabella            IN VARCHAR2: nome tavola da analizzare
                 p_nome_dal           IN VARCHAR2: nome colonna fine periodo
                 p_nome_al            IN VARCHAR2: nome colonna inizio periodo
                 p_al                 IN DATE: data di confronto
                 p_campi_controllare  IN VARCHAR2: elenco campi da controllare
                 p_valori_controllare IN VARCHAR2: elenco valori da controllare
                 P_ROWID              IN VARCHAR2: rowid del record passato come parametro
                                                   (di default e null)
    RITORNA:     date: la data di fine dell'ultimo periodo per uguaglianza dei valori
                 nei campi indicati
    ECCEZIONI:   --
    ANNOTAZIONI: se p_dal is not null, restituisce il primo periodo considerando periodi
                 contigui; se p_dal is null restituisce il primo periodo in assoluto
    REVISIONI:
    Rev. Data       Autore     Descrizione
    ---- ---------- ---------- ------------------------------------------------------
    0    26/09/2005 FTASSINARI Prima emissione.
    1    28/09/2005 FTASSINARI utilizzo della rowid
   ******************************************************************************/
   is
      d_periodo t_periodo;
      d_al date;
   begin
      d_periodo := get_ultimo( p_tabella
                             , p_nome_dal
                             , p_nome_al
                             , p_al
                             , p_campi_controllare
                             , p_valori_controllare
                             , p_rowid
                             );
      d_al := d_periodo.AL;
      return d_al;
   end; -- AFC_Periodo.get_ultimo_al;
----------------------------------------------------------------------------------
   function is_primo
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   ) return number
   /******************************************************************************
    NOME:        is_primo
    DESCRIZIONE: Indica se il periodo � il primo record, cercando tra i periodi contigui al
                 periodo indicato, con i valori richiesti nei campi indicati e date contigue.
    PARAMETRI: p_tabella            IN VARCHAR2: nome tavola da analizzare
               p_nome_dal           IN VARCHAR2: nome colonna inizio periodo
               p_nome_al            IN VARCHAR2: nome colonna fine periodo
               p_dal                IN DATE    : valore dal del record in esame
               p_al                 IN DATE    : valore al del record in esame
               p_campi_controllare  IN VARCHAR2: elenco campi da controllare
               p_valori_controllare IN VARCHAR2: elenco valori da controllare
    RITORNA:   NUMBER: AFC_Error.ok se il record � il primo con le caratteristiche date
    ECCEZIONI: --
    ANNOTAZIONI: Gli elenchi sono delimitati dal carattere '#'
    REVISIONI:
    Rev. Data       Autore     Descrizione
    ---- ---------- ---------- ------------------------------------------------------
    0    23/09/2005 FTASSINARI Prima emissione.
    15   16/07/2007 FT         Aggiunto controllo integrita sui parametri in input (check_parametri)
    17   25/11/2009 FT         Tolto controllo su p_campi_controllare in check_parametri
   ******************************************************************************/
   is
      v_result number;
      d_dal varchar2(10);
      d_al varchar2(10);
      v_campi_controllare varchar2(32000);
      v_statement varchar2 (32000);
   begin
      DbC.PRE( not DbC.PreOn or afc.to_boolean( check_parametri( p_tabella
                                                               , p_nome_dal
                                                               , p_nome_al
                                                               )
                                              )
             , ' check_parametri on AFC_PERIODO.is_primo'
             );
      -- compongo le condizioni di ricerca relative a campi_controllare
      estrazione_condizioni( p_campi_controllare
                           , p_valori_controllare
                           , v_campi_controllare
                           );
      -- compongo la stringa di select che devo eseguire
      v_statement := 'select to_char(' || p_nome_dal || ', ''ddmmyyyy'' ),'
                  || '       to_char(' || p_nome_al || ', ''ddmmyyyy'' )'
                  || ' from ' || p_tabella
                  || v_campi_controllare
                  || p_nome_al || ' = to_date( ''' || to_char( p_dal, 'ddmmyyyy' ) || ''', ''ddmmyyyy'' ) - 1 '
                  ;
      v_result := estrazione_val( v_statement
                                , d_dal
                                , d_al
                                );
      if v_result = AFC_Error.ok
      then
         v_result := 0;
      else
         v_result := AFC_Error.ok;
      end if;
      return v_result;
   end; -- AFC_Periodo.is_primo ;
----------------------------------------------------------------------------------
   function isPrimo
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   ) return boolean
   /******************************************************************************
    NOME:        isPrimo
    DESCRIZIONE: Indica se il periodo � il primo record, cercando tra i periodi contigui al
                 periodo indicato, con i valori richiesti nei campi indicati e date contigue.
    PARAMETRI: p_tabella            IN VARCHAR2: nome tavola da analizzare
               p_nome_dal           IN VARCHAR2: nome colonna inizio periodo
               p_nome_al            IN VARCHAR2: nome colonna fine periodo
               p_dal                IN DATE    : valore dal del record in esame
               p_al                 IN DATE    : valore al del record in esame
               p_campi_controllare  IN VARCHAR2: elenco campi da controllare
               p_valori_controllare IN VARCHAR2: elenco valori da controllare
    RITORNA:   BOOLEAN: true: se il record � il primo con le caratteristiche date
    ECCEZIONI: --
    ANNOTAZIONI: Gli elenchi sono delimitati dal carattere '#'; versione booleana di
                 is_primo
    REVISIONI:
    Rev. Data       Autore     Descrizione
    ---- ---------- ---------- ------------------------------------------------------
    0    23/09/2005 FTASSINARI Prima emissione.
    1    30/09/2005 FTASSINARI Eliminata dipendenza da AFC
   ******************************************************************************/
   is
      v_result_number number;
      v_result boolean;
   begin
      v_result_number := is_primo( p_tabella
                                 , p_nome_dal
                                 , p_nome_al
                                 , p_dal
                                 , p_al
                                 , p_campi_controllare
                                 , p_valori_controllare
                                 );
      if v_result_number = AFC_Error.ok
      then
         v_result := true;
      else
         v_result := false;
      end if;
      return v_result;
   end; -- AFC_Periodo.isPrimo ;
----------------------------------------------------------------------------------
   function is_ultimo
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   ) return number
   /******************************************************************************
    NOME:        is_ultimo
    DESCRIZIONE: Indica se il periodo � l'ultimo record , cercando tra i periodi contigui al
                 periodo indicato, con i valori richiesti nei campi indicati e date contigue.
    PARAMETRI: p_tabella            IN VARCHAR2: nome tavola da analizzare
               p_nome_dal           IN VARCHAR2: nome colonna inizio periodo
               p_nome_al            IN VARCHAR2: nome colonna fine periodo
               p_dal                IN DATE    : valore dal del record in esame
               p_al                 IN DATE    : valore al del record in esame
               p_campi_controllare  IN VARCHAR2: elenco campi da controllare
               p_valori_controllare IN VARCHAR2: elenco valori da controllare
    RITORNA:   NUMBER: AFC_Error.ok se il record � l'ultimo con le caratteristiche date
    ECCEZIONI: --
    ANNOTAZIONI: Gli elenchi sono delimitati dal carattere '#'
    REVISIONI:
    Rev. Data       Autore     Descrizione
    ---- ---------- ---------- ------------------------------------------------------
    0    23/09/2005 FTASSINARI Prima emissione.
    15   16/07/2007 FT         Aggiunto controllo integrita sui parametri in input (check_parametri)
    17   25/11/2009 FT         Tolto controllo su p_campi_controllare in check_parametri
   ******************************************************************************/
   is
      v_result number;
      d_dal varchar2(10);
      d_al varchar2(10);
      v_campi_controllare varchar2(32000);
      v_statement varchar2 (32000);
   begin
      DbC.PRE( not DbC.PreOn or afc.to_boolean( check_parametri( p_tabella
                                                               , p_nome_dal
                                                               , p_nome_al
                                                               )
                                              )
             , ' check_parametri on AFC_PERIODO.is_ultimo'
             );
      -- compongo le condizioni di ricerca relative a campi_controllare
      estrazione_condizioni( p_campi_controllare
                           , p_valori_controllare
                           , v_campi_controllare
                           );
      -- compongo la stringa di select che devo eseguire
      v_statement := 'select to_char(' || p_nome_dal || ', ''ddmmyyyy'' ),'
                  || '       to_char(' || p_nome_al || ', ''ddmmyyyy'' )'
                  || ' from ' || p_tabella
                  || v_campi_controllare
                  || p_nome_dal || ' = to_date( ''' || to_char( p_al, 'ddmmyyyy' ) || ''', ''ddmmyyyy'' ) + 1 '
                  ;
      v_result := estrazione_val( v_statement
                                , d_dal
                                , d_al
                                );
      if v_result = AFC_Error.ok
      then
         v_result := 0;
      else
         v_result := AFC_Error.ok;
      end if;
      return v_result;
   end; -- AFC_Periodo.is_ultimo ;
----------------------------------------------------------------------------------
   function isUltimo
   ( p_tabella            in varchar2
   , p_nome_dal            in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   ) return boolean
   /******************************************************************************
    NOME:        isUltimo
    DESCRIZIONE: Indica se il periodo � l'ultimo record , cercando tra i periodi contigui al
                 periodo indicato, con i valori richiesti nei campi indicati e date contigue.
    PARAMETRI: p_tabella            IN VARCHAR2: nome tavola da analizzare
               p_nome_dal           IN VARCHAR2: nome colonna inizio periodo
               p_nome_al            IN VARCHAR2: nome colonna fine periodo
               p_dal                IN DATE    : valore dal del record in esame
               p_al                 IN DATE    : valore al del record in esame
               p_campi_controllare  IN VARCHAR2: elenco campi da controllare
               p_valori_controllare IN VARCHAR2: elenco valori da controllare
    RITORNA:   BOOLEAN: true: se il record � l'ultimo con le caratteristiche date
    ECCEZIONI: --
    ANNOTAZIONI: Gli elenchi sono delimitati dal carattere '#'; versione booleana di
                 is_ultimo
    REVISIONI:
    Rev. Data       Autore     Descrizione
    ---- ---------- ---------- ------------------------------------------------------
    0    23/09/2005 FTASSINARI Prima emissione.
    1    30/09/2005 FTASSINARI Eliminata dipendenza da AFC
   ******************************************************************************/
   is
      v_result_number number;
      v_result boolean;
   begin
      v_result_number := is_ultimo( p_tabella
                                  , p_nome_dal
                                  , p_nome_al
                                  , p_dal
                                  , p_al
                                  , p_campi_controllare
                                  , p_valori_controllare
                                  );
      if v_result_number = AFC_Error.ok
      then
         v_result := true;
      else
         v_result := false;
      end if;
      return v_result;
   end; -- AFC_Periodo.isUltimo ;
----------------------------------------------------------------------------------
   function get_precedente
   ( p_tabella            in     varchar2
   , p_nome_dal           in     varchar2
   , p_nome_al            in     varchar2
   , p_dal                in     date
   , p_al                 in     date
   , p_campi_controllare  in     varchar2
   , p_valori_controllare in     varchar2
   , p_rowid              in     rowid default null
   ) return t_periodo
   /******************************************************************************
   NOME:        get_precedente
   DESCRIZIONE: ritorna il periodo precedente a quello passato come parametro,
                in relazione ai CAMPI_CONTROLLARE
   PARAMETRI:   P_TABELLA:            nome della tabella sulla quale eseguire la
                                      ricerca
                P_NOME_DAL:           nome della colonna nella quale cercare il
                                      valore P_DAL
                P_NOME_AL:            nome della colonna nella quale cercare il
                                      valore P_AL
                P_DAL:                valore da cercare nella colonna P_NOME_DAL
                P_AL:                 valore da cercare nella colonna P_NOME_AL
                P_CAMPI_CONTROLLARE:  nomi delle colonne sulle quali cercare i
                                      valore VALORI_CONTROLLARE
                P_VALORI_CONTROLLARE: valori da controllare nelle colonne
                                      P_CAMPI_CONTROLLARE
   RITORNA:     il periodo precedente a quello passato come parametro
   ECCEZIONI:   --
   ANNOTAZIONI: --
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    21/06/2005 FTASSINARI Creazione.
   1    28/09/2005 FTASSINARI utilizzo di estrazione_val, aggiunta di to_char(...)
                              nella select
   2    19/04/2006 FTASSINARI controllo sulla data DAL
   13   28/09/2006 FTASSINARI Aggiunta rowid
   14   16/05/2007 FTASSINARI Aggiunto nvl e conversione corretta su parametri date
   15   16/07/2007 FT         Aggiunto controllo integrita sui parametri in input (check_parametri)
   17   25/11/2009 FT         Tolto controllo su p_campi_controllare in check_parametri
   ******************************************************************************/
   IS
      v_periodo t_periodo;
      d_dal varchar2(10);
      d_al varchar2(10);
      v_result number;
      v_statement varchar2 (32000);
      v_campi_controllare varchar2(32000);
   begin
      DbC.PRE( not DbC.PreOn or afc.to_boolean( check_parametri( p_tabella
                                                               , p_nome_dal
                                                               , p_nome_al
                                                               )
                                              )
             , ' check_parametri on AFC_PERIODO.get_precedente'
             );
      -- compongo le condizioni di ricerca relative a campi_controllare
      estrazione_condizioni( p_campi_controllare
                           , p_valori_controllare
                           , v_campi_controllare
                           );
      -- compongo la stringa di select che devo eseguire
      v_statement := 'select to_char(' || p_nome_dal || ', ''ddmmyyyy'' ),'
                  || '       to_char(' || p_nome_al || ', ''ddmmyyyy'' )'
                  || ' from ' || p_tabella
                  || v_campi_controllare
                  || ' nvl(' || p_nome_dal || ', to_date(''3333333'',''j'') ) '
                  || ' < nvl( to_date( ''' || to_char( p_dal, afc.date_format ) || ''', afc.date_format ), to_date(''2222222'',''j'') ) '
                  || ' and rowid != nvl( ''' || p_rowid || ''', ''0'' )'
                  || 'order by ' || p_nome_dal || ' desc';
      v_result := estrazione_val( v_statement
                                , d_dal
                                , d_al
                                );
      if v_result = AFC_Error.ok
      then
         v_periodo.dal := to_date( d_dal, 'ddmmyyyy' );
         v_periodo.al := to_date( d_al, 'ddmmyyyy' );
      else
         v_periodo.dal := null;
         v_periodo.al := null;
      end if;
      return v_periodo;
   end; -- AFC_Periodo.get_precedente
----------------------------------------------------------------------------------
   function get_precedente_dal
   ( p_tabella            in     varchar2
   , p_nome_dal           in     varchar2
   , p_nome_al            in     varchar2
   , p_dal                in     date
   , p_al                 in     date
   , p_campi_controllare  in     varchar2
   , p_valori_controllare in     varchar2
   , p_rowid              in     rowid default null
   ) return date
   /******************************************************************************
   NOME:        get_precedente_dal
   DESCRIZIONE: ritorna la data di inizio del periodo precedente a quello passato
                come parametro, in relazione ai CAMPI_CONTROLLARE
   PARAMETRI:   P_TABELLA:            nome della tabella sulla quale eseguire la
                                      ricerca
                P_NOME_DAL:           nome della colonna nella quale cercare il
                                      valore P_DAL
                P_NOME_AL:            nome della colonna nella quale cercare il
                                      valore P_AL
                P_DAL:                valore da cercare nella colonna P_NOME_DAL
                P_AL:                 valore da cercare nella colonna P_NOME_AL
                P_CAMPI_CONTROLLARE:  nomi delle colonne sulle quali cercare i
                                      valore VALORI_CONTROLLARE
                P_VALORI_CONTROLLARE: valori da controllare nelle colonne
                                      P_CAMPI_CONTROLLARE
   RITORNA:     la data di inizio del periodo precedente a quello passato come
                parametro
   ECCEZIONI:   --
   ANNOTAZIONI: --
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    26/06/2005 FTASSINARI Creazione.
   13   28/09/2006 FTASSINARI Aggiunta rowid
   ******************************************************************************/
   is
      d_periodo t_periodo;
      d_dal date;
   begin
      d_periodo := get_precedente( p_tabella
                                 , p_nome_dal
                                 , p_nome_al
                                 , p_dal
                                 , p_al
                                 , p_campi_controllare
                                 , p_valori_controllare
                                 , p_rowid
                                 );
      d_dal := d_periodo.DAL;
      return d_dal;
   end; -- AFC_Periodo.get_precedente_dal;
----------------------------------------------------------------------------------
   function get_seguente
   ( p_tabella            in     varchar2
   , p_nome_dal           in     varchar2
   , p_nome_al            in     varchar2
   , p_dal                in     date
   , p_al                 in     date
   , p_campi_controllare  in     varchar2
   , p_valori_controllare in     varchar2
   , p_rowid              in     rowid default null
   ) return t_periodo
   /******************************************************************************
   NOME:        get_seguente
   DESCRIZIONE: ritorna il periodo successivo a quello passato come parametro,
                in relazione ai CAMPI_CONTROLLARE
   PARAMETRI:   P_TABELLA:            nome della tabella sulla quale eseguire la
                                      ricerca
                P_NOME_DAL:           nome della colonna nella quale cercare il
                                      valore P_DAL
                P_NOME_AL:            nome della colonna nella quale cercare il
                                      valore P_AL
                P_DAL:                valore da cercare nella colonna P_NOME_DAL
                P_AL:                 valore da cercare nella colonna P_NOME_AL
                P_CAMPI_CONTROLLARE:  nomi delle colonne sulle quali cercare i
                                      valore VALORI_CONTROLLARE
                P_VALORI_CONTROLLARE: valori da controllare nelle colonne
                                      P_CAMPI_CONTROLLARE
   RITORNA:     il periodo successivo a quello passato come parametro
   ECCEZIONI:   --
   ANNOTAZIONI: --
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    21/06/2005 FTASSINARI Creazione.
   1    28/09/2005 FTASSINARI utilizzo di estrazione_val, aggiunta di to_char(...)
                              nella select
   2    19/04/2006 FTASSINARI controllo sulla data DAL
   13   28/09/2006 FTASSINARI Aggiunta rowid
   14   16/05/2007 FTASSINARI Aggiunto nvl e conversione corretta su parametri date
   15   16/07/2007 FT         Aggiunto controllo integrita sui parametri in input (check_parametri)
   17   25/11/2009 FT         Tolto controllo su p_campi_controllare in check_parametri
   ******************************************************************************/
   is
      v_periodo t_periodo;
      d_dal varchar2(10);
      d_al varchar2(10);
      v_result number;
      v_statement varchar2 (32000);
      v_campi_controllare varchar2 (32000);
   begin
      DbC.PRE( not DbC.PreOn or afc.to_boolean( check_parametri( p_tabella
                                                               , p_nome_dal
                                                               , p_nome_al
                                                               )
                                              )
             , ' check_parametri on AFC_PERIODO.get_seguente'
             );
      -- compongo le condizioni di ricerca relative a campi_controllare
      estrazione_condizioni( p_campi_controllare
                           , p_valori_controllare
                           , v_campi_controllare
                           );
      -- compingo la stringa di select che devo eseguire
      v_statement := 'select to_char(' || p_nome_dal || ', ''ddmmyyyy'' ),'
                  || '       to_char(' || p_nome_al || ', ''ddmmyyyy'' )'
                  || 'from ' || p_tabella
                  || v_campi_controllare
                  || ' nvl(' || p_nome_dal || ', to_date(''2222222'',''j'')) '
                  || ' > nvl( to_date( ''' || to_char( p_dal, afc.date_format ) || ''', afc.date_format ), to_date(''3333333'',''j'') ) '
                  || ' and rowid != nvl( ''' || p_rowid || ''', ''0'' )'
                  || 'order by ' || p_nome_dal || ' asc';
      v_result := estrazione_val( v_statement
                                , d_dal
                                , d_al
                                );
      if v_result = AFC_Error.ok
      then
         v_periodo.dal := to_date( d_dal, 'ddmmyyyy' );
         v_periodo.al := to_date( d_al, 'ddmmyyyy' );
      else
         v_periodo.dal := null;
         v_periodo.al := null;
      end if;
      return v_periodo;
   end; -- AFC_Periodo.get_seguente
----------------------------------------------------------------------------------
   function get_seguente_al
   ( p_tabella            in     varchar2
   , p_nome_dal           in     varchar2
   , p_nome_al            in     varchar2
   , p_dal                in     date
   , p_al                 in     date
   , p_campi_controllare  in     varchar2
   , p_valori_controllare in     varchar2
   , p_rowid              in     rowid default null
   ) return date
   /******************************************************************************
   NOME:        get_seguente_al
   DESCRIZIONE: ritorna la data di fine del periodo seguente a quello passato
                come parametro, in relazione ai CAMPI_CONTROLLARE
   PARAMETRI:   P_TABELLA:            nome della tabella sulla quale eseguire la
                                      ricerca
                P_NOME_DAL:           nome della colonna nella quale cercare il
                                      valore P_DAL
                P_NOME_AL:            nome della colonna nella quale cercare il
                                      valore P_AL
                P_DAL:                valore da cercare nella colonna P_NOME_DAL
                P_AL:                 valore da cercare nella colonna P_NOME_AL
                P_CAMPI_CONTROLLARE:  nomi delle colonne sulle quali cercare i
                                      valore VALORI_CONTROLLARE
                P_VALORI_CONTROLLARE: valori da controllare nelle colonne
                                      P_CAMPI_CONTROLLARE
   RITORNA:     la data di fine del periodo seguente a quello passato come parametro
   ECCEZIONI:   --
   ANNOTAZIONI: --
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    26/06/2005 FTASSINARI Creazione.
   13   28/09/2006 FTASSINARI Aggiunta rowid
   ******************************************************************************/
   is
      d_periodo t_periodo;
      d_al date;
   begin
      d_periodo := get_seguente( p_tabella
                               , p_nome_dal
                               , p_nome_al
                               , p_dal
                               , p_al
                               , p_campi_controllare
                               , p_valori_controllare
                               , p_rowid
                               );
      d_al := d_periodo.AL;
      return d_al;
   end; -- AFC_Periodo.get_seguente_al;
----------------------------------------------------------------------------------
   function get_contenuto
   ( p_tabella            in     varchar2
   , p_nome_dal           in     varchar2
   , p_nome_al            in     varchar2
   , p_dal                in     date
   , p_al                 in     date
   , p_campi_controllare  in     varchar2
   , p_valori_controllare in     varchar2
   , p_rowid              in     rowid default null
   ) return t_periodo
   /******************************************************************************
   NOME:        get_contenuto
   DESCRIZIONE: ritorna il periodo contenuto a quello passato come parametro,
                con DAL piu vicino al DAL del periodo in esame
                in relazione ai CAMPI_CONTROLLARE
   PARAMETRI:   P_TABELLA:            nome della tabella sulla quale eseguire la
                                      ricerca
                P_NOME_DAL:           nome della colonna nella quale cercare il
                                      valore P_DAL
                P_NOME_AL:            nome della colonna nella quale cercare il
                                      valore P_AL
                P_DAL:                valore da cercare nella colonna P_NOME_DAL
                P_AL:                 valore da cercare nella colonna P_NOME_AL
                P_CAMPI_CONTROLLARE:  nomi delle colonne sulle quali cercare i
                                      valore VALORI_CONTROLLARE
                P_VALORI_CONTROLLARE: valori da controllare nelle colonne
                                      P_CAMPI_CONTROLLARE
   RITORNA:     il periodo contenuto a quello passato come parametro
   ECCEZIONI:   --
   ANNOTAZIONI: --
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    01/07/2005 FTASSINARI Creazione.
   1    28/09/2005 FTASSINARI utilizzo di estrazione_val, aggiunta di to_char(...)
                              nella select
   13   28/09/2006 FTASSINARI Aggiunta rowid
   14   16/05/2007 FTASSINARI Aggiunto nvl e conversione corretta su parametri date
   15   16/07/2007 FT         Aggiunto controllo integrita sui parametri in input (check_parametri)
   17   25/11/2009 FT         Tolto controllo su p_campi_controllare in check_parametri
   ******************************************************************************/
   IS
      v_periodo t_periodo;
      d_dal varchar2(10);
      d_al varchar2(10);
      v_result number;
      v_statement varchar2 (32000);
      v_campi_controllare varchar2 (32000);
   begin
      DbC.PRE( not DbC.PreOn or afc.to_boolean( check_parametri( p_tabella
                                                               , p_nome_dal
                                                               , p_nome_al
                                                               )
                                              )
             , ' check_parametri on AFC_PERIODO.get_contenuto'
             );
      -- compongo le condizioni di ricerca relative a campi_controllare
      estrazione_condizioni( p_campi_controllare
                           , p_valori_controllare
                           , v_campi_controllare
                           );
      -- compongo la stringa di select che devo eseguire
      v_statement := 'select to_char(' || p_nome_dal || ', ''ddmmyyyy'' ),'
                  || '       to_char(' || p_nome_al || ', ''ddmmyyyy'' )'
                  || 'from ' || p_tabella
                  || v_campi_controllare
                  || ' nvl(' || p_nome_dal || ', to_date(''2222222'',''j'')) '
                  || ' between to_date( ''' || to_char( p_dal, afc.date_format ) || ''', afc.date_format ) '
                  || ' and nvl( to_date( ''' || to_char( p_al, afc.date_format ) || ''', afc.date_format ), to_date( ''3333333'', ''j'' ) ) and '
                  || ' nvl(' || p_nome_al || ', to_date(''3333333'',''j'')) '
                  || ' between to_date( ''' || to_char( p_dal, afc.date_format ) || ''', afc.date_format ) and nvl( to_date( ''' || to_char( p_al, afc.date_format ) || ''', afc.date_format ), to_date( ''3333333'', ''j'' ) ) '
                  || ' and rowid != nvl( ''' || p_rowid || ''', ''0'' )'
                  || 'order by ' || p_nome_dal || ' asc'
                  ;
      v_result := estrazione_val( v_statement
                                , d_dal
                                , d_al
                                );
      if v_result = AFC_Error.ok
      then
         v_periodo.dal := to_date( d_dal, 'ddmmyyyy' );
         v_periodo.al := to_date( d_al, 'ddmmyyyy' );
      else
         v_periodo.dal := null;
         v_periodo.al := null;
      end if;
      return v_periodo;
   end; -- AFC_Periodo.get_contenuto
----------------------------------------------------------------------------------
   function get_intersecato_inizio
   ( p_tabella            in     varchar2
   , p_nome_dal           in     varchar2
   , p_nome_al            in     varchar2
   , p_dal                in     date
   , p_al                 in     date
   , p_campi_controllare  in     varchar2
   , p_valori_controllare in     varchar2
   , p_rowid              in     rowid default null
   ) return t_periodo
   /******************************************************************************
   NOME:        get_intersecato_inizio
   DESCRIZIONE: ritorna il periodo intersecato nell'estremo di sx a quello passato
                come parametro, con DAL piu lontano al DAL del periodo in esame
                in relazione ai CAMPI_CONTROLLARE
   PARAMETRI:   P_TABELLA:            nome della tabella sulla quale eseguire la
                                      ricerca
                P_NOME_DAL:           nome della colonna nella quale cercare il
                                      valore P_DAL
                P_NOME_AL:            nome della colonna nella quale cercare il
                                      valore P_AL
                P_DAL:                valore da cercare nella colonna P_NOME_DAL
                P_AL:                 valore da cercare nella colonna P_NOME_AL
                P_CAMPI_CONTROLLARE:  nomi delle colonne sulle quali cercare i
                                      valore VALORI_CONTROLLARE
                P_VALORI_CONTROLLARE: valori da controllare nelle colonne
                                      P_CAMPI_CONTROLLARE
   RITORNA:     il periodo intersecato a quello passato come parametro
   ECCEZIONI:   --
   ANNOTAZIONI: --
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    04/07/2005 FTASSINARI Creazione.
   1    28/09/2005 FTASSINARI utilizzo di estrazione_val, aggiunta di to_char(...)
                              nella select
   2    18/04/2006 FTASSINARI modifica nome: get_intersecante_inizio => get_intersecato_inizio
   13   28/09/2006 FTASSINARI Aggiunta rowid
   14   16/05/2007 FTASSINARI Aggiunto nvl e conversione corretta su parametri date
   15   16/07/2007 FT         Aggiunto controllo integrita sui parametri in input (check_parametri)
   17   25/11/2009 FT         Tolto controllo su p_campi_controllare in check_parametri
   ******************************************************************************/
   IS
      v_periodo t_periodo;
      d_dal varchar2(10);
      d_al varchar2(10);
      v_result number;
      v_statement varchar2 (32000);
      v_campi_controllare afc.t_statement;
   begin
      DbC.PRE( not DbC.PreOn or afc.to_boolean( check_parametri( p_tabella
                                                               , p_nome_dal
                                                               , p_nome_al
                                                               )
                                              )
             , ' check_parametri on AFC_PERIODO.get_intersecato_inizio'
             );
      -- compongo le condizioni di ricerca relative a campi_controllare
      estrazione_condizioni( p_campi_controllare
                           , p_valori_controllare
                           , v_campi_controllare
                           );
      -- compongo la stringa di select che devo eseguire
      v_statement := 'select to_char(' || p_nome_dal || ', ''ddmmyyyy'' ),'
                  || '       to_char(' || p_nome_al || ', ''ddmmyyyy'' )'
                  || 'from ' || p_tabella
                  || v_campi_controllare
                  || ' nvl(' || p_nome_dal || ', to_date(''2222222'',''j'')) '
                  || ' < nvl( to_date( ''' || to_char( p_dal, afc.date_format ) || ''', afc.date_format ), to_date(''2222222'',''j'') ) and '
                  || ' nvl(' || p_nome_al || ', to_date(''3333333'',''j'')) '
                  || ' between nvl( to_date( ''' || to_char( p_dal, afc.date_format ) || ''', afc.date_format ), to_date(''2222222'',''j'') ) '
                  || ' and nvl( to_date( ''' || to_char( p_al, afc.date_format ) || ''', afc.date_format ), to_date(''3333333'',''j'') ) '
                  || ' and rowid != nvl( ''' || p_rowid || ''', ''0'' )'
                  || 'order by ' || p_nome_dal || ' asc';
      v_result := estrazione_val( v_statement
                                , d_dal
                                , d_al
                                );
      if v_result = AFC_Error.ok
      then
         v_periodo.dal := to_date( d_dal, 'ddmmyyyy' );
         v_periodo.al := to_date( d_al, 'ddmmyyyy' );
      else
         v_periodo.dal := null;
         v_periodo.al := null;
      end if;
      return v_periodo;
   end; -- AFC_Periodo.get_intersecato_inizio
----------------------------------------------------------------------------------
   function get_intersecato_fine
   ( p_tabella            in     varchar2
   , p_nome_dal           in     varchar2
   , p_nome_al            in     varchar2
   , p_dal                in     date
   , p_al                 in     date
   , p_campi_controllare  in     varchar2
   , p_valori_controllare in     varchar2
   , p_rowid              in     rowid default null
   ) return t_periodo
   /******************************************************************************
   NOME:        get_intersecato_fine
   DESCRIZIONE: ritorna il periodo intersecato nell'estremo di dx a quello passato
                come parametro, con DAL piu vicino al DAL del periodo in esame
                in relazione ai CAMPI_CONTROLLARE
   PARAMETRI:   P_TABELLA:            nome della tabella sulla quale eseguire la
                                      ricerca
                P_NOME_DAL:           nome della colonna nella quale cercare il
                                      valore P_DAL
                P_NOME_AL:            nome della colonna nella quale cercare il
                                      valore P_AL
                P_DAL:                valore da cercare nella colonna P_NOME_DAL
                P_AL:                 valore da cercare nella colonna P_NOME_AL
                P_CAMPI_CONTROLLARE:  nomi delle colonne sulle quali cercare i
                                      valore VALORI_CONTROLLARE
                P_VALORI_CONTROLLARE: valori da controllare nelle colonne
                                      P_CAMPI_CONTROLLARE
   RITORNA:     il periodo intersecato a quello passato come parametro
   ECCEZIONI:   --
   ANNOTAZIONI: --
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    04/07/2005 FTASSINARI Creazione.
   1    28/09/2005 FTASSINARI utilizzo di estrazione_val, aggiunta di to_char(...)
                              nella select
   2    18/04/2006 FTASSINARI modifica nome: get_intersecante_fine => get_intersecato_fine
   13   28/09/2006 FTASSINARI Aggiunta rowid
   14   16/05/2007 FTASSINARI Aggiunto nvl e conversione corretta su parametri date
   15   16/07/2007 FT         Aggiunto controllo integrita sui parametri in input (check_parametri)
   17   25/11/2009 FT         Tolto controllo su p_campi_controllare in check_parametri
   ******************************************************************************/
   IS
      v_periodo t_periodo;
      d_dal varchar2(10);
      d_al varchar2(10);
      v_result number;
      v_statement varchar2 (32000);
      v_campi_controllare varchar2 (32000);
   begin
      DbC.PRE( not DbC.PreOn or afc.to_boolean( check_parametri( p_tabella
                                                               , p_nome_dal
                                                               , p_nome_al
                                                               )
                                              )
             , ' check_parametri on AFC_PERIODO.get_intersecato_fine'
             );
      -- compongo le condizioni di ricerca relative a campi_controllare
      estrazione_condizioni( p_campi_controllare
                           , p_valori_controllare
                           , v_campi_controllare
                           );
      -- compongo la stringa di select che devo eseguire
      v_statement := 'select to_char(' || p_nome_dal || ', ''ddmmyyyy'' ),'
                  || '       to_char(' || p_nome_al || ', ''ddmmyyyy'' )'
                  || 'from ' || p_tabella
                  || v_campi_controllare
                  || ' nvl( ' || p_nome_dal || ', to_date(''2222222'',''j'')) '
                  || ' between nvl( to_date( ''' || to_char( p_dal, afc.date_format ) || ''', afc.date_format ), to_date(''2222222'',''j'') ) and ''' || p_al || ''''
                  || ' and nvl( ' || p_nome_al || ', to_date(''3333333'',''j'') ) '
                  || ' > nvl( to_date( ''' || to_char( p_al, afc.date_format ) || ''', afc.date_format ), to_date(''3333333'',''j'') ) '
                  || ' and rowid != nvl( ''' || p_rowid || ''', ''0'' )'
                  || 'order by ' || p_nome_dal || ' asc';
      v_result := estrazione_val( v_statement
                                , d_dal
                                , d_al
                                );
      if v_result = AFC_Error.ok
      then
         v_periodo.dal := to_date( d_dal, 'ddmmyyyy' );
         v_periodo.al := to_date( d_al, 'ddmmyyyy' );
      else
         v_periodo.dal := null;
         v_periodo.al := null;
      end if;
      return v_periodo;
   end; -- AFC_Periodo.get_intersecato_fine
----------------------------------------------------------------------------------
   function get_intersecato
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   , p_rowid              in rowid default null
   ) return t_periodo
   /******************************************************************************
   NOME:        get_intersecato
   DESCRIZIONE: ritorna il periodo che interseca il periodo indicato in relazione
                ai CAMPI_CONTROLLARE
   PARAMETRI:   P_TABELLA:            nome della tabella sulla quale eseguire la
                                      ricerca
                P_NOME_DAL:           nome della colonna nella quale cercare il
                                      valore P_DAL
                P_NOME_AL:            nome della colonna nella quale cercare il
                                      valore P_AL
                P_DAL:                valore da cercare nella colonna P_NOME_DAL
                P_AL:                 valore da cercare nella colonna P_NOME_AL
                P_CAMPI_CONTROLLARE:  nomi delle colonne sulle quali cercare i
                                      valore VALORI_CONTROLLARE
                P_VALORI_CONTROLLARE: valori da controllare nelle colonne
                                      P_CAMPI_CONTROLLARE
   RITORNA:     il periodo intersecato a quello passato come parametro
   ECCEZIONI:   --
   ANNOTAZIONI: --
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    18/04/2006 FTASSINARI Creazione.
   13   28/09/2006 FTASSINARI Aggiunta rowid
   15   16/07/2007 FT         Aggiunto controllo integrita sui parametri in input (check_parametri)
   17   25/11/2009 FT         Tolto controllo su p_campi_controllare in check_parametri
   ******************************************************************************/
   is
      d_periodo AFC_Periodo.t_periodo;
   begin
      DbC.PRE( not DbC.PreOn or afc.to_boolean( check_parametri( p_tabella
                                                               , p_nome_dal
                                                               , p_nome_al
                                                               )
                                              )
             , ' check_parametri on AFC_PERIODO.get_intersecato'
             );
      d_periodo := get_intersecato_inizio( p_tabella => p_tabella
                                         , p_nome_dal => p_nome_dal
                                         , p_nome_al => p_nome_al
                                         , p_dal => p_dal
                                         , p_al => p_al
                                         , p_campi_controllare => p_campi_controllare
                                         , p_valori_controllare => p_valori_controllare
                                         , p_rowid =>  p_rowid
                                         );
      if  d_periodo.dal is null
      and d_periodo.al is null
      then
         d_periodo := get_intersecato_fine( p_tabella => p_tabella
                                          , p_nome_dal => p_nome_dal
                                          , p_nome_al => p_nome_al
                                          , p_dal => p_dal
                                          , p_al => p_al
                                          , p_campi_controllare => p_campi_controllare
                                          , p_valori_controllare => p_valori_controllare
                                          , p_rowid =>  p_rowid
                                          );
      end if;
      return d_periodo;
   end; -- AFC_Periodo.get_intersecato
----------------------------------------------------------------------------------
   function get_non_incluso
   ( p_tabella            in varchar2
   , p_nome_dal           in varchar2
   , p_nome_al            in varchar2
   , p_dal                in date
   , p_al                 in date
   , p_campi_controllare  in varchar2
   , p_valori_controllare in varchar2
   , p_rowid              in rowid default null
   ) return t_periodo
   /******************************************************************************
   NOME:        get_non_incluso
   DESCRIZIONE: ritorna il primo periodo non incluso in quello passato come parametro,
                con DAL piu vicino al DAL del periodo in esame, in relazione ai
                CAMPI_CONTROLLARE
   PARAMETRI:   P_TABELLA:            nome della tabella sulla quale eseguire la
                                      ricerca
                P_NOME_DAL:           nome della colonna nella quale cercare il
                                      valore P_DAL
                P_NOME_AL:            nome della colonna nella quale cercare il
                                      valore P_AL
                P_DAL:                valore da cercare nella colonna P_NOME_DAL
                P_AL:                 valore da cercare nella colonna P_NOME_AL
                P_CAMPI_CONTROLLARE:  nomi delle colonne sulle quali cercare i
                                      valore VALORI_CONTROLLARE
                P_VALORI_CONTROLLARE: valori da controllare nelle colonne
                                      P_CAMPI_CONTROLLARE
   RITORNA:     il primo periodo non incluso in quello passato come parametro
   ECCEZIONI:   --
   ANNOTAZIONI: --
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    04/04/2006 FTASSINARI Creazione.
   1    19/04/2006 FTASSINARI ricerca tramite statement SQL
   2    28/04/2006 FTASSINARI modificata condizione di where per considerare periodi
                              aperti in entrambi gli estremi
   13   28/09/2006 FTASSINARI Aggiunta rowid
   15   16/07/2007 FT         Aggiunto controllo integrita sui parametri in input (check_parametri)
   16   17/10/2008 MM         Modificata condizione di nvl sul valore p_dal da
                              to_date('3333333','j') a to_date('2222223','j').
   17   25/11/2009 FT         Tolto controllo su p_campi_controllare in check_parametri
   ******************************************************************************/
   is
      d_periodo t_periodo;
      d_dal varchar2(10);
      d_al varchar2(10);
      d_result number;
      d_statement varchar2 (32000);
      d_campi_controllare varchar2 (32000);
   begin
      DbC.PRE( not DbC.PreOn or afc.to_boolean( check_parametri( p_tabella
                                                               , p_nome_dal
                                                               , p_nome_al
                                                               )
                                              )
             , ' check_parametri on AFC_PERIODO.get_non_incluso'
             );
      -- compongo le condizioni di ricerca relative a campi_controllare
      estrazione_condizioni( p_campi_controllare
                           , p_valori_controllare
                           , d_campi_controllare
                           );
      -- compongo la stringa di select che devo eseguire
      d_statement := 'select to_char(' || p_nome_dal || ', ''ddmmyyyy'' ),'
                  || '       to_char(' || p_nome_al || ', ''ddmmyyyy'' )'
                  || 'from ' || p_tabella
                  || d_campi_controllare
                  || ' ( ( nvl(' || p_nome_dal || ', to_date(''2222222'',''j'') ) '
                  || ' < ( nvl( to_date( ''' || to_char( p_dal, 'ddmmyyyy' ) || ''', ''ddmmyyyy'' ), '
                  --|| ' to_date(''3333333'',''j'') ) ) ) '
                  || ' to_date(''2222223'',''j'') ) ) ) '
                  || ' or ( nvl(' || p_nome_al || ', to_date(''3333333'',''j'') ) '
                  || ' > ( nvl( to_date( ''' || to_char( p_al, 'ddmmyyyy' ) || ''', ''ddmmyyyy'' ), '
                  || ' to_date(''2222222'',''j'') ) ) ) ) '
                  || ' and rowid != nvl( ''' || p_rowid || ''', ''0'' )'
                  || 'order by ' || p_nome_dal || ' asc';
      d_result := estrazione_val( d_statement
                                , d_dal
                                , d_al
                                );
      if d_result = AFC_Error.ok
      then
         d_periodo.dal := to_date( d_dal, 'ddmmyyyy' );
         d_periodo.al := to_date( d_al, 'ddmmyyyy' );
      else
         d_periodo.dal := null;
         d_periodo.al := null;
      end if;
      return d_periodo;
   end; -- AFC_Periodo.get_non_incluso
----------------------------------------------------------------------------------
   function get_contiguo
   ( p_tabella            in     varchar2
   , p_nome_dal           in     varchar2
   , p_nome_al            in     varchar2
   , p_dal                in     date
   , p_al                 in     date
   , p_campi_controllare  in     varchar2
   , p_valori_controllare in     varchar2
   , p_rowid              in     varchar2 default null
   ) return t_periodo
   /******************************************************************************
   NOME:        get_contiguo
   DESCRIZIONE: ritorna il periodo totale composto dai periodi contigui a quello
                passato come parametro, in relazione ai CAMPI_CONTROLLARE
   PARAMETRI:   P_TABELLA:            nome della tabella sulla quale eseguire la
                                      ricerca
                P_NOME_DAL:           nome della colonna nella quale cercare il
                                      valore P_DAL
                P_NOME_AL:            nome della colonna nella quale cercare il
                                      valore P_AL
                P_DAL:                valore da cercare nella colonna P_NOME_DAL
                P_AL:                 valore da cercare nella colonna P_NOME_AL
                P_CAMPI_CONTROLLARE:  nomi delle colonne sulle quali cercare i
                                      valore VALORI_CONTROLLARE
                P_VALORI_CONTROLLARE: valori da controllare nelle colonne
                                      P_CAMPI_CONTROLLARE
                P_ROWID               rowid del record passato come parametro
                                      (di default e null)
   RITORNA:     il periodo totale
   ECCEZIONI:   --
   ANNOTAZIONI: --
   REVISIONI:
   Rev. Data       Autore     Descrizione
   ---- ---------- ---------- ---------------------------------------------------
   0    04/07/2005 FTASSINARI Creazione.
   1    16/08/2005 FTASSINARI aggiunta della rowid
   2    28/09/2005 FTASSINARI utilizzo di get_primo_dal e get_ultimo_al
   ******************************************************************************/
   is
      v_periodo t_periodo;
   begin
      v_periodo.dal := get_primo_dal( p_tabella
                                    , p_nome_dal
                                    , p_nome_al
                                    , p_dal
                                    , p_campi_controllare
                                    , p_valori_controllare
                                    , p_rowid
                                    );
      v_periodo.al := get_ultimo_al( p_tabella
                                   , p_nome_dal
                                   , p_nome_al
                                   , p_al
                                   , p_campi_controllare
                                   , p_valori_controllare
                                   , p_rowid
                                   );
      return v_periodo;
   end; -- AFC_Periodo.get_contiguo
----------------------------------------------------------------------------------
end AFC_Periodo;
/

