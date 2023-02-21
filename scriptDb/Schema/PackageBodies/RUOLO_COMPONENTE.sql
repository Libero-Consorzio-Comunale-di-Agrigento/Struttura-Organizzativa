CREATE OR REPLACE package body ruolo_componente is
   /******************************************************************************
    NOME:        ruolo_componente
    DESCRIZIONE: Gestione tabella ruoli_componente.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore  Descrizione.
    000   06/11/2006  VDAVALLI  Prima emissione.
    001   04/09/2009  VDAVALLI  Modifiche per configurazione master/slave
    002   17/02/2010  VDAVALLI  Modificata eredita_ruoli: tratta anche assegnazioni
                                cessate con revisione in modifica
    003   06/12/2011  MMONARI   Dati Storici
    004   01/03/2012  VDAVALLI  Modificata funzione EREDITA_RUOLI
    005   31/01/2013  MMONARI   Redmine Feature #166
    006   31/01/2013  MMONARI   Redmine Feature #158
    007   05/02/2013  MMONARI   Redmine Feature #168
    008   15/02/2013  MMONARI   Redmine Feature #194
    009   10/03/2013  ADADAMO   Redmine Bug #235, creata la procedure inserimento_logico_ruolo
                                e corretta la inserisci_ruoli per gestire i ruoli
                                logicamente eliminati
    010   21/03/2014  MMONARI   Redmine Bug#412
    011   12/08/2014  MMONARI   Redmine Bug#482
          19/08/2014  MMONARI   Gestione "logica" su elimina_ruoli per #313
    012   07/07/2014  MMONARI   Ruoli di Ruoli #430
          19/09/2014  MMONARI   #499 gestione storica dei ruoli in ripristina_componente
          10/03/2015  MMONARI   #581 inibizione is_al_ok in eliminazione logica
    013   02/04/2015  MMONARI   Eliminazione logica #580
    014   10/08/2015  MMONARI   Gestione eliminazione fisica per impostazioni parametri
                                di registro #580
    015   10/08/2015  MMONARI   Attribuzione automatica ruolo #634
          26/10/2015  MMONARI   #281 Gestione dei ruoli unici
    016   14/08/2016  MMONARI   Esecuzione is_ri_ok in chk_ri #758
    017   27/04/2017  MMONARI   #762 Ricalcolo dei ruoli da profilo su update ruoli individuali
          09/08/2017  MMONARI   #784 Elimina dei ruoli da profilo su delete logica del profilo
          24/10/2017  MMONARI   #764 #760
          15/02/2018  MMONARI   #799
          01/03/2018  MMONARI   #810
          15/05/2018  MMONARI   #28222
    018   22/02/2019  MMONARI   #33266
          17/02/2020  MMONARI   #40701 Attribuzione ruoli condivisi tra profili diversi e contemporanei
          17/02/2020  MMONARI   #39939 DDS
          18/05/2020  MMONARI   #42480 Inibisce il ricalcolo dei ruoli derivati

   ******************************************************************************/

   s_revisione_body constant afc.t_revision := '018';

   s_error_table afc_error.t_error_table;

   s_nulld date := to_date(3333333, 'j');

   --------------------------------------------------------------------------------

   function versione return varchar2 is /* SLAVE_COPY */
      /******************************************************************************
       NOME:        versione
       DESCRIZIONE: Versione e revisione di distribuzione del package.
       RITORNA:     varchar2 stringa contenente versione e revisione.
       NOTE:        Primo numero  : versione compatibilità del Package.
                    Secondo numero: revisione del Package specification.
                    Terzo numero  : revisione del Package body.
      ******************************************************************************/
   begin
      return afc.version(s_revisione, s_revisione_body);
   end; -- ruolo_componente.versione

   --------------------------------------------------------------------------------

   function pk(p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type)
      return t_pk is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        PK
       DESCRIZIONE: Costruttore di un t_PK dati gli attributi della chiave
      ******************************************************************************/
      d_result t_pk;
   begin

      d_result.id_ruolo_componente := p_id_ruolo_componente;

      dbc.pre(not dbc.preon or canhandle(d_result.id_ruolo_componente)
             ,'canHandle on ruolo_componente.PK');
      return d_result;

   end; -- end ruolo_componente.PK

   --------------------------------------------------------------------------------

   function can_handle(p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type)
      return number is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        can_handle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: 1 se la chiave è manipolabile, 0 altrimenti.
       NOTE:        cfr. canHandle per ritorno valori boolean.
      ******************************************************************************/
      d_result number;
   begin
      d_result := 1;

      -- nelle chiavi primarie composte da più attributi, ciascun attributo deve essere not null
      if d_result = 1 and (p_id_ruolo_componente is null) then
         d_result := 0;
      end if;

      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on ruolo_componente.can_handle');

      return d_result;

   end; -- ruolo_componente.can_handle

   --------------------------------------------------------------------------------

   function canhandle(p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type)
      return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        canHandle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: true se la chiave è manipolabile, false altrimenti.
       NOTE:        Wrapper boolean di can_handle (cfr. can_handle).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(can_handle(p_id_ruolo_componente));
   begin
      return d_result;
   end; -- ruolo_componente.canHandle

   --------------------------------------------------------------------------------

   function exists_id(p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type)
      return number is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        exists_id
       DESCRIZIONE: Esistenza riga con chiave indicata.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: 1 se la riga esiste, 0 altrimenti.
       NOTE:        cfr. existsId per ritorno valori boolean.
      ******************************************************************************/
      d_result number;
   begin

      dbc.pre(not dbc.preon or canhandle(p_id_ruolo_componente)
             ,'canHandle on ruolo_componente.exists_id');

      begin
         select 1
           into d_result
           from ruoli_componente
          where id_ruolo_componente = p_id_ruolo_componente;
      exception
         when no_data_found then
            d_result := 0;
      end;

      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on ruolo_componente.exists_id');

      return d_result;
   end; -- ruolo_componente.exists_id

   --------------------------------------------------------------------------------

   function existsid(p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type)
      return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        existsId
       DESCRIZIONE: Esistenza riga con chiave indicata.
       NOTE:        Wrapper boolean di exists_id (cfr. exists_id).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(exists_id(p_id_ruolo_componente));
   begin
      return d_result;
   end; -- ruolo_componente.existsId

   --------------------------------------------------------------------------------

   function error_message(p_error_number in afc_error.t_error_number)
      return afc_error.t_error_msg is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        error_message
       DESCRIZIONE: Messaggio previsto per il numero di eccezione indicato.
       NOTE:        Restituisce il messaggio abbinato al numero indicato nella tabella
                    s_error_table del Package.
      ******************************************************************************/
      d_result constant afc_error.t_error_msg := s_error_table(p_error_number);
   begin
      return d_result;
   end; -- ruolo_componente.error_message

   --------------------------------------------------------------------------------

   procedure ins
   (
      p_id_ruolo_componente  in ruoli_componente.id_ruolo_componente%type default null
     ,p_id_componente        in ruoli_componente.id_componente%type
     ,p_ruolo                in ruoli_componente.ruolo%type
     ,p_dal                  in ruoli_componente.dal%type
     ,p_al                   in ruoli_componente.al%type default null
     ,p_dal_pubb             in ruoli_componente.dal_pubb%type default null
     ,p_al_pubb              in ruoli_componente.al_pubb%type default null
     ,p_al_prec              in ruoli_componente.al_pubb%type default null
     ,p_utente_aggiornamento in ruoli_componente.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in ruoli_componente.data_aggiornamento%type default null
   ) is
      /******************************************************************************
       NOME:        ins
       DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
                    Viene verificato preventivamente verificato se esiste già per
                    il medesimo componente, medesima decorrenza e medesimo ruolo
                    una registrazione eliminata logicamente, in caso positivo viene
                    ripristinata, ma con l'al del nuovo periodo
       PARAMETRI:   Chiavi e attributi della table.
      ******************************************************************************/
   begin

      -- Check Mandatory on Insert
      dbc.pre(not dbc.preon or p_id_componente is not null
             ,'p_id_componente on ruolo_componente.ins');
      dbc.pre(not dbc.preon or p_ruolo is not null, 'p_ruolo on ruolo_componente.ins');
      dbc.pre(not dbc.preon or p_dal is not null, 'p_dal on ruolo_componente.ins');
      dbc.pre(not dbc.preon or p_al is not null or /*default value*/
              'default null' is not null
             ,'p_al on ruolo_componente.ins');

      dbc.pre(not dbc.preon or (p_id_ruolo_componente is null and /*default value*/
              '' is not null) -- PK nullable on insert
              or not existsid(p_id_ruolo_componente)
             ,'not existsId on ruolo_componente.ins');

      insert into ruoli_componente
         (id_ruolo_componente
         ,id_componente
         ,ruolo
         ,dal
         ,al
         ,dal_pubb
         ,al_pubb
         ,al_prec
         ,utente_aggiornamento
         ,data_aggiornamento)
      values
         (p_id_ruolo_componente
         ,p_id_componente
         ,p_ruolo
         ,p_dal
         ,p_al
         ,p_dal_pubb
         ,p_al_pubb
         ,p_al_prec
         ,p_utente_aggiornamento
         ,p_data_aggiornamento);
   end; -- ruolo_componente.ins

   --------------------------------------------------------------------------------

   procedure upd
   (
      p_new_id_ruolo_componente  in ruoli_componente.id_ruolo_componente%type
     ,p_new_id_componente        in ruoli_componente.id_componente%type
     ,p_new_ruolo                in ruoli_componente.ruolo%type
     ,p_new_dal                  in ruoli_componente.dal%type
     ,p_new_al                   in ruoli_componente.al%type
     ,p_new_dal_pubb             in ruoli_componente.dal_pubb%type
     ,p_new_al_pubb              in ruoli_componente.al_pubb%type
     ,p_new_al_prec              in ruoli_componente.al_prec%type
     ,p_new_utente_aggiornamento in ruoli_componente.utente_aggiornamento%type default null
     ,p_new_data_aggiornamento   in ruoli_componente.data_aggiornamento%type
     ,p_old_id_ruolo_componente  in ruoli_componente.id_ruolo_componente%type default null
     ,p_old_id_componente        in ruoli_componente.id_componente%type default null
     ,p_old_ruolo                in ruoli_componente.ruolo%type default null
     ,p_old_dal                  in ruoli_componente.dal%type default null
     ,p_old_al                   in ruoli_componente.al%type default null
     ,p_old_dal_pubb             in ruoli_componente.dal_pubb%type
     ,p_old_al_pubb              in ruoli_componente.al_pubb%type
     ,p_old_al_prec              in ruoli_componente.al_prec%type
     ,p_old_utente_aggiornamento in ruoli_componente.utente_aggiornamento%type default null
     ,p_old_data_aggiornamento   in ruoli_componente.data_aggiornamento%type
     ,p_check_old                in integer default 0
   ) is
      /******************************************************************************
       NOME:        upd
       DESCRIZIONE: Aggiornamento di una riga con chiave.
       PARAMETRI:   Chiavi e attributi della table
                    p_check_OLD: 0, ricerca senza controllo su attributi precedenti
                                 1, ricerca con controllo anche su attributi precedenti.

       NOTE:        Nel caso in cui non venga elaborato alcun record viene lanciata
                    l'eccezione -20010 (cfr. AFC_ERROR).
                    Se p_check_old = 1, viene controllato se il record corrispondente a
                    tutti i campi passati come parametri esiste nella tabella.
      ******************************************************************************/
      d_key       t_pk;
      d_row_found number;
   begin

      dbc.pre(not dbc.preon or
              not ((p_old_id_componente is not null or p_old_ruolo is not null or
               p_old_dal is not null or p_old_al is not null or
               p_old_dal_pubb is not null or p_old_al_pubb is not null or
               p_old_al_prec is not null) and p_check_old = 0)
             ,' <OLD values> is not null on ruolo_componente.upd');

      dbc.pre(not dbc.preon or p_check_old is not null
             ,'p_check_OLD is not null on ruolo_componente.upd');

      d_key := pk(nvl(p_old_id_ruolo_componente, p_new_id_ruolo_componente));

      dbc.pre(not dbc.preon or existsid(d_key.id_ruolo_componente)
             ,'existsId on ruolo_componente.upd');

      update ruoli_componente
         set id_ruolo_componente  = p_new_id_ruolo_componente
            ,id_componente        = p_new_id_componente
            ,ruolo                = p_new_ruolo
            ,dal                  = p_new_dal
            ,al                   = p_new_al
            ,dal_pubb             = p_new_dal_pubb
            ,al_pubb              = p_new_al_pubb
            ,al_prec              = p_new_al_prec
            ,utente_aggiornamento = p_new_utente_aggiornamento
            ,data_aggiornamento   = p_new_data_aggiornamento
       where id_ruolo_componente = d_key.id_ruolo_componente
         and (p_check_old = 0 or
             p_check_old = 1 and (id_componente = p_old_id_componente or
             id_componente is null and p_old_id_componente is null) and
             (ruolo = p_old_ruolo or ruolo is null and p_old_ruolo is null) and
             (dal = p_old_dal or dal is null and p_old_dal is null) and
             (al = p_old_al or al is null and p_old_al is null) and
             (dal_pubb = p_old_dal_pubb or dal_pubb is null and p_old_dal_pubb is null) and
             (al_pubb = p_old_al_pubb or al_pubb is null and p_old_al_pubb is null) and
             (al_prec = p_old_al_prec or al_prec is null and p_old_al_prec is null) and
             (utente_aggiornamento = p_old_utente_aggiornamento or
             utente_aggiornamento is null and p_old_utente_aggiornamento is null) and
             (data_aggiornamento = p_old_data_aggiornamento or
             data_aggiornamento is null and p_old_data_aggiornamento is null));
      d_row_found := sql%rowcount;

      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on ruolo_componente.upd');

      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;

   end; -- ruolo_componente.upd

   --------------------------------------------------------------------------------

   procedure upd_column
   (
      p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type
     ,p_column              in varchar2
     ,p_value               in varchar2 default null
     ,p_literal_value       in number default 1
   ) is
      /******************************************************************************
       NOME:        upd_column
       DESCRIZIONE: Aggiornamento del campo p_column col valore p_value.
       PARAMETRI:   p_column:        identificatore del campo da aggiornare.
                    p_value:         valore da modificare.
                    p_literal_value: indica se il valore è un stringa e non un numero
                                     o una funzione.
      ******************************************************************************/
      d_statement afc.t_statement;
      d_literal   varchar2(2);
   begin

      dbc.pre(not dbc.preon or existsid(p_id_ruolo_componente)
             ,'existsId on ruolo_componente.upd_column');
      dbc.pre(not dbc.preon or p_column is not null
             ,'p_column is not null on ruolo_componente.upd_column');
      dbc.pre(not dbc.preon or afc_ddl.hasattribute(s_table_name, p_column)
             ,'AFC_DDL.HasAttribute on ruolo_componente.upd_column');
      dbc.pre(p_literal_value in (0, 1)
             ,'p_literal_value in ( 0, 1 ) on ruolo_componente.upd_column; p_literal_value = ' ||
              p_literal_value);

      if p_literal_value = 1 then
         d_literal := '''';
      end if;

      d_statement := 'begin ' || '   update ruoli_componente' || '   set    ' || p_column ||
                     ' = ' || d_literal || p_value || d_literal ||
                     '   where  id_ruolo_componente = ''' || p_id_ruolo_componente || '''' ||
                     '   ;' || 'end;';

      afc.sql_execute(d_statement);

   end; -- ruolo_componente.upd_column

   --------------------------------------------------------------------------------

   procedure upd_column
   (
      p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type
     ,p_column              in varchar2
     ,p_value               in date
   ) is
      /******************************************************************************
       NOME:        upd_column
       DESCRIZIONE: Aggiornamento del campo p_column col valore p_value.

       NOTE:        Richiama se stessa con il parametro date convertito in stringa.
      ******************************************************************************/
      d_data varchar2(19);
   begin
      d_data := to_char(p_value, afc.date_format);
      upd_column(p_id_ruolo_componente
                ,p_column
                ,'to_date( ''' || d_data || ''', ''' || afc.date_format || ''' )'
                ,0);
   end; -- ruolo_componente.upd_column

   --------------------------------------------------------------------------------

   procedure del
   (
      p_id_ruolo_componente  in ruoli_componente.id_ruolo_componente%type
     ,p_id_componente        in ruoli_componente.id_componente%type default null
     ,p_ruolo                in ruoli_componente.ruolo%type default null
     ,p_dal                  in ruoli_componente.dal%type default null
     ,p_al                   in ruoli_componente.al%type default null
     ,p_dal_pubb             in ruoli_componente.dal_pubb%type default null
     ,p_al_pubb              in ruoli_componente.al_pubb%type default null
     ,p_al_prec              in ruoli_componente.al_prec%type default null
     ,p_utente_aggiornamento in ruoli_componente.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in ruoli_componente.data_aggiornamento%type
     ,p_check_old            in integer default 0
   ) is
      /******************************************************************************
       NOME:        del
       DESCRIZIONE: Cancellazione della riga indicata.
       PARAMETRI:   Chiavi e attributi della table.
                    p_check_OLD: 0, ricerca senza controllo su attributi precedenti
                                 1, ricerca con controllo anche su attributi precedenti.

       NOTE:        Nel caso in cui non venga elaborato alcun record viene lanciata
                    l'eccezione -20010 (cfr. AFC_ERROR).
                    Se p_check_old = 1, viene controllato se il record corrispondente a
                    tutti i campi passati come parametri esiste nella tabella.
      ******************************************************************************/
      d_row_found number;
   begin
      delete from ruoli_componente
       where id_ruolo_componente = p_id_ruolo_componente
         and (p_check_old = 0 or
             p_check_old = 1 and (id_componente = p_id_componente or
             id_componente is null and p_id_componente is null) and
             (ruolo = p_ruolo or ruolo is null and p_ruolo is null) and
             (dal = p_dal or dal is null and p_dal is null) and
             (al = p_al or al is null and p_al is null) and
             (dal_pubb = p_dal_pubb or dal_pubb is null and p_dal_pubb is null) and
             (al_pubb = p_al_pubb or al_pubb is null and p_al_pubb is null) and
             (al_prec = p_al_prec or al_prec is null and p_al_prec is null) and
             (utente_aggiornamento = p_utente_aggiornamento or
             utente_aggiornamento is null and p_utente_aggiornamento is null) and
             (data_aggiornamento = p_data_aggiornamento or
             data_aggiornamento is null and p_data_aggiornamento is null));
      d_row_found := sql%rowcount;

      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   end; -- ruolo_componente.del

   --------------------------------------------------------------------------------

   function get_id_componente(p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type)
      return ruoli_componente.id_componente%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_id_componente
       DESCRIZIONE: Attributo id_componente di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ruoli_componente.id_componente%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ruoli_componente.id_componente%type;
   begin

      select id_componente
        into d_result
        from ruoli_componente
       where id_ruolo_componente = p_id_ruolo_componente;

      return d_result;
   end; -- ruolo_componente.get_id_componente

   --------------------------------------------------------------------------------

   function get_ruolo(p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type)
      return ruoli_componente.ruolo%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_ruolo
       DESCRIZIONE: Attributo ruolo di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ruoli_componente.ruolo%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ruoli_componente.ruolo%type;
   begin

      select ruolo
        into d_result
        from ruoli_componente
       where id_ruolo_componente = p_id_ruolo_componente;

      return d_result;
   end; -- ruolo_componente.get_ruolo

   --------------------------------------------------------------------------------

   function get_dal(p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type)
      return ruoli_componente.dal%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_dal
       DESCRIZIONE: Attributo dal di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ruoli_componente.dal%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ruoli_componente.dal%type;
   begin

      select dal
        into d_result
        from ruoli_componente
       where id_ruolo_componente = p_id_ruolo_componente;

      return d_result;
   end; -- ruolo_componente.get_dal

   --------------------------------------------------------------------------------

   function get_al(p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type)
      return ruoli_componente.al%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_al
       DESCRIZIONE: Attributo al di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ruoli_componente.al%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ruoli_componente.al%type;
   begin

      select al
        into d_result
        from ruoli_componente
       where id_ruolo_componente = p_id_ruolo_componente;

      return d_result;
   end; -- ruolo_componente.get_al

   --------------------------------------------------------------------------------

   function get_dal_pubb(p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type)
      return ruoli_componente.dal_pubb%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_dal_pubb
       DESCRIZIONE: Attributo dal_pubb di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ruoli_componente.dal_pubb%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ruoli_componente.dal_pubb%type;
   begin

      select dal_pubb
        into d_result
        from ruoli_componente
       where id_ruolo_componente = p_id_ruolo_componente;

      return d_result;
   end; -- ruolo_componente.get_dal_pubb

   --------------------------------------------------------------------------------

   function get_al_pubb(p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type)
      return ruoli_componente.al_pubb%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_al_pubb
       DESCRIZIONE: Attributo al_pubb di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ruoli_componente.al_pubb%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ruoli_componente.al_pubb%type;
   begin

      select al_pubb
        into d_result
        from ruoli_componente
       where id_ruolo_componente = p_id_ruolo_componente;

      return d_result;
   end; -- ruolo_componente.get_al_pubb

   --------------------------------------------------------------------------------

   function get_al_prec(p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type)
      return ruoli_componente.al_prec%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_al_prec
       DESCRIZIONE: Attributo al_prec di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ruoli_componente.al_prec%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ruoli_componente.al_prec%type;
   begin

      select al_prec
        into d_result
        from ruoli_componente
       where id_ruolo_componente = p_id_ruolo_componente;

      return d_result;
   end; -- ruolo_componente.get_al_prec

   --------------------------------------------------------------------------------

   function where_condition
   (
      p_id_ruolo_componente in varchar2 default null
     ,p_id_componente       in varchar2 default null
     ,p_ruolo               in varchar2 default null
     ,p_dal                 in varchar2 default null
     ,p_al                  in varchar2 default null
     ,p_dal_pubb            in varchar2 default null
     ,p_al_pubb             in varchar2 default null
     ,p_al_prec             in varchar2 default null
     ,p_other_condition     in varchar2 default null
     ,p_qbe                 in number default 0
   ) return afc.t_statement is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        where_condition
       DESCRIZIONE: Ritorna la where_condition per lo statement di select di get_rows e count_rows.
       PARAMETRI:   p_other_condition
                    p_QBE 0: se l'operatore da utilizzare nella where-condition è
                             quello di default ('=')
                          1: se l'operatore da utilizzare nella where-condition è
                             quello specificato per ogni attributo.

       RITORNA:     AFC.t_statement.
       NOTE:        Se p_QBE = 1 , ogni parametro deve contenere, nella prima parte,
                    l'operatore da utilizzare nella where-condition.
      ******************************************************************************/
      d_statement afc.t_statement;
   begin

      d_statement := ' where ( 1 = 1 ' ||
                     afc.get_field_condition(' and ( id_ruolo_componente '
                                            ,p_id_ruolo_componente
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( id_componente '
                                            ,p_id_componente
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( ruolo ', p_ruolo, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( dal '
                                            ,p_dal
                                            ,' )'
                                            ,p_qbe
                                            ,afc.date_format) ||
                     afc.get_field_condition(' and ( al '
                                            ,p_al
                                            ,' )'
                                            ,p_qbe
                                            ,afc.date_format) || ' ) ' ||
                     afc.get_field_condition(' and ( dal_pubb '
                                            ,p_dal_pubb
                                            ,' )'
                                            ,p_qbe
                                            ,afc.date_format) ||
                     afc.get_field_condition(' and ( al_pubb '
                                            ,p_al_pubb
                                            ,' )'
                                            ,p_qbe
                                            ,afc.date_format) || ' ) ' ||
                     afc.get_field_condition(' and ( al_prec '
                                            ,p_al_prec
                                            ,' )'
                                            ,p_qbe
                                            ,afc.date_format) || ' ) ' ||
                     p_other_condition;

      return d_statement;

   end; --- ruolo_componente.where_condition

   --------------------------------------------------------------------------------

   function get_rows
   (
      p_id_ruolo_componente in varchar2 default null
     ,p_id_componente       in varchar2 default null
     ,p_ruolo               in varchar2 default null
     ,p_dal                 in varchar2 default null
     ,p_al                  in varchar2 default null
     ,p_dal_pubb            in varchar2 default null
     ,p_al_pubb             in varchar2 default null
     ,p_al_prec             in varchar2 default null
     ,p_other_condition     in varchar2 default null
     ,p_qbe                 in number default 0
   ) return afc.t_ref_cursor is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_rows
       DESCRIZIONE: Ritorna il risultato di una query in base ai valori che passiamo.
       PARAMETRI:   Chiavi e attributi della table
                    p_other_condition
                    p_QBE 0: se l'operatore da utilizzare nella where-condition è
                             quello di default ('=')
                          1: se l'operatore da utilizzare nella where-condition è
                             quello specificato per ogni attributo.

       RITORNA:     Un ref_cursor che punta al risultato della query.
       NOTE:        Se p_QBE = 1 , ogni parametro deve contenere, nella prima parte,
                    l'operatore da utilizzare nella where-condition.
      ******************************************************************************/
      d_statement  afc.t_statement;
      d_ref_cursor afc.t_ref_cursor;
   begin

      dbc.pre(not dbc.preon or p_qbe in (0, 1)
             ,'check p_QBE on ruolo_componente.get_rows');

      d_statement := ' select * from ruoli_componente ' ||
                     where_condition(p_id_ruolo_componente
                                    ,p_id_componente
                                    ,p_ruolo
                                    ,p_dal
                                    ,p_al
                                    ,p_dal_pubb
                                    ,p_al_pubb
                                    ,p_al_prec
                                    ,p_other_condition
                                    ,p_qbe);

      d_ref_cursor := afc_dml.get_ref_cursor(d_statement);

      return d_ref_cursor;

   end; -- ruolo_componente.get_rows

   --------------------------------------------------------------------------------

   function count_rows
   (
      p_id_ruolo_componente in varchar2 default null
     ,p_id_componente       in varchar2 default null
     ,p_ruolo               in varchar2 default null
     ,p_dal                 in varchar2 default null
     ,p_al                  in varchar2 default null
     ,p_dal_pubb            in varchar2 default null
     ,p_al_pubb             in varchar2 default null
     ,p_al_prec             in varchar2 default null
     ,p_other_condition     in varchar2 default null
     ,p_qbe                 in number default 0
   ) return integer is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        count_rows
       DESCRIZIONE: Ritorna il numero di righe della tabella gli attributi delle quali
                    rispettano i valori indicati.
       PARAMETRI:   Almeno uno dei parametri della tabella.
                    p_other_condition
                    p_QBE
       RITORNA:     Numero di righe che rispettano la selezione indicata.
      ******************************************************************************/
      d_result    integer;
      d_statement afc.t_statement;
   begin

      dbc.pre(not dbc.preon or p_qbe in (0, 1)
             ,'check p_QBE on ruolo_componente.count_rows');

      d_statement := ' select count( * ) from ruoli_componente ' ||
                     where_condition(p_id_ruolo_componente
                                    ,p_id_componente
                                    ,p_ruolo
                                    ,p_dal
                                    ,p_al
                                    ,p_dal_pubb
                                    ,p_al_pubb
                                    ,p_al_prec
                                    ,p_other_condition
                                    ,p_qbe);

      d_result := afc.sql_execute(d_statement);

      return d_result;
   end; -- ruolo_componente.count_rows

   --------------------------------------------------------------------------------

   function exists_ruolo
   (
      p_id_componente in ruoli_componente.id_componente%type
     ,p_ruolo         in ruoli_componente.ruolo%type
     ,p_data          in ruoli_componente.dal%type
   ) return afc_error.t_error_number is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        exists_ruolo
       DESCRIZIONE: Controlla l'esistenza di un ruolo per un componente
       PARAMETRI:   p_id_componente
                    p_ruolo
                    p_data
       NOTE:        --
      ******************************************************************************/
      d_result    afc_error.t_error_number;
      d_contatore number;
   begin
      begin
         select count(*)
           into d_contatore
           from ruoli_componente
          where id_componente = p_id_componente
            and ruolo = p_ruolo
            and p_data between dal and nvl(al, to_date('3333333', 'j'));
      exception
         when others then
            d_contatore := 0;
      end;

      if d_contatore = 0 then
         d_result := 0;
      else
         d_result := afc_error.ok;
      end if;

      return d_result;
   end; -- ruolo_componente.exists_ruolo

   --------------------------------------------------------------------------------

   function is_dal_al_ok
   (
      p_dal in ruoli_componente.dal%type
     ,p_al  in ruoli_componente.al%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_dal_al_ok
       DESCRIZIONE: Controllo di congruenza tra data inizio e fine validità
       PARAMETRI:   p_dal
                    p_al
       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin

      if nvl(p_dal, to_date('01011800', 'ddmmyyyy')) >
         nvl(p_al, to_date('31122200', 'ddmmyyyy')) then
         d_result := s_dal_al_errato_num;
      else
         d_result := afc_error.ok;
      end if;

      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on area_org_om.is_dal_al_ok');

      return d_result;

   end; -- ruolo_componente.is_dal_al_ok

   --------------------------------------------------------------------------------

   function is_di_ok
   (
      p_dal in ruoli_componente.dal%type
     ,p_al  in ruoli_componente.al%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_DI_ok.
       DESCRIZIONE: controllo integrita dati:
                    - dal < al
       RITORNA:     -
      ******************************************************************************/
      d_result afc_error.t_error_number := afc_error.ok;
   begin

      -- is_dal_al_ok
      if ruolo_componente.s_eliminazione_logica = 0 then
         d_result := is_dal_al_ok(p_dal, p_al);
      end if;

      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on attributo_componente.is_DI_ok');

      return d_result;

   end; -- ruolo_componente.is_DI_ok

   --------------------------------------------------------------------------------

   procedure chk_di
   (
      p_dal in ruoli_componente.dal%type
     ,p_al  in ruoli_componente.al%type
   ) is
      /******************************************************************************
       NOME:        chk_DI.
       DESCRIZIONE: controllo integrita dati:
                    - dal < al
       RITORNA:     -
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin

      d_result := is_di_ok(p_dal, p_al);

      dbc.assertion(not dbc.assertionon or d_result = afc_error.ok or d_result < 0
                   ,'d_result = AFC_Error.ok or d_result < 0 on attributo_componente.chk_DI');

      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, s_error_table(d_result));
      end if;

   end; -- ruolo_componente.chk_DI

   --------------------------------------------------------------------------------

   function is_dal_ok
   (
      p_id_componente in ruoli_componente.id_componente%type
     ,p_new_dal       in ruoli_componente.dal%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_dal_ok
       DESCRIZIONE: Controllo nuovo dal compreso nel periodo di attribuzione
                    del componente all'unità organizzativa
       PARAMETRI:   p_id_componente
                    p_new_dal
                    p_inserting
                    p_updating
       NOTE:        --
      ******************************************************************************/
      d_dal_componente componenti.dal%type;
      d_result         afc_error.t_error_number := afc_error.ok;
   begin

      if p_new_dal is not null then
         d_dal_componente := componente.get_dal(p_id_componente => p_id_componente);
         if p_new_dal < nvl(d_dal_componente, to_date('2222222', 'j')) then
            d_result := s_dal_minore_num;
         end if;
      end if;

      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on attributo_componente.is_dal_ok');

      return d_result;

   end; -- ruolo_componente.is_dal_ok

   --------------------------------------------------------------------------------

   function is_al_ok
   (
      p_id_componente in ruoli_componente.id_componente%type
     ,p_new_al        in ruoli_componente.al%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_al_ok
       DESCRIZIONE: Controllo is_al_ok
       PARAMETRI:   p_id_componente
                    p_new_al
       NOTE:        --
      ******************************************************************************/
      d_al_componente componenti.al%type;
      d_result        afc_error.t_error_number := afc_error.ok;
   begin

      if p_new_al is not null then
         d_al_componente := componente.get_al(p_id_componente => p_id_componente);
         if p_new_al > nvl(d_al_componente, to_date('3333333', 'j')) then
            d_result := s_al_maggiore_num;
         end if;
      end if;

      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on attributo_componente.is_al_ok');

      return d_result;

   end; -- ruolo_componente.is_al_ok

   --------------------------------------------------------------------------------

   function is_ruolo_ok
   (
      p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type
     ,p_id_componente       in ruoli_componente.id_componente%type
     ,p_new_dal             in ruoli_componente.dal%type
     ,p_new_al              in ruoli_componente.al%type
     ,p_new_ruolo           in ruoli_componente.ruolo%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_ruolo_ok.
       DESCRIZIONE: Si controlla se il ruolo è già stato inserito per il
                    componente nel periodo indicato
       PARAMETRI:   p_id_componente
                    p_new_dal
                    p_new_al
                    p_new_ruolo
       RETURN:      1 se tutti i controlli danno esito positivo, l'error_code altrimenti
       NOTE:        --
      ******************************************************************************/
      d_result        afc_error.t_error_number := afc_error.ok;
      d_select_result number;

   begin
      begin
         select count(*)
           into d_select_result
           from ruoli_componente
          where id_ruolo_componente != p_id_ruolo_componente
            and id_componente = p_id_componente
            and ruolo = p_new_ruolo
            and dal <= nvl(al, to_date(3333333, 'j')) --Bug#412
            and p_new_dal <= nvl(al, to_date('3333333', 'j')) --#48384
            and nvl(p_new_al, to_date('3333333', 'j')) >= dal; --p_new_dal;
      exception
         when others then
            d_select_result := 1;
      end;

      if d_select_result > 0 then
         d_result := s_ruolo_presente_num;
      else
         d_result := afc_error.ok;
      end if;

      return d_result;

   end; -- ruolo_componente.is_ruolo_ok

   --------------------------------------------------------------------------------

   function is_ri_ok
   (
      p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type
     ,p_id_componente       in ruoli_componente.id_componente%type
     ,p_old_dal             in ruoli_componente.dal%type
     ,p_new_dal             in ruoli_componente.dal%type
     ,p_old_al              in ruoli_componente.al%type
     ,p_new_al              in ruoli_componente.al%type
     ,p_new_ruolo           in ruoli_componente.ruolo%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_RI_ok.
       DESCRIZIONE: gestione della Referential Integrity:
                    - is_dal_ok
                    - is_al_ok
       PARAMETRI:   p_id_ruolo_componente
                    p_id_componente
                    p_old_dal
                    p_new_dal
                    p_old_al
                    p_new_al
                    p_new_ruolo
       RETURN:      1 se tutti i controlli danno esito positivo, l'error_code altrimenti
       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number := afc_error.ok;
   begin

      -- is_dal_ok
      if nvl(p_old_dal, to_date('3333333', 'j')) <>
         nvl(p_new_dal, to_date('3333333', 'j')) then
         d_result := is_dal_ok(p_id_componente, p_new_dal);
      end if;

      -- is_al_ok
      if (d_result = afc_error.ok) and ruolo_componente.s_eliminazione_logica = 0 /*#581*/
       then
         if nvl(p_old_al, to_date('3333333', 'j')) <>
            nvl(p_new_al, to_date('3333333', 'j')) then
            d_result := is_al_ok(p_id_componente, p_new_al);
         end if;
      end if;

      -- is_ruolo_ok
      if (d_result = afc_error.ok)/* and ruolo_componente.s_gestione_profili = 0*/ then --#48384
         if p_new_dal is not null then
            d_result := is_ruolo_ok(p_id_ruolo_componente
                                   ,p_id_componente
                                   ,p_new_dal
                                   ,p_new_al
                                   ,p_new_ruolo);
         end if;
      end if;

      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on attributo_componente.is_RI_ok');

      return d_result;

   end; -- ruolo_componente.is_RI_ok

   --------------------------------------------------------------------------------

   procedure chk_ri
   (
      p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type
     ,p_id_componente       in ruoli_componente.id_componente%type
     ,p_old_dal             in ruoli_componente.dal%type
     ,p_new_dal             in ruoli_componente.dal%type
     ,p_old_al              in ruoli_componente.al%type
     ,p_new_al              in ruoli_componente.al%type
     ,p_new_ruolo           in ruoli_componente.ruolo%type
   ) is
      /******************************************************************************
       NOME:        chk_RI.
       DESCRIZIONE: gestione della Referential Integrity:
                    - is_dal_ok
                    - is_al_ok
       PARAMETRI:   p_id_componente
                    p_old_dal
                    p_new_dal
                    p_old_al
                    p_new_al
       NOTE:        --
      ******************************************************************************/
      d_result      afc_error.t_error_number := afc_error.ok;
      d_ruoli_unici registro.valore%type;
   begin
      -- #281, Gestione dei ruoli unici
      if p_new_ruolo is not null then
         d_ruoli_unici := registro_utility.leggi_stringa('PRODUCTS/SI4SO'
                                                        ,'RuoliUniciPerUO'
                                                        ,'');
         if d_ruoli_unici like '%' || p_new_ruolo || ',%' then
            --verifica dell'unicita' del ruolo tra i componenti della stessa UO, per l'intero periodo
            begin
               select s_ruolo_unico_per_uo_num
                 into d_result
                 from dual
                where exists
                (select 'x'
                         from ruoli_componente r
                        where dal <= nvl(p_new_al, to_date(3333333, 'j'))
                          and nvl(al, to_date(3333333, 'j')) >= p_new_dal
                          and ruolo = p_new_ruolo
                          and id_componente in
                              (select id_componente
                                 from componenti
                                where progr_unita_organizzativa =
                                      (select componente.get_progr_unita_organizzativa(p_id_componente)
                                         from dual)
                                  and id_componente <> p_id_componente
                                  and dal <= nvl(p_new_al, to_date(3333333, 'j'))
                                  and nvl(al, to_date(3333333, 'j')) >= p_new_dal));
            exception
               when no_data_found then
                  null;
            end;
         end if;
      end if;

      if d_result = afc_error.ok then
         d_result := is_ri_ok(p_id_ruolo_componente
                             ,p_id_componente
                             ,p_old_dal
                             ,p_new_dal
                             ,p_old_al
                             ,p_new_al
                             ,p_new_ruolo);
      end if;

      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, s_error_table(d_result));
      end if;

   end; -- ruolo_componente.chk_RI

   --------------------------------------------------------------------------------

   procedure set_fi
   (
      p_id_ruolo_componente  in ruoli_componente.id_ruolo_componente%type
     ,p_id_componente        in ruoli_componente.id_componente%type
     ,p_old_dal              in ruoli_componente.dal%type
     ,p_new_dal              in ruoli_componente.dal%type
     ,p_old_al               in ruoli_componente.al%type
     ,p_new_al               in ruoli_componente.al%type
     ,p_new_ruolo            in ruoli_componente.ruolo%type
     ,p_new_dal_pubb         in ruoli_componente.dal_pubb%type
     ,p_new_al_pubb          in ruoli_componente.al_pubb%type
     ,p_data_aggiornamento   in ruoli_componente.data_aggiornamento%type
     ,p_utente_aggiornamento in ruoli_componente.utente_aggiornamento%type
     ,p_inserting            in number
     ,p_updating             in number
     ,p_deleting             in number
   ) is
      /******************************************************************************
       NOME:        set_fi.

       NOTE:        creata per #430
      ******************************************************************************/
      w_ruco                ruoli_componente%rowtype;
      d_id_ruolo_componente ruoli_componente.id_ruolo_componente%type;
      d_contatore           number;
      d_des_ruolo           ad4_ruoli.descrizione%type;
      -- #39939 DDS
      d_utente                 ad4_utenti.utente%type;
      d_soggetto               anagrafe_soggetti.ni%type;
      d_owner_dds              anagrafe_unita_organizzative.amministrazione%type;
      d_progetto_dds           varchar2(30);
      d_tabella_dds            varchar2(30);
      d_profilo_dds            varchar2(1);
      d_segnalazione           varchar2(200);
      d_segnalazione_bloccante varchar2(1);
      d_result                 afc_error.t_error_number;
   begin
      --gestione dei ruoli per profilo
      if componente.s_aggiorna_date_componente = 0 then
         --#42480
         if is_profilo(p_new_ruolo
                      ,greatest(nvl(p_new_dal, p_old_dal)
                               ,trunc(sysdate) --#784
                               ,nvl(nvl(p_new_al, p_old_al), to_date(3333333, 'j')))) /* #762 */
          then
            ruolo_componente.s_gestione_profili := 1;
            if p_inserting = 1 then
               --In modalita' profili per progetto, chiude l'eventuale profilo preesistente dello stesso progetto/modulo
               if nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO'
                                                    ,'ProfiliPerProgetto'
                                                    ,'')
                     ,'NO') = 'SI' then
                  select count(distinct id_ruolo_componente)
                        ,max(id_ruolo_componente)
                    into d_contatore
                        ,d_id_ruolo_componente
                    from ruoli_componente r
                   where r.id_componente = p_id_componente
                     and id_ruolo_componente <> p_id_ruolo_componente
                     and dal <= nvl(al, to_date(3333333, 'j'))
                     and 0 < (select count(*)
                                from ruoli_profilo p
                               where p.ruolo_profilo = p_new_ruolo
                                 and nvl(p_new_al, to_date(3333333, 'j')) between
                                     nvl(dal, to_date(2222222, 'j')) and
                                     nvl(al, to_date(3333333, 'j')))
                     and r.dal <= nvl(p_new_al, to_date(3333333, 'j'))
                     and nvl(r.al, to_date(3333333, 'j')) >= p_new_dal
                     and (select nvl(progetto, 'x') || nvl(modulo, 'y')
                            from ad4_ruoli
                           where ruolo = r.ruolo) =
                         (select nvl(progetto, 'z') || nvl(modulo, 'k')
                            from ad4_ruoli
                           where ruolo = p_new_ruolo);

                  if d_contatore > 1 then
                     --il nuovo profilo si interseca con piu' profili preesistenti
                     --elimina logicamente i profili completamente inclusi nel nuovo
                     for ruco in (select id_ruolo_componente
                                    from ruoli_componente r
                                   where r.id_componente = p_id_componente
                                     and id_ruolo_componente <> p_id_ruolo_componente
                                     and dal <= nvl(al, to_date(3333333, 'j'))
                                     and 0 < (select count(*)
                                                from ruoli_profilo p
                                               where p.ruolo_profilo = p_new_ruolo
                                                 and nvl(p_new_al, to_date(3333333, 'j')) between
                                                     nvl(dal, to_date(2222222, 'j')) and
                                                     nvl(al, to_date(3333333, 'j')))
                                     and r.dal >= p_new_dal
                                     and nvl(r.al, to_date(3333333, 'j')) <=
                                         nvl(p_new_al, to_date(3333333, 'j'))
                                     and (select nvl(progetto, 'x') || nvl(modulo, 'y')
                                            from ad4_ruoli
                                           where ruolo = r.ruolo) =
                                         (select nvl(progetto, 'x') || nvl(modulo, 'y')
                                            from ad4_ruoli
                                           where ruolo = p_new_ruolo))
                     loop
                        eliminazione_logica_ruolo(ruco.id_ruolo_componente
                                                 ,p_data_aggiornamento
                                                 ,p_utente_aggiornamento
                                                 ,d_segnalazione_bloccante
                                                 ,d_segnalazione);
                        if d_segnalazione_bloccante = 'Y' then
                           d_result := s_errore_eliminazione_num;
                        end if;
                     end loop;
                     if d_result = afc_error.ok then
                        --assesta le date dei profili che contengono gli estremi nel nuovo periodo
                        update ruoli_componente r
                           set al = p_new_dal - 1
                         where id_ruolo_componente =
                               (select id_ruolo_componente
                                  from ruoli_componente r
                                 where r.id_componente = p_id_componente
                                   and id_ruolo_componente <> p_id_ruolo_componente
                                   and dal <= nvl(al, to_date(3333333, 'j'))
                                   and 0 < (select count(*)
                                              from ruoli_profilo p
                                             where p.ruolo_profilo = p_new_ruolo
                                               and nvl(p_new_al, to_date(3333333, 'j')) between
                                                   nvl(dal, to_date(2222222, 'j')) and
                                                   nvl(al, to_date(3333333, 'j')))
                                   and p_new_dal between r.dal and
                                       nvl(al, to_date(3333333, 'j'))
                                   and (select nvl(progetto, 'x') || nvl(modulo, 'y')
                                          from ad4_ruoli
                                         where ruolo = r.ruolo) =
                                       (select nvl(progetto, 'x') || nvl(modulo, 'y')
                                          from ad4_ruoli
                                         where ruolo = p_new_ruolo));
                        --
                        update ruoli_componente r
                           set dal = p_new_al + 1
                         where id_ruolo_componente =
                               (select id_ruolo_componente
                                  from ruoli_componente r
                                 where r.id_componente = p_id_componente
                                   and id_ruolo_componente <> p_id_ruolo_componente
                                   and dal <= nvl(al, to_date(3333333, 'j'))
                                   and 0 < (select count(*)
                                              from ruoli_profilo p
                                             where p.ruolo_profilo = p_new_ruolo
                                               and nvl(p_new_al, to_date(3333333, 'j')) between
                                                   nvl(dal, to_date(2222222, 'j')) and
                                                   nvl(al, to_date(3333333, 'j')))
                                   and nvl(p_new_al, to_date(3333333, 'j')) between r.dal and
                                       nvl(al, to_date(3333333, 'j'))
                                   and (select nvl(progetto, 'x') || nvl(modulo, 'y')
                                          from ad4_ruoli
                                         where ruolo = r.ruolo) =
                                       (select nvl(progetto, 'x') || nvl(modulo, 'y')
                                          from ad4_ruoli
                                         where ruolo = p_new_ruolo));
                     end if;
                  elsif d_contatore = 1 then
                     --il nuovo profilo si interseca con un solo profilo preesistenti
                     --determiniamo i dati del preesistente profilo
                     select *
                       into w_ruco
                       from ruoli_componente
                      where id_ruolo_componente = d_id_ruolo_componente;
                     --caso: estremi coincidenti
                     if p_new_dal = w_ruco.dal and nvl(p_new_al, to_date(3333333, 'j')) =
                        nvl(w_ruco.al, to_date(3333333, 'j')) then
                        --eliminazione logica del profilo preesistente
                        eliminazione_logica_ruolo(w_ruco.id_ruolo_componente
                                                 ,p_data_aggiornamento
                                                 ,p_utente_aggiornamento
                                                 ,d_segnalazione_bloccante
                                                 ,d_segnalazione);
                        if d_segnalazione_bloccante = 'Y' then
                           d_result := s_errore_eliminazione_num;
                        end if;
                     end if;
                     --caso: dal coincidente
                     if p_new_dal = w_ruco.dal and nvl(p_new_al, to_date(3333333, 'j')) <
                        nvl(w_ruco.al, to_date(3333333, 'j')) then
                        --assestamento della data di fine periodo del profilo preesistente
                        update ruoli_componente r
                           set dal = p_new_al + 1
                         where id_ruolo_componente = w_ruco.id_ruolo_componente;
                     end if;
                     --caso: al coincidente
                     if p_new_dal > w_ruco.dal and nvl(p_new_al, to_date(3333333, 'j')) =
                        nvl(w_ruco.al, to_date(3333333, 'j')) then
                        --assestamento della data di inizio periodo del profilo preesistente
                        update ruoli_componente r
                           set al = p_new_dal - 1
                         where id_ruolo_componente = w_ruco.id_ruolo_componente;
                     end if;
                     --caso: nuovo periodo completamente incluso nel profilo preesistente
                     if p_new_dal > w_ruco.dal and nvl(p_new_al, to_date(3333333, 'j')) <
                        nvl(w_ruco.al, to_date(3333333, 'j')) then
                        --assestamento della data di inizio periodo del profilo preesistente
                        update ruoli_componente r
                           set al = p_new_dal - 1
                         where id_ruolo_componente = w_ruco.id_ruolo_componente;
                        --inserimento dello spezzone mancante
                        ruolo_componente.ins(p_id_ruolo_componente  => ''
                                            ,p_id_componente        => p_id_componente
                                            ,p_ruolo                => w_ruco.ruolo
                                            ,p_dal                  => nvl(p_new_al
                                                                          ,to_date(3333333
                                                                                  ,'j'))
                                            ,p_al                   => w_ruco.al
                                            ,p_dal_pubb             => nvl(p_new_al
                                                                          ,to_date(3333333
                                                                                  ,'j'))
                                            ,p_al_pubb              => w_ruco.al_pubb
                                            ,p_utente_aggiornamento => p_utente_aggiornamento
                                            ,p_data_aggiornamento   => p_data_aggiornamento);
                     end if;
                  end if;
               end if;
               --Se il profilo e' storicamente significativo, si procede con l'attribuzione dei ruoli relativi
               if p_new_dal_pubb <= nvl(p_new_al_pubb, to_date(3333333, 'j')) then
                  attribuzione_ruoli_profilo(p_id_componente        => p_id_componente
                                            ,p_ruolo                => p_new_ruolo
                                            ,p_data                 => nvl(p_new_al
                                                                          ,to_date(3333333
                                                                                  ,'j'))
                                            ,p_dal                  => p_new_dal
                                            ,p_al                   => p_new_al
                                            ,p_utente_aggiornamento => p_utente_aggiornamento
                                            ,p_data_aggiornamento   => p_data_aggiornamento);
               end if;
            elsif p_updating = 1 or p_deleting = 1 then
               if p_new_al = p_new_dal - 1 or p_deleting = 1 then
                  --eliminazione logica dei ruoli relativi al profilo
                  ruolo_componente.eliminazione_ruoli_profilo(p_id_ruolo_componente  => p_id_ruolo_componente
                                                             ,p_utente_aggiornamento => p_utente_aggiornamento
                                                             ,p_data_aggiornamento   => p_data_aggiornamento);
               elsif p_new_dal <> p_old_dal or nvl(p_new_al, to_date(3333333, 'j')) <>
                     nvl(p_old_al, to_date(3333333, 'j')) then
                  --modifica degli estremi del periodo
                  ruolo_componente.aggiornamento_ruoli_profilo(p_id_ruolo_componente  => p_id_ruolo_componente
                                                              ,p_dal                  => p_new_dal
                                                              ,p_al                   => p_new_al
                                                              ,p_dal_pubb             => ''
                                                              ,p_al_pubb              => ''
                                                              ,p_utente_aggiornamento => p_utente_aggiornamento
                                                              ,p_data_aggiornamento   => p_data_aggiornamento);
               end if;
            end if;
            if componente.s_modifica_componente = 0 then
               ruolo_componente.s_gestione_profili := 0;
            end if;
         else
            --fine trattamento profili
            --gestione ruolo privato o derivante da profilo
            if (p_updating = 1 or p_deleting = 1) /*and
                                                                                                                                                                                             get_id_profilo_origine(p_id_ruolo_componente) = -1*/ /* #810 #36282*/
             then
               --#760 #764
               --#762
               /* in caso di eliminazione o chiusura di un ruolo privato, verificare che al componente sia attribuito un profilo che
                  comprende il ruolo eliminato. in quel caso, ricalcolare i ruoli del profilo
               */
               for prof in (select p.ruolo_profilo
                                  ,r.dal
                                  ,r.al
                                  ,r.dal_pubb
                                  ,r.al_pubb
                                  ,r.utente_aggiornamento
                              from ruoli_componente r
                                  ,ruoli_profilo    p
                             where r.id_componente = p_id_componente
                               and r.dal <= nvl(p_old_al, to_date(3333333, 'j'))
                               and nvl(r.al, to_date(3333333, 'j')) >= p_old_dal
                               and p.ruolo = p_new_ruolo
                               and r.ruolo = p.ruolo_profilo
                               and ruolo_profilo <> p_new_ruolo --#40701 non rivaluta il profilo che viene trattato
                               and r.dal <= nvl(r.al, to_date(3333333, 'j')) --#28222
                             order by r.dal)
               loop
                  begin
                     ruolo_componente.attribuzione_ruoli_profilo(p_id_componente        => p_id_componente
                                                                ,p_ruolo                => prof.ruolo_profilo
                                                                ,p_data                 => trunc(sysdate)
                                                                ,p_dal                  => prof.dal
                                                                ,p_al                   => prof.al
                                                                ,p_dal_pubb             => prof.dal_pubb
                                                                ,p_al_pubb              => prof.al_pubb
                                                                ,p_utente_aggiornamento => prof.utente_aggiornamento
                                                                ,p_data_aggiornamento   => trunc(sysdate));
                  exception
                     when others then
                        d_result := s_riattribuzione_fallita_num;
                  end;

               end loop;

            end if;
         end if;
      end if;

      -- #39939 Aggiornamento DDS
      if nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO'
                                           ,'AggiornaProfilazioneUtentiDDS'
                                           ,'')
            ,'NO') = 'SI' then
         begin
            select 1
              into d_contatore
              from ad4_ruoli
             where ruolo = p_new_ruolo
               and progetto = 'DDS';
            raise too_many_rows;
         exception
            when no_data_found then
               null;
            when too_many_rows then
               /* determina il profilo di utilizzo, l'oggetto di competenza e l'utente da aggiornare su DDS */
               dds_util.analyze_role(p_new_ruolo
                                    ,d_progetto_dds
                                    ,d_tabella_dds
                                    ,d_profilo_dds);

               select max(utente)
                 into d_utente
                 from ad4_utenti_soggetti
                where soggetto = componente.get_ni(p_id_componente);

               if p_inserting = 1 or
                  (p_updating = 1 and
                  nvl(p_new_al, to_date(3333333, 'j')) >= trunc(sysdate)) then
                  if d_progetto_dds is null and d_tabella_dds is null and
                     d_profilo_dds = 'A' then
                     /* superamministratore */
                     dds_util.set_user(d_utente, 1);
                  end if;
                  if d_progetto_dds is not null and d_tabella_dds is null then
                     if d_profilo_dds = 'A' then
                        /* amministratore di progetto */
                        dds_util.set_role(d_utente, d_progetto_dds, 1, 0);
                     elsif d_profilo_dds = 'V' then
                        dds_util.set_role(d_utente, d_progetto_dds, 0, 1);
                     else
                        dds_util.set_role(d_utente, d_progetto_dds, 0, 0);
                     end if;
                  end if;
                  if d_progetto_dds is not null and d_tabella_dds is not null then
                     /* grants dirette sulla table */
                     dds_util.set_grants(d_utente
                                        ,d_profilo_dds
                                        ,d_owner_dds
                                        ,d_progetto_dds
                                        ,d_tabella_dds);
                  end if;
               elsif p_deleting = 1 or
                     (p_updating = 1 and
                     nvl(p_new_al, to_date(3333333, 'j')) <= trunc(sysdate)) then
                  if d_progetto_dds is null and d_tabella_dds is null and
                     d_profilo_dds = 'A' then
                     /* superamministratore */
                     dds_util.set_user(d_utente, 0);
                  end if;
                  if d_progetto_dds is not null and d_tabella_dds is null then
                     if d_profilo_dds in ('A', 'V') then
                        /* amministratore/observer di progetto */
                        dds_util.set_role(d_utente, d_progetto_dds, 0, 0);
                     end if;
                  end if;
                  if d_progetto_dds is not null and d_tabella_dds is not null then
                     /* grants dirette sulla table */
                     dds_util.reset_grants(d_utente, d_tabella_dds);
                  end if;
               end if;
         end;
      end if;

      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, s_error_table(d_result));
      end if;

   end;

   --------------------------------------------------------------------------------

   procedure elimina_ruoli
   (
      p_id_componente          in ruoli_componente.id_componente%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        elimina_ruoli.
       DESCRIZIONE: cancella logicamente tutti i record di RUOLI_COMPONENTE
                    relativi ad un id_componente
       PARAMETRI:   p_id_componente
                    p_segnalazione_bloccante
                    p_segnalazione
       NOTE:        --
      ******************************************************************************/
      d_errore exception;
   begin
      --#313
      begin
         for ruoli in (select *
                         from ruoli_componente
                        where id_componente = p_id_componente
                          and dal <= nvl(al, to_date(3333333, 'j'))
                        order by id_ruolo_componente)
         loop
            eliminazione_logica_ruolo(p_id_ruolo_componente    => ruoli.id_ruolo_componente
                                     ,p_data_aggiornamento     => trunc(sysdate)
                                     ,p_utente_aggiornamento   => ''
                                     ,p_segnalazione_bloccante => p_segnalazione_bloccante
                                     ,p_segnalazione           => p_segnalazione);

            if p_segnalazione_bloccante = 'Y' then
               raise d_errore;
            end if;
         end loop;
      exception
         when others then
            if sqlcode between - 20999 and - 20900 then
               p_segnalazione := s_error_table(sqlcode);
            else
               p_segnalazione := sqlerrm;
            end if;
            raise d_errore;
      end;
   exception
      when d_errore then
         p_segnalazione_bloccante := 'Y';
   end; -- ruolo_componente.elimina_ruoli

   --------------------------------------------------------------------------------

   procedure annulla_ruoli
   (
      p_id_componente          in ruoli_componente.id_componente%type
     ,p_old_al                 in ruoli_componente.al%type
     ,p_new_al                 in ruoli_componente.al%type
     ,p_new_al_pubb            in ruoli_componente.al_pubb%type
     ,p_new_al_prec            in ruoli_componente.al_prec%type
     ,p_data_aggiornamento     in ruoli_componente.data_aggiornamento%type
     ,p_utente_aggiornamento   in ruoli_componente.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        annulla_ruoli.
       DESCRIZIONE: aggiorna la data di fine validità di tutti i record
                    di RUOLI_COMPONENTE relativi ad un id_componente
       PARAMETRI:   p_id_componente
                    p_al
                    p_data_aggiornamento
                    p_utente_aggiornamento
                    p_segnalazione_bloccante
                    p_segnalazione
       NOTE:        --
      ******************************************************************************/
      d_errore exception;
   begin
      begin
         if nvl(p_new_al, to_date(3333333, 'j')) > nvl(p_old_al, to_date(3333333, 'j')) then
            update ruoli_componente
               set al                   = p_new_al
                  ,al_pubb              = p_new_al_pubb
                  ,al_prec              = p_new_al_prec
                  ,data_aggiornamento   = p_data_aggiornamento
                  ,utente_aggiornamento = p_utente_aggiornamento
             where id_componente = p_id_componente
               and nvl(al, to_date(3333333, 'j')) = nvl(p_old_al, to_date(3333333, 'j'))
               and dal <= nvl(al, to_date(3333333, 'j')); --#482
         else
            update ruoli_componente
               set al                   = decode(least(nvl(al, to_date(3333333, 'j'))
                                                      ,nvl(p_new_al, to_date(3333333, 'j')))
                                                ,to_date(3333333, 'j')
                                                ,to_date(null)
                                                ,least(nvl(al, to_date(3333333, 'j'))
                                                      ,nvl(p_new_al, to_date(3333333, 'j'))))
                  ,al_pubb              = p_new_al_pubb
                  ,al_prec              = p_new_al_prec
                  ,data_aggiornamento   = p_data_aggiornamento
                  ,utente_aggiornamento = p_utente_aggiornamento
             where id_componente = p_id_componente
               and dal <= nvl(al, to_date(3333333, 'j')); --#482
         end if;
      exception
         when others then
            if sqlcode between - 20999 and - 20900 then
               p_segnalazione := s_error_table(sqlcode);
            else
               p_segnalazione := sqlerrm;
            end if;
            raise d_errore;
      end;
   exception
      when d_errore then
         p_segnalazione_bloccante := 'Y';
   end; -- ruolo_componente.annulla_ruoli

   --------------------------------------------------------------------------------

   procedure aggiorna_ruoli
   (
      p_id_componente          in ruoli_componente.id_componente%type
     ,p_dal                    in ruoli_componente.dal%type
     ,p_dal_pubb               in ruoli_componente.dal_pubb%type
     ,p_data_aggiornamento     in ruoli_componente.data_aggiornamento%type
     ,p_utente_aggiornamento   in ruoli_componente.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        aggiorna_ruoli.
       DESCRIZIONE: aggiorna la data di inizio validità di tutti i record
                    di RUOLI_COMPONENTE relativi ad un id_componente
       PARAMETRI:   p_id_componente
                    p_dal
                    p_data_aggiornamento
                    p_utente_aggiornamento
                    p_segnalazione_bloccante
                    p_segnalazione
       NOTE:        --
      ******************************************************************************/
      d_errore exception;
   begin
      begin
         update ruoli_componente
            set dal                  = p_dal
               ,dal_pubb             = p_dal_pubb
               ,data_aggiornamento   = p_data_aggiornamento
               ,utente_aggiornamento = p_utente_aggiornamento
          where id_componente = p_id_componente
            and (dal is null or dal < p_dal)
            and dal <= nvl(al, to_date(3333333, 'j')); --#482

         update ruoli_componente
            set dal_pubb = greatest(p_dal_pubb, nvl(dal, to_date(2222222, 'j')))
          where id_componente = p_id_componente
            and dal <= nvl(al, to_date(3333333, 'j')); --#482

      exception
         when others then
            if sqlcode between - 20999 and - 20900 then
               p_segnalazione := s_error_table(sqlcode);
            else
               p_segnalazione := sqlerrm;
            end if;
            raise d_errore;
      end;
   exception
      when d_errore then
         p_segnalazione_bloccante := 'Y';
   end; -- ruolo_componente.aggiorna_ruoli

   --------------------------------------------------------------------------------

   procedure duplica_ruoli
   (
      p_old_id_componente      in ruoli_componente.id_componente%type
     ,p_new_id_componente      in ruoli_componente.id_componente%type
     ,p_dal                    in ruoli_componente.dal%type
     ,p_al                     in ruoli_componente.al%type
     ,p_data_aggiornamento     in ruoli_componente.data_aggiornamento%type
     ,p_utente_aggiornamento   in ruoli_componente.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        duplica_ruoli.
       DESCRIZIONE: Duplica tutti i record di RUOLI_COMPONENTE relativi
                    ad un id_componente
       PARAMETRI:   p_id_componente
                    p_dal
                    p_al
                    p_data_aggiornamento
                    p_utente_aggiornamento
                    p_segnalazione_bloccante
                    p_segnalazione
       NOTE:        --
      ******************************************************************************/
      d_errore exception;
   begin
      begin
         insert into ruoli_componente
            (id_ruolo_componente
            ,id_componente
            ,dal
            ,al
            ,ruolo
            ,utente_aggiornamento
            ,data_aggiornamento)
            select null
                  ,p_new_id_componente
                  ,nvl(p_dal, dal)
                  ,p_al
                  ,ruolo
                  ,p_utente_aggiornamento
                  ,p_data_aggiornamento
              from ruoli_componente r
             where id_componente = p_old_id_componente
               and so4_pkg.check_ruolo_riservato(r.ruolo) = 0 --#30648
               and get_origine(r.id_ruolo_componente) in ('S', 'P')
               and (al is null or al >= nvl(p_al, to_date('3333333', 'j')) or
                   al = p_dal - 1);
      exception
         when others then
            if sqlcode between - 20999 and - 20900 then
               p_segnalazione := s_error_table(sqlcode);
            else
               p_segnalazione := sqlerrm;
            end if;
            raise d_errore;
      end;
   exception
      when d_errore then
         p_segnalazione_bloccante := 'Y';
   end; -- Ruolo_componente.duplica_ruoli

   --------------------------------------------------------------------------------

   procedure inserisci_ruoli
   (
      p_ottica                 in ottiche.ottica%type
     ,p_progr_unor             in componenti.progr_unita_organizzativa%type
     ,p_id_componente          in ruoli_componente.id_componente%type
     ,p_ruolo                  in ruoli_componente.ruolo%type
     ,p_dal                    in ruoli_componente.dal%type
     ,p_al                     in ruoli_componente.al%type default null
     ,p_utente_aggiornamento   in ruoli_componente.utente_aggiornamento%type default null
     ,p_data_aggiornamento     in ruoli_componente.data_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        inserisci_ruoli
       DESCRIZIONE: Lancia la procedure di inserimento dei ruoli intercettando
                    la segnalazione di errore
       PARAMETRI:   p_id_componente
                    p_dal
                    p_al
                    p_data_aggiornamento
                    p_utente_aggiornamento
                    p_segnalazione_bloccante
                    p_segnalazione
       NOTE:        --
      ******************************************************************************/
      d_errore exception;
      d_denominazione componenti.denominazione%type;
      d_revisione_mod componenti.revisione_assegnazione%type;
      d_id_ruco       ruoli_componente.id_ruolo_componente%type;
      d_assegnatario  componenti.denominazione%type;
   begin
      d_revisione_mod := revisione_struttura.get_revisione_mod(p_ottica);
      for comp in (select id_componente
                     from componenti
                    where ottica = p_ottica
                      and progr_unita_organizzativa = p_progr_unor
                      and nvl(revisione_assegnazione, -2) != d_revisione_mod
                      and p_dal between dal and
                          nvl(decode(nvl(revisione_cessazione, -2)
                                    ,d_revisione_mod
                                    ,to_date(null)
                                    ,al)
                             ,to_date(3333333, 'j'))
                      and p_progr_unor is not null
                   union
                   select p_id_componente
                     from dual
                    where p_id_componente is not null)
      loop
         d_denominazione := componente.get_denominazione(comp.id_componente);
         if d_denominazione is null then
            d_denominazione := soggetti_get_descr(p_soggetto_ni  => componente.get_ni(comp.id_componente)
                                                 ,p_soggetto_dal => nvl(p_dal
                                                                       ,trunc(sysdate))
                                                 ,p_colonna      => 'COGNOME E NOME');
         end if;

         begin
            select id_ruolo_componente
              into d_id_ruco
              from ruoli_componente
             where id_componente = comp.id_componente
               and ruolo = p_ruolo
               and dal <= nvl(p_al, to_date(3333333, 'j'))
               and nvl(al, to_date(3333333, 'j')) >= p_dal
               and al != dal - 1; -- aggiunto per gestire i record eliminati logicamente
         exception
            when no_data_found then
               d_id_ruco := null;
            when too_many_rows then
               d_id_ruco := 1;
         end;
         if d_id_ruco is null then
            begin
               inserimento_logico_ruolo(p_id_ruolo_componente  => null
                                       ,p_id_componente        => comp.id_componente
                                       ,p_ruolo                => p_ruolo
                                       ,p_dal                  => p_dal
                                       ,p_al                   => p_al
                                       ,p_dal_pubb             => null
                                       ,p_al_pubb              => null
                                       ,p_al_prec              => null
                                       ,p_utente_aggiornamento => p_utente_aggiornamento
                                       ,p_data_aggiornamento   => p_data_aggiornamento);
            exception
               when others then
                  if sqlcode between - 20999 and - 20900 then
                     p_segnalazione := p_segnalazione || ' ' || 'Componente: ' ||
                                       d_denominazione || ' - ' || s_error_table(sqlcode);
                     --#281 dettaglio del messaggio di errore
                     if sqlcode = -20906 then
                        -- determina l'assegnatario del ruolo unico
                        select min(soggetti_get_descr(componente.get_ni(r.id_componente)
                                                     ,p_dal
                                                     ,'COGNOME E NOME'))
                          into d_assegnatario
                          from ruoli_componente r
                         where dal <= nvl(p_al, to_date(3333333, 'j'))
                           and nvl(al, to_date(3333333, 'j')) >= p_dal
                           and ruolo = p_ruolo
                           and id_componente in
                               (select id_componente
                                  from componenti
                                 where progr_unita_organizzativa =
                                       (select componente.get_progr_unita_organizzativa(p_id_componente)
                                          from dual)
                                   and id_componente <> p_id_componente
                                   and dal <= nvl(p_al, to_date(3333333, 'j'))
                                   and nvl(al, to_date(3333333, 'j')) >= p_dal);

                        p_segnalazione := p_segnalazione || ' (' || d_assegnatario || ')';

                     end if;
                  else
                     p_segnalazione := p_segnalazione || ' ' || 'Componente: ' ||
                                       d_denominazione || ' - ' || sqlerrm;
                  end if;
                  raise d_errore;
            end;
         end if;
      end loop;
   exception
      when d_errore then
         p_segnalazione_bloccante := 'Y';
   end; -- ruolo_componente.inserisci_ruoli

   --------------------------------------------------------------------------------

   procedure ripristina_ruoli
   (
      p_id_componente          in ruoli_componente.id_componente%type
     ,p_old_al                 in ruoli_componente.al%type
     ,p_storico_ruoli          in number
     ,p_data_aggiornamento     in ruoli_componente.data_aggiornamento%type
     ,p_utente_aggiornamento   in ruoli_componente.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        ripristina_ruoli.
       DESCRIZIONE: annulla la data di fine validità di tutti i record
                    di RUOLI_COMPONENTE relativi ad un id_componente
       PARAMETRI:   p_id_compoennte
                    p_data_aggiornamento
                    p_utente_aggiornamento
                    p_segnalazione_bloccante
                    p_segnalazione
       NOTE:        --
      ******************************************************************************/
      d_errore exception;
      d_al_componente componenti.al%type := componente.get_al(p_id_componente);
   begin
      begin
         if p_storico_ruoli = 0 then
            --#499
            update ruoli_componente
               set al                   = al_prec --null
                  ,al_pubb              = null
                  ,data_aggiornamento   = p_data_aggiornamento
                  ,utente_aggiornamento = p_utente_aggiornamento
             where id_componente = p_id_componente
               and al = p_old_al
               and dal <= nvl(al, to_date(3333333, 'j')); --#482
         elsif p_storico_ruoli = 1 and --#499
               nvl(d_al_componente, to_date(3333333, 'j')) >= trunc(sysdate) then
            for ruco in (select *
                           from ruoli_componente
                          where id_componente = p_id_componente
                            and al = p_old_al
                          order by id_ruolo_componente)
            loop
               ruolo_componente.ins(p_id_ruolo_componente  => ''
                                   ,p_id_componente        => p_id_componente
                                   ,p_ruolo                => ruco.ruolo
                                   ,p_dal                  => p_old_al + 1
                                   ,p_al                   => d_al_componente
                                   ,p_dal_pubb             => trunc(sysdate)
                                   ,p_al_pubb              => d_al_componente
                                   ,p_al_prec              => to_date(null)
                                   ,p_utente_aggiornamento => p_utente_aggiornamento
                                   ,p_data_aggiornamento   => p_data_aggiornamento);
            end loop;
         end if;
      exception
         when others then
            if sqlcode between - 20999 and - 20900 then
               p_segnalazione := s_error_table(sqlcode);
            else
               p_segnalazione := sqlerrm;
            end if;
            raise d_errore;
      end;
   exception
      when d_errore then
         p_segnalazione_bloccante := 'Y';
   end; -- ruolo_componente.ripristina_ruoli

   --------------------------------------------------------------------------------

   procedure eredita_ruoli
   (
      p_new_id_componente      in ruoli_componente.id_componente%type
     ,p_dal                    in ruoli_componente.dal%type
     ,p_al                     in ruoli_componente.al%type
     ,p_data_aggiornamento     in ruoli_componente.data_aggiornamento%type
     ,p_utente_aggiornamento   in ruoli_componente.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        eredita_ruoli.
       DESCRIZIONE: Eredita i ruoli dall'assegnazione precedente del componente
       PARAMETRI:   p_id_componente
                    p_dal
                    p_al
                    p_data_aggiornamento
                    p_utente_aggiornamento
                    p_segnalazione_bloccante
                    p_segnalazione
       NOTE:        Versione 001: i ruoli vengono ereditati o dall'assegnazione
                    chiusa con la revisione in modifica o dall'assegnazione con
                    al = dal - 1 della nuova assegnazione
      ******************************************************************************/
      d_errore exception;
      d_uscita exception;
      d_ottica        componenti.ottica%type;
      d_ni            componenti.ni%type;
      d_ci            componenti.ci%type;
      d_id_componente componenti.id_componente%type;
      d_revisione     componenti.revisione_assegnazione%type;

   begin
      begin
         select ottica
               ,ni
               ,ci
               ,revisione_assegnazione
           into d_ottica
               ,d_ni
               ,d_ci
               ,d_revisione
           from componenti
          where id_componente = p_new_id_componente;
      exception
         when others then
            if sqlcode between - 20999 and - 20900 then
               p_segnalazione := s_error_table(sqlcode);
            else
               p_segnalazione := sqlerrm;
            end if;
            raise d_errore;
      end;
      --
      begin
         select c.id_componente
           into d_id_componente
           from componenti c
          where c.ottica = d_ottica
            and c.ni = d_ni
            and nvl(c.ci, 0) = nvl(d_ci, 0)
            and c.dal <= nvl(c.al, to_date(3333333, 'j')) --#799
            and (nvl(c.al, to_date(3333333, 'j')) = nvl(p_dal, to_date(3333333, 'j')) - 1 or
                c.revisione_cessazione = d_revisione);
      exception
         when no_data_found then
            p_segnalazione := 'Non esistono assegnazioni da cui ereditare i ruoli';
            raise d_uscita;
         when too_many_rows then
            p_segnalazione := 'Funzione non eseguita - Esistono più assegnazioni precedenti';
            raise d_uscita;
      end;
      --
      if d_id_componente is not null then
         begin
            insert into ruoli_componente
               (id_ruolo_componente
               ,id_componente
               ,dal
               ,al
               ,ruolo
               ,utente_aggiornamento
               ,data_aggiornamento)
               select null
                     ,p_new_id_componente
                     ,nvl(p_dal, dal)
                     ,p_al
                     ,ruolo
                     ,p_utente_aggiornamento
                     ,p_data_aggiornamento
                 from ruoli_componente
                where id_componente = d_id_componente
                  and dal <= nvl(al, to_date(3333333, 'j')) --#799
               ;
         exception
            when others then
               if sqlcode between - 20999 and - 20900 then
                  p_segnalazione := s_error_table(sqlcode);
               else
                  p_segnalazione := sqlerrm;
               end if;
               raise d_errore;
         end;
      end if;
   exception
      when d_uscita then
         p_segnalazione_bloccante := 'N';
      when d_errore then
         p_segnalazione_bloccante := 'Y';
   end; -- Ruolo_componente.duplica_ruoli

   --------------------------------------------------------------------------------

   procedure eliminazione_logica_ruolo
   (
      p_id_ruolo_componente    in ruoli_componente.id_ruolo_componente%type
     ,p_data_aggiornamento     in ruoli_componente.data_aggiornamento%type default null
     ,p_utente_aggiornamento   in ruoli_componente.utente_aggiornamento%type default null
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        eliminazione_logica_ruolo.
       DESCRIZIONE: esegue l'eliminazione logica (inversione al=dal-1) preservando il record
                    che rimane pubblicato per gli altri applicativi
       NOTE:        --
      ******************************************************************************/
      d_segnalazione       varchar2(200);
      d_data_aggiornamento ruoli_componente.data_aggiornamento%type;
      d_ruolo              ruoli_componente.ruolo%type;
      d_dal                ruoli_componente.dal%type;
      d_al                 ruoli_componente.al%type;
      d_eccezione          registro.valore%type := nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO'
                                                                                     ,'ModuliRuoliEliminatiFisicamente'
                                                                                     ,'')
                                                      ,'xxxxxxxx');
      d_modulo             ad4_ruoli.modulo%type;
      d_errore exception;
   begin
      begin
         select r.data_aggiornamento
               ,r.ruolo
               ,r.dal
               ,r.al
               ,nvl(a.modulo, 'xyz')
           into d_data_aggiornamento
               ,d_ruolo
               ,d_dal
               ,d_al
               ,d_modulo
           from ruoli_componente r
               ,ad4_ruoli        a
          where r.id_ruolo_componente = p_id_ruolo_componente
            and r.ruolo = a.ruolo;

         if d_data_aggiornamento = trunc(sysdate) or instr(d_eccezione, d_modulo) > 0 or
            d_dal > trunc(sysdate) then
            --#580
            if is_profilo(d_ruolo, nvl(d_al, to_date(3333333, 'j'))) then
               ruolo_componente.s_gestione_profili := 1;
            end if;
            delete from ruoli_componente
             where id_ruolo_componente = p_id_ruolo_componente;
            delete from ruoli_derivati --#634
             where id_ruolo_componente = p_id_ruolo_componente;
            p_segnalazione           := 'Eliminazione fisica eseguita';
            p_segnalazione_bloccante := 'N';
         else
            ruolo_componente.s_eliminazione_logica := 1;

            update ruoli_componente
               set al_prec              = al
                  ,al                   = dal - 1
                  ,al_pubb              = least(nvl(al_pubb, to_date(3333333, 'j')) -- ???
                                               ,trunc(sysdate) - 1) -- ???
                  ,data_aggiornamento   = nvl(p_data_aggiornamento, data_aggiornamento)
                  ,utente_aggiornamento = nvl(p_utente_aggiornamento
                                             ,utente_aggiornamento)
             where id_ruolo_componente = p_id_ruolo_componente;

            p_segnalazione           := 'Eliminazione logica eseguita';
            p_segnalazione_bloccante := 'N';

            ruolo_componente.s_eliminazione_logica := 0;
         end if;
      exception
         when others then
            if sqlcode between - 20999 and - 20900 then
               p_segnalazione := s_error_table(sqlcode);
            else
               d_segnalazione := substr(sqlerrm, 1, 100);
            end if;
            raise d_errore;
      end;
   exception
      when d_errore then
         p_segnalazione_bloccante               := 'Y';
         p_segnalazione                         := 'Eliminazione non eseguita : ' ||
                                                   d_segnalazione;
         ruolo_componente.s_eliminazione_logica := 0;
   end; -- ruolo_componente.eliminazione_logica_ruolo

   --------------------------------------------------------------------------------

   procedure inserimento_logico_ruolo
   (
      p_id_ruolo_componente  in ruoli_componente.id_ruolo_componente%type default null
     ,p_id_componente        in ruoli_componente.id_componente%type
     ,p_ruolo                in ruoli_componente.ruolo%type
     ,p_dal                  in ruoli_componente.dal%type
     ,p_al                   in ruoli_componente.al%type default null
     ,p_dal_pubb             in ruoli_componente.dal_pubb%type default null
     ,p_al_pubb              in ruoli_componente.al_pubb%type default null
     ,p_al_prec              in ruoli_componente.al_pubb%type default null
     ,p_utente_aggiornamento in ruoli_componente.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in ruoli_componente.data_aggiornamento%type default null
   ) is
      esiste_ruolo_da_ripristinare number := 0;
   begin
      --#762
      begin
         select min(id_ruolo_componente)
           into esiste_ruolo_da_ripristinare
           from ruoli_componente r
          where 0 = (select count(*)
                       from ruoli_derivati
                      where id_ruolo_componente = r.id_ruolo_componente
                        and id_profilo is not null)
            and id_componente = p_id_componente
            and ruolo = p_ruolo
            and dal = p_dal
            and al = dal - 1;
      exception
         when no_data_found then
            esiste_ruolo_da_ripristinare := 0;
      end;
      if esiste_ruolo_da_ripristinare <> 0 then
         update ruoli_componente
            set al                   = p_al
               ,al_prec              = null
               ,utente_aggiornamento = p_utente_aggiornamento
               ,data_aggiornamento   = p_data_aggiornamento
          where id_componente = p_id_componente
            and id_ruolo_componente = esiste_ruolo_da_ripristinare
            and ruolo = p_ruolo
            and dal = p_dal;
      else
         ins(p_id_ruolo_componente
            ,p_id_componente
            ,p_ruolo
            ,p_dal
            ,p_al
            ,p_dal_pubb
            ,p_al_pubb
            ,p_al_prec
            ,p_utente_aggiornamento
            ,p_data_aggiornamento);
      end if;
   end;

   --------------------------------------------------------------------------------

   function is_profilo
   (
      p_ruolo in ruoli_componente.ruolo%type
     ,p_data  in ruoli_componente.dal%type
   ) return boolean is
      /******************************************************************************
       NOME:        is_profilo
       DESCRIZIONE: Controllo is_profilo
       PARAMETRI:   p_ruolo
                    p_data
       NOTE:        Verifica se un RUOLO e' anche profilo alla data indicata
      ******************************************************************************/
      d_result    boolean := false;
      d_contatore number(10) := 0;
   begin
      if p_ruolo is not null then
         select count(*)
           into d_contatore
           from ruoli_profilo p
          where p.ruolo_profilo = p_ruolo
            and p_data between nvl(dal, to_date(2222222, 'j')) and
                nvl(al, to_date(3333333, 'j'));

         if d_contatore > 0 then
            d_result := true;
         end if;
      end if;

      return d_result;

   end;

   --------------------------------------------------------------------------------

   function is_ruolo_progetto --#430
   (p_ruolo in ruoli_componente.ruolo%type) return boolean is
      /******************************************************************************
       NOME:        is_ruolo_progetto
       DESCRIZIONE: Controllo is_ruolo_progetto
       PARAMETRI:   p_ruolo
       NOTE:        Verifica se un RUOLO e' abbinato ad un progetto/modulo
      ******************************************************************************/
      d_result    boolean := false;
      d_contatore number(10) := 0;
   begin
      if p_ruolo is not null then
         select count(*)
           into d_contatore
           from ad4_ruoli r
          where r.ruolo = p_ruolo
            and progetto is not null
            and modulo is not null;

         if d_contatore > 0 then
            d_result := true;
         end if;
      end if;

      return d_result;

   end;

   --------------------------------------------------------------------------------

   function get_id_profilo_origine(p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type)
      return integer is
      /******************************************************************************
       NOME:        get_id_profilo_origine
       DESCRIZIONE: Riporta id_ruolo_componente del profilo di origine
       PARAMETRI:   p_id_ruolo_componente
      ******************************************************************************/
      d_result     ruoli_derivati.id_profilo%type := -1;
      d_id_profilo number(10);
   begin

      begin
         select r.id_profilo
           into d_id_profilo
           from ruoli_derivati r
          where r.id_ruolo_componente = p_id_ruolo_componente;
         raise too_many_rows;
      exception
         when no_data_found then
            null;
         when too_many_rows then
            d_result := d_id_profilo;
      end;

      return d_result;

   end;

   --------------------------------------------------------------------------------

   function get_id_relazione_origine(p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type)
      return integer is
      /******************************************************************************
       NOME:        get_id_relazione_origine #634
       DESCRIZIONE: Riporta id_relazione della regola che ha determinato il ruolo
       PARAMETRI:   p_id_ruolo_componente
      ******************************************************************************/
      d_result       ruoli_derivati.id_relazione%type := -1;
      d_id_relazione number(10);
   begin

      begin
         select r.id_relazione
           into d_id_relazione
           from ruoli_derivati r
          where r.id_ruolo_componente = p_id_ruolo_componente;
         raise too_many_rows;
      exception
         when no_data_found then
            null;
         when too_many_rows then
            d_result := d_id_relazione;
      end;

      return d_result;

   end;

   --------------------------------------------------------------------------------

   function get_ruolo_profilo_origine(p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type)
      return varchar2 is
      /******************************************************************************
       NOME:        get_ruolo_profilo_origine
       DESCRIZIONE: Riporta codice del ruolo del profilo di origine
       PARAMETRI:   p_id_ruolo_componente
      ******************************************************************************/
      d_result varchar2(2000) := '';
   begin
      for rude in (select r.id_profilo
                     from ruoli_derivati r
                    where id_ruolo_componente = p_id_ruolo_componente)
      loop
         if d_result is null then
            d_result := ruolo_componente.get_ruolo(rude.id_profilo);
         else
            d_result := d_result || '; ' || ruolo_componente.get_ruolo(rude.id_profilo);
         end if;
      end loop;

      return d_result;

   end;

   --------------------------------------------------------------------------------

   function get_ordinamento(p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type)
      return varchar2 is
      /******************************************************************************
       NOME:        get_ordinamento
       DESCRIZIONE: Riporta una stringa utile per l'ordinamento nell'interfaccia
       PARAMETRI:   p_id_ruolo_componente
      ******************************************************************************/
      d_result  varchar2(32767);
      d_origine varchar2(1) := get_origine(p_id_ruolo_componente);
   begin
      d_result := '';

      if d_origine = 'S' then
         select lpad(ruolo, 16, 'a')
           into d_result
           from ruoli_componente
          where id_ruolo_componente = p_id_ruolo_componente;
      elsif d_origine = 'A' then
         --#634
         select lpad(ruolo, 16, 'b')
           into d_result
           from ruoli_componente
          where id_ruolo_componente = p_id_ruolo_componente;
      elsif d_origine = 'P' then
         select ruolo
           into d_result
           from ruoli_componente
          where id_ruolo_componente = p_id_ruolo_componente;
      elsif d_origine = 'D' then
         for ruco in (select level livello
                            ,r.ruolo
                            ,r.profilo
                        from vista_ruoli_profili r
                      connect by prior id_profilo = id_ruolo_componente
                       start with id_ruolo_componente = p_id_ruolo_componente
                       order by 1 desc
                               ,2)
         loop
            /*            d_result := d_result || lpad(ruco.profilo, 8, 'a') ||
                                    rpad(ruco.ruolo, 8, 'a');
            */
            d_result := d_result || ruco.profilo || ruco.ruolo;
         end loop;
      end if;
      return d_result;
   end;

   --------------------------------------------------------------------------------

   function get_origine(p_id_ruolo_componente in ruoli_componente.id_ruolo_componente%type)
      return varchar2 is
      /******************************************************************************
       NOME:        get_origine
       DESCRIZIONE: Riporta l'identificativo della genesi del ruolo
                    S : ruolo singolo
                    P : profilo
                    D : derivato da profilo
                    A : derivato da regola automatica
       PARAMETRI:   p_id_ruolo_componente
      ******************************************************************************/
      d_result varchar2(32767);
      d_dal    ruoli_componente.dal%type;
      d_al     ruoli_componente.dal%type;
      d_ruolo  ruoli_componente.ruolo%type;
   begin
      d_result := '';
      select ruolo
            ,dal
            ,al
        into d_ruolo
            ,d_dal
            ,d_al
        from ruoli_componente
       where id_ruolo_componente = p_id_ruolo_componente;
      if is_profilo(d_ruolo, least(trunc(sysdate), nvl(d_al, to_date(3333333, 'j')))) then
         d_result := 'P';
      else
         begin
            select 'D'
              into d_result
              from ruoli_derivati r
             where id_ruolo_componente = p_id_ruolo_componente
               and r.id_profilo is not null; --#634
         exception
            when no_data_found then
               begin
                  select 'A'
                    into d_result
                    from ruoli_derivati
                   where id_ruolo_componente = p_id_ruolo_componente
                     and id_relazione is not null; --#634
               exception
                  when no_data_found then
                     d_result := 'S';
                  when too_many_rows then
                     d_result := 'A';
               end;
            when too_many_rows then
               d_result := 'D';
         end;
      end if;
      --
      return d_result;
   end;

   --------------------------------------------------------------------------------

   function get_id_ruco_profilo
   (
      p_ruolo         in ruoli_componente.ruolo%type
     ,p_id_componente in ruoli_componente.id_componente%type
     ,p_data          in ruoli_componente.dal%type
   ) return ruoli_componente.id_ruolo_componente%type is
      /******************************************************************************
       NOME:        get_id_ruco_profilo
       DESCRIZIONE: riporta il id_ruolo_componente identificato da p_ruolo alla p_data
       PARAMETRI:   p_ruolo
                    p_id_componente
                    p_data
      ******************************************************************************/
      d_result ruoli_componente.id_ruolo_componente%type := -1;
   begin

      if p_ruolo is not null then
         select r.id_ruolo_componente
           into d_result
           from ruoli_componente r
          where ruolo = p_ruolo
            and id_componente = p_id_componente
            and p_data between nvl(dal, to_date(2222222, 'j')) and
                nvl(al, to_date(3333333, 'j'));
      end if;

      return d_result;

   end;

   --------------------------------------------------------------------------------

   procedure attribuzione_ruoli_profilo
   (
      p_id_componente        in ruoli_componente.id_componente%type
     ,p_ruolo                in ruoli_componente.ruolo%type
     ,p_data                 in ruoli_componente.dal%type
     ,p_dal                  in ruoli_componente.dal%type
     ,p_al                   in ruoli_componente.al%type default null
     ,p_dal_pubb             in ruoli_componente.dal_pubb%type default null
     ,p_al_pubb              in ruoli_componente.al_pubb%type default null
     ,p_utente_aggiornamento in ruoli_componente.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in ruoli_componente.data_aggiornamento%type default null
   ) is
      d_conta_ruoli_prec number(10) := 0;
      d_dal_prec         date;
      d_al_prec          date;
      d_id_ruco          ruoli_componente.id_ruolo_componente%type;
      d_id_ruco_prec     ruoli_componente.id_ruolo_componente%type;
      d_id_ruco_profilo  ruoli_componente.id_ruolo_componente%type := get_id_ruco_profilo(p_ruolo
                                                                                         ,p_id_componente
                                                                                         ,p_dal);
      d_dal              date;
      d_al               date;
      d_data_wrk         date;
      d_id_wrk           number;
      d_ruolo            varchar2(8);
   begin
      begin
         for rp in (select *
                      from ruoli_profilo
                     where ruolo_profilo = p_ruolo
                       and least(trunc(sysdate), p_data) between
                           nvl(dal, to_date(2222222, 'j')) and
                           nvl(al, to_date(3333333, 'j'))
                       and nvl(ruolo, 'def') <> 'def'
                     order by ruolo)
         loop
            d_ruolo            := rp.ruolo;
            d_conta_ruoli_prec := 0;
            begin
               --verifica se il ruolo in fase di inserimento non sia già presente per il componente
               select count(*)
                     ,min(dal)
                     ,max(al)
                     ,max(id_ruolo_componente)
                 into d_conta_ruoli_prec
                     ,d_dal_prec
                     ,d_al_prec
                     ,d_id_ruco_prec
                 from ruoli_componente
                where id_componente = p_id_componente
                  and ruolo = rp.ruolo
                  and dal <= nvl(p_al, to_date(3333333, 'j'))
                  and nvl(al, to_date(3333333, 'j')) >= p_dal
                  and dal <= nvl(al, to_date(3333333, 'j'));

               if d_conta_ruoli_prec = 0 then
                  -- per il componente il ruolo non esiste, lo inseriamo
                  select ruoli_componente_sq.nextval into d_id_ruco from dual;

                  --determina la data di fine attribuzione
                  select decode(least(nvl(rp.al, to_date(3333333, 'j'))
                                     ,nvl(p_al, to_date(3333333, 'j')))
                               ,s_nulld
                               ,to_date(null)
                               ,least(nvl(rp.al, to_date(3333333, 'j'))
                                     ,nvl(p_al, to_date(3333333, 'j'))))
                    into d_al
                    from dual;
                  ruolo_componente.ins(p_id_ruolo_componente  => d_id_ruco
                                      ,p_id_componente        => p_id_componente
                                      ,p_ruolo                => rp.ruolo
                                      ,p_dal                  => greatest(rp.dal, p_dal)
                                      ,p_al                   => d_al
                                      ,p_dal_pubb             => p_dal_pubb
                                      ,p_al_pubb              => p_al_pubb
                                      ,p_utente_aggiornamento => p_utente_aggiornamento
                                      ,p_data_aggiornamento   => p_data_aggiornamento);
                  if not
                      ruoli_derivati_pkg.esiste_relazione(p_id_ruolo_componente => d_id_ruco
                                                         ,p_id_profilo          => d_id_ruco_profilo) then
                     --#762
                     ruoli_derivati_tpk.ins(p_id_ruolo_derivato   => ''
                                           ,p_id_ruolo_componente => d_id_ruco
                                           ,p_id_profilo          => d_id_ruco_profilo);
                  end if;
               else
                  if get_id_profilo_origine(d_id_ruco_prec) <> d_id_ruco_profilo then
                     --#810
                     d_dal      := greatest(rp.dal, p_dal); --#36282
                     d_data_wrk := nvl(d_data_wrk, to_date(3333333, 'j')); --#40701
                     d_id_wrk   := '';
                     begin
                        while d_dal < nvl(d_al, to_date(3333333, 'j'))
                        loop
                           begin
                              select id_componente
                                    ,nvl(al, to_date(3333333, 'j'))
                                    ,id_ruolo_componente
                                into d_id_wrk
                                    ,d_data_wrk
                                    ,d_id_ruco_prec
                                from ruoli_componente
                               where id_componente = p_id_componente
                                 and ruolo = d_ruolo
                                 and dal <= nvl(al, to_date(3333333, 'j'))
                                 and d_dal between dal and nvl(al, to_date(3333333, 'j'));
                              raise too_many_rows;
                           exception
                              when no_data_found then
                                 select min(dal) - 1
                                   into d_data_wrk
                                   from ruoli_componente
                                  where id_componente = p_id_componente
                                    and ruolo = d_ruolo
                                    and dal <= nvl(al, to_date(3333333, 'j'))
                                    and dal > d_dal;

                                 select ruoli_componente_sq.nextval
                                   into d_id_ruco
                                   from dual;
                                 ruolo_componente.ins(p_id_ruolo_componente  => d_id_ruco
                                                     ,p_id_componente        => p_id_componente
                                                     ,p_ruolo                => rp.ruolo
                                                     ,p_dal                  => d_dal
                                                     ,p_al                   => d_data_wrk
                                                     ,p_dal_pubb             => p_dal_pubb
                                                     ,p_al_pubb              => least(d_data_wrk
                                                                                     ,p_al_pubb)
                                                     ,p_utente_aggiornamento => p_utente_aggiornamento
                                                     ,p_data_aggiornamento   => p_data_aggiornamento);

                                 if not
                                     ruoli_derivati_pkg.esiste_relazione(p_id_ruolo_componente => d_id_ruco
                                                                        ,p_id_profilo          => d_id_ruco_profilo) then
                                    --#762
                                    ruoli_derivati_tpk.ins(p_id_ruolo_derivato   => ''
                                                          ,p_id_ruolo_componente => d_id_ruco
                                                          ,p_id_profilo          => d_id_ruco_profilo);
                                 end if;

                                 d_dal := d_data_wrk + 1;
                              when too_many_rows then
                                 if nvl(d_al, to_date(3333333, 'j')) > d_data_wrk then
                                    if ruoli_derivati_pkg.is_origine_profilo(d_id_ruco_prec) then
                                       /* se il ruolo precedente deriva da un altro profilo aggiungiamo la nuova origine su RUDE
                                          in caso contrario lo lasciamo singolare
                                       */
                                       if not
                                           ruoli_derivati_pkg.esiste_relazione(p_id_ruolo_componente => d_id_ruco_prec
                                                                              ,p_id_profilo          => d_id_ruco_profilo) then
                                          --#762

                                          ruoli_derivati_tpk.ins(p_id_ruolo_derivato   => ''
                                                                ,p_id_ruolo_componente => d_id_ruco_prec
                                                                ,p_id_profilo          => d_id_ruco_profilo);
                                       end if;
                                       d_al := d_data_wrk + 1; --#33266
                                    end if;

                                    d_dal := d_data_wrk + 1;
                                 elsif nvl(d_al, to_date(3333333, 'j')) <= d_data_wrk then
                                    if ruoli_derivati_pkg.is_origine_profilo(d_id_ruco_prec) then
                                       /* se il ruolo precedente deriva da un altro profilo aggiungiamo la nuova origine su RUDE
                                          in caso contrario lo lasciamo singolare
                                       */
                                       if not
                                           ruoli_derivati_pkg.esiste_relazione(p_id_ruolo_componente => d_id_ruco_prec
                                                                              ,p_id_profilo          => d_id_ruco_profilo) then
                                          --#762

                                          ruoli_derivati_tpk.ins(p_id_ruolo_derivato   => ''
                                                                ,p_id_ruolo_componente => d_id_ruco_prec
                                                                ,p_id_profilo          => d_id_ruco_profilo);
                                       end if;
                                    end if;

                                    d_dal := nvl(d_al, to_date(3333333, 'j'));
                                 end if;
                                 d_al := d_data_wrk + 1; --#33266
                           end;
                        end loop;
                     end;
                  end if; --#810
               end if;
            end;
         end loop;
      end;
   end;

   --------------------------------------------------------------------------------

   procedure eliminazione_ruoli_profilo --#430
   (
      p_id_ruolo_componente  in ruoli_componente.id_ruolo_componente%type
     ,p_utente_aggiornamento in ruoli_componente.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in ruoli_componente.data_aggiornamento%type default null
   ) is
      d_segnalazione           varchar2(200);
      d_segnalazione_bloccante varchar2(1);
   begin
      begin
         s_gestione_profili := 1;
         for rd in (select r.*
                      from ruoli_derivati   r
                          ,ruoli_componente rc --#760 #764
                     where id_profilo = p_id_ruolo_componente
                       and rc.id_ruolo_componente = r.id_ruolo_componente
                       and rc.dal <= nvl(rc.al, to_date(3333333, 'j'))
                       and not exists
                     (select 'x'
                              from ruoli_derivati d
                             where id_ruolo_componente = r.id_ruolo_componente
                               and id_profilo <> r.id_profilo
                               and exists (select 'x'
                                      from ruoli_componente
                                     where id_ruolo_componente = d.id_profilo
                                       and nvl(al_pubb, to_date(3333333, 'j')) >=
                                           trunc(sysdate)))
                     order by r.id_ruolo_componente)
         loop
            ruolo_componente.eliminazione_logica_ruolo(p_id_ruolo_componente    => rd.id_ruolo_componente
                                                      ,p_data_aggiornamento     => p_data_aggiornamento
                                                      ,p_utente_aggiornamento   => p_utente_aggiornamento
                                                      ,p_segnalazione_bloccante => d_segnalazione_bloccante
                                                      ,p_segnalazione           => d_segnalazione);
         end loop;
         s_gestione_profili := 0;
      end;
   end;

   --------------------------------------------------------------------------------

   procedure aggiornamento_ruoli_profilo --#430
   (
      p_id_ruolo_componente  in ruoli_componente.id_ruolo_componente%type
     ,p_dal                  in ruoli_componente.dal%type
     ,p_al                   in ruoli_componente.al%type default null
     ,p_dal_pubb             in ruoli_componente.dal_pubb%type default null
     ,p_al_pubb              in ruoli_componente.al_pubb%type default null
     ,p_utente_aggiornamento in ruoli_componente.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in ruoli_componente.data_aggiornamento%type default null
   ) is
      d_wrk_dal date;
      d_wrk_al  date;
   begin
      begin
         s_gestione_profili := 1;
         for rd in (select r.*
                      from ruoli_derivati r
                     where id_profilo = p_id_ruolo_componente
                     order by id_ruolo_componente)
         loop
            --determina le date estreme piu' favorevoli se il ruolo è condiviso tra più profili del componente
            select nvl(least(min(dal_profilo), p_dal), p_dal)
                  ,nvl(greatest(max(nvl(al_profilo, to_date(3333333, 'j')))
                               ,nvl(p_al, to_date(3333333, 'j')))
                      ,p_al)
              into d_wrk_dal
                  ,d_wrk_al
              from vista_ruoli_profili
             where id_ruolo_componente = rd.id_ruolo_componente
               and id_profilo <> p_id_ruolo_componente
               and dal_profilo <= nvl(p_al, to_date(3333333, 'j'))
               and nvl(al_profilo, to_date(3333333, 'j')) >= p_dal;

            update ruoli_componente
               set dal                  = d_wrk_dal
                  ,al                   = decode(d_wrk_al
                                                ,to_date(3333333, 'j')
                                                ,to_date(null)
                                                ,d_wrk_al)
                  ,dal_pubb             = p_dal_pubb
                  ,al_pubb              = p_al_pubb
                  ,utente_aggiornamento = p_utente_aggiornamento
                  ,data_aggiornamento   = p_data_aggiornamento
             where id_ruolo_componente = rd.id_ruolo_componente
                  -- #40701 non aggiorna i periodi non modificati
               and (dal <> d_wrk_dal or
                   nvl(al, to_date(3333333, 'j')) <>
                   nvl(d_wrk_al, to_date(3333333, 'j')));
               --    decode(d_wrk_al, to_date(3333333, 'j'), to_date(null), d_wrk_al)); #48384
            -- #40701 elimina dai ruoli derivati i ruoli che sono rimasti esterni ai profili precedentemente condivisi
            delete from ruoli_derivati d
             where id_ruolo_componente = rd.id_ruolo_componente
               and id_profilo <> p_id_ruolo_componente
               and not (d_wrk_dal >= ruolo_componente.get_dal(d.id_profilo) and
                    d_wrk_al <=
                    nvl(ruolo_componente.get_al(d.id_profilo), to_date(3333333, 'j')));
         end loop;
         if componente.s_modifica_componente = 0 then
            s_gestione_profili := 0;
         end if;
      end;
   end;

--------------------------------------------------------------------------------

begin

   -- inserimento degli errori nella tabella
   --   s_error_table( s_<exception_name>_number ) := s_<exception_name>_msg;
   s_error_table(s_dal_al_errato_num) := s_dal_al_errato_msg;
   s_error_table(s_dal_minore_num) := s_dal_minore_msg;
   s_error_table(s_al_maggiore_num) := s_al_maggiore_msg;
   s_error_table(s_ruolo_presente_num) := s_ruolo_presente_msg;
   s_error_table(s_errore_eliminazione_num) := s_errore_eliminazione_msg;
   s_error_table(s_ruolo_unico_per_uo_num) := s_ruolo_unico_per_uo_msg;
   s_error_table(s_riattribuzione_fallita_num) := s_riattribuzione_fallita_msg;
   s_error_table(s_agg_dds_fallito_num) := s_agg_dds_fallito_msg; -- #39939 DDS

end ruolo_componente;
/

