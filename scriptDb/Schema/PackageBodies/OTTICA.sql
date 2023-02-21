CREATE OR REPLACE package body ottica is
   /******************************************************************************
    NOME:        ottica
    DESCRIZIONE: Gestione tabella ottiche.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore  Descrizione.
    000   27/06/2006  VDAVALLI  Prima emissione.
    001   04/09/2009  VDAVALLI  Modifiche per configurazione master/slave
    002   01/08/2011  MMONARI   Modifiche per ottiche non istituzionali derivate
   ******************************************************************************/

   s_revisione_body constant afc.t_revision := '002';

   s_table_name       constant afc.t_object_name := 'ottiche';
   s_desc_column_name constant afc.t_object_name := 'descrizione';

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
   end; -- ottica.versione

   --------------------------------------------------------------------------------

   function pk(p_ottica in ottiche.ottica%type) return t_pk is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        PK
       DESCRIZIONE: Costruttore di un t_PK dati gli attributi della chiave
      ******************************************************************************/
      d_result t_pk;
   begin

      d_result.ottica := p_ottica;
      dbc.pre(not dbc.preon or canhandle(d_result.ottica), 'canHandle on ottica.PK');
      return d_result;

   end; -- end ottica.PK

   --------------------------------------------------------------------------------

   function can_handle(p_ottica in ottiche.ottica%type) return number is
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
      if d_result = 1 and (p_ottica is null) then
         d_result := 0;
      end if;

      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on ottica.can_handle');

      return d_result;

   end; -- ottica.can_handle

   --------------------------------------------------------------------------------

   function canhandle(p_ottica in ottiche.ottica%type) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        canHandle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: true se la chiave è manipolabile, false altrimenti.
       NOTE:        Wrapper boolean di can_handle (cfr. can_handle).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(can_handle(p_ottica));
   begin
      return d_result;
   end; -- ottica.canHandle

   --------------------------------------------------------------------------------

   function exists_id(p_ottica in ottiche.ottica%type) return number is
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

      dbc.pre(not dbc.preon or canhandle(p_ottica), 'canHandle on ottica.exists_id');

      begin
         select 1 into d_result from ottiche where ottica = p_ottica;
      exception
         when no_data_found then
            d_result := 0;
      end;

      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on ottica.exists_id');

      return d_result;
   end; -- ottica.exists_id

   --------------------------------------------------------------------------------

   function existsid(p_ottica in ottiche.ottica%type) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        existsId
       DESCRIZIONE: Esistenza riga con chiave indicata.
       NOTE:        Wrapper boolean di exists_id (cfr. exists_id).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(exists_id(p_ottica));
   begin
      return d_result;
   end; -- ottica.existsId

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

      return d_result;
   end error_message; -- ottica.error_message

   --------------------------------------------------------------------------------

   procedure ins
   (
      p_ottica                   in ottiche.ottica%type
     ,p_descrizione              in ottiche.descrizione%type
     ,p_descrizione_al1          in ottiche.descrizione_al1%type default null
     ,p_descrizione_al2          in ottiche.descrizione_al2%type default null
     ,p_nota                     in ottiche.nota%type default null
     ,p_amministrazione          in ottiche.amministrazione%type default null
     ,p_ottica_istituzionale     in ottiche.ottica_istituzionale%type default null
     ,p_gestione_revisioni       in ottiche.gestione_revisioni%type default null
     ,p_ottica_origine           in ottiche.ottica_origine%type default null
     ,p_aggiornamento_componenti in ottiche.aggiornamento_componenti%type default null
     ,p_utente_aggiornamento     in ottiche.utente_aggiornamento%type default null
     ,p_data_aggiornamento       in ottiche.data_aggiornamento%type default null
   ) is
      /******************************************************************************
       NOME:        ins
       DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
       PARAMETRI:   Chiavi e attributi della table.
      ******************************************************************************/
   begin

      dbc.pre(not dbc.preon or p_ottica is not null, 'p_ottica on ottica.ins');

      dbc.pre(not dbc.preon or p_descrizione is not null, 'p_descrizione on ottica.ins');

      dbc.pre(not dbc.preon or not existsid(p_ottica), 'not existsId on ottica.ins');

      insert into ottiche
         (ottica
         ,descrizione
         ,descrizione_al1
         ,descrizione_al2
         ,nota
         ,amministrazione
         ,ottica_istituzionale
         ,gestione_revisioni
         ,ottica_origine
         ,aggiornamento_componenti
         ,utente_aggiornamento
         ,data_aggiornamento)
      values
         (p_ottica
         ,p_descrizione
         ,p_descrizione_al1
         ,p_descrizione_al2
         ,p_nota
         ,p_amministrazione
         ,p_ottica_istituzionale
         ,p_gestione_revisioni
         ,p_ottica_origine
         ,p_aggiornamento_componenti
         ,p_utente_aggiornamento
         ,p_data_aggiornamento);

   end; -- ottica.ins

   --------------------------------------------------------------------------------

   procedure upd
   (
      p_new_ottica                   in ottiche.ottica%type
     ,p_new_descrizione              in ottiche.descrizione%type
     ,p_new_descrizione_al1          in ottiche.descrizione_al1%type
     ,p_new_descrizione_al2          in ottiche.descrizione_al2%type
     ,p_new_nota                     in ottiche.nota%type
     ,p_new_amministrazione          in ottiche.amministrazione%type
     ,p_new_ottica_istituzionale     in ottiche.ottica_istituzionale%type default null
     ,p_new_gestione_revisioni       in ottiche.gestione_revisioni%type
     ,p_new_ottica_origine           in ottiche.ottica_origine%type default null
     ,p_new_aggiornamento_componenti in ottiche.aggiornamento_componenti%type default null
     ,p_new_utente_aggiornamento     in ottiche.utente_aggiornamento%type
     ,p_new_data_aggiornamento       in ottiche.data_aggiornamento%type
     ,p_old_ottica                   in ottiche.ottica%type default null
     ,p_old_descrizione              in ottiche.descrizione%type default null
     ,p_old_descrizione_al1          in ottiche.descrizione_al1%type default null
     ,p_old_descrizione_al2          in ottiche.descrizione_al2%type default null
     ,p_old_nota                     in ottiche.nota%type default null
     ,p_old_amministrazione          in ottiche.amministrazione%type default null
     ,p_old_ottica_istituzionale     in ottiche.ottica_istituzionale%type default null
     ,p_old_gestione_revisioni       in ottiche.gestione_revisioni%type default null
     ,p_old_ottica_origine           in ottiche.ottica_origine%type default null
     ,p_old_aggiornamento_componenti in ottiche.aggiornamento_componenti%type default null
     ,p_old_utente_aggiornamento     in ottiche.utente_aggiornamento%type default null
     ,p_old_data_aggiornamento       in ottiche.data_aggiornamento%type default null
     ,p_check_old                    in integer default 0
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
               ((p_old_descrizione is not null or p_old_descrizione_al1 is not null or
               p_old_descrizione_al2 is not null or p_old_nota is not null or
               p_old_amministrazione is not null or
               p_old_ottica_istituzionale is not null or
               p_old_gestione_revisioni is not null or p_old_ottica_origine is not null or
               p_old_aggiornamento_componenti is not null or
               p_old_utente_aggiornamento is not null or
               p_old_data_aggiornamento is not null) and p_check_old = 0)
             ,' <OLD values> is not null on ottica.upd');

      dbc.pre(not dbc.preon or p_check_old is not null
             ,'p_check_OLD is not null on ottica.upd');

      d_key := pk(nvl(p_old_ottica, p_new_ottica));

      dbc.pre(not dbc.preon or existsid(d_key.ottica), 'existsId on ottica.upd');

      update ottiche
         set ottica                   = p_new_ottica
            ,descrizione              = p_new_descrizione
            ,descrizione_al1          = p_new_descrizione_al1
            ,descrizione_al2          = p_new_descrizione_al2
            ,nota                     = p_new_nota
            ,amministrazione          = p_new_amministrazione
            ,ottica_istituzionale     = p_new_ottica_istituzionale
            ,gestione_revisioni       = p_new_gestione_revisioni
            ,ottica_origine           = p_new_ottica_origine
            ,aggiornamento_componenti = p_new_aggiornamento_componenti
            ,utente_aggiornamento     = p_new_utente_aggiornamento
            ,data_aggiornamento       = p_new_data_aggiornamento
       where ottica = d_key.ottica
         and (p_check_old = 0 or
             p_check_old = 1 and (descrizione = p_old_descrizione or
             descrizione is null and p_old_descrizione is null) and
             (descrizione_al1 = p_old_descrizione_al1 or
             descrizione_al1 is null and p_old_descrizione_al1 is null) and
             (descrizione_al2 = p_old_descrizione_al2 or
             descrizione_al2 is null and p_old_descrizione_al2 is null) and
             (nota = p_old_nota or nota is null and p_old_nota is null) and
             (amministrazione = p_old_amministrazione or
             amministrazione is null and p_old_amministrazione is null) and
             (ottica_istituzionale = p_old_ottica_istituzionale or
             ottica_istituzionale is null and p_old_ottica_istituzionale is null) and
             (gestione_revisioni = p_old_gestione_revisioni or
             gestione_revisioni is null and p_old_gestione_revisioni is null) and
             (ottica_origine = p_old_ottica_origine or
             ottica_origine is null and p_old_ottica_origine is null) and
             (aggiornamento_componenti = p_old_aggiornamento_componenti or
             aggiornamento_componenti is null and
             p_old_aggiornamento_componenti is null) and
             (utente_aggiornamento = p_old_utente_aggiornamento or
             utente_aggiornamento is null and p_old_utente_aggiornamento is null) and
             (data_aggiornamento = p_old_data_aggiornamento or
             data_aggiornamento is null and p_old_data_aggiornamento is null));
      d_row_found := sql%rowcount;

      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on ottica.upd');

      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;

   end; -- ottica.upd

   --------------------------------------------------------------------------------

   procedure upd_column
   (
      p_ottica        in ottiche.ottica%type
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

      dbc.pre(not dbc.preon or existsid(p_ottica), 'existsId on ottica.upd_column');
      dbc.pre(not dbc.preon or p_column is not null
             ,'p_column is not null on ottica.upd_column');
      dbc.pre(not dbc.preon or afc_ddl.hasattribute(s_table_name, p_column)
             ,'AFC_DDL.HasAttribute on ottica.upd_column');
      dbc.pre(p_literal_value in (0, 1)
             ,'p_literal_value in ( 0, 1 ) on ottica.upd_column; p_literal_value = ' ||
              p_literal_value);

      if p_literal_value = 1 then
         d_literal := '''';
      end if;

      d_statement := 'begin ' || '   update ottiche' || '   set    ' || p_column || ' = ' ||
                     d_literal || p_value || d_literal || '   where  ottica = ''' ||
                     p_ottica || '''' || '   ;' || 'end;';

      execute immediate d_statement;

   end; -- ottica.upd_column

   --------------------------------------------------------------------------------

   procedure upd_column
   (
      p_ottica in ottiche.ottica%type
     ,p_column in varchar2
     ,p_value  in date
   ) is
      /******************************************************************************
       NOME:        upd_column
       DESCRIZIONE: Aggiornamento del campo p_column col valore p_value.

       NOTE:        Richiama se stessa con il parametro date convertito in stringa.
      ******************************************************************************/
      d_data varchar2(19);
   begin
      d_data := to_char(p_value, 'dd/mm/yyyy hh24:mi:ss');
      upd_column(p_ottica
                ,p_column
                ,'to_date( ''' || d_data || ''', ''dd/mm/yyyy hh24:mi:ss'')'
                ,0);
   end; -- ottica.upd_column

   --------------------------------------------------------------------------------

   procedure del
   (
      p_ottica                   in ottiche.ottica%type
     ,p_descrizione              in ottiche.descrizione%type
     ,p_descrizione_al1          in ottiche.descrizione_al1%type default null
     ,p_descrizione_al2          in ottiche.descrizione_al2%type default null
     ,p_nota                     in ottiche.nota%type default null
     ,p_amministrazione          in ottiche.amministrazione%type default null
     ,p_ottica_istituzionale     in ottiche.ottica_istituzionale%type default null
     ,p_gestione_revisioni       in ottiche.gestione_revisioni%type default null
     ,p_ottica_origine           in ottiche.ottica_origine%type default null
     ,p_aggiornamento_componenti in ottiche.aggiornamento_componenti%type default null
     ,p_utente_aggiornamento     in ottiche.utente_aggiornamento%type default null
     ,p_data_aggiornamento       in ottiche.data_aggiornamento%type default null
     ,p_check_old                in integer default 0
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
              not
               ((p_descrizione is not null or p_descrizione_al1 is not null or
               p_descrizione_al2 is not null or p_nota is not null or
               p_amministrazione is not null or p_ottica_istituzionale is not null or
               p_ottica_origine is not null or p_aggiornamento_componenti is not null or
               p_gestione_revisioni is not null or p_utente_aggiornamento is not null or
               p_data_aggiornamento is not null) and p_check_old = 0)
             ,' <OLD values> is not null on ottica.del');

      dbc.pre(not dbc.preon or existsid(p_ottica), 'existsId on ottica.upd');

      delete from ottiche
       where ottica = p_ottica
         and (p_check_old = 0 or
             p_check_old = 1 and (descrizione = p_descrizione or
             descrizione is null and p_descrizione is null) and
             (descrizione_al1 = p_descrizione_al1 or
             descrizione_al1 is null and p_descrizione_al1 is null) and
             (descrizione_al2 = p_descrizione_al2 or
             descrizione_al2 is null and p_descrizione_al2 is null) and
             (nota = p_nota or nota is null and p_nota is null) and
             (amministrazione = p_amministrazione or
             amministrazione is null and p_amministrazione is null) and
             (ottica_istituzionale = p_ottica_istituzionale or
             ottica_istituzionale is null and p_ottica_istituzionale is null) and
             (gestione_revisioni = p_gestione_revisioni or
             gestione_revisioni is null and p_gestione_revisioni is null) and
             (ottica_origine = p_ottica_origine or
             ottica_origine is null and p_ottica_origine is null) and
             (aggiornamento_componenti = p_aggiornamento_componenti or
             aggiornamento_componenti is null and p_aggiornamento_componenti is null) and
             (utente_aggiornamento = p_utente_aggiornamento or
             utente_aggiornamento is null and p_utente_aggiornamento is null) and
             (data_aggiornamento = p_data_aggiornamento or
             data_aggiornamento is null and p_data_aggiornamento is null));
      d_row_found := sql%rowcount;

      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on ottica.del');

      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;

      dbc.post(not dbc.poston or not existsid(p_ottica), 'existsId on ottica.del');

   end; -- ottica.del

   --------------------------------------------------------------------------------

   function get_descrizione(p_ottica in ottiche.ottica%type) return ottiche.descrizione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_Descrizione
       DESCRIZIONE: Attributo Descrizione di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ottiche.Descrizione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ottiche.descrizione%type;
   begin

      dbc.pre(not dbc.preon or existsid(p_ottica), 'existsId on ottica.get_Descrizione');

      select descrizione into d_result from ottiche where ottica = p_ottica;

      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on ottica.get_descrizione');
      return d_result;
   end; -- ottica.get_Descrizione

   --------------------------------------------------------------------------------

   function get_nota(p_ottica in ottiche.ottica%type) return ottiche.nota%type is
      /* SLAVE_COPY */
      /******************************************************************************
      NOME:        get_nota
      DESCRIZIONE: Attributo nota di riga esistente identificata dlla PK.
      PARAMETRI:   d_key: chiave.
      RITORNA:     ottiche.nota%type.
      NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ottiche.nota%type;
   begin

      dbc.pre(not dbc.preon or existsid(p_ottica), 'existsId on ottica.get_nota');

      select nota into d_result from ottiche where ottica = p_ottica;

      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on ottica.get_nota');
      return d_result;
   end; -- ottica.get_nota

   --------------------------------------------------------------------------------

   function get_amministrazione(p_ottica in ottiche.ottica%type)
      return ottiche.amministrazione%type is
      /* SLAVE_COPY */
      /******************************************************************************
      NOME:        get_amministrazione
      DESCRIZIONE: Attributo amministrazione di riga esistente identificata dlla PK.
      PARAMETRI:   d_key: chiave.
      RITORNA:     ottiche.amministrazione%type.
      NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ottiche.amministrazione%type;
   begin

      dbc.pre(not dbc.preon or existsid(p_ottica)
             ,'existsId on ottica.get_amministrazione');

      select amministrazione into d_result from ottiche where ottica = p_ottica;

      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on ottica.get_amministrazione');
      return d_result;
   end; -- ottica.get_amministrazione

   --------------------------------------------------------------------------------

   function get_ottica_origine(p_ottica in ottiche.ottica%type)
      return ottiche.ottica_origine%type is
      /* SLAVE_COPY */
      /******************************************************************************
      NOME:        get_ottica_origine
      DESCRIZIONE: Attributo ottica_origine di riga esistente identificata dlla PK.
      PARAMETRI:   d_key: chiave.
      RITORNA:     ottiche.ottica_origine%type.
      NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ottiche.ottica_origine%type;
   begin

      dbc.pre(not dbc.preon or existsid(p_ottica)
             ,'existsId on ottica.get_ottica_origine');

      select ottica_origine into d_result from ottiche where ottica = p_ottica;

      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on ottica.get_ottica_origine');
      return d_result;
   end; -- ottica.get_ottica_origine

   --------------------------------------------------------------------------------

   function get_aggiornamento_componenti(p_ottica in ottiche.ottica%type)
      return ottiche.aggiornamento_componenti%type is
      /* SLAVE_COPY */
      /******************************************************************************
      NOME:        get_aggiornamento_componenti
      DESCRIZIONE: Attributo aggiornamento_componenti di riga esistente identificata dlla PK.
      PARAMETRI:   d_key: chiave.
      RITORNA:     ottiche.aggiornamento_componenti%type.
      NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ottiche.aggiornamento_componenti%type;
   begin

      dbc.pre(not dbc.preon or existsid(p_ottica)
             ,'existsId on ottica.get_aggiornamento_componenti');

      select aggiornamento_componenti into d_result from ottiche where ottica = p_ottica;

      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on ottica.get_aggiornamento_componenti');
      return d_result;
   end; -- ottica.get_aggiornamento_componenti

   --------------------------------------------------------------------------------

   function get_ottica_istituzionale(p_ottica in ottiche.ottica%type)
      return ottiche.ottica_istituzionale%type is
      /* SLAVE_COPY */
      /******************************************************************************
      NOME:        get_ottica_istituzionale
      DESCRIZIONE: Attributo ottica_istituzionale di riga esistente identificata dlla PK.
      PARAMETRI:   d_key: chiave.
      RITORNA:     ottiche.ottica_istituzionale%type.
      NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ottiche.ottica_istituzionale%type;
   begin

      dbc.pre(not dbc.preon or existsid(p_ottica)
             ,'existsId on ottica.get_ottica_istituzionale');

      select ottica_istituzionale into d_result from ottiche where ottica = p_ottica;

      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on ottica.get_ottica_istituzionale');
      return d_result;
   end; -- ottica.get_ottica_istituzionale

   --------------------------------------------------------------------------------

   function get_gestione_revisioni(p_ottica in ottiche.ottica%type)
      return ottiche.gestione_revisioni%type is
      /* SLAVE_COPY */
      /******************************************************************************
      NOME:        get_gestione_revisioni
      DESCRIZIONE: Attributo gestione_revisioni di riga esistente identificata dlla PK.
      PARAMETRI:   d_key: chiave.
      RITORNA:     ottiche.gestione_revisioni%type.
      NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ottiche.gestione_revisioni%type;
   begin

      dbc.pre(not dbc.preon or existsid(p_ottica)
             ,'existsId on ottica.get_gestione_revisioni');

      select gestione_revisioni into d_result from ottiche where ottica = p_ottica;

      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on ottica.get_gestione_revisioni');
      return d_result;
   end; -- ottica.get_gestione_revisioni

   --------------------------------------------------------------------------------

   function get_utente_aggiornamento(p_ottica in ottiche.ottica%type)
      return ottiche.utente_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
      NOME:        get_utente_aggiornamento
      DESCRIZIONE: Attributo utente_aggiornamento di riga esistente identificata dlla PK.
      PARAMETRI:   d_key: chiave.
      RITORNA:     ottiche.utente_aggiornamento%type.
      NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ottiche.utente_aggiornamento%type;
   begin

      dbc.pre(not dbc.preon or existsid(p_ottica)
             ,'existsId on ottica.get_utente_aggiornamento');

      select utente_aggiornamento into d_result from ottiche where ottica = p_ottica;

      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on ottica.get_utente_aggiornamento');
      return d_result;
   end; -- ottica.get_utente_aggiornamento

   --------------------------------------------------------------------------------

   function get_data_aggiornamento(p_ottica in ottiche.ottica%type)
      return ottiche.data_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
      NOME:        get_data_aggiornamento
      DESCRIZIONE: Attributo data_aggiornamento di riga esistente identificata dlla PK.
      PARAMETRI:   d_key: chiave.
      RITORNA:     ottiche.data_aggiornamento%type.
      NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ottiche.data_aggiornamento%type;
   begin

      dbc.pre(not dbc.preon or existsid(p_ottica)
             ,'existsId on ottica.get_data_aggiornamento');

      select data_aggiornamento into d_result from ottiche where ottica = p_ottica;

      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on ottica.get_data_aggiornamento');
      return d_result;
   end; -- ottica.get_data_aggiornamento

   --------------------------------------------------------------------------------

   function get_ottica_per_amm(p_amministrazione in ottiche.amministrazione%type)
      return ottiche.ottica%type is
      /* SLAVE_COPY */
      /******************************************************************************
      NOME:        get_ottica_per_amm
      DESCRIZIONE: Restituisce l'ottica istituzionale associata all'amministrazione
      PARAMETRI:   Amministrazione
      RITORNA:     ottiche.ottica%type.
      NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result ottiche.ottica%type;
   begin
      select ottica
        into d_result
        from ottiche
       where amministrazione = p_amministrazione
         and ottica_istituzionale = 'SI';
      return d_result;
   end; -- ottica.get_ottica_amm

   --------------------------------------------------------------------------------

   function get_rows
   (
      p_ottica                   in ottiche.ottica%type default null
     ,p_descrizione              in ottiche.descrizione%type
     ,p_descrizione_al1          in ottiche.descrizione_al1%type default null
     ,p_descrizione_al2          in ottiche.descrizione_al2%type default null
     ,p_nota                     in ottiche.nota%type default null
     ,p_amministrazione          in ottiche.amministrazione%type default null
     ,p_ottica_istituzionale     in ottiche.ottica_istituzionale%type default null
     ,p_gestione_revisioni       in ottiche.gestione_revisioni%type default null
     ,p_ottica_origine           in ottiche.ottica_origine%type default null
     ,p_aggiornamento_componenti in ottiche.aggiornamento_componenti%type default null
     ,p_utente_aggiornamento     in ottiche.utente_aggiornamento%type default null
     ,p_data_aggiornamento       in ottiche.data_aggiornamento%type default null
     ,p_order_condition          in varchar2 default null
     ,p_qbe                      in number default 0
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

      d_statement := ' select * from ottiche ' || ' where 1 = 1 ' ||
                     afc.get_field_condition(' and ( ottica ', p_ottica, ' )', p_qbe) ||
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
                     afc.get_field_condition(' and ( nota ', p_nota, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( amministrazione '
                                            ,p_amministrazione
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( ottica_istituzionale '
                                            ,p_ottica_istituzionale
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( gestione_revisioni '
                                            ,p_gestione_revisioni
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( ottica_origine '
                                            ,p_ottica_origine
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( aggiornamento_componenti '
                                            ,p_aggiornamento_componenti
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( utente_aggiornamento '
                                            ,p_utente_aggiornamento
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( data_aggiornamento '
                                            ,p_data_aggiornamento
                                            ,' )'
                                            ,p_qbe) ||
                     afc.decode_value(p_order_condition
                                     ,null
                                     ,' '
                                     ,' order by ' || p_order_condition);

      open d_ref_cursor for d_statement;

      return d_ref_cursor;

   end; -- ottica.get_rows

   --------------------------------------------------------------------------------

   function count_rows
   (
      p_ottica                   in ottiche.ottica%type default null
     ,p_descrizione              in ottiche.descrizione%type default null
     ,p_descrizione_al1          in ottiche.descrizione_al1%type default null
     ,p_descrizione_al2          in ottiche.descrizione_al2%type default null
     ,p_nota                     in ottiche.nota%type default null
     ,p_amministrazione          in ottiche.amministrazione%type default null
     ,p_ottica_istituzionale     in ottiche.ottica_istituzionale%type default null
     ,p_gestione_revisioni       in ottiche.gestione_revisioni%type default null
     ,p_ottica_origine           in ottiche.ottica_origine%type default null
     ,p_aggiornamento_componenti in ottiche.aggiornamento_componenti%type default null
     ,p_utente_aggiornamento     in ottiche.utente_aggiornamento%type default null
     ,p_data_aggiornamento       in ottiche.data_aggiornamento%type default null
     ,p_qbe                      in number default 0
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

      d_statement := ' select count( * ) from ottiche ' || ' where 1 = 1 ' ||
                     afc.get_field_condition(' and ( ottica ', p_ottica, ' )', p_qbe) ||
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
                     afc.get_field_condition(' and ( nota ', p_nota, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( amministrazione '
                                            ,p_amministrazione
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( ottica_istituzionale '
                                            ,p_ottica_istituzionale
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( gestione_revisioni '
                                            ,p_gestione_revisioni
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( ottica_origine '
                                            ,p_ottica_origine
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( aggiornamento_componenti '
                                            ,p_aggiornamento_componenti
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( utente_aggiornamento '
                                            ,p_utente_aggiornamento
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( data_aggiornamento '
                                            ,p_data_aggiornamento
                                            ,' )'
                                            ,p_qbe);

      d_result := afc.sql_execute(d_statement);

      return d_result;
   end; -- ottica.count_rows

   --------------------------------------------------------------------------------

   function is_ottica_istituzionale(p_ottica in ottiche.ottica%type)
      return afc_error.t_error_number is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        is_ottica_istituzionale.
       DESCRIZIONE: verifica che l'ottica passata sia istituzionale

       PARAMETRI:   p_ottica

       RETURN:      1 se tutti i controlli danno esito positivo, l'error_code altrimenti
       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number;

   begin
      select decode(ottica_istituzionale, 'SI', afc_error.ok, 0)
        into d_result
        from ottiche
       where ottica = p_ottica;
      --
      return d_result;
   end; -- ottica.is_ottica_istituzionale

   --------------------------------------------------------------------------------

   function is_codice_ottica_ok
   (
      p_ottica          in ottiche.ottica%type
     ,p_amministrazione in ottiche.amministrazione%type
   ) return afc_error.t_error_number
   /******************************************************************************
       NOME:        is_codice_ottica_ok.
       DESCRIZIONE: gestione della Referential Integrity:

       PARAMETRI:   p_amministrazione

       NOTE:        --
      ******************************************************************************/
    is
      d_ente   amministrazioni.ente%type;
      d_result afc_error.t_error_number := afc_error.ok;
   begin
      d_ente := amministrazione.get_ente(p_amministrazione);
      if d_ente = 'SI' and p_ottica like 'E/%' then
         d_result := s_codice_errato_number;
      end if;

      return d_result;

   end; -- ottica.is_codice_ottica_ok

   --------------------------------------------------------------------------------

   function is_ottica_origine_ok
   (
      p_ottica_origine  in ottiche.ottica_origine%type
     ,p_amministrazione in ottiche.amministrazione%type
   ) return afc_error.t_error_number
   /******************************************************************************
       NOME:        is_ottica_origine_ok.
       DESCRIZIONE: gestione della correttezza dell'otica origine selezionata

       PARAMETRI:   p_amministrazione
                    p_ottica_origine

       NOTE:        --
      ******************************************************************************/
    is
      d_amministrazione  amministrazioni.ente%type;
      d_revisione_attiva number := '';
      d_result           afc_error.t_error_number := afc_error.ok;
   begin

      d_revisione_attiva := revisione_struttura.get_revisione_mod(p_ottica_origine);
      d_amministrazione  := ottica.get_amministrazione(p_ottica_origine);

      if d_revisione_attiva = -1 or d_amministrazione <> p_amministrazione then
         d_result := s_ott_origine_errata_number;
      end if;

      return d_result;

   end; -- ottica.is_ottica_origine_ok

   --------------------------------------------------------------------------------

   function is_gestione_revisioni_ok
   (
      p_ottica_istituzionale in ottiche.ottica_istituzionale%type
     ,p_gestione_revisioni   in ottiche.gestione_revisioni%type
   ) return afc_error.t_error_number
   /******************************************************************************
       NOME:        is_gestione_revisioni_ok.
       DESCRIZIONE: gestione della Referential Integrity:

       PARAMETRI:   p_amministrazione

       NOTE:        --
      ******************************************************************************/
    is
      d_result afc_error.t_error_number := afc_error.ok;
   begin
      if p_ottica_istituzionale = 'SI' and p_gestione_revisioni = 'NO' then
         d_result := s_ott_ist_errata_number;
      end if;

      return d_result;

   end; -- ottica.is_gestione_revisioni_ok

   --------------------------------------------------------------------------------

   function is_di_ok
   (
      p_ottica               in ottiche.ottica%type
     ,p_amministrazione      in ottiche.amministrazione%type
     ,p_ottica_istituzionale in ottiche.ottica_istituzionale%type
     ,p_gestione_revisioni   in ottiche.gestione_revisioni%type
   ) return afc_error.t_error_number
   /******************************************************************************
       NOME:        is_DI_ok.
       DESCRIZIONE: gestione della Data Integrity:

       PARAMETRI:   p_amministrazione

       NOTE:        --
      ******************************************************************************/
    is
      d_result afc_error.t_error_number := afc_error.ok;
   begin
      d_result := is_codice_ottica_ok(p_ottica, p_amministrazione);
      --
      if d_result = afc_error.ok then
         d_result := is_gestione_revisioni_ok(p_ottica_istituzionale
                                             ,p_gestione_revisioni);
      end if;
      --
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on amministrazione.is_RI_ok');

      return d_result;

   end; -- ottica.is_DI_ok

   --------------------------------------------------------------------------------

   procedure chk_di
   (
      p_ottica               in ottiche.ottica%type
     ,p_amministrazione      in ottiche.amministrazione%type
     ,p_ottica_istituzionale in ottiche.ottica_istituzionale%type
     ,p_gestione_revisioni   in ottiche.gestione_revisioni%type
   ) is
      /******************************************************************************
       NOME:        chk_DI.
       DESCRIZIONE: gestione della Data Integrity:

       PARAMETRI:   p_amministrazione

       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin

      d_result := is_di_ok(p_ottica
                          ,p_amministrazione
                          ,p_ottica_istituzionale
                          ,p_gestione_revisioni);

      dbc.assertion(not dbc.assertionon or d_result = afc_error.ok or d_result < 0
                   ,'d_result = AFC_Error.ok or d_result < 0 on amministrazione.chk_RI');

      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, s_error_table(d_result));
      end if;

   end; -- ottica.chk_DI

   --------------------------------------------------------------------------------

   function is_ottica_istituzionale_ok
   (
      p_ottica          in ottiche.ottica%type
     ,p_amministrazione in ottiche.amministrazione%type
   ) return afc_error.t_error_number
   /******************************************************************************
       NOME:        is_ottica_istituzionale_ok.
       DESCRIZIONE: verifica la presenza di una sola ottica istituzionale per
                    l'amministrazione indicata

       PARAMETRI:   p_amministrazione

       RETURN:      1 se tutti i controlli danno esito positivo, l'error_code altrimenti
       NOTE:        --
      ******************************************************************************/
    is
      d_result    afc_error.t_error_number := afc_error.ok;
      d_contatore number;
   begin

      select count(*)
        into d_contatore
        from ottiche
       where amministrazione = p_amministrazione
         and ottica_istituzionale = 'SI'
         and ottica != p_ottica;

      if d_contatore > 0 then
         d_result := s_ott_ist_multiple_number;
      else
         d_result := afc_error.ok;
      end if;
      --
      return d_result;
   end; -- ottica.is_ottica_istituzionale_ok

   --------------------------------------------------------------------------------

   function is_ri_ok
   (
      p_ottica          in ottiche.ottica%type
     ,p_amministrazione in ottiche.amministrazione%type
   ) return afc_error.t_error_number
   /******************************************************************************
       NOME:        is_RI_ok.
       DESCRIZIONE: gestione della Referential Integrity:

       PARAMETRI:   p_ottica
                    p_amministrazione

       NOTE:        --
      ******************************************************************************/
    is
      d_result afc_error.t_error_number := afc_error.ok;
   begin
      d_result := is_ottica_istituzionale_ok(p_ottica, p_amministrazione);

      return d_result;

   end; -- ottica.is_RI_ok

   --------------------------------------------------------------------------------

   procedure chk_ri
   (
      p_ottica          in ottiche.ottica%type
     ,p_amministrazione in ottiche.amministrazione%type
   ) is
      /******************************************************************************
       NOME:        chk_RI.
       DESCRIZIONE: gestione della Referential Integrity:

       PARAMETRI:   p_ottica
                    p_amministrazione

       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin

      d_result := is_ri_ok(p_ottica, p_amministrazione);

      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, s_error_table(d_result));
      end if;

   end; -- ottica.chk_DI

--------------------------------------------------------------------------------

begin

   -- inserimento degli errori nella tabella
   s_error_table(s_ott_ist_multiple_number) := s_ott_ist_multiple_msg;
   s_error_table(s_ott_ist_mancante_number) := s_ott_ist_mancante_msg;
   s_error_table(s_ott_ist_errata_number) := s_ott_ist_errata_msg;
   s_error_table(s_codice_errato_number) := s_codice_errato_msg;

end ottica;
/

