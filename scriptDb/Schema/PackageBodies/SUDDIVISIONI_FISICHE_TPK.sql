CREATE OR REPLACE package body suddivisioni_fisiche_tpk is
   /******************************************************************************
    NOME:        suddivisioni_fisiche_tpk
    DESCRIZIONE: Gestione tabella SUDDIVISIONI_FISICHE.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore      Descrizione.
    000   14/08/2012  mmonari  Generazione automatica. 
   ******************************************************************************/
   s_revisione_body constant afc.t_revision := '000 - 14/08/2012';
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
   end versione; -- suddivisioni_fisiche_tpk.versione
   --------------------------------------------------------------------------------
   function pk(p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type) return t_pk is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        PK
       DESCRIZIONE: Costruttore di un t_PK dati gli attributi della chiave
      ******************************************************************************/
      d_result t_pk;
   begin
      d_result.id_suddivisione := p_id_suddivisione;
      dbc.pre(not dbc.preon or canhandle(p_id_suddivisione => d_result.id_suddivisione)
             ,'canHandle on suddivisioni_fisiche_tpk.PK');
      return d_result;
   end pk; -- suddivisioni_fisiche_tpk.PK
   --------------------------------------------------------------------------------
   function can_handle(p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type)
      return number is
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
      if d_result = 1 and (p_id_suddivisione is null) then
         d_result := 0;
      end if;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on suddivisioni_fisiche_tpk.can_handle');
      return d_result;
   end can_handle; -- suddivisioni_fisiche_tpk.can_handle
   --------------------------------------------------------------------------------
   function canhandle(p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type)
      return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        canHandle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: true se la chiave e manipolabile, false altrimenti.
       NOTE:        Wrapper boolean di can_handle (cfr. can_handle).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(can_handle(p_id_suddivisione => p_id_suddivisione));
   begin
      return d_result;
   end canhandle; -- suddivisioni_fisiche_tpk.canHandle
   --------------------------------------------------------------------------------
   function exists_id(p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type)
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
      dbc.pre(not dbc.preon or canhandle(p_id_suddivisione => p_id_suddivisione)
             ,'canHandle on suddivisioni_fisiche_tpk.exists_id');
      begin
         select 1
           into d_result
           from suddivisioni_fisiche
          where id_suddivisione = p_id_suddivisione;
      exception
         when no_data_found then
            d_result := 0;
      end;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on suddivisioni_fisiche_tpk.exists_id');
      return d_result;
   end exists_id; -- suddivisioni_fisiche_tpk.exists_id
   --------------------------------------------------------------------------------
   function existsid(p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type)
      return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        existsId
       DESCRIZIONE: Esistenza riga con chiave indicata.
       NOTE:        Wrapper boolean di exists_id (cfr. exists_id).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(exists_id(p_id_suddivisione => p_id_suddivisione));
   begin
      return d_result;
   end existsid; -- suddivisioni_fisiche_tpk.existsId
   --------------------------------------------------------------------------------
   procedure ins
   (
      p_id_suddivisione      in suddivisioni_fisiche.id_suddivisione%type default null
     ,p_amministrazione      in suddivisioni_fisiche.amministrazione%type
     ,p_suddivisione         in suddivisioni_fisiche.suddivisione%type
     ,p_denominazione        in suddivisioni_fisiche.denominazione%type
     ,p_denominazione_al1    in suddivisioni_fisiche.denominazione_al1%type default null
     ,p_denominazione_al2    in suddivisioni_fisiche.denominazione_al2%type default null
     ,p_des_abb              in suddivisioni_fisiche.des_abb%type default null
     ,p_des_abb_al1          in suddivisioni_fisiche.des_abb_al1%type default null
     ,p_des_abb_al2          in suddivisioni_fisiche.des_abb_al2%type default null
     ,p_icona_standard       in suddivisioni_fisiche.icona_standard%type default null
     ,p_nota                 in suddivisioni_fisiche.nota%type default null
     ,p_utente_aggiornamento in suddivisioni_fisiche.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in suddivisioni_fisiche.data_aggiornamento%type default null
     ,p_assegnabile          in suddivisioni_fisiche.assegnabile%type default null
     ,p_ordinamento          in suddivisioni_fisiche.ordinamento%type default null
   ) is
      /******************************************************************************
       NOME:        ins
       DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
       PARAMETRI:   Chiavi e attributi della table.
      ******************************************************************************/
   begin
      -- Check Mandatory on Insert
   
      dbc.pre(not dbc.preon or p_amministrazione is not null or /*default value*/
              '' is not null
             ,'p_amministrazione on suddivisioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_suddivisione is not null or /*default value*/
              '' is not null
             ,'p_suddivisione on suddivisioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_denominazione is not null or /*default value*/
              '' is not null
             ,'p_denominazione on suddivisioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_denominazione_al1 is not null or /*default value*/
              'default' is not null
             ,'p_denominazione_al1 on suddivisioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_denominazione_al2 is not null or /*default value*/
              'default' is not null
             ,'p_denominazione_al2 on suddivisioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_des_abb is not null or /*default value*/
              'default' is not null
             ,'p_des_abb on suddivisioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_des_abb_al1 is not null or /*default value*/
              'default' is not null
             ,'p_des_abb_al1 on suddivisioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_des_abb_al2 is not null or /*default value*/
              'default' is not null
             ,'p_des_abb_al2 on suddivisioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_icona_standard is not null or /*default value*/
              'default' is not null
             ,'p_icona_standard on suddivisioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_nota is not null or /*default value*/
              'default' is not null
             ,'p_nota on suddivisioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_utente_aggiornamento is not null or /*default value*/
              'default' is not null
             ,'p_utente_aggiornamento on suddivisioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_data_aggiornamento is not null or /*default value*/
              'default' is not null
             ,'p_data_aggiornamento on suddivisioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_assegnabile is not null or /*default value*/
              'default' is not null
             ,'p_assegnabile on suddivisioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_ordinamento is not null or /*default value*/
              'default' is not null
             ,'p_ordinamento on suddivisioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or (p_id_suddivisione is null and /*default value*/
              'default null' is not null) -- PK nullable on insert
              or not existsid(p_id_suddivisione => p_id_suddivisione)
             ,'not existsId on suddivisioni_fisiche_tpk.ins');
      insert into suddivisioni_fisiche
         (id_suddivisione
         ,amministrazione
         ,suddivisione
         ,denominazione
         ,denominazione_al1
         ,denominazione_al2
         ,des_abb
         ,des_abb_al1
         ,des_abb_al2
         ,icona_standard
         ,nota
         ,utente_aggiornamento
         ,data_aggiornamento
         ,assegnabile
         ,ordinamento)
      values
         (p_id_suddivisione
         ,p_amministrazione
         ,p_suddivisione
         ,p_denominazione
         ,p_denominazione_al1
         ,p_denominazione_al2
         ,p_des_abb
         ,p_des_abb_al1
         ,p_des_abb_al2
         ,p_icona_standard
         ,p_nota
         ,p_utente_aggiornamento
         ,p_data_aggiornamento
         ,p_assegnabile
         ,p_ordinamento);
   end ins; -- suddivisioni_fisiche_tpk.ins
   --------------------------------------------------------------------------------
   function ins
   (
      p_id_suddivisione      in suddivisioni_fisiche.id_suddivisione%type default null
     ,p_amministrazione      in suddivisioni_fisiche.amministrazione%type
     ,p_suddivisione         in suddivisioni_fisiche.suddivisione%type
     ,p_denominazione        in suddivisioni_fisiche.denominazione%type
     ,p_denominazione_al1    in suddivisioni_fisiche.denominazione_al1%type default null
     ,p_denominazione_al2    in suddivisioni_fisiche.denominazione_al2%type default null
     ,p_des_abb              in suddivisioni_fisiche.des_abb%type default null
     ,p_des_abb_al1          in suddivisioni_fisiche.des_abb_al1%type default null
     ,p_des_abb_al2          in suddivisioni_fisiche.des_abb_al2%type default null
     ,p_icona_standard       in suddivisioni_fisiche.icona_standard%type default null
     ,p_nota                 in suddivisioni_fisiche.nota%type default null
     ,p_utente_aggiornamento in suddivisioni_fisiche.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in suddivisioni_fisiche.data_aggiornamento%type default null
     ,p_assegnabile          in suddivisioni_fisiche.assegnabile%type default null
     ,p_ordinamento          in suddivisioni_fisiche.ordinamento%type default null
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
   
      dbc.pre(not dbc.preon or p_amministrazione is not null or /*default value*/
              '' is not null
             ,'p_amministrazione on suddivisioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_suddivisione is not null or /*default value*/
              '' is not null
             ,'p_suddivisione on suddivisioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_denominazione is not null or /*default value*/
              '' is not null
             ,'p_denominazione on suddivisioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_denominazione_al1 is not null or /*default value*/
              'default' is not null
             ,'p_denominazione_al1 on suddivisioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_denominazione_al2 is not null or /*default value*/
              'default' is not null
             ,'p_denominazione_al2 on suddivisioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_des_abb is not null or /*default value*/
              'default' is not null
             ,'p_des_abb on suddivisioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_des_abb_al1 is not null or /*default value*/
              'default' is not null
             ,'p_des_abb_al1 on suddivisioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_des_abb_al2 is not null or /*default value*/
              'default' is not null
             ,'p_des_abb_al2 on suddivisioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_icona_standard is not null or /*default value*/
              'default' is not null
             ,'p_icona_standard on suddivisioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_nota is not null or /*default value*/
              'default' is not null
             ,'p_nota on suddivisioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_utente_aggiornamento is not null or /*default value*/
              'default' is not null
             ,'p_utente_aggiornamento on suddivisioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_data_aggiornamento is not null or /*default value*/
              'default' is not null
             ,'p_data_aggiornamento on suddivisioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_assegnabile is not null or /*default value*/
              'default' is not null
             ,'p_assegnabile on suddivisioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or p_ordinamento is not null or /*default value*/
              'default' is not null
             ,'p_ordinamento on suddivisioni_fisiche_tpk.ins');
      dbc.pre(not dbc.preon or (p_id_suddivisione is null and /*default value*/
              'default null' is not null) -- PK nullable on insert
              or not existsid(p_id_suddivisione => p_id_suddivisione)
             ,'not existsId on suddivisioni_fisiche_tpk.ins');
      insert into suddivisioni_fisiche
         (id_suddivisione
         ,amministrazione
         ,suddivisione
         ,denominazione
         ,denominazione_al1
         ,denominazione_al2
         ,des_abb
         ,des_abb_al1
         ,des_abb_al2
         ,icona_standard
         ,nota
         ,utente_aggiornamento
         ,data_aggiornamento
         ,assegnabile
         ,ordinamento)
      values
         (p_id_suddivisione
         ,p_amministrazione
         ,p_suddivisione
         ,p_denominazione
         ,p_denominazione_al1
         ,p_denominazione_al2
         ,p_des_abb
         ,p_des_abb_al1
         ,p_des_abb_al2
         ,p_icona_standard
         ,p_nota
         ,p_utente_aggiornamento
         ,p_data_aggiornamento
         ,p_assegnabile
         ,p_ordinamento)
      returning id_suddivisione into d_result;
      return d_result;
   end ins; -- suddivisioni_fisiche_tpk.ins
   --------------------------------------------------------------------------------
   procedure upd
   (
      p_check_old                in integer default 0
     ,p_new_id_suddivisione      in suddivisioni_fisiche.id_suddivisione%type
     ,p_old_id_suddivisione      in suddivisioni_fisiche.id_suddivisione%type default null
     ,p_new_amministrazione      in suddivisioni_fisiche.amministrazione%type default afc.default_null('SUDDIVISIONI_FISICHE.amministrazione')
     ,p_old_amministrazione      in suddivisioni_fisiche.amministrazione%type default null
     ,p_new_suddivisione         in suddivisioni_fisiche.suddivisione%type default afc.default_null('SUDDIVISIONI_FISICHE.suddivisione')
     ,p_old_suddivisione         in suddivisioni_fisiche.suddivisione%type default null
     ,p_new_denominazione        in suddivisioni_fisiche.denominazione%type default afc.default_null('SUDDIVISIONI_FISICHE.denominazione')
     ,p_old_denominazione        in suddivisioni_fisiche.denominazione%type default null
     ,p_new_denominazione_al1    in suddivisioni_fisiche.denominazione_al1%type default afc.default_null('SUDDIVISIONI_FISICHE.denominazione_al1')
     ,p_old_denominazione_al1    in suddivisioni_fisiche.denominazione_al1%type default null
     ,p_new_denominazione_al2    in suddivisioni_fisiche.denominazione_al2%type default afc.default_null('SUDDIVISIONI_FISICHE.denominazione_al2')
     ,p_old_denominazione_al2    in suddivisioni_fisiche.denominazione_al2%type default null
     ,p_new_des_abb              in suddivisioni_fisiche.des_abb%type default afc.default_null('SUDDIVISIONI_FISICHE.des_abb')
     ,p_old_des_abb              in suddivisioni_fisiche.des_abb%type default null
     ,p_new_des_abb_al1          in suddivisioni_fisiche.des_abb_al1%type default afc.default_null('SUDDIVISIONI_FISICHE.des_abb_al1')
     ,p_old_des_abb_al1          in suddivisioni_fisiche.des_abb_al1%type default null
     ,p_new_des_abb_al2          in suddivisioni_fisiche.des_abb_al2%type default afc.default_null('SUDDIVISIONI_FISICHE.des_abb_al2')
     ,p_old_des_abb_al2          in suddivisioni_fisiche.des_abb_al2%type default null
     ,p_new_icona_standard       in suddivisioni_fisiche.icona_standard%type default afc.default_null('SUDDIVISIONI_FISICHE.icona_standard')
     ,p_old_icona_standard       in suddivisioni_fisiche.icona_standard%type default null
     ,p_new_nota                 in suddivisioni_fisiche.nota%type default afc.default_null('SUDDIVISIONI_FISICHE.nota')
     ,p_old_nota                 in suddivisioni_fisiche.nota%type default null
     ,p_new_utente_aggiornamento in suddivisioni_fisiche.utente_aggiornamento%type default afc.default_null('SUDDIVISIONI_FISICHE.utente_aggiornamento')
     ,p_old_utente_aggiornamento in suddivisioni_fisiche.utente_aggiornamento%type default null
     ,p_new_data_aggiornamento   in suddivisioni_fisiche.data_aggiornamento%type default afc.default_null('SUDDIVISIONI_FISICHE.data_aggiornamento')
     ,p_old_data_aggiornamento   in suddivisioni_fisiche.data_aggiornamento%type default null
     ,p_new_assegnabile          in suddivisioni_fisiche.assegnabile%type default afc.default_null('SUDDIVISIONI_FISICHE.assegnabile')
     ,p_old_assegnabile          in suddivisioni_fisiche.assegnabile%type default null
     ,p_new_ordinamento          in suddivisioni_fisiche.ordinamento%type default afc.default_null('SUDDIVISIONI_FISICHE.ordinamento')
     ,p_old_ordinamento          in suddivisioni_fisiche.ordinamento%type default null
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
      d_key := pk(nvl(p_old_id_suddivisione, p_new_id_suddivisione));
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => d_key.id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.upd');
      update suddivisioni_fisiche
         set id_suddivisione      = nvl(p_new_id_suddivisione
                                       ,decode(afc.is_default_null('SUDDIVISIONI_FISICHE.id_suddivisione')
                                              ,1
                                              ,id_suddivisione
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_id_suddivisione
                                                            ,null
                                                            ,id_suddivisione
                                                            ,null))))
            ,amministrazione      = nvl(p_new_amministrazione
                                       ,decode(afc.is_default_null('SUDDIVISIONI_FISICHE.amministrazione')
                                              ,1
                                              ,amministrazione
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_amministrazione
                                                            ,null
                                                            ,amministrazione
                                                            ,null))))
            ,suddivisione         = nvl(p_new_suddivisione
                                       ,decode(afc.is_default_null('SUDDIVISIONI_FISICHE.suddivisione')
                                              ,1
                                              ,suddivisione
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_suddivisione
                                                            ,null
                                                            ,suddivisione
                                                            ,null))))
            ,denominazione        = nvl(p_new_denominazione
                                       ,decode(afc.is_default_null('SUDDIVISIONI_FISICHE.denominazione')
                                              ,1
                                              ,denominazione
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_denominazione
                                                            ,null
                                                            ,denominazione
                                                            ,null))))
            ,denominazione_al1    = nvl(p_new_denominazione_al1
                                       ,decode(afc.is_default_null('SUDDIVISIONI_FISICHE.denominazione_al1')
                                              ,1
                                              ,denominazione_al1
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_denominazione_al1
                                                            ,null
                                                            ,denominazione_al1
                                                            ,null))))
            ,denominazione_al2    = nvl(p_new_denominazione_al2
                                       ,decode(afc.is_default_null('SUDDIVISIONI_FISICHE.denominazione_al2')
                                              ,1
                                              ,denominazione_al2
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_denominazione_al2
                                                            ,null
                                                            ,denominazione_al2
                                                            ,null))))
            ,des_abb              = nvl(p_new_des_abb
                                       ,decode(afc.is_default_null('SUDDIVISIONI_FISICHE.des_abb')
                                              ,1
                                              ,des_abb
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_des_abb
                                                            ,null
                                                            ,des_abb
                                                            ,null))))
            ,des_abb_al1          = nvl(p_new_des_abb_al1
                                       ,decode(afc.is_default_null('SUDDIVISIONI_FISICHE.des_abb_al1')
                                              ,1
                                              ,des_abb_al1
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_des_abb_al1
                                                            ,null
                                                            ,des_abb_al1
                                                            ,null))))
            ,des_abb_al2          = nvl(p_new_des_abb_al2
                                       ,decode(afc.is_default_null('SUDDIVISIONI_FISICHE.des_abb_al2')
                                              ,1
                                              ,des_abb_al2
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_des_abb_al2
                                                            ,null
                                                            ,des_abb_al2
                                                            ,null))))
            ,icona_standard       = nvl(p_new_icona_standard
                                       ,decode(afc.is_default_null('SUDDIVISIONI_FISICHE.icona_standard')
                                              ,1
                                              ,icona_standard
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_icona_standard
                                                            ,null
                                                            ,icona_standard
                                                            ,null))))
            ,nota                 = nvl(p_new_nota
                                       ,decode(afc.is_default_null('SUDDIVISIONI_FISICHE.nota')
                                              ,1
                                              ,nota
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_nota, null, nota, null))))
            ,utente_aggiornamento = nvl(p_new_utente_aggiornamento
                                       ,decode(afc.is_default_null('SUDDIVISIONI_FISICHE.utente_aggiornamento')
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
                                       ,decode(afc.is_default_null('SUDDIVISIONI_FISICHE.data_aggiornamento')
                                              ,1
                                              ,data_aggiornamento
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_data_aggiornamento
                                                            ,null
                                                            ,data_aggiornamento
                                                            ,null))))
            ,assegnabile          = nvl(p_new_assegnabile
                                       ,decode(afc.is_default_null('SUDDIVISIONI_FISICHE.assegnabile')
                                              ,1
                                              ,assegnabile
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_assegnabile
                                                            ,null
                                                            ,assegnabile
                                                            ,null))))
            ,ordinamento          = nvl(p_new_ordinamento
                                       ,decode(afc.is_default_null('SUDDIVISIONI_FISICHE.ordinamento')
                                              ,1
                                              ,ordinamento
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_ordinamento
                                                            ,null
                                                            ,ordinamento
                                                            ,null))))
       where id_suddivisione = d_key.id_suddivisione
         and (p_check_old = 0 or
             (1 = 1 and (amministrazione = p_old_amministrazione or
             (p_old_amministrazione is null and
             (p_check_old is null or amministrazione is null))) and
             (suddivisione = p_old_suddivisione or
             (p_old_suddivisione is null and
             (p_check_old is null or suddivisione is null))) and
             (denominazione = p_old_denominazione or
             (p_old_denominazione is null and
             (p_check_old is null or denominazione is null))) and
             (denominazione_al1 = p_old_denominazione_al1 or
             (p_old_denominazione_al1 is null and
             (p_check_old is null or denominazione_al1 is null))) and
             (denominazione_al2 = p_old_denominazione_al2 or
             (p_old_denominazione_al2 is null and
             (p_check_old is null or denominazione_al2 is null))) and
             (des_abb = p_old_des_abb or
             (p_old_des_abb is null and (p_check_old is null or des_abb is null))) and
             (des_abb_al1 = p_old_des_abb_al1 or
             (p_old_des_abb_al1 is null and
             (p_check_old is null or des_abb_al1 is null))) and
             (des_abb_al2 = p_old_des_abb_al2 or
             (p_old_des_abb_al2 is null and
             (p_check_old is null or des_abb_al2 is null))) and
             (icona_standard = p_old_icona_standard or
             (p_old_icona_standard is null and
             (p_check_old is null or icona_standard is null))) and
             (nota = p_old_nota or
             (p_old_nota is null and (p_check_old is null or nota is null))) and
             (utente_aggiornamento = p_old_utente_aggiornamento or
             (p_old_utente_aggiornamento is null and
             (p_check_old is null or utente_aggiornamento is null))) and
             (data_aggiornamento = p_old_data_aggiornamento or
             (p_old_data_aggiornamento is null and
             (p_check_old is null or data_aggiornamento is null))) and
             (assegnabile = p_old_assegnabile or
             (p_old_assegnabile is null and
             (p_check_old is null or assegnabile is null))) and
             (ordinamento = p_old_ordinamento or
             (p_old_ordinamento is null and
             (p_check_old is null or ordinamento is null)))));
      d_row_found := sql%rowcount;
      afc.default_null(null);
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on suddivisioni_fisiche_tpk.upd');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   end upd; -- suddivisioni_fisiche_tpk.upd
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type
     ,p_column          in varchar2
     ,p_value           in varchar2 default null
     ,p_literal_value   in number default 1
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
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => p_id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.upd_column');
      dbc.pre(not dbc.preon or p_column is not null
             ,'p_column is not null on suddivisioni_fisiche_tpk.upd_column');
      dbc.pre(not dbc.preon or afc_ddl.hasattribute(s_table_name, p_column)
             ,'AFC_DDL.HasAttribute on suddivisioni_fisiche_tpk.upd_column');
      dbc.pre(p_literal_value in (0, 1) or p_literal_value is null
             ,'p_literal_value on suddivisioni_fisiche_tpk.upd_column; p_literal_value = ' ||
              p_literal_value);
      if p_literal_value = 1 or p_literal_value is null then
         d_literal := '''';
      end if;
      d_statement := ' declare ' || '    d_row_found number; ' || ' begin ' ||
                     '    update SUDDIVISIONI_FISICHE ' || '       set ' || p_column ||
                     ' = ' || d_literal || p_value || d_literal || '     where 1 = 1 ' ||
                     nvl(afc.get_field_condition(' and ( id_suddivisione '
                                                ,p_id_suddivisione
                                                ,' )'
                                                ,0
                                                ,null)
                        ,' and ( id_suddivisione is null ) ') || '    ; ' ||
                     '    d_row_found := SQL%ROWCOUNT; ' || '    if d_row_found < 1 ' ||
                     '    then ' ||
                     '       raise_application_error ( AFC_ERROR.modified_by_other_user_number, AFC_ERROR.modified_by_other_user_msg ); ' ||
                     '    end if; ' || ' end; ';
      afc.sql_execute(d_statement);
   end upd_column; -- suddivisioni_fisiche_tpk.upd_column
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type
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
      d_data := to_char(p_value, afc.date_format);
      upd_column(p_id_suddivisione => p_id_suddivisione
                ,p_column          => p_column
                ,p_value           => 'to_date( ''' || d_data || ''', ''' ||
                                      afc.date_format || ''' )'
                ,p_literal_value   => 0);
   end upd_column; -- suddivisioni_fisiche_tpk.upd_column
   --------------------------------------------------------------------------------
   procedure del
   (
      p_check_old            in integer default 0
     ,p_id_suddivisione      in suddivisioni_fisiche.id_suddivisione%type
     ,p_amministrazione      in suddivisioni_fisiche.amministrazione%type default null
     ,p_suddivisione         in suddivisioni_fisiche.suddivisione%type default null
     ,p_denominazione        in suddivisioni_fisiche.denominazione%type default null
     ,p_denominazione_al1    in suddivisioni_fisiche.denominazione_al1%type default null
     ,p_denominazione_al2    in suddivisioni_fisiche.denominazione_al2%type default null
     ,p_des_abb              in suddivisioni_fisiche.des_abb%type default null
     ,p_des_abb_al1          in suddivisioni_fisiche.des_abb_al1%type default null
     ,p_des_abb_al2          in suddivisioni_fisiche.des_abb_al2%type default null
     ,p_icona_standard       in suddivisioni_fisiche.icona_standard%type default null
     ,p_nota                 in suddivisioni_fisiche.nota%type default null
     ,p_utente_aggiornamento in suddivisioni_fisiche.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in suddivisioni_fisiche.data_aggiornamento%type default null
     ,p_assegnabile          in suddivisioni_fisiche.assegnabile%type default null
     ,p_ordinamento          in suddivisioni_fisiche.ordinamento%type default null
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
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => p_id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.del');
      delete from suddivisioni_fisiche
       where id_suddivisione = p_id_suddivisione
         and (p_check_old = 0 or
             (1 = 1 and (amministrazione = p_amministrazione or
             (p_amministrazione is null and
             (p_check_old is null or amministrazione is null))) and
             (suddivisione = p_suddivisione or
             (p_suddivisione is null and (p_check_old is null or suddivisione is null))) and
             (denominazione = p_denominazione or
             (p_denominazione is null and
             (p_check_old is null or denominazione is null))) and
             (denominazione_al1 = p_denominazione_al1 or
             (p_denominazione_al1 is null and
             (p_check_old is null or denominazione_al1 is null))) and
             (denominazione_al2 = p_denominazione_al2 or
             (p_denominazione_al2 is null and
             (p_check_old is null or denominazione_al2 is null))) and
             (des_abb = p_des_abb or
             (p_des_abb is null and (p_check_old is null or des_abb is null))) and
             (des_abb_al1 = p_des_abb_al1 or
             (p_des_abb_al1 is null and (p_check_old is null or des_abb_al1 is null))) and
             (des_abb_al2 = p_des_abb_al2 or
             (p_des_abb_al2 is null and (p_check_old is null or des_abb_al2 is null))) and
             (icona_standard = p_icona_standard or
             (p_icona_standard is null and
             (p_check_old is null or icona_standard is null))) and
             (nota = p_nota or
             (p_nota is null and (p_check_old is null or nota is null))) and
             (utente_aggiornamento = p_utente_aggiornamento or
             (p_utente_aggiornamento is null and
             (p_check_old is null or utente_aggiornamento is null))) and
             (data_aggiornamento = p_data_aggiornamento or
             (p_data_aggiornamento is null and
             (p_check_old is null or data_aggiornamento is null))) and
             (assegnabile = p_assegnabile or
             (p_assegnabile is null and (p_check_old is null or assegnabile is null))) and
             (ordinamento = p_ordinamento or
             (p_ordinamento is null and (p_check_old is null or ordinamento is null)))));
      d_row_found := sql%rowcount;
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on suddivisioni_fisiche_tpk.del');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
      dbc.post(not dbc.poston or not existsid(p_id_suddivisione => p_id_suddivisione)
              ,'existsId on suddivisioni_fisiche_tpk.del');
   end del; -- suddivisioni_fisiche_tpk.del
   --------------------------------------------------------------------------------
   function get_amministrazione(p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type)
      return suddivisioni_fisiche.amministrazione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_amministrazione
       DESCRIZIONE: Getter per attributo amministrazione di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     SUDDIVISIONI_FISICHE.amministrazione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result suddivisioni_fisiche.amministrazione%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => p_id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.get_amministrazione');
      select amministrazione
        into d_result
        from suddivisioni_fisiche
       where id_suddivisione = p_id_suddivisione;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on suddivisioni_fisiche_tpk.get_amministrazione');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'amministrazione')
                      ,' AFC_DDL.IsNullable on suddivisioni_fisiche_tpk.get_amministrazione');
      end if;
      return d_result;
   end get_amministrazione; -- suddivisioni_fisiche_tpk.get_amministrazione
   --------------------------------------------------------------------------------
   function get_suddivisione(p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type)
      return suddivisioni_fisiche.suddivisione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_suddivisione
       DESCRIZIONE: Getter per attributo suddivisione di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     SUDDIVISIONI_FISICHE.suddivisione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result suddivisioni_fisiche.suddivisione%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => p_id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.get_suddivisione');
      select suddivisione
        into d_result
        from suddivisioni_fisiche
       where id_suddivisione = p_id_suddivisione;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on suddivisioni_fisiche_tpk.get_suddivisione');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'suddivisione')
                      ,' AFC_DDL.IsNullable on suddivisioni_fisiche_tpk.get_suddivisione');
      end if;
      return d_result;
   end get_suddivisione; -- suddivisioni_fisiche_tpk.get_suddivisione
   --------------------------------------------------------------------------------
   function get_denominazione(p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type)
      return suddivisioni_fisiche.denominazione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_denominazione
       DESCRIZIONE: Getter per attributo denominazione di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     SUDDIVISIONI_FISICHE.denominazione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result suddivisioni_fisiche.denominazione%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => p_id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.get_denominazione');
      select denominazione
        into d_result
        from suddivisioni_fisiche
       where id_suddivisione = p_id_suddivisione;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on suddivisioni_fisiche_tpk.get_denominazione');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'denominazione')
                      ,' AFC_DDL.IsNullable on suddivisioni_fisiche_tpk.get_denominazione');
      end if;
      return d_result;
   end get_denominazione; -- suddivisioni_fisiche_tpk.get_denominazione
   --------------------------------------------------------------------------------
   function get_denominazione_al1(p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type)
      return suddivisioni_fisiche.denominazione_al1%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_denominazione_al1
       DESCRIZIONE: Getter per attributo denominazione_al1 di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     SUDDIVISIONI_FISICHE.denominazione_al1%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result suddivisioni_fisiche.denominazione_al1%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => p_id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.get_denominazione_al1');
      select denominazione_al1
        into d_result
        from suddivisioni_fisiche
       where id_suddivisione = p_id_suddivisione;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on suddivisioni_fisiche_tpk.get_denominazione_al1');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'denominazione_al1')
                      ,' AFC_DDL.IsNullable on suddivisioni_fisiche_tpk.get_denominazione_al1');
      end if;
      return d_result;
   end get_denominazione_al1; -- suddivisioni_fisiche_tpk.get_denominazione_al1
   --------------------------------------------------------------------------------
   function get_denominazione_al2(p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type)
      return suddivisioni_fisiche.denominazione_al2%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_denominazione_al2
       DESCRIZIONE: Getter per attributo denominazione_al2 di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     SUDDIVISIONI_FISICHE.denominazione_al2%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result suddivisioni_fisiche.denominazione_al2%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => p_id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.get_denominazione_al2');
      select denominazione_al2
        into d_result
        from suddivisioni_fisiche
       where id_suddivisione = p_id_suddivisione;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on suddivisioni_fisiche_tpk.get_denominazione_al2');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'denominazione_al2')
                      ,' AFC_DDL.IsNullable on suddivisioni_fisiche_tpk.get_denominazione_al2');
      end if;
      return d_result;
   end get_denominazione_al2; -- suddivisioni_fisiche_tpk.get_denominazione_al2
   --------------------------------------------------------------------------------
   function get_des_abb(p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type)
      return suddivisioni_fisiche.des_abb%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_des_abb
       DESCRIZIONE: Getter per attributo des_abb di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     SUDDIVISIONI_FISICHE.des_abb%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result suddivisioni_fisiche.des_abb%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => p_id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.get_des_abb');
      select des_abb
        into d_result
        from suddivisioni_fisiche
       where id_suddivisione = p_id_suddivisione;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on suddivisioni_fisiche_tpk.get_des_abb');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'des_abb')
                      ,' AFC_DDL.IsNullable on suddivisioni_fisiche_tpk.get_des_abb');
      end if;
      return d_result;
   end get_des_abb; -- suddivisioni_fisiche_tpk.get_des_abb
   --------------------------------------------------------------------------------
   function get_des_abb_al1(p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type)
      return suddivisioni_fisiche.des_abb_al1%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_des_abb_al1
       DESCRIZIONE: Getter per attributo des_abb_al1 di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     SUDDIVISIONI_FISICHE.des_abb_al1%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result suddivisioni_fisiche.des_abb_al1%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => p_id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.get_des_abb_al1');
      select des_abb_al1
        into d_result
        from suddivisioni_fisiche
       where id_suddivisione = p_id_suddivisione;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on suddivisioni_fisiche_tpk.get_des_abb_al1');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'des_abb_al1')
                      ,' AFC_DDL.IsNullable on suddivisioni_fisiche_tpk.get_des_abb_al1');
      end if;
      return d_result;
   end get_des_abb_al1; -- suddivisioni_fisiche_tpk.get_des_abb_al1
   --------------------------------------------------------------------------------
   function get_des_abb_al2(p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type)
      return suddivisioni_fisiche.des_abb_al2%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_des_abb_al2
       DESCRIZIONE: Getter per attributo des_abb_al2 di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     SUDDIVISIONI_FISICHE.des_abb_al2%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result suddivisioni_fisiche.des_abb_al2%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => p_id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.get_des_abb_al2');
      select des_abb_al2
        into d_result
        from suddivisioni_fisiche
       where id_suddivisione = p_id_suddivisione;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on suddivisioni_fisiche_tpk.get_des_abb_al2');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'des_abb_al2')
                      ,' AFC_DDL.IsNullable on suddivisioni_fisiche_tpk.get_des_abb_al2');
      end if;
      return d_result;
   end get_des_abb_al2; -- suddivisioni_fisiche_tpk.get_des_abb_al2
   --------------------------------------------------------------------------------
   function get_icona_standard(p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type)
      return suddivisioni_fisiche.icona_standard%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_icona_standard
       DESCRIZIONE: Getter per attributo icona_standard di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     SUDDIVISIONI_FISICHE.icona_standard%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result suddivisioni_fisiche.icona_standard%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => p_id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.get_icona_standard');
      select icona_standard
        into d_result
        from suddivisioni_fisiche
       where id_suddivisione = p_id_suddivisione;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on suddivisioni_fisiche_tpk.get_icona_standard');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'icona_standard')
                      ,' AFC_DDL.IsNullable on suddivisioni_fisiche_tpk.get_icona_standard');
      end if;
      return d_result;
   end get_icona_standard; -- suddivisioni_fisiche_tpk.get_icona_standard
   --------------------------------------------------------------------------------
   function get_blob_icona_standard(p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type)
      return suddivisioni_fisiche.blob_icona_standard%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_blob_icona_standard
       DESCRIZIONE: Getter per attributo blob_icona_standard di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     SUDDIVISIONI_FISICHE.blob_icona_standard%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result suddivisioni_fisiche.blob_icona_standard%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => p_id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.get_blob_icona_standard');
      select blob_icona_standard
        into d_result
        from suddivisioni_fisiche
       where id_suddivisione = p_id_suddivisione;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on suddivisioni_fisiche_tpk.get_blob_icona_standard');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'blob_icona_standard')
                      ,' AFC_DDL.IsNullable on suddivisioni_fisiche_tpk.get_blob_icona_standard');
      end if;
      return d_result;
   end get_blob_icona_standard; -- suddivisioni_fisiche_tpk.get_blob_icona_standard
   --------------------------------------------------------------------------------
   function get_nota(p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type)
      return suddivisioni_fisiche.nota%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_nota
       DESCRIZIONE: Getter per attributo nota di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     SUDDIVISIONI_FISICHE.nota%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result suddivisioni_fisiche.nota%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => p_id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.get_nota');
      select nota
        into d_result
        from suddivisioni_fisiche
       where id_suddivisione = p_id_suddivisione;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on suddivisioni_fisiche_tpk.get_nota');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'nota')
                      ,' AFC_DDL.IsNullable on suddivisioni_fisiche_tpk.get_nota');
      end if;
      return d_result;
   end get_nota; -- suddivisioni_fisiche_tpk.get_nota
   --------------------------------------------------------------------------------
   function get_utente_aggiornamento(p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type)
      return suddivisioni_fisiche.utente_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_utente_aggiornamento
       DESCRIZIONE: Getter per attributo utente_aggiornamento di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     SUDDIVISIONI_FISICHE.utente_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result suddivisioni_fisiche.utente_aggiornamento%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => p_id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.get_utente_aggiornamento');
      select utente_aggiornamento
        into d_result
        from suddivisioni_fisiche
       where id_suddivisione = p_id_suddivisione;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on suddivisioni_fisiche_tpk.get_utente_aggiornamento');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'utente_aggiornamento')
                      ,' AFC_DDL.IsNullable on suddivisioni_fisiche_tpk.get_utente_aggiornamento');
      end if;
      return d_result;
   end get_utente_aggiornamento; -- suddivisioni_fisiche_tpk.get_utente_aggiornamento
   --------------------------------------------------------------------------------
   function get_data_aggiornamento(p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type)
      return suddivisioni_fisiche.data_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_data_aggiornamento
       DESCRIZIONE: Getter per attributo data_aggiornamento di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     SUDDIVISIONI_FISICHE.data_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result suddivisioni_fisiche.data_aggiornamento%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => p_id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.get_data_aggiornamento');
      select data_aggiornamento
        into d_result
        from suddivisioni_fisiche
       where id_suddivisione = p_id_suddivisione;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on suddivisioni_fisiche_tpk.get_data_aggiornamento');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'data_aggiornamento')
                      ,' AFC_DDL.IsNullable on suddivisioni_fisiche_tpk.get_data_aggiornamento');
      end if;
      return d_result;
   end get_data_aggiornamento; -- suddivisioni_fisiche_tpk.get_data_aggiornamento
   --------------------------------------------------------------------------------
   function get_assegnabile(p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type)
      return suddivisioni_fisiche.assegnabile%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_assegnabile
       DESCRIZIONE: Getter per attributo assegnabile di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     SUDDIVISIONI_FISICHE.assegnabile%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result suddivisioni_fisiche.assegnabile%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => p_id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.get_assegnabile');
      select assegnabile
        into d_result
        from suddivisioni_fisiche
       where id_suddivisione = p_id_suddivisione;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on suddivisioni_fisiche_tpk.get_assegnabile');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'assegnabile')
                      ,' AFC_DDL.IsNullable on suddivisioni_fisiche_tpk.get_assegnabile');
      end if;
      return d_result;
   end get_assegnabile; -- suddivisioni_fisiche_tpk.get_assegnabile
   --------------------------------------------------------------------------------
   function get_ordinamento(p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type)
      return suddivisioni_fisiche.ordinamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_ordinamento
       DESCRIZIONE: Getter per attributo ordinamento di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     SUDDIVISIONI_FISICHE.ordinamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result suddivisioni_fisiche.ordinamento%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => p_id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.get_ordinamento');
      select ordinamento
        into d_result
        from suddivisioni_fisiche
       where id_suddivisione = p_id_suddivisione;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on suddivisioni_fisiche_tpk.get_ordinamento');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'ordinamento')
                      ,' AFC_DDL.IsNullable on suddivisioni_fisiche_tpk.get_ordinamento');
      end if;
      return d_result;
   end get_ordinamento; -- suddivisioni_fisiche_tpk.get_ordinamento
   --------------------------------------------------------------------------------
   procedure set_id_suddivisione
   (
      p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type
     ,p_value           in suddivisioni_fisiche.id_suddivisione%type default null
   ) is
      /******************************************************************************
       NOME:        set_id_suddivisione
       DESCRIZIONE: Setter per attributo id_suddivisione di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => p_id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.set_id_suddivisione');
      update suddivisioni_fisiche
         set id_suddivisione = p_value
       where id_suddivisione = p_id_suddivisione;
   end set_id_suddivisione; -- suddivisioni_fisiche_tpk.set_id_suddivisione
   --------------------------------------------------------------------------------
   procedure set_amministrazione
   (
      p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type
     ,p_value           in suddivisioni_fisiche.amministrazione%type default null
   ) is
      /******************************************************************************
       NOME:        set_amministrazione
       DESCRIZIONE: Setter per attributo amministrazione di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => p_id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.set_amministrazione');
      update suddivisioni_fisiche
         set amministrazione = p_value
       where id_suddivisione = p_id_suddivisione;
   end set_amministrazione; -- suddivisioni_fisiche_tpk.set_amministrazione
   --------------------------------------------------------------------------------
   procedure set_suddivisione
   (
      p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type
     ,p_value           in suddivisioni_fisiche.suddivisione%type default null
   ) is
      /******************************************************************************
       NOME:        set_suddivisione
       DESCRIZIONE: Setter per attributo suddivisione di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => p_id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.set_suddivisione');
      update suddivisioni_fisiche
         set suddivisione = p_value
       where id_suddivisione = p_id_suddivisione;
   end set_suddivisione; -- suddivisioni_fisiche_tpk.set_suddivisione
   --------------------------------------------------------------------------------
   procedure set_denominazione
   (
      p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type
     ,p_value           in suddivisioni_fisiche.denominazione%type default null
   ) is
      /******************************************************************************
       NOME:        set_denominazione
       DESCRIZIONE: Setter per attributo denominazione di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => p_id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.set_denominazione');
      update suddivisioni_fisiche
         set denominazione = p_value
       where id_suddivisione = p_id_suddivisione;
   end set_denominazione; -- suddivisioni_fisiche_tpk.set_denominazione
   --------------------------------------------------------------------------------
   procedure set_denominazione_al1
   (
      p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type
     ,p_value           in suddivisioni_fisiche.denominazione_al1%type default null
   ) is
      /******************************************************************************
       NOME:        set_denominazione_al1
       DESCRIZIONE: Setter per attributo denominazione_al1 di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => p_id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.set_denominazione_al1');
      update suddivisioni_fisiche
         set denominazione_al1 = p_value
       where id_suddivisione = p_id_suddivisione;
   end set_denominazione_al1; -- suddivisioni_fisiche_tpk.set_denominazione_al1
   --------------------------------------------------------------------------------
   procedure set_denominazione_al2
   (
      p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type
     ,p_value           in suddivisioni_fisiche.denominazione_al2%type default null
   ) is
      /******************************************************************************
       NOME:        set_denominazione_al2
       DESCRIZIONE: Setter per attributo denominazione_al2 di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => p_id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.set_denominazione_al2');
      update suddivisioni_fisiche
         set denominazione_al2 = p_value
       where id_suddivisione = p_id_suddivisione;
   end set_denominazione_al2; -- suddivisioni_fisiche_tpk.set_denominazione_al2
   --------------------------------------------------------------------------------
   procedure set_des_abb
   (
      p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type
     ,p_value           in suddivisioni_fisiche.des_abb%type default null
   ) is
      /******************************************************************************
       NOME:        set_des_abb
       DESCRIZIONE: Setter per attributo des_abb di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => p_id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.set_des_abb');
      update suddivisioni_fisiche
         set des_abb = p_value
       where id_suddivisione = p_id_suddivisione;
   end set_des_abb; -- suddivisioni_fisiche_tpk.set_des_abb
   --------------------------------------------------------------------------------
   procedure set_des_abb_al1
   (
      p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type
     ,p_value           in suddivisioni_fisiche.des_abb_al1%type default null
   ) is
      /******************************************************************************
       NOME:        set_des_abb_al1
       DESCRIZIONE: Setter per attributo des_abb_al1 di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => p_id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.set_des_abb_al1');
      update suddivisioni_fisiche
         set des_abb_al1 = p_value
       where id_suddivisione = p_id_suddivisione;
   end set_des_abb_al1; -- suddivisioni_fisiche_tpk.set_des_abb_al1
   --------------------------------------------------------------------------------
   procedure set_des_abb_al2
   (
      p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type
     ,p_value           in suddivisioni_fisiche.des_abb_al2%type default null
   ) is
      /******************************************************************************
       NOME:        set_des_abb_al2
       DESCRIZIONE: Setter per attributo des_abb_al2 di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => p_id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.set_des_abb_al2');
      update suddivisioni_fisiche
         set des_abb_al2 = p_value
       where id_suddivisione = p_id_suddivisione;
   end set_des_abb_al2; -- suddivisioni_fisiche_tpk.set_des_abb_al2
   --------------------------------------------------------------------------------
   procedure set_icona_standard
   (
      p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type
     ,p_value           in suddivisioni_fisiche.icona_standard%type default null
   ) is
      /******************************************************************************
       NOME:        set_icona_standard
       DESCRIZIONE: Setter per attributo icona_standard di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => p_id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.set_icona_standard');
      update suddivisioni_fisiche
         set icona_standard = p_value
       where id_suddivisione = p_id_suddivisione;
   end set_icona_standard; -- suddivisioni_fisiche_tpk.set_icona_standard
   --------------------------------------------------------------------------------
   procedure set_blob_icona_standard
   (
      p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type
     ,p_value           in suddivisioni_fisiche.blob_icona_standard%type default null
   ) is
      /******************************************************************************
       NOME:        set_blob_icona_standard
       DESCRIZIONE: Setter per attributo blob_icona_standard di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => p_id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.set_blob_icona_standard');
      update suddivisioni_fisiche
         set blob_icona_standard = p_value
       where id_suddivisione = p_id_suddivisione;
   end set_blob_icona_standard; -- suddivisioni_fisiche_tpk.set_blob_icona_standard
   --------------------------------------------------------------------------------
   procedure set_nota
   (
      p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type
     ,p_value           in suddivisioni_fisiche.nota%type default null
   ) is
      /******************************************************************************
       NOME:        set_nota
       DESCRIZIONE: Setter per attributo nota di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => p_id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.set_nota');
      update suddivisioni_fisiche
         set nota = p_value
       where id_suddivisione = p_id_suddivisione;
   end set_nota; -- suddivisioni_fisiche_tpk.set_nota
   --------------------------------------------------------------------------------
   procedure set_utente_aggiornamento
   (
      p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type
     ,p_value           in suddivisioni_fisiche.utente_aggiornamento%type default null
   ) is
      /******************************************************************************
       NOME:        set_utente_aggiornamento
       DESCRIZIONE: Setter per attributo utente_aggiornamento di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => p_id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.set_utente_aggiornamento');
      update suddivisioni_fisiche
         set utente_aggiornamento = p_value
       where id_suddivisione = p_id_suddivisione;
   end set_utente_aggiornamento; -- suddivisioni_fisiche_tpk.set_utente_aggiornamento
   --------------------------------------------------------------------------------
   procedure set_data_aggiornamento
   (
      p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type
     ,p_value           in suddivisioni_fisiche.data_aggiornamento%type default null
   ) is
      /******************************************************************************
       NOME:        set_data_aggiornamento
       DESCRIZIONE: Setter per attributo data_aggiornamento di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => p_id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.set_data_aggiornamento');
      update suddivisioni_fisiche
         set data_aggiornamento = p_value
       where id_suddivisione = p_id_suddivisione;
   end set_data_aggiornamento; -- suddivisioni_fisiche_tpk.set_data_aggiornamento
   --------------------------------------------------------------------------------
   procedure set_assegnabile
   (
      p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type
     ,p_value           in suddivisioni_fisiche.assegnabile%type default null
   ) is
      /******************************************************************************
       NOME:        set_assegnabile
       DESCRIZIONE: Setter per attributo assegnabile di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => p_id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.set_assegnabile');
      update suddivisioni_fisiche
         set assegnabile = p_value
       where id_suddivisione = p_id_suddivisione;
   end set_assegnabile; -- suddivisioni_fisiche_tpk.set_assegnabile
   --------------------------------------------------------------------------------
   procedure set_ordinamento
   (
      p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type
     ,p_value           in suddivisioni_fisiche.ordinamento%type default null
   ) is
      /******************************************************************************
       NOME:        set_ordinamento
       DESCRIZIONE: Setter per attributo ordinamento di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or existsid(p_id_suddivisione => p_id_suddivisione)
             ,'existsId on suddivisioni_fisiche_tpk.set_ordinamento');
      update suddivisioni_fisiche
         set ordinamento = p_value
       where id_suddivisione = p_id_suddivisione;
   end set_ordinamento; -- suddivisioni_fisiche_tpk.set_ordinamento
   --------------------------------------------------------------------------------
   function where_condition /* SLAVE_COPY */
   (
      p_qbe                  in number default 0
     ,p_other_condition      in varchar2 default null
     ,p_id_suddivisione      in varchar2 default null
     ,p_amministrazione      in varchar2 default null
     ,p_suddivisione         in varchar2 default null
     ,p_denominazione        in varchar2 default null
     ,p_denominazione_al1    in varchar2 default null
     ,p_denominazione_al2    in varchar2 default null
     ,p_des_abb              in varchar2 default null
     ,p_des_abb_al1          in varchar2 default null
     ,p_des_abb_al2          in varchar2 default null
     ,p_icona_standard       in varchar2 default null
     ,p_nota                 in varchar2 default null
     ,p_utente_aggiornamento in varchar2 default null
     ,p_data_aggiornamento   in varchar2 default null
     ,p_assegnabile          in varchar2 default null
     ,p_ordinamento          in varchar2 default null
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
                     afc.get_field_condition(' and ( id_suddivisione '
                                            ,p_id_suddivisione
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( amministrazione '
                                            ,p_amministrazione
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( suddivisione '
                                            ,p_suddivisione
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( denominazione '
                                            ,p_denominazione
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( denominazione_al1 '
                                            ,p_denominazione_al1
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( denominazione_al2 '
                                            ,p_denominazione_al2
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( des_abb '
                                            ,p_des_abb
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( des_abb_al1 '
                                            ,p_des_abb_al1
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( des_abb_al2 '
                                            ,p_des_abb_al2
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( icona_standard '
                                            ,p_icona_standard
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( nota ', p_nota, ' )', p_qbe, null) ||
                     afc.get_field_condition(' and ( utente_aggiornamento '
                                            ,p_utente_aggiornamento
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( data_aggiornamento '
                                            ,p_data_aggiornamento
                                            ,' )'
                                            ,p_qbe
                                            ,afc.date_format) ||
                     afc.get_field_condition(' and ( assegnabile '
                                            ,p_assegnabile
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( ordinamento '
                                            ,p_ordinamento
                                            ,' )'
                                            ,p_qbe
                                            ,null) || ' ) ' || p_other_condition;
      return d_statement;
   end where_condition; --- suddivisioni_fisiche_tpk.where_condition
   --------------------------------------------------------------------------------
   function get_rows
   (
      p_qbe                  in number default 0
     ,p_other_condition      in varchar2 default null
     ,p_order_by             in varchar2 default null
     ,p_extra_columns        in varchar2 default null
     ,p_extra_condition      in varchar2 default null
     ,p_id_suddivisione      in varchar2 default null
     ,p_amministrazione      in varchar2 default null
     ,p_suddivisione         in varchar2 default null
     ,p_denominazione        in varchar2 default null
     ,p_denominazione_al1    in varchar2 default null
     ,p_denominazione_al2    in varchar2 default null
     ,p_des_abb              in varchar2 default null
     ,p_des_abb_al1          in varchar2 default null
     ,p_des_abb_al2          in varchar2 default null
     ,p_icona_standard       in varchar2 default null
     ,p_nota                 in varchar2 default null
     ,p_utente_aggiornamento in varchar2 default null
     ,p_data_aggiornamento   in varchar2 default null
     ,p_assegnabile          in varchar2 default null
     ,p_ordinamento          in varchar2 default null
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
      d_statement  := ' select SUDDIVISIONI_FISICHE.* ' ||
                      afc.decode_value(p_extra_columns
                                      ,null
                                      ,null
                                      ,' , ' || p_extra_columns) ||
                      ' from SUDDIVISIONI_FISICHE ' ||
                      where_condition(p_qbe                  => p_qbe
                                     ,p_other_condition      => p_other_condition
                                     ,p_id_suddivisione      => p_id_suddivisione
                                     ,p_amministrazione      => p_amministrazione
                                     ,p_suddivisione         => p_suddivisione
                                     ,p_denominazione        => p_denominazione
                                     ,p_denominazione_al1    => p_denominazione_al1
                                     ,p_denominazione_al2    => p_denominazione_al2
                                     ,p_des_abb              => p_des_abb
                                     ,p_des_abb_al1          => p_des_abb_al1
                                     ,p_des_abb_al2          => p_des_abb_al2
                                     ,p_icona_standard       => p_icona_standard
                                     ,p_nota                 => p_nota
                                     ,p_utente_aggiornamento => p_utente_aggiornamento
                                     ,p_data_aggiornamento   => p_data_aggiornamento
                                     ,p_assegnabile          => p_assegnabile
                                     ,p_ordinamento          => p_ordinamento) || ' ' ||
                      p_extra_condition ||
                      afc.decode_value(p_order_by, null, null, ' order by ' || p_order_by);
      d_ref_cursor := afc_dml.get_ref_cursor(d_statement);
      return d_ref_cursor;
   end get_rows; -- suddivisioni_fisiche_tpk.get_rows
   --------------------------------------------------------------------------------
   function count_rows
   (
      p_qbe                  in number default 0
     ,p_other_condition      in varchar2 default null
     ,p_id_suddivisione      in varchar2 default null
     ,p_amministrazione      in varchar2 default null
     ,p_suddivisione         in varchar2 default null
     ,p_denominazione        in varchar2 default null
     ,p_denominazione_al1    in varchar2 default null
     ,p_denominazione_al2    in varchar2 default null
     ,p_des_abb              in varchar2 default null
     ,p_des_abb_al1          in varchar2 default null
     ,p_des_abb_al2          in varchar2 default null
     ,p_icona_standard       in varchar2 default null
     ,p_nota                 in varchar2 default null
     ,p_utente_aggiornamento in varchar2 default null
     ,p_data_aggiornamento   in varchar2 default null
     ,p_assegnabile          in varchar2 default null
     ,p_ordinamento          in varchar2 default null
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
      d_statement := ' select count( * ) from SUDDIVISIONI_FISICHE ' ||
                     where_condition(p_qbe                  => p_qbe
                                    ,p_other_condition      => p_other_condition
                                    ,p_id_suddivisione      => p_id_suddivisione
                                    ,p_amministrazione      => p_amministrazione
                                    ,p_suddivisione         => p_suddivisione
                                    ,p_denominazione        => p_denominazione
                                    ,p_denominazione_al1    => p_denominazione_al1
                                    ,p_denominazione_al2    => p_denominazione_al2
                                    ,p_des_abb              => p_des_abb
                                    ,p_des_abb_al1          => p_des_abb_al1
                                    ,p_des_abb_al2          => p_des_abb_al2
                                    ,p_icona_standard       => p_icona_standard
                                    ,p_nota                 => p_nota
                                    ,p_utente_aggiornamento => p_utente_aggiornamento
                                    ,p_data_aggiornamento   => p_data_aggiornamento
                                    ,p_assegnabile          => p_assegnabile
                                    ,p_ordinamento          => p_ordinamento);
      d_result    := afc.sql_execute(d_statement);
      return d_result;
   end count_rows; -- suddivisioni_fisiche_tpk.count_rows
--------------------------------------------------------------------------------

end suddivisioni_fisiche_tpk;
/

