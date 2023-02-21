CREATE OR REPLACE package body suddivisione_struttura is
   /******************************************************************************
    NOME:        suddivisione_struttura
    DESCRIZIONE: Gestione tabella suddivisioni_struttura.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore     Descrizione.
    000   28/06/2006  VDAVALLI   Prima emissione.
    001   04/09/2009  VDAVALLI   Modifiche per configurazione master/slave
    002   29/04/2010  APASSUELLO Aggiunta funzione get_ordinamento
    003   01/08/2011  MMONARI    Aggiunta procedura duplica_suddivisioni
    004   05/10/2012  VDAVALLI   Aggiunta funzione get_id_suddivisione
   ******************************************************************************/

   s_revisione_body constant afc.t_revision := '004';

   s_table_name       constant afc.t_object_name := 'suddivisioni_struttura';
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
   end; -- suddivisione_struttura.versione

   --------------------------------------------------------------------------------

   function pk(p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type) return t_pk is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        PK
       DESCRIZIONE: Costruttore di un t_PK dati gli attributi della chiave
      ******************************************************************************/
      d_result t_pk;
   begin
   
      d_result.id_suddivisione := p_id_suddivisione;
      dbc.pre(not dbc.preon or canhandle(d_result.id_suddivisione)
             ,'canHandle on suddivisione_struttura.PK');
      return d_result;
   
   end; -- end suddivisione_struttura.PK

   --------------------------------------------------------------------------------

   function can_handle(p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type)
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
      if d_result = 1 and (p_id_suddivisione is null) then
         d_result := 0;
      end if;
   
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on suddivisione_struttura.can_handle');
   
      return d_result;
   
   end; -- suddivisione_struttura.can_handle

   --------------------------------------------------------------------------------

   function canhandle(p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type)
      return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        canHandle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: true se la chiave è manipolabile, false altrimenti.
       NOTE:        Wrapper boolean di can_handle (cfr. can_handle).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(can_handle(p_id_suddivisione));
   begin
      return d_result;
   end; -- suddivisione_struttura.canHandle

   --------------------------------------------------------------------------------

   function exists_id(p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type)
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
   
      dbc.pre(not dbc.preon or canhandle(p_id_suddivisione)
             ,'canHandle on suddivisione_struttura.exists_id');
   
      begin
         select 1
           into d_result
           from suddivisioni_struttura
          where id_suddivisione = p_id_suddivisione;
      exception
         when no_data_found then
            d_result := 0;
      end;
   
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on suddivisione_struttura.exists_id');
   
      return d_result;
   end; -- suddivisione_struttura.exists_id

   --------------------------------------------------------------------------------

   function existsid(p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type)
      return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        existsId
       DESCRIZIONE: Esistenza riga con chiave indicata.
       NOTE:        Wrapper boolean di exists_id (cfr. exists_id).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(exists_id(p_id_suddivisione));
   begin
      return d_result;
   end; -- suddivisione_struttura.existsId

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
      p_id_suddivisione      in suddivisioni_struttura.id_suddivisione%type default null
     ,p_ottica               in suddivisioni_struttura.ottica%type
     ,p_suddivisione         in suddivisioni_struttura.suddivisione%type
     ,p_descrizione          in suddivisioni_struttura.descrizione%type
     ,p_descrizione_al1      in suddivisioni_struttura.descrizione_al1%type default null
     ,p_descrizione_al2      in suddivisioni_struttura.descrizione_al2%type default null
     ,p_des_abb              in suddivisioni_struttura.des_abb%type default null
     ,p_des_abb_al1          in suddivisioni_struttura.des_abb_al1%type default null
     ,p_des_abb_al2          in suddivisioni_struttura.des_abb_al2%type default null
     ,p_icona_standard       in suddivisioni_struttura.icona_standard%type default null
     ,p_icona_modifica       in suddivisioni_struttura.icona_modifica%type default null
     ,p_icona_eliminazione   in suddivisioni_struttura.icona_eliminazione%type default null
     ,p_nota                 in suddivisioni_struttura.nota%type default null
     ,p_utente_aggiornamento in suddivisioni_struttura.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in suddivisioni_struttura.data_aggiornamento%type default null
     ,p_ordinamento          in suddivisioni_struttura.ordinamento%type default null
   ) is
      /******************************************************************************
       NOME:        ins
       DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
       PARAMETRI:   Chiavi e attributi della table.
      ******************************************************************************/
   begin
   
      dbc.pre(not dbc.preon or p_ottica is not null
             ,'p_ottica on suddivisione_struttura.ins');
   
      dbc.pre(not dbc.preon or p_suddivisione is not null
             ,'p_suddivisione on suddivisione_struttura.ins');
   
      dbc.pre(not dbc.preon or p_descrizione is not null
             ,'p_descrizione on suddivisione_struttura.ins');
   
      dbc.pre(not dbc.preon or p_id_suddivisione is null or
              not existsid(p_id_suddivisione)
             ,'not existsId on suddivisione_struttura.ins');
   
      insert into suddivisioni_struttura
         (id_suddivisione
         ,ottica
         ,suddivisione
         ,descrizione
         ,descrizione_al1
         ,descrizione_al2
         ,des_abb
         ,des_abb_al1
         ,des_abb_al2
         ,icona_standard
         ,icona_modifica
         ,icona_eliminazione
         ,nota
         ,utente_aggiornamento
         ,data_aggiornamento
         ,ordinamento)
      values
         (p_id_suddivisione
         ,p_ottica
         ,p_suddivisione
         ,p_descrizione
         ,p_descrizione_al1
         ,p_descrizione_al2
         ,p_des_abb
         ,p_des_abb_al1
         ,p_des_abb_al2
         ,p_icona_standard
         ,p_icona_modifica
         ,p_icona_eliminazione
         ,p_nota
         ,p_utente_aggiornamento
         ,p_data_aggiornamento
         ,p_ordinamento);
   
   end; -- suddivisione_struttura.ins

   --------------------------------------------------------------------------------

   procedure upd
   (
      p_new_id_suddivisione      in suddivisioni_struttura.id_suddivisione%type
     ,p_new_ottica               in suddivisioni_struttura.ottica%type
     ,p_new_suddivisione         in suddivisioni_struttura.suddivisione%type
     ,p_new_descrizione          in suddivisioni_struttura.descrizione%type
     ,p_new_descrizione_al1      in suddivisioni_struttura.descrizione_al1%type
     ,p_new_descrizione_al2      in suddivisioni_struttura.descrizione_al2%type
     ,p_new_des_abb              in suddivisioni_struttura.des_abb%type
     ,p_new_des_abb_al1          in suddivisioni_struttura.des_abb_al1%type
     ,p_new_des_abb_al2          in suddivisioni_struttura.des_abb_al2%type
     ,p_new_icona_standard       in suddivisioni_struttura.icona_standard%type
     ,p_new_icona_modifica       in suddivisioni_struttura.icona_modifica%type
     ,p_new_icona_eliminazione   in suddivisioni_struttura.icona_eliminazione%type
     ,p_new_nota                 in suddivisioni_struttura.nota%type
     ,p_new_utente_aggiornamento in suddivisioni_struttura.utente_aggiornamento%type
     ,p_new_data_aggiornamento   in suddivisioni_struttura.data_aggiornamento%type
     ,p_new_ordinamento          in suddivisioni_struttura.ordinamento%type default null
     ,p_old_id_suddivisione      in suddivisioni_struttura.id_suddivisione%type default null
     ,p_old_ottica               in suddivisioni_struttura.ottica%type default null
     ,p_old_suddivisione         in suddivisioni_struttura.suddivisione%type default null
     ,p_old_descrizione          in suddivisioni_struttura.descrizione%type default null
     ,p_old_descrizione_al1      in suddivisioni_struttura.descrizione_al1%type default null
     ,p_old_descrizione_al2      in suddivisioni_struttura.descrizione_al2%type default null
     ,p_old_des_abb              in suddivisioni_struttura.des_abb%type default null
     ,p_old_des_abb_al1          in suddivisioni_struttura.des_abb_al1%type default null
     ,p_old_des_abb_al2          in suddivisioni_struttura.des_abb_al2%type default null
     ,p_old_icona_standard       in suddivisioni_struttura.icona_standard%type default null
     ,p_old_icona_modifica       in suddivisioni_struttura.icona_modifica%type default null
     ,p_old_icona_eliminazione   in suddivisioni_struttura.icona_eliminazione%type default null
     ,p_old_nota                 in suddivisioni_struttura.nota%type default null
     ,p_old_utente_aggiornamento in suddivisioni_struttura.utente_aggiornamento%type default null
     ,p_old_data_aggiornamento   in suddivisioni_struttura.data_aggiornamento%type default null
     ,p_old_ordinamento          in suddivisioni_struttura.ordinamento%type default null
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
              not ((p_old_ottica is not null or p_old_suddivisione is not null or
               p_old_descrizione is not null or p_old_descrizione_al1 is not null or
               p_old_descrizione_al1 is not null or p_old_des_abb is not null or
               p_old_des_abb_al1 is not null or p_old_des_abb_al2 is not null or
               p_old_icona_standard is not null or p_old_icona_modifica is not null or
               p_old_icona_eliminazione is not null or p_old_nota is not null or
               p_old_utente_aggiornamento is not null or
               p_old_data_aggiornamento is not null or p_old_ordinamento is not null) and
               p_check_old = 0)
             ,' <OLD values> is not null on suddivisione_struttura.upd');
   
      dbc.pre(not dbc.preon or p_check_old is not null
             ,'p_check_OLD is not null on suddivisione_struttura.upd');
   
      d_key := pk(nvl(p_old_id_suddivisione, p_new_id_suddivisione));
   
      dbc.pre(not dbc.preon or existsid(d_key.id_suddivisione)
             ,'existsId on suddivisione_struttura.upd');
   
      update suddivisioni_struttura
         set id_suddivisione      = p_new_id_suddivisione
            ,ottica               = p_new_ottica
            ,suddivisione         = p_new_suddivisione
            ,descrizione          = p_new_descrizione
            ,descrizione_al1      = p_new_descrizione_al1
            ,descrizione_al2      = p_new_descrizione_al2
            ,des_abb              = p_new_des_abb
            ,des_abb_al1          = p_new_des_abb_al1
            ,des_abb_al2          = p_new_des_abb_al2
            ,icona_standard       = p_new_icona_standard
            ,icona_modifica       = p_new_icona_modifica
            ,icona_eliminazione   = p_new_icona_eliminazione
            ,nota                 = p_new_nota
            ,utente_aggiornamento = p_new_utente_aggiornamento
            ,data_aggiornamento   = p_new_data_aggiornamento
            ,ordinamento          = p_new_ordinamento
       where id_suddivisione = d_key.id_suddivisione
         and (p_check_old = 0 or
             p_check_old = 1 and
             (ottica = p_old_ottica or ottica is null and p_old_ottica is null) and
             (suddivisione = p_old_suddivisione or
             suddivisione is null and p_old_suddivisione is null) and
             (descrizione = p_old_descrizione or
             descrizione is null and p_old_descrizione is null) and
             (descrizione_al1 = p_old_descrizione_al1 or
             descrizione_al1 is null and p_old_descrizione_al1 is null) and
             (descrizione_al2 = p_old_descrizione_al2 or
             descrizione_al2 is null and p_old_descrizione_al2 is null) and
             (des_abb = p_old_des_abb or des_abb is null and p_old_des_abb is null) and
             (des_abb_al1 = p_old_des_abb_al1 or
             des_abb_al1 is null and p_old_des_abb_al1 is null) and
             (des_abb_al2 = p_old_des_abb_al2 or
             des_abb_al2 is null and p_old_des_abb_al2 is null) and
             (icona_standard = p_old_icona_standard or
             icona_standard is null and p_old_icona_standard is null) and
             (icona_modifica = p_old_icona_modifica or
             icona_modifica is null and p_old_icona_modifica is null) and
             (icona_eliminazione = p_old_icona_eliminazione or
             icona_eliminazione is null and p_old_icona_eliminazione is null) and
             (nota = p_old_nota or nota is null and p_old_nota is null) and
             (utente_aggiornamento = p_old_utente_aggiornamento or
             utente_aggiornamento is null and p_old_utente_aggiornamento is null) and
             (data_aggiornamento = p_old_data_aggiornamento or
             data_aggiornamento is null and p_old_data_aggiornamento is null) and
             (ordinamento = p_old_ordinamento or
             ordinamento is null and p_old_ordinamento is null));
      d_row_found := sql%rowcount;
   
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on suddivisione_struttura.upd');
   
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   
   end; -- suddivisione_struttura.upd

   --------------------------------------------------------------------------------

   procedure upd_column
   (
      p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type
     ,p_column          in varchar2
     ,p_value           in varchar2 default null
     ,p_literal_value   in number default 1
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
   
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione)
             ,'existsId on suddivisione_struttura.upd_column');
      dbc.pre(not dbc.preon or p_column is not null
             ,'p_column is not null on suddivisione_struttura.upd_column');
      dbc.pre(not dbc.preon or afc_ddl.hasattribute(s_table_name, p_column)
             ,'AFC_DDL.HasAttribute on suddivisione_struttura.upd_column');
      dbc.pre(p_literal_value in (0, 1)
             ,'p_literal_value in ( 0, 1 ) on suddivisione_struttura.upd_column; p_literal_value = ' ||
              p_literal_value);
   
      if p_literal_value = 1 then
         d_literal := '''';
      end if;
   
      d_statement := 'begin ' || '   update suddivisioni_struttura' || '   set    ' ||
                     p_column || ' = ' || d_literal || p_value || d_literal ||
                     '   where  id_suddivisione = ''' || p_id_suddivisione || '''' ||
                     '   ;' || 'end;';
   
      execute immediate d_statement;
   
   end; -- suddivisione_struttura.upd_column

   --------------------------------------------------------------------------------

   procedure upd_column
   (
      p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type
     ,p_column          in varchar2
     ,p_value           in date
   ) is
      /******************************************************************************
       NOME:        upd_column
       DESCRIZIONE: Aggiornamento del campo p_column col valore p_value.
       
       NOTE:        Richiama se stessa con il parametro date convertito in stringa.
      ******************************************************************************/
      d_data varchar2(19);
   begin
      d_data := to_char(p_value, 'dd/mm/yyyy hh24:mi:ss');
      upd_column(p_id_suddivisione
                ,p_column
                ,'to_date( ''' || d_data || ''', ''dd/mm/yyyy hh24:mi:ss'')'
                ,0);
   end; -- suddivisione_struttura.upd_column

   --------------------------------------------------------------------------------

   procedure del
   (
      p_id_suddivisione      in suddivisioni_struttura.id_suddivisione%type
     ,p_ottica               in suddivisioni_struttura.ottica%type
     ,p_suddivisione         in suddivisioni_struttura.suddivisione%type
     ,p_descrizione          in suddivisioni_struttura.descrizione%type
     ,p_descrizione_al1      in suddivisioni_struttura.descrizione_al1%type default null
     ,p_descrizione_al2      in suddivisioni_struttura.descrizione_al2%type default null
     ,p_des_abb              in suddivisioni_struttura.des_abb%type default null
     ,p_des_abb_al1          in suddivisioni_struttura.des_abb_al1%type default null
     ,p_des_abb_al2          in suddivisioni_struttura.des_abb_al2%type default null
     ,p_icona_standard       in suddivisioni_struttura.icona_standard%type default null
     ,p_icona_modifica       in suddivisioni_struttura.icona_modifica%type default null
     ,p_icona_eliminazione   in suddivisioni_struttura.icona_eliminazione%type default null
     ,p_nota                 in suddivisioni_struttura.nota%type default null
     ,p_utente_aggiornamento in suddivisioni_struttura.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in suddivisioni_struttura.data_aggiornamento%type default null
     ,p_ordinamento          in suddivisioni_struttura.ordinamento%type default null
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
   
      dbc.pre(not dbc.preon or
              not
               ((p_ottica is not null or p_suddivisione is not null or
               p_descrizione is not null or p_descrizione_al1 is not null or
               p_descrizione_al2 is not null or p_des_abb is not null or
               p_des_abb_al1 is not null or p_des_abb_al2 is not null or
               p_icona_standard is not null or p_icona_modifica is not null or
               p_icona_eliminazione is not null or p_nota is not null or
               p_utente_aggiornamento is not null or p_data_aggiornamento is not null or
               p_ordinamento is not null) and p_check_old = 0)
             ,' <OLD values> is not null on suddivisione_struttura.del');
   
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione)
             ,'existsId on suddivisione_struttura.upd');
   
      delete from suddivisioni_struttura
       where id_suddivisione = p_id_suddivisione
         and (p_check_old = 0 or
             p_check_old = 1 and
             (ottica = p_ottica or ottica is null and p_ottica is null) and
             (suddivisione = p_suddivisione or
             suddivisione is null and p_suddivisione is null) and
             (descrizione = p_descrizione or
             descrizione is null and p_descrizione is null) and
             (descrizione_al1 = p_descrizione_al1 or
             descrizione_al1 is null and p_descrizione_al1 is null) and
             (descrizione_al2 = p_descrizione_al2 or
             descrizione_al2 is null and p_descrizione_al2 is null) and
             (des_abb = p_des_abb or des_abb is null and p_des_abb is null) and
             (des_abb_al1 = p_des_abb_al1 or
             des_abb_al1 is null and p_des_abb_al1 is null) and
             (des_abb_al2 = p_des_abb_al2 or
             des_abb_al2 is null and p_des_abb_al2 is null) and
             (icona_standard = p_icona_standard or
             icona_standard is null and p_icona_standard is null) and
             (icona_modifica = p_icona_modifica or
             icona_modifica is null and p_icona_modifica is null) and
             (icona_eliminazione = p_icona_eliminazione or
             icona_eliminazione is null and p_icona_eliminazione is null) and
             (nota = p_nota or nota is null and p_nota is null) and
             (utente_aggiornamento = p_utente_aggiornamento or
             utente_aggiornamento is null and p_utente_aggiornamento is null) and
             (data_aggiornamento = p_data_aggiornamento or
             data_aggiornamento is null and p_data_aggiornamento is null) and
             (ordinamento = p_ordinamento or
             ordinamento is null and p_ordinamento is null));
      d_row_found := sql%rowcount;
   
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on suddivisione_struttura.del');
   
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   
      dbc.post(not dbc.poston or not existsid(p_id_suddivisione)
              ,'existsId on suddivisione_struttura.del');
   
   end; -- suddivisione_struttura.del

   --------------------------------------------------------------------------------

   procedure duplica_suddivisioni
   (
      p_ottica_origine in ottiche.ottica_origine%type
     ,p_ottica         in ottiche.ottica%type
   ) is
      /******************************************************************************
       NOME:        duplica_suddivisioni
       DESCRIZIONE: data un'ottica di origine, duplica le suddivisioni struttura nell'ottica derivata
       
       NOTE:        
      ******************************************************************************/
   
   begin
      for sust in (select *
                     from suddivisioni_struttura s
                    where s.ottica = p_ottica_origine
                    order by s.id_suddivisione)
      loop
         suddivisione_struttura.ins(p_id_suddivisione      => ''
                                   ,p_ottica               => p_ottica
                                   ,p_suddivisione         => sust.suddivisione
                                   ,p_descrizione          => sust.descrizione
                                   ,p_descrizione_al1      => sust.descrizione_al1
                                   ,p_descrizione_al2      => sust.descrizione_al2
                                   ,p_des_abb              => sust.des_abb
                                   ,p_des_abb_al1          => sust.des_abb_al1
                                   ,p_des_abb_al2          => sust.des_abb_al2
                                   ,p_icona_standard       => sust.icona_standard
                                   ,p_icona_modifica       => sust.icona_modifica
                                   ,p_icona_eliminazione   => sust.icona_eliminazione
                                   ,p_nota                 => sust.nota
                                   ,p_utente_aggiornamento => ''
                                   ,p_data_aggiornamento   => ''
                                   ,p_ordinamento          => sust.ordinamento);
      
      end loop;
   
   end; -- suddivisione_struttura.duplica_suddivisioni

   --------------------------------------------------------------------------------

   function get_suddivisione(p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type)
      return suddivisioni_struttura.suddivisione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_suddivisione
       DESCRIZIONE: Attributo suddivisione di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     suddivisioni_struttura.suddivisione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result suddivisioni_struttura.suddivisione%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione)
             ,'existsId on suddivisione_struttura.get_suddivisione');
   
      select suddivisione
        into d_result
        from suddivisioni_struttura
       where id_suddivisione = p_id_suddivisione;
   
      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on suddivisione_struttura.get_suddivisione');
      return d_result;
   end; -- suddivisione_struttura.get_suddivisione

   --------------------------------------------------------------------------------

   function get_descrizione(p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type)
      return suddivisioni_struttura.descrizione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_descrizione
       DESCRIZIONE: Attributo descrizione di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     suddivisioni_struttura.descrizione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result suddivisioni_struttura.descrizione%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione)
             ,'existsId on suddivisione_struttura.get_descrizione');
   
      select descrizione
        into d_result
        from suddivisioni_struttura
       where id_suddivisione = p_id_suddivisione;
   
      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on suddivisione_struttura.get_descrizione');
      return d_result;
   end; -- suddivisione_struttura.get_descrizione

   --------------------------------------------------------------------------------

   function get_ottica(p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type)
      return suddivisioni_struttura.ottica%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_ottica
       ottica: Attributo ottica di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     suddivisioni_struttura.ottica%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result suddivisioni_struttura.ottica%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione)
             ,'existsId on suddivisione_struttura.get_ottica');
   
      select ottica
        into d_result
        from suddivisioni_struttura
       where id_suddivisione = p_id_suddivisione;
   
      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on suddivisione_struttura.get_ottica');
      return d_result;
   end; -- suddivisione_struttura.get_ottica

   --------------------------------------------------------------------------------

   function get_des_abb(p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type)
      return suddivisioni_struttura.des_abb%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_des_abb
       DESCRIZIONE: Attributo des_abb di riga esistente identificata dlla PK.
       PARAMETRI:   d_key: chiave.
       RITORNA:     suddivisioni_struttura.des_abb%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result suddivisioni_struttura.des_abb%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione)
             ,'existsId on suddivisione_struttura.get_des_abb');
   
      select des_abb
        into d_result
        from suddivisioni_struttura
       where id_suddivisione = p_id_suddivisione;
   
      dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'des_abb')
                   ,' AFC_DDL.IsNullable on suddivisione_struttura.get_des_abb');
      return d_result;
   end; -- suddivisione_struttura.get_des_abb

   --------------------------------------------------------------------------------

   function get_icona_standard(p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type)
      return suddivisioni_struttura.icona_standard%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_icona_standard
       DESCRIZIONE: Attributo icona_standard di riga esistente identificata dlla PK.
       PARAMETRI:   d_key: chiave.
       RITORNA:     suddivisioni_struttura.icona_standard%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result suddivisioni_struttura.icona_standard%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione)
             ,'existsId on suddivisione_struttura.get_icona_standard');
   
      select icona_standard
        into d_result
        from suddivisioni_struttura
       where id_suddivisione = p_id_suddivisione;
   
      dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'des_abb')
                   ,' AFC_DDL.IsNullable on suddivisione_struttura.get_icona_standard');
      return d_result;
   end; -- suddivisione_struttura.get_icona_standard

   --------------------------------------------------------------------------------

   function get_nota(p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type)
      return suddivisioni_struttura.nota%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_nota
       DESCRIZIONE: Attributo nota di riga esistente identificata dlla PK.
       PARAMETRI:   d_key: chiave.
       RITORNA:     suddivisioni_struttura.nota%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result suddivisioni_struttura.nota%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione)
             ,'existsId on suddivisione_struttura.get_nota');
   
      select nota
        into d_result
        from suddivisioni_struttura
       where id_suddivisione = p_id_suddivisione;
   
      dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'des_abb')
                   ,' AFC_DDL.IsNullable on suddivisione_struttura.get_nota');
      return d_result;
   end; -- suddivisione_struttura.get_nota

   --------------------------------------------------------------------------------

   function get_utente_aggiornamento(p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type)
      return suddivisioni_struttura.utente_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_utente_aggiornamento
       DESCRIZIONE: Attributo utente_aggiornamento di riga esistente identificata dlla PK.
       PARAMETRI:   d_key: chiave.
       RITORNA:     suddivisioni_struttura.utente_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result suddivisioni_struttura.utente_aggiornamento%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione)
             ,'existsId on suddivisione_struttura.get_utente_aggiornamento');
   
      select utente_aggiornamento
        into d_result
        from suddivisioni_struttura
       where id_suddivisione = p_id_suddivisione;
   
      dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'des_abb')
                   ,' AFC_DDL.IsNullable on suddivisione_struttura.get_utente_aggiornamento');
      return d_result;
   end; -- suddivisione_struttura.get_utente_aggiornamento

   --------------------------------------------------------------------------------

   function get_data_aggiornamento(p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type)
      return suddivisioni_struttura.data_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_data_aggiornamento
       DESCRIZIONE: Attributo data_aggiornamento di riga esistente identificata dlla PK.
       PARAMETRI:   d_key: chiave.
       RITORNA:     suddivisioni_struttura.data_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result suddivisioni_struttura.data_aggiornamento%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione)
             ,'existsId on suddivisione_struttura.get_data_aggiornamento');
   
      select data_aggiornamento
        into d_result
        from suddivisioni_struttura
       where id_suddivisione = p_id_suddivisione;
   
      dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'des_abb')
                   ,' AFC_DDL.IsNullable on suddivisione_struttura.get_data_aggiornamento');
      return d_result;
   end; -- suddivisione_struttura.get_data_aggiornamento

   --------------------------------------------------------------------------------

   function get_ordinamento(p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type)
      return suddivisioni_struttura.ordinamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_ordinamento
       DESCRIZIONE: Attributo ordinamento di riga esistente identificata dlla PK.
       PARAMETRI:   d_key: chiave.
       RITORNA:     suddivisioni_struttura.ordinamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result suddivisioni_struttura.ordinamento%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione)
             ,'existsId on suddivisione_struttura.get_ordinamento');
   
      select ordinamento
        into d_result
        from suddivisioni_struttura
       where id_suddivisione = p_id_suddivisione;
   
      dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'des_abb')
                   ,' AFC_DDL.IsNullable on suddivisione_struttura.get_ordinamento');
      return d_result;
   end; -- suddivisione_struttura.get_ordinamento

   --------------------------------------------------------------------------------

   function get_livello(p_id_suddivisione in suddivisioni_struttura.id_suddivisione%type)
      return number is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_livello
       DESCRIZIONE: Riporta il numero delle suddivisioni struttura di ordinamento inferiore
       PARAMETRI:   
       RITORNA:     
       NOTE:        
      ******************************************************************************/
      d_result number(3);
      d_ottica suddivisioni_struttura.ottica%type := get_ottica(p_id_suddivisione);
   begin
      d_result := to_number(null);
      begin
         select count(distinct ordinamento)
           into d_result
           from suddivisioni_struttura s
          where ottica = d_ottica
            and ordinamento < get_ordinamento(p_id_suddivisione);
      exception
         when no_data_found or too_many_rows then
            begin
               d_result := to_number(null);
            end;
      end;
      return d_result;
   end; -- suddivisione_struttura.get_livello

   --------------------------------------------------------------------------------

   function get_rows
   (
      p_id_suddivisione      in suddivisioni_struttura.id_suddivisione%type default null
     ,p_ottica               in suddivisioni_struttura.ottica%type default null
     ,p_suddivisione         in suddivisioni_struttura.suddivisione%type default null
     ,p_descrizione          in suddivisioni_struttura.descrizione%type default null
     ,p_descrizione_al1      in suddivisioni_struttura.descrizione_al1%type default null
     ,p_descrizione_al2      in suddivisioni_struttura.descrizione_al2%type default null
     ,p_des_abb              in suddivisioni_struttura.des_abb%type default null
     ,p_des_abb_al1          in suddivisioni_struttura.des_abb_al1%type default null
     ,p_des_abb_al2          in suddivisioni_struttura.des_abb_al2%type default null
     ,p_icona_standard       in suddivisioni_struttura.icona_standard%type default null
     ,p_icona_modifica       in suddivisioni_struttura.icona_modifica%type default null
     ,p_icona_eliminazione   in suddivisioni_struttura.icona_eliminazione%type default null
     ,p_nota                 in suddivisioni_struttura.nota%type default null
     ,p_utente_aggiornamento in suddivisioni_struttura.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in suddivisioni_struttura.data_aggiornamento%type default null
     ,p_ordinamento          in suddivisioni_struttura.ordinamento%type default null
     ,p_order_condition      in varchar2 default null
     ,p_qbe                  in number default 0
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
   
      d_statement := ' select * from suddivisioni_struttura ' || ' where 1 = 1 ' ||
                     afc.get_field_condition(' and ( id_suddivisione '
                                            ,p_id_suddivisione
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( ottica ', p_ottica, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( suddivisione '
                                            ,p_suddivisione
                                            ,' )'
                                            ,p_qbe) ||
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
                     afc.get_field_condition(' and ( des_abb ', p_des_abb, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( des_abb_al1 '
                                            ,p_des_abb_al1
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( des_abb_al2 '
                                            ,p_des_abb_al2
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( icona_standard '
                                            ,p_icona_standard
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( icona_modifica '
                                            ,p_icona_modifica
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( icona_eliminazione '
                                            ,p_icona_eliminazione
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( nota ', p_nota, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( utente_aggiornamento '
                                            ,p_utente_aggiornamento
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( data_aggiornamento '
                                            ,p_data_aggiornamento
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( ordinamento '
                                            ,p_ordinamento
                                            ,' )'
                                            ,p_qbe) ||
                     afc.decode_value(p_order_condition
                                     ,null
                                     ,' '
                                     ,' order by ' || p_order_condition);
   
      open d_ref_cursor for d_statement;
   
      return d_ref_cursor;
   
   end; -- suddivisione_struttura.get_rows

   --------------------------------------------------------------------------------

   function count_rows
   (
      p_id_suddivisione      in suddivisioni_struttura.id_suddivisione%type default null
     ,p_ottica               in suddivisioni_struttura.ottica%type default null
     ,p_suddivisione         in suddivisioni_struttura.suddivisione%type default null
     ,p_descrizione          in suddivisioni_struttura.descrizione%type default null
     ,p_descrizione_al1      in suddivisioni_struttura.descrizione_al1%type default null
     ,p_descrizione_al2      in suddivisioni_struttura.descrizione_al2%type default null
     ,p_des_abb              in suddivisioni_struttura.des_abb%type default null
     ,p_des_abb_al1          in suddivisioni_struttura.des_abb_al1%type default null
     ,p_des_abb_al2          in suddivisioni_struttura.des_abb_al2%type default null
     ,p_icona_standard       in suddivisioni_struttura.icona_standard%type default null
     ,p_icona_modifica       in suddivisioni_struttura.icona_modifica%type default null
     ,p_icona_eliminazione   in suddivisioni_struttura.icona_eliminazione%type default null
     ,p_nota                 in suddivisioni_struttura.nota%type default null
     ,p_utente_aggiornamento in suddivisioni_struttura.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in suddivisioni_struttura.data_aggiornamento%type default null
     ,p_ordinamento          in suddivisioni_struttura.ordinamento%type default null
     ,p_qbe                  in number default 0
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
   
      d_statement := ' select count( * ) from suddivisioni_struttura ' || ' where 1 = 1 ' ||
                     afc.get_field_condition(' and ( id_suddivisione '
                                            ,p_id_suddivisione
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( ottica ', p_ottica, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( suddivisione '
                                            ,p_suddivisione
                                            ,' )'
                                            ,p_qbe) ||
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
                     afc.get_field_condition(' and ( des_abb ', p_des_abb, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( des_abb_al1 '
                                            ,p_des_abb_al1
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( des_abb_al2 '
                                            ,p_des_abb_al2
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( icona_standard '
                                            ,p_icona_standard
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( icona_modifica '
                                            ,p_icona_modifica
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( icona_eliminazione '
                                            ,p_icona_eliminazione
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( nota ', p_nota, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( utente_aggiornamento '
                                            ,p_utente_aggiornamento
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( data_aggiornamento '
                                            ,p_data_aggiornamento
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( ordinamento '
                                            ,p_ordinamento
                                            ,' )'
                                            ,p_qbe);
   
      d_result := afc.sql_execute(d_statement);
   
      return d_result;
   end; -- suddivisione_struttura.count_rows

   --------------------------------------------------------------------------------

   function ordertree
   (
      p_level  in number
     ,p_figlio in varchar2
   ) return varchar2 is
      /******************************************************************************
         NAME:       ORDERTREE
         PURPOSE:    Gestisce l'ordinamento di un tree mantenendo la gerarchia
                     (da usare nella order by)
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        20/03/2003   Cinzia Baffo    1. Created this function.
      ******************************************************************************/
   begin
      v_testo := substr(v_testo, 1, (p_level - 1) * 21) || p_figlio;
      return v_testo;
   exception
      when no_data_found then
         return(null);
   end ordertree;

   --------------------------------------------------------------------------------

   function get_id_suddivisione
   (
      p_ottica       suddivisioni_struttura.ottica%type
     ,p_suddivisione in suddivisioni_struttura.suddivisione%type
   ) return suddivisioni_struttura.id_suddivisione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_id_suddivisione
       DESCRIZIONE: Chiave id_suddivisione di riga identificata da ottica e suddivisione
       PARAMETRI:   Ottica e suddivisione
       RITORNA:     suddivisioni_struttura.id_suddivisione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result suddivisioni_struttura.id_suddivisione%type;
   begin
      select id_suddivisione
        into d_result
        from suddivisioni_struttura
       where ottica = p_ottica
         and suddivisione = p_suddivisione;
   
      return d_result;
   end; -- suddivisione_struttura.get_id_suddivisione   
--------------------------------------------------------------------------------
-- begin

-- inserimento degli errori nella tabella
--   s_error_table( s_ottica_assente_number ) := s_ottica_assente_msg;

end suddivisione_struttura;
/

