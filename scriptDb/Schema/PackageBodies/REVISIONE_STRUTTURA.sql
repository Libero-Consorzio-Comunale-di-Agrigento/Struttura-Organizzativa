CREATE OR REPLACE package body revisione_struttura is
   /******************************************************************************
    NOME:        Revisione_struttura
    DESCRIZIONE: Gestione tabella revisioni_struttura.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore      Descrizione.
    000   31/07/2006  VDAVALLI    Prima emissione.
    001   04/09/2009  VDAVALLI    Modifiche per configurazione master/slave
    002   28/12/2009  VDAVALLI    Modificata gestione messaggi di errore in verifica
                                  revisione
    003   04/05/2010  APASSUELLO  Aggiunto controllo sui campi della tabella IMPOSTAZIONI
                                  nella procedure verifica_revisione
    004   19/05/2010  APASSUELLO  Aggiunto function is_data_ok per controllo sulla congruenza delle date
    005   09/08/2011  MMONARI     Modifiche per ottiche alternative
    006   18/10/2011  MMONARI     Funzione get_al
    007   01/12/2011  MMONARI     Revisioni Retroattive
    008   02/07/2012  MMONARI     Consolidamento rel.1.4.1
    009   02/08/2012  MMONARI     Modifiche per bug-fixing rilevato in regione Marche
    010   30/10/2012  VD/MM       Redmine 95
    011   12/11/2012  MMONARI     Redmine feature #120
    012   16/11/2012  MMONARI     Redmine bug #109
    013   20/12/2012  MMONARI     Redmine bug #119
    014   11/01/2013  MMONARI     Redmine bug #114 & #173
    015   29/01/2013  MMONARI     Redmine bug #86
    016   15/03/2013  ADADAMO     Redmine bug #222
          28/03/2013  AD/MM       Corretto controllo su ruoli
          02/04/2013  ADADAMO     Corretta get_ultima_revisione Remine bug #216
          15/04/2013  MMONARI     Redmine Bug#239
    017   03/09/2013  ADADAMO     Redmine Bug#292
    018   09/09/2013  MMONARI     Redmine Bug#301
    019   25/09/2013  MMONARI     Redmine Bug#309
    020   18/11/2013  MMONARI     Redmine Bug#338
    021   19/12/2013  ADADAMO     Redmine Bug#348
    022   08/01/2014  MMONARI     Redmine Bug#316 - Verifica revisione ad personam
    023   27/03/2014  ADADAMO     Sostituiti riferimenti al so4gp4 con so4gp_pkg Feature#418
          15/04/2014  MMONARI     Sostituiti riferimenti p00so4_modifiche_assegnazioni con so4gp4 con so4gp_pkg #429
          30/04/2014  MMONARI     #423 - Eliminazione anagrafiche UO utilizzate in piu' ottiche
    024   16/06/2014  MMONARI     #431 - Modifiche reatroattiva ad ANUO
          21/10/2014  MMONARI     #533 - Modifiche ai controlli di verifica revisione
          16/01/2015  MMONARI     #574 - Modifiche ai controlli di verifica revisione
          09/09/2015  MMONARI     #645 - Modifiche ai controlli di verifica revisione
          16/09/2015  MMONARI     #500 - Modifiche ai controlli di verifica revisione e is_ri_ok
                                         In verifica revisione, eliminato il controllo sull'attributo
                                         "Componente assegnato alla unita' in data antecedente alla data di inizio validita' della revisione"
    025   20/08/2015  MMONARI     #634 - Attribuzione ruoli automatici in attivazione della revisione
          12/04/2016  ADADAMO     #710 - Aggiunta in coda alla validazione schedulazione di un job
                                  per la rigenerazione della struttura
    026   13/09/2017  MMONARI     #713 - Eredita ruoli in attivazione della revisione
          14/09/2017  MMONARI     #709 - Eredita ruoli in attivazione della revisione
          22/09/2017  MMONARI     #703 - Ripristino della cancellazione logica alla situazione pre #431
          14/10/2020  MMONARI     #45341 Completamento attributi utente applicativo
    027   18/09/2018  MMONARI     #30648
   ******************************************************************************/
   s_revisione_body constant afc.t_revision := '027';
   s_table_name     constant afc.t_object_name := 'revisioni_struttura';
   s_error_table    afc_error.t_error_table;
   s_dummy          varchar2(1);
   s_tipo_revisione revisioni_struttura.tipo_revisione%type;
   --------------------------------------------------------------------------------
   function versione return varchar2 is /* SLAVE_COPY */
      /******************************************************************************
       NOME:        versione
       DESCRIZIONE: Versione e revisione di distribuzione del package.
       RITORNA:     varchar2 stringa contenente versione e revisione.
       NOTE:        Primo numero  : versione compatibilita del Package.
                    Secondo numero: revisione del Package specification.
                    Terzo numero  : revisione del Package body.
      ******************************************************************************/
   begin
      return afc.version(s_revisione, s_revisione_body);
   end; -- Revisione_struttura.versione
   --------------------------------------------------------------------------------
   function pk
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return t_pk is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        PK
       DESCRIZIONE: Costruttore di un t_PK dati gli attributi della chiave
      ******************************************************************************/
      d_result t_pk;
   begin
      d_result.ottica    := p_ottica;
      d_result.revisione := p_revisione;
      dbc.pre(not dbc.preon or canhandle(d_result.ottica, d_result.revisione)
             ,'canHandle on Revisione_struttura.PK');
      return d_result;
   end; -- end Revisione_struttura.PK
   --------------------------------------------------------------------------------
   function can_handle
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return number is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        can_handle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: 1 se la chiave e manipolabile, 0 altrimenti.
       NOTE:        cfr. canHandle per ritorno valori boolean.
      ******************************************************************************/
      d_result number;
   begin
      d_result := 1;
      -- nelle chiavi primarie composte da piu attributi, ciascun attributo deve essere not null
      if d_result = 1 and (p_ottica is null or p_revisione is null) then
         d_result := 0;
      end if;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on Revisione_struttura.can_handle');
      return d_result;
   end; -- Revisione_struttura.can_handle
   --------------------------------------------------------------------------------
   function canhandle
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        canHandle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: true se la chiave e manipolabile, false altrimenti.
       NOTE:        Wrapper boolean di can_handle (cfr. can_handle).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(can_handle(p_ottica, p_revisione));
   begin
      return d_result;
   end; -- Revisione_struttura.canHandle
   --------------------------------------------------------------------------------
   function exists_id
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return number is
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
      dbc.pre(not dbc.preon or canhandle(p_ottica, p_revisione)
             ,'canHandle on Revisione_struttura.exists_id');
      begin
         select 1
           into d_result
           from revisioni_struttura
          where ottica = p_ottica
            and revisione = p_revisione;
      exception
         when no_data_found then
            d_result := 0;
      end;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on Revisione_struttura.exists_id');
      return d_result;
   end; -- Revisione_struttura.exists_id
   --------------------------------------------------------------------------------
   function existsid
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        existsId
       DESCRIZIONE: Esistenza riga con chiave indicata.
       NOTE:        Wrapper boolean di exists_id (cfr. exists_id).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(exists_id(p_ottica, p_revisione));
   begin
      return d_result;
   end; -- Revisione_struttura.existsId
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
   end error_message; -- anagrafe_unita_organizzativa.error_message
   --------------------------------------------------------------------------------
   procedure ins
   (
      p_ottica               in revisioni_struttura.ottica%type
     ,p_revisione            in revisioni_struttura.revisione%type default null
     ,p_descrizione          in revisioni_struttura.descrizione%type
     ,p_tipo_registro        in revisioni_struttura.tipo_registro%type default null
     ,p_anno                 in revisioni_struttura.anno%type default null
     ,p_numero               in revisioni_struttura.numero%type default null
     ,p_data                 in revisioni_struttura.data%type default null
     ,p_descrizione_al1      in revisioni_struttura.descrizione_al1%type default null
     ,p_descrizione_al2      in revisioni_struttura.descrizione_al2%type default null
     ,p_dal                  in revisioni_struttura.dal%type default null
     ,p_data_pubblicazione   in revisioni_struttura.data_pubblicazione%type default null
     ,p_data_termine         in revisioni_struttura.data_termine%type default null
     ,p_tipo_revisione       in revisioni_struttura.tipo_revisione%type default null
     ,p_nota                 in revisioni_struttura.nota%type default null
     ,p_stato                in revisioni_struttura.stato%type default null
     ,p_provenienza          in revisioni_struttura.provenienza%type default null
     ,p_utente_aggiornamento in revisioni_struttura.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in revisioni_struttura.data_aggiornamento%type default null
   ) is
      /******************************************************************************
       NOME:        ins
       DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
       PARAMETRI:   Chiavi e attributi della table.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or p_descrizione is not null
             ,'p_descrizione on Revisione_struttura.ins');
      dbc.pre(not dbc.preon or p_revisione is null or
              not existsid(p_ottica, p_revisione)
             ,'not existsId on Revisione_struttura.ins');
      insert into revisioni_struttura
         (ottica
         ,revisione
         ,tipo_registro
         ,anno
         ,numero
         ,data
         ,descrizione
         ,descrizione_al1
         ,descrizione_al2
         ,dal
         ,data_pubblicazione
         ,data_termine
         ,tipo_revisione
         ,nota
         ,stato
         ,provenienza
         ,utente_aggiornamento
         ,data_aggiornamento)
      values
         (p_ottica
         ,p_revisione
         ,p_tipo_registro
         ,p_anno
         ,p_numero
         ,p_data
         ,p_descrizione
         ,p_descrizione_al1
         ,p_descrizione_al2
         ,p_dal
         ,p_data_pubblicazione
         ,p_data_termine
         ,p_tipo_revisione
         ,p_nota
         ,p_stato
         ,p_provenienza
         ,p_utente_aggiornamento
         ,p_data_aggiornamento);
   end; -- Revisione_struttura.ins
   --------------------------------------------------------------------------------
   procedure upd
   (
      p_new_ottica               in revisioni_struttura.ottica%type
     ,p_new_revisione            in revisioni_struttura.revisione%type
     ,p_new_tipo_registro        in revisioni_struttura.tipo_registro%type
     ,p_new_anno                 in revisioni_struttura.anno%type
     ,p_new_numero               in revisioni_struttura.numero%type
     ,p_new_data                 in revisioni_struttura.data%type
     ,p_new_descrizione          in revisioni_struttura.descrizione%type
     ,p_new_descrizione_al1      in revisioni_struttura.descrizione_al1%type
     ,p_new_descrizione_al2      in revisioni_struttura.descrizione_al2%type
     ,p_new_dal                  in revisioni_struttura.dal%type
     ,p_new_data_pubblicazione   in revisioni_struttura.data_pubblicazione%type
     ,p_new_data_termine         in revisioni_struttura.data_termine%type default null
     ,p_new_tipo_revisione       in revisioni_struttura.tipo_revisione%type
     ,p_new_nota                 in revisioni_struttura.nota%type
     ,p_new_stato                in revisioni_struttura.stato%type
     ,p_new_provenienza          in revisioni_struttura.provenienza%type
     ,p_new_utente_aggiornamento in revisioni_struttura.utente_aggiornamento%type
     ,p_new_data_aggiornamento   in revisioni_struttura.data_aggiornamento%type
     ,p_old_ottica               in revisioni_struttura.ottica%type default null
     ,p_old_revisione            in revisioni_struttura.revisione%type default null
     ,p_old_tipo_registro        in revisioni_struttura.tipo_registro%type default null
     ,p_old_anno                 in revisioni_struttura.anno%type default null
     ,p_old_numero               in revisioni_struttura.numero%type default null
     ,p_old_data                 in revisioni_struttura.data%type default null
     ,p_old_descrizione          in revisioni_struttura.descrizione%type default null
     ,p_old_descrizione_al1      in revisioni_struttura.descrizione_al1%type default null
     ,p_old_descrizione_al2      in revisioni_struttura.descrizione_al2%type default null
     ,p_old_dal                  in revisioni_struttura.dal%type default null
     ,p_old_data_pubblicazione   in revisioni_struttura.data_pubblicazione%type
     ,p_old_data_termine         in revisioni_struttura.data_termine%type default null
     ,p_old_tipo_revisione       in revisioni_struttura.tipo_revisione%type
     ,p_old_nota                 in revisioni_struttura.nota%type default null
     ,p_old_stato                in revisioni_struttura.stato%type default null
     ,p_old_provenienza          in revisioni_struttura.provenienza%type default null
     ,p_old_utente_aggiornamento in revisioni_struttura.utente_aggiornamento%type default null
     ,p_old_data_aggiornamento   in revisioni_struttura.data_aggiornamento%type default null
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
              not
               ((p_old_tipo_registro is not null or p_old_anno is not null or
               p_old_numero is not null or p_old_data is not null or
               p_old_descrizione is not null or p_old_descrizione_al1 is not null or
               p_old_descrizione_al2 is not null or p_old_dal is not null or
               p_old_data_pubblicazione is not null or p_old_data_termine is not null or
               p_old_tipo_revisione is not null or p_old_nota is not null or
               p_old_stato is not null or p_old_provenienza is not null or
               p_old_utente_aggiornamento is not null or
               p_old_data_aggiornamento is not null) and p_check_old = 0)
             ,' <OLD values> is not null on Revisione_struttura.upd');
      dbc.pre(not dbc.preon or p_check_old is not null
             ,'p_check_OLD is not null on Revisione_struttura.upd');
      d_key := pk(nvl(p_old_ottica, p_new_ottica), nvl(p_old_revisione, p_new_revisione));
      dbc.pre(not dbc.preon or existsid(d_key.ottica, d_key.revisione)
             ,'existsId on Revisione_struttura.upd');
      update revisioni_struttura
         set ottica               = p_new_ottica
            ,revisione            = p_new_revisione
            ,tipo_registro        = p_new_tipo_registro
            ,anno                 = p_new_anno
            ,numero               = p_new_numero
            ,data                 = p_new_data
            ,descrizione          = p_new_descrizione
            ,descrizione_al1      = p_new_descrizione_al1
            ,descrizione_al2      = p_new_descrizione_al2
            ,dal                  = p_new_dal
            ,data_pubblicazione   = p_new_data_pubblicazione
            ,data_termine         = p_new_data_termine
            ,tipo_revisione       = p_new_tipo_revisione
            ,nota                 = p_new_nota
            ,stato                = p_new_stato
            ,provenienza          = p_new_provenienza
            ,utente_aggiornamento = p_new_utente_aggiornamento
            ,data_aggiornamento   = p_new_data_aggiornamento
       where ottica = d_key.ottica
         and revisione = d_key.revisione
         and (p_check_old = 0 or
             p_check_old = 1 and (tipo_registro = p_old_tipo_registro or
             tipo_registro is null and p_old_tipo_registro is null) and
             (anno = p_old_anno or anno is null and p_old_anno is null) and
             (numero = p_old_numero or numero is null and p_old_numero is null) and
             (data = p_old_data or data is null and p_old_data is null) and
             (descrizione = p_old_descrizione or
             descrizione is null and p_old_descrizione is null) and
             (descrizione_al1 = p_old_descrizione_al1 or
             descrizione_al1 is null and p_old_descrizione_al1 is null) and
             (descrizione_al2 = p_old_descrizione_al2 or
             descrizione_al2 is null and p_old_descrizione_al2 is null) and
             (dal = p_old_dal or dal is null and p_old_dal is null) and
             (data_pubblicazione = p_old_data_pubblicazione or
             data_pubblicazione is null and p_old_data_pubblicazione is null) and
             (data_termine = p_old_data_termine or
             data_termine is null and p_old_data_termine is null) and
             (tipo_revisione = p_old_tipo_revisione or
             tipo_revisione is null and p_old_tipo_revisione is null) and
             (nota = p_old_nota or nota is null and p_old_nota is null) and
             (stato = p_old_stato or stato is null and p_old_stato is null) and
             (provenienza = p_old_provenienza or
             provenienza is null and p_old_provenienza is null) and
             (utente_aggiornamento = p_old_utente_aggiornamento or
             utente_aggiornamento is null and p_old_utente_aggiornamento is null) and
             (data_aggiornamento = p_old_data_aggiornamento or
             data_aggiornamento is null and p_old_data_aggiornamento is null));
      d_row_found := sql%rowcount;
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on Revisione_struttura.upd');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   end; -- Revisione_struttura.upd
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_ottica        in revisioni_struttura.ottica%type
     ,p_revisione     in revisioni_struttura.revisione%type
     ,p_column        in varchar2
     ,p_value         in varchar2 default null
     ,p_literal_value in number default 1
   ) is
      /******************************************************************************
       NOME:        upd_column
       DESCRIZIONE: Aggiornamento del campo p_column col valore p_value.
       PARAMETRI:   p_column:        identificatore del campo da aggiornare.
                    p_value:         valore da modificare.
                    p_literal_value: indica se il valore e un stringa e non un numero
                                     o una funzione.
      ******************************************************************************/
      d_statement afc.t_statement;
      d_literal   varchar2(2);
   begin
      dbc.pre(not dbc.preon or existsid(p_ottica, p_revisione)
             ,'existsId on Revisione_struttura.upd_column');
      dbc.pre(not dbc.preon or p_column is not null
             ,'p_column is not null on Revisione_struttura.upd_column');
      dbc.pre(not dbc.preon or afc_ddl.hasattribute(s_table_name, p_column)
             ,'AFC_DDL.HasAttribute on Revisione_struttura.upd_column');
      dbc.pre(p_literal_value in (0, 1)
             ,'p_literal_value in ( 0, 1 ) on Revisione_struttura.upd_column; p_literal_value = ' ||
              p_literal_value);
      if p_literal_value = 1 then
         d_literal := '''';
      end if;
      d_statement := 'begin ' || '   update revisioni_struttura' || '   set    ' ||
                     p_column || ' = ' || d_literal || p_value || d_literal ||
                     '   where  ottica = ''' || p_ottica || '''' ||
                     '   and    revisione = ''' || p_revisione || '''' || '   ;' ||
                     'end;';
      execute immediate d_statement;
   end; -- Revisione_struttura.upd_column
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
     ,p_column    in varchar2
     ,p_value     in date
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
                ,p_revisione
                ,p_column
                ,'to_date( ''' || d_data || ''', ''dd/mm/yyyy hh24:mi:ss'')'
                ,0);
   end; -- Revisione_struttura.upd_column
   --------------------------------------------------------------------------------
   procedure del
   (
      p_ottica               in revisioni_struttura.ottica%type
     ,p_revisione            in revisioni_struttura.revisione%type
     ,p_tipo_registro        in revisioni_struttura.tipo_registro%type default null
     ,p_anno                 in revisioni_struttura.anno%type default null
     ,p_numero               in revisioni_struttura.numero%type default null
     ,p_data                 in revisioni_struttura.data%type default null
     ,p_descrizione          in revisioni_struttura.descrizione%type default null
     ,p_descrizione_al1      in revisioni_struttura.descrizione_al1%type default null
     ,p_descrizione_al2      in revisioni_struttura.descrizione_al2%type default null
     ,p_dal                  in revisioni_struttura.dal%type default null
     ,p_data_pubblicazione   in revisioni_struttura.data_pubblicazione%type default null
     ,p_data_termine         in revisioni_struttura.data_termine%type default null
     ,p_tipo_revisione       in revisioni_struttura.tipo_revisione%type default null
     ,p_nota                 in revisioni_struttura.nota%type default null
     ,p_stato                in revisioni_struttura.stato%type default null
     ,p_provenienza          in revisioni_struttura.provenienza%type default null
     ,p_utente_aggiornamento in revisioni_struttura.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in revisioni_struttura.data_aggiornamento%type default null
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
              not ((p_ottica is not null or p_revisione is not null or
               p_tipo_registro is not null or p_anno is not null or
               p_numero is not null or p_data is not null or
               p_descrizione is not null or p_descrizione_al1 is not null or
               p_descrizione_al2 is not null or p_dal is not null or
               p_data_pubblicazione is not null or p_data_termine is not null or
               p_tipo_revisione is null or p_nota is not null or p_stato is not null or
               p_provenienza is not null or p_utente_aggiornamento is not null or
               p_data_aggiornamento is not null) and p_check_old = 0)
             ,' <OLD values> is not null on Revisione_struttura.del');
      dbc.pre(not dbc.preon or existsid(p_ottica, p_revisione)
             ,'existsId on Revisione_struttura.upd');
      delete from revisioni_struttura
       where ottica = p_ottica
         and revisione = p_revisione
         and (p_check_old = 0 or
             p_check_old = 1 and
             (ottica = p_ottica or ottica is null and p_ottica is null) and
             (revisione = p_revisione or revisione is null and p_revisione is null) and
             (tipo_registro = p_tipo_registro or
             tipo_registro is null and p_tipo_registro is null) and
             (anno = p_anno or anno is null and p_anno is null) and
             (numero = p_numero or numero is null and p_numero is null) and
             (data = p_data or data is null and p_data is null) and
             (descrizione = p_descrizione or
             descrizione is null and p_descrizione is null) and
             (descrizione_al1 = p_descrizione_al1 or
             descrizione_al1 is null and p_descrizione_al1 is null) and
             (descrizione_al2 = p_descrizione_al2 or
             descrizione_al2 is null and p_descrizione_al2 is null) and
             (dal = p_dal or dal is null and p_dal is null) and
             (data_pubblicazione = p_data_pubblicazione or
             data_pubblicazione is null and p_data_pubblicazione is null) and
             (data_termine = p_data_termine or
             data_termine is null and p_data_termine is null) and
             (tipo_revisione = p_tipo_revisione or tipo_revisione = p_tipo_revisione or
             tipo_revisione is null and p_tipo_revisione is null) and
             (nota = p_nota or nota is null and p_nota is null) and
             (stato = p_stato or stato is null and p_stato is null) and
             (provenienza = p_provenienza or
             provenienza is null and p_provenienza is null) and
             (utente_aggiornamento = p_utente_aggiornamento or
             utente_aggiornamento is null and p_utente_aggiornamento is null) and
             (data_aggiornamento = p_data_aggiornamento or
             data_aggiornamento is null and p_data_aggiornamento is null));
      d_row_found := sql%rowcount;
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on Revisione_struttura.del');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
      dbc.post(not dbc.poston or not existsid(p_ottica, p_revisione)
              ,'existsId on Revisione_struttura.del');
   end; -- Revisione_struttura.del
   --------------------------------------------------------------------------------
   function get_descrizione
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return revisioni_struttura.descrizione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_descrizione
       DESCRIZIONE: Attributo descrizione di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     revisioni_struttura.descrizione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result revisioni_struttura.descrizione%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_ottica, p_revisione)
             ,'existsId on Revisione_struttura.get_descrizione');
      select descrizione
        into d_result
        from revisioni_struttura
       where ottica = p_ottica
         and revisione = p_revisione;
      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on Revisione_struttura.get_descrizione');
      return d_result;
   end; -- Revisione_struttura.get_descrizione
   --------------------------------------------------------------------------------
   function get_tipo_registro
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return revisioni_struttura.tipo_registro%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_tipo_registro
       DESCRIZIONE: Attributo descrizione di riga esistente identificata dlla PK.
       PARAMETRI:   d_key: chiave.
       RITORNA:     revisioni_struttura.descrizione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result revisioni_struttura.tipo_registro%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_ottica, p_revisione)
             ,'existsId on Revisione_struttura.get_tipo_registro');
      select tipo_registro
        into d_result
        from revisioni_struttura
       where ottica = p_ottica
         and revisione = p_revisione;
      dbc.assertion(not dbc.assertionon or
                    afc_ddl.isnullable(s_table_name, 'tipo_registro')
                   ,' AFC_DDL.IsNullable on Revisione_struttura.get_tipo_registro');
      return d_result;
   end; -- Revisione_struttura.get_tipo_registro
   --------------------------------------------------------------------------------
   function get_anno
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return revisioni_struttura.anno%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_anno
       DESCRIZIONE: Attributo descrizione di riga esistente identificata dlla PK.
       PARAMETRI:   d_key: chiave.
       RITORNA:     revisioni_struttura.descrizione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result revisioni_struttura.anno%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_ottica, p_revisione)
             ,'existsId on Revisione_struttura.get_anno');
      select anno
        into d_result
        from revisioni_struttura
       where ottica = p_ottica
         and revisione = p_revisione;
      dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'anno')
                   ,' AFC_DDL.IsNullable on revisione_struttura.get_anno');
      return d_result;
   end; -- Revisione_struttura.get_anno
   --------------------------------------------------------------------------------
   function get_numero
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return revisioni_struttura.numero%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_numero
       DESCRIZIONE: Attributo descrizione di riga esistente identificata dlla PK.
       PARAMETRI:   d_key: chiave.
       RITORNA:     revisioni_struttura.descrizione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result revisioni_struttura.numero%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_ottica, p_revisione)
             ,'existsId on revisione_struttura.get_numero');
      select numero
        into d_result
        from revisioni_struttura
       where ottica = p_ottica
         and revisione = p_revisione;
      dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'numero')
                   ,' AFC_DDL.IsNullable on revisione_struttura.get_numero');
      return d_result;
   end; -- revisione_struttura.get_numero
   --------------------------------------------------------------------------------
   function get_data
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return revisioni_struttura.data%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_data
       DESCRIZIONE: Attributo descrizione di riga esistente identificata dlla PK.
       PARAMETRI:   d_key: chiave.
       RITORNA:     revisioni_struttura.descrizione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result revisioni_struttura.data%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_ottica, p_revisione)
             ,'existsId on revisione_struttura.get_data');
      select data
        into d_result
        from revisioni_struttura
       where ottica = p_ottica
         and revisione = p_revisione;
      dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'data')
                   ,' AFC_DDL.IsNullable on revisione_struttura.get_data');
      return d_result;
   end; -- revisione_struttura.get_data
   --------------------------------------------------------------------------------
   function get_dal
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return revisioni_struttura.dal%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_dal
       DESCRIZIONE: Attributo descrizione di riga esistente identificata dlla PK.
       PARAMETRI:   d_key: chiave.
       RITORNA:     revisioni_struttura.descrizione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result revisioni_struttura.dal%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_ottica, p_revisione)
             ,'existsId on revisione_struttura.get_dal');
      select dal
        into d_result
        from revisioni_struttura
       where ottica = p_ottica
         and revisione = p_revisione;
      dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'dal')
                   ,' AFC_DDL.IsNullable on revisione_struttura.get_dal');
      return d_result;
   end; -- revisione_struttura.get_dal
   --------------------------------------------------------------------------------
   function get_data_pubblicazione
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return revisioni_struttura.data_pubblicazione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_data_pubblicazione
       DESCRIZIONE: Attributo data_pubblicazione di riga esistente identificata dlla PK.
       PARAMETRI:   d_key: chiave.
       RITORNA:     revisioni_struttura.descrizione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result revisioni_struttura.data_pubblicazione%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_ottica, p_revisione)
             ,'existsId on revisione_struttura.get_data_pubblicazione');
      select data_pubblicazione
        into d_result
        from revisioni_struttura
       where ottica = p_ottica
         and revisione = p_revisione;
      dbc.assertion(not dbc.assertionon or
                    afc_ddl.isnullable(s_table_name, 'data_pubblicazione')
                   ,' AFC_DDL.IsNullable on revisione_struttura.get_data_pubblicazione');
      return d_result;
   end; -- revisione_struttura.get_data_pubblicazione
   --------------------------------------------------------------------------------
   function get_data_termine
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return revisioni_struttura.data_termine%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_data_termine
       DESCRIZIONE: Attributo data_termine di riga esistente identificata dlla PK.
       PARAMETRI:   d_key: chiave.
       RITORNA:     revisioni_struttura.descrizione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result revisioni_struttura.data_termine%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_ottica, p_revisione)
             ,'existsId on revisione_struttura.get_data_termine');
      select data_termine
        into d_result
        from revisioni_struttura
       where ottica = p_ottica
         and revisione = p_revisione;
      dbc.assertion(not dbc.assertionon or
                    afc_ddl.isnullable(s_table_name, 'data_termine')
                   ,' AFC_DDL.IsNullable on revisione_struttura.get_data_termine');
      return d_result;
   end; -- revisione_struttura.get_data_termine
   --------------------------------------------------------------------------------
   function get_tipo_revisione
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return revisioni_struttura.tipo_revisione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_tipo_revisione
       DESCRIZIONE: Attributo tipo_revisione di riga esistente identificata dlla PK.
       PARAMETRI:   d_key: chiave.
       RITORNA:     revisioni_struttura.descrizione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result revisioni_struttura.tipo_revisione%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_ottica, p_revisione)
             ,'existsId on revisione_struttura.get_tipo_revisione');
      begin
         select tipo_revisione
           into d_result
           from revisioni_struttura
          where ottica = p_ottica
            and revisione = p_revisione;
      exception
         when no_data_found then
            d_result := 'N';
      end;
      dbc.assertion(not dbc.assertionon or
                    afc_ddl.isnullable(s_table_name, 'tipo_revisione')
                   ,' AFC_DDL.IsNullable on revisione_struttura.get_tipo_revisione');
      return d_result;
   end; -- revisione_struttura.get_tipo_revisione
   --------------------------------------------------------------------------------
   function get_nota
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return revisioni_struttura.nota%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_nota
       DESCRIZIONE: Attributo descrizione di riga esistente identificata dlla PK.
       PARAMETRI:   d_key: chiave.
       RITORNA:     revisioni_struttura.descrizione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result revisioni_struttura.nota%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_ottica, p_revisione)
             ,'existsId on revisione_struttura.get_nota');
      select nota
        into d_result
        from revisioni_struttura
       where ottica = p_ottica
         and revisione = p_revisione;
      dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'nota')
                   ,' AFC_DDL.IsNullable on revisione_struttura.get_nota');
      return d_result;
   end; -- revisione_struttura.get_nota
   --------------------------------------------------------------------------------
   function get_stato
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return revisioni_struttura.stato%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_stato
       DESCRIZIONE: Attributo descrizione di riga esistente identificata dlla PK.
       PARAMETRI:   d_key: chiave.
       RITORNA:     revisioni_struttura.descrizione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result revisioni_struttura.stato%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_ottica, p_revisione)
             ,'existsId on revisione_struttura.get_stato');
      select stato
        into d_result
        from revisioni_struttura
       where ottica = p_ottica
         and revisione = p_revisione;
      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on revisione_struttura.get_stato');
      return d_result;
   end; -- revisione_struttura.get_stato
   --------------------------------------------------------------------------------
   function get_provenienza
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return revisioni_struttura.provenienza%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_provenienza
       DESCRIZIONE: Attributo descrizione di riga esistente identificata dlla PK.
       PARAMETRI:   d_key: chiave.
       RITORNA:     revisioni_struttura.descrizione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result revisioni_struttura.provenienza%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_ottica, p_revisione)
             ,'existsId on revisione_struttura.get_provenienza');
      select provenienza
        into d_result
        from revisioni_struttura
       where ottica = p_ottica
         and revisione = p_revisione;
      dbc.assertion(not dbc.assertionon or
                    afc_ddl.isnullable(s_table_name, 'provenienza')
                   ,' AFC_DDL.IsNullable on revisione_struttura.get_provenienza');
      return d_result;
   end; -- revisione_struttura.get_provenienza
   --------------------------------------------------------------------------------
   function get_utente_aggiornamento
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return revisioni_struttura.utente_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_utente_aggiornamento
       DESCRIZIONE: Attributo descrizione di riga esistente identificata dlla PK.
       PARAMETRI:   d_key: chiave.
       RITORNA:     revisioni_struttura.descrizione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result revisioni_struttura.utente_aggiornamento%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_ottica, p_revisione)
             ,'existsId on revisione_struttura.get_utente_aggiornamento');
      select utente_aggiornamento
        into d_result
        from revisioni_struttura
       where ottica = p_ottica
         and revisione = p_revisione;
      dbc.assertion(not dbc.assertionon or
                    afc_ddl.isnullable(s_table_name, 'utente_aggiornamento')
                   ,' AFC_DDL.IsNullable on revisione_struttura.get_utente_aggiornamento');
      return d_result;
   end; -- revisione_struttura.get_utente_aggiornamento
   --------------------------------------------------------------------------------
   function get_data_aggiornamento
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return revisioni_struttura.data_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_data_aggiornamento
       DESCRIZIONE: Attributo descrizione di riga esistente identificata dlla PK.
       PARAMETRI:   d_key: chiave.
       RITORNA:     revisioni_struttura.descrizione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result revisioni_struttura.data_aggiornamento%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_ottica, p_revisione)
             ,'existsId on revisione_struttura.get_data_aggiornamento');
      select data_aggiornamento
        into d_result
        from revisioni_struttura
       where ottica = p_ottica
         and revisione = p_revisione;
      dbc.assertion(not dbc.assertionon or
                    afc_ddl.isnullable(s_table_name, 'data_aggiornamento')
                   ,' AFC_DDL.IsNullable on revisione_struttura.get_data_aggiornamento');
      return d_result;
   end; -- revisione_struttura.get_data_aggiornamento
   --------------------------------------------------------------------------------
   function get_id_revisione(p_ottica in revisioni_struttura.ottica%type)
      return revisioni_struttura.revisione%type is
      /******************************************************************************
       NOME:        get_id_revisione
       DESCRIZIONE: Determinazione del nuovo progressivo in inserimento
                    di una nuova revisione
       PARAMETRI:   p_ottica
       RITORNA:     revisioni_struttura.revisione%type.
       NOTE:        --
      ******************************************************************************/
      d_result revisioni_struttura.revisione%type;
   begin
      select nvl(max(revisione), 0) + 1
        into d_result
        from revisioni_struttura
       where ottica = p_ottica;
      return d_result;
   end; -- revisioni_struttura.get_id_revisione
   --------------------------------------------------------------------------------
   function get_rows
   (
      p_ottica               in varchar2 default null
     ,p_revisione            in varchar2 default null
     ,p_tipo_registro        in varchar2 default null
     ,p_anno                 in varchar2 default null
     ,p_numero               in varchar2 default null
     ,p_data                 in varchar2 default null
     ,p_descrizione          in varchar2 default null
     ,p_descrizione_al1      in varchar2 default null
     ,p_descrizione_al2      in varchar2 default null
     ,p_dal                  in varchar2 default null
     ,p_data_pubblicazione   in varchar2 default null
     ,p_data_termine         in varchar2 default null
     ,p_tipo_revisione       in varchar2 default null
     ,p_nota                 in varchar2 default null
     ,p_stato                in varchar2 default null
     ,p_provenienza          in varchar2 default null
     ,p_utente_aggiornamento in varchar2 default null
     ,p_data_aggiornamento   in varchar2 default null
     ,p_order_condition      in varchar2 default null
     ,p_qbe                  in number default 0
   ) return afc.t_ref_cursor is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_rows
       DESCRIZIONE: Ritorna il risultato di una query in base ai valori che passiamo.
       PARAMETRI:   Chiavi e attributi della table
                    p_order_condition
                    p_QBE 0: se l'operatore da utilizzare nella where-condition e
                             quello di default ('=')
                          1: se l'operatore da utilizzare nella where-condition e
                             quello specificato per ogni attributo.
       RITORNA:     Un ref_cursor che punta al risultato della query.
       NOTE:        Se p_QBE = 1 , ogni parametro deve contenere, nella prima parte,
                    l'operatore da utilizzare nella where-condition.
      ******************************************************************************/
      d_statement  afc.t_statement;
      d_ref_cursor afc.t_ref_cursor;
   begin
      d_statement := ' select * from revisioni_struttura ' || ' where 1 = 1 ' ||
                     afc.get_field_condition(' and ( ottica ', p_ottica, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( revisione '
                                            ,p_revisione
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( tipo_registro '
                                            ,p_tipo_registro
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( anno ', p_anno, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( numero ', p_numero, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( data '
                                            ,p_data
                                            ,' )'
                                            ,p_qbe
                                            ,afc.date_format) ||
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
                     afc.get_field_condition(' and ( dal '
                                            ,p_dal
                                            ,' )'
                                            ,p_qbe
                                            ,afc.date_format) ||
                     afc.get_field_condition(' and ( data_pubblicazione '
                                            ,p_data_pubblicazione
                                            ,' )'
                                            ,p_qbe
                                            ,afc.date_format) ||
                     afc.get_field_condition(' and ( data_termine '
                                            ,p_data_termine
                                            ,' )'
                                            ,p_qbe
                                            ,afc.date_format) ||
                     afc.get_field_condition(' and ( tipo_revisione '
                                            ,p_tipo_revisione
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( nota ', p_nota, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( stato ', p_stato, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( provenienza '
                                            ,p_provenienza
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( utente_aggiornamento '
                                            ,p_utente_aggiornamento
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( data_aggiornamento '
                                            ,p_data_aggiornamento
                                            ,' )'
                                            ,p_qbe
                                            ,afc.date_format) ||
                     afc.decode_value(p_order_condition
                                     ,null
                                     ,' '
                                     ,' order by ' || p_order_condition);
      open d_ref_cursor for d_statement;
      return d_ref_cursor;
   end; -- Revisione_struttura.get_rows
   --------------------------------------------------------------------------------
   function count_rows
   (
      p_ottica               in varchar2 default null
     ,p_revisione            in varchar2 default null
     ,p_tipo_registro        in varchar2 default null
     ,p_anno                 in varchar2 default null
     ,p_numero               in varchar2 default null
     ,p_data                 in varchar2 default null
     ,p_descrizione          in varchar2 default null
     ,p_descrizione_al1      in varchar2 default null
     ,p_descrizione_al2      in varchar2 default null
     ,p_dal                  in varchar2 default null
     ,p_data_pubblicazione   in varchar2 default null
     ,p_data_termine         in varchar2 default null
     ,p_tipo_revisione       in varchar2 default null
     ,p_nota                 in varchar2 default null
     ,p_stato                in varchar2 default null
     ,p_provenienza          in varchar2 default null
     ,p_utente_aggiornamento in varchar2 default null
     ,p_data_aggiornamento   in varchar2 default null
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
      d_statement := ' select count( * ) from revisioni_struttura ' || ' where 1 = 1 ' ||
                     afc.get_field_condition(' and ( ottica ', p_ottica, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( revisione '
                                            ,p_revisione
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( tipo_registro '
                                            ,p_tipo_registro
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( anno ', p_anno, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( numero ', p_numero, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( data '
                                            ,p_data
                                            ,' )'
                                            ,p_qbe
                                            ,afc.date_format) ||
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
                     afc.get_field_condition(' and ( dal '
                                            ,p_dal
                                            ,' )'
                                            ,p_qbe
                                            ,afc.date_format) ||
                     afc.get_field_condition(' and ( data_pubblicazione '
                                            ,p_data_pubblicazione
                                            ,' )'
                                            ,p_qbe
                                            ,afc.date_format) ||
                     afc.get_field_condition(' and ( data_termine '
                                            ,p_data_termine
                                            ,' )'
                                            ,p_qbe
                                            ,afc.date_format) ||
                     afc.get_field_condition(' and ( tipo_revisione '
                                            ,p_tipo_revisione
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( nota ', p_nota, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( stato ', p_stato, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( provenienza '
                                            ,p_provenienza
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( utente_aggiornamento '
                                            ,p_utente_aggiornamento
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( data_aggiornamento '
                                            ,p_data_aggiornamento
                                            ,' )'
                                            ,p_qbe
                                            ,afc.date_format);
      d_result    := afc.sql_execute(d_statement);
      return d_result;
   end; -- Revisione_struttura.count_rows
   --------------------------------------------------------------------------------
   -- Verifica che la revisione sia in modifica per l'ottica
   function esiste_revisione_mod
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return number is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        esiste_revisione_mod
       DESCRIZIONE: Verifica che la revisione indicata per l'ottica sia in corso di
                    modifica (stato = 'M')
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: 1 se la riga esiste, 0 altrimenti.
       NOTE:
      ******************************************************************************/
      d_result number;
   begin
      dbc.pre(not dbc.preon or canhandle(p_ottica, p_revisione)
             ,'canHandle on Revisione_struttura.esiste_revisione_mod');
      begin
         select 1
           into d_result
           from revisioni_struttura
          where ottica = p_ottica
            and revisione = p_revisione
            and stato = 'M';
      exception
         when no_data_found then
            d_result := 0;
      end;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on Revisione_struttura.esiste_revisione_mod');
      return d_result;
   end; -- Revisione_struttura.esiste_revisione_mod
   --------------------------------------------------------------------------------
   -- Restituisce la revisione in modifica per l'ottica
   function get_revisione_mod(p_ottica in revisioni_struttura.ottica%type)
      return revisioni_struttura.revisione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_revisione_mod
       DESCRIZIONE: Restituisce il progressivo della revisione in corso di
                    modifica per l'ottica; se non esiste, restituisce -1
       PARAMETRI:   Codice ottica
       RITORNA:     number: progressivo revisione in corso di modifica
       NOTE:
      ******************************************************************************/
      d_result number;
   begin
      /*   DbC.PRE ( not DbC.PreOn or canHandle ( p_ottica
                                              )
                 , 'canHandle on Revisione_struttura.esiste_revisione_mod'
                 );
      */
      begin
         select revisione
           into d_result
           from revisioni_struttura
          where ottica = p_ottica
            and stato = 'M';
      exception
         when no_data_found then
            d_result := -1;
      end;
      return d_result;
   end /*   DbC.POST ( d_result = 1  or  d_result = 0
                                                                                                                                    , 'd_result = 1  or  d_result = 0 on Revisione_struttura.esiste_revisione_mod'
                                                                                                                                    );
                                                                                                                        */
   ; -- Revisione_struttura.get_revisione_mod
   --------------------------------------------------------------------------------
   function get_ultima_revisione(p_ottica in revisioni_struttura.ottica%type)
      return revisioni_struttura.revisione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_ultima_revisione
       DESCRIZIONE: Restituisce il progressivo dell'ultimaa revisione attiva
                    per l'ottica
       PARAMETRI:   Codice ottica
       RITORNA:     number: progressivo ultima revisione
       NOTE:
      ******************************************************************************/
      d_result number;
   begin
      select nvl(max(revisione), -1)
        into d_result
        from revisioni_struttura
       where ottica = p_ottica
         and stato = 'A'
         and nvl(tipo_revisione, 'N') = 'N';
      return d_result;
   end; -- Revisione_struttura.get_revisione_mod
   --------------------------------------------------------------------------------
   -- Esistenza delibera su revisione per ottica
   function esiste_delibera
   (
      p_ottica        in revisioni_struttura.ottica%type
     ,p_revisione     in revisioni_struttura.revisione%type default null
     ,p_tipo_registro in revisioni_struttura.tipo_registro%type default null
     ,p_anno          in revisioni_struttura.anno%type default null
     ,p_numero        in revisioni_struttura.numero%type default null
     ,p_data          in revisioni_struttura.data%type default null
   ) return number is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        esiste_delibera
       DESCRIZIONE: Esistenza di una delibera nell'ambito dell'ottica
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: 1 se la riga esiste, 0 altrimenti.
       NOTE:
      ******************************************************************************/
      d_result number;
   begin
      dbc.pre(not dbc.preon or canhandle(p_ottica, p_revisione)
             ,'canHandle on Revisione_struttura.esiste_delibera');
      if p_tipo_registro is not null or p_anno is not null or p_numero is not null or
         p_data is not null then
         begin
            select 1
              into d_result
              from revisioni_struttura
             where ottica = p_ottica
               and revisione != nvl(p_revisione, -1)
               and nvl(tipo_registro, ' ') = nvl(p_tipo_registro, ' ')
               and nvl(anno, -1) = nvl(p_anno, -1)
               and nvl(numero, -1) = nvl(p_numero, -1)
               and nvl(data, to_date('2200-12-31', 'YYYY-MM-DD')) =
                   nvl(p_data, to_date('2200-12-31', 'YYYY-MM-DD'));
         exception
            when no_data_found then
               d_result := 0;
         end;
      end if;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on Revisione_struttura.esiste_delibera');
      return d_result;
   end; -- Revisione_struttura.esiste_delibera
   --------------------------------------------------------------------------------
   -- Controllo di congruenza sulle date delle revisioni
   function is_data_ok
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
     ,p_data      in revisioni_struttura.data%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_data_ok
       DESCRIZIONE: Controllo di congruenza sulle date delle revisioni
       PARAMETRI:   Ottica e campo data del nuovo record
       RITORNA:     Afc_error.t_error_number
       NOTE:
      ******************************************************************************/
      d_result   afc_error.t_error_number := s_data_revisione_errata_number;
      d_max_data revisioni_struttura.dal%type;
   begin
      set_tipo_revisione(p_ottica, p_revisione);
      begin
         select max(r.dal)
           into d_max_data
           from revisioni_struttura r
          where r.ottica = p_ottica
            and r.revisione <> p_revisione;
      exception
         when others then
            d_result := s_data_revisione_errata_number;
      end;
      if s_tipo_revisione = 'N' then
         if d_max_data is null or (d_max_data is not null and d_max_data < p_data) then
            d_result := afc_error.ok;
         end if;
      else
         if d_max_data is not null and d_max_data >= p_data then
            d_result := afc_error.ok;
         end if;
      end if;
      return d_result;
   end; -- Revisione_struttura.is_data_ok
   --------------------------------------------------------------------------------
   function is_ri_ok
   (
      p_ottica             in revisioni_struttura.ottica%type
     ,p_revisione          in revisioni_struttura.revisione%type
     ,p_data               in revisioni_struttura.data%type
     ,p_new_stato          in revisioni_struttura.stato%type
     ,p_old_stato          in revisioni_struttura.stato%type
     ,p_new_tipo_revisione in revisioni_struttura.stato%type default null
     ,p_old_tipo_revisione in revisioni_struttura.stato%type default null
   ) return afc_error.t_error_number is
      d_result afc_error.t_error_number := afc_error.ok;
   begin
      if p_data is not null and nvl(p_new_tipo_revisione, 'N') = 'N' then
         d_result := is_data_ok(p_ottica, p_revisione, p_data);
      end if;
      if d_result = afc_error.ok then
         if p_new_stato = 'A' and p_old_stato = 'M' and
            nvl(p_new_tipo_revisione, 'N') = 'N' then
            d_result := unita_organizzativa.is_legami_revisione_ok(p_ottica
                                                                  ,p_revisione
                                                                  ,p_data
                                                                  ,0);
            if d_result = afc_error.ok and nvl(p_new_tipo_revisione, 'N') = 'N' then
               d_result := unita_organizzativa.is_legami_revisione_ok(p_ottica
                                                                     ,p_revisione
                                                                     ,p_data
                                                                     ,1);
            end if;
            if d_result = afc_error.ok then
               d_result := componente.is_componenti_revisione_ok(p_ottica
                                                                ,p_revisione
                                                                ,p_data
                                                                ,0);
            end if;
            /*if d_result = afc_error.ok then --#500
               d_result := componente.is_componenti_revisione_ok(p_ottica
                                                                ,p_revisione
                                                                ,p_data
                                                                ,1);
            end if;*/
            if d_result = afc_error.ok then
               d_result := attributo_componente.is_attributi_revisione_ok(p_ottica
                                                                         ,p_revisione
                                                                         ,p_data
                                                                         ,0);
            end if;
            /*if d_result = afc_error.ok then --#500
               d_result := attributo_componente.is_attributi_revisione_ok(p_ottica
                                                                         ,p_revisione
                                                                         ,p_data
                                                                         ,1);
            end if;*/
         end if;
      end if;
      if p_new_stato = 'M' and d_result = afc_error.ok then
         begin
            select 'x'
              into s_dummy
              from revisioni_struttura
             where ottica = p_ottica
               and revisione <> p_revisione
               and stato = 'M';
            raise too_many_rows;
         exception
            when no_data_found then
               d_result := afc_error.ok;
            when too_many_rows then
               d_result := s_esiste_rev_modifica_number;
         end;
      end if;
      --
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on Revisione_struttura.is_DI_ok');
      return d_result;
   end; -- Revisione_struttura.is_RI_ok
   --------------------------------------------------------------------------------
   procedure chk_ri
   (
      p_ottica             in revisioni_struttura.ottica%type
     ,p_revisione          in revisioni_struttura.revisione%type
     ,p_data               in revisioni_struttura.data%type
     ,p_new_stato          in revisioni_struttura.stato%type
     ,p_old_stato          in revisioni_struttura.stato%type
     ,p_new_tipo_revisione in revisioni_struttura.stato%type default null
     ,p_old_tipo_revisione in revisioni_struttura.stato%type default null
   ) is
      /******************************************************************************
       NOME:        chk_RI.
       DESCRIZIONE: controllo integrita dati:
                    - controllo presenza revisione in legami di struttura e componenti
       RITORNA:     -
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
      d_result := is_ri_ok(p_ottica
                          ,p_revisione
                          ,p_data
                          ,p_new_stato
                          ,p_old_stato
                          ,p_new_tipo_revisione
                          ,p_old_tipo_revisione);
      dbc.assertion(not dbc.assertionon or d_result = afc_error.ok or d_result < 0
                   ,'d_result = AFC_Error.ok or d_result < 0 on Revisione_struttura.chk_DI');
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, error_message(d_result));
      end if;
   end; -- Revisione_struttura.chk_RI
   --------------------------------------------------------------------------------
   procedure verifica_revisione
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
     ,p_data      in revisioni_struttura.dal%type
     ,p_ni        in componenti.ni%type default null
   ) is
      /******************************************************************************
       NOME:        verifica_revisione.
       DESCRIZIONE: Verifica che le date DAL e AL da aggiornare siano
                    congruenti con la data inizio validita' della revisione
       RITORNA:     -
      ******************************************************************************/
      d_codice_uo        anagrafe_unita_organizzative.codice_uo%type;
      d_descrizione      anagrafe_unita_organizzative.descrizione%type;
      d_al               anagrafe_unita_organizzative.al%type;
      d_periodo          afc_periodo.t_periodo;
      d_dal_componente   attributi_componente.dal%type;
      d_result           afc_error.t_error_number;
      d_errore           varchar2(2);
      d_messaggio        varchar2(2000);
      d_wore_id          work_revisioni.id_work_revisione%type;
      d_obbligo_sefi     impostazioni.obbligo_sefi%type;
      d_obbligo_imbi     impostazioni.obbligo_imbi%type;
      d_nominativo       varchar2(100);
      d_data_pubb        date := nvl(revisione_struttura.get_data_pubblicazione(p_ottica
                                                                               ,p_revisione)
                                    ,p_data);
      d_integrazione_gp4 impostazioni.integr_gp4%type := impostazione.get_integr_gp4(1);
      d_dummy            varchar2(1);
   begin
      set_tipo_revisione(p_ottica, p_revisione);
      -- la data di pubblicazione non può essere precedente la sysdate
      if d_data_pubb < trunc(sysdate) or d_data_pubb is null or d_data_pubb = p_data then
         select greatest(trunc(sysdate), p_data) into d_data_pubb from dual;
      end if;
      delete from work_revisioni
       where ottica = p_ottica
         and revisione = p_revisione;
      -- la data di pubblicazione non può essere precedente la decorrenza
      if d_data_pubb < p_data then
         d_messaggio := 'La data di pubblicazione e'' precedente la data di decorrenza';
         d_errore    := 'SI';
         d_wore_id   := work_revisione.get_id_errore(p_ottica                    => p_ottica
                                                    ,p_revisione                 => p_revisione
                                                    ,p_progr_unita_organizzativa => ''
                                                    ,p_ni                        => ''
                                                    ,p_errore_bloccante          => 'SI');
         if d_wore_id is null then
            begin
               work_revisione.ins(p_id_work_revisione         => null
                                 ,p_ottica                    => p_ottica
                                 ,p_revisione                 => p_revisione
                                 ,p_data                      => p_data
                                 ,p_messaggio                 => d_messaggio
                                 ,p_errore_bloccante          => 'SI'
                                 ,p_progr_unita_organizzativa => ''
                                 ,p_codice_uo                 => ''
                                 ,p_descr_uo                  => ''
                                 ,p_ni                        => ''
                                 ,p_nominativo                => '');
            exception
               when others then
                  raise_application_error(-20999, 'Errore in inserimento WORK_REVISIONI');
            end;
         end if;
      end if;
      --
      --
      -- Controllo Struttura
      --
      -- I controlli non vengono eseguiti se e'' stata richiesta una elaborazione ad personam
      --
      if p_ni is null then
         --
         -- Controllo legami struttura
         --
         for sel_unor in (select progr_unita_organizzativa progr_uo
                                ,dal
                                ,al
                                ,revisione
                                ,revisione_cessazione
                                ,rowid
                            from unita_organizzative
                           where ottica = p_ottica
                             and (revisione = p_revisione or
                                 revisione_cessazione = p_revisione)
                           order by progr_unita_organizzativa)
         loop
            d_errore := 'NO';
            begin
               select codice_uo
                     ,descrizione
                 into d_codice_uo
                     ,d_descrizione
                 from anagrafe_unita_organizzative
                where progr_unita_organizzativa = sel_unor.progr_uo
                  and nvl(sel_unor.dal, p_data) between dal and
                      nvl(al, to_date(3333333, 'j'));
            exception
               when no_data_found then
                  d_codice_uo   := lpad('*', 16, '*');
                  d_descrizione := 'Unita'' non codificata';
               when others then
                  raise_application_error(-20999
                                         ,'Errore in lettura ANAGRAFE_UNITA_ORGANIZZATIVE (' ||
                                          sel_unor.progr_uo || ') - ' || sqlerrm);
            end;
            --
            -- Controllo legami inseriti con la revisione
            --
            if sel_unor.revisione = p_revisione and nvl(s_tipo_revisione, 'N') = 'N' then
               --
               -- Si segnalano i legami inseriti per la revisione aventi data inizio
               -- validita' inferiore alla data di inizio validita' revisione
               --
               if sel_unor.dal is not null then
                  if sel_unor.dal < p_data then
                     d_messaggio := 'Inserita in struttura in data antecedente alla data di inizio validita'' della revisione';
                     d_errore    := 'SI';
                  end if;
               else
                  --
                  -- Si segnalano i legami inseriti per la revisione per cui aggiornando
                  -- la data di inizio validita' si avrebbero periodi non congruenti
                  --
                  d_periodo := unita_organizzativa.get_ultimo_periodo(p_ottica
                                                                     ,sel_unor.progr_uo
                                                                     ,sel_unor.rowid);
                  --
                  if d_periodo.dal is not null then
                     if p_data <= d_periodo.dal then
                        d_messaggio := 'Data inizio validita'' non congruente con periodo precedente';
                        d_errore    := 'SI';
                     end if;
                  end if;
               end if;
            end if;
            --
            -- Controllo legami cessati con la revisione
            --
            if sel_unor.revisione_cessazione = p_revisione and
               nvl(s_tipo_revisione, 'N') = 'N' then
               --
               -- Si segnalano i legami cessati con la revisione aventi data fine
               -- validita' diversa dalla data di inizio revisione - 1
               --
               if sel_unor.al is not null then
                  if sel_unor.al <> p_data - 1 then
                     d_messaggio := 'Eliminata dalla struttura in data successiva alla data di inizio validita'' della revisione';
                     d_errore    := 'SI';
                  end if;
               else
                  --
                  -- Se il legame ha l'AL nullo, si controlla che le date del legame
                  -- cessato siano congruenti
                  --
                  if nvl(s_tipo_revisione, 'N') = 'N' then
                     d_result := unita_organizzativa.is_dal_al_ok(sel_unor.dal
                                                                 ,p_data - 1);
                     if d_result <> afc_error.ok then
                        d_messaggio := unita_organizzativa.error_message(d_result);
                        d_errore    := 'SI';
                     end if;
                  end if;
                  d_result := unita_organizzativa.is_ultimo_periodo(p_ottica
                                                                   ,sel_unor.progr_uo
                                                                   ,sel_unor.dal);
                  if not d_result = afc_error.ok then
                     d_messaggio := 'Impossibile modificare periodi diversi dall''ultimo';
                     d_errore    := 'SI';
                  end if;
               end if;
            end if;
            if sel_unor.revisione_cessazione = p_revisione then
               --
               -- Si segnalano le assegnazioni al di fuori del periodo di definizione della UO
               --
               d_nominativo := '';
               select min(cognome || '  ' || nome || ' Ni: ' || ni)
                 into d_nominativo
                 from anagrafe_soggetti a
                where ni in (select ni
                               from componenti c
                              where progr_unita_organizzativa = sel_unor.progr_uo
                                and nvl(c.al, to_date(3333333, 'j')) > p_data - 1
                                and nvl(c.revisione_cessazione, -1) <> p_revisione
                                and c.dal <= nvl(c.al, to_date(3333333, 'j')) --#709
                                   -- controllo che l'assegnazione faccia riferimento all'ottica
                                   -- REDMINE 292
                                and ottica = p_ottica
                                   --
                                and not exists
                              (select 'x'
                                       from unita_organizzative
                                      where progr_unita_organizzativa = sel_unor.progr_uo
                                        and ottica = p_ottica
                                        and revisione = p_revisione));
               if d_nominativo is not null then
                  d_messaggio := 'UO non eliminabile: esistono assegnazioni valide (' ||
                                 d_nominativo || ')';
                  d_errore    := 'SI';
               end if;
               --
               -- Si segnalano le assegnazioni al di fuori del periodo di pubblicazione della UO
               --
               d_nominativo := '';
               select min(cognome || '  ' || nome || ' Ni: ' || ni)
                 into d_nominativo
                 from anagrafe_soggetti a
                where ni in
                      (select ni
                         from componenti c
                        where progr_unita_organizzativa = sel_unor.progr_uo
                          and nvl(c.al_pubb, to_date(3333333, 'j')) > d_data_pubb - 1
                          and nvl(c.revisione_cessazione, -1) <> p_revisione
                             -- controllo che l'assegnazione faccia riferimento all'ottica
                             -- REDMINE 292
                          and ottica = p_ottica
                             --
                          and not exists
                        (select 'x'
                                 from unita_organizzative
                                where progr_unita_organizzativa = sel_unor.progr_uo
                                  and ottica = p_ottica
                                  and revisione = p_revisione));
               if d_nominativo is not null then
                  d_messaggio := 'UO non eliminabile: esistono assegnazioni pubblicate (' ||
                                 d_nominativo || ')';
                  d_errore    := 'SI';
               end if;
            end if;
            --
            -- Se si e' verificato un errore, si inserisce il messaggio nella
            -- tabella WORK_REVISIONI
            --
            if d_errore = 'SI' then
               d_wore_id := work_revisione.get_id_errore(p_ottica                    => p_ottica
                                                        ,p_revisione                 => p_revisione
                                                        ,p_progr_unita_organizzativa => sel_unor.progr_uo
                                                        ,p_ni                        => null
                                                        ,p_errore_bloccante          => 'SI');
               if d_wore_id is null then
                  begin
                     work_revisione.ins(p_id_work_revisione         => null
                                       ,p_ottica                    => p_ottica
                                       ,p_revisione                 => p_revisione
                                       ,p_data                      => p_data
                                       ,p_messaggio                 => d_messaggio
                                       ,p_errore_bloccante          => 'SI'
                                       ,p_progr_unita_organizzativa => sel_unor.progr_uo
                                       ,p_codice_uo                 => d_codice_uo
                                       ,p_descr_uo                  => d_descrizione
                                       ,p_ni                        => null
                                       ,p_nominativo                => null);
                  exception
                     when others then
                        raise_application_error(-20999
                                               ,'Errore in inserimento WORK_REVISIONI - ' ||
                                                sqlerrm);
                  end;
               else
                  begin
                     update work_revisioni
                        set messaggio = substr(decode(messaggio
                                                     ,null
                                                     ,null
                                                     ,messaggio || ' - ') || d_messaggio
                                              ,1
                                              ,2000)
                      where id_work_revisione = d_wore_id;
                  exception
                     when others then
                        raise_application_error(-20999
                                               ,'Errore in aggiornamento WORK_REVISIONI (' ||
                                                d_wore_id || ') - ' || sqlerrm);
                  end;
               end if;
            end if;
         end loop;
         --
         -- Controllo unita' organizzative con componenti e non inserite in struttura
         --
         for sel_unita in (select a.progr_unita_organizzativa progr_uo
                                 ,a.codice_uo
                                 ,a.descrizione
                             from anagrafe_unita_organizzative a
                            where a.ottica = p_ottica
                              and a.al is null
                              and exists (select 'x'
                                     from componenti c
                                    where c.ottica = p_ottica
                                      and c.progr_unita_organizzativa =
                                          a.progr_unita_organizzativa
                                      and al is null)
                              and not exists (select 'x'
                                     from unita_organizzative u
                                    where u.ottica = p_ottica
                                      and u.progr_unita_organizzativa =
                                          a.progr_unita_organizzativa
                                      and al is null))
         loop
            d_messaggio := 'U.O. non presente in struttura ma con componenti assegnati';
            d_wore_id   := work_revisione.get_id_errore(p_ottica                    => p_ottica
                                                       ,p_revisione                 => p_revisione
                                                       ,p_progr_unita_organizzativa => sel_unita.progr_uo
                                                       ,p_ni                        => null
                                                       ,p_errore_bloccante          => 'SI');
            if d_wore_id is null then
               begin
                  work_revisione.ins(p_id_work_revisione         => null
                                    ,p_ottica                    => p_ottica
                                    ,p_revisione                 => p_revisione
                                    ,p_data                      => p_data
                                    ,p_messaggio                 => d_messaggio
                                    ,p_errore_bloccante          => 'SI'
                                    ,p_progr_unita_organizzativa => sel_unita.progr_uo
                                    ,p_codice_uo                 => sel_unita.codice_uo
                                    ,p_descr_uo                  => sel_unita.descrizione
                                    ,p_ni                        => null
                                    ,p_nominativo                => null);
               exception
                  when others then
                     raise_application_error(-20999
                                            ,'Errore in inserimento WORK_REVISIONI');
               end;
            else
               begin
                  update work_revisioni
                     set messaggio = substr(decode(messaggio
                                                  ,null
                                                  ,null
                                                  ,messaggio || ' - ') || d_messaggio
                                           ,1
                                           ,2000)
                   where id_work_revisione = d_wore_id;
               exception
                  when others then
                     raise_application_error(-20999
                                            ,'Errore in aggiornamento WORK_REVISIONI (' ||
                                             d_wore_id || ') - ' || sqlerrm);
               end;
            end if;
         end loop;
         --
         -- Controllo anagrafe unita' organizzative
         --
         for sel_anuo in (select progr_unita_organizzativa
                                ,codice_uo
                                ,descrizione
                                ,dal
                                ,al
                                ,revisione_istituzione
                                ,revisione_cessazione
                                ,rowid
                            from anagrafe_unita_organizzative
                           where ottica = p_ottica
                             and (revisione_istituzione = p_revisione or
                                 (revisione_cessazione = p_revisione and al is null))
                           order by progr_unita_organizzativa)
         loop
            d_errore := 'NO';
            if sel_anuo.revisione_istituzione = p_revisione and sel_anuo.dal > p_data then
               d_periodo := anagrafe_unita_organizzativa.get_periodo_precedente(sel_anuo.progr_unita_organizzativa
                                                                               ,sel_anuo.dal
                                                                               ,sel_anuo.rowid);
               if d_periodo.dal is not null and d_periodo.al is not null then
                  if p_data not between d_periodo.dal and d_periodo.al then
                     d_messaggio := '(Anagrafica) Data inizio validita'' non congruente con periodo precedente';
                     d_errore    := 'SI';
                  end if;
               end if;
            end if;
            if sel_anuo.revisione_cessazione = p_revisione and sel_anuo.al is null then
               if nvl(s_tipo_revisione, 'N') = 'N' then
                  d_result := anagrafe_unita_organizzativa.is_dal_al_ok(sel_anuo.dal
                                                                       ,p_data - 1);
                  if d_result <> afc_error.ok then
                     d_messaggio := anagrafe_unita_organizzativa.error_message(d_result);
                     d_errore    := 'SI';
                  end if;
               end if;
               d_result := anagrafe_unita_organizzativa.is_ultimo_periodo(sel_anuo.progr_unita_organizzativa
                                                                         ,sel_anuo.dal);
               if d_result <> afc_error.ok then
                  d_messaggio := 'Impossibile modificare periodi diversi dall''ultimo';
                  d_errore    := 'SI';
               end if;
            end if;
            --
            -- Se si e' verificato un errore, si inserisce il messaggio nella
            -- tabella WORK_REVISIONI
            --
            if d_errore = 'SI' then
               begin
                  work_revisione.ins(p_id_work_revisione         => null
                                    ,p_ottica                    => p_ottica
                                    ,p_revisione                 => p_revisione
                                    ,p_data                      => p_data
                                    ,p_messaggio                 => d_messaggio
                                    ,p_errore_bloccante          => 'SI'
                                    ,p_progr_unita_organizzativa => sel_anuo.progr_unita_organizzativa
                                    ,p_codice_uo                 => sel_anuo.codice_uo
                                    ,p_descr_uo                  => sel_anuo.descrizione
                                    ,p_ni                        => null
                                    ,p_nominativo                => null);
               exception
                  when others then
                     raise_application_error(-20999
                                            ,'Errore in inserimento WORK_REVISIONI');
               end;
            end if;
         end loop;
      end if;
      --
      -- Controllo componenti
      --
      for sel_comp in (select id_componente
                             ,ni
                             ,ci
                             ,decode(ni
                                    ,null
                                    ,denominazione
                                    ,soggetti_get_descr(ni, dal, 'COGNOME E NOME')) denominazione
                             ,dal
                             ,nvl(al
                                 ,decode(revisione_cessazione
                                        ,p_revisione
                                        ,p_data - 1
                                        ,al)) al --redmine 338
                             ,revisione_assegnazione
                             ,revisione_cessazione
                             ,progr_unita_organizzativa progr_uo
                             ,(select assegnazione_prevalente
                                 from attributi_componente
                                where id_componente = c.id_componente
                                  and p_data between nvl(dal, to_date(2222222, 'j')) and
                                      nvl(al, to_date(3333333, 'j'))) assegnazione_prevalente --#645
                             ,rowid
                         from componenti c
                        where ottica = p_ottica
                          and ni = nvl(p_ni, ni) --issue 316, elaborazione ad personam
                          and (revisione_assegnazione = p_revisione or
                              revisione_cessazione = p_revisione)
                        order by denominazione)
      loop
         d_errore    := 'NO';
         d_messaggio := '';
         begin
            -- memorizzo i dati dell'UO
            select codice_uo
                  ,descrizione
              into d_codice_uo
                  ,d_descrizione
              from anagrafe_unita_organizzative
             where progr_unita_organizzativa = sel_comp.progr_uo
               and nvl(sel_comp.dal, p_data) between dal and
                   nvl(al, to_date(3333333, 'j'));

            -- memorizzo l'eventuale data di termine dell'UO
            select al
              into d_al
              from anagrafe_unita_organizzative a
             where progr_unita_organizzativa = sel_comp.progr_uo
               and dal = (select max(dal)
                            from anagrafe_unita_organizzative
                           where progr_unita_organizzativa = sel_comp.progr_uo);

         exception
            when no_data_found then
               d_codice_uo   := lpad('*', 16, '*');
               d_descrizione := 'Unita'' non codificata';
            when others then
               raise_application_error(-20999
                                      ,'Errore in lettura ANAGRAFE_UNITA_ORGANIZZATIVE (' ||
                                       sel_comp.progr_uo || ') - ' || sqlerrm);
         end;
         --
         -- Controllo componenti assegnati con la revisione
         --
         if sel_comp.revisione_assegnazione = p_revisione then
            --
            -- Si segnalano i componenti assegnati per la revisione aventi data inizio
            -- validita' inferiore alla data di inizio validita' revisione
            --
            if sel_comp.dal is not null then
               if sel_comp.dal < p_data then
                  d_messaggio := 'Componente assegnato alla unita'' in data antecedente alla data di inizio validita'' della revisione (id=' ||
                                 sel_comp.id_componente || ')';
                  d_errore    := 'SI';
               end if;
            end if;

            --
            -- Si verifica che l'UO di assegnazione sia definita per l'intero periodo
            --

            begin
               select 'x'
                 into d_dummy
                 from unita_organizzative u
                where u.progr_unita_organizzativa = sel_comp.progr_uo
                  and u.ottica = p_ottica
                  and exists
                (select 'x'
                         from unita_organizzative
                        where progr_unita_organizzativa = u.progr_unita_organizzativa
                          and ottica = u.ottica
                          and nvl(sel_comp.dal, nvl(dal, to_date(2222222, 'j'))) between
                              nvl(dal, to_date(2222222, 'j')) and
                              nvl(decode(revisione_cessazione, p_revisione, p_data - 1, al)
                                 ,to_date(3333333, 'j')))
                  and exists
                (select 'x'
                         from unita_organizzative
                        where progr_unita_organizzativa = u.progr_unita_organizzativa
                          and ottica = u.ottica
                          and nvl(sel_comp.al, to_date(3333333, 'j')) between
                              nvl(dal, to_date(2222222, 'j')) and
                              nvl(decode(revisione_cessazione, p_revisione, p_data - 1, al)
                                 ,to_date(3333333, 'j')));
               raise too_many_rows;
            exception
               when too_many_rows then
                  null;
               when no_data_found then
                  d_messaggio := 'Unita'' organizzativa non in struttura per il periodo indicato (id=' ||
                                 sel_comp.id_componente || ')';
                  d_errore    := 'SI';
            end;

            -- non e' ammesso riassegnare un individuo alla stessa UO in periodi sovrapposti
            -- viene concessa una eccezione per le registrazioni di provenienza GPS
            if d_errore = 'NO' then
               begin
                  select 'x'
                    into d_dummy
                    from componenti c
                   where c.progr_unita_organizzativa = sel_comp.progr_uo
                     and c.ottica = p_ottica
                     and c.id_componente <> sel_comp.id_componente
                     and c.ni = sel_comp.ni
                     and not
                          ((select attributo_componente.get_assegnazione_valida(c.id_componente
                                                                               ,p_data
                                                                               ,c.ottica)
                              from dual) = 99 or sel_comp.assegnazione_prevalente = 99)
                     and nvl(revisione_assegnazione, -1) <> p_revisione
                     and ((c.ci = sel_comp.ci) or c.ci is null) --#645
                     and nvl(c.dal, to_date(2222222, 'j')) <=
                         nvl(sel_comp.al, to_date(3333333, 'j'))
                     and nvl(c.al, to_date(3333333, 'j')) >= nvl(sel_comp.dal, p_data);
                  raise too_many_rows;
               exception
                  when no_data_found then
                     null;
                  when too_many_rows then
                     d_messaggio := 'Componente gia'' assegnato alla unita'' nello stesso periodo (id=' ||
                                    sel_comp.id_componente || ')';
                     if s_tipo_revisione <> 'R' then
                        d_errore := 'SI';
                     else
                        d_wore_id := work_revisione.get_id_errore(p_ottica                    => p_ottica
                                                                 ,p_revisione                 => p_revisione
                                                                 ,p_progr_unita_organizzativa => sel_comp.progr_uo
                                                                 ,p_ni                        => sel_comp.ni
                                                                 ,p_errore_bloccante          => 'NO');
                        if d_wore_id is null then
                           begin
                              work_revisione.ins(p_id_work_revisione         => null
                                                ,p_ottica                    => p_ottica
                                                ,p_revisione                 => p_revisione
                                                ,p_data                      => p_data
                                                ,p_messaggio                 => d_messaggio
                                                ,p_errore_bloccante          => 'NO'
                                                ,p_progr_unita_organizzativa => sel_comp.progr_uo
                                                ,p_codice_uo                 => d_codice_uo
                                                ,p_descr_uo                  => d_descrizione
                                                ,p_ni                        => sel_comp.ni
                                                ,p_nominativo                => sel_comp.denominazione);
                           exception
                              when others then
                                 raise_application_error(-20999
                                                        ,'Errore in inserimento WORK_REVISIONI');
                           end;
                        else
                           begin
                              update work_revisioni
                                 set messaggio = substr(decode(messaggio
                                                              ,null
                                                              ,null
                                                              ,messaggio || ' - ') ||
                                                        d_messaggio
                                                       ,1
                                                       ,2000)
                               where id_work_revisione = d_wore_id;
                           exception
                              when others then
                                 raise_application_error(-20999
                                                        ,'Errore in aggiornamento WORK_REVISIONI (' ||
                                                         d_wore_id || ') - ' || sqlerrm);
                           end;
                        end if;
                     end if;
               end;
            end if;
            --
            -- Controlla se l'assegnazione e' stata eseguita su di una unita' gia' chiusa
            --
            if d_al is not null and sel_comp.al = d_al then
               d_messaggio := 'Componente assegnato ad una U.O. gia'' chiusa: il periodo e'' stato chiuso alla data di termine dell''U.O (id=' ||
                              sel_comp.id_componente || ')';
               d_wore_id   := work_revisione.get_id_errore(p_ottica                    => p_ottica
                                                          ,p_revisione                 => p_revisione
                                                          ,p_progr_unita_organizzativa => sel_comp.progr_uo
                                                          ,p_ni                        => sel_comp.ni
                                                          ,p_errore_bloccante          => 'NO');
               if d_wore_id is null then
                  begin
                     work_revisione.ins(p_id_work_revisione         => null
                                       ,p_ottica                    => p_ottica
                                       ,p_revisione                 => p_revisione
                                       ,p_data                      => p_data
                                       ,p_messaggio                 => d_messaggio
                                       ,p_errore_bloccante          => 'NO'
                                       ,p_progr_unita_organizzativa => sel_comp.progr_uo
                                       ,p_codice_uo                 => d_codice_uo
                                       ,p_descr_uo                  => d_descrizione
                                       ,p_ni                        => sel_comp.ni
                                       ,p_nominativo                => sel_comp.denominazione);
                  exception
                     when others then
                        raise_application_error(-20999
                                               ,'Errore in inserimento WORK_REVISIONI');
                  end;
               else
                  begin
                     update work_revisioni
                        set messaggio = substr(decode(messaggio
                                                     ,null
                                                     ,null
                                                     ,messaggio || ' - ') || d_messaggio
                                              ,1
                                              ,2000)
                      where id_work_revisione = d_wore_id;
                  exception
                     when others then
                        raise_application_error(-20999
                                               ,'Errore in aggiornamento WORK_REVISIONI (' ||
                                                d_wore_id || ') - ' || sqlerrm);
                  end;
               end if;
            end if;
            --
            -- Controlla se è necessario segnalare o meno le imputazioni_bliancio e le sedi_fisiche mancanti
            --
            select i.obbligo_imbi
                  ,i.obbligo_sefi
              into d_obbligo_imbi
                  ,d_obbligo_sefi
              from impostazioni i;
            --
            -- Si segnalano le imputazioni_bilancio mancanti (errore non bloccante) se nella tabella IMPOSTAZIONI
            -- il relativo campo è settato a SI
            --
            if d_obbligo_imbi = 'SI' then
               begin
                  select afc_error.ok
                    into d_result
                    from imputazioni_bilancio
                   where id_componente = sel_comp.id_componente
                     and nvl(al, to_date(3333333, 'j')) =
                         nvl(sel_comp.al, to_date(3333333, 'j'));
               exception
                  when no_data_found then
                     d_result := 0;
                  when too_many_rows then
                     d_result := afc_error.ok;
               end;
               if d_result != afc_error.ok then
                  d_wore_id := work_revisione.get_id_errore(p_ottica                    => p_ottica
                                                           ,p_revisione                 => p_revisione
                                                           ,p_progr_unita_organizzativa => sel_comp.progr_uo
                                                           ,p_ni                        => sel_comp.ni
                                                           ,p_errore_bloccante          => 'NO');
                  if d_wore_id is null then
                     begin
                        work_revisione.ins(p_id_work_revisione         => null
                                          ,p_ottica                    => p_ottica
                                          ,p_revisione                 => p_revisione
                                          ,p_data                      => p_data
                                          ,p_messaggio                 => 'Imputazione bilancio mancante (id=' ||
                                                                          sel_comp.id_componente || ')'
                                          ,p_errore_bloccante          => 'NO'
                                          ,p_progr_unita_organizzativa => sel_comp.progr_uo
                                          ,p_codice_uo                 => d_codice_uo
                                          ,p_descr_uo                  => d_descrizione
                                          ,p_ni                        => sel_comp.ni
                                          ,p_nominativo                => sel_comp.denominazione);
                     exception
                        when others then
                           raise_application_error(-20999
                                                  ,'Errore in inserimento WORK_REVISIONI');
                     end;
                  else
                     begin
                        update work_revisioni
                           set messaggio = substr(decode(messaggio
                                                        ,null
                                                        ,null
                                                        ,messaggio || ' - ') ||
                                                  'Imputazione bilancio mancante (id=' ||
                                                  sel_comp.id_componente || ')'
                                                 ,1
                                                 ,2000)
                         where id_work_revisione = d_wore_id;
                     exception
                        when others then
                           raise_application_error(-20999
                                                  ,'Errore in aggiornamento WORK_REVISIONI (' ||
                                                   d_wore_id || ') - ' || sqlerrm);
                     end;
                  end if;
               end if;
            end if;
            --
            -- Se ubicazioni_componente è obbligatoria si segnalano le sedi mancanti (se nella tabella IMPOSTAZIONI
            -- il relativo campo è settato a SI)
            --
            if d_obbligo_sefi = 'SI' then
               begin
                  select afc_error.ok
                    into d_result
                    from ubicazioni_componente
                   where id_componente = sel_comp.id_componente
                     and nvl(al, to_date(3333333, 'j')) =
                         nvl(sel_comp.al, to_date(3333333, 'j'));
               exception
                  when no_data_found then
                     d_result := 0;
                  when too_many_rows then
                     d_result := afc_error.ok;
               end;
               if d_result != afc_error.ok then
                  d_wore_id := work_revisione.get_id_errore(p_ottica                    => p_ottica
                                                           ,p_revisione                 => p_revisione
                                                           ,p_progr_unita_organizzativa => sel_comp.progr_uo
                                                           ,p_ni                        => sel_comp.ni
                                                           ,p_errore_bloccante          => 'NO');
                  if d_wore_id is null then
                     begin
                        work_revisione.ins(p_id_work_revisione         => null
                                          ,p_ottica                    => p_ottica
                                          ,p_revisione                 => p_revisione
                                          ,p_data                      => p_data
                                          ,p_messaggio                 => 'Sede fisica mancante (id=' ||
                                                                          sel_comp.id_componente || ')'
                                          ,p_errore_bloccante          => 'NO'
                                          ,p_progr_unita_organizzativa => sel_comp.progr_uo
                                          ,p_codice_uo                 => d_codice_uo
                                          ,p_descr_uo                  => d_descrizione
                                          ,p_ni                        => sel_comp.ni
                                          ,p_nominativo                => sel_comp.denominazione);
                     exception
                        when others then
                           raise_application_error(-20999
                                                  ,'Errore in inserimento WORK_REVISIONI');
                     end;
                  else
                     begin
                        update work_revisioni
                           set messaggio = substr(decode(messaggio
                                                        ,null
                                                        ,null
                                                        ,messaggio || ' - ') ||
                                                  'Sede fisica mancante (id=' ||
                                                  sel_comp.id_componente || ')'
                                                 ,1
                                                 ,2000)
                         where id_work_revisione = d_wore_id;
                     exception
                        when others then
                           raise_application_error(-20999
                                                  ,'Errore in aggiornamento WORK_REVISIONI (' ||
                                                   d_wore_id || ') - ' || sqlerrm);
                     end;
                  end if;
               end if;
            end if;
         end if;
         --
         -- Controllo componenti cessati con la revisione
         --
         if sel_comp.revisione_cessazione = p_revisione then
            --
            -- Si segnalano i componenti cessati con la revisione aventi data fine
            -- validita' diversa dalla data di inizio validita' revisione - 1
            --
            if sel_comp.al is not null then
               if sel_comp.al <> p_data - 1 then
                  d_messaggio := 'Componente eliminato dall''unita'' in data successiva alla data di inizio validita'' della revisione (id=' ||
                                 sel_comp.id_componente || ')';
                  d_errore    := 'NO'; --#500
                  work_revisione.ins(p_id_work_revisione         => null
                                    ,p_ottica                    => p_ottica
                                    ,p_revisione                 => p_revisione
                                    ,p_data                      => p_data
                                    ,p_messaggio                 => d_messaggio
                                    ,p_errore_bloccante          => 'NO'
                                    ,p_progr_unita_organizzativa => sel_comp.progr_uo
                                    ,p_codice_uo                 => d_codice_uo
                                    ,p_descr_uo                  => d_descrizione
                                    ,p_ni                        => sel_comp.ni
                                    ,p_nominativo                => sel_comp.denominazione);
               end if;
            else
               --
               -- Se il componente ha l'AL nullo, si controlla che le date del legame
               -- cessato siano congruenti
               --
               if nvl(s_tipo_revisione, 'N') = 'N' then
                  d_result := componente.is_dal_al_ok(sel_comp.dal, p_data - 1);
                  if d_result <> afc_error.ok then
                     d_messaggio := componente.error_message(d_result) ||
                                    ' su COMPONENTI (id=' || sel_comp.id_componente || ')';
                     d_errore    := 'SI';
                  end if;
               end if;
            end if;

            --
            -- Si verifica che l'UO di assegnazione sia definita per l'intero periodo
            --
            if not (sel_comp.dal > nvl(sel_comp.al, to_date(3333333, 'j')) and --#574 verifica eseguita solo sui record ancora validi
                sel_comp.revisione_cessazione = p_revisione) then
               begin
                  select 'x'
                    into d_dummy
                    from unita_organizzative u
                   where u.progr_unita_organizzativa = sel_comp.progr_uo
                     and u.ottica = p_ottica
                     and exists
                   (select 'x'
                            from unita_organizzative
                           where progr_unita_organizzativa = u.progr_unita_organizzativa
                             and ottica = u.ottica
                             and nvl(sel_comp.dal, nvl(dal, to_date(2222222, 'j'))) between
                                 nvl(dal, to_date(2222222, 'j')) and
                                 nvl(decode(revisione_cessazione
                                           ,p_revisione
                                           ,p_data - 1
                                           ,al)
                                    ,to_date(3333333, 'j')))
                     and exists
                   (select 'x'
                            from unita_organizzative
                           where progr_unita_organizzativa = u.progr_unita_organizzativa
                             and ottica = u.ottica
                             and nvl(sel_comp.al, to_date(3333333, 'j')) between
                                 nvl(dal, to_date(2222222, 'j')) and
                                 nvl(decode(revisione_cessazione
                                           ,p_revisione
                                           ,p_data - 1
                                           ,al)
                                    ,to_date(3333333, 'j')));
                  raise too_many_rows;
               exception
                  when too_many_rows then
                     null;
                  when no_data_found then
                     d_messaggio := 'Unita'' organizzativa non in struttura per il periodo indicato  (id=' ||
                                    sel_comp.id_componente || ')';
                     d_errore    := 'SI';
               end;
            end if;
            --
            -- si segnalano i componenti cessati con la revisione aventi ruoli con
            -- data di decorrenza successiva al dal-1 della revisione
            -- solo se la revisione è progressiva (Bug#348)
            if nvl(s_tipo_revisione, 'N') = 'N' then
               begin
                  select 'x'
                    into d_dummy
                    from ruoli_componente
                   where id_componente = sel_comp.id_componente
                     and dal > p_data - 1
                     and dal <= nvl(al, to_date(3333333, 'j'));
                  raise too_many_rows;
               exception
                  when too_many_rows then
                     -- trovato almeno un ruolo con decorrenza successiva alla data di chiusura del componente
                     d_messaggio := 'Esistono ruoli assegnati al Componente con decorrenza successiva al ' ||
                                    to_char(p_data - 1, 'DD/MM/YYYY') || ' (id=' ||
                                    sel_comp.id_componente || ')';
                     d_errore    := 'NO'; --#533
                     begin
                        work_revisione.ins(p_id_work_revisione         => null
                                          ,p_ottica                    => p_ottica
                                          ,p_revisione                 => p_revisione
                                          ,p_data                      => p_data
                                          ,p_messaggio                 => d_messaggio
                                          ,p_errore_bloccante          => 'NO'
                                          ,p_progr_unita_organizzativa => sel_comp.progr_uo
                                          ,p_codice_uo                 => d_codice_uo
                                          ,p_descr_uo                  => d_descrizione
                                          ,p_ni                        => sel_comp.ni
                                          ,p_nominativo                => sel_comp.denominazione);
                     exception
                        when others then
                           raise_application_error(-20999
                                                  ,'Errore in inserimento WORK_REVISIONI');
                     end;
                  when no_data_found then
                     -- nessun ruolo trovato
                     null;
               end;
            end if;
         end if;
         --
         -- Se si e' verificato un errore, si inserisce il messaggio nella
         -- tabella WORK_REVISIONI
         --
         if d_errore = 'SI' then
            d_wore_id := work_revisione.get_id_errore(p_ottica                    => p_ottica
                                                     ,p_revisione                 => p_revisione
                                                     ,p_progr_unita_organizzativa => sel_comp.progr_uo
                                                     ,p_ni                        => sel_comp.ni
                                                     ,p_errore_bloccante          => 'SI');
            if d_wore_id is null then
               begin
                  work_revisione.ins(p_id_work_revisione         => null
                                    ,p_ottica                    => p_ottica
                                    ,p_revisione                 => p_revisione
                                    ,p_data                      => p_data
                                    ,p_messaggio                 => d_messaggio
                                    ,p_errore_bloccante          => 'SI'
                                    ,p_progr_unita_organizzativa => sel_comp.progr_uo
                                    ,p_codice_uo                 => d_codice_uo
                                    ,p_descr_uo                  => d_descrizione
                                    ,p_ni                        => sel_comp.ni
                                    ,p_nominativo                => sel_comp.denominazione);
               exception
                  when others then
                     raise_application_error(-20999
                                            ,'Errore in inserimento WORK_REVISIONI');
               end;
            else
               begin
                  update work_revisioni
                     set messaggio = substr(decode(messaggio
                                                  ,null
                                                  ,null
                                                  ,messaggio || ' - ') || d_messaggio
                                           ,1
                                           ,2000)
                   where id_work_revisione = d_wore_id;
               exception
                  when others then
                     raise_application_error(-20999
                                            ,'Errore in aggiornamento WORK_REVISIONI (' ||
                                             d_wore_id || ') - ' || sqlerrm);
               end;
            end if;
         end if;
      end loop;
      --
      -- Controllo attributi componente
      --
      for sel_attr in (select id_attr_componente
                             ,ni
                             ,decode(ni
                                    ,null
                                    ,denominazione
                                    ,soggetti_get_descr(ni
                                                       ,nvl(a.dal, p_data)
                                                       ,'COGNOME E NOME')) denominazione
                             ,a.dal
                             ,a.al
                             ,a.id_componente
                             ,a.tipo_assegnazione
                             ,a.revisione_assegnazione
                             ,a.revisione_cessazione
                             ,a.assegnazione_prevalente
                             ,c.progr_unita_organizzativa progr_uo
                             ,a.rowid
                         from componenti           c
                             ,attributi_componente a
                        where c.id_componente = a.id_componente
                          and a.ottica = p_ottica
                          and c.ni = nvl(p_ni, c.ni) --issue 316, elaborazione ad personam
                          and (a.revisione_assegnazione = p_revisione or
                              a.revisione_cessazione = p_revisione)
                        order by denominazione)
      loop
         d_errore := 'NO';
         begin
            select codice_uo
                  ,descrizione
              into d_codice_uo
                  ,d_descrizione
              from anagrafe_unita_organizzative
             where progr_unita_organizzativa = sel_attr.progr_uo
               and nvl(sel_attr.dal, p_data) between dal and
                   nvl(al, to_date(3333333, 'j'));
         exception
            when no_data_found then
               d_codice_uo   := lpad('*', 16, '*');
               d_descrizione := 'Unita'' non codificata';
            when others then
               raise_application_error(-20999
                                      ,'Errore in lettura ANAGRAFE_UNITA_ORGANIZZATIVE (' ||
                                       sel_attr.progr_uo || ') - ' || sqlerrm);
         end;
         --
         -- Controllo attributi assegnati con la revisione
         --
         if sel_attr.revisione_assegnazione = p_revisione then
            if sel_attr.dal is not null then
               if sel_attr.dal < p_data then
                  d_messaggio := 'Incarico assegnato al componente in data antecedente alla data di inizio validita'' della revisione (id=' ||
                                 sel_attr.id_componente || ')';
                  d_errore    := 'SI';
               end if;
               begin
                  select 'x'
                    into s_dummy
                    from componenti c
                   where ni = sel_attr.ni
                     and ottica = p_ottica
                     and sel_attr.tipo_assegnazione = 'I'
                     and revisione_assegnazione = p_revisione
                     and id_componente <> sel_attr.id_componente
                     and sel_attr.assegnazione_prevalente =
                         (select assegnazione_prevalente
                            from attributi_componente
                           where id_componente = c.id_componente
                             and tipo_assegnazione = sel_attr.tipo_assegnazione
                             and id_attr_componente <> sel_attr.id_attr_componente);

                  raise too_many_rows;
               exception
                  when no_data_found then
                     null;
                  when too_many_rows then
                     d_messaggio := 'Componente con incarichi multipli per la stessa revisione (id=' ||
                                    sel_attr.id_componente || ')';
                     d_errore    := 'NO'; --#533
                     begin
                        work_revisione.ins(p_id_work_revisione         => null
                                          ,p_ottica                    => p_ottica
                                          ,p_revisione                 => p_revisione
                                          ,p_data                      => p_data
                                          ,p_messaggio                 => d_messaggio
                                          ,p_errore_bloccante          => 'NO'
                                          ,p_progr_unita_organizzativa => sel_attr.progr_uo
                                          ,p_codice_uo                 => d_codice_uo
                                          ,p_descr_uo                  => d_descrizione
                                          ,p_ni                        => sel_attr.ni
                                          ,p_nominativo                => sel_attr.denominazione);
                     exception
                        when others then
                           raise_application_error(-20999
                                                  ,'Errore in inserimento WORK_REVISIONI');
                     end;
               end;
            else
               d_periodo := attributo_componente.get_ultimo_periodo(p_id_componente => sel_attr.id_componente
                                                                   ,p_rowid         => sel_attr.rowid);
               if d_periodo.dal is not null and p_data <= d_periodo.dal then
                  d_messaggio := 'Data inizio validita'' incarico non congruente con periodo precedente (id=' ||
                                 sel_attr.id_componente || ')';
                  d_errore    := 'SI';
               end if;
            end if;
         end if;
         --
         -- Controllo attributi cessati con la revisione
         --
         if sel_attr.revisione_cessazione = p_revisione then
            if sel_attr.al is not null then
               if sel_attr.al <> p_data - 1 then
                  d_messaggio := 'Incarico cessato in data successiva alla data di inizio validita'' della revisione (id=' ||
                                 sel_attr.id_componente || ')';
                  d_errore    := 'NO'; --#500
                  work_revisione.ins(p_id_work_revisione         => null
                                    ,p_ottica                    => p_ottica
                                    ,p_revisione                 => p_revisione
                                    ,p_data                      => p_data
                                    ,p_messaggio                 => d_messaggio
                                    ,p_errore_bloccante          => 'NO'
                                    ,p_progr_unita_organizzativa => '' --sel_attr.progr_uo
                                    ,p_codice_uo                 => '' --d_codice_uo
                                    ,p_descr_uo                  => '' --d_descrizione
                                    ,p_ni                        => sel_attr.ni
                                    ,p_nominativo                => sel_attr.denominazione);
               end if;
            else
               --
               -- Se l'attributo componente ha l'AL nullo, si controlla che le date
               -- dell'attributo cessato siano congruenti
               --
               if nvl(s_tipo_revisione, 'N') = 'N' then
                  d_result := attributo_componente.is_dal_al_ok(sel_attr.dal, p_data - 1);
                  if d_result <> afc_error.ok then
                     d_messaggio := attributo_componente.error_message(d_result) ||
                                    ' su ATTRIBUTI_COMPONENTE (id=' ||
                                    sel_attr.id_componente || ')';
                     d_errore    := 'NO'; --#533
                     begin
                        work_revisione.ins(p_id_work_revisione         => null
                                          ,p_ottica                    => p_ottica
                                          ,p_revisione                 => p_revisione
                                          ,p_data                      => p_data
                                          ,p_messaggio                 => d_messaggio
                                          ,p_errore_bloccante          => 'NO'
                                          ,p_progr_unita_organizzativa => sel_attr.progr_uo
                                          ,p_codice_uo                 => d_codice_uo
                                          ,p_descr_uo                  => d_descrizione
                                          ,p_ni                        => sel_attr.ni
                                          ,p_nominativo                => sel_attr.denominazione);
                     exception
                        when others then
                           raise_application_error(-20999
                                                  ,'Errore in inserimento WORK_REVISIONI');
                     end;
                  end if;
               end if;
            end if;
         end if;
         --
         -- Se si e' verificato un errore, si inserisce il messaggio nella
         -- tabella WORK_REVISIONI
         --
         if d_errore = 'SI' then
            d_wore_id := work_revisione.get_id_errore(p_ottica                    => p_ottica
                                                     ,p_revisione                 => p_revisione
                                                     ,p_progr_unita_organizzativa => sel_attr.progr_uo
                                                     ,p_ni                        => sel_attr.ni
                                                     ,p_errore_bloccante          => 'SI');
            if d_wore_id is null then
               begin
                  work_revisione.ins(p_id_work_revisione         => null
                                    ,p_ottica                    => p_ottica
                                    ,p_revisione                 => p_revisione
                                    ,p_data                      => p_data
                                    ,p_messaggio                 => d_messaggio
                                    ,p_errore_bloccante          => 'SI'
                                    ,p_progr_unita_organizzativa => sel_attr.progr_uo
                                    ,p_codice_uo                 => d_codice_uo
                                    ,p_descr_uo                  => d_descrizione
                                    ,p_ni                        => sel_attr.ni
                                    ,p_nominativo                => sel_attr.denominazione);
               exception
                  when others then
                     raise_application_error(-20999
                                            ,'Errore in inserimento WORK_REVISIONI');
               end;
            else
               begin
                  update work_revisioni
                     set messaggio = substr(decode(messaggio
                                                  ,null
                                                  ,null
                                                  ,messaggio || ' - ') || d_messaggio
                                           ,1
                                           ,2000)
                   where id_work_revisione = d_wore_id;
               exception
                  when others then
                     raise_application_error(-20999
                                            ,'Errore in aggiornamento WORK_REVISIONI (' ||
                                             d_wore_id || ') - ' || sqlerrm);
               end;
            end if;
         end if;
      end loop;
      --
      -- Controllo incarichi assenti, assegnazioni prevalenti, percentuali impiego
      --
      for sel_ass in (select distinct ni
                                     ,ci
                                     ,decode(ni
                                            ,null
                                            ,denominazione
                                            ,soggetti_get_descr(ni
                                                               ,nvl(a.dal, p_data)
                                                               ,'COGNOME E NOME')) denominazione
                                     ,c.id_componente
                        from componenti           c
                            ,attributi_componente a
                       where c.id_componente = a.id_componente
                         and a.ottica = p_ottica
                         and c.ni = nvl(p_ni, c.ni) --issue 316, elaborazione ad personam
                         and (a.revisione_assegnazione = p_revisione or
                             a.revisione_cessazione = p_revisione)
                       order by denominazione)
      loop
         for sel_inc in (select distinct incarico
                           from componenti           c
                               ,attributi_componente a
                          where c.ottica = p_ottica
                            and c.ni = sel_ass.ni
                            and nvl(c.ci, -1) = nvl(sel_ass.ci, -1)
                            and c.id_componente = a.id_componente
                            and a.ottica = p_ottica
                            and a.revisione_assegnazione = p_revisione
                            and a.incarico is null
                         union
                         select null
                           from componenti c
                          where c.ottica = p_ottica
                            and c.ni = sel_ass.ni
                            and nvl(c.ci, -1) = nvl(sel_ass.ci, -1)
                            and c.revisione_assegnazione = p_revisione
                            and not exists
                          (select 'x'
                                   from attributi_componente a
                                  where a.id_componente = c.id_componente))
         loop
            d_messaggio := 'Incarico non assegnato (id=' || sel_ass.id_componente || ')';
            d_wore_id   := work_revisione.get_id_errore(p_ottica                    => p_ottica
                                                       ,p_revisione                 => p_revisione
                                                       ,p_progr_unita_organizzativa => null
                                                       ,p_ni                        => sel_ass.ni
                                                       ,p_errore_bloccante          => 'SI');
            if d_wore_id is null then
               begin
                  work_revisione.ins(p_id_work_revisione         => null
                                    ,p_ottica                    => p_ottica
                                    ,p_revisione                 => p_revisione
                                    ,p_data                      => p_data
                                    ,p_messaggio                 => d_messaggio
                                    ,p_errore_bloccante          => 'SI'
                                    ,p_progr_unita_organizzativa => null
                                    ,p_codice_uo                 => null
                                    ,p_descr_uo                  => null
                                    ,p_ni                        => sel_ass.ni
                                    ,p_nominativo                => sel_ass.denominazione);
               exception
                  when others then
                     raise_application_error(-20999
                                            ,'Errore in inserimento WORK_REVISIONI');
               end;
            else
               begin
                  update work_revisioni
                     set messaggio = substr(decode(messaggio
                                                  ,null
                                                  ,null
                                                  ,messaggio || ' - ') || d_messaggio
                                           ,1
                                           ,2000)
                   where id_work_revisione = d_wore_id;
               exception
                  when others then
                     raise_application_error(-20999
                                            ,'Errore in aggiornamento WORK_REVISIONI (' ||
                                             d_wore_id || ') - ' || sqlerrm);
               end;
            end if;
         end loop;
         --
         if nvl(s_tipo_revisione, 'N') = 'N' then
            for sel_inc in (select distinct nvl(a.dal, p_data) dal
                                           ,decode(a.revisione_cessazione
                                                  ,p_revisione
                                                  ,p_data - 1
                                                  ,a.al) al
                                           ,c.id_componente
                              from componenti           c
                                  ,attributi_componente a
                             where c.ottica = p_ottica
                               and c.ni = sel_ass.ni
                               and nvl(c.ci, -1) = nvl(sel_ass.ci, -1)
                               and c.id_componente = a.id_componente
                               and a.ottica = p_ottica
                               and a.revisione_assegnazione = p_revisione)
            loop
               d_result := attributo_componente.is_assegnazione_prevalente_ok(p_ottica => p_ottica
                                                                             ,p_ni     => sel_ass.ni
                                                                             ,p_ci     => sel_ass.ci
                                                                             ,p_dal    => sel_inc.dal
                                                                             ,p_al     => sel_inc.al
                                                                             ,p_data   => p_data);
               if d_result <> afc_error.ok then
                  d_messaggio := attributo_componente.error_message(d_result) || ' (id=' ||
                                 sel_ass.id_componente || ')';
                  d_wore_id   := work_revisione.get_id_errore(p_ottica                    => p_ottica
                                                             ,p_revisione                 => p_revisione
                                                             ,p_progr_unita_organizzativa => null
                                                             ,p_ni                        => sel_ass.ni
                                                             ,p_errore_bloccante          => 'SI');
                  if d_wore_id is null then
                     begin
                        work_revisione.ins(p_id_work_revisione         => null
                                          ,p_ottica                    => p_ottica
                                          ,p_revisione                 => p_revisione
                                          ,p_data                      => p_data
                                          ,p_messaggio                 => d_messaggio
                                          ,p_errore_bloccante          => 'NO' --'SI' #533
                                          ,p_progr_unita_organizzativa => null
                                          ,p_codice_uo                 => null
                                          ,p_descr_uo                  => null
                                          ,p_ni                        => sel_ass.ni
                                          ,p_nominativo                => sel_ass.denominazione);
                     exception
                        when others then
                           raise_application_error(-20999
                                                  ,'Errore in inserimento WORK_REVISIONI');
                     end;
                  else
                     begin
                        update work_revisioni
                           set messaggio = substr(decode(messaggio
                                                        ,null
                                                        ,null
                                                        ,messaggio || ' - ') ||
                                                  d_messaggio
                                                 ,1
                                                 ,2000)
                         where id_work_revisione = d_wore_id;
                     exception
                        when others then
                           raise_application_error(-20999
                                                  ,'Errore in aggiornamento WORK_REVISIONI (' ||
                                                   d_wore_id || ') - ' || sqlerrm);
                     end;
                  end if;
               end if;
               --
               d_result := attributo_componente.is_percentuale_impiego_ok(p_ottica => p_ottica
                                                                         ,p_ni     => sel_ass.ni
                                                                         ,p_ci     => sel_ass.ci
                                                                         ,p_dal    => sel_inc.dal
                                                                         ,p_al     => sel_inc.al
                                                                         ,p_data   => p_data);
               if d_result <> afc_error.ok then
                  d_messaggio := attributo_componente.error_message(d_result) || ' (id=' ||
                                 sel_ass.id_componente || ')';
                  begin
                     work_revisione.ins(p_id_work_revisione         => null
                                       ,p_ottica                    => p_ottica
                                       ,p_revisione                 => p_revisione
                                       ,p_data                      => p_data
                                       ,p_messaggio                 => d_messaggio
                                       ,p_errore_bloccante          => 'NO'
                                       ,p_progr_unita_organizzativa => null
                                       ,p_codice_uo                 => null
                                       ,p_descr_uo                  => null
                                       ,p_ni                        => sel_ass.ni
                                       ,p_nominativo                => sel_ass.denominazione);
                  exception
                     when others then
                        raise_application_error(-20999
                                               ,'Errore in inserimento WORK_REVISIONI');
                  end;
               end if;
            end loop;
         end if;
      end loop;
      --
      -- Se è attiva l'integrazione con GP4, trattiamo le eventuali modifiche di assegnazione di provenienza
      -- giuridico (MOAS) generate mentre il componente era già stato movimentato nella revisione in modifica di SO4
      --
      if d_integrazione_gp4 = 'SI' then
         so4gp_pkg.tratta_moas_verifica_revisione(p_ottica, p_revisione, p_data); --#429
      end if;
      --
      commit;
      --
   end; -- revisione_struttura.verifica_revisione
   --------------------------------------------------------------------------------
   procedure aggiorna_ottica
   (
      p_ottica_derivata        in revisioni_struttura.ottica%type
     ,p_ottica_origine         in revisioni_struttura.ottica%type
     ,p_data                   in revisioni_struttura.dal%type
     ,p_aggiornamento          in varchar2 default 'NO'
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
          NOME:        aggiorna_ottica.
          DESCRIZIONE: crea una nuova revisione in modifica per l'ottica data
                       acquisendo le modifiche apportate sull'ottica di origine
                       alla data indicata.
                       Se l'ottica di origine è diversa da quella da cui l'ottica derivata è stata
                       duplicata, vengono chiuse tutte le relazioni tra le UO e le assegnazioni dei
                       componenti al giorno precedente.
                       Se l'ottica di origine non è cambiata, si aggiornano struttura e assegnazioni
                       secondo i seguenti criteri.
                       Struttura:
                       -  Le UO in comune non più presenti sull'ottica di origine vengono chiuse e con
                          esse le UO comuni figlie; le UO specifiche dell'ottica N/Ist. che perdono in
                          questo modo l'UO padre, vengono trattate come nuove radici.
                       -  Le UO che permangono sulla nuova revisione dell'ottica di origine ma che non
                          erano già presenti nell'ottica N/Ist., non vengono replicate.
                       -  Le UO dell'origine con validità successiva alla data della nuova  revisione
                          dell'ottica N/Ist. vengono replicate nell'ottica N/Ist. (possono essere
                          eliminate manualmente).
                       Assegnazioni:
                       -  Le assegnazioni uguali (nelle nuova revisione dell'ottica di origine e nella
                          revisione precedente dell'ottica N/Ist.) per individuo, UO, vengono mantenute
                          anche sulla revisione in modifica dell'ottica N/Ist.
                       -  Le assegnazioni dell'ottica N/Ist. presenti e uguali alla data corrispondente
                          nell'ottica di origine non più presenti alla data della nuove revisione
                          nell'ottica di origine vengono chiuse.
                       -  Le assegnazioni dell'ottica N/Ist. non presenti o diverse alla data corrispondente
                          nell'ottica di origine vengono mantenute.
                       -  Le assegnazioni dell'ottica di origine relative a nuove UO vengono replicate
                          sull'ottica N/Ist. come assegnazioni funzionali.
      ******************************************************************************/
      d_ottica_istituzionale       ottiche.ottica_istituzionale%type;
      d_ente_origine               amministrazioni.codice_amministrazione%type;
      d_ente_destinazione          amministrazioni.codice_amministrazione%type;
      d_ottica_origine             ottiche.ottica_origine%type := ottica.get_ottica_origine(p_ottica_derivata);
      d_revisione_corrente         revisioni_struttura.revisione%type;
      d_revisione_modifica         revisioni_struttura.revisione%type;
      d_revisione_modifica_origine revisioni_struttura.revisione%type;
      d_data_rev_precedente        date;
      d_progr_padre                unita_organizzative.progr_unita_organizzativa%type;
      d_id_unita_padre             unita_organizzative.id_elemento%type;
      d_segnalazione_bloccante     varchar2(2000);
      d_segnalazione               varchar2(2000);
      w_atco                       attributi_componente%rowtype;
      d_id_componente              componenti.id_componente%type := '';
      fine_regolare             exception;
      errore_ottiche            exception;
      errore_duplica            exception;
      errore_revisione          exception;
      errore_assegnazioni       exception;
      errore_elimina_relazioni  exception;
      errore_aggiorna_relazioni exception;
      errore_anagrafe           exception;
   begin
      -- controllo di compatibilità delle ottiche
      d_ottica_istituzionale := ottica.get_ottica_istituzionale(p_ottica_derivata);
      d_ente_origine         := ottica.get_amministrazione(p_ottica_origine);
      d_ente_destinazione    := ottica.get_amministrazione(p_ottica_derivata);
      -- la duplicazione è possibile solamente se l'ottica di destinazione NON è istituzionale e se le
      -- due ottiche fanno parte della stessa amministrazione
      if not (d_ottica_istituzionale = 'NO' and d_ente_origine = d_ente_destinazione) then
         p_segnalazione := 'Aggiornamento possibile solamente se l''ottica derivata NON è istituzionale e se ottica
                         di origine e destinazione fanno parte della stessa amministrazione';
         raise errore_ottiche;
      end if;
      -- verifica della revisione dell'ottica derivata
      -- Crea una nuova revisione in modifica con dal = parametro della procedure
      -- estrae la revisione più recente
      select max(r.revisione)
        into d_revisione_corrente
        from revisioni_struttura r
       where r.ottica = p_ottica_derivata;
      if d_revisione_corrente is null then
         -- non esistono precedenti revisioni, eseguo la replica dalla revisione modello
         unita_organizzativa.duplica_ottica(p_ottica_origine         => p_ottica_origine
                                           ,p_ottica_derivata        => p_ottica_derivata
                                           ,p_data                   => p_data
                                           ,p_duplica_assegnazioni   => 'SI'
                                           ,p_aggiornamento          => p_aggiornamento
                                           ,p_segnalazione_bloccante => d_segnalazione_bloccante
                                           ,p_segnalazione           => d_segnalazione);
         if d_segnalazione_bloccante <> 'Y' then
            raise fine_regolare;
         else
            raise errore_duplica;
         end if;
      else
         if revisione_struttura.esiste_revisione_mod(p_ottica_derivata
                                                    ,d_revisione_corrente) = 1 then
            -- l'ultima revisione è quella in modifica
            -- controllo se esistono attività precedenti
            begin
               select 'x'
                 into s_dummy
                 from unita_organizzative
                where ottica = p_ottica_derivata
                  and (revisione = d_revisione_corrente or
                      revisione_cessazione = d_revisione_corrente);
               raise too_many_rows;
            exception
               when too_many_rows then
                  p_segnalazione := 'Sono state già eseguite operazioni sull''attuale revisione in modifica';
                  raise errore_revisione;
               when no_data_found then
                  begin
                     select 'x'
                       into s_dummy
                       from revisioni_struttura
                      where ottica = p_ottica_derivata
                        and stato = 'A'
                        and dal >= p_data;
                     raise too_many_rows;
                  exception
                     when no_data_found then
                        d_revisione_modifica := d_revisione_corrente;
                        update revisioni_struttura
                           set dal = p_data
                         where ottica = p_ottica_derivata
                           and stato = 'M';
                     when too_many_rows then
                        p_segnalazione := 'Esistono revisioni attive successive alla data indicata. ';
                        raise errore_revisione;
                  end;
            end;
         else
            -- l'ultima revisione è attiva
            -- controllo se la data della revisione e' minore della data della nuova revisione
            if revisione_struttura.get_dal(p_ottica_derivata, d_revisione_corrente) >=
               p_data then
               p_segnalazione := 'Esistono revisioni attive successive alla data indicata. ';
               raise errore_revisione;
            end if;
         end if;
      end if;
      -- verifica dell'ottica di origine
      if p_ottica_origine <> d_ottica_origine then
         -- chiusura della situazione precedente
         -- chiusura della assegnazioni dell'ottica derivata al giorno precedente la data indicata
         for comp in (select id_componente
                            ,ni
                        from componenti c
                       where ottica = p_ottica_derivata
                         and nvl(al, to_date(3333333, 'j')) > p_data
                       order by id_componente desc)
         loop
            begin
               update componenti
                  set al                   = p_data - 1
                     ,revisione_cessazione = d_revisione_modifica
                where id_componente = comp.id_componente;
            exception
               when others then
                  if sqlcode between - 20999 and - 20900 then
                     p_segnalazione := s_error_table(sqlcode);
                  else
                     p_segnalazione := 'Errore cessazione componente NI: ' || comp.ni ||
                                       sqlerrm;
                  end if;
                  raise errore_assegnazioni;
            end;
         end loop;
         -- chiusura della unita' organizzative (legami) dell'ottica derivata al giorno precedente la data indicata
         for unor in (select id_elemento
                            ,progr_unita_organizzativa
                        from unita_organizzative u
                       where u.revisione = d_revisione_corrente
                         and ottica = p_ottica_derivata
                         and (p_data - 1) between dal and nvl(al, to_date(3333333, 'j'))
                      connect by prior progr_unita_organizzativa = id_unita_padre
                             and ottica = p_ottica_derivata
                             and (p_data - 1) between dal and
                                 nvl(al, to_date(3333333, 'j'))
                       start with ottica = p_ottica_derivata
                              and id_unita_padre is null
                              and (p_data - 1) between dal and
                                  nvl(al, to_date(3333333, 'j'))
                       order by level desc
                               ,id_elemento)
         loop
            begin
               update unita_organizzative
                  set al                   = p_data - 1
                     ,revisione_cessazione = d_revisione_modifica
                where id_elemento = unor.id_elemento;
            exception
               when others then
                  if sqlcode between - 20999 and - 20900 then
                     p_segnalazione := s_error_table(sqlcode);
                  else
                     p_segnalazione := 'Errore eliminazione progressivo : ' ||
                                       unor.progr_unita_organizzativa || sqlerrm;
                  end if;
                  raise errore_elimina_relazioni;
            end;
         end loop;
         -- duplicazione della nuova ottica di origine
         -- Eseguo la replica dalla nuova ottica di origine
         unita_organizzativa.duplica_ottica(p_ottica_origine         => p_ottica_origine
                                           ,p_ottica_derivata        => p_ottica_derivata
                                           ,p_data                   => p_data
                                           ,p_duplica_assegnazioni   => 'SI'
                                           ,p_aggiornamento          => p_aggiornamento
                                           ,p_segnalazione_bloccante => d_segnalazione_bloccante
                                           ,p_segnalazione           => d_segnalazione);
         if d_segnalazione_bloccante <> 'Y' then
            raise fine_regolare;
         else
            raise errore_duplica;
         end if;
      else
         -- applicazione delle modifiche all'ottica derivata
         -- genero una nuova revisione in modifica per l'ottica derivata
         if d_revisione_corrente <> nvl(d_revisione_modifica, -1) then
            d_revisione_modifica := d_revisione_corrente + 1;
            revisione_struttura.ins(p_ottica               => p_ottica_derivata
                                   ,p_revisione            => d_revisione_modifica
                                   ,p_descrizione          => 'Revisione ' ||
                                                              d_revisione_modifica ||
                                                              ' per aggiornamento da ottica ' ||
                                                              p_ottica_origine
                                   ,p_dal                  => p_data
                                   ,p_stato                => 'M'
                                   ,p_utente_aggiornamento => 'SO4'
                                   ,p_data_aggiornamento   => trunc(sysdate));
         end if;
         -- aggiornamento delle segnalazioni
         d_revisione_modifica_origine := revisione_struttura.get_revisione_mod(p_ottica_origine);
         begin
            select nvl(max(dal), to_date(2222222, 'j'))
              into d_data_rev_precedente
              from revisioni_struttura
             where ottica = p_ottica_derivata
               and dal < p_data;
         exception
            when no_data_found then
               d_data_rev_precedente := to_date(2222222, 'j');
         end;
         /*
          Le UO in comune non più presenti sull'ottica di origine vengono chiuse e con esse
          le UO comuni figlie; le UO specifiche dell'ottica N/Ist. che perdono in questo modo
          l'UO padre, vengono trattate come nuove radici.
         */
         -- uo eliminate
         for uo_eliminate in (select id_elemento
                                    ,progr_unita_organizzativa
                                from unita_organizzative u
                               where ottica = p_ottica_origine
                                 and u.dal < d_data_rev_precedente
                                 and not exists
                               (select 'x'
                                        from unita_organizzative
                                       where ottica = p_ottica_origine
                                         and progr_unita_organizzativa =
                                             u.progr_unita_organizzativa
                                         and nvl(al, to_date(3333333, 'j')) >= p_data)
                                 and exists
                               (select 'x'
                                        from unita_organizzative
                                       where ottica = p_ottica_derivata
                                         and progr_unita_organizzativa =
                                             u.progr_unita_organizzativa
                                         and nvl(al, to_date(3333333, 'j')) >= p_data)
                               order by id_elemento)
         loop
            --foglie delle uo eliminate
            for foglie_eliminate in (select id_elemento
                                           ,progr_unita_organizzativa
                                       from unita_organizzative u
                                      where nvl(u.al, to_date(3333333, 'j')) >= p_data
                                        and ottica = p_ottica_derivata
                                     connect by prior
                                                 progr_unita_organizzativa = id_unita_padre
                                            and nvl(u.al, to_date(3333333, 'j')) >= p_data
                                            and ottica = p_ottica_derivata
                                      start with progr_unita_organizzativa =
                                                 uo_eliminate.progr_unita_organizzativa
                                             and ottica = p_ottica_derivata
                                      order by level desc
                                              ,id_elemento)
            loop
               -- chiusura della assegnazioni dell'ottica derivata al giorno precedente la data indicata
               for comp in (select id_componente
                                  ,ni
                              from componenti c
                             where ottica = p_ottica_derivata
                               and nvl(al, to_date(3333333, 'j')) > p_data
                               and progr_unita_organizzativa =
                                   foglie_eliminate.progr_unita_organizzativa
                             order by id_componente desc)
               loop
                  begin
                     update componenti
                        set al                   = p_data - 1
                           ,revisione_cessazione = d_revisione_modifica
                      where id_componente = comp.id_componente;
                  exception
                     when others then
                        if sqlcode between - 20999 and - 20900 then
                           p_segnalazione := s_error_table(sqlcode);
                        else
                           p_segnalazione := 'Errore cessazione componente NI: ' ||
                                             comp.ni || sqlerrm;
                        end if;
                        raise errore_assegnazioni;
                  end;
               end loop;
               -- chiusura della uo
               begin
                  update unita_organizzative
                     set al                   = p_data - 1
                        ,revisione_cessazione = d_revisione_modifica
                   where id_elemento = foglie_eliminate.id_elemento;
               exception
                  when others then
                     if sqlcode between - 20999 and - 20900 then
                        p_segnalazione := s_error_table(sqlcode);
                     else
                        p_segnalazione := 'Errore eliminazione progressivo : ' ||
                                          foglie_eliminate.progr_unita_organizzativa ||
                                          sqlerrm;
                     end if;
                     raise errore_elimina_relazioni;
               end;
            end loop;
            /*begin
               update unita_organizzative
                  set al                   = p_data - 1
                     ,revisione_cessazione = d_revisione_modifica
                where id_elemento = uo_eliminate.id_elemento;
            exception
               when others then
                  if sqlcode between - 20999 and - 20900 then
                     p_segnalazione := s_error_table(sqlcode);
                  else
                     p_segnalazione := 'Errore eliminazione progressivo : ' ||
                                       uo_eliminate.progr_unita_organizzativa || sqlerrm;
                  end if;
                  raise errore_elimina_relazioni;
            end;*/
         end loop;
         /*
          Le UO dell'origine con validità successiva alla data della nuova  revisione dell'ottica N/Ist.
          vengono replicate nell'ottica N/Ist. (possono essere eliminate manualmente)
         */
         for uo_nuove in (select *
                            from unita_organizzative u
                           where u.ottica = d_ottica_origine
                                --  and u.dal > d_data_rev_precedente
                             and p_data between u.dal and
                                 nvl(decode(u.revisione_cessazione
                                           ,d_revisione_modifica_origine
                                           ,to_date(null)
                                           ,al)
                                    ,to_date('3333333', 'j'))
                             and not exists
                           (select 'x'
                                    from unita_organizzative
                                   where ottica = p_ottica_derivata
                                     and progr_unita_organizzativa =
                                         u.progr_unita_organizzativa
                                     and dal <= d_data_rev_precedente))
         loop
            unita_organizzativa.ins(p_id_elemento               => null
                                   ,p_ottica                    => p_ottica_derivata
                                   ,p_revisione                 => d_revisione_modifica
                                   ,p_sequenza                  => uo_nuove.sequenza
                                   ,p_progr_unita_organizzativa => uo_nuove.progr_unita_organizzativa
                                   ,p_id_unita_padre            => null
                                   ,p_revisione_cessazione      => null
                                   ,p_dal                       => p_data
                                   ,p_al                        => to_date(null)
                                   ,p_utente_aggiornamento      => 'SO4'
                                   ,p_data_aggiornamento        => sysdate);
         end loop;
         -- determinazione dei padri
         for uo_nuove in (select *
                            from unita_organizzative u
                           where u.ottica = d_ottica_origine
                                --   and u.dal > d_data_rev_precedente
                             and p_data between u.dal and
                                 nvl(decode(u.revisione_cessazione
                                           ,d_revisione_modifica_origine
                                           ,to_date(null)
                                           ,al)
                                    ,to_date('3333333', 'j'))
                             and not exists
                           (select 'x'
                                    from unita_organizzative
                                   where ottica = p_ottica_derivata
                                     and progr_unita_organizzativa =
                                         u.progr_unita_organizzativa
                                     and dal <= d_data_rev_precedente))
         loop
            -- seleziona il progressivo dell'unità padre nell'ottica di partenza
            begin
               select u.progr_unita_organizzativa
                 into d_progr_padre
                 from unita_organizzative u
                where u.ottica = p_ottica_origine
                  and u.progr_unita_organizzativa = uo_nuove.id_unita_padre
                  and p_data between u.dal and
                      nvl(decode(u.revisione_cessazione
                                ,d_revisione_modifica_origine
                                ,to_date(null)
                                ,al)
                         ,to_date('3333333', 'j'))
               /*and u.id_elemento = uo_nuove.id_unita_padre*/
               ;
            exception
               when others then
                  if sqlcode between - 20999 and - 20900 then
                     p_segnalazione := s_error_table(sqlcode);
                  else
                     p_segnalazione := 'Errore aggionamento padre progressivo: ' ||
                                       uo_nuove.progr_unita_organizzativa || ' ' ||
                                       sqlerrm;
                  end if;
                  raise errore_aggiorna_relazioni;
            end;
            -- recupera l'id_elemento dell'unità padre nell'ottica destinazione
            begin
               /*select u.id_elemento
                into d_id_unita_padre
                from unita_organizzative u
               where u.ottica = p_ottica_derivata
                 and u.progr_unita_organizzativa = d_progr_padre;*/
               select u.progr_unita_organizzativa
                 into d_id_unita_padre
                 from unita_organizzative u
                where u.ottica = p_ottica_derivata
                  and u.progr_unita_organizzativa = d_progr_padre
                  and p_data between u.dal and nvl(u.al, to_date(3333333, 'j'));
            exception
               when others then
                  if sqlcode between - 20999 and - 20900 then
                     p_segnalazione := s_error_table(sqlcode);
                  else
                     p_segnalazione := 'Errore id_elemento: ' || sqlerrm;
                  end if;
                  raise errore_aggiorna_relazioni;
            end;
            -- aggiorna id_unita_padre per il corrispondente record del loop per l'ottica destinazione
            update unita_organizzative u
               set u.id_unita_padre = d_id_unita_padre
             where u.ottica = p_ottica_derivata
               and u.progr_unita_organizzativa = uo_nuove.progr_unita_organizzativa
               and p_data between u.dal and nvl(u.al, to_date(3333333, 'j'));
         end loop;
         /*
          Le nuove assegnazioni dell'ottica di origine relative a UO comuni o nuove UO vengono replicate
          sull'ottica N/Ist. come assegnazioni funzionali.
         */
         --assegnati alle nuove unita' appena create o alle uo gia' comuni
         for nuove_assegnazioni in (select *
                                      from componenti c
                                     where c.ottica = p_ottica_origine
                                       and p_data between c.dal and
                                           nvl(c.al, to_date(3333333, 'j'))
                                       and c.dal > d_data_rev_precedente
                                       and exists
                                     (select 'x'
                                              from unita_organizzative
                                             where progr_unita_organizzativa =
                                                   c.progr_unita_organizzativa
                                               and ottica = p_ottica_derivata
                                               and nvl(al, to_date(3333333, 'j')) >= p_data)
                                       and not exists
                                     (select 'x'
                                              from componenti
                                             where ottica = p_ottica_origine
                                               and ni = c.ni
                                               and progr_unita_organizzativa =
                                                   c.progr_unita_organizzativa
                                               and dal <= d_data_rev_precedente))
         loop
            begin
               select *
                 into w_atco
                 from attributi_componente
                where id_componente = nuove_assegnazioni.id_componente
                  and p_data between dal and nvl(al, to_date(3333333, 'j'));
               select componenti_sq.nextval into d_id_componente from dual;
               componente.ins(p_id_componente             => d_id_componente
                             ,p_progr_unita_organizzativa => nuove_assegnazioni.progr_unita_organizzativa
                             ,p_dal                       => p_data
                             ,p_al                        => nuove_assegnazioni.al
                             ,p_ni                        => nuove_assegnazioni.ni
                             ,p_ci                        => nuove_assegnazioni.ci
                             ,p_codice_fiscale            => nuove_assegnazioni.codice_fiscale
                             ,p_denominazione             => nuove_assegnazioni.denominazione
                             ,p_denominazione_al1         => nuove_assegnazioni.denominazione_al1
                             ,p_denominazione_al2         => nuove_assegnazioni.denominazione_al2
                             ,p_stato                     => 'P'
                             ,p_ottica                    => p_ottica_derivata
                             ,p_revisione_assegnazione    => d_revisione_modifica
                             ,p_revisione_cessazione      => ''
                             ,p_utente_aggiornamento      => 'Agg.Rev'
                             ,p_data_aggiornamento        => sysdate);
               attributo_componente.ins(p_id_attr_componente      => ''
                                       ,p_id_componente           => d_id_componente
                                       ,p_dal                     => p_data
                                       ,p_al                      => w_atco.al
                                       ,p_incarico                => w_atco.incarico
                                       ,p_telefono                => w_atco.telefono
                                       ,p_fax                     => w_atco.fax
                                       ,p_e_mail                  => w_atco.e_mail
                                       ,p_assegnazione_prevalente => 88
                                       ,p_tipo_assegnazione       => 'F'
                                       ,p_percentuale_impiego     => w_atco.percentuale_impiego
                                       ,p_ottica                  => p_ottica_derivata
                                       ,p_revisione_assegnazione  => d_revisione_modifica
                                       ,p_revisione_cessazione    => ''
                                       ,p_gradazione              => w_atco.gradazione
                                       ,p_utente_aggiornamento    => 'Agg.Rev'
                                       ,p_data_aggiornamento      => sysdate
                                       ,p_voto                    => w_atco.voto);
            exception
               when others then
                  if sqlcode between - 20999 and - 20900 then
                     p_segnalazione := s_error_table(sqlcode);
                  else
                     p_segnalazione := 'Errore inserimento componente NI: ' ||
                                       nuove_assegnazioni.ni || sqlerrm;
                  end if;
                  raise errore_assegnazioni;
            end;
         end loop;
         /*
          Le assegnazioni dell'ottica N/Ist. presenti e uguali alla data corrispondente nell'ottica di
          origine non più presenti alla data della nuove revisione nell'ottica di origine vengono chiuse
         */
         for comp_cessati in (select id_componente
                                    ,ni
                                from componenti c
                               where c.ottica = p_ottica_derivata
                                 and p_data between c.dal and
                                     nvl(c.al, to_date(3333333, 'j'))
                                 and exists
                               (select 'x'
                                        from componenti
                                       where ottica = p_ottica_origine
                                         and ni = c.ni
                                         and nvl(ci, -99999999) = nvl(c.ci, -999999999)
                                         and progr_unita_organizzativa =
                                             c.progr_unita_organizzativa
                                         and dal < p_data)
                                 and not exists
                               (select 'x'
                                        from componenti
                                       where ottica = p_ottica_origine
                                         and ni = c.ni
                                         and nvl(ci, -99999999) = nvl(c.ci, -999999999)
                                         and progr_unita_organizzativa =
                                             c.progr_unita_organizzativa
                                         and nvl(al, to_date(3333333, 'j')) > p_data))
         loop
            begin
               update componenti
                  set al                   = p_data - 1
                     ,revisione_cessazione = d_revisione_modifica
                where id_componente = comp_cessati.id_componente;
            exception
               when others then
                  if sqlcode between - 20999 and - 20900 then
                     p_segnalazione := s_error_table(sqlcode);
                  else
                     p_segnalazione := 'Errore sulla cessazione componente NI: ' ||
                                       comp_cessati.ni || sqlerrm;
                  end if;
                  raise errore_assegnazioni;
            end;
         end loop;
         for uo_comuni in (select progr_unita_organizzativa
                             from unita_organizzative u
                            where u.ottica = p_ottica_derivata
                              and p_data between u.dal and
                                  nvl(u.al, to_date(3333333, 'j'))
                              and exists (select 'x'
                                     from unita_organizzative
                                    where ottica = p_ottica_origine
                                      and progr_unita_organizzativa =
                                          u.progr_unita_organizzativa
                                      and p_data between dal and
                                          nvl(decode(u.revisione_cessazione
                                                    ,d_revisione_modifica_origine
                                                    ,to_date(null)
                                                    ,al)
                                             ,to_date('3333333', 'j'))))
         loop
            null;
         end loop;
      end if;
   exception
      when fine_regolare then
         p_segnalazione_bloccante := '';
         p_segnalazione           := 'Fine Elaborazione. ' || chr(10) || p_segnalazione;
      when errore_duplica then
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Errore di duplica. ' || chr(10) || d_segnalazione;
      when errore_ottiche then
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Ottiche incompatibili. ' || chr(10) ||
                                     p_segnalazione;
      when errore_revisione then
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Revisione dell''ottica derivata incompatibile. ' ||
                                     chr(10) || p_segnalazione;
      when errore_assegnazioni then
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Errore durante l''aggiornamento delle assegnazioni ' ||
                                     chr(10) || p_segnalazione;
      when errore_elimina_relazioni then
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Errore durante l''eliminazione delle relazioni ' ||
                                     chr(10) || p_segnalazione;
      when errore_aggiorna_relazioni then
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Errore durante l''aggiornamento delle relazioni ' ||
                                     chr(10) || p_segnalazione;
      when errore_anagrafe then
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Errore durante l''eliminazione dell''anagrafe UO ' ||
                                     chr(10) || p_segnalazione;
         /*when others then
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Eliminazione non eseguita' || chr(10) || sqlerrm;*/
   end aggiorna_ottica;
   --------------------------------------------------------------------------------
   procedure attivazione_revisione
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
     ,p_data      in revisioni_struttura.dal%type
   ) is
      /******************************************************************************
       NOME:        Attivazione_revisione.
       DESCRIZIONE: Aggiorna le date di inizio e fine validità nei legami
                    coinvolti dalla revisione.
                    In presenza di integrazione con GP4, registra le modifiche
                    nella tabella MODIFICHE_STRUTTURA dell'utente P00SO4
       RITORNA:     -
      ******************************************************************************/
      d_integrazione_gp4       impostazioni.integr_gp4%type;
      d_amministrazione        ottiche.amministrazione%type;
      d_ottica_istituzionale   ottiche.ottica_istituzionale%type;
      d_data_pubb              date := nvl(revisione_struttura.get_data_pubblicazione(p_ottica
                                                                                     ,p_revisione)
                                          ,p_data);
      d_oggi                   date := trunc(sysdate);
      d_id_componente_prec     componenti.id_componente%type;
      d_next_date              date;
      d_job                    number;
      d_segnalazione           varchar2(2000);
      d_segnalazione_bloccante varchar2(2);
   begin
      set_tipo_revisione(p_ottica, p_revisione);
      revisione_struttura.s_attivazione              := 1;
      revisione_struttura.s_ottica_in_attivazione    := p_ottica;
      revisione_struttura.s_revisione_in_attivazione := p_revisione;
      -- la data di pubblicazione non può essere precedente la sysdate
      if d_data_pubb < trunc(sysdate) or d_data_pubb is null or d_data_pubb = p_data then
         update revisioni_struttura
            set data_pubblicazione = greatest(trunc(sysdate), p_data)
          where ottica = p_ottica
            and revisione = p_revisione;

         d_data_pubb := greatest(trunc(sysdate), p_data);

      end if;
      revisione_struttura.s_data_pubb_in_attivazione := d_data_pubb;
      -- si aggiorna la data di inizio e/o fine validita dei legami
      -- istituiti e/o cessati con la revisione data
      unita_organizzativa.update_unor(p_ottica, p_revisione, p_data);
      -- si aggiorna la data di inizio e/o fine validita dei componenti
      -- istituiti e/o cessati con la revisione data
      componente.update_comp(p_ottica, p_revisione, p_data);
      -- si aggiorna la data di inizio e/o fine validita degli incarichi
      -- assegnati e/o revocati con la revisione data per i quali i componenti non
      -- sono stati modificati
      attributo_componente.update_atco(p_ottica, p_revisione, p_data);
      -- si aggiorna la data di fine validita' delle anagrafiche
      -- delle unita' organizzative cessate con la revisione
      update_anuo(p_ottica, p_revisione, p_data);
      --
      -- Si controlla se l'integrazione con GP4 e' attiva
      --
      d_integrazione_gp4     := impostazione.get_integr_gp4(1);
      d_amministrazione      := ottica.get_amministrazione(p_ottica);
      d_ottica_istituzionale := ottica.get_ottica_istituzionale(p_ottica);
      --
      if nvl(d_ottica_istituzionale, 'NO') = 'NO' then
         d_integrazione_gp4 := 'NO';
      end if;
      --
      -- Se l'integrazione e' attiva, si controlla se le modifiche di
      -- struttura originano una revisione in GP4
      --
      if d_integrazione_gp4 = 'SI' and
         so4gp_pkg.is_struttura_integrata(d_amministrazione, '') = 'SI' and --#429
         p_revisione <> 0 then
         -- gestiamo le UO modificate su UOSG
         so4gp_pkg.tratta_most_attivazione_rev(p_ottica, p_revisione, p_data); --#429
         --
         -- Si aggiorna la data modifica sui componenti modificati con la
         -- revisione
         --
         for moas in (select *
                        from vista_componenti c
                       where ci is not null
                         and nvl(tipo_assegnazione, 'I') = 'I'
                         and ottica = p_ottica
                         and nvl(assegnazione_prevalente, -1) in (1, 11, 12, 13)
                         and (revisione_assegnazione = p_revisione or
                             rev_asse_attr = p_revisione)
                      union
                      select *
                        from vista_componenti c
                       where ci is not null
                         and nvl(tipo_assegnazione, 'I') = 'I'
                         and ottica = p_ottica
                         and nvl(assegnazione_prevalente, -1) in (1, 11, 12, 13)
                         and responsabile = 'SI'
                         and nvl(c.al, to_date(3333333, 'j')) >= p_data
                         and progr_unita_organizzativa in
                             (select progr_unita_organizzativa
                                from anagrafe_unita_organizzative
                               where revisione_istituzione = p_revisione
                                  or revisione_cessazione = p_revisione)
                       order by 7
                               ,3)
         loop
            begin
               so4gp_pkg.ins_modifiche_assegnazioni(p_ottica            => p_ottica
                                                   ,p_ni                => moas.ni
                                                   ,p_ci                => moas.ci
                                                   ,p_provenienza       => 'SO4'
                                                   ,p_data_modifica     => p_data
                                                   ,p_revisione_so4     => p_revisione
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
         end loop;
      end if;
      --
      -- Popola (in differita) la RELAZIONI_STRUTTURA con la le registrazioni della revisione
      --
      begin
         begin
            select sysdate + (select (count(*) + 1) * 0.001
                                from user_jobs
                               where what like '%begin aggiorna_relazioni_struttura%'
                                 and broken = 'N')
              into d_next_date
              from dual;
            d_job := job_utility.crea('declare d_segnalazione varchar2(2000); d_segnalazione_bloccante varchar2(2000); begin aggiorna_relazioni_struttura(p_ottica=>''' ||
                                      p_ottica || ''',p_revisione=>' || p_revisione ||
                                      ',p_revisione_modifica=>''NO'',p_aggiorna_dati=>''NO'',p_segnalazione_bloccante=>d_segnalazione_bloccante,p_segnalazione=>d_segnalazione);exception when others then null;end;'
                                     ,d_next_date);
            -- Feature #710 schedula anche la rigenerazione della parte relativa alla parte di AD4
            -- Feature #45341 modificata la chiamata all'oggetto di AD4 e limitata l'azione ai soli componenti validi dell'ottica richiesta
            for ute in (select u.utente
                          from ad4_utenti_soggetti u
                              ,componenti          c
                         where u.soggetto = c.ni
                           and nvl(c.al, to_date(3333333, 'j')) >= p_data
                           and ottica = p_ottica)
            loop
               ad4_schedula_rigenera_so(ute.utente);
            end loop;
         exception
            when no_data_found then
               null;
         end;

      exception
         when others then
            null;
      end;
      revisione_struttura.s_attivazione              := 0;
      revisione_struttura.s_ottica_in_attivazione    := '';
      revisione_struttura.s_revisione_in_attivazione := -1;
      revisione_struttura.s_data_pubb_in_attivazione := '';

      --#713 Eredita i ruoli per i componenti spostati nella revisione
      if nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO', 'EreditaRuoli', 0), 'NO') = 'SI' then
         begin
            for comp in (select id_componente
                               ,dal
                               ,al
                               ,ni
                               ,codice_fiscale
                               ,(select count(*)
                                   from componenti c1
                                  where ottica = p_ottica
                                    and nvl(revisione_cessazione, -2) = p_revisione
                                    and ni = c.ni
                                    and exists
                                  (select 'x'
                                           from ruoli_componente
                                          where id_componente = c1.id_componente
                                            and al = p_data - 1)) num_componente_prec
                           from componenti c
                          where ottica = p_ottica
                            and c.dal <= nvl(c.al, to_date(3333333, 'j'))
                            and nvl(c.revisione_assegnazione, -2) = p_revisione
                            and nvl(c.al, to_date(3333333, 'j')) >=
                                (greatest(p_data, d_oggi)))
            loop
               if comp.num_componente_prec = 1 then
                  --determinazione dell'id_componente modello
                  select id_componente
                    into d_id_componente_prec
                    from componenti c
                   where ottica = p_ottica
                     and nvl(revisione_cessazione, -2) = p_revisione
                     and ni = comp.ni
                     and exists (select 'x'
                            from ruoli_componente
                           where id_componente = c.id_componente
                             and al = p_data - 1);
                  --riassegnazione ruoli da modello
                  for ruco in (select ruolo
                                 from ruoli_componente r
                                where id_componente = d_id_componente_prec
                                  and so4_pkg.check_ruolo_riservato(r.ruolo) = 0 --#30648
                                  and not exists
                                (select 'x'
                                         from ruoli_derivati
                                        where id_ruolo_componente = r.id_ruolo_componente)
                                  and al = p_data - 1
                                order by ruolo
                                        ,dal)
                  loop
                     begin
                        ruolo_componente.ins(p_id_ruolo_componente  => ''
                                            ,p_id_componente        => comp.id_componente
                                            ,p_ruolo                => ruco.ruolo
                                            ,p_dal                  => comp.dal
                                            ,p_al                   => comp.al
                                            ,p_utente_aggiornamento => 'SO4'
                                            ,p_data_aggiornamento   => trunc(sysdate));
                     exception
                        when others then
                           key_error_log_tpk.ins(p_error_id       => ''
                                                ,p_error_session  => p_revisione + 0.1
                                                ,p_error_date     => trunc(sysdate)
                                                ,p_error_text     => 'Errore in eredita ruoli della revisione ' ||
                                                                     p_ottica || '-' ||
                                                                     p_revisione ||
                                                                     '; Id.comp. ' ||
                                                                     comp.id_componente ||
                                                                     ' - Ruolo: ' ||
                                                                     ruco.ruolo
                                                ,p_error_user     => 'Ered.Att'
                                                ,p_error_usertext => sqlerrm
                                                ,p_error_type     => 'E');
                     end;
                  end loop;
               else
                  key_error_log_tpk.ins(p_error_id       => ''
                                       ,p_error_session  => p_revisione + 0.1
                                       ,p_error_date     => trunc(sysdate)
                                       ,p_error_text     => 'Errore in eredita ruoli della revisione ' ||
                                                            p_ottica || '-' ||
                                                            p_revisione || '; Id.comp. ' ||
                                                            comp.id_componente
                                       ,p_error_user     => 'Ered.Att'
                                       ,p_error_usertext => 'Non esiste un modello di assegnazione precedente univoca'
                                       ,p_error_type     => 'E');
               end if;
            end loop;
         exception
            when others then
               key_error_log_tpk.ins(p_error_id       => ''
                                    ,p_error_session  => p_revisione + 0.1
                                    ,p_error_date     => trunc(sysdate)
                                    ,p_error_text     => 'Errore in eredita ruoli della revisione ' ||
                                                         p_ottica || '-' || p_revisione
                                    ,p_error_user     => 'Ered.Att'
                                    ,p_error_usertext => sqlerrm
                                    ,p_error_type     => 'E');
         end;
      end if;

      --#634 Assegnazione dei ruoli automatici ai componenti interessati dall'attivazione della revisione
      if nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO'
                                           ,'AttribuzioneAutomaticaRuoli'
                                           ,0)
            ,'NO') = 'SI' then
         begin
            ruolo_componente.s_ruoli_automatici := 1;
            --Anagrafe UO
            for anuo in (select *
                           from anagrafe_unita_organizzative a
                          where ottica = p_ottica
                            and revisione_istituzione = p_revisione
                            and nvl(al, to_date(3333333, 'j')) >= d_oggi
                            and (exists --UO storicizzata con modifiche a suddivisione e/o codice
                                 (select 'x'
                                    from anagrafe_unita_organizzative
                                   where progr_unita_organizzativa =
                                         a.progr_unita_organizzativa
                                     and al = p_data - 1
                                     and (id_suddivisione <> a.id_suddivisione or
                                         codice_uo <> a.codice_uo)) or not exists --UO creata nella revisione
                                 (select 'x'
                                    from anagrafe_unita_organizzative
                                   where progr_unita_organizzativa =
                                         a.progr_unita_organizzativa
                                     and dal < p_data)))
            loop
               -- tratta tutti i componenti non modificati dalla revisione ma assegnatio alle UO interessate
               for comp in (select id_componente
                                  ,dal
                                  ,al
                              from componenti c
                             where progr_unita_organizzativa =
                                   anuo.progr_unita_organizzativa
                               and ottica = p_ottica
                               and c.dal <= nvl(c.al, to_date(3333333, 'j'))
                               and nvl(c.revisione_assegnazione, -2) <> p_revisione
                               and nvl(c.al, to_date(3333333, 'j')) >=
                                   (greatest(p_data, d_oggi)))
               loop
                  componente.attribuzione_ruoli(comp.id_componente
                                               ,greatest(p_data, d_oggi)
                                               ,comp.al
                                               ,4
                                               ,d_segnalazione_bloccante
                                               ,d_segnalazione);
               end loop;
            end loop;
            --Analizza i componenti creati con la revisione
            for comp in (select id_componente
                               ,dal
                               ,al
                           from componenti c
                          where ottica = p_ottica
                            and c.dal <= nvl(c.al, to_date(3333333, 'j'))
                            and nvl(c.revisione_assegnazione, -2) = p_revisione
                            and nvl(c.al, to_date(3333333, 'j')) >=
                                (greatest(p_data, d_oggi)))
            loop
               componente.attribuzione_ruoli(comp.id_componente
                                            ,greatest(p_data, d_oggi)
                                            ,comp.al
                                            ,1
                                            ,d_segnalazione_bloccante
                                            ,d_segnalazione);
            end loop;
            --Analizza gli Attributi modificati in revisione (modifica del solo attributo)
            for atco in (select id_componente
                               ,dal
                               ,al
                           from attributi_componente a
                          where ottica = p_ottica
                            and a.dal <= nvl(a.al, to_date(3333333, 'j'))
                            and nvl(a.revisione_assegnazione, -2) = p_revisione
                            and nvl(a.al, to_date(3333333, 'j')) >=
                                (greatest(p_data, d_oggi))
                            and not exists
                          (select 'x'
                                   from componenti c
                                  where c.id_componente = a.id_componente
                                    and nvl(c.revisione_assegnazione, -2) = p_revisione))
            loop
               componente.attribuzione_ruoli(atco.id_componente
                                            ,greatest(p_data, d_oggi)
                                            ,atco.al
                                            ,2
                                            ,d_segnalazione_bloccante
                                            ,d_segnalazione);
            end loop;
            --Analizza gli spostamenti di UO in revisione
            for unor in (select ottica
                               ,revisione
                               ,progr_unita_organizzativa
                           from unita_organizzative u
                          where ottica = p_ottica
                            and revisione = p_revisione
                            and exists (select 'x'
                                   from unita_organizzative u1
                                  where progr_unita_organizzativa =
                                        u.progr_unita_organizzativa
                                    and ottica = u.ottica
                                    and id_elemento <> u.id_elemento
                                    and revisione_cessazione = u.revisione
                                    and nvl(id_unita_padre, -1) <>
                                        nvl(u.id_unita_padre, -1))
                          order by progr_unita_organizzativa)
            loop
               --tratta tutti i componenti assegnati alla UO spostata e non gia' trattati nella revisione
               for comp in (select id_componente
                                  ,dal
                                  ,al
                              from componenti c
                             where progr_unita_organizzativa =
                                   unor.progr_unita_organizzativa
                               and ottica = p_ottica
                               and c.dal <= nvl(c.al, to_date(3333333, 'j'))
                               and nvl(c.revisione_assegnazione, -2) <> p_revisione
                               and nvl(c.al, to_date(3333333, 'j')) >=
                                   (greatest(p_data, d_oggi)))
               loop
                  componente.attribuzione_ruoli(comp.id_componente
                                               ,greatest(p_data, d_oggi)
                                               ,comp.al
                                               ,5
                                               ,d_segnalazione_bloccante
                                               ,d_segnalazione);
               end loop;
            end loop;
            ruolo_componente.s_ruoli_automatici := 0;
         end;
      end if;
     --Attiva la rigenerazione dei diritti di accesso di AD4  #45341
      begin
         begin
            -- Feature #710 schedula anche la rigenerazione della parte relativa alla parte di AD4
            -- Feature #45341 modificata la chiamata all'oggetto di AD4 e limitata l'azione ai soli componenti validi dell'ottica richiesta
            for ute in (select u.utente,soggetto
                          from ad4_utenti_soggetti u
                              ,componenti          c
                         where u.soggetto = c.ni
                           and nvl(c.al, to_date(3333333, 'j')) >= p_data
                           and ottica = p_ottica)
            loop
               begin
                  ad4_schedula_rigenera_so(ute.utente);
               exception
                  when others then
                     key_error_log_tpk.ins(p_error_id       => ''
                                          ,p_error_session  => p_revisione + 0.1
                                          ,p_error_date     => trunc(sysdate)
                                          ,p_error_text     => 'Errore in ad4_schedula_rigenera_so ' ||
                                                               ute.utente || '-' ||
                                                               p_revisione ||
                                                               '; NI ' ||
                                                               ute.soggetto
                                          ,p_error_user     => 'rigene_SO'
                                          ,p_error_usertext => sqlerrm
                                          ,p_error_type     => 'E');
               end;
            end loop;
         exception
            when others then
               null;
         end;
      exception
         when others then
            null;
      end;
   end; -- revisione_struttura.attivazione_revisione
   --------------------------------------------------------------------------------
   -- procedure di aggiornamento della data di inizio e fine validità
   -- delle anagrafiche U.O. istituite o cessate al momento dell'attivazione
   -- della revisione
   --
   procedure update_anuo
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
     ,p_data      in revisioni_struttura.dal%type
   ) is
      /******************************************************************************
       NOME:        update_ANUO.
       DESCRIZIONE: Aggiornamento della data di inizio e fine validità
                    delle anagrafiche U.O. istituite o cessate al momento dell'attivazione
                    della revisione
                    Determinazione delle date di pubblicazione per gli altri applicativi
       RITORNA:     -
      ******************************************************************************/
      d_data_pubb    date := nvl(revisione_struttura.get_data_pubblicazione(p_ottica
                                                                           ,p_revisione)
                                ,p_data);
      d_min_dal_pubb anagrafe_unita_organizzative.dal_pubb%type;
      d_al_pubb      anagrafe_unita_organizzative.dal%type;
      d_new_dal      anagrafe_unita_organizzative.al_pubb%type;
      d_max_al       date;
      d_max_al_pubb  date;
   begin
      set_tipo_revisione(p_ottica, p_revisione);
      if s_tipo_revisione = 'N' then
         -- revisione non retroattiva
         update anagrafe_unita_organizzative
            set dal      = least(dal, p_data)
               ,dal_pubb = d_data_pubb
          where ottica = p_ottica
            and revisione_istituzione = p_revisione;
         update anagrafe_unita_organizzative a
            set a.al      = p_data - 1
               ,a.al_pubb = d_data_pubb - 1
          where a.ottica = p_ottica
            and a.revisione_cessazione = p_revisione;
      elsif s_tipo_revisione = 'R' then
         -- revisione con profondita' storica fino alla situazione Corrente
         revisione_struttura.s_attivazione := 1;
         /* elimina logicamente le registrazioni relative a UO modificate modifiche
            che hanno decorrenza successiva alla data di decorrenza della nuova revisione #703
         */
         -----------------------------------------------------------------------------------------------------------------------
         for anuo in (select *
                        from anagrafe_unita_organizzative a
                       where ottica = p_ottica
                         and revisione_istituzione <> p_revisione
                         and dal >= p_data
                         and dal <= nvl(al, to_date(3333333, 'j')) --#703
                         and exists
                       (select 'x'
                                from anagrafe_unita_organizzative
                               where ottica = p_ottica
                                 and progr_unita_organizzativa =
                                     a.progr_unita_organizzativa
                                 and ((revisione_istituzione = p_revisione) or --#703
                                     (revisione_cessazione = p_revisione)))
                       order by progr_unita_organizzativa
                               ,dal)
         loop
            --determiniamo la data di termine pubblicazione del record eliminato
            select least(trunc(sysdate), nvl(anuo.al_pubb, to_date(3333333, 'j')))
              into d_al_pubb
              from dual;

            --determiniamo la prima data di inizio pubblicazione tra i record gia' (eventualmente) eliminati
            select min(dal_pubb)
              into d_min_dal_pubb
              from anagrafe_unita_organizzative
             where progr_unita_organizzativa = anuo.progr_unita_organizzativa
               and dal > nvl(al, to_date(3333333, 'j'));

            d_al_pubb := least(d_al_pubb, d_min_dal_pubb - 1);

            /* inserisco la registrazione eliminata sulla tabella ANAGRAFE_UNITA_ORGANIZZATIVE nel range temporale
               che identifica le cancellazioni logiche
            */
            d_new_dal                                          := anagrafe_unita_organizzativa.get_pk_anue(anuo.progr_unita_organizzativa);
            anagrafe_unita_organizzativa.s_eliminazione_logica := 1;
            anagrafe_unita_organizzativa.ins_anue(p_progr_unita_organizzativa => anuo.progr_unita_organizzativa
                                                 ,p_dal                       => d_new_dal
                                                 ,p_codice_uo                 => anuo.codice_uo
                                                 ,p_descrizione               => anuo.descrizione
                                                 ,p_descrizione_al1           => anuo.descrizione_al1
                                                 ,p_descrizione_al2           => anuo.descrizione_al2
                                                 ,p_des_abb                   => anuo.des_abb
                                                 ,p_des_abb_al1               => anuo.des_abb_al1
                                                 ,p_des_abb_al2               => anuo.des_abb_al2
                                                 ,p_id_suddivisione           => anuo.id_suddivisione
                                                 ,p_ottica                    => anuo.ottica
                                                 ,p_revisione_istituzione     => anuo.revisione_istituzione
                                                 ,p_revisione_cessazione      => p_revisione
                                                 ,p_tipologia_unita           => anuo.tipologia_unita
                                                 ,p_se_giuridico              => anuo.se_giuridico
                                                 ,p_assegnazione_componenti   => anuo.assegnazione_componenti
                                                 ,p_amministrazione           => anuo.amministrazione
                                                 ,p_progr_aoo                 => anuo.progr_aoo
                                                 ,p_indirizzo                 => anuo.indirizzo
                                                 ,p_cap                       => anuo.cap
                                                 ,p_provincia                 => anuo.provincia
                                                 ,p_comune                    => anuo.comune
                                                 ,p_telefono                  => anuo.telefono
                                                 ,p_fax                       => anuo.fax
                                                 ,p_centro                    => anuo.centro
                                                 ,p_centro_responsabilita     => anuo.centro_responsabilita
                                                 ,p_al                        => d_new_dal - 1
                                                 ,p_utente_ad4                => anuo.utente_ad4
                                                 ,p_utente_aggiornamento      => anuo.utente_aggiornamento
                                                 ,p_data_aggiornamento        => trunc(sysdate)
                                                 ,p_note                      => anuo.note
                                                 ,p_tipo_unita                => anuo.tipo_unita
                                                 ,p_dal_pubb                  => anuo.dal_pubb
                                                 ,p_al_pubb                   => least(d_al_pubb
                                                                                      ,d_min_dal_pubb - 1)
                                                 ,p_al_prec                   => anuo.al_prec
                                                 ,p_incarico_resp             => anuo.incarico_resp
                                                 ,p_etichetta                 => anuo.etichetta
                                                 ,p_aggregatore               => anuo.aggregatore
                                                 ,p_se_fattura_elettronica    => anuo.se_fattura_elettronica);
            anagrafe_unita_organizzativa.s_eliminazione_logica := 0;

            --cancellazione fisica della riga indicata
            delete from anagrafe_unita_organizzative
             where progr_unita_organizzativa = anuo.progr_unita_organizzativa
               and dal = anuo.dal;
            --chiudo il periodo con data di pubblicazione nulla dell'eventuale registrazione precedentemente eliminata
            anagrafe_unita_organizzativa.s_eliminazione_logica := 1;
            update anagrafe_unita_organizzative
               set al_pubb = trunc(sysdate)
             where progr_unita_organizzativa = anuo.progr_unita_organizzativa
                  --and dal = d_new_dal
               and anagrafe_unita_organizzativa.is_periodo_eliminato(dal) = 1
               and al_pubb is null;
            --elimino i periodi di cancellazione logica obsoleti
            delete from anagrafe_unita_organizzative
             where progr_unita_organizzativa = anuo.progr_unita_organizzativa
               and anagrafe_unita_organizzativa.is_periodo_eliminato(dal) = 1
               and nvl(al_pubb, to_date(3333333, 'j')) < dal_pubb;
            anagrafe_unita_organizzativa.s_eliminazione_logica := 0;

         end loop;

         /*modifica la data di termine delle registrazioni relative a UO modificate
         con termine successivo alla data di decorrenza della nuova revisione*/
         update anagrafe_unita_organizzative a
            set al_prec = ''
                -- al: dopo l'attivazione l'al_prec non viene piu' utilizzato
               ,al = p_data - 1
                -- ,dal = decode(dal,p_data,add_months(dal,-12000),dal)
               ,al_pubb              = least((d_data_pubb - 1)
                                            ,nvl(al_pubb, to_date(3333333, 'j')))
               ,revisione_cessazione = p_revisione --#703
          where ottica = p_ottica
            and revisione_istituzione <> p_revisione
            and nvl(a.al, to_date(3333333, 'j')) >= p_data
            and dal <= nvl(al, to_date(3333333, 'j'))
            and (exists (select 'x'
                           from anagrafe_unita_organizzative
                          where progr_unita_organizzativa = a.progr_unita_organizzativa
                            and revisione_istituzione = p_revisione
                            and ottica = p_ottica) or exists
                 (select 'x'
                    from anagrafe_unita_organizzative --#703
                   where progr_unita_organizzativa = a.progr_unita_organizzativa
                     and revisione_cessazione = p_revisione
                     and anagrafe_unita_organizzativa.is_periodo_eliminato(dal) = 1
                     and ottica = p_ottica));
         update anagrafe_unita_organizzative
            set dal      = least(dal, p_data)
               ,dal_pubb = d_data_pubb
          where ottica = p_ottica
            and revisione_istituzione = p_revisione;
         update anagrafe_unita_organizzative
            set al      = p_data - 1
               ,al_pubb = d_data_pubb - 1
          where ottica = p_ottica
            and anagrafe_unita_organizzativa.is_periodo_eliminato(dal) = 0 --#703
            and revisione_cessazione = p_revisione;
         revisione_struttura.s_attivazione := 0;
      end if;
      /* Chiusura dell' Anagrafe UO delle unità di altre ottiche eliminate nella revisione
         e non altrove utilizzate #423
      */
      for unor in (select progr_unita_organizzativa
                     from unita_organizzative u
                    where ottica = p_ottica
                      and revisione_cessazione = p_revisione
                      and dal <= nvl(al, to_date(3333333, 'j'))
                      and exists
                    (select 'x'
                             from anagrafe_unita_organizzative
                            where (al = p_data - 1 or al is null)
                              and revisione_cessazione = p_revisione
                              and progr_unita_organizzativa = u.progr_unita_organizzativa)
                      and not exists
                    (select 'x'
                             from unita_organizzative
                            where progr_unita_organizzativa = u.progr_unita_organizzativa
                              and al is null)
                    order by progr_unita_organizzativa)
      loop
         --determina la massima validita del progressivo su UNOR
         select max(nvl(al, to_date(3333333, 'j')))
               ,max(nvl(al_pubb, to_date(3333333, 'j')))
           into d_max_al
               ,d_max_al_pubb
           from unita_organizzative
          where progr_unita_organizzativa = unor.progr_unita_organizzativa
            and dal <= nvl(al, to_date(3333333, 'j'));

         update anagrafe_unita_organizzative a
            set al                   = d_max_al
               ,al_pubb              = d_max_al_pubb
               ,revisione_cessazione = decode(a.ottica
                                             ,p_ottica
                                             ,p_revisione
                                             ,to_number(null))
          where progr_unita_organizzativa = unor.progr_unita_organizzativa
            and (al = p_data - 1 or al is null)
            and revisione_cessazione = p_revisione;
      end loop;

   end;
   --------------------------------------------------------------------------------
   function get_al
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return date is
      d_al revisioni_struttura.dal%type := to_date(null);
      /******************************************************************************
         NAME:       GET_AL
         PURPOSE:    Fornire la data di fine validita della revisione fornita
                     che equivale al dal della revisione successiva - 1
      ******************************************************************************/
   begin
      begin
         select dal - 1
           into d_al
           from revisioni_struttura
          where dal = (select min(dal)
                         from revisioni_struttura
                        where dal > revisione_struttura.get_dal(p_ottica, p_revisione)
                          and ottica = p_ottica)
            and ottica = p_ottica;
      exception
         when no_data_found or too_many_rows then
            d_al := to_date(null);
      end;
      return d_al;
   end get_al;
   --------------------------------------------------------------------------------
   procedure set_fi
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
     ,p_data      in revisioni_struttura.data%type
     ,p_new_stato in revisioni_struttura.stato%type
     ,p_old_stato in revisioni_struttura.stato%type
     ,p_inserting in number
     ,p_updating  in number
     ,p_deleting  in number
   ) is
      /******************************************************************************
       NOME:        set_FI.
       DESCRIZIONE: Settaggio della functional integrity
       RITORNA:     -
      ******************************************************************************/
   begin
      if p_inserting = 0 and p_updating = 1 and p_deleting = 0 then
         if p_new_stato = 'A' and p_old_stato = 'M' then
            --
            --   Si lancia la procedure di attivazione della revisione
            --
            revisione_struttura.attivazione_revisione(p_ottica, p_revisione, p_data);
         end if;
      end if;
   end;
   --------------------------------------------------------------------------------
   -- Procedure di definizione del tipo_revisione
   procedure set_tipo_revisione
   (
      p_ottica    in unita_organizzative.ottica%type
     ,p_revisione in unita_organizzative.revisione%type
   ) is
      /******************************************************************************
       NOME:        set_tipo_assegnazione
       DESCRIZIONE: valorizza la variabile s_tipo_revisione
       PARAMETRI:   Ottica
                    Revisione
      ******************************************************************************/
   begin
      s_tipo_revisione := nvl(revisione_struttura.get_tipo_revisione(p_ottica
                                                                    ,p_revisione)
                             ,'N');
   end; -- revisione_struttura.set_tipo_revisione
   --------------------------------------------------------------------------------
   procedure modifica_decorrenza
   (
      p_ottica                 in revisioni_struttura.ottica%type
     ,p_revisione              in revisioni_struttura.revisione%type
     ,p_dal                    in date
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        modifica_decorrenza
       DESCRIZIONE: Modifica il dal della revisione e aggiorna le date
                    delle registrazioni di componenti e UO ad essa correlate
                    se sono uguali alla precedente decorrenza
       PARAMETRI:   Ottica
                    Revisione
      ******************************************************************************/
   begin
      null;
   end; -- revisione_struttura.modifica_decorrenza
   --------------------------------------------------------------------------------
   -- Verifica se la revisione e' gia' stata istanziata
   function is_revisione_modificabile
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_revisione_modificabile
       DESCRIZIONE: Verifica se la revisione e' gia' stata istanziata
       NOTE:
      ******************************************************************************/
      d_result afc_error.t_error_number := s_data_revisione_errata_number;
   begin
      begin
         select 'x'
           into s_dummy
           from unita_organizzative u
          where ottica = p_ottica
            and (u.revisione = p_revisione or u.revisione_cessazione = p_revisione);
         raise too_many_rows;
      exception
         when no_data_found then
            d_result := afc_error.ok;
         when too_many_rows then
            d_result := s_rev_non_modificabile_number;
      end;
      begin
         select 'x'
           into s_dummy
           from anagrafe_unita_organizzative a
          where ottica = p_ottica
            and (a.revisione_istituzione = p_revisione or
                a.revisione_cessazione = p_revisione);
         raise too_many_rows;
      exception
         when no_data_found then
            d_result := afc_error.ok;
         when too_many_rows then
            d_result := s_rev_non_modificabile_number;
      end;
      begin
         select 'x'
           into s_dummy
           from componenti c
          where ottica = p_ottica
            and (c.revisione_assegnazione = p_revisione or
                c.revisione_cessazione = p_revisione);
         raise too_many_rows;
      exception
         when no_data_found then
            d_result := afc_error.ok;
         when too_many_rows then
            d_result := s_rev_non_modificabile_number;
      end;
      begin
         select 'x'
           into s_dummy
           from attributi_componente a
          where ottica = p_ottica
            and (a.revisione_assegnazione = p_revisione or
                a.revisione_cessazione = p_revisione);
         raise too_many_rows;
      exception
         when no_data_found then
            d_result := afc_error.ok;
         when too_many_rows then
            d_result := s_rev_non_modificabile_number;
      end;
      return d_result;
   end; -- Revisione_struttura.is_revisione_modificabile
   --------------------------------------------------------------------------------
   -- Valuta le modifiche eseguite nella revisione
   function get_motivo_revisione
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
   ) return varchar2 is
      /******************************************************************************
       NOME:        get_motivo_revisione
       DESCRIZIONE: Valuta le modifiche eseguite nella revisione
       NOTE:
      ******************************************************************************/
      d_motivo varchar2(1) := 'N';
      d_uo     number(1) := 0;
      d_comp   number(1) := 0;
   begin
      begin
         select 1
           into d_uo
           from dual
          where exists
          (select 'x'
                   from unita_organizzative u
                  where ottica = p_ottica
                    and (u.revisione = p_revisione or u.revisione_cessazione = p_revisione))
             or exists (select 'x'
                   from anagrafe_unita_organizzative a
                  where ottica = p_ottica
                    and (a.revisione_istituzione = p_revisione or
                        a.revisione_cessazione = p_revisione));
      exception
         when no_data_found then
            null;
      end;
      begin
         select 1
           into d_comp
           from dual
          where exists (select 'x'
                   from componenti c
                  where ottica = p_ottica
                    and (c.revisione_assegnazione = p_revisione or
                        c.revisione_cessazione = p_revisione))
             or exists (select 'x'
                   from attributi_componente a
                  where ottica = p_ottica
                    and (a.revisione_assegnazione = p_revisione or
                        a.revisione_cessazione = p_revisione));
      exception
         when no_data_found then
            null;
      end;
      if d_comp = 1 and d_uo = 1 then
         d_motivo := 'G';
      elsif d_comp = 1 and d_uo = 0 then
         d_motivo := 'O';
      elsif d_comp = 0 and d_uo = 1 then
         d_motivo := 'S';
      end if;
      return d_motivo;
   end; -- Revisione_struttura.GET_MOTIVO_REVISIONE
--------------------------------------------------------------------------------
begin
   -- inserimento degli errori nella tabella
   s_error_table(s_legami_istituiti_number) := s_legami_istituiti_msg;
   s_error_table(s_legami_cessati_number) := s_legami_cessati_msg;
   s_error_table(s_componenti_istituiti_number) := s_componenti_istituiti_msg;
   s_error_table(s_componenti_cessati_number) := s_componenti_cessati_msg;
   s_error_table(s_data_revisione_errata_number) := s_data_revisione_errata_msg;
   s_error_table(s_rev_non_modificabile_number) := s_rev_non_modificabile_msg;
   s_error_table(s_esiste_rev_modifica_number) := s_esiste_rev_modifica_msg;
   s_error_table(s_data_pubb_errata_number) := s_data_pubb_errata_msg;
end revisione_struttura;
/

