CREATE OR REPLACE package body imputazione_bilancio is
   /******************************************************************************
    NOME:        IMPUTAZIONE_BILANCIO
    DESCRIZIONE: Gestione tabella imputazioni_bilancio.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore     Descrizione.
    000   16/10/2008  VDAVALLI   Prima emissione.
    001   03/09/2009  VDAVALLI   Modifiche per configurazione master/slave
    002   07/09/2009  VDAVALLI   Corretto controlli per eliminazione
    003   24/05/2012  MMONARI    Rel.1.4 - eliminazione delle scrittura su MOAS
    004   08/01/2013  MMONARI    Redmine Bug#161
    005   09/08/2013  ADADAMO    Redmine Bug#273 per integrazione Bug#161
    006   13/01/2014  MMONARI    Redmine Bug#302
    007   27/03/2014  ADADAMO    Sostituiti riferimenti al so4gp4 con so4gp_pkg Feature#418
          23/04/2014  MMONARI    #429
    008   28/04/2015  MMONARI    #596 Modifiche a set_fi per gestione date DAL-AL
          20/05/2015  MMONARI    #594 Comunicazione bidirezionale tra SO4 e GPs 
                                 delle modifiche alla sola imputazione bilancio
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
   end versione; -- IMPUTAZIONE_BILANCIO.versione
   --------------------------------------------------------------------------------
   function pk(p_id_imputazione in imputazioni_bilancio.id_imputazione%type) return t_pk is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        PK
       DESCRIZIONE: Costruttore di un t_PK dati gli attributi della chiave
      ******************************************************************************/
      d_result t_pk;
   begin
      d_result.id_imputazione := p_id_imputazione;
      dbc.pre(not dbc.preon or canhandle(d_result.id_imputazione)
             ,'canHandle on IMPUTAZIONE_BILANCIO.PK');
      return d_result;
   end pk; -- end IMPUTAZIONE_BILANCIO.PK
   --------------------------------------------------------------------------------
   function can_handle(p_id_imputazione in imputazioni_bilancio.id_imputazione%type)
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
      if d_result = 1 and (p_id_imputazione is null) then
         d_result := 0;
      end if;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on IMPUTAZIONE_BILANCIO.can_handle');
      return d_result;
   end can_handle; -- IMPUTAZIONE_BILANCIO.can_handle
   --------------------------------------------------------------------------------
   function canhandle(p_id_imputazione in imputazioni_bilancio.id_imputazione%type)
      return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        canHandle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: true se la chiave è manipolabile, false altrimenti.
       NOTE:        Wrapper boolean di can_handle (cfr. can_handle).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(can_handle(p_id_imputazione));
   begin
      return d_result;
   end canhandle; -- IMPUTAZIONE_BILANCIO.canHandle
   --------------------------------------------------------------------------------
   function exists_id(p_id_imputazione in imputazioni_bilancio.id_imputazione%type)
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
      dbc.pre(not dbc.preon or canhandle(p_id_imputazione)
             ,'canHandle on IMPUTAZIONE_BILANCIO.exists_id');
      begin
         select 1
           into d_result
           from imputazioni_bilancio
          where id_imputazione = p_id_imputazione;
      exception
         when no_data_found then
            d_result := 0;
      end;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on IMPUTAZIONE_BILANCIO.exists_id');
      return d_result;
   end exists_id; -- IMPUTAZIONE_BILANCIO.exists_id
   --------------------------------------------------------------------------------
   function existsid(p_id_imputazione in imputazioni_bilancio.id_imputazione%type)
      return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        existsId
       DESCRIZIONE: Esistenza riga con chiave indicata.
       NOTE:        Wrapper boolean di exists_id (cfr. exists_id).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(exists_id(p_id_imputazione));
   begin
      return d_result;
   end existsid; -- IMPUTAZIONE_BILANCIO.existsId
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
      d_result afc_error.t_error_msg;
   begin
      if s_error_table.exists(p_error_number) then
         d_result := s_error_table(p_error_number);
      else
         raise_application_error(afc_error.exception_not_in_table_number
                                ,afc_error.exception_not_in_table_msg);
      end if;
      --
      return d_result;
   end; -- anagrafe_unita_organizzativa.error_message
   --------------------------------------------------------------------------------
   procedure ins
   (
      p_id_imputazione in imputazioni_bilancio.id_imputazione%type
     ,p_id_componente  in imputazioni_bilancio.id_componente%type
     ,p_numero         in imputazioni_bilancio.numero%type
     ,p_dal            in imputazioni_bilancio.dal%type
     ,p_al             in imputazioni_bilancio.al%type default null
     ,p_utente_agg     in imputazioni_bilancio.utente_agg%type default null
     ,p_data_agg       in imputazioni_bilancio.data_agg%type default null
   ) is
      /******************************************************************************
       NOME:        ins
       DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
       PARAMETRI:   Chiavi e attributi della table.
      ******************************************************************************/
   begin
      -- Check Mandatory on Insert
      dbc.pre(not dbc.preon or p_id_componente is not null or /*default value*/
              '' is not null
             ,'p_id_componente on IMPUTAZIONE_BILANCIO.ins');
      dbc.pre(not dbc.preon or p_numero is not null or /*default value*/
              '' is not null
             ,'p_numero on IMPUTAZIONE_BILANCIO.ins');
      dbc.pre(not dbc.preon or p_dal is not null or /*default value*/
              '' is not null
             ,'p_dal on IMPUTAZIONE_BILANCIO.ins');
      dbc.pre(not dbc.preon or p_al is not null or /*default value*/
              'default null' is not null
             ,'p_al on IMPUTAZIONE_BILANCIO.ins');
      dbc.pre(not dbc.preon or p_utente_agg is not null or /*default value*/
              'default null' is not null
             ,'p_utente_agg on IMPUTAZIONE_BILANCIO.ins');
      dbc.pre(not dbc.preon or p_data_agg is not null or /*default value*/
              'default null' is not null
             ,'p_data_agg on IMPUTAZIONE_BILANCIO.ins');
      dbc.pre(not dbc.preon or (p_id_imputazione is null and /*default value*/
              '' is not null) -- PK nullable on insert
              or not existsid(p_id_imputazione)
             ,'not existsId on IMPUTAZIONE_BILANCIO.ins');
      integritypackage.initnestlevel; --#594 azzeramento cautelativo del level             
      insert into imputazioni_bilancio
         (id_imputazione
         ,id_componente
         ,numero
         ,dal
         ,al
         ,utente_agg
         ,data_agg)
      values
         (p_id_imputazione
         ,p_id_componente
         ,p_numero
         ,p_dal
         ,p_al
         ,p_utente_agg
         ,p_data_agg);
   end ins; -- IMPUTAZIONE_BILANCIO.ins
   --------------------------------------------------------------------------------
   procedure upd
   (
      p_new_id_imputazione in imputazioni_bilancio.id_imputazione%type
     ,p_new_id_componente  in imputazioni_bilancio.id_componente%type
     ,p_new_numero         in imputazioni_bilancio.numero%type
     ,p_new_dal            in imputazioni_bilancio.dal%type
     ,p_new_al             in imputazioni_bilancio.al%type
     ,p_new_utente_agg     in imputazioni_bilancio.utente_agg%type
     ,p_new_data_agg       in imputazioni_bilancio.data_agg%type
     ,p_old_id_imputazione in imputazioni_bilancio.id_imputazione%type default null
     ,p_old_id_componente  in imputazioni_bilancio.id_componente%type default null
     ,p_old_numero         in imputazioni_bilancio.numero%type default null
     ,p_old_dal            in imputazioni_bilancio.dal%type default null
     ,p_old_al             in imputazioni_bilancio.al%type default null
     ,p_old_utente_agg     in imputazioni_bilancio.utente_agg%type default null
     ,p_old_data_agg       in imputazioni_bilancio.data_agg%type default null
     ,p_check_old          in integer default 0
   ) is
      /******************************************************************************
       NOME:        upd
       DESCRIZIONE: Aggiornamento di una riga con chiave.
       PARAMETRI:   Chiavi e attributi della table
                    p_check_OLD: 0 e null, ricerca senza controllo su attributi precedenti
                                 1       , ricerca con controllo anche su attributi precedenti.
       NOTE:        Nel caso in cui non venga elaborato alcun record viene lanciata
                    l'eccezione -20010 (cfr. AFC_ERROR).
                    Se p_check_old è NULL, gli attributi vengono annullati solo se viene
                    indicato anche il relativo attributo OLD.
                    Se p_check_old = 1, viene controllato se il record corrispondente a
                    tutti i campi passati come parametri esiste nella tabella.
      ******************************************************************************/
      d_key       t_pk;
      d_row_found number;
   begin
      dbc.pre(not dbc.preon or
              not ((p_old_id_componente is not null or p_old_numero is not null or
               p_old_dal is not null or p_old_al is not null or
               p_old_utente_agg is not null or p_old_data_agg is not null) and
               (nvl(p_check_old, -1) = 0))
             ,' <OLD values> is not null on IMPUTAZIONE_BILANCIO.upd');
      d_key := pk(nvl(p_old_id_imputazione, p_new_id_imputazione));
      dbc.pre(not dbc.preon or existsid(d_key.id_imputazione)
             ,'existsId on IMPUTAZIONE_BILANCIO.upd');
      integritypackage.initnestlevel; --#594 azzeramento cautelativo del level             
      update imputazioni_bilancio
         set id_imputazione = decode(p_check_old
                                    ,0
                                    ,p_new_id_imputazione
                                    ,decode(p_new_id_imputazione
                                           ,p_old_id_imputazione
                                           ,id_imputazione
                                           ,p_new_id_imputazione))
            ,id_componente  = decode(p_check_old
                                    ,0
                                    ,p_new_id_componente
                                    ,decode(p_new_id_componente
                                           ,p_old_id_componente
                                           ,id_componente
                                           ,p_new_id_componente))
            ,numero         = decode(p_check_old
                                    ,0
                                    ,p_new_numero
                                    ,decode(p_new_numero
                                           ,p_old_numero
                                           ,numero
                                           ,p_new_numero))
            ,dal            = decode(p_check_old
                                    ,0
                                    ,p_new_dal
                                    ,decode(p_new_dal, p_old_dal, dal, p_new_dal))
            ,al             = decode(p_check_old
                                    ,0
                                    ,p_new_al
                                    ,decode(p_new_al, p_old_al, al, p_new_al))
            ,utente_agg     = decode(p_check_old
                                    ,0
                                    ,p_new_utente_agg
                                    ,decode(p_new_utente_agg
                                           ,p_old_utente_agg
                                           ,utente_agg
                                           ,p_new_utente_agg))
            ,data_agg       = decode(p_check_old
                                    ,0
                                    ,p_new_data_agg
                                    ,decode(p_new_data_agg
                                           ,p_old_data_agg
                                           ,data_agg
                                           ,p_new_data_agg))
       where id_imputazione = d_key.id_imputazione
         and (nvl(p_check_old, 0) = 0 or
             p_check_old = 1 and (id_componente = p_old_id_componente or
             id_componente is null and p_old_id_componente is null) and
             (numero = p_old_numero or numero is null and p_old_numero is null) and
             (dal = p_old_dal or dal is null and p_old_dal is null) and
             (al = p_old_al or al is null and p_old_al is null) and
             (utente_agg = p_old_utente_agg or
             utente_agg is null and p_old_utente_agg is null) and
             (data_agg = p_old_data_agg or data_agg is null and p_old_data_agg is null));
      d_row_found := sql%rowcount;
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on IMPUTAZIONE_BILANCIO.upd');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   end upd; -- IMPUTAZIONE_BILANCIO.upd
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_id_imputazione in imputazioni_bilancio.id_imputazione%type
     ,p_column         in varchar2
     ,p_value          in varchar2 default null
     ,p_literal_value  in number default 1
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
      dbc.pre(not dbc.preon or existsid(p_id_imputazione)
             ,'existsId on IMPUTAZIONE_BILANCIO.upd_column');
      dbc.pre(not dbc.preon or p_column is not null
             ,'p_column is not null on IMPUTAZIONE_BILANCIO.upd_column');
      dbc.pre(not dbc.preon or afc_ddl.hasattribute(s_table_name, p_column)
             ,'AFC_DDL.HasAttribute on IMPUTAZIONE_BILANCIO.upd_column');
      dbc.pre(p_literal_value in (0, 1) or p_literal_value is null
             ,'p_literal_value on IMPUTAZIONE_BILANCIO.upd_column; p_literal_value = ' ||
              p_literal_value);
      if p_literal_value = 1 or p_literal_value is null then
         d_literal := '''';
      end if;
      d_statement := 'begin ' || '   update imputazioni_bilancio' || '   set    ' ||
                     p_column || ' = ' || d_literal || p_value || d_literal ||
                     '   where  id_imputazione = ''' || p_id_imputazione || '''' ||
                     '   ;' || 'end;';
      integritypackage.initnestlevel; --#594 azzeramento cautelativo del level                     
      afc.sql_execute(d_statement);
   end upd_column; -- IMPUTAZIONE_BILANCIO.upd_column
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_id_imputazione in imputazioni_bilancio.id_imputazione%type
     ,p_column         in varchar2
     ,p_value          in date
   ) is
      /******************************************************************************
       NOME:        upd_column
       DESCRIZIONE: Aggiornamento del campo p_column col valore p_value.
       NOTE:        Richiama se stessa con il parametro date convertito in stringa.
      ******************************************************************************/
      d_data varchar2(19);
   begin
      d_data := to_char(p_value, afc.date_format);
      upd_column(p_id_imputazione
                ,p_column
                ,'to_date( ''' || d_data || ''', ''' || afc.date_format || ''' )'
                ,0);
   end upd_column; -- IMPUTAZIONE_BILANCIO.upd_column
   --------------------------------------------------------------------------------
   procedure del
   (
      p_id_imputazione in imputazioni_bilancio.id_imputazione%type
     ,p_id_componente  in imputazioni_bilancio.id_componente%type default null
     ,p_numero         in imputazioni_bilancio.numero%type default null
     ,p_dal            in imputazioni_bilancio.dal%type default null
     ,p_al             in imputazioni_bilancio.al%type default null
     ,p_utente_agg     in imputazioni_bilancio.utente_agg%type default null
     ,p_data_agg       in imputazioni_bilancio.data_agg%type default null
     ,p_check_old      in integer default 0
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
              not ((p_id_componente is not null or p_numero is not null or
               p_dal is not null or p_al is not null or p_utente_agg is not null or
               p_data_agg is not null) and (nvl(p_check_old, 0) = 0))
             ,' <OLD values> is not null on IMPUTAZIONE_BILANCIO.del');
      dbc.pre(not dbc.preon or existsid(p_id_imputazione)
             ,'existsId on IMPUTAZIONE_BILANCIO.del');
      integritypackage.initnestlevel; --#594 azzeramento cautelativo del level             
      delete from imputazioni_bilancio
       where id_imputazione = p_id_imputazione
         and (nvl(p_check_old, 0) = 0 or
             p_check_old = 1 and (id_componente = p_id_componente or
             id_componente is null and p_id_componente is null) and
             (numero = p_numero or numero is null and p_numero is null) and
             (dal = p_dal or dal is null and p_dal is null) and
             (al = p_al or al is null and p_al is null) and
             (utente_agg = p_utente_agg or utente_agg is null and p_utente_agg is null) and
             (data_agg = p_data_agg or data_agg is null and p_data_agg is null));
      d_row_found := sql%rowcount;
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on IMPUTAZIONE_BILANCIO.del');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
      dbc.post(not dbc.poston or not existsid(p_id_imputazione)
              ,'existsId on IMPUTAZIONE_BILANCIO.del');
   end del; -- IMPUTAZIONE_BILANCIO.del
   --------------------------------------------------------------------------------
   function get_id_componente(p_id_imputazione in imputazioni_bilancio.id_imputazione%type)
      return imputazioni_bilancio.id_componente%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_id_componente
       DESCRIZIONE: Attributo id_componente di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     imputazioni_bilancio.id_componente%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result imputazioni_bilancio.id_componente%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_imputazione)
             ,'existsId on IMPUTAZIONE_BILANCIO.get_id_componente');
      select id_componente
        into d_result
        from imputazioni_bilancio
       where id_imputazione = p_id_imputazione;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on IMPUTAZIONE_BILANCIO.get_id_componente');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'id_componente')
                      ,' AFC_DDL.IsNullable on IMPUTAZIONE_BILANCIO.get_id_componente');
      end if;
      return d_result;
   end get_id_componente; -- IMPUTAZIONE_BILANCIO.get_id_componente
   --------------------------------------------------------------------------------
   function get_numero(p_id_imputazione in imputazioni_bilancio.id_imputazione%type)
      return imputazioni_bilancio.numero%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_numero
       DESCRIZIONE: Attributo numero di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     imputazioni_bilancio.numero%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result imputazioni_bilancio.numero%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_imputazione)
             ,'existsId on IMPUTAZIONE_BILANCIO.get_numero');
      select numero
        into d_result
        from imputazioni_bilancio
       where id_imputazione = p_id_imputazione;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on IMPUTAZIONE_BILANCIO.get_numero');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'numero')
                      ,' AFC_DDL.IsNullable on IMPUTAZIONE_BILANCIO.get_numero');
      end if;
      return d_result;
   end get_numero; -- IMPUTAZIONE_BILANCIO.get_numero
   --------------------------------------------------------------------------------
   function get_dal(p_id_imputazione in imputazioni_bilancio.id_imputazione%type)
      return imputazioni_bilancio.dal%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_dal
       DESCRIZIONE: Attributo dal di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     imputazioni_bilancio.dal%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result imputazioni_bilancio.dal%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_imputazione)
             ,'existsId on IMPUTAZIONE_BILANCIO.get_dal');
      select dal
        into d_result
        from imputazioni_bilancio
       where id_imputazione = p_id_imputazione;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on IMPUTAZIONE_BILANCIO.get_dal');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'dal')
                      ,' AFC_DDL.IsNullable on IMPUTAZIONE_BILANCIO.get_dal');
      end if;
      return d_result;
   end get_dal; -- IMPUTAZIONE_BILANCIO.get_dal
   --------------------------------------------------------------------------------
   function get_al(p_id_imputazione in imputazioni_bilancio.id_imputazione%type)
      return imputazioni_bilancio.al%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_al
       DESCRIZIONE: Attributo al di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     imputazioni_bilancio.al%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result imputazioni_bilancio.al%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_imputazione)
             ,'existsId on IMPUTAZIONE_BILANCIO.get_al');
      select al
        into d_result
        from imputazioni_bilancio
       where id_imputazione = p_id_imputazione;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on IMPUTAZIONE_BILANCIO.get_al');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'al')
                      ,' AFC_DDL.IsNullable on IMPUTAZIONE_BILANCIO.get_al');
      end if;
      return d_result;
   end get_al; -- IMPUTAZIONE_BILANCIO.get_al
   --------------------------------------------------------------------------------
   function get_utente_agg(p_id_imputazione in imputazioni_bilancio.id_imputazione%type)
      return imputazioni_bilancio.utente_agg%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_utente_agg
       DESCRIZIONE: Attributo utente_agg di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     imputazioni_bilancio.utente_agg%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result imputazioni_bilancio.utente_agg%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_imputazione)
             ,'existsId on IMPUTAZIONE_BILANCIO.get_utente_agg');
      select utente_agg
        into d_result
        from imputazioni_bilancio
       where id_imputazione = p_id_imputazione;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on IMPUTAZIONE_BILANCIO.get_utente_agg');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'utente_agg')
                      ,' AFC_DDL.IsNullable on IMPUTAZIONE_BILANCIO.get_utente_agg');
      end if;
      return d_result;
   end get_utente_agg; -- IMPUTAZIONE_BILANCIO.get_utente_agg
   --------------------------------------------------------------------------------
   function get_data_agg(p_id_imputazione in imputazioni_bilancio.id_imputazione%type)
      return imputazioni_bilancio.data_agg%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_data_agg
       DESCRIZIONE: Attributo data_agg di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     imputazioni_bilancio.data_agg%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result imputazioni_bilancio.data_agg%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_imputazione)
             ,'existsId on IMPUTAZIONE_BILANCIO.get_data_agg');
      select data_agg
        into d_result
        from imputazioni_bilancio
       where id_imputazione = p_id_imputazione;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on IMPUTAZIONE_BILANCIO.get_data_agg');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'data_agg')
                      ,' AFC_DDL.IsNullable on IMPUTAZIONE_BILANCIO.get_data_agg');
      end if;
      return d_result;
   end get_data_agg; -- IMPUTAZIONE_BILANCIO.get_data_agg
   --------------------------------------------------------------------------------
   function where_condition
   (
      p_id_imputazione  in varchar2 default null
     ,p_id_componente   in varchar2 default null
     ,p_numero          in varchar2 default null
     ,p_dal             in varchar2 default null
     ,p_al              in varchar2 default null
     ,p_utente_agg      in varchar2 default null
     ,p_data_agg        in varchar2 default null
     ,p_other_condition in varchar2 default null
     ,p_qbe             in number default 0
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
                     afc.get_field_condition(' and ( id_imputazione '
                                            ,p_id_imputazione
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( id_componente '
                                            ,p_id_componente
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( numero '
                                            ,p_numero
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( dal '
                                            ,p_dal
                                            ,' )'
                                            ,p_qbe
                                            ,afc.date_format) ||
                     afc.get_field_condition(' and ( al '
                                            ,p_al
                                            ,' )'
                                            ,p_qbe
                                            ,afc.date_format) ||
                     afc.get_field_condition(' and ( utente_agg '
                                            ,p_utente_agg
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( data_agg '
                                            ,p_data_agg
                                            ,' )'
                                            ,p_qbe
                                            ,afc.date_format) || ' ) ' ||
                     p_other_condition;
      return d_statement;
   end where_condition; --- IMPUTAZIONE_BILANCIO.where_condition
   --------------------------------------------------------------------------------
   function get_rows
   (
      p_id_imputazione  in varchar2 default null
     ,p_id_componente   in varchar2 default null
     ,p_numero          in varchar2 default null
     ,p_dal             in varchar2 default null
     ,p_al              in varchar2 default null
     ,p_utente_agg      in varchar2 default null
     ,p_data_agg        in varchar2 default null
     ,p_other_condition in varchar2 default null
     ,p_qbe             in number default 0
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
      d_statement  := ' select * from imputazioni_bilancio ' ||
                      where_condition(p_id_imputazione
                                     ,p_id_componente
                                     ,p_numero
                                     ,p_dal
                                     ,p_al
                                     ,p_utente_agg
                                     ,p_data_agg
                                     ,p_other_condition
                                     ,p_qbe);
      d_ref_cursor := afc_dml.get_ref_cursor(d_statement);
      return d_ref_cursor;
   end get_rows; -- IMPUTAZIONE_BILANCIO.get_rows
   --------------------------------------------------------------------------------
   function count_rows
   (
      p_id_imputazione  in varchar2 default null
     ,p_id_componente   in varchar2 default null
     ,p_numero          in varchar2 default null
     ,p_dal             in varchar2 default null
     ,p_al              in varchar2 default null
     ,p_utente_agg      in varchar2 default null
     ,p_data_agg        in varchar2 default null
     ,p_other_condition in varchar2 default null
     ,p_qbe             in number default 0
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
      d_statement := ' select count( * ) from imputazioni_bilancio ' ||
                     where_condition(p_id_imputazione
                                    ,p_id_componente
                                    ,p_numero
                                    ,p_dal
                                    ,p_al
                                    ,p_utente_agg
                                    ,p_data_agg
                                    ,p_other_condition
                                    ,p_qbe);
      d_result    := afc.sql_execute(d_statement);
      return d_result;
   end count_rows; -- IMPUTAZIONE_BILANCIO.count_rows
   --------------------------------------------------------------------------------
   function get_id_imputazione return imputazioni_bilancio.id_imputazione%type is
      /******************************************************************************
       NOME:        get_id_imputazione
       DESCRIZIONE: Restituisce un nuovo valore della sequence per l'inserimento
                    di un nuovo record
       PARAMETRI:   --
       RITORNA:     imputazioni_bilancio.id_imputazione%type
      ******************************************************************************/
      d_result imputazioni_bilancio.id_imputazione%type;
   begin
      select imbi_sq.nextval into d_result from dual;
      --
      return d_result;
      --
   end; -- IMPUTAZIONE_BILANCIO.get_id_imputazione
   --------------------------------------------------------------------------------
   function get_ultimo_periodo
   (
      p_id_componente in imputazioni_bilancio.id_componente%type
     ,p_rowid         in rowid
   ) return afc_periodo.t_periodo is
      /******************************************************************************
       NOME:        get_ultimo_periodo
       DESCRIZIONE: Restituisce l'ultimo periodo per il componente indicato
       PARAMETRI:   Id componente
       RITORNA:     Afc_periodo.t_periodo
      ******************************************************************************/
      d_result afc_periodo.t_periodo;
   begin
      select max(dal)
        into d_result.dal
        from imputazioni_bilancio
       where id_componente = p_id_componente
         and rowid != p_rowid;
      --
      if d_result.dal is not null then
         select al
           into d_result.al
           from imputazioni_bilancio
          where id_componente = p_id_componente
            and dal = d_result.dal;
      else
         d_result.al := to_date(null);
      end if;
      --
      return d_result;
      --
   end; -- IMPUTAZIONI_BILANCIO.get_ultimo_periodo
   --------------------------------------------------------------------------------
   function get_periodo_precedente
   (
      p_id_componente imputazioni_bilancio.id_componente%type
     ,p_dal           imputazioni_bilancio.dal%type
     ,p_rowid         in rowid
   ) return afc_periodo.t_periodo is
      /******************************************************************************
       NOME:        get_periodo_precedente
       DESCRIZIONE: Restituisce il periodo precedente al periodo dato per il componente
       PARAMETRI:   Id componente
                    Dal
       RITORNA:     Afc_periodo.t_periodo
      ******************************************************************************/
      d_result afc_periodo.t_periodo;
   begin
      select max(dal)
        into d_result.dal
        from imputazioni_bilancio
       where id_componente = p_id_componente
         and dal < p_dal
         and rowid != p_rowid;
      --
      if d_result.dal is not null then
         select al
           into d_result.al
           from imputazioni_bilancio
          where id_componente = p_id_componente
            and dal = d_result.dal;
      else
         d_result.al := to_date(null);
      end if;
      --
      return d_result;
   end; -- IMPUTAZIONI_BILANCIO.get_periodo_precedente
   --------------------------------------------------------------------------------
   function get_periodo_successivo
   (
      p_id_componente imputazioni_bilancio.id_componente%type
     ,p_dal           imputazioni_bilancio.dal%type
     ,p_rowid         in rowid
   ) return afc_periodo.t_periodo is
      /******************************************************************************
       NOME:        get_periodo_successivo
       DESCRIZIONE: Restituisce il periodo successivo al periodo dato per il componente
       PARAMETRI:   Id componente
                    Dal
       RITORNA:     Afc_periodo.t_periodo
      ******************************************************************************/
      d_result afc_periodo.t_periodo;
   begin
      select min(dal)
        into d_result.dal
        from imputazioni_bilancio
       where id_componente = p_id_componente
         and dal > p_dal
         and rowid != p_rowid;
      --
      if d_result.dal is not null then
         select al
           into d_result.al
           from imputazioni_bilancio
          where id_componente = p_id_componente
            and dal = d_result.dal;
      else
         d_result.al := to_date(null);
      end if;
      --
      return d_result;
      --
   end; -- IMPUTAZIONI_BILANCIO.get_get_periodo_successivo
   --------------------------------------------------------------------------------
   function get_id_imputazione_corrente
   (
      p_id_componente in imputazioni_bilancio.id_componente%type
     ,p_data          in imputazioni_bilancio.dal%type
   ) return imputazioni_bilancio.id_imputazione%type is
      /******************************************************************************
       NOME:        get_id_imputazione_corrente
       DESCRIZIONE: Restituisce l'id_imputazione del componente alla data indicata
       PARAMETRI:   Id componente
                    Dal
       RITORNA:     Id_imputazione%type
      ******************************************************************************/
      d_result imputazioni_bilancio.id_imputazione%type;
   begin
      begin
         select id_imputazione
           into d_result
           from imputazioni_bilancio
          where id_componente = p_id_componente
            and p_data between dal and nvl(al, to_date('3333333', 'j'));
      exception
         when no_data_found then
            d_result := null;
      end;
      --
      return d_result;
      --
   end; -- IMPUTAZIONI_BILANCIO.get_id_imputazione_corrente
   --------------------------------------------------------------------------------
   function get_imputazione_corrente
   (
      p_id_componente in imputazioni_bilancio.id_componente%type
     ,p_data          in imputazioni_bilancio.dal%type
   ) return imputazioni_bilancio.numero%type is
      /******************************************************************************
       NOME:        get_imputazione_corrente
       DESCRIZIONE: Restituisce l'imputazione del componente alla data indicata
       PARAMETRI:   Id componente
                    Dal
       RITORNA:     Numero%type
      ******************************************************************************/
      d_result imputazioni_bilancio.numero%type;
   begin
      begin
         select numero
           into d_result
           from imputazioni_bilancio
          where id_componente = p_id_componente
            and p_data between dal and nvl(al, to_date('3333333', 'j'));
      exception
         when no_data_found then
            d_result := null;
      end;
      --
      return d_result;
      --
   end; -- IMPUTAZIONI_BILANCIO.get_imputazione_corrente
   --------------------------------------------------------------------------------
   function verifica_periodi(p_id_componente imputazioni_bilancio.id_componente%type)
      return afc_error.t_error_number is
      /******************************************************************************
       NOME:        verifica_periodi
       DESCRIZIONE: Verifica che i periodi inseriti per il componente siano
                    congruenti
       PARAMETRI:   Id componente
       RITORNA:     Afc_error.ok se i periodi sono congruenti, altrimenti 0
      ******************************************************************************/
      d_result    afc_error.t_error_number;
      d_contatore number(8);
      d_al_prec   imputazioni_bilancio.al%type;
   begin
      d_contatore := 0;
      --
      for imbi in (select dal
                         ,al
                     from imputazioni_bilancio
                    where id_componente = p_id_componente
                    order by 1
                            ,2)
      loop
         d_contatore := d_contatore + 1;
         if d_contatore = 1 then
            d_al_prec := imbi.al;
         else
            if imbi.dal != d_al_prec + 1 then
               d_result := 0;
            end if;
         end if;
      end loop;
      --
      return d_result;
      --
   end; -- IMPUTAZIONE_BILANCIO.verifica_periodi
   --------------------------------------------------------------------------------
   function is_dal_al_ok
   (
      p_dal in imputazioni_bilancio.dal%type
     ,p_al  in imputazioni_bilancio.al%type
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
         d_result := s_dal_al_errato_number;
      else
         d_result := afc_error.ok;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on area_org_om.is_dal_al_ok');
      return d_result;
   end; -- IMPUTAZIONE_BILANCIO.is_dal_al_ok
   --------------------------------------------------------------------------------
   function is_di_ok
   (
      p_dal in imputazioni_bilancio.dal%type
     ,p_al  in imputazioni_bilancio.al%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_DI_ok
       DESCRIZIONE: Function di gestione data integrity
       PARAMETRI:   is_dal_al_ok
       NOTE:        afc_error.t_error_number
      ******************************************************************************/
      d_result afc_error.t_error_number := afc_error.ok;
   begin
      -- is_dal_al_ok
      d_result := is_dal_al_ok(p_dal, p_al);
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on Imputazione_bilancio.is_DI_ok');
      return d_result;
   end; -- IMPUTAZIONE_BILANCIO.is_DI_ok
   --------------------------------------------------------------------------------
   procedure chk_di
   (
      p_dal in imputazioni_bilancio.dal%type
     ,p_al  in imputazioni_bilancio.al%type
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
                   ,'d_result = AFC_Error.ok or d_result < 0 on componente.chk_DI');
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, s_error_table(d_result));
      end if;
   end; -- IMPUTAZIONE_BILANCIO.chk_DI
   --------------------------------------------------------------------------------
   function is_dal_ok
   (
      p_id_componente in imputazioni_bilancio.id_componente%type
     ,p_old_dal       in imputazioni_bilancio.dal%type
     ,p_new_dal       in imputazioni_bilancio.dal%type
     ,p_old_al        in imputazioni_bilancio.al%type
     ,p_rowid         in rowid
     ,p_inserting     in number
     ,p_updating      in number
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_dal_ok
       DESCRIZIONE: controllo validita' dal: si puo' modificare solo quello
                    dell'ultimo record relativo all'id_componente
       RITORNA:     afc_error.t_error_number
      ******************************************************************************/
      d_periodo        afc_periodo.t_periodo;
      d_dal_componente componenti.dal%type;
      d_result         afc_error.t_error_number := afc_error.ok;
   begin
      --
      -- Il dal deve essere sempre >= del dal dell'assegnazione
      --
      d_dal_componente := componente.get_dal(p_id_componente);
      if p_new_dal < d_dal_componente then
         d_result := s_dal_fuori_periodo_num;
      end if;
      --
      -- In caso di inserimento, il dal deve essere > dell'ultimo dal inserito
      --
      if d_result = afc_error.ok then
         if p_inserting = 1 then
            d_periodo := afc_periodo.get_ultimo(p_tabella            => 'IMPUTAZIONI_BILANCIO'
                                               ,p_nome_dal           => 'DAL'
                                               ,p_nome_al            => 'AL'
                                               ,p_al                 => p_old_al
                                               ,p_campi_controllare  => '#ID_COMPONENTE#DAL#'
                                               ,p_valori_controllare => '#' ||
                                                                        p_id_componente ||
                                                                        '#!=' || p_new_dal || '#'
                                               ,p_rowid              => p_rowid);
            if d_periodo.dal is null and d_periodo.al is null then
               d_result := afc_error.ok;
            else
               if p_new_dal <= d_periodo.dal then
                  d_result := s_dal_errato_ins_num;
               else
                  d_result := afc_error.ok;
               end if;
            end if;
         end if;
      end if;
      --
      -- In caso di aggiornamento, il dal deve essere compreso nel periodo
      -- immediatamente precedente; si può aggiornare solo l'ultimo periodo
      -- rimosso in #596
      --
      return d_result;
      --
   end; -- IMPUTAZIONE_BILANCIO.is_dal_ok
   --------------------------------------------------------------------------------
   function is_al_ok
   (
      p_id_componente in imputazioni_bilancio.id_componente%type
     ,p_old_dal       in imputazioni_bilancio.dal%type
     ,p_old_al        in imputazioni_bilancio.dal%type
     ,p_new_al        in imputazioni_bilancio.dal%type
     ,p_rowid         in rowid
     ,p_inserting     in number
     ,p_updating      in number
     ,p_nest_level    in integer
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_al_ok
       DESCRIZIONE: controllo validita' al: si puo' modificare solo quello
                    dell'ultimo record relativo all'id_componente
       RITORNA:     afc_error.t_error_number
      ******************************************************************************/
      d_periodo       afc_periodo.t_periodo;
      d_al_componente componenti.dal%type;
      d_result        afc_error.t_error_number := afc_error.ok;
   begin
      --
      -- L'al deve essere sempre <= dell'al dell'assegnazione
      --
      d_al_componente := componente.get_al(p_id_componente);
      if nvl(nvl(p_new_al, d_al_componente), to_date('31/12/2200', 'dd/mm/yyyy')) >
         nvl(d_al_componente, to_date('31/12/2200', 'dd/mm/yyyy')) then
         d_result := s_al_fuori_periodo_num;
      end if;
      --
      -- In caso di inserimento, l'al deve essere > dell'ultimo al inserito
      --
      if d_result = afc_error.ok then
         if p_inserting = 1 then
            if p_new_al is null then
               d_result := afc_error.ok;
               /*        else
               d_periodo := AFC_Periodo.get_ultimo ( p_tabella => 'IMPUTAZIONI_BILANCIO'
                                                   , p_nome_dal => 'DAL'
                                                   , p_nome_al => 'AL'
                                                   , p_al => p_old_al
                                                   , p_campi_controllare => '#ID_COMPONENTE#'
                                                   , p_valori_controllare => '#'||p_id_componente||'#'
                                                   , p_rowid => p_rowid
                                                   );
               if d_periodo.dal is null and d_periodo.al is null then
                  d_result := afc_error.ok;
               else
                  if p_new_al <= d_periodo.al then
                     d_result := s_al_errato_ins_num;
                  else
                     d_result := AFC_Error.ok;
                  end if;
               end if;*/
            end if;
         end if;
      end if;
      --
      -- In caso di aggiornamento, l'al deve essere compreso nel periodo
      -- immediatamente successivo
      --
      if d_result = afc_error.ok then
         if p_updating = 1 and p_nest_level = 0 then
            if p_new_al > p_old_al then
               d_periodo := imputazione_bilancio.get_periodo_successivo(p_id_componente
                                                                       ,p_old_dal
                                                                       ,p_rowid);
               if d_periodo.dal is null and d_periodo.al is null then
                  d_result := afc_error.ok;
               else
                  if p_new_al between d_periodo.dal and d_periodo.al then
                     d_result := afc_error.ok;
                  else
                     d_result := s_al_errato_num;
                  end if;
               end if;
            else
               d_result := afc_error.ok;
            end if;
         end if;
      end if;
      --
      return d_result;
      --
   end; -- IMPUTAZIONE_BILANCIO.is_al_ok
   --------------------------------------------------------------------------------
   function is_record_eliminabile
   (
      p_id_componente in imputazioni_bilancio.id_componente%type
     ,p_old_dal       in imputazioni_bilancio.dal%type
     ,p_old_al        in imputazioni_bilancio.al%type
     ,p_deleting      in number
     ,p_nest_level    in integer
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_record_eliminabile
       DESCRIZIONE: si puo' eliminare solo l'ultimo record relativo a un componente
       RITORNA:     afc_error.t_error_number
      ******************************************************************************/
      d_result afc_error.t_error_number := afc_error.ok;
   begin
      if p_deleting = 1 and p_nest_level = 0 then
         if p_old_dal is not null and p_old_al is not null then
            d_result := s_record_storico_num;
         else
            d_result := afc_error.ok;
         end if;
      end if;
      --
      return d_result;
      --
   end; --IMPUTAZIONE_BILANCIO.is_record_eliminabile
   --------------------------------------------------------------------------------
   function is_ri_ok
   (
      p_id_componente in imputazioni_bilancio.id_componente%type
     ,p_old_dal       in imputazioni_bilancio.dal%type
     ,p_new_dal       in imputazioni_bilancio.dal%type
     ,p_old_al        in imputazioni_bilancio.dal%type
     ,p_new_al        in imputazioni_bilancio.dal%type
     ,p_rowid         in rowid
     ,p_inserting     in number
     ,p_updating      in number
     ,p_deleting      in number
     ,p_nest_level    in integer
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_RI_ok
       DESCRIZIONE: function di controllo integrita' referenziale
       RITORNA:     afc_error.t_error_number
      ******************************************************************************/
      d_result afc_error.t_error_number := afc_error.ok;
   begin
      if p_inserting = 1 or p_updating = 1 then
         -- is_dal_ok
         d_result := is_dal_ok(p_id_componente
                              ,p_old_dal
                              ,p_new_dal
                              ,p_old_al
                              ,p_rowid
                              ,p_inserting
                              ,p_updating);
         -- is_al_ok
         if d_result = afc_error.ok then
            d_result := is_al_ok(p_id_componente
                                ,p_old_dal
                                ,p_old_al
                                ,p_new_al
                                ,p_rowid
                                ,p_inserting
                                ,p_updating
                                ,p_nest_level);
         end if;
      end if;
      -- is_record_eliminabile
      if d_result = afc_error.ok and p_deleting = 1 then
         d_result := is_record_eliminabile(p_id_componente
                                          ,p_old_dal
                                          ,p_old_al
                                          ,p_deleting
                                          ,p_nest_level);
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on IMPUTAZIONE_BILANCIO.is_RI_ok');
      return d_result;
   end; -- IMPUTAZIONE_BILANCIO.is_RI_ok
   --------------------------------------------------------------------------------
   procedure chk_ri
   (
      p_id_componente in imputazioni_bilancio.id_componente%type
     ,p_old_dal       in imputazioni_bilancio.dal%type
     ,p_new_dal       in imputazioni_bilancio.dal%type
     ,p_old_al        in imputazioni_bilancio.dal%type
     ,p_new_al        in imputazioni_bilancio.dal%type
     ,p_rowid         in rowid
     ,p_inserting     in number
     ,p_updating      in number
     ,p_deleting      in number
     ,p_nest_level    in integer
   ) is
      /******************************************************************************
       NOME:        chk_RI
       DESCRIZIONE: function di controllo integrita' referenziale
       RITORNA:     afc_error.t_error_number
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
      d_result := is_ri_ok(p_id_componente
                          ,p_old_dal
                          ,p_new_dal
                          ,p_old_al
                          ,p_new_al
                          ,p_rowid
                          ,p_inserting
                          ,p_updating
                          ,p_deleting
                          ,p_nest_level);
      dbc.assertion(not dbc.assertionon or d_result = afc_error.ok or d_result < 0
                   ,'d_result = AFC_Error.ok or d_result < 0 on Imputazioni_bilancio.chk_RI');
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, error_message(d_result));
      end if;
   end; -- Imputazione_bilancio.chk_RI
   --------------------------------------------------------------------------------
   procedure set_periodo_precedente
   (
      p_id_componente        in imputazioni_bilancio.id_componente%type
     ,p_dal                  in imputazioni_bilancio.dal%type
     ,p_al                   in imputazioni_bilancio.al%type
     ,p_utente_aggiornamento in imputazioni_bilancio.utente_agg%type
   ) is
      /******************************************************************************
       NOME:        set_periodo_precedente
       DESCRIZIONE: Aggiorna la data di fine validita' del periodo precedente
       PARAMETRI:   p_id_componente
                    p_dal
                    p_al
                    p_utente_aggiornamento
       NOTE:        afc_error.t_error_number
      ******************************************************************************/
   begin
      update imputazioni_bilancio i1
         set i1.al         = nvl(p_al, i1.al)
            ,i1.data_agg   = sysdate
            ,i1.utente_agg = p_utente_aggiornamento
       where i1.id_componente = p_id_componente
         and i1.dal =
             (select max(i2.dal)
                from imputazioni_bilancio i2
               where i2.id_componente = p_id_componente
                 and i2.dal < nvl(p_dal, to_date('31122200', 'ddmmyyyy')));
   end; -- imputazione_bilancio.set_periodo_precedente
   --------------------------------------------------------------------------------
   procedure set_periodo_successivo
   (
      p_id_componente        in imputazioni_bilancio.id_componente%type
     ,p_dal                  in imputazioni_bilancio.dal%type
     ,p_al                   in imputazioni_bilancio.al%type
     ,p_utente_aggiornamento in imputazioni_bilancio.utente_agg%type
   ) is
      /******************************************************************************
       NOME:        set_periodo_successivo
       DESCRIZIONE: Aggiorna la data di inizio validita' del periodo successivo
       PARAMETRI:   p_id_componente
                    p_dal
                    p_al
                    p_utente_aggiornamento
       NOTE:        afc_error.t_error_number
      ******************************************************************************/
   begin
      --#596           
      update imputazioni_bilancio i1
         set i1.dal        = p_al + 1
            ,i1.data_agg   = sysdate
            ,i1.utente_agg = p_utente_aggiornamento
       where i1.id_componente = p_id_componente
         and p_al is not null
         and i1.dal =
             (select min(i2.dal)
                from imputazioni_bilancio i2
               where i2.id_componente = p_id_componente
                 and i2.dal > nvl(p_dal, to_date('31122200', 'ddmmyyyy')));
   end; -- imputazione_bilancio.set_periodo_precedente
   --------------------------------------------------------------------------------
   procedure set_riapertura_periodo
   (
      p_id_componente        in imputazioni_bilancio.id_componente%type
     ,p_dal                  in imputazioni_bilancio.dal%type
     ,p_utente_aggiornamento in imputazioni_bilancio.utente_agg%type
   ) is
      /******************************************************************************
       NOME:        set_riapertura_periodo
       DESCRIZIONE: Annulla la data di fine validita' del periodo precedente
       PARAMETRI:   p_id_componente
                    p_dal
                    p_utente_aggiornamento
       NOTE:        afc_error.t_error_number
      ******************************************************************************/
   begin
      update imputazioni_bilancio i1
         set i1.al         = null
            ,i1.data_agg   = sysdate
            ,i1.utente_agg = p_utente_aggiornamento
       where i1.id_componente = p_id_componente
         and i1.dal =
             (select max(i2.dal)
                from imputazioni_bilancio i2
               where i2.id_componente = p_id_componente
                 and i2.dal < nvl(p_dal, to_date('31122200', 'ddmmyyyy')));
   end; -- imputazioni_bilancio.set_riapertura_periodo
   --------------------------------------------------------------------------------
   procedure set_fi
   (
      p_id_componente        in imputazioni_bilancio.id_componente%type
     ,p_old_dal              in imputazioni_bilancio.dal%type
     ,p_dal                  in imputazioni_bilancio.dal%type
     ,p_old_al               in imputazioni_bilancio.al%type
     ,p_al                   in imputazioni_bilancio.al%type
     ,p_numero               in imputazioni_bilancio.numero%type
     ,p_utente_aggiornamento in imputazioni_bilancio.utente_agg%type
     ,p_inserting            in number
     ,p_updating             in number
     ,p_deleting             in number
   ) is
      /******************************************************************************
       NOME:        set_FI.
       DESCRIZIONE: Impostazione integrita' funzionale
       RITORNA:     -
      ******************************************************************************/
      d_ottica          ottiche.ottica%type;
      d_ni              componenti.ni%type;
      d_ci              componenti.ci%type;
      d_revisione       componenti.revisione_assegnazione%type;
      d_amministrazione ottiche.amministrazione%type;
      d_data_modifica   date := trunc(sysdate);
      d_dal_componente  componenti.dal%type := componente.get_dal(p_id_componente);
      d_al_componente   componenti.al%type := componente.get_al(p_id_componente);
      d_assegnazione    attributi_componente.assegnazione_prevalente%type;
      d_dummy           varchar2(1);
   begin
      if p_inserting = 1 then
         -- impostazione periodo precedente al record inserito
         set_periodo_precedente(p_id_componente
                               ,p_dal
                               ,p_dal - 1
                               ,p_utente_aggiornamento);
      elsif p_updating = 1 then
         -- impostazione periodo precedente
         set_periodo_precedente(p_id_componente
                               ,p_dal
                               ,p_dal - 1
                               ,p_utente_aggiornamento);
         -- impostazione periodo successivo
         set_periodo_successivo(p_id_componente, p_dal, p_al, p_utente_aggiornamento);
      elsif p_deleting = 1 then
         set_riapertura_periodo(p_id_componente, p_old_dal, p_utente_aggiornamento);
      end if;
      -- se il record è il primo per quell'id_componente, le decorrenze devono coincidere #596
      update imputazioni_bilancio i
         set dal = d_dal_componente
       where dal = (select min(dal)
                      from imputazioni_bilancio
                     where id_componente = p_id_componente)
         and dal <> d_dal_componente
         and id_componente = p_id_componente;
      -- se il record è l'ultimo per quell'id_componente, le date di termine devono coincidere #596
      update imputazioni_bilancio i
         set al = d_al_componente
       where dal = (select max(dal)
                      from imputazioni_bilancio
                     where id_componente = p_id_componente)
         and id_componente = p_id_componente;
      -- bug#302
      if p_id_componente is not null and so4gp_pkg.is_int_gp4 and p_deleting <> 1 then --#594
         -- crea MOAS se non gia' presente
         begin
            d_ottica          := componente.get_ottica(p_id_componente => p_id_componente);
            d_amministrazione := ottica.get_amministrazione(d_ottica);
            if so4gp_pkg.is_struttura_integrata(d_amministrazione, '') = 'SI' then
               --#429
               d_ci            := componente.get_ci(p_id_componente => p_id_componente);
               d_data_modifica := so4gp_pkg.get_data_modifica_moas(d_ci);
               if d_data_modifica is null then
                  d_revisione := nvl(componente.get_revisione_assegnazione(p_id_componente => p_id_componente)
                                    ,-2);
                  if d_revisione <> revisione_struttura.get_revisione_mod(d_ottica) and
                     ottica.get_ottica_istituzionale(d_ottica) = 'SI' then
                     d_ni := componente.get_ni(p_id_componente => p_id_componente);
                     begin
                        so4gp_pkg.ins_modifiche_assegnazioni(p_ottica            => d_ottica
                                                            ,p_ni                => d_ni
                                                            ,p_ci                => d_ci
                                                            ,p_provenienza       => 'SO4'
                                                            ,p_data_modifica     => p_dal
                                                            ,p_revisione_so4     => ''
                                                            ,p_utente            => 'SO4'
                                                            ,p_data_acquisizione => to_date(null)
                                                            ,p_data_cessazione   => to_date(null)
                                                            ,p_data_eliminazione => to_date(null)
                                                            ,p_funzionale        => null);
                     exception
                        when others then
                           raise_application_error(-20999
                                                  ,'Errore in aggiornamento P00SO4_MODIFICHE_ASSEGNAZIONI - ' ||
                                                   sqlerrm);
                     end;
                  end if;
               end if;
               if d_data_modifica > p_dal then
                  so4gp_pkg.set_data_modifica_moas(d_ci, p_dal);
               end if;
            end if;
         end;
      elsif p_id_componente is not null and so4gp_pkg.is_int_gps and
            imputazione_bilancio.s_origine_gps = 0 and p_deleting <> 1 then --#594
         -- Attiva l'allineamento della modifica su GPs
         begin
            d_ottica          := componente.get_ottica(p_id_componente => p_id_componente);
            d_amministrazione := ottica.get_amministrazione(d_ottica);
            if so4gp_pkg.is_struttura_integrata(d_amministrazione, '') = 'SI' then
               d_ci        := componente.get_ci(p_id_componente => p_id_componente);
               d_revisione := nvl(componente.get_revisione_assegnazione(p_id_componente => p_id_componente)
                                 ,-2);
               if d_revisione <> revisione_struttura.get_revisione_mod(d_ottica) and
                  ottica.get_ottica_istituzionale(d_ottica) = 'SI' then
                  d_assegnazione := attributo_componente.get_assegnazione_corrente(p_id_componente
                                                                                  ,p_dal
                                                                                  ,d_ottica);
                  so4gp_pkg.aggiorna_imputazione_gps(d_ci
                                                    ,p_dal
                                                    ,p_al
                                                    ,p_old_dal
                                                    ,p_old_al
                                                    ,p_numero
                                                    ,d_assegnazione
                                                    ,p_utente_aggiornamento);
               end if;
            end if;
         end;
      end if;
      --
   end; -- IMPUTAZIONE_BILANCIO.set_fi
   --------------------------------------------------------------------------------
   procedure elimina_imputazioni
   (
      p_id_componente          in imputazioni_bilancio.id_componente%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        elimina_imputazioni.
       DESCRIZIONE: elimina i record di IMPUTAZIONI_BILANCIO relativi ad un
                    id_componente
       PARAMETRI:   p_id_compoennte
                    p_segnalazione_bloccante
                    p_segnalazione
       NOTE:        --
      ******************************************************************************/
      d_errore exception;
   begin
      begin
         delete imputazioni_bilancio where id_componente = p_id_componente;
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
         p_segnalazione           := p_segnalazione || ' (' || p_id_componente || ')';
   end; -- imputazione_bilancio.elimina_imputazioni
   --------------------------------------------------------------------------------
   procedure annulla_imputazioni
   (
      p_id_componente          in imputazioni_bilancio.id_componente%type
     ,p_al                     in imputazioni_bilancio.al%type
     ,p_data_aggiornamento     in imputazioni_bilancio.data_agg%type
     ,p_utente_aggiornamento   in imputazioni_bilancio.utente_agg%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        annulla_imputazioni.
       DESCRIZIONE: aggiorna la data di fine validità dell'ultimo record
                    di IMPUTAZIONI_BILANCIO relativo ad un id_componente
       PARAMETRI:   p_id_compoennte
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
         update imputazioni_bilancio i
            set i.al         = p_al
               ,i.data_agg   = p_data_aggiornamento
               ,i.utente_agg = p_utente_aggiornamento
          where i.id_componente = p_id_componente
            and i.dal = (select max(i2.dal)
                           from imputazioni_bilancio i2
                          where i2.id_componente = i.id_componente);
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
         p_segnalazione           := p_segnalazione || ' (' || p_id_componente || ')';
   end; -- imputazione_bilancio.annulla_imputazioni
   --------------------------------------------------------------------------------
   procedure aggiorna_imputazioni
   (
      p_id_componente          in imputazioni_bilancio.id_componente%type
     ,p_dal                    in imputazioni_bilancio.dal%type
     ,p_data_aggiornamento     in imputazioni_bilancio.data_agg%type
     ,p_utente_aggiornamento   in imputazioni_bilancio.utente_agg%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        aggiorna_imputazioni.
       DESCRIZIONE: aggiorna la data di inizio validità del primo record
                    di IMPUTAZIONI_BILANCIO relativi ad un id_componente
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
         update imputazioni_bilancio i
            set i.dal        = p_dal
               ,i.data_agg   = p_data_aggiornamento
               ,i.utente_agg = p_utente_aggiornamento
          where i.id_componente = p_id_componente
            and i.dal = (select min(i2.dal)
                           from imputazioni_bilancio i2
                          where i2.id_componente = p_id_componente);
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
         p_segnalazione           := p_segnalazione || ' (' || p_id_componente || ')';
   end; -- imputazione_bilancio.aggiorna_imputazioni
   --------------------------------------------------------------------------------
   procedure ripristina_imputazioni
   (
      p_id_componente          in imputazioni_bilancio.id_componente%type
     ,p_data_aggiornamento     in imputazioni_bilancio.data_agg%type
     ,p_utente_aggiornamento   in imputazioni_bilancio.utente_agg%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        ripristina_imputazioni.
       DESCRIZIONE: riapre i record cessati
       PARAMETRI:   p_id_componente
                    p_data_aggiornamento
                    p_utente_aggiornamento
                    p_segnalazione_bloccante
                    p_segnalazione
       NOTE:        --
      ******************************************************************************/
      d_errore exception;
   begin
      begin
         update imputazioni_bilancio i1
            set i1.al         = null
               ,i1.utente_agg = p_utente_aggiornamento
               ,i1.data_agg   = p_data_aggiornamento
          where i1.id_componente = p_id_componente
            and i1.dal = (select max(i2.dal)
                            from imputazioni_bilancio i2
                           where i2.id_componente = p_id_componente);
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
         p_segnalazione           := p_segnalazione || ' (' || p_id_componente || ')';
   end; -- Imputazione_bilancio.elimina_attributi
--------------------------------------------------------------------------------
begin
   -- inserimento degli errori nella tabella
   s_error_table(s_dal_al_errato_number) := s_dal_al_errato_msg;
   s_error_table(s_dal_errato_num) := s_dal_errato_msg;
   s_error_table(s_dal_errato_ins_num) := s_dal_errato_ins_msg;
   s_error_table(s_dal_fuori_periodo_num) := s_dal_fuori_periodo_msg;
   s_error_table(s_al_errato_num) := s_al_errato_msg;
   s_error_table(s_al_errato_ins_num) := s_al_errato_ins_msg;
   s_error_table(s_al_fuori_periodo_num) := s_al_fuori_periodo_msg;
   s_error_table(s_record_storico_num) := s_record_storico_msg;
end imputazione_bilancio;
/

