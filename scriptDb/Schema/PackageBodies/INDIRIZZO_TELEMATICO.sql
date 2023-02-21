CREATE OR REPLACE package body indirizzo_telematico is
   /******************************************************************************
    NOME:        indirizzo_telematico
    DESCRIZIONE: Gestione tabella indirizzi_telematici.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore  Descrizione.
    000   29/01/2007  VDAVALLI  Prima   emissione.
    001   03/09/2009  VDAVALLI  Modifiche per configurazione master/slave
    002   08/01/2015  MMONARI   Issue #551: prestazioni get_indirizzo
          08/01/2015  MMONARI   Issue #561: prestazioni get_tag_mail
    003   14/03/2016  MMONARI   #689 Modifiche per gestione Contatti
    004   08/03/2018  MMONARI   #794 Modifiche per Aggiornamento indirizzo telematico
                                     esistente su entità con indirizzi multipli
    005   08/03/2019  SNEGRONI  Bug #33620 Modificata gestione degli indirizzi telematici 
                                in fase di gestione dello scarico IPA
    006   22/02/2022  MMONARI   #54239 ;iglioramenti prestazionali
                                in fase di gestione dello scarico IPA
    007   25/01/2023  MMONARI   #60713
   ******************************************************************************/
   s_revisione_body constant afc.t_revision := '007';
   s_error_table afc_error.t_error_table;
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
   end; -- indirizzo_telematico.versione
   --------------------------------------------------------------------------------
   function pk(p_id_indirizzo in indirizzi_telematici.id_indirizzo%type) return t_pk is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        PK
       DESCRIZIONE: Costruttore di un t_PK dati gli attributi della chiave
      ******************************************************************************/
      d_result t_pk;
   begin
      d_result.id_indirizzo := p_id_indirizzo;
      dbc.pre(not dbc.preon or canhandle(d_result.id_indirizzo)
             ,'canHandle on indirizzo_telematico.PK');
      return d_result;
   end; -- end indirizzo_telematico.PK
   --------------------------------------------------------------------------------
   function can_handle(p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
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
      if d_result = 1 and (p_id_indirizzo is null) then
         d_result := 0;
      end if;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on indirizzo_telematico.can_handle');
      return d_result;
   end; -- indirizzo_telematico.can_handle
   --------------------------------------------------------------------------------
   function canhandle(p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        canHandle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: true se la chiave è manipolabile, false altrimenti.
       NOTE:        Wrapper boolean di can_handle (cfr. can_handle).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(can_handle(p_id_indirizzo));
   begin
      return d_result;
   end; -- indirizzo_telematico.canHandle
   --------------------------------------------------------------------------------
   function exists_id(p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
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
      dbc.pre(not dbc.preon or canhandle(p_id_indirizzo)
             ,'canHandle on indirizzo_telematico.exists_id');
      begin
         select 1
           into d_result
           from indirizzi_telematici
          where id_indirizzo = p_id_indirizzo;
      exception
         when no_data_found then
            d_result := 0;
      end;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on indirizzo_telematico.exists_id');
      return d_result;
   end; -- indirizzo_telematico.exists_id
   --------------------------------------------------------------------------------
   function existsid(p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        existsId
       DESCRIZIONE: Esistenza riga con chiave indicata.
       NOTE:        Wrapper boolean di exists_id (cfr. exists_id).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(exists_id(p_id_indirizzo));
   begin
      return d_result;
   end; -- indirizzo_telematico.existsId
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
   end; -- indirizzo_telematico.error_message
   --------------------------------------------------------------------------------
   procedure ins
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_id_indirizzo           in indirizzi_telematici.id_indirizzo%type
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
     ,p_indirizzo              in indirizzi_telematici.indirizzo%type
     ,p_note                   in indirizzi_telematici.note%type default null
     ,p_protocol               in indirizzi_telematici.protocol%type default null
     ,p_server                 in indirizzi_telematici.server%type default null
     ,p_port                   in indirizzi_telematici.port%type default null
     ,p_utente                 in indirizzi_telematici.utente%type default null
     ,p_password               in indirizzi_telematici.password%type default null
     ,p_ssl                    in indirizzi_telematici.ssl%type default null
     ,p_authentication         in indirizzi_telematici.authentication%type default null
     ,p_utente_aggiornamento   in indirizzi_telematici.utente_aggiornamento%type default null
     ,p_data_aggiornamento     in indirizzi_telematici.data_aggiornamento%type default null
     ,p_tag_mail               in indirizzi_telematici.tag_mail%type default null
   ) is
      /******************************************************************************
       NOME:        ins
       DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
       PARAMETRI:   Chiavi e attributi della table.
      ******************************************************************************/
   begin
      -- Check Mandatory on Insert
      dbc.pre(not dbc.preon or p_tipo_indirizzo is not null
             ,'p_tipo_indirizzo on indirizzo_telematico.ins');
      dbc.pre(not dbc.preon or p_indirizzo is not null
             ,'p_indirizzo on indirizzo_telematico.ins');
      dbc.pre(not dbc.preon or p_id_indirizzo is null or not existsid(p_id_indirizzo)
             ,'not existsId on indirizzo_telematico.ins');
      insert into indirizzi_telematici
         (tipo_entita
         ,id_indirizzo
         ,tipo_indirizzo
         ,id_amministrazione
         ,id_aoo
         ,id_unita_organizzativa
         ,indirizzo
         ,note
         ,protocol
         ,server
         ,port
         ,utente
         ,password
         ,ssl
         ,authentication
         ,utente_aggiornamento
         ,data_aggiornamento
         ,tag_mail)
      values
         (p_tipo_entita
         ,p_id_indirizzo
         ,p_tipo_indirizzo
         ,p_id_amministrazione
         ,p_id_aoo
         ,p_id_unita_organizzativa
         ,p_indirizzo
         ,p_note
         ,p_protocol
         ,p_server
         ,p_port
         ,p_utente
         ,p_password
         ,p_ssl
         ,p_authentication
         ,p_utente_aggiornamento
         ,p_data_aggiornamento
         ,p_tag_mail);
   end; -- indirizzo_telematico.ins
   --------------------------------------------------------------------------------
   procedure upd
   (
      p_new_id_indirizzo           in indirizzi_telematici.id_indirizzo%type
     ,p_new_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
     ,p_new_id_amministrazione     in indirizzi_telematici.id_amministrazione%type
     ,p_new_id_aoo                 in indirizzi_telematici.id_aoo%type
     ,p_new_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type
     ,p_new_indirizzo              in indirizzi_telematici.indirizzo%type
     ,p_new_note                   in indirizzi_telematici.note%type default null
     ,p_new_protocol               in indirizzi_telematici.protocol%type default null
     ,p_new_server                 in indirizzi_telematici.server%type default null
     ,p_new_port                   in indirizzi_telematici.port%type default null
     ,p_new_utente                 in indirizzi_telematici.utente%type default null
     ,p_new_password               in indirizzi_telematici.password%type default null
     ,p_new_ssl                    in indirizzi_telematici.ssl%type default null
     ,p_new_authentication         in indirizzi_telematici.authentication%type default null
     ,p_new_utente_aggiornamento   in indirizzi_telematici.utente_aggiornamento%type default null
     ,p_new_data_aggiornamento     in indirizzi_telematici.data_aggiornamento%type default null
     ,p_new_tag_mail               in indirizzi_telematici.tag_mail%type default null
     ,p_old_id_indirizzo           in indirizzi_telematici.id_indirizzo%type default null
     ,p_old_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type default null
     ,p_old_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_old_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_old_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
     ,p_old_indirizzo              in indirizzi_telematici.indirizzo%type default null
     ,p_old_note                   in indirizzi_telematici.note%type default null
     ,p_old_protocol               in indirizzi_telematici.protocol%type default null
     ,p_old_server                 in indirizzi_telematici.server%type default null
     ,p_old_port                   in indirizzi_telematici.port%type default null
     ,p_old_utente                 in indirizzi_telematici.utente%type default null
     ,p_old_password               in indirizzi_telematici.password%type default null
     ,p_old_ssl                    in indirizzi_telematici.ssl%type default null
     ,p_old_authentication         in indirizzi_telematici.authentication%type default null
     ,p_old_utente_aggiornamento   in indirizzi_telematici.utente_aggiornamento%type default null
     ,p_old_data_aggiornamento     in indirizzi_telematici.data_aggiornamento%type default null
     ,p_old_tag_mail               in indirizzi_telematici.tag_mail%type default null
     ,p_check_old                  in integer default 0
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
              not
               ((p_old_tipo_indirizzo is not null or p_old_id_amministrazione is not null or
               p_old_id_aoo is not null or p_old_id_unita_organizzativa is not null or
               p_old_indirizzo is not null or p_old_note is not null or
               p_old_protocol is not null or p_old_server is not null or
               p_old_port is not null or p_old_utente is not null or
               p_old_password is not null or p_old_ssl is not null or
               p_old_authentication is not null or
               p_old_utente_aggiornamento is not null or
               p_old_data_aggiornamento is not null or p_old_tag_mail is not null) and
               p_check_old = 0)
             ,' <OLD values> is not null on indirizzo_telematico.upd');
      dbc.pre(not dbc.preon or p_check_old is not null
             ,'p_check_OLD is not null on indirizzo_telematico.upd');
      d_key := pk(nvl(p_old_id_indirizzo, p_new_id_indirizzo));
      dbc.pre(not dbc.preon or existsid(d_key.id_indirizzo)
             ,'existsId on indirizzo_telematico.upd');
      update indirizzi_telematici
         set id_indirizzo           = p_new_id_indirizzo
            ,tipo_indirizzo         = p_new_tipo_indirizzo
            ,id_amministrazione     = p_new_id_amministrazione
            ,id_aoo                 = p_new_id_aoo
            ,id_unita_organizzativa = p_new_id_unita_organizzativa
            ,indirizzo              = p_new_indirizzo
            ,note                   = p_new_note
            ,protocol               = p_new_protocol
            ,server                 = p_new_server
            ,port                   = p_new_port
            ,utente                 = p_new_utente
            ,password               = p_new_password
            ,ssl                    = p_new_ssl
            ,authentication         = p_new_authentication
            ,utente_aggiornamento   = p_new_utente_aggiornamento
            ,data_aggiornamento     = p_new_data_aggiornamento
            ,tag_mail               = p_new_tag_mail
       where id_indirizzo = d_key.id_indirizzo
         and (p_check_old = 0 or
             p_check_old = 1 and
             (tipo_indirizzo = p_old_tipo_indirizzo or
             tipo_indirizzo is null and p_old_tipo_indirizzo is null) and
             (id_amministrazione = p_old_id_amministrazione or
             id_amministrazione is null and p_old_id_amministrazione is null) and
             (id_aoo = p_old_id_aoo or id_aoo is null and p_old_id_aoo is null) and
             (id_unita_organizzativa = p_old_id_unita_organizzativa or
             id_unita_organizzativa is null and p_old_id_unita_organizzativa is null) and
             (indirizzo = p_old_indirizzo or
             indirizzo is null and p_old_indirizzo is null) and
             (note = p_old_note or note is null and p_old_note is null) and
             (protocol = p_old_protocol or protocol is null and p_old_protocol is null) and
             (server = p_old_server or server is null and p_old_server is null) and
             (port = p_old_port or port is null and p_old_port is null) and
             (utente = p_old_utente or utente is null and p_old_utente is null) and
             (password = p_old_password or password is null and p_old_password is null) and
             (ssl = p_old_ssl or ssl is null and p_old_ssl is null) and
             (authentication = p_old_authentication or
             authentication is null and p_old_authentication is null) and
             (utente_aggiornamento = p_old_utente_aggiornamento or
             utente_aggiornamento is null and p_old_utente_aggiornamento is null) and
             (data_aggiornamento = p_old_data_aggiornamento or
             data_aggiornamento is null and p_old_data_aggiornamento is null) and
             (tag_mail = p_old_tag_mail or tag_mail is null and p_old_tag_mail is null));
      d_row_found := sql%rowcount;
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on indirizzo_telematico.upd');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   end; -- indirizzo_telematico.upd
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_id_indirizzo  in indirizzi_telematici.id_indirizzo%type
     ,p_column        in varchar2
     ,p_value         in varchar2 default null
     ,p_literal_value in number default 1
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
      dbc.pre(not dbc.preon or existsid(p_id_indirizzo)
             ,'existsId on indirizzo_telematico.upd_column');
      dbc.pre(not dbc.preon or p_column is not null
             ,'p_column is not null on indirizzo_telematico.upd_column');
      dbc.pre(not dbc.preon or afc_ddl.hasattribute(s_table_name, p_column)
             ,'AFC_DDL.HasAttribute on indirizzo_telematico.upd_column');
      dbc.pre(p_literal_value in (0, 1)
             ,'p_literal_value in ( 0, 1 ) on indirizzo_telematico.upd_column; p_literal_value = ' ||
              p_literal_value);
      if p_literal_value = 1 then
         d_literal := '''';
      end if;
      d_statement := 'begin ' || '   update indirizzi_telematici' || '   set    ' ||
                     p_column || ' = ' || d_literal || p_value || d_literal ||
                     '   where  id_indirizzo = ''' || p_id_indirizzo || '''' || '   ;' ||
                     'end;';
      afc.sql_execute(d_statement);
   end; -- indirizzo_telematico.upd_column
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_id_indirizzo in indirizzi_telematici.id_indirizzo%type
     ,p_column       in varchar2
     ,p_value        in date
   ) is
      /******************************************************************************
       NOME:        upd_column
       DESCRIZIONE: Aggiornamento del campo p_column col valore p_value.
       NOTE:        Richiama se stessa con il parametro date convertito in stringa.
      ******************************************************************************/
      d_data varchar2(19);
   begin
      d_data := to_char(p_value, afc.date_format);
      upd_column(p_id_indirizzo
                ,p_column
                ,'to_date( ''' || d_data || ''', ''' || afc.date_format || ''' )'
                ,0);
   end; -- indirizzo_telematico.upd_column
   --------------------------------------------------------------------------------
   procedure del
   (
      p_id_indirizzo           in indirizzi_telematici.id_indirizzo%type
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type default null
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
     ,p_indirizzo              in indirizzi_telematici.indirizzo%type default null
     ,p_note                   in indirizzi_telematici.note%type default null
     ,p_protocol               in indirizzi_telematici.protocol%type default null
     ,p_server                 in indirizzi_telematici.server%type default null
     ,p_port                   in indirizzi_telematici.port%type default null
     ,p_utente                 in indirizzi_telematici.utente%type default null
     ,p_password               in indirizzi_telematici.password%type default null
     ,p_ssl                    in indirizzi_telematici.ssl%type default null
     ,p_authentication         in indirizzi_telematici.authentication%type default null
     ,p_utente_aggiornamento   in indirizzi_telematici.utente_aggiornamento%type default null
     ,p_data_aggiornamento     in indirizzi_telematici.data_aggiornamento%type default null
     ,p_tag_mail               in indirizzi_telematici.tag_mail%type default null
     ,p_check_old              in integer default 0
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
      dbc.pre(not dbc.preon or
              not ((p_tipo_indirizzo is not null or p_id_amministrazione is not null or
               p_id_aoo is not null or p_id_unita_organizzativa is not null or
               p_indirizzo is not null or p_note is not null or
               p_protocol is not null or p_server is not null or p_port is not null or
               p_utente is not null or p_password is not null or p_ssl is not null or
               p_authentication is not null or p_utente_aggiornamento is not null or
               p_data_aggiornamento is not null) and p_check_old = 0)
             ,' <OLD values> is not null on indirizzo_telematico.del');
      dbc.pre(not dbc.preon or existsid(p_id_indirizzo)
             ,'existsId on indirizzo_telematico.del');
      delete from indirizzi_telematici
       where id_indirizzo = p_id_indirizzo
         and (p_check_old = 0 or
             p_check_old = 1 and (tipo_indirizzo = p_tipo_indirizzo or
             tipo_indirizzo is null and p_tipo_indirizzo is null) and
             (id_amministrazione = p_id_amministrazione or
             id_amministrazione is null and p_id_amministrazione is null) and
             (id_aoo = p_id_aoo or id_aoo is null and p_id_aoo is null) and
             (id_unita_organizzativa = p_id_unita_organizzativa or
             id_unita_organizzativa is null and p_id_unita_organizzativa is null) and
             (indirizzo = p_indirizzo or indirizzo is null and p_indirizzo is null) and
             (note = p_note or note is null and p_note is null) and
             (protocol = p_protocol or protocol is null and p_protocol is null) and
             (server = p_server or server is null and p_server is null) and
             (port = p_port or port is null and p_port is null) and
             (utente = p_utente or utente is null and p_utente is null) and
             (password = p_password or password is null and p_password is null) and
             (ssl = p_ssl or ssl is null and p_ssl is null) and
             (authentication = p_authentication or
             authentication is null and p_authentication is null) and
             (utente_aggiornamento = p_utente_aggiornamento or
             utente_aggiornamento is null and p_utente_aggiornamento is null) and
             (data_aggiornamento = p_data_aggiornamento or
             data_aggiornamento is null and p_data_aggiornamento is null) and
             (tag_mail = p_tag_mail or tag_mail is null and p_tag_mail is null));
      d_row_found := sql%rowcount;
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on indirizzo_telematico.del');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
      dbc.post(not dbc.poston or not existsid(p_id_indirizzo)
              ,'existsId on indirizzo_telematico.del');
   end; -- indirizzo_telematico.del
   --------------------------------------------------------------------------------
   function get_tipo_indirizzo(p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return indirizzi_telematici.tipo_indirizzo%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_tipo_indirizzo
       DESCRIZIONE: Attributo tipo_indirizzo di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     indirizzi_telematici.tipo_indirizzo%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result indirizzi_telematici.tipo_indirizzo%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_indirizzo)
             ,'existsId on indirizzo_telematico.get_tipo_indirizzo');
      select tipo_indirizzo
        into d_result
        from indirizzi_telematici
       where id_indirizzo = p_id_indirizzo;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on indirizzo_telematico.get_tipo_indirizzo');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'tipo_indirizzo')
                      ,' AFC_DDL.IsNullable on indirizzo_telematico.get_tipo_indirizzo');
      end if;
      return d_result;
   end; -- indirizzo_telematico.get_tipo_indirizzo
   --------------------------------------------------------------------------------
   function get_id_amministrazione(p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return indirizzi_telematici.id_amministrazione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_id_amministrazione
       DESCRIZIONE: Attributo id_amministrazione di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     indirizzi_telematici.id_amministrazione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result indirizzi_telematici.id_amministrazione%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_indirizzo)
             ,'existsId on indirizzo_telematico.get_id_amministrazione');
      select id_amministrazione
        into d_result
        from indirizzi_telematici
       where id_indirizzo = p_id_indirizzo;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on indirizzo_telematico.get_id_amministrazione');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'id_amministrazione')
                      ,' AFC_DDL.IsNullable on indirizzo_telematico.get_id_amministrazione');
      end if;
      return d_result;
   end; -- indirizzo_telematico.get_id_amministrazione
   --------------------------------------------------------------------------------
   function get_id_aoo(p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return indirizzi_telematici.id_aoo%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_id_aoo
       DESCRIZIONE: Attributo id_aoo di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     indirizzi_telematici.id_aoo%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result indirizzi_telematici.id_aoo%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_indirizzo)
             ,'existsId on indirizzo_telematico.get_id_aoo');
      select id_aoo
        into d_result
        from indirizzi_telematici
       where id_indirizzo = p_id_indirizzo;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on indirizzo_telematico.get_id_aoo');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'id_aoo')
                      ,' AFC_DDL.IsNullable on indirizzo_telematico.get_id_aoo');
      end if;
      return d_result;
   end; -- indirizzo_telematico.get_id_aoo
   --------------------------------------------------------------------------------
   function get_id_unita_organizzativa(p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return indirizzi_telematici.id_unita_organizzativa%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_id_unita_organizzativa
       DESCRIZIONE: Attributo id_unita_organizzativa di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     indirizzi_telematici.id_unita_organizzativa%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result indirizzi_telematici.id_unita_organizzativa%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_indirizzo)
             ,'existsId on indirizzo_telematico.get_id_unita_organizzativa');
      select id_unita_organizzativa
        into d_result
        from indirizzi_telematici
       where id_indirizzo = p_id_indirizzo;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on indirizzo_telematico.get_id_unita_organizzativa');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'id_unita_organizzativa')
                      ,' AFC_DDL.IsNullable on indirizzo_telematico.get_id_unita_organizzativa');
      end if;
      return d_result;
   end; -- indirizzo_telematico.get_id_unita_organizzativa
   --------------------------------------------------------------------------------
   function get_indirizzo(p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return indirizzi_telematici.indirizzo%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_indirizzo
       DESCRIZIONE: Attributo indirizzo di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     indirizzi_telematici.indirizzo%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result indirizzi_telematici.indirizzo%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_indirizzo)
             ,'existsId on indirizzo_telematico.get_indirizzo');
      select indirizzo
        into d_result
        from indirizzi_telematici
       where id_indirizzo = p_id_indirizzo;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on indirizzo_telematico.get_indirizzo');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'indirizzo')
                      ,' AFC_DDL.IsNullable on indirizzo_telematico.get_indirizzo');
      end if;
      return d_result;
   end; -- indirizzo_telematico.get_indirizzo
   --------------------------------------------------------------------------------
   function get_indirizzo
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
   ) return indirizzi_telematici.indirizzo%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_indirizzo
       DESCRIZIONE: Attributo indirizzo di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     indirizzi_telematici.indirizzo%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result indirizzi_telematici.indirizzo%type;
   begin
      -- #551
      if p_id_unita_organizzativa is not null and p_id_amministrazione is null and
         p_id_aoo is null then
         begin
            select indirizzo
              into d_result
              from indirizzi_telematici
             where tipo_entita = p_tipo_entita
               and tipo_indirizzo = p_tipo_indirizzo
               and id_amministrazione is null
               and id_aoo is null
               and id_unita_organizzativa = p_id_unita_organizzativa;
         exception
            when no_data_found then
               d_result := to_char(null);
            when too_many_rows then
               d_result := to_char(null);
         end;
      elsif p_id_amministrazione is not null and p_id_aoo is null and
            p_id_unita_organizzativa is null then
         begin
            select indirizzo
              into d_result
              from indirizzi_telematici
             where tipo_entita = p_tipo_entita
               and tipo_indirizzo = p_tipo_indirizzo
               and id_amministrazione = p_id_amministrazione
               and p_id_amministrazione is not null
               and p_id_aoo is null
               and p_id_unita_organizzativa is null;
         exception
            when no_data_found then
               d_result := to_char(null);
            when too_many_rows then
               d_result := to_char(null);
         end;
      elsif p_id_amministrazione is null and p_id_aoo is not null and
            p_id_unita_organizzativa is null then
         begin
            select indirizzo
              into d_result
              from indirizzi_telematici
             where tipo_entita = p_tipo_entita
               and tipo_indirizzo = p_tipo_indirizzo
               and p_id_amministrazione is null
               and id_aoo = p_id_aoo
               and p_id_aoo is not null
               and p_id_unita_organizzativa is null;
         exception
            when no_data_found then
               d_result := to_char(null);
            when too_many_rows then
               d_result := to_char(null);
         end;
      end if;
      return d_result;
   end; -- indirizzo_telematico.get_indirizzo
   --------------------------------------------------------------------------------
   function get_note(p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return indirizzi_telematici.note%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_note
       DESCRIZIONE: Attributo note di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     indirizzi_telematici.note%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result indirizzi_telematici.note%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_indirizzo)
             ,'existsId on indirizzo_telematico.get_note');
      select note
        into d_result
        from indirizzi_telematici
       where id_indirizzo = p_id_indirizzo;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on indirizzo_telematico.get_note');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'note')
                      ,' AFC_DDL.IsNullable on indirizzo_telematico.get_note');
      end if;
      return d_result;
   end; -- indirizzo_telematico.get_note
   --------------------------------------------------------------------------------
   function get_note
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
   ) return indirizzi_telematici.note%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_note
       DESCRIZIONE: Attributo note di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     indirizzi_telematici.note%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result indirizzi_telematici.note%type;
   begin
      begin
         select note
           into d_result
           from indirizzi_telematici
          where tipo_entita = p_tipo_entita
            and tipo_indirizzo = p_tipo_indirizzo
            and nvl(id_amministrazione, 0) = nvl(p_id_amministrazione, 0)
            and nvl(id_aoo, 0) = nvl(p_id_aoo, 0)
            and nvl(id_unita_organizzativa, 0) = nvl(p_id_unita_organizzativa, 0);
      exception
         when no_data_found then
            d_result := to_char(null);
         when too_many_rows then
            d_result := to_char(null);
      end;
      return d_result;
   end; -- indirizzo_telematico.get_note
   --------------------------------------------------------------------------------
   function get_protocol(p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return indirizzi_telematici.protocol%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_protocol
       DESCRIZIONE: Attributo protocol di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     indirizzi_telematici.protocol%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result indirizzi_telematici.protocol%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_indirizzo)
             ,'existsId on indirizzo_telematico.get_protocol');
      select protocol
        into d_result
        from indirizzi_telematici
       where id_indirizzo = p_id_indirizzo;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on indirizzo_telematico.get_protocol');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'protocol')
                      ,' AFC_DDL.IsNullable on indirizzo_telematico.get_protocol');
      end if;
      return d_result;
   end; -- indirizzo_telematico.get_protocol
   --------------------------------------------------------------------------------
   function get_protocol
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
   ) return indirizzi_telematici.protocol%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_protocol
       DESCRIZIONE: Attributo protocol di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     indirizzi_telematici.protocol%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result indirizzi_telematici.protocol%type;
   begin
      begin
         select protocol
           into d_result
           from indirizzi_telematici
          where tipo_entita = p_tipo_entita
            and tipo_indirizzo = p_tipo_indirizzo
            and nvl(id_amministrazione, 0) = nvl(p_id_amministrazione, 0)
            and nvl(id_aoo, 0) = nvl(p_id_aoo, 0)
            and nvl(id_unita_organizzativa, 0) = nvl(p_id_unita_organizzativa, 0);
      exception
         when no_data_found then
            d_result := to_char(null);
         when too_many_rows then
            d_result := to_char(null);
      end;
      return d_result;
   end; -- indirizzo_telematico.get_protocol
   --------------------------------------------------------------------------------
   function get_server(p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return indirizzi_telematici.server%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_server
       DESCRIZIONE: Attributo server di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     indirizzi_telematici.server%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result indirizzi_telematici.server%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_indirizzo)
             ,'existsId on indirizzo_telematico.get_server');
      select server
        into d_result
        from indirizzi_telematici
       where id_indirizzo = p_id_indirizzo;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on indirizzo_telematico.get_server');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'server')
                      ,' AFC_DDL.IsNullable on indirizzo_telematico.get_server');
      end if;
      return d_result;
   end; -- indirizzo_telematico.get_server
   --------------------------------------------------------------------------------
   function get_server
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
   ) return indirizzi_telematici.server%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_server
       DESCRIZIONE: Attributo server di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     indirizzi_telematici.server%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result indirizzi_telematici.server%type;
   begin
      begin
         select server
           into d_result
           from indirizzi_telematici
          where tipo_entita = p_tipo_entita
            and tipo_indirizzo = p_tipo_indirizzo
            and nvl(id_amministrazione, 0) = nvl(p_id_amministrazione, 0)
            and nvl(id_aoo, 0) = nvl(p_id_aoo, 0)
            and nvl(id_unita_organizzativa, 0) = nvl(p_id_unita_organizzativa, 0);
      exception
         when no_data_found then
            d_result := to_char(null);
         when too_many_rows then
            d_result := to_char(null);
      end;
      return d_result;
   end; -- indirizzo_telematico.get_server
   --------------------------------------------------------------------------------
   function get_port(p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return indirizzi_telematici.port%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_port
       DESCRIZIONE: Attributo port di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     indirizzi_telematici.port%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result indirizzi_telematici.port%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_indirizzo)
             ,'existsId on indirizzo_telematico.get_port');
      select port
        into d_result
        from indirizzi_telematici
       where id_indirizzo = p_id_indirizzo;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on indirizzo_telematico.get_port');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'port')
                      ,' AFC_DDL.IsNullable on indirizzo_telematico.get_port');
      end if;
      return d_result;
   end; -- indirizzo_telematico.get_port
   --------------------------------------------------------------------------------
   function get_port
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
   ) return indirizzi_telematici.port%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_port
       DESCRIZIONE: Attributo port di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     indirizzi_telematici.port%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result indirizzi_telematici.port%type;
   begin
      begin
         select port
           into d_result
           from indirizzi_telematici
          where tipo_entita = p_tipo_entita
            and tipo_indirizzo = p_tipo_indirizzo
            and nvl(id_amministrazione, 0) = nvl(p_id_amministrazione, 0)
            and nvl(id_aoo, 0) = nvl(p_id_aoo, 0)
            and nvl(id_unita_organizzativa, 0) = nvl(p_id_unita_organizzativa, 0);
      exception
         when no_data_found then
            d_result := to_number(null);
         when too_many_rows then
            d_result := to_number(null);
      end;
      return d_result;
   end; -- indirizzo_telematico.get_port
   --------------------------------------------------------------------------------
   function get_utente(p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return indirizzi_telematici.utente%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_utente
       DESCRIZIONE: Attributo utente di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     indirizzi_telematici.utente%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result indirizzi_telematici.utente%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_indirizzo)
             ,'existsId on indirizzo_telematico.get_utente');
      select utente
        into d_result
        from indirizzi_telematici
       where id_indirizzo = p_id_indirizzo;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on indirizzo_telematico.get_utente');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'utente')
                      ,' AFC_DDL.IsNullable on indirizzo_telematico.get_utente');
      end if;
      return d_result;
   end; -- indirizzo_telematico.get_utente
   --------------------------------------------------------------------------------
   function get_utente
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
   ) return indirizzi_telematici.utente%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_utente
       DESCRIZIONE: Attributo utente di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     indirizzi_telematici.utente%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result indirizzi_telematici.utente%type;
   begin
      begin
         select utente
           into d_result
           from indirizzi_telematici
          where tipo_entita = p_tipo_entita
            and tipo_indirizzo = p_tipo_indirizzo
            and nvl(id_amministrazione, 0) = nvl(p_id_amministrazione, 0)
            and nvl(id_aoo, 0) = nvl(p_id_aoo, 0)
            and nvl(id_unita_organizzativa, 0) = nvl(p_id_unita_organizzativa, 0);
      exception
         when no_data_found then
            d_result := to_char(null);
         when too_many_rows then
            d_result := to_char(null);
      end;
      return d_result;
   end; -- indirizzo_telematico.get_utente
   --------------------------------------------------------------------------------
   function get_password(p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return indirizzi_telematici.password%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_password
       DESCRIZIONE: Attributo password di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     indirizzi_telematici.password%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result indirizzi_telematici.password%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_indirizzo)
             ,'existsId on indirizzo_telematico.get_password');
      select password
        into d_result
        from indirizzi_telematici
       where id_indirizzo = p_id_indirizzo;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on indirizzo_telematico.get_password');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'password')
                      ,' AFC_DDL.IsNullable on indirizzo_telematico.get_password');
      end if;
      return d_result;
   end; -- indirizzo_telematico.get_password
   --------------------------------------------------------------------------------
   function get_password
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
   ) return indirizzi_telematici.password%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_password
       DESCRIZIONE: Attributo password di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     indirizzi_telematici.password%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result indirizzi_telematici.password%type;
   begin
      begin
         select password
           into d_result
           from indirizzi_telematici
          where tipo_entita = p_tipo_entita
            and tipo_indirizzo = p_tipo_indirizzo
            and nvl(id_amministrazione, 0) = nvl(p_id_amministrazione, 0)
            and nvl(id_aoo, 0) = nvl(p_id_aoo, 0)
            and nvl(id_unita_organizzativa, 0) = nvl(p_id_unita_organizzativa, 0);
      exception
         when no_data_found then
            d_result := to_char(null);
         when too_many_rows then
            d_result := to_char(null);
      end;
      return d_result;
   end; -- indirizzo_telematico.get_password
   --------------------------------------------------------------------------------
   function get_ssl(p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return indirizzi_telematici.ssl%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_ssl
       DESCRIZIONE: Attributo ssl di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     indirizzi_telematici.ssl%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result indirizzi_telematici.ssl%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_indirizzo)
             ,'existsId on indirizzo_telematico.get_ssl');
      select ssl
        into d_result
        from indirizzi_telematici
       where id_indirizzo = p_id_indirizzo;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on indirizzo_telematico.get_ssl');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'ssl')
                      ,' AFC_DDL.IsNullable on indirizzo_telematico.get_ssl');
      end if;
      return d_result;
   end; -- indirizzo_telematico.get_ssl
   --------------------------------------------------------------------------------
   function get_ssl
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
   ) return indirizzi_telematici.ssl%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_ssl
       DESCRIZIONE: Attributo ssl di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     indirizzi_telematici.ssl%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result indirizzi_telematici.ssl%type;
   begin
      begin
         select ssl
           into d_result
           from indirizzi_telematici
          where tipo_entita = p_tipo_entita
            and tipo_indirizzo = p_tipo_indirizzo
            and nvl(id_amministrazione, 0) = nvl(p_id_amministrazione, 0)
            and nvl(id_aoo, 0) = nvl(p_id_aoo, 0)
            and nvl(id_unita_organizzativa, 0) = nvl(p_id_unita_organizzativa, 0);
      exception
         when no_data_found then
            d_result := to_number(null);
         when too_many_rows then
            d_result := to_number(null);
      end;
      return d_result;
   end; -- indirizzo_telematico.get_ssl
   --------------------------------------------------------------------------------
   function get_authentication(p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return indirizzi_telematici.authentication%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_authentication
       DESCRIZIONE: Attributo authentication di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     indirizzi_telematici.authentication%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result indirizzi_telematici.authentication%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_indirizzo)
             ,'existsId on indirizzo_telematico.get_authentication');
      select authentication
        into d_result
        from indirizzi_telematici
       where id_indirizzo = p_id_indirizzo;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on indirizzo_telematico.get_authentication');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'authentication')
                      ,' AFC_DDL.IsNullable on indirizzo_telematico.get_authentication');
      end if;
      return d_result;
   end; -- indirizzo_telematico.get_authentication
   --------------------------------------------------------------------------------
   function get_authentication
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
   ) return indirizzi_telematici.authentication%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_authentication
       DESCRIZIONE: Attributo authentication di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     indirizzi_telematici.authentication%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result indirizzi_telematici.authentication%type;
   begin
      begin
         select authentication
           into d_result
           from indirizzi_telematici
          where tipo_entita = p_tipo_entita
            and tipo_indirizzo = p_tipo_indirizzo
            and nvl(id_amministrazione, 0) = nvl(p_id_amministrazione, 0)
            and nvl(id_aoo, 0) = nvl(p_id_aoo, 0)
            and nvl(id_unita_organizzativa, 0) = nvl(p_id_unita_organizzativa, 0);
      exception
         when no_data_found then
            d_result := to_number(null);
         when too_many_rows then
            d_result := to_number(null);
      end;
      return d_result;
   end; -- indirizzo_telematico.get_authentication
   --------------------------------------------------------------------------------
   function get_utente_aggiornamento(p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return indirizzi_telematici.utente_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_utente_aggiornamento
       DESCRIZIONE: Attributo utente_aggiornamento di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     indirizzi_telematici.utente_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result indirizzi_telematici.utente_aggiornamento%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_indirizzo)
             ,'existsId on indirizzo_telematico.get_utente_aggiornamento');
      select utente_aggiornamento
        into d_result
        from indirizzi_telematici
       where id_indirizzo = p_id_indirizzo;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on indirizzo_telematico.get_utente_aggiornamento');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'utente_aggiornamento')
                      ,' AFC_DDL.IsNullable on indirizzo_telematico.get_utente_aggiornamento');
      end if;
      return d_result;
   end; -- indirizzo_telematico.get_utente_aggiornamento
   --------------------------------------------------------------------------------
   function get_utente_aggiornamento
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
   ) return indirizzi_telematici.utente_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_utente_aggiornamento
       DESCRIZIONE: Attributo utente_aggiornamento di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     indirizzi_telematici.utente_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result indirizzi_telematici.utente_aggiornamento%type;
   begin
      begin
         select utente_aggiornamento
           into d_result
           from indirizzi_telematici
          where tipo_entita = p_tipo_entita
            and tipo_indirizzo = p_tipo_indirizzo
            and nvl(id_amministrazione, 0) = nvl(p_id_amministrazione, 0)
            and nvl(id_aoo, 0) = nvl(p_id_aoo, 0)
            and nvl(id_unita_organizzativa, 0) = nvl(p_id_unita_organizzativa, 0);
      exception
         when no_data_found then
            d_result := to_char(null);
         when too_many_rows then
            d_result := to_char(null);
      end;
      return d_result;
   end; -- indirizzo_telematico.get_utente_aggiornamento
   --------------------------------------------------------------------------------
   function get_data_aggiornamento(p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return indirizzi_telematici.data_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_data_aggiornamento
       DESCRIZIONE: Attributo data_aggiornamento di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     indirizzi_telematici.data_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result indirizzi_telematici.data_aggiornamento%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_indirizzo)
             ,'existsId on indirizzo_telematico.get_data_aggiornamento');
      select data_aggiornamento
        into d_result
        from indirizzi_telematici
       where id_indirizzo = p_id_indirizzo;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on indirizzo_telematico.get_data_aggiornamento');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'data_aggiornamento')
                      ,' AFC_DDL.IsNullable on indirizzo_telematico.get_data_aggiornamento');
      end if;
      return d_result;
   end; -- indirizzo_telematico.get_data_aggiornamento
   --------------------------------------------------------------------------------
   function get_data_aggiornamento
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
   ) return indirizzi_telematici.data_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_data_aggiornamento
       DESCRIZIONE: Attributo data_aggiornamento di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     indirizzi_telematici.data_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result indirizzi_telematici.data_aggiornamento%type;
   begin
      begin
         select data_aggiornamento
           into d_result
           from indirizzi_telematici
          where tipo_entita = p_tipo_entita
            and tipo_indirizzo = p_tipo_indirizzo
            and nvl(id_amministrazione, 0) = nvl(p_id_amministrazione, 0)
            and nvl(id_aoo, 0) = nvl(p_id_aoo, 0)
            and nvl(id_unita_organizzativa, 0) = nvl(p_id_unita_organizzativa, 0);
      exception
         when no_data_found then
            d_result := to_date(null);
         when too_many_rows then
            d_result := to_date(null);
      end;
      return d_result;
   end; -- indirizzo_telematico.get_data_aggiornamento
   --------------------------------------------------------------------------------
   function get_tag_mail(p_id_indirizzo in indirizzi_telematici.id_indirizzo%type)
      return indirizzi_telematici.tag_mail%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_tag_mail
       DESCRIZIONE: Attributo tag_mail di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     indirizzi_telematici.tag_mail%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result indirizzi_telematici.tag_mail%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_indirizzo)
             ,'existsId on indirizzo_telematico.get_tag_mail');
      select tag_mail
        into d_result
        from indirizzi_telematici
       where id_indirizzo = p_id_indirizzo;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on indirizzo_telematico.get_tag_mail');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'tag_mail')
                      ,' AFC_DDL.IsNullable on indirizzo_telematico.get_tag_mail');
      end if;
      return d_result;
   end; -- indirizzo_telematico.get_tag_mail
   --------------------------------------------------------------------------------
   function get_tag_mail
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
   ) return indirizzi_telematici.tag_mail%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_tag_mail
       DESCRIZIONE: Attributo tag_mail di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     indirizzi_telematici.tag_mail%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result indirizzi_telematici.tag_mail%type;
   begin
      -- #561
      if p_id_unita_organizzativa is not null and p_id_amministrazione is null and
         p_id_aoo is null then
         begin
            select tag_mail
              into d_result
              from indirizzi_telematici
             where tipo_entita = p_tipo_entita
               and tipo_indirizzo = p_tipo_indirizzo
               and id_amministrazione is null
               and id_aoo is null
               and id_unita_organizzativa = p_id_unita_organizzativa;
         exception
            when no_data_found then
               d_result := to_char(null);
            when too_many_rows then
               d_result := to_char(null);
         end;
      elsif p_id_amministrazione is not null and p_id_aoo is null and
            p_id_unita_organizzativa is null then
         begin
            select tag_mail
              into d_result
              from indirizzi_telematici
             where tipo_entita = p_tipo_entita
               and tipo_indirizzo = p_tipo_indirizzo
               and id_amministrazione = p_id_amministrazione
               and p_id_amministrazione is not null
               and p_id_aoo is null
               and p_id_unita_organizzativa is null;
         exception
            when no_data_found then
               d_result := to_char(null);
            when too_many_rows then
               d_result := to_char(null);
         end;
      elsif p_id_amministrazione is null and p_id_aoo is not null and
            p_id_unita_organizzativa is null then
         begin
            select tag_mail
              into d_result
              from indirizzi_telematici
             where tipo_entita = p_tipo_entita
               and tipo_indirizzo = p_tipo_indirizzo
               and p_id_amministrazione is null
               and id_aoo = p_id_aoo
               and p_id_aoo is not null
               and p_id_unita_organizzativa is null;
         exception
            when no_data_found then
               d_result := to_char(null);
            when too_many_rows then
               d_result := to_char(null);
         end;
      end if;
      return d_result;
   end; -- indirizzo_telematico.get_tag_mail
   --------------------------------------------------------------------------------
   function get_chiave
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
   ) return indirizzi_telematici.id_indirizzo%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_chiave
       DESCRIZIONE: Attributo id_indirizzo di riga esistente identificata da altri
                    campi
       PARAMETRI:
       RITORNA:     indirizzi_telematici.id_indirizzo%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result indirizzi_telematici.id_indirizzo%type;
   begin
      begin
         select id_indirizzo
           into d_result
           from indirizzi_telematici
          where tipo_entita = p_tipo_entita
            and tipo_indirizzo = p_tipo_indirizzo
            and ((p_tipo_entita = 'AM' and id_amministrazione = p_id_amministrazione) or
                (p_tipo_entita = 'AO' and id_aoo = p_id_aoo) or
                (p_tipo_entita = 'UO' and
                id_unita_organizzativa = p_id_unita_organizzativa));
      exception
         when no_data_found then
            d_result := null;
         when too_many_rows then
            d_result := null;
         when others then
            raise_application_error(-20999
                                   ,'Errore in lettura INDIRIZZI_TELEMATICI - ' ||
                                    sqlerrm);
      end;
      --
      return d_result;
   end; -- indirizzo_telematico.get_chiave
   --------------------------------------------------------------------------------
   function get_id_indirizzo return indirizzi_telematici.id_indirizzo%type is
      /******************************************************************************
       NOME:        get_id_indirizzo
       DESCRIZIONE: Attributo nuova chiave per inserimento
       PARAMETRI:   Nessuno
       RITORNA:     indirizzi_telematici.id_indirizzo%type.
       NOTE:        Si seleziona il nextval della sequence INDIRIZZI_TELEMATICI_SQ
      ******************************************************************************/
      d_result indirizzi_telematici.id_indirizzo%type;
   begin
      select indirizzi_telematici_sq.nextval into d_result from dual;
      return d_result;
   end; -- indirizzo_telematico.get_id_indirizzo
   --------------------------------------------------------------------------------
   function where_condition
   (
      p_id_indirizzo           in varchar2 default null
     ,p_tipo_indirizzo         in varchar2 default null
     ,p_id_amministrazione     in varchar2 default null
     ,p_id_aoo                 in varchar2 default null
     ,p_id_unita_organizzativa in varchar2 default null
     ,p_indirizzo              in varchar2 default null
     ,p_note                   in varchar2 default null
     ,p_protocol               in varchar2 default null
     ,p_server                 in varchar2 default null
     ,p_port                   in varchar2 default null
     ,p_utente                 in varchar2 default null
     ,p_password               in varchar2 default null
     ,p_ssl                    in varchar2 default null
     ,p_authentication         in varchar2 default null
     ,p_tag_mail               in varchar2 default null
     ,p_other_condition        in varchar2 default null
     ,p_qbe                    in number default 0
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
                     afc.get_field_condition(' and ( id_indirizzo '
                                            ,p_id_indirizzo
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( tipo_indirizzo '
                                            ,p_tipo_indirizzo
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( id_amministrazione '
                                            ,p_id_amministrazione
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( id_aoo ', p_id_aoo, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( id_unita_organizzativa '
                                            ,p_id_unita_organizzativa
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( indirizzo '
                                            ,p_indirizzo
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( note ', p_note, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( protocol ', p_protocol, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( server ', p_server, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( port ', p_port, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( utente ', p_utente, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( password ', p_password, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( ssl ', p_ssl, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( authentication '
                                            ,p_authentication
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( tag_mail ', p_tag_mail, ' )', p_qbe) ||
                     ' ) ' || p_other_condition;
      return d_statement;
   end; --- indirizzo_telematico.where_condition
   --------------------------------------------------------------------------------
   function get_rows
   (
      p_id_indirizzo           in varchar2 default null
     ,p_tipo_indirizzo         in varchar2 default null
     ,p_id_amministrazione     in varchar2 default null
     ,p_id_aoo                 in varchar2 default null
     ,p_id_unita_organizzativa in varchar2 default null
     ,p_indirizzo              in varchar2 default null
     ,p_note                   in varchar2 default null
     ,p_protocol               in varchar2 default null
     ,p_server                 in varchar2 default null
     ,p_port                   in varchar2 default null
     ,p_utente                 in varchar2 default null
     ,p_password               in varchar2 default null
     ,p_ssl                    in varchar2 default null
     ,p_authentication         in varchar2 default null
     ,p_tag_mail               in varchar2 default null
     ,p_other_condition        in varchar2 default null
     ,p_qbe                    in number default 0
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
             ,'check p_QBE on indirizzo_telematico.get_rows');
      d_statement  := ' select * from indirizzi_telematici ' ||
                      where_condition(p_id_indirizzo
                                     ,p_tipo_indirizzo
                                     ,p_id_amministrazione
                                     ,p_id_aoo
                                     ,p_id_unita_organizzativa
                                     ,p_indirizzo
                                     ,p_note
                                     ,p_protocol
                                     ,p_server
                                     ,p_port
                                     ,p_utente
                                     ,p_password
                                     ,p_ssl
                                     ,p_authentication
                                     ,p_tag_mail
                                     ,p_other_condition
                                     ,p_qbe);
      d_ref_cursor := afc_dml.get_ref_cursor(d_statement);
      return d_ref_cursor;
   end; -- indirizzo_telematico.get_rows
   --------------------------------------------------------------------------------
   function count_rows
   (
      p_id_indirizzo           in varchar2 default null
     ,p_tipo_indirizzo         in varchar2 default null
     ,p_id_amministrazione     in varchar2 default null
     ,p_id_aoo                 in varchar2 default null
     ,p_id_unita_organizzativa in varchar2 default null
     ,p_indirizzo              in varchar2 default null
     ,p_note                   in varchar2 default null
     ,p_protocol               in varchar2 default null
     ,p_server                 in varchar2 default null
     ,p_port                   in varchar2 default null
     ,p_utente                 in varchar2 default null
     ,p_password               in varchar2 default null
     ,p_ssl                    in varchar2 default null
     ,p_authentication         in varchar2 default null
     ,p_tag_mail               in varchar2 default null
     ,p_other_condition        in varchar2 default null
     ,p_qbe                    in number default 0
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
             ,'check p_QBE on indirizzo_telematico.count_rows');
      d_statement := ' select count( * ) from indirizzi_telematici ' ||
                     where_condition(p_id_indirizzo
                                    ,p_tipo_indirizzo
                                    ,p_id_amministrazione
                                    ,p_id_aoo
                                    ,p_id_unita_organizzativa
                                    ,p_indirizzo
                                    ,p_note
                                    ,p_protocol
                                    ,p_server
                                    ,p_port
                                    ,p_utente
                                    ,p_password
                                    ,p_ssl
                                    ,p_authentication
                                    ,p_tag_mail
                                    ,p_other_condition
                                    ,p_qbe);
      d_result    := afc.sql_execute(d_statement);
      return d_result;
   end; -- indirizzo_telematico.count_rows
   --------------------------------------------------------------------------------
   function is_indirizzo_ok
   (
      p_tipo_entita        in indirizzi_telematici.tipo_entita%type
     ,p_tipo_indirizzo     in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_indirizzo       in indirizzi_telematici.id_indirizzo%type
     ,p_id_amministrazione in indirizzi_telematici.id_amministrazione%type
     ,p_id_aoo             in indirizzi_telematici.id_aoo%type
     ,p_id_unita           in indirizzi_telematici.id_unita_organizzativa%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_indirizzo_ok.
       DESCRIZIONE: Controlla che non vengano inseriti più indirizzi dello stesso
                    tipo per la stessa entita'
       PARAMETRI:
       NOTE:        --
      ******************************************************************************/
      d_result        afc_error.t_error_number;
      d_select_result number;
   begin
      if p_tipo_indirizzo in ('P', 'C', 'G') then
         --#689
         d_select_result := 0;
      else
         --#54239
         begin
            if p_tipo_entita = 'AM' then
               select count(*)
                 into d_select_result
                 from indirizzi_telematici
                where tipo_entita = p_tipo_entita
                  and tipo_indirizzo = p_tipo_indirizzo
                  and id_amministrazione = p_id_amministrazione
                  and id_indirizzo <> p_id_indirizzo;
            elsif p_tipo_entita = 'AO' then
               select count(*)
                 into d_select_result
                 from indirizzi_telematici
                where tipo_entita = p_tipo_entita
                  and tipo_indirizzo = p_tipo_indirizzo
                  and id_aoo = p_id_aoo
                  and id_indirizzo <> p_id_indirizzo;
            elsif p_tipo_entita = 'UO' then
               select count(*)
                 into d_select_result
                 from indirizzi_telematici
                where tipo_entita = p_tipo_entita
                  and tipo_indirizzo = p_tipo_indirizzo
                  and id_unita_organizzativa = p_id_unita
                  and id_indirizzo <> p_id_indirizzo;
            end if;
         exception
            when others then
               d_select_result := 1;
         end;
      end if;
      --
      if d_select_result = 0 then
         d_result := afc_error.ok;
      else
         d_result := s_indirizzo_presente_number;
      end if;
      return d_result;
   end; -- indirizzo_telematico.is_indirizzo_ok
   --------------------------------------------------------------------------------
   function is_ri_ok
   (
      p_tipo_entita        in indirizzi_telematici.tipo_entita%type
     ,p_tipo_indirizzo     in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_indirizzo       in indirizzi_telematici.id_indirizzo%type
     ,p_id_amministrazione in indirizzi_telematici.id_amministrazione%type
     ,p_id_aoo             in indirizzi_telematici.id_aoo%type
     ,p_id_unita           in indirizzi_telematici.id_unita_organizzativa%type
     ,p_inserting          in number
     ,p_updating           in number
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_RI_ok.
       DESCRIZIONE: gestione della Referential Integrity:
       PARAMETRI:
       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
      if p_inserting = 1 or p_updating = 1 then
         d_result := is_indirizzo_ok(p_tipo_entita
                                    ,p_tipo_indirizzo
                                    ,p_id_indirizzo
                                    ,p_id_amministrazione
                                    ,p_id_aoo
                                    ,p_id_unita);
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on indirizzo_telematico.is_RI_ok');
      return d_result;
   end; -- indirizzo_telematico.is_RI_ok
   --------------------------------------------------------------------------------
   procedure chk_ri
   (
      p_tipo_entita        in indirizzi_telematici.tipo_entita%type
     ,p_tipo_indirizzo     in indirizzi_telematici.tipo_indirizzo%type
     ,p_id_indirizzo       in indirizzi_telematici.id_indirizzo%type
     ,p_id_amministrazione in indirizzi_telematici.id_amministrazione%type
     ,p_id_aoo             in indirizzi_telematici.id_aoo%type
     ,p_id_unita           in indirizzi_telematici.id_unita_organizzativa%type
     ,p_inserting          in number
     ,p_updating           in number
   ) is
      /******************************************************************************
       NOME:        chk_RI.
       DESCRIZIONE: gestione della Referential Integrity:
       PARAMETRI:
       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
      d_result := is_ri_ok(p_tipo_entita
                          ,p_tipo_indirizzo
                          ,p_id_indirizzo
                          ,p_id_amministrazione
                          ,p_id_aoo
                          ,p_id_unita
                          ,p_inserting
                          ,p_updating);
      dbc.assertion(not dbc.assertionon or d_result = afc_error.ok or d_result < 0
                   ,'d_result = AFC_Error.ok or d_result < 0 on aoo_pkg.chk_RI');
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, error_message(d_result));
      end if;
   end; -- indirizzo_telematico.chk_RI
   --------------------------------------------------------------------------------
   procedure agg_automatico
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
     ,p_tipo_indirizzo         in indirizzi_telematici.tipo_indirizzo%type
     ,p_indirizzo              in indirizzi_telematici.indirizzo%type
     ,p_contatti               in indirizzi_telematici.note%type default null --#689
     ,p_scarico_ipa            in number default null  --#54239
     ,p_utente_aggiornamento   in indirizzi_telematici.utente_aggiornamento%type
     ,p_data_aggiornamento     in indirizzi_telematici.data_aggiornamento%type
   ) is
      /******************************************************************************
       NOME:        agg_automatico
       DESCRIZIONE: Verifica se i dati passati sono stati modificati;
                    in caso affermativo si esegue l'aggiornamento del record
                    Se i dati non esistono vengono inseriti
                    -
       RITORNA:     -
        REVISIONI:   .
        Rev.  Data        Autore  Descrizione.       
       005   08/03/2019  SNEGRONI  Bug #33620 Modificata gestione degli indirizzi telematici 
                                in fase di gestione dello scarico IPA
      ******************************************************************************/
      d_id_indirizzo   indirizzi_telematici.id_indirizzo%type;
      d_indirizzo      indirizzi_telematici.indirizzo%type;
      d_tipo_indirizzo indirizzi_telematici.tipo_indirizzo%type;
      uscita exception;
      d_num_elementi number(4);
      d_inizio       number(4);
      d_lunghezza    number(4);
      d_contatto     indirizzi_telematici.indirizzo%type;
   begin
      if p_indirizzo is null and p_contatti is null then
         raise uscita;
      end if;
      --#54239
      if p_scarico_ipa =1 then
        s_scarico_ipa := 1;
      end if;
      if p_indirizzo is not null then     
       d_id_indirizzo := null;
       d_indirizzo    := null;
        if   p_tipo_indirizzo = 'I' then --primo giro  
         -- gestione dell'indirizzo
         begin
            select id_indirizzo
                  ,indirizzo
              into d_id_indirizzo
                  ,d_indirizzo
              from indirizzi_telematici
             where p_id_amministrazione is not null
               and tipo_entita = p_tipo_entita
               and id_amministrazione = p_id_amministrazione
               and tipo_indirizzo = p_tipo_indirizzo --#794
            union
            select id_indirizzo
                  ,indirizzo
              from indirizzi_telematici
             where p_id_aoo is not null
               and tipo_entita = p_tipo_entita
               and id_aoo = p_id_aoo
               and tipo_indirizzo = p_tipo_indirizzo --#794
            union
            select id_indirizzo
                  ,indirizzo
              from indirizzi_telematici
             where p_id_unita_organizzativa is not null
               and tipo_entita = p_tipo_entita
               and id_unita_organizzativa = p_id_unita_organizzativa
               and tipo_indirizzo = p_tipo_indirizzo --#794
            ;
         exception
            when others then
               d_id_indirizzo := null;
               d_indirizzo    := null;
         end;
         end if;
         --
         if d_id_indirizzo is not null then
            if d_indirizzo != p_indirizzo and p_tipo_indirizzo = 'I' then
               indirizzo_telematico.upd_column(p_id_indirizzo => d_id_indirizzo
                                              ,p_column       => 'INDIRIZZO'
                                              ,p_value        => p_indirizzo);
            end if;
         else
           if p_tipo_indirizzo = 'I' then
            indirizzo_telematico.ins(p_id_indirizzo           => null
                                    ,p_tipo_entita            => p_tipo_entita
                                    ,p_tipo_indirizzo         => p_tipo_indirizzo
                                    ,p_id_amministrazione     => p_id_amministrazione
                                    ,p_id_aoo                 => p_id_aoo
                                    ,p_id_unita_organizzativa => p_id_unita_organizzativa
                                    ,p_indirizzo              => p_indirizzo
                                    ,p_utente_aggiornamento   => p_utente_aggiornamento
                                    ,p_data_aggiornamento     => p_data_aggiornamento);
            else
            
            declare
         v_esiste_gia number := 0;
         begin          
         --#33620 Inizio
         -- ne controllo 1 x volta qui arrivano gia spezzati
         -- inserimento fuori dal loop
             v_esiste_gia := 0;
         for v_esistono in (
         select id_indirizzo
                  ,indirizzo
                  ,tipo_indirizzo
              from indirizzi_telematici
             where p_id_amministrazione is not null
               and tipo_entita = p_tipo_entita
               and id_amministrazione = p_id_amministrazione
               and tipo_indirizzo != 'I'
            union
            select id_indirizzo
                  ,indirizzo
                  ,tipo_indirizzo
              from indirizzi_telematici
             where p_id_aoo is not null
               and tipo_entita = p_tipo_entita
               and id_aoo = p_id_aoo
               and tipo_indirizzo  != 'I'
            union
            select id_indirizzo
                  ,indirizzo
                  ,tipo_indirizzo
              from indirizzi_telematici
             where p_id_unita_organizzativa is not null
               and tipo_entita = p_tipo_entita
               and id_unita_organizzativa = p_id_unita_organizzativa
                                        and tipo_indirizzo != 'I')
                  loop
               if upper(p_indirizzo) = upper(v_esistono.indirizzo) and 
               p_tipo_indirizzo = v_esistono.tipo_indirizzo then
                   v_esiste_gia := 1;
               end if;    
            end loop;
          
             if v_esiste_gia = 0 then
            indirizzo_telematico.ins(p_id_indirizzo           => null
                                    ,p_tipo_entita            => p_tipo_entita
                                    ,p_tipo_indirizzo         => p_tipo_indirizzo
                                    ,p_id_amministrazione     => p_id_amministrazione
                                    ,p_id_aoo                 => p_id_aoo
                                    ,p_id_unita_organizzativa => p_id_unita_organizzativa
                                    ,p_indirizzo              => p_indirizzo
                                    ,p_utente_aggiornamento   => p_utente_aggiornamento
                                    ,p_data_aggiornamento     => p_data_aggiornamento);
             end if;
         end;
         end if;
         end if;
      end if;
      -- #33620 Fine
      --verifica e aggiorna i contatti
      if p_contatti is not null then      
      -- #33620 Inizio x chiudere contatti non più esistenti
         if p_tipo_indirizzo = 'I' then -- primo giro
         declare
         v_esiste_ancora number := 0;
         begin
         for v_se_chiudere in (
         select id_indirizzo
                  ,indirizzo
                  ,tipo_indirizzo
              from indirizzi_telematici
             where p_id_amministrazione is not null
               and tipo_entita = p_tipo_entita
               and id_amministrazione = p_id_amministrazione
               and tipo_indirizzo != 'I'
            union
            select id_indirizzo
                  ,indirizzo
                  ,tipo_indirizzo
              from indirizzi_telematici
             where p_id_aoo is not null
               and tipo_entita = p_tipo_entita
               and id_aoo = p_id_aoo
               and tipo_indirizzo  != 'I'
            union
            select id_indirizzo
                  ,indirizzo
                  ,tipo_indirizzo
              from indirizzi_telematici
             where p_id_unita_organizzativa is not null
               and tipo_entita = p_tipo_entita
               and id_unita_organizzativa = p_id_unita_organizzativa
               and tipo_indirizzo != 'I')
         loop
         v_esiste_ancora := 0;
               
          --spacchetta i contatti dalla stringa parametro
         d_num_elementi := afc.countoccurrenceof(rtrim(p_contatti, ';') || ';', ';'); -- #33620 altrimenti non trova il secondo ; separatore
         d_inizio       := 1;
         for d_indice in 1 .. d_num_elementi
         loop
            d_lunghezza      := (instr(rtrim(p_contatti, ';') || ';', ';', 1, d_indice) - 1) - d_inizio + 1;-- #33620 altrimenti non trova il secondo ; separatore
            d_contatto       := substr(rtrim(p_contatti, ';') || ';', d_inizio, d_lunghezza);-- #33620 altrimenti non trova il secondo ; separatore
            d_inizio         := d_inizio + d_lunghezza + 1;
            d_tipo_indirizzo := 'C';
            -- depura l'indirizzo dei caratteri a destra dell'eventuale #
            if instr(d_contatto, '#') <> 0 then
               if instr(upper(d_contatto), '#PEC') <> 0 then
                  d_tipo_indirizzo := 'P';
               end if;
               d_contatto := substr(d_contatto, 1, instr(d_contatto, '#') - 1);
            end if;
            if upper(d_contatto) = upper(v_se_chiudere.indirizzo) and 
               d_tipo_indirizzo = v_se_chiudere.tipo_indirizzo then
               v_esiste_ancora := 1;
            end if;
             end loop;
             if v_esiste_ancora = 0 then
               indirizzo_telematico.del(p_id_indirizzo => v_se_chiudere.id_indirizzo);
             end if;
          END LOOP;
         end;
         end if;
         -- #33620 Fine
      
         --spacchetta i contatti dalla stringa parametro
         d_num_elementi := afc.countoccurrenceof(rtrim(p_contatti, ';') || ';', ';'); -- #33620 altrimenti non trova il secondo ; separatore
         d_inizio       := 1;
         for d_indice in 1 .. d_num_elementi
         loop
            d_lunghezza      := (instr(rtrim(p_contatti, ';') || ';', ';', 1, d_indice) - 1) - d_inizio + 1;-- #33620 altrimenti non trova il secondo ; separatore
            d_contatto       := substr(rtrim(p_contatti, ';') || ';', d_inizio, d_lunghezza);-- #33620 altrimenti non trova il secondo ; separatore
            d_inizio         := d_inizio + d_lunghezza + 1;
            d_tipo_indirizzo := 'C';
            -- depura l'indirizzo dei caratteri a destra dell'eventuale #
            if instr(d_contatto, '#') <> 0 then
               if instr(upper(d_contatto), '#PEC') <> 0 then
                  d_tipo_indirizzo := 'P';
               end if;
               d_contatto := substr(d_contatto, 1, instr(d_contatto, '#') - 1);
            end if;
            if p_tipo_entita = 'AM' then
               agg_automatico(p_tipo_entita          => p_tipo_entita
                             ,p_id_amministrazione   => p_id_amministrazione
                             ,p_tipo_indirizzo       => d_tipo_indirizzo
                             ,p_indirizzo            => trim(d_contatto)
                             ,p_contatti             => ''
                             ,p_utente_aggiornamento => p_utente_aggiornamento
                             ,p_data_aggiornamento   => p_data_aggiornamento);
            elsif p_tipo_entita = 'AO' then
               agg_automatico(p_tipo_entita          => p_tipo_entita
                             ,p_id_aoo               => p_id_aoo
                             ,p_tipo_indirizzo       => d_tipo_indirizzo
                             ,p_indirizzo            => trim(d_contatto)
                             ,p_contatti             => ''
                             ,p_utente_aggiornamento => p_utente_aggiornamento
                             ,p_data_aggiornamento   => p_data_aggiornamento);
            elsif p_tipo_entita = 'UO' then
               agg_automatico(p_tipo_entita            => p_tipo_entita
                             ,p_id_unita_organizzativa => p_id_unita_organizzativa
                             ,p_tipo_indirizzo         => d_tipo_indirizzo
                             ,p_indirizzo              => trim(d_contatto)
                             ,p_contatti               => ''
                             ,p_utente_aggiornamento   => p_utente_aggiornamento
                             ,p_data_aggiornamento     => p_data_aggiornamento);
            end if;
         end loop;
      end if;
      --
      s_scarico_ipa := 0; --#54239
      --
   exception
      when uscita then
         null;
   end; -- indirizzo_telematico.agg_automatico
   --------------------------------------------------------------------------------
   procedure del_contatti_ipa --#60713
   (
      p_tipo_entita            in indirizzi_telematici.tipo_entita%type
     ,p_id_amministrazione     in indirizzi_telematici.id_amministrazione%type default null
     ,p_id_aoo                 in indirizzi_telematici.id_aoo%type default null
     ,p_id_unita_organizzativa in indirizzi_telematici.id_unita_organizzativa%type default null
     ,p_scarico_ipa            in number default null
   ) is
      /******************************************************************************
       NOME:        del_contatti_ipa
       DESCRIZIONE: Cancella gli indirizzi telematici dell'entita' indicata
                    Verifica la pulizia dei contatti AS4 del soggetto corrispondente,
                    limitatamente ai recapiti di residenza
                    -
      ******************************************************************************/
      uscita exception;
   begin
      if p_scarico_ipa = 1 then
         s_scarico_ipa := 1;
      end if;
      if p_tipo_entita = 'AM' then
         delete from indirizzi_telematici
          where p_id_amministrazione is not null
            and tipo_entita = p_tipo_entita
            and id_amministrazione = p_id_amministrazione;
      elsif p_tipo_entita = 'AO' then
         delete from indirizzi_telematici
          where p_id_aoo is not null
            and tipo_entita = p_tipo_entita
            and id_aoo = p_id_aoo;
      elsif p_tipo_entita = 'UO' then
         delete from indirizzi_telematici
          where p_id_unita_organizzativa is not null
            and tipo_entita = p_tipo_entita
            and id_unita_organizzativa = p_id_unita_organizzativa;
      end if;
      --
      s_scarico_ipa := 0;
      --
   end;
--------------------------------------------------------------------------------
-- inserimento degli errori nella tabella
begin
   s_error_table(s_indirizzo_presente_number) := s_indirizzo_presente_msg;
   --   s_error_table( s_<exception_name>_number ) := s_<exception_name>_msg;
end indirizzo_telematico;
/

