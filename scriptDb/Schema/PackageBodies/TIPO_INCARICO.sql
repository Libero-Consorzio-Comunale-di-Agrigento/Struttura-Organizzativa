CREATE OR REPLACE package body tipo_incarico is
   /******************************************************************************
    NOME:        Tipo_incarico
    DESCRIZIONE: Gestione tabella tipi_incarico.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore     Descrizione.
    000   20/07/2006  VDAVALLI   Prima emissione.
    001   04/09/2009  VDAVALLI   Modifiche per configurazione master/slave
    002   07/09/2009  VDAVALLI   Aggiunto campo se_aspettativa
    003   21/12/2009  APASSUELLO Aggiunto campo ordinamento
    004   16/04/2010  APASSUELLO Aggiunto campo tipo_incarico
    005   12/08/2015  MMONARI    Aggiunto set_fi per #634      
   ******************************************************************************/

   s_revisione_body constant afc.t_revision := '005';

   s_table_name constant afc.t_object_name := 'tipi_incarico';
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
   end; -- Tipo_incarico.versione

   --------------------------------------------------------------------------------

   function pk(p_incarico in tipi_incarico.incarico%type) return t_pk is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        PK
       DESCRIZIONE: Costruttore di un t_PK dati gli attributi della chiave
      ******************************************************************************/
      d_result t_pk;
   begin
   
      d_result.incarico := p_incarico;
      dbc.pre(not dbc.preon or canhandle(d_result.incarico)
             ,'canHandle on Tipo_incarico.PK');
      return d_result;
   
   end; -- end Tipo_incarico.PK

   --------------------------------------------------------------------------------

   function can_handle(p_incarico in tipi_incarico.incarico%type) return number is
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
      if d_result = 1 and (p_incarico is null) then
         d_result := 0;
      end if;
   
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on Tipo_incarico.can_handle');
   
      return d_result;
   
   end; -- Tipo_incarico.can_handle

   --------------------------------------------------------------------------------

   function canhandle(p_incarico in tipi_incarico.incarico%type) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        canHandle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: true se la chiave è manipolabile, false altrimenti.
       NOTE:        Wrapper boolean di can_handle (cfr. can_handle).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(can_handle(p_incarico));
   begin
      return d_result;
   end; -- Tipo_incarico.canHandle

   --------------------------------------------------------------------------------

   function exists_id(p_incarico in tipi_incarico.incarico%type) return number is
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
   
      dbc.pre(not dbc.preon or canhandle(p_incarico)
             ,'canHandle on Tipo_incarico.exists_id');
   
      begin
         select 1 into d_result from tipi_incarico where incarico = p_incarico;
      exception
         when no_data_found then
            d_result := 0;
      end;
   
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on Tipo_incarico.exists_id');
   
      return d_result;
   end; -- Tipo_incarico.exists_id

   --------------------------------------------------------------------------------

   function existsid(p_incarico in tipi_incarico.incarico%type) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        existsId
       DESCRIZIONE: Esistenza riga con chiave indicata.
       NOTE:        Wrapper boolean di exists_id (cfr. exists_id).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(exists_id(p_incarico));
   begin
      return d_result;
   end; -- Tipo_incarico.existsId

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
   end; -- anagrafe_unita_organizzativa.error_message

   --------------------------------------------------------------------------------

   procedure ins
   (
      p_incarico        in tipi_incarico.incarico%type
     ,p_descrizione     in tipi_incarico.descrizione%type
     ,p_descrizione_al1 in tipi_incarico.descrizione_al1%type default null
     ,p_descrizione_al2 in tipi_incarico.descrizione_al2%type default null
     ,p_responsabile    in tipi_incarico.responsabile%type default null
     ,p_se_aspettativa  in tipi_incarico.se_aspettativa%type default null
     ,p_ordinamento     in tipi_incarico.ordinamento%type default null
     ,p_tipo_incarico   in tipi_incarico.tipo_incarico%type default null
   ) is
      /******************************************************************************
       NOME:        ins
       DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
       PARAMETRI:   Chiavi e attributi della table.
      ******************************************************************************/
   begin
   
      dbc.pre(not dbc.preon or p_descrizione is not null
             ,'p_descrizione on Tipo_incarico.ins');
      dbc.pre(not dbc.preon or p_descrizione_al1 is null or p_descrizione_al2 is null or
              p_responsabile is null or p_se_aspettativa is null or
              p_ordinamento is null or p_tipo_incarico is null or
              not existsid(p_incarico)
             ,'not existsId on Tipo_incarico.ins');
   
      insert into tipi_incarico
         (incarico
         ,descrizione
         ,descrizione_al1
         ,descrizione_al2
         ,responsabile
         ,se_aspettativa
         ,ordinamento
         ,tipo_incarico)
      values
         (p_incarico
         ,p_descrizione
         ,p_descrizione_al1
         ,p_descrizione_al2
         ,p_responsabile
         ,p_se_aspettativa
         ,p_ordinamento
         ,p_tipo_incarico);
   
   end; -- Tipo_incarico.ins

   --------------------------------------------------------------------------------

   procedure upd
   (
      p_new_incarico        in tipi_incarico.incarico%type
     ,p_new_descrizione     in tipi_incarico.descrizione%type
     ,p_new_descrizione_al1 in tipi_incarico.descrizione_al1%type
     ,p_new_descrizione_al2 in tipi_incarico.descrizione_al2%type
     ,p_new_responsabile    in tipi_incarico.responsabile%type
     ,p_new_se_aspettativa  in tipi_incarico.se_aspettativa%type
     ,p_new_ordinamento     in tipi_incarico.ordinamento%type
     ,p_new_tipo_incarico   in tipi_incarico.tipo_incarico%type default null
     ,p_old_incarico        in tipi_incarico.incarico%type default null
     ,p_old_descrizione     in tipi_incarico.descrizione%type default null
     ,p_old_descrizione_al1 in tipi_incarico.descrizione_al1%type default null
     ,p_old_descrizione_al2 in tipi_incarico.descrizione_al2%type default null
     ,p_old_responsabile    in tipi_incarico.responsabile%type default null
     ,p_old_se_aspettativa  in tipi_incarico.se_aspettativa%type default null
     ,p_old_ordinamento     in tipi_incarico.ordinamento%type default null
     ,p_old_tipo_incarico   in tipi_incarico.tipo_incarico%type default null
     ,p_check_old           in integer default 0
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
              not ((p_old_descrizione is not null or p_old_descrizione_al1 is not null or
               p_old_descrizione_al2 is not null or p_old_responsabile is not null or
               p_old_se_aspettativa is not null or p_old_ordinamento is null or
               p_old_tipo_incarico is null) and p_check_old = 0)
             ,' <OLD values> is not null on Tipo_incarico.upd');
   
      dbc.pre(not dbc.preon or p_check_old is not null
             ,'p_check_OLD is not null on Tipo_incarico.upd');
   
      d_key := pk(nvl(p_old_incarico, p_new_incarico));
   
      dbc.pre(not dbc.preon or existsid(d_key.incarico), 'existsId on Tipo_incarico.upd');
   
      update tipi_incarico
         set incarico        = p_new_incarico
            ,descrizione     = p_new_descrizione
            ,descrizione_al1 = p_new_descrizione_al1
            ,descrizione_al2 = p_new_descrizione_al2
            ,responsabile    = p_new_responsabile
            ,se_aspettativa  = p_new_se_aspettativa
            ,ordinamento     = p_new_ordinamento
            ,tipo_incarico   = p_new_tipo_incarico
       where incarico = d_key.incarico
         and (p_check_old = 0 or
             p_check_old = 1 and (descrizione = p_old_descrizione or
             descrizione is null and p_old_descrizione is null) and
             (descrizione_al1 = p_old_descrizione_al1 or
             descrizione_al1 is null and p_old_descrizione_al1 is null) and
             (descrizione_al2 = p_old_descrizione_al2 or
             descrizione_al2 is null and p_old_descrizione_al2 is null) and
             (responsabile = p_old_responsabile or
             responsabile is null and p_old_responsabile is null) and
             (se_aspettativa = p_old_se_aspettativa or
             se_aspettativa is null and p_old_se_aspettativa is null) and
             (ordinamento = p_old_ordinamento or
             ordinamento is null and p_old_ordinamento is null) and
             (tipo_incarico = p_old_tipo_incarico or
             tipo_incarico is null and p_old_tipo_incarico is null));
      d_row_found := sql%rowcount;
   
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on Tipo_incarico.upd');
   
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   
   end; -- Tipo_incarico.upd

   --------------------------------------------------------------------------------

   procedure upd_column
   (
      p_incarico      in tipi_incarico.incarico%type
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
   
      dbc.pre(not dbc.preon or existsid(p_incarico)
             ,'existsId on Tipo_incarico.upd_column');
      dbc.pre(not dbc.preon or p_column is not null
             ,'p_column is not null on Tipo_incarico.upd_column');
      dbc.pre(not dbc.preon or afc_ddl.hasattribute(s_table_name, p_column)
             ,'AFC_DDL.HasAttribute on Tipo_incarico.upd_column');
      dbc.pre(p_literal_value in (0, 1)
             ,'p_literal_value in ( 0, 1 ) on Tipo_incarico.upd_column; p_literal_value = ' ||
              p_literal_value);
   
      if p_literal_value = 1 then
         d_literal := '''';
      end if;
   
      d_statement := 'begin ' || '   update tipi_incarico' || '   set    ' || p_column ||
                     ' = ' || d_literal || p_value || d_literal ||
                     '   where  incarico = ''' || p_incarico || '''' || '   ;' || 'end;';
   
      execute immediate d_statement;
   
   end; -- Tipo_incarico.upd_column

   --------------------------------------------------------------------------------

   procedure upd_column
   (
      p_incarico in tipi_incarico.incarico%type
     ,p_column   in varchar2
     ,p_value    in date
   ) is
      /******************************************************************************
       NOME:        upd_column
       DESCRIZIONE: Aggiornamento del campo p_column col valore p_value.
       
       NOTE:        Richiama se stessa con il parametro date convertito in stringa.
      ******************************************************************************/
      d_data varchar2(19);
   begin
      d_data := to_char(p_value, 'dd/mm/yyyy hh24:mi:ss');
      upd_column(p_incarico
                ,p_column
                ,'to_date( ''' || d_data || ''', ''dd/mm/yyyy hh24:mi:ss'')'
                ,0);
   end; -- Tipo_incarico.upd_column

   --------------------------------------------------------------------------------

   procedure del
   (
      p_incarico        in tipi_incarico.incarico%type
     ,p_descrizione     in tipi_incarico.descrizione%type default null
     ,p_descrizione_al1 in tipi_incarico.descrizione_al1%type default null
     ,p_descrizione_al2 in tipi_incarico.descrizione_al2%type default null
     ,p_responsabile    in tipi_incarico.responsabile%type default null
     ,p_se_aspettativa  in tipi_incarico.se_aspettativa%type default null
     ,p_ordinamento     in tipi_incarico.ordinamento%type default null
     ,p_tipo_incarico   in tipi_incarico.tipo_incarico%type default null
     ,p_check_old       in integer default 0
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
              not ((p_descrizione is not null or p_descrizione_al1 is not null or
               p_descrizione_al2 is not null or p_responsabile is not null or
               p_se_aspettativa is not null or p_ordinamento is null or
               p_tipo_incarico is null) and p_check_old = 0)
             ,' <OLD values> is not null on Tipo_incarico.del');
   
      dbc.pre(not dbc.preon or existsid(p_incarico), 'existsId on Tipo_incarico.upd');
   
      delete from tipi_incarico
       where incarico = p_incarico
         and (p_check_old = 0 or
             p_check_old = 1 and (descrizione = p_descrizione or
             descrizione is null and p_descrizione is null) and
             (descrizione_al1 = p_descrizione_al1 or
             descrizione_al1 is null and p_descrizione_al1 is null) and
             (descrizione_al2 = p_descrizione_al2 or
             descrizione_al2 is null and p_descrizione_al2 is null) and
             (responsabile = p_responsabile or
             responsabile is null and p_responsabile is null) and
             (se_aspettativa = p_se_aspettativa or
             se_aspettativa is null and p_se_aspettativa is null) and
             (ordinamento = p_ordinamento or
             ordinamento is null and p_ordinamento is null) and
             (tipo_incarico = p_tipo_incarico or
             tipo_incarico is null and p_tipo_incarico is null));
      d_row_found := sql%rowcount;
   
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on Tipo_incarico.del');
   
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   
      dbc.post(not dbc.poston or not existsid(p_incarico)
              ,'existsId on Tipo_incarico.del');
   
   end; -- Tipo_incarico.del

   --------------------------------------------------------------------------------

   function get_descrizione(p_incarico in tipi_incarico.incarico%type)
      return tipi_incarico.descrizione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_descrizione
       DESCRIZIONE: Attributo descrizione di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     tipi_incarico.descrizione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result tipi_incarico.descrizione%type;
   begin
      select descrizione into d_result from tipi_incarico where incarico = p_incarico;
      return d_result;
   end; -- Tipo_incarico.get_descrizione

   --------------------------------------------------------------------------------

   function get_responsabile(p_incarico in tipi_incarico.incarico%type)
      return tipi_incarico.responsabile%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_responsabile
       DESCRIZIONE: Attributo responsabile di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     tipi_incarico.responsabile%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result tipi_incarico.responsabile%type;
   begin
      select responsabile into d_result from tipi_incarico where incarico = p_incarico;
      return d_result;
   end; -- Tipo_incarico.get_responsabile

   --------------------------------------------------------------------------------

   function get_se_aspettativa(p_incarico in tipi_incarico.incarico%type)
      return tipi_incarico.se_aspettativa%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_se_aspettativa
       DESCRIZIONE: Attributo se_aspettativa di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     tipi_incarico.se_aspettativa%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result tipi_incarico.se_aspettativa%type;
   begin
      select se_aspettativa into d_result from tipi_incarico where incarico = p_incarico;
      return d_result;
   end; -- Tipo_incarico.get_se_aspettativa

   --------------------------------------------------------------------------------

   function get_ordinamento(p_incarico in tipi_incarico.incarico%type)
      return tipi_incarico.ordinamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_ordinamento
       DESCRIZIONE: Attributo ordinamento di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     tipi_incarico.ordinamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result tipi_incarico.ordinamento%type;
   begin
      select ordinamento into d_result from tipi_incarico where incarico = p_incarico;
      return d_result;
   end; -- Tipo_incarico.get_ordinamento

   --------------------------------------------------------------------------------

   function get_tipo_incarico(p_incarico in tipi_incarico.incarico%type)
      return tipi_incarico.tipo_incarico%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_tipo_incarico
       DESCRIZIONE: Attributo tipo_incarico di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     tipi_incarico.tipo_incarico%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result tipi_incarico.tipo_incarico%type;
   begin
      select tipo_incarico into d_result from tipi_incarico where incarico = p_incarico;
      return d_result;
   end; -- Tipo_incarico.get_tipo_incarico

   --------------------------------------------------------------------------------

   function get_rows
   (
      p_incarico        in varchar2 default null
     ,p_descrizione     in varchar2 default null
     ,p_descrizione_al1 in varchar2 default null
     ,p_descrizione_al2 in varchar2 default null
     ,p_responsabile    in varchar2 default null
     ,p_se_aspettativa  in varchar2 default null
     ,p_ordinamento     in varchar2 default null
     ,p_tipo_incarico   in varchar2 default null
     ,p_order_condition in varchar2 default null
     ,p_qbe             in number default 0
   ) return afc.t_ref_cursor is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_rows
       DESCRIZIONE: Ritorna il risultato di una query in base ai valori che passiamo. 
       PARAMETRI:   Chiavi e attributi della table
                    p_order_condition
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
   
      d_statement := ' select * from tipi_incarico ' || ' where 1 = 1 ' ||
                     afc.get_field_condition(' and ( incarico ', p_incarico, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( descrizione '
                                            ,p_descrizione
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( descrizione_al1 '
                                            ,p_descrizione_al1
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( descrizione_al2 '
                                            ,p_descrizione_al2
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( responsabile '
                                            ,p_responsabile
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( se_aspettativa '
                                            ,p_se_aspettativa
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( ordinamento '
                                            ,p_ordinamento
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( tipo_incarico '
                                            ,p_tipo_incarico
                                            ,' )'
                                            ,p_qbe) ||
                     afc.decode_value(p_order_condition
                                     ,null
                                     ,' '
                                     ,' order by ' || p_order_condition);
   
      open d_ref_cursor for d_statement;
   
      return d_ref_cursor;
   
   end; -- Tipo_incarico.get_rows

   --------------------------------------------------------------------------------

   function count_rows
   (
      p_incarico        in varchar2 default null
     ,p_descrizione     in varchar2 default null
     ,p_descrizione_al1 in varchar2 default null
     ,p_descrizione_al2 in varchar2 default null
     ,p_responsabile    in varchar2 default null
     ,p_se_aspettativa  in varchar2 default null
     ,p_ordinamento     in varchar2 default null
     ,p_tipo_incarico   in varchar2 default null
     ,p_qbe             in number default 0
   ) return integer is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        count_rows
       DESCRIZIONE: Ritorna il numero di righe della tabella gli attributi delle quali
                    rispettano i valori indicati.
       PARAMETRI:   Almeno uno dei parametri della tabella.
                    p_QBE
       RITORNA:     Numero di righe che rispettano la selezione indicata.
      ******************************************************************************/
      d_result    integer;
      d_statement afc.t_statement;
   begin
   
      d_statement := ' select count( * ) from tipi_incarico ' || ' where 1 = 1 ' ||
                     afc.get_field_condition(' and ( incarico ', p_incarico, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( descrizione '
                                            ,p_descrizione
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( descrizione_al1 '
                                            ,p_descrizione_al1
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( descrizione_al2 '
                                            ,p_descrizione_al2
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( responsabile '
                                            ,p_responsabile
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( se_aspettativa '
                                            ,p_se_aspettativa
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( ordinamento '
                                            ,p_ordinamento
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( tipo_incarico '
                                            ,p_tipo_incarico
                                            ,' )'
                                            ,p_qbe);
   
      d_result := afc.sql_execute(d_statement);
   
      return d_result;
   end; -- Tipo_incarico.count_rows
   --------------------------------------------------------------------------------

   procedure set_fi
   (
      p_old_responsabile in tipi_incarico.responsabile%type
     ,p_new_responsabile in tipi_incarico.responsabile%type
     ,p_incarico         in tipi_incarico.responsabile%type
   ) is
      /******************************************************************************
       NOME:        set_fi.
       
       NOTE:        creata per #634, attribuzione ruoli automatici
      ******************************************************************************/
      d_progetto               ad4_ruoli.progetto%type;
      d_modulo                 ad4_ruoli.modulo%type;
      w_ruco                   ruoli_componente%rowtype;
      d_contatore              number;
      d_segnalazione           varchar2(200);
      d_segnalazione_bloccante varchar2(1);
      d_result                 afc_error.t_error_number;
   begin
      --gestione dei ruoli automatici in caso di variazione del campo RESPONSABILE dell'incarico
      for atco in (select id_componente
                         ,dal
                         ,al
                     from attributi_componente a
                    where incarico = p_incarico
                      and trunc(sysdate) between dal and nvl(al, to_date(3333333, 'j'))
                      and revisione_struttura.get_revisione_mod(a.ottica) <>
                          nvl(a.revisione_assegnazione, -2))
      loop
         componente.attribuzione_ruoli(atco.id_componente
                                      ,trunc(sysdate)
                                      ,atco.al
                                      ,3
                                      ,d_segnalazione_bloccante
                                      ,d_segnalazione);
      end loop;
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, s_error_table(d_result));
      end if;
   
   end;

--------------------------------------------------------------------------------

/*begin

   -- inserimento degli errori nella tabella
   s_error_table( s_<exception_name>_number ) := s_<exception_name>_msg;
   ...
*/
end tipo_incarico;
/

