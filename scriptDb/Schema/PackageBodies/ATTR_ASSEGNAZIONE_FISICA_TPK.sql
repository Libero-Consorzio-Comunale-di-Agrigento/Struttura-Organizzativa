CREATE OR REPLACE package body attr_assegnazione_fisica_tpk is
   /******************************************************************************
    NOME:        attr_assegnazione_fisica_tpk
    DESCRIZIONE: Gestione tabella ATTRIBUTI_ASSEGNAZIONE_FISICA.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore      Descrizione.
    000   29/08/2012  mmonari  Generazione automatica. 
   ******************************************************************************/
   s_revisione_body constant afc.t_revision := '000 - 29/08/2012';
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
   end versione; -- attr_assegnazione_fisica_tpk.versione
   --------------------------------------------------------------------------------
   function pk
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
   ) return t_pk is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        PK
       DESCRIZIONE: Costruttore di un t_PK dati gli attributi della chiave
      ******************************************************************************/
      d_result t_pk;
   begin
      d_result.id_asfi   := p_id_asfi;
      d_result.attributo := p_attributo;
      d_result.dal       := p_dal;
      dbc.pre(not dbc.preon or canhandle(p_id_asfi   => d_result.id_asfi
                                        ,p_attributo => d_result.attributo
                                        ,p_dal       => d_result.dal)
             ,'canHandle on attr_assegnazione_fisica_tpk.PK');
      return d_result;
   end pk; -- attr_assegnazione_fisica_tpk.PK
   --------------------------------------------------------------------------------
   function can_handle
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
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
      if d_result = 1 and (p_id_asfi is null or p_attributo is null or p_dal is null) then
         d_result := 0;
      end if;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on attr_assegnazione_fisica_tpk.can_handle');
      return d_result;
   end can_handle; -- attr_assegnazione_fisica_tpk.can_handle
   --------------------------------------------------------------------------------
   function canhandle
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
   ) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        canHandle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: true se la chiave e manipolabile, false altrimenti.
       NOTE:        Wrapper boolean di can_handle (cfr. can_handle).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(can_handle(p_id_asfi   => p_id_asfi
                                                            ,p_attributo => p_attributo
                                                            ,p_dal       => p_dal));
   begin
      return d_result;
   end canhandle; -- attr_assegnazione_fisica_tpk.canHandle
   --------------------------------------------------------------------------------
   function exists_id
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
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
      dbc.pre(not dbc.preon or canhandle(p_id_asfi   => p_id_asfi
                                        ,p_attributo => p_attributo
                                        ,p_dal       => p_dal)
             ,'canHandle on attr_assegnazione_fisica_tpk.exists_id');
      begin
         select 1
           into d_result
           from attributi_assegnazione_fisica
          where id_asfi = p_id_asfi
            and attributo = p_attributo
            and dal = p_dal;
      exception
         when no_data_found then
            d_result := 0;
      end;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on attr_assegnazione_fisica_tpk.exists_id');
      return d_result;
   end exists_id; -- attr_assegnazione_fisica_tpk.exists_id
   --------------------------------------------------------------------------------
   function existsid
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
   ) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        existsId
       DESCRIZIONE: Esistenza riga con chiave indicata.
       NOTE:        Wrapper boolean di exists_id (cfr. exists_id).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(exists_id(p_id_asfi   => p_id_asfi
                                                           ,p_attributo => p_attributo
                                                           ,p_dal       => p_dal));
   begin
      return d_result;
   end existsid; -- attr_assegnazione_fisica_tpk.existsId
   --------------------------------------------------------------------------------
   procedure ins
   (
      p_id_asfi              in attributi_assegnazione_fisica.id_asfi%type default null
     ,p_attributo            in attributi_assegnazione_fisica.attributo%type
     ,p_dal                  in attributi_assegnazione_fisica.dal%type
     ,p_al                   in attributi_assegnazione_fisica.al%type default null
     ,p_valore               in attributi_assegnazione_fisica.valore%type default null
     ,p_utente_aggiornamento in attributi_assegnazione_fisica.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in attributi_assegnazione_fisica.data_aggiornamento%type default null
   ) is
      /******************************************************************************
       NOME:        ins
       DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
       PARAMETRI:   Chiavi e attributi della table.
      ******************************************************************************/
   begin
      -- Check Mandatory on Insert
   
      dbc.pre(not dbc.preon or p_al is not null or /*default value*/
              'default' is not null
             ,'p_al on attr_assegnazione_fisica_tpk.ins');
      dbc.pre(not dbc.preon or p_valore is not null or /*default value*/
              'default' is not null
             ,'p_valore on attr_assegnazione_fisica_tpk.ins');
      dbc.pre(not dbc.preon or p_utente_aggiornamento is not null or /*default value*/
              'default' is not null
             ,'p_utente_aggiornamento on attr_assegnazione_fisica_tpk.ins');
      dbc.pre(not dbc.preon or p_data_aggiornamento is not null or /*default value*/
              'default' is not null
             ,'p_data_aggiornamento on attr_assegnazione_fisica_tpk.ins');
      dbc.pre(not dbc.preon or (p_id_asfi is null and /*default value*/
              'default null' is not null) -- PK nullable on insert
              or (p_attributo is null and /*default value*/
              '' is not null) -- PK nullable on insert
              or (p_dal is null and /*default value*/
              '' is not null) -- PK nullable on insert
              or not existsid(p_id_asfi   => p_id_asfi
                             ,p_attributo => p_attributo
                             ,p_dal       => p_dal)
             ,'not existsId on attr_assegnazione_fisica_tpk.ins');
      insert into attributi_assegnazione_fisica
         (id_asfi
         ,attributo
         ,dal
         ,al
         ,valore
         ,utente_aggiornamento
         ,data_aggiornamento)
      values
         (p_id_asfi
         ,p_attributo
         ,p_dal
         ,p_al
         ,p_valore
         ,p_utente_aggiornamento
         ,p_data_aggiornamento);
   end ins; -- attr_assegnazione_fisica_tpk.ins
   --------------------------------------------------------------------------------
   function ins
   (
      p_id_asfi              in attributi_assegnazione_fisica.id_asfi%type default null
     ,p_attributo            in attributi_assegnazione_fisica.attributo%type
     ,p_dal                  in attributi_assegnazione_fisica.dal%type
     ,p_al                   in attributi_assegnazione_fisica.al%type default null
     ,p_valore               in attributi_assegnazione_fisica.valore%type default null
     ,p_utente_aggiornamento in attributi_assegnazione_fisica.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in attributi_assegnazione_fisica.data_aggiornamento%type default null
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
   
      dbc.pre(not dbc.preon or p_al is not null or /*default value*/
              'default' is not null
             ,'p_al on attr_assegnazione_fisica_tpk.ins');
      dbc.pre(not dbc.preon or p_valore is not null or /*default value*/
              'default' is not null
             ,'p_valore on attr_assegnazione_fisica_tpk.ins');
      dbc.pre(not dbc.preon or p_utente_aggiornamento is not null or /*default value*/
              'default' is not null
             ,'p_utente_aggiornamento on attr_assegnazione_fisica_tpk.ins');
      dbc.pre(not dbc.preon or p_data_aggiornamento is not null or /*default value*/
              'default' is not null
             ,'p_data_aggiornamento on attr_assegnazione_fisica_tpk.ins');
      dbc.pre(not dbc.preon or (p_id_asfi is null and /*default value*/
              'default null' is not null) -- PK nullable on insert
              or (p_attributo is null and /*default value*/
              '' is not null) -- PK nullable on insert
              or (p_dal is null and /*default value*/
              '' is not null) -- PK nullable on insert
              or not existsid(p_id_asfi   => p_id_asfi
                             ,p_attributo => p_attributo
                             ,p_dal       => p_dal)
             ,'not existsId on attr_assegnazione_fisica_tpk.ins');
      insert into attributi_assegnazione_fisica
         (id_asfi
         ,attributo
         ,dal
         ,al
         ,valore
         ,utente_aggiornamento
         ,data_aggiornamento)
      values
         (p_id_asfi
         ,p_attributo
         ,p_dal
         ,p_al
         ,p_valore
         ,p_utente_aggiornamento
         ,p_data_aggiornamento);
      d_result := 0;
      return d_result;
   end ins; -- attr_assegnazione_fisica_tpk.ins
   --------------------------------------------------------------------------------
   procedure upd
   (
      p_check_old                in integer default 0
     ,p_new_id_asfi              in attributi_assegnazione_fisica.id_asfi%type
     ,p_old_id_asfi              in attributi_assegnazione_fisica.id_asfi%type default null
     ,p_new_attributo            in attributi_assegnazione_fisica.attributo%type
     ,p_old_attributo            in attributi_assegnazione_fisica.attributo%type default null
     ,p_new_dal                  in attributi_assegnazione_fisica.dal%type
     ,p_old_dal                  in attributi_assegnazione_fisica.dal%type default null
     ,p_new_al                   in attributi_assegnazione_fisica.al%type default afc.default_null('ATTRIBUTI_ASSEGNAZIONE_FISICA.al')
     ,p_old_al                   in attributi_assegnazione_fisica.al%type default null
     ,p_new_valore               in attributi_assegnazione_fisica.valore%type default afc.default_null('ATTRIBUTI_ASSEGNAZIONE_FISICA.valore')
     ,p_old_valore               in attributi_assegnazione_fisica.valore%type default null
     ,p_new_utente_aggiornamento in attributi_assegnazione_fisica.utente_aggiornamento%type default afc.default_null('ATTRIBUTI_ASSEGNAZIONE_FISICA.utente_aggiornamento')
     ,p_old_utente_aggiornamento in attributi_assegnazione_fisica.utente_aggiornamento%type default null
     ,p_new_data_aggiornamento   in attributi_assegnazione_fisica.data_aggiornamento%type default afc.default_null('ATTRIBUTI_ASSEGNAZIONE_FISICA.data_aggiornamento')
     ,p_old_data_aggiornamento   in attributi_assegnazione_fisica.data_aggiornamento%type default null
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
              not ((p_old_al is not null or p_old_valore is not null or
               p_old_utente_aggiornamento is not null or
               p_old_data_aggiornamento is not null) and (nvl(p_check_old, -1) = 0))
             ,' "OLD values" is not null on attr_assegnazione_fisica_tpk.upd');
      d_key := pk(nvl(p_old_id_asfi, p_new_id_asfi)
                 ,nvl(p_old_attributo, p_new_attributo)
                 ,nvl(p_old_dal, p_new_dal));
      dbc.pre(not dbc.preon or existsid(p_id_asfi   => d_key.id_asfi
                                       ,p_attributo => d_key.attributo
                                       ,p_dal       => d_key.dal)
             ,'existsId on attr_assegnazione_fisica_tpk.upd');
      update attributi_assegnazione_fisica
         set id_asfi              = nvl(p_new_id_asfi
                                       ,decode(afc.is_default_null('ATTRIBUTI_ASSEGNAZIONE_FISICA.id_asfi')
                                              ,1
                                              ,id_asfi
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_id_asfi
                                                            ,null
                                                            ,id_asfi
                                                            ,null))))
            ,attributo            = nvl(p_new_attributo
                                       ,decode(afc.is_default_null('ATTRIBUTI_ASSEGNAZIONE_FISICA.attributo')
                                              ,1
                                              ,attributo
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_attributo
                                                            ,null
                                                            ,attributo
                                                            ,null))))
            ,dal                  = nvl(p_new_dal
                                       ,decode(afc.is_default_null('ATTRIBUTI_ASSEGNAZIONE_FISICA.dal')
                                              ,1
                                              ,dal
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_dal, null, dal, null))))
            ,al                   = nvl(p_new_al
                                       ,decode(afc.is_default_null('ATTRIBUTI_ASSEGNAZIONE_FISICA.al')
                                              ,1
                                              ,al
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_al, null, al, null))))
            ,valore               = nvl(p_new_valore
                                       ,decode(afc.is_default_null('ATTRIBUTI_ASSEGNAZIONE_FISICA.valore')
                                              ,1
                                              ,valore
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_valore
                                                            ,null
                                                            ,valore
                                                            ,null))))
            ,utente_aggiornamento = nvl(p_new_utente_aggiornamento
                                       ,decode(afc.is_default_null('ATTRIBUTI_ASSEGNAZIONE_FISICA.utente_aggiornamento')
                                              ,1
                                              ,utente_aggiornamento
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_utente_aggiornamento
                                                            ,null
                                                            ,utente_aggiornamento
                                                            ,null))))
            ,data_aggiornamento   = nvl(p_new_data_aggiornamento
                                       ,decode(afc.is_default_null('ATTRIBUTI_ASSEGNAZIONE_FISICA.data_aggiornamento')
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
         and attributo = d_key.attributo
         and dal = d_key.dal
         and (p_check_old = 0 or
             (1 = 1 and (al = p_old_al or
             (p_old_al is null and (p_check_old is null or al is null))) and
             (valore = p_old_valore or
             (p_old_valore is null and (p_check_old is null or valore is null))) and
             (utente_aggiornamento = p_old_utente_aggiornamento or
             (p_old_utente_aggiornamento is null and
             (p_check_old is null or utente_aggiornamento is null))) and
             (data_aggiornamento = p_old_data_aggiornamento or
             (p_old_data_aggiornamento is null and
             (p_check_old is null or data_aggiornamento is null)))));
      d_row_found := sql%rowcount;
      afc.default_null(null);
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on attr_assegnazione_fisica_tpk.upd');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   end upd; -- attr_assegnazione_fisica_tpk.upd
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_id_asfi       in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo     in attributi_assegnazione_fisica.attributo%type
     ,p_dal           in attributi_assegnazione_fisica.dal%type
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
      dbc.pre(not dbc.preon or existsid(p_id_asfi   => p_id_asfi
                                       ,p_attributo => p_attributo
                                       ,p_dal       => p_dal)
             ,'existsId on attr_assegnazione_fisica_tpk.upd_column');
      dbc.pre(not dbc.preon or p_column is not null
             ,'p_column is not null on attr_assegnazione_fisica_tpk.upd_column');
      dbc.pre(not dbc.preon or afc_ddl.hasattribute(s_table_name, p_column)
             ,'AFC_DDL.HasAttribute on attr_assegnazione_fisica_tpk.upd_column');
      dbc.pre(p_literal_value in (0, 1) or p_literal_value is null
             ,'p_literal_value on attr_assegnazione_fisica_tpk.upd_column; p_literal_value = ' ||
              p_literal_value);
      if p_literal_value = 1 or p_literal_value is null then
         d_literal := '''';
      end if;
      d_statement := ' declare ' || '    d_row_found number; ' || ' begin ' ||
                     '    update ATTRIBUTI_ASSEGNAZIONE_FISICA ' || '       set ' ||
                     p_column || ' = ' || d_literal || p_value || d_literal ||
                     '     where 1 = 1 ' ||
                     nvl(afc.get_field_condition(' and ( id_asfi '
                                                ,p_id_asfi
                                                ,' )'
                                                ,0
                                                ,null)
                        ,' and ( id_asfi is null ) ') ||
                     nvl(afc.get_field_condition(' and ( attributo '
                                                ,p_attributo
                                                ,' )'
                                                ,0
                                                ,null)
                        ,' and ( attributo is null ) ') ||
                     nvl(afc.get_field_condition(' and ( dal '
                                                ,p_dal
                                                ,' )'
                                                ,0
                                                ,afc.date_format)
                        ,' and ( dal is null ) ') || '    ; ' ||
                     '    d_row_found := SQL%ROWCOUNT; ' || '    if d_row_found < 1 ' ||
                     '    then ' ||
                     '       raise_application_error ( AFC_ERROR.modified_by_other_user_number, AFC_ERROR.modified_by_other_user_msg ); ' ||
                     '    end if; ' || ' end; ';
      afc.sql_execute(d_statement);
   end upd_column; -- attr_assegnazione_fisica_tpk.upd_column
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
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
      upd_column(p_id_asfi       => p_id_asfi
                ,p_attributo     => p_attributo
                ,p_dal           => p_dal
                ,p_column        => p_column
                ,p_value         => 'to_date( ''' || d_data || ''', ''' ||
                                    afc.date_format || ''' )'
                ,p_literal_value => 0);
   end upd_column; -- attr_assegnazione_fisica_tpk.upd_column
   --------------------------------------------------------------------------------
   procedure del
   (
      p_check_old            in integer default 0
     ,p_id_asfi              in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo            in attributi_assegnazione_fisica.attributo%type
     ,p_dal                  in attributi_assegnazione_fisica.dal%type
     ,p_al                   in attributi_assegnazione_fisica.al%type default null
     ,p_valore               in attributi_assegnazione_fisica.valore%type default null
     ,p_utente_aggiornamento in attributi_assegnazione_fisica.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in attributi_assegnazione_fisica.data_aggiornamento%type default null
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
              not ((p_al is not null or p_valore is not null or
               p_utente_aggiornamento is not null or
               p_data_aggiornamento is not null) and (nvl(p_check_old, -1) = 0))
             ,' "OLD values" is not null on attr_assegnazione_fisica_tpk.del');
      dbc.pre(not dbc.preon or existsid(p_id_asfi   => p_id_asfi
                                       ,p_attributo => p_attributo
                                       ,p_dal       => p_dal)
             ,'existsId on attr_assegnazione_fisica_tpk.del');
      delete from attributi_assegnazione_fisica
       where id_asfi = p_id_asfi
         and attributo = p_attributo
         and dal = p_dal
         and (p_check_old = 0 or
             (1 = 1 and
             (al = p_al or (p_al is null and (p_check_old is null or al is null))) and
             (valore = p_valore or
             (p_valore is null and (p_check_old is null or valore is null))) and
             (utente_aggiornamento = p_utente_aggiornamento or
             (p_utente_aggiornamento is null and
             (p_check_old is null or utente_aggiornamento is null))) and
             (data_aggiornamento = p_data_aggiornamento or
             (p_data_aggiornamento is null and
             (p_check_old is null or data_aggiornamento is null)))));
      d_row_found := sql%rowcount;
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on attr_assegnazione_fisica_tpk.del');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
      dbc.post(not dbc.poston or not existsid(p_id_asfi   => p_id_asfi
                                             ,p_attributo => p_attributo
                                             ,p_dal       => p_dal)
              ,'existsId on attr_assegnazione_fisica_tpk.del');
   end del; -- attr_assegnazione_fisica_tpk.del
   --------------------------------------------------------------------------------
   function get_al
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
   ) return attributi_assegnazione_fisica.al%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_al
       DESCRIZIONE: Getter per attributo al di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ATTRIBUTI_ASSEGNAZIONE_FISICA.al%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result attributi_assegnazione_fisica.al%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_asfi   => p_id_asfi
                                       ,p_attributo => p_attributo
                                       ,p_dal       => p_dal)
             ,'existsId on attr_assegnazione_fisica_tpk.get_al');
      select al
        into d_result
        from attributi_assegnazione_fisica
       where id_asfi = p_id_asfi
         and attributo = p_attributo
         and dal = p_dal;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on attr_assegnazione_fisica_tpk.get_al');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'al')
                      ,' AFC_DDL.IsNullable on attr_assegnazione_fisica_tpk.get_al');
      end if;
      return d_result;
   end get_al; -- attr_assegnazione_fisica_tpk.get_al
   --------------------------------------------------------------------------------
   function get_valore
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
   ) return attributi_assegnazione_fisica.valore%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_valore
       DESCRIZIONE: Getter per attributo valore di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ATTRIBUTI_ASSEGNAZIONE_FISICA.valore%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result attributi_assegnazione_fisica.valore%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_asfi   => p_id_asfi
                                       ,p_attributo => p_attributo
                                       ,p_dal       => p_dal)
             ,'existsId on attr_assegnazione_fisica_tpk.get_valore');
      select valore
        into d_result
        from attributi_assegnazione_fisica
       where id_asfi = p_id_asfi
         and attributo = p_attributo
         and dal = p_dal;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on attr_assegnazione_fisica_tpk.get_valore');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'valore')
                      ,' AFC_DDL.IsNullable on attr_assegnazione_fisica_tpk.get_valore');
      end if;
      return d_result;
   end get_valore; -- attr_assegnazione_fisica_tpk.get_valore
   --------------------------------------------------------------------------------
   function get_utente_aggiornamento
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
   ) return attributi_assegnazione_fisica.utente_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_utente_aggiornamento
       DESCRIZIONE: Getter per attributo utente_aggiornamento di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ATTRIBUTI_ASSEGNAZIONE_FISICA.utente_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result attributi_assegnazione_fisica.utente_aggiornamento%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_asfi   => p_id_asfi
                                       ,p_attributo => p_attributo
                                       ,p_dal       => p_dal)
             ,'existsId on attr_assegnazione_fisica_tpk.get_utente_aggiornamento');
      select utente_aggiornamento
        into d_result
        from attributi_assegnazione_fisica
       where id_asfi = p_id_asfi
         and attributo = p_attributo
         and dal = p_dal;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on attr_assegnazione_fisica_tpk.get_utente_aggiornamento');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'utente_aggiornamento')
                      ,' AFC_DDL.IsNullable on attr_assegnazione_fisica_tpk.get_utente_aggiornamento');
      end if;
      return d_result;
   end get_utente_aggiornamento; -- attr_assegnazione_fisica_tpk.get_utente_aggiornamento
   --------------------------------------------------------------------------------
   function get_data_aggiornamento
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
   ) return attributi_assegnazione_fisica.data_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_data_aggiornamento
       DESCRIZIONE: Getter per attributo data_aggiornamento di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ATTRIBUTI_ASSEGNAZIONE_FISICA.data_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result attributi_assegnazione_fisica.data_aggiornamento%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_asfi   => p_id_asfi
                                       ,p_attributo => p_attributo
                                       ,p_dal       => p_dal)
             ,'existsId on attr_assegnazione_fisica_tpk.get_data_aggiornamento');
      select data_aggiornamento
        into d_result
        from attributi_assegnazione_fisica
       where id_asfi = p_id_asfi
         and attributo = p_attributo
         and dal = p_dal;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on attr_assegnazione_fisica_tpk.get_data_aggiornamento');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'data_aggiornamento')
                      ,' AFC_DDL.IsNullable on attr_assegnazione_fisica_tpk.get_data_aggiornamento');
      end if;
      return d_result;
   end get_data_aggiornamento; -- attr_assegnazione_fisica_tpk.get_data_aggiornamento
   --------------------------------------------------------------------------------
   procedure set_id_asfi
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
     ,p_value     in attributi_assegnazione_fisica.id_asfi%type default null
   ) is
      /******************************************************************************
       NOME:        set_id_asfi
       DESCRIZIONE: Setter per attributo id_asfi di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_asfi   => p_id_asfi
                                       ,p_attributo => p_attributo
                                       ,p_dal       => p_dal)
             ,'existsId on attr_assegnazione_fisica_tpk.set_id_asfi');
      update attributi_assegnazione_fisica
         set id_asfi = p_value
       where id_asfi = p_id_asfi
         and attributo = p_attributo
         and dal = p_dal;
   end set_id_asfi; -- attr_assegnazione_fisica_tpk.set_id_asfi
   --------------------------------------------------------------------------------
   procedure set_attributo
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
     ,p_value     in attributi_assegnazione_fisica.attributo%type default null
   ) is
      /******************************************************************************
       NOME:        set_attributo
       DESCRIZIONE: Setter per attributo attributo di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_asfi   => p_id_asfi
                                       ,p_attributo => p_attributo
                                       ,p_dal       => p_dal)
             ,'existsId on attr_assegnazione_fisica_tpk.set_attributo');
      update attributi_assegnazione_fisica
         set attributo = p_value
       where id_asfi = p_id_asfi
         and attributo = p_attributo
         and dal = p_dal;
   end set_attributo; -- attr_assegnazione_fisica_tpk.set_attributo
   --------------------------------------------------------------------------------
   procedure set_dal
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
     ,p_value     in attributi_assegnazione_fisica.dal%type default null
   ) is
      /******************************************************************************
       NOME:        set_dal
       DESCRIZIONE: Setter per attributo dal di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_asfi   => p_id_asfi
                                       ,p_attributo => p_attributo
                                       ,p_dal       => p_dal)
             ,'existsId on attr_assegnazione_fisica_tpk.set_dal');
      update attributi_assegnazione_fisica
         set dal = p_value
       where id_asfi = p_id_asfi
         and attributo = p_attributo
         and dal = p_dal;
   end set_dal; -- attr_assegnazione_fisica_tpk.set_dal
   --------------------------------------------------------------------------------
   procedure set_al
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
     ,p_value     in attributi_assegnazione_fisica.al%type default null
   ) is
      /******************************************************************************
       NOME:        set_al
       DESCRIZIONE: Setter per attributo al di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_asfi   => p_id_asfi
                                       ,p_attributo => p_attributo
                                       ,p_dal       => p_dal)
             ,'existsId on attr_assegnazione_fisica_tpk.set_al');
      update attributi_assegnazione_fisica
         set al = p_value
       where id_asfi = p_id_asfi
         and attributo = p_attributo
         and dal = p_dal;
   end set_al; -- attr_assegnazione_fisica_tpk.set_al
   --------------------------------------------------------------------------------
   procedure set_valore
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
     ,p_value     in attributi_assegnazione_fisica.valore%type default null
   ) is
      /******************************************************************************
       NOME:        set_valore
       DESCRIZIONE: Setter per attributo valore di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_asfi   => p_id_asfi
                                       ,p_attributo => p_attributo
                                       ,p_dal       => p_dal)
             ,'existsId on attr_assegnazione_fisica_tpk.set_valore');
      update attributi_assegnazione_fisica
         set valore = p_value
       where id_asfi = p_id_asfi
         and attributo = p_attributo
         and dal = p_dal;
   end set_valore; -- attr_assegnazione_fisica_tpk.set_valore
   --------------------------------------------------------------------------------
   procedure set_utente_aggiornamento
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
     ,p_value     in attributi_assegnazione_fisica.utente_aggiornamento%type default null
   ) is
      /******************************************************************************
       NOME:        set_utente_aggiornamento
       DESCRIZIONE: Setter per attributo utente_aggiornamento di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_asfi   => p_id_asfi
                                       ,p_attributo => p_attributo
                                       ,p_dal       => p_dal)
             ,'existsId on attr_assegnazione_fisica_tpk.set_utente_aggiornamento');
      update attributi_assegnazione_fisica
         set utente_aggiornamento = p_value
       where id_asfi = p_id_asfi
         and attributo = p_attributo
         and dal = p_dal;
   end set_utente_aggiornamento; -- attr_assegnazione_fisica_tpk.set_utente_aggiornamento
   --------------------------------------------------------------------------------
   procedure set_data_aggiornamento
   (
      p_id_asfi   in attributi_assegnazione_fisica.id_asfi%type
     ,p_attributo in attributi_assegnazione_fisica.attributo%type
     ,p_dal       in attributi_assegnazione_fisica.dal%type
     ,p_value     in attributi_assegnazione_fisica.data_aggiornamento%type default null
   ) is
      /******************************************************************************
       NOME:        set_data_aggiornamento
       DESCRIZIONE: Setter per attributo data_aggiornamento di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_asfi   => p_id_asfi
                                       ,p_attributo => p_attributo
                                       ,p_dal       => p_dal)
             ,'existsId on attr_assegnazione_fisica_tpk.set_data_aggiornamento');
      update attributi_assegnazione_fisica
         set data_aggiornamento = p_value
       where id_asfi = p_id_asfi
         and attributo = p_attributo
         and dal = p_dal;
   end set_data_aggiornamento; -- attr_assegnazione_fisica_tpk.set_data_aggiornamento
   --------------------------------------------------------------------------------
   function where_condition /* SLAVE_COPY */
   (
      p_qbe                  in number default 0
     ,p_other_condition      in varchar2 default null
     ,p_id_asfi              in varchar2 default null
     ,p_attributo            in varchar2 default null
     ,p_dal                  in varchar2 default null
     ,p_al                   in varchar2 default null
     ,p_valore               in varchar2 default null
     ,p_utente_aggiornamento in varchar2 default null
     ,p_data_aggiornamento   in varchar2 default null
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
                     afc.get_field_condition(' and ( attributo '
                                            ,p_attributo
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
                     afc.get_field_condition(' and ( valore '
                                            ,p_valore
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
   end where_condition; --- attr_assegnazione_fisica_tpk.where_condition
   --------------------------------------------------------------------------------
   function get_rows
   (
      p_qbe                  in number default 0
     ,p_other_condition      in varchar2 default null
     ,p_order_by             in varchar2 default null
     ,p_extra_columns        in varchar2 default null
     ,p_extra_condition      in varchar2 default null
     ,p_id_asfi              in varchar2 default null
     ,p_attributo            in varchar2 default null
     ,p_dal                  in varchar2 default null
     ,p_al                   in varchar2 default null
     ,p_valore               in varchar2 default null
     ,p_utente_aggiornamento in varchar2 default null
     ,p_data_aggiornamento   in varchar2 default null
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
      d_statement  := ' select ATTRIBUTI_ASSEGNAZIONE_FISICA.* ' ||
                      afc.decode_value(p_extra_columns
                                      ,null
                                      ,null
                                      ,' , ' || p_extra_columns) ||
                      ' from ATTRIBUTI_ASSEGNAZIONE_FISICA ' ||
                      where_condition(p_qbe                  => p_qbe
                                     ,p_other_condition      => p_other_condition
                                     ,p_id_asfi              => p_id_asfi
                                     ,p_attributo            => p_attributo
                                     ,p_dal                  => p_dal
                                     ,p_al                   => p_al
                                     ,p_valore               => p_valore
                                     ,p_utente_aggiornamento => p_utente_aggiornamento
                                     ,p_data_aggiornamento   => p_data_aggiornamento) || ' ' ||
                      p_extra_condition ||
                      afc.decode_value(p_order_by, null, null, ' order by ' || p_order_by);
      d_ref_cursor := afc_dml.get_ref_cursor(d_statement);
      return d_ref_cursor;
   end get_rows; -- attr_assegnazione_fisica_tpk.get_rows
   --------------------------------------------------------------------------------
   function count_rows
   (
      p_qbe                  in number default 0
     ,p_other_condition      in varchar2 default null
     ,p_id_asfi              in varchar2 default null
     ,p_attributo            in varchar2 default null
     ,p_dal                  in varchar2 default null
     ,p_al                   in varchar2 default null
     ,p_valore               in varchar2 default null
     ,p_utente_aggiornamento in varchar2 default null
     ,p_data_aggiornamento   in varchar2 default null
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
      d_statement := ' select count( * ) from ATTRIBUTI_ASSEGNAZIONE_FISICA ' ||
                     where_condition(p_qbe                  => p_qbe
                                    ,p_other_condition      => p_other_condition
                                    ,p_id_asfi              => p_id_asfi
                                    ,p_attributo            => p_attributo
                                    ,p_dal                  => p_dal
                                    ,p_al                   => p_al
                                    ,p_valore               => p_valore
                                    ,p_utente_aggiornamento => p_utente_aggiornamento
                                    ,p_data_aggiornamento   => p_data_aggiornamento);
      d_result    := afc.sql_execute(d_statement);
      return d_result;
   end count_rows; -- attr_assegnazione_fisica_tpk.count_rows
--------------------------------------------------------------------------------

end attr_assegnazione_fisica_tpk;
/

