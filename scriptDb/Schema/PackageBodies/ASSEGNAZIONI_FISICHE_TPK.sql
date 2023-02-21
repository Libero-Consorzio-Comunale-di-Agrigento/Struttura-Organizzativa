CREATE OR REPLACE package body assegnazioni_fisiche_tpk is
   /******************************************************************************
    NOME:        assegnazioni_fisiche_tpk
    DESCRIZIONE: Gestione tabella ASSEGNAZIONI_FISICHE.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore      Descrizione.
    000   16/08/2012  mmonari  Generazione automatica. 
   ******************************************************************************/
   s_revisione_body constant afc.t_revision := '000 - 16/08/2012';
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
   end versione; -- assegnazioni_fisiche_tpk.versione
   --------------------------------------------------------------------------------
   function pk(p_id_asfi in assegnazioni_fisiche.id_asfi%type) return t_pk is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        PK
       DESCRIZIONE: Costruttore di un t_PK dati gli attributi della chiave
      ******************************************************************************/
      d_result t_pk;
   begin
      d_result.id_asfi := p_id_asfi;
      dbc.pre(not dbc.preon or canhandle(p_id_asfi => d_result.id_asfi)
             ,'canHandle on assegnazioni_fisiche_tpk.PK');
      return d_result;
   end pk; -- assegnazioni_fisiche_tpk.PK
   --------------------------------------------------------------------------------
   function can_handle(p_id_asfi in assegnazioni_fisiche.id_asfi%type) return number is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        can_handle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti su assegnazioni fisiche
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: 1 se la chiave e manipolabile, 0 altrimenti.
       NOTE:        cfr. canHandle per ritorno valori boolean.
      ******************************************************************************/
      d_result number;
   begin
      d_result := 1;
      -- nelle chiavi primarie composte da piu attributi, ciascun attributo deve essere not null
      if d_result = 1 and (p_id_asfi is null) then
         d_result := 0;
      end if;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on assegnazioni_fisiche_tpk.can_handle');
      return d_result;
   end can_handle; -- assegnazioni_fisiche_tpk.can_handle
   --------------------------------------------------------------------------------
   function canhandle(p_id_asfi in assegnazioni_fisiche.id_asfi%type) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        canHandle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli assegnazioni fisiche
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: true se la chiave e manipolabile, false altrimenti.
       NOTE:        Wrapper boolean di can_handle (cfr. can_handle).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(can_handle(p_id_asfi => p_id_asfi));
   begin
      return d_result;
   end canhandle; -- assegnazioni_fisiche_tpk.canHandle
   --------------------------------------------------------------------------------
   function exists_id(p_id_asfi in assegnazioni_fisiche.id_asfi%type) return number is
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
      dbc.pre(not dbc.preon or canhandle(p_id_asfi => p_id_asfi)
             ,'canHandle on assegnazioni_fisiche_tpk.exists_id');
      begin
         select 1 into d_result from assegnazioni_fisiche where id_asfi = p_id_asfi;
      exception
         when no_data_found then
            d_result := 0;
      end;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on assegnazioni_fisiche_tpk.exists_id');
      return d_result;
   end exists_id; -- assegnazioni_fisiche_tpk.exists_id
   --------------------------------------------------------------------------------
   function existsid(p_id_asfi in assegnazioni_fisiche.id_asfi%type) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        existsId
       DESCRIZIONE: Esistenza riga con chiave indicata.
       NOTE:        Wrapper boolean di exists_id (cfr. exists_id).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(exists_id(p_id_asfi => p_id_asfi));
   begin
      return d_result;
   end existsid; -- assegnazioni_fisiche_tpk.existsId
   --------------------------------------------------------------------------------
   procedure ins
   (
      p_id_asfi                   in assegnazioni_fisiche.id_asfi%type default null
     ,p_id_ubicazione_componente  in assegnazioni_fisiche.id_ubicazione_componente%type default null
     ,p_ni                        in assegnazioni_fisiche.ni%type
     ,p_progr_unita_fisica        in assegnazioni_fisiche.progr_unita_fisica%type
     ,p_dal                       in assegnazioni_fisiche.dal%type
     ,p_al                        in assegnazioni_fisiche.al%type default null
     ,p_progr_unita_organizzativa in assegnazioni_fisiche.progr_unita_organizzativa%type default null
     ,p_utente_aggiornamento      in assegnazioni_fisiche.utente_aggiornamento%type default null
     ,p_data_aggiornamento        in assegnazioni_fisiche.data_aggiornamento%type default null
   ) is
      /******************************************************************************
       NOME:        ins
       DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
       PARAMETRI:   Chiavi e attributi della table.
      ******************************************************************************/
   begin
      -- Check Mandatory on Insert
   
      dbc.pre(not dbc.preon or p_id_ubicazione_componente is not null or /*default value*/
              'default' is not null
             ,'p_id_ubicazione_componente on assegnazioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_ni is not null or /*default value*/
              '' is not null
             ,'p_ni on assegnazioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_progr_unita_fisica is not null or /*default value*/
              '' is not null
             ,'p_progr_unita_fisica on assegnazioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_dal is not null or /*default value*/
              '' is not null
             ,'p_dal on assegnazioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_al is not null or /*default value*/
              'default' is not null
             ,'p_al on assegnazioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_progr_unita_organizzativa is not null or /*default value*/
              'default' is not null
             ,'p_progr_unita_organizzativa on assegnazioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_utente_aggiornamento is not null or /*default value*/
              'default' is not null
             ,'p_utente_aggiornamento on assegnazioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_data_aggiornamento is not null or /*default value*/
              'default' is not null
             ,'p_data_aggiornamento on assegnazioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or (p_id_asfi is null and /*default value*/
              'default null' is not null) -- PK nullable on insert
              or not existsid(p_id_asfi => p_id_asfi)
             ,'not existsId on assegnazioni_fisiche_tpk.ins');
      insert into assegnazioni_fisiche
         (id_asfi
         ,id_ubicazione_componente
         ,ni
         ,progr_unita_fisica
         ,dal
         ,al
         ,progr_unita_organizzativa
         ,utente_aggiornamento
         ,data_aggiornamento)
      values
         (p_id_asfi
         ,p_id_ubicazione_componente
         ,p_ni
         ,p_progr_unita_fisica
         ,p_dal
         ,p_al
         ,p_progr_unita_organizzativa
         ,p_utente_aggiornamento
         ,p_data_aggiornamento);
   end ins; -- assegnazioni_fisiche_tpk.ins
   --------------------------------------------------------------------------------
   function ins
   (
      p_id_asfi                   in assegnazioni_fisiche.id_asfi%type default null
     ,p_id_ubicazione_componente  in assegnazioni_fisiche.id_ubicazione_componente%type default null
     ,p_ni                        in assegnazioni_fisiche.ni%type
     ,p_progr_unita_fisica        in assegnazioni_fisiche.progr_unita_fisica%type
     ,p_dal                       in assegnazioni_fisiche.dal%type
     ,p_al                        in assegnazioni_fisiche.al%type default null
     ,p_progr_unita_organizzativa in assegnazioni_fisiche.progr_unita_organizzativa%type default null
     ,p_utente_aggiornamento      in assegnazioni_fisiche.utente_aggiornamento%type default null
     ,p_data_aggiornamento        in assegnazioni_fisiche.data_aggiornamento%type default null
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
   
      dbc.pre(not dbc.preon or p_id_ubicazione_componente is not null or /*default value*/
              'default' is not null
             ,'p_id_ubicazione_componente on assegnazioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_ni is not null or /*default value*/
              '' is not null
             ,'p_ni on assegnazioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_progr_unita_fisica is not null or /*default value*/
              '' is not null
             ,'p_progr_unita_fisica on assegnazioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_dal is not null or /*default value*/
              '' is not null
             ,'p_dal on assegnazioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_al is not null or /*default value*/
              'default' is not null
             ,'p_al on assegnazioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_progr_unita_organizzativa is not null or /*default value*/
              'default' is not null
             ,'p_progr_unita_organizzativa on assegnazioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_utente_aggiornamento is not null or /*default value*/
              'default' is not null
             ,'p_utente_aggiornamento on assegnazioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_data_aggiornamento is not null or /*default value*/
              'default' is not null
             ,'p_data_aggiornamento on assegnazioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or (p_id_asfi is null and /*default value*/
              'default null' is not null) -- PK nullable on insert
              or not existsid(p_id_asfi => p_id_asfi)
             ,'not existsId on assegnazioni_fisiche_tpk.ins');
      insert into assegnazioni_fisiche
         (id_asfi
         ,id_ubicazione_componente
         ,ni
         ,progr_unita_fisica
         ,dal
         ,al
         ,progr_unita_organizzativa
         ,utente_aggiornamento
         ,data_aggiornamento)
      values
         (p_id_asfi
         ,p_id_ubicazione_componente
         ,p_ni
         ,p_progr_unita_fisica
         ,p_dal
         ,p_al
         ,p_progr_unita_organizzativa
         ,p_utente_aggiornamento
         ,p_data_aggiornamento)
      returning id_asfi into d_result;
      return d_result;
   end ins; -- assegnazioni_fisiche_tpk.ins
   --------------------------------------------------------------------------------
   procedure upd
   (
      p_check_old                    in integer default 0
     ,p_new_id_asfi                  in assegnazioni_fisiche.id_asfi%type
     ,p_old_id_asfi                  in assegnazioni_fisiche.id_asfi%type default null
     ,p_new_id_ubicazione_componente in assegnazioni_fisiche.id_ubicazione_componente%type default afc.default_null('ASSEGNAZIONI_FISICHE.id_ubicazione_componente')
     ,p_old_id_ubicazione_componente in assegnazioni_fisiche.id_ubicazione_componente%type default null
     ,p_new_ni                       in assegnazioni_fisiche.ni%type default afc.default_null('ASSEGNAZIONI_FISICHE.ni')
     ,p_old_ni                       in assegnazioni_fisiche.ni%type default null
     ,p_new_progr_unita_fisica       in assegnazioni_fisiche.progr_unita_fisica%type default afc.default_null('ASSEGNAZIONI_FISICHE.progr_unita_fisica')
     ,p_old_progr_unita_fisica       in assegnazioni_fisiche.progr_unita_fisica%type default null
     ,p_new_dal                      in assegnazioni_fisiche.dal%type default afc.default_null('ASSEGNAZIONI_FISICHE.dal')
     ,p_old_dal                      in assegnazioni_fisiche.dal%type default null
     ,p_new_al                       in assegnazioni_fisiche.al%type default afc.default_null('ASSEGNAZIONI_FISICHE.al')
     ,p_old_al                       in assegnazioni_fisiche.al%type default null
     ,p_new_progr_unita_organizzativ in assegnazioni_fisiche.progr_unita_organizzativa%type default afc.default_null('ASSEGNAZIONI_FISICHE.progr_unita_organizzativa')
     ,p_old_progr_unita_organizzativ in assegnazioni_fisiche.progr_unita_organizzativa%type default null
     ,p_new_utente_aggiornamento     in assegnazioni_fisiche.utente_aggiornamento%type default afc.default_null('ASSEGNAZIONI_FISICHE.utente_aggiornamento')
     ,p_old_utente_aggiornamento     in assegnazioni_fisiche.utente_aggiornamento%type default null
     ,p_new_data_aggiornamento       in assegnazioni_fisiche.data_aggiornamento%type default afc.default_null('ASSEGNAZIONI_FISICHE.data_aggiornamento')
     ,p_old_data_aggiornamento       in assegnazioni_fisiche.data_aggiornamento%type default null
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
              not ((p_old_id_ubicazione_componente is not null or p_old_ni is not null or
               p_old_progr_unita_fisica is not null or p_old_dal is not null or
               p_old_al is not null or p_old_progr_unita_organizzativ is not null or
               p_old_utente_aggiornamento is not null or
               p_old_data_aggiornamento is not null) and (nvl(p_check_old, -1) = 0))
             ,' "OLD values" is not null on assegnazioni_fisiche_tpk.upd');
      d_key := pk(nvl(p_old_id_asfi, p_new_id_asfi));
      dbc.pre(not dbc.preon or existsid(p_id_asfi => d_key.id_asfi)
             ,'existsId on assegnazioni_fisiche_tpk.upd');
      update assegnazioni_fisiche
         set id_asfi                   = nvl(p_new_id_asfi
                                            ,decode(afc.is_default_null('ASSEGNAZIONI_FISICHE.id_asfi')
                                                   ,1
                                                   ,id_asfi
                                                   ,decode(p_check_old
                                                          ,0
                                                          ,null
                                                          ,decode(p_old_id_asfi
                                                                 ,null
                                                                 ,id_asfi
                                                                 ,null))))
            ,id_ubicazione_componente  = nvl(p_new_id_ubicazione_componente
                                            ,decode(afc.is_default_null('ASSEGNAZIONI_FISICHE.id_ubicazione_componente')
                                                   ,1
                                                   ,id_ubicazione_componente
                                                   ,decode(p_check_old
                                                          ,0
                                                          ,null
                                                          ,decode(p_old_id_ubicazione_componente
                                                                 ,null
                                                                 ,id_ubicazione_componente
                                                                 ,null))))
            ,ni                        = nvl(p_new_ni
                                            ,decode(afc.is_default_null('ASSEGNAZIONI_FISICHE.ni')
                                                   ,1
                                                   ,ni
                                                   ,decode(p_check_old
                                                          ,0
                                                          ,null
                                                          ,decode(p_old_ni
                                                                 ,null
                                                                 ,ni
                                                                 ,null))))
            ,progr_unita_fisica        = nvl(p_new_progr_unita_fisica
                                            ,decode(afc.is_default_null('ASSEGNAZIONI_FISICHE.progr_unita_fisica')
                                                   ,1
                                                   ,progr_unita_fisica
                                                   ,decode(p_check_old
                                                          ,0
                                                          ,null
                                                          ,decode(p_old_progr_unita_fisica
                                                                 ,null
                                                                 ,progr_unita_fisica
                                                                 ,null))))
            ,dal                       = nvl(p_new_dal
                                            ,decode(afc.is_default_null('ASSEGNAZIONI_FISICHE.dal')
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
                                            ,decode(afc.is_default_null('ASSEGNAZIONI_FISICHE.al')
                                                   ,1
                                                   ,al
                                                   ,decode(p_check_old
                                                          ,0
                                                          ,null
                                                          ,decode(p_old_al
                                                                 ,null
                                                                 ,al
                                                                 ,null))))
            ,progr_unita_organizzativa = nvl(p_new_progr_unita_organizzativ
                                            ,decode(afc.is_default_null('ASSEGNAZIONI_FISICHE.progr_unita_organizzativa')
                                                   ,1
                                                   ,progr_unita_organizzativa
                                                   ,decode(p_check_old
                                                          ,0
                                                          ,null
                                                          ,decode(p_old_progr_unita_organizzativ
                                                                 ,null
                                                                 ,progr_unita_organizzativa
                                                                 ,null))))
            ,utente_aggiornamento      = nvl(p_new_utente_aggiornamento
                                            ,decode(afc.is_default_null('ASSEGNAZIONI_FISICHE.utente_aggiornamento')
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
                                            ,decode(afc.is_default_null('ASSEGNAZIONI_FISICHE.data_aggiornamento')
                                                   ,1
                                                   ,data_aggiornamento
                                                   ,decode(p_check_old
                                                          ,0
                                                          ,null
                                                          ,decode(p_old_data_aggiornamento
                                                                 ,null
                                                                 ,data_aggiornamento
                                                                 ,null))))
       where id_asfi = d_key.id_asfi
         and (p_check_old = 0 or
             (1 = 1 and (id_ubicazione_componente = p_old_id_ubicazione_componente or
             (p_old_id_ubicazione_componente is null and
             (p_check_old is null or id_ubicazione_componente is null))) and
             (ni = p_old_ni or
             (p_old_ni is null and (p_check_old is null or ni is null))) and
             (progr_unita_fisica = p_old_progr_unita_fisica or
             (p_old_progr_unita_fisica is null and
             (p_check_old is null or progr_unita_fisica is null))) and
             (dal = p_old_dal or
             (p_old_dal is null and (p_check_old is null or dal is null))) and
             (al = p_old_al or
             (p_old_al is null and (p_check_old is null or al is null))) and
             (progr_unita_organizzativa = p_old_progr_unita_organizzativ or
             (p_old_progr_unita_organizzativ is null and
             (p_check_old is null or progr_unita_organizzativa is null))) and
             (utente_aggiornamento = p_old_utente_aggiornamento or
             (p_old_utente_aggiornamento is null and
             (p_check_old is null or utente_aggiornamento is null))) and
             (data_aggiornamento = p_old_data_aggiornamento or
             (p_old_data_aggiornamento is null and
             (p_check_old is null or data_aggiornamento is null)))));
      d_row_found := sql%rowcount;
      afc.default_null(null);
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on assegnazioni_fisiche_tpk.upd');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   end upd; -- assegnazioni_fisiche_tpk.upd
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_id_asfi       in assegnazioni_fisiche.id_asfi%type
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
      dbc.pre(not dbc.preon or existsid(p_id_asfi => p_id_asfi)
             ,'existsId on assegnazioni_fisiche_tpk.upd_column');
      dbc.pre(not dbc.preon or p_column is not null
             ,'p_column is not null on assegnazioni_fisiche_tpk.upd_column');
      dbc.pre(not dbc.preon or afc_ddl.hasattribute(s_table_name, p_column)
             ,'AFC_DDL.HasAttribute on assegnazioni_fisiche_tpk.upd_column');
      dbc.pre(p_literal_value in (0, 1) or p_literal_value is null
             ,'p_literal_value on assegnazioni_fisiche_tpk.upd_column; p_literal_value = ' ||
              p_literal_value);
      if p_literal_value = 1 or p_literal_value is null then
         d_literal := '''';
      end if;
      d_statement := ' declare ' || '    d_row_found number; ' || ' begin ' ||
                     '    update ASSEGNAZIONI_FISICHE ' || '       set ' || p_column ||
                     ' = ' || d_literal || p_value || d_literal || '     where 1 = 1 ' ||
                     nvl(afc.get_field_condition(' and ( id_asfi '
                                                ,p_id_asfi
                                                ,' )'
                                                ,0
                                                ,null)
                        ,' and ( id_asfi is null ) ') || '    ; ' ||
                     '    d_row_found := SQL%ROWCOUNT; ' || '    if d_row_found < 1 ' ||
                     '    then ' ||
                     '       raise_application_error ( AFC_ERROR.modified_by_other_user_number, AFC_ERROR.modified_by_other_user_msg ); ' ||
                     '    end if; ' || ' end; ';
      afc.sql_execute(d_statement);
   end upd_column; -- assegnazioni_fisiche_tpk.upd_column
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_id_asfi in assegnazioni_fisiche.id_asfi%type
     ,p_column  in varchar2
     ,p_value   in date
   ) is
      /******************************************************************************
       NOME:        upd_column
       DESCRIZIONE: Aggiornamento del campo p_column col valore p_value.
       NOTE:        Richiama se stessa con il parametro date convertito in stringa.
      ******************************************************************************/
      d_data varchar2(19);
   begin
      d_data := to_char(p_value, afc.date_format);
      upd_column(p_id_asfi       => p_id_asfi
                ,p_column        => p_column
                ,p_value         => 'to_date( ''' || d_data || ''', ''' ||
                                    afc.date_format || ''' )'
                ,p_literal_value => 0);
   end upd_column; -- assegnazioni_fisiche_tpk.upd_column
   --------------------------------------------------------------------------------
   procedure del
   (
      p_check_old                 in integer default 0
     ,p_id_asfi                   in assegnazioni_fisiche.id_asfi%type
     ,p_id_ubicazione_componente  in assegnazioni_fisiche.id_ubicazione_componente%type default null
     ,p_ni                        in assegnazioni_fisiche.ni%type default null
     ,p_progr_unita_fisica        in assegnazioni_fisiche.progr_unita_fisica%type default null
     ,p_dal                       in assegnazioni_fisiche.dal%type default null
     ,p_al                        in assegnazioni_fisiche.al%type default null
     ,p_progr_unita_organizzativa in assegnazioni_fisiche.progr_unita_organizzativa%type default null
     ,p_utente_aggiornamento      in assegnazioni_fisiche.utente_aggiornamento%type default null
     ,p_data_aggiornamento        in assegnazioni_fisiche.data_aggiornamento%type default null
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
              not ((p_id_ubicazione_componente is not null or p_ni is not null or
               p_progr_unita_fisica is not null or p_dal is not null or
               p_al is not null or p_progr_unita_organizzativa is not null or
               p_utente_aggiornamento is not null or
               p_data_aggiornamento is not null) and (nvl(p_check_old, -1) = 0))
             ,' "OLD values" is not null on assegnazioni_fisiche_tpk.del');
      dbc.pre(not dbc.preon or existsid(p_id_asfi => p_id_asfi)
             ,'existsId on assegnazioni_fisiche_tpk.del');
      delete from assegnazioni_fisiche
       where id_asfi = p_id_asfi
         and (p_check_old = 0 or
             (1 = 1 and (id_ubicazione_componente = p_id_ubicazione_componente or
             (p_id_ubicazione_componente is null and
             (p_check_old is null or id_ubicazione_componente is null))) and
             (ni = p_ni or (p_ni is null and (p_check_old is null or ni is null))) and
             (progr_unita_fisica = p_progr_unita_fisica or
             (p_progr_unita_fisica is null and
             (p_check_old is null or progr_unita_fisica is null))) and
             (dal = p_dal or (p_dal is null and (p_check_old is null or dal is null))) and
             (al = p_al or (p_al is null and (p_check_old is null or al is null))) and
             (progr_unita_organizzativa = p_progr_unita_organizzativa or
             (p_progr_unita_organizzativa is null and
             (p_check_old is null or progr_unita_organizzativa is null))) and
             (utente_aggiornamento = p_utente_aggiornamento or
             (p_utente_aggiornamento is null and
             (p_check_old is null or utente_aggiornamento is null))) and
             (data_aggiornamento = p_data_aggiornamento or
             (p_data_aggiornamento is null and
             (p_check_old is null or data_aggiornamento is null)))));
      d_row_found := sql%rowcount;
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on assegnazioni_fisiche_tpk.del');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
      dbc.post(not dbc.poston or not existsid(p_id_asfi => p_id_asfi)
              ,'existsId on assegnazioni_fisiche_tpk.del');
   end del; -- assegnazioni_fisiche_tpk.del
   --------------------------------------------------------------------------------
   function get_id_ubicazione_componente(p_id_asfi in assegnazioni_fisiche.id_asfi%type)
      return assegnazioni_fisiche.id_ubicazione_componente%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_id_ubicazione_componente
       DESCRIZIONE: Getter per attributo id_ubicazione_componente di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ASSEGNAZIONI_FISICHE.id_ubicazione_componente%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result assegnazioni_fisiche.id_ubicazione_componente%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_asfi => p_id_asfi)
             ,'existsId on assegnazioni_fisiche_tpk.get_id_ubicazione_componente');
      select id_ubicazione_componente
        into d_result
        from assegnazioni_fisiche
       where id_asfi = p_id_asfi;
   
      return d_result;
   end get_id_ubicazione_componente; -- assegnazioni_fisiche_tpk.get_id_ubicazione_componente
   --------------------------------------------------------------------------------
   function get_ni(p_id_asfi in assegnazioni_fisiche.id_asfi%type)
      return assegnazioni_fisiche.ni%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_ni
       DESCRIZIONE: Getter per attributo ni di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ASSEGNAZIONI_FISICHE.ni%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result assegnazioni_fisiche.ni%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_asfi => p_id_asfi)
             ,'existsId on assegnazioni_fisiche_tpk.get_ni');
      select ni into d_result from assegnazioni_fisiche where id_asfi = p_id_asfi;
   
      return d_result;
   end get_ni; -- assegnazioni_fisiche_tpk.get_ni
   --------------------------------------------------------------------------------
   function get_progr_unita_fisica(p_id_asfi in assegnazioni_fisiche.id_asfi%type)
      return assegnazioni_fisiche.progr_unita_fisica%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_progr_unita_fisica
       DESCRIZIONE: Getter per attributo progr_unita_fisica di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ASSEGNAZIONI_FISICHE.progr_unita_fisica%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result assegnazioni_fisiche.progr_unita_fisica%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_asfi => p_id_asfi)
             ,'existsId on assegnazioni_fisiche_tpk.get_progr_unita_fisica');
      select progr_unita_fisica
        into d_result
        from assegnazioni_fisiche
       where id_asfi = p_id_asfi;
   
      return d_result;
   end get_progr_unita_fisica; -- assegnazioni_fisiche_tpk.get_progr_unita_fisica
   --------------------------------------------------------------------------------
   function get_dal(p_id_asfi in assegnazioni_fisiche.id_asfi%type)
      return assegnazioni_fisiche.dal%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_dal
       DESCRIZIONE: Getter per attributo dal di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ASSEGNAZIONI_FISICHE.dal%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result assegnazioni_fisiche.dal%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_asfi => p_id_asfi)
             ,'existsId on assegnazioni_fisiche_tpk.get_dal');
      select dal into d_result from assegnazioni_fisiche where id_asfi = p_id_asfi;
   
      return d_result;
   end get_dal; -- assegnazioni_fisiche_tpk.get_dal
   --------------------------------------------------------------------------------
   function get_al(p_id_asfi in assegnazioni_fisiche.id_asfi%type)
      return assegnazioni_fisiche.al%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_al
       DESCRIZIONE: Getter per attributo al di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ASSEGNAZIONI_FISICHE.al%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result assegnazioni_fisiche.al%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_asfi => p_id_asfi)
             ,'existsId on assegnazioni_fisiche_tpk.get_al');
      select al into d_result from assegnazioni_fisiche where id_asfi = p_id_asfi;
   
      return d_result;
   end get_al; -- assegnazioni_fisiche_tpk.get_al
   --------------------------------------------------------------------------------
   function get_progr_unita_organizzativa(p_id_asfi in assegnazioni_fisiche.id_asfi%type)
      return assegnazioni_fisiche.progr_unita_organizzativa%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_progr_unita_organizzativa
       DESCRIZIONE: Getter per attributo progr_unita_organizzativa di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ASSEGNAZIONI_FISICHE.progr_unita_organizzativa%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result assegnazioni_fisiche.progr_unita_organizzativa%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_asfi => p_id_asfi)
             ,'existsId on assegnazioni_fisiche_tpk.get_progr_unita_organizzativa');
      select progr_unita_organizzativa
        into d_result
        from assegnazioni_fisiche
       where id_asfi = p_id_asfi;
   
      return d_result;
   end get_progr_unita_organizzativa; -- assegnazioni_fisiche_tpk.get_progr_unita_organizzativa
   --------------------------------------------------------------------------------
   function get_utente_aggiornamento(p_id_asfi in assegnazioni_fisiche.id_asfi%type)
      return assegnazioni_fisiche.utente_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_utente_aggiornamento
       DESCRIZIONE: Getter per attributo utente_aggiornamento di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ASSEGNAZIONI_FISICHE.utente_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result assegnazioni_fisiche.utente_aggiornamento%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_asfi => p_id_asfi)
             ,'existsId on assegnazioni_fisiche_tpk.get_utente_aggiornamento');
      select utente_aggiornamento
        into d_result
        from assegnazioni_fisiche
       where id_asfi = p_id_asfi;
   
      return d_result;
   end get_utente_aggiornamento; -- assegnazioni_fisiche_tpk.get_utente_aggiornamento
   --------------------------------------------------------------------------------
   function get_data_aggiornamento(p_id_asfi in assegnazioni_fisiche.id_asfi%type)
      return assegnazioni_fisiche.data_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_data_aggiornamento
       DESCRIZIONE: Getter per attributo data_aggiornamento di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ASSEGNAZIONI_FISICHE.data_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result assegnazioni_fisiche.data_aggiornamento%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_asfi => p_id_asfi)
             ,'existsId on assegnazioni_fisiche_tpk.get_data_aggiornamento');
      select data_aggiornamento
        into d_result
        from assegnazioni_fisiche
       where id_asfi = p_id_asfi;
   
      return d_result;
   end get_data_aggiornamento; -- assegnazioni_fisiche_tpk.get_data_aggiornamento
   --------------------------------------------------------------------------------
   procedure set_id_asfi
   (
      p_id_asfi in assegnazioni_fisiche.id_asfi%type
     ,p_value   in assegnazioni_fisiche.id_asfi%type default null
   ) is
      /******************************************************************************
       NOME:        set_id_asfi
       DESCRIZIONE: Setter per attributo id_asfi di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_asfi => p_id_asfi)
             ,'existsId on assegnazioni_fisiche_tpk.set_id_asfi');
      update assegnazioni_fisiche set id_asfi = p_value where id_asfi = p_id_asfi;
   end set_id_asfi; -- assegnazioni_fisiche_tpk.set_id_asfi
   --------------------------------------------------------------------------------
   procedure set_id_ubicazione_componente
   (
      p_id_asfi in assegnazioni_fisiche.id_asfi%type
     ,p_value   in assegnazioni_fisiche.id_ubicazione_componente%type default null
   ) is
      /******************************************************************************
       NOME:        set_id_ubicazione_componente
       DESCRIZIONE: Setter per attributo id_ubicazione_componente di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_asfi => p_id_asfi)
             ,'existsId on assegnazioni_fisiche_tpk.set_id_ubicazione_componente');
      update assegnazioni_fisiche
         set id_ubicazione_componente = p_value
       where id_asfi = p_id_asfi;
   end set_id_ubicazione_componente; -- assegnazioni_fisiche_tpk.set_id_ubicazione_componente
   --------------------------------------------------------------------------------
   procedure set_ni
   (
      p_id_asfi in assegnazioni_fisiche.id_asfi%type
     ,p_value   in assegnazioni_fisiche.ni%type default null
   ) is
      /******************************************************************************
       NOME:        set_ni
       DESCRIZIONE: Setter per attributo ni di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_asfi => p_id_asfi)
             ,'existsId on assegnazioni_fisiche_tpk.set_ni');
      update assegnazioni_fisiche set ni = p_value where id_asfi = p_id_asfi;
   end set_ni; -- assegnazioni_fisiche_tpk.set_ni
   --------------------------------------------------------------------------------
   procedure set_progr_unita_fisica
   (
      p_id_asfi in assegnazioni_fisiche.id_asfi%type
     ,p_value   in assegnazioni_fisiche.progr_unita_fisica%type default null
   ) is
      /******************************************************************************
       NOME:        set_progr_unita_fisica
       DESCRIZIONE: Setter per attributo progr_unita_fisica di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_asfi => p_id_asfi)
             ,'existsId on assegnazioni_fisiche_tpk.set_progr_unita_fisica');
      update assegnazioni_fisiche
         set progr_unita_fisica = p_value
       where id_asfi = p_id_asfi;
   end set_progr_unita_fisica; -- assegnazioni_fisiche_tpk.set_progr_unita_fisica
   --------------------------------------------------------------------------------
   procedure set_dal
   (
      p_id_asfi in assegnazioni_fisiche.id_asfi%type
     ,p_value   in assegnazioni_fisiche.dal%type default null
   ) is
      /******************************************************************************
       NOME:        set_dal
       DESCRIZIONE: Setter per attributo dal di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_asfi => p_id_asfi)
             ,'existsId on assegnazioni_fisiche_tpk.set_dal');
      update assegnazioni_fisiche set dal = p_value where id_asfi = p_id_asfi;
   end set_dal; -- assegnazioni_fisiche_tpk.set_dal
   --------------------------------------------------------------------------------
   procedure set_al
   (
      p_id_asfi in assegnazioni_fisiche.id_asfi%type
     ,p_value   in assegnazioni_fisiche.al%type default null
   ) is
      /******************************************************************************
       NOME:        set_al
       DESCRIZIONE: Setter per attributo al di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_asfi => p_id_asfi)
             ,'existsId on assegnazioni_fisiche_tpk.set_al');
      update assegnazioni_fisiche set al = p_value where id_asfi = p_id_asfi;
   end set_al; -- assegnazioni_fisiche_tpk.set_al
   --------------------------------------------------------------------------------
   procedure set_progr_unita_organizzativa
   (
      p_id_asfi in assegnazioni_fisiche.id_asfi%type
     ,p_value   in assegnazioni_fisiche.progr_unita_organizzativa%type default null
   ) is
      /******************************************************************************
       NOME:        set_progr_unita_organizzativa
       DESCRIZIONE: Setter per attributo progr_unita_organizzativa di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_asfi => p_id_asfi)
             ,'existsId on assegnazioni_fisiche_tpk.set_progr_unita_organizzativa');
      update assegnazioni_fisiche
         set progr_unita_organizzativa = p_value
       where id_asfi = p_id_asfi;
   end set_progr_unita_organizzativa; -- assegnazioni_fisiche_tpk.set_progr_unita_organizzativa
   --------------------------------------------------------------------------------
   procedure set_utente_aggiornamento
   (
      p_id_asfi in assegnazioni_fisiche.id_asfi%type
     ,p_value   in assegnazioni_fisiche.utente_aggiornamento%type default null
   ) is
      /******************************************************************************
       NOME:        set_utente_aggiornamento
       DESCRIZIONE: Setter per attributo utente_aggiornamento di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_asfi => p_id_asfi)
             ,'existsId on assegnazioni_fisiche_tpk.set_utente_aggiornamento');
      update assegnazioni_fisiche
         set utente_aggiornamento = p_value
       where id_asfi = p_id_asfi;
   end set_utente_aggiornamento; -- assegnazioni_fisiche_tpk.set_utente_aggiornamento
   --------------------------------------------------------------------------------
   procedure set_data_aggiornamento
   (
      p_id_asfi in assegnazioni_fisiche.id_asfi%type
     ,p_value   in assegnazioni_fisiche.data_aggiornamento%type default null
   ) is
      /******************************************************************************
       NOME:        set_data_aggiornamento
       DESCRIZIONE: Setter per attributo data_aggiornamento di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_asfi => p_id_asfi)
             ,'existsId on assegnazioni_fisiche_tpk.set_data_aggiornamento');
      update assegnazioni_fisiche
         set data_aggiornamento = p_value
       where id_asfi = p_id_asfi;
   end set_data_aggiornamento; -- assegnazioni_fisiche_tpk.set_data_aggiornamento
   --------------------------------------------------------------------------------
   function where_condition /* SLAVE_COPY */
   (
      p_qbe                       in number default 0
     ,p_other_condition           in varchar2 default null
     ,p_id_asfi                   in varchar2 default null
     ,p_id_ubicazione_componente  in varchar2 default null
     ,p_ni                        in varchar2 default null
     ,p_progr_unita_fisica        in varchar2 default null
     ,p_dal                       in varchar2 default null
     ,p_al                        in varchar2 default null
     ,p_progr_unita_organizzativa in varchar2 default null
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
                     afc.get_field_condition(' and ( id_asfi '
                                            ,p_id_asfi
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( id_ubicazione_componente '
                                            ,p_id_ubicazione_componente
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( ni ', p_ni, ' )', p_qbe, null) ||
                     afc.get_field_condition(' and ( progr_unita_fisica '
                                            ,p_progr_unita_fisica
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
                     afc.get_field_condition(' and ( progr_unita_organizzativa '
                                            ,p_progr_unita_organizzativa
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
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
   end where_condition; --- assegnazioni_fisiche_tpk.where_condition
   --------------------------------------------------------------------------------
   function get_rows
   (
      p_qbe                       in number default 0
     ,p_other_condition           in varchar2 default null
     ,p_order_by                  in varchar2 default null
     ,p_extra_columns             in varchar2 default null
     ,p_extra_condition           in varchar2 default null
     ,p_id_asfi                   in varchar2 default null
     ,p_id_ubicazione_componente  in varchar2 default null
     ,p_ni                        in varchar2 default null
     ,p_progr_unita_fisica        in varchar2 default null
     ,p_dal                       in varchar2 default null
     ,p_al                        in varchar2 default null
     ,p_progr_unita_organizzativa in varchar2 default null
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
      d_statement  := ' select ASSEGNAZIONI_FISICHE.* ' ||
                      afc.decode_value(p_extra_columns
                                      ,null
                                      ,null
                                      ,' , ' || p_extra_columns) ||
                      ' from ASSEGNAZIONI_FISICHE ' ||
                      where_condition(p_qbe                       => p_qbe
                                     ,p_other_condition           => p_other_condition
                                     ,p_id_asfi                   => p_id_asfi
                                     ,p_id_ubicazione_componente  => p_id_ubicazione_componente
                                     ,p_ni                        => p_ni
                                     ,p_progr_unita_fisica        => p_progr_unita_fisica
                                     ,p_dal                       => p_dal
                                     ,p_al                        => p_al
                                     ,p_progr_unita_organizzativa => p_progr_unita_organizzativa
                                     ,p_utente_aggiornamento      => p_utente_aggiornamento
                                     ,p_data_aggiornamento        => p_data_aggiornamento) || ' ' ||
                      p_extra_condition ||
                      afc.decode_value(p_order_by, null, null, ' order by ' || p_order_by);
      d_ref_cursor := afc_dml.get_ref_cursor(d_statement);
      return d_ref_cursor;
   end get_rows; -- assegnazioni_fisiche_tpk.get_rows
   --------------------------------------------------------------------------------
   function count_rows
   (
      p_qbe                       in number default 0
     ,p_other_condition           in varchar2 default null
     ,p_id_asfi                   in varchar2 default null
     ,p_id_ubicazione_componente  in varchar2 default null
     ,p_ni                        in varchar2 default null
     ,p_progr_unita_fisica        in varchar2 default null
     ,p_dal                       in varchar2 default null
     ,p_al                        in varchar2 default null
     ,p_progr_unita_organizzativa in varchar2 default null
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
      d_statement := ' select count( * ) from ASSEGNAZIONI_FISICHE ' ||
                     where_condition(p_qbe                       => p_qbe
                                    ,p_other_condition           => p_other_condition
                                    ,p_id_asfi                   => p_id_asfi
                                    ,p_id_ubicazione_componente  => p_id_ubicazione_componente
                                    ,p_ni                        => p_ni
                                    ,p_progr_unita_fisica        => p_progr_unita_fisica
                                    ,p_dal                       => p_dal
                                    ,p_al                        => p_al
                                    ,p_progr_unita_organizzativa => p_progr_unita_organizzativa
                                    ,p_utente_aggiornamento      => p_utente_aggiornamento
                                    ,p_data_aggiornamento        => p_data_aggiornamento);
      d_result    := afc.sql_execute(d_statement);
      return d_result;
   end count_rows; -- assegnazioni_fisiche_tpk.count_rows
--------------------------------------------------------------------------------

end assegnazioni_fisiche_tpk;
/

