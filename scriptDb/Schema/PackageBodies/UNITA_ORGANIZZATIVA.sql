CREATE OR REPLACE package body unita_organizzativa is
   /******************************************************************************
    NOME:        unita_organizzativa
    DESCRIZIONE: Gestione tabella unita_organizzative.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore      Descrizione.
    000   01/08/2006  VDAVALLI    Prima emissione.
    001   04/09/2009  VDAVALLI    Modifiche per configurazione master/slave
    002   29/04/2010  APASSUELLO  Modifica per aggiunta di controlli sulla congruenza delle revisioni
    003   12/05/2010  APASSUELLO  Modifica dell procedures elimina_legame, ripristina_legame,
                                  sposta_legame per gestione della descrizione dell'unità considerando la
                                  revisione in modifica (anagrafe_unita_organizzative.get_descrizione_corrente)
    004   22/09/2010  APASSUELLO  Modificato function esistono_componenti per l'utilizzo nello spostamento
                                  componenti
    005   04/11/2010  SNEGRONI    Inserite copia_figli e cancella_figli per spostamento e ripristino
                                  di un sottoalbero.
    006   24/11/2010  APASSUELLO  Aggiunto procedure duplica_struttura
    007   01/08/2011  MMONARI     Modifiche per ottiche non istituzionali derivate
    008   24/11/2011  VDAVALLI    Modifiche alla procedure spostamento componenti
    009   30/11/2011  MMONARI     Modifiche per revisioni reetroattive (Dati Storici)
    010   02/07/2012  MMONARI     Consolidamento rel.1.4.1
    011   16/11/2012  MMONARI     Redmine bug #109
    012   30/01/2012  MMONARI     Redmine bug #86
    013   22/04/2013  ADADAMO     Redmine bug #216
    014   09/05/2013  VDAVALLI    Redmine bug #250, correzione ripristina_legame (su padre eliminato)
    015   21/03/2014  MMONARI     Redmine bug #406, correzione su duplica ottiche
    016   28/04/2014  MMONARI     Redmine bug #423, correzione elimina_legame e set_revisione_cessazione
    017   15/05/2014  MMONARI     Redmine bug #448, correzione impostazione date su nodi radice
    018   28/05/2014  MMONARI     Redmine bug #455, correzione condizioni su esistono_componenti
    019   18/08/2014  MMONARI     Redmine bug #264, correzione condizioni in duplica_ottica
          26/08/2014  MMONARI     Redmine bug #489, correzione condizioni in update_unor
          05/09/2014  MMONARI     Redmine Feature #265, trasformazione di nodo in radice in sposta_legame
          05/09/2014  MMONARI     Redmine Bug #490, gestione date pubblicazione in ripristina_legame
          15/10/2014  MMONARI     Redmine Bug #541, gestione componenti extra revisione in duplica_ottica
    020   20/03/2015  MMONARI     Bug #584 errata gestione del dal_pubb su elimina_legame
    021   20/03/2015  MMONARI     Bug #771 correzione si update_unor
    022   01/10/2019  MMONARI     #37253 correzione del ripristino legame di una radice
   ******************************************************************************/
   s_revisione_body constant afc.t_revision := '022';
   s_table_name     constant afc.t_object_name := 'unita_organizzative';
   s_error_table    afc_error.t_error_table;
   s_dummy          varchar2(1);
   s_tipo_revisione revisioni_struttura.tipo_revisione%type;
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
   end; -- unita_organizzativa.versione
   --------------------------------------------------------------------------------
   function pk(p_id_elemento in unita_organizzative.id_elemento%type) return t_pk is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        PK
       DESCRIZIONE: Costruttore di un t_PK dati gli attributi della chiave
      ******************************************************************************/
      d_result t_pk;
   begin
      d_result.id_elemento := p_id_elemento;
      dbc.pre(not dbc.preon or canhandle(d_result.id_elemento)
             ,'canHandle on unita_organizzativa.PK');
      return d_result;
   end; -- end unita_organizzativa.PK
   --------------------------------------------------------------------------------
   function can_handle(p_id_elemento in unita_organizzative.id_elemento%type) return number is
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
      if d_result = 1 and (p_id_elemento is null) then
         d_result := 0;
      end if;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on unita_organizzativa.can_handle');
      return d_result;
   end; -- unita_organizzativa.can_handle
   --------------------------------------------------------------------------------
   function canhandle(p_id_elemento in unita_organizzative.id_elemento%type) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        canHandle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: true se la chiave è manipolabile, false altrimenti.
       NOTE:        Wrapper boolean di can_handle (cfr. can_handle).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(can_handle(p_id_elemento));
   begin
      return d_result;
   end; -- unita_organizzativa.canHandle
   --------------------------------------------------------------------------------
   function exists_id(p_id_elemento in unita_organizzative.id_elemento%type) return number is
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
      dbc.pre(not dbc.preon or canhandle(p_id_elemento)
             ,'canHandle on unita_organizzativa.exists_id');
      begin
         select 1
           into d_result
           from unita_organizzative
          where id_elemento = p_id_elemento;
      exception
         when no_data_found then
            d_result := 0;
      end;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on unita_organizzativa.exists_id');
      return d_result;
   end; -- unita_organizzativa.exists_id
   --------------------------------------------------------------------------------
   function existsid(p_id_elemento in unita_organizzative.id_elemento%type) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        existsId
       DESCRIZIONE: Esistenza riga con chiave indicata.
       NOTE:        Wrapper boolean di exists_id (cfr. exists_id).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(exists_id(p_id_elemento));
   begin
      return d_result;
   end; -- unita_organizzativa.existsId
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
      p_id_elemento               in unita_organizzative.id_elemento%type default null
     ,p_ottica                    in unita_organizzative.ottica%type
     ,p_revisione                 in unita_organizzative.revisione%type default null
     ,p_sequenza                  in unita_organizzative.sequenza%type default null
     ,p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type default null
     ,p_id_unita_padre            in unita_organizzative.id_unita_padre%type default null
     ,p_revisione_cessazione      in unita_organizzative.revisione_cessazione%type default null
     ,p_dal                       in unita_organizzative.dal%type default null
     ,p_al                        in unita_organizzative.al%type default null
     ,p_utente_aggiornamento      in unita_organizzative.utente_aggiornamento%type default null
     ,p_data_aggiornamento        in unita_organizzative.data_aggiornamento%type default null
     ,p_dal_pubb                  in unita_organizzative.dal_pubb%type default null
     ,p_al_pubb                   in unita_organizzative.al_pubb%type default null
     ,p_al_prec                   in unita_organizzative.al_prec%type default null
     ,p_revisione_cess_prec       in unita_organizzative.revisione_cess_prec%type default null
   ) is
      /******************************************************************************
       NOME:        ins
       DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
       PARAMETRI:   Chiavi e attributi della table.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or p_ottica is not null
             ,'p_ottica on unita_organizzativa.ins');
      dbc.pre(not dbc.preon or p_id_elemento is null or p_revisione is null or
              p_sequenza is null or p_progr_unita_organizzativa is null or
              p_id_unita_padre is null or p_revisione_cessazione is null or
              p_dal is null or p_al is null or p_utente_aggiornamento is null or
              p_data_aggiornamento is null or not existsid(p_id_elemento)
             ,'not existsId on unita_organizzativa.ins');
      insert into unita_organizzative
         (id_elemento
         ,ottica
         ,revisione
         ,sequenza
         ,progr_unita_organizzativa
         ,id_unita_padre
         ,revisione_cessazione
         ,dal
         ,al
         ,dal_pubb
         ,al_pubb
         ,al_prec
         ,revisione_cess_prec
         ,utente_aggiornamento
         ,data_aggiornamento)
      values
         (p_id_elemento
         ,p_ottica
         ,p_revisione
         ,p_sequenza
         ,p_progr_unita_organizzativa
         ,p_id_unita_padre
         ,p_revisione_cessazione
         ,p_dal
         ,p_al
         ,p_dal_pubb
         ,p_al_pubb
         ,p_al_prec
         ,p_revisione_cess_prec
         ,p_utente_aggiornamento
         ,p_data_aggiornamento);
   end; -- unita_organizzativa.ins
   --------------------------------------------------------------------------------
   procedure upd
   (
      p_new_id_elemento          in unita_organizzative.id_elemento%type
     ,p_new_ottica               in unita_organizzative.ottica%type
     ,p_new_revisione            in unita_organizzative.revisione%type
     ,p_new_sequenza             in unita_organizzative.sequenza%type
     ,p_new_progr_unita_org      in unita_organizzative.progr_unita_organizzativa%type
     ,p_new_id_unita_padre       in unita_organizzative.id_unita_padre%type
     ,p_new_revisione_cessazione in unita_organizzative.revisione_cessazione%type
     ,p_new_dal                  in unita_organizzative.dal%type
     ,p_new_al                   in unita_organizzative.al%type
     ,p_new_dal_pubb             in unita_organizzative.dal_pubb%type default null
     ,p_new_al_pubb              in unita_organizzative.al_pubb%type default null
     ,p_new_al_prec              in unita_organizzative.al_prec%type default null
     ,p_new_revisione_cess_prec  in unita_organizzative.revisione_cess_prec%type default null
     ,p_new_utente_aggiornamento in unita_organizzative.utente_aggiornamento%type
     ,p_new_data_aggiornamento   in unita_organizzative.data_aggiornamento%type
     ,p_old_id_elemento          in unita_organizzative.id_elemento%type default null
     ,p_old_ottica               in unita_organizzative.ottica%type default null
     ,p_old_revisione            in unita_organizzative.revisione%type default null
     ,p_old_sequenza             in unita_organizzative.sequenza%type default null
     ,p_old_progr_unita_org      in unita_organizzative.progr_unita_organizzativa%type default null
     ,p_old_id_unita_padre       in unita_organizzative.id_unita_padre%type default null
     ,p_old_revisione_cessazione in unita_organizzative.revisione_cessazione%type default null
     ,p_old_dal                  in unita_organizzative.dal%type default null
     ,p_old_al                   in unita_organizzative.al%type default null
     ,p_old_dal_pubb             in unita_organizzative.dal_pubb%type default null
     ,p_old_al_pubb              in unita_organizzative.al_pubb%type default null
     ,p_old_al_prec              in unita_organizzative.al_prec%type default null
     ,p_old_revisione_cess_prec  in unita_organizzative.revisione_cess_prec%type default null
     ,p_old_utente_aggiornamento in unita_organizzative.utente_aggiornamento%type default null
     ,p_old_data_aggiornamento   in unita_organizzative.data_aggiornamento%type default null
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
              not ((p_old_ottica is not null or p_old_revisione is not null or
               p_old_sequenza is not null or p_old_progr_unita_org is not null or
               p_old_id_unita_padre is not null or
               p_old_revisione_cessazione is not null or p_old_dal is not null or
               p_old_al is not null or p_old_utente_aggiornamento is not null or
               p_old_data_aggiornamento is not null) and p_check_old = 0)
             ,' <OLD values> is not null on unita_organizzativa.upd');
      dbc.pre(not dbc.preon or p_check_old is not null
             ,'p_check_OLD is not null on unita_organizzativa.upd');
      d_key := pk(nvl(p_old_id_elemento, p_new_id_elemento));
      dbc.pre(not dbc.preon or existsid(d_key.id_elemento)
             ,'existsId on unita_organizzativa.upd');
      update unita_organizzative
         set id_elemento               = p_new_id_elemento
            ,ottica                    = p_new_ottica
            ,revisione                 = p_new_revisione
            ,sequenza                  = p_new_sequenza
            ,progr_unita_organizzativa = p_new_progr_unita_org
            ,id_unita_padre            = p_new_id_unita_padre
            ,revisione_cessazione      = p_new_revisione_cessazione
            ,dal                       = p_new_dal
            ,al                        = p_new_al
            ,dal_pubb                  = p_new_dal_pubb
            ,al_pubb                   = p_new_al_pubb
            ,al_prec                   = p_new_al_prec
            ,revisione_cess_prec       = p_new_revisione_cess_prec
            ,utente_aggiornamento      = p_new_utente_aggiornamento
            ,data_aggiornamento        = p_new_data_aggiornamento
       where id_elemento = d_key.id_elemento
         and (p_check_old = 0 or
             p_check_old = 1 and
             (ottica = p_old_ottica or ottica is null and p_old_ottica is null) and
             (revisione = p_old_revisione or
             revisione is null and p_old_revisione is null) and
             (sequenza = p_old_sequenza or sequenza is null and p_old_sequenza is null) and
             (progr_unita_organizzativa = p_old_progr_unita_org or
             progr_unita_organizzativa is null and p_old_progr_unita_org is null) and
             (id_unita_padre = p_old_id_unita_padre or
             id_unita_padre is null and p_old_id_unita_padre is null) and
             (revisione_cessazione = p_old_revisione_cessazione or
             revisione_cessazione is null and p_old_revisione_cessazione is null) and
             (dal = p_old_dal or dal is null and p_old_dal is null) and
             (al = p_old_al or al is null and p_old_al is null) and
             (dal = p_old_dal_pubb or dal_pubb is null and p_old_dal_pubb is null) and
             (al = p_old_al_pubb or al_pubb is null and p_old_al_pubb is null) and
             (al_prec = p_old_al_prec or al_prec is null and p_old_al_prec is null) and
             (revisione_cess_prec = p_old_revisione_cess_prec or
             revisione_cess_prec is null and p_old_revisione_cess_prec is null) and
             (utente_aggiornamento = p_old_utente_aggiornamento or
             utente_aggiornamento is null and p_old_utente_aggiornamento is null) and
             (data_aggiornamento = p_old_data_aggiornamento or
             data_aggiornamento is null and p_old_data_aggiornamento is null));
      d_row_found := sql%rowcount;
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on unita_organizzativa.upd');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   end; -- unita_organizzativa.upd
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_id_elemento   in unita_organizzative.id_elemento%type
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
      dbc.pre(not dbc.preon or existsid(p_id_elemento)
             ,'existsId on unita_organizzativa.upd_column');
      dbc.pre(not dbc.preon or p_column is not null
             ,'p_column is not null on unita_organizzativa.upd_column');
      dbc.pre(not dbc.preon or afc_ddl.hasattribute(s_table_name, p_column)
             ,'AFC_DDL.HasAttribute on unita_organizzativa.upd_column');
      dbc.pre(p_literal_value in (0, 1)
             ,'p_literal_value in ( 0, 1 ) on unita_organizzativa.upd_column; p_literal_value = ' ||
              p_literal_value);
      if p_literal_value = 1 then
         d_literal := '''';
      end if;
      d_statement := 'begin ' || '   update unita_organizzative' || '   set    ' ||
                     p_column || ' = ' || d_literal || p_value || d_literal ||
                     '   where  id_elemento = ''' || p_id_elemento || '''' || '   ;' ||
                     'end;';
      execute immediate d_statement;
   end; -- unita_organizzativa.upd_column
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_id_elemento in unita_organizzative.id_elemento%type
     ,p_column      in varchar2
     ,p_value       in date
   ) is
      /******************************************************************************
       NOME:        upd_column
       DESCRIZIONE: Aggiornamento del campo p_column col valore p_value.
       NOTE:        Richiama se stessa con il parametro date convertito in stringa.
      ******************************************************************************/
      d_data varchar2(19);
   begin
      d_data := to_char(p_value, 'dd/mm/yyyy hh24:mi:ss');
      upd_column(p_id_elemento
                ,p_column
                ,'to_date( ''' || d_data || ''', ''dd/mm/yyyy hh24:mi:ss'')'
                ,0);
   end; -- unita_organizzativa.upd_column
   procedure del
   (
      p_id_elemento               in unita_organizzative.id_elemento%type
     ,p_ottica                    in unita_organizzative.ottica%type default null
     ,p_revisione                 in unita_organizzative.revisione%type default null
     ,p_sequenza                  in unita_organizzative.sequenza%type default null
     ,p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type default null
     ,p_id_unita_padre            in unita_organizzative.id_unita_padre%type default null
     ,p_revisione_cessazione      in unita_organizzative.revisione_cessazione%type default null
     ,p_dal                       in unita_organizzative.dal%type default null
     ,p_al                        in unita_organizzative.al%type default null
     ,p_dal_pubb                  in unita_organizzative.dal_pubb%type default null
     ,p_al_pubb                   in unita_organizzative.al_pubb%type default null
     ,p_al_prec                   in unita_organizzative.al_prec%type default null
     ,p_revisione_cess_prec       in unita_organizzative.revisione_cess_prec%type default null
     ,p_utente_aggiornamento      in unita_organizzative.utente_aggiornamento%type default null
     ,p_data_aggiornamento        in unita_organizzative.data_aggiornamento%type default null
     ,p_check_old                 in integer default 0
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
               p_sequenza is not null or p_progr_unita_organizzativa is not null or
               p_id_unita_padre is not null or p_revisione_cessazione is not null or
               p_dal is not null or p_al is not null or
               p_utente_aggiornamento is not null or
               p_data_aggiornamento is not null) and p_check_old = 0)
             ,' <OLD values> is not null on unita_organizzativa.del');
      dbc.pre(not dbc.preon or existsid(p_id_elemento)
             ,'existsId on unita_organizzativa.upd');
      delete from unita_organizzative
       where id_elemento = p_id_elemento
         and (p_check_old = 0 or
             p_check_old = 1 and
             (ottica = p_ottica or ottica is null and p_ottica is null) and
             (revisione = p_revisione or revisione is null and p_revisione is null) and
             (sequenza = p_sequenza or sequenza is null and p_sequenza is null) and
             (progr_unita_organizzativa = p_progr_unita_organizzativa or
             progr_unita_organizzativa is null and p_progr_unita_organizzativa is null) and
             (id_unita_padre = p_id_unita_padre or
             id_unita_padre is null and p_id_unita_padre is null) and
             (revisione_cessazione = p_revisione_cessazione or
             revisione_cessazione is null and p_revisione_cessazione is null) and
             (dal = p_dal or dal is null and p_dal is null) and
             (al = p_al or al is null and p_al is null) and
             (dal_pubb = p_dal_pubb or dal_pubb is null and p_dal_pubb is null) and
             (al_pubb = p_al_pubb or al_pubb is null and p_al_pubb is null) and
             (utente_aggiornamento = p_utente_aggiornamento or
             utente_aggiornamento is null and p_utente_aggiornamento is null) and
             (data_aggiornamento = p_data_aggiornamento or
             data_aggiornamento is null and p_data_aggiornamento is null));
      d_row_found := sql%rowcount;
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on unita_organizzativa.del');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
      dbc.post(not dbc.poston or not existsid(p_id_elemento)
              ,'existsId on unita_organizzativa.del');
   end; -- unita_organizzativa.del
   --------------------------------------------------------------------------------
   function get_ottica(p_id_elemento in unita_organizzative.id_elemento%type)
      return unita_organizzative.ottica%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_ottica
       DESCRIZIONE: Attributo ottica di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     unita_organizzative.ottica%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result unita_organizzative.ottica%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_elemento)
             ,'existsId on unita_organizzativa.get_ottica');
      select ottica
        into d_result
        from unita_organizzative
       where id_elemento = p_id_elemento;
      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on unita_organizzativa.get_ottica');
      return d_result;
   end; -- unita_organizzativa.get_ottica
   --------------------------------------------------------------------------------
   function get_revisione(p_id_elemento in unita_organizzative.id_elemento%type)
      return unita_organizzative.revisione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_revisione
       DESCRIZIONE: Attributo revisione di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     unita_organizzative.revisione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result unita_organizzative.revisione%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_elemento)
             ,'existsId on unita_organizzativa.get_revisione');
      select revisione
        into d_result
        from unita_organizzative
       where id_elemento = p_id_elemento;
      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on unita_organizzativa.get_revisione');
      return d_result;
   end; -- unita_organizzativa.get_revisione
   --------------------------------------------------------------------------------
   function get_sequenza(p_id_elemento in unita_organizzative.id_elemento%type)
      return unita_organizzative.sequenza%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_sequenza
       DESCRIZIONE: Attributo sequenza di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     unita_organizzative.sequenza%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result unita_organizzative.sequenza%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_elemento)
             ,'existsId on unita_organizzativa.get_sequenza');
      select sequenza
        into d_result
        from unita_organizzative
       where id_elemento = p_id_elemento;
      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on unita_organizzativa.get_sequenza');
      return d_result;
   end; -- unita_organizzativa.get_sequenza
   --------------------------------------------------------------------------------
   function get_progr_unita(p_id_elemento in unita_organizzative.id_elemento%type)
      return unita_organizzative.progr_unita_organizzativa%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_progr_unita
       DESCRIZIONE: Attributo progr_unita_organizzativa di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     unita_organizzative.progr_unita_organizzativa%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result unita_organizzative.progr_unita_organizzativa%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_elemento)
             ,'existsId on unita_organizzativa.get_progr_unita_organizzativa');
      select progr_unita_organizzativa
        into d_result
        from unita_organizzative
       where id_elemento = p_id_elemento;
      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on unita_organizzativa.get_progr_unita_organizzativa');
      return d_result;
   end; -- unita_organizzativa.get_progr_unita
   --------------------------------------------------------------------------------
   function get_id_unita_padre(p_id_elemento in unita_organizzative.id_elemento%type)
      return unita_organizzative.id_unita_padre%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_id_unita_padre
       DESCRIZIONE: Attributo id_unita_padre di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     unita_organizzative.id_unita_padre%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result unita_organizzative.id_unita_padre%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_elemento)
             ,'existsId on unita_organizzativa.get_id_unita_padre');
      select id_unita_padre
        into d_result
        from unita_organizzative
       where id_elemento = p_id_elemento;
      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on unita_organizzativa.get_id_unita_padre');
      return d_result;
   end; -- unita_organizzativa.get_id_unita_padre
   --------------------------------------------------------------------------------
   function get_revisione_cessazione(p_id_elemento in unita_organizzative.id_elemento%type)
      return unita_organizzative.revisione_cessazione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_revisione_cessazione
       DESCRIZIONE: Attributo revisione_cessazione di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     unita_organizzative.revisione_cessazione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result unita_organizzative.revisione_cessazione%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_elemento)
             ,'existsId on unita_organizzativa.get_revisione_cessazione');
      select revisione_cessazione
        into d_result
        from unita_organizzative
       where id_elemento = p_id_elemento;
      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on unita_organizzativa.get_revisione_cessazione');
      return d_result;
   end; -- unita_organizzativa.get_revisione_cessazione
   --------------------------------------------------------------------------------
   function get_dal(p_id_elemento in unita_organizzative.id_elemento%type)
      return unita_organizzative.dal%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_dal
       DESCRIZIONE: Attributo dal di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     unita_organizzative.dal%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result unita_organizzative.dal%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_elemento)
             ,'existsId on unita_organizzativa.get_dal');
      select dal
        into d_result
        from unita_organizzative
       where id_elemento = p_id_elemento;
      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on unita_organizzativa.get_dal');
      return d_result;
   end; -- unita_organizzativa.get_dal
   --------------------------------------------------------------------------------
   function get_al(p_id_elemento in unita_organizzative.id_elemento%type)
      return unita_organizzative.al%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_al
       DESCRIZIONE: Attributo al di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     unita_organizzative.al%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result unita_organizzative.al%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_elemento)
             ,'existsId on unita_organizzativa.get_al');
      select al into d_result from unita_organizzative where id_elemento = p_id_elemento;
      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on unita_organizzativa.get_al');
      return d_result;
   end; -- unita_organizzativa.get_al
   --------------------------------------------------------------------------------
   function get_dal_pubb(p_id_elemento in unita_organizzative.id_elemento%type)
      return unita_organizzative.dal_pubb%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_dal_pubb
       DESCRIZIONE: Attributo dal_pubb di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     unita_organizzative.dal_pubb%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result unita_organizzative.dal_pubb%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_elemento)
             ,'existsId on unita_organizzativa.get_dal_pubb');
      select dal_pubb
        into d_result
        from unita_organizzative
       where id_elemento = p_id_elemento;
      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on unita_organizzativa.get_dal_pubb');
      return d_result;
   end; -- unita_organizzativa.get_dal_pubb
   --------------------------------------------------------------------------------
   function get_al_pubb(p_id_elemento in unita_organizzative.id_elemento%type)
      return unita_organizzative.al_pubb%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_al_pubb
       DESCRIZIONE: Attributo al_pubb di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     unita_organizzative.al_pubb%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result unita_organizzative.al_pubb%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_elemento)
             ,'existsId on unita_organizzativa.get_al_pubb');
      select al_pubb
        into d_result
        from unita_organizzative
       where id_elemento = p_id_elemento;
      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on unita_organizzativa.get_al_pubb');
      return d_result;
   end; -- unita_organizzativa.get_al_pubb
   --------------------------------------------------------------------------------
   function get_al_prec(p_id_elemento in unita_organizzative.id_elemento%type)
      return unita_organizzative.al_prec%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_al_prec
       DESCRIZIONE: Attributo al_prec di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     unita_organizzative.al_prec%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result unita_organizzative.al_prec%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_elemento)
             ,'existsId on unita_organizzativa.get_al_prec');
      select al_prec
        into d_result
        from unita_organizzative
       where id_elemento = p_id_elemento;
      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on unita_organizzativa.get_al_prec');
      return d_result;
   end; -- unita_organizzativa.get_al_prec
   --------------------------------------------------------------------------------
   function get_revisione_cess_prec(p_id_elemento in unita_organizzative.id_elemento%type)
      return unita_organizzative.revisione_cess_prec%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_revisione_cess_prec
       DESCRIZIONE: Attributo revisione_cess_prec di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     unita_organizzative.revisione_cess_prec%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result unita_organizzative.revisione_cess_prec%type;
   begin
      select revisione_cess_prec
        into d_result
        from unita_organizzative
       where id_elemento = p_id_elemento;
      return d_result;
   end; -- unita_organizzativa.get_revisione_cess_prec
   --------------------------------------------------------------------------------
   function get_utente_aggiornamento(p_id_elemento in unita_organizzative.id_elemento%type)
      return unita_organizzative.utente_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_utente_aggiornamento
       DESCRIZIONE: Attributo utente_aggiornamento di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     unita_organizzative.utente_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result unita_organizzative.utente_aggiornamento%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_elemento)
             ,'existsId on unita_organizzativa.get_utente_aggiornamento');
      select utente_aggiornamento
        into d_result
        from unita_organizzative
       where id_elemento = p_id_elemento;
      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on unita_organizzativa.get_utente_aggiornamento');
      return d_result;
   end; -- unita_organizzativa.get_utente_aggiornamento
   --------------------------------------------------------------------------------
   function get_data_aggiornamento(p_id_elemento in unita_organizzative.id_elemento%type)
      return unita_organizzative.data_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_data_aggiornamento
       DESCRIZIONE: Attributo data_aggiornamento di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     unita_organizzative.aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result unita_organizzative.data_aggiornamento%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_elemento)
             ,'existsId on unita_organizzativa.get_data_aggiornamento');
      select data_aggiornamento
        into d_result
        from unita_organizzative
       where id_elemento = p_id_elemento;
      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on unita_organizzativa.get_data_aggiornamento');
      return d_result;
   end; -- unita_organizzativa.get_data_aggiornamento
   --------------------------------------------------------------------------------
   function where_condition
   (
      p_id_elemento               in varchar2 default null
     ,p_ottica                    in varchar2 default null
     ,p_revisione                 in varchar2 default null
     ,p_sequenza                  in varchar2 default null
     ,p_progr_unita_organizzativa in varchar2 default null
     ,p_id_unita_padre            in varchar2 default null
     ,p_revisione_cessazione      in varchar2 default null
     ,p_dal                       in varchar2 default null
     ,p_al                        in varchar2 default null
     ,p_utente_aggiornamento      in varchar2 default null
     ,p_data_aggiornamento        in varchar2 default null
     ,p_other_condition           in varchar2 default null
     ,p_qbe                       in number default 0
   ) return afc.t_statement is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        where_condition
       DESCRIZIONE: Ritorna la where_condition per lo statement di select di get_rows e count_rows.
       PARAMETRI:   Chiavi e attributi della table
                    p_other_condition
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
                     afc.get_field_condition(' and ( id_elemento '
                                            ,p_id_elemento
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( ottica ', p_ottica, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( revisione '
                                            ,p_revisione
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( sequenza ', p_sequenza, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( progr_unita_organizzativa '
                                            ,p_progr_unita_organizzativa
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( id_unita_padre '
                                            ,p_id_unita_padre
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( revisione_cessazione '
                                            ,p_revisione_cessazione
                                            ,' )'
                                            ,p_qbe) ||
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
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( data_aggiornamento '
                                            ,p_data_aggiornamento
                                            ,' )'
                                            ,p_qbe
                                            ,afc.date_format) || ' ) ' ||
                     p_other_condition;
      return d_statement;
   end; --- unita_organizzativa.where_condition
   --------------------------------------------------------------------------------
   function get_rows
   (
      p_id_elemento               in varchar2 default null
     ,p_ottica                    in varchar2 default null
     ,p_revisione                 in varchar2 default null
     ,p_sequenza                  in varchar2 default null
     ,p_progr_unita_organizzativa in varchar2 default null
     ,p_id_unita_padre            in varchar2 default null
     ,p_revisione_cessazione      in varchar2 default null
     ,p_dal                       in varchar2 default null
     ,p_al                        in varchar2 default null
     ,p_dal_pubb                  in varchar2 default null
     ,p_al_pubb                   in varchar2 default null
     ,p_al_prec                   in varchar2 default null
     ,p_revisione_cess_prec       in varchar2 default null
     ,p_utente_aggiornamento      in varchar2 default null
     ,p_data_aggiornamento        in varchar2 default null
     ,p_other_condition           in varchar2 default null
     ,p_qbe                       in number default 0
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
      d_statement := ' select * from unita_organizzative ' ||
                     where_condition(p_id_elemento
                                    ,p_ottica
                                    ,p_revisione
                                    ,p_sequenza
                                    ,p_progr_unita_organizzativa
                                    ,p_id_unita_padre
                                    ,p_revisione_cessazione
                                    ,p_dal
                                    ,p_al
                                    ,p_utente_aggiornamento
                                    ,p_data_aggiornamento
                                    ,p_other_condition
                                    ,p_qbe);
      open d_ref_cursor for d_statement;
      return d_ref_cursor;
   end; -- unita_organizzativa.get_rows
   --------------------------------------------------------------------------------
   function count_rows
   (
      p_id_elemento               in varchar2 default null
     ,p_ottica                    in varchar2 default null
     ,p_revisione                 in varchar2 default null
     ,p_sequenza                  in varchar2 default null
     ,p_progr_unita_organizzativa in varchar2 default null
     ,p_id_unita_padre            in varchar2 default null
     ,p_revisione_cessazione      in varchar2 default null
     ,p_dal                       in varchar2 default null
     ,p_al                        in varchar2 default null
     ,p_dal_pubb                  in varchar2 default null
     ,p_al_pubb                   in varchar2 default null
     ,p_al_prec                   in varchar2 default null
     ,p_revisione_cess_prec       in varchar2 default null
     ,p_utente_aggiornamento      in varchar2 default null
     ,p_data_aggiornamento        in varchar2 default null
     ,p_other_condition           in varchar2 default null
     ,p_qbe                       in number default 0
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
      d_statement := ' select count( * ) from unita_organizzative ' ||
                     where_condition(p_id_elemento
                                    ,p_ottica
                                    ,p_revisione
                                    ,p_sequenza
                                    ,p_progr_unita_organizzativa
                                    ,p_id_unita_padre
                                    ,p_revisione_cessazione
                                    ,p_dal
                                    ,p_al
                                    ,p_utente_aggiornamento
                                    ,p_data_aggiornamento
                                    ,p_other_condition
                                    ,p_qbe);
      d_result    := afc.sql_execute(d_statement);
      return d_result;
   end; -- unita_organizzativa.count_rows
   --------------------------------------------------------------------------------
   function get_id_elemento return unita_organizzative.id_elemento%type is
      /******************************************************************************
       NOME:        get_id_elemento
       DESCRIZIONE: Restituisce il valore della nuova sequence per l'inserimento
       PARAMETRI:
       RITORNA:     unita_organizzative.id_elemento%type.
       NOTE:
      ******************************************************************************/
      d_result unita_organizzative.id_elemento%type;
   begin
      select unita_organizzative_sq.nextval into d_result from dual;
      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on unita_organizzativa.get_id_elemento');
      return d_result;
   end; -- unita_organizzativa.get_id_elemento
   --------------------------------------------------------------------------------
   function get_progr_unita_padre(p_id_elemento in unita_organizzative.id_elemento%type)
      return unita_organizzative.progr_unita_organizzativa%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_progr_unita_padre
       DESCRIZIONE: Attributo progr_unita_organizzativa di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     unita_organizzative.progr_unita_organizzativa%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result unita_organizzative.progr_unita_organizzativa%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_elemento)
             ,'existsId on unita_organizzativa.get_progr_unita_organizzativa');
      select progr_unita_organizzativa
        into d_result
        from unita_organizzative
       where id_elemento = (select id_unita_padre
                              from unita_organizzative
                             where id_elemento = p_id_elemento);
      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on unita_organizzativa.get_progr_unita_padre');
      return d_result;
   end; -- unita_organizzativa.get_progr_unita_padre
   --------------------------------------------------------------------------------
   function get_id_progr_unita
   (
      p_progr_unita in unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica      in unita_organizzative.ottica%type
     ,p_data        in unita_organizzative.dal%type
   ) return unita_organizzative.id_elemento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_id_progr_unita
       DESCRIZIONE: Restituisce l'identificativo del record su cui è presente
                    il progr. unita' indicato
       PARAMETRI:   Attributi chiave.
       RITORNA:     unita_organizzative.id_elemento%type.
       NOTE:        --
      ******************************************************************************/
      d_result    unita_organizzative.progr_unita_organizzativa%type;
      d_revisione revisioni_struttura.revisione%type;
   begin
      d_revisione := revisione_struttura.get_revisione_mod(p_ottica);
      begin
         select id_elemento
           into d_result
           from unita_organizzative
          where ottica = p_ottica
            and progr_unita_organizzativa = p_progr_unita
            and revisione != d_revisione
            and p_data between dal and
                nvl(decode(revisione_cessazione, d_revisione, to_date(null), al)
                   ,to_date('3333333', 'j'));
      exception
         when no_data_found then
            d_result := to_number(null);
      end;
      return d_result;
   end; -- unita_organizzativa.get_id_progr_unita
   --------------------------------------------------------------------------------
   function get_nuova_sequenza
   (
      p_ottica         unita_organizzative.ottica%type
     ,p_id_unita_padre unita_organizzative.id_unita_padre%type
     ,p_data           unita_organizzative.dal%type
   ) return unita_organizzative.sequenza%type is
      /******************************************************************************
       NOME:        get_nuova_sequenza
       DESCRIZIONE: Determina la sequenza di inserimento di un nuovo legame di struttura
       PARAMETRI:   Ottica
                    Id. unita' padre (identificativo della U.O. padre di destinazione)
                    Data controllo
       RITORNA:     unita_organizzative.sequenza%type
      ******************************************************************************/
      d_seq_iniz unita_organizzative.sequenza%type;
      d_result   unita_organizzative.sequenza%type;
   begin
      --
      -- Si seleziona la massima sequenza utilizzata per l'unità padre
      begin
         select nvl(max(sequenza), 0)
           into d_seq_iniz
           from unita_organizzative
          where ottica = p_ottica
            and id_unita_padre = p_id_unita_padre
            and p_data between nvl(dal, to_date(2222222, 'j')) and
                nvl(al, to_date(3333333, 'j'));
      end;
      --
      d_result := d_seq_iniz + 100;
      --
      return d_result;
   end; -- unita_organizzativa.get_nuova_sequenza
   --------------------------------------------------------------------------------
   function conta_righe
   (
      p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_data                      in unita_organizzative.dal%type
   ) return number is
      /******************************************************************************
       NOME:        conta_righe
       DESCRIZIONE: Conta le righe contenenti l'unita' indicata ancora valide alla data
       PARAMETRI:   Ottica
                    Progr. unita' organizzativa
                    Data controllo
       RITORNA:     Number
      ******************************************************************************/
      d_result number;
   begin
      select count(*)
        into d_result
        from unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and nvl(al, to_date(3333333, 'j')) > p_data;
      return d_result;
   end; -- unita_organizzativa.conta_righe
   --------------------------------------------------------------------------------
   function get_ultimo_periodo
   (
      p_ottica                    in unita_organizzative.ottica%type
     ,p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_rowid                     in rowid
   ) return afc_periodo.t_periodo is
      /******************************************************************************
       NOME:        get_ultimo_periodo
       DESCRIZIONE: Restituisce le date dell'ultimo periodo dell'unita' organizzativa
       PARAMETRI:   Ottica
                    Progr. unita' organizzativa
                    Rowid
       RITORNA:     AFC_periodo.t_periodo
      ******************************************************************************/
      d_result afc_periodo.t_periodo;
   begin
      begin
         select u1.dal
               ,u1.al
           into d_result.dal
               ,d_result.al
           from unita_organizzative u1
          where u1.ottica = p_ottica
            and u1.progr_unita_organizzativa = p_progr_unita_organizzativa
            and u1.rowid != p_rowid
            and u1.dal =
                (select max(u2.dal)
                   from unita_organizzative u2
                  where u2.ottica = p_ottica
                    and u2.progr_unita_organizzativa = p_progr_unita_organizzativa
                    and u2.rowid != p_rowid);
      exception
         when others then
            d_result.dal := to_date(null);
            d_result.al  := to_date(null);
      end;
      --
      return d_result;
      --
   end; -- unita_organizzativa.get_ultimo_periodo
   --------------------------------------------------------------------------------
   function is_ultimo_periodo
   (
      p_ottica                    in unita_organizzative.ottica%type
     ,p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in unita_organizzative.dal%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_ultimo_periodo
       DESCRIZIONE: Controlla che il periodo passato sia l'ultimo per l'unita'
                    organizzativa indicata
       PARAMETRI:   Ottica
                    Progr. unita' organizzativa
                    Dal
                    Al
       RITORNA:     AFC_ERROR
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
      begin
         select afc_error.ok
           into d_result
           from dual
          where not exists (select 'x'
                   from unita_organizzative
                  where ottica = p_ottica
                    and progr_unita_organizzativa = p_progr_unita_organizzativa
                    and dal > p_dal);
      exception
         when others then
            d_result := 0;
      end;
      --
      return d_result;
      --
   end; -- unita_organizzativa.is_ultimo_periodo
   --------------------------------------------------------------------------------
   function esiste_unita
   (
      p_ottica                    in unita_organizzative.ottica%type
     ,p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_data                      in unita_organizzative.dal%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        esiste_unita
       DESCRIZIONE: Verifica che l'unita' organizzativa che si vuole inserire o
                    ripristinare non sia gia' presente nella struttura
       PARAMETRI:   Ottica
                    Progr. unita' organizzativa
                    Data controllo
       RITORNA:     AFC_ERROR
      ******************************************************************************/
      d_result       afc_error.t_error_number;
      d_conta_record number;
   begin
      select count(*)
        into d_conta_record
        from unita_organizzative
       where ottica = p_ottica
         and progr_unita_organizzativa = p_progr_unita_organizzativa
         and revisione_cessazione is null
         and p_data between nvl(dal, trunc(sysdate)) and
             nvl(al, to_date('31/12/2200', 'dd/mm/yyyy'));
      if d_conta_record > 0 then
         d_result := s_unita_presente_number;
      else
         d_result := afc_error.ok;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on Unita_organizzativa.esiste_unita');
      return d_result;
   end; -- unita_organizzativa.esiste_unita
   --------------------------------------------------------------------------------
   function esiste_unita_figlia
   (
      p_ottica                    in unita_organizzative.ottica%type
     ,p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_id_unita_padre            in unita_organizzative.id_unita_padre%type
     ,p_revisione                 in unita_organizzative.revisione%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        esiste_unita_figlia
       DESCRIZIONE: Verifica che l'unita' organizzativa che si vuole inserire o
                    ripristinare non sia gia' presente nella struttura con lo
                    stesso padre
       PARAMETRI:   Ottica
                    Progr. unita' organizzativa
                    Id. unita' padre
       RITORNA:     AFC_ERROR
      ******************************************************************************/
      d_result       afc_error.t_error_number;
      d_conta_record number;
      d_data         date;
   begin
      select count(*)
        into d_conta_record
        from unita_organizzative
       where ottica = p_ottica
         and progr_unita_organizzativa = p_progr_unita_organizzativa
         and id_unita_padre = p_id_unita_padre
         and revisione_cessazione = p_revisione;
      if d_conta_record > 0 then
         d_result := s_unita_presente_number;
      else
         d_result := s_unita_presente_number; --per vedere se serve a qualcosa
         -- d_result := afc_error.ok;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on Unita_organizzativa.esiste_unita');
      return d_result;
   end; -- unita_organizzativa.esiste_unita_figlia
   --------------------------------------------------------------------------------
   function esistono_componenti
   (
      p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica                    in unita_organizzative.ottica%type
     ,p_data                      in unita_organizzative.dal%type
     ,p_revisione                 in unita_organizzative.revisione%type default null
     ,p_sposta_componenti         in number default 0
   ) return varchar2
   /******************************************************************************
       NOME:        esistono_componenti_ok
       DESCRIZIONE: Verifica l'esistenza di componenti associati all'unita'
                    organizzativa
       PARAMETRI:   p_ottica
                    p_progr_unita_organizzativa
                    p_dal
                    p_revisione                codice della revisione in modifica:
                                               se non indicato, si conteggiano tutti
                                               i componente, se indicato si escludono
                                               i componenti inseriti con la revisione
                                               indicata
                    p_sposta_componenti        1 indica che la function viene utilizzata
                                               nella form Spostamento Componenti e che
                                               viene effettuato un controllo con dal >= p_data
                                               0 indica che viene utilizzata in altre form
                                               dove il controllo necessario è p_data between dal, al
       NOTE:        --
      ******************************************************************************/
    is
      d_contatore number;
      d_result    varchar2(2);
   begin
      --#455
      if p_sposta_componenti = 0 then
         select count(*)
           into d_contatore
           from componenti
          where ottica = p_ottica
            and progr_unita_organizzativa = p_progr_unita_organizzativa
            and nvl(dal, to_date(2222222, 'j')) <= nvl(al, to_date(3333333, 'j'))
            and (p_data between nvl(dal, p_data) and nvl(al, to_date(3333333, 'j')) or
                (p_data <= nvl(al, to_date(3333333, 'J')) and p_revisione is not null));
      else
         if p_revisione is null then
            select count(*)
              into d_contatore
              from componenti
             where ottica = p_ottica
               and nvl(dal, to_date(2222222, 'j')) <= nvl(al, to_date(3333333, 'j'))
               and progr_unita_organizzativa = p_progr_unita_organizzativa
               and nvl(al, to_date(3333333, 'j')) >= p_data;
         else
            select count(*)
              into d_contatore
              from componenti
             where ottica = p_ottica
               and progr_unita_organizzativa = p_progr_unita_organizzativa
               and nvl(revisione_assegnazione, -2) != p_revisione
               and nvl(dal, to_date(2222222, 'j')) <= nvl(al, to_date(3333333, 'j'))
               and (p_data between dal and
                   nvl(decode(revisione_cessazione, p_revisione, to_date(null), al)
                       ,to_date(3333333, 'j')) or
                   p_data <= nvl(al, to_date(3333333, 'J')));
         end if;
      end if;
      /*      if p_revisione is null then
         if p_sposta_componenti = 0 then
            d_contatore := componente.count_rows(p_progr_unita_organizzativa => '=' ||
                                                                                p_progr_unita_organizzativa
                                                 --                                      , p_ottica => '='''||p_ottica||''''
                                                ,p_other_condition => ' and to_date(''' ||
                                                                      to_char(p_data
                                                                             ,'dd/mm/yyyy') ||
                                                                      ''', ''dd/mm/yyyy'')' ||
                                                                      ' between nvl(dal,to_date(''2222222'',''j'')) ' ||
                                                                      ' and nvl(al,to_date(''3333333'',''j''))'
                                                ,p_qbe             => 1);
         elsif p_sposta_componenti = 1 then
            d_contatore := componente.count_rows(p_progr_unita_organizzativa => '=' ||
                                                                                p_progr_unita_organizzativa
                                                 --                                      , p_ottica => '='''||p_ottica||''''
                                                ,p_other_condition => ' and nvl(al,to_date(''3333333'',''j'')) >= ' ||
                                                                      ' to_date(''' ||
                                                                      to_char(p_data
                                                                             ,'dd/mm/yyyy') ||
                                                                      ''', ''dd/mm/yyyy'')'
                                                 --|| ' and attributo_componente.get_assegnazione_valida(id_componente, dal, ottica) = 1 '
                                                ,p_qbe => 1);
         end if;
      else
         if p_sposta_componenti = 0 then
            d_contatore := componente.count_rows(p_progr_unita_organizzativa => '=' ||
                                                                                p_progr_unita_organizzativa
                                                 --                                        , p_ottica => '='''||p_ottica||''''
                                                ,p_other_condition => ' and to_date(''' ||
                                                                      to_char(p_data
                                                                             ,'dd/mm/yyyy') ||
                                                                      ''', ''dd/mm/yyyy'')' ||
                                                                      ' between dal ' ||
                                                                      ' and nvl(al,to_date(''3333333'',''j''))' ||
                                                                      ' and nvl(revisione_assegnazione, -2) != ' ||
                                                                      p_revisione
                                                ,p_qbe             => 1);
         elsif p_sposta_componenti = 1 then
            d_contatore := componente.count_rows(p_progr_unita_organizzativa => '=' ||
                                                                                p_progr_unita_organizzativa
                                                 --                                      , p_ottica => '='''||p_ottica||''''
                                                ,p_other_condition => ' and nvl(al,to_date(''3333333'',''j'')) >= ' ||
                                                                      ' to_date(''' ||
                                                                      to_char(p_data
                                                                             ,'dd/mm/yyyy') ||
                                                                      ''', ''dd/mm/yyyy'')'
                                                                     --|| ' and attributo_componente.get_assegnazione_valida(id_componente, dal, ottica) = 1 '
                                                                      ||
                                                                      ' and nvl(revisione_assegnazione, -2) != ' ||
                                                                      p_revisione
                                                ,p_qbe             => 1);
         end if;
      end if;*/
      if d_contatore = 0 then
         d_result := 'NO';
      else
         d_result := 'SI';
      end if;
      return d_result;
   end; -- unita_organizzativa.esistono_componenti
   --------------------------------------------------------------------------------
   -- Controlla che non esistano legami istituiti o cessati con la
   -- revisione indicata aventi data inizio o fine validità non congruente
   -- con la data della revisione
   function is_legami_revisione_ok
   (
      p_ottica         in unita_organizzative.ottica%type
     ,p_revisione      in unita_organizzative.revisione%type
     ,p_data           in unita_organizzative.dal%type
     ,p_tipo_controllo in number default 0
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_legami_revisione_ok
       DESCRIZIONE: Controlla che non esistano legami istituiti o cessati con la
                    revisione indicata aventi data inizio o fine validità non congruente
                    con la data della revisione
       PARAMETRI:   Ottica
                    Revisione
                    Data revisione
                    Tipo controllo: se = 0 si controllano i legami istituiti, se = 1
                                    si controllano i legami cessati
       RITORNA:     AFC_ERROR
      ******************************************************************************/
      d_result       afc_error.t_error_number;
      d_conta_record number;
   begin
      select count(*)
        into d_conta_record
        from unita_organizzative
       where ottica = p_ottica
         and ((p_tipo_controllo = 0 and revisione = p_revisione and
             nvl(dal, p_data) < p_data) or
             (p_tipo_controllo = 1 and revisione_cessazione = p_revisione and
             nvl(al, p_data - 1) != p_data - 1));
      if d_conta_record > 0 then
         if p_tipo_controllo = 0 then
            d_result := s_legami_istituiti_number;
         else
            d_result := s_legami_cessati_number;
         end if;
      else
         d_result := afc_error.ok;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on Unita_organizzativa.is_legami_revisione_ok');
      return d_result;
   end; -- unita_organizzativa.is_legami_revisione_ok
   --------------------------------------------------------------------------------
   -- Procedure di aggiornamento delle date di inizio e fine validità
   -- al momento dell'attivazione della revisione
   procedure update_unor
   (
      p_ottica    in unita_organizzative.ottica%type
     ,p_revisione in unita_organizzative.revisione%type
     ,p_data      in unita_organizzative.dal%type
   ) is
      /******************************************************************************
       NOME:        update_UNOR
       DESCRIZIONE: Aggiornamento delle date di inizio e fine validita'
                    al momento dell'attivazione della revisione
       PARAMETRI:   Ottica
                    Revisione
                    Data revisione
      ******************************************************************************/
      d_fine_validita_revisione date;
      d_id_elemento_new         unita_organizzative.id_elemento%type;
      d_data_pubb               date := nvl(revisione_struttura.get_data_pubblicazione(p_ottica
                                                                                      ,p_revisione)
                                           ,p_data);
      d_al_padre                unita_organizzative.al%type;
      d_rev_cess_padre          unita_organizzative.revisione_cessazione%type;
      d_al_pubb_padre           unita_organizzative.al_pubb%type;
   begin
      set_tipo_revisione(p_ottica, p_revisione);
      if s_tipo_revisione = 'N' then
         -- revisione non retroattiva
         update unita_organizzative
            set dal      = nvl(dal, p_data)
               ,dal_pubb = d_data_pubb
          where ottica = p_ottica
            and revisione = p_revisione
         /*and dal is null*/
         ;
         update unita_organizzative
            set al      = nvl(al, p_data - 1)
               ,al_pubb = d_data_pubb - 1
          where ottica = p_ottica
            and revisione_cessazione = p_revisione
         /*and al is null*/
         ;
      elsif s_tipo_revisione = 'P' then
         -- revisione con profondita' storica fino alla revisione immediatamente successiva
         select min(dal) - 1
           into d_fine_validita_revisione
           from revisioni_struttura
          where ottica = p_ottica
            and stato = 'A'
            and dal > p_data;
         /*modifica la data di termine delle registrazioni relative a UO modificate
         con termine successivo alla data di decorrenza della nuova revisione*/
         update unita_organizzative u
            set al_prec = al
               ,al      = p_data - 1
          where ottica = p_ottica
            and revisione <> p_revisione
            and nvl(u.al, to_date(3333333, 'j')) >= p_data
            and u.dal <= p_data
            and exists
          (select 'x'
                   from unita_organizzative
                  where progr_unita_organizzativa = u.progr_unita_organizzativa
                    and revisione = p_revisione
                    and ottica = p_ottica
                    and dal is null);
         /*modifica la data di decorrenza delle registrazioni relative a UO modificate
         con termine successivo alla data di decorrenza della nuova revisione*/
         update unita_organizzative u
            set dal = d_fine_validita_revisione + 1
          where ottica = p_ottica
            and revisione <> p_revisione
            and nvl(u.al, to_date(3333333, 'j')) >= d_fine_validita_revisione + 1
            and u.dal > p_data
            and exists
          (select 'x'
                   from unita_organizzative
                  where progr_unita_organizzativa = u.progr_unita_organizzativa
                    and revisione = p_revisione
                    and ottica = p_ottica
                    and dal is null);
         update unita_organizzative
            set dal      = p_data
               ,al       = d_fine_validita_revisione
               ,dal_pubb = d_data_pubb
               ,al_pubb  = d_fine_validita_revisione
          where ottica = p_ottica
            and revisione = p_revisione
            and dal is null;
         update unita_organizzative
            set al      = d_fine_validita_revisione
               ,al_pubb = d_fine_validita_revisione
          where ottica = p_ottica
            and revisione_cessazione = p_revisione
            and al is null;
      elsif s_tipo_revisione = 'R' then
         -- revisione con profondita' storica fino alla situazione Corrente
         /*elimina logicamente le registrazioni relative a UO modificate
         che hanno decorrenza successiva alla data di decorrenza della nuova revisione*/
         for unor in (select *
                        from unita_organizzative u
                       where ottica = p_ottica
                         and revisione <> p_revisione
                         and dal >= p_data
                         and dal <= nvl(al, to_date(3333333, 'j')) --#771
                         and exists
                       (select 'x'
                                from unita_organizzative
                               where ottica = p_ottica
                                 and progr_unita_organizzativa =
                                     u.progr_unita_organizzativa
                                 and ((revisione = p_revisione and dal is null) or
                                     (revisione_cessazione = p_revisione and al is null))))
         loop
            update unita_organizzative u
               set al                   = dal - 1 --(al minore del dal)
                  ,al_pubb              = least((d_data_pubb - 1)
                                               ,nvl(al_pubb, to_date(3333333, 'j')))
                  ,revisione_cessazione = p_revisione
             where id_elemento = unor.id_elemento;
         end loop;
         /*modifica la data di termine delle registrazioni relative a UO modificate
         con termine successivo alla data di decorrenza della nuova revisione*/
         for unor in (select *
                        from unita_organizzative u
                       where ottica = p_ottica
                         and revisione <> p_revisione
                         and nvl(u.al, to_date(3333333, 'j')) >= p_data
                         and u.dal <= nvl(u.al, to_date(3333333, 'j')) --#489
                         and exists (select 'x'
                                from unita_organizzative
                               where progr_unita_organizzativa =
                                     u.progr_unita_organizzativa
                                 and revisione = p_revisione
                                 and ottica = p_ottica
                                 and dal is null))
         loop
            update unita_organizzative u
               set al_prec              = '' --al: dopo l'attivazione l'al_prec non può essere piu' utilizzato
                  ,al                   = p_data - 1
                  ,al_pubb              = least((d_data_pubb - 1)
                                               ,nvl(al_pubb, to_date(3333333, 'j')))
                  ,revisione_cessazione = p_revisione
             where id_elemento = unor.id_elemento;
         end loop;
         for unor in (select id_elemento
                            ,progr_unita_organizzativa
                            ,revisione_cessazione
                            ,al
                            ,id_unita_padre
                        from unita_organizzative unor
                       where ottica = p_ottica
                         and revisione = p_revisione) --#448
         loop
            if unor.id_unita_padre is not null then
               begin
                  select al
                        ,revisione_cessazione
                        ,al_pubb
                    into d_al_padre
                        ,d_rev_cess_padre
                        ,d_al_pubb_padre
                    from unita_organizzative u
                   where progr_unita_organizzativa = unor.id_unita_padre
                     and ottica = p_ottica
                     and dal <= nvl(al, to_date(3333333, 'j')) --#771
                     and nvl(dal, to_date(2222222, 'j')) =
                         (select max(nvl(dal, to_date(2222222, 'j')))
                            from unita_organizzative
                           where progr_unita_organizzativa = u.progr_unita_organizzativa
                             and ottica = p_ottica);
               exception
                  when no_data_found then
                     null;
               end;
               /* Aggiorna la revisione di cessazione dei componenti assegnati alle UO di nuova istituzione
                  collegate a UO padri per le quali esiste già una revisione di cessazione definita
               */
               update componenti c
                  set revisione_cessazione = d_rev_cess_padre
                     ,al_pubb              = d_al_pubb_padre
                     ,al                   = d_al_padre
                where ottica = p_ottica
                  and progr_unita_organizzativa = unor.progr_unita_organizzativa
                  and al is null;
            end if; --#448

            update unita_organizzative
               set dal                  = nvl(dal, p_data)
                  ,dal_pubb             = d_data_pubb
                  ,al_pubb              = d_al_pubb_padre
                  ,al                   = d_al_padre
                  ,revisione_cessazione = d_rev_cess_padre
             where id_elemento = unor.id_elemento;
         end loop;
         for unor in (select id_elemento
                            ,revisione_cessazione
                            ,al
                        from unita_organizzative
                       where ottica = p_ottica
                         and revisione_cessazione = p_revisione)
         loop
            update unita_organizzative
               set al      = nvl(al, p_data - 1)
                  ,al_pubb = least((d_data_pubb - 1), nvl(al_pubb, to_date(3333333, 'j'))) --#703
             where id_elemento = unor.id_elemento
            /*and dal is null*/
            ;
         end loop;
      end if;
   end; -- unita_organizzativa.update_UNOR
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
   end; -- unita_organizzativa.set_tipo_revisione
   --------------------------------------------------------------------------------
   -- Controlla che il nuovo periodo di validita' di un legame sia
   -- congruente con i periodi gia' registrati
   function is_nuovo_periodo_ok
   (
      p_id_elemento unita_organizzative.id_elemento%type
     ,p_dal         unita_organizzative.dal%type
     ,p_al          unita_organizzative.al%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_nuovo_periodo_ok
       DESCRIZIONE: Controlla che il nuovo periodo di validita' di un legame sia
                    congruente con i periodi gia' registrati
       PARAMETRI:   Id elemento
                    Dal
                    Al
       RITORNA:     AFC_ERROR
      ******************************************************************************/
      d_ottica      unita_organizzative.ottica%type;
      d_progr_unita unita_organizzative.progr_unita_organizzativa%type;
      d_old_dal     unita_organizzative.dal%type;
      d_old_al      unita_organizzative.al%type;
      d_periodo     afc_periodo.t_periodo;
      d_result      afc_error.t_error_number := afc_error.ok;
   begin
      --
      -- Si controlla la sequenza di data inizio e data fine
      --
      if nvl(p_dal, to_date('1111111', 'j')) < nvl(p_al, to_date('3333333', 'j')) then
         d_result := afc_error.ok;
      else
         d_result := s_date_non_congruenti_number;
      end if;
      --
      -- Si selezionano i dati originali del record da modificare
      --
      if d_result = afc_error.ok then
         begin
            select unita_organizzativa.get_ottica(p_id_elemento)
                  ,unita_organizzativa.get_progr_unita(p_id_elemento)
                  ,unita_organizzativa.get_dal(p_id_elemento)
                  ,unita_organizzativa.get_al(p_id_elemento)
              into d_ottica
                  ,d_progr_unita
                  ,d_old_dal
                  ,d_old_al
              from dual;
         exception
            when others then
               d_result := s_errore_lettura_unor_number;
         end;
         --
         -- Se la data di fine validita e' stata annullata, occorre verificare che non
         -- esistano legami per la stessa unita organizzativa con periodo di validita'
         -- successivo
         --
         -- Se la nuova data di fine validita e' superiore a quella indicata
         -- precedentemente sul legame, occorre verificare che la nuova data sia
         -- compresa nel periodo immediatamente successivo a quello modificato
         --
         if (p_al is null and d_old_al is not null) or
            (p_al > d_old_al and d_old_al is not null) then
            d_periodo := afc_periodo.get_seguente(p_tabella            => 'UNITA_ORGANIZZATIVE'
                                                 ,p_nome_dal           => 'DAL'
                                                 ,p_nome_al            => 'AL'
                                                 ,p_dal                => d_old_dal
                                                 ,p_al                 => d_old_al
                                                 ,p_campi_controllare  => '#OTTICA#PROGR_UNITA_ORGANIZZATIVA'
                                                 ,p_valori_controllare => '#' || d_ottica || '#' ||
                                                                          d_progr_unita || '#');
            if p_al is null and d_old_al is not null and d_periodo.dal is not null then
               d_result := s_esiste_periodo_succ_number;
            else
               if p_al > d_old_al and
                  p_al not between nvl(d_periodo.dal, to_date('2222222', 'j')) and
                  nvl(d_periodo.al, to_date('3333333', 'j')) then
                  d_result := s_incongr_periodo_succ_number;
               end if;
            end if;
         end if;
      end if;
      --
      -- Se la data di inizio validita nuova e' inferiore a quella indicata
      -- precedentemente sul legame, occorre verificare che la nuova data sia
      -- compresa nel periodo immediatamente precedente a quello modificato
      --
      if d_result = afc_error.ok then
         if p_dal < d_old_dal then
            d_periodo := afc_periodo.get_precedente(p_tabella            => 'UNITA_ORGANIZZATIVE'
                                                   ,p_nome_dal           => 'DAL'
                                                   ,p_nome_al            => 'AL'
                                                   ,p_dal                => d_old_dal
                                                   ,p_al                 => d_old_al
                                                   ,p_campi_controllare  => '#OTTICA#PROGR_UNITA_ORGANIZZATIVA'
                                                   ,p_valori_controllare => '#' ||
                                                                            d_ottica || '#' ||
                                                                            d_progr_unita || '#');
            if d_periodo.dal is not null and d_periodo.al is not null then
               if p_dal < d_periodo.dal or p_dal > d_periodo.al then
                  d_result := s_incongr_periodo_prec_number;
               end if;
            end if;
         end if;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on unita_organizzativa.is_nuovo_periodo_ok');
      --
      return d_result;
      --
   end; -- unita_organizzativa.is_nuovo_periodo_ok
   --------------------------------------------------------------------------------
   function is_dal_al_ok
   (
      p_dal in unita_organizzative.dal%type
     ,p_al  in unita_organizzative.al%type
   ) return afc_error.t_error_number
   /******************************************************************************
       NOME:        is_dal_al_ok
       DESCRIZIONE: Controllo di congruenza tra data inizio e fine validità
       PARAMETRI:   p_dal
                    p_al
       NOTE:        --
      ******************************************************************************/
    is
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
   end; -- unita_organizzativa.is_dal_al_ok
   --------------------------------------------------------------------------------
   function is_revisioni_ok
   (
      p_revisione            in unita_organizzative.revisione%type
     ,p_revisione_cessazione in unita_organizzative.revisione_cessazione%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_revisioni_ok
       DESCRIZIONE: Controlla che le revisioni siano congruenti
       PARAMETRI:   p_revisione
                    p_revisione_cessazione
       RITORNA:     Afc_error.t_error_number
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
      if (p_revisione is null) or (p_revisione_cessazione is null) or
         (p_revisione is not null and p_revisione_cessazione is not null and
         p_revisione < p_revisione_cessazione) then
         d_result := afc_error.ok;
      else
         d_result := s_revisioni_errate_num;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on unita_organizzativa.is_revisioni_ok');
      return d_result;
   end; -- unita_organizzativa.is_revisioni_ok
   --------------------------------------------------------------------------------
   function is_di_ok
   (
      p_dal                  in unita_organizzative.dal%type
     ,p_al                   in unita_organizzative.al%type
     ,p_revisione            in unita_organizzative.revisione%type default null
     ,p_revisione_cessazione in unita_organizzative.revisione_cessazione%type default null
   ) return afc_error.t_error_number is
      d_result afc_error.t_error_number := afc_error.ok;
   begin
      -- is_dal_al_ok
      d_result := is_dal_al_ok(p_dal, p_al);
      if d_result = afc_error.ok then
         d_result := is_revisioni_ok(p_revisione, p_revisione_cessazione);
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on unita_organizzativa.is_DI_ok');
      return d_result;
   end; -- unita_organizzativa.is_DI_ok
   --------------------------------------------------------------------------------
   procedure chk_di
   (
      p_dal                  in unita_organizzative.dal%type
     ,p_al                   in unita_organizzative.al%type
     ,p_ottica               in unita_organizzative.ottica%type
     ,p_revisione            in unita_organizzative.revisione%type default null
     ,p_revisione_cessazione in unita_organizzative.revisione_cessazione%type default null
   ) is
      /******************************************************************************
       NOME:        chk_DI.
       DESCRIZIONE: controllo integrita dati:
                    - dal < al
                    - se le revisioni sono entrambe non nulle deve essere revisione < revisione_cessazione
       RITORNA:     -
      ******************************************************************************/
      d_result              afc_error.t_error_number;
      d_tipo_revisione_ass  revisioni_struttura.tipo_revisione%type;
      d_tipo_revisione_cess revisioni_struttura.tipo_revisione%type;
   begin
      if p_revisione is not null then
         d_tipo_revisione_ass := revisione_struttura.get_tipo_revisione(p_ottica
                                                                       ,p_revisione);
      end if;
      if p_revisione_cessazione is not null then
         d_tipo_revisione_cess := revisione_struttura.get_tipo_revisione(p_ottica
                                                                        ,p_revisione_cessazione);
      end if;
      if ((p_revisione is not null and nvl(d_tipo_revisione_ass, 'N') = 'N') or
         p_revisione is null) and
         ((p_revisione_cessazione is not null and nvl(d_tipo_revisione_cess, 'N') = 'N') or
         p_revisione_cessazione is null) then
         d_result := is_di_ok(p_dal, p_al, p_revisione, p_revisione_cessazione);
         dbc.assertion(not dbc.assertionon or d_result = afc_error.ok or d_result < 0
                      ,'d_result = AFC_Error.ok or d_result < 0 on unita_organizzativa.chk_DI');
      end if;
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, error_message(d_result));
      end if;
   end; -- unita_organizzativa.chk_DI
   --------------------------------------------------------------------------------
   function is_dal_ok
   (
      p_ottica                    in unita_organizzative.ottica%type
     ,p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_old_dal                   in unita_organizzative.dal%type
     ,p_new_dal                   in unita_organizzative.dal%type
     ,p_old_al                    in unita_organizzative.al%type
     ,p_id_elemento               in unita_organizzative.id_elemento%type
     ,p_rowid                     in rowid
     ,p_inserting                 in number
     ,p_updating                  in number
   ) return afc_error.t_error_number
   /******************************************************************************
       NOME:        is_dal_ok
       DESCRIZIONE: Controllo nuovo dal compreso in periodo immediatamente
                    precedente
       PARAMETRI:   p_ottica
                    p_progr_unita_organizzative
                    p_old_dal
                    p_new_dal
                    p_old_al
                    p_rowid
                    p_inserting
                    p_updating
       NOTE:        --
      ******************************************************************************/
    is
      d_periodo afc_periodo.t_periodo;
      d_result  afc_error.t_error_number := afc_error.ok;
   begin
      if p_inserting = 1 and p_updating = 0 and p_new_dal is not null then
         d_periodo := afc_periodo.get_ultimo(p_tabella            => 'UNITA_ORGANIZZATIVE'
                                            ,p_nome_dal           => 'DAL'
                                            ,p_nome_al            => 'AL'
                                            ,p_al                 => p_old_al
                                            ,p_campi_controllare  => '#OTTICA#PROGR_UNITA_ORGANIZZATIVA#ID_ELEMENTO#'
                                            ,p_valori_controllare => '#' || p_ottica || '#' ||
                                                                     p_progr_unita_organizzativa || '#' || '<>' ||
                                                                     p_id_elemento || '#'
                                             --                                          , p_rowid => p_rowid
                                             );
         if d_periodo.dal is null and d_periodo.al is null then
            d_result := afc_error.ok;
         else
            if p_new_dal <= d_periodo.dal then
               d_result := s_dal_errato_ins_number;
            else
               d_result := afc_error.ok;
            end if;
         end if;
      end if;
      if p_inserting = 0 and p_updating = 1 then
         if p_new_dal < p_old_dal and p_new_dal is not null then
            d_periodo := afc_periodo.get_precedente(p_tabella            => 'UNITA_ORGANIZZATIVE'
                                                   ,p_nome_dal           => 'DAL'
                                                   ,p_nome_al            => 'AL'
                                                   ,p_dal                => p_old_dal
                                                   ,p_al                 => p_old_al
                                                   ,p_campi_controllare  => '#OTTICA#PROGR_UNITA_ORGANIZZATIVA#'
                                                   ,p_valori_controllare => '#' ||
                                                                            p_ottica || '#' ||
                                                                            p_progr_unita_organizzativa || '#'
                                                   ,p_rowid              => p_rowid);
            if d_periodo.dal is null and d_periodo.al is null then
               d_result := afc_error.ok;
            else
               if p_new_dal between d_periodo.dal and d_periodo.al then
                  d_result := afc_error.ok;
               else
                  d_result := s_dal_errato_number;
               end if;
            end if;
         else
            d_result := afc_error.ok;
         end if;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on unita_organizzative_pkg.is_dal_ok');
      return d_result;
   end; -- unita_organizzativa.is_dal_ok
   --------------------------------------------------------------------------------
   function is_al_ok
   (
      p_ottica                    in unita_organizzative.ottica%type
     ,p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_old_dal                   in unita_organizzative.dal%type
     ,p_old_al                    in unita_organizzative.al%type
     ,p_new_al                    in unita_organizzative.al%type
     ,p_id_elemento               in unita_organizzative.id_elemento%type
     ,p_rowid                     in rowid
     ,p_inserting                 in number
     ,p_updating                  in number
   ) return afc_error.t_error_number
   /******************************************************************************
       NOME:        is_al_ok
       DESCRIZIONE: Controllo is_al_ok
       PARAMETRI:   p_ottica
                    p_progr_unita_organizzativa
                    p_old_dal
                    p_old_al
                    p_new_al
                    p_rowid
                    p_inserting
                    p_updating
       NOTE:        --
      ******************************************************************************/
    is
      d_periodo afc_periodo.t_periodo;
      d_result  afc_error.t_error_number := afc_error.ok;
   begin
      if p_inserting = 1 and p_updating = 0 and p_new_al is not null then
         d_periodo := afc_periodo.get_ultimo(p_tabella            => 'UNITA_ORGANIZZATIVE'
                                            ,p_nome_dal           => 'DAL'
                                            ,p_nome_al            => 'AL'
                                            ,p_al                 => p_old_al
                                            ,p_campi_controllare  => '#OTTICA#PROGR_UNITA_ORGANIZZATIVA#ID_ELEMENTO#'
                                            ,p_valori_controllare => '#' || p_ottica || '#' ||
                                                                     p_progr_unita_organizzativa || '#' || '<>' ||
                                                                     p_id_elemento
                                             --                                          , p_rowid => p_rowid
                                             );
         if d_periodo.dal is null and d_periodo.al is null then
            d_result := afc_error.ok;
         else
            if p_new_al <= d_periodo.al then
               d_result := s_al_errato_number;
            else
               d_result := afc_error.ok;
            end if;
         end if;
      end if;
      if p_inserting = 0 and p_updating = 1 then
         d_result := afc_periodo.is_ultimo(p_tabella            => 'UNITA_ORGANIZZATIVE'
                                          ,p_nome_dal           => 'DAL'
                                          ,p_nome_al            => 'AL'
                                          ,p_dal                => p_old_dal
                                          ,p_al                 => p_old_al
                                          ,p_campi_controllare  => '#OTTICA#PROGR_UNITA_ORGANIZZATIVA#'
                                          ,p_valori_controllare => '#' || p_ottica || '#' ||
                                                                   p_progr_unita_organizzativa || '#');
         if not d_result = afc_error.ok then
            d_result := s_al_errato_number;
         end if;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on unita_organizzative.is_al_ok');
      return d_result;
   end; -- unita_organizzativa.is_al_ok
   --------------------------------------------------------------------------------
   function is_unita_figlie_ok
   (
      p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica                    unita_organizzative.ottica%type
     ,p_dal                       in unita_organizzative.dal%type
   ) return afc_error.t_error_number
   /******************************************************************************
       NOME:        is_unita_figlie_ok
       DESCRIZIONE: Controllo che non esistano unità organizzative figlie (in caso
                    di eliminazione)
       PARAMETRI:   p_id_elemento
                    p_dal
       NOTE:        --
      ******************************************************************************/
    is
      d_contatore number := 0;
      d_result    afc_error.t_error_number := afc_error.ok;
   begin
      begin
         /*select count(*)
          into d_contatore
          from unita_organizzative
         where id_unita_padre = p_id_elemento
           and (nvl(al, to_date('3333333', 'j')) > p_dal and
               revisione_cessazione is null);*/
         select count(*)
           into d_contatore
           from unita_organizzative u
          where id_unita_padre = p_progr_unita_organizzativa
            and ottica = p_ottica
            and (nvl(al, to_date('3333333', 'j')) > p_dal and
                revisione_cessazione is null)
            and not exists
          (select 'x'
                   from unita_organizzative
                  where ottica = p_ottica
                    and progr_unita_organizzativa = p_progr_unita_organizzativa
                    and (nvl(al, to_date('3333333', 'j')) > p_dal and
                        revisione_cessazione is null));
      exception
         when others then
            d_contatore := 0;
      end;
      if d_contatore = 0 then
         d_result := afc_error.ok;
      else
         d_result := s_esistono_unita_figlie_number;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on unita_organizzative.is_unita_figlie_ok');
      return d_result;
   end;
   --------------------------------------------------------------------------------
   function is_componenti_ok
   (
      p_ottica                    in unita_organizzative.ottica%type
     ,p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in unita_organizzative.dal%type
   ) return afc_error.t_error_number
   /******************************************************************************
       NOME:        is_componenti_ok
       DESCRIZIONE: Controllo che non esistano componenti associati alla U.O. che si
                    vuole eliminare
       PARAMETRI:   p_id_elemento
                    p_dal
       NOTE:        --
      ******************************************************************************/
    is
      d_contatore number;
      d_result    afc_error.t_error_number := afc_error.ok;
   begin
      select count(*)
        into d_contatore
        from unita_organizzative
       where ottica = p_ottica
         and progr_unita_organizzativa = p_progr_unita_organizzativa
         and revisione_cessazione is null
         and nvl(al, to_date(3333333, 'j')) > p_dal;
      --
      if d_contatore = 0 then
         select count(*)
           into d_contatore
           from componenti
          where ottica = p_ottica
            and progr_unita_organizzativa = p_progr_unita_organizzativa
            and al is null
            and revisione_cessazione is null;
         /*      d_contatore :=  componente.count_rows ( p_progr_unita_organizzativa => '='||p_progr_unita_organizzativa
         , p_ottica => '='''||p_ottica||''''
         , p_other_condition => ' and (nvl(al,to_date(''3333333'',''j'')) > '
                              ||' to_date(''' || nvl(to_char(p_dal, 'dd/mm/yyyy'), '01/01/1500') || ''', ''dd/mm/yyyy'') and '
                              ||' revisione_cessazione is null)'
         , p_QBE => 1);*/
         if d_contatore = 0 then
            d_result := afc_error.ok;
         else
            d_result := s_esistono_componenti_number;
         end if;
      else
         d_result := afc_error.ok;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on unita_organizzative.is_componenti_ok');
      return d_result;
   end;
   --------------------------------------------------------------------------------
   function is_ri_ok
   (
      p_ottica                    in unita_organizzative.ottica%type
     ,p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_old_dal                   in unita_organizzative.dal%type
     ,p_new_dal                   in unita_organizzative.dal%type
     ,p_old_al                    in unita_organizzative.al%type
     ,p_new_al                    in unita_organizzative.al%type
     ,p_id_elemento               in unita_organizzative.id_elemento%type
     ,p_old_revisione_cessazione  in unita_organizzative.revisione_cessazione%type
     ,p_new_revisione_cessazione  in unita_organizzative.revisione_cessazione%type
     ,p_rowid                     in rowid
     ,p_inserting                 in number
     ,p_updating                  in number
     ,p_deleting                  in number
   ) return afc_error.t_error_number
   /******************************************************************************
       NOME:        is_RI_ok.
       DESCRIZIONE: gestione della Referential Integrity:
                    - is_dal_ok
                    - is_al_ok
                    - is_unita_figlie_ok
                    - is_componenti_ok
       PARAMETRI:   p_ottica
                    p_progr_unita_organizzativa
                    p_old_dal
                    p_new_dal
                    p_old_al
                    p_new_al
                    p_id_elemento
                    p_old_revisione_cessazione
                    p_new_revisione_cessazione
                    p_rowid
                    p_inserting
                    p_updating
                    p_deleting
       RETURN:      1 se tutti i controlli danno esito positivo, l'error_code altrimenti
       NOTE:        --
      ******************************************************************************/
    is
      d_result    afc_error.t_error_number := afc_error.ok;
      d_revisione revisioni_struttura.revisione%type;
   begin
      select nvl(decode(revisione_struttura.get_revisione_mod(p_ottica)
                       ,-1
                       ,to_number(null)
                       ,revisione_struttura.get_revisione_mod(p_ottica))
                ,revisione_struttura.get_ultima_revisione(p_ottica))
        into d_revisione
        from dual;
      set_tipo_revisione(p_ottica, d_revisione);
      -- is_dal_ok
      -- is_al_ok
      if (d_result = afc_error.ok) and nvl(s_tipo_revisione, 'N') = 'N' then
         if nvl(p_old_dal, to_date('3333333', 'j')) <>
            nvl(p_new_dal, to_date('3333333', 'j')) then
            d_result := is_dal_ok(p_ottica
                                 ,p_progr_unita_organizzativa
                                 ,p_old_dal
                                 ,p_new_dal
                                 ,p_old_al
                                 ,p_id_elemento
                                 ,p_rowid
                                 ,p_inserting
                                 ,p_updating);
         end if;
         if nvl(p_old_al, to_date('3333333', 'j')) <>
            nvl(p_new_al, to_date('3333333', 'j')) then
            d_result := is_al_ok(p_ottica
                                ,p_progr_unita_organizzativa
                                ,p_old_dal
                                ,p_old_al
                                ,p_new_al
                                ,p_id_elemento
                                ,p_rowid
                                ,p_inserting
                                ,p_updating);
         end if;
      end if;
      if d_result = afc_error.ok then
         if (p_new_revisione_cessazione is not null and
            p_old_revisione_cessazione is null) or p_deleting = 1 then
            -- is_unita_figlie_ok
            d_result := is_unita_figlie_ok(p_progr_unita_organizzativa
                                          ,p_ottica
                                          ,nvl(p_new_dal, p_old_dal));
            -- componente.is_componenti_ok
            if d_result = afc_error.ok then
               d_result := is_componenti_ok(p_ottica
                                           ,p_progr_unita_organizzativa
                                           ,nvl(p_new_dal, p_old_dal));
            end if;
         end if;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on unita_organizzativa.is_RI_ok');
      return d_result;
   end; -- unita_organizzativa.is_RI_ok
   --------------------------------------------------------------------------------
   procedure chk_ri
   (
      p_ottica                    in unita_organizzative.ottica%type
     ,p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_old_dal                   in unita_organizzative.dal%type
     ,p_new_dal                   in unita_organizzative.dal%type
     ,p_old_al                    in unita_organizzative.al%type
     ,p_new_al                    in unita_organizzative.al%type
     ,p_id_elemento               in unita_organizzative.id_elemento%type
     ,p_old_revisione_cessazione  in unita_organizzative.revisione_cessazione%type
     ,p_new_revisione_cessazione  in unita_organizzative.revisione_cessazione%type
     ,p_rowid                     in rowid
     ,p_inserting                 in number
     ,p_updating                  in number
     ,p_deleting                  in number
   ) is
      /******************************************************************************
       NOME:        chk_RI.
       DESCRIZIONE: gestione della Referential Integrity:
                    - is_dal_ok
                    - is_al_ok
       PARAMETRI:   p_progr_unita_organizzativa
                    p_old_dal
                    p_new_dal
                    p_old_al
                    p_new_al
       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
      d_result := is_ri_ok(p_ottica
                          ,p_progr_unita_organizzativa
                          ,p_old_dal
                          ,p_new_dal
                          ,p_old_al
                          ,p_new_al
                          ,p_id_elemento
                          ,p_old_revisione_cessazione
                          ,p_new_revisione_cessazione
                          ,p_rowid
                          ,p_inserting
                          ,p_updating
                          ,p_deleting);
      dbc.assertion(not dbc.assertionon or d_result = afc_error.ok or d_result < 0
                   ,'d_result = AFC_Error.ok or d_result < 0 on unita_organizzativa.chk_RI');
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, error_message(d_result));
      end if;
   end; -- unita_organizzativa.chk_RI
   --------------------------------------------------------------------------------
   procedure elimina_legame
   (
      p_id_elemento            in unita_organizzative.id_elemento%type
     ,p_revisione              in unita_organizzative.revisione_cessazione%type
     ,p_al                     in unita_organizzative.al%type
     ,p_data_aggiornamento     in unita_organizzative.data_aggiornamento%type
     ,p_utente_aggiornamento   in unita_organizzative.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        elimina_legame.
       DESCRIZIONE: Eliminazione di un legame padre-figlio (unità organizzative)
       PARAMETRI:   p_id_elemento
                    p_revisione
                    p_al
                    p_data_aggiornamento
                    p_utente_aggiornamento
                    p_segnalazione_bloccante
                    p_segnalazione
       NOTE:        --
      ******************************************************************************/
      d_ottica                    unita_organizzative.ottica%type;
      d_revisione_ins             unita_organizzative.revisione%type := null;
      d_progr_unita_organizzativa unita_organizzative.progr_unita_organizzativa%type;
      d_id_elemento_orig          unita_organizzative.id_elemento%type;
      d_id_padre_orig             unita_organizzative.id_unita_padre%type;
      d_revisione_orig            unita_organizzative.revisione%type;
      d_dal_orig                  unita_organizzative.dal%type;
      d_dal_pubb_orig             unita_organizzative.dal_pubb%type;
      d_sequenza_orig             unita_organizzative.sequenza%type;
      d_anagrafe_dal              anagrafe_unita_organizzative.dal%type;
      d_descr_unita               anagrafe_unita_organizzative.descrizione%type;
      d_contatore                 number;
      d_errore exception;
   begin
      d_ottica := unita_organizzativa.get_ottica(p_id_elemento => p_id_elemento);

      d_progr_unita_organizzativa := unita_organizzativa.get_progr_unita(p_id_elemento => p_id_elemento);

      d_anagrafe_dal := anagrafe_unita_organizzativa.get_dal_corrente(d_progr_unita_organizzativa
                                                                     ,nvl(revisione_struttura.get_dal(d_ottica
                                                                                                     ,p_revisione)
                                                                         ,trunc(sysdate)));

      d_descr_unita := anagrafe_unita_organizzativa.get_descrizione_corrente(d_progr_unita_organizzativa
                                                                            ,trunc(sysdate));
      --
      -- Se l'ottica non è gestita a revisioni, l'eliminazione consiste nella delete
      -- del record di UNITA_ORGANIZZATIVE
      --
      if p_revisione is null then
         begin
            del(p_id_elemento => p_id_elemento);
         exception
            when others then
               if sqlcode between - 20999 and - 20900 then
                  p_segnalazione := error_message(sqlcode);
               else
                  p_segnalazione := sqlerrm;
               end if;
               raise d_errore;
         end;
      else

         d_revisione_ins := unita_organizzativa.get_revisione(p_id_elemento => p_id_elemento);
         --
         -- Se il legame è stato istituito con la revisione in corso di modifica,
         -- si controlla se proviene da uno spostamento
         --
         if d_revisione_ins = p_revisione then
            begin
               select id_elemento
                     ,id_unita_padre
                     ,revisione
                     ,dal
                     ,sequenza
                     ,dal_pubb
                 into d_id_elemento_orig
                     ,d_id_padre_orig
                     ,d_revisione_orig
                     ,d_dal_orig
                     ,d_sequenza_orig
                     ,d_dal_pubb_orig --#584
                 from unita_organizzative
                where ottica = d_ottica
                  and progr_unita_organizzativa = d_progr_unita_organizzativa
                  and revisione_cessazione = p_revisione;
            exception
               when no_data_found then
                  d_id_elemento_orig := to_number(null);
               when others then
                  p_segnalazione := sqlerrm;
                  raise d_errore;
            end;
            --
            -- Se il legame da eliminare proviene da uno spostamento, si ripristina la
            -- situazione originale
            --
            if d_id_elemento_orig is not null then
               begin
                  del(p_id_elemento => d_id_elemento_orig);
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
                  update unita_organizzative
                     set id_unita_padre = d_id_padre_orig
                        ,revisione      = d_revisione_orig
                        ,dal            = d_dal_orig
                        ,sequenza       = d_sequenza_orig
                        ,dal_pubb       = d_dal_pubb_orig --#584
                   where id_elemento = p_id_elemento;
               exception
                  when others then
                     if sqlcode between - 20999 and - 20900 then
                        p_segnalazione := s_error_table(sqlcode);
                     else
                        p_segnalazione := sqlerrm;
                     end if;
                     raise d_errore;
               end;
            else
               --
               -- Se il legame da eliminare è stato inserito con la revisione in corso di modifica
               -- si elimina il record
               --
               begin
                  del(p_id_elemento => p_id_elemento);
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
         else
            --
            -- Se il legame da eliminare è stato istituito con un'altra revisione,
            -- si aggiorna la revisione di cessazione
            --
            begin
               update unita_organizzative
                  set revisione_cessazione = p_revisione
                     ,al                   = p_al
                     ,al_prec              = al
                     ,revisione_cess_prec  = revisione_cessazione
                     ,utente_aggiornamento = p_utente_aggiornamento
                     ,data_aggiornamento   = p_data_aggiornamento
                where id_elemento = p_id_elemento;
            exception
               when others then
                  if sqlcode between - 20999 and - 20900 then
                     p_segnalazione := s_error_table(sqlcode);
                  else
                     p_segnalazione := sqlerrm;
                  end if;
                  raise d_errore;
            end;

            -- impostazione revisione in anagrafe unita' organizzative
            -- verifichiamo se il progressivo è utilizzato anche in altre ottiche
            select count(*)
              into d_contatore
              from unita_organizzative
             where progr_unita_organizzativa = d_progr_unita_organizzativa
               and ottica <> d_ottica
               and (nvl(al, to_date(3333333, 'j')) > p_al or al is null);

            if d_contatore = 0 then
               --#423
               set_revisione_cessazione(d_ottica
                                       ,d_progr_unita_organizzativa
                                       ,p_revisione
                                       ,d_anagrafe_dal);
            else
               p_segnalazione_bloccante := 'N';
               p_segnalazione           := 'U.O.: ' || d_descr_unita || ' - ' ||
                                           'non eliminata dall''Anagrafe in quanto utilizzata in altre ottiche';
            end if;
         end if;
      end if;
   exception
      when d_errore then
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'U.O.: ' || d_descr_unita || ' - ' || p_segnalazione;
   end; -- Unita_organizzativa.elimina_legame
   --------------------------------------------------------------------------------
   procedure cancella_figli
   (
      p_da_eliminare    unita_organizzative.id_elemento%type
     ,p_da_ripristinare unita_organizzative.id_elemento%type
     ,p_level           number default 0
   ) is
      /******************************************************************************
       NOME:        cancella_figli
       DESCRIZIONE: Elimina tutti i figli di una unità creata in fase di spostamento.
                    Questa attività è necessaria per effettuare il ripristino.
       PARAMETRI:   p_da_eliminare
                    p_da_ripristinare
                    p_level
       NOTE:        --
      ******************************************************************************/
      v_id_elemento                  unita_organizzative.id_elemento%type;
      v_unita_organizzativa          unita_organizzative%rowtype;
      v_unita_organizzativa_cancella unita_organizzative%rowtype;
      cursor c_figli_ripristinare(p_da_ripristinare varchar2) is
         select *
           from unita_organizzative
          where id_unita_padre = p_da_ripristinare
            and revisione = revisione_struttura.get_revisione_mod(ottica)
            for update;
   begin
      for v_figlio in c_figli_ripristinare(p_da_ripristinare)
      loop
         -- per ogni figlio che ha come padre l'unità da ripristinare
         -- prendo le informazioni del figlio corrispondente nell'unità
         -- da eliminare perchè era stata creata per gestire lo spostamento.
         select *
           into v_unita_organizzativa
           from unita_organizzative
          where id_unita_padre = p_da_eliminare
            and progr_unita_organizzativa = v_figlio.progr_unita_organizzativa;
         cancella_figli(v_unita_organizzativa.id_elemento, v_figlio.id_elemento, 1);
      end loop;
      if p_level = 1 then
         -- i record a livello 0 vengono sistemati da ripristina_legame
         select *
           into v_unita_organizzativa_cancella
           from unita_organizzative
          where id_elemento = p_da_eliminare;
         del(p_id_elemento => p_da_eliminare);
         -- sistemo le informazioni come erano in origine
         update unita_organizzative
            set dal       = v_unita_organizzativa_cancella.dal
               ,al        = v_unita_organizzativa_cancella.al
               ,revisione = v_unita_organizzativa.revisione
          where id_elemento = p_da_ripristinare;
      end if;
   end;
   --------------------------------------------------------------------------------
   procedure ripristina_legame
   (
      p_id_elemento            in unita_organizzative.id_elemento%type
     ,p_revisione              in unita_organizzative.revisione_cessazione%type
     ,p_al                     in unita_organizzative.al%type
     ,p_data_aggiornamento     in unita_organizzative.data_aggiornamento%type
     ,p_utente_aggiornamento   in unita_organizzative.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        ripristina_legame.
       DESCRIZIONE: Ripristino di un legame padre-figlio eliminato (unità organizzative)
       PARAMETRI:   p_id_elemento
                    p_revisione
                    p_al
                    p_data_aggiornamento
                    p_utente_aggiornamento
                    p_segnalazione_bloccante
                    p_segnalazione
       NOTE:        --
      ******************************************************************************/
      d_ottica                    unita_organizzative.ottica%type;
      d_progr_unita_organizzativa unita_organizzative.progr_unita_organizzativa%type;
      d_id_elemento_orig          unita_organizzative.id_elemento%type;
      d_id_padre_orig             unita_organizzative.id_unita_padre%type;
      d_revisione_orig            unita_organizzative.revisione%type;
      d_progr_padre_orig          unita_organizzative.progr_unita_organizzativa%type;
      d_dal_orig                  unita_organizzative.dal%type;
      d_sequenza_orig             unita_organizzative.sequenza%type;
      d_contatore                 number;
      d_anagrafe_dal              anagrafe_unita_organizzative.dal%type;
      d_descr_unita               anagrafe_unita_organizzative.descrizione%type;
      d_dal_revisione_mod         revisioni_struttura.dal%type;
      d_dal_pubb                  unita_organizzative.dal_pubb%type;
      d_al_pubb                   unita_organizzative.al_pubb%type;
      d_errore exception;
   begin
      begin
         select ottica
               ,progr_unita_organizzativa
               ,id_unita_padre
               ,revisione
               ,dal
               ,sequenza
               ,dal_pubb
               ,al_pubb
           into d_ottica
               ,d_progr_unita_organizzativa
               ,d_id_padre_orig
               ,d_revisione_orig
               ,d_dal_orig
               ,d_sequenza_orig
               ,d_dal_pubb --#490
               ,d_al_pubb
           from unita_organizzative
          where id_elemento = p_id_elemento;
      exception
         when others then
            if sqlcode between - 20999 and - 20900 then
               p_segnalazione := error_message(sqlcode);
            else
               p_segnalazione := sqlerrm;
            end if;
            raise d_errore;
      end;

      d_anagrafe_dal := anagrafe_unita_organizzativa.get_dal_corrente(d_progr_unita_organizzativa
                                                                     ,nvl(revisione_struttura.get_dal(d_ottica
                                                                                                     ,p_revisione)
                                                                         ,trunc(sysdate)));

      d_dal_revisione_mod := revisione_struttura.get_dal(d_ottica, p_revisione);
      if d_dal_revisione_mod is null then
         select max(dal)
           into d_dal_revisione_mod
           from revisioni_struttura
          where ottica = d_ottica
            and stato = 'A';
      end if;
      d_descr_unita := anagrafe_unita_organizzativa.get_descrizione_corrente(d_progr_unita_organizzativa
                                                                            ,d_dal_orig);
      set_tipo_revisione(d_ottica, p_revisione);
      --
      -- Si controlla se il legame da ripristinare è stato eliminato a causa di uno
      -- spostamento
      --
      begin
         select id_elemento
           into d_id_elemento_orig
           from unita_organizzative
          where ottica = d_ottica
            and progr_unita_organizzativa = d_progr_unita_organizzativa
            and revisione = p_revisione;
      exception
         when no_data_found then
            d_id_elemento_orig := null;
         when others then
            if sqlcode between - 20999 and - 20900 then
               p_segnalazione := error_message(sqlcode);
            else
               p_segnalazione := sqlerrm;
            end if;
            raise d_errore;
      end;

      -- verifichiamo che il padre che riceve il legame ripristinato non sia stato a sua volta eliminato
      select count(*)
        into d_contatore
        from unita_organizzative u
       where ottica = d_ottica
         and (progr_unita_organizzativa = d_id_padre_orig or d_id_padre_orig is null) --#37253
         and d_dal_revisione_mod between nvl(dal, to_date(2222222, 'j')) and
             nvl(u.al, to_date(3333333, 'j'))
         and nvl(revisione_cessazione, -1) <> p_revisione;
      if d_contatore = 0 then
         p_segnalazione := 'Non e'' possibile ripristinare il legame - l''unita'' padre e'' stata eliminata';
         raise d_errore;
      end if;

      --
      -- se il legame eliminato deriva da uno spostamento e si sta annullando lo spostamento
      -- stesso, si ripristina la situazione originale
      --
      if d_id_elemento_orig is not null then
         begin
            del(p_id_elemento => p_id_elemento);
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
            update unita_organizzative
               set dal                  = d_dal_orig
                  ,dal_pubb             = d_dal_pubb --#490
                  ,al_pubb              = d_al_pubb
                  ,revisione            = d_revisione_orig
                  ,id_unita_padre       = d_id_padre_orig
                  ,sequenza             = d_sequenza_orig
                  ,utente_aggiornamento = p_utente_aggiornamento
                  ,data_aggiornamento   = p_data_aggiornamento
             where id_elemento = d_id_elemento_orig;
         exception
            when others then
               if sqlcode between - 20999 and - 20900 then
                  p_segnalazione := error_message(sqlcode);
               else
                  p_segnalazione := sqlerrm;
               end if;
               raise d_errore;
         end;
      else
         begin
            update unita_organizzative
               set al                   = al_prec --null
                  ,revisione_cessazione = revisione_cess_prec
                  ,al_prec              = ''
                  ,revisione_cess_prec  = ''
                  ,utente_aggiornamento = p_utente_aggiornamento
                  ,data_aggiornamento   = p_data_aggiornamento
             where id_elemento = p_id_elemento;
         exception
            when others then
               if sqlcode between - 20999 and - 20900 then
                  p_segnalazione := error_message(sqlcode);
               else
                  p_segnalazione := sqlerrm;
               end if;
               raise d_errore;
         end;
         -- impostazione revisione in anagrafe unita' organizzative
         set_revisione_cessazione(p_ottica                    => d_ottica
                                 ,p_progr_unita_organizzativa => d_progr_unita_organizzativa
                                 ,p_revisione_cessazione      => null
                                 ,p_dal                       => d_anagrafe_dal);
      end if;
   exception
      when d_errore then
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'U.O.: ' || d_descr_unita || ' - ' || p_segnalazione;
   end; -- unita_organizzativa.ripristina legame
   --------------------------------------------------------------------------------
   procedure copia_figli
   (
      p_provenienza  unita_organizzative.id_elemento%type
     ,p_destinazione unita_organizzative.id_elemento%type
     ,p_revisione    unita_organizzative.revisione%type
     ,p_dal          date
     ,p_al           date
     ,p_data         date
   ) is
      /******************************************************************************
       NOME:        copia_figli
       DESCRIZIONE: In caso di spostamento di un albero duplica i figli della unita
                    da spostare nel sottoramo creato per mantenere le informazioni del
                    passato.
       PARAMETRI:   p_provenienza
                    p_destinazione
                    p_revisione
                    p_dal
                    p_al
       NOTE:        --
      ******************************************************************************/
      v_id_elemento unita_organizzative.id_elemento%type;
      cursor c_figlio(p_provenienza varchar2) is
         select *
           from unita_organizzative
          where id_unita_padre = p_provenienza
            and p_data between dal and nvl(al, to_date('3333333', 'j'))
            for update;
      v_info_figlio c_figlio%rowtype;
   begin
      -- per ogni figlio esistente nel sottoramo da spostare
      for v_figlio in c_figlio(p_provenienza)
      loop
         -- sistemazione delle date che siano congruenti con il padre.
         v_info_figlio := v_figlio;
         update unita_organizzative
            set dal                  = p_dal
               ,al                   = p_al
               ,revisione            = p_revisione
               ,revisione_cessazione = decode(sign(revisione_cessazione - p_revisione)
                                             ,1
                                             ,revisione_cessazione
                                             ,'') --
          where current of c_figlio;
         -- inserimento unità con le informazioni "storiche"

         insert into unita_organizzative
            (id_elemento
            ,ottica
            ,revisione
            ,sequenza
            ,progr_unita_organizzativa
            ,id_unita_padre
            ,revisione_cessazione
            ,dal
            ,al
            ,utente_aggiornamento
            ,data_aggiornamento)
         values
            (null
            ,v_info_figlio.ottica
            ,v_info_figlio.revisione
            ,v_info_figlio.sequenza
            ,v_info_figlio.progr_unita_organizzativa
            ,p_destinazione
            ,decode(sign(p_revisione - v_info_figlio.revisione), 1, p_revisione, '') --p_revisione
            ,v_info_figlio.dal
            ,v_info_figlio.al
            ,v_info_figlio.utente_aggiornamento
            ,v_info_figlio.data_aggiornamento)
         returning id_elemento into v_id_elemento;
         -- copia di tutti i figli dell'unità appena creata.
         copia_figli(v_figlio.id_elemento
                    ,v_id_elemento
                    ,p_revisione
                    ,p_dal
                    ,p_al
                    ,p_data);
      end loop;
   end;
   procedure sposta_legame
   (
      p_id_elemento_partenza   in unita_organizzative.id_elemento%type
     ,p_id_elemento_arrivo     in unita_organizzative.id_elemento%type
     ,p_revisione              in unita_organizzative.revisione_cessazione%type
     ,p_dal                    in unita_organizzative.dal%type
     ,p_al                     in unita_organizzative.al%type
     ,p_data_aggiornamento     in unita_organizzative.data_aggiornamento%type
     ,p_utente_aggiornamento   in unita_organizzative.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        sposta_legame.
       DESCRIZIONE: Spostamente di una unità organizzativa da un padre ad un altro
       PARAMETRI:   p_id_elemento_partenza
                    p_id_elemento_arrivo
                    p_revisione
                    p_dal
                    p_al
                    p_data_aggiornamento
                    p_utente_aggiornamento
                    p_segnalazione_bloccante
                    p_segnalazione
       NOTE:        --
      ******************************************************************************/
      d_ottica                    unita_organizzative.ottica%type;
      d_revisione_partenza        unita_organizzative.revisione%type;
      d_rev_cessazione_partenza   unita_organizzative.revisione_cessazione%type;
      d_sequenza                  unita_organizzative.sequenza%type;
      d_progr_unita_organizzativa unita_organizzative.progr_unita_organizzativa%type;
      d_progr_unita_org_arrivo    unita_organizzative.progr_unita_organizzativa%type;
      d_progr_unita_padre         unita_organizzative.id_unita_padre%type;
      d_dal                       unita_organizzative.dal%type;
      d_dal_pubb                  unita_organizzative.dal_pubb%type;
      d_al_pubb                   unita_organizzative.al_pubb%type;
      d_rev_cessazione_arrivo     unita_organizzative.revisione_cessazione%type;
      d_id_elemento_ins           unita_organizzative.id_elemento%type;
      d_revisione_orig            unita_organizzative.revisione%type;
      d_dal_orig                  unita_organizzative.dal%type;
      d_dal_pubb_orig             unita_organizzative.dal_pubb%type;
      d_al_orig                   unita_organizzative.al%type;
      d_al_pubb_orig              unita_organizzative.al_pubb%type;
      d_sequenza_orig             unita_organizzative.sequenza%type;
      d_al_prec                   unita_organizzative.al_prec%type;
      d_revisione_cess_prec       unita_organizzative.revisione_cess_prec%type;
      d_al_prec_orig              unita_organizzative.al_prec%type;
      d_revisione_cess_prec_orig  unita_organizzative.revisione_cess_prec%type;
      d_nuova_sequenza            unita_organizzative.sequenza%type;
      -- d_data                      date;
      --D_anagrafe_dal               anagrafe_unita_organizzative.dal%type;
      d_descr_unita anagrafe_unita_organizzative.descrizione%type;
      d_errore               exception;
      d_errore_non_bloccante exception;
   begin
      begin
         select ottica
               ,revisione
               ,revisione_cessazione
               ,sequenza
               ,progr_unita_organizzativa
               ,id_unita_padre
               ,dal
               ,dal_pubb
               ,al_pubb
               ,al_prec
               ,revisione_cess_prec
           into d_ottica
               ,d_revisione_partenza
               ,d_rev_cessazione_partenza
               ,d_sequenza
               ,d_progr_unita_organizzativa
               ,d_progr_unita_padre
               ,d_dal
               ,d_dal_pubb
               ,d_al_pubb
               ,d_al_prec
               ,d_revisione_cess_prec
           from unita_organizzative
          where id_elemento = p_id_elemento_partenza;
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
      -- d_data := nvl(revisione_struttura.get_dal(d_ottica, p_revisione), trunc(sysdate));
      --
      begin
         --D_anagrafe_dal := anagrafe_unita_organizzativa.get_dal_corrente ( d_progr_unita_organizzativa
         --                                                                , d_dal );
         d_descr_unita := anagrafe_unita_organizzativa.get_descrizione_corrente(d_progr_unita_organizzativa
                                                                               ,d_dal);
      exception
         when no_data_found then
            d_descr_unita := '*';
      end;
      --
      if p_id_elemento_arrivo is null then
         --#265
         --trasformazione del nodo in radice
         d_progr_unita_org_arrivo := to_number(null);
         d_rev_cessazione_arrivo  := to_number(null);
      else
         --normale spostamento su un nodo esistente
         begin
            select revisione_cessazione
                  ,progr_unita_organizzativa
              into d_rev_cessazione_arrivo
                  ,d_progr_unita_org_arrivo
              from unita_organizzative
             where id_elemento = p_id_elemento_arrivo;
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
      --
      -- Un legame cessato non può essere spostato
      --
      if d_rev_cessazione_partenza = p_revisione then
         p_segnalazione := 'Non e'' possibile spostare i legami cessati';
         raise d_errore;
      end if;
      --
      -- Non si possono spostare legami all'interno di un legame cessato
      --
      if d_rev_cessazione_arrivo = p_revisione then
         p_segnalazione := 'Non e'' possibile inserire dati in un legame cessato';
         raise d_errore;
      end if;
      --
      --- Non si può spostare un legame nell'ambito dello stesso padre
      --
      if d_progr_unita_org_arrivo = d_progr_unita_padre then
         p_segnalazione := 'Non e'' possibile spostare un legame nell''ambito della stessa radice';
         raise d_errore_non_bloccante;
      end if;
      d_nuova_sequenza := unita_organizzativa.get_nuova_sequenza(p_ottica         => d_ottica
                                                                ,p_id_unita_padre => d_progr_unita_org_arrivo
                                                                ,p_data           => nvl(p_dal
                                                                                        ,trunc(sysdate)));
      --
      -- se l'ottica non è gestita a revisioni si aggiorna direttamente il record interessato
      --
      if p_revisione is null then
         begin
            update unita_organizzative
               set id_unita_padre       = d_progr_unita_org_arrivo
                  ,sequenza             = d_nuova_sequenza
                  ,utente_aggiornamento = p_utente_aggiornamento
                  ,data_aggiornamento   = p_data_aggiornamento
             where id_elemento = p_id_elemento_partenza;
         exception
            when others then
               if sqlcode between - 20999 and - 20900 then
                  p_segnalazione := error_message(sqlcode);
               else
                  p_segnalazione := sqlerrm;
               end if;
               raise d_errore;
         end;
      else
         --
         -- se il legame è stato istituito con la revisione in modifica, si verifica
         -- che la creazione derivi da uno spostamento oppure da un inserimento ex-novo
         --
         if d_revisione_partenza = p_revisione then
            begin
               select id_elemento
                     ,revisione
                     ,dal
                     ,al
                     ,dal_pubb
                     ,al_pubb
                     ,sequenza
                     ,al_prec
                     ,revisione_cess_prec
                 into d_id_elemento_ins
                     ,d_revisione_orig
                     ,d_dal_orig
                     ,d_al_orig
                     ,d_dal_pubb_orig
                     ,d_al_pubb_orig
                     ,d_sequenza_orig
                     ,d_al_prec_orig
                     ,d_revisione_cess_prec_orig
                 from unita_organizzative
                where ottica = d_ottica
                  and progr_unita_organizzativa = d_progr_unita_organizzativa
                  and id_unita_padre = d_progr_unita_org_arrivo
                  and revisione_cessazione = p_revisione;
            exception
               when no_data_found then
                  d_revisione_orig := to_number(null);
                  d_dal_orig       := to_date(null);
                  d_dal_pubb_orig  := to_date(null);
               when others then
                  if sqlcode between - 20999 and - 20900 then
                     p_segnalazione := error_message(sqlcode);
                  else
                     p_segnalazione := sqlerrm;
                  end if;
                  raise d_errore;
            end;
            --
            -- se il legame deriva da uno spostamento e si sta annullando lo spostamento precedente,
            -- si ripristina la situazione originale
            --
            if d_revisione_orig is not null and d_dal_orig is not null then
               begin
                  delete from unita_organizzative where id_elemento = d_id_elemento_ins;
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
                  update unita_organizzative
                     set dal                  = d_dal_orig
                        ,al                   = d_al_orig
                        ,dal_pubb             = d_dal_pubb_orig
                        ,al_pubb              = d_al_pubb_orig
                        ,revisione            = d_revisione_orig
                        ,id_unita_padre       = d_progr_unita_org_arrivo
                        ,sequenza             = d_sequenza_orig
                        ,al_prec              = d_al_prec_orig
                        ,revisione_cessazione = d_revisione_cess_prec_orig
                        ,utente_aggiornamento = p_utente_aggiornamento
                        ,data_aggiornamento   = p_data_aggiornamento
                   where id_elemento = p_id_elemento_partenza;
               exception
                  when others then
                     if sqlcode between - 20999 and - 20900 then
                        p_segnalazione := error_message(sqlcode);
                     else
                        p_segnalazione := sqlerrm;
                     end if;
                     raise d_errore;
               end;
            else
               --
               -- Se si sta spostando un legame istituito con la revisione in modifica, lo spostamento
               -- viene affettuato aggiornando direttamente l'unità padre
               --
               begin
                  update unita_organizzative
                     set id_unita_padre       = d_progr_unita_org_arrivo
                        ,sequenza             = d_nuova_sequenza
                        ,utente_aggiornamento = p_utente_aggiornamento
                        ,data_aggiornamento   = p_data_aggiornamento
                   where id_elemento = p_id_elemento_partenza;
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
         else
            --
            -- Se si sta spostando un legame istituito con un'altra revisione, si aggiorna
            -- il legame originale e si emette un legame con i vecchi dati cessati
            --
            begin

               update unita_organizzative
                  set id_unita_padre       = d_progr_unita_org_arrivo
                     ,revisione            = p_revisione
                     ,revisione_cessazione = ''
                     ,sequenza             = d_nuova_sequenza
                     ,dal                  = p_dal
                     ,al                   = p_al
                     ,al_prec              = al
                     ,revisione_cess_prec  = revisione_cessazione
                     ,dal_pubb             = ''
                     ,al_pubb              = ''
                where id_elemento = p_id_elemento_partenza;
            exception
               when others then
                  if sqlcode between - 20999 and - 20900 then
                     p_segnalazione := error_message(sqlcode);
                  else
                     p_segnalazione := sqlerrm;
                  end if;
                  raise d_errore;
            end;
            declare
               v_id_elemento unita_organizzative.id_elemento%type;
            begin
               insert into unita_organizzative
                  (id_elemento
                  ,ottica
                  ,revisione
                  ,revisione_cessazione
                  ,sequenza
                  ,progr_unita_organizzativa
                  ,id_unita_padre
                  ,dal
                  ,al
                  ,dal_pubb
                  ,al_pubb
                  ,al_prec
                  ,revisione_cess_prec
                  ,utente_aggiornamento
                  ,data_aggiornamento)
               values
                  (null
                  ,d_ottica
                  ,d_revisione_partenza
                  ,p_revisione
                  ,d_sequenza
                  ,d_progr_unita_organizzativa
                  ,d_progr_unita_padre
                  ,d_dal
                  ,decode(p_dal, null, to_date(null), p_dal - 1)
                  ,d_dal_pubb
                  ,d_al_pubb
                  ,d_al_prec
                  ,d_revisione_cess_prec
                  ,p_utente_aggiornamento
                  ,p_data_aggiornamento)
               returning id_elemento into v_id_elemento;
               /*copia_figli(p_id_elemento_partenza
               ,v_id_elemento
               ,p_revisione
               ,p_dal
               ,p_al
               ,d_data);*/
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
      end if;
   exception
      when d_errore then
         rollback;
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'U.O.: ' || d_descr_unita || ' - ' || p_segnalazione;
      when d_errore_non_bloccante then
         null;
   end; -- unita_organizzativa.sposta_legame
   --------------------------------------------------------------------------------
   procedure set_data_al
   (
      p_ottica                    in unita_organizzative.ottica%type
     ,p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in unita_organizzative.dal%type
   ) is
      /******************************************************************************
       NOME:        set_data_al.
       DESCRIZIONE: Aggiornamento data fine validita' periodo inserito
       PARAMETRI:   p_ottica
                    p_dal
       NOTE:        --
      ******************************************************************************/
      d_periodo afc_periodo.t_periodo;
   begin
      d_periodo := afc_periodo.get_seguente(p_tabella            => 'UNITA_ORGANIZZATIVE'
                                           ,p_nome_dal           => 'DAL'
                                           ,p_nome_al            => 'AL'
                                           ,p_dal                => p_dal
                                           ,p_al                 => to_date(null)
                                           ,p_campi_controllare  => '#OTTICA#PROGR_UNITA_ORGANIZZATIVA#'
                                           ,p_valori_controllare => '#' || p_ottica || '#' ||
                                                                    p_progr_unita_organizzativa || '#');
      if d_periodo.dal is not null then
         update unita_organizzative
            set al = d_periodo.dal - 1
          where ottica = p_ottica
            and progr_unita_organizzativa = p_progr_unita_organizzativa
            and dal = p_dal;
      end if;
   end; -- unita_organizzativa.set_data_al
   --------------------------------------------------------------------------------
   procedure set_periodo_precedente
   (
      p_ottica                    in unita_organizzative.ottica%type
     ,p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in unita_organizzative.dal%type
     ,p_al                        in unita_organizzative.al%type
   ) is
      /******************************************************************************
       NOME:        set_data_al.
       DESCRIZIONE: Aggiornamento data fine validita' periodo precedente
       PARAMETRI:   p_ottica
                    p_dal
                    p_al
       NOTE:        --
      ******************************************************************************/
   begin
      update unita_organizzative
         set al                   = p_al
            ,data_aggiornamento   = sysdate
            ,utente_aggiornamento = si4.utente
       where ottica = p_ottica
         and progr_unita_organizzativa = p_progr_unita_organizzativa
         and nvl(al, to_date('2222222', 'j')) != nvl(p_al, to_date('2222222', 'j'))
         and dal = (select max(dal)
                      from unita_organizzative
                     where ottica = p_ottica
                       and progr_unita_organizzativa = p_progr_unita_organizzativa
                       and dal < p_dal);
   end; -- unita_organizzativa.set_periodo_precedente
   --------------------------------------------------------------------------------
   procedure set_revisione_istituzione
   (
      p_ottica                    in unita_organizzative.ottica%type
     ,p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_revisione                 in unita_organizzative.revisione%type
   ) is
      /******************************************************************************
       NOME:        set_revisione_istituzione.
       DESCRIZIONE: Aggiornamento revisione istituzione
       PARAMETRI:   p_ottica
                    p_progr_unita_organizzativa
                    p_revisione
       NOTE:        --
      ******************************************************************************/
   begin
      update anagrafe_unita_organizzative
         set revisione_istituzione = p_revisione
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and ottica = p_ottica
         and revisione_istituzione is null;
   end; -- unita_organizzativa.set_revisione_istituzione
   --------------------------------------------------------------------------------
   procedure set_revisione_cessazione
   (
      p_ottica                    in unita_organizzative.ottica%type
     ,p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_revisione_cessazione      in unita_organizzative.revisione_cessazione%type
     ,p_dal                       in unita_organizzative.dal%type
   ) is
      /******************************************************************************
       NOME:        set_revisione_cessazione.
       DESCRIZIONE: Aggiornamento revisione istituzione
       PARAMETRI:   p_ottica
                    p_progr_unita_organizzativa
                    p_revisione_cessazione
       NOTE:        --
      ******************************************************************************/
   begin
      update anagrafe_unita_organizzative
         set revisione_cessazione = p_revisione_cessazione
       where progr_unita_organizzativa = p_progr_unita_organizzativa
            -- and ottica = p_ottica --#423
         and dal = p_dal
      /*and revisione_cessazione is null*/
      ;
   end; -- unita_organizzativa.set_revisione_cessazione
   --------------------------------------------------------------------------------
   procedure set_fi
   (
      p_ottica                    in unita_organizzative.ottica%type
     ,p_old_progr_unor            in unita_organizzative.progr_unita_organizzativa%type
     ,p_progr_unita_organizzativa in unita_organizzative.progr_unita_organizzativa%type
     ,p_revisione                 in unita_organizzative.revisione%type
     ,p_revisione_cessazione      in unita_organizzative.revisione_cessazione%type
     ,p_old_dal                   in unita_organizzative.dal%type
     ,p_dal                       in unita_organizzative.dal%type
     ,p_old_al                    in unita_organizzative.al%type
     ,p_al                        in unita_organizzative.al%type
     ,p_inserting                 in number
     ,p_updating                  in number
     ,p_deleting                  in number
   ) is
      /******************************************************************************
       NOME:        set_FI.
       DESCRIZIONE: procedure di settaggio di Functional Integrity
       PARAMETRI:   p_ottica
                    p_OLD_progr_unor
                    p_progr_unita_organizzativa
                    p_revisione
                    p_revisione_cessazione
                    p_OLD_dal
                    p_dal
                    p_OLD_al
                    p_al
                    p_inserting
                    p_updating
                    p_deleting
       NOTE:        --
      ******************************************************************************/
      d_tipo_rev      revisioni_struttura.tipo_revisione%type;
      d_tipo_rev_cess revisioni_struttura.tipo_revisione%type;
   begin
      set_tipo_revisione(p_ottica, p_revisione);
      d_tipo_rev := s_tipo_revisione;
      set_tipo_revisione(p_ottica, nvl(p_revisione_cessazione, p_revisione));
      d_tipo_rev_cess := s_tipo_revisione;
      if d_tipo_rev <> 'N' and d_tipo_rev_cess <> 'N' and 1 = 2 then
         if p_inserting = 1 and p_updating = 0 and p_deleting = 0 then
            -- determinazione della data AL del record inserito
            set_data_al(p_ottica, p_progr_unita_organizzativa, p_dal);
            -- impostazione periodo precedente al record inserito
            set_periodo_precedente(p_ottica
                                  ,p_progr_unita_organizzativa
                                  ,p_dal
                                  ,p_dal - 1);
            -- impostazione revisione in anagrafe unita' organizzative
            set_revisione_istituzione(p_ottica, p_progr_unita_organizzativa, p_revisione);
         elsif p_inserting = 0 and p_updating = 1 and p_deleting = 0 then
            -- impostazione periodo precedente
            set_periodo_precedente(p_ottica
                                  ,p_progr_unita_organizzativa
                                  ,p_dal
                                  ,p_dal - 1);
         elsif p_inserting = 0 and p_updating = 0 and p_deleting = 1 then
            set_periodo_precedente(p_ottica, p_old_progr_unor, p_old_dal, p_old_al);
         end if;
      end if;
   end; -- Unita_organizzativa.set_fi
   --------------------------------------------------------------------------------
   function contiene_unita
   (
      p_ottica          in unita_organizzative.ottica%type
     ,p_id_provenienza  in unita_organizzative.id_elemento%type
     ,p_id_destinazione in unita_organizzative.id_elemento%type
     ,p_data            in unita_organizzative.dal%type
   ) return integer is
      /******************************************************************************
       NOME:        contiene_unita
       DESCRIZIONE: Restituisce 1 se l'unita' da spostare e' presente tra gli
                    ascendenti dell'unita' di destinazione
       PARAMETRI:   p_ottica
                    p_id_provenienza
                    p_id_destinazione
                    p_data
       RITORNA:     1 se l'unita' e' contenute, altrimenti 0
      ******************************************************************************/
      d_result      afc_error.t_error_number := afc_error.ok;
      d_progr_unita unita_organizzative.progr_unita_organizzativa%type;
      d_contatore   number;
   begin
      d_progr_unita := unita_organizzativa.get_progr_unita(p_id_elemento => p_id_provenienza);
      /*select count(*)
        into d_contatore
        from unita_organizzative
       where ottica = p_ottica
         and progr_unita_organizzativa = d_progr_unita
         and p_data between nvl(dal, trunc(sysdate)) and nvl(al, to_date('3333333', 'j'))
      connect by prior id_unita_padre = id_elemento
             and p_data between prior dal and nvl(prior al, to_date('3333333', 'j'))
       start with id_elemento = p_id_destinazione;*/
      select count(*)
        into d_contatore
        from unita_organizzative
       where ottica = p_ottica
         and progr_unita_organizzativa = d_progr_unita
         and p_data between nvl(dal, trunc(sysdate)) and nvl(al, to_date('3333333', 'j'))
      connect by prior id_unita_padre = progr_unita_organizzativa
             and ottica = p_ottica
             and p_data between dal and nvl(al, to_date('3333333', 'j'))
       start with id_elemento = p_id_destinazione;
      if d_contatore > 0 then
         d_result := afc_error.ok;
      else
         d_result := 0;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result = 0
              ,'d_result = AFC_Error.ok or d_result = 0 on unita_organizzativa.contiene_unita');
      return d_result;
   end; -- unita_organizzativa.contiene_unita
   --------------------------------------------------------------------------------
   procedure duplica_struttura
   (
      p_ottica_partenza        in unita_organizzative.ottica%type
     ,p_ottica_destinazione    in unita_organizzative.ottica%type
     ,p_data                   in unita_organizzative.dal%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        duplica_struttura.
       DESCRIZIONE: Duplica la struttura esistente associata ad un'ottica di partenza
                    in un'ottica destinazione
       PARAMETRI:   p_ottica_partenza
                    p_ottica_destinazione
                    p_data
                    p_segnalazione_bloccante
                    p_segnalazione
       NOTE:        --
      ******************************************************************************/
      d_ottica_istituzionale  ottiche.ottica_istituzionale%type;
      d_ente_partenza         amministrazioni.codice_amministrazione%type;
      d_ente_destinazione     amministrazioni.codice_amministrazione%type;
      d_gestione_revisioni    ottiche.gestione_revisioni%type;
      d_revisione_new         revisioni_struttura.revisione%type;
      d_record_struttura      unita_organizzative%rowtype;
      d_revisione_modifica    revisioni_struttura.revisione%type;
      d_revisione_da_inserire revisioni_struttura.revisione%type;
      d_data_da_inserire      unita_organizzative.dal%type;
      d_id_elemento           unita_organizzative.id_elemento%type;
      d_puo                   unita_organizzative.progr_unita_organizzativa%type;
      d_errore exception;
   begin
      begin
         d_ottica_istituzionale := ottica.get_ottica_istituzionale(p_ottica_destinazione);
         d_ente_partenza        := ottica.get_amministrazione(p_ottica_partenza);
         d_ente_destinazione    := ottica.get_amministrazione(p_ottica_destinazione);
         -- la duplicazione è possibile solamente se l'ottica di destinazione NON è istituzionale e se le
         -- due ottiche fanno parte della stessa amministrazione
         if d_ottica_istituzionale = 'NO' and d_ente_partenza = d_ente_destinazione then
            d_gestione_revisioni := ottica.get_gestione_revisioni(p_ottica_destinazione);
            -- se l'ottica di destinazione è gestita a revisioni crea una nuova revisione in modifica con dal = parametro della procedure
            if d_gestione_revisioni = 'SI' then
               -- estra la revisione pià alta
               select max(r.revisione)
                 into d_revisione_new
                 from revisioni_struttura r
                where r.ottica = p_ottica_destinazione;
               if d_revisione_new is null then
                  d_revisione_new := 0;
               end if;
               d_revisione_new := d_revisione_new + 1;
               revisione_struttura.ins(p_ottica               => p_ottica_destinazione
                                      ,p_revisione            => d_revisione_new
                                      ,p_descrizione          => 'Revisione ' ||
                                                                 d_revisione_new ||
                                                                 ' per duplicazione struttura da ottica ' ||
                                                                 p_ottica_partenza
                                      ,p_dal                  => p_data
                                      ,p_stato                => 'M'
                                      ,p_utente_aggiornamento => 'SO4'
                                      ,p_data_aggiornamento   => trunc(sysdate));
            end if;
            d_revisione_modifica := revisione_struttura.get_revisione_mod(p_ottica_partenza);
            -- imposta revisione e dal: se l'ottica destinazione è gestita a revisioni
            -- i record vengono inseriti con la nuova revisione e dal nullo
            -- altrimenti con dal = parametre della procedure e revisione nulla
            if d_gestione_revisioni = 'SI' then
               d_revisione_da_inserire := d_revisione_new;
               d_data_da_inserire      := to_date(null);
            else
               d_revisione_da_inserire := null;
               d_data_da_inserire      := p_data;
            end if;
            -- inserisce tutti i legami validi dell'ottica di partenza
            for d_record_struttura in (select *
                                         from unita_organizzative u
                                        where u.ottica = p_ottica_partenza
                                          and trunc(sysdate) between u.dal and
                                              nvl(decode(u.revisione_cessazione
                                                        ,d_revisione_modifica
                                                        ,to_date(null)
                                                        ,u.al)
                                                 ,to_date('3333333', 'j')))
            loop
               unita_organizzativa.ins(p_id_elemento               => null
                                      ,p_ottica                    => p_ottica_destinazione
                                      ,p_revisione                 => d_revisione_da_inserire
                                      ,p_sequenza                  => d_record_struttura.sequenza
                                      ,p_progr_unita_organizzativa => d_record_struttura.progr_unita_organizzativa
                                      ,p_id_unita_padre            => d_record_struttura.id_unita_padre
                                      ,p_revisione_cessazione      => null
                                      ,p_dal                       => d_data_da_inserire
                                      ,p_al                        => to_date(null)
                                      ,p_utente_aggiornamento      => 'SO4'
                                      ,p_data_aggiornamento        => trunc(sysdate));
            end loop;
            /*          -- cicla i record dell'ottica di partenza con padre non nullo per poter aggiornare i corrispondenti
                        -- dell'ottica di destianazione
                        for d_record_struttura in (select *
                                                     from unita_organizzative u
                                                    where u.ottica = p_ottica_partenza
                                                      and trunc(sysdate) between u.dal and
                                                          nvl(decode(u.revisione_cessazione
                                                                    ,d_revisione_modifica
                                                                    ,null
                                                                    ,u.al)
                                                             ,to_date('3333333', 'j'))
                                                      and u.id_unita_padre is not null)
                        loop
                           -- seleziona il progressivo dell'unità padre nell'ottica di partenza
                           begin
                              select u.progr_unita_organizzativa
                               into d_puo
                               from unita_organizzative u
                              where u.ottica = p_ottica_partenza
                                and u.id_elemento = d_record_struttura.id_unita_padre;
                           exception
                              when others then
                                 if sqlcode between - 20999 and - 20900 then
                                    p_segnalazione := s_error_table(sqlcode);
                                 else
                                    p_segnalazione := 'Errore progressivo: ' || sqlerrm;
                                 end if;
                                 raise d_errore;
                           end;
                           -- recupera l'id_elemento dell'unità padre nell'ottica destinazione
                           begin
                              select u.id_elemento
                                into d_id_elemento
                                from unita_organizzative u
                               where u.ottica = p_ottica_destinazione
                                 and u.progr_unita_organizzativa = d_puo;
                           exception
                              when others then
                                 if sqlcode between - 20999 and - 20900 then
                                    p_segnalazione := s_error_table(sqlcode);
                                 else
                                    p_segnalazione := 'Errore id_elemento: ' || sqlerrm;
                                 end if;
                                 raise d_errore;
                           end;
                           -- aggiorna id_unita_padre per il corrispondente record del loop per l'ottica destinazione
                           update unita_organizzative u
                              set u.id_unita_padre = d_id_elemento
                            where u.ottica = p_ottica_destinazione
                              and u.progr_unita_organizzativa =
                                  d_record_struttura.progr_unita_organizzativa;
                        end loop;
            */
            -- se l'ottica è gestita a revisoni attiva la nuova revisione
            if d_gestione_revisioni = 'SI' then
               update revisioni_struttura r
                  set r.stato = 'A'
                where r.ottica = p_ottica_destinazione
                  and r.revisione = d_revisione_new;
            end if;
         else
            p_segnalazione := 'La duplicazione è possibile solamente se l''ottica di destinazione NON è istituzionale e se ottica
                         sorgente e destinazione fanno parte della stessa amministrazione';
            raise d_errore;
         end if;
         --p_segnalazione_bloccante := 'N';
         p_segnalazione := 'Duplicazione eseguita con successo!';
      exception
         when d_errore then
            rollback;
            p_segnalazione_bloccante := 'Y';
            p_segnalazione           := 'Duplicazione non eseguita' || chr(10) /*|| chr(13)*/
                                        || p_segnalazione;
         when others then
            rollback;
            p_segnalazione_bloccante := 'Y';
            p_segnalazione           := 'Duplicazione non eseguita' || chr(10) /*|| chr(13)*/
                                        || sqlerrm;
      end;
   end; -- unita_organizzativa.duplica_struttura
   --------------------------------------------------------------------------------
   procedure duplica_ottica
   (
      p_ottica_origine         in unita_organizzative.ottica%type
     ,p_ottica_derivata        in unita_organizzative.ottica%type
     ,p_data                   in unita_organizzative.dal%type
     ,p_duplica_assegnazioni   in varchar2 default 'NO'
     ,p_aggiornamento          in varchar2 default 'NO'
     ,p_tipo_agg_componenti    in varchar2 default 'N'
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        duplica_ottica
       DESCRIZIONE: Duplica la struttura esistente ed eventualmente le assegnazioni associate
                    ad un'ottica modello in un'ottica derivata
                    - Crea la nuova revisione
                    - Duplica UNITA_ORGANIZZATIVE
                    - Se richiesto, duplica le assegnazioni dell'ottica di origine come assegnazioni
                      funzionali sull'ottica derivata
                    La revisione risultante viene lasciata in stato di Modifica
       NOTE:        --
      ******************************************************************************/
      d_ottica_istituzionale  ottiche.ottica_istituzionale%type;
      d_ente_partenza         amministrazioni.codice_amministrazione%type;
      d_ente_destinazione     amministrazioni.codice_amministrazione%type;
      d_revisione_new         revisioni_struttura.revisione%type;
      d_record_struttura      unita_organizzative%rowtype;
      d_revisione_modifica    revisioni_struttura.revisione%type;
      d_revisione_da_inserire revisioni_struttura.revisione%type;
      d_data_da_inserire      unita_organizzative.dal%type;
      d_id_unita_padre        unita_organizzative.id_elemento%type;
      d_id_componente         componenti.id_componente%type := '';
      d_progr_padre           unita_organizzative.progr_unita_organizzativa%type;
      w_atco                  attributi_componente%rowtype;
      errore exception;
   begin
      begin
         d_ottica_istituzionale := ottica.get_ottica_istituzionale(p_ottica_derivata);
         d_ente_partenza        := ottica.get_amministrazione(p_ottica_origine);
         d_ente_destinazione    := ottica.get_amministrazione(p_ottica_derivata);
         -- la duplicazione è possibile solamente se l'ottica di destinazione NON è istituzionale e se le
         -- due ottiche fanno parte della stessa amministrazione
         if d_ottica_istituzionale = 'NO' and d_ente_partenza = d_ente_destinazione and
            p_tipo_agg_componenti in ('A', 'M', 'N') then
            -- Crea una nuova revisione in modifica con dal = parametro della procedure
            -- estrae la revisione più recente
            select max(r.revisione)
              into d_revisione_new
              from revisioni_struttura r
             where r.ottica = p_ottica_derivata;
            if d_revisione_new is null or p_aggiornamento = 'SI' then
               -- non esistono precedenti revisioni
               -- (o la duplica viene richiesta da revisioni_struttura.aggiorna_ottica)
               if d_revisione_new is null then
                  d_revisione_new := 1;
               else
                  d_revisione_new := d_revisione_new + 1;
               end if;
               revisione_struttura.ins(p_ottica               => p_ottica_derivata
                                      ,p_revisione            => d_revisione_new
                                      ,p_descrizione          => 'Revisione ' ||
                                                                 d_revisione_new ||
                                                                 ' per duplicazione struttura da ottica ' ||
                                                                 p_ottica_origine
                                      ,p_dal                  => p_data
                                      ,p_stato                => 'M'
                                      ,p_utente_aggiornamento => 'SO4'
                                      ,p_data_aggiornamento   => trunc(sysdate));
            else
               if revisione_struttura.esiste_revisione_mod(p_ottica_derivata
                                                          ,d_revisione_new) = 1 then
                  -- l'ultima revisione è quella in modifica
                  -- controllo se esistono attività precedenti
                  begin
                     select 'x'
                       into s_dummy
                       from unita_organizzative
                      where ottica = p_ottica_derivata
                        and (revisione = d_revisione_new or
                            revisione_cessazione = d_revisione_new);
                     raise too_many_rows;
                  exception
                     when too_many_rows then
                        p_segnalazione := 'Sono state già eseguite operazioni sull''attuale revisione in modifica';
                        raise errore;
                     when no_data_found then
                        null;
                  end;
               else
                  -- l'ultima revisione è attiva
                  p_segnalazione := 'Esistono precedenti revisioni attive: utilizzare la funzione di Aggiornamento';
                  raise errore;
               end if;
            end if;
            d_revisione_modifica := revisione_struttura.get_revisione_mod(p_ottica_origine);
            -- imposta revisione e dal: se l'ottica destinazione è gestita a revisioni
            -- i record vengono inseriti con la nuova revisione e dal nullo
            -- altrimenti con dal = parametro della procedure e revisione nulla
            d_revisione_da_inserire := d_revisione_new;
            d_data_da_inserire      := p_data;
            -- inserisce tutti i legami validi dell'ottica di partenza
            for d_record_struttura in (select *
                                         from unita_organizzative u
                                        where u.ottica = p_ottica_origine
                                          and dal <= nvl(al, to_date(3333333, 'j'))
                                          and nvl(revisione, -2) <> d_revisione_modifica --#406
                                          and p_data between u.dal and
                                              nvl(decode(u.revisione_cessazione
                                                        ,d_revisione_modifica
                                                        ,to_date(null)
                                                        ,u.al)
                                                 ,to_date('3333333', 'j'))
                                       connect by prior progr_unita_organizzativa =
                                                   id_unita_padre
                                              and ottica = p_ottica_origine
                                              and dal <= nvl(al, to_date(3333333, 'j')) --#406
                                              and p_data between u.dal and
                                                  nvl(decode(u.revisione_cessazione
                                                            ,d_revisione_modifica
                                                            ,to_date(null)
                                                            ,u.al)
                                                     ,to_date('3333333', 'j'))
                                        start with id_unita_padre is null
                                               and ottica = p_ottica_origine
                                               and dal <= nvl(al, to_date(3333333, 'j')) --#406
                                               and p_data between u.dal and
                                                   nvl(decode(u.revisione_cessazione
                                                             ,d_revisione_modifica
                                                             ,to_date(null)
                                                             ,u.al)
                                                      ,to_date('3333333', 'j'))
                                       /*order by nvl(id_unita_padre
                                           ,-progr_unita_organizzativa)
                                       ,id_elemento*/
                                       )
            loop

               unita_organizzativa.ins(p_id_elemento               => null
                                      ,p_ottica                    => p_ottica_derivata
                                      ,p_revisione                 => d_revisione_da_inserire
                                      ,p_sequenza                  => d_record_struttura.sequenza
                                      ,p_progr_unita_organizzativa => d_record_struttura.progr_unita_organizzativa
                                      ,p_id_unita_padre            => d_record_struttura.id_unita_padre
                                      ,p_revisione_cessazione      => null
                                      ,p_dal                       => d_data_da_inserire
                                      ,p_al                        => to_date(null)
                                      ,p_utente_aggiornamento      => 'SO4'
                                      ,p_data_aggiornamento        => sysdate);
            end loop;

            if p_duplica_assegnazioni = 'SI' then
               declare
                  w_atco attributi_componente%rowtype;
               begin
                  for comp_ist in (select *
                                     from componenti c
                                    where ottica = p_ottica_origine
                                      and dal <= nvl(al, to_date(3333333, 'j'))
                                      and nvl(revisione_assegnazione, -1) <>
                                          d_revisione_modifica --#406
                                      and d_data_da_inserire between dal and
                                          nvl(decode(nvl(c.revisione_cessazione, -1) --#541
                                                    ,d_revisione_modifica
                                                    ,to_date(null)
                                                    ,c.al)
                                             ,to_date('3333333', 'j'))
                                      and exists --#264
                                    (select 'x'
                                             from attributi_componente
                                            where id_componente = c.id_componente
                                              and dal <= nvl(al, to_date(3333333, 'j'))
                                              and d_data_da_inserire between dal and
                                                  nvl(al, to_date(3333333, 'j')))
                                    order by id_componente)
                  loop
                     begin
                        select *
                          into w_atco
                          from attributi_componente
                         where id_componente = comp_ist.id_componente
                           and dal <= nvl(al, to_date(3333333, 'j')) --#406
                           and d_data_da_inserire between dal and
                               nvl(al, to_date(3333333, 'j'));
                        select componenti_sq.nextval into d_id_componente from dual;
                        componente.ins(p_id_componente             => d_id_componente
                                      ,p_progr_unita_organizzativa => comp_ist.progr_unita_organizzativa
                                      ,p_dal                       => d_data_da_inserire
                                      ,p_al                        => comp_ist.al
                                      ,p_ni                        => comp_ist.ni
                                      ,p_ci                        => comp_ist.ci
                                      ,p_codice_fiscale            => comp_ist.codice_fiscale
                                      ,p_denominazione             => comp_ist.denominazione
                                      ,p_denominazione_al1         => comp_ist.denominazione_al1
                                      ,p_denominazione_al2         => comp_ist.denominazione_al2
                                      ,p_stato                     => 'P'
                                      ,p_ottica                    => p_ottica_derivata
                                      ,p_revisione_assegnazione    => d_revisione_new
                                      ,p_revisione_cessazione      => ''
                                      ,p_utente_aggiornamento      => 'Dup.Rev'
                                      ,p_data_aggiornamento        => sysdate);
                        attributo_componente.ins(p_id_attr_componente      => ''
                                                ,p_id_componente           => d_id_componente
                                                ,p_dal                     => d_data_da_inserire
                                                ,p_al                      => w_atco.al
                                                ,p_incarico                => w_atco.incarico
                                                ,p_telefono                => w_atco.telefono
                                                ,p_fax                     => w_atco.fax
                                                ,p_e_mail                  => w_atco.e_mail
                                                ,p_assegnazione_prevalente => 88
                                                ,p_tipo_assegnazione       => 'F'
                                                ,p_percentuale_impiego     => w_atco.percentuale_impiego
                                                ,p_ottica                  => p_ottica_derivata
                                                ,p_revisione_assegnazione  => d_revisione_new
                                                ,p_revisione_cessazione    => ''
                                                ,p_gradazione              => w_atco.gradazione
                                                ,p_utente_aggiornamento    => 'Dup.Rev'
                                                ,p_data_aggiornamento      => sysdate
                                                ,p_voto                    => w_atco.voto);
                     exception
                        when others then
                           if sqlcode between - 20999 and - 20900 then
                              p_segnalazione := s_error_table(sqlcode);
                           else
                              p_segnalazione := 'Errore inserimento componente NI: ' ||
                                                comp_ist.ni || sqlerrm;
                           end if;
                           raise errore;
                     end;
                  end loop;
               end;
            end if;
         elsif p_tipo_agg_componenti not in ('A', 'M', 'N') then
            p_segnalazione := 'Il tipo di aggiornamento dei componenti può assumere solo i valori ''M'' (Manuale), ''A'' (Automatico), ''N'' (Nessun aggiornamento)';
         else
            p_segnalazione := 'La duplicazione è possibile solamente se l''ottica derivata NON è istituzionale e se ottica
                         di origine e destinazione fanno parte della stessa amministrazione';
            raise errore;
         end if;
         -- aggiorna l'ottica derivata registrando l'ottica di origine utilizzata
         update ottiche
            set ottica_origine           = p_ottica_origine
               ,aggiornamento_componenti = p_tipo_agg_componenti
          where ottica = p_ottica_derivata;
         p_segnalazione := 'Duplicazione eseguita con successo!';
      exception
         when errore then
            rollback;
            p_segnalazione_bloccante := 'Y';
            p_segnalazione           := 'Duplicazione non eseguita' || chr(10) /*|| chr(13)*/
                                        || p_segnalazione;
         when others then
            rollback;
            p_segnalazione_bloccante := 'Y';
            p_segnalazione           := 'Duplicazione non eseguita' || chr(10) /*|| chr(13)*/
                                        || sqlerrm;
      end;
   end; -- unita_organizzativa.duplica_ottica
   --------------------------------------------------------------------------------
   procedure elimina_assegnazioni
   (
      p_ottica                 in unita_organizzative.ottica%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        elimina_assegnazioni
       DESCRIZIONE: Elimina le assegnazioni relative all'ottica data istituite con la revisione in modifica
                    - determina la revisione in modifica
                    - elimina le assegnazioni
                    - ripristina le assegnazioni cessate con la revisione in modifica
       NOTE:        --
      ******************************************************************************/
      d_revisione_modifica revisioni_struttura.revisione%type;
      errore_revisione    exception;
      errore_assegnazioni exception;
   begin
      -- determina la revisione in modifica
      d_revisione_modifica := revisione_struttura.get_revisione_mod(p_ottica);
      if d_revisione_modifica = -1 then
         raise errore_revisione;
      end if;
      -- elimina le assegnazioni istituite con la revisione in modifica
      for elimina_comp in (select id_componente
                                 ,ni
                             from componenti c
                            where c.revisione_assegnazione = d_revisione_modifica
                              and ottica = p_ottica
                            order by id_componente desc)
      loop
         begin
            componente.del(elimina_comp.id_componente);
         exception
            when others then
               if sqlcode between - 20999 and - 20900 then
                  p_segnalazione := s_error_table(sqlcode);
               else
                  p_segnalazione := 'Errore eliminazione componente NI: ' ||
                                    elimina_comp.ni || sqlerrm;
               end if;
               raise errore_assegnazioni;
         end;
      end loop;
      -- ripristina le assegnazioni cessate con la revisione in modifica
      for ripristina_comp in (select id_componente
                                    ,ni
                                from componenti c
                               where c.revisione_cessazione = d_revisione_modifica
                                 and ottica = p_ottica
                               order by id_componente)
      loop
         begin
            update componenti
               set revisione_cessazione = ''
             where id_componente = ripristina_comp.id_componente;
         exception
            when others then
               if sqlcode between - 20999 and - 20900 then
                  p_segnalazione := s_error_table(sqlcode);
               else
                  p_segnalazione := 'Errore ripristino componente NI: ' ||
                                    ripristina_comp.ni || '; ' || sqlerrm;
               end if;
               raise errore_assegnazioni;
         end;
      end loop;
      p_segnalazione := 'Eliminazione eseguita con successo';
   exception
      when errore_revisione then
         rollback;
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Non esiste una revisione in modifica; eliminazione non eseguita' ||
                                     chr(10) || p_segnalazione;
      when errore_assegnazioni then
         rollback;
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := p_segnalazione || chr(10) ||
                                     '; eliminazione non eseguita';
      when others then
         rollback;
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Eliminazione non eseguita' || chr(10) || sqlerrm;
   end elimina_assegnazioni;
   --------------------------------------------------------------------------------
   procedure elimina_struttura
   (
      p_ottica                 in unita_organizzative.ottica%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        elimina_assegnazioni
       DESCRIZIONE: Elimina la struttura relativa all'ottica data
                    - determina la revisione in modifica
                    - elimina le assegnazioni
                    - ripristina le assegnazioni cessate con la revisione in modifica
                    - elimina la struttura
                    - ripristina la struttura e le UO eliminate con la revisione in modifica
       NOTE:        --
      ******************************************************************************/
      d_revisione_modifica revisioni_struttura.revisione%type;
      errore_revisione    exception;
      errore_assegnazioni exception;
      errore_relazioni    exception;
      errore_anagrafe     exception;
   begin
      -- determina la revisione in modifica
      d_revisione_modifica := revisione_struttura.get_revisione_mod(p_ottica);
      if d_revisione_modifica = -1 then
         raise errore_revisione;
      end if;
      -- elimina le assegnazioni istituite con la revisione in modifica
      elimina_assegnazioni(p_ottica, p_segnalazione_bloccante, p_segnalazione);
      if p_segnalazione_bloccante = 'Y' then
         raise errore_assegnazioni;
      end if;
      -- elimina le relazioni istituite con la revisione in modifica
      for elimina_unor in ( /*select id_elemento
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ,progr_unita_organizzativa
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           from unita_organizzative u
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          where u.revisione = d_revisione_modifica
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            and ottica = p_ottica
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         connect by prior id_elemento = id_unita_padre
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          start with id_unita_padre is null
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          order by level desc
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  ,id_elemento*/
                           select level
                                  ,id_elemento
                                  ,progr_unita_organizzativa
                             from unita_organizzative u
                            where u.revisione = d_revisione_modifica
                              and ottica = p_ottica
                           connect by prior progr_unita_organizzativa = id_unita_padre
                                  and ottica = p_ottica
                                  and revisione = d_revisione_modifica
                            start with id_unita_padre is null
                                   and ottica = p_ottica
                                   and revisione = d_revisione_modifica
                            order by level       desc
                                     ,id_elemento desc)
      loop
         begin

            unita_organizzativa.del(elimina_unor.id_elemento);
         exception
            when others then
               if sqlcode between - 20999 and - 20900 then
                  p_segnalazione := s_error_table(sqlcode);
               else
                  p_segnalazione := 'Errore eliminazione progressivo : ' ||
                                    elimina_unor.progr_unita_organizzativa || sqlerrm;
               end if;
               raise errore_relazioni;
         end;
      end loop;
      -- ripristina le relazioni cessate con la revisione in modifica
      for ripristina_unor in (select id_elemento
                                    ,progr_unita_organizzativa
                                from unita_organizzative u
                               where u.revisione_cessazione = d_revisione_modifica
                                 and ottica = p_ottica
                               order by id_elemento)
      loop
         begin
            update unita_organizzative
               set revisione_cessazione = ''
             where id_elemento = ripristina_unor.id_elemento;
         exception
            when others then
               if sqlcode between - 20999 and - 20900 then
                  p_segnalazione := s_error_table(sqlcode);
               else
                  p_segnalazione := 'Errore ripristino progressivo : ' ||
                                    ripristina_unor.progr_unita_organizzativa || sqlerrm;
               end if;
               raise errore_relazioni;
         end;
      end loop;
      -- elimina le unita' organizzative istituite con la revisione in modifica
      for elimina_anuo in (select a.progr_unita_organizzativa
                                 ,a.dal
                             from anagrafe_unita_organizzative a
                            where a.revisione_istituzione = d_revisione_modifica
                              and ottica = p_ottica
                            order by a.progr_unita_organizzativa
                                    ,a.dal)
      loop
         begin
            anagrafe_unita_organizzativa.del(elimina_anuo.progr_unita_organizzativa
                                            ,elimina_anuo.dal);
         exception
            when others then
               if sqlcode between - 20999 and - 20900 then
                  p_segnalazione := s_error_table(sqlcode);
               else
                  p_segnalazione := 'Errore eliminazione progressivo : ' ||
                                    elimina_anuo.progr_unita_organizzativa || sqlerrm;
               end if;
               raise errore_anagrafe;
         end;
      end loop;
      -- ripristina le unita' organizzative cessate con la revisione in modifica
      for ripristina_anuo in (select a.progr_unita_organizzativa
                                    ,a.dal
                                from anagrafe_unita_organizzative a
                               where a.revisione_cessazione = d_revisione_modifica
                                 and ottica = p_ottica
                               order by a.progr_unita_organizzativa
                                       ,a.dal)
      loop
         begin
            update unita_organizzative
               set revisione_cessazione = ''
                  ,al                   = null
             where progr_unita_organizzativa = ripristina_anuo.progr_unita_organizzativa
               and dal = ripristina_anuo.dal;
         exception
            when others then
               if sqlcode between - 20999 and - 20900 then
                  p_segnalazione := s_error_table(sqlcode);
               else
                  p_segnalazione := 'Errore ripristino progressivo : ' ||
                                    ripristina_anuo.progr_unita_organizzativa || sqlerrm;
               end if;
               raise errore_anagrafe;
         end;
      end loop;
      p_segnalazione := 'Eliminazione eseguita con successo';
      -- elimina la struttura
   exception
      when errore_revisione then
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Non esiste una revisione in modifica; eliminazione non eseguita' ||
                                     chr(10) || p_segnalazione;
      when errore_assegnazioni then
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Errore durante l''eliminazione delle assegnazioni ' ||
                                     chr(10) || p_segnalazione;
      when errore_relazioni then
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Errore durante l''eliminazione delle relazioni ' ||
                                     chr(10) || p_segnalazione;
      when errore_anagrafe then
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Errore durante l''eliminazione dell''anagrafe UO ' ||
                                     chr(10) || p_segnalazione;
      when others then
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Eliminazione non eseguita' || chr(10) || sqlerrm;
   end elimina_struttura;
   --------------------------------------------------------------------------------
begin
   -- inserimento degli errori nella tabella
   s_error_table(s_dal_al_errato_number) := s_dal_al_errato_msg;
   s_error_table(s_dal_errato_number) := s_dal_errato_msg;
   s_error_table(s_dal_errato_ins_number) := s_dal_errato_ins_msg;
   s_error_table(s_al_errato_number) := s_al_errato_msg;
   s_error_table(s_legami_istituiti_number) := s_legami_istituiti_msg;
   s_error_table(s_legami_cessati_number) := s_legami_cessati_msg;
   s_error_table(s_componenti_non_ass_number) := s_componenti_non_ass_msg;
   s_error_table(s_unita_presente_number) := s_unita_presente_msg;
   s_error_table(s_errore_lettura_unor_number) := s_errore_lettura_unor_msg;
   s_error_table(s_sequenza_non_disp_number) := s_sequenza_non_disp_msg;
   s_error_table(s_date_non_congruenti_number) := s_date_non_congruenti_msg;
   s_error_table(s_esiste_periodo_succ_number) := s_esiste_periodo_succ_msg;
   s_error_table(s_incongr_periodo_prec_number) := s_incongr_periodo_prec_msg;
   s_error_table(s_incongr_periodo_succ_number) := s_incongr_periodo_succ_msg;
   s_error_table(s_esistono_unita_figlie_number) := s_esistono_unita_figlie_msg;
   s_error_table(s_esistono_componenti_number) := s_esistono_componenti_msg;
   s_error_table(s_revisioni_errate_num) := s_revisioni_errate_msg;
   s_error_table(s_estrazione_puo_num) := s_estrazione_puo_msg;
   s_error_table(s_estrazione_id_elemento_num) := s_estrazione_id_elemento_msg;
   s_error_table(s_duplicazione_errore_num) := s_duplicazione_errore_msg;
end unita_organizzativa;
/

