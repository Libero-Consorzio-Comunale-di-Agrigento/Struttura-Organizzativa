CREATE OR REPLACE package body deleghe_tpk is
/******************************************************************************
 NOME:        deleghe_tpk
 DESCRIZIONE: Gestione tabella DELEGHE.
 ANNOTAZIONI: .
 REVISIONI:   .
 Rev.  Data        Autore      Descrizione.
    000   22/11/2017  MMonari  Generazione automatica.
   ******************************************************************************/
   s_revisione_body constant afc.t_revision := '000 - 22/11/2017';
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
   end versione; -- deleghe_tpk.versione
   --------------------------------------------------------------------------------
   function pk(p_id_delega in deleghe.id_delega%type) return t_pk is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        PK
       DESCRIZIONE: Costruttore di un t_PK dati gli attributi della chiave
      ******************************************************************************/
      d_result t_pk;
   begin
      d_result.id_delega := p_id_delega;
      dbc.pre(not dbc.preon or canhandle(p_id_delega => d_result.id_delega)
             ,'canHandle on deleghe_tpk.PK');
      return d_result;
   end pk; -- deleghe_tpk.PK
   --------------------------------------------------------------------------------
   function can_handle(p_id_delega in deleghe.id_delega%type) return number is
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
      if d_result = 1 and (p_id_delega is null) then
         d_result := 0;
      end if;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on deleghe_tpk.can_handle');
      return d_result;
   end can_handle; -- deleghe_tpk.can_handle
   --------------------------------------------------------------------------------
   function canhandle(p_id_delega in deleghe.id_delega%type) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        canHandle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: true se la chiave e manipolabile, false altrimenti.
       NOTE:        Wrapper boolean di can_handle (cfr. can_handle).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(can_handle(p_id_delega => p_id_delega));
   begin
      return d_result;
   end canhandle; -- deleghe_tpk.canHandle
   --------------------------------------------------------------------------------
   function exists_id(p_id_delega in deleghe.id_delega%type) return number is
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
      dbc.pre(not dbc.preon or canhandle(p_id_delega => p_id_delega)
             ,'canHandle on deleghe_tpk.exists_id');
      begin
         select 1 into d_result from deleghe where id_delega = p_id_delega;
      exception
         when no_data_found then
            d_result := 0;
      end;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on deleghe_tpk.exists_id');
      return d_result;
   end exists_id; -- deleghe_tpk.exists_id
   --------------------------------------------------------------------------------
   function existsid(p_id_delega in deleghe.id_delega%type) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        existsId
       DESCRIZIONE: Esistenza riga con chiave indicata.
       NOTE:        Wrapper boolean di exists_id (cfr. exists_id).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(exists_id(p_id_delega => p_id_delega));
   begin
      return d_result;
   end existsid; -- deleghe_tpk.existsId
   --------------------------------------------------------------------------------
   procedure ins
   (
      p_id_delega                 in deleghe.id_delega%type default null
     ,p_delegante                 in deleghe.delegante%type
     ,p_delegato                  in deleghe.delegato%type
     ,p_ottica                    in deleghe.ottica%type default null
     ,p_progr_unita_organizzativa in deleghe.progr_unita_organizzativa%type default null
     ,p_ruolo                     in deleghe.ruolo%type default null
     ,p_id_competenza_delega      in deleghe.id_competenza_delega%type default null
     ,p_dal                       in deleghe.dal%type
     ,p_al                        in deleghe.al%type default null
     ,p_utente_aggiornamento      in deleghe.utente_aggiornamento%type default null
     ,p_data_aggiornamento        in deleghe.data_aggiornamento%type default null
   ) is
      /******************************************************************************
       NOME:        ins
       DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
       PARAMETRI:   Chiavi e attributi della table.
      ******************************************************************************/
   begin
      -- Check Mandatory on Insert
      dbc.pre(not dbc.preon or p_delegante is not null or /*default value*/
              '' is not null
             ,'p_delegante on deleghe_tpk.ins');
      dbc.pre(not dbc.preon or p_delegato is not null or /*default value*/
              '' is not null
             ,'p_delegato on deleghe_tpk.ins');
      dbc.pre(not dbc.preon or p_ottica is not null or /*default value*/
              'default' is not null
             ,'p_ottica on deleghe_tpk.ins');
      dbc.pre(not dbc.preon or p_progr_unita_organizzativa is not null or /*default value*/
              'default' is not null
             ,'p_progr_unita_organizzativa on deleghe_tpk.ins');
      dbc.pre(not dbc.preon or p_ruolo is not null or /*default value*/
              'default' is not null
             ,'p_ruolo on deleghe_tpk.ins');
      dbc.pre(not dbc.preon or p_id_competenza_delega is not null or /*default value*/
              'default' is not null
             ,'p_id_competenza_delega on deleghe_tpk.ins');
      dbc.pre(not dbc.preon or p_dal is not null or /*default value*/
              '' is not null
             ,'p_dal on deleghe_tpk.ins');
      dbc.pre(not dbc.preon or p_al is not null or /*default value*/
              'default' is not null
             ,'p_al on deleghe_tpk.ins');
      dbc.pre(not dbc.preon or p_utente_aggiornamento is not null or /*default value*/
              'default' is not null
             ,'p_utente_aggiornamento on deleghe_tpk.ins');
      dbc.pre(not dbc.preon or p_data_aggiornamento is not null or /*default value*/
              'default' is not null
             ,'p_data_aggiornamento on deleghe_tpk.ins');
      dbc.pre(not dbc.preon or (p_id_delega is null and /*default value*/
              'default null' is not null) -- PK nullable on insert
              or not existsid(p_id_delega => p_id_delega)
             ,'not existsId on deleghe_tpk.ins');
      insert into deleghe
         (id_delega
         ,delegante
         ,delegato
         ,ottica
         ,progr_unita_organizzativa
         ,ruolo
         ,id_competenza_delega
         ,dal
         ,al
         ,utente_aggiornamento
         ,data_aggiornamento)
      values
         (p_id_delega
         ,p_delegante
         ,p_delegato
         ,p_ottica
         ,p_progr_unita_organizzativa
         ,p_ruolo
         ,p_id_competenza_delega
         ,p_dal
         ,p_al
         ,p_utente_aggiornamento
         ,p_data_aggiornamento);
   end ins; -- deleghe_tpk.ins
   --------------------------------------------------------------------------------
   function ins
   (
      p_id_delega                 in deleghe.id_delega%type default null
     ,p_delegante                 in deleghe.delegante%type
     ,p_delegato                  in deleghe.delegato%type
     ,p_ottica                    in deleghe.ottica%type default null
     ,p_progr_unita_organizzativa in deleghe.progr_unita_organizzativa%type default null
     ,p_ruolo                     in deleghe.ruolo%type default null
     ,p_id_competenza_delega      in deleghe.id_competenza_delega%type default null
     ,p_dal                       in deleghe.dal%type
     ,p_al                        in deleghe.al%type default null
     ,p_utente_aggiornamento      in deleghe.utente_aggiornamento%type default null
     ,p_data_aggiornamento        in deleghe.data_aggiornamento%type default null
   ) return number
   /******************************************************************************
       NOME:        ins
       DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
       PARAMETRI:   Chiavi e attributi della table.
       RITORNA:     In caso di PK formata da colonna numerica, ritorna il valore della PK
                    (se positivo), in tutti gli altri casi ritorna 0; in caso di errore,
                    ritorna il codice di errore
      ******************************************************************************/
    is
      d_result number;
   begin
      -- Check Mandatory on Insert
      dbc.pre(not dbc.preon or p_delegante is not null or /*default value*/
              '' is not null
             ,'p_delegante on deleghe_tpk.ins');
      dbc.pre(not dbc.preon or p_delegato is not null or /*default value*/
              '' is not null
             ,'p_delegato on deleghe_tpk.ins');
      dbc.pre(not dbc.preon or p_ottica is not null or /*default value*/
              'default' is not null
             ,'p_ottica on deleghe_tpk.ins');
      dbc.pre(not dbc.preon or p_progr_unita_organizzativa is not null or /*default value*/
              'default' is not null
             ,'p_progr_unita_organizzativa on deleghe_tpk.ins');
      dbc.pre(not dbc.preon or p_ruolo is not null or /*default value*/
              'default' is not null
             ,'p_ruolo on deleghe_tpk.ins');
      dbc.pre(not dbc.preon or p_id_competenza_delega is not null or /*default value*/
              'default' is not null
             ,'p_id_competenza_delega on deleghe_tpk.ins');
      dbc.pre(not dbc.preon or p_dal is not null or /*default value*/
              '' is not null
             ,'p_dal on deleghe_tpk.ins');
      dbc.pre(not dbc.preon or p_al is not null or /*default value*/
              'default' is not null
             ,'p_al on deleghe_tpk.ins');
      dbc.pre(not dbc.preon or p_utente_aggiornamento is not null or /*default value*/
              'default' is not null
             ,'p_utente_aggiornamento on deleghe_tpk.ins');
      dbc.pre(not dbc.preon or p_data_aggiornamento is not null or /*default value*/
              'default' is not null
             ,'p_data_aggiornamento on deleghe_tpk.ins');
      dbc.pre(not dbc.preon or (p_id_delega is null and /*default value*/
              'default null' is not null) -- PK nullable on insert
              or not existsid(p_id_delega => p_id_delega)
             ,'not existsId on deleghe_tpk.ins');
      insert into deleghe
         (id_delega
         ,delegante
         ,delegato
         ,ottica
         ,progr_unita_organizzativa
         ,ruolo
         ,id_competenza_delega
         ,dal
         ,al
         ,utente_aggiornamento
         ,data_aggiornamento)
      values
         (p_id_delega
         ,p_delegante
         ,p_delegato
         ,p_ottica
         ,p_progr_unita_organizzativa
         ,p_ruolo
         ,p_id_competenza_delega
         ,p_dal
         ,p_al
         ,p_utente_aggiornamento
         ,p_data_aggiornamento)
      returning id_delega into d_result;
      return d_result;
   end ins; -- deleghe_tpk.ins
   --------------------------------------------------------------------------------
   procedure upd
   (
      p_check_old                    in integer default 0
     ,p_new_id_delega                in deleghe.id_delega%type
     ,p_old_id_delega                in deleghe.id_delega%type default null
     ,p_new_delegante                in deleghe.delegante%type default afc.default_null('DELEGHE.delegante')
     ,p_old_delegante                in deleghe.delegante%type default null
     ,p_new_delegato                 in deleghe.delegato%type default afc.default_null('DELEGHE.delegato')
     ,p_old_delegato                 in deleghe.delegato%type default null
     ,p_new_ottica                   in deleghe.ottica%type default afc.default_null('DELEGHE.ottica')
     ,p_old_ottica                   in deleghe.ottica%type default null
     ,p_new_progr_unita_organizzativ in deleghe.progr_unita_organizzativa%type default afc.default_null('DELEGHE.progr_unita_organizzativa')
     ,p_old_progr_unita_organizzativ in deleghe.progr_unita_organizzativa%type default null
     ,p_new_ruolo                    in deleghe.ruolo%type default afc.default_null('DELEGHE.ruolo')
     ,p_old_ruolo                    in deleghe.ruolo%type default null
     ,p_new_id_competenza_delega     in deleghe.id_competenza_delega%type default afc.default_null('DELEGHE.id_competenza_delega')
     ,p_old_id_competenza_delega     in deleghe.id_competenza_delega%type default null
     ,p_new_dal                      in deleghe.dal%type default afc.default_null('DELEGHE.dal')
     ,p_old_dal                      in deleghe.dal%type default null
     ,p_new_al                       in deleghe.al%type default afc.default_null('DELEGHE.al')
     ,p_old_al                       in deleghe.al%type default null
     ,p_new_utente_aggiornamento     in deleghe.utente_aggiornamento%type default afc.default_null('DELEGHE.utente_aggiornamento')
     ,p_old_utente_aggiornamento     in deleghe.utente_aggiornamento%type default null
     ,p_new_data_aggiornamento       in deleghe.data_aggiornamento%type default afc.default_null('DELEGHE.data_aggiornamento')
     ,p_old_data_aggiornamento       in deleghe.data_aggiornamento%type default null
   ) is
      /******************************************************************************
       NOME:        upd
       DESCRIZIONE: Aggiornamento di una riga con chiave.
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
      dbc.pre(not dbc.preon or
              not ((p_old_delegante is not null or p_old_delegato is not null or
               p_old_ottica is not null or
               p_old_progr_unita_organizzativ is not null or p_old_ruolo is not null or
               p_old_id_competenza_delega is not null or p_old_dal is not null or
               p_old_al is not null or p_old_utente_aggiornamento is not null or
               p_old_data_aggiornamento is not null) and (nvl(p_check_old, -1) = 0))
             ,' "OLD values" is not null on deleghe_tpk.upd');
      d_key := pk(nvl(p_old_id_delega, p_new_id_delega));
      dbc.pre(not dbc.preon or existsid(p_id_delega => d_key.id_delega)
             ,'existsId on deleghe_tpk.upd');
      update deleghe
         set id_delega                 = nvl(p_new_id_delega
                                            ,decode(afc.is_default_null('DELEGHE.id_delega')
                                                   ,1
                                                   ,id_delega
                                                   ,decode(p_check_old
                                                          ,0
                                                          ,null
                                                          ,decode(p_old_id_delega
                                                                 ,null
                                                                 ,id_delega
                                                                 ,null))))
            ,delegante                 = nvl(p_new_delegante
                                            ,decode(afc.is_default_null('DELEGHE.delegante')
                                                   ,1
                                                   ,delegante
                                                   ,decode(p_check_old
                                                          ,0
                                                          ,null
                                                          ,decode(p_old_delegante
                                                                 ,null
                                                                 ,delegante
                                                                 ,null))))
            ,delegato                  = nvl(p_new_delegato
                                            ,decode(afc.is_default_null('DELEGHE.delegato')
                                                   ,1
                                                   ,delegato
                                                   ,decode(p_check_old
                                                          ,0
                                                          ,null
                                                          ,decode(p_old_delegato
                                                                 ,null
                                                                 ,delegato
                                                                 ,null))))
            ,ottica                    = nvl(p_new_ottica
                                            ,decode(afc.is_default_null('DELEGHE.ottica')
                                                   ,1
                                                   ,ottica
                                                   ,decode(p_check_old
                                                          ,0
                                                          ,null
                                                          ,decode(p_old_ottica
                                                                 ,null
                                                                 ,ottica
                                                                 ,null))))
            ,progr_unita_organizzativa = nvl(p_new_progr_unita_organizzativ
                                            ,decode(afc.is_default_null('DELEGHE.progr_unita_organizzativa')
                                                   ,1
                                                   ,progr_unita_organizzativa
                                                   ,decode(p_check_old
                                                          ,0
                                                          ,null
                                                          ,decode(p_old_progr_unita_organizzativ
                                                                 ,null
                                                                 ,progr_unita_organizzativa
                                                                 ,null))))
            ,ruolo                     = nvl(p_new_ruolo
                                            ,decode(afc.is_default_null('DELEGHE.ruolo')
                                                   ,1
                                                   ,ruolo
                                                   ,decode(p_check_old
                                                          ,0
                                                          ,null
                                                          ,decode(p_old_ruolo
                                                                 ,null
                                                                 ,ruolo
                                                                 ,null))))
            ,id_competenza_delega      = nvl(p_new_id_competenza_delega
                                            ,decode(afc.is_default_null('DELEGHE.id_competenza_delega')
                                                   ,1
                                                   ,id_competenza_delega
                                                   ,decode(p_check_old
                                                          ,0
                                                          ,null
                                                          ,decode(p_old_id_competenza_delega
                                                                 ,null
                                                                 ,id_competenza_delega
                                                                 ,null))))
            ,dal                       = nvl(p_new_dal
                                            ,decode(afc.is_default_null('DELEGHE.dal')
                                                   ,1
                                                   ,dal
                                                   ,decode(p_check_old
                                                          ,0
                                                          ,null
                                                          ,decode(p_old_dal
                                                                 ,null
                                                                 ,dal
                                                                 ,null))))
            ,al                        = nvl(p_new_al
                                            ,decode(afc.is_default_null('DELEGHE.al')
                                                   ,1
                                                   ,al
                                                   ,decode(p_check_old
                                                          ,0
                                                          ,null
                                                          ,decode(p_old_al
                                                                 ,null
                                                                 ,al
                                                                 ,null))))
            ,utente_aggiornamento      = nvl(p_new_utente_aggiornamento
                                            ,decode(afc.is_default_null('DELEGHE.utente_aggiornamento')
                                                   ,1
                                                   ,utente_aggiornamento
                                                   ,decode(p_check_old
                                                          ,0
                                                          ,null
                                                          ,decode(p_old_utente_aggiornamento
                                                                 ,null
                                                                 ,utente_aggiornamento
                                                                 ,null))))
            ,data_aggiornamento        = nvl(p_new_data_aggiornamento
                                            ,decode(afc.is_default_null('DELEGHE.data_aggiornamento')
                                                   ,1
                                                   ,data_aggiornamento
                                                   ,decode(p_check_old
                                                          ,0
                                                          ,null
                                                          ,decode(p_old_data_aggiornamento
                                                                 ,null
                                                                 ,data_aggiornamento
                                                                 ,null))))
       where id_delega = d_key.id_delega
         and (p_check_old = 0 or
             (1 = 1 and
             (delegante = p_old_delegante or
             (p_old_delegante is null and (p_check_old is null or delegante is null))) and
             (delegato = p_old_delegato or
             (p_old_delegato is null and (p_check_old is null or delegato is null))) and
             (ottica = p_old_ottica or
             (p_old_ottica is null and (p_check_old is null or ottica is null))) and
             (progr_unita_organizzativa = p_old_progr_unita_organizzativ or
             (p_old_progr_unita_organizzativ is null and
             (p_check_old is null or progr_unita_organizzativa is null))) and
             (ruolo = p_old_ruolo or
             (p_old_ruolo is null and (p_check_old is null or ruolo is null))) and
             (id_competenza_delega = p_old_id_competenza_delega or
             (p_old_id_competenza_delega is null and
             (p_check_old is null or id_competenza_delega is null))) and
             (dal = p_old_dal or
             (p_old_dal is null and (p_check_old is null or dal is null))) and
             (al = p_old_al or
             (p_old_al is null and (p_check_old is null or al is null))) and
             (utente_aggiornamento = p_old_utente_aggiornamento or
             (p_old_utente_aggiornamento is null and
             (p_check_old is null or utente_aggiornamento is null))) and
             (data_aggiornamento = p_old_data_aggiornamento or
             (p_old_data_aggiornamento is null and
             (p_check_old is null or data_aggiornamento is null)))));
      d_row_found := sql%rowcount;
      afc.default_null(null);
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on deleghe_tpk.upd');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   end upd; -- deleghe_tpk.upd
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_id_delega     in deleghe.id_delega%type
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
      dbc.pre(not dbc.preon or existsid(p_id_delega => p_id_delega)
             ,'existsId on deleghe_tpk.upd_column');
      dbc.pre(not dbc.preon or p_column is not null
             ,'p_column is not null on deleghe_tpk.upd_column');
      dbc.pre(not dbc.preon or afc_ddl.hasattribute(s_table_name, p_column)
             ,'AFC_DDL.HasAttribute on deleghe_tpk.upd_column');
      dbc.pre(p_literal_value in (0, 1) or p_literal_value is null
             ,'p_literal_value on deleghe_tpk.upd_column; p_literal_value = ' ||
              p_literal_value);
      if p_literal_value = 1 or p_literal_value is null then
         d_literal := '''';
      end if;
      d_statement := ' declare ' || '    d_row_found number; ' || ' begin ' ||
                     '    update DELEGHE ' || '       set ' || p_column || ' = ' ||
                     d_literal || p_value || d_literal || '     where 1 = 1 ' ||
                     nvl(afc.get_field_condition(' and ( id_delega '
                                                ,p_id_delega
                                                ,' )'
                                                ,0
                                                ,null)
                        ,' and ( id_delega is null ) ') || '    ; ' ||
                     '    d_row_found := SQL%ROWCOUNT; ' || '    if d_row_found < 1 ' ||
                     '    then ' ||
                     '       raise_application_error ( AFC_ERROR.modified_by_other_user_number, AFC_ERROR.modified_by_other_user_msg ); ' ||
                     '    end if; ' || ' end; ';
      afc.sql_execute(d_statement);
   end upd_column; -- deleghe_tpk.upd_column
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_id_delega in deleghe.id_delega%type
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
      d_data := to_char(p_value, afc.date_format);
      upd_column(p_id_delega     => p_id_delega
                ,p_column        => p_column
                ,p_value         => 'to_date( ''' || d_data || ''', ''' ||
                                    afc.date_format || ''' )'
                ,p_literal_value => 0);
   end upd_column; -- deleghe_tpk.upd_column
   --------------------------------------------------------------------------------
   procedure del
   (
      p_check_old                 in integer default 0
     ,p_id_delega                 in deleghe.id_delega%type
     ,p_delegante                 in deleghe.delegante%type default null
     ,p_delegato                  in deleghe.delegato%type default null
     ,p_ottica                    in deleghe.ottica%type default null
     ,p_progr_unita_organizzativa in deleghe.progr_unita_organizzativa%type default null
     ,p_ruolo                     in deleghe.ruolo%type default null
     ,p_id_competenza_delega      in deleghe.id_competenza_delega%type default null
     ,p_dal                       in deleghe.dal%type default null
     ,p_al                        in deleghe.al%type default null
     ,p_utente_aggiornamento      in deleghe.utente_aggiornamento%type default null
     ,p_data_aggiornamento        in deleghe.data_aggiornamento%type default null
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
      dbc.pre(not dbc.preon or
              not ((p_delegante is not null or p_delegato is not null or
               p_ottica is not null or p_progr_unita_organizzativa is not null or
               p_ruolo is not null or p_id_competenza_delega is not null or
               p_dal is not null or p_al is not null or
               p_utente_aggiornamento is not null or
               p_data_aggiornamento is not null) and (nvl(p_check_old, -1) = 0))
             ,' "OLD values" is not null on deleghe_tpk.del');
      dbc.pre(not dbc.preon or existsid(p_id_delega => p_id_delega)
             ,'existsId on deleghe_tpk.del');
      delete from deleghe
       where id_delega = p_id_delega
         and (p_check_old = 0 or
             (1 = 1 and
             (delegante = p_delegante or
             (p_delegante is null and (p_check_old is null or delegante is null))) and
             (delegato = p_delegato or
             (p_delegato is null and (p_check_old is null or delegato is null))) and
             (ottica = p_ottica or
             (p_ottica is null and (p_check_old is null or ottica is null))) and
             (progr_unita_organizzativa = p_progr_unita_organizzativa or
             (p_progr_unita_organizzativa is null and
             (p_check_old is null or progr_unita_organizzativa is null))) and
             (ruolo = p_ruolo or
             (p_ruolo is null and (p_check_old is null or ruolo is null))) and
             (id_competenza_delega = p_id_competenza_delega or
             (p_id_competenza_delega is null and
             (p_check_old is null or id_competenza_delega is null))) and
             (dal = p_dal or (p_dal is null and (p_check_old is null or dal is null))) and
             (al = p_al or (p_al is null and (p_check_old is null or al is null))) and
             (utente_aggiornamento = p_utente_aggiornamento or
             (p_utente_aggiornamento is null and
             (p_check_old is null or utente_aggiornamento is null))) and
             (data_aggiornamento = p_data_aggiornamento or
             (p_data_aggiornamento is null and
             (p_check_old is null or data_aggiornamento is null)))));
      d_row_found := sql%rowcount;
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on deleghe_tpk.del');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
      dbc.post(not dbc.poston or not existsid(p_id_delega => p_id_delega)
              ,'existsId on deleghe_tpk.del');
   end del; -- deleghe_tpk.del
   --------------------------------------------------------------------------------
   function get_delegante(p_id_delega in deleghe.id_delega%type)
      return deleghe.delegante%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_delegante
       DESCRIZIONE: Getter per attributo delegante di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     DELEGHE.delegante%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result deleghe.delegante%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_delega => p_id_delega)
             ,'existsId on deleghe_tpk.get_delegante');
      select delegante into d_result from deleghe where id_delega = p_id_delega;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on deleghe_tpk.get_delegante');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'delegante')
                      ,' AFC_DDL.IsNullable on deleghe_tpk.get_delegante');
      end if;
      return d_result;
   end get_delegante; -- deleghe_tpk.get_delegante
   --------------------------------------------------------------------------------
   function get_delegato(p_id_delega in deleghe.id_delega%type) return deleghe.delegato%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_delegato
       DESCRIZIONE: Getter per attributo delegato di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     DELEGHE.delegato%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result deleghe.delegato%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_delega => p_id_delega)
             ,'existsId on deleghe_tpk.get_delegato');
      select delegato into d_result from deleghe where id_delega = p_id_delega;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on deleghe_tpk.get_delegato');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'delegato')
                      ,' AFC_DDL.IsNullable on deleghe_tpk.get_delegato');
      end if;
      return d_result;
   end get_delegato; -- deleghe_tpk.get_delegato
   --------------------------------------------------------------------------------
   function get_ottica(p_id_delega in deleghe.id_delega%type) return deleghe.ottica%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_ottica
       DESCRIZIONE: Getter per attributo ottica di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     DELEGHE.ottica%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result deleghe.ottica%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_delega => p_id_delega)
             ,'existsId on deleghe_tpk.get_ottica');
      select ottica into d_result from deleghe where id_delega = p_id_delega;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on deleghe_tpk.get_ottica');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'ottica')
                      ,' AFC_DDL.IsNullable on deleghe_tpk.get_ottica');
      end if;
      return d_result;
   end get_ottica; -- deleghe_tpk.get_ottica
   --------------------------------------------------------------------------------
   function get_progr_unita_organizzativa(p_id_delega in deleghe.id_delega%type)
      return deleghe.progr_unita_organizzativa%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_progr_unita_organizzativa
       DESCRIZIONE: Getter per attributo progr_unita_organizzativa di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     DELEGHE.progr_unita_organizzativa%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result deleghe.progr_unita_organizzativa%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_delega => p_id_delega)
             ,'existsId on deleghe_tpk.get_progr_unita_organizzativa');
      select progr_unita_organizzativa
        into d_result
        from deleghe
       where id_delega = p_id_delega;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on deleghe_tpk.get_progr_unita_organizzativa');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'progr_unita_organizzativa')
                      ,' AFC_DDL.IsNullable on deleghe_tpk.get_progr_unita_organizzativa');
      end if;
      return d_result;
   end get_progr_unita_organizzativa; -- deleghe_tpk.get_progr_unita_organizzativa
   --------------------------------------------------------------------------------
   function get_ruolo(p_id_delega in deleghe.id_delega%type) return deleghe.ruolo%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_ruolo
       DESCRIZIONE: Getter per attributo ruolo di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     DELEGHE.ruolo%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result deleghe.ruolo%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_delega => p_id_delega)
             ,'existsId on deleghe_tpk.get_ruolo');
      select ruolo into d_result from deleghe where id_delega = p_id_delega;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on deleghe_tpk.get_ruolo');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'ruolo')
                      ,' AFC_DDL.IsNullable on deleghe_tpk.get_ruolo');
      end if;
      return d_result;
   end get_ruolo; -- deleghe_tpk.get_ruolo
   --------------------------------------------------------------------------------
   function get_id_competenza_delega(p_id_delega in deleghe.id_delega%type)
      return deleghe.id_competenza_delega%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_id_competenza_delega
       DESCRIZIONE: Getter per attributo id_competenza_delega di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     DELEGHE.id_competenza_delega%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result deleghe.id_competenza_delega%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_delega => p_id_delega)
             ,'existsId on deleghe_tpk.get_id_competenza_delega');
      select id_competenza_delega
        into d_result
        from deleghe
       where id_delega = p_id_delega;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on deleghe_tpk.get_id_competenza_delega');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'id_competenza_delega')
                      ,' AFC_DDL.IsNullable on deleghe_tpk.get_id_competenza_delega');
      end if;
      return d_result;
   end get_id_competenza_delega; -- deleghe_tpk.get_id_competenza_delega
   --------------------------------------------------------------------------------
   function get_dal(p_id_delega in deleghe.id_delega%type) return deleghe.dal%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_dal
       DESCRIZIONE: Getter per attributo dal di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     DELEGHE.dal%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result deleghe.dal%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_delega => p_id_delega)
             ,'existsId on deleghe_tpk.get_dal');
      select dal into d_result from deleghe where id_delega = p_id_delega;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on deleghe_tpk.get_dal');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'dal')
                      ,' AFC_DDL.IsNullable on deleghe_tpk.get_dal');
      end if;
      return d_result;
   end get_dal; -- deleghe_tpk.get_dal
   --------------------------------------------------------------------------------
   function get_al(p_id_delega in deleghe.id_delega%type) return deleghe.al%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_al
       DESCRIZIONE: Getter per attributo al di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     DELEGHE.al%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result deleghe.al%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_delega => p_id_delega)
             ,'existsId on deleghe_tpk.get_al');
      select al into d_result from deleghe where id_delega = p_id_delega;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on deleghe_tpk.get_al');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'al')
                      ,' AFC_DDL.IsNullable on deleghe_tpk.get_al');
      end if;
      return d_result;
   end get_al; -- deleghe_tpk.get_al
   --------------------------------------------------------------------------------
   function get_utente_aggiornamento(p_id_delega in deleghe.id_delega%type)
      return deleghe.utente_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_utente_aggiornamento
       DESCRIZIONE: Getter per attributo utente_aggiornamento di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     DELEGHE.utente_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result deleghe.utente_aggiornamento%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_delega => p_id_delega)
             ,'existsId on deleghe_tpk.get_utente_aggiornamento');
      select utente_aggiornamento
        into d_result
        from deleghe
       where id_delega = p_id_delega;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on deleghe_tpk.get_utente_aggiornamento');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'utente_aggiornamento')
                      ,' AFC_DDL.IsNullable on deleghe_tpk.get_utente_aggiornamento');
      end if;
      return d_result;
   end get_utente_aggiornamento; -- deleghe_tpk.get_utente_aggiornamento
   --------------------------------------------------------------------------------
   function get_data_aggiornamento(p_id_delega in deleghe.id_delega%type)
      return deleghe.data_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_data_aggiornamento
       DESCRIZIONE: Getter per attributo data_aggiornamento di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     DELEGHE.data_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result deleghe.data_aggiornamento%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_delega => p_id_delega)
             ,'existsId on deleghe_tpk.get_data_aggiornamento');
      select data_aggiornamento into d_result from deleghe where id_delega = p_id_delega;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on deleghe_tpk.get_data_aggiornamento');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'data_aggiornamento')
                      ,' AFC_DDL.IsNullable on deleghe_tpk.get_data_aggiornamento');
      end if;
      return d_result;
   end get_data_aggiornamento; -- deleghe_tpk.get_data_aggiornamento
   --------------------------------------------------------------------------------
   procedure set_id_delega
   (
      p_id_delega in deleghe.id_delega%type
     ,p_value     in deleghe.id_delega%type default null
   ) is
      /******************************************************************************
       NOME:        set_id_delega
       DESCRIZIONE: Setter per attributo id_delega di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_delega => p_id_delega)
             ,'existsId on deleghe_tpk.set_id_delega');
      update deleghe set id_delega = p_value where id_delega = p_id_delega;
   end set_id_delega; -- deleghe_tpk.set_id_delega
   --------------------------------------------------------------------------------
   procedure set_delegante
   (
      p_id_delega in deleghe.id_delega%type
     ,p_value     in deleghe.delegante%type default null
   ) is
      /******************************************************************************
       NOME:        set_delegante
       DESCRIZIONE: Setter per attributo delegante di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_delega => p_id_delega)
             ,'existsId on deleghe_tpk.set_delegante');
      update deleghe set delegante = p_value where id_delega = p_id_delega;
   end set_delegante; -- deleghe_tpk.set_delegante
   --------------------------------------------------------------------------------
   procedure set_delegato
   (
      p_id_delega in deleghe.id_delega%type
     ,p_value     in deleghe.delegato%type default null
   ) is
      /******************************************************************************
       NOME:        set_delegato
       DESCRIZIONE: Setter per attributo delegato di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_delega => p_id_delega)
             ,'existsId on deleghe_tpk.set_delegato');
      update deleghe set delegato = p_value where id_delega = p_id_delega;
   end set_delegato; -- deleghe_tpk.set_delegato
   --------------------------------------------------------------------------------
   procedure set_ottica
   (
      p_id_delega in deleghe.id_delega%type
     ,p_value     in deleghe.ottica%type default null
   ) is
      /******************************************************************************
       NOME:        set_ottica
       DESCRIZIONE: Setter per attributo ottica di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_delega => p_id_delega)
             ,'existsId on deleghe_tpk.set_ottica');
      update deleghe set ottica = p_value where id_delega = p_id_delega;
   end set_ottica; -- deleghe_tpk.set_ottica
   --------------------------------------------------------------------------------
   procedure set_progr_unita_organizzativa
   (
      p_id_delega in deleghe.id_delega%type
     ,p_value     in deleghe.progr_unita_organizzativa%type default null
   ) is
      /******************************************************************************
       NOME:        set_progr_unita_organizzativa
       DESCRIZIONE: Setter per attributo progr_unita_organizzativa di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_delega => p_id_delega)
             ,'existsId on deleghe_tpk.set_progr_unita_organizzativa');
      update deleghe
         set progr_unita_organizzativa = p_value
       where id_delega = p_id_delega;
   end set_progr_unita_organizzativa; -- deleghe_tpk.set_progr_unita_organizzativa
   --------------------------------------------------------------------------------
   procedure set_ruolo
   (
      p_id_delega in deleghe.id_delega%type
     ,p_value     in deleghe.ruolo%type default null
   ) is
      /******************************************************************************
       NOME:        set_ruolo
       DESCRIZIONE: Setter per attributo ruolo di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_delega => p_id_delega)
             ,'existsId on deleghe_tpk.set_ruolo');
      update deleghe set ruolo = p_value where id_delega = p_id_delega;
   end set_ruolo; -- deleghe_tpk.set_ruolo
   --------------------------------------------------------------------------------
   procedure set_id_competenza_delega
   (
      p_id_delega in deleghe.id_delega%type
     ,p_value     in deleghe.id_competenza_delega%type default null
   ) is
      /******************************************************************************
       NOME:        set_id_competenza_delega
       DESCRIZIONE: Setter per attributo id_competenza_delega di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_delega => p_id_delega)
             ,'existsId on deleghe_tpk.set_id_competenza_delega');
      update deleghe set id_competenza_delega = p_value where id_delega = p_id_delega;
   end set_id_competenza_delega; -- deleghe_tpk.set_id_competenza_delega
   --------------------------------------------------------------------------------
   procedure set_dal
   (
      p_id_delega in deleghe.id_delega%type
     ,p_value     in deleghe.dal%type default null
   ) is
      /******************************************************************************
       NOME:        set_dal
       DESCRIZIONE: Setter per attributo dal di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_delega => p_id_delega)
             ,'existsId on deleghe_tpk.set_dal');
      update deleghe set dal = p_value where id_delega = p_id_delega;
   end set_dal; -- deleghe_tpk.set_dal
   --------------------------------------------------------------------------------
   procedure set_al
   (
      p_id_delega in deleghe.id_delega%type
     ,p_value     in deleghe.al%type default null
   ) is
      /******************************************************************************
       NOME:        set_al
       DESCRIZIONE: Setter per attributo al di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_delega => p_id_delega)
             ,'existsId on deleghe_tpk.set_al');
      update deleghe set al = p_value where id_delega = p_id_delega;
   end set_al; -- deleghe_tpk.set_al
   --------------------------------------------------------------------------------
   procedure set_utente_aggiornamento
   (
      p_id_delega in deleghe.id_delega%type
     ,p_value     in deleghe.utente_aggiornamento%type default null
   ) is
      /******************************************************************************
       NOME:        set_utente_aggiornamento
       DESCRIZIONE: Setter per attributo utente_aggiornamento di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_delega => p_id_delega)
             ,'existsId on deleghe_tpk.set_utente_aggiornamento');
      update deleghe set utente_aggiornamento = p_value where id_delega = p_id_delega;
   end set_utente_aggiornamento; -- deleghe_tpk.set_utente_aggiornamento
   --------------------------------------------------------------------------------
   procedure set_data_aggiornamento
   (
      p_id_delega in deleghe.id_delega%type
     ,p_value     in deleghe.data_aggiornamento%type default null
   ) is
      /******************************************************************************
       NOME:        set_data_aggiornamento
       DESCRIZIONE: Setter per attributo data_aggiornamento di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_delega => p_id_delega)
             ,'existsId on deleghe_tpk.set_data_aggiornamento');
      update deleghe set data_aggiornamento = p_value where id_delega = p_id_delega;
   end set_data_aggiornamento; -- deleghe_tpk.set_data_aggiornamento
   --------------------------------------------------------------------------------
   function where_condition /* SLAVE_COPY */
   (
      p_qbe                       in number default 0
     ,p_other_condition           in varchar2 default null
     ,p_id_delega                 in varchar2 default null
     ,p_delegante                 in varchar2 default null
     ,p_delegato                  in varchar2 default null
     ,p_ottica                    in varchar2 default null
     ,p_progr_unita_organizzativa in varchar2 default null
     ,p_ruolo                     in varchar2 default null
     ,p_id_competenza_delega      in varchar2 default null
     ,p_dal                       in varchar2 default null
     ,p_al                        in varchar2 default null
     ,p_utente_aggiornamento      in varchar2 default null
     ,p_data_aggiornamento        in varchar2 default null
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
                     afc.get_field_condition(' and ( id_delega '
                                            ,p_id_delega
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( delegante '
                                            ,p_delegante
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( delegato '
                                            ,p_delegato
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( ottica '
                                            ,p_ottica
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( progr_unita_organizzativa '
                                            ,p_progr_unita_organizzativa
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( ruolo ', p_ruolo, ' )', p_qbe, null) ||
                     afc.get_field_condition(' and ( id_competenza_delega '
                                            ,p_id_competenza_delega
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
   end where_condition; --- deleghe_tpk.where_condition
   --------------------------------------------------------------------------------
   function get_rows
   (
      p_qbe                       in number default 0
     ,p_other_condition           in varchar2 default null
     ,p_order_by                  in varchar2 default null
     ,p_extra_columns             in varchar2 default null
     ,p_extra_condition           in varchar2 default null
     ,p_id_delega                 in varchar2 default null
     ,p_delegante                 in varchar2 default null
     ,p_delegato                  in varchar2 default null
     ,p_ottica                    in varchar2 default null
     ,p_progr_unita_organizzativa in varchar2 default null
     ,p_ruolo                     in varchar2 default null
     ,p_id_competenza_delega      in varchar2 default null
     ,p_dal                       in varchar2 default null
     ,p_al                        in varchar2 default null
     ,p_utente_aggiornamento      in varchar2 default null
     ,p_data_aggiornamento        in varchar2 default null
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
      d_statement  := ' select DELEGHE.* ' ||
                      afc.decode_value(p_extra_columns
                                      ,null
                                      ,null
                                      ,' , ' || p_extra_columns) || ' from DELEGHE ' ||
                      where_condition(p_qbe                       => p_qbe
                                     ,p_other_condition           => p_other_condition
                                     ,p_id_delega                 => p_id_delega
                                     ,p_delegante                 => p_delegante
                                     ,p_delegato                  => p_delegato
                                     ,p_ottica                    => p_ottica
                                     ,p_progr_unita_organizzativa => p_progr_unita_organizzativa
                                     ,p_ruolo                     => p_ruolo
                                     ,p_id_competenza_delega      => p_id_competenza_delega
                                     ,p_dal                       => p_dal
                                     ,p_al                        => p_al
                                     ,p_utente_aggiornamento      => p_utente_aggiornamento
                                     ,p_data_aggiornamento        => p_data_aggiornamento) || ' ' ||
                      p_extra_condition ||
                      afc.decode_value(p_order_by, null, null, ' order by ' || p_order_by);
      d_ref_cursor := afc_dml.get_ref_cursor(d_statement);
      return d_ref_cursor;
   end get_rows; -- deleghe_tpk.get_rows
   --------------------------------------------------------------------------------
   function count_rows
   (
      p_qbe                       in number default 0
     ,p_other_condition           in varchar2 default null
     ,p_id_delega                 in varchar2 default null
     ,p_delegante                 in varchar2 default null
     ,p_delegato                  in varchar2 default null
     ,p_ottica                    in varchar2 default null
     ,p_progr_unita_organizzativa in varchar2 default null
     ,p_ruolo                     in varchar2 default null
     ,p_id_competenza_delega      in varchar2 default null
     ,p_dal                       in varchar2 default null
     ,p_al                        in varchar2 default null
     ,p_utente_aggiornamento      in varchar2 default null
     ,p_data_aggiornamento        in varchar2 default null
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
      d_statement := ' select count( * ) from DELEGHE ' ||
                     where_condition(p_qbe                       => p_qbe
                                    ,p_other_condition           => p_other_condition
                                    ,p_id_delega                 => p_id_delega
                                    ,p_delegante                 => p_delegante
                                    ,p_delegato                  => p_delegato
                                    ,p_ottica                    => p_ottica
                                    ,p_progr_unita_organizzativa => p_progr_unita_organizzativa
                                    ,p_ruolo                     => p_ruolo
                                    ,p_id_competenza_delega      => p_id_competenza_delega
                                    ,p_dal                       => p_dal
                                    ,p_al                        => p_al
                                    ,p_utente_aggiornamento      => p_utente_aggiornamento
                                    ,p_data_aggiornamento        => p_data_aggiornamento);
      d_result    := afc.sql_execute(d_statement);
      return d_result;
   end count_rows; -- deleghe_tpk.count_rows
--------------------------------------------------------------------------------
end deleghe_tpk;
/

