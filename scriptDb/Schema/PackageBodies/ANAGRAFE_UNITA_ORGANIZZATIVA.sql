CREATE OR REPLACE package body anagrafe_unita_organizzativa is
   /******************************************************************************
    NOME:        anagrafe_unita_organizzativa
    DESCRIZIONE: Gestione tabella anagrafe_unita_organizzative.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore      Descrizione.
    000   13/09/2006  VDAVALLI    Prima emissione.
    001   02/09/2009  VDAVALLI    Modifiche per gestione master/slave
    002   07/04/2010  APASSUELLO  Modifica per aggiunta del campo note
    003   28/04/2010  VDAVALLI    Modificata function get_progr_unor per gestione
                                  revisione in modifica
    004   29/04/2010  APASSUELLO  Modifica per aggiunta di controlli sulla congruenza delle revisioni
    005   12/05/2010  APASSUELLO  Modifica per aggiunta delle functions: get_descrizione_corrente,
                                  get_codice_uo_corrente, get_id_suddivisione_corrente che NON scartano
                                  la revisione in modifica
    006   31/05/2010  APASSUELLO  Gestione del campo tipo_unita nelle procedure ins, upd, del, get_tipo_unita
    007   25/10/2010  APASSUELLO  Modifica functions get_descrizione_corrente, get_codice_uo_corrente,
                                  get_id_suddivisione_corrente per gestione di unità create con la revisione
                                  in modifica ma con DAL > SYSDATE
    008   18/11/2010  APASSUELLO  Modifica procedure set_FI per aggiunta controllo p_inserting = 1 or p_updating = 1
                                  per il calcolo dell'ottica istituzionale e per l'inserimento ins_unita_so4_gp4
    009   26/11/2010  APASSUELLO  Correzione function get_progr_unor per inserimento controllo sulla revisione in
                                  modifica (revisione_istituzione != d_revisione)
    010   20/12/2010  MMONARI     Dati Storici
    011   02/07/2012  MMONARI     Consolidamento Rel.1.4.1
    012   07/11/2012  MMONARI     Consolidamento Rel.1.4.2
    013   13/11/2012  MMONARI     Redmine bug #108
    014   05/03/2013  MMONARI     Redmine Bug #210
    015   15/03/2013  VDAVALLI    Aggiunti controlli su eliminazione record Redmine bug #224
    016   28/04/2013  ADADAMO     Aggiunta gestione della nuova colonna AGGREGATORE feature #236
          13/08/2013  ADADAMO     Aggiunto controllo di integrità su AGGREGATORE,
                                  un aggregatore può essere associato ad un sola UO
                                  in un determinato periodo (feature #236)
    017   14/02/2014  ADADAMO     Aggiunto controllo in set_dal_successivo per
                                  evitare update ridondanti Bug#361
    018   21/03/2014  VDAVALLI    Gestione nuovo campo SE_FATTURA_ELETTRONICA
    019   15/04/2014  MMONARI     Spostamento della proc. ins_unita_so4_gp4 su SO4GP_PKG #429
          28/05/2014  MMONARI     Bug #453, eliminazione upd_column
    020   16/06/2014  MMONARI     #431 Modifiche retroattive su ANUO
          13/01/2015  MMONARI     Modifiche a get_num_modifiche_uo per #558
    021   13/04/2015  ADADAMO     Modificata upd_column per conversione implicita
                                  sulle date (Bug#591)
    022   13/08/2015  MMONARI     #634 Modifiche a set_fi per attribuzione automatica ruoli
    023   04/02/2016  MM/AD       Modificata del_logica per gestire l'eliminazione di
                                  unità istituite in revisione in modifica (Bug#682)
    024   05/02/2016  ADADAMO     Modificata del_logica per aggiornare il nominativo
                                  dell'utente associato all'unità eliminata fisicamente (Bug#669)
    025   15/09/2017  MMONARI     #703 - Ripristino della logica di cancellazione normale e modifiche a ins
                                  per intercettare inserimenti di record con decorrenza gia' presente
    026   20/02/2018  ADADAMO     #811 - Aggiunta in set_fi impostazione del si4.utente di AD4
                                  per consentire la corretta inizializzazione della colonna
                                  utente_aggiornamento
          07/06/2018  MMONARI     #28708 gestione dei codici UO su CODICI_IPA
    027   03/11/2021  MMONARI     #52548 Nuovo campo CODICE_IPA
   ******************************************************************************/
   s_revisione_body constant afc.t_revision := '027';
   s_error_table    afc_error.t_error_table;
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
   end; -- anagrafe_unita_organizzativa.versione
   --------------------------------------------------------------------------------
   function pk
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return t_pk is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        PK
       DESCRIZIONE: Costruttore di un t_PK dati gli attributi della chiave
      ******************************************************************************/
      d_result t_pk;
   begin
      d_result.progr_unita_organizzativa := p_progr_unita_organizzativa;
      d_result.dal                       := p_dal;
      dbc.pre(not dbc.preon or
              canhandle(d_result.progr_unita_organizzativa, d_result.dal)
             ,'canHandle on anagrafe_unita_organizzativa.PK');
      return d_result;
   end; -- end anagrafe_unita_organizzativa.PK
   --------------------------------------------------------------------------------
   function can_handle
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
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
      if d_result = 1 and (p_progr_unita_organizzativa is null or p_dal is null) then
         d_result := 0;
      end if;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on anagrafe_unita_organizzativa.can_handle');
      return d_result;
   end; -- anagrafe_unita_organizzativa.can_handle
   --------------------------------------------------------------------------------
   function canhandle
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        canHandle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: true se la chiave e manipolabile, false altrimenti.
       NOTE:        Wrapper boolean di can_handle (cfr. can_handle).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(can_handle(p_progr_unita_organizzativa
                                                            ,p_dal));
   begin
      return d_result;
   end; -- anagrafe_unita_organizzativa.canHandle
   --------------------------------------------------------------------------------
   function exists_id
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
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
      dbc.pre(not dbc.preon or canhandle(p_progr_unita_organizzativa, p_dal)
             ,'canHandle on anagrafe_unita_organizzativa.exists_id');
      begin
         select 1
           into d_result
           from anagrafe_unita_organizzative
          where progr_unita_organizzativa = p_progr_unita_organizzativa
            and dal = p_dal;
      exception
         when no_data_found then
            d_result := 0;
      end;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on anagrafe_unita_organizzativa.exists_id');
      return d_result;
   end; -- anagrafe_unita_organizzativa.exists_id
   --------------------------------------------------------------------------------
   function existsid
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        existsId
       DESCRIZIONE: Esistenza riga con chiave indicata.
       NOTE:        Wrapper boolean di exists_id (cfr. exists_id).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(exists_id(p_progr_unita_organizzativa
                                                           ,p_dal));
   begin
      return d_result;
   end; -- anagrafe_unita_organizzativa.existsId
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
      --
      return d_result;
   end; -- anagrafe_unita_organizzativa.error_message
   --------------------------------------------------------------------------------
   procedure ins
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type default null
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
     ,p_codice_uo                 in anagrafe_unita_organizzative.codice_uo%type
     ,p_descrizione               in anagrafe_unita_organizzative.descrizione%type default null
     ,p_descrizione_al1           in anagrafe_unita_organizzative.descrizione_al1%type default null
     ,p_descrizione_al2           in anagrafe_unita_organizzative.descrizione_al2%type default null
     ,p_des_abb                   in anagrafe_unita_organizzative.des_abb%type default null
     ,p_des_abb_al1               in anagrafe_unita_organizzative.des_abb_al1%type default null
     ,p_des_abb_al2               in anagrafe_unita_organizzative.des_abb_al2%type default null
     ,p_id_suddivisione           in anagrafe_unita_organizzative.id_suddivisione%type default null
     ,p_ottica                    in anagrafe_unita_organizzative.ottica%type
     ,p_revisione_istituzione     in anagrafe_unita_organizzative.revisione_istituzione%type default null
     ,p_revisione_cessazione      in anagrafe_unita_organizzative.revisione_cessazione%type default null
     ,p_tipologia_unita           in anagrafe_unita_organizzative.tipologia_unita%type default null
     ,p_se_giuridico              in anagrafe_unita_organizzative.se_giuridico%type default null
     ,p_assegnazione_componenti   in anagrafe_unita_organizzative.assegnazione_componenti%type default null
     ,p_amministrazione           in anagrafe_unita_organizzative.amministrazione%type default null
     ,p_progr_aoo                 in anagrafe_unita_organizzative.progr_aoo%type default null
     ,p_indirizzo                 in anagrafe_unita_organizzative.indirizzo%type default null
     ,p_cap                       in anagrafe_unita_organizzative.cap%type default null
     ,p_provincia                 in anagrafe_unita_organizzative.provincia%type default null
     ,p_comune                    in anagrafe_unita_organizzative.comune%type default null
     ,p_telefono                  in anagrafe_unita_organizzative.telefono%type default null
     ,p_fax                       in anagrafe_unita_organizzative.fax%type default null
     ,p_centro                    in anagrafe_unita_organizzative.centro%type default null
     ,p_centro_responsabilita     in anagrafe_unita_organizzative.centro_responsabilita%type default null
     ,p_al                        in anagrafe_unita_organizzative.al%type default null
     ,p_utente_ad4                in anagrafe_unita_organizzative.utente_ad4%type default null
     ,p_utente_aggiornamento      in anagrafe_unita_organizzative.utente_aggiornamento%type default null
     ,p_data_aggiornamento        in anagrafe_unita_organizzative.data_aggiornamento%type default null
     ,p_note                      in anagrafe_unita_organizzative.note%type default null
     ,p_tipo_unita                in anagrafe_unita_organizzative.tipo_unita%type default null
     ,p_dal_pubb                  in anagrafe_unita_organizzative.dal_pubb%type default null
     ,p_al_pubb                   in anagrafe_unita_organizzative.al_pubb%type default null
     ,p_al_prec                   in anagrafe_unita_organizzative.al_prec%type default null
     ,p_incarico_resp             in anagrafe_unita_organizzative.incarico_resp%type default null
     ,p_etichetta                 in anagrafe_unita_organizzative.etichetta%type default null
     ,p_aggregatore               in anagrafe_unita_organizzative.aggregatore%type default null
     ,p_se_fattura_elettronica    in anagrafe_unita_organizzative.se_fattura_elettronica%type default null
     ,p_codice_ipa                in anagrafe_unita_organizzative.codice_ipa%type  default null --#52548
   ) is
      /******************************************************************************
       NOME:        ins
       DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
       PARAMETRI:   Chiavi e attributi della table.
      ******************************************************************************/
      d_dummy varchar2(1);
   begin
      begin
         --#703
         select 'x'
           into d_dummy
           from anagrafe_unita_organizzative
          where progr_unita_organizzativa = p_progr_unita_organizzativa
            and dal = p_dal;
         raise too_many_rows;
      exception
         --decorrenza non presente, normale inserimento
         when no_data_found then
            insert into anagrafe_unita_organizzative
               (progr_unita_organizzativa
               ,dal
               ,dal_pubb
               ,al_pubb
               ,al_prec
               ,codice_uo
               ,codice_ipa     --#52548
               ,descrizione
               ,descrizione_al1
               ,descrizione_al2
               ,des_abb
               ,des_abb_al1
               ,des_abb_al2
               ,id_suddivisione
               ,ottica
               ,revisione_istituzione
               ,revisione_cessazione
               ,tipologia_unita
               ,se_giuridico
               ,assegnazione_componenti
               ,amministrazione
               ,progr_aoo
               ,indirizzo
               ,cap
               ,provincia
               ,comune
               ,telefono
               ,fax
               ,centro
               ,centro_responsabilita
               ,al
               ,utente_ad4
               ,utente_aggiornamento
               ,data_aggiornamento
               ,note
               ,tipo_unita
               ,incarico_resp
               ,etichetta
               ,aggregatore
               ,se_fattura_elettronica)
            values
               (p_progr_unita_organizzativa
               ,p_dal
               ,p_dal_pubb
               ,p_al_pubb
               ,p_al_prec
               ,p_codice_uo
               ,p_codice_ipa     --#52548
               ,p_descrizione
               ,p_descrizione_al1
               ,p_descrizione_al2
               ,p_des_abb
               ,p_des_abb_al1
               ,p_des_abb_al2
               ,p_id_suddivisione
               ,p_ottica
               ,p_revisione_istituzione
               ,p_revisione_cessazione
               ,p_tipologia_unita
               ,p_se_giuridico
               ,p_assegnazione_componenti
               ,p_amministrazione
               ,p_progr_aoo
               ,p_indirizzo
               ,p_cap
               ,p_provincia
               ,p_comune
               ,p_telefono
               ,p_fax
               ,p_centro
               ,p_centro_responsabilita
               ,p_al
               ,p_utente_ad4
               ,p_utente_aggiornamento
               ,p_data_aggiornamento
               ,p_note
               ,p_tipo_unita
               ,p_incarico_resp
               ,p_etichetta
               ,p_aggregatore
               ,p_se_fattura_elettronica);
         when too_many_rows then
            --decorrenza già presente, eseguo l'update del record e di quelli successivi
            update anagrafe_unita_organizzative
               set codice_uo               = codice_uo
                  ,codice_ipa              = p_codice_ipa
                  ,descrizione             = p_descrizione
                  ,descrizione_al1         = p_descrizione_al1
                  ,descrizione_al2         = p_descrizione_al2
                  ,des_abb                 = p_des_abb
                  ,des_abb_al1             = p_des_abb_al1
                  ,des_abb_al2             = p_des_abb_al2
                  ,id_suddivisione         = p_id_suddivisione
                  ,ottica                  = p_ottica
                  ,revisione_istituzione   = p_revisione_istituzione
                  ,revisione_cessazione    = p_revisione_cessazione
                  ,tipologia_unita         = p_tipologia_unita
                  ,se_giuridico            = p_se_giuridico
                  ,assegnazione_componenti = p_assegnazione_componenti
                  ,amministrazione         = p_amministrazione
                  ,progr_aoo               = p_progr_aoo
                  ,indirizzo               = p_indirizzo
                  ,cap                     = p_cap
                  ,provincia               = p_provincia
                  ,comune                  = p_comune
                  ,telefono                = p_telefono
                  ,fax                     = p_fax
                  ,centro                  = p_centro
                  ,centro_responsabilita   = p_centro_responsabilita
                  ,al                      = p_al
                  ,utente_ad4              = p_utente_ad4
                  ,utente_aggiornamento    = p_utente_aggiornamento
                  ,data_aggiornamento      = p_data_aggiornamento
                  ,note                    = p_note
                  ,tipo_unita              = p_tipo_unita
                  ,incarico_resp           = p_incarico_resp
                  ,etichetta               = p_etichetta
                  ,aggregatore             = p_aggregatore
                  ,se_fattura_elettronica  = se_fattura_elettronica
             where progr_unita_organizzativa = p_progr_unita_organizzativa
               and dal >= p_dal
               and dal <= nvl(al, to_date(3333333, 'j'));
      end;
   end; -- anagrafe_unita_organizzativa.ins
   --------------------------------------------------------------------------------
   procedure ins_anue --#431
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type default null
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
     ,p_codice_uo                 in anagrafe_unita_organizzative.codice_uo%type
     ,p_descrizione               in anagrafe_unita_organizzative.descrizione%type default null
     ,p_descrizione_al1           in anagrafe_unita_organizzative.descrizione_al1%type default null
     ,p_descrizione_al2           in anagrafe_unita_organizzative.descrizione_al2%type default null
     ,p_des_abb                   in anagrafe_unita_organizzative.des_abb%type default null
     ,p_des_abb_al1               in anagrafe_unita_organizzative.des_abb_al1%type default null
     ,p_des_abb_al2               in anagrafe_unita_organizzative.des_abb_al2%type default null
     ,p_id_suddivisione           in anagrafe_unita_organizzative.id_suddivisione%type default null
     ,p_ottica                    in anagrafe_unita_organizzative.ottica%type
     ,p_revisione_istituzione     in anagrafe_unita_organizzative.revisione_istituzione%type default null
     ,p_revisione_cessazione      in anagrafe_unita_organizzative.revisione_cessazione%type default null
     ,p_tipologia_unita           in anagrafe_unita_organizzative.tipologia_unita%type default null
     ,p_se_giuridico              in anagrafe_unita_organizzative.se_giuridico%type default null
     ,p_assegnazione_componenti   in anagrafe_unita_organizzative.assegnazione_componenti%type default null
     ,p_amministrazione           in anagrafe_unita_organizzative.amministrazione%type default null
     ,p_progr_aoo                 in anagrafe_unita_organizzative.progr_aoo%type default null
     ,p_indirizzo                 in anagrafe_unita_organizzative.indirizzo%type default null
     ,p_cap                       in anagrafe_unita_organizzative.cap%type default null
     ,p_provincia                 in anagrafe_unita_organizzative.provincia%type default null
     ,p_comune                    in anagrafe_unita_organizzative.comune%type default null
     ,p_telefono                  in anagrafe_unita_organizzative.telefono%type default null
     ,p_fax                       in anagrafe_unita_organizzative.fax%type default null
     ,p_centro                    in anagrafe_unita_organizzative.centro%type default null
     ,p_centro_responsabilita     in anagrafe_unita_organizzative.centro_responsabilita%type default null
     ,p_al                        in anagrafe_unita_organizzative.al%type default null
     ,p_utente_ad4                in anagrafe_unita_organizzative.utente_ad4%type default null
     ,p_utente_aggiornamento      in anagrafe_unita_organizzative.utente_aggiornamento%type default null
     ,p_data_aggiornamento        in anagrafe_unita_organizzative.data_aggiornamento%type default null
     ,p_note                      in anagrafe_unita_organizzative.note%type default null
     ,p_tipo_unita                in anagrafe_unita_organizzative.tipo_unita%type default null
     ,p_dal_pubb                  in anagrafe_unita_organizzative.dal_pubb%type default null
     ,p_al_pubb                   in anagrafe_unita_organizzative.al_pubb%type default null
     ,p_al_prec                   in anagrafe_unita_organizzative.al_prec%type default null
     ,p_incarico_resp             in anagrafe_unita_organizzative.incarico_resp%type default null
     ,p_etichetta                 in anagrafe_unita_organizzative.etichetta%type default null
     ,p_aggregatore               in anagrafe_unita_organizzative.aggregatore%type default null
     ,p_se_fattura_elettronica    in anagrafe_unita_organizzative.se_fattura_elettronica%type default null
   ) is
      /******************************************************************************
       NOME:        ins_anue
       DESCRIZIONE: Inserimento di una riga su ANAGRAFE_UNITA_ELIMINATE per registrare le cancellazioni logiche
       PARAMETRI:   Chiavi e attributi della table.
      ******************************************************************************/
   begin
      insert into anagrafe_unita_organizzative --#703
         (progr_unita_organizzativa
         ,dal
         ,dal_pubb
         ,al_pubb
         ,al_prec
         ,codice_uo
         ,descrizione
         ,descrizione_al1
         ,descrizione_al2
         ,des_abb
         ,des_abb_al1
         ,des_abb_al2
         ,id_suddivisione
         ,ottica
         ,revisione_istituzione
         ,revisione_cessazione
         ,tipologia_unita
         ,se_giuridico
         ,assegnazione_componenti
         ,amministrazione
         ,progr_aoo
         ,indirizzo
         ,cap
         ,provincia
         ,comune
         ,telefono
         ,fax
         ,centro
         ,centro_responsabilita
         ,al
         ,utente_ad4
         ,utente_aggiornamento
         ,data_aggiornamento
         ,note
         ,tipo_unita
         ,incarico_resp
         ,etichetta
         ,aggregatore
         ,se_fattura_elettronica)
      values
         (p_progr_unita_organizzativa
         ,p_dal
         ,p_dal_pubb
         ,p_al_pubb
         ,p_al_prec
         ,p_codice_uo
         ,p_descrizione
         ,p_descrizione_al1
         ,p_descrizione_al2
         ,p_des_abb
         ,p_des_abb_al1
         ,p_des_abb_al2
         ,p_id_suddivisione
         ,p_ottica
         ,p_revisione_istituzione
         ,p_revisione_cessazione
         ,p_tipologia_unita
         ,p_se_giuridico
         ,p_assegnazione_componenti
         ,p_amministrazione
         ,p_progr_aoo
         ,p_indirizzo
         ,p_cap
         ,p_provincia
         ,p_comune
         ,p_telefono
         ,p_fax
         ,p_centro
         ,p_centro_responsabilita
         ,p_al
         ,p_utente_ad4
         ,p_utente_aggiornamento
         ,p_data_aggiornamento
         ,p_note
         ,p_tipo_unita
         ,p_incarico_resp
         ,p_etichetta
         ,p_aggregatore
         ,p_se_fattura_elettronica);
   end; -- anagrafe_unita_organizzativa.ins_anue
   --------------------------------------------------------------------------------
   procedure upd
   (
      p_new_progr_unita_org         in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_new_dal                     in anagrafe_unita_organizzative.dal%type
     ,p_new_dal_pubb                in anagrafe_unita_organizzative.dal_pubb%type
     ,p_new_al_pubb                 in anagrafe_unita_organizzative.al_pubb%type
     ,p_new_al_prec                 in anagrafe_unita_organizzative.al_prec%type
     ,p_new_codice_uo               in anagrafe_unita_organizzative.codice_uo%type
     ,p_new_descrizione             in anagrafe_unita_organizzative.descrizione%type
     ,p_new_descrizione_al1         in anagrafe_unita_organizzative.descrizione_al1%type
     ,p_new_descrizione_al2         in anagrafe_unita_organizzative.descrizione_al2%type
     ,p_new_des_abb                 in anagrafe_unita_organizzative.des_abb%type
     ,p_new_des_abb_al1             in anagrafe_unita_organizzative.des_abb_al1%type
     ,p_new_des_abb_al2             in anagrafe_unita_organizzative.des_abb_al2%type
     ,p_new_id_suddivisione         in anagrafe_unita_organizzative.id_suddivisione%type
     ,p_new_ottica                  in anagrafe_unita_organizzative.ottica%type
     ,p_new_revisione_istituzione   in anagrafe_unita_organizzative.revisione_istituzione%type
     ,p_new_revisione_cessazione    in anagrafe_unita_organizzative.revisione_cessazione%type
     ,p_new_tipologia_unita         in anagrafe_unita_organizzative.tipologia_unita%type
     ,p_new_se_giuridico            in anagrafe_unita_organizzative.se_giuridico%type
     ,p_new_assegnazione_componenti in anagrafe_unita_organizzative.assegnazione_componenti%type
     ,p_new_amministrazione         in anagrafe_unita_organizzative.amministrazione%type
     ,p_new_progr_aoo               in anagrafe_unita_organizzative.progr_aoo%type
     ,p_new_indirizzo               in anagrafe_unita_organizzative.indirizzo%type default null
     ,p_new_cap                     in anagrafe_unita_organizzative.cap%type default null
     ,p_new_provincia               in anagrafe_unita_organizzative.provincia%type default null
     ,p_new_comune                  in anagrafe_unita_organizzative.comune%type default null
     ,p_new_telefono                in anagrafe_unita_organizzative.telefono%type default null
     ,p_new_fax                     in anagrafe_unita_organizzative.fax%type default null
     ,p_new_centro                  in anagrafe_unita_organizzative.centro%type
     ,p_new_centro_responsabilita   in anagrafe_unita_organizzative.centro_responsabilita%type
     ,p_new_al                      in anagrafe_unita_organizzative.al%type
     ,p_new_utente_ad4              in anagrafe_unita_organizzative.utente_ad4%type
     ,p_new_utente_aggiornamento    in anagrafe_unita_organizzative.utente_aggiornamento%type
     ,p_new_data_aggiornamento      in anagrafe_unita_organizzative.data_aggiornamento%type
     ,p_new_note                    in anagrafe_unita_organizzative.note%type default null
     ,p_new_tipo_unita              in anagrafe_unita_organizzative.tipo_unita%type default null
     ,p_new_incarico_resp           in anagrafe_unita_organizzative.incarico_resp%type default null
     ,p_new_etichetta               in anagrafe_unita_organizzative.etichetta%type default null
     ,p_new_aggregatore             in anagrafe_unita_organizzative.aggregatore%type default null
     ,p_new_se_fattura_elettronica  in anagrafe_unita_organizzative.se_fattura_elettronica%type default null
     ,p_old_progr_unita_org         in anagrafe_unita_organizzative.progr_unita_organizzativa%type default null
     ,p_old_dal                     in anagrafe_unita_organizzative.dal%type default null
     ,p_old_dal_pubb                in anagrafe_unita_organizzative.dal_pubb%type
     ,p_old_al_pubb                 in anagrafe_unita_organizzative.al_pubb%type
     ,p_old_al_prec                 in anagrafe_unita_organizzative.al_prec%type
     ,p_old_codice_uo               in anagrafe_unita_organizzative.codice_uo%type default null
     ,p_old_descrizione             in anagrafe_unita_organizzative.descrizione%type default null
     ,p_old_descrizione_al1         in anagrafe_unita_organizzative.descrizione_al1%type default null
     ,p_old_descrizione_al2         in anagrafe_unita_organizzative.descrizione_al2%type default null
     ,p_old_des_abb                 in anagrafe_unita_organizzative.des_abb%type default null
     ,p_old_des_abb_al1             in anagrafe_unita_organizzative.des_abb_al1%type default null
     ,p_old_des_abb_al2             in anagrafe_unita_organizzative.des_abb_al2%type default null
     ,p_old_id_suddivisione         in anagrafe_unita_organizzative.id_suddivisione%type default null
     ,p_old_ottica                  in anagrafe_unita_organizzative.ottica%type default null
     ,p_old_revisione_istituzione   in anagrafe_unita_organizzative.revisione_istituzione%type default null
     ,p_old_revisione_cessazione    in anagrafe_unita_organizzative.revisione_cessazione%type default null
     ,p_old_tipologia_unita         in anagrafe_unita_organizzative.tipologia_unita%type default null
     ,p_old_se_giuridico            in anagrafe_unita_organizzative.se_giuridico%type default null
     ,p_old_assegnazione_componenti in anagrafe_unita_organizzative.assegnazione_componenti%type default null
     ,p_old_amministrazione         in anagrafe_unita_organizzative.amministrazione%type default null
     ,p_old_progr_aoo               in anagrafe_unita_organizzative.progr_aoo%type default null
     ,p_old_indirizzo               in anagrafe_unita_organizzative.indirizzo%type default null
     ,p_old_cap                     in anagrafe_unita_organizzative.cap%type default null
     ,p_old_provincia               in anagrafe_unita_organizzative.provincia%type default null
     ,p_old_comune                  in anagrafe_unita_organizzative.comune%type default null
     ,p_old_telefono                in anagrafe_unita_organizzative.telefono%type default null
     ,p_old_fax                     in anagrafe_unita_organizzative.fax%type default null
     ,p_old_centro                  in anagrafe_unita_organizzative.centro%type default null
     ,p_old_centro_responsabilita   in anagrafe_unita_organizzative.centro_responsabilita%type default null
     ,p_old_al                      in anagrafe_unita_organizzative.al%type default null
     ,p_old_utente_ad4              in anagrafe_unita_organizzative.utente_ad4%type default null
     ,p_old_utente_aggiornamento    in anagrafe_unita_organizzative.utente_aggiornamento%type default null
     ,p_old_data_aggiornamento      in anagrafe_unita_organizzative.data_aggiornamento%type default null
     ,p_old_note                    in anagrafe_unita_organizzative.note%type default null
     ,p_old_tipo_unita              in anagrafe_unita_organizzative.tipo_unita%type default null
     ,p_old_incarico_resp           in anagrafe_unita_organizzative.incarico_resp%type default null
     ,p_old_etichetta               in anagrafe_unita_organizzative.etichetta%type default null
     ,p_old_aggregatore             in anagrafe_unita_organizzative.aggregatore%type default null
     ,p_old_se_fattura_elettronica  in anagrafe_unita_organizzative.se_fattura_elettronica%type default null
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
               ((p_old_codice_uo is not null or p_old_descrizione is not null or
               p_old_descrizione_al1 is not null or p_old_descrizione_al2 is not null or
               p_old_des_abb is not null or p_old_des_abb_al1 is not null or
               p_old_des_abb_al2 is not null or p_old_id_suddivisione is not null or
               p_old_ottica is not null or p_old_revisione_istituzione is not null or
               p_old_revisione_cessazione is not null or
               p_old_tipologia_unita is not null or p_old_se_giuridico is not null or
               p_old_assegnazione_componenti is not null or
               p_old_amministrazione is not null or p_old_progr_aoo is not null or
               p_old_indirizzo is not null or p_old_cap is not null or
               p_old_provincia is not null or p_old_comune is not null or
               p_old_telefono is not null or p_old_fax is not null or
               p_old_centro is not null or p_old_centro_responsabilita is not null or
               p_old_al is not null or p_old_utente_ad4 is not null or
               p_old_utente_aggiornamento is not null or
               p_old_data_aggiornamento is not null or p_old_note is not null or
               p_old_tipo_unita is not null or p_old_incarico_resp is not null or
               p_old_dal_pubb is not null or p_old_al_pubb is not null or
               p_old_al_prec is not null or p_old_etichetta is not null or
               p_old_aggregatore is not null or
               p_old_se_fattura_elettronica is not null) and p_check_old = 0)
             ,' <OLD values> is not null on anagrafe_unita_organizzativa.upd');
      dbc.pre(not dbc.preon or p_check_old is not null
             ,'p_check_OLD is not null on anagrafe_unita_organizzativa.upd');
      d_key := pk(nvl(p_old_progr_unita_org, p_new_progr_unita_org)
                 ,nvl(p_old_dal, p_new_dal));
      dbc.pre(not dbc.preon or existsid(d_key.progr_unita_organizzativa, d_key.dal)
             ,'existsId on anagrafe_unita_organizzativa.upd');
      update anagrafe_unita_organizzative
         set progr_unita_organizzativa = p_new_progr_unita_org
            ,dal                       = p_new_dal
            ,codice_uo                 = p_new_codice_uo
            ,descrizione               = p_new_descrizione
            ,descrizione_al1           = p_new_descrizione_al1
            ,descrizione_al2           = p_new_descrizione_al2
            ,des_abb                   = p_new_des_abb
            ,des_abb_al1               = p_new_des_abb_al1
            ,des_abb_al2               = p_new_des_abb_al2
            ,id_suddivisione           = p_new_id_suddivisione
            ,ottica                    = p_new_ottica
            ,revisione_istituzione     = p_new_revisione_istituzione
            ,revisione_cessazione      = p_new_revisione_cessazione
            ,tipologia_unita           = p_new_tipologia_unita
            ,se_giuridico              = p_new_se_giuridico
            ,assegnazione_componenti   = p_new_assegnazione_componenti
            ,amministrazione           = p_new_amministrazione
            ,progr_aoo                 = p_new_progr_aoo
            ,indirizzo                 = p_new_indirizzo
            ,cap                       = p_new_cap
            ,provincia                 = p_new_provincia
            ,comune                    = p_new_comune
            ,telefono                  = p_new_telefono
            ,fax                       = p_new_fax
            ,centro                    = p_new_centro
            ,centro_responsabilita     = p_new_centro_responsabilita
            ,al                        = p_new_al
            ,utente_ad4                = p_new_utente_ad4
            ,utente_aggiornamento      = p_new_utente_aggiornamento
            ,data_aggiornamento        = p_new_data_aggiornamento
            ,note                      = p_new_note
            ,tipo_unita                = p_new_tipo_unita
            ,incarico_resp             = p_new_incarico_resp
            ,etichetta                 = p_new_etichetta
            ,aggregatore               = p_new_aggregatore
            ,dal_pubb                  = p_new_dal_pubb
            ,al_pubb                   = p_new_al_pubb
            ,al_prec                   = p_new_al_prec
            ,se_fattura_elettronica    = p_new_se_fattura_elettronica
       where progr_unita_organizzativa = d_key.progr_unita_organizzativa
         and dal = d_key.dal
         and (p_check_old = 0 or
             p_check_old = 1 and (codice_uo = p_old_codice_uo or
             codice_uo is null and p_old_codice_uo is null) and
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
             (id_suddivisione = p_old_id_suddivisione or
             id_suddivisione is null and p_old_id_suddivisione is null) and
             (ottica = p_old_ottica or ottica is null and p_old_ottica is null) and
             (revisione_istituzione = p_old_revisione_istituzione or
             revisione_istituzione is null and p_old_revisione_istituzione is null) and
             (revisione_cessazione = p_old_revisione_cessazione or
             revisione_cessazione is null and p_old_revisione_cessazione is null) and
             (tipologia_unita = p_old_tipologia_unita or
             tipologia_unita is null and p_old_tipologia_unita is null) and
             (se_giuridico = p_old_se_giuridico or
             se_giuridico is null and p_old_se_giuridico is null) and
             (assegnazione_componenti = p_old_assegnazione_componenti or
             assegnazione_componenti is null and p_old_assegnazione_componenti is null) and
             (amministrazione = p_old_amministrazione or
             amministrazione is null and p_old_amministrazione is null) and
             (progr_aoo = p_old_progr_aoo or
             progr_aoo is null and p_old_progr_aoo is null) and
             (indirizzo = p_old_indirizzo or
             indirizzo is null and p_old_indirizzo is null) and
             (cap = p_old_cap or cap is null and p_old_cap is null) and
             (provincia = p_old_provincia or
             provincia is null and p_old_provincia is null) and
             (comune = p_old_comune or comune is null and p_old_comune is null) and
             (telefono = p_old_telefono or telefono is null and p_old_telefono is null) and
             (fax = p_old_fax or fax is null and p_old_fax is null) and
             (centro = p_old_centro or centro is null and p_old_centro is null) and
             (centro_responsabilita = p_old_centro_responsabilita or
             centro_responsabilita is null and p_old_centro_responsabilita is null) and
             (al = p_old_al or al is null and p_old_al is null) and
             (utente_ad4 = p_old_utente_ad4 or
             utente_ad4 is null and p_old_utente_ad4 is null) and
             (utente_aggiornamento = p_old_utente_aggiornamento or
             utente_aggiornamento is null and p_old_utente_aggiornamento is null) and
             (data_aggiornamento = p_old_data_aggiornamento or
             data_aggiornamento is null and p_old_data_aggiornamento is null) and
             (note = p_old_note or note is null and p_old_note is null) and
             (tipo_unita = p_old_tipo_unita or
             tipo_unita is null and p_old_tipo_unita is null) and
             (incarico_resp = p_old_incarico_resp or
             incarico_resp is null and p_old_incarico_resp is null) and
             (etichetta = p_old_etichetta or
             etichetta is null and p_old_etichetta is null) and
             (aggregatore = p_old_aggregatore or
             aggregatore is null and p_old_aggregatore is null) and
             (dal_pubb = p_old_dal_pubb or dal_pubb is null and p_old_dal_pubb is null) and
             (al_pubb = p_old_al_pubb or al_pubb is null and p_old_al_pubb is null) and
             (al_prec = p_old_al_prec or al_prec is null and p_old_al_prec is null) and
             (se_fattura_elettronica = p_old_se_fattura_elettronica or
             p_old_se_fattura_elettronica is null));
      d_row_found := sql%rowcount;
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on anagrafe_unita_organizzativa.upd');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   end; -- anagrafe_unita_organizzativa.upd
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
     ,p_column                    in varchar2
     ,p_value                     in varchar2 default null
     ,p_literal_value             in number default 1
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
        d_value   varchar2(2000);
   begin
      -- modificata da AD 02/07/2018
      if p_literal_value = 1 then
        -- d_literal := '''';
        d_value := afc.quote(p_value);
      else
        d_value := p_value;
      end if;
      d_statement := 'begin ' || '   update anagrafe_unita_organizzative' || '   set    ' ||
                     p_column || ' = ' ||d_value|| --|| d_literal || p_value || d_literal ||
                     '   where  progr_unita_organizzativa = ''' ||
                     p_progr_unita_organizzativa || '''' || '   and    dal = to_date( ''' || -- cambiata
                     to_char(p_dal, 'dd/mm/yyyy') || ''',''dd/mm/yyyy'')' || -- cambiata
                     '   ;' || 'end;';
      afc.sql_execute(d_statement);
   end; -- anagrafe_unita_organizzativa.upd_column
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
     ,p_column                    in varchar2
     ,p_value                     in date
   ) is
      /******************************************************************************
       NOME:        upd_column
       DESCRIZIONE: Aggiornamento del campo p_column col valore p_value.
       NOTE:        Richiama se stessa con il parametro date convertito in stringa.
      ******************************************************************************/
      d_data varchar2(19);
   begin
      d_data := to_char(p_value, afc.date_format);
      upd_column(p_progr_unita_organizzativa
                ,p_dal
                ,p_column
                ,'to_date( ''' || d_data || ''', ''' || afc.date_format || ''' )'
                ,0);
   end; -- anagrafe_unita_organizzativa.upd_column
   --------------------------------------------------------------------------------
   procedure del
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
     ,p_codice_uo                 in anagrafe_unita_organizzative.codice_uo%type default null
     ,p_descrizione               in anagrafe_unita_organizzative.descrizione%type default null
     ,p_descrizione_al1           in anagrafe_unita_organizzative.descrizione_al1%type default null
     ,p_descrizione_al2           in anagrafe_unita_organizzative.descrizione_al2%type default null
     ,p_des_abb                   in anagrafe_unita_organizzative.des_abb%type default null
     ,p_des_abb_al1               in anagrafe_unita_organizzative.des_abb_al1%type default null
     ,p_des_abb_al2               in anagrafe_unita_organizzative.des_abb_al2%type default null
     ,p_id_suddivisione           in anagrafe_unita_organizzative.id_suddivisione%type default null
     ,p_ottica                    in anagrafe_unita_organizzative.ottica%type default null
     ,p_revisione_istituzione     in anagrafe_unita_organizzative.revisione_istituzione%type default null
     ,p_revisione_cessazione      in anagrafe_unita_organizzative.revisione_cessazione%type default null
     ,p_tipologia_unita           in anagrafe_unita_organizzative.tipologia_unita%type default null
     ,p_se_giuridico              in anagrafe_unita_organizzative.se_giuridico%type default null
     ,p_assegnazione_componenti   in anagrafe_unita_organizzative.assegnazione_componenti%type default null
     ,p_amministrazione           in anagrafe_unita_organizzative.amministrazione%type default null
     ,p_progr_aoo                 in anagrafe_unita_organizzative.progr_aoo%type default null
     ,p_indirizzo                 in anagrafe_unita_organizzative.indirizzo%type default null
     ,p_cap                       in anagrafe_unita_organizzative.cap%type default null
     ,p_provincia                 in anagrafe_unita_organizzative.provincia%type default null
     ,p_comune                    in anagrafe_unita_organizzative.comune%type default null
     ,p_telefono                  in anagrafe_unita_organizzative.telefono%type default null
     ,p_fax                       in anagrafe_unita_organizzative.fax%type default null
     ,p_centro                    in anagrafe_unita_organizzative.centro%type default null
     ,p_centro_responsabilita     in anagrafe_unita_organizzative.centro_responsabilita%type default null
     ,p_al                        in anagrafe_unita_organizzative.al%type default null
     ,p_utente_ad4                in anagrafe_unita_organizzative.utente_ad4%type default null
     ,p_utente_aggiornamento      in anagrafe_unita_organizzative.utente_aggiornamento%type default null
     ,p_data_aggiornamento        in anagrafe_unita_organizzative.data_aggiornamento%type default null
     ,p_note                      in anagrafe_unita_organizzative.note%type default null
     ,p_tipo_unita                in anagrafe_unita_organizzative.tipo_unita%type default null
     ,p_dal_pubb                  in anagrafe_unita_organizzative.dal_pubb%type default null
     ,p_al_pubb                   in anagrafe_unita_organizzative.al_pubb%type default null
     ,p_al_prec                   in anagrafe_unita_organizzative.al_prec%type default null
     ,p_incarico_resp             in anagrafe_unita_organizzative.incarico_resp%type default null
     ,p_etichetta                 in anagrafe_unita_organizzative.etichetta%type default null
     ,p_aggregatore               in anagrafe_unita_organizzative.aggregatore%type default null
     ,p_se_fattura_elettronica    in anagrafe_unita_organizzative.se_fattura_elettronica%type default null
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
                    ripristinata con #703
      ******************************************************************************/
      d_row_found number;
   begin
      -- #431 metodo DEL rimappato sul metodo DEL_LOGICA
      begin
         del_logica(p_progr_unita_organizzativa, p_dal);
      exception
         when others then
            raise_application_error(afc_error.modified_by_other_user_number
                                   ,afc_error.modified_by_other_user_msg);
      end;
   end; -- anagrafe_unita_organizzativa.del
   --------------------------------------------------------------------------------
   procedure del_logica
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) is
      /******************************************************************************
       NOME:        del_logica #431
       DESCRIZIONE: Cancellazione logica della riga indicata.
       PARAMETRI:   Chiavi  table.
       NOTE:        Registra la riga cancellata su ANAGRAFE_UNITA_ELIMINATE
                    Ripristina la situazione precedente su ANAGRAFE_UNITA_ORGANIZZATIVE
      ******************************************************************************/
      d_row_found     number;
      d_anuo          anagrafe_unita_organizzative%rowtype;
      d_new_dal       date;
      d_al_pubb       date;
      d_min_dal_pubb  date;
      d_revisione_mod revisioni_struttura.revisione%type;
   begin
      /*      --#703 ripristinato il funzionamento originario della procedure DEL
            del(p_progr_unita_organizzativa, p_dal);
      */
      --memorizza i dati del record in eliminazione
      select a.*
        into d_anuo
        from anagrafe_unita_organizzative a
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = p_dal;
      if revisione_struttura.get_revisione_mod(d_anuo.ottica) =
         d_anuo.revisione_istituzione or
         ottica.get_gestione_revisioni(d_anuo.ottica) = 'NO' or
         d_anuo.dal > trunc(sysdate) then
         -- Bug#682
         --se la registrazione è stata creata nella revisione in modifica viene semplicemente eliminata
         --anagrafe_unita_organizzativa.del(p_progr_unita_organizzativa, p_dal);
         delete from anagrafe_unita_organizzative
          where progr_unita_organizzativa = p_progr_unita_organizzativa
            and dal = p_dal;
         --Bug#669
         update ad4_utenti
            set nominativo = 'X_' || nominativo || '_' ||
                             to_char(sysdate, 'ddmmyyyyhh24miss')
               ,stato      = 'R'
          where utente = d_anuo.utente_ad4;
      else
         --determiniamo la data di termine pubblicazione del record eliminato
         select least(trunc(sysdate), nvl(d_anuo.al_pubb, to_date(3333333, 'j')))
           into d_al_pubb
           from dual;
         --determiniamo la prima data di inizio pubblicazione tra i record gia' (eventualmente) eliminati
         select min(dal_pubb)
           into d_min_dal_pubb
           from anagrafe_unita_organizzative
          where progr_unita_organizzativa = p_progr_unita_organizzativa
            and dal > nvl(al, to_date(3333333, 'j'));
         d_al_pubb := least(d_al_pubb, d_min_dal_pubb - 1);
         /* inserisco la registrazione eliminata sulla tabella ANAGRAFE_UNITA_ORGANIZZATIVE nel range temporale
            che identifica le cancellazioni logiche
         */
         d_new_dal             := anagrafe_unita_organizzativa.get_pk_anue(p_progr_unita_organizzativa);
         s_eliminazione_logica := 1;
         anagrafe_unita_organizzativa.ins_anue(p_progr_unita_organizzativa => d_anuo.progr_unita_organizzativa
                                              ,p_dal                       => d_new_dal
                                              ,p_codice_uo                 => d_anuo.codice_uo
                                              ,p_descrizione               => d_anuo.descrizione
                                              ,p_descrizione_al1           => d_anuo.descrizione_al1
                                              ,p_descrizione_al2           => d_anuo.descrizione_al2
                                              ,p_des_abb                   => d_anuo.des_abb
                                              ,p_des_abb_al1               => d_anuo.des_abb_al1
                                              ,p_des_abb_al2               => d_anuo.des_abb_al2
                                              ,p_id_suddivisione           => d_anuo.id_suddivisione
                                              ,p_ottica                    => d_anuo.ottica
                                              ,p_revisione_istituzione     => d_anuo.revisione_istituzione
                                              ,p_revisione_cessazione      => d_anuo.revisione_cessazione
                                              ,p_tipologia_unita           => d_anuo.tipologia_unita
                                              ,p_se_giuridico              => d_anuo.se_giuridico
                                              ,p_assegnazione_componenti   => d_anuo.assegnazione_componenti
                                              ,p_amministrazione           => d_anuo.amministrazione
                                              ,p_progr_aoo                 => d_anuo.progr_aoo
                                              ,p_indirizzo                 => d_anuo.indirizzo
                                              ,p_cap                       => d_anuo.cap
                                              ,p_provincia                 => d_anuo.provincia
                                              ,p_comune                    => d_anuo.comune
                                              ,p_telefono                  => d_anuo.telefono
                                              ,p_fax                       => d_anuo.fax
                                              ,p_centro                    => d_anuo.centro
                                              ,p_centro_responsabilita     => d_anuo.centro_responsabilita
                                              ,p_al                        => d_new_dal - 1
                                              ,p_utente_ad4                => d_anuo.utente_ad4
                                              ,p_utente_aggiornamento      => d_anuo.utente_aggiornamento
                                              ,p_data_aggiornamento        => trunc(sysdate)
                                              ,p_note                      => d_anuo.note
                                              ,p_tipo_unita                => d_anuo.tipo_unita
                                              ,p_dal_pubb                  => d_anuo.dal_pubb
                                              ,p_al_pubb                   => least(d_al_pubb
                                                                                   ,d_min_dal_pubb - 1)
                                              ,p_al_prec                   => d_anuo.al_prec
                                              ,p_incarico_resp             => d_anuo.incarico_resp
                                              ,p_etichetta                 => d_anuo.etichetta
                                              ,p_aggregatore               => d_anuo.aggregatore
                                              ,p_se_fattura_elettronica    => d_anuo.se_fattura_elettronica);
         s_eliminazione_logica := 0;
         --cancellazione fisica della riga indicata
         delete from anagrafe_unita_organizzative
          where progr_unita_organizzativa = p_progr_unita_organizzativa
            and dal = p_dal;
         d_row_found := sql%rowcount;
         if d_row_found < 1 then
            raise_application_error(afc_error.modified_by_other_user_number
                                   ,afc_error.modified_by_other_user_msg);
         end if;
         --registra gli attributi dell'ultima registrazione residua del progressivo
         begin
            select a.*
              into d_anuo
              from anagrafe_unita_organizzative a
             where progr_unita_organizzativa = p_progr_unita_organizzativa
               and dal =
                   (select max(dal)
                      from anagrafe_unita_organizzative
                     where progr_unita_organizzativa = a.progr_unita_organizzativa);
         exception
            when no_data_found then
               d_row_found := 0;
         end;
         --chiudo il periodo con data di pubblicazione nulla dell'eventuale registrazione precedentemente eliminata
         s_eliminazione_logica := 1;
         update anagrafe_unita_organizzative
            set al_pubb = trunc(sysdate)
          where progr_unita_organizzativa = p_progr_unita_organizzativa
            and dal = d_new_dal
            and al_pubb is null;
         s_eliminazione_logica := 0;
         if d_row_found <> 0 then
            /* inserisce una nuova riga su ANUE, consecutiva per date di pubblicazione, per rappresentare il record corrente
               ma che ha date di pubblicazione chiuse
            */
            d_new_dal             := anagrafe_unita_organizzativa.get_pk_anue(p_progr_unita_organizzativa);
            s_eliminazione_logica := 1;
            anagrafe_unita_organizzativa.ins_anue(p_progr_unita_organizzativa => d_anuo.progr_unita_organizzativa
                                                 ,p_dal                       => d_new_dal
                                                 ,p_codice_uo                 => d_anuo.codice_uo
                                                 ,p_descrizione               => d_anuo.descrizione
                                                 ,p_descrizione_al1           => d_anuo.descrizione_al1
                                                 ,p_descrizione_al2           => d_anuo.descrizione_al2
                                                 ,p_des_abb                   => d_anuo.des_abb
                                                 ,p_des_abb_al1               => d_anuo.des_abb_al1
                                                 ,p_des_abb_al2               => d_anuo.des_abb_al2
                                                 ,p_id_suddivisione           => d_anuo.id_suddivisione
                                                 ,p_ottica                    => d_anuo.ottica
                                                 ,p_revisione_istituzione     => d_anuo.revisione_istituzione
                                                 ,p_revisione_cessazione      => d_anuo.revisione_cessazione
                                                 ,p_tipologia_unita           => d_anuo.tipologia_unita
                                                 ,p_se_giuridico              => d_anuo.se_giuridico
                                                 ,p_assegnazione_componenti   => d_anuo.assegnazione_componenti
                                                 ,p_amministrazione           => d_anuo.amministrazione
                                                 ,p_progr_aoo                 => d_anuo.progr_aoo
                                                 ,p_indirizzo                 => d_anuo.indirizzo
                                                 ,p_cap                       => d_anuo.cap
                                                 ,p_provincia                 => d_anuo.provincia
                                                 ,p_comune                    => d_anuo.comune
                                                 ,p_telefono                  => d_anuo.telefono
                                                 ,p_fax                       => d_anuo.fax
                                                 ,p_centro                    => d_anuo.centro
                                                 ,p_centro_responsabilita     => d_anuo.centro_responsabilita
                                                 ,p_al                        => d_new_dal - 1
                                                 ,p_utente_ad4                => d_anuo.utente_ad4
                                                 ,p_utente_aggiornamento      => d_anuo.utente_aggiornamento
                                                 ,p_data_aggiornamento        => trunc(sysdate)
                                                 ,p_note                      => d_anuo.note
                                                 ,p_tipo_unita                => d_anuo.tipo_unita
                                                 ,p_dal_pubb                  => trunc(sysdate) + 1
                                                 ,p_al_pubb                   => to_date(null)
                                                 ,p_al_prec                   => to_date(null)
                                                 ,p_incarico_resp             => d_anuo.incarico_resp
                                                 ,p_etichetta                 => d_anuo.etichetta
                                                 ,p_aggregatore               => d_anuo.aggregatore
                                                 ,p_se_fattura_elettronica    => d_anuo.se_fattura_elettronica);
            --elimino i periodi di cancellazione logica obsoleti
            delete from anagrafe_unita_organizzative
             where progr_unita_organizzativa = p_progr_unita_organizzativa
               and is_periodo_eliminato(dal) = 1
               and nvl(al_pubb, to_date(3333333, 'j')) < dal_pubb;
            s_eliminazione_logica := 0;
         end if;
      end if;
   end; -- anagrafe_unita_organizzativa.del_logica
   --------------------------------------------------------------------------------
   function get_descriptor
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return varchar2 is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_descriptor
       DESCRIZIONE: Descriptor di riga esistente identificata da chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     varchar2: null in caso di chiave nulla.
       NOTE:        -
      ******************************************************************************/
      d_result varchar2(32000);
   begin
      if p_progr_unita_organizzativa is null or p_dal is null then
         d_result := null;
      else
         select descrizione
           into d_result
           from anagrafe_unita_organizzative
          where progr_unita_organizzativa = p_progr_unita_organizzativa
            and dal = p_dal;
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_descriptor
   --------------------------------------------------------------------------------
   function get_dal_id
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.dal%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_dal_id
       DESCRIZIONE: Attributo dal di riga con periodo di validità comprendente
                    la data indicata
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.dal%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result    anagrafe_unita_organizzative.dal%type;
      d_ottica    anagrafe_unita_organizzative.ottica%type;
      d_revisione anagrafe_unita_organizzative.revisione_istituzione%type;
   begin
      --
      -- Si verifica la presenza di una revisione in corso di modifica: eventuali
      -- righe inserite con tale revisione non vengono considerate
      --
      begin
         select min(ottica)
           into d_ottica
           from anagrafe_unita_organizzative
          where progr_unita_organizzativa = p_progr_unita_organizzativa;
      exception
         when others then
            d_ottica := null;
      end;
      --
      if d_ottica is not null then
         d_revisione := revisione_struttura.get_revisione_mod(d_ottica);
         if d_revisione = -1 then
            -- Non ci sono revisioni in modifica
            select dal
              into d_result
              from anagrafe_unita_organizzative
             where progr_unita_organizzativa = p_progr_unita_organizzativa
               and p_dal between dal and nvl(al, to_date('3333333', 'j'));
         else
            select dal
              into d_result
              from anagrafe_unita_organizzative
             where progr_unita_organizzativa = p_progr_unita_organizzativa
               and revisione_istituzione != d_revisione
               and p_dal between dal and
                   nvl(decode(revisione_cessazione, d_revisione, to_date(null), al)
                      ,to_date(3333333, 'j'));
         end if;
      else
         select dal
           into d_result
           from anagrafe_unita_organizzative
          where progr_unita_organizzativa = p_progr_unita_organizzativa
            and p_dal between dal and nvl(al, to_date('3333333', 'j'));
      end if;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_id_dal');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'dal')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_id_dal');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_id_dal
   --------------------------------------------------------------------------------
   function get_dal_pubb_id
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.dal_pubb%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_dal_pubb_id
       DESCRIZIONE: Attributo dal_pubb di riga con periodo di validità comprendente
                    la data indicata
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.dal_pubb%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result    anagrafe_unita_organizzative.dal_pubb%type;
      d_ottica    anagrafe_unita_organizzative.ottica%type;
      d_revisione anagrafe_unita_organizzative.revisione_istituzione%type;
   begin
      --
      -- Si verifica la presenza di una revisione in corso di modifica: eventuali
      -- righe inserite con tale revisione non vengono considerate
      --
      begin
         select min(ottica)
           into d_ottica
           from anagrafe_unita_organizzative
          where progr_unita_organizzativa = p_progr_unita_organizzativa;
      exception
         when others then
            d_ottica := null;
      end;
      --
      if d_ottica is not null then
         d_revisione := revisione_struttura.get_revisione_mod(d_ottica);
         if d_revisione = -1 then
            -- Non ci sono revisioni in modifica
            select dal_pubb
              into d_result
              from anagrafe_unita_organizzative
             where progr_unita_organizzativa = p_progr_unita_organizzativa
               and p_dal between dal_pubb and nvl(al_pubb, to_date('3333333', 'j'));
         else
            select dal_pubb
              into d_result
              from anagrafe_unita_organizzative
             where progr_unita_organizzativa = p_progr_unita_organizzativa
               and revisione_istituzione != d_revisione
               and p_dal between dal_pubb and
                   nvl(decode(revisione_cessazione, d_revisione, to_date(null), al_pubb)
                      ,to_date(3333333, 'j'));
         end if;
      else
         select dal_pubb
           into d_result
           from anagrafe_unita_organizzative
          where progr_unita_organizzativa = p_progr_unita_organizzativa
            and p_dal between dal_pubb and nvl(al_pubb, to_date('3333333', 'j'));
      end if;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_id_dal_pubb');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'dal')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_id_dal_pubb');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_id_dal
   --------------------------------------------------------------------------------
   function get_codice_uo
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.codice_uo%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_codice_uo
       DESCRIZIONE: Attributo codice_uo di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.codice_uo%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.codice_uo%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      /*   DbC.PRE ( not DbC.PreOn or  existsId ( p_progr_unita_organizzativa
                                   , p_dal
                                   )
      , 'existsId on anagrafe_unita_organizzativa.get_codice_uo'
      ); */
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select codice_uo
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_codice_uo');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'codice_uo')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_codice_uo');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_codice_uo
   --------------------------------------------------------------------------------
   function get_codice_ipa   --#52548
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.codice_ipa%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_codice_ipa
       DESCRIZIONE: Attributo codice_ipa di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.codice_ipa%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.codice_ipa%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select codice_ipa
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_codice_ipa
   --------------------------------------------------------------------------------
   function get_descrizione
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.descrizione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_descrizione
       DESCRIZIONE: Attributo descrizione di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.descrizione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.descrizione%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      /*   DbC.PRE ( not DbC.PreOn or  existsId ( p_progr_unita_organizzativa
                                   , p_dal
                                   )
      , 'existsId on anagrafe_unita_organizzativa.get_descrizione'
      );*/
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select descrizione
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_descrizione');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'descrizione')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_descrizione');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_descrizione
   --------------------------------------------------------------------------------
   function get_descrizione_al1
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.descrizione_al1%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_descrizione_al1
       DESCRIZIONE: Attributo descrizione_al1 di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.descrizione_al1%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.descrizione_al1%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      /*   DbC.PRE ( not DbC.PreOn or  existsId ( p_progr_unita_organizzativa
                                   , p_dal
                                   )
      , 'existsId on anagrafe_unita_organizzativa.get_descrizione_al1'
      );*/
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select descrizione_al1
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_descrizione_al1');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'descrizione_al1')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_descrizione_al1');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_descrizione_al1
   --------------------------------------------------------------------------------
   function get_descrizione_al2
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.descrizione_al2%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_descrizione_al2
       DESCRIZIONE: Attributo descrizione_al2 di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.descrizione_al2%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.descrizione_al2%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      /*   DbC.PRE ( not DbC.PreOn or  existsId ( p_progr_unita_organizzativa
                                   , p_dal
                                   )
      , 'existsId on anagrafe_unita_organizzativa.get_descrizione_al2'
      );*/
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select descrizione_al2
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_descrizione_al2');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'descrizione_al2')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_descrizione_al2');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_descrizione_al2
   --------------------------------------------------------------------------------
   function get_des_abb
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.des_abb%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_des_abb
       DESCRIZIONE: Attributo des_abb di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.des_abb%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.des_abb%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      /*   DbC.PRE ( not DbC.PreOn or  existsId ( p_progr_unita_organizzativa
                                   , p_dal
                                   )
      , 'existsId on anagrafe_unita_organizzativa.get_des_abb'
      );*/
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select des_abb
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_des_abb');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'des_abb')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_des_abb');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_des_abb
   --------------------------------------------------------------------------------
   function get_des_abb_al1
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.des_abb_al1%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_des_abb_al1
       DESCRIZIONE: Attributo des_abb_al1 di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.des_abb_al1%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.des_abb_al1%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      /*   DbC.PRE ( not DbC.PreOn or  existsId ( p_progr_unita_organizzativa
                                   , p_dal
                                   )
      , 'existsId on anagrafe_unita_organizzativa.get_des_abb_al1'
      );*/
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select des_abb_al1
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_des_abb_al1');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'des_abb_al1')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_des_abb_al1');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_des_abb_al1
   --------------------------------------------------------------------------------
   function get_des_abb_al2
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.des_abb_al2%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_des_abb_al2
       DESCRIZIONE: Attributo des_abb_al2 di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.des_abb_al2%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.des_abb_al2%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      /*   DbC.PRE ( not DbC.PreOn or  existsId ( p_progr_unita_organizzativa
                                   , p_dal
                                   )
      , 'existsId on anagrafe_unita_organizzativa.get_des_abb_al2'
      );*/
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select des_abb_al2
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_des_abb_al2');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'des_abb_al2')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_des_abb_al2');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_des_abb_al2
   --------------------------------------------------------------------------------
   function get_id_suddivisione
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.id_suddivisione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_id_suddivisione
       DESCRIZIONE: Attributo id_suddivisione di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.id_suddivisione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.id_suddivisione%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      /*   DbC.PRE ( not DbC.PreOn or  existsId ( p_progr_unita_organizzativa
                                   , p_dal
                                   )
      , 'existsId on anagrafe_unita_organizzativa.get_id_suddivisione'
      );*/
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select id_suddivisione
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_id_suddivisione');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'id_suddivisione')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_id_suddivisione');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_id_suddivisione
   --------------------------------------------------------------------------------
   function get_ottica
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.ottica%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_ottica
       DESCRIZIONE: Attributo ottica di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.ottica%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.ottica%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      /*   DbC.PRE ( not DbC.PreOn or  existsId ( p_progr_unita_organizzativa
                                   , p_dal
                                   )
      , 'existsId on anagrafe_unita_organizzativa.get_ottica'
      );*/
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select ottica
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_ottica');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'ottica')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_ottica');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_ottica
   --------------------------------------------------------------------------------
   function get_revisione_istituzione
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.revisione_istituzione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_revisione_istituzione
       DESCRIZIONE: Attributo revisione_istituzione di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.revisione_istituzione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.revisione_istituzione%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      /*   DbC.PRE ( not DbC.PreOn or  existsId ( p_progr_unita_organizzativa
                                   , p_dal
                                   )
      , 'existsId on anagrafe_unita_organizzativa.get_revisione_istituzione'
      );*/
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select revisione_istituzione
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_revisione_istituzione');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'revisione_istituzione')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_revisione_istituzione');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_revisione_istituzione
   --------------------------------------------------------------------------------
   function get_revisione_cessazione
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.revisione_cessazione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_revisione_cessazione
       DESCRIZIONE: Attributo revisione_cessazione di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.revisione_cessazione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.revisione_cessazione%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      /*   DbC.PRE ( not DbC.PreOn or  existsId ( p_progr_unita_organizzativa
                                   , p_dal
                                   )
      , 'existsId on anagrafe_unita_organizzativa.get_revisione_cessazione'
      );*/
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select revisione_cessazione
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_revisione_cessazione');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'revisione_cessazione')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_revisione_cessazione');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_revisione_cessazione
   --------------------------------------------------------------------------------
   function get_tipologia_unita
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.tipologia_unita%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_tipologia_unita
       DESCRIZIONE: Attributo tipologia_unita di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.tipologia_unita%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.tipologia_unita%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      /*   DbC.PRE ( not DbC.PreOn or  existsId ( p_progr_unita_organizzativa
                                   , p_dal
                                   )
      , 'existsId on anagrafe_unita_organizzativa.get_tipologia_unita'
      );*/
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select tipologia_unita
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_tipologia_unita');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'tipologia_unita')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_tipologia_unita');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_tipologia_unita
   --------------------------------------------------------------------------------
   function get_se_giuridico
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.se_giuridico%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_se_giuridico
       DESCRIZIONE: Attributo se_giuridico di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.se_giuridico%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.se_giuridico%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      /*   DbC.PRE ( not DbC.PreOn or  existsId ( p_progr_unita_organizzativa
                                   , p_dal
                                   )
      , 'existsId on anagrafe_unita_organizzativa.get_se_giuridico'
      );*/
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select se_giuridico
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_se_giuridico');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'se_giuridico')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_se_giuridico');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_se_giuridico
   --------------------------------------------------------------------------------
   function get_assegnazione_componenti
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.assegnazione_componenti%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_assegnazione_componenti
       DESCRIZIONE: Attributo assegnazione_componenti di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.assegnazione_componenti%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.assegnazione_componenti%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      /*   DbC.PRE ( not DbC.PreOn or  existsId ( p_progr_unita_organizzativa
                                   , p_dal
                                   )
      , 'existsId on anagrafe_unita_organizzativa.get_assegnazione_componenti'
      );*/
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select assegnazione_componenti
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_assegnazione_componenti');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'assegnazione_componenti')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_assegnazione_componenti');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_assegnazione_componenti
   --------------------------------------------------------------------------------
   function get_amministrazione
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.amministrazione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_amministrazione
       DESCRIZIONE: Attributo amministrazione di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.amministrazione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.amministrazione%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      /*   DbC.PRE ( not DbC.PreOn or  existsId ( p_progr_unita_organizzativa
                                   , p_dal
                                   )
      , 'existsId on anagrafe_unita_organizzativa.get_amministrazione'
      );*/
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select amministrazione
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_amministrazione');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'amministrazione')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_amministrazione');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_amministrazione
   --------------------------------------------------------------------------------
   function get_progr_aoo
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.progr_aoo%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_progr_aoo
       DESCRIZIONE: Attributo progr_aoo di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.progr_aoo%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.progr_aoo%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      /*   DbC.PRE ( not DbC.PreOn or  existsId ( p_progr_unita_organizzativa
                                   , p_dal
                                   )
      , 'existsId on anagrafe_unita_organizzativa.get_progr_aoo'
      );*/
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select progr_aoo
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_progr_aoo');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'progr_aoo')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_progr_aoo');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_progr_aoo
   --------------------------------------------------------------------------------
   function get_indirizzo
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.indirizzo%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_indirizzo
       DESCRIZIONE: Attributo indirizzo di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.indirizzo%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.indirizzo%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      /*   DbC.PRE ( not DbC.PreOn or  existsId ( p_progr_unita_organizzativa
                                   , p_dal
                                   )
      , 'existsId on anagrafe_unita_organizzativa.get_indirizzo'
      );*/
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select indirizzo
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_indirizzo');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'indirizzo')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_indirizzo');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_indirizzo
   --------------------------------------------------------------------------------
   function get_cap
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.cap%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_cap
       DESCRIZIONE: Attributo cap di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.cap%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.cap%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      /*   DbC.PRE ( not DbC.PreOn or  existsId ( p_progr_unita_organizzativa
                                   , p_dal
                                   )
      , 'existsId on anagrafe_unita_organizzativa.get_cap'
      );*/
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select cap
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_cap');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'cap')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_cap');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_cap
   --------------------------------------------------------------------------------
   function get_provincia
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.provincia%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_provincia
       DESCRIZIONE: Attributo provincia di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.provincia%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.provincia%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      /*   DbC.PRE ( not DbC.PreOn or  existsId ( p_progr_unita_organizzativa
                                   , p_dal
                                   )
      , 'existsId on anagrafe_unita_organizzativa.get_provincia'
      );*/
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select provincia
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_provincia');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'provincia')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_provincia');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_provincia
   --------------------------------------------------------------------------------
   function get_comune
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.comune%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_comune
       DESCRIZIONE: Attributo comune di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.comune%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.comune%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      /*   DbC.PRE ( not DbC.PreOn or  existsId ( p_progr_unita_organizzativa
                                   , p_dal
                                   )
      , 'existsId on anagrafe_unita_organizzativa.get_comune'
      );*/
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select comune
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_comune');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'comune')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_comune');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_comune
   --------------------------------------------------------------------------------
   function get_telefono
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.telefono%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_telefono
       DESCRIZIONE: Attributo telefono di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.telefono%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.telefono%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      /*   DbC.PRE ( not DbC.PreOn or  existsId ( p_progr_unita_organizzativa
                                   , p_dal
                                   )
      , 'existsId on anagrafe_unita_organizzativa.get_telefono'
      );*/
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select telefono
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_telefono');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'telefono')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_telefono');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_telefono
   --------------------------------------------------------------------------------
   function get_fax
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.fax%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_fax
       DESCRIZIONE: Attributo fax di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.fax%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.fax%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      /*   DbC.PRE ( not DbC.PreOn or  existsId ( p_progr_unita_organizzativa
                                   , p_dal
                                   )
      , 'existsId on anagrafe_unita_organizzativa.get_fax'
      );*/
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select fax
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_fax');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'fax')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_fax');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_fax
   --------------------------------------------------------------------------------
   function get_centro
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.centro%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_centro
       DESCRIZIONE: Attributo centro di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.centro%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.centro%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      /*   DbC.PRE ( not DbC.PreOn or  existsId ( p_progr_unita_organizzativa
                                   , p_dal
                                   )
      , 'existsId on anagrafe_unita_organizzativa.get_centro'
      );*/
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select centro
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_centro');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'centro')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_centro');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_centro
   --------------------------------------------------------------------------------
   function get_centro_responsabilita
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.centro_responsabilita%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_centro_responsabilita
       DESCRIZIONE: Attributo centro_responsabilita di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.centro_responsabilita%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.centro_responsabilita%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      /*   DbC.PRE ( not DbC.PreOn or  existsId ( p_progr_unita_organizzativa
                                   , p_dal
                                   )
      , 'existsId on anagrafe_unita_organizzativa.get_centro_responsabilita'
      );*/
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select centro_responsabilita
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_centro_responsabilita');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'centro_responsabilita')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_centro_responsabilita');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_centro_responsabilita
   --------------------------------------------------------------------------------
   function get_al
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.al%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_al
       DESCRIZIONE: Attributo al di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.al%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.al%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      /*   DbC.PRE ( not DbC.PreOn or  existsId ( p_progr_unita_organizzativa
                                   , p_dal
                                   )
      , 'existsId on anagrafe_unita_organizzativa.get_al'
      );*/
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select al
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_al');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'al')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_al');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_al
   --------------------------------------------------------------------------------
   function get_utente_ad4
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.utente_ad4%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_utente_AD4
       DESCRIZIONE: Attributo utente_AD4 di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.utente_AD4%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.utente_ad4%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      /*   DbC.PRE ( not DbC.PreOn or  existsId ( p_progr_unita_organizzativa
                                   , p_dal
                                   )
      , 'existsId on anagrafe_unita_organizzativa.get_utente_AD4'
      );*/
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select utente_ad4
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_utente_AD4');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'utente_AD4')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_utente_AD4');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_utente_AD4
   --------------------------------------------------------------------------------
   function get_utente_aggiornamento
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.utente_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_utente_aggiornamento
       DESCRIZIONE: Attributo utente_aggiornamento di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.utente_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.utente_aggiornamento%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      /*   DbC.PRE ( not DbC.PreOn or  existsId ( p_progr_unita_organizzativa
                                   , p_dal
                                   )
      , 'existsId on anagrafe_unita_organizzativa.get_utente_aggiornamento'
      );*/
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select utente_aggiornamento
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_utente_aggiornamento');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'utente_aggiornamento')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_utente_aggiornamento');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_utente_aggiornamento
   --------------------------------------------------------------------------------
   function get_data_aggiornamento
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.data_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_data_aggiornamento
       DESCRIZIONE: Attributo data_aggiornamento di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.data_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.data_aggiornamento%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      /*   DbC.PRE ( not DbC.PreOn or  existsId ( p_progr_unita_organizzativa
                                   , p_dal
                                   )
      , 'existsId on anagrafe_unita_organizzativa.get_data_aggiornamento'
      );*/
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select data_aggiornamento
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_data_aggiornamento');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'data_aggiornamento')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_data_aggiornamento');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_data_aggiornamento
   --------------------------------------------------------------------------------
   function get_note
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.note%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_note
       DESCRIZIONE: Attributo note di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.note%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.note%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      /*   DbC.PRE ( not DbC.PreOn or  existsId ( p_progr_unita_organizzativa
                                   , p_dal
                                   )
      , 'existsId on anagrafe_unita_organizzativa.get_data_aggiornamento'
      );*/
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select note
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_note');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'note')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_note');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_note
   --------------------------------------------------------------------------------
   function get_tipo_unita
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.tipo_unita%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_tipo_unita
       DESCRIZIONE: Attributo tipo_unita di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.tipo_unita%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.tipo_unita%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select tipo_unita
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_tipo_unita');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'tipo_unita')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_tipo_unita');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_tipo_unita
   --------------------------------------------------------------------------------
   function get_incarico_resp
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.incarico_resp%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_incarico_resp
       DESCRIZIONE: Attributo incarico_resp di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.incarico_resp%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.incarico_resp%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select incarico_resp
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_incarico_resp');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'incarico_resp')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_incarico_resp');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_incarico_resp
   --------------------------------------------------------------------------------
   function get_etichetta
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.etichetta%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_etichetta
       DESCRIZIONE: Attributo etichetta di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.etichetta%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.etichetta%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select etichetta
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_etichetta');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'etichetta')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_etichetta');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_etichetta
   --------------------------------------------------------------------------------
   function get_aggregatore
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.aggregatore%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_etichetta
       DESCRIZIONE: Attributo aggregatore di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.aggregatore%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.aggregatore%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select aggregatore
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_etichetta');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'etichetta')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_etichetta');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_aggregatore
   --------------------------------------------------------------------------------
   function get_se_fattura_elettronica
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.se_fattura_elettronica%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_se_fattura_elettronica
       DESCRIZIONE: Attributo se_fattura_elettronica di riga esistente identificata
                    dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.se_fattura_elettronica%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.se_fattura_elettronica%type;
      d_data   anagrafe_unita_organizzative.dal%type;
   begin
      d_data := get_dal_id(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                          ,p_dal                       => p_dal);
      select se_fattura_elettronica
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_se_fattura_elettronica');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'etichetta')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_se_fattura_elettronica');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_se_fattura_elettronica
   --------------------------------------------------------------------------------
   function where_condition
   (
      p_progr_unita_organizzativa in varchar2 default null
     ,p_dal                       in varchar2 default null
     ,p_codice_uo                 in varchar2 default null
     ,p_descrizione               in varchar2 default null
     ,p_descrizione_al1           in varchar2 default null
     ,p_descrizione_al2           in varchar2 default null
     ,p_des_abb                   in varchar2 default null
     ,p_des_abb_al1               in varchar2 default null
     ,p_des_abb_al2               in varchar2 default null
     ,p_id_suddivisione           in varchar2 default null
     ,p_ottica                    in varchar2 default null
     ,p_revisione_istituzione     in varchar2 default null
     ,p_revisione_cessazione      in varchar2 default null
     ,p_tipologia_unita           in varchar2 default null
     ,p_se_giuridico              in varchar2 default null
     ,p_assegnazione_componenti   in varchar2 default null
     ,p_amministrazione           in varchar2 default null
     ,p_progr_aoo                 in varchar2 default null
     ,p_indirizzo                 in varchar2 default null
     ,p_cap                       in varchar2 default null
     ,p_provincia                 in varchar2 default null
     ,p_comune                    in varchar2 default null
     ,p_telefono                  in varchar2 default null
     ,p_fax                       in varchar2 default null
     ,p_centro                    in varchar2 default null
     ,p_centro_responsabilita     in varchar2 default null
     ,p_al                        in varchar2 default null
     ,p_note                      in varchar2 default null
     ,p_tipo_unita                in varchar2 default null
     ,p_dal_pubb                  in varchar2 default null
     ,p_al_pubb                   in varchar2 default null
     ,p_al_prec                   in varchar2 default null
     ,p_incarico_resp             in varchar2 default null
     ,p_etichetta                 in varchar2 default null
     ,p_utente_ad4                in varchar2 default null
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
                    p_QBE 0: se l'operatore da utilizzare nella where-condition e
                             quello di default ('=')
                          1: se l'operatore da utilizzare nella where-condition e
                             quello specificato per ogni attributo.
       RITORNA:     AFC.t_statement.
       NOTE:        Se p_QBE = 1 , ogni parametro deve contenere, nella prima parte,
                    l'operatore da utilizzare nella where-condition.
      ******************************************************************************/
      d_statement afc.t_statement;
   begin
      d_statement := ' where ( 1 = 1 ' ||
                     afc.get_field_condition(' and ( progr_unita_organizzativa '
                                            ,p_progr_unita_organizzativa
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( dal ', p_dal, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( codice_uo '
                                            ,p_codice_uo
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
                     afc.get_field_condition(' and ( id_suddivisione '
                                            ,p_id_suddivisione
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( ottica ', p_ottica, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( revisione_istituzione '
                                            ,p_revisione_istituzione
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( revisione_cessazione '
                                            ,p_revisione_cessazione
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( tipologia_unita '
                                            ,p_tipologia_unita
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( se_giuridico '
                                            ,p_se_giuridico
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( assegnazione_componenti '
                                            ,p_assegnazione_componenti
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( amministrazione '
                                            ,p_amministrazione
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( progr_aoo '
                                            ,p_progr_aoo
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( indirizzo '
                                            ,p_indirizzo
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( cap ', p_cap, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( provincia '
                                            ,p_provincia
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( comune ', p_comune, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( telefono ', p_telefono, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( fax ', p_fax, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( centro ', p_centro, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( centro_responsabilita '
                                            ,p_centro_responsabilita
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( al ', p_al, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( tipo_unita '
                                            ,p_tipo_unita
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( note ', p_note, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( dal_pubb ', p_dal_pubb, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( al_pubb ', p_al_pubb, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( al_prec ', p_al_prec, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( incarico_resp '
                                            ,p_incarico_resp
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( etichetta '
                                            ,p_etichetta
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( utente_AD4 '
                                            ,p_utente_ad4
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
   end; --- anagrafe_unita_organizzativa.where_condition
   --------------------------------------------------------------------------------
   function get_rows
   (
      p_progr_unita_organizzativa in varchar2 default null
     ,p_dal                       in varchar2 default null
     ,p_codice_uo                 in varchar2 default null
     ,p_descrizione               in varchar2 default null
     ,p_descrizione_al1           in varchar2 default null
     ,p_descrizione_al2           in varchar2 default null
     ,p_des_abb                   in varchar2 default null
     ,p_des_abb_al1               in varchar2 default null
     ,p_des_abb_al2               in varchar2 default null
     ,p_id_suddivisione           in varchar2 default null
     ,p_ottica                    in varchar2 default null
     ,p_revisione_istituzione     in varchar2 default null
     ,p_revisione_cessazione      in varchar2 default null
     ,p_tipologia_unita           in varchar2 default null
     ,p_se_giuridico              in varchar2 default null
     ,p_assegnazione_componenti   in varchar2 default null
     ,p_amministrazione           in varchar2 default null
     ,p_progr_aoo                 in varchar2 default null
     ,p_indirizzo                 in varchar2 default null
     ,p_cap                       in varchar2 default null
     ,p_provincia                 in varchar2 default null
     ,p_comune                    in varchar2 default null
     ,p_telefono                  in varchar2 default null
     ,p_fax                       in varchar2 default null
     ,p_centro                    in varchar2 default null
     ,p_centro_responsabilita     in varchar2 default null
     ,p_al                        in varchar2 default null
     ,p_note                      in varchar2 default null
     ,p_tipo_unita                in varchar2 default null
     ,p_dal_pubb                  in varchar2 default null
     ,p_al_pubb                   in varchar2 default null
     ,p_al_prec                   in varchar2 default null
     ,p_incarico_resp             in varchar2 default null
     ,p_etichetta                 in varchar2 default null
     ,p_utente_ad4                in varchar2 default null
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
                    p_other_condition
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
      dbc.pre(not dbc.preon or p_qbe in (0, 1)
             ,'check p_QBE on anagrafe_unita_organizzativa.get_rows');
      d_statement  := ' select * from anagrafe_unita_organizzative ' ||
                      where_condition(p_progr_unita_organizzativa
                                     ,p_dal
                                     ,p_codice_uo
                                     ,p_descrizione
                                     ,p_descrizione_al1
                                     ,p_descrizione_al2
                                     ,p_des_abb
                                     ,p_des_abb_al1
                                     ,p_des_abb_al2
                                     ,p_id_suddivisione
                                     ,p_ottica
                                     ,p_revisione_istituzione
                                     ,p_revisione_cessazione
                                     ,p_tipologia_unita
                                     ,p_se_giuridico
                                     ,p_assegnazione_componenti
                                     ,p_amministrazione
                                     ,p_progr_aoo
                                     ,p_indirizzo
                                     ,p_cap
                                     ,p_provincia
                                     ,p_comune
                                     ,p_telefono
                                     ,p_fax
                                     ,p_centro
                                     ,p_centro_responsabilita
                                     ,p_al
                                     ,p_note
                                     ,p_tipo_unita
                                     ,p_dal_pubb
                                     ,p_al_pubb
                                     ,p_al_prec
                                     ,p_incarico_resp
                                     ,p_etichetta
                                     ,p_utente_ad4
                                     ,p_utente_aggiornamento
                                     ,p_data_aggiornamento
                                     ,p_other_condition
                                     ,p_qbe);
      d_ref_cursor := afc_dml.get_ref_cursor(d_statement);
      return d_ref_cursor;
   end; -- anagrafe_unita_organizzativa.get_rows
   --------------------------------------------------------------------------------
   function count_rows
   (
      p_progr_unita_organizzativa in varchar2 default null
     ,p_dal                       in varchar2 default null
     ,p_codice_uo                 in varchar2 default null
     ,p_descrizione               in varchar2 default null
     ,p_descrizione_al1           in varchar2 default null
     ,p_descrizione_al2           in varchar2 default null
     ,p_des_abb                   in varchar2 default null
     ,p_des_abb_al1               in varchar2 default null
     ,p_des_abb_al2               in varchar2 default null
     ,p_id_suddivisione           in varchar2 default null
     ,p_ottica                    in varchar2 default null
     ,p_revisione_istituzione     in varchar2 default null
     ,p_revisione_cessazione      in varchar2 default null
     ,p_tipologia_unita           in varchar2 default null
     ,p_se_giuridico              in varchar2 default null
     ,p_assegnazione_componenti   in varchar2 default null
     ,p_amministrazione           in varchar2 default null
     ,p_progr_aoo                 in varchar2 default null
     ,p_indirizzo                 in varchar2 default null
     ,p_cap                       in varchar2 default null
     ,p_provincia                 in varchar2 default null
     ,p_comune                    in varchar2 default null
     ,p_telefono                  in varchar2 default null
     ,p_fax                       in varchar2 default null
     ,p_centro                    in varchar2 default null
     ,p_centro_responsabilita     in varchar2 default null
     ,p_al                        in varchar2 default null
     ,p_note                      in varchar2 default null
     ,p_tipo_unita                in varchar2 default null
     ,p_dal_pubb                  in varchar2 default null
     ,p_al_pubb                   in varchar2 default null
     ,p_al_prec                   in varchar2 default null
     ,p_incarico_resp             in varchar2 default null
     ,p_etichetta                 in varchar2 default null
     ,p_utente_ad4                in varchar2 default null
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
                    p_other_condition
                    p_QBE
       RITORNA:     Numero di righe che rispettano la selezione indicata.
      ******************************************************************************/
      d_result    integer;
      d_statement afc.t_statement;
   begin
      dbc.pre(not dbc.preon or p_qbe in (0, 1)
             ,'check p_QBE on anagrafe_unita_organizzativa.count_rows');
      d_statement := ' select count( * ) from anagrafe_unita_organizzative ' ||
                     where_condition(p_progr_unita_organizzativa
                                    ,p_dal
                                    ,p_codice_uo
                                    ,p_descrizione
                                    ,p_descrizione_al1
                                    ,p_descrizione_al2
                                    ,p_des_abb
                                    ,p_des_abb_al1
                                    ,p_des_abb_al2
                                    ,p_id_suddivisione
                                    ,p_ottica
                                    ,p_revisione_istituzione
                                    ,p_revisione_cessazione
                                    ,p_tipologia_unita
                                    ,p_se_giuridico
                                    ,p_assegnazione_componenti
                                    ,p_amministrazione
                                    ,p_progr_aoo
                                    ,p_indirizzo
                                    ,p_cap
                                    ,p_provincia
                                    ,p_comune
                                    ,p_telefono
                                    ,p_fax
                                    ,p_centro
                                    ,p_centro_responsabilita
                                    ,p_al
                                    ,p_note
                                    ,p_tipo_unita
                                    ,p_dal_pubb
                                    ,p_al_pubb
                                    ,p_al_prec
                                    ,p_incarico_resp
                                    ,p_etichetta
                                    ,p_utente_ad4
                                    ,p_utente_aggiornamento
                                    ,p_data_aggiornamento
                                    ,p_other_condition
                                    ,p_qbe);
      d_result    := afc.sql_execute(d_statement);
      return d_result;
   end; -- anagrafe_unita_organizzativa.count_rows
   --------------------------------------------------------------------------------
   function get_id_unita return anagrafe_unita_organizzative.progr_unita_organizzativa%type is
      /******************************************************************************
       NOME:        get_id_unita
       DESCRIZIONE: Attributo id per inserimento nuova unità
       PARAMETRI:
       RITORNA:     anagrafe_unita_organizzative.progr_unita_organizzativa%type.
       NOTE:
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.progr_unita_organizzativa%type;
   begin
      select nvl(max(progr_unita_organizzativa), 0) + 1
        into d_result
        from anagrafe_unita_organizzative;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_id_unita
   --------------------------------------------------------------------------------
   function get_dal_corrente
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data                      in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.dal%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_dal_corrente
       DESCRIZIONE: Restituisce un'unico DAL per l'unita organizzativa indicata
                    - Se l'U.O. non esiste piu, viene restituito il max
                    - Se l'U.O. e valida, viene restituito il dal valido alla data passata
                    - Se l'U.O. ha validita futura, viene restituito il min
       PARAMETRI:   p_progr_unita_organizzativa
                    p_data
       RITORNA:     anagrafe_unita_organizzative.dal%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.dal%type;
   begin
      begin
         select dal
           into d_result
           from anagrafe_unita_organizzative
          where progr_unita_organizzativa = p_progr_unita_organizzativa
            and p_data between dal and nvl(al, to_date('3333333', 'j'));
      exception
         when no_data_found then
            d_result := null;
      end;
      --
      -- Se il risultato e nullo, significa che la U.O. non ha record
      -- in corso di validita; si ricerca il record scaduto piu recente
      --
      if d_result is null then
         begin
            select max(dal)
              into d_result
              from anagrafe_unita_organizzative
             where progr_unita_organizzativa = p_progr_unita_organizzativa;
         end;
      end if;
      --
      -- Se il risultato e ancora nullo, significa che la U.O. ha validita
      -- futura
      --
      if d_result is null then
         begin
            select min(dal)
              into d_result
              from anagrafe_unita_organizzative
             where progr_unita_organizzativa = p_progr_unita_organizzativa;
         end;
      end if;
      --
      -- Se il risultato e ancora nullo, e un errore !
      --
      if d_result is null then
         raise_application_error(-20999
                                ,'Errore in determinazione data validita U.O. - Progr. ' ||
                                 p_progr_unita_organizzativa);
      end if;
      --
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_dal_corrente
   --------------------------------------------------------------------------------
   function get_dal_pubb_corrente
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_data                      in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.dal_pubb%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_dal_pubb_corrente
       DESCRIZIONE: Restituisce un'unico DAL_pubb per l'unita organizzativa indicata
                    - Se l'U.O. non esiste piu, viene restituito il max
                    - Se l'U.O. e valida, viene restituito il dal_pubb valido alla data passata
                    - Se l'U.O. ha validita futura, viene restituito il min
       PARAMETRI:   p_progr_unita_organizzativa
                    p_data
       RITORNA:     anagrafe_unita_organizzative.dal_pubb%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result        anagrafe_unita_organizzative.dal_pubb%type;
      d_ottica        anagrafe_unita_organizzative.ottica%type;
      d_revisione_mod anagrafe_unita_organizzative.revisione_istituzione%type;
   begin
      begin
         select dal_pubb
           into d_result
           from anagrafe_unita_organizzative
          where progr_unita_organizzativa = p_progr_unita_organizzativa
            and p_data between dal_pubb and nvl(al_pubb, to_date('3333333', 'j'));
      exception
         when no_data_found then
            d_result := null;
      end;
      --
      -- Se il risultato e nullo, significa che la U.O. non ha record
      -- in corso di validita; si ricerca il record scaduto piu recente
      --
      if d_result is null then
         begin
            select max(dal_pubb)
              into d_result
              from anagrafe_unita_organizzative
             where progr_unita_organizzativa = p_progr_unita_organizzativa;
         end;
      end if;
      --
      -- Se il risultato e ancora nullo, significa che la U.O. ha validita
      -- futura
      --
      if d_result is null then
         begin
            select min(dal_pubb)
              into d_result
              from anagrafe_unita_organizzative
             where progr_unita_organizzativa = p_progr_unita_organizzativa;
         end;
      end if;
      --
      -- Se il risultato e ancora nullo, la UO potrebbe essere stata creata con
      -- la revisione in modifica
      --
      if d_result is null then
         select min(ottica)
           into d_ottica
           from anagrafe_unita_organizzative
          where progr_unita_organizzativa = p_progr_unita_organizzativa;
         d_revisione_mod := revisione_struttura.get_revisione_mod(d_ottica);
         begin
            select ottica
              into d_ottica
              from anagrafe_unita_organizzative
             where progr_unita_organizzativa = p_progr_unita_organizzativa
               and dal = revisione_struttura.get_dal(d_ottica, d_revisione_mod)
               and revisione_istituzione = d_revisione_mod;
            raise too_many_rows;
         exception
            when no_data_found then
               null;
            when too_many_rows then
               d_result := nvl(revisione_struttura.get_dal(d_ottica, d_revisione_mod)
                              ,trunc(sysdate));
         end;
      end if;
      --
      -- Se il risultato e ancora nullo, e un errore !
      --
      if d_result is null then
         raise_application_error(-20999
                                ,'Errore in determinazione data pubblicazione U.O. - Progr. ' ||
                                 p_progr_unita_organizzativa);
      end if;
      --
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_dal_pubb_corrente
   --------------------------------------------------------------------------------
   function get_progr_unor
   (
      p_ottica          in anagrafe_unita_organizzative.ottica%type default null
     ,p_amministrazione in anagrafe_unita_organizzative.amministrazione%type default null
     ,p_codice_uo       in anagrafe_unita_organizzative.codice_uo%type default null
     ,p_utente_ad4      in anagrafe_unita_organizzative.utente_ad4%type default null
     ,p_data            in anagrafe_unita_organizzative.dal%type default null
   ) return anagrafe_unita_organizzative.progr_unita_organizzativa%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_progr_unor
       DESCRIZIONE: Restituisce il progressivo (chiave) dell'unità organizzativa
                    associato al codice e all'ottica indicati
       PARAMETRI:   p_ottica
                    p_codice_uo
                    p_data
       RITORNA:     anagrafe_unita_organizzative.progr_unita_organizzativa%type.
       NOTE:
      ******************************************************************************/
      d_result    anagrafe_unita_organizzative.progr_unita_organizzativa%type;
      d_data      anagrafe_unita_organizzative.dal%type;
      d_revisione revisioni_struttura.revisione%type;
   begin
      d_revisione := revisione_struttura.get_revisione_mod(p_ottica);
      --
      -- Se la data non e indicata, si assume la data di sistema
      --
      d_data := p_data;
      if d_data is null then
         d_data := trunc(sysdate);
      end if;
      --
      begin
         select progr_unita_organizzativa
           into d_result
           from anagrafe_unita_organizzative
          where codice_uo = p_codice_uo
            and revisione_istituzione != d_revisione
            and d_data between dal and
                nvl(decode(revisione_cessazione, d_revisione, to_date(null), al)
                   ,to_date('3333333', 'j'))
            and ((ottica = p_ottica and p_ottica is not null) or
                (amministrazione = p_amministrazione and p_amministrazione is not null))
            and ((codice_uo = p_codice_uo and p_codice_uo is not null) or
                (utente_ad4 = p_utente_ad4 and p_utente_ad4 is not null));
      exception
         when others then
            d_result := null;
      end;
      --
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_progr_unor
   --------------------------------------------------------------------------------
   function get_ultimo_codice
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.codice_uo%type is
      /******************************************************************************
       NOME:        get_ultimo_codice
       DESCRIZIONE: Restituisce il codice dell'ultimo record valido alla data indicata.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.codice_uo%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.codice_uo%type;
   begin
      begin
         select a1.codice_uo
           into d_result
           from anagrafe_unita_organizzative a1
          where a1.progr_unita_organizzativa = p_progr_unita_organizzativa
            and a1.dal =
                (select max(a2.dal)
                   from anagrafe_unita_organizzative a2
                  where a2.progr_unita_organizzativa = p_progr_unita_organizzativa
                    and a2.dal < p_dal);
      exception
         when no_data_found then
            d_result := null;
      end;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_ultimo_codice
   --------------------------------------------------------------------------------
   function get_periodo_precedente
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
     ,p_rowid                     in rowid
   ) return afc_periodo.t_periodo is
      /******************************************************************************
       NOME:        get_periodo_precedente
       DESCRIZIONE: Restituisce le date del periodo immediatamente precedente a quello
                    indicato
       PARAMETRI:   Progr. unita' organizzativa
                    Dal
                    Rowid
       RITORNA:     AFC_periodo.t_periodo
      ******************************************************************************/
      d_result afc_periodo.t_periodo;
   begin
      begin
         select a1.dal
               ,a1.al
           into d_result.dal
               ,d_result.al
           from anagrafe_unita_organizzative a1
          where a1.progr_unita_organizzativa = p_progr_unita_organizzativa
            and a1.rowid != p_rowid
            and a1.dal =
                (select max(a2.dal)
                   from anagrafe_unita_organizzative a2
                  where a2.progr_unita_organizzativa = p_progr_unita_organizzativa
                    and a2.dal < p_dal
                    and a2.rowid != p_rowid);
      exception
         when others then
            d_result.dal := null;
            d_result.al  := null;
      end;
      --
      return d_result;
      --
   end; -- anagrafe_unita_organizzativa.get_periodo_precedente
   --------------------------------------------------------------------------------
   function get_descrizione_corrente
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.descrizione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_descrizione_corrente
       DESCRIZIONE: Restituisce la descrizione dell'unità considerando la revisione in modifica
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.descrizione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_ottica anagrafe_unita_organizzative.ottica%type;
      d_result anagrafe_unita_organizzative.descrizione%type;
   begin
      begin
         select descrizione
           into d_result
           from anagrafe_unita_organizzative
          where progr_unita_organizzativa = p_progr_unita_organizzativa
            and p_dal between dal and nvl(al, to_date(3333333, 'j'));
      exception
         when no_data_found then
            d_result := null;
      end;
      if d_result is null then
         begin
            select a.ottica
              into d_ottica
              from anagrafe_unita_organizzative a
             where a.progr_unita_organizzativa = p_progr_unita_organizzativa;
         exception
            when others then
               d_ottica := null;
         end;
         if d_ottica is not null then
            if revisione_struttura.get_revisione_mod(p_ottica => d_ottica) != -1 then
               begin
                  select a.descrizione
                    into d_result
                    from anagrafe_unita_organizzative a
                   where a.progr_unita_organizzativa = p_progr_unita_organizzativa
                     and a.revisione_istituzione =
                         revisione_struttura.get_revisione_mod(d_ottica);
               exception
                  when others then
                     d_result := null;
               end;
            end if;
         end if;
      end if;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_descrizione_corrente');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'descrizione')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_descrizione_corrente');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_descrizione_corrente
   --------------------------------------------------------------------------------
   function get_codice_uo_corrente
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.codice_uo%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_codice_uo_corrente
       DESCRIZIONE: Restituisce il codice dell'unità considerando la revisione in modifica
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.codice_uo%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_ottica anagrafe_unita_organizzative.ottica%type;
      d_result anagrafe_unita_organizzative.codice_uo%type;
   begin
      begin
         select a.codice_uo
           into d_result
           from anagrafe_unita_organizzative a
          where a.progr_unita_organizzativa = p_progr_unita_organizzativa
            and p_dal between a.dal and nvl(a.al, to_date(3333333, 'j'));
      exception
         when no_data_found then
            d_result := null;
      end;
      if d_result is null then
         begin
            select a.ottica
              into d_ottica
              from anagrafe_unita_organizzative a
             where a.progr_unita_organizzativa = p_progr_unita_organizzativa;
         exception
            when others then
               d_ottica := null;
         end;
         if d_ottica is not null then
            if revisione_struttura.get_revisione_mod(p_ottica => d_ottica) != -1 then
               begin
                  select a.codice_uo
                    into d_result
                    from anagrafe_unita_organizzative a
                   where a.progr_unita_organizzativa = p_progr_unita_organizzativa
                     and a.revisione_istituzione =
                         revisione_struttura.get_revisione_mod(d_ottica);
               exception
                  when others then
                     d_result := null;
               end;
            end if;
         end if;
      end if;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_codice_uo_corrente');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'codice_uo')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_codice_uo_corrente');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_codice_uo_corrente
   --------------------------------------------------------------------------------
   function get_codice_ipa_corrente  --#52548
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.codice_ipa%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_codice_ipa_corrente
       DESCRIZIONE: Restituisce il codice univoco ipa dell'unità considerando la revisione in modifica
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.codice_ipa%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_ottica anagrafe_unita_organizzative.ottica%type;
      d_result anagrafe_unita_organizzative.codice_ipa%type;
   begin
      begin
         select a.codice_ipa
           into d_result
           from anagrafe_unita_organizzative a
          where a.progr_unita_organizzativa = p_progr_unita_organizzativa
            and p_dal between a.dal and nvl(a.al, to_date(3333333, 'j'));
      exception
         when no_data_found then
            d_result := null;
      end;
      if d_result is null then
         begin
            select a.ottica
              into d_ottica
              from anagrafe_unita_organizzative a
             where a.progr_unita_organizzativa = p_progr_unita_organizzativa;
         exception
            when others then
               d_ottica := null;
         end;
         if d_ottica is not null then
            if revisione_struttura.get_revisione_mod(p_ottica => d_ottica) != -1 then
               begin
                  select a.codice_ipa
                    into d_result
                    from anagrafe_unita_organizzative a
                   where a.progr_unita_organizzativa = p_progr_unita_organizzativa
                     and a.revisione_istituzione =
                         revisione_struttura.get_revisione_mod(d_ottica);
               exception
                  when others then
                     d_result := null;
               end;
            end if;
         end if;
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_codice_ipa_corrente
   --------------------------------------------------------------------------------
   function get_id_suddivisione_corrente
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzative.id_suddivisione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_id_suddivisione_corrente
       DESCRIZIONE: Restituisce l'id_suddivisione dell'unità considerando la revisione in modifica
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_organizzative.id_suddivisione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_ottica anagrafe_unita_organizzative.ottica%type;
      d_result anagrafe_unita_organizzative.id_suddivisione%type;
   begin
      begin
         select a.id_suddivisione
           into d_result
           from anagrafe_unita_organizzative a
          where a.progr_unita_organizzativa = p_progr_unita_organizzativa
            and p_dal between a.dal and nvl(a.al, to_date(3333333, 'j'));
      exception
         when no_data_found then
            d_result := null;
      end;
      if d_result is null then
         begin
            select a.ottica
              into d_ottica
              from anagrafe_unita_organizzative a
             where a.progr_unita_organizzativa = p_progr_unita_organizzativa;
         exception
            when others then
               d_ottica := null;
         end;
         if d_ottica is not null then
            if revisione_struttura.get_revisione_mod(p_ottica => d_ottica) != -1 then
               begin
                  select a.id_suddivisione
                    into d_result
                    from anagrafe_unita_organizzative a
                   where a.progr_unita_organizzativa = p_progr_unita_organizzativa
                     and a.revisione_istituzione =
                         revisione_struttura.get_revisione_mod(d_ottica);
               exception
                  when others then
                     d_result := null;
               end;
            end if;
         end if;
      end if;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on anagrafe_unita_organizzativa.get_id_suddivisione_corrente');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'id_suddivisione')
                      ,' AFC_DDL.IsNullable on anagrafe_unita_organizzativa.get_id_suddivisione_corrente');
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_id_suddivisione_corrente
   --------------------------------------------------------------------------------
   function get_num_modifiche_uo
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_comp_ottica               in componenti.ottica%type
     ,p_comp_rev_cess             in componenti.revisione_cessazione%type
     ,p_comp_rev_mod              in componenti.revisione_cessazione%type
     ,p_comp_dal                  in componenti.dal%type
     ,p_comp_al                   in componenti.al%type
   ) return number is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_num_modifiche_uo
       DESCRIZIONE: Restituisce il numero delle modifiche a codice e descrizione
                    dell'unita' nel periodo
      ******************************************************************************/
      d_result number;
   begin
      select count(distinct codice_uo || descrizione)
        into d_result
        from anagrafe_unita_organizzative u
       where u.progr_unita_organizzativa = p_progr_unita_organizzativa
         and u.revisione_istituzione != p_comp_rev_mod
         and u.dal <=
             nvl(decode(nvl(p_comp_rev_cess, -2), p_comp_rev_mod, u.al_prec, p_comp_al)
                ,to_date(3333333, 'j'))
         and nvl(decode(nvl(u.revisione_cessazione, -2), p_comp_rev_mod, u.al_prec, u.al)
                ,to_date(3333333, 'j')) >= nvl(p_comp_dal, to_date(2222222, 'j'));
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_num_modifiche_uo
   --------------------------------------------------------------------------------
   procedure chk_ins
   (
      p_ottica                    in anagrafe_unita_organizzative.ottica%type
     ,p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
     ,p_codice_uo                 in anagrafe_unita_organizzative.codice_uo%type
   ) is
      /******************************************************************************
       NOME:        chk_ins.
       DESCRIZIONE: Se l'ottica e' gestita a revisioni, controlla la presenze di una
                    revisione in modifica
       PARAMETRI:   p_ottica
       NOTE:        --
      ******************************************************************************/
      d_codice_prec   anagrafe_unita_organizzative.codice_uo%type;
      d_gestione_rev  ottiche.gestione_revisioni%type;
      d_revisione_mod revisioni_struttura.revisione%type;
   begin
      d_codice_prec := get_ultimo_codice(p_progr_unita_organizzativa, p_dal);
      if d_codice_prec is null or d_codice_prec <> p_codice_uo then
         d_gestione_rev := ottica.get_gestione_revisioni(p_ottica);
         if d_gestione_rev = 'SI' then
            d_revisione_mod := revisione_struttura.get_revisione_mod(p_ottica);
            if d_revisione_mod = -1 then
               raise_application_error(-20999
                                      ,'Non esiste revisione in modifica per l''ottica ' ||
                                       p_ottica ||
                                       '. La registrazione  non puo'' essere inserita.');
            end if;
         end if;
      end if;
   end; -- anagrafe_unita_organizzativa.chk_ins
   --------------------------------------------------------------------------------
   function is_dal_al_ok
   (
      p_dal in anagrafe_unita_organizzative.dal%type
     ,p_al  in anagrafe_unita_organizzative.al%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_dal_al_ok
       DESCRIZIONE: Controlla che le date di inizio e fine validita'
                    siano congruenti
       PARAMETRI:   p_dal
                    p_al
       RITORNA:     Afc_error.t_error_number
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
      if nvl(p_dal, to_date('01011800', 'ddmmyyyy')) <=
         nvl(p_al, to_date('3333333', 'j')) then
         d_result := afc_error.ok;
      else
         d_result := s_dal_al_errato_num;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on anagrafe_unita_organizzativa.is_dal_al_ok');
      return d_result;
   end; -- anagrafe_unita_organizzativa.is_dal_al_ok
   --------------------------------------------------------------------------------
   function is_des_abb_ok
   (
      p_ottica  in anagrafe_unita_organizzative.ottica%type
     ,p_des_abb in anagrafe_unita_organizzative.des_abb%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_des_abb_ok
       DESCRIZIONE: Controlla che la descrizione abbreviata della U.O. non sia nulla
                    per U.O. dell'ottica istituzionale (per l'inserimento dell'utente
                    di tipo "O" in AD4)
       PARAMETRI:   p_ottica
                    p_des_abb
       RITORNA:     Afc_error.t_error_number
      ******************************************************************************/
      d_ottica_istituzionale ottiche.ottica_istituzionale%type;
      d_result               afc_error.t_error_number := afc_error.ok;
   begin
      if p_ottica is not null then
         d_ottica_istituzionale := ottica.get_ottica_istituzionale(p_ottica);
         if d_ottica_istituzionale = 'SI' and p_des_abb is null then
            d_result := s_des_abb_errata_num;
         end if;
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzative.is_des_abb_ok
   --------------------------------------------------------------------------------
   function is_aoo_ok
   (
      p_ottica    in anagrafe_unita_organizzative.ottica%type
     ,p_progr_aoo in anagrafe_unita_organizzative.progr_aoo%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_AOO_ok
       DESCRIZIONE: Controlla che la AOO della U.O. non sia nulla
                    per U.O. dell'ottica istituzionale (per l'inserimento dell'utente
                    di tipo "O" in AD4)
       PARAMETRI:   p_ottica
                    p_progr_aoo
       RITORNA:     Afc_error.t_error_number
      ******************************************************************************/
      d_ottica_istituzionale ottiche.ottica_istituzionale%type;
      d_result               afc_error.t_error_number := afc_error.ok;
   begin
      if p_ottica is not null then
         d_ottica_istituzionale := ottica.get_ottica_istituzionale(p_ottica);
         if d_ottica_istituzionale = 'SI' and p_progr_aoo is null then
            d_result := s_progr_aoo_errato_num;
         end if;
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzative.is_AOO_ok
   --------------------------------------------------------------------------------
   function is_indirizzo_ok
   (
      p_amministrazione in anagrafe_unita_organizzative.amministrazione%type
     ,p_indirizzo       in anagrafe_unita_organizzative.indirizzo%type
     ,p_cap             in anagrafe_unita_organizzative.cap%type
     ,p_provincia       in anagrafe_unita_organizzative.provincia%type
     ,p_comune          in anagrafe_unita_organizzative.comune%type
     ,p_telefono        in anagrafe_unita_organizzative.telefono%type
     ,p_fax             in anagrafe_unita_organizzative.fax%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_indirizzo_ok
       DESCRIZIONE: Controlla che non venga indicato l'indirizzo per U.O. di una
                    amministrazione gestita da SO4 (non più utilizzata)
       PARAMETRI:   p_amministrazione
                    p_indirizzo
                    p_cap
                    p_provincia
                    p_comune
                    p_telefono
                    p_fax
       RITORNA:     Afc_error.t_error_number
      ******************************************************************************/
      d_result afc_error.t_error_number := afc_error.ok;
      d_ente   amministrazioni.ente%type;
   begin
      if p_amministrazione is not null then
         d_ente := amministrazione.get_ente(p_amministrazione);
         if d_ente = 'SI' and
            (p_indirizzo is not null or p_cap is not null or p_provincia is not null or
            p_comune is not null or p_telefono is not null or p_fax is not null) then
            d_result := s_indirizzo_errato_num;
         end if;
      end if;
      --
      return d_result;
   end; -- anagrafe_unita_organizzativa.is_indirizzo_ok
   --------------------------------------------------------------------------------
   -- function di gestione di Data Integrity
   function is_di_ok
   (
      p_dal                   in anagrafe_unita_organizzative.dal%type
     ,p_al                    in anagrafe_unita_organizzative.al%type
     ,p_ottica                in anagrafe_unita_organizzative.ottica%type
     ,p_des_abb               in anagrafe_unita_organizzative.des_abb%type
     ,p_progr_aoo             in anagrafe_unita_organizzative.progr_aoo%type
     ,p_amministrazione       in anagrafe_unita_organizzative.amministrazione%type
     ,p_indirizzo             in anagrafe_unita_organizzative.indirizzo%type default null
     ,p_cap                   in anagrafe_unita_organizzative.cap%type default null
     ,p_provincia             in anagrafe_unita_organizzative.provincia%type default null
     ,p_comune                in anagrafe_unita_organizzative.comune%type default null
     ,p_telefono              in anagrafe_unita_organizzative.telefono%type default null
     ,p_fax                   in anagrafe_unita_organizzative.fax%type default null
     ,p_revisione_istituzione in anagrafe_unita_organizzative.revisione_istituzione%type default null
     ,p_revisione_cessazione  in anagrafe_unita_organizzative.revisione_cessazione%type default null
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_DI_ok
       DESCRIZIONE: Controllo data integrity:
                    dal < al
                    des_abb obbligatoria per U.O. dell'ottica istituzionale
                    AOO obbligatoria per U.O. dell'ottica istituzionale
                    Dati indirizzo nulli per U.O. delle amministrazioni gestite in SO4
       PARAMETRI:   p_dal
                    p_al
                    p_ottica
                    p_des_abb
                    p_progr_aoo
                    p_amministrazione
                    p_indirizzo
                    p_cap
                    p_provincia
                    p_comune
                    p_telefono
                    p_fax
                    p_revisione_istituzione
                    p_revisione_cessazione
       RITORNA:     Afc_error.t_error_number
      ******************************************************************************/
      d_result afc_error.t_error_number := afc_error.ok;
   begin
      if p_revisione_cessazione is not null then
         set_tipo_revisione(p_ottica, p_revisione_cessazione);
      end if;
      if nvl(s_tipo_revisione, 'N') <> 'R' then
         d_result := is_dal_al_ok(p_dal, p_al);
      end if;
      if d_result = afc_error.ok then
         d_result := is_des_abb_ok(p_ottica, p_des_abb);
      end if;
      if d_result = afc_error.ok then
         d_result := is_aoo_ok(p_ottica, p_progr_aoo);
      end if;
      /*  if d_result = afc_error.ok
        then
           d_result := is_indirizzo_ok ( p_amministrazione
                                       , p_indirizzo
                                       , p_cap
                                       , p_provincia
                                       , p_comune
                                       , p_telefono
                                       , p_fax );
        end if;
      */
      if d_result = afc_error.ok then
         d_result := is_revisioni_ok(p_revisione_istituzione, p_revisione_cessazione);
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on Anagrafe_unita_organizzativa.is_DI_ok');
      return d_result;
   end; -- Anagrafe_unita_organizzativa.is_DI_ok
   --------------------------------------------------------------------------------
   -- procedure di gestione di Data Integrity
   procedure chk_di
   (
      p_dal                   in anagrafe_unita_organizzative.dal%type
     ,p_al                    in anagrafe_unita_organizzative.al%type
     ,p_ottica                in anagrafe_unita_organizzative.ottica%type
     ,p_des_abb               in anagrafe_unita_organizzative.des_abb%type
     ,p_progr_aoo             in anagrafe_unita_organizzative.progr_aoo%type
     ,p_amministrazione       in anagrafe_unita_organizzative.amministrazione%type
     ,p_indirizzo             in anagrafe_unita_organizzative.indirizzo%type default null
     ,p_cap                   in anagrafe_unita_organizzative.cap%type default null
     ,p_provincia             in anagrafe_unita_organizzative.provincia%type default null
     ,p_comune                in anagrafe_unita_organizzative.comune%type default null
     ,p_telefono              in anagrafe_unita_organizzative.telefono%type default null
     ,p_fax                   in anagrafe_unita_organizzative.fax%type default null
     ,p_revisione_istituzione in anagrafe_unita_organizzative.revisione_istituzione%type default null
     ,p_revisione_cessazione  in anagrafe_unita_organizzative.revisione_cessazione%type default null
   ) is
      /******************************************************************************
       NOME:        chk_DI.
       DESCRIZIONE: controllo data integrity
       RITORNA:     -
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
      if anagrafe_unita_organizzativa.s_eliminazione_logica = 0 then
         --#703
         d_result := is_di_ok(p_dal                   => p_dal
                             ,p_al                    => p_al
                             ,p_ottica                => p_ottica
                             ,p_des_abb               => p_des_abb
                             ,p_progr_aoo             => p_progr_aoo
                             ,p_amministrazione       => p_amministrazione
                             ,p_indirizzo             => p_indirizzo
                             ,p_cap                   => p_cap
                             ,p_provincia             => p_provincia
                             ,p_comune                => p_comune
                             ,p_telefono              => p_telefono
                             ,p_fax                   => p_fax
                             ,p_revisione_istituzione => p_revisione_istituzione
                             ,p_revisione_cessazione  => p_revisione_cessazione);
         dbc.assertion(not dbc.assertionon or d_result = afc_error.ok or d_result < 0
                      ,'d_result = AFC_Error.ok or d_result < 0 on Anagrafe_unita_organizzativa.chk_DI');
         if not (d_result = afc_error.ok) then
            raise_application_error(d_result, error_message(d_result));
         end if;
      end if;
   end; -- Anagrafe_unita_organizzative.chk_DI
   --------------------------------------------------------------------------------
   function is_last_record(p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type)
      return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_last_record
       DESCRIZIONE: In caso di eliminazione, controlla che non esistano referenze per
                    la U.O. nelle tabelle dipendenti:
                    UNITA_ORGANIZZATIVE
                    COMPONENTI
                    UBICAZIONI_UNITA
                    INDIRIZZI_TELEMATICI
       PARAMETRI:   p_progr_unita_organizzativa
       RITORNA:     Afc_error.t_error_number
      ******************************************************************************/
      d_result        afc_error.t_error_number;
      d_select_result number;
   begin
      -- Si controlla quanti record esistono per l'anagrafe_unita_organizzative da eliminare
      begin
         select count(*)
           into d_select_result
           from anagrafe_unita_organizzative
          where progr_unita_organizzativa = p_progr_unita_organizzativa;
      exception
         when others then
            d_select_result := 0;
      end;
      --
      -- Se non esistono altri record della stessa anagrafe_unita_organizzative oltre a quello che si
      -- sta cancellando, si verifica che non esistano referenze alla anagrafe_unita_organizzative
      -- sulle tabelle figlie (UNITA_ORGANIZZATIVE, COMPONENTI, UBICAZIONI_UNITA, INDIRIZZI_TELEMATICI,
      -- ASSEGNAZIONI_FISICHE)
      -- (in questo caso l'anagrafe_unita_organizzative non e' eliminabile)
      --
      if d_select_result > 0 then
         d_result := afc_error.ok;
      else
         -- unita organizzative: unita figlia
         begin
            select count(*)
              into d_select_result
              from unita_organizzative
             where progr_unita_organizzativa = p_progr_unita_organizzativa;
         exception
            when others then
               d_select_result := 1;
         end;
         if d_select_result > 0 then
            d_result := s_auo_non_elim_1_num;
         else
            d_result := afc_error.ok;
         end if;
         -- unita organizzative: unita padre
         if d_result = afc_error.ok then
            begin
               select count(*)
                 into d_select_result
                 from unita_organizzative
                where id_unita_padre = p_progr_unita_organizzativa;
            exception
               when others then
                  d_select_result := 1;
            end;
            if d_select_result > 0 then
               d_result := s_auo_non_elim_1_num;
            else
               d_result := afc_error.ok;
            end if;
         end if;
         -- componenti
         if d_result = afc_error.ok then
            begin
               select count(*)
                 into d_select_result
                 from componenti
                where progr_unita_organizzativa = p_progr_unita_organizzativa;
            exception
               when others then
                  d_select_result := 1;
            end;
            if d_select_result > 0 then
               d_result := s_auo_non_elim_2_num;
            else
               d_result := afc_error.ok;
            end if;
         end if;
         -- ubicazioni_unita
         if d_result = afc_error.ok then
            begin
               select count(*)
                 into d_select_result
                 from ubicazioni_unita
                where progr_unita_organizzativa = p_progr_unita_organizzativa;
            exception
               when others then
                  d_select_result := 1;
            end;
            if d_select_result > 0 then
               d_result := s_auo_non_elim_3_num;
            else
               d_result := afc_error.ok;
            end if;
         end if;
         -- indirizzi_telematici
         if d_result = afc_error.ok then
            begin
               select count(*)
                 into d_select_result
                 from indirizzi_telematici
                where tipo_entita = 'UO'
                  and id_indirizzo = p_progr_unita_organizzativa
                  and id_unita_organizzativa = p_progr_unita_organizzativa;
            exception
               when others then
                  d_select_result := 1;
            end;
            if d_select_result > 0 then
               d_result := s_auo_non_elim_4_num;
            else
               d_result := afc_error.ok;
            end if;
         end if;
         -- assegnazioni_fisiche
         if d_result = afc_error.ok then
            begin
               select count(*)
                 into d_select_result
                 from assegnazioni_fisiche
                where progr_unita_organizzativa = p_progr_unita_organizzativa;
            exception
               when others then
                  d_select_result := 1;
            end;
            if d_select_result > 0 then
               d_result := s_auo_non_elim_5_num;
            else
               d_result := afc_error.ok;
            end if;
         end if;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0);
      return d_result;
   end; -- anagrafe_unita_organizzativa.is_last_record
   --------------------------------------------------------------------------------
   function is_ultimo_periodo
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_ultimo_periodo
       DESCRIZIONE: Se il periodo passato è l'ultimo restituisce 1, altrimenti 0
       PARAMETRI:   p_progr_unita_organizzativa
                    p_dal (per IS_RI_OK passare il nuovo dal)
       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
      begin
         select afc_error.ok
           into d_result
           from anagrafe_unita_organizzative a1
          where a1.progr_unita_organizzativa = p_progr_unita_organizzativa
            and a1.dal = p_dal
            and not exists
          (select 'x'
                   from anagrafe_unita_organizzative a2
                  where a2.progr_unita_organizzativa = p_progr_unita_organizzativa
                    and a2.dal > p_dal);
      exception
         when no_data_found then
            d_result := 0;
         when others then
            raise_application_error(-20999
                                   ,'(' || p_progr_unita_organizzativa || ' ' || p_dal || ' ' ||
                                    sqlerrm);
      end;
      --
      return d_result;
      --
   end; -- anagrafe_unita_organizzativa.is_ultimo_periodo
   --------------------------------------------------------------------------------
   function is_al_ok
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_new_dal                   in anagrafe_unita_organizzative.dal%type
     ,p_new_al                    in anagrafe_unita_organizzative.al%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_al_ok
       DESCRIZIONE: Controllo al
       PARAMETRI:   p_progr_aoo
                    p_new_dal
                    p_new_al
       NOTE:        --
      ******************************************************************************/
      d_numero_righe number;
      d_result       afc_error.t_error_number;
   begin
      d_result := is_ultimo_periodo(p_progr_unita_organizzativa, p_new_dal);
      if d_result = afc_error.ok then
         d_numero_righe := unita_organizzativa.conta_righe(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                                                          ,p_data                      => p_new_al);
         if d_numero_righe = 0 then
            d_result := afc_error.ok;
         else
            d_result := s_unita_presente_num;
         end if;
      else
         d_result := afc_error.ok;
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.is_al_ok
   --------------------------------------------------------------------------------
   function is_periodo_ok
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_new_dal                   in anagrafe_unita_organizzative.dal%type
     ,p_new_al                    in anagrafe_unita_organizzative.al%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_periodo_ok
       DESCRIZIONE: Controllo is_periodo_ok
       PARAMETRI:   p_progr_unita_organizzativa
                    p_new_dal
                    p_new_al
       NOTE:        --
      ******************************************************************************/
      d_contatore number(8);
      d_min_dal   date;
      d_result    afc_error.t_error_number;
   begin
      --
      -- Si controlla che il periodo inserito non intersechi uno o piu' periodi
      -- gia' presenti
      --
      begin
         select min(dal)
               ,count(*)
           into d_min_dal
               ,d_contatore
           from anagrafe_unita_organizzative a
          where a.progr_unita_organizzativa = p_progr_unita_organizzativa
            and ((a.dal < p_new_dal and
                nvl(a.al, p_new_dal - 1) > nvl(p_new_al, to_date(3333333, 'j'))) or
                (a.dal > p_new_dal and
                nvl(a.al, to_date(3333332, 'j')) < nvl(p_new_al, to_date(3333333, 'j'))));
      exception
         when others then
            raise_application_error(-20999
                                   ,'Prg. unita ' || p_progr_unita_organizzativa || ' ' ||
                                    sqlerrm);
      end;
      if d_contatore > 0 then
         d_result := s_periodo_errato_num;
      else
         d_result := afc_error.ok;
      end if;
      --
      return d_result;
      --
   end; -- anagrafe_unita_organizzativa.is_periodo_ok
   --------------------------------------------------------------------------------
   function is_codice_ok
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_codice_uo                 in anagrafe_unita_organizzative.codice_uo%type
     ,p_amministrazione           in anagrafe_unita_organizzative.amministrazione%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_codice_ok
       DESCRIZIONE: Controllo univocita' codice U.O
       PARAMETRI:   p_progr_aoo
                    p_codice_uo
                    p_amministrazione
       NOTE:        --
      ******************************************************************************/
      d_result        afc_error.t_error_number;
      d_select_result number;
   begin
      -- Si controlla se esistono altre unita' per la stessa amministrazione
      -- con lo stesso codice
      begin
         select count(*)
           into d_select_result
           from anagrafe_unita_organizzative
          where progr_unita_organizzativa <> p_progr_unita_organizzativa
            and codice_uo = p_codice_uo
            and amministrazione = p_amministrazione;
      exception
         when others then
            d_select_result := 1;
      end;
      if d_select_result = 0 then
         d_result := afc_error.ok;
      else
         d_result := s_codice_errato_num;
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.is_codice_ok
   --------------------------------------------------------------------------------
   function is_descrizione_ok
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_descrizione               in anagrafe_unita_organizzative.descrizione%type
     ,p_amministrazione           in anagrafe_unita_organizzative.amministrazione%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_descrizione_ok
       DESCRIZIONE: Controllo univocita' descrizione U.O. (non più usata)
       PARAMETRI:   p_progr_aoo
                    p_descrizione
                    p_amministrazione
       NOTE:        --
      ******************************************************************************/
      d_result        afc_error.t_error_number;
      d_select_result number;
   begin
      -- Si controlla se esistono altre unita' per la stessa amministrazione
      -- con la stessa descrizione
      begin
         select count(*)
           into d_select_result
           from anagrafe_unita_organizzative
          where progr_unita_organizzativa <> p_progr_unita_organizzativa
            and descrizione = p_descrizione
            and amministrazione = p_amministrazione;
      exception
         when others then
            d_select_result := 1;
      end;
      --
      if d_select_result = 0 then
         d_result := afc_error.ok;
      else
         d_result := s_descrizione_errata_num;
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.is_descrizione_ok
   --------------------------------------------------------------------------------
   function is_des_abb_ok
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_des_abb                   in anagrafe_unita_organizzative.des_abb%type
     ,p_amministrazione           in anagrafe_unita_organizzative.amministrazione%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_des_abb_ok
       DESCRIZIONE: Controllo univocita' descr. abbr. U.O.
       PARAMETRI:   p_progr_aoo
                    p_des_abb
                    p_amministrazione
       NOTE:        --
      ******************************************************************************/
      d_result        afc_error.t_error_number;
      d_select_result number;
   begin
      -- Si controlla se esistono altre unita' per la stessa amministrazione
      -- con la stessa descrizione abbreviata
      begin
         select count(*)
           into d_select_result
           from anagrafe_unita_organizzative
          where progr_unita_organizzativa <> p_progr_unita_organizzativa
            and des_abb = p_des_abb
            and amministrazione = p_amministrazione;
      exception
         when others then
            d_select_result := 1;
      end;
      --
      if d_select_result = 0 then
         d_result := afc_error.ok;
      else
         d_result := s_des_abb_usata_num;
      end if;
      return d_result;
   end; -- anagrafe_unita_organizzativa.is_des_abb_ok
   --------------------------------------------------------------------------------
   function is_revisioni_ok
   (
      p_revisione_istituzione in anagrafe_unita_organizzative.revisione_istituzione%type
     ,p_revisione_cessazione  in anagrafe_unita_organizzative.revisione_cessazione%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_revisioni_ok
       DESCRIZIONE: Controlla che le revisioni siano congruenti
       PARAMETRI:   p_revisione_istituzione
                    p_revisione_cessazione
       RITORNA:     Afc_error.t_error_number
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
      if (p_revisione_istituzione is null) or (p_revisione_cessazione is null) or
         (p_revisione_istituzione is not null and p_revisione_cessazione is not null and
         p_revisione_istituzione < p_revisione_cessazione) then
         d_result := afc_error.ok;
      else
         d_result := s_revisioni_errate_num;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on anagrafe_unita_organizzativa.is_revisioni_ok');
      return d_result;
   end; -- anagrafe_unita_organizzativa.is_revisioni_ok
   --------------------------------------------------------------------------------
   function is_aggregatore_ok
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_ottica                    in anagrafe_unita_organizzative.ottica%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
     ,p_al                        in anagrafe_unita_organizzative.al%type
     ,p_aggregatore               in anagrafe_unita_organizzative.aggregatore%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_aggregatore_ok
       DESCRIZIONE: Controlla l'univocita' dell'assegnazione dell'aggregatore
       PARAMETRI:
       RITORNA:     Afc_error.t_error_number
      ******************************************************************************/
      d_result afc_error.t_error_number := afc_error.ok;
   begin
      begin
         select s_aggregatore_errato_num
           into d_result
           from anagrafe_unita_organizzative
          where progr_unita_organizzativa != p_progr_unita_organizzativa
            and dal < nvl(p_al, to_date(3333333, 'j'))
            and nvl(al, to_date(3333333, 'j')) >= p_dal
            and aggregatore = p_aggregatore
            and ottica = p_ottica;
      exception
         when too_many_rows then
            d_result := s_aggregatore_errato_num;
         when no_data_found then
            null;
      end;
      return d_result;
   end;
   function is_ri_ok
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_codice_uo                 in anagrafe_unita_organizzative.codice_uo%type
     ,p_descrizione               in anagrafe_unita_organizzative.descrizione%type
     ,p_des_abb                   in anagrafe_unita_organizzative.des_abb%type
     ,p_amministrazione           in anagrafe_unita_organizzative.amministrazione%type
     ,p_old_dal                   in anagrafe_unita_organizzative.dal%type
     ,p_new_dal                   in anagrafe_unita_organizzative.dal%type
     ,p_old_al                    in anagrafe_unita_organizzative.al%type
     ,p_new_al                    in anagrafe_unita_organizzative.al%type
     ,p_ottica                    in anagrafe_unita_organizzative.ottica%type
     ,p_aggregatore               in anagrafe_unita_organizzative.aggregatore%type
     ,p_rowid                     in rowid
     ,p_inserting                 in number
     ,p_updating                  in number
     ,p_deleting                  in number
     ,p_nest_level                in integer
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_RI_ok.
       DESCRIZIONE: function di gestione della Referential Integrity:
                    - is_dal_ok
                    - is_al_ok
                    - is_codice_ok
                    - is_descrizione_ok (non più usata)
                    - is_des_abb_ok
       PARAMETRI:   p_progr_unita_organizzativa
                    p_codice_uo
                    p_descrizione
                    p_des_abb
                    p_amministrazione
                    p_old_dal
                    p_new_dal
                    p_old_al
                    p_new_al
                    p_rowid
                    p_inserting
                    p_updating
                    p_deleting
       RETURN:      1 se tutti i controlli danno esito positivo, l'error_code altrimenti
       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number := afc_error.ok;
   begin
      d_result := afc_error.ok;
      /*set_tipo_revisione(p_ottica, revisione_struttura.get_revisione_mod(p_ottica));*/
      if p_deleting = 1 then
         d_result := is_last_record(p_progr_unita_organizzativa);
      end if;
      if (p_inserting = 1 or p_updating = 1) and p_nest_level = 0 then
         if p_old_al is null and p_new_al is not null /*and s_tipo_revisione <> 'R'*/
          then
            d_result := is_al_ok(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                                ,p_new_dal                   => p_new_dal
                                ,p_new_al                    => p_new_al);
         end if;
         if d_result = afc_error.ok /*and s_tipo_revisione <> 'R'*/
          then
            if nvl(p_old_dal, to_date('3333333', 'j')) <>
               nvl(p_new_dal, to_date('3333333', 'j')) or
               nvl(p_old_al, to_date('3333333', 'j')) <>
               nvl(p_new_al, to_date('3333333', 'j')) then
               d_result := is_periodo_ok(p_progr_unita_organizzativa, p_new_dal, p_new_al);
            end if;
         end if;
         -- is_codice_ok
         if d_result = afc_error.ok then
            d_result := is_codice_ok(p_progr_unita_organizzativa
                                    ,p_codice_uo
                                    ,p_amministrazione);
         end if;
         -- is_des_abb_ok
         if d_result = afc_error.ok then
            d_result := is_des_abb_ok(p_progr_unita_organizzativa
                                     ,p_des_abb
                                     ,p_amministrazione);
         end if;
         if d_result = afc_error.ok and p_aggregatore is not null then
            d_result := is_aggregatore_ok(p_progr_unita_organizzativa
                                         ,p_ottica
                                         ,p_new_dal
                                         ,p_new_al
                                         ,p_aggregatore);
         end if;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on Anagrafe_unita_organizzative.is_RI_ok');
      return d_result;
   end; -- Anagrafe_unita_organizzative.is_RI_ok
   --------------------------------------------------------------------------------
   procedure chk_ri
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_codice_uo                 in anagrafe_unita_organizzative.codice_uo%type
     ,p_descrizione               in anagrafe_unita_organizzative.descrizione%type
     ,p_des_abb                   in anagrafe_unita_organizzative.des_abb%type
     ,p_amministrazione           in anagrafe_unita_organizzative.amministrazione%type
     ,p_old_dal                   in anagrafe_unita_organizzative.dal%type
     ,p_new_dal                   in anagrafe_unita_organizzative.dal%type
     ,p_old_al                    in anagrafe_unita_organizzative.al%type
     ,p_new_al                    in anagrafe_unita_organizzative.al%type
     ,p_ottica                    in anagrafe_unita_organizzative.ottica%type
     ,p_aggregatore               in anagrafe_unita_organizzative.aggregatore%type
     ,p_rowid                     in rowid
     ,p_inserting                 in number
     ,p_updating                  in number
     ,p_deleting                  in number
     ,p_nest_level                in integer
   ) is
      /******************************************************************************
       NOME:        chk_RI.
       DESCRIZIONE: procedure di gestione della Referential Integrity:
       PARAMETRI:   p_progr_unita_organizzativa
                    p_codice_uo
                    p_descrizione
                    p_des_abb
                    p_amministrazione
                    p_old_dal
                    p_new_dal
                    p_old_al
                    p_new_al
                    p_inserting
                    p_updating
       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
      d_result := is_ri_ok(p_progr_unita_organizzativa
                          ,p_codice_uo
                          ,p_descrizione
                          ,p_des_abb
                          ,p_amministrazione
                          ,p_old_dal
                          ,p_new_dal
                          ,p_old_al
                          ,p_new_al
                          ,p_ottica
                          ,p_aggregatore
                          ,p_rowid
                          ,p_inserting
                          ,p_updating
                          ,p_deleting
                          ,p_nest_level);
      dbc.assertion(not dbc.assertionon or d_result = afc_error.ok or d_result < 0
                   ,'d_result = AFC_Error.ok or d_result < 0 on Anagrafe_unita_organizzative.chk_RI');
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, error_message(d_result));
      end if;
   end; -- Anagrafe_unita_organizzative.chk_RI
   --------------------------------------------------------------------------------
   function get_periodo_successivo
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) return anagrafe_unita_organizzativa.t_periodo is
      /******************************************************************************
       NOME:        get_periodo_successivo
       DESCRIZIONE: Restituisce le date di validita' del periodo immediatamente
                    successivo al periodo modificato per l'unita' organizzativa
       PARAMETRI:   p_progr_unita_organizzativa
                    p_dal
       NOTE:        --
      ******************************************************************************/
      d_result anagrafe_unita_organizzativa.t_periodo;
   begin
      begin
         select a1.dal
               ,a1.al
           into d_result.dal
               ,d_result.al
           from anagrafe_unita_organizzative a1
          where a1.progr_unita_organizzativa = p_progr_unita_organizzativa
            and a1.dal =
                (select min(a2.dal)
                   from anagrafe_unita_organizzative a2
                  where a2.progr_unita_organizzativa = a1.progr_unita_organizzativa
                    and a2.dal > p_dal);
      exception
         when no_data_found then
            d_result.dal := to_date(null);
            d_result.al  := to_date(null);
         when others then
            raise_application_error(-20999
                                   ,'(' || p_progr_unita_organizzativa || ' ' || p_dal || ' ' ||
                                    sqlerrm);
      end;
      --
      return d_result;
      --
   end; -- anagrafe_unita_organizzativa.get_periodo_precedente
   --------------------------------------------------------------------------------
   function get_pk_anue(p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type)
      return anagrafe_unita_organizzative.dal%type is
      d_result anagrafe_unita_organizzative.dal%type;
   begin
      select max(dal) + 1
        into d_result
        from anagrafe_unita_organizzative
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal between to_date(1750000, 'j') and to_date(1999999, 'j');
      if d_result is null then
         d_result := to_date(1750000, 'j');
      end if;
      return d_result;
   end;
   --------------------------------------------------------------------------------
   function is_periodo_eliminato(p_dal in anagrafe_unita_organizzative.dal%type)
      return number is
   begin
      if to_char(p_dal, 'j') between 1750000 and 1999999 then
         return 1;
      else
         return 0;
      end if;
   end;
   --------------------------------------------------------------------------------
   procedure set_al_corrente
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
   ) is
      /******************************************************************************
       NOME:        set_al_corrente
       DESCRIZIONE: Aggiornamento data fine validità periodo inserito (solo se al è nullo)
       PARAMETRI:   p_progr_unita_organizzativa
                    p_dal
       NOTE:        --
      ******************************************************************************/
      d_periodo anagrafe_unita_organizzativa.t_periodo;
   begin
      d_periodo := get_periodo_successivo(p_progr_unita_organizzativa, p_dal);
      if d_periodo.dal is not null then
         update anagrafe_unita_organizzative --#453
            set al = d_periodo.dal - 1
          where progr_unita_organizzativa = p_progr_unita_organizzativa
            and dal = p_dal;
      end if;
   end; -- anagrafe_unita_organizzativa.set_al_corrente
   --------------------------------------------------------------------------------
   procedure set_al_precedente
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
     ,p_al                        in anagrafe_unita_organizzative.al%type
     ,p_ottica                    in anagrafe_unita_organizzative.ottica%type
     ,p_deleting                  in number default 0
   ) is
      d_revisione_mod anagrafe_unita_organizzative.revisione_cessazione%type := revisione_struttura.get_revisione_mod(p_ottica);
      /******************************************************************************
       NOME:        set_al_precedente
       DESCRIZIONE: Aggiornamento data fine validità periodo precedente
       PARAMETRI:   p_progr_unita_organizzativa
                    p_dal
       NOTE:        --
      ******************************************************************************/
   begin
      update anagrafe_unita_organizzative
         set al                   = p_al
            ,revisione_cessazione = decode(p_deleting
                                          ,1
                                          ,null
                                          ,decode(d_revisione_mod
                                                 ,-1
                                                 ,revisione_cessazione
                                                 ,d_revisione_mod))
            ,data_aggiornamento   = trunc(sysdate)
            ,utente_aggiornamento = si4.utente
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and nvl(al, to_date('2222222', 'j')) != nvl(p_al, to_date('2222222', 'j'))
         and dal <= nvl(al, to_date(3333333, 'j')) --#703
         and dal = (select max(dal)
                      from anagrafe_unita_organizzative
                     where progr_unita_organizzativa = p_progr_unita_organizzativa
                       and dal <= nvl(al, to_date(3333333, 'j')) --#703
                       and dal < p_dal);
   end; -- anagrafe_unita_organizzativa.set_al_precedente
   --------------------------------------------------------------------------------
   procedure set_dal_successivo
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
     ,p_new_dal                   in anagrafe_unita_organizzative.dal%type
   ) is
      /******************************************************************************
       NOME:        set_dal_successivo
       DESCRIZIONE: Aggiornamento data fine validità periodo precedente
       PARAMETRI:   p_progr_unita_organizzativa
                    p_dal
       NOTE:        --
      ******************************************************************************/
   begin
      update anagrafe_unita_organizzative
         set dal                  = p_new_dal
            ,data_aggiornamento   = trunc(sysdate)
            ,utente_aggiornamento = si4.utente
       where progr_unita_organizzativa = p_progr_unita_organizzativa
         and dal != p_dal
         and dal != p_new_dal -- Bug#361
         and dal <= nvl(al, to_date(3333333, 'j')) --#703
         and dal = (select min(dal)
                      from anagrafe_unita_organizzative
                     where progr_unita_organizzativa = p_progr_unita_organizzativa
                       and dal <= nvl(al, to_date(3333333, 'j')) --#703
                       and dal > p_dal);
   end; -- anagrafe_unita_organizzativa.set_dal_successivo
   --------------------------------------------------------------------------------
   procedure set_gruppo_ad4
   (
      p_progr_unita_organizzativa anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       anagrafe_unita_organizzative.dal%type
     ,p_progr_aoo                 anagrafe_unita_organizzative.progr_aoo%type
     ,p_des_abb                   anagrafe_unita_organizzative.des_abb%type
     ,p_utente_ad4                anagrafe_unita_organizzative.utente_ad4%type
   ) is
      /******************************************************************************
       NOME:        set_gruppo_ad4
       DESCRIZIONE: Se l'unita' appartiene all'ottica istituzionale, si inserisce o si
                    aggiorna il relativo gruppo di AD4
       PARAMETRI:   p_progr_unita_organizzativa
                    p_dal
       NOTE:        --
      ******************************************************************************/
      d_nominativo varchar2(40);
      d_dal_aoo    date;
      d_codice_aoo varchar2(16);
      d_codice     varchar2(8);
      d_id         number(10);
      d_messaggio  varchar2(200);
   begin
      if p_utente_ad4 is null then
         begin
            d_messaggio  := 'Sel. dal AOO (' || p_progr_aoo || ')';
            d_dal_aoo    := aoo_pkg.get_dal_corrente(p_progr_aoo, trunc(sysdate));
            d_messaggio  := 'Sel. codice AOO (' || p_progr_aoo || '-' || d_dal_aoo || ')';
            d_codice_aoo := aoo_pkg.get_codice_aoo(p_progr_aoo, d_dal_aoo);
            d_messaggio  := 'Nominativo' || p_des_abb || '-' || d_codice_aoo;
            d_nominativo := p_des_abb || '-' || d_codice_aoo;
            d_messaggio  := 'get_utente (' || d_nominativo || ')';
            d_codice     := ad4_utente.get_utente(d_nominativo);
         exception
            when others then
               raise_application_error(-20999, d_messaggio || sqlerrm);
         end;
         if d_codice is null then
            d_id := null;
            begin
               ad4_gruppo.ins_uo(d_nominativo, d_codice, d_id);
            exception
               when dup_val_on_index then
                  raise_application_error(-20999, 'Utente AD4 gia'' inserito');
               when others then
                  raise_application_error(-20999, 'Errore in inserimento utente AD4');
            end;
         end if;
         if d_codice is not null then
            update anagrafe_unita_organizzative --#453
               set utente_ad4 = d_codice
             where progr_unita_organizzativa = p_progr_unita_organizzativa
               and dal = p_dal;
         end if;
      else
         begin
            d_messaggio  := 'Sel. dal AOO (' || p_progr_aoo || ')';
            d_dal_aoo    := aoo_pkg.get_dal_corrente(p_progr_aoo, trunc(sysdate));
            d_messaggio  := 'Sel. codice AOO (' || p_progr_aoo || '-' || d_dal_aoo || ')';
            d_codice_aoo := aoo_pkg.get_codice_aoo(p_progr_aoo, d_dal_aoo);
            d_messaggio  := 'Nominativo' || p_des_abb || '-' || d_codice_aoo;
            d_nominativo := p_des_abb || '-' || d_codice_aoo;
            d_messaggio  := 'set_nominativo (' || d_nominativo || ')';
            ad4_gruppo.set_descrizione(p_gruppo => p_utente_ad4, p_value => d_nominativo);
         exception
            when others then
               raise_application_error(-20999, d_messaggio || sqlerrm);
         end;
      end if;
   end;
   --------------------------------------------------------------------------------
   -- procedure di gestione di Data Integrity
   procedure set_fi
   (
      p_progr_unita_organizzativa in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_old_progr_unita_org       in anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_dal                       in anagrafe_unita_organizzative.dal%type
     ,p_old_dal                   in anagrafe_unita_organizzative.dal%type
     ,p_al                        in anagrafe_unita_organizzative.al%type
     ,p_old_al                    in anagrafe_unita_organizzative.al%type
     ,p_ottica                    in anagrafe_unita_organizzative.ottica%type
     ,p_utente_ad4                in anagrafe_unita_organizzative.utente_ad4%type
     ,p_id_suddivisione           in anagrafe_unita_organizzative.id_suddivisione%type
     ,p_old_id_suddivisione       in anagrafe_unita_organizzative.id_suddivisione%type
     ,p_revisione_istituzione     in anagrafe_unita_organizzative.revisione_istituzione%type
     ,p_progr_aoo                 in anagrafe_unita_organizzative.progr_aoo%type
     ,p_old_progr_aoo             in anagrafe_unita_organizzative.progr_aoo%type
     ,p_des_abb                   in anagrafe_unita_organizzative.descrizione%type
     ,p_old_des_abb               in anagrafe_unita_organizzative.descrizione%type
     ,p_amministrazione           in anagrafe_unita_organizzative.amministrazione%type
     ,p_utente_agg                in anagrafe_unita_organizzative.utente_aggiornamento%type
     ,p_inserting                 in number
     ,p_updating                  in number
     ,p_deleting                  in number
   ) is
      /******************************************************************************
       NOME:        set_FI.
       DESCRIZIONE: impostazione integrita funzionale:
                    -
       RITORNA:     -
      ******************************************************************************/
      d_ottica_istituzionale   ottiche.ottica_istituzionale%type;
      d_revisione_mod          revisioni_struttura.revisione%type;
      d_segnalazione_bloccante varchar2(1);
      d_segnalazione           varchar2(2000);
      d_contatore              integer := 0;
      d_dal_eliminato          date; --#703
      d_user_ad4               varchar2(8);
      d_codice_uo              anagrafe_unita_organizzative.codice_uo%type;
      dummy                    integer;
   begin
      if p_inserting = 1 or p_updating = 1 then
         d_ottica_istituzionale := ottica.get_ottica_istituzionale(p_ottica);
         --#28708
         if d_ottica_istituzionale = 'SI' then
            begin
               select codice_uo
                 into d_codice_uo
                 from anagrafe_unita_organizzative
                where progr_unita_organizzativa = p_progr_unita_organizzativa
                  and dal =
                      (select max(dal)
                         from anagrafe_unita_organizzative
                        where progr_unita_organizzativa = p_progr_unita_organizzativa);
               select 1
                 into dummy
                 from codici_ipa
                where tipo_entita = 'UO'
                  and progressivo = p_progr_unita_organizzativa;
               raise too_many_rows;
            exception
               when no_data_found then
                  insert into codici_ipa
                     (tipo_entita
                     ,progressivo
                     ,codice_originale)
                  values
                     ('UO'
                     ,p_progr_unita_organizzativa
                     ,d_codice_uo);
               when too_many_rows then
                  update codici_ipa
                     set codice_originale = d_codice_uo
                   where tipo_entita = 'UO'
                     and progressivo = p_progr_unita_organizzativa;
            end;
         end if;
      end if;
      if p_inserting = 1 then
         if d_ottica_istituzionale = 'SI' then
            -- #811
            select max(grantor)
              into d_user_ad4
              from user_tab_privs
             where grantee = user
               and table_name = 'UTENTI'
               and privilege = 'SELECT';
            if d_user_ad4 is not null then
               begin
                  si4.sql_execute('begin ' || d_user_ad4 || '.si4.utente := ''' ||
                                  p_utente_agg || '''; end;');
               exception
                  when others then
                     null;
               end;
            end if;
            --
            set_gruppo_ad4(p_progr_unita_organizzativa
                          ,p_dal
                          ,p_progr_aoo
                          ,p_des_abb
                          ,p_utente_ad4);
         end if;
         if p_al is null then
            -- determinazione della data AL del record inserito
            set_al_corrente(p_progr_unita_organizzativa, p_dal);
         else
            set_dal_successivo(p_progr_unita_organizzativa, p_dal, p_al + 1);
         end if;
         -- impostazione periodo precedente al record inserito
         set_al_precedente(p_progr_unita_organizzativa, p_dal, p_dal - 1, p_ottica);
         -- impostazione della data di pubblicazione dei periodi eliminati logicamente #703
         begin
            select max(dal)
              into d_dal_eliminato
              from anagrafe_unita_organizzative
             where progr_unita_organizzativa = p_progr_unita_organizzativa
               and is_periodo_eliminato(dal) = 1
               and nvl(al_pubb, to_date(3333333, 'j')) >= greatest(p_dal, trunc(sysdate));
            s_eliminazione_logica := 1;
            update anagrafe_unita_organizzative
               set al_pubb = greatest(p_dal, trunc(sysdate)) - 1
             where progr_unita_organizzativa = p_progr_unita_organizzativa
               and is_periodo_eliminato(dal) = 1
               and dal = d_dal_eliminato;
            s_eliminazione_logica := 0;
         exception
            when others then
               null;
         end;
      elsif p_updating = 1 then
         if p_dal <> p_old_dal then
            -- impostazione periodo precedente
            set_al_precedente(p_progr_unita_organizzativa, p_dal, p_dal - 1, p_ottica);
         end if;
         if nvl(p_al, to_date(3333333, 'j')) <> nvl(p_old_al, to_date(3333333, 'j')) then
            set_dal_successivo(p_progr_unita_organizzativa, p_old_dal, p_al + 1);
         end if;
         if d_ottica_istituzionale = 'SI' and
            (p_des_abb <> p_old_des_abb or p_progr_aoo <> p_old_progr_aoo) then
            set_gruppo_ad4(p_progr_unita_organizzativa
                          ,p_dal
                          ,p_progr_aoo
                          ,p_des_abb
                          ,p_utente_ad4);
         end if;
      elsif p_deleting = 1 then
         -- impostazione periodo precedente
         set_al_precedente(p_old_progr_unita_org
                          ,p_old_dal
                          ,p_old_al
                          ,p_ottica
                          ,p_deleting);
      end if;
      --
      if p_inserting = 1 or p_updating = 1 then
         if d_ottica_istituzionale = 'SI' then
            --#429
            so4gp_pkg.ins_unita_so4_gp4(p_progr_unita_organizzativa => p_progr_unita_organizzativa
                                       ,p_dal                       => p_dal
                                       ,p_utente_aggiornamento      => p_utente_agg
                                       ,p_amministrazione           => p_amministrazione);
         end if;
      end if;
      -- #634 Attribuzione automatica dei ruoli applicativi
      if nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO'
                                           ,'AttribuzioneAutomaticaRuoli'
                                           ,0)
            ,'NO') = 'SI' then
         d_revisione_mod := revisione_struttura.get_revisione_mod(p_ottica);
         if nvl(p_revisione_istituzione, -2) <> d_revisione_mod and
            trunc(sysdate) <= nvl(p_al, to_date(3333333, 'j')) then
            if p_inserting = 1 then
               /* cerca una storicizzazione con cambio di suddivisione:
               attiviamo l'attribuzione dei ruoli per i componenti assegnati all'UO */
               select count(*)
                 into d_contatore
                 from anagrafe_unita_organizzative
                where progr_unita_organizzativa = p_progr_unita_organizzativa
                  and al = p_dal - 1
                  and (id_suddivisione <> p_id_suddivisione);
            end if;
            if (p_updating = 1 and p_id_suddivisione <> p_old_id_suddivisione) or
               (p_inserting = 1 and d_contatore > 0) then
               for comp in (select id_componente
                              from componenti c
                             where progr_unita_organizzativa = p_progr_unita_organizzativa
                               and c.dal <= nvl(c.al, to_date(3333333, 'j'))
                               and nvl(c.revisione_assegnazione, -2) <> d_revisione_mod
                               and nvl(c.al, to_date(3333333, 'j')) >= p_dal)
               loop
                  componente.attribuzione_ruoli(comp.id_componente
                                               ,p_dal
                                               ,p_al
                                               ,4
                                               ,d_segnalazione_bloccante
                                               ,d_segnalazione);
               end loop;
            end if;
         end if;
      end if;
   end; -- Anagrafe_unita_organizzativa.set_FI
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
begin
   -- inserimento degli errori nella tabella
   --   s_error_table( s_<exception_name>_num ) := s_<exception_name>_msg;
   s_error_table(s_dal_al_errato_num) := s_dal_al_errato_msg;
   s_error_table(s_dal_errato_num) := s_dal_errato_msg;
   s_error_table(s_dal_errato_ins_num) := s_dal_errato_ins_msg;
   s_error_table(s_al_errato_num) := s_al_errato_msg;
   s_error_table(s_auo_non_elim_1_num) := s_auo_non_elim_1_msg;
   s_error_table(s_auo_non_elim_2_num) := s_auo_non_elim_2_msg;
   s_error_table(s_auo_non_elim_3_num) := s_auo_non_elim_3_msg;
   s_error_table(s_des_abb_errata_num) := s_des_abb_errata_msg;
   s_error_table(s_progr_aoo_errato_num) := s_progr_aoo_errato_msg;
   s_error_table(s_auo_non_elim_4_num) := s_auo_non_elim_4_msg;
   s_error_table(s_indirizzo_errato_num) := s_indirizzo_errato_msg;
   s_error_table(s_codice_errato_num) := s_codice_errato_msg;
   s_error_table(s_descrizione_errata_num) := s_descrizione_errata_msg;
   s_error_table(s_des_abb_usata_num) := s_des_abb_usata_msg;
   s_error_table(s_unita_presente_num) := s_unita_presente_msg;
   s_error_table(s_al_errato_ins_num) := s_al_errato_ins_msg;
   s_error_table(s_periodo_errato_num) := s_periodo_errato_msg;
   s_error_table(s_revisioni_errate_num) := s_revisioni_errate_msg;
   s_error_table(s_auo_non_elim_5_num) := s_auo_non_elim_5_msg;
   s_error_table(s_aggregatore_errato_num) := s_aggregatore_errato_msg;
end anagrafe_unita_organizzativa;
/

