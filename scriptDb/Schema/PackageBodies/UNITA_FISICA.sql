CREATE OR REPLACE package body unita_fisica is
   /******************************************************************************
    NOME:        unita_fisica
    DESCRIZIONE: Gestione tabella unita_fisiche.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore    Descrizione.
    000   31/10/2007  VDAVALLI  Prima emissione.
    001   04/09/2009  VDAVALLI  Modifiche per configurazione master/slave
    002   27/08/2012  mmonari   Revisione complessiva struttura fisica
    003   04/12/2012  MMONARI   Redmine bug#136
    004   02/01/2013  ADADAMO   Aggiunta get_uo_competenza
    005   13/02/2014  ADADAMO   Modificata is_ri_ok per vincolare la chiamata alla
                                chk_integrita_storica_figlio al fatto che id_uf_padre
                                sia non nullo (Bug#383)
    006   14/04/2016  MM/AA     #266, trasformazione nodo in radice
   ******************************************************************************/

   s_revisione_body constant afc.t_revision := '006';
   s_error_table afc_error.t_error_table;
   s_dummy       varchar2(1);

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
   end versione; -- unita_fisica.versione

   --------------------------------------------------------------------------------

   function pk(p_id_elemento_fisico in unita_fisiche.id_elemento_fisico%type) return t_pk is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        PK
       DESCRIZIONE: Costruttore di un t_PK dati gli attributi della chiave
      ******************************************************************************/
      d_result t_pk;
   begin
   
      d_result.id_elemento_fisico := p_id_elemento_fisico;
   
      dbc.pre(not dbc.preon or canhandle(d_result.id_elemento_fisico)
             ,'canHandle on unita_fisica.PK');
      return d_result;
   
   end pk; -- end unita_fisica.PK

   --------------------------------------------------------------------------------

   function can_handle(p_id_elemento_fisico in unita_fisiche.id_elemento_fisico%type)
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
      if d_result = 1 and (p_id_elemento_fisico is null) then
         d_result := 0;
      end if;
   
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on unita_fisica.can_handle');
   
      return d_result;
   
   end can_handle; -- unita_fisica.can_handle

   --------------------------------------------------------------------------------

   function canhandle(p_id_elemento_fisico in unita_fisiche.id_elemento_fisico%type)
      return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        canHandle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: true se la chiave è manipolabile, false altrimenti.
       NOTE:        Wrapper boolean di can_handle (cfr. can_handle).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(can_handle(p_id_elemento_fisico));
   begin
      return d_result;
   end canhandle; -- unita_fisica.canHandle

   --------------------------------------------------------------------------------

   function exists_id(p_id_elemento_fisico in unita_fisiche.id_elemento_fisico%type)
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
   
      dbc.pre(not dbc.preon or canhandle(p_id_elemento_fisico)
             ,'canHandle on unita_fisica.exists_id');
   
      begin
         select 1
           into d_result
           from unita_fisiche
          where id_elemento_fisico = p_id_elemento_fisico;
      exception
         when no_data_found then
            d_result := 0;
      end;
   
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on unita_fisica.exists_id');
   
      return d_result;
   end exists_id; -- unita_fisica.exists_id

   --------------------------------------------------------------------------------

   function existsid(p_id_elemento_fisico in unita_fisiche.id_elemento_fisico%type)
      return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        existsId
       DESCRIZIONE: Esistenza riga con chiave indicata.
       NOTE:        Wrapper boolean di exists_id (cfr. exists_id).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(exists_id(p_id_elemento_fisico));
   begin
      return d_result;
   end existsid; -- unita_fisica.existsId

   --------------------------------------------------------------------------------

   procedure ins
   (
      p_id_elemento_fisico    in unita_fisiche.id_elemento_fisico%type
     ,p_amministrazione       in unita_fisiche.amministrazione%type
     ,p_progr_unita_fisica    in unita_fisiche.progr_unita_fisica%type
     ,p_id_unita_fisica_padre in unita_fisiche.id_unita_fisica_padre%type default null
     ,p_sequenza              in unita_fisiche.sequenza%type default null
     ,p_dal                   in unita_fisiche.dal%type
     ,p_al                    in unita_fisiche.al%type default null
     ,p_utente_aggiornamento  in unita_fisiche.utente_aggiornamento%type default null
     ,p_data_aggiornamento    in unita_fisiche.data_aggiornamento%type default null
   ) is
      /******************************************************************************
       NOME:        ins
       DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
       PARAMETRI:   Chiavi e attributi della table.
      ******************************************************************************/
   begin
   
      -- Check Mandatory on Insert
      dbc.pre(not dbc.preon or p_amministrazione is not null or /*default value*/
              '' is not null
             ,'p_amministrazione on unita_fisica.ins');
      dbc.pre(not dbc.preon or p_progr_unita_fisica is not null or /*default value*/
              '' is not null
             ,'p_progr_unita_fisica on unita_fisica.ins');
      dbc.pre(not dbc.preon or p_id_unita_fisica_padre is not null or /*default value*/
              'default null' is not null
             ,'p_id_unita_fisica_padre on unita_fisica.ins');
      dbc.pre(not dbc.preon or p_sequenza is not null or /*default value*/
              'default null' is not null
             ,'p_sequenza on unita_fisica.ins');
      dbc.pre(not dbc.preon or p_dal is not null or /*default value*/
              '' is not null
             ,'p_dal on unita_fisica.ins');
      dbc.pre(not dbc.preon or p_al is not null or /*default value*/
              'default null' is not null
             ,'p_al on unita_fisica.ins');
      dbc.pre(not dbc.preon or p_utente_aggiornamento is not null or /*default value*/
              'default null' is not null
             ,'p_utente_aggiornamento on unita_fisica.ins');
      dbc.pre(not dbc.preon or p_data_aggiornamento is not null or /*default value*/
              'default null' is not null
             ,'p_data_aggiornamento on unita_fisica.ins');
   
      dbc.pre(not dbc.preon or (p_id_elemento_fisico is null and /*default value*/
              '' is not null) -- PK nullable on insert
              or not existsid(p_id_elemento_fisico)
             ,'not existsId on unita_fisica.ins');
   
      insert into unita_fisiche
         (id_elemento_fisico
         ,amministrazione
         ,progr_unita_fisica
         ,id_unita_fisica_padre
         ,sequenza
         ,dal
         ,al
         ,utente_aggiornamento
         ,data_aggiornamento)
      values
         (p_id_elemento_fisico
         ,p_amministrazione
         ,p_progr_unita_fisica
         ,p_id_unita_fisica_padre
         ,p_sequenza
         ,p_dal
         ,p_al
         ,p_utente_aggiornamento
         ,p_data_aggiornamento);
   
   end ins; -- unita_fisica.ins

   --------------------------------------------------------------------------------

   procedure upd
   (
      p_new_id_elemento_fisico    in unita_fisiche.id_elemento_fisico%type
     ,p_new_amministrazione       in unita_fisiche.amministrazione%type
     ,p_new_progr_unita_fisica    in unita_fisiche.progr_unita_fisica%type
     ,p_new_id_unita_fisica_padre in unita_fisiche.id_unita_fisica_padre%type
     ,p_new_sequenza              in unita_fisiche.sequenza%type
     ,p_new_dal                   in unita_fisiche.dal%type
     ,p_new_al                    in unita_fisiche.al%type
     ,p_new_utente_aggiornamento  in unita_fisiche.utente_aggiornamento%type
     ,p_new_data_aggiornamento    in unita_fisiche.data_aggiornamento%type
     ,p_old_id_elemento_fisico    in unita_fisiche.id_elemento_fisico%type default null
     ,p_old_amministrazione       in unita_fisiche.amministrazione%type default null
     ,p_old_progr_unita_fisica    in unita_fisiche.progr_unita_fisica%type default null
     ,p_old_id_unita_fisica_padre in unita_fisiche.id_unita_fisica_padre%type default null
     ,p_old_sequenza              in unita_fisiche.sequenza%type default null
     ,p_old_dal                   in unita_fisiche.dal%type default null
     ,p_old_al                    in unita_fisiche.al%type default null
     ,p_old_utente_aggiornamento  in unita_fisiche.utente_aggiornamento%type default null
     ,p_old_data_aggiornamento    in unita_fisiche.data_aggiornamento%type default null
     ,p_check_old                 in integer default 0
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
              not ((p_old_amministrazione is not null or
               p_old_progr_unita_fisica is not null or
               p_old_id_unita_fisica_padre is not null or p_old_sequenza is not null or
               p_old_dal is not null or p_old_al is not null or
               p_old_utente_aggiornamento is not null or
               p_old_data_aggiornamento is not null) and (nvl(p_check_old, -1) = 0))
             ,' <OLD values> is not null on unita_fisica.upd');
   
      d_key := pk(nvl(p_old_id_elemento_fisico, p_new_id_elemento_fisico));
   
      dbc.pre(not dbc.preon or existsid(d_key.id_elemento_fisico)
             ,'existsId on unita_fisica.upd');
   
      update unita_fisiche
         set id_elemento_fisico    = decode(p_check_old
                                           ,0
                                           ,p_new_id_elemento_fisico
                                           ,decode(p_new_id_elemento_fisico
                                                  ,p_old_id_elemento_fisico
                                                  ,id_elemento_fisico
                                                  ,p_new_id_elemento_fisico))
            ,amministrazione       = decode(p_check_old
                                           ,0
                                           ,p_new_amministrazione
                                           ,decode(p_new_amministrazione
                                                  ,p_new_amministrazione
                                                  ,p_old_amministrazione))
            ,progr_unita_fisica    = decode(p_check_old
                                           ,0
                                           ,p_new_progr_unita_fisica
                                           ,decode(p_new_progr_unita_fisica
                                                  ,p_old_progr_unita_fisica
                                                  ,progr_unita_fisica
                                                  ,p_new_progr_unita_fisica))
            ,id_unita_fisica_padre = decode(p_check_old
                                           ,0
                                           ,p_new_id_unita_fisica_padre
                                           ,decode(p_new_id_unita_fisica_padre
                                                  ,p_old_id_unita_fisica_padre
                                                  ,id_unita_fisica_padre
                                                  ,p_new_id_unita_fisica_padre))
            ,sequenza              = decode(p_check_old
                                           ,0
                                           ,p_new_sequenza
                                           ,decode(p_new_sequenza
                                                  ,p_old_sequenza
                                                  ,sequenza
                                                  ,p_new_sequenza))
            ,dal                   = decode(p_check_old
                                           ,0
                                           ,p_new_dal
                                           ,decode(p_new_dal, p_old_dal, dal, p_new_dal))
            ,al                    = decode(p_check_old
                                           ,0
                                           ,p_new_al
                                           ,decode(p_new_al, p_old_al, al, p_new_al))
            ,utente_aggiornamento  = decode(p_check_old
                                           ,0
                                           ,p_new_utente_aggiornamento
                                           ,decode(p_new_utente_aggiornamento
                                                  ,p_old_utente_aggiornamento
                                                  ,utente_aggiornamento
                                                  ,p_new_utente_aggiornamento))
            ,data_aggiornamento    = decode(p_check_old
                                           ,0
                                           ,p_new_data_aggiornamento
                                           ,decode(p_new_data_aggiornamento
                                                  ,p_old_data_aggiornamento
                                                  ,data_aggiornamento
                                                  ,p_new_data_aggiornamento))
       where id_elemento_fisico = d_key.id_elemento_fisico
         and (nvl(p_check_old, 0) = 0 or
             p_check_old = 1 and
             (amministrazione = p_old_amministrazione or
             amministrazione is null and p_old_amministrazione is null) and
             (progr_unita_fisica = p_old_progr_unita_fisica or
             progr_unita_fisica is null and p_old_progr_unita_fisica is null) and
             (id_unita_fisica_padre = p_old_id_unita_fisica_padre or
             id_unita_fisica_padre is null and p_old_id_unita_fisica_padre is null) and
             (sequenza = p_old_sequenza or sequenza is null and p_old_sequenza is null) and
             (dal = p_old_dal or dal is null and p_old_dal is null) and
             (al = p_old_al or al is null and p_old_al is null) and
             (utente_aggiornamento = p_old_utente_aggiornamento or
             utente_aggiornamento is null and p_old_utente_aggiornamento is null) and
             (data_aggiornamento = p_old_data_aggiornamento or
             data_aggiornamento is null and p_old_data_aggiornamento is null));
      d_row_found := sql%rowcount;
   
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on unita_fisica.upd');
   
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   
   end upd; -- unita_fisica.upd

   --------------------------------------------------------------------------------

   procedure upd_column
   (
      p_id_elemento_fisico in unita_fisiche.id_elemento_fisico%type
     ,p_column             in varchar2
     ,p_value              in varchar2 default null
     ,p_literal_value      in number default 1
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
   
      dbc.pre(not dbc.preon or existsid(p_id_elemento_fisico)
             ,'existsId on unita_fisica.upd_column');
      dbc.pre(not dbc.preon or p_column is not null
             ,'p_column is not null on unita_fisica.upd_column');
      dbc.pre(not dbc.preon or afc_ddl.hasattribute(s_table_name, p_column)
             ,'AFC_DDL.HasAttribute on unita_fisica.upd_column');
      dbc.pre(p_literal_value in (0, 1) or p_literal_value is null
             ,'p_literal_value on unita_fisica.upd_column; p_literal_value = ' ||
              p_literal_value);
   
      if p_literal_value = 1 or p_literal_value is null then
         d_literal := '''';
      end if;
   
      d_statement := 'begin ' || '   update unita_fisiche' || '   set    ' || p_column ||
                     ' = ' || d_literal || p_value || d_literal ||
                     '   where  id_elemento_fisico = ''' || p_id_elemento_fisico || '''' ||
                     '   ;' || 'end;';
   
      afc.sql_execute(d_statement);
   
   end upd_column; -- unita_fisica.upd_column

   --------------------------------------------------------------------------------

   procedure upd_column
   (
      p_id_elemento_fisico in unita_fisiche.id_elemento_fisico%type
     ,p_column             in varchar2
     ,p_value              in date
   ) is
      /******************************************************************************
       NOME:        upd_column
       DESCRIZIONE: Aggiornamento del campo p_column col valore p_value.
      
       NOTE:        Richiama se stessa con il parametro date convertito in stringa.
      ******************************************************************************/
      d_data varchar2(19);
   begin
      d_data := to_char(p_value, afc.date_format);
      upd_column(p_id_elemento_fisico
                ,p_column
                ,'to_date( ''' || d_data || ''', ''' || afc.date_format || ''' )'
                ,0);
   end upd_column; -- unita_fisica.upd_column

   --------------------------------------------------------------------------------

   procedure del
   (
      p_id_elemento_fisico    in unita_fisiche.id_elemento_fisico%type
     ,p_amministrazione       in unita_fisiche.amministrazione%type
     ,p_progr_unita_fisica    in unita_fisiche.progr_unita_fisica%type default null
     ,p_id_unita_fisica_padre in unita_fisiche.id_unita_fisica_padre%type default null
     ,p_sequenza              in unita_fisiche.sequenza%type default null
     ,p_dal                   in unita_fisiche.dal%type default null
     ,p_al                    in unita_fisiche.al%type default null
     ,p_utente_aggiornamento  in unita_fisiche.utente_aggiornamento%type default null
     ,p_data_aggiornamento    in unita_fisiche.data_aggiornamento%type default null
     ,p_check_old             in integer default 0
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
              not ((p_amministrazione is not null or p_progr_unita_fisica is not null or
               p_id_unita_fisica_padre is not null or p_sequenza is not null or
               p_dal is not null or p_al is not null or
               p_utente_aggiornamento is not null or
               p_data_aggiornamento is not null) and (nvl(p_check_old, 0) = 0))
             ,' <OLD values> is not null on unita_fisica.del');
   
      dbc.pre(not dbc.preon or existsid(p_id_elemento_fisico)
             ,'existsId on unita_fisica.del');
   
      delete from unita_fisiche
       where id_elemento_fisico = p_id_elemento_fisico
         and (nvl(p_check_old, 0) = 0 or
             p_check_old = 1 and (amministrazione = p_amministrazione or
             amministrazione is null and p_amministrazione is null) and
             (progr_unita_fisica = p_progr_unita_fisica or
             progr_unita_fisica is null and p_progr_unita_fisica is null) and
             (id_unita_fisica_padre = p_id_unita_fisica_padre or
             id_unita_fisica_padre is null and p_id_unita_fisica_padre is null) and
             (sequenza = p_sequenza or sequenza is null and p_sequenza is null) and
             (dal = p_dal or dal is null and p_dal is null) and
             (al = p_al or al is null and p_al is null) and
             (utente_aggiornamento = p_utente_aggiornamento or
             utente_aggiornamento is null and p_utente_aggiornamento is null) and
             (data_aggiornamento = p_data_aggiornamento or
             data_aggiornamento is null and p_data_aggiornamento is null));
      d_row_found := sql%rowcount;
   
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on unita_fisica.del');
   
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   
      dbc.post(not dbc.poston or not existsid(p_id_elemento_fisico)
              ,'existsId on unita_fisica.del');
   
   end del; -- unita_fisica.del

   --------------------------------------------------------------------------------

   function get_amministrazione(p_id_elemento_fisico in unita_fisiche.id_elemento_fisico%type)
      return unita_fisiche.amministrazione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_amministrazione
       DESCRIZIONE: Attributo amministrazione di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     unita_fisiche.amministrazione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result unita_fisiche.amministrazione%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_elemento_fisico)
             ,'existsId on unita_fisica.get_amministrazione');
   
      select amministrazione
        into d_result
        from unita_fisiche
       where id_elemento_fisico = p_id_elemento_fisico;
   
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on unita_fisica.get_amministrazione');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'amministrazione')
                      ,' AFC_DDL.IsNullable on unita_fisica.get_amministrazione');
      end if;
   
      return d_result;
   end get_amministrazione; -- unita_fisica.get_amministrazione

   --------------------------------------------------------------------------------

   function get_progr_unita_fisica(p_id_elemento_fisico in unita_fisiche.id_elemento_fisico%type)
      return unita_fisiche.progr_unita_fisica%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_progr_unita_fisica
       DESCRIZIONE: Attributo progr_unita_fisica di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     unita_fisiche.progr_unita_fisica%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result unita_fisiche.progr_unita_fisica%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_elemento_fisico)
             ,'existsId on unita_fisica.get_progr_unita_fisica');
   
      select progr_unita_fisica
        into d_result
        from unita_fisiche
       where id_elemento_fisico = p_id_elemento_fisico;
   
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on unita_fisica.get_progr_unita_fisica');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'progr_unita_fisica')
                      ,' AFC_DDL.IsNullable on unita_fisica.get_progr_unita_fisica');
      end if;
   
      return d_result;
   end get_progr_unita_fisica; -- unita_fisica.get_progr_unita_fisica

   --------------------------------------------------------------------------------

   function get_id_unita_fisica_padre(p_id_elemento_fisico in unita_fisiche.id_elemento_fisico%type)
      return unita_fisiche.id_unita_fisica_padre%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_id_unita_fisica_padre
       DESCRIZIONE: Attributo id_unita_fisica_padre di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     unita_fisiche.id_unita_fisica_padre%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result unita_fisiche.id_unita_fisica_padre%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_elemento_fisico)
             ,'existsId on unita_fisica.get_id_unita_fisica_padre');
   
      select id_unita_fisica_padre
        into d_result
        from unita_fisiche
       where id_elemento_fisico = p_id_elemento_fisico
         and sysdate between dal and nvl(al, to_date(3333333, 'j'));
   
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on unita_fisica.get_id_unita_fisica_padre');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'id_unita_fisica_padre')
                      ,' AFC_DDL.IsNullable on unita_fisica.get_id_unita_fisica_padre');
      end if;
   
      return d_result;
   end get_id_unita_fisica_padre; -- unita_fisica.get_id_unita_fisica_padre

   --------------------------------------------------------------------------------

   function get_sequenza(p_id_elemento_fisico in unita_fisiche.id_elemento_fisico%type)
      return unita_fisiche.sequenza%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_sequenza
       DESCRIZIONE: Attributo sequenza di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     unita_fisiche.sequenza%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result unita_fisiche.sequenza%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_elemento_fisico)
             ,'existsId on unita_fisica.get_sequenza');
   
      select sequenza
        into d_result
        from unita_fisiche
       where id_elemento_fisico = p_id_elemento_fisico
         and sysdate between dal and nvl(al, to_date(3333333, 'j'));
   
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on unita_fisica.get_sequenza');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'sequenza')
                      ,' AFC_DDL.IsNullable on unita_fisica.get_sequenza');
      end if;
   
      return d_result;
   end get_sequenza; -- unita_fisica.get_sequenza

   --------------------------------------------------------------------------------

   function get_dal(p_id_elemento_fisico in unita_fisiche.id_elemento_fisico%type)
      return unita_fisiche.dal%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_dal
       DESCRIZIONE: Attributo dal di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     unita_fisiche.dal%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result unita_fisiche.dal%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_elemento_fisico)
             ,'existsId on unita_fisica.get_dal');
   
      select dal
        into d_result
        from unita_fisiche
       where id_elemento_fisico = p_id_elemento_fisico;
   
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on unita_fisica.get_dal');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'dal')
                      ,' AFC_DDL.IsNullable on unita_fisica.get_dal');
      end if;
   
      return d_result;
   end get_dal; -- unita_fisica.get_dal

   --------------------------------------------------------------------------------

   function get_al(p_id_elemento_fisico in unita_fisiche.id_elemento_fisico%type)
      return unita_fisiche.al%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_al
       DESCRIZIONE: Attributo al di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     unita_fisiche.al%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result unita_fisiche.al%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_elemento_fisico)
             ,'existsId on unita_fisica.get_al');
   
      select al
        into d_result
        from unita_fisiche
       where id_elemento_fisico = p_id_elemento_fisico;
   
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on unita_fisica.get_al');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'al')
                      ,' AFC_DDL.IsNullable on unita_fisica.get_al');
      end if;
   
      return d_result;
   end get_al; -- unita_fisica.get_al

   --------------------------------------------------------------------------------

   function get_utente_aggiornamento(p_id_elemento_fisico in unita_fisiche.id_elemento_fisico%type)
      return unita_fisiche.utente_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_utente_aggiornamento
       DESCRIZIONE: Attributo utente_aggiornamento di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     unita_fisiche.utente_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result unita_fisiche.utente_aggiornamento%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_elemento_fisico)
             ,'existsId on unita_fisica.get_utente_aggiornamento');
   
      select utente_aggiornamento
        into d_result
        from unita_fisiche
       where id_elemento_fisico = p_id_elemento_fisico;
   
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on unita_fisica.get_utente_aggiornamento');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'utente_aggiornamento')
                      ,' AFC_DDL.IsNullable on unita_fisica.get_utente_aggiornamento');
      end if;
   
      return d_result;
   end get_utente_aggiornamento; -- unita_fisica.get_utente_aggiornamento

   --------------------------------------------------------------------------------

   function get_data_aggiornamento(p_id_elemento_fisico in unita_fisiche.id_elemento_fisico%type)
      return unita_fisiche.data_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_data_aggiornamento
       DESCRIZIONE: Attributo data_aggiornamento di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     unita_fisiche.data_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result unita_fisiche.data_aggiornamento%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_elemento_fisico)
             ,'existsId on unita_fisica.get_data_aggiornamento');
   
      select data_aggiornamento
        into d_result
        from unita_fisiche
       where id_elemento_fisico = p_id_elemento_fisico;
   
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on unita_fisica.get_data_aggiornamento');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'data_aggiornamento')
                      ,' AFC_DDL.IsNullable on unita_fisica.get_data_aggiornamento');
      end if;
   
      return d_result;
   end get_data_aggiornamento; -- unita_fisica.get_data_aggiornamento

   --------------------------------------------------------------------------------

   function where_condition
   (
      p_id_elemento_fisico    in varchar2 default null
     ,p_amministrazione       in varchar2 default null
     ,p_progr_unita_fisica    in varchar2 default null
     ,p_id_unita_fisica_padre in varchar2 default null
     ,p_sequenza              in varchar2 default null
     ,p_dal                   in varchar2 default null
     ,p_al                    in varchar2 default null
     ,p_utente_aggiornamento  in varchar2 default null
     ,p_data_aggiornamento    in varchar2 default null
     ,p_other_condition       in varchar2 default null
     ,p_qbe                   in number default 0
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
                     afc.get_field_condition(' and ( id_elemento_fisico '
                                            ,p_id_elemento_fisico
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( amministrazione '
                                            ,p_amministrazione
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( progr_unita_fisica '
                                            ,p_progr_unita_fisica
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( id_unita_fisica_padre '
                                            ,p_id_unita_fisica_padre
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( sequenza '
                                            ,p_sequenza
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
                     afc.get_field_condition(' and ( utente_aggiornamento '
                                            ,p_utente_aggiornamento
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( data_aggiornamento '
                                            ,p_data_aggiornamento
                                            ,' )'
                                            ,p_qbe
                                            ,afc.date_format) || ' ) ' ||
                     p_other_condition;
   
      return d_statement;
   
   end where_condition; --- unita_fisica.where_condition

   --------------------------------------------------------------------------------

   function get_rows
   (
      p_id_elemento_fisico    in varchar2 default null
     ,p_amministrazione       in varchar2 default null
     ,p_progr_unita_fisica    in varchar2 default null
     ,p_id_unita_fisica_padre in varchar2 default null
     ,p_sequenza              in varchar2 default null
     ,p_dal                   in varchar2 default null
     ,p_al                    in varchar2 default null
     ,p_utente_aggiornamento  in varchar2 default null
     ,p_data_aggiornamento    in varchar2 default null
     ,p_other_condition       in varchar2 default null
     ,p_qbe                   in number default 0
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
   
      d_statement := ' select * from unita_fisiche ' ||
                     where_condition(p_id_elemento_fisico
                                    ,p_amministrazione
                                    ,p_progr_unita_fisica
                                    ,p_id_unita_fisica_padre
                                    ,p_sequenza
                                    ,p_dal
                                    ,p_al
                                    ,p_utente_aggiornamento
                                    ,p_data_aggiornamento
                                    ,p_other_condition
                                    ,p_qbe);
   
      d_ref_cursor := afc_dml.get_ref_cursor(d_statement);
   
      return d_ref_cursor;
   
   end get_rows; -- unita_fisica.get_rows

   --------------------------------------------------------------------------------

   function count_rows
   (
      p_id_elemento_fisico    in varchar2 default null
     ,p_amministrazione       in varchar2 default null
     ,p_progr_unita_fisica    in varchar2 default null
     ,p_id_unita_fisica_padre in varchar2 default null
     ,p_sequenza              in varchar2 default null
     ,p_dal                   in varchar2 default null
     ,p_al                    in varchar2 default null
     ,p_utente_aggiornamento  in varchar2 default null
     ,p_data_aggiornamento    in varchar2 default null
     ,p_other_condition       in varchar2 default null
     ,p_qbe                   in number default 0
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
   
      d_statement := ' select count( * ) from unita_fisiche ' ||
                     where_condition(p_id_elemento_fisico
                                    ,p_amministrazione
                                    ,p_progr_unita_fisica
                                    ,p_id_unita_fisica_padre
                                    ,p_sequenza
                                    ,p_dal
                                    ,p_al
                                    ,p_utente_aggiornamento
                                    ,p_data_aggiornamento
                                    ,p_other_condition
                                    ,p_qbe);
   
      d_result := afc.sql_execute(d_statement);
   
      return d_result;
   end count_rows; -- unita_fisica.count_rows

   --------------------------------------------------------------------------------

   function get_id_elemento
   (
      p_amministrazione    in unita_fisiche.amministrazione%type
     ,p_progr_unita_fisica in unita_fisiche.progr_unita_fisica%type
     ,p_data               in unita_fisiche.dal%type
   ) return unita_fisiche.id_elemento_fisico%type is
      /******************************************************************************
       NOME:        get_id_elemento
       DESCRIZIONE: Restituisce l'id_elemento dell'unita' indicata
       PARAMETRI:   p_amministrazione
                    p_progr_unita_fisica
                    p_data
       RITORNA:     Id elemento dell'unita' indicata
      ******************************************************************************/
      d_result unita_fisiche.id_elemento_fisico%type;
   begin
      select id_elemento_fisico
        into d_result
        from unita_fisiche
       where amministrazione = p_amministrazione
         and progr_unita_fisica = p_progr_unita_fisica
         and p_data between dal and nvl(al, to_date('3333333', 'j'));
      --
      return d_result;
   end; -- unita_fisica.get_id_elemento

   --------------------------------------------------------------------------------

   function is_unita_padre
   (
      p_amministrazione    in unita_fisiche.amministrazione%type
     ,p_progr_unita_fisica in unita_fisiche.progr_unita_fisica%type
     ,p_data               in unita_fisiche.dal%type
   ) return integer is
      /******************************************************************************
       NOME:        is_unita_padre
       DESCRIZIONE: Restituisce ok se l'unita' e' padre di altre unita'
       PARAMETRI:   p_amministrazione
                    p_progr_unita_fisica
                    p_data
       RITORNA:     1 se l'unita' e' padre, altrimenti 0
      ******************************************************************************/
      d_result      afc_error.t_error_number := afc_error.ok;
      d_id_elemento unita_fisiche.id_elemento_fisico%type;
      d_contatore   number;
   begin
      d_id_elemento := unita_fisica.get_id_elemento(p_amministrazione    => p_amministrazione
                                                   ,p_progr_unita_fisica => p_progr_unita_fisica
                                                   ,p_data               => p_data);
      d_contatore   := unita_fisica.count_rows(p_id_unita_fisica_padre => '=''' ||
                                                                          d_id_elemento || ''''
                                              ,p_other_condition       => ' and nvl(al,to_date(''3333333'',''j'')) > ' ||
                                                                          ' to_date(''' ||
                                                                          nvl(p_data
                                                                             ,to_date('2222222'
                                                                                     ,'j')) ||
                                                                          ''')'
                                              ,p_qbe                   => 1);
   
      if d_contatore > 0 then
         d_result := afc_error.ok;
      else
         d_result := 0;
      end if;
   
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result = 0
              ,'d_result = AFC_Error.ok or d_result = 0 on unita_fisica.is_unita_padre');
   
      return d_result;
   
   end; -- unita_fisica.is_unita_padre

   --------------------------------------------------------------------------------

   function contiene_unita
   (
      p_amministrazione in unita_fisiche.amministrazione%type
     ,p_id_provenienza  in unita_fisiche.id_elemento_fisico%type
     ,p_id_destinazione in unita_fisiche.id_elemento_fisico%type
     ,p_data            in unita_fisiche.dal%type
   ) return integer is
      /******************************************************************************
       NOME:        contiene_unita
       DESCRIZIONE: Restituisce 1 se l'unita' da spostare e' presente tra gli
                    ascendenti dell'unita' di destinazione
       PARAMETRI:   p_id_provenienza
                    p_id_provenienza
                    p_data
       RITORNA:     1 se l'unita' e' contenute, altrimenti 0
      ******************************************************************************/
      d_result             afc_error.t_error_number := afc_error.ok;
      d_progr_unita_fisica unita_fisiche.progr_unita_fisica%type;
      d_contatore          number;
   begin
      d_progr_unita_fisica := unita_fisica.get_progr_unita_fisica(p_id_elemento_fisico => p_id_provenienza);
   
      select count(*)
        into d_contatore
        from unita_fisiche
       where amministrazione = p_amministrazione
         and progr_unita_fisica = d_progr_unita_fisica
         and p_data between dal and nvl(al, to_date('3333333', 'j'))
      connect by prior id_unita_fisica_padre = id_elemento_fisico
             and p_data between prior dal and nvl(prior al, to_date('3333333', 'j'))
       start with id_elemento_fisico = p_id_destinazione;
   
      if d_contatore > 0 then
         d_result := afc_error.ok;
      else
         d_result := 0;
      end if;
   
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result = 0
              ,'d_result = AFC_Error.ok or d_result = 0 on unita_fisica.is_unita_padre');
   
      return d_result;
   
   end; -- unita_fisica.contiene_unita

   ------------------------------------------------------------------------------------------------

   -- Modifica della sequenza di ordinamento tramite drag and drop
   procedure aggiorna_sequenza
   (
      p_id_elemento_partenza   in unita_fisiche.id_elemento_fisico%type
     ,p_id_elemento_arrivo     in unita_fisiche.id_elemento_fisico%type
     ,p_data_aggiornamento     in unita_fisiche.data_aggiornamento%type
     ,p_utente_aggiornamento   in unita_fisiche.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      d_sequenza_arrivo unita_fisiche.sequenza%type;
      d_sequenza        unita_fisiche.sequenza%type;
      d_progr_padre     unita_fisiche.id_unita_fisica_padre%type;
   begin
      d_progr_padre     := unita_fisica.get_id_unita_fisica_padre(p_id_elemento_arrivo);
      d_sequenza_arrivo := unita_fisica.get_sequenza(p_id_elemento_arrivo);
   
      select decode(d_sequenza_arrivo + 1, 1000000, 1, d_sequenza_arrivo + 1)
        into d_sequenza
        from dual;
      begin
         begin
            -- verifica esistenza stessa sequenza, stesso padre
            select 'x'
              into s_dummy
              from unita_fisiche u
             where sysdate between dal and nvl(al, to_date(3333333, 'j'))
               and id_unita_fisica_padre = d_progr_padre
               and sequenza = d_sequenza;
            raise too_many_rows;
         
         exception
            when no_data_found then
               null;
            when too_many_rows then
               -- faccio posto
               update unita_fisiche u
                  set sequenza = sequenza + 1
                where sysdate between dal and nvl(al, to_date(3333333, 'j'))
                  and id_unita_fisica_padre = d_progr_padre
                  and sequenza >= d_sequenza;
         end;
         --  inserisce nuova sequenza
         update unita_fisiche
            set sequenza             = d_sequenza
               ,utente_aggiornamento = p_utente_aggiornamento
               ,data_aggiornamento   = p_data_aggiornamento
          where id_elemento_fisico = p_id_elemento_partenza;
      
         p_segnalazione_bloccante := 'N';
         p_segnalazione           := 'Modifica ordinamento eseguita';
      exception
         when others then
            p_segnalazione_bloccante := 'Y';
            p_segnalazione           := 'Modifica ordinamento non eseguita';
      end;
   
   end;

   --------------------------------------------------------------------------------------------------

   procedure sposta_legame
   (
      p_id_elemento_partenza   in unita_fisiche.id_elemento_fisico%type
     ,p_id_elemento_arrivo     in unita_fisiche.id_elemento_fisico%type
     ,p_data_aggiornamento     in unita_fisiche.data_aggiornamento%type
     ,p_utente_aggiornamento   in unita_fisiche.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        sposta_legame.
       DESCRIZIONE: Spostamente di una unità fisica da un padre ad un altro
       PARAMETRI:   p_id_elemento_partenza
                    p_id_elemento_arrivo
                    p_dal
                    p_al
                    p_data_aggiornamento
                    p_utente_aggiornamento
                    p_segnalazione_bloccante
                    p_segnalazione
       NOTE:        --
      ******************************************************************************/
      d_sequenza                  unita_fisiche.sequenza%type;
      d_progr_unita_fisica        unita_fisiche.progr_unita_fisica%type;
      d_progr_unita_fisica_arrivo unita_fisiche.progr_unita_fisica%type;
      d_progr_unita_padre         unita_fisiche.id_unita_fisica_padre%type;
      d_progr_unita_padre_arrivo  unita_fisiche.id_unita_fisica_padre%type;
      d_dal                       unita_fisiche.dal%type;
      d_nuova_sequenza            unita_fisiche.sequenza%type;
      d_amministrazione           unita_fisiche.amministrazione%type;
      d_data                      date := trunc(sysdate);
      d_descr_unita               anagrafe_unita_fisiche.denominazione%type;
      d_id_suddivisione           anagrafe_unita_fisiche.id_suddivisione%type;
      d_id_suddivisione_arrivo    anagrafe_unita_fisiche.id_suddivisione%type;
      d_errore               exception;
      d_errore_non_bloccante exception;
   begin
      begin
         select sequenza
               ,progr_unita_fisica
               ,id_unita_fisica_padre
               ,dal
               ,amministrazione
           into d_sequenza
               ,d_progr_unita_fisica
               ,d_progr_unita_padre
               ,d_dal
               ,d_amministrazione
           from unita_fisiche
          where id_elemento_fisico = p_id_elemento_partenza;
      exception
         when others then
            if sqlcode between - 20999 and - 20900 then
               p_segnalazione := error_message(sqlcode);
            else
               p_segnalazione := sqlerrm;
            end if;
            raise d_errore;
      end;
      --
      begin
         d_descr_unita := anagrafe_unita_fisica.get_denominazione(d_progr_unita_fisica
                                                                 ,d_dal);
      exception
         when no_data_found then
            d_descr_unita := '*';
      end;
      --
      if p_id_elemento_arrivo is null then
         --#266
         --trasformazione del nodo in radice
         d_progr_unita_fisica_arrivo := to_number(null);
         d_progr_unita_padre_arrivo := to_number(null);
      else
         begin
            select progr_unita_fisica
                  ,id_unita_fisica_padre
              into d_progr_unita_fisica_arrivo
                  ,d_progr_unita_padre_arrivo
              from unita_fisiche
             where id_elemento_fisico = p_id_elemento_arrivo;
         exception
            when others then
               if sqlcode between - 20999 and - 20900 then
                  p_segnalazione := error_message(sqlcode);
               else
                  p_segnalazione := sqlerrm;
               end if;
               raise d_errore;
         end;
      end if;
      -- determina le suddivisioni dei due nodi
      d_id_suddivisione        := anagrafe_unita_fisica.get_id_suddivisione(d_progr_unita_fisica
                                                                           ,anagrafe_unita_fisica.get_dal_id(d_progr_unita_fisica
                                                                                                            ,sysdate));
      if d_progr_unita_fisica_arrivo is not null then                                                                                                            
          d_id_suddivisione_arrivo := anagrafe_unita_fisica.get_id_suddivisione(d_progr_unita_fisica_arrivo
                                                                               ,anagrafe_unita_fisica.get_dal_id(d_progr_unita_fisica_arrivo
                                                                                                                ,sysdate));
      end if;
      --
      --- Non si può spostare un legame nell'ambito dello stesso padre, ma posso cambiare le sequenze
      --
      if d_id_suddivisione = d_id_suddivisione_arrivo then
         if d_progr_unita_padre = d_progr_unita_padre_arrivo then
            aggiorna_sequenza(p_id_elemento_partenza
                             ,p_id_elemento_arrivo
                             ,p_data_aggiornamento
                             ,p_utente_aggiornamento
                             ,p_segnalazione_bloccante
                             ,p_segnalazione);
            if p_segnalazione_bloccante = 'N' then
               commit;
            end if;
            raise d_errore_non_bloccante;
         end if;
      else
         if d_progr_unita_fisica_arrivo = nvl(d_progr_unita_padre, -2) then
         
            p_segnalazione := 'Non e'' possibile spostare un legame nell''ambito della stessa radice';
            raise d_errore_non_bloccante;
         end if;
      end if;
   
      select nvl(max(sequenza), 0) + 100
        into d_nuova_sequenza
        from unita_fisiche
       where progr_unita_fisica = d_progr_unita_fisica_arrivo
         and sysdate between nvl(dal, to_date(2222222, 'j')) and
             nvl(al, to_date(3333333, 'j'));
   
      /* Gestione dello spostamento:
         Se unita_fisiche.dal = oggi, eseguiamo l'update del legame, altrimenti chiudiamo il legame al giorno precedente
         ed inseriamo il nuovo legame con decorrenza oggi
      */
      if d_dal = d_data then
         -- spostamento successivo ad un altro eseguito nella stessa sessione di lavoro
         begin
            update unita_fisiche
               set id_unita_fisica_padre = d_progr_unita_fisica_arrivo
                  ,sequenza              = d_nuova_sequenza
                  ,utente_aggiornamento  = p_utente_aggiornamento
                  ,data_aggiornamento    = p_data_aggiornamento
             where id_elemento_fisico = p_id_elemento_partenza;
         exception
            when others then
               if sqlcode between - 20999 and - 20900 then
                  p_segnalazione := error_message(sqlcode);
               else
                  p_segnalazione := sqlerrm;
               end if;
               raise d_errore;
         end;
         --
      else
         declare
            v_id_elemento unita_fisiche.id_elemento_fisico%type;
         begin
            insert into unita_fisiche
               (id_elemento_fisico
               ,amministrazione
               ,progr_unita_fisica
               ,id_unita_fisica_padre
               ,sequenza
               ,dal
               ,al
               ,utente_aggiornamento
               ,data_aggiornamento)
            values
               (null
               ,d_amministrazione
               ,d_progr_unita_fisica
               ,d_progr_unita_fisica_arrivo
               ,d_nuova_sequenza
               ,d_data
               ,to_date(null)
               ,p_utente_aggiornamento
               ,p_data_aggiornamento)
            returning id_elemento_fisico into v_id_elemento;
         exception
            when others then
               if sqlcode between - 20999 and - 20900 then
                  p_segnalazione := error_message(sqlcode);
               else
                  p_segnalazione := sqlerrm;
               end if;
               raise d_errore;
         end;
      
         begin
            update unita_fisiche
               set al                   = d_data - 1
                  ,utente_aggiornamento = p_utente_aggiornamento
                  ,data_aggiornamento   = p_data_aggiornamento
             where id_elemento_fisico = p_id_elemento_partenza;
         exception
            when others then
               if sqlcode between - 20999 and - 20900 then
                  p_segnalazione := error_message(sqlcode);
               else
                  p_segnalazione := sqlerrm;
               end if;
               raise d_errore;
         end;
      end if;
      commit;
   exception
      when d_errore then
         rollback;
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'U.F.: ' || d_descr_unita || ' - ' || p_segnalazione;
      when d_errore_non_bloccante then
         null;
   end;

   --------------------------------------------------------------------------------------------------

   procedure elimina_legame
   (
      p_id_elemento            in unita_fisiche.id_elemento_fisico%type
     ,p_data_aggiornamento     in unita_fisiche.data_aggiornamento%type
     ,p_utente_aggiornamento   in unita_fisiche.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        elimina_legame.
       DESCRIZIONE: chiusura alla sysdate di una unità fisica
      ******************************************************************************/
      d_descr_unita anagrafe_unita_fisiche.denominazione%type;
      d_errore               exception;
      d_errore_non_bloccante exception;
   begin
      begin
         d_descr_unita := anagrafe_unita_fisica.get_denominazione(unita_fisica.get_progr_unita_fisica(p_id_elemento)
                                                                 ,anagrafe_unita_fisica.get_dal_id(unita_fisica.get_progr_unita_fisica(p_id_elemento)
                                                                                                  ,trunc(sysdate)));
      exception
         when no_data_found then
            d_descr_unita := '*';
      end;
      begin
         update unita_fisiche
            set al                   = trunc(sysdate)
               ,utente_aggiornamento = p_utente_aggiornamento
               ,data_aggiornamento   = p_data_aggiornamento
          where id_elemento_fisico = p_id_elemento;
      
         raise d_errore_non_bloccante;
      exception
         when d_errore_non_bloccante then
            commit;
            p_segnalazione_bloccante := 'N';
            p_segnalazione           := 'U.F.: ' || d_descr_unita || ' : ' || 'Eliminata';
         when others then
         
            if sqlcode between (-20999) and (-20900) then
               dbms_output.put_line(error_message(sqlcode) || ' - ' || sqlerrm);
               p_segnalazione := error_message(sqlcode) /*|| ' - ' || sqlerrm*/
                ;
            else
               p_segnalazione := sqlerrm;
            end if;
            raise d_errore;
      end;
   
   exception
      when d_errore then
         rollback;
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'U.F.: ' || d_descr_unita || ' - ' || p_segnalazione;
      
   end;

   --------------------------------------------------------------------------------------------------

   procedure ripristina_legame
   (
      p_id_elemento            in unita_fisiche.id_elemento_fisico%type
     ,p_data_aggiornamento     in unita_fisiche.data_aggiornamento%type
     ,p_utente_aggiornamento   in unita_fisiche.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        ripristina_legame.
       DESCRIZIONE: ripristina i legami chiusi alla sysdate
      ******************************************************************************/
      d_descr_unita anagrafe_unita_fisiche.denominazione%type;
      d_errore               exception;
      d_errore_non_bloccante exception;
   begin
      begin
         d_descr_unita := anagrafe_unita_fisica.get_denominazione(unita_fisica.get_progr_unita_fisica(p_id_elemento)
                                                                 ,anagrafe_unita_fisica.get_dal_id(unita_fisica.get_progr_unita_fisica(p_id_elemento)
                                                                                                  ,trunc(sysdate)));
      exception
         when no_data_found then
            d_descr_unita := '*';
      end;
      begin
         update unita_fisiche
            set al                   = ''
               ,utente_aggiornamento = p_utente_aggiornamento
               ,data_aggiornamento   = p_data_aggiornamento
          where id_elemento_fisico = p_id_elemento
            and al = trunc(sysdate);
      
         raise d_errore_non_bloccante;
      exception
         when d_errore_non_bloccante then
            commit;
            p_segnalazione_bloccante := 'N';
            p_segnalazione           := 'U.F.: ' || d_descr_unita || ' : ' ||
                                        ' ripristinata';
         when others then
         
            if sqlcode between (-20999) and (-20900) then
               dbms_output.put_line(error_message(sqlcode) || ' - ' || sqlerrm);
               p_segnalazione := error_message(sqlcode) /*|| ' - ' || sqlerrm*/
                ;
            else
               p_segnalazione := sqlerrm;
            end if;
            raise d_errore;
      end;
   
   exception
      when d_errore then
         rollback;
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'U.F.: ' || d_descr_unita || ' - ' || p_segnalazione;
      
   end;

   ------------------------------------------------------------------------------------------

   -- Controlla la coerenza della suddivisione fisica della UF padre
   function chk_ordine_padre
   (
      p_progr_unita_fisica    in unita_fisiche.progr_unita_fisica%type
     ,p_id_unita_fisica_padre in unita_fisiche.id_unita_fisica_padre%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        chk_ordine_padre.
       DESCRIZIONE: Controlla la coerenza della suddivisione fisica della UF padre
       PARAMETRI:   p_progr_unita_fisica
                    p_id_unita_fisica_padre
                    p_amministrazione
                    p_segnalazione_bloccante
                    p_segnalazione
       NOTE:        --
      ******************************************************************************/
      d_data      date := trunc(sysdate);
      d_ord       suddivisioni_fisiche.ordinamento%type;
      d_ord_padre suddivisioni_fisiche.ordinamento%type;
      d_errore               exception;
      d_errore_non_bloccante exception;
      d_amministrazione anagrafe_unita_organizzative.amministrazione%type;
      d_result          afc_error.t_error_number;
   
   begin
      d_ord := suddivisione_fisica.get_ordinamento(anagrafe_unita_fisica.get_id_suddivisione(p_progr_unita_fisica
                                                                                            ,anagrafe_unita_fisica.get_dal_id(p_progr_unita_fisica
                                                                                                                             ,d_data)));
   
      if p_id_unita_fisica_padre is not null then
      
         d_ord_padre := suddivisione_fisica.get_ordinamento(anagrafe_unita_fisica.get_id_suddivisione(p_id_unita_fisica_padre
                                                                                                     ,anagrafe_unita_fisica.get_dal_id(p_id_unita_fisica_padre
                                                                                                                                      ,d_data)));
      else
         select max(amministrazione)
           into d_amministrazione
           from anagrafe_unita_fisiche
          where progr_unita_fisica = p_progr_unita_fisica;
      
         select min(ordinamento)
           into d_ord_padre
           from suddivisioni_fisiche
          where amministrazione = d_amministrazione;
      end if;
   
      if d_ord is not null and d_ord_padre is not null and d_ord <= d_ord_padre then
         d_result := s_ordinamento_errato_number;
      
      else
         d_result := afc_error.ok;
      end if;
   
      return d_result;
   
   end;

   ------------------------------------------------------------------------------------------

   -- Controlla la coerenza storica della relazione padre-figlio
   function chk_integrita_storica_figlio
   (
      p_progr_unita_fisica    in unita_fisiche.progr_unita_fisica%type
     ,p_id_unita_fisica_padre in unita_fisiche.id_unita_fisica_padre%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        chk_integrita_storica.
       DESCRIZIONE: Controlla la coerenza storica della relazione padre-figlio
       PARAMETRI:   p_progr_unita_fisica
                    p_id_unita_fisica_padre
                    p_amministrazione
                    p_segnalazione_bloccante
                    p_segnalazione
       NOTE:        --
      ******************************************************************************/
      d_data date := trunc(sysdate);
      d_dal  unita_fisiche.dal%type;
      d_al   unita_fisiche.al%type;
      d_errore               exception;
      d_errore_non_bloccante exception;
      d_result afc_error.t_error_number;
   
   begin
      begin
         select dal
               ,al
           into d_dal
               ,d_al
           from unita_fisiche
          where progr_unita_fisica = p_progr_unita_fisica
            and d_data between dal and nvl(al, to_date(3333333, 'j'));
      exception
         when no_data_found then
            select dal
                  ,al
              into d_dal
                  ,d_al
              from unita_fisiche
             where progr_unita_fisica = p_progr_unita_fisica
               and dal = (select max(dal)
                            from anagrafe_unita_fisiche
                           where progr_unita_fisica = p_progr_unita_fisica);
      end;
   
      if p_id_unita_fisica_padre is not null then
      
         begin
            select 'x'
              into s_dummy
              from unita_fisiche u
             where progr_unita_fisica = p_id_unita_fisica_padre
               and dal <= d_dal
               and nvl(al, to_date(3333333, 'j')) >= nvl(d_al, to_date(3333333, 'j'));
         
            d_result := afc_error.ok;
         
         exception
            when no_data_found then
               d_result := s_figlio_non_incluso_number;
         end;
      
      end if;
   
      return d_result;
   
   end;

   ------------------------------------------------------------------------------------------

   -- Controlla l'integrita' storica tra il padre e i figli
   function chk_integrita_storica_padre(p_progr_unita_fisica in unita_fisiche.progr_unita_fisica%type)
      return afc_error.t_error_number is
      /******************************************************************************
       NOME:        chk_integrita_storica_padre.
       DESCRIZIONE: Controlla l'integrita' storica tra il padre e i figli
       PARAMETRI:   p_progr_unita_fisica
       NOTE:        --
      ******************************************************************************/
      d_data date := trunc(sysdate);
      d_dal  unita_fisiche.dal%type;
      d_al   unita_fisiche.al%type;
      d_errore               exception;
      d_errore_non_bloccante exception;
      d_result afc_error.t_error_number;
   
   begin
      begin
         select dal
               ,al
           into d_dal
               ,d_al
           from unita_fisiche
          where progr_unita_fisica = p_progr_unita_fisica
            and d_data between dal and nvl(al, to_date(3333333, 'j'));
      exception
         when no_data_found then
            select dal
                  ,al
              into d_dal
                  ,d_al
              from unita_fisiche
             where progr_unita_fisica = p_progr_unita_fisica
               and dal = (select max(dal)
                            from anagrafe_unita_fisiche
                           where progr_unita_fisica = p_progr_unita_fisica);
      end;
   
      begin
         select 'x'
           into s_dummy
           from unita_fisiche u
          where u.id_unita_fisica_padre = p_progr_unita_fisica
            and d_data between dal and nvl(al, to_date(3333333, 'j'))
            and (not exists (select 'x'
                               from unita_fisiche
                              where progr_unita_fisica = u.id_unita_fisica_padre
                                and d_dal between dal and nvl(al, to_date(3333333, 'j'))) or
                 not exists (select 'x'
                               from unita_fisiche
                              where progr_unita_fisica = u.id_unita_fisica_padre
                                and nvl(d_al, to_date(3333333, 'j')) between dal and
                                    nvl(al, to_date(3333333, 'j'))));
      
         raise too_many_rows;
      
      exception
         when no_data_found then
            d_result := afc_error.ok;
         when too_many_rows then
            d_result := s_figli_non_coperti_number;
      end;
   
      return d_result;
   
   end;

   ------------------------------------------------------------------------------------------

   -- Controlla l'integrita' storica tra la UF e gli individui assegnati
   function chk_integrita_assegnazioni(p_progr_unita_fisica in unita_fisiche.progr_unita_fisica%type)
      return afc_error.t_error_number is
      /******************************************************************************
       NOME:        chk_integrita_assegnazioni.
       DESCRIZIONE: Controlla l'integrita' storica tra la UF e gli individui assegnati
       PARAMETRI:   p_progr_unita_fisica
       NOTE:        --
      ******************************************************************************/
      d_data date := trunc(sysdate);
      d_dal  unita_fisiche.dal%type;
      d_al   unita_fisiche.al%type;
      d_errore               exception;
      d_errore_non_bloccante exception;
      d_result afc_error.t_error_number;
   
   begin
      select dal
            ,al
        into d_dal
            ,d_al
        from unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and d_data between dal and nvl(al, to_date(3333333, 'j'));
   
      begin
         select 'x'
           into s_dummy
           from assegnazioni_fisiche a
          where a.progr_unita_fisica = p_progr_unita_fisica
            and d_data between dal and nvl(al, to_date(3333333, 'j'))
            and not (dal >= d_dal and
                 nvl(al, to_date(3333333, 'j')) <= nvl(d_al, to_date(3333333, 'j')));
      
         raise too_many_rows;
      
      exception
         when no_data_found then
            d_result := afc_error.ok;
         when too_many_rows then
            d_result := s_ass_non_coperte_number;
      end;
   
      return d_result;
   
   end;

   ------------------------------------------------------------------------------------------

   function is_ri_ok
   (
      p_progr_unita_fisica in unita_fisiche.progr_unita_fisica%type
     ,p_old_id_uf_padre    in unita_fisiche.id_unita_fisica_padre%type
     ,p_new_id_uf_padre    in unita_fisiche.id_unita_fisica_padre%type
     ,p_old_al             in anagrafe_unita_organizzative.al%type
     ,p_new_al             in anagrafe_unita_organizzative.al%type
     ,p_inserting          in number
     ,p_updating           in number
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_RI_ok.
       DESCRIZIONE: gestione della Referential Integrity:
                    - chk_ordine_padre
                    - chk_integrita_storica_figlio
                    - chk_integrita_storica_padre
                    - chk_integrita_assegnazione
       RETURN:      1 se tutti i controlli danno esito positivo, l'error_code altrimenti
       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number := afc_error.ok;
   begin
      if p_inserting = 1 and p_new_id_uf_padre is not null or
         (p_updating = 1 and
         (nvl(p_new_id_uf_padre, -1) <> nvl(p_old_id_uf_padre, -1) or
         (nvl(p_new_al, to_date(3333333, 'j')) <> nvl(p_old_al, to_date(3333333, 'j'))))) then
         d_result := chk_ordine_padre(p_progr_unita_fisica, p_new_id_uf_padre);
         if d_result = afc_error.ok and p_inserting = 0 and p_new_id_uf_padre is not null then
            d_result := chk_integrita_storica_figlio(p_progr_unita_fisica
                                                    ,p_new_id_uf_padre);
         end if;
      
         --      
         if d_result = afc_error.ok and p_inserting = 0 then
            d_result := chk_integrita_storica_padre(p_progr_unita_fisica);
         end if;
         --      
         if d_result = afc_error.ok and p_inserting = 0 then
            d_result := chk_integrita_assegnazioni(p_progr_unita_fisica);
         end if;
         --      
         if not (d_result = afc_error.ok) then
            raise_application_error(d_result, s_error_table(d_result));
         end if;
      end if;
      return d_result;
   end;

   ------------------------------------------------------------------------------------------

   procedure chk_ri
   (
      p_progr_unita_fisica in unita_fisiche.progr_unita_fisica%type
     ,p_old_id_uf_padre    in unita_fisiche.id_unita_fisica_padre%type
     ,p_new_id_uf_padre    in unita_fisiche.id_unita_fisica_padre%type
     ,p_old_al             in anagrafe_unita_organizzative.al%type
     ,p_new_al             in anagrafe_unita_organizzative.al%type
     ,p_inserting          in number
     ,p_updating           in number
   ) is
      /******************************************************************************
       NOME:        chk_RI.
       DESCRIZIONE: gestione della Referential Integrity:
                    - is_capienza_ok
                    - is_dal_ok
                    - is_al_ok
       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
      d_result := is_ri_ok(p_progr_unita_fisica
                          ,p_old_id_uf_padre
                          ,p_new_id_uf_padre
                          ,p_old_al
                          ,p_new_al
                          ,p_inserting
                          ,p_updating);
   
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, s_error_table(d_result));
      end if;
   
   end;

   ------------------------------------------------------------------------------------------

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
      return d_result;
   end error_message; -- anagrafe_unita_fisica.error_message

   --------------------------------------------------------------------------------
   function get_uo_competenza
   (
      p_progr_unita_fisica in unita_fisiche.progr_unita_fisica%type
     ,p_amministrazione    in unita_fisiche.amministrazione%type
     ,p_data_rif           in date
   ) return varchar2 is
      d_result                    varchar2(300);
      d_progr_unita_organizzativa anagrafe_unita_organizzative.progr_unita_organizzativa%type;
   begin
      d_progr_unita_organizzativa := anagrafe_unita_fisica.get_uo_competenza(p_progr_unita_fisica
                                                                            ,p_amministrazione
                                                                            ,p_data_rif);
      if d_progr_unita_organizzativa is null then
         d_progr_unita_organizzativa := ubicazione_unita.get_uo_competenza(p_progr_unita_fisica
                                                                          ,p_data_rif);
      end if;
      if d_progr_unita_organizzativa is not null and
         d_progr_unita_organizzativa not in (-1, -2) then
         select anagrafe_unita_organizzativa.get_descrizione(d_progr_unita_organizzativa
                                                            ,nvl(p_data_rif, sysdate)) ||
                decode(impostazione.get_visualizza_codice(1)
                      ,'SI'
                      ,' (' ||
                       anagrafe_unita_organizzativa.get_codice_uo(d_progr_unita_organizzativa
                                                                 ,nvl(p_data_rif, sysdate)) || ')'
                      ,null)
           into d_result
           from dual;
      end if;
      return d_result;
   end get_uo_competenza; -- unita_fisica.get_uo_competenza
   --------------------------------------------------------------------------------
   function get_icona_uo_competenza
   (
      p_progr_unita_fisica in unita_fisiche.progr_unita_fisica%type
     ,p_amministrazione    in unita_fisiche.amministrazione%type
     ,p_data_rif           in date
   ) return varchar2 is
      d_result                    varchar2(300);
      d_progr_unita_organizzativa anagrafe_unita_organizzative.progr_unita_organizzativa%type;
   begin
      d_progr_unita_organizzativa := anagrafe_unita_fisica.get_uo_competenza(p_progr_unita_fisica
                                                                            ,p_amministrazione
                                                                            ,p_data_rif);
      if d_progr_unita_organizzativa is null then
         d_progr_unita_organizzativa := ubicazione_unita.get_uo_competenza(p_progr_unita_fisica
                                                                          ,p_data_rif);
      end if;
      if d_progr_unita_organizzativa is not null and
         d_progr_unita_organizzativa not in (-1, -2) then
         d_result := suddivisione_struttura.get_icona_standard(anagrafe_unita_organizzativa.get_id_suddivisione(d_progr_unita_organizzativa
                                                                                                               ,p_data_rif));
      end if;
      return d_result;
   end get_icona_uo_competenza; -- unita_fisica.get_icona_uo_competenza

--------------------------------------------------------------------------------
begin

   -- inserimento degli errori nella tabella
   s_error_table(s_ordinamento_errato_number) := s_ordinamento_errato_msg;
   s_error_table(s_figlio_non_incluso_number) := s_figlio_non_incluso_msg;
   s_error_table(s_figli_non_coperti_number) := s_figli_non_coperti_msg;
   s_error_table(s_ass_non_coperte_number) := s_ass_non_coperte_msg;
   s_error_table(s_errore_bloccante_number) := s_errore_bloccante_msg;

end unita_fisica;
/

