CREATE OR REPLACE package body soggetti_rubrica_tpk is
   /******************************************************************************
    NOME:        soggetti_rubrica_tpk
    DESCRIZIONE: Gestione tabella SOGGETTI_RUBRICA.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore      Descrizione.
    000   09/11/2009  VDAVALLI  Prima emissione.
    001   16/01/2012  vdavalli  Generazione automatica. 
   ******************************************************************************/
   s_revisione_body constant afc.t_revision := '001 - 16/01/2012';
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
   end versione; -- soggetti_rubrica_tpk.versione
   --------------------------------------------------------------------------------
   function pk
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
   ) return t_pk is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        PK
       DESCRIZIONE: Costruttore di un t_PK dati gli attributi della chiave
      ******************************************************************************/
      d_result t_pk;
   begin
      d_result.ni            := p_ni;
      d_result.tipo_contatto := p_tipo_contatto;
      d_result.progressivo   := p_progressivo;
      dbc.pre(not dbc.preon or
              canhandle(p_ni            => d_result.ni
                       ,p_tipo_contatto => d_result.tipo_contatto
                       ,p_progressivo   => d_result.progressivo)
             ,'canHandle on soggetti_rubrica_tpk.PK');
      return d_result;
   end pk; -- soggetti_rubrica_tpk.PK
   --------------------------------------------------------------------------------
   function can_handle
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
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
      if d_result = 1 and
         (p_ni is null or p_tipo_contatto is null or p_progressivo is null) then
         d_result := 0;
      end if;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on soggetti_rubrica_tpk.can_handle');
      return d_result;
   end can_handle; -- soggetti_rubrica_tpk.can_handle
   --------------------------------------------------------------------------------
   function canhandle
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
   ) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        canHandle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: true se la chiave e manipolabile, false altrimenti.
       NOTE:        Wrapper boolean di can_handle (cfr. can_handle).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(can_handle(p_ni            => p_ni
                                                            ,p_tipo_contatto => p_tipo_contatto
                                                            ,p_progressivo   => p_progressivo));
   begin
      return d_result;
   end canhandle; -- soggetti_rubrica_tpk.canHandle
   --------------------------------------------------------------------------------
   function exists_id
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
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
      dbc.pre(not dbc.preon or
              canhandle(p_ni            => p_ni
                       ,p_tipo_contatto => p_tipo_contatto
                       ,p_progressivo   => p_progressivo)
             ,'canHandle on soggetti_rubrica_tpk.exists_id');
      begin
         select 1
           into d_result
           from soggetti_rubrica
          where ni = p_ni
            and tipo_contatto = p_tipo_contatto
            and progressivo = p_progressivo;
      exception
         when no_data_found then
            d_result := 0;
      end;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on soggetti_rubrica_tpk.exists_id');
      return d_result;
   end exists_id; -- soggetti_rubrica_tpk.exists_id
   --------------------------------------------------------------------------------
   function existsid
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
   ) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        existsId
       DESCRIZIONE: Esistenza riga con chiave indicata.
       NOTE:        Wrapper boolean di exists_id (cfr. exists_id).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(exists_id(p_ni            => p_ni
                                                           ,p_tipo_contatto => p_tipo_contatto
                                                           ,p_progressivo   => p_progressivo));
   begin
      return d_result;
   end existsid; -- soggetti_rubrica_tpk.existsId
   --------------------------------------------------------------------------------
   procedure ins
   (
      p_ni                   in soggetti_rubrica.ni%type default null
     ,p_tipo_contatto        in soggetti_rubrica.tipo_contatto%type default null
     ,p_progressivo          in soggetti_rubrica.progressivo%type default null
     ,p_contatto             in soggetti_rubrica.contatto%type
     ,p_riferimento_tipo     in soggetti_rubrica.riferimento_tipo%type default null
     ,p_riferimento          in soggetti_rubrica.riferimento%type default null
     ,p_pubblicabile         in soggetti_rubrica.pubblicabile%type default null
     ,p_utente_agg           in soggetti_rubrica.utente_agg%type default null
     ,p_data_agg             in soggetti_rubrica.data_agg%type default null
     ,p_descrizione_contatto in soggetti_rubrica.descrizione_contatto%type default null
   ) is
      /******************************************************************************
       NOME:        ins
       DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
       PARAMETRI:   Chiavi e attributi della table.
      ******************************************************************************/
   begin
      -- Check Mandatory on Insert
   
      dbc.pre(not dbc.preon or p_contatto is not null or /*default value*/
              '' is not null
             ,'p_contatto on soggetti_rubrica_tpk.ins');
      dbc.pre(not dbc.preon or p_riferimento_tipo is not null or /*default value*/
              'default' is not null
             ,'p_riferimento_tipo on soggetti_rubrica_tpk.ins');
      dbc.pre(not dbc.preon or p_riferimento is not null or /*default value*/
              'default' is not null
             ,'p_riferimento on soggetti_rubrica_tpk.ins');
      dbc.pre(not dbc.preon or p_pubblicabile is not null or /*default value*/
              'default' is not null
             ,'p_pubblicabile on soggetti_rubrica_tpk.ins');
      dbc.pre(not dbc.preon or p_utente_agg is not null or /*default value*/
              'default' is not null
             ,'p_utente_agg on soggetti_rubrica_tpk.ins');
      dbc.pre(not dbc.preon or p_data_agg is not null or /*default value*/
              'default' is not null
             ,'p_data_agg on soggetti_rubrica_tpk.ins');
      dbc.pre(not dbc.preon or p_descrizione_contatto is not null or /*default value*/
              'default' is not null
             ,'p_descrizione_contatto on soggetti_rubrica_tpk.ins');
      dbc.pre(not dbc.preon or (p_ni is null and /*default value*/
              'default null' is not null) -- PK nullable on insert
              or (p_tipo_contatto is null and /*default value*/
              'default null' is not null) -- PK nullable on insert
              or (p_progressivo is null and /*default value*/
              'default null' is not null) -- PK nullable on insert
              or not existsid(p_ni            => p_ni
                             ,p_tipo_contatto => p_tipo_contatto
                             ,p_progressivo   => p_progressivo)
             ,'not existsId on soggetti_rubrica_tpk.ins');
      insert into soggetti_rubrica
         (ni
         ,tipo_contatto
         ,progressivo
         ,contatto
         ,riferimento_tipo
         ,riferimento
         ,pubblicabile
         ,utente_agg
         ,data_agg
         ,descrizione_contatto)
      values
         (p_ni
         ,p_tipo_contatto
         ,p_progressivo
         ,p_contatto
         ,p_riferimento_tipo
         ,p_riferimento
         ,p_pubblicabile
         ,p_utente_agg
         ,p_data_agg
         ,p_descrizione_contatto);
   end ins; -- soggetti_rubrica_tpk.ins
   --------------------------------------------------------------------------------
   function ins
   (
      p_ni                   in soggetti_rubrica.ni%type default null
     ,p_tipo_contatto        in soggetti_rubrica.tipo_contatto%type default null
     ,p_progressivo          in soggetti_rubrica.progressivo%type default null
     ,p_contatto             in soggetti_rubrica.contatto%type
     ,p_riferimento_tipo     in soggetti_rubrica.riferimento_tipo%type default null
     ,p_riferimento          in soggetti_rubrica.riferimento%type default null
     ,p_pubblicabile         in soggetti_rubrica.pubblicabile%type default null
     ,p_utente_agg           in soggetti_rubrica.utente_agg%type default null
     ,p_data_agg             in soggetti_rubrica.data_agg%type default null
     ,p_descrizione_contatto in soggetti_rubrica.descrizione_contatto%type default null
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
   
      dbc.pre(not dbc.preon or p_contatto is not null or /*default value*/
              '' is not null
             ,'p_contatto on soggetti_rubrica_tpk.ins');
      dbc.pre(not dbc.preon or p_riferimento_tipo is not null or /*default value*/
              'default' is not null
             ,'p_riferimento_tipo on soggetti_rubrica_tpk.ins');
      dbc.pre(not dbc.preon or p_riferimento is not null or /*default value*/
              'default' is not null
             ,'p_riferimento on soggetti_rubrica_tpk.ins');
      dbc.pre(not dbc.preon or p_pubblicabile is not null or /*default value*/
              'default' is not null
             ,'p_pubblicabile on soggetti_rubrica_tpk.ins');
      dbc.pre(not dbc.preon or p_utente_agg is not null or /*default value*/
              'default' is not null
             ,'p_utente_agg on soggetti_rubrica_tpk.ins');
      dbc.pre(not dbc.preon or p_data_agg is not null or /*default value*/
              'default' is not null
             ,'p_data_agg on soggetti_rubrica_tpk.ins');
      dbc.pre(not dbc.preon or p_descrizione_contatto is not null or /*default value*/
              'default' is not null
             ,'p_descrizione_contatto on soggetti_rubrica_tpk.ins');
      dbc.pre(not dbc.preon or (p_ni is null and /*default value*/
              'default null' is not null) -- PK nullable on insert
              or (p_tipo_contatto is null and /*default value*/
              'default null' is not null) -- PK nullable on insert
              or (p_progressivo is null and /*default value*/
              'default null' is not null) -- PK nullable on insert
              or not existsid(p_ni            => p_ni
                             ,p_tipo_contatto => p_tipo_contatto
                             ,p_progressivo   => p_progressivo)
             ,'not existsId on soggetti_rubrica_tpk.ins');
      insert into soggetti_rubrica
         (ni
         ,tipo_contatto
         ,progressivo
         ,contatto
         ,riferimento_tipo
         ,riferimento
         ,pubblicabile
         ,utente_agg
         ,data_agg
         ,descrizione_contatto)
      values
         (p_ni
         ,p_tipo_contatto
         ,p_progressivo
         ,p_contatto
         ,p_riferimento_tipo
         ,p_riferimento
         ,p_pubblicabile
         ,p_utente_agg
         ,p_data_agg
         ,p_descrizione_contatto);
      d_result := 0;
      return d_result;
   end ins; -- soggetti_rubrica_tpk.ins
   --------------------------------------------------------------------------------
   procedure upd
   (
      p_check_old                in integer default 0
     ,p_new_ni                   in soggetti_rubrica.ni%type
     ,p_old_ni                   in soggetti_rubrica.ni%type default null
     ,p_new_tipo_contatto        in soggetti_rubrica.tipo_contatto%type
     ,p_old_tipo_contatto        in soggetti_rubrica.tipo_contatto%type default null
     ,p_new_progressivo          in soggetti_rubrica.progressivo%type
     ,p_old_progressivo          in soggetti_rubrica.progressivo%type default null
     ,p_new_contatto             in soggetti_rubrica.contatto%type default afc.default_null('SOGGETTI_RUBRICA.contatto')
     ,p_old_contatto             in soggetti_rubrica.contatto%type default null
     ,p_new_riferimento_tipo     in soggetti_rubrica.riferimento_tipo%type default afc.default_null('SOGGETTI_RUBRICA.riferimento_tipo')
     ,p_old_riferimento_tipo     in soggetti_rubrica.riferimento_tipo%type default null
     ,p_new_riferimento          in soggetti_rubrica.riferimento%type default afc.default_null('SOGGETTI_RUBRICA.riferimento')
     ,p_old_riferimento          in soggetti_rubrica.riferimento%type default null
     ,p_new_pubblicabile         in soggetti_rubrica.pubblicabile%type default afc.default_null('SOGGETTI_RUBRICA.pubblicabile')
     ,p_old_pubblicabile         in soggetti_rubrica.pubblicabile%type default null
     ,p_new_utente_agg           in soggetti_rubrica.utente_agg%type default afc.default_null('SOGGETTI_RUBRICA.utente_agg')
     ,p_old_utente_agg           in soggetti_rubrica.utente_agg%type default null
     ,p_new_data_agg             in soggetti_rubrica.data_agg%type default afc.default_null('SOGGETTI_RUBRICA.data_agg')
     ,p_old_data_agg             in soggetti_rubrica.data_agg%type default null
     ,p_new_descrizione_contatto in soggetti_rubrica.descrizione_contatto%type default afc.default_null('SOGGETTI_RUBRICA.descrizione_contatto')
     ,p_old_descrizione_contatto in soggetti_rubrica.descrizione_contatto%type default null
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
              not ((p_old_contatto is not null or p_old_riferimento_tipo is not null or
               p_old_riferimento is not null or p_old_pubblicabile is not null or
               p_old_utente_agg is not null or p_old_data_agg is not null or
               p_old_descrizione_contatto is not null) and (nvl(p_check_old, -1) = 0))
             ,' "OLD values" is not null on soggetti_rubrica_tpk.upd');
      d_key := pk(nvl(p_old_ni, p_new_ni)
                 ,nvl(p_old_tipo_contatto, p_new_tipo_contatto)
                 ,nvl(p_old_progressivo, p_new_progressivo));
      dbc.pre(not dbc.preon or
              existsid(p_ni            => d_key.ni
                      ,p_tipo_contatto => d_key.tipo_contatto
                      ,p_progressivo   => d_key.progressivo)
             ,'existsId on soggetti_rubrica_tpk.upd');
      update soggetti_rubrica
         set ni                   = nvl(p_new_ni
                                       ,decode(afc.is_default_null('SOGGETTI_RUBRICA.ni')
                                              ,1
                                              ,ni
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_ni, null, ni, null))))
            ,tipo_contatto        = nvl(p_new_tipo_contatto
                                       ,decode(afc.is_default_null('SOGGETTI_RUBRICA.tipo_contatto')
                                              ,1
                                              ,tipo_contatto
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_tipo_contatto
                                                            ,null
                                                            ,tipo_contatto
                                                            ,null))))
            ,progressivo          = nvl(p_new_progressivo
                                       ,decode(afc.is_default_null('SOGGETTI_RUBRICA.progressivo')
                                              ,1
                                              ,progressivo
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_progressivo
                                                            ,null
                                                            ,progressivo
                                                            ,null))))
            ,contatto             = nvl(p_new_contatto
                                       ,decode(afc.is_default_null('SOGGETTI_RUBRICA.contatto')
                                              ,1
                                              ,contatto
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_contatto
                                                            ,null
                                                            ,contatto
                                                            ,null))))
            ,riferimento_tipo     = nvl(p_new_riferimento_tipo
                                       ,decode(afc.is_default_null('SOGGETTI_RUBRICA.riferimento_tipo')
                                              ,1
                                              ,riferimento_tipo
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_riferimento_tipo
                                                            ,null
                                                            ,riferimento_tipo
                                                            ,null))))
            ,riferimento          = nvl(p_new_riferimento
                                       ,decode(afc.is_default_null('SOGGETTI_RUBRICA.riferimento')
                                              ,1
                                              ,riferimento
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_riferimento
                                                            ,null
                                                            ,riferimento
                                                            ,null))))
            ,pubblicabile         = nvl(p_new_pubblicabile
                                       ,decode(afc.is_default_null('SOGGETTI_RUBRICA.pubblicabile')
                                              ,1
                                              ,pubblicabile
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_pubblicabile
                                                            ,null
                                                            ,pubblicabile
                                                            ,null))))
            ,utente_agg           = nvl(p_new_utente_agg
                                       ,decode(afc.is_default_null('SOGGETTI_RUBRICA.utente_agg')
                                              ,1
                                              ,utente_agg
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_utente_agg
                                                            ,null
                                                            ,utente_agg
                                                            ,null))))
            ,data_agg             = nvl(p_new_data_agg
                                       ,decode(afc.is_default_null('SOGGETTI_RUBRICA.data_agg')
                                              ,1
                                              ,data_agg
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_data_agg
                                                            ,null
                                                            ,data_agg
                                                            ,null))))
            ,descrizione_contatto = nvl(p_new_descrizione_contatto
                                       ,decode(afc.is_default_null('SOGGETTI_RUBRICA.descrizione_contatto')
                                              ,1
                                              ,descrizione_contatto
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_descrizione_contatto
                                                            ,null
                                                            ,descrizione_contatto
                                                            ,null))))
       where ni = d_key.ni
         and tipo_contatto = d_key.tipo_contatto
         and progressivo = d_key.progressivo
         and (p_check_old = 0 or
             (1 = 1 and
             (contatto = p_old_contatto or
             (p_old_contatto is null and (p_check_old is null or contatto is null))) and
             (riferimento_tipo = p_old_riferimento_tipo or
             (p_old_riferimento_tipo is null and
             (p_check_old is null or riferimento_tipo is null))) and
             (riferimento = p_old_riferimento or
             (p_old_riferimento is null and
             (p_check_old is null or riferimento is null))) and
             (pubblicabile = p_old_pubblicabile or
             (p_old_pubblicabile is null and
             (p_check_old is null or pubblicabile is null))) and
             (utente_agg = p_old_utente_agg or
             (p_old_utente_agg is null and (p_check_old is null or utente_agg is null))) and
             (data_agg = p_old_data_agg or
             (p_old_data_agg is null and (p_check_old is null or data_agg is null))) and
             (descrizione_contatto = p_old_descrizione_contatto or
             (p_old_descrizione_contatto is null and
             (p_check_old is null or descrizione_contatto is null)))));
      d_row_found := sql%rowcount;
      afc.default_null(null);
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on soggetti_rubrica_tpk.upd');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   end upd; -- soggetti_rubrica_tpk.upd
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
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
      dbc.pre(not dbc.preon or
              existsid(p_ni            => p_ni
                      ,p_tipo_contatto => p_tipo_contatto
                      ,p_progressivo   => p_progressivo)
             ,'existsId on soggetti_rubrica_tpk.upd_column');
      dbc.pre(not dbc.preon or p_column is not null
             ,'p_column is not null on soggetti_rubrica_tpk.upd_column');
      dbc.pre(not dbc.preon or afc_ddl.hasattribute(s_table_name, p_column)
             ,'AFC_DDL.HasAttribute on soggetti_rubrica_tpk.upd_column');
      dbc.pre(p_literal_value in (0, 1) or p_literal_value is null
             ,'p_literal_value on soggetti_rubrica_tpk.upd_column; p_literal_value = ' ||
              p_literal_value);
      if p_literal_value = 1 or p_literal_value is null then
         d_literal := '''';
      end if;
      d_statement := ' declare ' || '    d_row_found number; ' || ' begin ' ||
                     '    update SOGGETTI_RUBRICA ' || '       set ' || p_column || ' = ' ||
                     d_literal || p_value || d_literal || '     where 1 = 1 ' ||
                     nvl(afc.get_field_condition(' and ( ni ', p_ni, ' )', 0, null)
                        ,' and ( ni is null ) ') ||
                     nvl(afc.get_field_condition(' and ( tipo_contatto '
                                                ,p_tipo_contatto
                                                ,' )'
                                                ,0
                                                ,null)
                        ,' and ( tipo_contatto is null ) ') ||
                     nvl(afc.get_field_condition(' and ( progressivo '
                                                ,p_progressivo
                                                ,' )'
                                                ,0
                                                ,null)
                        ,' and ( progressivo is null ) ') || '    ; ' ||
                     '    d_row_found := SQL%ROWCOUNT; ' || '    if d_row_found < 1 ' ||
                     '    then ' ||
                     '       raise_application_error ( AFC_ERROR.modified_by_other_user_number, AFC_ERROR.modified_by_other_user_msg ); ' ||
                     '    end if; ' || ' end; ';
      afc.sql_execute(d_statement);
   end upd_column; -- soggetti_rubrica_tpk.upd_column
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
     ,p_column        in varchar2
     ,p_value         in date
   ) is
      /******************************************************************************
       NOME:        upd_column
       DESCRIZIONE: Aggiornamento del campo p_column col valore p_value.
       NOTE:        Richiama se stessa con il parametro date convertito in stringa.
      ******************************************************************************/
      d_data varchar2(19);
   begin
      d_data := to_char(p_value, afc.date_format);
      upd_column(p_ni            => p_ni
                ,p_tipo_contatto => p_tipo_contatto
                ,p_progressivo   => p_progressivo
                ,p_column        => p_column
                ,p_value         => 'to_date( ''' || d_data || ''', ''' ||
                                    afc.date_format || ''' )'
                ,p_literal_value => 0);
   end upd_column; -- soggetti_rubrica_tpk.upd_column
   --------------------------------------------------------------------------------
   procedure del
   (
      p_check_old            in integer default 0
     ,p_ni                   in soggetti_rubrica.ni%type
     ,p_tipo_contatto        in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo          in soggetti_rubrica.progressivo%type
     ,p_contatto             in soggetti_rubrica.contatto%type default null
     ,p_riferimento_tipo     in soggetti_rubrica.riferimento_tipo%type default null
     ,p_riferimento          in soggetti_rubrica.riferimento%type default null
     ,p_pubblicabile         in soggetti_rubrica.pubblicabile%type default null
     ,p_utente_agg           in soggetti_rubrica.utente_agg%type default null
     ,p_data_agg             in soggetti_rubrica.data_agg%type default null
     ,p_descrizione_contatto in soggetti_rubrica.descrizione_contatto%type default null
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
              not ((p_contatto is not null or p_riferimento_tipo is not null or
               p_riferimento is not null or p_pubblicabile is not null or
               p_utente_agg is not null or p_data_agg is not null or
               p_descrizione_contatto is not null) and (nvl(p_check_old, -1) = 0))
             ,' "OLD values" is not null on soggetti_rubrica_tpk.del');
      dbc.pre(not dbc.preon or
              existsid(p_ni            => p_ni
                      ,p_tipo_contatto => p_tipo_contatto
                      ,p_progressivo   => p_progressivo)
             ,'existsId on soggetti_rubrica_tpk.del');
      delete from soggetti_rubrica
       where ni = p_ni
         and tipo_contatto = p_tipo_contatto
         and progressivo = p_progressivo
         and (p_check_old = 0 or
             (1 = 1 and
             (contatto = p_contatto or
             (p_contatto is null and (p_check_old is null or contatto is null))) and
             (riferimento_tipo = p_riferimento_tipo or
             (p_riferimento_tipo is null and
             (p_check_old is null or riferimento_tipo is null))) and
             (riferimento = p_riferimento or
             (p_riferimento is null and (p_check_old is null or riferimento is null))) and
             (pubblicabile = p_pubblicabile or
             (p_pubblicabile is null and (p_check_old is null or pubblicabile is null))) and
             (utente_agg = p_utente_agg or
             (p_utente_agg is null and (p_check_old is null or utente_agg is null))) and
             (data_agg = p_data_agg or
             (p_data_agg is null and (p_check_old is null or data_agg is null))) and
             (descrizione_contatto = p_descrizione_contatto or
             (p_descrizione_contatto is null and
             (p_check_old is null or descrizione_contatto is null)))));
      d_row_found := sql%rowcount;
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on soggetti_rubrica_tpk.del');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
      dbc.post(not dbc.poston or
               not existsid(p_ni            => p_ni
                           ,p_tipo_contatto => p_tipo_contatto
                           ,p_progressivo   => p_progressivo)
              ,'existsId on soggetti_rubrica_tpk.del');
   end del; -- soggetti_rubrica_tpk.del
   --------------------------------------------------------------------------------
   function get_contatto
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
   ) return soggetti_rubrica.contatto%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_contatto
       DESCRIZIONE: Getter per attributo contatto di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     SOGGETTI_RUBRICA.contatto%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result soggetti_rubrica.contatto%type;
   begin
      dbc.pre(not dbc.preon or
              existsid(p_ni            => p_ni
                      ,p_tipo_contatto => p_tipo_contatto
                      ,p_progressivo   => p_progressivo)
             ,'existsId on soggetti_rubrica_tpk.get_contatto');
      select contatto
        into d_result
        from soggetti_rubrica
       where ni = p_ni
         and tipo_contatto = p_tipo_contatto
         and progressivo = p_progressivo;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on soggetti_rubrica_tpk.get_contatto');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'contatto')
                      ,' AFC_DDL.IsNullable on soggetti_rubrica_tpk.get_contatto');
      end if;
      return d_result;
   end get_contatto; -- soggetti_rubrica_tpk.get_contatto
   --------------------------------------------------------------------------------
   function get_riferimento_tipo
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
   ) return soggetti_rubrica.riferimento_tipo%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_riferimento_tipo
       DESCRIZIONE: Getter per attributo riferimento_tipo di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     SOGGETTI_RUBRICA.riferimento_tipo%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result soggetti_rubrica.riferimento_tipo%type;
   begin
      dbc.pre(not dbc.preon or
              existsid(p_ni            => p_ni
                      ,p_tipo_contatto => p_tipo_contatto
                      ,p_progressivo   => p_progressivo)
             ,'existsId on soggetti_rubrica_tpk.get_riferimento_tipo');
      select riferimento_tipo
        into d_result
        from soggetti_rubrica
       where ni = p_ni
         and tipo_contatto = p_tipo_contatto
         and progressivo = p_progressivo;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on soggetti_rubrica_tpk.get_riferimento_tipo');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'riferimento_tipo')
                      ,' AFC_DDL.IsNullable on soggetti_rubrica_tpk.get_riferimento_tipo');
      end if;
      return d_result;
   end get_riferimento_tipo; -- soggetti_rubrica_tpk.get_riferimento_tipo
   --------------------------------------------------------------------------------
   function get_riferimento
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
   ) return soggetti_rubrica.riferimento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_riferimento
       DESCRIZIONE: Getter per attributo riferimento di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     SOGGETTI_RUBRICA.riferimento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result soggetti_rubrica.riferimento%type;
   begin
      dbc.pre(not dbc.preon or
              existsid(p_ni            => p_ni
                      ,p_tipo_contatto => p_tipo_contatto
                      ,p_progressivo   => p_progressivo)
             ,'existsId on soggetti_rubrica_tpk.get_riferimento');
      select riferimento
        into d_result
        from soggetti_rubrica
       where ni = p_ni
         and tipo_contatto = p_tipo_contatto
         and progressivo = p_progressivo;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on soggetti_rubrica_tpk.get_riferimento');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'riferimento')
                      ,' AFC_DDL.IsNullable on soggetti_rubrica_tpk.get_riferimento');
      end if;
      return d_result;
   end get_riferimento; -- soggetti_rubrica_tpk.get_riferimento
   --------------------------------------------------------------------------------
   function get_pubblicabile
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
   ) return soggetti_rubrica.pubblicabile%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_pubblicabile
       DESCRIZIONE: Getter per attributo pubblicabile di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     SOGGETTI_RUBRICA.pubblicabile%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result soggetti_rubrica.pubblicabile%type;
   begin
      dbc.pre(not dbc.preon or
              existsid(p_ni            => p_ni
                      ,p_tipo_contatto => p_tipo_contatto
                      ,p_progressivo   => p_progressivo)
             ,'existsId on soggetti_rubrica_tpk.get_pubblicabile');
      select pubblicabile
        into d_result
        from soggetti_rubrica
       where ni = p_ni
         and tipo_contatto = p_tipo_contatto
         and progressivo = p_progressivo;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on soggetti_rubrica_tpk.get_pubblicabile');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'pubblicabile')
                      ,' AFC_DDL.IsNullable on soggetti_rubrica_tpk.get_pubblicabile');
      end if;
      return d_result;
   end get_pubblicabile; -- soggetti_rubrica_tpk.get_pubblicabile
   --------------------------------------------------------------------------------
   function get_utente_agg
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
   ) return soggetti_rubrica.utente_agg%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_utente_agg
       DESCRIZIONE: Getter per attributo utente_agg di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     SOGGETTI_RUBRICA.utente_agg%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result soggetti_rubrica.utente_agg%type;
   begin
      dbc.pre(not dbc.preon or
              existsid(p_ni            => p_ni
                      ,p_tipo_contatto => p_tipo_contatto
                      ,p_progressivo   => p_progressivo)
             ,'existsId on soggetti_rubrica_tpk.get_utente_agg');
      select utente_agg
        into d_result
        from soggetti_rubrica
       where ni = p_ni
         and tipo_contatto = p_tipo_contatto
         and progressivo = p_progressivo;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on soggetti_rubrica_tpk.get_utente_agg');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'utente_agg')
                      ,' AFC_DDL.IsNullable on soggetti_rubrica_tpk.get_utente_agg');
      end if;
      return d_result;
   end get_utente_agg; -- soggetti_rubrica_tpk.get_utente_agg
   --------------------------------------------------------------------------------
   function get_data_agg
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
   ) return soggetti_rubrica.data_agg%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_data_agg
       DESCRIZIONE: Getter per attributo data_agg di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     SOGGETTI_RUBRICA.data_agg%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result soggetti_rubrica.data_agg%type;
   begin
      dbc.pre(not dbc.preon or
              existsid(p_ni            => p_ni
                      ,p_tipo_contatto => p_tipo_contatto
                      ,p_progressivo   => p_progressivo)
             ,'existsId on soggetti_rubrica_tpk.get_data_agg');
      select data_agg
        into d_result
        from soggetti_rubrica
       where ni = p_ni
         and tipo_contatto = p_tipo_contatto
         and progressivo = p_progressivo;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on soggetti_rubrica_tpk.get_data_agg');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'data_agg')
                      ,' AFC_DDL.IsNullable on soggetti_rubrica_tpk.get_data_agg');
      end if;
      return d_result;
   end get_data_agg; -- soggetti_rubrica_tpk.get_data_agg
   --------------------------------------------------------------------------------
   function get_descrizione_contatto
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
   ) return soggetti_rubrica.descrizione_contatto%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_descrizione_contatto
       DESCRIZIONE: Getter per attributo descrizione_contatto di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     SOGGETTI_RUBRICA.descrizione_contatto%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result soggetti_rubrica.descrizione_contatto%type;
   begin
      dbc.pre(not dbc.preon or
              existsid(p_ni            => p_ni
                      ,p_tipo_contatto => p_tipo_contatto
                      ,p_progressivo   => p_progressivo)
             ,'existsId on soggetti_rubrica_tpk.get_descrizione_contatto');
      select descrizione_contatto
        into d_result
        from soggetti_rubrica
       where ni = p_ni
         and tipo_contatto = p_tipo_contatto
         and progressivo = p_progressivo;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on soggetti_rubrica_tpk.get_descrizione_contatto');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'descrizione_contatto')
                      ,' AFC_DDL.IsNullable on soggetti_rubrica_tpk.get_descrizione_contatto');
      end if;
      return d_result;
   end get_descrizione_contatto; -- soggetti_rubrica_tpk.get_descrizione_contatto
   --------------------------------------------------------------------------------
   procedure set_ni
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
     ,p_value         in soggetti_rubrica.ni%type default null
   ) is
      /******************************************************************************
       NOME:        set_ni
       DESCRIZIONE: Setter per attributo ni di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_ni            => p_ni
                      ,p_tipo_contatto => p_tipo_contatto
                      ,p_progressivo   => p_progressivo)
             ,'existsId on soggetti_rubrica_tpk.set_ni');
      update soggetti_rubrica
         set ni = p_value
       where ni = p_ni
         and tipo_contatto = p_tipo_contatto
         and progressivo = p_progressivo;
   end set_ni; -- soggetti_rubrica_tpk.set_ni
   --------------------------------------------------------------------------------
   procedure set_tipo_contatto
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
     ,p_value         in soggetti_rubrica.tipo_contatto%type default null
   ) is
      /******************************************************************************
       NOME:        set_tipo_contatto
       DESCRIZIONE: Setter per attributo tipo_contatto di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_ni            => p_ni
                      ,p_tipo_contatto => p_tipo_contatto
                      ,p_progressivo   => p_progressivo)
             ,'existsId on soggetti_rubrica_tpk.set_tipo_contatto');
      update soggetti_rubrica
         set tipo_contatto = p_value
       where ni = p_ni
         and tipo_contatto = p_tipo_contatto
         and progressivo = p_progressivo;
   end set_tipo_contatto; -- soggetti_rubrica_tpk.set_tipo_contatto
   --------------------------------------------------------------------------------
   procedure set_progressivo
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
     ,p_value         in soggetti_rubrica.progressivo%type default null
   ) is
      /******************************************************************************
       NOME:        set_progressivo
       DESCRIZIONE: Setter per attributo progressivo di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_ni            => p_ni
                      ,p_tipo_contatto => p_tipo_contatto
                      ,p_progressivo   => p_progressivo)
             ,'existsId on soggetti_rubrica_tpk.set_progressivo');
      update soggetti_rubrica
         set progressivo = p_value
       where ni = p_ni
         and tipo_contatto = p_tipo_contatto
         and progressivo = p_progressivo;
   end set_progressivo; -- soggetti_rubrica_tpk.set_progressivo
   --------------------------------------------------------------------------------
   procedure set_contatto
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
     ,p_value         in soggetti_rubrica.contatto%type default null
   ) is
      /******************************************************************************
       NOME:        set_contatto
       DESCRIZIONE: Setter per attributo contatto di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_ni            => p_ni
                      ,p_tipo_contatto => p_tipo_contatto
                      ,p_progressivo   => p_progressivo)
             ,'existsId on soggetti_rubrica_tpk.set_contatto');
      update soggetti_rubrica
         set contatto = p_value
       where ni = p_ni
         and tipo_contatto = p_tipo_contatto
         and progressivo = p_progressivo;
   end set_contatto; -- soggetti_rubrica_tpk.set_contatto
   --------------------------------------------------------------------------------
   procedure set_riferimento_tipo
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
     ,p_value         in soggetti_rubrica.riferimento_tipo%type default null
   ) is
      /******************************************************************************
       NOME:        set_riferimento_tipo
       DESCRIZIONE: Setter per attributo riferimento_tipo di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_ni            => p_ni
                      ,p_tipo_contatto => p_tipo_contatto
                      ,p_progressivo   => p_progressivo)
             ,'existsId on soggetti_rubrica_tpk.set_riferimento_tipo');
      update soggetti_rubrica
         set riferimento_tipo = p_value
       where ni = p_ni
         and tipo_contatto = p_tipo_contatto
         and progressivo = p_progressivo;
   end set_riferimento_tipo; -- soggetti_rubrica_tpk.set_riferimento_tipo
   --------------------------------------------------------------------------------
   procedure set_riferimento
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
     ,p_value         in soggetti_rubrica.riferimento%type default null
   ) is
      /******************************************************************************
       NOME:        set_riferimento
       DESCRIZIONE: Setter per attributo riferimento di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_ni            => p_ni
                      ,p_tipo_contatto => p_tipo_contatto
                      ,p_progressivo   => p_progressivo)
             ,'existsId on soggetti_rubrica_tpk.set_riferimento');
      update soggetti_rubrica
         set riferimento = p_value
       where ni = p_ni
         and tipo_contatto = p_tipo_contatto
         and progressivo = p_progressivo;
   end set_riferimento; -- soggetti_rubrica_tpk.set_riferimento
   --------------------------------------------------------------------------------
   procedure set_pubblicabile
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
     ,p_value         in soggetti_rubrica.pubblicabile%type default null
   ) is
      /******************************************************************************
       NOME:        set_pubblicabile
       DESCRIZIONE: Setter per attributo pubblicabile di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_ni            => p_ni
                      ,p_tipo_contatto => p_tipo_contatto
                      ,p_progressivo   => p_progressivo)
             ,'existsId on soggetti_rubrica_tpk.set_pubblicabile');
      update soggetti_rubrica
         set pubblicabile = p_value
       where ni = p_ni
         and tipo_contatto = p_tipo_contatto
         and progressivo = p_progressivo;
   end set_pubblicabile; -- soggetti_rubrica_tpk.set_pubblicabile
   --------------------------------------------------------------------------------
   procedure set_utente_agg
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
     ,p_value         in soggetti_rubrica.utente_agg%type default null
   ) is
      /******************************************************************************
       NOME:        set_utente_agg
       DESCRIZIONE: Setter per attributo utente_agg di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_ni            => p_ni
                      ,p_tipo_contatto => p_tipo_contatto
                      ,p_progressivo   => p_progressivo)
             ,'existsId on soggetti_rubrica_tpk.set_utente_agg');
      update soggetti_rubrica
         set utente_agg = p_value
       where ni = p_ni
         and tipo_contatto = p_tipo_contatto
         and progressivo = p_progressivo;
   end set_utente_agg; -- soggetti_rubrica_tpk.set_utente_agg
   --------------------------------------------------------------------------------
   procedure set_data_agg
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
     ,p_value         in soggetti_rubrica.data_agg%type default null
   ) is
      /******************************************************************************
       NOME:        set_data_agg
       DESCRIZIONE: Setter per attributo data_agg di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_ni            => p_ni
                      ,p_tipo_contatto => p_tipo_contatto
                      ,p_progressivo   => p_progressivo)
             ,'existsId on soggetti_rubrica_tpk.set_data_agg');
      update soggetti_rubrica
         set data_agg = p_value
       where ni = p_ni
         and tipo_contatto = p_tipo_contatto
         and progressivo = p_progressivo;
   end set_data_agg; -- soggetti_rubrica_tpk.set_data_agg
   --------------------------------------------------------------------------------
   procedure set_descrizione_contatto
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_progressivo   in soggetti_rubrica.progressivo%type
     ,p_value         in soggetti_rubrica.descrizione_contatto%type default null
   ) is
      /******************************************************************************
       NOME:        set_descrizione_contatto
       DESCRIZIONE: Setter per attributo descrizione_contatto di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_ni            => p_ni
                      ,p_tipo_contatto => p_tipo_contatto
                      ,p_progressivo   => p_progressivo)
             ,'existsId on soggetti_rubrica_tpk.set_descrizione_contatto');
      update soggetti_rubrica
         set descrizione_contatto = p_value
       where ni = p_ni
         and tipo_contatto = p_tipo_contatto
         and progressivo = p_progressivo;
   end set_descrizione_contatto; -- soggetti_rubrica_tpk.set_descrizione_contatto
   --------------------------------------------------------------------------------
   function where_condition /* SLAVE_COPY */
   (
      p_qbe                  in number default 0
     ,p_other_condition      in varchar2 default null
     ,p_ni                   in varchar2 default null
     ,p_tipo_contatto        in varchar2 default null
     ,p_progressivo          in varchar2 default null
     ,p_contatto             in varchar2 default null
     ,p_riferimento_tipo     in varchar2 default null
     ,p_riferimento          in varchar2 default null
     ,p_pubblicabile         in varchar2 default null
     ,p_utente_agg           in varchar2 default null
     ,p_data_agg             in varchar2 default null
     ,p_descrizione_contatto in varchar2 default null
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
                     afc.get_field_condition(' and ( ni ', p_ni, ' )', p_qbe, null) ||
                     afc.get_field_condition(' and ( tipo_contatto '
                                            ,p_tipo_contatto
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( progressivo '
                                            ,p_progressivo
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( contatto '
                                            ,p_contatto
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( riferimento_tipo '
                                            ,p_riferimento_tipo
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( riferimento '
                                            ,p_riferimento
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( pubblicabile '
                                            ,p_pubblicabile
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( utente_agg '
                                            ,p_utente_agg
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( data_agg '
                                            ,p_data_agg
                                            ,' )'
                                            ,p_qbe
                                            ,afc.date_format) ||
                     afc.get_field_condition(' and ( descrizione_contatto '
                                            ,p_descrizione_contatto
                                            ,' )'
                                            ,p_qbe
                                            ,null) || ' ) ' || p_other_condition;
      return d_statement;
   end where_condition; --- soggetti_rubrica_tpk.where_condition
   --------------------------------------------------------------------------------
   function get_rows
   (
      p_qbe                  in number default 0
     ,p_other_condition      in varchar2 default null
     ,p_order_by             in varchar2 default null
     ,p_extra_columns        in varchar2 default null
     ,p_extra_condition      in varchar2 default null
     ,p_ni                   in varchar2 default null
     ,p_tipo_contatto        in varchar2 default null
     ,p_progressivo          in varchar2 default null
     ,p_contatto             in varchar2 default null
     ,p_riferimento_tipo     in varchar2 default null
     ,p_riferimento          in varchar2 default null
     ,p_pubblicabile         in varchar2 default null
     ,p_utente_agg           in varchar2 default null
     ,p_data_agg             in varchar2 default null
     ,p_descrizione_contatto in varchar2 default null
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
      d_statement  := ' select SOGGETTI_RUBRICA.* ' ||
                      afc.decode_value(p_extra_columns
                                      ,null
                                      ,null
                                      ,' , ' || p_extra_columns) ||
                      ' from SOGGETTI_RUBRICA ' ||
                      where_condition(p_qbe                  => p_qbe
                                     ,p_other_condition      => p_other_condition
                                     ,p_ni                   => p_ni
                                     ,p_tipo_contatto        => p_tipo_contatto
                                     ,p_progressivo          => p_progressivo
                                     ,p_contatto             => p_contatto
                                     ,p_riferimento_tipo     => p_riferimento_tipo
                                     ,p_riferimento          => p_riferimento
                                     ,p_pubblicabile         => p_pubblicabile
                                     ,p_utente_agg           => p_utente_agg
                                     ,p_data_agg             => p_data_agg
                                     ,p_descrizione_contatto => p_descrizione_contatto) || ' ' ||
                      p_extra_condition ||
                      afc.decode_value(p_order_by, null, null, ' order by ' || p_order_by);
      d_ref_cursor := afc_dml.get_ref_cursor(d_statement);
      return d_ref_cursor;
   end get_rows; -- soggetti_rubrica_tpk.get_rows
   --------------------------------------------------------------------------------
   function count_rows
   (
      p_qbe                  in number default 0
     ,p_other_condition      in varchar2 default null
     ,p_ni                   in varchar2 default null
     ,p_tipo_contatto        in varchar2 default null
     ,p_progressivo          in varchar2 default null
     ,p_contatto             in varchar2 default null
     ,p_riferimento_tipo     in varchar2 default null
     ,p_riferimento          in varchar2 default null
     ,p_pubblicabile         in varchar2 default null
     ,p_utente_agg           in varchar2 default null
     ,p_data_agg             in varchar2 default null
     ,p_descrizione_contatto in varchar2 default null
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
      d_statement := ' select count( * ) from SOGGETTI_RUBRICA ' ||
                     where_condition(p_qbe                  => p_qbe
                                    ,p_other_condition      => p_other_condition
                                    ,p_ni                   => p_ni
                                    ,p_tipo_contatto        => p_tipo_contatto
                                    ,p_progressivo          => p_progressivo
                                    ,p_contatto             => p_contatto
                                    ,p_riferimento_tipo     => p_riferimento_tipo
                                    ,p_riferimento          => p_riferimento
                                    ,p_pubblicabile         => p_pubblicabile
                                    ,p_utente_agg           => p_utente_agg
                                    ,p_data_agg             => p_data_agg
                                    ,p_descrizione_contatto => p_descrizione_contatto);
      d_result    := afc.sql_execute(d_statement);
      return d_result;
   end count_rows; -- soggetti_rubrica_tpk.count_rows
--------------------------------------------------------------------------------

end soggetti_rubrica_tpk;
/

