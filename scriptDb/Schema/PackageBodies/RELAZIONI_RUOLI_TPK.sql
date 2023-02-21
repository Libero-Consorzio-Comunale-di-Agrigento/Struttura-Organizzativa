CREATE OR REPLACE package body relazioni_ruoli_tpk is
   /******************************************************************************
    NOME:        relazioni_ruoli_tpk
    DESCRIZIONE: Gestione tabella RELAZIONI_RUOLI.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore      Descrizione.
    000   18/08/2015  mmonari  Generazione automatica. 
   ******************************************************************************/
   s_revisione_body constant afc.t_revision := '000 - 18/08/2015';
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
   end versione; -- relazioni_ruoli_tpk.versione
   --------------------------------------------------------------------------------
   function pk(p_id_relazione in relazioni_ruoli.id_relazione%type) return t_pk is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        PK
       DESCRIZIONE: Costruttore di un t_PK dati gli attributi della note
      ******************************************************************************/
      d_result t_pk;
   begin
      d_result.id_relazione := p_id_relazione;
      dbc.pre(not dbc.preon or canhandle(p_id_relazione => d_result.id_relazione)
             ,'canHandle on relazioni_ruoli_tpk.PK');
      return d_result;
   end pk; -- relazioni_ruoli_tpk.PK
   --------------------------------------------------------------------------------
   function can_handle(p_id_relazione in relazioni_ruoli.id_relazione%type) return number is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        can_handle
       DESCRIZIONE: La note specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi note.
       RITORNA:     number: 1 se la note e manipolabile, 0 altrimenti.
       NOTE:        cfr. canHandle per ritorno valori boolean.
      ******************************************************************************/
      d_result number;
   begin
      d_result := 1;
      -- nelle chiavi primarie composte da piu attributi, ciascun attributo deve essere not null
      if d_result = 1 and (p_id_relazione is null) then
         d_result := 0;
      end if;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on relazioni_ruoli_tpk.can_handle');
      return d_result;
   end can_handle; -- relazioni_ruoli_tpk.can_handle
   --------------------------------------------------------------------------------
   function canhandle(p_id_relazione in relazioni_ruoli.id_relazione%type) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        canHandle
       DESCRIZIONE: La note specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi note.
       RITORNA:     number: true se la note e manipolabile, false altrimenti.
       NOTE:        Wrapper boolean di can_handle (cfr. can_handle).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(can_handle(p_id_relazione => p_id_relazione));
   begin
      return d_result;
   end canhandle; -- relazioni_ruoli_tpk.canHandle
   --------------------------------------------------------------------------------
   function exists_id(p_id_relazione in relazioni_ruoli.id_relazione%type) return number is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        exists_id
       DESCRIZIONE: Esistenza riga con note indicata.
       PARAMETRI:   Attributi note.
       RITORNA:     number: 1 se la riga esiste, 0 altrimenti.
       NOTE:        cfr. existsId per ritorno valori boolean.
      ******************************************************************************/
      d_result number;
   begin
      dbc.pre(not dbc.preon or canhandle(p_id_relazione => p_id_relazione)
             ,'canHandle on relazioni_ruoli_tpk.exists_id');
      begin
         select 1 into d_result from relazioni_ruoli where id_relazione = p_id_relazione;
      exception
         when no_data_found then
            d_result := 0;
      end;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on relazioni_ruoli_tpk.exists_id');
      return d_result;
   end exists_id; -- relazioni_ruoli_tpk.exists_id
   --------------------------------------------------------------------------------
   function existsid(p_id_relazione in relazioni_ruoli.id_relazione%type) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        existsId
       DESCRIZIONE: Esistenza riga con note indicata.
       NOTE:        Wrapper boolean di exists_id (cfr. exists_id).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(exists_id(p_id_relazione => p_id_relazione));
   begin
      return d_result;
   end existsid; -- relazioni_ruoli_tpk.existsId
   --------------------------------------------------------------------------------
   procedure ins
   (
      p_id_relazione   in relazioni_ruoli.id_relazione%type default null
     ,p_ottica         in relazioni_ruoli.ottica%type default '%'
     ,p_codice_uo      in relazioni_ruoli.codice_uo%type default '%'
     ,p_uo_discendenti in relazioni_ruoli.uo_discendenti%type default 'NO'
     ,p_suddivisione   in relazioni_ruoli.suddivisione%type default '%'
     ,p_incarico       in relazioni_ruoli.incarico%type default '%'
     ,p_responsabile   in relazioni_ruoli.responsabile%type default '%'
     ,p_dipendente     in relazioni_ruoli.dipendente%type default '%'
     ,p_note           in relazioni_ruoli.note%type
     ,p_ruolo          in relazioni_ruoli.ruolo%type
   ) is
      /******************************************************************************
       NOME:        ins
       DESCRIZIONE: Inserimento di una riga con note e attributi indicati.
       PARAMETRI:   Chiavi e attributi della table.
      ******************************************************************************/
   begin
      insert into relazioni_ruoli
         (id_relazione
         ,ottica
         ,codice_uo
         ,uo_discendenti
         ,suddivisione
         ,incarico
         ,responsabile
         ,dipendente
         ,note
         ,ruolo)
      values
         (p_id_relazione
         ,nvl(p_ottica, '%')
         ,nvl(p_codice_uo, '%')
         ,nvl(p_uo_discendenti, 'NO')
         ,nvl(p_suddivisione, '%')
         ,nvl(p_incarico, '%')
         ,nvl(p_responsabile, '%')
         ,nvl(p_dipendente, '%')
         ,p_note
         ,p_ruolo);
   end ins; -- relazioni_ruoli_tpk.ins
   --------------------------------------------------------------------------------
   function ins
   (
      p_id_relazione   in relazioni_ruoli.id_relazione%type default null
     ,p_ottica         in relazioni_ruoli.ottica%type default '%'
     ,p_codice_uo      in relazioni_ruoli.codice_uo%type default '%'
     ,p_uo_discendenti in relazioni_ruoli.uo_discendenti%type default 'NO'
     ,p_suddivisione   in relazioni_ruoli.suddivisione%type default '%'
     ,p_incarico       in relazioni_ruoli.incarico%type default '%'
     ,p_responsabile   in relazioni_ruoli.responsabile%type default '%'
     ,p_dipendente     in relazioni_ruoli.dipendente%type default '%'
     ,p_note           in relazioni_ruoli.note%type
     ,p_ruolo          in relazioni_ruoli.ruolo%type
   ) return number
   /******************************************************************************
       NOME:        ins
       DESCRIZIONE: Inserimento di una riga con note e attributi indicati.
       PARAMETRI:   Chiavi e attributi della table.
       RITORNA:     In caso di PK formata da colonna numerica, ritorna il valore della PK
                    (se positivo), in tutti gli altri casi ritorna 0; in caso di errore,
                    ritorna il codice di errore
      ******************************************************************************/
    is
      d_result number;
   begin
      insert into relazioni_ruoli
         (id_relazione
         ,ottica
         ,codice_uo
         ,uo_discendenti
         ,suddivisione
         ,incarico
         ,responsabile
         ,dipendente
         ,note
         ,ruolo)
      values
         (p_id_relazione
         ,nvl(p_ottica, '%')
         ,nvl(p_codice_uo, '%')
         ,nvl(p_uo_discendenti, 'NO')
         ,nvl(p_suddivisione, '%')
         ,nvl(p_incarico, '%')
         ,nvl(p_responsabile, '%')
         ,nvl(p_dipendente, '%')
         ,p_note
         ,p_ruolo)
      returning id_relazione into d_result;
      return d_result;
   end ins; -- relazioni_ruoli_tpk.ins
   --------------------------------------------------------------------------------
   procedure upd
   (
      p_check_old          in integer default 0
     ,p_new_id_relazione   in relazioni_ruoli.id_relazione%type
     ,p_old_id_relazione   in relazioni_ruoli.id_relazione%type default null
     ,p_new_ottica         in relazioni_ruoli.ottica%type default afc.default_null('RELAZIONI_RUOLI.ottica')
     ,p_old_ottica         in relazioni_ruoli.ottica%type default null
     ,p_new_codice_uo      in relazioni_ruoli.codice_uo%type default afc.default_null('RELAZIONI_RUOLI.codice_uo')
     ,p_old_codice_uo      in relazioni_ruoli.codice_uo%type default null
     ,p_new_uo_discendenti in relazioni_ruoli.uo_discendenti%type default afc.default_null('RELAZIONI_RUOLI.uo_discendenti')
     ,p_old_uo_discendenti in relazioni_ruoli.uo_discendenti%type default null
     ,p_new_suddivisione   in relazioni_ruoli.suddivisione%type default afc.default_null('RELAZIONI_RUOLI.suddivisione')
     ,p_old_suddivisione   in relazioni_ruoli.suddivisione%type default null
     ,p_new_incarico       in relazioni_ruoli.incarico%type default afc.default_null('RELAZIONI_RUOLI.incarico')
     ,p_old_incarico       in relazioni_ruoli.incarico%type default null
     ,p_new_responsabile   in relazioni_ruoli.responsabile%type default afc.default_null('RELAZIONI_RUOLI.responsabile')
     ,p_old_responsabile   in relazioni_ruoli.responsabile%type default null
     ,p_new_dipendente     in relazioni_ruoli.dipendente%type default afc.default_null('RELAZIONI_RUOLI.dipendente')
     ,p_old_dipendente     in relazioni_ruoli.dipendente%type default null
     ,p_new_note           in relazioni_ruoli.note%type default afc.default_null('RELAZIONI_RUOLI.note')
     ,p_old_note           in relazioni_ruoli.note%type default null
     ,p_new_ruolo          in relazioni_ruoli.ruolo%type default afc.default_null('RELAZIONI_RUOLI.ruolo')
     ,p_old_ruolo          in relazioni_ruoli.ruolo%type default null
   ) is
      /******************************************************************************
       NOME:        upd
       DESCRIZIONE: Aggiornamento di una riga con note.
       PARAMETRI:   Chiavi e attributi della table
                    p_check_OLD: 0    , ricerca senza controllo su attributi precedenti
                                 1    , ricerca con controllo su tutti gli attributi precedenti.
                                 null , ricerca con controllo sui soli attributi precedenti passati.
       NOTE:        Nel caso in cui non venga elaborato alcun record viene lanciata
                    l'eccezione -20010 (cfr. AFC_ERROR).
                    Se p_check_old e NULL, gli attributi vengono annullati solo se viene
                    indicato anche il relativo attributo OLD.
                    Se p_check_old = 1, viene controllato se il record corrispondente a
                    tutti i campi passati come parametri esiste nella tabella.
                    Se p_check_old e NULL, viene controllato se il record corrispondente
                    ai soli campi passati come parametri esiste nella tabella.
      ******************************************************************************/
      d_key       t_pk;
      d_row_found number;
   begin
      d_key := pk(nvl(p_old_id_relazione, p_new_id_relazione));
      update relazioni_ruoli
         set id_relazione   = nvl(p_new_id_relazione
                                 ,decode(afc.is_default_null('RELAZIONI_RUOLI.id_relazione')
                                        ,1
                                        ,id_relazione
                                        ,decode(p_check_old
                                               ,0
                                               ,null
                                               ,decode(p_old_id_relazione
                                                      ,null
                                                      ,id_relazione
                                                      ,null))))
            ,ottica         = nvl(p_new_ottica
                                 ,decode(afc.is_default_null('RELAZIONI_RUOLI.ottica')
                                        ,1
                                        ,ottica
                                        ,decode(p_check_old
                                               ,0
                                               ,null
                                               ,decode(p_old_ottica, null, ottica, null))))
            ,codice_uo      = nvl(p_new_codice_uo
                                 ,decode(afc.is_default_null('RELAZIONI_RUOLI.codice_uo')
                                        ,1
                                        ,codice_uo
                                        ,decode(p_check_old
                                               ,0
                                               ,null
                                               ,decode(p_old_codice_uo
                                                      ,null
                                                      ,codice_uo
                                                      ,null))))
            ,uo_discendenti = nvl(p_new_uo_discendenti
                                 ,decode(afc.is_default_null('RELAZIONI_RUOLI.uo_discendenti')
                                        ,1
                                        ,uo_discendenti
                                        ,decode(p_check_old
                                               ,0
                                               ,null
                                               ,decode(p_old_uo_discendenti
                                                      ,null
                                                      ,uo_discendenti
                                                      ,null))))
            ,suddivisione   = nvl(p_new_suddivisione
                                 ,decode(afc.is_default_null('RELAZIONI_RUOLI.suddivisione')
                                        ,1
                                        ,suddivisione
                                        ,decode(p_check_old
                                               ,0
                                               ,null
                                               ,decode(p_old_suddivisione
                                                      ,null
                                                      ,suddivisione
                                                      ,null))))
            ,incarico       = nvl(p_new_incarico
                                 ,decode(afc.is_default_null('RELAZIONI_RUOLI.incarico')
                                        ,1
                                        ,incarico
                                        ,decode(p_check_old
                                               ,0
                                               ,null
                                               ,decode(p_old_incarico
                                                      ,null
                                                      ,incarico
                                                      ,null))))
            ,responsabile   = nvl(p_new_responsabile
                                 ,decode(afc.is_default_null('RELAZIONI_RUOLI.responsabile')
                                        ,1
                                        ,responsabile
                                        ,decode(p_check_old
                                               ,0
                                               ,null
                                               ,decode(p_old_responsabile
                                                      ,null
                                                      ,responsabile
                                                      ,null))))
            ,dipendente     = nvl(p_new_dipendente
                                 ,decode(afc.is_default_null('RELAZIONI_RUOLI.dipendente')
                                        ,1
                                        ,dipendente
                                        ,decode(p_check_old
                                               ,0
                                               ,null
                                               ,decode(p_old_dipendente
                                                      ,null
                                                      ,dipendente
                                                      ,null))))
            ,note           = nvl(p_new_note
                                 ,decode(afc.is_default_null('RELAZIONI_RUOLI.note')
                                        ,1
                                        ,note
                                        ,decode(p_check_old
                                               ,0
                                               ,null
                                               ,decode(p_old_note, null, note, null))))
            ,ruolo          = nvl(p_new_ruolo
                                 ,decode(afc.is_default_null('RELAZIONI_RUOLI.ruolo')
                                        ,1
                                        ,ruolo
                                        ,decode(p_check_old
                                               ,0
                                               ,null
                                               ,decode(p_old_ruolo, null, ruolo, null))))
       where id_relazione = d_key.id_relazione
         and (p_check_old = 0 or
             (1 = 1 and
             (ottica = p_old_ottica or
             (p_old_ottica is null and (p_check_old is null or ottica is null))) and
             (codice_uo = p_old_codice_uo or
             (p_old_codice_uo is null and (p_check_old is null or codice_uo is null))) and
             (uo_discendenti = p_old_uo_discendenti or
             (p_old_uo_discendenti is null and
             (p_check_old is null or uo_discendenti is null))) and
             (suddivisione = p_old_suddivisione or
             (p_old_suddivisione is null and
             (p_check_old is null or suddivisione is null))) and
             (incarico = p_old_incarico or
             (p_old_incarico is null and (p_check_old is null or incarico is null))) and
             (responsabile = p_old_responsabile or
             (p_old_responsabile is null and
             (p_check_old is null or responsabile is null))) and
             (dipendente = p_old_dipendente or
             (p_old_dipendente is null and (p_check_old is null or dipendente is null))) and
             (note = p_old_note or
             (p_old_note is null and (p_check_old is null or note is null))) and
             (ruolo = p_old_ruolo or
             (p_old_ruolo is null and (p_check_old is null or ruolo is null)))));
      d_row_found := sql%rowcount;
      afc.default_null(null);
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on relazioni_ruoli_tpk.upd');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   end upd; -- relazioni_ruoli_tpk.upd
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_id_relazione  in relazioni_ruoli.id_relazione%type
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
      if p_literal_value = 1 or p_literal_value is null then
         d_literal := '''';
      end if;
      d_statement := ' declare ' || '    d_row_found number; ' || ' begin ' ||
                     '    update RELAZIONI_RUOLI ' || '       set ' || p_column || ' = ' ||
                     d_literal || p_value || d_literal || '     where 1 = 1 ' ||
                     nvl(afc.get_field_condition(' and ( id_relazione '
                                                ,p_id_relazione
                                                ,' )'
                                                ,0
                                                ,null)
                        ,' and ( id_relazione is null ) ') || '    ; ' ||
                     '    d_row_found := SQL%ROWCOUNT; ' || '    if d_row_found < 1 ' ||
                     '    then ' ||
                     '       raise_application_error ( AFC_ERROR.modified_by_other_user_number, AFC_ERROR.modified_by_other_user_msg ); ' ||
                     '    end if; ' || ' end; ';
      afc.sql_execute(d_statement);
   end upd_column; -- relazioni_ruoli_tpk.upd_column
   --------------------------------------------------------------------------------
   procedure del
   (
      p_check_old      in integer default 0
     ,p_id_relazione   in relazioni_ruoli.id_relazione%type
     ,p_ottica         in relazioni_ruoli.ottica%type default null
     ,p_codice_uo      in relazioni_ruoli.codice_uo%type default null
     ,p_uo_discendenti in relazioni_ruoli.uo_discendenti%type default null
     ,p_suddivisione   in relazioni_ruoli.suddivisione%type default null
     ,p_incarico       in relazioni_ruoli.incarico%type default null
     ,p_responsabile   in relazioni_ruoli.responsabile%type default null
     ,p_dipendente     in relazioni_ruoli.dipendente%type default null
     ,p_note           in relazioni_ruoli.note%type default null
     ,p_ruolo          in relazioni_ruoli.ruolo%type default null
   ) is
      /******************************************************************************
       NOME:        del
       DESCRIZIONE: Cancellazione della riga indicata.
       PARAMETRI:   Chiavi e attributi della table
                    p_check_OLD: 0    , ricerca senza controllo su attributi precedenti
                                 1    , ricerca con controllo su tutti gli attributi precedenti.
                                 null , ricerca con controllo sui soli attributi precedenti passati.
       NOTE:        Nel caso in cui non venga elaborato alcun record viene lanciata
                    l'eccezione -20010 (cfr. AFC_ERROR).
                    Se p_check_old = 1, viene controllato se il record corrispondente a
                    tutti i campi passati come parametri esiste nella tabella.
                    Se p_check_old e NULL, viene controllato se il record corrispondente
                    ai soli campi passati come parametri esiste nella tabella.
      ******************************************************************************/
      d_row_found number;
   begin
      delete from relazioni_ruoli
       where id_relazione = p_id_relazione
         and (p_check_old = 0 or
             (1 = 1 and (ottica = p_ottica or
             (p_ottica is null and (p_check_old is null or ottica is null))) and
             (codice_uo = p_codice_uo or
             (p_codice_uo is null and (p_check_old is null or codice_uo is null))) and
             (uo_discendenti = p_uo_discendenti or
             (p_uo_discendenti is null and
             (p_check_old is null or uo_discendenti is null))) and
             (suddivisione = p_suddivisione or
             (p_suddivisione is null and (p_check_old is null or suddivisione is null))) and
             (incarico = p_incarico or
             (p_incarico is null and (p_check_old is null or incarico is null))) and
             (responsabile = p_responsabile or
             (p_responsabile is null and (p_check_old is null or responsabile is null))) and
             (dipendente = p_dipendente or
             (p_dipendente is null and (p_check_old is null or dipendente is null))) and
             (note = p_note or
             (p_note is null and (p_check_old is null or note is null))) and
             (ruolo = p_ruolo or
             (p_ruolo is null and (p_check_old is null or ruolo is null)))));
      d_row_found := sql%rowcount;
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
      dbc.post(not dbc.poston or not existsid(p_id_relazione => p_id_relazione)
              ,'existsId on relazioni_ruoli_tpk.del');
   end del; -- relazioni_ruoli_tpk.del
   --------------------------------------------------------------------------------
   function get_ottica(p_id_relazione in relazioni_ruoli.id_relazione%type)
      return relazioni_ruoli.ottica%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_ottica
       DESCRIZIONE: Getter per attributo ottica di riga identificata dalla note.
       PARAMETRI:   Attributi note.
       RITORNA:     RELAZIONI_RUOLI.ottica%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result relazioni_ruoli.ottica%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_relazione => p_id_relazione)
             ,'existsId on relazioni_ruoli_tpk.get_ottica');
      select ottica
        into d_result
        from relazioni_ruoli
       where id_relazione = p_id_relazione;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on relazioni_ruoli_tpk.get_ottica');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'ottica')
                      ,' AFC_DDL.IsNullable on relazioni_ruoli_tpk.get_ottica');
      end if;
      return d_result;
   end get_ottica; -- relazioni_ruoli_tpk.get_ottica
   --------------------------------------------------------------------------------
   function get_codice_uo(p_id_relazione in relazioni_ruoli.id_relazione%type)
      return relazioni_ruoli.codice_uo%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_codice_uo
       DESCRIZIONE: Getter per attributo codice_uo di riga identificata dalla note.
       PARAMETRI:   Attributi note.
       RITORNA:     RELAZIONI_RUOLI.codice_uo%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result relazioni_ruoli.codice_uo%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_relazione => p_id_relazione)
             ,'existsId on relazioni_ruoli_tpk.get_codice_uo');
      select codice_uo
        into d_result
        from relazioni_ruoli
       where id_relazione = p_id_relazione;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on relazioni_ruoli_tpk.get_codice_uo');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'codice_uo')
                      ,' AFC_DDL.IsNullable on relazioni_ruoli_tpk.get_codice_uo');
      end if;
      return d_result;
   end get_codice_uo; -- relazioni_ruoli_tpk.get_codice_uo
   --------------------------------------------------------------------------------
   function get_uo_discendenti(p_id_relazione in relazioni_ruoli.id_relazione%type)
      return relazioni_ruoli.uo_discendenti%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_uo_discendenti
       DESCRIZIONE: Getter per attributo uo_discendenti di riga identificata dalla note.
       PARAMETRI:   Attributi note.
       RITORNA:     RELAZIONI_RUOLI.uo_discendenti%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result relazioni_ruoli.uo_discendenti%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_relazione => p_id_relazione)
             ,'existsId on relazioni_ruoli_tpk.get_uo_discendenti');
      select uo_discendenti
        into d_result
        from relazioni_ruoli
       where id_relazione = p_id_relazione;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on relazioni_ruoli_tpk.get_uo_discendenti');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'uo_discendenti')
                      ,' AFC_DDL.IsNullable on relazioni_ruoli_tpk.get_uo_discendenti');
      end if;
      return d_result;
   end get_uo_discendenti; -- relazioni_ruoli_tpk.get_uo_discendenti
   --------------------------------------------------------------------------------
   function get_suddivisione(p_id_relazione in relazioni_ruoli.id_relazione%type)
      return relazioni_ruoli.suddivisione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_suddivisione
       DESCRIZIONE: Getter per attributo suddivisione di riga identificata dalla note.
       PARAMETRI:   Attributi note.
       RITORNA:     RELAZIONI_RUOLI.suddivisione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result relazioni_ruoli.suddivisione%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_relazione => p_id_relazione)
             ,'existsId on relazioni_ruoli_tpk.get_suddivisione');
      select suddivisione
        into d_result
        from relazioni_ruoli
       where id_relazione = p_id_relazione;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on relazioni_ruoli_tpk.get_suddivisione');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'suddivisione')
                      ,' AFC_DDL.IsNullable on relazioni_ruoli_tpk.get_suddivisione');
      end if;
      return d_result;
   end get_suddivisione; -- relazioni_ruoli_tpk.get_suddivisione
   --------------------------------------------------------------------------------
   function get_incarico(p_id_relazione in relazioni_ruoli.id_relazione%type)
      return relazioni_ruoli.incarico%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_incarico
       DESCRIZIONE: Getter per attributo incarico di riga identificata dalla note.
       PARAMETRI:   Attributi note.
       RITORNA:     RELAZIONI_RUOLI.incarico%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result relazioni_ruoli.incarico%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_relazione => p_id_relazione)
             ,'existsId on relazioni_ruoli_tpk.get_incarico');
      select incarico
        into d_result
        from relazioni_ruoli
       where id_relazione = p_id_relazione;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on relazioni_ruoli_tpk.get_incarico');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'incarico')
                      ,' AFC_DDL.IsNullable on relazioni_ruoli_tpk.get_incarico');
      end if;
      return d_result;
   end get_incarico; -- relazioni_ruoli_tpk.get_incarico
   --------------------------------------------------------------------------------
   function get_responsabile(p_id_relazione in relazioni_ruoli.id_relazione%type)
      return relazioni_ruoli.responsabile%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_responsabile
       DESCRIZIONE: Getter per attributo responsabile di riga identificata dalla note.
       PARAMETRI:   Attributi note.
       RITORNA:     RELAZIONI_RUOLI.responsabile%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result relazioni_ruoli.responsabile%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_relazione => p_id_relazione)
             ,'existsId on relazioni_ruoli_tpk.get_responsabile');
      select responsabile
        into d_result
        from relazioni_ruoli
       where id_relazione = p_id_relazione;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on relazioni_ruoli_tpk.get_responsabile');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'responsabile')
                      ,' AFC_DDL.IsNullable on relazioni_ruoli_tpk.get_responsabile');
      end if;
      return d_result;
   end get_responsabile; -- relazioni_ruoli_tpk.get_responsabile
   --------------------------------------------------------------------------------
   function get_dipendente(p_id_relazione in relazioni_ruoli.id_relazione%type)
      return relazioni_ruoli.dipendente%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_dipendente
       DESCRIZIONE: Getter per attributo dipendente di riga identificata dalla note.
       PARAMETRI:   Attributi note.
       RITORNA:     RELAZIONI_RUOLI.dipendente%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result relazioni_ruoli.dipendente%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_relazione => p_id_relazione)
             ,'existsId on relazioni_ruoli_tpk.get_dipendente');
      select dipendente
        into d_result
        from relazioni_ruoli
       where id_relazione = p_id_relazione;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on relazioni_ruoli_tpk.get_dipendente');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'dipendente')
                      ,' AFC_DDL.IsNullable on relazioni_ruoli_tpk.get_dipendente');
      end if;
      return d_result;
   end get_dipendente; -- relazioni_ruoli_tpk.get_dipendente
   --------------------------------------------------------------------------------
   function get_note(p_id_relazione in relazioni_ruoli.id_relazione%type)
      return relazioni_ruoli.note%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_note
       DESCRIZIONE: Getter per attributo note di riga identificata dalla note.
       PARAMETRI:   Attributi note.
       RITORNA:     RELAZIONI_RUOLI.note%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result relazioni_ruoli.note%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_relazione => p_id_relazione)
             ,'existsId on relazioni_ruoli_tpk.get_note');
      select note into d_result from relazioni_ruoli where id_relazione = p_id_relazione;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on relazioni_ruoli_tpk.get_note');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'note')
                      ,' AFC_DDL.IsNullable on relazioni_ruoli_tpk.get_note');
      end if;
      return d_result;
   end get_note; -- relazioni_ruoli_tpk.get_note
   --------------------------------------------------------------------------------
   function get_ruolo(p_id_relazione in relazioni_ruoli.id_relazione%type)
      return relazioni_ruoli.ruolo%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_ruolo
       DESCRIZIONE: Getter per attributo ruolo di riga identificata dalla note.
       PARAMETRI:   Attributi note.
       RITORNA:     RELAZIONI_RUOLI.ruolo%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result relazioni_ruoli.ruolo%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_relazione => p_id_relazione)
             ,'existsId on relazioni_ruoli_tpk.get_ruolo');
      select ruolo
        into d_result
        from relazioni_ruoli
       where id_relazione = p_id_relazione;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on relazioni_ruoli_tpk.get_ruolo');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'ruolo')
                      ,' AFC_DDL.IsNullable on relazioni_ruoli_tpk.get_ruolo');
      end if;
      return d_result;
   end get_ruolo; -- relazioni_ruoli_tpk.get_ruolo
   --------------------------------------------------------------------------------
   procedure set_id_relazione
   (
      p_id_relazione in relazioni_ruoli.id_relazione%type
     ,p_value        in relazioni_ruoli.id_relazione%type default null
   ) is
      /******************************************************************************
       NOME:        set_id_relazione
       DESCRIZIONE: Setter per attributo id_relazione di riga identificata dalla note.
       PARAMETRI:   Attributi note.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_relazione => p_id_relazione)
             ,'existsId on relazioni_ruoli_tpk.set_id_relazione');
      update relazioni_ruoli
         set id_relazione = p_value
       where id_relazione = p_id_relazione;
   end set_id_relazione; -- relazioni_ruoli_tpk.set_id_relazione
   --------------------------------------------------------------------------------
   procedure set_ottica
   (
      p_id_relazione in relazioni_ruoli.id_relazione%type
     ,p_value        in relazioni_ruoli.ottica%type default null
   ) is
      /******************************************************************************
       NOME:        set_ottica
       DESCRIZIONE: Setter per attributo ottica di riga identificata dalla note.
       PARAMETRI:   Attributi note.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_relazione => p_id_relazione)
             ,'existsId on relazioni_ruoli_tpk.set_ottica');
      update relazioni_ruoli set ottica = p_value where id_relazione = p_id_relazione;
   end set_ottica; -- relazioni_ruoli_tpk.set_ottica
   --------------------------------------------------------------------------------
   procedure set_codice_uo
   (
      p_id_relazione in relazioni_ruoli.id_relazione%type
     ,p_value        in relazioni_ruoli.codice_uo%type default null
   ) is
      /******************************************************************************
       NOME:        set_codice_uo
       DESCRIZIONE: Setter per attributo codice_uo di riga identificata dalla note.
       PARAMETRI:   Attributi note.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_relazione => p_id_relazione)
             ,'existsId on relazioni_ruoli_tpk.set_codice_uo');
      update relazioni_ruoli set codice_uo = p_value where id_relazione = p_id_relazione;
   end set_codice_uo; -- relazioni_ruoli_tpk.set_codice_uo
   --------------------------------------------------------------------------------
   procedure set_uo_discendenti
   (
      p_id_relazione in relazioni_ruoli.id_relazione%type
     ,p_value        in relazioni_ruoli.uo_discendenti%type default null
   ) is
      /******************************************************************************
       NOME:        set_uo_discendenti
       DESCRIZIONE: Setter per attributo uo_discendenti di riga identificata dalla note.
       PARAMETRI:   Attributi note.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_relazione => p_id_relazione)
             ,'existsId on relazioni_ruoli_tpk.set_uo_discendenti');
      update relazioni_ruoli
         set uo_discendenti = p_value
       where id_relazione = p_id_relazione;
   end set_uo_discendenti; -- relazioni_ruoli_tpk.set_uo_discendenti
   --------------------------------------------------------------------------------
   procedure set_suddivisione
   (
      p_id_relazione in relazioni_ruoli.id_relazione%type
     ,p_value        in relazioni_ruoli.suddivisione%type default null
   ) is
      /******************************************************************************
       NOME:        set_suddivisione
       DESCRIZIONE: Setter per attributo suddivisione di riga identificata dalla note.
       PARAMETRI:   Attributi note.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_relazione => p_id_relazione)
             ,'existsId on relazioni_ruoli_tpk.set_suddivisione');
      update relazioni_ruoli
         set suddivisione = p_value
       where id_relazione = p_id_relazione;
   end set_suddivisione; -- relazioni_ruoli_tpk.set_suddivisione
   --------------------------------------------------------------------------------
   procedure set_incarico
   (
      p_id_relazione in relazioni_ruoli.id_relazione%type
     ,p_value        in relazioni_ruoli.incarico%type default null
   ) is
      /******************************************************************************
       NOME:        set_incarico
       DESCRIZIONE: Setter per attributo incarico di riga identificata dalla note.
       PARAMETRI:   Attributi note.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_relazione => p_id_relazione)
             ,'existsId on relazioni_ruoli_tpk.set_incarico');
      update relazioni_ruoli set incarico = p_value where id_relazione = p_id_relazione;
   end set_incarico; -- relazioni_ruoli_tpk.set_incarico
   --------------------------------------------------------------------------------
   procedure set_responsabile
   (
      p_id_relazione in relazioni_ruoli.id_relazione%type
     ,p_value        in relazioni_ruoli.responsabile%type default null
   ) is
      /******************************************************************************
       NOME:        set_responsabile
       DESCRIZIONE: Setter per attributo responsabile di riga identificata dalla note.
       PARAMETRI:   Attributi note.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_relazione => p_id_relazione)
             ,'existsId on relazioni_ruoli_tpk.set_responsabile');
      update relazioni_ruoli
         set responsabile = p_value
       where id_relazione = p_id_relazione;
   end set_responsabile; -- relazioni_ruoli_tpk.set_responsabile
   --------------------------------------------------------------------------------
   procedure set_dipendente
   (
      p_id_relazione in relazioni_ruoli.id_relazione%type
     ,p_value        in relazioni_ruoli.dipendente%type default null
   ) is
      /******************************************************************************
       NOME:        set_dipendente
       DESCRIZIONE: Setter per attributo dipendente di riga identificata dalla note.
       PARAMETRI:   Attributi note.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_relazione => p_id_relazione)
             ,'existsId on relazioni_ruoli_tpk.set_dipendente');
      update relazioni_ruoli
         set dipendente = p_value
       where id_relazione = p_id_relazione;
   end set_dipendente; -- relazioni_ruoli_tpk.set_dipendente
   --------------------------------------------------------------------------------
   procedure set_note
   (
      p_id_relazione in relazioni_ruoli.id_relazione%type
     ,p_value        in relazioni_ruoli.note%type default null
   ) is
      /******************************************************************************
       NOME:        set_note
       DESCRIZIONE: Setter per attributo note di riga identificata dalla note.
       PARAMETRI:   Attributi note.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_relazione => p_id_relazione)
             ,'existsId on relazioni_ruoli_tpk.set_note');
      update relazioni_ruoli set note = p_value where id_relazione = p_id_relazione;
   end set_note; -- relazioni_ruoli_tpk.set_note
   --------------------------------------------------------------------------------
   procedure set_ruolo
   (
      p_id_relazione in relazioni_ruoli.id_relazione%type
     ,p_value        in relazioni_ruoli.ruolo%type default null
   ) is
      /******************************************************************************
       NOME:        set_ruolo
       DESCRIZIONE: Setter per attributo ruolo di riga identificata dalla note.
       PARAMETRI:   Attributi note.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_relazione => p_id_relazione)
             ,'existsId on relazioni_ruoli_tpk.set_ruolo');
      update relazioni_ruoli set ruolo = p_value where id_relazione = p_id_relazione;
   end set_ruolo; -- relazioni_ruoli_tpk.set_ruolo
   --------------------------------------------------------------------------------
   function where_condition /* SLAVE_COPY */
   (
      p_qbe             in number default 0
     ,p_other_condition in varchar2 default null
     ,p_id_relazione    in varchar2 default null
     ,p_ottica          in varchar2 default null
     ,p_codice_uo       in varchar2 default null
     ,p_uo_discendenti  in varchar2 default null
     ,p_suddivisione    in varchar2 default null
     ,p_incarico        in varchar2 default null
     ,p_responsabile    in varchar2 default null
     ,p_modulo          in varchar2 default null
     ,p_istanza         in varchar2 default null
     ,p_ruolo_accesso   in varchar2 default null
     ,p_dipendente      in varchar2 default null
     ,p_note            in varchar2 default null
     ,p_ruolo           in varchar2 default null
   ) return afc.t_statement is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        where_condition
       DESCRIZIONE: Ritorna la where_condition per lo statement di select di get_rows e count_rows. 
       PARAMETRI:   p_QBE 0: viene controllato se all'inizio di ogni attributo e presente
                             un operatore, altrimenti viene usato quello di default ('=')
                          1: viene utilizzato l'operatore specificato all'inizio di ogni
                             attributo.
                    p_other_condition: condizioni aggiuntive di base
                    Chiavi e attributi della table
       RITORNA:     AFC.t_statement.
       NOTE:        Se p_QBE = 1 , ogni parametro deve contenere, nella prima parte,
                    l'operatore da utilizzare nella where-condition.
      ******************************************************************************/
      d_statement afc.t_statement;
   begin
      d_statement := ' where ( 1 = 1 ' ||
                     afc.get_field_condition(' and ( id_relazione '
                                            ,p_id_relazione
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( ottica '
                                            ,p_ottica
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( codice_uo '
                                            ,p_codice_uo
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( uo_discendenti '
                                            ,p_uo_discendenti
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( suddivisione '
                                            ,p_suddivisione
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( incarico '
                                            ,p_incarico
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( responsabile '
                                            ,p_responsabile
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( modulo '
                                            ,p_modulo
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( istanza '
                                            ,p_istanza
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( ruolo_accesso '
                                            ,p_ruolo_accesso
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( dipendente '
                                            ,p_dipendente
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( note ', p_note, ' )', p_qbe, null) ||
                     afc.get_field_condition(' and ( ruolo ', p_ruolo, ' )', p_qbe, null) ||
                     ' ) ' || p_other_condition;
      return d_statement;
   end where_condition; --- relazioni_ruoli_tpk.where_condition
   --------------------------------------------------------------------------------
   function get_rows
   (
      p_qbe             in number default 0
     ,p_other_condition in varchar2 default null
     ,p_order_by        in varchar2 default null
     ,p_extra_columns   in varchar2 default null
     ,p_extra_condition in varchar2 default null
     ,p_id_relazione    in varchar2 default null
     ,p_ottica          in varchar2 default null
     ,p_codice_uo       in varchar2 default null
     ,p_uo_discendenti  in varchar2 default null
     ,p_suddivisione    in varchar2 default null
     ,p_incarico        in varchar2 default null
     ,p_responsabile    in varchar2 default null
     ,p_dipendente      in varchar2 default null
     ,p_note            in varchar2 default null
     ,p_ruolo           in varchar2 default null
   ) return afc.t_ref_cursor is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_rows
       DESCRIZIONE: Ritorna il risultato di una query in base ai valori che passiamo. 
       PARAMETRI:   p_QBE 0: viene controllato se all'inizio di ogni attributo e presente
                             un operatore, altrimenti viene usato quello di default ('=')
                          1: viene utilizzato l'operatore specificato all'inizio di ogni
                             attributo.
                    p_other_condition: condizioni aggiuntive di base
                    p_order_by: condizioni di ordinamento
                    p_extra_columns: colonne da aggiungere alla select
                    p_extra_condition: condizioni aggiuntive 
                    Chiavi e attributi della table
       RITORNA:     Un ref_cursor che punta al risultato della query.
       NOTE:        Se p_QBE = 1 , ogni parametro deve contenere, nella prima parte,
                    l'operatore da utilizzare nella where-condition.
                    In p_extra_columns e p_order_by non devono essere passati anche la
                    virgola iniziale (per p_extra_columns) e la stringa 'order by' (per
                    p_order_by)
      ******************************************************************************/
      d_statement  afc.t_statement;
      d_ref_cursor afc.t_ref_cursor;
   begin
      d_statement  := ' select RELAZIONI_RUOLI.* ' ||
                      afc.decode_value(p_extra_columns
                                      ,null
                                      ,null
                                      ,' , ' || p_extra_columns) ||
                      ' from RELAZIONI_RUOLI ' ||
                      where_condition(p_qbe             => p_qbe
                                     ,p_other_condition => p_other_condition
                                     ,p_id_relazione    => p_id_relazione
                                     ,p_ottica          => p_ottica
                                     ,p_codice_uo       => p_codice_uo
                                     ,p_uo_discendenti  => p_uo_discendenti
                                     ,p_suddivisione    => p_suddivisione
                                     ,p_incarico        => p_incarico
                                     ,p_responsabile    => p_responsabile
                                     ,p_dipendente      => p_dipendente
                                     ,p_note            => p_note
                                     ,p_ruolo           => p_ruolo) || ' ' ||
                      p_extra_condition ||
                      afc.decode_value(p_order_by, null, null, ' order by ' || p_order_by);
      d_ref_cursor := afc_dml.get_ref_cursor(d_statement);
      return d_ref_cursor;
   end get_rows; -- relazioni_ruoli_tpk.get_rows
   --------------------------------------------------------------------------------
   function count_rows
   (
      p_qbe             in number default 0
     ,p_other_condition in varchar2 default null
     ,p_id_relazione    in varchar2 default null
     ,p_ottica          in varchar2 default null
     ,p_codice_uo       in varchar2 default null
     ,p_uo_discendenti  in varchar2 default null
     ,p_suddivisione    in varchar2 default null
     ,p_incarico        in varchar2 default null
     ,p_responsabile    in varchar2 default null
     ,p_dipendente      in varchar2 default null
     ,p_note            in varchar2 default null
     ,p_ruolo           in varchar2 default null
   ) return integer is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        count_rows
       DESCRIZIONE: Ritorna il numero di righe della tabella gli attributi delle quali
                    rispettano i valori indicati.
       PARAMETRI:   p_QBE 0: viene controllato se all'inizio di ogni attributo e presente
                             un operatore, altrimenti viene usato quello di default ('=')
                          1: viene utilizzato l'operatore specificato all'inizio di ogni
                             attributo.
                    p_other_condition: condizioni aggiuntive di base
                    Chiavi e attributi della table
       RITORNA:     Numero di righe che rispettano la selezione indicata.
      ******************************************************************************/
      d_result    integer;
      d_statement afc.t_statement;
   begin
      d_statement := ' select count( * ) from RELAZIONI_RUOLI ' ||
                     where_condition(p_qbe             => p_qbe
                                    ,p_other_condition => p_other_condition
                                    ,p_id_relazione    => p_id_relazione
                                    ,p_ottica          => p_ottica
                                    ,p_codice_uo       => p_codice_uo
                                    ,p_uo_discendenti  => p_uo_discendenti
                                    ,p_suddivisione    => p_suddivisione
                                    ,p_incarico        => p_incarico
                                    ,p_responsabile    => p_responsabile
                                    ,p_dipendente      => p_dipendente
                                    ,p_note            => p_note
                                    ,p_ruolo           => p_ruolo);
      d_result    := afc.sql_execute(d_statement);
      return d_result;
   end count_rows; -- relazioni_ruoli_tpk.count_rows
--------------------------------------------------------------------------------

end relazioni_ruoli_tpk;
/

