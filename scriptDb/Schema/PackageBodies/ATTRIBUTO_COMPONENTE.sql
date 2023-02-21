CREATE OR REPLACE package body attributo_componente is
   /******************************************************************************
    NOME:        attributo_componente
    DESCRIZIONE: Gestione tabella attributi_componente.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore      Descrizione.
    000   18/09/2006  VDAVALLI    Prima emissione.
    001   03/09/2009  VDAVALLI    Modifiche per configurazione master/slave.
    002   07/09/2009  VDAVALLI    Nuovo campo tipo_assegnazione
    003   29/04/2010  APASSUELLO  Modifica per aggiunta di controlli sulla congruenza delle revisioni
    004   05/07/2010  APASSUELLO  Modifiche per gestione del campo Voto
    005   16/08/2011  MMONARI     Att.45288
    006   07/11/2011  MMONARI     Dati storici
    007   02/07/2011  MMONARI     Consolidamento rel. 1.4.1
    008   08/07/2011  MMONARI     Redmine feature #120
    009   29/01/2013  MMONARI     Redmine Bug#148
    010   19/03/2013  VDAVALLI    Aggiunta  get_tipo_ass_corrente per determinare icona Bug#214
    011   22/03/2013  ADADAMO     Aggiunto controllo su congruenza assegnazione_prevalente Bug#184
    012   22/03/2013  MMONARI     Aggiunto controllo su s_attivazione is is_di_ok Bug#159
    013   03/06/2013  ADADAMO     Integrato controllo is_ass_prev_compatibile Bug#268
    014   05/08/2013  ADADAMO     Modificata get_assegnazione _valida per gestire i
                                  codici 12, 13, ecc. Bug#297
    015   13/12/2013  AD/MM       Corretta esiste_componente Bug#345
    016   23/01/2014  MM          Corretta set_periodo_precedente Bug#367
    017   11/02/2014  MMONARI     Aggiunto nuovo parametro a DUPLICA_ATTRIBUTI Bug#380
    018   27/03/2014  ADADAMO     Sostituiti riferimenti al so4gp4 con so4gp_pkg Feature#418 #427
    019   03/04/2014  VDAVALLI    Corretta funzione GET_ASSEGNAZIONE_CORRENTE
                                  per to_date(null) su data AL
    020   15/04/2014  MMONARI     Modificata set_fi #429
    021   16/07/2014  ADADAMO     Modificata chiamata chk_ri e gestito controllo is_last_record
                                  solo su delete dirette su attributi_componente Bug#474
          13/08/2014  ADADAMO     Modificato controllo in chk_ri per consentire inserimento
                                  dell'attributo di default su stessa unità in caso di
                                  inserimento di incarico da GPS. Modifica get_assegnazione_valida
    022   18/08/2014  MMONARI     Modificata duplica_attributi #208
    023   03/09/2014  AD/MM       Modificato controllo in chk_ri per assegnazioni su
                                  stessa unità ma a parita' di tipo_assegnazione, condizionato
                                  controllo su compatibilita' del tipo_assegnazione Bug#427
    024   10/12/2014  MMONARI     Modifiche a chk_ri ed esiste_componente per modifiche di
                                  provenienza GPs #548
          16/01/2015  MMONARI     Modifiche a is_assegnazione_prevalente_ok per #543
    025   20/03/2015  MMONARI     Modifiche a set_periodo_precedente per #575
          04/08/2015  MMONARI     Nuovi controlli sulla chiusura automatica dei periodi precedenti #627
    026   03/09/2015  MMONARI     Corretta gestione date di pubblicazione in attivazione della
                                  revisione #631
          15/09/2015  MMONARI     Corretta gestione date di pubblicazione in attivazione della
                                  revisione #500
    027   10/08/2015  MMONARI     #634, nuovi parametri su set_fi per attribuzione ruoli automatici
          16/10/2015  MMONARI     #644, modifiche in chk_ri
          21/10/2015  MMONARI     #550, modifiche in chk_ri
          22/02/2016  MMONARI     #685, modifiche a set_riapertura_periodo
    028   18/04/2017  MMONARI     #763, inibizione del controllo s_dal_minore per modifiche di provenienza GPs
          09/05/2017  MMONARI     #742, controlli di congruenza tipo_assegnazione/assegnazione_prevalente
   ******************************************************************************/
   s_revisione_body constant afc.t_revision := '028';
   s_error_table    afc_error.t_error_table;
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
   end; -- attributo_componente.versione
   --------------------------------------------------------------------------------
   function pk(p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return t_pk is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        PK
       DESCRIZIONE: Costruttore di un t_PK dati gli attributi della chiave
      ******************************************************************************/
      d_result t_pk;
   begin
      d_result.id_attr_componente := p_id_attr_componente;
      dbc.pre(not dbc.preon or canhandle(d_result.id_attr_componente)
             ,'canHandle on attributo_componente.PK');
      return d_result;
   end; -- end attributo_componente.PK
   --------------------------------------------------------------------------------
   function can_handle(p_id_attr_componente in attributi_componente.id_attr_componente%type)
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
      if d_result = 1 and (p_id_attr_componente is null) then
         d_result := 0;
      end if;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on attributo_componente.can_handle');
      return d_result;
   end; -- attributo_componente.can_handle
   --------------------------------------------------------------------------------
   function canhandle(p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        canHandle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: true se la chiave è manipolabile, false altrimenti.
       NOTE:        Wrapper boolean di can_handle (cfr. can_handle).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(can_handle(p_id_attr_componente));
   begin
      return d_result;
   end; -- attributo_componente.canHandle
   --------------------------------------------------------------------------------
   function exists_id(p_id_attr_componente in attributi_componente.id_attr_componente%type)
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
      dbc.pre(not dbc.preon or canhandle(p_id_attr_componente)
             ,'canHandle on attributo_componente.exists_id');
      begin
         select 1
           into d_result
           from attributi_componente
          where id_attr_componente = p_id_attr_componente;
      exception
         when no_data_found then
            d_result := 0;
      end;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on attributo_componente.exists_id');
      return d_result;
   end; -- attributo_componente.exists_id
   --------------------------------------------------------------------------------
   function existsid(p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        existsId
       DESCRIZIONE: Esistenza riga con chiave indicata.
       NOTE:        Wrapper boolean di exists_id (cfr. exists_id).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(exists_id(p_id_attr_componente));
   begin
      return d_result;
   end; -- attributo_componente.existsId
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
   end; -- attributo_componente.error_message
   --------------------------------------------------------------------------------
   procedure ins
   (
      p_id_attr_componente      in attributi_componente.id_attr_componente%type default null
     ,p_id_componente           in attributi_componente.id_componente%type default null
     ,p_dal                     in attributi_componente.dal%type default null
     ,p_al                      in attributi_componente.al%type default null
     ,p_incarico                in attributi_componente.incarico%type default null
     ,p_telefono                in attributi_componente.telefono%type default null
     ,p_fax                     in attributi_componente.fax%type default null
     ,p_e_mail                  in attributi_componente.e_mail%type default null
     ,p_assegnazione_prevalente in attributi_componente.assegnazione_prevalente%type default null
     ,p_tipo_assegnazione       in attributi_componente.tipo_assegnazione%type default null
     ,p_percentuale_impiego     in attributi_componente.percentuale_impiego%type default null
     ,p_ottica                  in attributi_componente.ottica%type default null
     ,p_revisione_assegnazione  in attributi_componente.revisione_assegnazione%type default null
     ,p_revisione_cessazione    in attributi_componente.revisione_cessazione%type default null
     ,p_gradazione              in attributi_componente.gradazione% type default null
     ,p_utente_aggiornamento    in attributi_componente.utente_aggiornamento%type default null
     ,p_data_aggiornamento      in attributi_componente.data_aggiornamento%type default null
     ,p_voto                    in attributi_componente.voto%type default null
     ,p_dal_pubb                in attributi_componente.dal_pubb%type default null
     ,p_al_pubb                 in attributi_componente.al_pubb%type default null
   ) is
      /******************************************************************************
       NOME:        ins
       DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
       PARAMETRI:   Chiavi e attributi della table.
      ******************************************************************************/
   begin
      -- Check Mandatory on Insert
      dbc.pre(not dbc.preon or p_id_componente is not null or /*default value*/
              'default null' is not null
             ,'p_id_componente on attributo_componente.ins');
      dbc.pre(not dbc.preon or p_dal is not null or /*default value*/
              'default null' is not null
             ,'p_dal on attributo_componente.ins');
      dbc.pre(not dbc.preon or p_al is not null or /*default value*/
              'default null' is not null
             ,'p_al on attributo_componente.ins');
      dbc.pre(not dbc.preon or p_incarico is not null or /*default value*/
              'default null' is not null
             ,'p_incarico on attributo_componente.ins');
      dbc.pre(not dbc.preon or p_telefono is not null or /*default value*/
              'default null' is not null
             ,'p_telefono on attributo_componente.ins');
      dbc.pre(not dbc.preon or p_fax is not null or /*default value*/
              'default null' is not null
             ,'p_fax on attributo_componente.ins');
      dbc.pre(not dbc.preon or p_e_mail is not null or /*default value*/
              'default null' is not null
             ,'p_e_mail on attributo_componente.ins');
      dbc.pre(not dbc.preon or p_assegnazione_prevalente is not null or /*default value*/
              '<Attribute insert default value>' is not null
             ,'p_assegnazione_prevalente on attributo_componente.ins');
      dbc.pre(not dbc.preon or p_tipo_assegnazione is not null or /*default value*/
              '<Attribute insert default value>' is not null
             ,'p_tipo_assegnazione on attributo_componente.ins');
      dbc.pre(not dbc.preon or p_percentuale_impiego is not null or /*default value*/
              '<Attribute insert default value>' is not null
             ,'p_percentuale_impiego on attributo_componente.ins');
      dbc.pre(not dbc.preon or p_ottica is not null or /*default value*/
              '<Attribute insert default value>' is not null
             ,'p_ottica on attributo_componente.ins');
      dbc.pre(not dbc.preon or p_revisione_assegnazione is not null or /*default value*/
              '<Attribute insert default value>' is not null
             ,'p_revisione_assegnazione on attributo_componente.ins');
      dbc.pre(not dbc.preon or p_revisione_cessazione is not null or /*default value*/
              '<Attribute insert default value>' is not null
             ,'p_revisione_cessazione on attributo_componente.ins');
      dbc.pre(not dbc.preon or p_gradazione is not null or /*default value*/
              '<Attribute insert default value>' is not null
             ,'p_gradazione on attributo_componente.ins');
      dbc.pre(not dbc.preon or p_utente_aggiornamento is not null or /*default value*/
              '<Attribute insert default value>' is not null
             ,'p_utente_aggiornamento on attributo_componente.ins');
      dbc.pre(not dbc.preon or p_data_aggiornamento is not null or /*default value*/
              '<Attribute insert default value>' is not null
             ,'p_data_aggiornamento on attributo_componente.ins');
      dbc.pre(not dbc.preon or p_voto is not null or /*default value*/
              '<Attribute insert default value>' is not null
             ,'p_voto on attributo_componente.ins');
      dbc.pre(not dbc.preon or (p_id_attr_componente is null and /*default value*/
              'default null' is not null) -- PK nullable on insert
              or not existsid(p_id_attr_componente)
             ,'not existsId on attributo_componente.ins');
      dbc.pre(not dbc.preon or p_dal_pubb is not null or /*default value*/
              'default null' is not null
             ,'p_dal_pubb on attributo_componente.ins');
      dbc.pre(not dbc.preon or p_al_pubb is not null or /*default value*/
              'default null' is not null
             ,'p_al_pubb on attributo_componente.ins');
      /*      dbc.pre(not dbc.preon or p_al_prec is not null or \*default value*\
       'default null' is not null
      ,'p_al_prec on attributo_componente.ins');*/
      --dbms_output.put_line('inserisco attributo con incarico '||p_incarico);
      insert into attributi_componente
         (id_attr_componente
         ,id_componente
         ,dal
         ,al
         ,incarico
         ,telefono
         ,fax
         ,e_mail
         ,assegnazione_prevalente
         ,tipo_assegnazione
         ,percentuale_impiego
         ,ottica
         ,revisione_assegnazione
         ,revisione_cessazione
         ,gradazione
         ,utente_aggiornamento
         ,data_aggiornamento
         ,voto
         ,dal_pubb
         ,al_pubb
          --         ,al_prec
          )
      values
         (p_id_attr_componente
         ,p_id_componente
         ,p_dal
         ,p_al
         ,p_incarico
         ,p_telefono
         ,p_fax
         ,p_e_mail
         ,p_assegnazione_prevalente
         ,p_tipo_assegnazione
         ,p_percentuale_impiego
         ,p_ottica
         ,p_revisione_assegnazione
         ,p_revisione_cessazione
         ,p_gradazione
         ,p_utente_aggiornamento
         ,p_data_aggiornamento
         ,p_voto
         ,p_dal_pubb
         ,p_al_pubb
          --         ,p_al_prec
          );
   end; -- attributo_componente.ins
   --------------------------------------------------------------------------------
   procedure upd
   (
      p_new_id_attr_componente in attributi_componente.id_attr_componente%type
     ,p_new_id_componente      in attributi_componente.id_componente%type
     ,p_new_dal                in attributi_componente.dal%type
     ,p_new_al                 in attributi_componente.al%type
     ,p_new_dal_pubb           in attributi_componente.dal_pubb%type
     ,p_new_al_pubb            in attributi_componente.al_pubb%type
      --     ,p_new_al_prec                 in attributi_componente.al_prec%type
     ,p_new_incarico                in attributi_componente.incarico%type
     ,p_new_telefono                in attributi_componente.telefono%type
     ,p_new_fax                     in attributi_componente.fax%type
     ,p_new_e_mail                  in attributi_componente.e_mail%type
     ,p_new_assegnazione_prevalente in attributi_componente.assegnazione_prevalente%type
     ,p_new_tipo_assegnazione       in attributi_componente.tipo_assegnazione%type
     ,p_new_percentuale_impiego     in attributi_componente.percentuale_impiego%type
     ,p_new_ottica                  in attributi_componente.ottica%type
     ,p_new_revisione_assegnazione  in attributi_componente.revisione_assegnazione%type
     ,p_new_revisione_cessazione    in attributi_componente.revisione_cessazione%type
     ,p_new_gradazione              in attributi_componente.gradazione%type
     ,p_new_utente_aggiornamento    in attributi_componente.utente_aggiornamento%type
     ,p_new_data_aggiornamento      in attributi_componente.data_aggiornamento%type
     ,p_new_voto                    in attributi_componente.voto%type
     ,p_old_id_attr_componente      in attributi_componente.id_attr_componente%type default null
     ,p_old_id_componente           in attributi_componente.id_componente%type default null
     ,p_old_dal                     in attributi_componente.dal%type default null
     ,p_old_al                      in attributi_componente.al%type default null
     ,p_old_dal_pubb                in attributi_componente.dal_pubb%type default null
     ,p_old_al_pubb                 in attributi_componente.al_pubb%type default null
      --     ,p_old_al_prec                 in attributi_componente.al_prec%type default null
     ,p_old_incarico                in attributi_componente.incarico%type default null
     ,p_old_telefono                in attributi_componente.telefono%type default null
     ,p_old_fax                     in attributi_componente.fax%type default null
     ,p_old_e_mail                  in attributi_componente.e_mail%type default null
     ,p_old_assegnazione_prevalente in attributi_componente.assegnazione_prevalente%type default null
     ,p_old_tipo_assegnazione       in attributi_componente.tipo_assegnazione%type default null
     ,p_old_percentuale_impiego     in attributi_componente.percentuale_impiego%type default null
     ,p_old_ottica                  in attributi_componente.ottica%type default null
     ,p_old_revisione_assegnazione  in attributi_componente.revisione_assegnazione%type default null
     ,p_old_revisione_cessazione    in attributi_componente.revisione_cessazione%type default null
     ,p_old_gradazione              in attributi_componente.gradazione%type default null
     ,p_old_utente_aggiornamento    in attributi_componente.utente_aggiornamento%type default null
     ,p_old_data_aggiornamento      in attributi_componente.data_aggiornamento%type default null
     ,p_old_voto                    in attributi_componente.voto%type default null
     ,p_check_old                   in integer default 0
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
               ((p_old_id_componente is not null or p_old_dal is not null or
               p_old_al is not null or p_old_dal_pubb is not null or
               p_old_al_pubb is not null or
               --               p_old_al_prec is not null or
               p_old_incarico is not null or p_old_telefono is not null or
               p_old_fax is not null or p_old_e_mail is not null or
               p_old_assegnazione_prevalente is not null or
               p_old_tipo_assegnazione is not null or
               p_old_percentuale_impiego is not null or p_old_ottica is not null or
               p_old_revisione_assegnazione is not null or
               p_old_revisione_cessazione is not null or p_old_gradazione is not null or
               p_old_utente_aggiornamento is not null or
               p_old_data_aggiornamento is not null or p_old_voto is not null) and
               p_check_old = 0)
             ,' <OLD values> is not null on attributo_componente.upd');
      dbc.pre(not dbc.preon or p_check_old is not null
             ,'p_check_OLD is not null on attributo_componente.upd');
      d_key := pk(nvl(p_old_id_attr_componente, p_new_id_attr_componente));
      dbc.pre(not dbc.preon or existsid(d_key.id_attr_componente)
             ,'existsId on attributo_componente.upd');
      update attributi_componente
         set id_attr_componente = p_new_id_attr_componente
            ,id_componente      = p_new_id_componente
            ,dal                = p_new_dal
            ,al                 = p_new_al
            ,dal_pubb           = p_new_dal_pubb
            ,al_pubb            = p_new_al_pubb
             --            ,al_prec                 = p_new_al_prec
            ,incarico                = p_new_incarico
            ,telefono                = p_new_telefono
            ,fax                     = p_new_fax
            ,e_mail                  = p_new_e_mail
            ,assegnazione_prevalente = p_new_assegnazione_prevalente
            ,tipo_assegnazione       = p_new_tipo_assegnazione
            ,percentuale_impiego     = p_new_percentuale_impiego
            ,ottica                  = p_new_ottica
            ,revisione_assegnazione  = p_new_revisione_assegnazione
            ,revisione_cessazione    = p_new_revisione_cessazione
            ,gradazione              = p_new_gradazione
            ,utente_aggiornamento    = p_new_utente_aggiornamento
            ,data_aggiornamento      = p_new_data_aggiornamento
            ,voto                    = p_new_voto
       where id_attr_componente = d_key.id_attr_componente
         and (p_check_old = 0 or
             p_check_old = 1 and (id_componente = p_old_id_componente or
             id_componente is null and p_old_id_componente is null) and
             (dal = p_old_dal or dal is null and p_old_dal is null) and
             (al = p_old_al or al is null and p_old_al is null) and
             (dal = p_old_dal_pubb or dal_pubb is null and p_old_dal_pubb is null) and
             (al = p_old_al_pubb or al_pubb is null and p_old_al_pubb is null) and
             --             (al = p_old_al_prec or al_prec is null and p_old_al_prec is null) and
             (incarico = p_old_incarico or incarico is null and p_old_incarico is null) and
             (telefono = p_old_telefono or telefono is null and p_old_telefono is null) and
             (fax = p_old_fax or fax is null and p_old_fax is null) and
             (e_mail = p_old_e_mail or e_mail is null and p_old_e_mail is null) and
             (assegnazione_prevalente = p_old_assegnazione_prevalente or
             assegnazione_prevalente is null and p_old_assegnazione_prevalente is null) and
             (tipo_assegnazione = p_old_tipo_assegnazione or
             tipo_assegnazione is null and p_old_tipo_assegnazione is null) and
             (percentuale_impiego = p_old_percentuale_impiego or
             percentuale_impiego is null and p_old_percentuale_impiego is null) and
             (ottica = p_old_ottica or ottica is null and p_old_ottica is null) and
             (revisione_assegnazione = p_old_revisione_assegnazione or
             revisione_assegnazione is null and p_old_revisione_assegnazione is null) and
             (revisione_cessazione = p_old_revisione_cessazione or
             revisione_cessazione is null and p_old_revisione_cessazione is null) and
             (gradazione = p_old_gradazione or
             gradazione is null and p_old_gradazione is null) and
             (utente_aggiornamento = p_old_utente_aggiornamento or
             utente_aggiornamento is null and p_old_utente_aggiornamento is null) and
             (data_aggiornamento = p_old_data_aggiornamento or
             data_aggiornamento is null and p_old_data_aggiornamento is null) and
             (voto = p_old_voto or voto is null and p_old_voto is null));
      d_row_found := sql%rowcount;
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on attributo_componente.upd');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   end; -- attributo_componente.upd
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_id_attr_componente in attributi_componente.id_attr_componente%type
     ,p_column             in varchar2
     ,p_value              in varchar2 default null
     ,p_literal_value      in number default 1
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
      dbc.pre(not dbc.preon or existsid(p_id_attr_componente)
             ,'existsId on attributo_componente.upd_column');
      dbc.pre(not dbc.preon or p_column is not null
             ,'p_column is not null on attributo_componente.upd_column');
      dbc.pre(not dbc.preon or afc_ddl.hasattribute(s_table_name, p_column)
             ,'AFC_DDL.HasAttribute on attributo_componente.upd_column');
      dbc.pre(p_literal_value in (0, 1)
             ,'p_literal_value in ( 0, 1 ) on attributo_componente.upd_column; p_literal_value = ' ||
              p_literal_value);
      if p_literal_value = 1 then
         d_literal := '''';
      end if;
      d_statement := 'begin ' || '   update attributi_componente' || '   set    ' ||
                     p_column || ' = ' || d_literal || p_value || d_literal ||
                     '   where  id_attr_componente = ''' || p_id_attr_componente || '''' ||
                     '   ;' || 'end;';
      afc.sql_execute(d_statement);
   end; -- attributo_componente.upd_column
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_id_attr_componente in attributi_componente.id_attr_componente%type
     ,p_column             in varchar2
     ,p_value              in date
   ) is
      /******************************************************************************
       NOME:        upd_column
       DESCRIZIONE: Aggiornamento del campo p_column col valore p_value.
       NOTE:        Richiama se stessa con il parametro date convertito in stringa.
      ******************************************************************************/
      d_data varchar2(19);
   begin
      d_data := to_char(p_value, afc.date_format);
      upd_column(p_id_attr_componente
                ,p_column
                ,'to_date( ''' || d_data || ''', ''' || afc.date_format || ''' )'
                ,0);
   end; -- attributo_componente.upd_column
   --------------------------------------------------------------------------------
   procedure del
   (
      p_id_attr_componente      in attributi_componente.id_attr_componente%type
     ,p_id_componente           in attributi_componente.id_componente%type default null
     ,p_dal                     in attributi_componente.dal%type default null
     ,p_al                      in attributi_componente.al%type default null
     ,p_incarico                in attributi_componente.incarico%type default null
     ,p_telefono                in attributi_componente.telefono%type default null
     ,p_fax                     in attributi_componente.fax%type default null
     ,p_e_mail                  in attributi_componente.e_mail%type default null
     ,p_assegnazione_prevalente in attributi_componente.assegnazione_prevalente%type default null
     ,p_tipo_assegnazione       in attributi_componente.tipo_assegnazione%type default null
     ,p_percentuale_impiego     in attributi_componente.percentuale_impiego%type default null
     ,p_ottica                  in attributi_componente.ottica%type default null
     ,p_revisione_assegnazione  in attributi_componente.revisione_assegnazione%type default null
     ,p_revisione_cessazione    in attributi_componente.revisione_cessazione%type default null
     ,p_gradazione              in attributi_componente.gradazione%type default null
     ,p_utente_aggiornamento    in attributi_componente.utente_aggiornamento%type default null
     ,p_data_aggiornamento      in attributi_componente.data_aggiornamento%type default null
     ,p_voto                    in attributi_componente.voto%type default null
     ,p_dal_pubb                in attributi_componente.dal_pubb%type default null
     ,p_al_pubb                 in attributi_componente.al_pubb%type default null
      --     ,p_al_prec                 in attributi_componente.al_prec%type default null
     ,p_check_old in integer default 0
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
               ((p_id_componente is not null or p_dal is not null or p_al is not null or
               p_dal_pubb is not null or p_al_pubb is not null or
               --               p_al_prec is not null or
               p_incarico is not null or p_telefono is not null or p_fax is not null or
               p_e_mail is not null or p_assegnazione_prevalente is not null or
               p_tipo_assegnazione is not null or p_percentuale_impiego is not null or
               p_ottica is not null or p_revisione_assegnazione is not null or
               p_revisione_cessazione is not null or p_gradazione is not null or
               p_utente_aggiornamento is not null or p_data_aggiornamento is not null or
               p_voto is not null) and p_check_old = 0)
             ,' <OLD values> is not null on attributo_componente.del');
      dbc.pre(not dbc.preon or existsid(p_id_attr_componente)
             ,'existsId on attributo_componente.del');
      delete from attributi_componente
       where id_attr_componente = p_id_attr_componente
         and (p_check_old = 0 or
             p_check_old = 1 and (id_componente = p_id_componente or
             id_componente is null and p_id_componente is null) and
             (dal = p_dal or dal is null and p_dal is null) and
             (al = p_al or al is null and p_al is null) and
             (incarico = p_incarico or incarico is null and p_incarico is null) and
             (telefono = p_telefono or telefono is null and p_telefono is null) and
             (fax = p_fax or fax is null and p_fax is null) and
             (e_mail = p_e_mail or e_mail is null and p_e_mail is null) and
             (assegnazione_prevalente = p_assegnazione_prevalente or
             assegnazione_prevalente is null and p_assegnazione_prevalente is null) and
             (tipo_assegnazione = p_tipo_assegnazione or
             tipo_assegnazione is null and p_tipo_assegnazione is null) and
             (percentuale_impiego = p_percentuale_impiego or
             percentuale_impiego is null and p_percentuale_impiego is null) and
             (ottica = p_ottica or ottica is null and p_ottica is null) and
             (revisione_assegnazione = p_revisione_assegnazione or
             revisione_assegnazione is null and p_revisione_assegnazione is null) and
             (revisione_cessazione = p_revisione_cessazione or
             revisione_cessazione is null and p_revisione_cessazione is null) and
             (gradazione = p_gradazione or gradazione is null and gradazione is null) and
             (utente_aggiornamento = p_utente_aggiornamento or
             utente_aggiornamento is null and p_utente_aggiornamento is null) and
             (data_aggiornamento = p_data_aggiornamento or
             data_aggiornamento is null and p_data_aggiornamento is null) and
             (voto = p_voto or voto is null and p_voto is null) and
             (dal = p_dal_pubb or dal_pubb is null and p_dal_pubb is null) and
             (al = p_al_pubb or al_pubb is null and p_al_pubb is null));
      --             and (al_prec = p_al_prec or al_prec is null and p_al_prec is null)
      d_row_found := sql%rowcount;
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on attributo_componente.del');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
      dbc.post(not dbc.poston or not existsid(p_id_attr_componente)
              ,'existsId on attributo_componente.del');
   end; -- attributo_componente.del
   --------------------------------------------------------------------------------
   function get_id_componente(p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.id_componente%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_id_componente
       DESCRIZIONE: Attributo id_componente di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     attributi_componente.id_componente%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result attributi_componente.id_componente%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_attr_componente)
             ,'existsId on attributo_componente.get_id_componente');
      select id_componente
        into d_result
        from attributi_componente
       where id_attr_componente = p_id_attr_componente;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on attributo_componente.get_id_componente');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'id_componente')
                      ,' AFC_DDL.IsNullable on attributo_componente.get_id_componente');
      end if;
      return d_result;
   end; -- attributo_componente.get_id_componente
   --------------------------------------------------------------------------------
   function get_dal(p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.dal%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_dal
       DESCRIZIONE: Attributo dal di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     attributi_componente.dal%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result attributi_componente.dal%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_attr_componente)
             ,'existsId on attributo_componente.get_dal');
      select dal
        into d_result
        from attributi_componente
       where id_attr_componente = p_id_attr_componente;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on attributo_componente.get_dal');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'dal')
                      ,' AFC_DDL.IsNullable on attributo_componente.get_dal');
      end if;
      return d_result;
   end; -- attributo_componente.get_dal
   --------------------------------------------------------------------------------
   function get_al(p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.al%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_al
       DESCRIZIONE: Attributo al di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     attributi_componente.al%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result attributi_componente.al%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_attr_componente)
             ,'existsId on attributo_componente.get_al');
      select al
        into d_result
        from attributi_componente
       where id_attr_componente = p_id_attr_componente;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on attributo_componente.get_al');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'al')
                      ,' AFC_DDL.IsNullable on attributo_componente.get_al');
      end if;
      return d_result;
   end; -- attributo_componente.get_al
   --------------------------------------------------------------------------------
   function get_dal_pubb(p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.dal_pubb%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_dal_pubb
       DESCRIZIONE: Attributo dal_pubb di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     attributi_componente.dal_pubb%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result attributi_componente.dal_pubb%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_attr_componente)
             ,'existsId on attributo_componente.get_dal_pubb');
      select dal_pubb
        into d_result
        from attributi_componente
       where id_attr_componente = p_id_attr_componente;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on attributo_componente.get_dal_pubb');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'dal_pubb')
                      ,' AFC_DDL.IsNullable on attributo_componente.get_dal_pubb');
      end if;
      return d_result;
   end; -- attributo_componente.get_dal_pubb
   --------------------------------------------------------------------------------
   function get_al_pubb(p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.al_pubb%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_al_pubb
       DESCRIZIONE: Attributo al_pubb di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     attributi_componente.al_pubb%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result attributi_componente.al_pubb%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_attr_componente)
             ,'existsId on attributo_componente.get_al_pubb');
      select al_pubb
        into d_result
        from attributi_componente
       where id_attr_componente = p_id_attr_componente;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on attributo_componente.get_al_pubb');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'al_pubb')
                      ,' AFC_DDL.IsNullable on attributo_componente.get_al_pubb');
      end if;
      return d_result;
   end; -- attributo_componente.get_al_pubb
   --------------------------------------------------------------------------------
   function get_al_prec(p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.al_prec%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_al_prec
       DESCRIZIONE: Attributo al_prec di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     attributi_componente.al_prec%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result attributi_componente.al_prec%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_attr_componente)
             ,'existsId on attributo_componente.get_al_prec');
      select al_prec
        into d_result
        from attributi_componente
       where id_attr_componente = p_id_attr_componente;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on attributo_componente.get_al_prec');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'al_prec')
                      ,' AFC_DDL.IsNullable on attributo_componente.get_al_prec');
      end if;
      return d_result;
   end; -- attributo_componente.get_al_prec
   --------------------------------------------------------------------------------
   function get_incarico(p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.incarico%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_incarico
       DESCRIZIONE: Attributo incarico di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     attributi_componente.incarico%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result attributi_componente.incarico%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_attr_componente)
             ,'existsId on attributo_componente.get_incarico');
      select incarico
        into d_result
        from attributi_componente
       where id_attr_componente = p_id_attr_componente;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on attributo_componente.get_incarico');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'incarico')
                      ,' AFC_DDL.IsNullable on attributo_componente.get_incarico');
      end if;
      return d_result;
   end; -- attributo_componente.get_incarico
   --------------------------------------------------------------------------------
   function get_telefono(p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.telefono%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_telefono
       DESCRIZIONE: Attributo telefono di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     attributi_componente.telefono%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result attributi_componente.telefono%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_attr_componente)
             ,'existsId on attributo_componente.get_telefono');
      select telefono
        into d_result
        from attributi_componente
       where id_attr_componente = p_id_attr_componente;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on attributo_componente.get_telefono');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'telefono')
                      ,' AFC_DDL.IsNullable on attributo_componente.get_telefono');
      end if;
      return d_result;
   end; -- attributo_componente.get_telefono
   --------------------------------------------------------------------------------
   function get_fax(p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.fax%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_fax
       DESCRIZIONE: Attributo fax di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     attributi_componente.fax%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result attributi_componente.fax%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_attr_componente)
             ,'existsId on attributo_componente.get_fax');
      select fax
        into d_result
        from attributi_componente
       where id_attr_componente = p_id_attr_componente;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on attributo_componente.get_fax');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'fax')
                      ,' AFC_DDL.IsNullable on attributo_componente.get_fax');
      end if;
      return d_result;
   end; -- attributo_componente.get_fax
   --------------------------------------------------------------------------------
   function get_e_mail(p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.e_mail%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_e_mail
       DESCRIZIONE: Attributo e_mail di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     attributi_componente.e_mail%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result attributi_componente.e_mail%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_attr_componente)
             ,'existsId on attributo_componente.get_e_mail');
      select e_mail
        into d_result
        from attributi_componente
       where id_attr_componente = p_id_attr_componente;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on attributo_componente.get_e_mail');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'e_mail')
                      ,' AFC_DDL.IsNullable on attributo_componente.get_e_mail');
      end if;
      return d_result;
   end; -- attributo_componente.get_e_mail
   --------------------------------------------------------------------------------
   function get_assegnazione_prevalente(p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.assegnazione_prevalente%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_assegnazione_prevalente
       DESCRIZIONE: Attributo assegnazione_prevalente di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     attributi_componente.assegnazione_prevalente%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result attributi_componente.assegnazione_prevalente%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_attr_componente)
             ,'existsId on attributo_componente.get_assegnazione_prevalente');
      select assegnazione_prevalente
        into d_result
        from attributi_componente
       where id_attr_componente = p_id_attr_componente;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on attributo_componente.get_assegnazione_prevalente');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'assegnazione_prevalente')
                      ,' AFC_DDL.IsNullable on attributo_componente.get_assegnazione_prevalente');
      end if;
      return d_result;
   end; -- attributo_componente.get_assegnazione_prevalente
   --------------------------------------------------------------------------------
   function get_tipo_assegnazione(p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.tipo_assegnazione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_tipo_assegnazione
       DESCRIZIONE: Attributo tipo_assegnazione di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     attributi_componente.tipo_assegnazione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result attributi_componente.tipo_assegnazione%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_attr_componente)
             ,'existsId on attributo_componente.get_tipo_assegnazione');
      select tipo_assegnazione
        into d_result
        from attributi_componente
       where id_attr_componente = p_id_attr_componente;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on attributo_componente.get_tipo_assegnazione');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'tipo_assegnazione')
                      ,' AFC_DDL.IsNullable on attributo_componente.get_tipo_assegnazione');
      end if;
      return d_result;
   end; -- attributo_componente.get_tipo_assegnazione
   --------------------------------------------------------------------------------
   function get_percentuale_impiego(p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.percentuale_impiego%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_percentuale_impiego
       DESCRIZIONE: Attributo percentuale_impiego di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     attributi_componente.percentuale_impiego%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result attributi_componente.percentuale_impiego%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_attr_componente)
             ,'existsId on attributo_componente.get_percentuale_impiego');
      select percentuale_impiego
        into d_result
        from attributi_componente
       where id_attr_componente = p_id_attr_componente;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on attributo_componente.get_percentuale_impiego');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'percentuale_impiego')
                      ,' AFC_DDL.IsNullable on attributo_componente.get_percentuale_impiego');
      end if;
      return d_result;
   end; -- attributo_componente.get_percentuale_impiego
   --------------------------------------------------------------------------------
   function get_gradazione(p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.gradazione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_gradazione
       DESCRIZIONE: Attributo gradazione di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     attributi_componente.gradazione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result attributi_componente.gradazione%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_attr_componente)
             ,'existsId on attributo_componente.get_percentuale_impiego');
      select gradazione
        into d_result
        from attributi_componente
       where id_attr_componente = p_id_attr_componente;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on attributo_componente.get_gradazione');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'gradazione')
                      ,' AFC_DDL.IsNullable on attributo_componente.get_gradazione');
      end if;
      return d_result;
   end; -- attributo_componente.get_gradazione
   --------------------------------------------------------------------------------
   function get_voto(p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.voto%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_voto
       DESCRIZIONE: Restituisce il voto associato all'incarico
       PARAMETRI:   Id_attr_componente
       RITORNA:     attributi_componente.voto%type.
       NOTE:
      ******************************************************************************/
      d_result attributi_componente.voto%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_attr_componente)
             ,'existsId on attributo_componente.get_voto');
      select voto
        into d_result
        from attributi_componente
       where id_attr_componente = p_id_attr_componente;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on attributo_componente.get_voto');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'voto')
                      ,' AFC_DDL.IsNullable on attributo_componente.get_voto');
      end if;
      return d_result;
   end; --attributo_componente.get_voto
   --------------------------------------------------------------------------------
   function get_utente_aggiornamento(p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.utente_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_utente_aggiornamento
       DESCRIZIONE: Restituisce l'utente aggiornamento associato all'incarico
       PARAMETRI:   Id_attr_componente
       RITORNA:     attributi_componente.utente_aggiornamento%type.
       NOTE:
      ******************************************************************************/
      d_result attributi_componente.utente_aggiornamento%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_attr_componente)
             ,'existsId on attributo_componente.get_utente_aggiornamento');
      select utente_aggiornamento
        into d_result
        from attributi_componente
       where id_attr_componente = p_id_attr_componente;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on attributo_componente.get_utente_aggiornamento');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'utente_aggiornamento')
                      ,' AFC_DDL.IsNullable on attributo_componente.get_utente_aggiornamento');
      end if;
      return d_result;
   end; --attributo_componente.get_utente_aggiornamento
   --------------------------------------------------------------------------------
   function get_data_aggiornamento(p_id_attr_componente in attributi_componente.id_attr_componente%type)
      return attributi_componente.data_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_data_aggiornamento
       DESCRIZIONE: Restituisce la data aggiornamento associato all'incarico
       PARAMETRI:   Id_attr_componente
       RITORNA:     attributi_componente.data_aggiornamento%type.
       NOTE:
      ******************************************************************************/
      d_result attributi_componente.data_aggiornamento%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_attr_componente)
             ,'existsId on attributo_componente.get_data_aggiornamento');
      select data_aggiornamento
        into d_result
        from attributi_componente
       where id_attr_componente = p_id_attr_componente;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on attributo_componente.get_data_aggiornamento');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'utente_aggiornamento')
                      ,' AFC_DDL.IsNullable on attributo_componente.get_data_aggiornamento');
      end if;
      return d_result;
   end; --attributo_componente.get_data_aggiornamento
   --------------------------------------------------------------------------------
   function get_id_attr_componente
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_dal           in attributi_componente.dal%type
   ) return attributi_componente.id_attr_componente%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_id_attr_componente
       DESCRIZIONE: Attributo id_attr_componente di riga esistente identificata
                    da id_componente e dal.
       PARAMETRI:   Id_componente
                    Dal
       RITORNA:     attributi_componente.id_attr_componente%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result attributi_componente.id_attr_componente%type;
   begin
      select id_attr_componente
        into d_result
        from attributi_componente
       where id_componente = p_id_componente
         and nvl(dal, to_date('2222222', 'j')) = nvl(p_dal, to_date('2222222', 'j'));
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on attributo_componente.get_id_attr_componente');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'id_componente')
                      ,' AFC_DDL.IsNullable on attributo_componente.get_id_attr_componente');
      end if;
      return d_result;
   end; -- attributo_componente.get_id_attr_componente
   --------------------------------------------------------------------------------
   function get_id_corrente
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_data          in attributi_componente.dal%type
     ,p_ottica        in attributi_componente.ottica%type
   ) return attributi_componente.id_attr_componente%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_id_corrente
       DESCRIZIONE: Attributo id_attr_componente di riga esistente identificata
                    da id_componente e valido alla data indicata considerando
                    anche la revisione in modifica
       PARAMETRI:   Id_componente
                    Dal
       RITORNA:     attributi_componente.id_attr_componente%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result        attributi_componente.id_attr_componente%type;
      d_revisione_mod attributi_componente.revisione_assegnazione%type;
   begin
      d_revisione_mod := revisione_struttura.get_revisione_mod(p_ottica => p_ottica);
      select max(id_attr_componente)
        into d_result
        from attributi_componente
       where id_componente = p_id_componente
         and p_data between nvl(dal, p_data) and
             nvl(decode(revisione_cessazione, d_revisione_mod, to_date(null), al)
                ,to_date('3333333', 'j'));
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on attributo_componente.get_id_attr_componente');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'id_componente')
                      ,' AFC_DDL.IsNullable on attributo_componente.get_id_attr_componente');
      end if;
      return d_result;
   end; -- attributo_componente.get_id_corrente
   --------------------------------------------------------------------------------
   function get_incarico_corrente
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_data          in attributi_componente.dal%type
     ,p_ottica        in attributi_componente.ottica%type
   ) return attributi_componente.incarico%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_incarico_corrente
       DESCRIZIONE: Restituisce l'incarico valido alla data indicata
       PARAMETRI:   Id_componente
                    Dal
                    Ottica
       RITORNA:     attributi_componente.incarico%type.
       NOTE:
      ******************************************************************************/
      d_result  attributi_componente.incarico%type;
      d_atco_id attributi_componente.id_attr_componente%type;
   begin
      d_atco_id := attributo_componente.get_id_corrente(p_id_componente, p_data, p_ottica);
      d_result  := attributo_componente.get_incarico(d_atco_id);
      --
      return d_result;
   end; -- attributo_componente.get_id_attr_componente
   --------------------------------------------------------------------------------
   function get_assegnazione_corrente
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_data          in attributi_componente.dal%type
     ,p_ottica        in attributi_componente.ottica%type
   ) return attributi_componente.assegnazione_prevalente%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_assegnazione_corrente
       DESCRIZIONE: Restituisce l'assegnazione prevalente valida alla data indicata
       PARAMETRI:   Id_componente
                    Dal
                    Ottica
       RITORNA:     attributi_componente.assegnazione_prevalente%type.
       NOTE:
      ******************************************************************************/
      d_result        attributi_componente.assegnazione_prevalente%type;
      d_revisione_mod attributi_componente.revisione_assegnazione%type;
   begin
      d_revisione_mod := revisione_struttura.get_revisione_mod(p_ottica => p_ottica);
      begin
         select min(assegnazione_prevalente)
           into d_result
           from attributi_componente
          where id_componente = p_id_componente
            and p_data between nvl(dal, p_data) and
                nvl(decode(revisione_cessazione, d_revisione_mod, to_date(null), al)
                   ,to_date('3333333', 'j'));
      exception
         when no_data_found then
            d_result := null;
      end;
      --
      return d_result;
   end; -- attributo_componente.get_assegnazione_corrente
   --------------------------------------------------------------------------------
   function get_gradazione_corrente
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_data          in attributi_componente.dal%type
     ,p_ottica        in attributi_componente.ottica%type
   ) return attributi_componente.gradazione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_gradazione_corrente
       DESCRIZIONE: Restituisce la gradazione valida alla data indicata
       PARAMETRI:   Id_componente
                    Dal
                    Ottica
       RITORNA:     attributi_componente.gradazione%type.
       NOTE:
      ******************************************************************************/
      d_result      attributi_componente.gradazione%type;
      d_id_corrente attributi_componente.id_attr_componente%type;
   begin
      d_id_corrente := attributo_componente.get_id_corrente(p_id_componente
                                                           ,p_data
                                                           ,p_ottica);
      d_result      := attributo_componente.get_gradazione(d_id_corrente);
      return d_result;
   end;
   --------------------------------------------------------------------------------
   function get_tipo_ass_corrente
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_data          in attributi_componente.dal%type
     ,p_ottica        in attributi_componente.ottica%type
   ) return attributi_componente.tipo_assegnazione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_tipo_ass_corrente
       DESCRIZIONE: Restituisce il tipo assegnazione valido alla data indicata
       PARAMETRI:   Id_componente
                    Dal
                    Ottica
       RITORNA:     attributi_componente.tipo_assegnazione%type.
       NOTE:
      ******************************************************************************/
      d_result      attributi_componente.tipo_assegnazione%type;
      d_id_corrente attributi_componente.id_attr_componente%type;
   begin
      d_id_corrente := attributo_componente.get_id_corrente(p_id_componente
                                                           ,p_data
                                                           ,p_ottica);
      d_result      := attributo_componente.get_tipo_assegnazione(d_id_corrente);
      return d_result;
   end; --------------------------------------------------------------------------------
   function get_id_valido
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_data          in attributi_componente.dal%type
     ,p_ottica        in attributi_componente.ottica%type
   ) return attributi_componente.id_attr_componente%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_id_valido
       DESCRIZIONE: Attributo id_attr_componente di riga esistente identificata
                    da id_componente e valido alla data indicata senza considerare
                    la revisione in modifica
       PARAMETRI:   Id_componente
                    Dal
       RITORNA:     attributi_componente.id_attr_componente%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result        attributi_componente.id_attr_componente%type;
      d_revisione_mod attributi_componente.revisione_assegnazione%type;
   begin
      d_revisione_mod := revisione_struttura.get_revisione_mod(p_ottica => p_ottica);
      select id_attr_componente
        into d_result
        from attributi_componente
       where id_componente = p_id_componente
         and nvl(revisione_assegnazione, -2) != d_revisione_mod
         and p_data between dal and
             nvl(decode(nvl(revisione_cessazione, -2), d_revisione_mod, to_date(null), al)
                ,to_date('3333333', 'j'));
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on attributo_componente.get_id_attr_componente');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'id_componente')
                      ,' AFC_DDL.IsNullable on attributo_componente.get_id_attr_componente');
      end if;
      return d_result;
   end; -- attributo_componente.get_id_valido
   --------------------------------------------------------------------------------
   function get_incarico_valido
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_data          in attributi_componente.dal%type
     ,p_ottica        in attributi_componente.ottica%type
   ) return attributi_componente.incarico%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_incarico_valido
       DESCRIZIONE: Restituisce l'assegnazione valida alla data indicata
       PARAMETRI:   Id_componente
                    Dal
                    Ottica
       RITORNA:     attributi_componente.incarico%type.
       NOTE:
      ******************************************************************************/
      d_result    attributi_componente.incarico%type;
      d_id_valido attributi_componente.id_attr_componente%type;
   begin
      d_id_valido := attributo_componente.get_id_valido(p_id_componente, p_data, p_ottica);
      d_result    := attributo_componente.get_incarico(d_id_valido);
      return d_result;
   end;
   --------------------------------------------------------------------------------
   function get_assegnazione_valida
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_data          in attributi_componente.dal%type
     ,p_ottica        in attributi_componente.ottica%type
   ) return attributi_componente.assegnazione_prevalente%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_assegnazione_valida
       DESCRIZIONE: Restituisce l'assegnazione valida alla data indicata
       PARAMETRI:   Id_componente
                    Dal
                    Ottica
       RITORNA:     attributi_componente.assegnazione_prevalente%type.
       NOTE:
      ******************************************************************************/
      d_result    attributi_componente.assegnazione_prevalente%type;
      d_id_valido attributi_componente.id_attr_componente%type;
   begin
      d_id_valido := attributo_componente.get_id_valido(p_id_componente, p_data, p_ottica);
      -- gestire anche la possibilità che in assegnazione prevalente sia memorizzato il valore 12,13,...
      d_result := attributo_componente.get_assegnazione_prevalente(d_id_valido);
      if d_result != '99' then
         d_result := substr(d_result, 1, 1);
      end if;
      return d_result;
   end;
   --------------------------------------------------------------------------------
   function get_gradazione_valida
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_data          in attributi_componente.dal%type
     ,p_ottica        in attributi_componente.ottica%type
   ) return attributi_componente.gradazione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_gradazione_valida
       DESCRIZIONE: Restituisce la gradazione valida alla data indicata
       PARAMETRI:   Id_componente
                    Dal
                    Ottica
       RITORNA:     attributi_componente.gradazione%type.
       NOTE:
      ******************************************************************************/
      d_result    attributi_componente.gradazione%type;
      d_id_valido attributi_componente.id_attr_componente%type;
   begin
      d_id_valido := attributo_componente.get_id_valido(p_id_componente, p_data, p_ottica);
      d_result    := attributo_componente.get_gradazione(d_id_valido);
      return d_result;
   end;
   --------------------------------------------------------------------------------
   function get_tipo_ass_valido
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_data          in attributi_componente.dal%type
     ,p_ottica        in attributi_componente.ottica%type
   ) return attributi_componente.tipo_assegnazione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_tipo_ass_valido
       DESCRIZIONE: Restituisce il tipo_assegnazione valido alla data indicata
       PARAMETRI:   Id_componente
                    Dal
                    Ottica
       RITORNA:     attributi_componente.tipo_assegnazione%type.
       NOTE:
      ******************************************************************************/
      d_result    attributi_componente.tipo_assegnazione%type;
      d_id_valido attributi_componente.id_attr_componente%type;
   begin
      d_id_valido := attributo_componente.get_id_valido(p_id_componente, p_data, p_ottica);
      d_result    := attributo_componente.get_tipo_assegnazione(d_id_valido);
      return d_result;
   end;
   --------------------------------------------------------------------------------
   function where_condition
   (
      p_id_attr_componente      in varchar2 default null
     ,p_id_componente           in varchar2 default null
     ,p_dal                     in varchar2 default null
     ,p_al                      in varchar2 default null
     ,p_dal_pubb                in varchar2 default null
     ,p_al_pubb                 in varchar2 default null
     ,p_al_prec                 in varchar2 default null
     ,p_incarico                in varchar2 default null
     ,p_telefono                in varchar2 default null
     ,p_fax                     in varchar2 default null
     ,p_e_mail                  in varchar2 default null
     ,p_assegnazione_prevalente in varchar2 default null
     ,p_tipo_assegnazione       in varchar2 default null
     ,p_percentuale_impiego     in varchar2 default null
     ,p_ottica                  in varchar2 default null
     ,p_revisione_assegnazione  in varchar2 default null
     ,p_revisione_cessazione    in varchar2 default null
     ,p_gradazione              in varchar2 default null
     ,p_utente_aggiornamento    in varchar2 default null
     ,p_data_aggiornamento      in varchar2 default null
     ,p_other_condition         in varchar2 default null
     ,p_qbe                     in number default 0
   ) return afc.t_statement is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        where_condition
       DESCRIZIONE: Ritorna la where_condition per lo statement di select di get_rows e count_rows.
       PARAMETRI:   p_other_condition
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
                     afc.get_field_condition(' and ( id_attr_componente '
                                            ,p_id_attr_componente
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( id_componente '
                                            ,p_id_componente
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
                     afc.get_field_condition(' and ( dal_pubb '
                                            ,p_dal_pubb
                                            ,' )'
                                            ,p_qbe
                                            ,afc.date_format) ||
                     afc.get_field_condition(' and ( al_pubb '
                                            ,p_al_pubb
                                            ,' )'
                                            ,p_qbe
                                            ,afc.date_format) ||
                     afc.get_field_condition(' and ( al_prec '
                                            ,p_al_prec
                                            ,' )'
                                            ,p_qbe
                                            ,afc.date_format) ||
                     afc.get_field_condition(' and ( incarico ', p_incarico, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( telefono ', p_telefono, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( fax ', p_fax, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( e_mail ', p_e_mail, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( assegnazione_prevalente '
                                            ,p_assegnazione_prevalente
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( tipo_assegnazione '
                                            ,p_tipo_assegnazione
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( percentuale_impiego '
                                            ,p_percentuale_impiego
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( ottica ', p_ottica, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( revisione_assegnazione '
                                            ,p_revisione_assegnazione
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( revisione_cessazione '
                                            ,p_revisione_cessazione
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( gradazione '
                                            ,p_gradazione
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
                                            ,afc.date_format) || ' ) ' ||
                     p_other_condition;
      return d_statement;
   end; --- attributo_componente.where_condition
   --------------------------------------------------------------------------------
   function get_rows
   (
      p_id_attr_componente      in varchar2 default null
     ,p_id_componente           in varchar2 default null
     ,p_dal                     in varchar2 default null
     ,p_al                      in varchar2 default null
     ,p_incarico                in varchar2 default null
     ,p_telefono                in varchar2 default null
     ,p_fax                     in varchar2 default null
     ,p_e_mail                  in varchar2 default null
     ,p_assegnazione_prevalente in varchar2 default null
     ,p_tipo_assegnazione       in varchar2 default null
     ,p_percentuale_impiego     in varchar2 default null
     ,p_ottica                  in varchar2 default null
     ,p_revisione_assegnazione  in varchar2 default null
     ,p_revisione_cessazione    in varchar2 default null
     ,p_gradazione              in varchar2 default null
     ,p_utente_aggiornamento    in varchar2 default null
     ,p_data_aggiornamento      in varchar2 default null
     ,p_other_condition         in varchar2 default null
     ,p_dal_pubb                in varchar2 default null
     ,p_al_pubb                 in varchar2 default null
     ,p_al_prec                 in varchar2 default null
     ,p_qbe                     in number default 0
   ) return afc.t_ref_cursor is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_rows
       DESCRIZIONE: Ritorna il risultato di una query in base ai valori che passiamo.
       PARAMETRI:   Chiavi e attributi della table
                    p_other_condition
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
      dbc.pre(not dbc.preon or p_qbe in (0, 1)
             ,'check p_QBE on attributo_componente.get_rows');
      d_statement  := ' select * from attributi_componente ' ||
                      where_condition(p_id_attr_componente
                                     ,p_id_componente
                                     ,p_dal
                                     ,p_al
                                     ,p_incarico
                                     ,p_telefono
                                     ,p_fax
                                     ,p_e_mail
                                     ,p_assegnazione_prevalente
                                     ,p_tipo_assegnazione
                                     ,p_percentuale_impiego
                                     ,p_ottica
                                     ,p_revisione_assegnazione
                                     ,p_revisione_cessazione
                                     ,p_gradazione
                                     ,p_utente_aggiornamento
                                     ,p_data_aggiornamento
                                     ,p_other_condition
                                     ,p_dal_pubb
                                     ,p_al_pubb
                                     ,p_al_prec
                                     ,p_qbe);
      d_ref_cursor := afc_dml.get_ref_cursor(d_statement);
      return d_ref_cursor;
   end; -- attributo_componente.get_rows
   --------------------------------------------------------------------------------
   function count_rows
   (
      p_id_attr_componente      in varchar2 default null
     ,p_id_componente           in varchar2 default null
     ,p_dal                     in varchar2 default null
     ,p_al                      in varchar2 default null
     ,p_incarico                in varchar2 default null
     ,p_telefono                in varchar2 default null
     ,p_fax                     in varchar2 default null
     ,p_e_mail                  in varchar2 default null
     ,p_assegnazione_prevalente in varchar2 default null
     ,p_tipo_assegnazione       in varchar2 default null
     ,p_percentuale_impiego     in varchar2 default null
     ,p_ottica                  in varchar2 default null
     ,p_revisione_assegnazione  in varchar2 default null
     ,p_revisione_cessazione    in varchar2 default null
     ,p_gradazione              in varchar2 default null
     ,p_utente_aggiornamento    in varchar2 default null
     ,p_data_aggiornamento      in varchar2 default null
     ,p_other_condition         in varchar2 default null
     ,p_dal_pubb                in varchar2 default null
     ,p_al_pubb                 in varchar2 default null
     ,p_al_prec                 in varchar2 default null
     ,p_qbe                     in number default 0
   ) return integer is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        count_rows
       DESCRIZIONE: Ritorna il numero di righe della tabella gli attributi delle quali
                    rispettano i valori indicati.
       PARAMETRI:   Almeno uno dei parametri della tabella.
                    p_other_condition
                    p_QBE
       RITORNA:     Numero di righe che rispettano la selezione indicata.
      ******************************************************************************/
      d_result    integer;
      d_statement afc.t_statement;
   begin
      dbc.pre(not dbc.preon or p_qbe in (0, 1)
             ,'check p_QBE on attributo_componente.count_rows');
      d_statement := ' select count( * ) from attributi_componente ' ||
                     where_condition(p_id_attr_componente
                                    ,p_id_componente
                                    ,p_dal
                                    ,p_al
                                    ,p_incarico
                                    ,p_telefono
                                    ,p_fax
                                    ,p_e_mail
                                    ,p_assegnazione_prevalente
                                    ,p_tipo_assegnazione
                                    ,p_percentuale_impiego
                                    ,p_ottica
                                    ,p_revisione_assegnazione
                                    ,p_revisione_cessazione
                                    ,p_gradazione
                                    ,p_utente_aggiornamento
                                    ,p_data_aggiornamento
                                    ,p_other_condition
                                    ,p_dal_pubb
                                    ,p_al_pubb
                                    ,p_al_prec
                                    ,p_qbe);
      d_result    := afc.sql_execute(d_statement);
      return d_result;
   end; -- attributo_componente.count_rows
   --------------------------------------------------------------------------------
   function get_ultimo_periodo
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_rowid         in rowid
   ) return afc_periodo.t_periodo is
      /******************************************************************************
       NOME:        get_ultimo_periodo
       DESCRIZIONE: Restituisce le date dell'ultimo periodo degli incarichi del componente
       PARAMETRI:   p_id_componente
                    p_rowid
       NOTE:        --
      ******************************************************************************/
      d_result afc_periodo.t_periodo;
   begin
      begin
         select a1.dal
               ,a1.al
           into d_result.dal
               ,d_result.al
           from attributi_componente a1
          where a1.id_componente = p_id_componente
            and a1.rowid != p_rowid
            and a1.dal = (select max(a2.dal)
                            from attributi_componente a2
                           where a2.id_componente = p_id_componente
                             and a2.rowid != p_rowid);
      exception
         when others then
            d_result.dal := to_date(null);
            d_result.al  := to_date(null);
      end;
      --
      return d_result;
      --
   end;
   --------------------------------------------------------------------------------
   function is_ultimo_periodo
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_dal           in attributi_componente.dal%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_ultimo_periodo
       DESCRIZIONE: Controlla che il periodo passato sia l'ultimo per il componente
                    indicato
       PARAMETRI:   Id.componente
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
                   from attributi_componente
                  where id_componente = p_id_componente
                    and dal > p_dal);
      exception
         when others then
            d_result := 0;
      end;
      --
      return d_result;
      --
   end; -- attributo_componente.is_ultimo_periodo
   --------------------------------------------------------------------------------
   function is_dal_al_ok
   (
      p_dal in attributi_componente.dal%type
     ,p_al  in attributi_componente.al%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_dal_al_ok
       DESCRIZIONE: Controllo di congruenza tra data inizio e fine validità
       PARAMETRI:   p_dal
                    p_al
       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
      if nvl(p_dal, to_date('01011800', 'ddmmyyyy')) >
         nvl(p_al, to_date('31122200', 'ddmmyyyy')) then
         d_result := s_dal_al_errato_num;
      else
         d_result := afc_error.ok;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on area_org_om.is_dal_al_ok');
      return d_result;
   end; -- attributo_componente.is_dal_al_ok
   --------------------------------------------------------------------------------
   function is_tipo_assegnazione_ok
   (
      p_assegnazione_prevalente in attributi_componente.assegnazione_prevalente%type
     ,p_tipo_assegnazione       in attributi_componente.tipo_assegnazione%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_tipo_assegnazione_ok
       DESCRIZIONE: Controllo di congruenza tra assegnazione_prevalente e tipo_assegnazione
       PARAMETRI:   p_assegnazione_prevalente
                    p_tipo_assegnazione
       NOTE:        --
      ******************************************************************************/
      d_result     afc_error.t_error_number;
      d_integr_gp4 impostazioni.integr_gp4%type := impostazione.get_integr_gp4(1);
   begin
      if d_integr_gp4 = 'NO' and not (so4gp_pkg.is_int_gps) then
         --#742
         if p_assegnazione_prevalente = 1 then
            if p_tipo_assegnazione = 'I' then
               d_result := afc_error.ok;
            else
               d_result := s_assegnazione_errata_num;
            end if;
         else
            d_result := afc_error.ok;
         end if;
      else
         if p_assegnazione_prevalente in (1, 11, 12, 13, 2, 21, 22, 23, 3, 4, 99) then
            if p_tipo_assegnazione = 'I' then
               d_result := afc_error.ok;
            else
               d_result := s_assegnazione_errata_num;
            end if;
         else
            --#742
            if p_tipo_assegnazione = 'I' then
               d_result := s_assegnazione_errata_num;
            else
               d_result := afc_error.ok;
            end if;
         end if;
      end if;
      --
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on area_org_om.is_dal_al_ok');
      return d_result;
   end; -- attributo_componente.is_tipo_assegnazione_ok
   --------------------------------------------------------------------------------
   function is_revisioni_ok
   (
      p_revisione_assegnazione in attributi_componente.revisione_assegnazione%type
     ,p_revisione_cessazione   in attributi_componente.revisione_cessazione%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_revisioni_ok
       DESCRIZIONE: Controlla che le revisioni siano congruenti
       PARAMETRI:   p_revisione_assegnazione
                    p_revisione_cessazione
       RITORNA:     Afc_error.t_error_number
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
      if (p_revisione_assegnazione is null) or (p_revisione_cessazione is null) or
         (p_revisione_assegnazione is not null and p_revisione_cessazione is not null and
         p_revisione_assegnazione < nvl(p_revisione_cessazione, 99999999)) then
         d_result := afc_error.ok;
      else
         d_result := s_revisioni_errate_num;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on attributo_componente.is_revisioni_ok');
      return d_result;
   end; -- attributi_componente.is_revisioni_ok
   --------------------------------------------------------------------------------
   function is_di_ok
   (
      p_dal                     in attributi_componente.dal%type
     ,p_al                      in attributi_componente.al%type
     ,p_ottica                  in attributi_componente.ottica%type
     ,p_assegnazione_prevalente in attributi_componente.assegnazione_prevalente%type
     ,p_tipo_assegnazione       in attributi_componente.tipo_assegnazione%type
     ,p_revisione_assegnazione  in attributi_componente.revisione_assegnazione%type default null
     ,p_revisione_cessazione    in attributi_componente.revisione_cessazione%type default null
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_DI_ok
       DESCRIZIONE: Function di gestione Data Integrity
       PARAMETRI:   is_dal_al_ok
                    is_tipo_assegnazione_ok
                    is_revisioni_ok
       NOTE:        --
      ******************************************************************************/
      d_result              afc_error.t_error_number := afc_error.ok;
      d_tipo_revisione_ass  revisioni_struttura.tipo_revisione%type;
      d_tipo_revisione_cess revisioni_struttura.tipo_revisione%type;
   begin
      -- verifica se la data di inizio e la revisione di assegnazioni sono stati comunicati
      if p_dal is null and p_revisione_assegnazione is null then
         d_result := s_data_inizio_mancante_num;
         return d_result;
      end if;
      if p_revisione_assegnazione is not null then
         d_tipo_revisione_ass := revisione_struttura.get_tipo_revisione(p_ottica
                                                                       ,p_revisione_assegnazione);
      end if;
      if p_revisione_cessazione is not null then
         d_tipo_revisione_cess := revisione_struttura.get_tipo_revisione(p_ottica
                                                                        ,p_revisione_cessazione);
      end if;
      -- is_dal_al_ok
      if ((p_revisione_assegnazione is not null and nvl(d_tipo_revisione_ass, 'N') = 'N') or
         p_revisione_assegnazione is null) and
         ((p_revisione_cessazione is not null and nvl(d_tipo_revisione_cess, 'N') = 'N') or
         p_revisione_cessazione is null) then
         if revisione_struttura.s_attivazione <> 1 then
            d_result := is_dal_al_ok(p_dal, p_al);
         end if;
         --#533
         /*if d_result = afc_error.ok then
            d_result := is_revisioni_ok(p_revisione_assegnazione, p_revisione_cessazione);
         end if;*/
      end if;
      -- is_tipo_assegnazione_ok
      if d_result = afc_error.ok then
         d_result := is_tipo_assegnazione_ok(p_assegnazione_prevalente
                                            ,p_tipo_assegnazione);
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on attributo_componente.is_DI_ok');
      return d_result;
   end; -- attributo_componente.is_DI_ok
   --------------------------------------------------------------------------------
   procedure chk_di
   (
      p_dal                     in attributi_componente.dal%type
     ,p_al                      in attributi_componente.al%type
     ,p_ottica                  in attributi_componente.ottica%type
     ,p_assegnazione_prevalente in attributi_componente.assegnazione_prevalente%type
     ,p_tipo_assegnazione       in attributi_componente.tipo_assegnazione%type
     ,p_revisione_assegnazione  in attributi_componente.revisione_assegnazione%type default null
     ,p_revisione_cessazione    in attributi_componente.revisione_cessazione%type default null
   ) is
      /******************************************************************************
       NOME:        chk_DI.
       DESCRIZIONE: controllo integrita dati:
                    - dal < al
                    - se le revisioni sono entrambe non nulle deve essere revisione_assegnazione < revisione_cessazione
       RITORNA:     -
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
      d_result := is_di_ok(p_dal
                          ,p_al
                          ,p_ottica
                          ,p_assegnazione_prevalente
                          ,p_tipo_assegnazione
                          ,p_revisione_assegnazione
                          ,p_revisione_cessazione);
      dbc.assertion(not dbc.assertionon or d_result = afc_error.ok or d_result < 0
                   ,'d_result = AFC_Error.ok or d_result < 0 on attributo_componente.chk_DI');
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, s_error_table(d_result));
      end if;
   end; -- attributo_componente.chk_DI
   --------------------------------------------------------------------------------
   function is_dal_ok
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_old_dal       in attributi_componente.dal%type
     ,p_new_dal       in attributi_componente.dal%type
     ,p_old_al        in attributi_componente.al%type
     ,p_rowid         in rowid
     ,p_inserting     in number
     ,p_updating      in number
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_dal_ok
       DESCRIZIONE: Controllo nuovo dal compreso in periodo immediatamente
                    precedente
       PARAMETRI:   p_id_componente
                    p_old_dal
                    p_new_dal
                    p_old_al
                    p_rowid
                    p_inserting
                    p_updating
       NOTE:        --
      ******************************************************************************/
      d_dal_componente componenti.dal%type;
      d_periodo        afc_periodo.t_periodo;
      d_result         afc_error.t_error_number := afc_error.ok;
   begin
      --
      if p_new_dal is not null then
         d_dal_componente := componente.get_dal(p_id_componente => p_id_componente);
         if p_new_dal < d_dal_componente and componente.s_origine_gp <> 1 --#763
          then
            d_result := s_dal_minore_num;
         end if;
      end if;
      --
      if d_result = afc_error.ok then
         if p_inserting = 1 and p_updating = 0 then
            d_periodo := afc_periodo.get_ultimo(p_tabella            => 'ATTRIBUTI_COMPONENTE'
                                               ,p_nome_dal           => 'DAL'
                                               ,p_nome_al            => 'AL'
                                               ,p_al                 => p_old_al
                                               ,p_campi_controllare  => '#ID_COMPONENTE#DAL#'
                                               ,p_valori_controllare => '#' ||
                                                                        p_id_componente ||
                                                                        '#!=' ||
                                                                        'to_date( ''' ||
                                                                        to_char(p_new_dal
                                                                               ,'dd/mm/yyyy') ||
                                                                        ''', ''dd/mm/yyyy'' ) ' || '#'
                                               ,p_rowid              => p_rowid);
            if d_periodo.dal is null and d_periodo.al is null then
               d_result := afc_error.ok;
            else
               if p_new_dal <= d_periodo.dal then
                  d_result := s_dal_errato_ins_num;
               else
                  d_result := afc_error.ok;
               end if;
            end if;
         end if;
      end if;
      if d_result = afc_error.ok then
         if p_inserting = 0 and p_updating = 1 then
            if p_new_dal < p_old_dal then
               d_periodo := afc_periodo.get_precedente(p_tabella            => 'ATTRIBUTI_COMPONENTE'
                                                      ,p_nome_dal           => 'DAL'
                                                      ,p_nome_al            => 'AL'
                                                      ,p_dal                => p_old_dal
                                                      ,p_al                 => p_old_al
                                                      ,p_campi_controllare  => '#ID_COMPONENTE#'
                                                      ,p_valori_controllare => '#' ||
                                                                               p_id_componente || '#'
                                                      ,p_rowid              => p_rowid);
               if d_periodo.dal is null and d_periodo.al is null then
                  d_result := afc_error.ok;
               else
                  if p_new_dal between d_periodo.dal and d_periodo.al then
                     d_result := afc_error.ok;
                  else
                     d_result := s_dal_errato_num;
                  end if;
               end if;
            else
               d_result := afc_error.ok;
            end if;
         end if;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on attributo_componente.is_dal_ok');
      return d_result;
   end; -- attributo_componente.is_dal_ok
   --------------------------------------------------------------------------------
   function is_al_ok
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_old_dal       in attributi_componente.dal%type
     ,p_old_al        in attributi_componente.al%type
     ,p_new_al        in attributi_componente.al%type
     ,p_rowid         in rowid
     ,p_inserting     in number
     ,p_updating      in number
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_al_ok
       DESCRIZIONE: Controllo is_al_ok
       PARAMETRI:   p_id_componente
                    p_old_dal
                    p_old_al
                    p_new_al
                    p_rowid
                    p_inserting
                    p_updating
       NOTE:        --
      ******************************************************************************/
      d_al_componente componenti.al%type;
      --      d_periodo       afc_periodo.t_periodo;
      d_result afc_error.t_error_number := afc_error.ok;
   begin
      d_al_componente := componente.get_al(p_id_componente => p_id_componente);
      if nvl(p_new_al, to_date('3333333', 'j')) >
         nvl(d_al_componente, to_date('3333333', 'j')) then
         d_result := s_al_maggiore_num;
      end if;
      /*   if d_result = Afc_Error.ok then
            if p_inserting = 1 and p_updating = 0 then
               d_periodo := AFC_Periodo.get_ultimo ( p_tabella => 'ATTRIBUTI_COMPONENTE'
                                                   , p_nome_dal => 'DAL'
                                                   , p_nome_al => 'AL'
                                                   , p_al => p_old_al
                                                   , p_campi_controllare => '#ID_COMPONENTE#'
                                                   , p_valori_controllare => '#'||p_id_componente||'#'
                                                   , p_rowid => p_rowid
                                                   );
               if d_periodo.dal is null and d_periodo.al is null
               then
                  d_result := AFC_Error.ok;
               else
                  if p_new_al <= d_periodo.al
                  then
                     d_result := s_al_errato_num;
                  else
                     d_result := AFC_Error.ok;
                  end if;
               end if;
            end if;
         end if;
      */
      /*   if d_result = afc_error.ok then
         if p_inserting = 0 and p_updating = 1 then
            d_result:= Afc_Periodo.is_ultimo ( p_tabella => 'ATTRIBUTI_COMPONENTE'
                                             , p_nome_dal => 'DAL'
                                             , p_nome_al => 'AL'
                                             , p_dal => p_old_dal
                                             , p_al => p_old_al
                                             , p_campi_controllare => '#ID_COMPONENTE#'
                                             , p_valori_controllare => '#'||p_id_componente||'#'
                                             );
            if NOT d_result = AFC_Error.ok
            then
               d_result := s_al_errato_num;
            end if;
         end if;
      end if;*/
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on attributo_componente.is_al_ok');
      return d_result;
   end; -- attributo_componente.is_al_ok
   --------------------------------------------------------------------------------
   function is_assegnazione_prevalente_ok
   (
      p_ottica in componenti.ottica%type
     ,p_ni     in componenti.ni%type
     ,p_ci     in componenti.ci%type
     ,p_dal    in attributi_componente.dal%type
     ,p_al     in attributi_componente.al%type
     ,p_data   in attributi_componente.dal%type default null
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_assegnazione_prevalente_ok
       DESCRIZIONE: Controlla che il componente abbia almeno un'assegnazione
                    prevalente nel periodo
       PARAMETRI:   p_ottica
                    p_ni
                    p_ci
                    p_dal
                    p_al
       NOTE:        --
      ******************************************************************************/
      d_contatore            number := 1;
      d_result               afc_error.t_error_number := afc_error.ok;
      d_revisione_mod        attributi_componente.revisione_assegnazione%type;
      d_ottica_istituzionale ottiche.ottica_istituzionale%type := ottica.get_ottica_istituzionale(p_ottica);
   begin
      if d_ottica_istituzionale = 'SI' then
         d_revisione_mod := revisione_struttura.get_revisione_mod(p_ottica);
         if p_ni is null or p_dal is null then
            d_contatore := 1;
         else
            begin
               select count(*)
                 into d_contatore
                 from componenti           c
                     ,attributi_componente a
                where c.ottica = p_ottica
                  and c.ni = p_ni
                  and nvl(c.ci, -1) = nvl(p_ci, -1)
                  and c.id_componente = a.id_componente
                  and (p_dal between
                      decode(a.revisione_assegnazione, d_revisione_mod, p_data, a.dal) and
                      nvl(a.al
                          ,decode(a.revisione_cessazione
                                 ,d_revisione_mod
                                 ,p_data - 1
                                 ,to_date('3333333', 'j'))) or
                      nvl(p_al, to_date('3333333', 'j')) between
                      decode(a.revisione_assegnazione, d_revisione_mod, p_data, a.dal) and
                      nvl(a.al
                          ,decode(a.revisione_cessazione
                                 ,d_revisione_mod
                                 ,p_data - 1
                                 ,to_date('3333333', 'j'))) or
                      (p_dal <
                      decode(a.revisione_assegnazione, d_revisione_mod, p_data, a.dal) and
                      nvl(p_al, to_date('3333333', 'j')) >
                      nvl(a.al
                           ,decode(a.revisione_cessazione
                                  ,d_revisione_mod
                                  ,p_data - 1
                                  ,to_date('3333333', 'j')))));
            exception
               when others then
                  d_contatore := 0;
            end;
            if d_contatore > 0 then
               begin
                  select count(*)
                    into d_contatore
                    from componenti           c
                        ,attributi_componente a
                   where c.ottica = p_ottica
                     and c.ni = p_ni
                     and nvl(c.ci, -1) = nvl(p_ci, -1)
                     and c.id_componente = a.id_componente
                     and (p_dal between
                         decode(a.revisione_assegnazione, d_revisione_mod, p_data, a.dal) and
                         nvl(a.al
                             ,decode(a.revisione_cessazione
                                    ,d_revisione_mod
                                    ,p_data - 1
                                    ,to_date('3333333', 'j'))) or
                         nvl(p_al, to_date('3333333', 'j')) between
                         decode(a.revisione_assegnazione, d_revisione_mod, p_data, a.dal) and
                         nvl(a.al
                             ,decode(a.revisione_cessazione
                                    ,d_revisione_mod
                                    ,p_data - 1
                                    ,to_date('3333333', 'j'))) or
                         (p_dal < decode(a.revisione_assegnazione
                                         ,d_revisione_mod
                                         ,p_data
                                         ,a.dal) and
                         nvl(p_al, to_date('3333333', 'j')) >
                         nvl(a.al
                              ,decode(a.revisione_cessazione
                                     ,d_revisione_mod
                                     ,p_data - 1
                                     ,to_date('3333333', 'j')))))
                     and nvl(a.assegnazione_prevalente, 0) like '1%'; --#543
               exception
                  when others then
                     d_contatore := 0;
               end;
            end if;
         end if;
      end if;
      if d_contatore = 0 then
         null; --d_result := s_ass_prev_assente_num;
      elsif d_contatore > 1 then
         d_result := s_ass_prev_multiple_num;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on attributo_componente.is_assegnazione_prevalente_ok');
      return d_result;
   end; -- attributo_componente.is_assegnazione_prevalente_ok
   --------------------------------------------------------------------------------
   function is_percentuale_impiego_ok
   (
      p_ottica in componenti.ottica%type
     ,p_ni     in componenti.ni%type
     ,p_ci     in componenti.ci%type
     ,p_dal    in attributi_componente.dal%type
     ,p_al     in attributi_componente.al%type
     ,p_data   in attributi_componente.dal%type default null
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_percentuale_impiego_ok
       DESCRIZIONE: Controlla che il componente abbia almeno un'assegnazione
                    prevalente nel periodo
       PARAMETRI:   p_ottica
                    p_ni
                    p_ci
                    p_dal
                    p_al
       NOTE:        --
      ******************************************************************************/
      d_perc_totale   attributi_componente.percentuale_impiego%type;
      d_revisione_mod attributi_componente.revisione_assegnazione%type;
      d_result        afc_error.t_error_number := afc_error.ok;
   begin
      d_revisione_mod := revisione_struttura.get_revisione_mod(p_ottica);
      if p_ni is null or p_dal is null then
         d_perc_totale := 100;
      else
         begin
            select sum(nvl(a.percentuale_impiego, 0))
              into d_perc_totale
              from componenti           c
                  ,attributi_componente a
             where c.ottica = p_ottica
               and c.ni = p_ni
               and nvl(c.ci, -1) = nvl(p_ci, -1)
               and c.id_componente = a.id_componente
               and (p_dal between
                   decode(a.revisione_assegnazione, d_revisione_mod, p_data, a.dal) and
                   nvl(a.al
                       ,decode(a.revisione_cessazione
                              ,d_revisione_mod
                              ,p_data - 1
                              ,to_date('3333333', 'j'))) or
                   nvl(p_al, to_date('3333333', 'j')) between
                   decode(a.revisione_assegnazione, d_revisione_mod, p_data, a.dal) and
                   nvl(a.al
                       ,decode(a.revisione_cessazione
                              ,d_revisione_mod
                              ,p_data - 1
                              ,to_date('3333333', 'j'))) or
                   (p_dal <
                   decode(a.revisione_assegnazione, d_revisione_mod, p_data, a.dal) and
                   nvl(p_al, to_date('3333333', 'j')) >
                   nvl(a.al
                        ,decode(a.revisione_cessazione
                               ,d_revisione_mod
                               ,p_data - 1
                               ,to_date('3333333', 'j')))));
         exception
            when others then
               d_perc_totale := 100;
         end;
      end if;
      if nvl(d_perc_totale, 0) <> 100 then
         d_result := s_perc_impiego_errata_num;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on attributo_componente.is_assegnazione_prevalente_ok');
      return d_result;
   end; -- attributo_componente.is_percentuale_impiego_ok
   --------------------------------------------------------------------------------
   function is_ass_prev_compatibile
   (
      p_id_componente               in componenti.id_componente%type
     ,p_dal                         in attributi_componente.dal%type
     ,p_assegnazione_prevalente     in attributi_componente.assegnazione_prevalente%type
     ,p_old_assegnazione_prevalente in attributi_componente.assegnazione_prevalente%type
     ,p_inserting                   in number
     ,p_updating                    in number
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_assegnazione_prevalente_ok
       DESCRIZIONE: Controlla che l'assegnazione prevalente specificata per il componente
                    sia compatibile con la sua situazione
       PARAMETRI:   p_id_componente
                    p_dal
                    p_assegnazione_prevalente
       NOTE:        --
      ******************************************************************************/
      d_result                  afc_error.t_error_number := afc_error.ok;
      d_ottica                  componenti.ottica%type := componente.get_ottica(p_id_componente);
      dummy                     number(1);
      d_assegnazione_prevalente attributi_componente.assegnazione_prevalente%type;
   begin
      -- verifico assegnazione precedente solo se siamo integrati e se ottica gestita
      if so4_pkg.get_integrazione_gp = 'SI' and
         so4gp_pkg.is_struttura_integrata('', d_ottica) = 'SI' and --#429
        -- Se non ho una revisione in modifica devo fare il controllo
        -- se ho una revisione in modifica faccio il controllo solo se il record è stato creato con questa revisione
         nvl(componente.get_revisione_assegnazione(p_id_componente), -2) <>
         nvl(revisione_struttura.get_revisione_mod(d_ottica), -1)
        -- controllo eseguito solo se non sto attivando la revisione, i.e. non sto operando da GPS
         and revisione_struttura.s_attivazione = 0 then
         -- verifico assegnazione precedente solo se siamo integrati e se ottica gestita
         if p_inserting = 1 then
            begin
               select assegnazione_prevalente
                 into d_assegnazione_prevalente
                 from attributi_componente
                where id_componente = p_id_componente
                  and dal = (select max(dal)
                               from attributi_componente
                              where id_componente = p_id_componente
                                and dal < p_dal);
            exception
               when no_data_found then
                  -- prima assegnazione
                  null;
            end;
         elsif p_updating = 1 then
            d_assegnazione_prevalente := p_old_assegnazione_prevalente;
         end if;
         --#742
         if ((d_assegnazione_prevalente not in (1, 11, 12, 13) and
            p_assegnazione_prevalente in (1, 11, 12, 13)) or
            (d_assegnazione_prevalente in (1, 11, 12, 13) and
            p_assegnazione_prevalente not in (1, 11, 12, 13))) or
            (d_assegnazione_prevalente <> 99 and p_assegnazione_prevalente = 99 or
            d_assegnazione_prevalente = 99 and p_assegnazione_prevalente <> 99) then
            d_result := s_ass_prev_errata_num;
         end if;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on attributo_componente.is_assegnazione_prevalente_ok');
      return d_result;
   end; -- attributo_componente.is_ass_prev_compatibile
   --------------------------------------------------------------------------------
   function is_last_record(p_id_componente in attributi_componente.id_componente%type)
      return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_last_record
       DESCRIZIONE: Controlla che il componente abbia almeno un attributo
       PARAMETRI:   p_id_componente
       NOTE:        --
      ******************************************************************************/
      d_result        afc_error.t_error_number := afc_error.ok;
      d_select_result number(8);
   begin
      begin
         select count(*)
           into d_select_result
           from attributi_componente
          where id_componente = p_id_componente;
      exception
         when others then
            d_select_result := 0;
      end;
      if d_select_result = 0 then
         d_result := s_attr_non_eliminabile_num;
      else
         d_result := afc_error.ok;
      end if;
      return d_result;
   end; -- attributo_componente.is_percentuale_impiego_ok
   --------------------------------------------------------------------------------
   function is_ri_ok
   (
      p_id_componente               in attributi_componente.id_componente%type
     ,p_old_dal                     in attributi_componente.dal%type
     ,p_new_dal                     in attributi_componente.dal%type
     ,p_old_al                      in attributi_componente.al%type
     ,p_new_al                      in attributi_componente.al%type
     ,p_rowid                       in rowid
     ,p_inserting                   in number
     ,p_updating                    in number
     ,p_deleting                    in number
     ,p_assegnazione_prevalente     in attributi_componente.assegnazione_prevalente%type
     ,p_old_assegnazione_prevalente in attributi_componente.assegnazione_prevalente%type
     ,p_id_attr_componente          in attributi_componente.id_attr_componente%type
     ,p_tipo_assegnazione           in attributi_componente.tipo_assegnazione%type
     ,p_livello                     in number
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_RI_ok.
       DESCRIZIONE: gestione della Referential Integrity:
                    - is_dal_ok
                    - is_al_ok
       PARAMETRI:   p_id_componente
                    p_old_dal
                    p_new_dal
                    p_old_al
                    p_new_al
                    p_rowid
                    p_inserting
                    p_updating
       RETURN:      1 se tutti i controlli danno esito positivo, l'error_code altrimenti
       NOTE:        --
      ******************************************************************************/
      d_comp componenti%rowtype;
      --      d_ni     componenti.ni%type;
      --      d_ci     componenti.ci%type;
      d_dummy  varchar2(1);
      d_result afc_error.t_error_number := afc_error.ok;
   begin
      -- is_last_record (deve rimanere almeno un attributo per il componente, se questo esiste ancora)
      if p_deleting = 1 and p_livello > 0 then
         -- se sono in cancellazione dell'attributo e non sono al livello 0 (cancellazione in cascade da componenti)
         -- evito il controllo sul fatto che sia l'ultimo record
         null;
      else
         begin
            select 'x'
              into d_dummy
              from componenti
             where id_componente = p_id_componente;
            raise too_many_rows;
         exception
            when too_many_rows then
               if p_deleting = 1 then
                  d_result := is_last_record(p_id_componente);
               end if;
            when no_data_found then
               null;
         end;
      end if;
      if p_deleting = 0 then
         -- is_dal_ok (la data DAL deve essere compresa nel periodo immediatamente
         -- precedente a quello che si sta trattando
         if d_result = afc_error.ok then
            d_result := is_dal_ok(p_id_componente
                                 ,p_old_dal
                                 ,p_new_dal
                                 ,p_old_al
                                 ,p_rowid
                                 ,p_inserting
                                 ,p_updating);
         end if;
         -- is_al_ok (la data AL deve essere maggiore dell'ultima inserita
         if revisione_struttura.s_attivazione <> 1 then
            if (d_result = afc_error.ok) then
               d_result := is_al_ok(p_id_componente
                                   ,p_old_dal
                                   ,p_old_al
                                   ,p_new_al
                                   ,p_rowid
                                   ,p_inserting
                                   ,p_updating);
            end if;
         end if;
      end if;
      -- esiste_componente (il componente può avere una sola assegnazione prevalente
      -- sulla stessa unita'
      if (d_result = afc_error.ok) and p_assegnazione_prevalente like '1%' /* #644 */
         and p_deleting = 0 then
         begin
            select * into d_comp from componenti where id_componente = p_id_componente;
         end;
         d_result := esiste_componente(p_id_componente
                                      ,d_comp.ottica
                                      ,d_comp.progr_unita_organizzativa
                                      ,d_comp.ni
                                      ,d_comp.ci
                                      ,d_comp.dal
                                      ,d_comp.al
                                      ,d_comp.revisione_cessazione);
      end if;
      -- is_tipo_assegnazione_ok (l'assegnazione non può essere Istituzionale e Funzionale
      -- a per lo stesso componente
      if (d_result = afc_error.ok) and p_deleting = 0 then
         d_result := is_tipo_assegnazione_ok(p_id_componente
                                            ,p_id_attr_componente
                                            ,p_tipo_assegnazione);
      end if;
      if (d_result = afc_error.ok) and p_deleting = 0 then
         d_result := is_ass_prev_compatibile(p_id_componente
                                            ,p_new_dal
                                            ,p_assegnazione_prevalente
                                            ,p_old_assegnazione_prevalente
                                            ,p_inserting
                                            ,p_updating);
      end if;
      -- is_assegnazione_prevalente_ok (il componente deve avere una
      -- sola assegnazione prevalente
      /*if d_result = afc_error.ok then
         if (p_updating = 1 and (p_new_dal is not null or p_new_al is not null)) or
            (p_deleting = 1 and integritypackage.getnestlevel = 0) or
            (p_inserting = 1 and integritypackage.getnestlevel = 0) then
            d_ottica := componente.get_ottica(p_id_componente);
            d_ni     := componente.get_ni(p_id_componente);
            d_ci     := componente.get_ci(p_id_componente);
            d_result := is_assegnazione_prevalente_ok(d_ottica
                                                     ,d_ni
                                                     ,d_ci
                                                     ,p_new_dal
                                                     ,p_new_al);
         end if;
      end if;*/
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on attributo_componente.is_RI_ok');
      return d_result;
   end; -- attributo_componente.is_RI_ok
   --------------------------------------------------------------------------------
   procedure chk_ri
   (
      p_id_componente               in attributi_componente.id_componente%type
     ,p_old_dal                     in attributi_componente.dal%type
     ,p_new_dal                     in attributi_componente.dal%type
     ,p_old_al                      in attributi_componente.al%type
     ,p_new_al                      in attributi_componente.al%type
     ,p_rowid                       in rowid
     ,p_inserting                   in number
     ,p_updating                    in number
     ,p_deleting                    in number
     ,p_assegnazione_prevalente     in attributi_componente.assegnazione_prevalente%type
     ,p_old_assegnazione_prevalente in attributi_componente.assegnazione_prevalente%type
     ,p_id_attr_componente          in attributi_componente.id_attr_componente%type
     ,p_tipo_assegnazione           in attributi_componente.tipo_assegnazione%type
     ,p_ottica                      in attributi_componente.ottica%type
     ,p_revisione_assegnazione      in attributi_componente.revisione_assegnazione%type
     ,p_old_revisione_assegnazione  in attributi_componente.revisione_assegnazione%type --#644
     ,p_livello                     in number
   ) is
      /******************************************************************************
       NOME:        chk_RI.
       DESCRIZIONE: gestione della Referential Integrity:
                    - is_dal_ok
                    - is_al_ok
       PARAMETRI:   p_id_compoennte
                    p_old_dal
                    p_new_dal
                    p_old_al
                    p_new_al
                    p_rowid
                    p_inserting
                    p_updating
       NOTE:        --
      ******************************************************************************/
      d_result        afc_error.t_error_number;
      d_dummy         varchar2(1);
      d_revisione_mod revisioni_struttura.revisione%type := revisione_struttura.get_revisione_mod(p_ottica);
      d_num_record    number(8); --#627
   begin
      -- #627: extra revisione, non è possibile avere piu' record sovrapposti per lo stesso componente
      if revisione_struttura.s_attivazione = 0 and p_livello = 0 /*#685*/
         and
         (p_inserting = 1 or (p_updating = 1 and (p_old_dal <> p_new_dal or
         nvl(p_old_al, to_date(3333333, 'j')) <>
         nvl(p_new_al, to_date(3333333, 'j'))))) then
         --controllo sulla sovrapposizione di periodi
         select count(*)
           into d_num_record
           from attributi_componente a
          where a.id_componente = p_id_componente
            and a.dal <= nvl(a.al, to_date(3333333, 'j'))
            and nvl(a.al, to_date(3333333, 'j')) >= p_new_dal
            and a.id_attr_componente <> p_id_attr_componente;
         if d_num_record > 1 then
            raise_application_error(s_dal_errato_ins_num
                                   ,s_error_table(s_dal_errato_ins_num));
         end if;
         --controllo sulla coincidenza di decorrenza dell'ultimo periodo preesistente
         select count(*)
           into d_num_record
           from attributi_componente a
          where a.id_componente = p_id_componente
            and a.dal <= nvl(a.al, to_date(3333333, 'j'))
            and a.dal = p_new_dal
            and a.id_attr_componente <> p_id_attr_componente;
         if d_num_record > 0 then
            raise_application_error(s_dal_errato_ins_num
                                   ,s_error_table(s_dal_errato_ins_num));
         end if;
      end if;
      -- #550: in caso di integrazione con GPs, non e' possibile modificare le date del periodo
      if revisione_struttura.s_attivazione = 0 and
         (p_inserting = 1 or (p_updating = 1 and (p_old_dal <> p_new_dal or
         nvl(p_old_al, to_date(3333333, 'j')) <>
         nvl(p_new_al, to_date(3333333, 'j'))))) and
         (so4gp_pkg.is_int_gps and so4gp_pkg.is_struttura_integrata('', p_ottica) = 'SI' and
         p_updating = 1 and componente.s_spostamento = 0 and componente.s_origine_gp = 0 and
         p_tipo_assegnazione = 'I' and
         (p_assegnazione_prevalente like '1%' or p_assegnazione_prevalente = 99) and
         (p_old_dal <> p_new_dal or
         nvl(p_old_al, to_date(3333333, 'j')) <> nvl(p_new_al, to_date(3333333, 'j')))) then
         raise_application_error(s_date_non_modificabili_num
                                ,s_error_table(s_date_non_modificabili_num));
      end if;
      d_result := is_ri_ok(p_id_componente
                          ,p_old_dal
                          ,p_new_dal
                          ,p_old_al
                          ,p_new_al
                          ,p_rowid
                          ,p_inserting
                          ,p_updating
                          ,p_deleting
                          ,p_assegnazione_prevalente
                          ,p_old_assegnazione_prevalente
                          ,p_id_attr_componente
                          ,p_tipo_assegnazione
                          ,p_livello);
      /* controllo spostato da componente a attributo #427 */
      --       non e' ammesso riassegnare un individuo alla stessa UO in periodi sovrapposti
      --       viene concessa una eccezione per le registrazioni di provenienza GPS
      set_tipo_revisione(p_ottica, nvl(p_revisione_assegnazione, -2));
      if d_result = afc_error.ok and p_deleting <> 1
        --and p_new_utente_aggiornamento not like 'Aut.%'
         and s_tipo_revisione = 'N' and p_assegnazione_prevalente != '99' -- aggiunta per consentire inserimento di incarichi su stessa UO
         and not (so4gp_pkg.is_int_gps and revisione_struttura.s_attivazione = 1) --#548
       then
         -- condizione per gestire l'inserimento di attributo di default
         -- in caso di incarico inserito da GPS
         begin
            select 'x'
              into d_dummy
              from componenti c
             where c.progr_unita_organizzativa =
                   componente.get_progr_unita_organizzativa(p_id_componente)
               and c.ottica = p_ottica
               and c.id_componente <> p_id_componente
               and c.ni = componente.get_ni(p_id_componente)
               and nvl(componente.get_revisione_assegnazione(p_id_componente), -2) <>
                   d_revisione_mod
               and revisione_struttura.get_tipo_revisione(c.ottica
                                                         ,c.revisione_assegnazione) <> 'R'
               and nvl(c.ci, -1) = nvl(componente.get_ci(p_id_componente), -1)
               and nvl(c.dal, to_date(2222222, 'j')) <=
                   nvl(p_new_al, to_date(3333333, 'j'))
               and nvl(c.al, to_date(3333333, 'j')) >=
                   nvl(p_new_dal, to_date(2222222, 'j'))
                  -- BUG#252 vanno esclusi i record con dal > al corrispondenti a record cessati logicamente
               and c.dal < nvl(c.al, to_date(3333333, 'j'))
                  -- conseguenza Bug#427
               and substr(p_assegnazione_prevalente, 1, 1) =
                   substr(attributo_componente.get_assegnazione_corrente(c.id_componente
                                                                        ,p_new_dal
                                                                        ,c.ottica)
                         ,1
                         ,1);
            --
            raise too_many_rows;
         exception
            when no_data_found then
               null;
            when too_many_rows then
               d_result := s_assegnazione_ripetuta_num;
         end;
      end if;
      -- verifica cautelativa dell'univocita' dell'assegnazione istituzionale prevalente #644
      if d_result = afc_error.ok and p_updating = 1 and p_revisione_assegnazione is null and
         p_old_revisione_assegnazione is not null then
         d_result := is_assegnazione_prevalente_ok(p_ottica
                                                  ,componente.get_ni(p_id_componente)
                                                  ,componente.get_ci(p_id_componente)
                                                  ,p_new_dal
                                                  ,p_new_al
                                                  ,to_date(null));
      end if;
      dbc.assertion(not dbc.assertionon or d_result = afc_error.ok or d_result < 0
                   ,'d_result = AFC_Error.ok or d_result < 0 on attributo_componente.chk_RI');
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, s_error_table(d_result));
      end if;
   end; -- attributo_componente.chk_RI
   --------------------------------------------------------------------------------
   function esiste_componente
   (
      p_id_componente             in componenti.id_componente%type
     ,p_ottica                    in componenti.ottica%type
     ,p_progr_unita_organizzativa in componenti.progr_unita_organizzativa%type
     ,p_ni                        in componenti.ni%type
     ,p_ci                        in componenti.ci%type
     ,p_dal                       in componenti.dal%type
     ,p_al                        in componenti.al%type
     ,p_revisione_cessazione      in componenti.revisione_cessazione%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        esiste_componente
       DESCRIZIONE: Controlla che il componente non sia gia'
                    associato alla unita' organizzativa con un'altra
                    assegnazione prevalente
       NOTE:        --
      ******************************************************************************/
      d_contatore              number;
      d_revisione_mod          revisioni_struttura.revisione%type;
      d_revisione_assegnazione componenti.revisione_assegnazione%type := componente.get_revisione_assegnazione(p_id_componente);
      d_result                 afc_error.t_error_number := afc_error.ok;
   begin
      d_revisione_mod := revisione_struttura.get_revisione_mod(p_ottica);
      begin
         if d_revisione_assegnazione = d_revisione_mod or
            p_revisione_cessazione = d_revisione_mod or --#548 --#543
            (so4gp_pkg.is_int_gps and componente.s_origine_gp = 1) then
            d_contatore := 0;
         else
            if so4gp_pkg.is_int_gps then
               --#543
               select count(*)
                 into d_contatore
                 from componenti c
                where ottica = p_ottica
                  and progr_unita_organizzativa = p_progr_unita_organizzativa
                  and ni = p_ni
                  and nvl(ci, -1) = nvl(p_ci, -1)
                  and nvl(p_dal, to_date(2222222, 'j')) <= nvl(al, to_date(3333333, 'j'))
                  and nvl(p_al, to_date(3333333, 'j')) >= nvl(dal, to_date(2222222, 'j'))
                     -- esclusione delle registrazioni eliminate logicamente
                  and c.dal <= nvl(c.al, to_date(3333333, 'j'))
                  and id_componente != nvl(p_id_componente, -1)
                  and exists (select 'x'
                         from attributi_componente
                        where id_componente = c.id_componente
                          and (to_char(assegnazione_prevalente) like '1%' or
                              to_char(assegnazione_prevalente) = 99)); --#543
            else
               select count(*)
                 into d_contatore
                 from componenti c
                where ottica = p_ottica
                  and progr_unita_organizzativa = p_progr_unita_organizzativa
                  and ni = p_ni
                  and nvl(ci, -1) = nvl(p_ci, -1)
                  and nvl(p_dal, to_date(2222222, 'j')) <= nvl(al, to_date(3333333, 'j'))
                  and nvl(p_al, to_date(3333333, 'j')) >= nvl(dal, to_date(2222222, 'j'))
                     -- esclusione delle registrazioni eliminate logicamente
                  and c.dal <= nvl(c.al, to_date(3333333, 'j'))
                  and id_componente != nvl(p_id_componente, -1)
                  and exists
                (select 'x'
                         from attributi_componente
                        where id_componente = c.id_componente
                          and to_char(assegnazione_prevalente) like '1%');
            end if;
         end if;
      exception
         when others then
            d_contatore := 0;
      end;
      if d_contatore <> 0 then
         d_result := s_componente_gia_pres_number;
      else
         d_result := afc_error.ok;
      end if;
      /*      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
                    ,'d_result = AFC_Error.ok or d_result < 0 on componente.esiste_componente');
      */
      return d_result;
   end; -- componente.esiste_componente
   --------------------------------------------------------------------------------
   function is_tipo_assegnazione_ok
   (
      p_id_componente      in componenti.id_componente%type
     ,p_id_attr_componente in attributi_componente.id_attr_componente%type
     ,p_tipo_assegnazione  in attributi_componente.tipo_assegnazione%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_tipo_assegnazione_ok
       DESCRIZIONE: Controlla che il tipo di assegnazione sia uguale agli altri periodi
                    di attributi relativi allo stesso componente
       NOTE:        --
      ******************************************************************************/
      d_contatore number;
      d_result    afc_error.t_error_number := afc_error.ok;
   begin
      begin
         select count(*)
           into d_contatore
           from attributi_componente a
          where id_componente = p_id_componente
            and exists
          (select 'x'
                   from attributi_componente
                  where id_componente = a.id_componente
                    and id_attr_componente <> p_id_attr_componente
                    and nvl(tipo_assegnazione, 'I') <> nvl(p_tipo_assegnazione, 'I'));
      exception
         when others then
            d_contatore := 0;
      end;
      if d_contatore <> 0 then
         d_result := s_tipo_ass_errato_number;
      else
         d_result := afc_error.ok;
      end if;
      return d_result;
   end; -- componente.is_tipo_assegnazione_ok
   --------------------------------------------------------------------------------
   function is_attributi_revisione_ok
   (
      p_ottica         in componenti.ottica%type
     ,p_revisione      in componenti.revisione_assegnazione%type
     ,p_data           in componenti.dal%type
     ,p_tipo_controllo in number default 0
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_attributi_revisione_ok
       DESCRIZIONE: Controlla che non esistano attributi istituiti o cessati con la
                    revisione indicata aventi data inizio o fine validità non congruente
                    con la data della revisione
       PARAMETRI:   Ottica
                    Revisione
                    Data revisione
                    Tipo controllo: se = 0 si controllano gli attributi istituiti, se = 1
                                    si controllano gli attributi cessati
       RITORNA:     AFC_ERROR
      ******************************************************************************/
      d_result       afc_error.t_error_number;
      d_conta_record number;
   begin
      select count(*)
        into d_conta_record
        from attributi_componente
       where ottica = p_ottica
         and ((p_tipo_controllo = 0 and revisione_assegnazione = p_revisione and
             nvl(dal, p_data) < p_data) or
             (p_tipo_controllo = 1 and revisione_cessazione = p_revisione and
             nvl(al, p_data - 1) != p_data - 1));
      if d_conta_record > 0 then
         if p_tipo_controllo = 0 then
            d_result := s_attributi_istituiti_num;
         else
            d_result := s_attributi_cessati_num;
         end if;
      else
         d_result := afc_error.ok;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on Unita_organizzativa.is_componenti_revisione_ok');
      return d_result;
   end; -- componenti.is_attributi_revisione_ok
   --------------------------------------------------------------------------------
   procedure elimina_attributi
   (
      p_id_componente          in attributi_componente.id_componente%type
     ,p_ni                     in componenti.ni%type
     ,p_denominazione          in componenti.denominazione%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        elimina_attributi.
       DESCRIZIONE: cancella tutti i record di ATTRIBUTI_COMPONENTE
                    relativi ad un id_componente
       PARAMETRI:   p_id_componente
                    p_ni
                    p_segnalazione_bloccante
                    p_segnalazione
       NOTE:        --
      ******************************************************************************/
      d_denominazione componenti.denominazione%type;
      d_errore exception;
   begin
      if p_ni is not null then
         d_denominazione := soggetti_get_descr(p_soggetto_ni  => p_ni
                                              ,p_soggetto_dal => trunc(sysdate)
                                              ,p_colonna      => 'COGNOME E NOME');
      end if;
      begin
         delete from attributi_componente where id_componente = p_id_componente;
      exception
         when others then
            if sqlcode between - 20999 and - 20900 then
               p_segnalazione := s_error_table(sqlcode);
            else
               p_segnalazione := sqlerrm;
            end if;
            raise d_errore;
      end;
   exception
      when d_errore then
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Componente: ' || d_denominazione || ' - ' ||
                                     p_segnalazione;
   end; -- Attributo_componente.elimina_attributi
   --------------------------------------------------------------------------------
   procedure annulla_attributi
   (
      p_id_componente          in attributi_componente.id_componente%type
     ,p_revisione_cessazione   in attributi_componente.revisione_cessazione%type
     ,p_al                     in attributi_componente.al%type
     ,p_al_pubb                in attributi_componente.al_pubb%type
     ,p_al_prec                in attributi_componente.al_prec%type
     ,p_data_aggiornamento     in attributi_componente.data_aggiornamento%type
     ,p_utente_aggiornamento   in attributi_componente.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        annulla_attributi.
       DESCRIZIONE: aggiorna la revisione cessazione di tutti i record
                    di ATTRIBUTI_COMPONENTE relativi ad un id_componente
       PARAMETRI:   p_id_compoennte
                    p_revisione_cessazione
                    p_al
                    p_data_aggiornamento
                    p_utente_aggiornamento
                    p_segnalazione_bloccante
                    p_segnalazione
       NOTE:        --
      ******************************************************************************/
      d_ni            componenti.ni%type;
      d_denominazione componenti.denominazione%type;
      d_errore exception;
   begin
      d_ni            := componente.get_ni(p_id_componente);
      d_denominazione := componente.get_denominazione(p_id_componente);
      if d_ni is not null then
         d_denominazione := soggetti_get_descr(p_soggetto_ni  => d_ni
                                              ,p_soggetto_dal => trunc(sysdate)
                                              ,p_colonna      => 'COGNOME E NOME');
      end if;
      begin
         update attributi_componente a1
            set a1.revisione_cessazione = p_revisione_cessazione
               ,a1.al                   = p_al
               ,a1.al_pubb              = p_al_pubb
               ,a1.al_prec              = p_al_prec
               ,a1.data_aggiornamento   = p_data_aggiornamento
               ,a1.utente_aggiornamento = p_utente_aggiornamento
          where a1.id_componente = p_id_componente
            and a1.dal = (select max(a2.dal)
                            from attributi_componente a2
                           where a2.id_componente = p_id_componente);
      exception
         when others then
            if sqlcode between - 20999 and - 20900 then
               p_segnalazione := s_error_table(sqlcode);
            else
               p_segnalazione := sqlerrm;
            end if;
            raise d_errore;
      end;
   exception
      when d_errore then
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Componente: ' || d_denominazione || ' - ' ||
                                     p_segnalazione;
   end; -- Attributo_componente.annulla_attributi
   --------------------------------------------------------------------------------
   procedure aggiorna_attributi
   (
      p_id_componente          in attributi_componente.id_componente%type
     ,p_revisione_assegnazione in attributi_componente.revisione_cessazione%type
     ,p_dal                    in attributi_componente.dal%type
     ,p_dal_pubb               in attributi_componente.dal_pubb%type
     ,p_data_aggiornamento     in attributi_componente.data_aggiornamento%type
     ,p_utente_aggiornamento   in attributi_componente.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        aggiorna_attributi.
       DESCRIZIONE: aggiorna la revisione assegnazione di tutti i record
                    di ATTRIBUTI_COMPONENTE relativi ad un id_componente
       PARAMETRI:   p_id_componente
                    p_revisione_assegnazione
                    p_dal
                    p_data_aggiornamento
                    p_utente_aggiornamento
                    p_segnalazione_bloccante
                    p_segnalazione
       NOTE:        --
      ******************************************************************************/
      d_ni            componenti.ni%type;
      d_denominazione componenti.denominazione%type;
      d_errore exception;
   begin
      d_ni            := componente.get_ni(p_id_componente);
      d_denominazione := componente.get_denominazione(p_id_componente);
      if d_ni is not null then
         d_denominazione := soggetti_get_descr(p_soggetto_ni  => d_ni
                                              ,p_soggetto_dal => trunc(sysdate)
                                              ,p_colonna      => 'COGNOME E NOME');
      end if;
      begin
         update attributi_componente a1
            set a1.revisione_assegnazione = p_revisione_assegnazione
               ,a1.dal                    = p_dal
               ,a1.dal_pubb               = p_dal_pubb
               ,a1.data_aggiornamento     = p_data_aggiornamento
               ,a1.utente_aggiornamento   = p_utente_aggiornamento
          where a1.id_componente = p_id_componente
            and nvl(a1.dal, to_date(2222222, 'j')) =
                (select min(nvl(a2.dal, to_date(2222222, 'j')))
                   from attributi_componente a2
                  where a2.id_componente = p_id_componente);
      exception
         when others then
            if sqlcode between - 20999 and - 20900 then
               p_segnalazione := s_error_table(sqlcode);
            else
               p_segnalazione := sqlerrm;
            end if;
            raise d_errore;
      end;
   exception
      when d_errore then
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Componente: ' || d_denominazione || ' - ' ||
                                     p_segnalazione;
   end; -- Attributo_componente.aggiorna_attributi
   --------------------------------------------------------------------------------
   procedure duplica_attributi
   (
      p_old_id_componente      in attributi_componente.id_componente%type
     ,p_new_id_componente      in attributi_componente.id_componente%type
     ,p_revisione              in attributi_componente.revisione_cessazione%type
     ,p_revisione_cessazione   in attributi_componente.revisione_cessazione%type
     ,p_dal                    in attributi_componente.dal%type
     ,p_al                     in attributi_componente.al%type
     ,p_data_aggiornamento     in attributi_componente.data_aggiornamento%type
     ,p_utente_aggiornamento   in attributi_componente.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        duplica_attributi.
       DESCRIZIONE: duplica tutti i record validi di ATTRIBUTI_COMPONENTE
                    relativi ad un id_componente
       PARAMETRI:   p_id_compoennte
                    p_revisione_cessazione
                    p_al
                    p_data_aggiornamento
                    p_utente_aggiornamento
                    p_segnalazione_bloccante
                    p_segnalazione
       NOTE:        --
      ******************************************************************************/
      d_ni            componenti.ni%type;
      d_denominazione componenti.denominazione%type;
      d_id_atco       attributi_componente.id_attr_componente%type;
      d_errore exception;
   begin
      d_ni            := componente.get_ni(p_old_id_componente);
      d_denominazione := componente.get_denominazione(p_old_id_componente);
      --
      if d_ni is not null then
         d_denominazione := soggetti_get_descr(p_soggetto_ni  => d_ni
                                              ,p_soggetto_dal => trunc(sysdate)
                                              ,p_colonna      => 'COGNOME E NOME');
      end if;
      --
      begin
         select id_attr_componente
           into d_id_atco
           from attributi_componente
          where id_componente = p_old_id_componente
            and dal = (select max(dal)
                         from attributi_componente
                        where id_componente = p_old_id_componente);
      exception
         when no_data_found then
            d_id_atco := null;
      end;
      --
      if d_id_atco is null then
         begin
            insert into attributi_componente
               (id_attr_componente
               ,id_componente
               ,dal
               ,al
               ,incarico
               ,telefono
               ,fax
               ,e_mail
               ,assegnazione_prevalente
               ,percentuale_impiego
               ,ottica
               ,revisione_assegnazione
               ,revisione_cessazione
               ,utente_aggiornamento
               ,data_aggiornamento)
               select null
                     ,p_new_id_componente
                     ,p_dal
                     ,p_al
                     ,incarico
                     ,telefono
                     ,fax
                     ,e_mail
                     ,assegnazione_prevalente
                     ,percentuale_impiego
                     ,ottica
                     ,p_revisione
                     ,null
                     ,p_utente_aggiornamento
                     ,p_data_aggiornamento
                 from attributi_componente a
                where id_componente = p_old_id_componente
                  and dal = (select max(dal)
                               from attributi_componente b
                              where b.id_componente = p_old_id_componente);
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
         begin
            update attributi_componente a
               set (incarico
                  ,telefono
                  ,fax
                  ,e_mail
                  ,assegnazione_prevalente
                  ,tipo_assegnazione
                  ,percentuale_impiego
                  ,revisione_assegnazione
                  ,revisione_cessazione
                  ,utente_aggiornamento
                  ,data_aggiornamento) =
                   (select incarico
                          ,telefono
                          ,fax
                          ,e_mail
                          ,assegnazione_prevalente
                          ,tipo_assegnazione
                          ,percentuale_impiego
                          ,p_revisione
                          ,p_revisione_cessazione --null #380
                          ,utente_aggiornamento
                          ,data_aggiornamento
                      from attributi_componente
                     where id_attr_componente = d_id_atco)
             where id_componente = p_new_id_componente;
            -- aggiornamento attributi degli eventuali componenti derivati #208
            begin
               for otti_der in (select o.ottica
                                      ,(select id_componente
                                          from componenti
                                         where ottica = o.ottica
                                           and (ni, progr_unita_organizzativa, dal) =
                                               (select ni
                                                      ,progr_unita_organizzativa
                                                      ,dal
                                                  from componenti
                                                 where id_componente = m.id_componente)
                                           and ottica = o.ottica) id_componente_der
                                      ,(select id_attr_componente
                                          from attributi_componente a
                                         where id_componente = m.id_componente
                                           and dal =
                                               (select max(dal)
                                                  from attributi_componente
                                                 where id_componente = m.id_componente
                                                   and dal <=
                                                       nvl(al, to_date(3333333, 'j')))) incarico_der
                                  from ottiche              o
                                      ,modifiche_componenti m
                                 where m.ottica = o.ottica_origine
                                   and o.aggiornamento_componenti = 'A'
                                   and m.operazione = 'S'
                                   and m.id_componente = p_new_id_componente
                                 order by o.ottica)
               loop
                  update attributi_componente a
                     set incarico           =
                         (select incarico
                            from attributi_componente
                           where id_attr_componente = otti_der.incarico_der)
                        ,percentuale_impiego = 100
                   where id_componente = otti_der.id_componente_der;
               end loop;
            exception
               when others then
                  null;
            end;
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
   exception
      when d_errore then
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Componente: ' || d_denominazione || ' - ' ||
                                     p_segnalazione;
   end; -- Attributo_componente.duplica_attributi
   --------------------------------------------------------------------------------
   procedure ripristina_attributi
   (
      p_id_componente          in attributi_componente.id_componente%type
     ,p_revisione              in attributi_componente.revisione_cessazione%type
     ,p_ni                     in componenti.ni%type
     ,p_denominazione          in componenti.denominazione%type
     ,p_data_aggiornamento     in attributi_componente.data_aggiornamento%type
     ,p_utente_aggiornamento   in attributi_componente.utente_aggiornamento%type
     ,p_rev_cessazione         in number
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        ripristina_attributi.
       DESCRIZIONE: riapre i record cessati con la revisione
       PARAMETRI:   p_id_componente
                    p_revisione
                    p_ni
                    p_segnalazione_bloccante
                    p_segnalazione
       NOTE:        --
      ******************************************************************************/
      d_denominazione componenti.denominazione%type;
      d_errore exception;
   begin
      if p_ni is not null then
         d_denominazione := soggetti_get_descr(p_soggetto_ni  => p_ni
                                              ,p_soggetto_dal => trunc(sysdate)
                                              ,p_colonna      => 'COGNOME E NOME');
      end if;
      --
      begin
         update attributi_componente a1
            set a1.revisione_cessazione = decode(p_rev_cessazione
                                                ,1
                                                ,to_number(null)
                                                ,a1.revisione_cessazione)
               ,a1.al                   = al_prec --null
               ,a1.al_pubb              = null
               ,a1.utente_aggiornamento = p_utente_aggiornamento
               ,a1.data_aggiornamento   = p_data_aggiornamento
          where a1.id_componente = p_id_componente
            and a1.revisione_cessazione = p_revisione
            and a1.dal = (select max(a2.dal)
                            from attributi_componente a2
                           where id_componente = p_id_componente);
      exception
         when others then
            if sqlcode between - 20999 and - 20900 then
               p_segnalazione := s_error_table(sqlcode);
            else
               p_segnalazione := sqlerrm;
            end if;
            raise d_errore;
      end;
   exception
      when d_errore then
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Componente: ' || d_denominazione || ' - ' ||
                                     p_segnalazione;
   end; -- Attributo_componente.elimina_attributi
   --------------------------------------------------------------------------------
   procedure set_data_al
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_dal           in attributi_componente.dal%type
   ) is
      /******************************************************************************
       NOME:        set_data_al.
       DESCRIZIONE: Aggiorna data al del record inserito
       PARAMETRI:   p_id_componente
                    p_dal
       NOTE:        --
      ******************************************************************************/
      d_periodo afc_periodo.t_periodo;
   begin
      d_periodo := afc_periodo.get_seguente(p_tabella            => 'ATTRIBUTI_COMPONENTE'
                                           ,p_nome_dal           => 'DAL'
                                           ,p_nome_al            => 'AL'
                                           ,p_dal                => p_dal
                                           ,p_al                 => null
                                           ,p_campi_controllare  => '#ID_COMPONENTE#'
                                           ,p_valori_controllare => '#' || p_id_componente || '#');
      if d_periodo.dal is not null then
         update attributi_componente
            set al                   = d_periodo.dal - 1
               ,data_aggiornamento   = sysdate
               ,utente_aggiornamento = si4.utente
          where id_componente = p_id_componente
            and dal = p_dal;
      end if;
   end; -- attributo_componente.set_data_al
   --------------------------------------------------------------------------------
   procedure set_periodo_precedente
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_revisione     in attributi_componente.revisione_assegnazione%type
     ,p_dal           in attributi_componente.dal%type
     ,p_al            in attributi_componente.al%type
   ) is
      /******************************************************************************
       NOME:        set_periodo_precedente.
       DESCRIZIONE: Aggiorna data al del periodo precedente
       PARAMETRI:   p_id_componente
                    p_dal
                    p_al
       NOTE:        --
      ******************************************************************************/
   begin
      update attributi_componente a1
         set a1.revisione_cessazione = p_revisione
            ,a1.al                   = nvl(p_al, a1.al)
            ,a1.data_aggiornamento   = sysdate
            ,a1.utente_aggiornamento = si4.utente
       where a1.id_componente = p_id_componente
            -- #627 eliminato il controllo sulla data di fine
         and a1.dal =
             (select max(a2.dal)
                from attributi_componente a2
               where a2.id_componente = p_id_componente
                 and a2.dal < nvl(p_dal, to_date('31122200', 'ddmmyyyy')));
   end; -- attributo_componente.set_periodo_precedente
   --------------------------------------------------------------------------------
   procedure set_riapertura_periodo
   (
      p_id_componente in attributi_componente.id_componente%type
     ,p_revisione     in attributi_componente.revisione_assegnazione%type
     ,p_dal           in attributi_componente.dal%type
     ,p_al            in attributi_componente.al%type
   ) is
      /******************************************************************************
       NOME:        set_riapertura_periodo.
       DESCRIZIONE: Riapertura ultimo periodo
       PARAMETRI:   p_id_componente
                    p_dal
                    p_al
       NOTE:        --
      ******************************************************************************/
      d_al attributi_componente.al%type; --#685
   begin
      select min(dal) - 1
        into d_al
        from attributi_componente
       where id_componente = p_id_componente
         and dal <= nvl(al, to_date(3333333, 'j'))
         and dal > p_dal;
      update attributi_componente a1
         set a1.revisione_cessazione = null
            ,a1.al                   = d_al --#685
            ,a1.data_aggiornamento   = sysdate
            ,a1.utente_aggiornamento = si4.utente
       where a1.id_componente = p_id_componente
         and a1.dal =
             (select max(a2.dal)
                from attributi_componente a2
               where a2.id_componente = p_id_componente
                 and a2.dal < nvl(p_dal, to_date('31122200', 'ddmmyyyy')));
   end; -- attributo_componente.set_riapertura_periodo
   --------------------------------------------------------------------------------
   -- procedure di settaggio di Functional Integrity
   procedure set_fi(p_id_componente in attributi_componente.id_componente%type
                    --, p_OLD_progr_unor             in unita_organizzative.progr_unita_organizzativa%type
                    --, p_progr_unita_organizzativa  in unita_organizzative.progr_unita_organizzativa%type
                   ,p_revisione                in attributi_componente.revisione_assegnazione%type
                   ,p_old_revisione            in attributi_componente.revisione_assegnazione%type
                   ,p_revisione_cessazione     in attributi_componente.revisione_cessazione%type
                   ,p_old_revisione_cessazione in attributi_componente.revisione_cessazione%type
                   ,p_old_dal                  in attributi_componente.dal%type
                   ,p_dal                      in attributi_componente.dal%type
                   ,p_old_al                   in attributi_componente.al%type
                   ,p_al                       in attributi_componente.al%type
                   ,p_tipo_assegnazione        in attributi_componente.tipo_assegnazione%type
                   ,p_assegnazione_prevalente  in attributi_componente.assegnazione_prevalente%type
                   ,p_old_incarico             in attributi_componente.incarico%type
                   ,p_incarico                 in attributi_componente.incarico%type
                   ,p_inserting                in number
                   ,p_updating                 in number
                   ,p_deleting                 in number) is
      /******************************************************************************
       NOME:        set_FI.
       DESCRIZIONE: Procedure di settaggio Functional Integrity
       PARAMETRI:   p_id_componente
                    p_revisione
                    p_OLD_dal
                    p_dal
                    p_OLD_al
                    p_al
                    p_inserting
                    p_updating
                    p_deleting
       NOTE:        --
      ******************************************************************************/
      d_ottica                     ottiche.ottica%type;
      d_ni                         componenti.ni%type;
      d_ci                         componenti.ci%type;
      d_revisione                  revisioni_struttura.revisione%type;
      d_stato_revisione_cessazione revisioni_struttura.stato%type := 'A';
      d_stato_revisione            revisioni_struttura.stato%type;
      d_dummy                      varchar2(1);
      d_data_modifica              date := nvl(p_old_al, p_al);
      d_segnalazione_bloccante     varchar2(2);
      d_segnalazione               varchar2(2000);
   begin
      if revisione_struttura.s_attivazione = 0 then
         --#627 interveniamo sui periodi precedenti solo se sono state effettivamente modificate le date
         if p_inserting = 1 or (p_updating = 1 and (p_dal <> p_old_dal or
            nvl(p_al, to_date(3333333, 'j')) <>
            nvl(p_old_al, to_date(3333333, 'j')))) then
            -- impostazione periodo precedente al record inserito/modificato
            set_periodo_precedente(p_id_componente, p_revisione, p_dal, p_dal - 1);
         elsif p_deleting = 1 then
            set_riapertura_periodo(p_id_componente, p_revisione, p_old_dal, p_old_al);
         end if;
         --#634 attribuzione dei ruoli automatici
         if nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO'
                                              ,'AttribuzioneAutomaticaRuoli'
                                              ,0)
               ,'NO') = 'SI' and p_inserting = 1 or
            (p_updating = 1 and (p_incarico <> p_old_incarico)) then
            componente.attribuzione_ruoli(p_id_componente
                                         ,to_date(null)
                                         ,to_date(null)
                                         ,2
                                         ,d_segnalazione_bloccante
                                         ,d_segnalazione);
         end if;
      end if;
      --
      if p_inserting = 1 or (p_updating = 1 and revisione_struttura.s_attivazione <> 1) then
         begin
            select ottica
                  ,ni
                  ,ci
              into d_ottica
                  ,d_ni
                  ,d_ci
              from componenti
             where id_componente = p_id_componente;
         exception
            when others then
               raise_application_error(-20999
                                      ,'Errore in selezione dati componente - ' ||
                                       sqlerrm);
         end;
         --
         if p_revisione is not null then
            d_stato_revisione := revisione_struttura.get_stato(d_ottica, p_revisione);
         else
            d_stato_revisione := 'A';
         end if;
         --
         -- Se la modifica avviente per una revisione attiva, occorre
         -- memorizzare la revisione nulla sulla tabella MODIFICHE ASSEGNAZIONI
         --
         if d_stato_revisione = 'A' then
            d_revisione := null;
         else
            d_revisione := p_revisione;
         end if;
         --
         if p_tipo_assegnazione = 'I' and substr(p_assegnazione_prevalente, 1, 1) = '1' and
            d_stato_revisione = 'A' then
            if componente.get_revisione_cessazione(p_id_componente) is not null then
               d_stato_revisione_cessazione := nvl(revisione_struttura.get_stato(d_ottica
                                                                                ,p_revisione_cessazione)
                                                  ,'A');
            else
               d_stato_revisione_cessazione := 'A';
            end if;
            if d_stato_revisione_cessazione = 'A' and p_dal is not null and
               not
                (p_revisione_cessazione is null and p_old_revisione_cessazione is not null) then
               begin
                  select 'x'
                    into d_dummy
                    from componenti
                   where ottica = d_ottica
                     and ni = d_ni
                     and al = p_dal - 1;
                  d_data_modifica := p_dal;
               exception
                  when no_data_found then
                     d_data_modifica := p_dal;
                  when too_many_rows then
                     d_data_modifica := p_dal;
               end;
               so4gp_pkg.ins_modifiche_assegnazioni(p_ottica            => d_ottica
                                                   ,p_ni                => d_ni
                                                   ,p_ci                => d_ci
                                                   ,p_provenienza       => 'SO4'
                                                   ,p_data_modifica     => d_data_modifica
                                                   ,p_revisione_so4     => d_revisione
                                                   ,p_utente            => 'SO4'
                                                   ,p_data_acquisizione => to_date(null)
                                                   ,p_data_cessazione   => to_date(null)
                                                   ,p_data_eliminazione => to_date(null)
                                                   ,p_funzionale        => p_id_componente);
            end if;
         end if;
      end if;
   end; -- attributo_componente.set_fi
   --------------------------------------------------------------------------------
   procedure update_atco
   (
      p_ottica    in attributi_componente.ottica%type
     ,p_revisione in attributi_componente.revisione_assegnazione%type
     ,p_data      in attributi_componente.dal%type
   ) is
      /******************************************************************************
       NOME:        update_atco.
       DESCRIZIONE: procedure di aggiornamento della data di inizio e fine validità
                    al momento dell'attivazione della revisione
       PARAMETRI:   p_ottica
                    p_revisione
                    p_data
       NOTE:        --
       VERSIONE     AUTORE     DESCRIZIONE
       19/07/2012   VD         Modificata gestione revisioni retroattive:
                               aggiorna dal/al attributi movimentati
      ******************************************************************************/
      --      d_num_atco       number;
      --      d_comp_dal       date;
      --      d_comp_al        date;
      d_tipo_revisione revisioni_struttura.tipo_revisione%type;
      d_data_pubb      date;
   begin
      d_tipo_revisione := revisione_struttura.get_tipo_revisione(p_ottica, p_revisione);
      --#631
      d_data_pubb := nvl(revisione_struttura.get_data_pubblicazione(p_ottica, p_revisione)
                        ,p_data);
      if d_tipo_revisione = 'R' then
         /*elimina logicamente le registrazioni relative a componenti modificati
         che hanno decorrenza successiva alla data di decorrenza della nuova revisione*/
         update attributi_componente a
            set al                   = dal - 1 --(al minore del dal)
               ,al_pubb              = least((d_data_pubb - 1)
                                            ,nvl(al_pubb, to_date(3333333, 'j'))
                                            ,trunc(sysdate))
               ,revisione_cessazione = p_revisione
          where ottica = p_ottica
            and nvl(revisione_assegnazione, -2) <> p_revisione
            and dal > p_data
            and nvl(tipo_assegnazione, 'I') = 'I'
            and exists
          (select 'x'
                   from attributi_componente a1
                  where (nvl(revisione_assegnazione, -2) = p_revisione and
                        ottica = p_ottica and nvl(tipo_assegnazione, 'I') = 'I' and
                        id_attr_componente <> a.id_attr_componente and
                        id_componente = a.id_componente));
         /*modifica la data di termine delle registrazioni relative a componenti modificati
         con termine successivo alla data di decorrenza della nuova revisione*/
         update attributi_componente a
            set al_prec = al
               ,al      = p_data - 1
               ,al_pubb = least((d_data_pubb - 1)
                               ,nvl(al_pubb, to_date(3333333, 'j'))
                               ,trunc(sysdate))
          where ottica = p_ottica
            and revisione_assegnazione <> p_revisione
            and nvl(al, to_date(3333333, 'j')) > p_data
            and nvl(tipo_assegnazione, 'I') = 'I'
            and exists (select 'x'
                   from attributi_componente a1
                  where revisione_assegnazione = p_revisione
                    and ottica = p_ottica
                    and id_componente = a.id_componente
                    and nvl(tipo_assegnazione, 'I') = 'I');
      end if;
      for atco in (select a.*
                         ,attributo_componente.count_rows(to_char(null)
                                                         ,to_char(a.id_componente)
                                                         ,to_char(null)
                                                         ,to_char(null)
                                                         ,to_char(null)
                                                         ,to_char(null)
                                                         ,to_char(null)
                                                         ,to_char(null)
                                                         ,to_char(null)
                                                         ,to_char(null)
                                                         ,to_char(null)
                                                         ,to_char(null)
                                                         ,to_char(null)
                                                         ,to_char(null)
                                                         ,to_char(null)
                                                         ,to_char(null)
                                                         ,to_char(null)
                                                         ,to_char(null)
                                                         ,to_char(null)
                                                         ,to_char(null)
                                                         ,to_char(null)
                                                         ,to_number('')) num_atco
                         ,componente.get_dal(a.id_componente) comp_dal
                         ,componente.get_al(a.id_componente) comp_al
                     from attributi_componente a
                    where ottica = p_ottica
                      and (revisione_assegnazione = p_revisione and not exists
                           (select 'x'
                              from componenti
                             where id_componente = a.id_componente
                               and revisione_assegnazione = p_revisione))
                       or (revisione_cessazione = p_revisione and not exists
                           (select 'x'
                              from componenti
                             where id_componente = a.id_componente
                               and revisione_cessazione = p_revisione))
                    order by id_componente
                            ,dal)
      loop
         update attributi_componente
            set dal      = p_data
               ,dal_pubb = d_data_pubb --#631
          where ottica = p_ottica
            and revisione_assegnazione = p_revisione
            and id_attr_componente = atco.id_attr_componente;
         update attributi_componente
            set al      = least(nvl(al, p_data - 1), (p_data - 1)) --#631  --#500
               ,al_pubb = least(nvl(al_pubb, to_date(3333333, 'j')), (d_data_pubb - 1))
          where ottica = p_ottica
            and revisione_cessazione = p_revisione
            and id_attr_componente = atco.id_attr_componente;
      end loop;
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
   end; -- attributo_componente.set_tipo_revisione
--------------------------------------------------------------------------------
begin
   -- inserimento degli errori nella tabella
   -- s_error_table( s_<exception_name>_number ) := s_<exception_name>_msg;
   s_error_table(s_dal_al_errato_num) := s_dal_al_errato_msg;
   s_error_table(s_dal_errato_num) := s_dal_errato_msg;
   s_error_table(s_dal_errato_ins_num) := s_dal_errato_ins_msg;
   s_error_table(s_al_errato_num) := s_al_errato_msg;
   s_error_table(s_dal_minore_num) := s_dal_minore_msg;
   s_error_table(s_al_maggiore_num) := s_al_maggiore_msg;
   s_error_table(s_ass_prev_assente_num) := s_ass_prev_assente_msg;
   s_error_table(s_ass_prev_multiple_num) := s_ass_prev_multiple_msg;
   s_error_table(s_perc_impiego_errata_num) := s_perc_impiego_errata_msg;
   s_error_table(s_attr_non_eliminabile_num) := s_attr_non_eliminabile_msg;
   s_error_table(s_attributi_istituiti_num) := s_attributi_istituiti_msg;
   s_error_table(s_attributi_cessati_num) := s_attributi_cessati_msg;
   s_error_table(s_dal_gia_presente_num) := s_dal_gia_presente_msg;
   s_error_table(s_assegnazione_errata_num) := s_assegnazione_errata_msg;
   s_error_table(s_revisioni_errate_num) := s_revisioni_errate_msg;
   s_error_table(s_componente_gia_pres_number) := s_componente_gia_pres_msg;
   s_error_table(s_tipo_ass_errato_number) := s_tipo_ass_errato_msg;
   s_error_table(s_data_inizio_mancante_num) := s_data_inizio_mancante_msg;
   s_error_table(s_ass_prev_errata_num) := s_ass_prev_errata_msg;
   s_error_table(s_assegnazione_ripetuta_num) := s_assegnazione_ripetuta_msg;
   s_error_table(s_date_non_modificabili_num) := s_date_non_modificabili_msg;
end attributo_componente;
/

