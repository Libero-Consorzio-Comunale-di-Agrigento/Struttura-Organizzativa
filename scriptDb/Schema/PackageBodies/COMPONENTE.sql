CREATE OR REPLACE package body componente is

   /******************************************************************************
    NOME:        componente
    DESCRIZIONE: Gestione tabella componenti.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore      Descrizione.
    000   02/08/2006  VDAVALLI    Prima emissione.
    001   03/09/2009  VDAVALLI    Modifiche per gestione master/slave
    002   03/09/2009  VDAVALLI    Aggiunta funzione DETERMINA_NOMINATIVO_4
    003   29/04/2010  APASSUELLO  Modifica per aggiunta di controlli sulla congruenza delle revisioni
    004   13/05/2010  APASSUELLO  Modifica procedure sposta_componente per gestione dello spostamento senza revisione
    005   05/08/2010  APASSUELLO  Corretta function determina_nominativo_cdr
    006   02/11/2010  APASSUELLO  Modifica function SPOSTA_COMPONENTE per controllo dei campi IMPOSTAZIONI.OBBLIGO_IMBI
                                  e IMPOSTAZIONI.OBBLIGO_SEFI nello spostamento di un componente
    007   07/03/2010  VDAVALLI    Modifica inserimento utente in ad4: se utente_agg
                                  like 'Aut.%' inserisce con utente_agg = 'SO4'
    008   23/06/2011  SNEGRONI    Per il nominativo può essere usata la funzione distribuita con AD4.
    009   18/08/2011  MMONARI     Att.45288 : Modifiche a esiste_componente
    010   19/08/2011  MMONARI     Modifiche per gestione ottiche derivate
    011   18/11/2011  VDAVALLI    Modifiche allo spostamento componenti
    012   05/12/2011  MMONARI     Modifiche per gestione dati storici
    013   14/12/2011  VDAVALLI    Modificata funzione SPOSTA_COMPONENTI per ereditarieta
                                  ruoli; corretta funzione BACKUP_COMPONENTI
                                  (inseriva in IMPUTAZIONI_BILANCIO anziche' in DUP_IMBI
    014   20/12/2011  MMONARI     Funzioni per Browser Componenti
    015   20/12/2011  VDAVALLI    Nuove funzioni DETERMINA_NOMINATIVO_7 e
                                  DETERMINA_UTENTE_7 per provincia di Modena
    016   02/03/2012  VDAVALLI    Nuova procedure di inserimento assegnazioni
                                  funzionali
    017   02/07/2012  MMONARI     Consolidamento rel.1.4.1
    018   28/08/2012  MM/VD       Acquisizione modifiche da TEST
    019   29/08/2012  VD          Aggiunta funzione VERIFICA_EREDITARIETA per
                                  verificare ereditarieta' ruoli + Redmine Bug #86
    020   30/10/2012  VD/MM       Redmine 95
    021   02/11/2012  ADADAMO     Modificata chiamata aggiorna_ottica_derivata in
                                  set_fi per disattivazione commit
    022   08/11/2012  MMONARI     Redmine Feature #120
    023   08/11/2012  MMONARI     Redmine Bug #130
    024   16/01/2013  MMONARI     Redmine Feature #169
    025   29/01/2013  MMONARI     Redmine Feature #149
    026   30/01/2013  MMONARI     Redmine Bug #86
    027   01/02/2013  MMONARI     Redmine Bug #171
    028   18/03/2013  MMONARI     Redmine Bug #86 : Feedback 1
    029   18/03/2013  VDAVALLI    Aggiunta funzione determina_nominativo_n_sp_c Bug #227
    030   25/03/2013  MMONARI     Aggiunta nvl su inserimento attributo di default Bug #229
    031   09/04/2013  ADADAMO     Aggiunta funzione get_desc_comp_tree Bug #216
    032   15/04/2013  MMONARI     Redmine Bug #239
    033   03/06/2013  ADADAMO     Modificata set_fi per calcolo tipo_assegnazione Bug#269
    034   01/08/2013  ADADAMO     Modificata set_fi per calcolo tipo_assegnazione Bug#286
                                  in caso di inserimento su UO con anagrafe chiusa
          06/09/2013  ADADAMO     Modificate chk_ri per verifica assegnazioni_ripetute
                                  Bug#252
          09/09/2013  ADADAMO     Corretta condizione in update_comp per Bug#270
          09/09/2013  MMONARI     reintrodotto inserimento MOAS su sposta_componente per Bug#299
          28/10/2013  ADADAMO     Corretta get_desc_comp_tree per Bug#332
    035   08/01/2014  MMONARI     Redmine Bug #351
          16/01/2014  ADADAMO     Redmine Bug #358
          11/02/2014  MMONARI     Nuovo parametro revisione cessazione per duplica_attributi  per Bug#380
          27/02/2014  MMONARI     Modifiche alla set_fi per Bug#355 e successive integrazioni
                      ADADAMO     per errori riscontrati da integrazione con GPS in data 12/03/2014
    036   27/03/2014  ADADAMO     Sostituiti riferimenti al so4gp4 con so4gp_pkg Feature#418
    037   03/04/2014  ADADAMO     Introdotta lettura dell'incarico di default da chiave di
                                  registro Bug#421
    038   03/04/2014  VDAVALLI    Corrette funzioni get_se_resp_corrente,
                                  get_se_resp_valido, conta_assegnazioni per
                                  to_date(null) in decode data AL
    039   27/03/2014  MMONARI     Sostituiti riferimenti a p00so4_modifiche_assegnazioni con so4gp_pkg Feature#429
                                  Sostituiti riferimenti a p00so4_unita_so4_gp4
                                  Modificata la is_componente_modificabile #433
                                  issue #440
                                  issue #446 (modifiche a get_desc_comp_tree)
                                  issue #457 (segnalazioni errore set_fi)
                      ADADAMO     feedback su issue #446 per inestetica indicazione
                                  "a tutt'oggi" su assegnazioni future
                      MMONARI     #459 : in revisione retroattiva non possiamo riciclare i record su COMPONENTI
    040   16/07/2014  ADADAMO     Gestito ritorno errore bloccante in ripristina_componente
                                  dopo elimina_componente Bug#474      
    041   07/08/2014  MMONARI     #189 - visualizza su albero struttura gli attributi modificati in revisione
          13/08/2014  ADADAMO     Modificato controllo in set_fi in caso di integrazione con GP4 o GPS
    042   19/08/2014  MMONARI     #208 - identificazione delle modifiche da riportare sulle ottiche derivate
          19/08/2014  MMONARI     #313 - eliminazione logica del componente nel caso di spostamento con decorrenza = dal
          20/08/2014  MMONARI     #486 - modifiche a ins_ass_funzionali
          16/09/2014  MMONARI     #500 - modifiche a elimina_componente e update_comp
          18/09/2014  MMONARI     #499 - modifiche a set_fi
          06/10/2014  MMONARI     #533 - attivazione revisione con componenti con decorrenza futura
                                         visualizzazione data di termine in get_desc_comp_tree
          17/12/2014  MMONARI     #548 - modifiche a is_ri_ok su controllo is_componente_modificabile
          16/01/2015  MMONARI     #543 - modifiche a set_fi : un individuo puo' avere al piu' una assegnazione prevalente
                                         in una certa ottica, in un dato momento, indipendentemente dal fatto che ci sia o meno
                                         integrazione con GPx
          13/02/2015  MMONARI     #574 - modifiche a sposta_componente
          09/03/2015  MMONARI     #577 - modifiche ad annulla_spostamento
    043   28/04/2015  MMONARI     #595 - Modifiche a sposta_componente
          08/05/2015  MMONARI     #597 - modifiche a update_comp
          20/05/2015  ADADAMO     #572 - nuova funzione is_componente_annullabile e modifiche a annulla_spostamento
          21/05/2015  MMONARI     #599 - modifiche a sposta_componente
          03/09/2015  MMONARI     #641 - gestione della revisione di cessazione su ATCO in ripristino del componente
    044   06/08/2015  MMONARI     #634 - Modifiche a set_fi per attribuzione automatica ruoli applicativi
          05/10/2015  MMONARI     #648 - Modifiche a set_fi per attribuzione automatica ubicazione unica
          15/10/2015  MMONARI     #643 - Modifiche a set_fi per gestione segnalazioni
          21/08/2014  MMONARI     #550 - Modifiche a sposta_componente
          02/11/2015  MMONARI     #655 - Modifiche a sposta_componente
          15/01/2016  MMONARI     #664 - Modifiche a verifica_ereditarieta
          03/05/2016  MMONARI     #713 - Eredita ruoli su spostamento componente
          12/12/2016  MMONARI     #747 - Correzione in set_fi per LaTraccia
    045   12/04/2017  MMONARI     #766 - Modifiche a set_fi per attribuzione automatica ruoli applicativi a componenti
                                         eliminati logicamente
          14/04/2017  MMONARI     #767 - Correzione in attribuzione_ruoli
          10/05/2017  MMONARI     #772 - Notifiche modifiche assegnazioni via mail
          09/08/2017  MMONARI     #774 - Gestione dell'annullamento degli spostemnti in presenza di integrazione con GPs
          29/08/2017  MMONARI     #786 - correzione in update_comp
    046   04/05/2018  ADADAMO     #27951 - Correzione nella procedura INS della valorizzazione dell'utente di aggiornamento
                                           passato alla funzione di inserimento dell'utente di AD4
    047   18/04/2019  MMONARI     #34478 - Correzione nella procedura SET_FI della valorizzazione del tipo di assegnazione
    048   12/11/2020  MMONARI     #45841 - gestione UO con suddivisione nulla in ATTRIBUZIONE_RUOLI

   ******************************************************************************/
   s_revisione_body constant afc.t_revision := '048';
   s_table_name     constant afc.t_object_name := 'componenti';
   s_error_table    afc_error.t_error_table;
   s_tipo_revisione revisioni_struttura.tipo_revisione%type;
   s_segnalazione   varchar2(2000) := ''; --#457

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
   end; -- componente.versione
   --------------------------------------------------------------------------------
   function pk(p_id_componente in componenti.id_componente%type) return t_pk is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        PK
       DESCRIZIONE: Costruttore di un t_PK dati gli attributi della chiave
      ******************************************************************************/
      d_result t_pk;
   begin
      d_result.id_componente := p_id_componente;
      dbc.pre(not dbc.preon or canhandle(d_result.id_componente)
             ,'canHandle on componente.PK');
      return d_result;
   end; -- end componente.PK
   --------------------------------------------------------------------------------
   function can_handle(p_id_componente in componenti.id_componente%type) return number is
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
      if d_result = 1 and (p_id_componente is null) then
         d_result := 0;
      end if;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on componente.can_handle');
      return d_result;
   end; -- componente.can_handle
   --------------------------------------------------------------------------------
   function canhandle(p_id_componente in componenti.id_componente%type) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        canHandle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: true se la chiave è manipolabile, false altrimenti.
       NOTE:        Wrapper boolean di can_handle (cfr. can_handle).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(can_handle(p_id_componente));
   begin
      return d_result;
   end; -- componente.canHandle
   --------------------------------------------------------------------------------
   function exists_id(p_id_componente in componenti.id_componente%type) return number is
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
      dbc.pre(not dbc.preon or canhandle(p_id_componente)
             ,'canHandle on componente.exists_id');
      begin
         select 1 into d_result from componenti where id_componente = p_id_componente;
      exception
         when no_data_found then
            d_result := 0;
      end;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on componente.exists_id');
      return d_result;
   end; -- componente.exists_id
   --------------------------------------------------------------------------------
   function existsid(p_id_componente in componenti.id_componente%type) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        existsId
       DESCRIZIONE: Esistenza riga con chiave indicata.
       NOTE:        Wrapper boolean di exists_id (cfr. exists_id).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(exists_id(p_id_componente));
   begin
      return d_result;
   end; -- componente.existsId
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
      d_result constant afc_error.t_error_msg := s_error_table(p_error_number);
   begin
      return d_result;
   end; -- anagrafe_unita_organizzativa.error_message
   --------------------------------------------------------------------------------
   procedure ins
   (
      p_id_componente             in componenti.id_componente%type default null
     ,p_progr_unita_organizzativa in componenti.progr_unita_organizzativa%type
     ,p_dal                       in componenti.dal%type
     ,p_al                        in componenti.al%type default null
      --     ,p_al_prec                   in componenti.al_prec%type default null
     ,p_ni                     in componenti.ni%type default null
     ,p_ci                     in componenti.ci%type default null
     ,p_codice_fiscale         in componenti.codice_fiscale%type default null
     ,p_denominazione          in componenti.denominazione%type default null
     ,p_denominazione_al1      in componenti.denominazione_al1%type default null
     ,p_denominazione_al2      in componenti.denominazione_al2%type default null
     ,p_stato                  in componenti.stato%type default null
     ,p_ottica                 in componenti.ottica%type default null
     ,p_revisione_assegnazione in componenti.revisione_assegnazione%type default null
     ,p_revisione_cessazione   in componenti.revisione_cessazione%type default null
     ,p_utente_aggiornamento   in componenti.utente_aggiornamento%type default null
     ,p_data_aggiornamento     in componenti.data_aggiornamento%type default null
     ,p_dal_pubb               in componenti.dal_pubb%type default null
     ,p_al_pubb                in componenti.al_pubb%type default null
   ) is
      /******************************************************************************
       NOME:        ins
       DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
       PARAMETRI:   Chiavi e attributi della table.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or p_progr_unita_organizzativa is not null
             ,'p_progr_unita_organizzativa on componente.ins');
      dbc.pre(not dbc.preon or p_id_componente is null or not existsid(p_id_componente)
             ,'not existsId on componente.ins');
      insert into componenti
         (id_componente
         ,progr_unita_organizzativa
         ,dal
         ,al
         ,dal_pubb
         ,al_pubb
          --         ,al_prec
         ,ni
         ,ci
         ,codice_fiscale
         ,denominazione
         ,denominazione_al1
         ,denominazione_al2
         ,stato
         ,ottica
         ,revisione_assegnazione
         ,revisione_cessazione
         ,utente_aggiornamento
         ,data_aggiornamento)
      values
         (p_id_componente
         ,p_progr_unita_organizzativa
         ,p_dal
         ,p_al
         ,p_dal_pubb
         ,p_al_pubb
          --         ,p_al_prec
         ,p_ni
         ,p_ci
         ,p_codice_fiscale
         ,p_denominazione
         ,p_denominazione_al1
         ,p_denominazione_al2
         ,p_stato
         ,p_ottica
         ,p_revisione_assegnazione
         ,p_revisione_cessazione
         ,p_utente_aggiornamento
         ,p_data_aggiornamento);
   end; -- componente.ins
   --------------------------------------------------------------------------------
   procedure upd
   (
      p_new_id_componente   in componenti.id_componente%type
     ,p_new_progr_unita_org in componenti.progr_unita_organizzativa%type
     ,p_new_dal             in componenti.dal%type
     ,p_new_al              in componenti.al%type
     ,p_new_dal_pubb        in componenti.dal_pubb%type default null
     ,p_new_al_pubb         in componenti.al_pubb%type default null
      --     ,p_new_al_prec                in componenti.al_prec%type default null
     ,p_new_ni                     in componenti.ni%type
     ,p_new_ci                     in componenti.ci%type
     ,p_new_codice_fiscale         in componenti.codice_fiscale%type
     ,p_new_denominazione          in componenti.denominazione%type
     ,p_new_denominazione_al1      in componenti.denominazione_al1%type
     ,p_new_denominazione_al2      in componenti.denominazione_al2%type
     ,p_new_stato                  in componenti.stato%type
     ,p_new_ottica                 in componenti.ottica%type
     ,p_new_revisione_assegnazione in componenti.revisione_assegnazione%type
     ,p_new_revisione_cessazione   in componenti.revisione_cessazione%type
     ,p_new_utente_aggiornamento   in componenti.utente_aggiornamento%type
     ,p_new_data_aggiornamento     in componenti.data_aggiornamento%type
     ,p_old_id_componente          in componenti.id_componente%type default null
     ,p_old_progr_unita_org        in componenti.progr_unita_organizzativa%type default null
     ,p_old_dal                    in componenti.dal%type default null
     ,p_old_al                     in componenti.al%type default null
     ,p_old_dal_pubb               in componenti.dal_pubb%type default null
     ,p_old_al_pubb                in componenti.al_pubb%type default null
      --     ,p_old_al_prec                in componenti.al_prec%type default null
     ,p_old_ni                     in componenti.ni%type default null
     ,p_old_ci                     in componenti.ci%type default null
     ,p_old_codice_fiscale         in componenti.codice_fiscale%type default null
     ,p_old_denominazione          in componenti.denominazione%type default null
     ,p_old_denominazione_al1      in componenti.denominazione_al1%type default null
     ,p_old_denominazione_al2      in componenti.denominazione_al2%type default null
     ,p_old_stato                  in componenti.stato%type default null
     ,p_old_ottica                 in componenti.ottica%type default null
     ,p_old_revisione_assegnazione in componenti.revisione_assegnazione%type default null
     ,p_old_revisione_cessazione   in componenti.revisione_cessazione%type default null
     ,p_old_utente_aggiornamento   in componenti.utente_aggiornamento%type default null
     ,p_old_data_aggiornamento     in componenti.data_aggiornamento%type default null
     ,p_check_old                  in integer default 0
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
              not ((p_old_progr_unita_org is not null or p_old_dal is not null or
               p_old_al is not null or p_old_dal_pubb is not null or
               p_old_al_pubb is not null or
               --               p_old_al_prec is not null or
               p_old_ni is not null or p_old_ci is not null or
               p_old_codice_fiscale is not null or p_old_denominazione is not null or
               p_old_denominazione_al1 is not null or
               p_old_denominazione_al2 is not null or p_old_stato is not null or
               p_old_ottica is not null or p_old_revisione_assegnazione is not null or
               p_old_revisione_cessazione is not null or
               p_old_utente_aggiornamento is not null or
               p_old_data_aggiornamento is not null) and p_check_old = 0)
             ,' <OLD values> is not null on componente.upd');
      dbc.pre(not dbc.preon or p_check_old is not null
             ,'p_check_OLD is not null on componente.upd');
      d_key := pk(nvl(p_old_id_componente, p_new_id_componente));
      dbc.pre(not dbc.preon or existsid(d_key.id_componente)
             ,'existsId on componente.upd');
      update componenti
         set id_componente             = p_new_id_componente
            ,progr_unita_organizzativa = p_new_progr_unita_org
            ,dal                       = p_new_dal
            ,al                        = p_new_al
            ,dal_pubb                  = p_new_dal_pubb
            ,al_pubb                   = p_new_al_pubb
             --            ,al_prec                   = p_new_al_prec
            ,ni                     = p_new_ni
            ,ci                     = p_new_ci
            ,codice_fiscale         = p_new_codice_fiscale
            ,denominazione          = p_new_denominazione
            ,denominazione_al1      = p_new_denominazione_al1
            ,denominazione_al2      = p_new_denominazione_al2
            ,stato                  = p_new_stato
            ,ottica                 = p_new_ottica
            ,revisione_assegnazione = p_new_revisione_assegnazione
            ,revisione_cessazione   = p_new_revisione_cessazione
            ,utente_aggiornamento   = p_new_utente_aggiornamento
            ,data_aggiornamento     = p_new_data_aggiornamento
       where id_componente = d_key.id_componente
         and (p_check_old = 0 or
             p_check_old = 1 and
             (progr_unita_organizzativa = p_old_progr_unita_org or
             progr_unita_organizzativa is null and p_old_progr_unita_org is null) and
             (dal = p_old_dal or dal is null and p_old_dal is null) and
             (al = p_old_al or al is null and p_old_al is null) and
             (dal_pubb = p_old_dal_pubb or dal_pubb is null and p_old_dal_pubb is null) and
             (al_pubb = p_old_al_pubb or al_pubb is null and p_old_al_pubb is null) and
             --             (al_prec = p_old_al_prec or al_prec is null and p_old_al_prec is null) and
             (ni = p_old_ni or ni is null and p_old_ni is null) and
             (ci = p_old_ci or ci is null and p_old_ci is null) and
             (codice_fiscale = p_old_codice_fiscale or
             codice_fiscale is null and p_old_codice_fiscale is null) and
             (denominazione = p_old_denominazione or
             denominazione is null and p_old_denominazione is null) and
             (denominazione_al1 = p_old_denominazione_al1 or
             denominazione_al1 is null and p_old_denominazione_al1 is null) and
             (denominazione_al2 = p_old_denominazione_al2 or
             denominazione_al2 is null and p_old_denominazione_al2 is null) and
             (stato = p_old_stato or stato is null and p_old_stato is null) and
             (ottica = p_old_ottica or ottica is null and p_old_ottica is null) and
             (revisione_assegnazione = p_old_revisione_assegnazione or
             revisione_assegnazione is null and p_old_revisione_assegnazione is null) and
             (revisione_cessazione = p_old_revisione_cessazione or
             revisione_cessazione is null and p_old_revisione_cessazione is null) and
             (utente_aggiornamento = p_old_utente_aggiornamento or
             utente_aggiornamento is null and p_old_utente_aggiornamento is null) and
             (data_aggiornamento = p_old_data_aggiornamento or
             data_aggiornamento is null and p_old_data_aggiornamento is null));
      d_row_found := sql%rowcount;
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on componente.upd');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   end; -- componente.upd
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_id_componente in componenti.id_componente%type
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
      dbc.pre(not dbc.preon or existsid(p_id_componente)
             ,'existsId on componente.upd_column');
      dbc.pre(not dbc.preon or p_column is not null
             ,'p_column is not null on componente.upd_column');
      dbc.pre(not dbc.preon or afc_ddl.hasattribute(s_table_name, p_column)
             ,'AFC_DDL.HasAttribute on componente.upd_column');
      dbc.pre(p_literal_value in (0, 1)
             ,'p_literal_value in ( 0, 1 ) on componente.upd_column; p_literal_value = ' ||
              p_literal_value);
      if p_literal_value = 1 then
         d_literal := '''';
      end if;
      d_statement := 'begin ' || '   update componenti' || '   set    ' || p_column ||
                     ' = ' || d_literal || p_value || d_literal ||
                     '   where  id_componente = ''' || p_id_componente || '''' || '   ;' ||
                     'end;';
      execute immediate d_statement;
   end; -- componente.upd_column
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_id_componente in componenti.id_componente%type
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
      d_data := to_char(p_value, 'dd/mm/yyyy hh24:mi:ss');
      upd_column(p_id_componente
                ,p_column
                ,'to_date( ''' || d_data || ''', ''dd/mm/yyyy hh24:mi:ss'')'
                ,0);
   end; -- componente.upd_column
   --------------------------------------------------------------------------------
   procedure del
   (
      p_id_componente             in componenti.id_componente%type
     ,p_progr_unita_organizzativa in componenti.progr_unita_organizzativa%type default null
     ,p_dal                       in componenti.dal%type default null
     ,p_al                        in componenti.al%type default null
     ,p_dal_pubb                  in componenti.dal_pubb%type default null
     ,p_al_pubb                   in componenti.al_pubb%type default null
      --     ,p_al_prec                   in componenti.al_prec%type default null
     ,p_ni                     in componenti.ni%type default null
     ,p_ci                     in componenti.ci%type default null
     ,p_codice_fiscale         in componenti.codice_fiscale%type default null
     ,p_denominazione          in componenti.denominazione%type default null
     ,p_denominazione_al1      in componenti.denominazione_al1%type default null
     ,p_denominazione_al2      in componenti.denominazione_al2%type default null
     ,p_ottica                 in componenti.ottica%type default null
     ,p_revisione_assegnazione in componenti.revisione_assegnazione%type default null
     ,p_revisione_cessazione   in componenti.revisione_cessazione%type default null
     ,p_utente_aggiornamento   in componenti.utente_aggiornamento%type default null
     ,p_data_aggiornamento     in componenti.data_aggiornamento%type default null
     ,p_check_old              in integer default 0
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
               ((p_progr_unita_organizzativa is not null or p_dal is not null or
               p_al is not null or p_dal_pubb is not null or p_al_pubb is not null or
               --               p_al_prec is not null or
               p_ni is not null or p_ci is not null or p_codice_fiscale is not null or
               p_denominazione is not null or p_denominazione_al1 is not null or
               p_denominazione_al2 is not null or p_ottica is not null or
               p_revisione_assegnazione is not null or
               p_revisione_cessazione is not null or p_utente_aggiornamento is not null or
               p_data_aggiornamento is not null) and p_check_old = 0)
             ,' <OLD values> is not null on componente.del');
      dbc.pre(not dbc.preon or existsid(p_id_componente), 'existsId on componente.del');
      delete from componenti
       where id_componente = p_id_componente
         and (p_check_old = 0 or
             p_check_old = 1 and
             (progr_unita_organizzativa = p_progr_unita_organizzativa or
             progr_unita_organizzativa is null and p_progr_unita_organizzativa is null) and
             (dal = p_dal or dal is null and p_dal is null) and
             (al = p_al or al is null and p_al is null) and
             (dal_pubb = p_dal_pubb or dal_pubb is null and p_dal_pubb is null) and
             (al_pubb = p_al_pubb or al_pubb is null and p_al_pubb is null) and
             --             (al_prec = p_al_prec or al_prec is null and p_al_prec is null) and
             (ni = p_ni or ni is null and p_ni is null) and
             (ci = p_ci or ci is null and p_ci is null) and
             (codice_fiscale = p_codice_fiscale or
             codice_fiscale is null and p_codice_fiscale is null) and
             (denominazione = p_denominazione or
             denominazione is null and p_denominazione is null) and
             (denominazione_al1 = p_denominazione_al1 or
             denominazione_al1 is null and p_denominazione_al1 is null) and
             (denominazione_al2 = p_denominazione_al2 or
             denominazione_al2 is null and p_denominazione_al2 is null) and
             (ottica = p_ottica or ottica is null and p_ottica is null) and
             (revisione_assegnazione = p_revisione_assegnazione or
             revisione_assegnazione is null and p_revisione_assegnazione is null) and
             (revisione_cessazione = p_revisione_cessazione or
             revisione_cessazione is null and p_revisione_cessazione is null) and
             (utente_aggiornamento = p_utente_aggiornamento or
             utente_aggiornamento is null and p_utente_aggiornamento is null) and
             (data_aggiornamento = p_data_aggiornamento or
             data_aggiornamento is null and p_data_aggiornamento is null));
      d_row_found := sql%rowcount;
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on componente.del');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
      dbc.post(not dbc.poston or not existsid(p_id_componente)
              ,'existsId on componente.del');
   end; -- componente.del
   --------------------------------------------------------------------------------
   function get_progr_unita_organizzativa(p_id_componente in componenti.id_componente%type)
      return componenti.progr_unita_organizzativa%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_progr_unita_organizzativa
       DESCRIZIONE: Attributo progr_unita_organizzativa di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     componenti.progr_unita_organizzativa%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result componenti.progr_unita_organizzativa%type;
   begin
      begin
         select progr_unita_organizzativa
           into d_result
           from componenti
          where id_componente = p_id_componente;
      exception
         --Bug #351
         when no_data_found then
            d_result := '';
      end;
      return d_result;
   end; -- componente.get_progr_unita_organizzativa
   --------------------------------------------------------------------------------
   function get_dal(p_id_componente in componenti.id_componente%type)
      return componenti.dal%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_dal
       DESCRIZIONE: Attributo dal di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     componenti.dal%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result componenti.dal%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_componente)
             ,'existsId on componente.get_dal');
      select dal into d_result from componenti where id_componente = p_id_componente;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on componente.get_dal');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'dal')
                      ,' AFC_DDL.IsNullable on componente.get_dal');
      end if;
      return d_result;
   end; -- componente.get_dal
   --------------------------------------------------------------------------------
   function get_al(p_id_componente in componenti.id_componente%type)
      return componenti.al%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_al
       DESCRIZIONE: Attributo al di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     componenti.al%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result componenti.al%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_componente)
             ,'existsId on componente.get_al');
      select al into d_result from componenti where id_componente = p_id_componente;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on componente.get_al');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'al')
                      ,' AFC_DDL.IsNullable on componente.get_al');
      end if;
      return d_result;
   end; -- componente.get_al
   --------------------------------------------------------------------------------
   function get_dal_pubb(p_id_componente in componenti.id_componente%type)
      return componenti.dal_pubb%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_dal_pubb
       DESCRIZIONE: Attributo dal_pubb di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     componenti.dal%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result componenti.dal_pubb%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_componente)
             ,'existsId on componente.get_dal_pubb');
      select dal_pubb
        into d_result
        from componenti
       where id_componente = p_id_componente;
      -- Check Mandatory Attribute on Table
      if (true) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on componente.get_dal_pubb');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'dal_pubb')
                      ,' AFC_DDL.IsNullable on componente.get_dal_pubb');
      end if;
      return d_result;
   end; -- componente.get_dal_pubb
   --------------------------------------------------------------------------------
   function get_al_pubb(p_id_componente in componenti.id_componente%type)
      return componenti.al_pubb%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_al_pubb
       DESCRIZIONE: Attributo al_pubb di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     componenti.al_pubb%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result componenti.al_pubb%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_componente)
             ,'existsId on componente.get_al_pubb');
      select al_pubb into d_result from componenti where id_componente = p_id_componente;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on componente.get_al_pubb');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'al_pubb')
                      ,' AFC_DDL.IsNullable on componente.get_al_pubb');
      end if;
      return d_result;
   end; -- componente.get_al_pubb
   --------------------------------------------------------------------------------
   function get_al_prec(p_id_componente in componenti.id_componente%type)
      return componenti.al_prec%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_al_prec
       DESCRIZIONE: Attributo al_prec di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     componenti.al_prec%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result componenti.al_prec%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_componente)
             ,'existsId on componente.get_al_prec');
      select al_prec into d_result from componenti where id_componente = p_id_componente;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on componente.get_al_prec');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'al_prec')
                      ,' AFC_DDL.IsNullable on componente.get_al_prec');
      end if;
      return d_result;
   end; -- componente.get_al_prec
   --------------------------------------------------------------------------------
   function get_ni(p_id_componente in componenti.id_componente%type)
      return componenti.ni%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_ni
       DESCRIZIONE: Attributo ni di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     componenti.ni%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result componenti.ni%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_componente)
             ,'existsId on componente.get_ni');
      select ni into d_result from componenti where id_componente = p_id_componente;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on componente.get_ni');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'ni')
                      ,' AFC_DDL.IsNullable on componente.get_ni');
      end if;
      return d_result;
   end; -- componente.get_ni
   --------------------------------------------------------------------------------
   function get_ci(p_id_componente in componenti.id_componente%type)
      return componenti.ci%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_ci
       DESCRIZIONE: Attributo ci di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     componenti.ci%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result componenti.ci%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_componente)
             ,'existsId on componente.get_ci');
      select ci into d_result from componenti where id_componente = p_id_componente;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on componente.get_ci');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'ci')
                      ,' AFC_DDL.IsNullable on componente.get_ci');
      end if;
      return d_result;
   end; -- componente.get_ci
   --------------------------------------------------------------------------------
   function get_codice_fiscale(p_id_componente in componenti.id_componente%type)
      return componenti.codice_fiscale%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_codice_fiscale
       DESCRIZIONE: Attributo codice_fiscale di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     componenti.codice_fiscale%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result componenti.codice_fiscale%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_componente)
             ,'existsId on componente.get_codice_fiscale');
      begin
         select decode(ni, null, codice_fiscale, '')
           into d_result
           from componenti
          where id_componente = p_id_componente;
      end;
      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on componente.get_codice_fiscale');
      return d_result;
   end; -- componente.get_codice_fiscale
   --------------------------------------------------------------------------------
   function get_denominazione(p_id_componente in componenti.id_componente%type)
      return componenti.denominazione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_denominazione
       DESCRIZIONE: Attributo denominazione di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     componenti.denominazione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result componenti.denominazione%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_componente)
             ,'existsId on componente.get_denominazione');
      begin
         select decode(ni, null, denominazione, '')
           into d_result
           from componenti
          where id_componente = p_id_componente;
      end;
      dbc.post(not dbc.poston or d_result is not null
              ,'d_result is not null on componente.get_denominazione');
      return d_result;
   end; -- componente.get_denominazione
   --------------------------------------------------------------------------------
   function get_stato(p_id_componente in componenti.id_componente%type)
      return componenti.stato%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_stato
       DESCRIZIONE: Attributo stato di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     componenti.stato%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result componenti.stato%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_componente)
             ,'existsId on componente.get_stato');
      select stato into d_result from componenti where id_componente = p_id_componente;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on componente.get_stato');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'stato')
                      ,' AFC_DDL.IsNullable on componente.get_stato');
      end if;
      return d_result;
   end; -- componente.get_stato
   --------------------------------------------------------------------------------
   function get_ottica(p_id_componente in componenti.id_componente%type)
      return componenti.ottica%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_ottica
       DESCRIZIONE: Attributo ottica di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     componenti.ottica%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result componenti.ottica%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_componente)
             ,'existsId on componente.get_ottica');
      select ottica into d_result from componenti where id_componente = p_id_componente;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on componente.get_ottica');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'ottica')
                      ,' AFC_DDL.IsNullable on componente.get_ottica');
      end if;
      return d_result;
   end; -- componente.get_ottica
   --------------------------------------------------------------------------------
   function get_revisione_assegnazione(p_id_componente in componenti.id_componente%type)
      return componenti.revisione_assegnazione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_revisione_assegnazione
       DESCRIZIONE: Attributo revisione_assegnazione di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     componenti.revisione_assegnazione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result componenti.revisione_assegnazione%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_componente)
             ,'existsId on componente.get_revisione_assegnazione');
      begin
         select revisione_assegnazione
           into d_result
           from componenti
          where id_componente = p_id_componente;
      exception
         when others then
            d_result := null;
      end;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on componente.get_revisione_assegnazione');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'revisione_assegmazione')
                      ,' AFC_DDL.IsNullable on componente.get_revisione_assegnazione');
      end if;
      return d_result;
   end; -- componente.get_revisione_assegnazione
   --------------------------------------------------------------------------------
   function get_revisione_cessazione(p_id_componente in componenti.id_componente%type)
      return componenti.revisione_cessazione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_revisione_cessazione
       DESCRIZIONE: Attributo revisione_cessazione di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     componenti.revisione_cessazione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result componenti.revisione_cessazione%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_componente)
             ,'existsId on componente.get_revisione_cessazione');
      select revisione_cessazione
        into d_result
        from componenti
       where id_componente = p_id_componente;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on componente.get_revisione_cessazione');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'revisione_cessazione')
                      ,' AFC_DDL.IsNullable on componente.get_revisione_cessazione');
      end if;
      return d_result;
   end; -- componente.get_revisione_cessazione
   --------------------------------------------------------------------------------
   function get_utente_aggiornamento(p_id_componente in componenti.id_componente%type)
      return componenti.utente_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_utente_aggiornamento
       DESCRIZIONE: Attributo utente_aggiornamento di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     componenti.utente_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result componenti.utente_aggiornamento%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_componente)
             ,'existsId on componente.get_utente_aggiornamento');
      select utente_aggiornamento
        into d_result
        from componenti
       where id_componente = p_id_componente;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on componente.get_utente_aggiornamento');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'utente_aggiornamento')
                      ,' AFC_DDL.IsNullable on componente.get_utente_aggiornamento');
      end if;
      return d_result;
   end; -- componente.get_utente_aggiornamento
   --------------------------------------------------------------------------------
   function get_data_aggiornamento(p_id_componente in componenti.id_componente%type)
      return componenti.data_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_data_aggiornamento
       DESCRIZIONE: Attributo data_aggiornamento di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     componenti.data_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result componenti.data_aggiornamento%type;
   begin
      dbc.pre(not dbc.preon or existsid(p_id_componente)
             ,'existsId on componente.get_data_aggiornamento');
      select data_aggiornamento
        into d_result
        from componenti
       where id_componente = p_id_componente;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on componente.get_data_aggiornamento');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'data_aggiornamento')
                      ,' AFC_DDL.IsNullable on componente.get_data_aggiornamento');
      end if;
      return d_result;
   end; -- componente.get_data_aggiornamento
   --------------------------------------------------------------------------------
   function where_condition
   (
      p_id_componente             in varchar2 default null
     ,p_progr_unita_organizzativa in varchar2 default null
     ,p_dal                       in varchar2 default null
     ,p_al                        in varchar2 default null
     ,p_dal_pubb                  in varchar2 default null
     ,p_al_pubb                   in varchar2 default null
     ,p_al_prec                   in varchar2 default null
     ,p_ni                        in varchar2 default null
     ,p_ci                        in varchar2 default null
     ,p_codice_fiscale            in varchar2 default null
     ,p_denominazione             in varchar2 default null
     ,p_denominazione_al1         in varchar2 default null
     ,p_denominazione_al2         in varchar2 default null
     ,p_ottica                    in varchar2 default null
     ,p_revisione_assegnazione    in varchar2 default null
     ,p_revisione_cessazione      in varchar2 default null
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
                     afc.get_field_condition(' and ( id_componente '
                                            ,p_id_componente
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( progr_unita_organizzativa '
                                            ,p_progr_unita_organizzativa
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
                     afc.get_field_condition(' and ( ni ', p_ni, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( ci ', p_ci, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( codice_fiscale '
                                            ,p_codice_fiscale
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( denominazione '
                                            ,p_denominazione
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( denominazione_al1 '
                                            ,p_denominazione_al1
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( denominazione_al2 '
                                            ,p_denominazione_al2
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
   end; --- componente.where_condition
   --------------------------------------------------------------------------------
   function get_rows
   (
      p_id_componente             in varchar2 default null
     ,p_progr_unita_organizzativa in varchar2 default null
     ,p_dal                       in varchar2 default null
     ,p_al                        in varchar2 default null
     ,p_dal_pubb                  in varchar2 default null
     ,p_al_pubb                   in varchar2 default null
     ,p_al_prec                   in varchar2 default null
     ,p_ni                        in varchar2 default null
     ,p_ci                        in varchar2 default null
     ,p_codice_fiscale            in varchar2 default null
     ,p_denominazione             in varchar2 default null
     ,p_denominazione_al1         in varchar2 default null
     ,p_denominazione_al2         in varchar2 default null
     ,p_ottica                    in varchar2 default null
     ,p_revisione_assegnazione    in varchar2 default null
     ,p_revisione_cessazione      in varchar2 default null
     ,p_utente_aggiornamento      in varchar2 default null
     ,p_data_aggiornamento        in varchar2 default null
     ,p_order_condition           in varchar2 default null
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
      d_statement := ' select * from componenti ' || ' where 1 = 1 ' ||
                     afc.get_field_condition(' and ( id_componente '
                                            ,p_id_componente
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( progr_unita_organizzativa '
                                            ,p_progr_unita_organizzativa
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
                     afc.get_field_condition(' and ( ni ', p_ni, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( ci ', p_ci, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( codice_fiscale '
                                            ,p_codice_fiscale
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( denominazione '
                                            ,p_denominazione
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( denominazione_al1 '
                                            ,p_denominazione_al1
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( denominazione_al2 '
                                            ,p_denominazione_al2
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
   end; -- componente.get_rows
   --------------------------------------------------------------------------------
   function count_rows
   (
      p_id_componente             in varchar2 default null
     ,p_progr_unita_organizzativa in varchar2 default null
     ,p_dal                       in varchar2 default null
     ,p_al                        in varchar2 default null
     ,p_dal_pubb                  in varchar2 default null
     ,p_al_pubb                   in varchar2 default null
     ,p_al_prec                   in varchar2 default null
     ,p_ni                        in varchar2 default null
     ,p_ci                        in varchar2 default null
     ,p_codice_fiscale            in varchar2 default null
     ,p_denominazione             in varchar2 default null
     ,p_denominazione_al1         in varchar2 default null
     ,p_denominazione_al2         in varchar2 default null
     ,p_ottica                    in varchar2 default null
     ,p_revisione_assegnazione    in varchar2 default null
     ,p_revisione_cessazione      in varchar2 default null
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
      d_statement := ' select count( * ) from componenti ' ||
                     where_condition(p_id_componente
                                    ,p_progr_unita_organizzativa
                                    ,p_dal
                                    ,p_al
                                    ,p_dal_pubb
                                    ,p_al_pubb
                                    ,p_al_prec
                                    ,p_ni
                                    ,p_ci
                                    ,p_codice_fiscale
                                    ,p_denominazione
                                    ,p_denominazione_al1
                                    ,p_denominazione_al2
                                    ,p_ottica
                                    ,p_revisione_assegnazione
                                    ,p_revisione_cessazione
                                    ,p_utente_aggiornamento
                                    ,p_data_aggiornamento
                                    ,p_other_condition
                                    ,p_qbe);
      d_result    := afc.sql_execute(d_statement);
      return d_result;
   end; -- componente.count_rows
   --------------------------------------------------------------------------------
   function get_id_componente return componenti.id_componente%type is
      /******************************************************************************
       NOME:        get_id_componente
       DESCRIZIONE: Restituisce l'id componente nuovo in caso di inserimento
       PARAMETRI:
       RITORNA:     componenti.id_componente%type
      ******************************************************************************/
      d_result componenti.id_componente%type;
   begin
      select componenti_sq.nextval into d_result from dual;
      return d_result;
   end; -- componenti.get_id_componente
   --------------------------------------------------------------------------------
   function get_descr_incarico
   (
      p_id_componente in componenti.id_componente%type
     ,p_dal           in componenti.dal%type
   ) return tipi_incarico.descrizione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_descr_incarico
       DESCRIZIONE: Restituisce la descrizione dell'incarico del componente
       PARAMETRI:   p_id_componente
                    p_dal
       RITORNA:     tipi_incarico.descrizione%type
      ******************************************************************************/
      d_incarico attributi_componente.incarico%type;
      d_result   tipi_incarico.descrizione%type;
   begin
      begin
         select incarico
           into d_incarico
           from attributi_componente
          where id_componente = p_id_componente
            and p_dal between nvl(dal, to_date('2222222', 'j')) and
                nvl(al, to_date('3333333', 'j'));
      exception
         when others then
            d_incarico := '';
      end;
      d_result := tipo_incarico.get_descrizione(p_incarico => d_incarico);
      return d_result;
   end; -- componente.get_descr_incarico
   --------------------------------------------------------------------------------
   function get_descr_incarico_mod
   (
      p_id_componente in componenti.id_componente%type
     ,p_revisione     in attributi_componente.revisione_assegnazione%type
   ) return tipi_incarico.descrizione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_descr_incarico
       DESCRIZIONE: Restituisce la descrizione dell'incarico del componente attribuito
                    con la revisione in modifica --#189
       PARAMETRI:   p_id_componente
                    p_revisione
       RITORNA:     tipi_incarico.descrizione%type
      ******************************************************************************/
      d_incarico attributi_componente.incarico%type;
      d_result   tipi_incarico.descrizione%type;
   begin
      begin
         select incarico
           into d_incarico
           from attributi_componente
          where id_componente = p_id_componente
            and revisione_assegnazione = p_revisione;
      exception
         when others then
            d_incarico := '';
      end;
      d_result := tipo_incarico.get_descrizione(p_incarico => d_incarico);
      if tipo_incarico.get_responsabile(d_incarico) = 'SI' then
         d_result := d_result || ' (Resp.)';
      end if;
      return d_result;
   end; -- componente.get_descr_incarico_mod
   --------------------------------------------------------------------------------
   function get_se_resp_corrente
   (
      p_id_componente in componenti.id_componente%type
     ,p_dal           in componenti.dal%type
   ) return tipi_incarico.responsabile%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_se_resp_corrente
       DESCRIZIONE: Restituisce il campo "responsabile" dell'incarico del componente
       PARAMETRI:   p_id_componente
                    p_dal
       RITORNA:     tipi_incarico.responsabile%type
      ******************************************************************************/
      d_incarico  attributi_componente.incarico%type;
      d_ottica    ottiche.ottica%type;
      d_revisione attributi_componente.revisione_assegnazione%type;
      d_result    tipi_incarico.responsabile%type;
   begin
      d_ottica    := componente.get_ottica(p_id_componente);
      d_revisione := revisione_struttura.get_revisione_mod(d_ottica);
      --
      if d_revisione != -1 then
         begin
            select incarico
              into d_incarico
              from attributi_componente
             where id_componente = p_id_componente
               and revisione_assegnazione = d_revisione;
         exception
            when others then
               d_incarico := '';
         end;
      end if;
      --
      if d_revisione = -1 or d_incarico is null then
         begin
            select incarico
              into d_incarico
              from attributi_componente
             where id_componente = p_id_componente
               and p_dal between dal and
                   nvl(decode(revisione_cessazione, d_revisione, to_date(null), al)
                      ,to_date(3333333, 'j'));
         exception
            when others then
               d_incarico := '';
         end;
      end if;
      --
      if d_incarico is not null then
         d_result := tipo_incarico.get_responsabile(p_incarico => d_incarico);
      else
         d_result := null;
      end if;
      --
      return d_result;
   end; -- componente.get_se_resp_corrente
   --------------------------------------------------------------------------------
   function get_se_resp_valido
   (
      p_id_componente in componenti.id_componente%type
     ,p_dal           in componenti.dal%type
   ) return tipi_incarico.responsabile%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_se_resp_valido
       DESCRIZIONE: Restituisce il campo "responsabile" dell'incarico del componente
       PARAMETRI:   p_id_componente
                    p_dal
       RITORNA:     tipi_incarico.responsabile%type
      ******************************************************************************/
      d_incarico  attributi_componente.incarico%type;
      d_ottica    ottiche.ottica%type;
      d_revisione attributi_componente.revisione_assegnazione%type;
      d_result    tipi_incarico.responsabile%type;
   begin
      d_ottica    := componente.get_ottica(p_id_componente);
      d_revisione := revisione_struttura.get_revisione_mod(d_ottica);
      --
      begin
         select incarico
           into d_incarico
           from attributi_componente
          where id_componente = p_id_componente
            and p_dal between dal and
                nvl(decode(revisione_cessazione, d_revisione, to_date(null), al)
                   ,to_date(3333333, 'j'));
      exception
         when others then
            d_incarico := '';
      end;
      --
      if d_incarico is not null then
         d_result := tipo_incarico.get_responsabile(p_incarico => d_incarico);
      else
         d_result := null;
      end if;
      --
      return d_result;
   end; -- componente.get_se_responsabile
   --------------------------------------------------------------------------------
   function get_ultima_assegnazione(p_ci in componenti.ci%type)
      return componenti.progr_unita_organizzativa%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_ultima_assegnazione
       DESCRIZIONE: Restituisce il campo "progr unita' organizzativa" dell'ultima
                    assegnazione del componente
       PARAMETRI:   p_ci
       RITORNA:     componenti.progr_unita_organizzativa%type
      ******************************************************************************/
      d_result componenti.progr_unita_organizzativa%type;
   begin
      begin
         select c1.progr_unita_organizzativa
           into d_result
           from componenti c1
          where c1.ci = p_ci
            and c1.dal = (select max(c2.dal)
                            from componenti c2
                           where c2.ci = p_ci
                             and not exists
                           (select 'x'
                                    from revisioni_struttura r
                                   where r.ottica = c1.ottica
                                     and r.revisione = nvl(c1.revisione_assegnazione, -1)
                                     and r.stato = 'M'));
      exception
         when others then
            d_result := '';
      end;
      return d_result;
   end; -- componente.get_ultima_assegnazione
   --------------------------------------------------------------------------------
   function controllo_modificabilita
   (
      p_ottica in componenti.ottica%type
     ,p_ni     in componenti.ni%type
     ,p_ci     in componenti.ci%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        controllo_modificabilita
       DESCRIZIONE: In presenza di integrazione con GP4, verifica che non ci siano
                    modifiche da acquisire. In caso contrario, la modifica del
                    componente non e' consentita.
       PARAMETRI:   p_ottica
                    p_ni
                    p_ci
       RITORNA:     afc_error.ok, altrimenti codice errore
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
      d_result := so4gp_pkg.controllo_modificabilita(p_ottica, p_ni, p_ci); --#429
      return d_result;
      --
   end; -- componente.controllo_modificabilita
   --------------------------------------------------------------------------------
   function determina_nominativo_cdr(p_ni in componenti.ni%type)
      return ad4_utenti.nominativo%type is
      /******************************************************************************
       NOME:        determina_nominativo_cdr
       DESCRIZIONE: Compone il nominativo da inserire in AD4_Utenti
                    secondo le regole stabilite per il comune di
                    Casalecchio di Reno.
                    Iniziale del nome + "." + cognome
                    Se il nome è composto si mettono entrambe le iniziali (es. Gian Maria = GM)
                    In caso di omonimia si aggiunge una lettere al nome fino a trovare una
                    combinazione valida.
                    Se non si riesce a calcolare una combinazione valida si restituisce
                    nominativo = null.
       PARAMETRI:   --
       NOTE:        --
      ******************************************************************************/
      d_cognome           as4_anagrafe_soggetti.cognome%type;
      d_nome              as4_anagrafe_soggetti.nome%type;
      d_nome_1            varchar2(20);
      d_nome_2            varchar2(20);
      d_utente            ad4_utenti.utente%type;
      d_nominativo        ad4_utenti.nominativo%type;
      d_esiste_nominativo boolean;
      d_contatore         number(3);
      d_lunghezza         number(2);
   begin
      select cognome
            ,nome
        into d_cognome
            ,d_nome
        from as4_anagrafe_soggetti
       where ni = p_ni
         and trunc(sysdate) between dal and nvl(al, to_date('3333333', 'j'));
      d_cognome := replace(replace(d_cognome, ' ', ''), '''', '');
      if instr(d_nome, ' ', 1) > 0 then
         d_nome_1 := substr(d_nome, 1, instr(d_nome, ' ', 1) - 1);
         d_nome_2 := rtrim(substr(d_nome, instr(d_nome, ' ', 1) + 1));
      else
         d_nome_1 := rtrim(d_nome);
         d_nome_2 := null;
      end if;
      d_nominativo        := substr(d_nome_1, 1, 1) || substr(d_nome_2, 1, 1) || '.' ||
                             d_cognome;
      d_esiste_nominativo := true;
      d_contatore         := 0;
      d_lunghezza         := length(d_nominativo);
      while d_esiste_nominativo
      loop
         d_contatore := d_contatore + 1;
         if (d_lunghezza + d_contatore) > 40 then
            d_nominativo := null;
         else
            if length(d_nome_1) > d_contatore then
               d_nominativo := substr(d_nome_1, 1, d_contatore) || substr(d_nome_2, 1, 1) || '.' ||
                               d_cognome;
            else
               d_contatore  := 40 - d_lunghezza;
               d_nominativo := d_nome_1 || d_nome_2 || '.' || d_cognome;
            end if;
            d_utente := ad4_utente.get_utente(d_nominativo);
            if d_utente is null then
               d_esiste_nominativo := false;
            end if;
         end if;
      end loop;
      return d_nominativo;
   end; -- componente.determina_nominativo_cdr
   --------------------------------------------------------------------------------
   function determina_nominativo_provmo(p_ni in componenti.ni%type)
      return ad4_utenti.nominativo%type is
      /******************************************************************************
       NOME:        determina_nominativo_provmo
       DESCRIZIONE: Compone il nominativo da inserire in AD4_Utenti
                    secondo le regole stabilite per la provincia di MO
                    Cognome + "." + Iniziale del nome
                    In caso di omonimia si aggiunge una lettera al nome fino a
                    trovare una combinazione valida.
                    Se non si trova una combinazione valida, si restituisce
                    nominativo = null.
       PARAMETRI:   --
       NOTE:        --
      ******************************************************************************/
      d_cognome           as4_anagrafe_soggetti.cognome%type;
      d_nome              as4_anagrafe_soggetti.nome%type;
      d_utente            ad4_utenti.utente%type;
      d_nominativo        ad4_utenti.nominativo%type;
      d_esiste_nominativo boolean;
      d_contatore         number(3);
      d_lunghezza         number(2);
   begin
      select cognome
            ,nome
        into d_cognome
            ,d_nome
        from as4_anagrafe_soggetti
       where ni = p_ni
         and trunc(sysdate) between dal and nvl(al, to_date('3333333', 'j'));
      d_esiste_nominativo := true;
      d_contatore         := 0;
      d_lunghezza         := length(rtrim(d_cognome) || '.');
      while d_esiste_nominativo
      loop
         if (d_lunghezza + d_contatore) > 40 then
            d_nominativo := null;
         else
            d_contatore  := d_contatore + 1;
            d_nominativo := rtrim(d_cognome) || '.' || substr(d_nome, 1, d_contatore);
            d_utente     := ad4_utente.get_utente(d_nominativo);
            if d_utente is null then
               d_esiste_nominativo := false;
            end if;
         end if;
      end loop;
      return d_nominativo;
   end; -- componente.determina_nominativo_provmo
   --------------------------------------------------------------------------------
   function determina_nominativo_sgm(p_ni in componenti.ni%type)
      return ad4_utenti.nominativo%type is
      /******************************************************************************
       NOME:        determina_nominativo_sgm
       DESCRIZIONE: Compone il nominativo da inserire in AD4_Utenti
                    secondo le regole stabilite per il comune di
                    San Giuliano Milanese.
                    Nome + "." + Cognome, eliminando spazi e apostrofi.
                    In caso di omonimia, si restituisce il nominativo = null.
       PARAMETRI:   --
       NOTE:        --
      ******************************************************************************/
      d_cognome    as4_anagrafe_soggetti.cognome%type;
      d_nome       as4_anagrafe_soggetti.nome%type;
      d_nominativo ad4_utenti.nominativo%type;
   begin
      begin
         select cognome
               ,nome
           into d_cognome
               ,d_nome
           from as4_anagrafe_soggetti
          where ni = p_ni
            and trunc(sysdate) between dal and nvl(al, to_date('3333333', 'j'));
      exception
         when others then
            d_cognome := null;
            d_nome    := null;
      end;
      if length(replace(replace(d_nome || '.' || d_cognome, ' ', ''), '''', '')) > 40 then
         d_nominativo := null;
      else
         d_nominativo := replace(replace(d_nome || '.' || d_cognome, ' ', ''), '''', '');
         if ad4_utente.exists_username(d_nominativo) = 1 then
            d_nominativo := null;
         end if;
      end if;
      return d_nominativo;
   end; -- componente.determina_nominativo_sgm
   --------------------------------------------------------------------------------
   function determina_nominativo_rm(p_ni in componenti.ni%type)
      return ad4_utenti.nominativo%type is
      /******************************************************************************
       NOME:        determina_nominativo_RM
       DESCRIZIONE: Compone il nominativo da inserire in AD4_Utenti
                    nome + '_' + cognome
                    in caso di omonimia, si aggiunge un progressivo numerico
                    di due cifre partendo da 02
                    Utilizzato da:
                    - Regione Marche
       PARAMETRI:   --
       NOTE:        --
      ******************************************************************************/
      d_cognome           as4_anagrafe_soggetti.cognome%type;
      d_nome              as4_anagrafe_soggetti.nome%type;
      d_utente            ad4_utenti.utente%type;
      d_nominativo        ad4_utenti.nominativo%type;
      d_esiste_nominativo boolean;
      d_contatore         number(3);
   begin
      begin
         select cognome
               ,nome
           into d_cognome
               ,d_nome
           from as4_anagrafe_soggetti
          where ni = p_ni
            and trunc(sysdate) between dal and nvl(al, to_date('3333333', 'j'));
      exception
         when others then
            d_cognome := null;
            d_nome    := null;
      end;
      --
      if d_cognome is null and d_nome is null then
         d_nominativo := null;
      else
         d_nominativo        := replace(replace(d_nome || '_' || d_cognome, ' ', '')
                                       ,''''
                                       ,'');
         d_esiste_nominativo := true;
         d_contatore         := 2;
         while d_esiste_nominativo
         loop
            d_utente := ad4_utente.get_utente(d_nominativo);
            if d_utente is null then
               d_esiste_nominativo := false;
            else
               d_contatore  := d_contatore + 1;
               d_nominativo := d_nominativo || lpad(d_contatore, 2, '0');
            end if;
         end loop;
      end if;
      --
      return d_nominativo;
      --
   end; -- componente.determina_nominativo_RM
   --------------------------------------------------------------------------------
   function determina_nominativo_n_sp_c(p_ni in componenti.ni%type)
      return ad4_utenti.nominativo%type is
      /******************************************************************************
       NOME:        determina_nominativo_n_sp_c
       DESCRIZIONE: Compone il nominativo da inserire in AD4_Utenti
                    Nome + spazio + cognome
                    in caso di omonimia, si aggiunge un progressivo numerico
                    di due cifre partendo da 02
                    Utilizzato da:
                    - SERT Regione Toscana
                    - SERT Regione Campania
       PARAMETRI:   --
       NOTE:        --
      ******************************************************************************/
      d_cognome           as4_anagrafe_soggetti.cognome%type;
      d_nome              as4_anagrafe_soggetti.nome%type;
      d_utente            ad4_utenti.utente%type;
      d_nominativo        ad4_utenti.nominativo%type;
      d_esiste_nominativo boolean;
      d_contatore         number(3);
   begin
      begin
         select cognome
               ,nome
           into d_cognome
               ,d_nome
           from as4_anagrafe_soggetti
          where ni = p_ni
            and trunc(sysdate) between dal and nvl(al, to_date('3333333', 'j'));
      exception
         when others then
            d_cognome := null;
            d_nome    := null;
      end;
      --
      if d_cognome is null and d_nome is null then
         d_nominativo := null;
      else
         d_nominativo        := d_nome || ' ' || d_cognome;
         d_esiste_nominativo := true;
         d_contatore         := 1;
         while d_esiste_nominativo
         loop
            d_utente := ad4_utente.get_utente(d_nominativo);
            if d_utente is null then
               d_esiste_nominativo := false;
            else
               d_contatore  := d_contatore + 1;
               d_nominativo := d_nominativo || lpad(d_contatore, 2, '0');
            end if;
         end loop;
      end if;
      --
      return d_nominativo;
      --
   end; -- componente.determina_nominativo_n_sp_c
   --------------------------------------------------------------------------------
   function determina_nominativo_4(p_ni in componenti.ni%type)
      return ad4_utenti.nominativo%type is
      /******************************************************************************
       NOME:        determina_nominativo_4
       DESCRIZIONE: Compone il nominativo da inserire in AD4_Utenti
                    Iniziale del nome + cognome
                    in caso di omonimia, si aggiunge un progressivo numerico
                    di due cifre partendo da 02
                    Utilizzato da:
                    - Provincia di Brescia
                    - Comune di Cornaredo
                    - Comune di Vigevano
       PARAMETRI:   --
       NOTE:        --
      ******************************************************************************/
      d_cognome           as4_anagrafe_soggetti.cognome%type;
      d_nome              as4_anagrafe_soggetti.nome%type;
      d_utente            ad4_utenti.utente%type;
      d_nominativo        ad4_utenti.nominativo%type;
      d_esiste_nominativo boolean;
      d_contatore         number(3);
   begin
      begin
         select cognome
               ,nome
           into d_cognome
               ,d_nome
           from as4_anagrafe_soggetti
          where ni = p_ni
            and trunc(sysdate) between dal and nvl(al, to_date('3333333', 'j'));
      exception
         when others then
            d_cognome := null;
            d_nome    := null;
      end;
      --
      if d_cognome is null and d_nome is null then
         d_nominativo := null;
      else
         d_nominativo        := substr(d_nome, 1, 1) || d_cognome;
         d_esiste_nominativo := true;
         d_contatore         := 2;
         while d_esiste_nominativo
         loop
            d_utente := ad4_utente.get_utente(d_nominativo);
            if d_utente is null then
               d_esiste_nominativo := false;
            else
               d_contatore  := d_contatore + 1;
               d_nominativo := d_nominativo || lpad(d_contatore, 2, '0');
            end if;
         end loop;
      end if;
      --
      return d_nominativo;
      --
   end; -- componente.determina_nominativo_4
   --------------------------------------------------------------------------------
   function determina_nominativo_5(p_ni in componenti.ni%type)
      return ad4_utenti.nominativo%type is
      /******************************************************************************
       NOME:        determina_nominativo_5
       DESCRIZIONE: Compone il nominativo da inserire in AD4_Utenti
                    Cognome + iniziale del nome
                    in caso di omonimia, si espone il nome completo
                    in caso di omonimia, si aggiunge un progressivo numerico al nome
                    partendo da 1
                    Utilizzato da:
                    - CRV
       PARAMETRI:   --
       NOTE:        --
      ******************************************************************************/
      d_cognome           as4_anagrafe_soggetti.cognome%type;
      d_nome              as4_anagrafe_soggetti.nome%type;
      d_utente            ad4_utenti.utente%type;
      d_nominativo        ad4_utenti.nominativo%type;
      d_esiste_nominativo boolean;
      d_contatore         number(3);
   begin
      begin
         select cognome
               ,nome
           into d_cognome
               ,d_nome
           from as4_anagrafe_soggetti
          where ni = p_ni
            and trunc(sysdate) between dal and nvl(al, to_date('3333333', 'j'));
      exception
         when others then
            d_cognome := null;
            d_nome    := null;
      end;
      --
      if d_cognome is null and d_nome is null then
         d_nominativo := null;
      else
         d_cognome    := replace(d_cognome, ' ', '');
         d_nome       := replace(d_nome, ' ', '');
         d_cognome    := replace(d_cognome, '''', '');
         d_nome       := replace(d_nome, '''', '');
         d_nominativo := d_cognome || substr(d_nome, 1, 1);
         d_utente     := ad4_utente.get_utente(d_nominativo);
         if d_utente is not null then
            d_nominativo        := d_cognome || d_nome;
            d_esiste_nominativo := true;
            d_contatore         := 0;
            while d_esiste_nominativo
            loop
               d_utente := ad4_utente.get_utente(d_nominativo);
               if d_utente is null then
                  d_esiste_nominativo := false;
               else
                  d_contatore  := d_contatore + 1;
                  d_nominativo := d_cognome || d_nome || d_contatore;
               end if;
            end loop;
         end if;
      end if;
      --
      return d_nominativo;
      --
   end; -- componente.determina_nominativo_5
   --------------------------------------------------------------------------------
   function determina_nominativo_6(p_ni in componenti.ni%type)
      return ad4_utenti.nominativo%type is
      /******************************************************************************
       NOME:        determina_nominativo_6
       DESCRIZIONE: Compone il nominativo da inserire in AD4_Utenti
                    Nome + "." + Cognome
                    Se il nominativo è più lungo di 20 crt, si utilizza
                    Iniziale del nome + "." + Cognome
                    In caso di omonimia si aggiunge una lettera al nome
                    Utilizzato da:
                    - Regione Calabria
       PARAMETRI:   --
       NOTE:        --
      ******************************************************************************/
      d_cognome           as4_anagrafe_soggetti.cognome%type;
      d_nome              as4_anagrafe_soggetti.nome%type;
      d_utente            ad4_utenti.utente%type;
      d_nominativo        ad4_utenti.nominativo%type;
      d_esiste_nominativo boolean;
      d_contatore         number(3);
   begin
      begin
         select cognome
               ,nome
           into d_cognome
               ,d_nome
           from as4_anagrafe_soggetti
          where ni = p_ni
            and trunc(sysdate) between dal and nvl(al, to_date('3333333', 'j'));
      exception
         when others then
            d_cognome := null;
            d_nome    := null;
      end;
      --
      if d_cognome is null and d_nome is null then
         d_nominativo := null;
      else
         d_cognome    := replace(d_cognome, ' ', '');
         d_nome       := replace(d_nome, ' ', '');
         d_cognome    := replace(d_cognome, '''', '');
         d_nome       := replace(d_nome, '''', '');
         d_nominativo := d_nome || '.' || d_cognome;
         d_contatore  := 0;
         if length(d_nominativo) > 20 then
            d_nominativo := substr(d_nome, 1, 1) || '.' || d_cognome;
            d_contatore  := 1;
         end if;
         d_esiste_nominativo := true;
         while d_esiste_nominativo
         loop
            d_utente := ad4_utente.get_utente(d_nominativo);
            if d_utente is null then
               d_esiste_nominativo := false;
            else
               d_contatore  := d_contatore + 1;
               d_nominativo := substr(d_nome, 1, d_contatore) || '.' || d_cognome;
            end if;
         end loop;
      end if;
      --
      return d_nominativo;
      --
   end; -- componente.determina_nominativo_6
   --------------------------------------------------------------------------------
   function determina_nominativo_7(p_ni in componenti.ni%type)
      return ad4_utenti.nominativo%type is
      /******************************************************************************
       NOME:        determina_nominativo_7
       DESCRIZIONE: Compone il nominativo da inserire in AD4_Utenti
                    secondo le regole stabilite per la provincia di MO
                    Cognome + "." + Iniziale del nome
                    In caso di omonimia si aggiunge una lettera al nome fino a
                    trovare una combinazione valida.
                    Se non si trova una combinazione valida, si restituisce
                    nominativo = null.
       PARAMETRI:   --
       NOTE:        --
      ******************************************************************************/
      d_cognome           as4_anagrafe_soggetti.cognome%type;
      d_nome              as4_anagrafe_soggetti.nome%type;
      d_utente            ad4_utenti.utente%type;
      d_nominativo        ad4_utenti.nominativo%type;
      d_esiste_nominativo boolean;
      d_contatore         number(3);
      d_lunghezza         number(2);
   begin
      select replace(replace(cognome, ' ', ''), '''', '')
            ,replace(replace(nome, ' ', ''), '''', '')
        into d_cognome
            ,d_nome
        from as4_anagrafe_soggetti
       where ni = p_ni
         and trunc(sysdate) between dal and nvl(al, to_date('3333333', 'j'));
      d_esiste_nominativo := true;
      d_contatore         := 0;
      d_lunghezza         := length(rtrim(d_cognome) || '.');
      while d_esiste_nominativo
      loop
         if (d_lunghezza + d_contatore) > 40 then
            d_nominativo := null;
         else
            if d_contatore > 0 then
               d_contatore := 40 - d_contatore + d_lunghezza;
            else
               d_contatore := d_contatore + 1;
            end if;
            d_nominativo := rtrim(d_cognome) || '.' || substr(d_nome, 1, d_contatore);
            d_utente     := ad4_utente.get_utente(d_nominativo);
            if d_utente is null then
               d_esiste_nominativo := false;
            end if;
         end if;
      end loop;
      return d_nominativo;
   end determina_nominativo_7;
   --------------------------------------------------------------------------------
   function determina_nominativo(p_ni in componenti.ni%type)
      return ad4_utenti.nominativo%type is
      /******************************************************************************
       NOME:        determina_nominativo
       DESCRIZIONE: Compone il nominativo da inserire in AD4_Utenti
       PARAMETRI:   p_ni                  ni del soggetto
       NOTE:        --
       008   23/06/2011   SNegroni Per il nominativo può essere usata la funzione distribuita con AD4.
      ******************************************************************************/
      d_nome_procedura impostazioni.procedura_nominativo%type;
      d_nominativo     ad4_utenti.nominativo%type;
      d_statement      varchar2(32767);
      cursor_id        integer;
      rows_processed   integer;
   begin
      d_nome_procedura := impostazione.get_procedura_nominativo(1);
      if d_nome_procedura is null then
         d_nominativo := null;
         return d_nominativo;
      elsif instr(d_nome_procedura, '.') = 0 then
         -- NON richiama package.function
         d_nome_procedura := 'componente.' || d_nome_procedura;
      end if;
      d_statement := 'select ' || d_nome_procedura || '(' || p_ni || ')' || ' from dual';
      cursor_id   := dbms_sql.open_cursor;
      dbms_sql.parse(cursor_id, d_statement, dbms_sql.native);
      dbms_sql.define_column(cursor_id, 1, d_nominativo, 100);
      rows_processed := dbms_sql.execute(cursor_id);
      if dbms_sql.fetch_rows(cursor_id) > 0 then
         dbms_sql.column_value(cursor_id, 1, d_nominativo);
      else
         d_nominativo := null;
      end if;
      dbms_sql.close_cursor(cursor_id);
      return d_nominativo;
   end; -- componente.determina_nominativo
   --------------------------------------------------------------------------------
   function determina_utente_sgm(p_ni in componenti.ni%type) return ad4_utenti.utente%type is
      /******************************************************************************
       NOME:        determina_nominativo_sgm
       DESCRIZIONE: Compone l'utente da inserire in AD4_Utenti
                    secondo le regole stabilite per il comune di
                    San Giuliano Milanese
                    Primi 8 caratteri del cognome.
                    In caso di omonimia, si elimina l'ultima lettera del cognome e si
                    aggiunge una lettera del nome a partire dalla prima fino a trovare
                    una combinazione valida.
                    Se non si trova una combinazione valida, si restituisce
                    utente = null.
       PARAMETRI:   --
       NOTE:        --
      ******************************************************************************/
      d_cognome       as4_anagrafe_soggetti.cognome%type;
      d_nome          as4_anagrafe_soggetti.nome%type;
      d_utente        ad4_utenti.utente%type;
      d_esiste_utente boolean;
      d_contatore     number(3);
   begin
      begin
         select cognome
               ,nome
           into d_cognome
               ,d_nome
           from as4_anagrafe_soggetti
          where ni = p_ni
            and trunc(sysdate) between dal and nvl(al, to_date('3333333', 'j'));
      exception
         when others then
            d_cognome := null;
            d_nome    := null;
      end;
      if d_cognome is not null then
         d_esiste_utente := true;
         d_contatore     := 9;
         while d_esiste_utente
         loop
            if d_contatore = 0 then
               d_utente        := null;
               d_esiste_utente := false;
            else
               d_contatore := d_contatore - 1;
               d_utente    := substr(d_cognome, 1, d_contatore) ||
                              substr(d_nome, 1, abs(d_contatore - 8));
               if ad4_utente.exists_utente(d_utente) = 0 then
                  d_esiste_utente := false;
               end if;
            end if;
         end loop;
      end if;
      return d_utente;
   end; -- componente.determina_utente_sgm
   --------------------------------------------------------------------------------
   function determina_utente_7(p_ni in componenti.ni%type) return ad4_utenti.utente%type
   /******************************************************************************
       NOME:        determina_utente_7
       DESCRIZIONE: Compone il codice utente da inserire in AD4_Utenti
                    secondo le regole stabilite per la provincia di MO
       PARAMETRI:   --
       NOTE:        --
      ******************************************************************************/
    is
      d_cognome           anagrafe_soggetti.cognome%type;
      d_nome              anagrafe_soggetti.nome%type;
      d_utente            ad4_utenti.utente%type;
      d_nominativo        ad4_utenti.nominativo%type;
      d_esiste_nominativo boolean;
      d_contatore         number(3);
      d_lunghezza         number(2);
   begin
      select replace(replace(cognome, ' ', ''), '''', '')
            ,replace(replace(nome, ' ', ''), '''', '')
        into d_cognome
            ,d_nome
        from anagrafe_soggetti
       where ni = p_ni
         and trunc(sysdate) between dal and nvl(al, to_date('3333333', 'j'));
      --                            and nvl(al,to_date('31/12/2999','dd/mm/yyyy'));
      d_esiste_nominativo := true;
      d_contatore         := 0;
      d_lunghezza         := 8;
      while d_esiste_nominativo
      loop
         if (d_lunghezza + d_contatore) > 8 then
            d_utente            := null;
            d_esiste_nominativo := false;
         else
            d_contatore := d_contatore + 1;
            d_utente    := substr(rtrim(d_cognome), 1, d_lunghezza - d_contatore) ||
                           substr(d_nome, 1, d_contatore);
            begin
               select nominativo
                 into d_nominativo
                 from ad4_utenti
                where utente = d_utente;
            exception
               when no_data_found then
                  d_nominativo := to_char(null);
            end;
            --      d_nominativo := ad4_utente.get_utente (d_utente);
            if d_nominativo is null then
               d_esiste_nominativo := false;
            end if;
         end if;
      end loop;
      return d_utente;
   end determina_utente_7;
   --------------------------------------------------------------------------------
   function determina_utente(p_ni in componenti.ni%type) return ad4_utenti.utente%type is
      /******************************************************************************
       NOME:        Determina_utente
       DESCRIZIONE: Compone l'utente da inserire in AD4_Utenti
       PARAMETRI:   p_ni             ni del soggetto
       NOTE:        --
      ******************************************************************************/
      d_nome_procedura impostazioni.procedura_nominativo%type;
      d_utente         ad4_utenti.utente%type;
      d_statement      varchar2(32767);
      cursor_id        integer;
      rows_processed   integer;
   begin
      d_nome_procedura := impostazione.get_procedura_nominativo(1);
      if d_nome_procedura is null or
         d_nome_procedura not in ('DETERMINA_NOMINATIVO_7', 'DETERMINA_NOMINATIVO_SGM') or
         instr(d_nome_procedura, '.') > 0 then
         -- NON esiste procedure per calcolo utente
         d_utente := null;
         return d_utente;
      end if;
      if d_nome_procedura = 'DETERMINA_NOMINATIVO_7' then
         d_statement := 'select ' || 'COMPONENTE.DETERMINA_UTENTE_7' || '(' || p_ni || ')' ||
                        'from dual';
      else
         d_statement := 'select ' || 'COMPONENTE.DETERMINA_UTENTE_SGM' || '(' || p_ni || ')' ||
                        'from dual';
      end if;
      cursor_id := dbms_sql.open_cursor;
      dbms_sql.parse(cursor_id, d_statement, dbms_sql.native);
      dbms_sql.define_column(cursor_id, 1, d_utente, 100);
      rows_processed := dbms_sql.execute(cursor_id);
      if dbms_sql.fetch_rows(cursor_id) > 0 then
         dbms_sql.column_value(cursor_id, 1, d_utente);
      else
         d_utente := null;
      end if;
      dbms_sql.close_cursor(cursor_id);
      return d_utente;
   end; -- componente.determina_utente
   --------------------------------------------------------------------------------
   function is_ultima_assegnazione(p_id_componente componenti.id_componente%type)
      return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_ultima_assegnazione
       DESCRIZIONE: Controlla se esiste un'ulteriore assegnazione per il componente
       PARAMETRI:   p_id_componente          componenti.id_componente%type
       RITORNA:     afc_error.t_error_number
       NOTE:        --
      ******************************************************************************/
      d_result    afc_error.t_error_number;
      d_ottica    ottiche.ottica%type;
      d_revisione revisioni_struttura.revisione%type;
      d_ni        componenti.ni%type;
      d_ci        componenti.ci%type;
      d_al        componenti.al%type;
      d_ass_prev  attributi_componente.assegnazione_prevalente%type;
   begin
      d_ottica    := componente.get_ottica(p_id_componente);
      d_revisione := revisione_struttura.get_revisione_mod(d_ottica);
      begin
         select c.ni
               ,c.ci
               ,c.al
               ,a.assegnazione_prevalente
           into d_ni
               ,d_ci
               ,d_al
               ,d_ass_prev
           from componenti           c
               ,attributi_componente a
          where c.id_componente = p_id_componente
            and nvl(c.revisione_assegnazione, -2) != d_revisione
            and c.id_componente = a.id_componente
            and nvl(a.revisione_assegnazione, -2) != d_revisione
            and nvl(decode(c.revisione_cessazione, d_revisione, to_date(null), c.al)
                   ,to_date(3333333, 'j')) =
                nvl(decode(a.revisione_cessazione, d_revisione, to_date(null), a.al)
                   ,to_date(3333333, 'j'));
      exception
         when no_data_found then
            d_ni       := to_number(null);
            d_ci       := to_number(null);
            d_al       := to_date(null);
            d_ass_prev := to_number(null);
      end;
      --
      if d_ni is not null then
         if d_al is null then
            d_result := 0;
         else
            begin
               select afc_error.ok
                 into d_result
                 from dual
                where exists
                (select 'x'
                         from componenti           c
                             ,attributi_componente a
                        where c.id_componente = a.id_componente
                          and c.ni = d_ni
                          and nvl(c.ci, 0) = nvl(d_ci, 0)
                          and c.dal > d_al
                          and nvl(c.revisione_assegnazione, -2) != d_revisione
                          and nvl(a.tipo_assegnazione, 'I') = 'I'
                          and nvl(a.revisione_assegnazione, -2) != d_revisione
                          and nvl(a.assegnazione_prevalente, 0) = nvl(d_ass_prev, 0));
            exception
               when others then
                  d_result := 0;
            end;
         end if;
      end if;
      --
      return d_result;
      --
   end;
   --------------------------------------------------------------------------------
   function is_dal_al_ok
   (
      p_dal in componenti.dal%type
     ,p_al  in componenti.al%type
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
         d_result := s_dal_al_errato_number;
      else
         d_result := afc_error.ok;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on area_org_om.is_dal_al_ok');
      return d_result;
   end; -- componente.is_dal_al_ok
   --------------------------------------------------------------------------------
   function is_revisioni_ok
   (
      p_revisione_assegnazione in componenti.revisione_assegnazione%type
     ,p_revisione_cessazione   in componenti.revisione_cessazione%type
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
         p_revisione_assegnazione < p_revisione_cessazione) then
         d_result := afc_error.ok;
      else
         d_result := s_revisioni_errate_num;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on componente.is_revisioni_ok');
      return d_result;
   end; -- componenti.is_revisioni_ok
   --------------------------------------------------------------------------------
   function is_di_ok
   (
      p_dal                    in componenti.dal%type
     ,p_al                     in componenti.al%type
     ,p_revisione_assegnazione in componenti.revisione_assegnazione%type default null
     ,p_revisione_cessazione   in componenti.revisione_cessazione%type default null
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_DI_ok
       DESCRIZIONE: Controllo data integrity
                    is_dal_al_ok
                    is_revisioni_ok
       PARAMETRI:   p_dal
                    p_al
                    p_revisione_assegnazione
                    p_revisione_cessazione
       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number := afc_error.ok;
   begin
      -- verifica se la data di inizio e la revisione di assegnazioni sono stati comunicati
      if p_dal is null and p_revisione_assegnazione is null then
         d_result := s_data_inizio_mancante_num;
         return d_result;
      end if;
      if d_result = afc_error.ok then
         -- is_dal_al_ok
         d_result := is_dal_al_ok(p_dal, p_al);
         -- #533
         /*if d_result = afc_error.ok then
            d_result := is_revisioni_ok(p_revisione_assegnazione, p_revisione_cessazione);
         end if;*/
         return d_result;
      end if;
   end; -- componente.is_DI_ok
   --------------------------------------------------------------------------------
   procedure chk_di
   (
      p_dal                    in componenti.dal%type
     ,p_al                     in componenti.al%type
     ,p_ottica                 in componenti.ottica%type
     ,p_revisione_assegnazione in componenti.revisione_assegnazione%type default null
     ,p_revisione_cessazione   in componenti.revisione_cessazione%type default null
   ) is
      /******************************************************************************
       NOME:        chk_DI.
       DESCRIZIONE: controllo data integrity
                    - dal < al
                    - se le revisioni sono entrambe non nulle deve essere revisione_assegnazione < revisione_cessazione
       RITORNA:     -
      ******************************************************************************/
      d_result              afc_error.t_error_number := afc_error.ok;
      d_tipo_revisione_ass  revisioni_struttura.tipo_revisione%type;
      d_tipo_revisione_cess revisioni_struttura.tipo_revisione%type;
   begin
      if p_revisione_assegnazione is not null then
         d_tipo_revisione_ass := revisione_struttura.get_tipo_revisione(p_ottica
                                                                       ,p_revisione_assegnazione);
      end if;
      if p_revisione_cessazione is not null then
         d_tipo_revisione_cess := revisione_struttura.get_tipo_revisione(p_ottica
                                                                        ,p_revisione_cessazione);
      end if;
      if ((p_revisione_assegnazione is not null and nvl(d_tipo_revisione_ass, 'N') = 'N') or
         p_revisione_assegnazione is null) and
         ((p_revisione_cessazione is not null and nvl(d_tipo_revisione_cess, 'N') = 'N') or
         p_revisione_cessazione is null) and revisione_struttura.s_attivazione = 0 then
         d_result := is_di_ok(p_dal
                             ,p_al
                             ,p_revisione_assegnazione
                             ,p_revisione_cessazione);
         dbc.assertion(not dbc.assertionon or d_result = afc_error.ok or d_result < 0
                      ,'d_result = AFC_Error.ok or d_result < 0 on componente.chk_DI');
      end if;
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, s_error_table(d_result));
      end if;
   end; -- componente.chk_DI
   --------------------------------------------------------------------------------
   function is_dal_ok
   (
      p_ottica                    in componenti.ottica%type
     ,p_progr_unita_organizzativa in componenti.progr_unita_organizzativa%type
     ,p_ni                        in componenti.ni%type
     ,p_ci                        in componenti.ci%type
     ,p_denominazione             in componenti.denominazione%type
     ,p_old_dal                   in componenti.dal%type
     ,p_new_dal                   in componenti.dal%type
     ,p_old_al                    in componenti.al%type
     ,p_rowid                     in rowid
     ,p_inserting                 in number
     ,p_updating                  in number
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_dal_ok
       DESCRIZIONE: Controllo nuovo dal compreso in periodo immediatamente
                    precedente
       PARAMETRI:   p_ottica
                    p_progr_unita_organizzativa
                    p_ni
                    p_ci
                    p_denominazione
                    p_old_dal
                    p_new_dal
                    p_old_al
                    p_rowid
                    p_inserting
                    p_updating
       NOTE:        --
      ******************************************************************************/
      d_periodo afc_periodo.t_periodo;
      d_result  afc_error.t_error_number := afc_error.ok;
   begin
      if p_inserting = 1 and p_updating = 0 then
         d_periodo := afc_periodo.get_ultimo(p_tabella            => 'COMPONENTI'
                                            ,p_nome_dal           => 'DAL'
                                            ,p_nome_al            => 'AL'
                                            ,p_al                 => p_old_al
                                            ,p_campi_controllare  => '#OTTICA#PROGR_UNITA_ORGANIZZATIVA#NVL(NI,-1)#NVL(CI,-1)#NVL(DENOMINAZIONE,''*'')' || '#'
                                            ,p_valori_controllare => '#' || p_ottica || '#' ||
                                                                     p_progr_unita_organizzativa || '#' ||
                                                                     nvl(p_ni, -1) || '#' ||
                                                                     nvl(p_ci, -1) || '#' ||
                                                                     nvl(p_denominazione
                                                                        ,'*') || '#'
                                            ,p_rowid              => p_rowid);
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
         if p_new_dal < p_old_dal then
            d_periodo := afc_periodo.get_precedente(p_tabella            => 'COMPONENTI'
                                                   ,p_nome_dal           => 'DAL'
                                                   ,p_nome_al            => 'AL'
                                                   ,p_dal                => p_old_dal
                                                   ,p_al                 => p_old_al
                                                   ,p_campi_controllare  => '#OTTICA#PROGR_UNITA_ORGANIZZATIVA#NVL(NI,-1)#NVL(CI,-1)#NVL(DENOMINAZIONE,''*'')' || '#'
                                                   ,p_valori_controllare => '#' ||
                                                                            p_ottica || '#' ||
                                                                            p_progr_unita_organizzativa || '#' ||
                                                                            nvl(p_ni, -1) || '#' ||
                                                                            nvl(p_ci, -1) || '#' ||
                                                                            nvl(p_denominazione
                                                                               ,'*') || '#'
                                                   ,p_rowid              => p_rowid);
            if d_periodo.dal is null and d_periodo.al is null then
               d_result := afc_error.ok;
            else
               if p_new_dal < d_periodo.al then
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
              ,'d_result = AFC_Error.ok or d_result < 0 on componente.is_dal_ok');
      return d_result;
   end; -- componente.is_dal_ok
   --------------------------------------------------------------------------------
   function is_al_ok
   (
      p_ottica                    in componenti.ottica%type
     ,p_progr_unita_organizzativa in componenti.progr_unita_organizzativa%type
     ,p_ni                        in componenti.ni%type
     ,p_ci                        in componenti.ci%type
     ,p_denominazione             in componenti.denominazione%type
     ,p_old_dal                   in componenti.dal%type
     ,p_old_al                    in componenti.al%type
     ,p_new_al                    in componenti.al%type
     ,p_rowid                     in rowid
     ,p_inserting                 in number
     ,p_updating                  in number
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_al_ok
       DESCRIZIONE: Controllo is_al_ok
       PARAMETRI:   p_ottica
                    p_progr_unita_organizzativa
                    p_ni
                    p_ci
                    p_denominazione
                    p_old_dal
                    p_old_al
                    p_new_al
                    p_rowid
                    p_inserting
                    p_updating
       NOTE:        --
      ******************************************************************************/
      d_periodo afc_periodo.t_periodo;
      d_result  afc_error.t_error_number := afc_error.ok;
   begin
      if p_inserting = 1 and p_updating = 0 then
         d_periodo := afc_periodo.get_ultimo(p_tabella            => 'COMPONENTI'
                                            ,p_nome_dal           => 'DAL'
                                            ,p_nome_al            => 'AL'
                                            ,p_al                 => p_old_al
                                            ,p_campi_controllare  => '#OTTICA#PROGR_UNITA_ORGANIZZATIVA#NVL(NI,-1)#NVL(CI,-1)#NVL(DENOMINAZIONE,''*'')' || '#'
                                            ,p_valori_controllare => '#' || p_ottica || '#' ||
                                                                     p_progr_unita_organizzativa || '#' ||
                                                                     nvl(p_ni, -1) || '#' ||
                                                                     nvl(p_ci, -1) || '#' ||
                                                                     nvl(p_denominazione
                                                                        ,'*') || '#'
                                            ,p_rowid              => p_rowid);
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
         d_result := afc_periodo.is_ultimo(p_tabella            => 'COMPONENTI'
                                          ,p_nome_dal           => 'DAL'
                                          ,p_nome_al            => 'AL'
                                          ,p_dal                => p_old_dal
                                          ,p_al                 => p_old_al
                                          ,p_campi_controllare  => '#OTTICA#PROGR_UNITA_ORGANIZZATIVA#NVL(NI,-1)#NVL(CI,-1)#NVL(DENOMINAZIONE,''*'')' || '#'
                                          ,p_valori_controllare => '#' || p_ottica || '#' ||
                                                                   p_progr_unita_organizzativa || '#' ||
                                                                   nvl(p_ni, -1) || '#' ||
                                                                   nvl(p_ci, -1) || '#' ||
                                                                   nvl(p_denominazione
                                                                      ,'*') || '#');
         if not d_result = afc_error.ok then
            d_result := s_al_errato_number;
         end if;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on componente.is_al_ok');
      return d_result;
   end; -- componente.is_al_ok
   --------------------------------------------------------------------------------
   function is_componente_ok
   (
      p_ottica        in componenti.ottica%type
     ,p_ni            in componenti.ni%type
     ,p_ci            in componenti.ci%type
     ,p_denominazione in componenti.denominazione%type
     ,p_dal           in componenti.dal%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_componente_ok
       DESCRIZIONE: Controlla che il componente eliminato sia comunque
                    assegnato ad un'altra unita' organizzativa
       PARAMETRI:   p_ottica
                    p_ni
                    p_ci
                    p_denominazione
                    p_dal
       NOTE:        --
      ******************************************************************************/
      d_contatore number;
      d_result    afc_error.t_error_number := afc_error.ok;
   begin
      begin
         select count(*)
           into d_contatore
           from componenti
          where ottica = p_ottica
            and nvl(ni, -1) = nvl(p_ni, -1)
            and nvl(ci, -1) = nvl(p_ci, -1)
            and nvl(denominazione, '*') = nvl(p_denominazione, '*')
            and (nvl(al, to_date('3333333', 'j')) > nvl(p_dal, to_date('2222222', 'j')) and
                revisione_cessazione is null);
      exception
         when others then
            d_contatore := 0;
      end;
      if d_contatore = 0 then
         d_result := s_componente_non_ass_number;
      else
         d_result := afc_error.ok;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on componente.is_componente_ok');
      return d_result;
   end; -- componente.is_componente_ok
   --------------------------------------------------------------------------------
   function is_componente_modificabile
   (
      p_ottica        in componenti.ottica%type
     ,p_ni            in componenti.ni%type
     ,p_ci            in componenti.ci%type
     ,p_id_componente in componenti.id_componente%type
     ,p_dal           in componenti.dal%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_componente_modificabile
       DESCRIZIONE: Controlla che il componente modificato non abbia ruoli
                    applicativi
       NOTE:        --
      ******************************************************************************/
      d_contatore number;
      d_result    afc_error.t_error_number := afc_error.ok;
   begin
      begin
         select count(*)
           into d_contatore
           from ruoli_componente
          where id_componente = p_id_componente
            and dal <= nvl(al, to_date(3333333, 'j')); --#433
      exception
         when others then
            d_contatore := 0;
      end;
      if d_contatore > 0 then
         d_result := s_modifica_retroattiva_num;
      else
         d_result := afc_error.ok;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on componente.is_componente_modificabile');
      return d_result;
   end; -- componente.is_componente_modificabile
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
                    associato alla unita' organizzativa
       PARAMETRI:   p_ottica
                    p_progr_unita_organizzativa
                    p_ni
                    p_ci
                    p_dal
       NOTE:        --
      ******************************************************************************/
      --      d_contatore              number;
      --      d_revisione_mod          revisioni_struttura.revisione%type;
      --      d_revisione_assegnazione componenti.revisione_assegnazione%type := componente.get_revisione_assegnazione(p_id_componente);
      d_result afc_error.t_error_number := afc_error.ok;
   begin
      /*
      -- Il controllo viene ora eseguito su attributo_componente
      d_revisione_mod := revisione_struttura.get_revisione_mod(p_ottica);
      begin
         if d_revisione_assegnazione = d_revisione_mod or
            p_revisione_cessazione = d_revisione_mod then
            d_contatore := 0;
         else
            select count(*)
              into d_contatore
              from componenti
             where ottica = p_ottica
               and progr_unita_organizzativa = p_progr_unita_organizzativa
               and ni = p_ni
               and nvl(ci, -1) = nvl(p_ci, -1)
               and nvl(p_dal, to_date(2222222, 'j')) <= nvl(al, to_date(3333333, 'j'))
               and nvl(p_al, to_date(3333333, 'j')) >= nvl(dal, to_date(2222222, 'j'))
               and id_componente != nvl(p_id_componente, -1);
         end if;
      exception
         when others then
            d_contatore := 0;
      end;
      if d_contatore <> 0 then
         d_result := s_componente_gia_pres_number;
      else
         d_result := afc_error.ok;
      end if;*/
      d_result := afc_error.ok;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on componente.esiste_componente');
      return d_result;
   end; -- componente.esiste_componente
   --------------------------------------------------------------------------------
   function is_ri_ok
   (
      p_id_componente            in componenti.id_componente%type
     ,p_ottica                   in componenti.ottica%type
     ,p_ni                       in componenti.ni%type
     ,p_ci                       in componenti.ci%type
     ,p_denominazione            in componenti.denominazione%type
     ,p_old_progr_unor           in componenti.progr_unita_organizzativa%type
     ,p_new_progr_unor           in componenti.progr_unita_organizzativa%type
     ,p_old_dal                  in componenti.dal%type
     ,p_new_dal                  in componenti.dal%type
     ,p_old_al                   in componenti.al%type
     ,p_new_al                   in componenti.al%type
     ,p_old_revisione_cessazione in componenti.revisione_cessazione%type
     ,p_new_revisione_cessazione in componenti.revisione_cessazione%type
     ,p_rowid                    in rowid
     ,p_inserting                in number
     ,p_updating                 in number
     ,p_deleting                 in number
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_RI_ok.
       DESCRIZIONE: gestione della Referential Integrity:
                    - is_dal_ok
                    - is_al_ok
                    - is_componente_ok
                    - esiste_componente
       PARAMETRI:   p_id_componente
                    p_ottica
                    p_ni
                    p_ci
                    p_denominazione
                    p_old_progr_unor
                    p_new_progr_unor
                    p_old_dal
                    p_new_dal
                    p_old_al
                    p_new_al
                    p_old_revisione_cessazione
                    p_new_revisione_cessazione
                    p_rowid
                    p_inserting
                    p_updating
                    p_deleting
       RETURN:      1 se tutti i controlli danno esito positivo, l'error_code altrimenti
       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number := afc_error.ok;
   begin
      -- is_dal_ok
      if nvl(p_old_dal, to_date('3333333', 'j')) <>
         nvl(p_new_dal, to_date('3333333', 'j')) then
         d_result := is_dal_ok(p_ottica
                              ,p_ni
                              ,p_ci
                              ,p_denominazione
                              ,p_new_progr_unor
                              ,p_old_dal
                              ,p_new_dal
                              ,p_old_al
                              ,p_rowid
                              ,p_inserting
                              ,p_updating);
      end if;
      -- is_al_ok
      if (d_result = afc_error.ok) then
         if nvl(p_old_al, to_date('3333333', 'j')) <>
            nvl(p_new_al, to_date('3333333', 'j')) then
            d_result := is_al_ok(p_ottica
                                ,p_ni
                                ,p_ci
                                ,p_denominazione
                                ,p_new_progr_unor
                                ,p_old_dal
                                ,p_old_al
                                ,p_new_al
                                ,p_rowid
                                ,p_inserting
                                ,p_updating);
         end if;
      end if;
      if d_result = afc_error.ok then
         if p_updating = 1 and p_new_progr_unor != p_old_progr_unor and
            p_new_dal <= trunc(sysdate) and revisione_struttura.s_attivazione = 0 /* --#548 */
          then
            d_result := is_componente_modificabile(p_ottica
                                                  ,p_ni
                                                  ,p_ci
                                                  ,p_id_componente
                                                  ,p_new_dal);
         end if;
      end if;
      if d_result = afc_error.ok then
         if (p_inserting = 1 or (p_updating = 1 and p_new_progr_unor != p_old_progr_unor)) then
            d_result := esiste_componente(p_id_componente
                                         ,p_ottica
                                         ,p_new_progr_unor
                                         ,p_ni
                                         ,p_ci
                                         ,p_new_dal
                                         ,p_new_al
                                         ,p_new_revisione_cessazione);
         end if;
      end if;
      --
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on componente.is_RI_ok');
      return d_result;
   end; -- componente.is_RI_ok
   --------------------------------------------------------------------------------
   procedure chk_ri
   (
      p_id_componente            in componenti.id_componente%type
     ,p_ottica                   in componenti.ottica%type
     ,p_ni                       in componenti.ni%type
     ,p_ci                       in componenti.ci%type
     ,p_denominazione            in componenti.denominazione%type
     ,p_old_progr_unor           in componenti.progr_unita_organizzativa%type
     ,p_new_progr_unor           in componenti.progr_unita_organizzativa%type
     ,p_old_dal                  in componenti.dal%type
     ,p_new_dal                  in componenti.dal%type
     ,p_old_al                   in componenti.al%type
     ,p_new_al                   in componenti.al%type
     ,p_old_revisione_cessazione in componenti.revisione_cessazione%type
     ,p_new_revisione_cessazione in componenti.revisione_cessazione%type
     ,p_new_utente_aggiornamento in componenti.utente_aggiornamento%type
     ,p_rowid                    in rowid
     ,p_inserting                in number
     ,p_updating                 in number
     ,p_deleting                 in number
   ) is
      /******************************************************************************
       NOME:        chk_RI.
       DESCRIZIONE: gestione della Referential Integrity:
                    - is_dal_ok
                    - is_al_ok
                    - is_componente_ok
                    - esiste_componente
       PARAMETRI:   p_id_componente
                    p_ottica
                    p_ni
                    p_ci
                    p_denominazione
                    p_old_progr_unor
                    p_new_progr_unor
                    p_old_dal
                    p_new_dal
                    p_old_al
                    p_new_al
                    p_old_revisione_cessazione
                    p_new_revisione_cessazione
                    p_rowid
                    p_inserting
                    p_updating
                    p_deleting
       NOTE:        --
      ******************************************************************************/
      d_result        afc_error.t_error_number;
      d_revisione_mod componenti.revisione_assegnazione%type := revisione_struttura.get_revisione_mod(p_ottica);
      d_dummy         varchar2(1);
   begin
      d_result := is_ri_ok(p_id_componente
                          ,p_ottica
                          ,p_ni
                          ,p_ci
                          ,p_denominazione
                          ,p_old_progr_unor
                          ,p_new_progr_unor
                          ,p_old_dal
                          ,p_new_dal
                          ,p_old_al
                          ,p_new_al
                          ,p_old_revisione_cessazione
                          ,p_new_revisione_cessazione
                          ,p_rowid
                          ,p_inserting
                          ,p_updating
                          ,p_deleting);
      -- la UO deve essere valida per l'intero periodo del componente
      if d_result = afc_error.ok and p_deleting <> 1 and
         p_new_dal <= nvl(p_new_al, to_date(3333333, 'j')) then
         begin
            select 'x'
              into d_dummy
              from unita_organizzative u
             where u.progr_unita_organizzativa = p_new_progr_unor
               and u.ottica = p_ottica
               and exists
             (select 'x'
                      from unita_organizzative
                     where progr_unita_organizzativa = u.progr_unita_organizzativa
                       and ottica = u.ottica
                          --and u.revisione != revisione_struttura.get_revisione_mod(u.ottica)
                       and nvl(p_new_dal, nvl(dal, to_date(2222222, 'j'))) between
                           nvl(dal, to_date(2222222, 'j')) and
                           nvl(decode(revisione_cessazione
                                     ,d_revisione_mod
                                     ,to_date(null)
                                     ,al)
                              ,to_date(3333333, 'j')))
               and exists
             (select 'x'
                      from unita_organizzative
                     where progr_unita_organizzativa = u.progr_unita_organizzativa
                       and ottica = u.ottica
                          --and u.revisione != revisione_struttura.get_revisione_mod(u.ottica)
                       and nvl(p_new_al, to_date(3333333, 'j')) between
                           nvl(dal, to_date(2222222, 'j')) and
                           nvl(decode(revisione_cessazione
                                     ,d_revisione_mod
                                     ,to_date(null)
                                     ,al)
                              ,to_date(3333333, 'j')));
            raise too_many_rows;
         exception
            when too_many_rows then
               null;
            when no_data_found then
               d_result := s_uo_non_valida_num;
         end;
      end if;
      -- non e' ammesso riassegnare un individuo alla stessa UO in periodi sovrapposti
      -- viene concessa una eccezione per le registrazioni di provenienza GPS
      /*   Controllo spostato su ATTRIBUTO_COMPONENTE
            set_tipo_revisione(p_ottica, get_revisione_assegnazione(p_id_componente));
            if d_result = afc_error.ok and p_deleting <> 1 and
               p_new_utente_aggiornamento not like 'Aut.%' and s_tipo_revisione = 'N' then
               begin
                  select 'x'
                    into d_dummy
                    from componenti c
                   where c.progr_unita_organizzativa = p_new_progr_unor
                     and c.ottica = p_ottica
                     and c.id_componente <> p_id_componente
                     and c.ni = p_ni
                     and nvl(componente.get_revisione_assegnazione(p_id_componente), -2) <>
                         d_revisione_mod
                     and revisione_struttura.get_tipo_revisione(c.ottica
                                                               ,c.revisione_assegnazione) <> 'R'
                     and nvl(c.ci, -1) = nvl(p_ci, -1)
                     and nvl(c.dal, to_date(2222222, 'j')) <=
                         nvl(p_new_al, to_date(3333333, 'j'))
                     and nvl(c.al, to_date(3333333, 'j')) >=
                         nvl(p_new_dal, to_date(2222222, 'j'))
                        -- BUG#252 vanno esclusi i record con dal > al corrispondenti a record cessati logicamente
                     and c.dal < nvl(c.al, to_date(3333333, 'j'));
                  raise too_many_rows;
               exception
                  when no_data_found then
                     null;
                  when too_many_rows then
                     d_result := s_assegnazione_ripetuta_num;
               end;
            end if;
      */
      dbc.assertion(not dbc.assertionon or d_result = afc_error.ok or d_result < 0
                   ,'d_result = AFC_Error.ok or d_result < 0 on componente.chk_RI');
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, s_error_table(d_result));
      end if;
   end; -- componente.chk_RI
   --------------------------------------------------------------------------------
   procedure set_fi
   (
      p_id_componente              in componenti.id_componente%type
     ,p_new_ottica                 in componenti.ottica%type
     ,p_old_ottica                 in componenti.ottica%type
     ,p_old_revisione_assegnazione in componenti.revisione_assegnazione%type
     ,p_new_revisione_assegnazione in componenti.revisione_assegnazione%type
     ,p_old_revisione_cessazione   in componenti.revisione_cessazione%type
     ,p_new_revisione_cessazione   in componenti.revisione_cessazione%type
     ,p_ni                         in componenti.ni%type
     ,p_ci                         in componenti.ci%type
     ,p_new_progr_uo               in componenti.progr_unita_organizzativa%type
     ,p_old_progr_uo               in componenti.progr_unita_organizzativa%type
     ,p_denominazione              in componenti.denominazione%type
     ,p_old_dal                    in componenti.dal%type
     ,p_new_dal                    in componenti.dal%type
     ,p_old_al                     in componenti.al%type
     ,p_new_al                     in componenti.al%type
     ,p_old_dal_pubb               in componenti.dal_pubb%type
     ,p_new_dal_pubb               in componenti.dal_pubb%type
     ,p_old_al_pubb                in componenti.al_pubb%type
     ,p_new_al_pubb                in componenti.al_pubb%type
     ,p_old_al_prec                in componenti.al_prec%type
     ,p_new_al_prec                in componenti.al_prec%type
     ,p_data_aggiornamento         in componenti.data_aggiornamento%type
     ,p_utente_aggiornamento       in componenti.utente_aggiornamento%type
     ,p_inserting                  in number
     ,p_updating                   in number
     ,p_deleting                   in number
   ) is
      /******************************************************************************
       NOME:        set_FI.
       DESCRIZIONE: Impostazione functional integrity
                    - is_dal_ok
                    - is_al_ok
                    - is_componente_ok
                    - esiste_componente
       PARAMETRI:   p_id_componente
                    p_new_ottica
                    p_old_revisione_assegnazione
                    p_new_revisione_assegnazione
                    p_old_revisione_cessazione
                    p_new_revisione_cessazione
                    p_ni
                    p_denominazione
                    p_old_dal
                    p_new_dal
                    p_old_al
                    p_new_al
                    p_data_aggiornamento
                    p_utente_aggiornamento
                    p_inserting
                    p_updating
                    p_deleting
       NOTE:        --
      ******************************************************************************/
      d_result                     afc_error.t_error_number;
      d_utente                     ad4_utenti.utente%type;
      d_utente_agg                 ad4_utenti.utente%type;
      d_id_utente                  ad4_utenti.id_utente%type;
      d_nominativo                 ad4_utenti.nominativo%type;
      d_aggiornamento_componenti   ottiche.aggiornamento_componenti%type;
      d_operazione                 modifiche_componenti.operazione%type;
      d_id_modifica                modifiche_componenti.id_modifica%type;
      d_dummy                      varchar2(1);
      d_segnalazione_bloccante     varchar2(2) := 'N'; --#643
      d_segnalazione               varchar2(2000);
      d_segnalazione_bloccante_der varchar2(2);
      d_segnalazione_der           varchar2(2000);
      d_revisione_mod              componenti.revisione_assegnazione%type := revisione_struttura.get_revisione_mod(p_new_ottica);
      d_contatore                  number(8) := 0;
      d_integr_gp4                 impostazioni.integr_gp4%type := impostazione.get_integr_gp4(1);
      d_integr_gps                 boolean := so4gp_pkg.is_int_gps;
      d_tipo_assegnazione          attributi_componente.tipo_assegnazione%type := 'I';
      d_assegnazione_prevalente    attributi_componente.assegnazione_prevalente%type := '1';
      d_dal_verifica               date;
      d_storico_ruoli              number(1) := 0; --#499
      d_new_dal_pubb               componenti.dal_pubb%type := p_new_dal_pubb;
      d_new_al_pubb                componenti.al_pubb%type := p_new_al_pubb;
      d_obbligo_sefi               impostazioni.obbligo_sefi%type := impostazione.get_obbligo_sefi(1);
      d_id_ubicazione              ubicazioni_unita.id_ubicazione%type; --#648
      d_name                       varchar2(2000); --#772
      d_sender_email               varchar2(2000); --#772
      d_recipient                  varchar2(2000); --#772
      d_subject                    varchar2(2000); --#772
      d_text_msg                   varchar2(2000); --#772
      d_nominativo_soggetto        anagrafe_soggetti.denominazione%type; --#772
      d_descr_uo                   anagrafe_soggetti.denominazione%type; --#772
      d_next_date                  date; --#772
      d_job                        number; --#772
      d_statement                  varchar2(2000); --#772
   begin
      if p_inserting = 1 then
         if p_utente_aggiornamento like 'Aut.%' then
            d_utente_agg := 'SO4';
         else
            -- #27951 AD
            d_utente_agg := nvl(p_utente_aggiornamento, si4.utente);
         end if;
         if p_utente_aggiornamento not like 'Aut.%' then
            -- #543
            if ((d_integr_gp4 = 'SI' or d_integr_gps or
               nvl(registro_utility.leggi_stringa('PRODUCTS/SO4', 'IntegrazioneGPS', 0)
                    ,'NO') = 'SI') and
               so4gp_pkg.is_struttura_integrata('', p_new_ottica) = 'SI') then
               -- #429
               -- Contesto integrato con GPs
               if (componente.s_origine_gp = 0 and componente.s_spostamento = 0) or
                  p_ci is null then
                  --#550
                  -- La modifica NON ha origine da GPs; l'assegnazione può essere solo funzionale
                  d_tipo_assegnazione       := 'F';
                  d_assegnazione_prevalente := 88;
               end if;
            else
               -- Contesto NON integrato con GPs
               begin
                  if d_revisione_mod <> -1 and p_new_dal is null then
                     -- sono in revisione con dal nullo
                     d_dal_verifica := revisione_struttura.get_dal(p_new_ottica
                                                                  ,d_revisione_mod); -- uso il dal della revisione
                     if d_dal_verifica is null then
                        -- se il dal della revisione non è specificato prendo il giorno successivo alla data di decorrenza dell'ultima revisione
                        select dal + 1
                          into d_dal_verifica
                          from revisioni_struttura r1
                         where ottica = p_new_ottica
                           and dal = (select max(dal)
                                        from revisioni_struttura r2
                                       where r2.ottica = r1.ottica
                                         and stato = 'A');
                        /*else #34478
                        d_dal_verifica := p_new_dal;*/
                     end if;
                  else
                     d_dal_verifica := p_new_dal;
                  end if;
                  -- verifica la presenza di altre assegnazioni istituzionali per lo stesso NI  --#543
                  select count(*)
                    into d_contatore
                    from componenti c
                   where ni = p_ni
                     and ottica = p_new_ottica
                     and nvl(revisione_assegnazione, -2) <> d_revisione_mod
                     and id_componente <> p_id_componente
                     and c.dal <= nvl(p_new_al, to_date(3333333, 'j')) -- Bug#355
                     and nvl(c.al, to_date(3333333, 'j')) >= d_dal_verifica --
                     and c.dal <= nvl(c.al, to_date(3333333, 'j')) -- devo sempre e comunque escludere i periodi cessati logicamente
                     and exists (select 'x'
                            from attributi_componente
                           where id_componente = c.id_componente
                             and assegnazione_prevalente like '1%'
                             and tipo_assegnazione = 'I');
                  /* Se l'ottica è istituzionale, non ci sono altre assegnazioni prevalenti e
                     non siamo in revisione, carichiamo una assegnazione istituzionale prevalente,
                     altrimenti una assegnazione funzionale
                  */
                  if not (ottica.is_ottica_istituzionale(p_new_ottica) = 1 and --#34478
                      d_contatore = 0) then
                     d_tipo_assegnazione       := 'F';
                     d_assegnazione_prevalente := 88;
                  end if;
               exception
                  when no_data_found then
                     null;
               end;
            end if;
         end if;
         /* Se sto inserendo una nuova assegnazione su una unita' chiusa l'assegnazione può essere
            solo di tipo FUNZIONALE, inoltre se l'ottica su cui stiamo inserendo non è istituzionale
            vale il medesimo ragionamento
         */
         if attributo_componente.s_eccezione = 0 then
            --#440
            begin
               select 'x'
                 into d_dummy
                 from anagrafe_unita_organizzative a
                where p_new_progr_uo = progr_unita_organizzativa
                  and not exists
                (select 'x'
                         from anagrafe_unita_organizzative
                        where progr_unita_organizzativa = a.progr_unita_organizzativa
                          and nvl(al, to_date(3333333, 'j')) > trunc(sysdate));
               raise too_many_rows;
            exception
               when too_many_rows then
                  d_tipo_assegnazione       := 'F';
                  d_assegnazione_prevalente := 88;
                  d_new_dal_pubb            := p_new_dal;
                  d_new_al_pubb             := p_new_al;
               when no_data_found then
                  null;
            end;
         end if;
         if (d_tipo_assegnazione != 'F' and d_assegnazione_prevalente != 88) and
            ottica.get_ottica_istituzionale(p_new_ottica) = 'NO' then
            d_tipo_assegnazione       := 'F';
            d_assegnazione_prevalente := 88;
         end if;
         --
         -- Inserimento d'ufficio dell'attributo componente con valori di default
         --
         if p_utente_aggiornamento not like 'Aut.%' and
            p_utente_aggiornamento not like 'Ott.%' and
            p_utente_aggiornamento <> 'Dup.Rev' then
            attributo_componente.ins(p_id_attr_componente      => null
                                    ,p_id_componente           => p_id_componente
                                    ,p_dal                     => p_new_dal
                                    ,p_al                      => p_new_al
                                    ,p_incarico                => nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO'
                                                                                                    ,'Incarico Default'
                                                                                                    ,0)
                                                                     ,'ASS') -- valore predefinito
                                    ,p_dal_pubb                => d_new_dal_pubb
                                    ,p_al_pubb                 => d_new_al_pubb
                                    ,p_telefono                => ''
                                    ,p_fax                     => ''
                                    ,p_e_mail                  => ''
                                    ,p_assegnazione_prevalente => d_assegnazione_prevalente
                                    ,p_tipo_assegnazione       => d_tipo_assegnazione
                                    ,p_percentuale_impiego     => ''
                                    ,p_ottica                  => p_new_ottica
                                    ,p_revisione_assegnazione  => p_new_revisione_assegnazione
                                    ,p_revisione_cessazione    => p_new_revisione_cessazione
                                    ,p_utente_aggiornamento    => d_utente_agg
                                    ,p_data_aggiornamento      => p_data_aggiornamento);
         end if;
         -- #648
         -- Se l'unita' organizzativa e' associata ad una sola sede fisica, si inserisce
         -- l'ubicazione del componente
         --
         if d_tipo_assegnazione = 'I' and
            (d_assegnazione_prevalente like '1%' or d_assegnazione_prevalente = 99) then
            d_id_ubicazione := ubicazione_unita.get_ubicazione_unica(p_new_progr_uo
                                                                    ,p_new_dal);
            if d_id_ubicazione is not null then
               begin
                  ubicazione_componente.ins(p_id_ubicazione_componente => null
                                           ,p_id_componente            => p_id_componente
                                           ,p_id_ubicazione_unita      => d_id_ubicazione
                                           ,p_dal                      => p_new_dal
                                           ,p_al                       => p_new_al
                                           ,p_id_origine               => null
                                           ,p_utente_aggiornamento     => p_utente_aggiornamento
                                           ,p_data_aggiornamento       => p_data_aggiornamento);
               exception
                  when others then
                     d_segnalazione_bloccante := 'Y';
                     d_segnalazione           := 'Errore nell''attribuzione della sede fisica per la nuova assegnazione';
               end;
            else
               if d_obbligo_sefi = 'SI' then
                  d_segnalazione_bloccante := 'N';
                  d_segnalazione           := 'Indicare la sede fisica per la nuova assegnazione';
               end if;
            end if;
         end if;
         --
         -- Si si sta trattando un'ottica istituzionale, si verifica l'esistenza
         -- in AD4_Utenti dell'utente relativo al componente inserito:
         -- se non esiste, si inserisce
         --
         d_result := ottica.is_ottica_istituzionale(p_ottica => p_new_ottica);
         if d_result = afc_error.ok then
            d_utente := ad4_utente.get_utente(p_ni);
            if d_utente is null then
               begin
                  d_nominativo := determina_nominativo(p_ni);
               exception
                  when others then
                     dbms_output.put_line('Errore in determina nominativo');
               end;
               d_utente := determina_utente(p_ni);
               if d_nominativo is not null then
                  ad4_utente.ins(p_nominativo           => d_nominativo
                                ,p_utente               => d_utente
                                ,p_id_utente            => d_id_utente
                                ,p_utente_aggiornamento => d_utente_agg
                                ,p_soggetto             => p_ni);
               end if;
            end if;
         end if;
      elsif p_updating = 1 then
         s_modifica_componente := 1; --#430
         -- verifica se un componente cessato in revisione viene riaperto successivamente #499
         if p_old_revisione_cessazione = p_new_revisione_cessazione and
            p_new_revisione_cessazione <> d_revisione_mod and p_old_al is not null and
            p_new_al is null then
            --attiviamo la modalità di ripristino dei ruoli preesistenti
            d_storico_ruoli := 1;
         end if;
         --
         -- Se è stata aggiornata la revisione di cessazione e/o la data
         -- fine validità, si aggiornano l'ultimo attributo, l'ultima imputazione_bilancio,
         -- l'ultima ubicazione del componente e tutti i ruoli associati all' id. componente
         --
         if ((p_old_revisione_cessazione is null and
            p_new_revisione_cessazione is not null) or
            (nvl(p_old_al, to_date(3333333, 'j')) <>
            nvl(p_new_al, to_date(3333333, 'j')))) or
            (revisione_struttura.s_attivazione = 1 and
            revisione_struttura.s_revisione_in_attivazione = p_new_revisione_cessazione and
            revisione_struttura.s_ottica_in_attivazione = p_new_ottica) then
            attributo_componente.annulla_attributi(p_id_componente
                                                  ,p_new_revisione_cessazione
                                                  ,p_new_al
                                                  ,d_new_al_pubb
                                                  ,p_new_al_prec
                                                  ,p_data_aggiornamento
                                                  ,p_utente_aggiornamento
                                                  ,d_segnalazione_bloccante
                                                  ,d_segnalazione);
            if nvl(d_segnalazione_bloccante, 'N') = 'N' /*#643*/
               and ((nvl(p_old_al, to_date(3333333, 'j')) <>
                    nvl(p_new_al, to_date(3333333, 'j'))) or
                    (revisione_struttura.s_attivazione = 1 and revisione_struttura.s_revisione_in_attivazione =
                    p_new_revisione_cessazione and
                    revisione_struttura.s_ottica_in_attivazione = p_new_ottica)) then
               if d_storico_ruoli = 0 then
                  --#533
                  if revisione_struttura.s_attivazione = 1 and revisione_struttura.s_revisione_in_attivazione =
                     p_new_revisione_cessazione and
                     revisione_struttura.s_ottica_in_attivazione = p_new_ottica then
                     ruolo_componente.s_eliminazione_logica := 1;
                  end if;
                  --#499
                  ruolo_componente.s_gestione_profili   := 1;
                  ruolo_componente.s_ruoli_automatici   := 1;
                  componente.s_aggiorna_date_componente := 1; --#42480
                  ruolo_componente.annulla_ruoli(p_id_componente
                                                ,p_old_al
                                                ,p_new_al
                                                ,d_new_al_pubb
                                                ,p_new_al_prec
                                                ,p_data_aggiornamento
                                                ,p_utente_aggiornamento
                                                ,d_segnalazione_bloccante
                                                ,d_segnalazione);
                  ruolo_componente.s_gestione_profili   := 0;
                  ruolo_componente.s_ruoli_automatici   := 0;
                  componente.s_aggiorna_date_componente := 0; --#42480
                  --#533
                  if revisione_struttura.s_attivazione = 1 and revisione_struttura.s_revisione_in_attivazione =
                     p_new_revisione_cessazione and
                     revisione_struttura.s_ottica_in_attivazione = p_new_ottica then
                     ruolo_componente.s_eliminazione_logica := 0;
                  end if;
               end if;
               if nvl(d_segnalazione_bloccante, 'N') = 'N' then
                  --#643
                  imputazione_bilancio.annulla_imputazioni(p_id_componente
                                                          ,p_new_al
                                                          ,p_data_aggiornamento
                                                          ,p_utente_aggiornamento
                                                          ,d_segnalazione_bloccante
                                                          ,d_segnalazione);
               end if;
               if nvl(d_segnalazione_bloccante, 'N') = 'N' then
                  --#643
                  ubicazione_componente.annulla_ubicazioni(p_id_componente
                                                          ,p_new_al
                                                          ,p_data_aggiornamento
                                                          ,p_utente_aggiornamento
                                                          ,d_segnalazione_bloccante
                                                          ,d_segnalazione);
               end if;
            end if;
         end if;
         --
         -- Se è stata aggiornata la data inizio validità, si aggiornano il primo attributo,
         -- la prima imputazione bilancio e i ruoli associati all' id. componente
         --
         if nvl(d_segnalazione_bloccante, 'N') = 'N' /*#643*/
            and ((nvl(p_old_dal, to_date(3333333, 'j')) <>
                 nvl(p_new_dal, to_date(3333333, 'j'))) or
                 (revisione_struttura.s_attivazione = 1 and revisione_struttura.s_revisione_in_attivazione =
                 p_new_revisione_assegnazione and
                 revisione_struttura.s_ottica_in_attivazione = p_new_ottica)) then
            attributo_componente.aggiorna_attributi(p_id_componente
                                                   ,p_new_revisione_assegnazione
                                                   ,p_new_dal
                                                   ,d_new_dal_pubb
                                                   ,p_data_aggiornamento
                                                   ,p_utente_aggiornamento
                                                   ,d_segnalazione_bloccante
                                                   ,d_segnalazione);
            if nvl(d_segnalazione_bloccante, 'N') = 'N' then
               --#643
               ruolo_componente.s_gestione_profili   := 1;
               ruolo_componente.s_ruoli_automatici   := 1;
               componente.s_aggiorna_date_componente := 1; --#42480
               ruolo_componente.aggiorna_ruoli(p_id_componente
                                              ,p_new_dal
                                              ,d_new_dal_pubb
                                              ,p_data_aggiornamento
                                              ,p_utente_aggiornamento
                                              ,d_segnalazione_bloccante
                                              ,d_segnalazione);
               ruolo_componente.s_gestione_profili   := 0;
               ruolo_componente.s_ruoli_automatici   := 0;
               componente.s_aggiorna_date_componente := 0; --#42480
            end if;
            if nvl(d_segnalazione_bloccante, 'N') = 'N' then
               --#643
               imputazione_bilancio.aggiorna_imputazioni(p_id_componente
                                                        ,p_new_dal
                                                        ,p_data_aggiornamento
                                                        ,p_utente_aggiornamento
                                                        ,d_segnalazione_bloccante
                                                        ,d_segnalazione);
            end if;
            if nvl(d_segnalazione_bloccante, 'N') = 'N' then
               --#643
               ubicazione_componente.aggiorna_ubicazioni(p_id_componente
                                                        ,p_new_dal
                                                        ,p_data_aggiornamento
                                                        ,p_utente_aggiornamento
                                                        ,d_segnalazione_bloccante
                                                        ,d_segnalazione);
            end if;
         end if;
         --
         -- Se sono state annullate la revisione di cessazione e/o la data
         -- di fine validita', si ripristinano attributi, imputazioni bilancio
         -- e ruoli del componente
         --
         if nvl(d_segnalazione_bloccante, 'N') = 'N' --#643
            and ((p_old_revisione_cessazione is not null and
                 p_new_revisione_cessazione is null) or
                 (p_old_al is not null and p_new_al is null)) then
            if (p_old_revisione_cessazione is not null and
               p_new_revisione_cessazione is null) and
               (componente.s_tipo_ripristino = 1 or /*#641*/
               (p_old_al is not null and p_new_al is null)) then
               -- annulla sia l'al che la revisione di cessazione
               attributo_componente.ripristina_attributi(p_id_componente
                                                        ,p_old_revisione_cessazione
                                                        ,p_ni
                                                        ,p_denominazione
                                                        ,p_data_aggiornamento
                                                        ,p_utente_aggiornamento
                                                        ,1
                                                        ,d_segnalazione_bloccante
                                                        ,d_segnalazione);
            elsif nvl(d_segnalazione_bloccante, 'N') = 'N' --#643
                  and not (p_old_revisione_cessazione is not null and
                           p_new_revisione_cessazione is null) then
               -- annulla solo l'al
               attributo_componente.ripristina_attributi(p_id_componente
                                                        ,p_old_revisione_cessazione
                                                        ,p_ni
                                                        ,p_denominazione
                                                        ,p_data_aggiornamento
                                                        ,p_utente_aggiornamento
                                                        ,0
                                                        ,d_segnalazione_bloccante
                                                        ,d_segnalazione);
            end if;
            if nvl(d_segnalazione_bloccante, 'N') = 'N' then
               --#643
               ruolo_componente.s_gestione_profili   := 1;
               ruolo_componente.s_ruoli_automatici   := 1;
               componente.s_aggiorna_date_componente := 1; --#42480
               ruolo_componente.ripristina_ruoli(p_id_componente
                                                ,p_old_al
                                                ,d_storico_ruoli --#499
                                                ,p_data_aggiornamento
                                                ,p_utente_aggiornamento
                                                ,d_segnalazione_bloccante
                                                ,d_segnalazione);
               ruolo_componente.s_gestione_profili   := 0;
               ruolo_componente.s_ruoli_automatici   := 0;
               componente.s_aggiorna_date_componente := 0; --#42480
            end if;
            if nvl(d_segnalazione_bloccante, 'N') = 'N' then
               --#643
               imputazione_bilancio.ripristina_imputazioni(p_id_componente
                                                          ,p_data_aggiornamento
                                                          ,p_utente_aggiornamento
                                                          ,d_segnalazione_bloccante
                                                          ,d_segnalazione);
            end if;
            if nvl(d_segnalazione_bloccante, 'N') = 'N' then
               --#643
               ubicazione_componente.ripristina_ubicazioni(p_id_componente
                                                          ,p_data_aggiornamento
                                                          ,p_utente_aggiornamento
                                                          ,d_segnalazione_bloccante
                                                          ,d_segnalazione);
            end if;
         end if;
         s_modifica_componente               := 0; --#430
         ruolo_componente.s_gestione_profili := 0;
      elsif p_deleting = 1 then
         so4_pubblicazione_modifiche.s_ottica  := p_old_ottica;
         s_modifica_componente                 := 1; --#430
         ruolo_componente.s_gestione_profili   := 1;
         ruolo_componente.s_ruoli_automatici   := 1; --#634
         componente.s_aggiorna_date_componente := 1; --#42480
         delete ruoli_componente where id_componente = p_id_componente;
         ruolo_componente.s_ruoli_automatici   := 0;
         ruolo_componente.s_gestione_profili   := 0;
         componente.s_aggiorna_date_componente := 0; --#42480
         --  Delete all children in "ATTRIBUTI_COMPONENTE"
         delete attributi_componente where id_componente = p_id_componente;
         --  Delete all children in "UBICAZIONI_COMPONENTE"
         delete ubicazioni_componente where id_componente = p_id_componente;
         --  Delete all children in "IMPUTAZIONI_BILANCIO"
         delete imputazioni_bilancio where id_componente = p_id_componente;
         s_modifica_componente := 0; --#430
      end if;
      -- integrazione con rilevazione presenze la traccia
      if nvl(registro_utility.leggi_stringa('PRODUCTS/SO4', 'IntegrazioneLaTraccia', 0)
            ,'NO') = 'SI' and nvl(p_new_revisione_assegnazione, -2) <> d_revisione_mod and
         nvl(p_new_revisione_cessazione, -2) <> d_revisione_mod and
         nvl(d_segnalazione_bloccante, 'N') <> 'Y' /* #747 */
       then
         --#457
         declare
            d_statement afc.t_statement;
         begin
            d_statement := 'begin' || chr(10) || '   so4_latraccia.allinea_individuo(' || p_ni || ',' ||
                           afc.quote(p_new_ottica) || ');' || chr(10) || 'end;';
            afc.sql_execute(d_statement);
         exception
            when others then
               null;
         end;
      end if;
      -- gestione delle modifiche sulle ottiche derivate
      if nvl(registro_utility.leggi_stringa('PRODUCTS/SO4'
                                           ,'AggiornamentoAutomaticoAssegnazioniOtticheDerivate'
                                           ,0)
            ,'NO') = 'SI' and nvl(d_segnalazione_bloccante, 'N') = 'N' then
         --#208 #457
         -- verifica se esistono ottiche derivate da p_ottica
         d_dummy := 'N';
         select max('S') into d_dummy from ottiche where ottica_origine = p_new_ottica; --#208

         -- determina il tipo di operazione

         if p_inserting = 1 and p_new_revisione_assegnazione is null and d_dummy = 'S' then
            --#208
            begin
               select 'x'
                 into d_dummy
                 from componenti
                where ni = p_ni
                  and nvl(ci, -1) = nvl(p_ci, -1)
                  and ottica = p_new_ottica;
               raise too_many_rows;
            exception
               when no_data_found then
                  -- nuova assunzione
                  d_operazione := 'N';
               when too_many_rows then
                  -- esistono assegnazioni precedenti
                  begin
                     select 'x'
                       into d_dummy
                       from componenti
                      where ni = p_ni
                           --and nvl(ci, -1) = nvl(p_ci, -1)
                        and ottica = p_new_ottica
                        and al = p_new_dal - 1
                        and progr_unita_organizzativa <> p_new_progr_uo;
                     raise too_many_rows;
                  exception
                     when no_data_found then
                        -- nuova assegnazione con stacco
                        d_operazione := 'N';
                     when too_many_rows then
                        -- spostamento
                        d_operazione := 'S';
                  end;
            end;
         elsif p_updating = 1 and d_dummy = 'S' --#208
          then
            if nvl(p_new_al, to_date(3333333, 'j')) <
               nvl(p_old_al, to_date(3333333, 'j')) and p_new_progr_uo = p_old_progr_uo then
               -- cessazione o riduzione
               d_operazione := 'C';
            elsif nvl(p_new_al, to_date(3333333, 'j')) >
                  nvl(p_old_al, to_date(3333333, 'j')) and
                  p_new_progr_uo = p_old_progr_uo then
               -- prolungamento
               d_operazione := 'P';
            elsif p_new_progr_uo <> p_old_progr_uo and
                  nvl(p_new_al, to_date(3333333, 'j')) =
                  nvl(p_old_al, to_date(3333333, 'j')) and
                  nvl(p_new_dal, to_date(2222222, 'j')) =
                  nvl(p_old_dal, to_date(2222222, 'j')) then
               -- modifica dell'assegnazione
               d_operazione := 'U';
            elsif p_deleting = 1 then
               -- eliminazione del periodo
               d_operazione := 'E';
            end if;
         end if;
         -- registra su modifiche_componenti
         if d_operazione is not null then
            d_id_modifica := modifica_componente.get_id;
            modifica_componente.ins(p_id_modifica             => d_id_modifica
                                   ,p_ottica                  => p_new_ottica
                                   ,p_id_componente           => p_id_componente
                                   ,p_id_attributo_componente => ''
                                   ,p_operazione              => d_operazione);
            -- verifica il tipo di allineamento previsto per le eventuali ottiche derivate
            for ottiche_derivate in (select ottica
                                       from ottiche
                                      where ottica_origine =
                                            nvl(p_new_ottica, p_old_ottica))
            loop
               d_aggiornamento_componenti := ottica.get_aggiornamento_componenti(ottiche_derivate.ottica);
               if d_aggiornamento_componenti <> 'N' then
                  -- registra su operazioni_derivate
                  operazione_derivata.ins(p_id_modifica => d_id_modifica
                                         ,p_ottica      => ottiche_derivate.ottica
                                         ,p_esecuzione  => 0);
                  if d_aggiornamento_componenti = 'A' then
                     -- esegue immediatamente la modifica sull'ottica derivata
                     modifica_componente.aggiorna_ottica_derivata(d_id_modifica
                                                                 ,ottiche_derivate.ottica
                                                                 ,d_segnalazione_bloccante_der
                                                                 ,d_segnalazione_der
                                                                 ,1);
                  end if;
               end if;
            end loop;
         end if;
      end if;
      --
      if d_segnalazione_bloccante_der = 'Y' then
         --#208
         d_segnalazione := d_segnalazione || '; ' || d_segnalazione_der;
      end if;
      -- #634 Attribuzione automatica dei ruoli applicativi
      if nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO'
                                           ,'AttribuzioneAutomaticaRuoli'
                                           ,0)
            ,'NO') = 'SI'
        -- #766
         and p_new_dal <= nvl(p_new_al, to_date(3333333, 'j')) then
         if nvl(p_new_revisione_assegnazione, -2) <> d_revisione_mod and
            nvl(p_new_revisione_cessazione, -2) <> d_revisione_mod and
            nvl(d_segnalazione_bloccante, 'N') = 'N' and
            trunc(sysdate) <= nvl(p_new_al, to_date(3333333, 'j')) and p_inserting = 1 or
            (p_updating = 1 and (p_new_progr_uo <> p_old_progr_uo or p_ci is not null)) then
            attribuzione_ruoli(p_id_componente
                              ,p_new_dal
                              ,p_new_al
                              ,1
                              ,d_segnalazione_bloccante
                              ,d_segnalazione);
         end if;
      end if;
      -- #772 Notifica ai gestori dei ruoli; esegue un job che invia un messaggio differito
      if nvl(d_segnalazione_bloccante, 'N') = 'N' and componente.s_origine_gp = 1 and
         registro_utility.leggi_stringa('PRODUCTS/SI4SO'
                                       ,'IndirizziMailNotificaSpostamenti'
                                       ,0) is not null then

         -- determina i dati del soggetto
         begin
            select cognome || ' ' || nome
              into d_nominativo_soggetto
              from anagrafe_soggetti a
             where ni = p_ni;
         exception
            when others then
               d_nominativo_soggetto := 'non determinabile';
               d_descr_uo            := 'non determinabile';
         end;

         -- compone il messaggio della mail
         d_name         := registro_utility.leggi_stringa('PRODUCTS/SI4SO'
                                                         ,'NomeMessaggioNotificaSpostamento'
                                                         ,0);
         d_sender_email := registro_utility.leggi_stringa('PRODUCTS/SI4SO'
                                                         ,'MittenteMessaggioNotificaSpostamento'
                                                         ,0);
         d_recipient    := registro_utility.leggi_stringa('PRODUCTS/SI4SO'
                                                         ,'IndirizziMailNotificaSpostamenti'
                                                         ,0);
         d_subject      := registro_utility.leggi_stringa('PRODUCTS/SI4SO'
                                                         ,'TestoOggettoNotificaSpostamento'
                                                         ,0);
         d_text_msg     := registro_utility.leggi_stringa('PRODUCTS/SI4SO'
                                                         ,'TestoMessaggioNotificaSpostamento'
                                                         ,0);
         d_text_msg     := replace(d_text_msg, '<soggetto>', d_nominativo_soggetto);
         if p_inserting = 1 or
            ((p_updating = 1 and p_new_dal <= nvl(p_new_al, to_date(3333333, 'j'))) and
            p_new_progr_uo <> p_old_progr_uo) then
            d_descr_uo := anagrafe_unita_organizzativa.get_descrizione_corrente(p_new_progr_uo
                                                                               ,nvl(p_new_al
                                                                                   ,to_date(3333333
                                                                                           ,'j')));
            d_text_msg := replace(d_text_msg, '<UO>', d_descr_uo) || ' (attuale)';
         else
            d_descr_uo := anagrafe_unita_organizzativa.get_descrizione_corrente(p_old_progr_uo
                                                                               ,nvl(p_old_al
                                                                                   ,to_date(3333333
                                                                                           ,'j')));
            d_text_msg := replace(d_text_msg, '<UO>', d_descr_uo) || ' (precedente)';
         end if;

         -- creazione del job per la notifica mail differita
         /*         begin
                     so4_pkg.notifica_mail(p_name         => d_name
                                          ,p_sender_email => d_sender_email
                                          ,p_recipient    => d_recipient
                                          ,p_subject      => d_subject
                                          ,p_text_msg     => d_text_msg);

                  exception
                     when others then
                        null;
                  end;
         */
         begin
            select sysdate + (select (count(*) + 1) * 0.0001
                                from user_jobs
                               where what like '%so4_pkg.notifica_mail%'
                                 and broken = 'N')
              into d_next_date
              from dual;
            d_job := job_utility.crea('begin so4_pkg.notifica_mail(p_name =>''' || d_name ||
                                      ''',p_sender_email=>''' || d_sender_email ||
                                      ''',p_recipient=>''' || d_recipient ||
                                      ''',p_subject=>''' || d_subject ||
                                      ''',p_text_msg=>''' || d_text_msg ||
                                      ''');exception when others then null;end;'
                                     ,d_next_date);
         exception
            when no_data_found then
               null;
         end;

      end if;
      --
      -- #39939 Aggiornamento DDS
      if nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO'
                                           ,'AggiornaProfilazioneUtentiDDS'
                                           ,'')
            ,'NO') = 'SI' then
         /* determina amministrazione e l'utente da aggiornare su DDS */
         select nvl(d_utente, max(utente))
           into d_utente
           from ad4_utenti_soggetti
          where soggetto = p_ni;

         if (p_inserting = 1 and d_utente is not null) or
            (p_updating = 1 and d_utente is not null and nvl(p_new_al, to_date(3333333, 'j')) >= trunc(sysdate)) then
            /* aggiorna il componente su DDS_MEMBERS e DDS_USERS */
            dds_util.set_user(d_utente, 0);
            dds_util.set_member(d_utente, ottica.get_amministrazione(p_new_ottica));
         elsif p_deleting = 1 or
               (p_updating = 1 and nvl(p_new_al, to_date(3333333, 'j')) <= trunc(sysdate)) then
            dds_util.set_user(d_utente, 0);
            dds_util.set_member(d_utente, ottica.get_amministrazione(p_old_ottica));
         end if;
      end if;
      --
      if d_segnalazione_bloccante = 'Y' then
         --#457
         s_segnalazione := d_segnalazione;
         raise_application_error(s_err_set_fi_num, d_segnalazione);
      end if;
   end; -- componente.set_fi
   --------------------------------------------------------------------------------
   function is_componenti_revisione_ok
   (
      p_ottica         in componenti.ottica%type
     ,p_revisione      in componenti.revisione_assegnazione%type
     ,p_data           in componenti.dal%type
     ,p_tipo_controllo in number default 0
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_componenti_revisione_ok
       DESCRIZIONE: Controlla che non esistano componenti assegnati o cessati con la
                    revisione indicata aventi data inizio o fine validità non congruente
                    con la data della revisione
       PARAMETRI:   Ottica
                    Revisione
                    Data revisione
                    Tipo controllo: se = 0 si controllano i componenti assegnati, se = 1
                                    si controllano i componenti cessati
       RITORNA:     AFC_ERROR
      ******************************************************************************/
      d_result       afc_error.t_error_number;
      d_conta_record number;
   begin
      select count(*)
        into d_conta_record
        from componenti
       where ottica = p_ottica
         and ((p_tipo_controllo = 0 and revisione_assegnazione = p_revisione and
             nvl(dal, p_data) < p_data) or
             (p_tipo_controllo = 1 and revisione_cessazione = p_revisione and
             nvl(al, p_data - 1) != p_data - 1));
      if d_conta_record > 0 then
         if p_tipo_controllo = 0 then
            d_result := s_componenti_istituiti_number;
         else
            d_result := s_componenti_cessati_number;
         end if;
      else
         d_result := afc_error.ok;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on Unita_organizzativa.is_componenti_revisione_ok');
      return d_result;
   end; -- componenti.is_componenti_revisione_ok
   --------------------------------------------------------------------------------
   procedure backup_componente(p_id_componente in componenti.id_componente%type) is
      /******************************************************************************
       NOME:        backup_componente
       DESCRIZIONE: Backup dei dati del componente nel caso in cui si aggiorni
                    direttamente il progr. dell'unita' organizzativa
       PARAMETRI:   p_id_componente          componenti.id_componente%type
      ******************************************************************************/
      d_messaggio varchar2(200);
   begin
      d_messaggio := 'Tabella COMPONENTI';
      insert into dup_comp
         (id_componente
         ,progr_unita_organizzativa
         ,dal
         ,al
         ,ni
         ,ci
         ,denominazione
         ,denominazione_al1
         ,denominazione_al2
         ,stato
         ,ottica
         ,revisione_assegnazione
         ,revisione_cessazione
         ,utente_aggiornamento
         ,data_aggiornamento
         ,codice_fiscale)
         select id_componente
               ,progr_unita_organizzativa
               ,dal
               ,al
               ,ni
               ,ci
               ,denominazione
               ,denominazione_al1
               ,denominazione_al2
               ,stato
               ,ottica
               ,revisione_assegnazione
               ,revisione_cessazione
               ,utente_aggiornamento
               ,data_aggiornamento
               ,codice_fiscale
           from componenti
          where id_componente = p_id_componente;
      --
      d_messaggio := 'Tabella ATTRIBUTI_COMPONENTE';
      insert into dup_atco
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
         ,voto)
         select id_attr_componente
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
           from attributi_componente
          where id_componente = p_id_componente;
      --
      d_messaggio := 'Tabella RUOLI_COMPONENTE';
      insert into dup_ruco
         (id_ruolo_componente
         ,id_componente
         ,ruolo
         ,dal
         ,al
         ,utente_aggiornamento
         ,data_aggiornamento)
         select id_ruolo_componente
               ,id_componente
               ,ruolo
               ,dal
               ,al
               ,utente_aggiornamento
               ,data_aggiornamento
           from ruoli_componente
          where id_componente = p_id_componente;
      --
      d_messaggio := 'Tabella UBICAZIONI_COMPONENTE';
      insert into dup_ubco
         (id_ubicazione_componente
         ,id_componente
         ,id_ubicazione_unita
         ,dal
         ,al
         ,id_origine
         ,utente_aggiornamento
         ,data_aggiornamento)
         select id_ubicazione_componente
               ,id_componente
               ,id_ubicazione_unita
               ,dal
               ,al
               ,id_origine
               ,utente_aggiornamento
               ,data_aggiornamento
           from ubicazioni_componente
          where id_componente = p_id_componente;
      --
      d_messaggio := 'Tabella IMPUTAZIONI_BILANCIO';
      insert into dup_imbi
         (id_imputazione
         ,id_componente
         ,numero
         ,dal
         ,al
         ,utente_agg
         ,data_agg)
         select id_imputazione
               ,id_componente
               ,numero
               ,dal
               ,al
               ,utente_agg
               ,data_agg
           from imputazioni_bilancio
          where id_componente = p_id_componente;
   exception
      when others then
         raise_application_error(-20999, d_messaggio || ' - ' || sqlerrm);
   end; -- componenti.backup_componente
   --------------------------------------------------------------------------------
   procedure recupera_componente(p_id_componente in componenti.id_componente%type) is
      /******************************************************************************
       NOME:        recupera_componente
       DESCRIZIONE: Recupero dei dati del componente nel caso in cui si sia aggiornato
                    direttamente il progr. dell'unita' organizzativa
                    Eliminazione dei dati backupati.
       PARAMETRI:   p_id_componente          componenti.id_componente%type
      ******************************************************************************/
      d_messaggio varchar2(200);
   begin
      d_messaggio := 'Tabella COMPONENTI';
      insert into componenti
         (id_componente
         ,progr_unita_organizzativa
         ,dal
         ,al
         ,ni
         ,ci
         ,denominazione
         ,denominazione_al1
         ,denominazione_al2
         ,stato
         ,ottica
         ,revisione_assegnazione
         ,revisione_cessazione
         ,utente_aggiornamento
         ,data_aggiornamento
         ,codice_fiscale)
         select id_componente
               ,progr_unita_organizzativa
               ,dal
               ,al
               ,ni
               ,ci
               ,denominazione
               ,denominazione_al1
               ,denominazione_al2
               ,stato
               ,ottica
               ,revisione_assegnazione
               ,revisione_cessazione
               ,utente_aggiornamento
               ,data_aggiornamento
               ,codice_fiscale
           from dup_comp
          where id_componente = p_id_componente;
      --
      d_messaggio := 'Tabella ATTRIBUTI_COMPONENTE';
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
         ,voto)
         select id_attr_componente
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
           from dup_atco
          where id_componente = p_id_componente;
      --
      d_messaggio := 'Tabella RUOLI_COMPONENTE';
      insert into ruoli_componente
         (id_ruolo_componente
         ,id_componente
         ,ruolo
         ,dal
         ,al
         ,utente_aggiornamento
         ,data_aggiornamento)
         select id_ruolo_componente
               ,id_componente
               ,ruolo
               ,dal
               ,al
               ,utente_aggiornamento
               ,data_aggiornamento
           from dup_ruco
          where id_componente = p_id_componente;
      --
      d_messaggio := 'Tabella UBICAZIONI_COMPONENTE';
      insert into ubicazioni_componente
         (id_ubicazione_componente
         ,id_componente
         ,id_ubicazione_unita
         ,dal
         ,al
         ,id_origine
         ,utente_aggiornamento
         ,data_aggiornamento)
         select id_ubicazione_componente
               ,id_componente
               ,id_ubicazione_unita
               ,dal
               ,al
               ,id_origine
               ,utente_aggiornamento
               ,data_aggiornamento
           from dup_ubco
          where id_componente = p_id_componente;
      --
      d_messaggio := 'Tabella IMPUTAZIONI_BILANCIO';
      insert into imputazioni_bilancio
         (id_imputazione
         ,id_componente
         ,numero
         ,dal
         ,al
         ,utente_agg
         ,data_agg)
         select id_imputazione
               ,id_componente
               ,numero
               ,dal
               ,al
               ,utente_agg
               ,data_agg
           from imputazioni_bilancio
          where id_componente = p_id_componente;
      --
      delete from dup_imbi where id_componente = p_id_componente;
      delete from dup_ubco where id_componente = p_id_componente;
      delete from dup_ruco where id_componente = p_id_componente;
      delete from dup_atco where id_componente = p_id_componente;
      delete from dup_comp where id_componente = p_id_componente;
   exception
      when others then
         raise_application_error(-20999, d_messaggio || ' - ' || sqlerrm);
   end; -- componenti.recupera_componente
   --------------------------------------------------------------------------------
   procedure inserisci_componente
   (
      p_id_componente             in componenti.id_componente%type default null
     ,p_progr_unita_organizzativa in componenti.progr_unita_organizzativa%type
     ,p_dal                       in componenti.dal%type
     ,p_al                        in componenti.al%type default null
     ,p_ni                        in componenti.ni%type default null
     ,p_ci                        in componenti.ci%type default null
     ,p_codice_fiscale            in componenti.codice_fiscale%type default null
     ,p_denominazione             in componenti.denominazione%type default null
     ,p_denominazione_al1         in componenti.denominazione_al1%type default null
     ,p_denominazione_al2         in componenti.denominazione_al2%type default null
     ,p_stato                     in componenti.stato%type default null
     ,p_ottica                    in componenti.ottica%type default null
     ,p_revisione_assegnazione    in componenti.revisione_assegnazione%type default null
     ,p_revisione_cessazione      in componenti.revisione_cessazione%type default null
     ,p_incarico                  in attributi_componente.incarico%type default null
     ,p_telefono                  in attributi_componente.telefono%type default null
     ,p_fax                       in attributi_componente.fax%type default null
     ,p_e_mail                    in attributi_componente.e_mail%type default null
     ,p_assegnazione_prevalente   in attributi_componente.assegnazione_prevalente%type default null
     ,p_percentuale_impiego       in attributi_componente.percentuale_impiego%type default null
     ,p_utente_aggiornamento      in componenti.utente_aggiornamento%type default null
     ,p_data_aggiornamento        in componenti.data_aggiornamento%type default null
     ,p_dal_pubb                  in componenti.dal_pubb%type
     ,p_al_pubb                   in componenti.al_pubb%type default null
   ) is
      /******************************************************************************
       NOME:        inserisci_componente
       DESCRIZIONE: Inserimento di una riga di COMPONENTI con chiave e attributi
                    indicati + inserimento di una riga di ATTRIBUTI_COMPONENTE
       PARAMETRI:   Chiavi e attributi della table.
      ******************************************************************************/
      d_result      afc_error.t_error_number := afc_error.ok;
      d_integr_gp4  impostazioni.integr_gp4%type;
      d_ni_gp4      componenti.ni%type;
      d_imputazione number;
   begin
      d_integr_gp4 := impostazione.get_integr_gp4(1);
      d_result     := is_di_ok(p_dal
                              ,p_al
                              ,p_revisione_assegnazione
                              ,p_revisione_cessazione);
      --
      if d_result = afc_error.ok then
         d_result := is_ri_ok(p_id_componente            => p_id_componente
                             ,p_ottica                   => p_ottica
                             ,p_ni                       => p_ni
                             ,p_ci                       => p_ci
                             ,p_denominazione            => p_denominazione
                             ,p_old_progr_unor           => null
                             ,p_new_progr_unor           => p_progr_unita_organizzativa
                             ,p_old_dal                  => null
                             ,p_new_dal                  => p_dal
                             ,p_old_al                   => null
                             ,p_new_al                   => p_al
                             ,p_old_revisione_cessazione => null
                             ,p_new_revisione_cessazione => p_revisione_cessazione
                             ,p_rowid                    => null
                             ,p_inserting                => 1
                             ,p_updating                 => 0
                             ,p_deleting                 => 0);
      end if;
      --
      if d_result = afc_error.ok then
         componente.ins(p_id_componente             => p_id_componente
                       ,p_progr_unita_organizzativa => p_progr_unita_organizzativa
                       ,p_dal                       => p_dal
                       ,p_al                        => p_al
                       ,p_ni                        => p_ni
                       ,p_ci                        => p_ci
                       ,p_codice_fiscale            => p_codice_fiscale
                       ,p_denominazione             => p_denominazione
                       ,p_denominazione_al1         => p_denominazione_al1
                       ,p_denominazione_al2         => p_denominazione_al2
                       ,p_stato                     => p_stato
                       ,p_ottica                    => p_ottica
                       ,p_revisione_assegnazione    => p_revisione_assegnazione
                       ,p_revisione_cessazione      => p_revisione_cessazione
                       ,p_utente_aggiornamento      => p_utente_aggiornamento
                       ,p_data_aggiornamento        => p_data_aggiornamento);
         attributo_componente.ins(p_id_attr_componente      => null
                                 ,p_id_componente           => p_id_componente
                                 ,p_dal                     => p_dal
                                 ,p_al                      => p_al
                                 ,p_incarico                => p_incarico
                                 ,p_telefono                => p_telefono
                                 ,p_fax                     => p_fax
                                 ,p_e_mail                  => p_e_mail
                                 ,p_assegnazione_prevalente => p_assegnazione_prevalente
                                 ,p_percentuale_impiego     => p_percentuale_impiego
                                 ,p_ottica                  => p_ottica
                                 ,p_revisione_assegnazione  => p_revisione_assegnazione
                                 ,p_revisione_cessazione    => p_revisione_cessazione
                                 ,p_utente_aggiornamento    => p_utente_aggiornamento
                                 ,p_data_aggiornamento      => p_data_aggiornamento);
         --
         -- Se l'unita' organizzativa e' associata ad una sola sede fisica, si inserisce
         -- l'ubicazione del componente
         -- #648: spostato in set_fi per tutte le operazioni di insert di assegnazioni istituzionali
         --

         --
         -- In presenza di integrazione con GP4, se all'unita' organizzativa e' associata
         -- un'unica sede contabile, si inserisce la tabella IMPUTAZIONI_BILANCIO
         --
         if nvl(d_integr_gp4, 'NO') = 'SI' then
            d_ni_gp4 := so4gp_pkg.get_ni_unor(p_progr_unita_organizzativa);
            if d_ni_gp4 is not null then
               --#594
               if so4gp_pkg.is_int_gps then
                  -- se sono integrato con gps passo id_componente
                  d_ni_gp4 := p_id_componente;
               end if;
               d_imputazione := so4gp_pkg.get_sede_unica(d_ni_gp4);
               if d_imputazione >= 0 then
                  imputazione_bilancio.ins(p_id_imputazione => null
                                          ,p_id_componente  => p_id_componente
                                          ,p_numero         => d_imputazione
                                          ,p_dal            => p_dal
                                          ,p_al             => p_al
                                          ,p_utente_agg     => p_utente_aggiornamento
                                          ,p_data_agg       => p_data_aggiornamento);
               end if;
            end if;
         end if;
      end if;
   end; -- componente.inserisci_componente
   --------------------------------------------------------------------------------
   procedure elimina_componente
   (
      p_id_componente          in componenti.id_componente%type
     ,p_revisione_cessazione   in componenti.revisione_cessazione%type
     ,p_al                     in componenti.al%type
     ,p_data_aggiornamento     in componenti.data_aggiornamento%type
     ,p_utente_aggiornamento   in componenti.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        elimina_componente
       DESCRIZIONE: Elimina il componente dalla U.O.
       PARAMETRI:   p_id_componente
                    p_revisione_cessazione
                    p_al
                    p_data_aggiornamento
                    p_utente_aggiornamento
                    p_segnalazione_bloccante
                    p_segnalazione
       NOTE:        --
      ******************************************************************************/
      d_revisione     componenti.revisione_assegnazione%type;
      d_ni            componenti.ni%type;
      d_denominazione componenti.denominazione%type;
      d_cognome_nome  as4_anagrafe_soggetti.denominazione%type;
      d_errore exception;
   begin
      begin
         select ni
               ,denominazione
               ,revisione_assegnazione
           into d_ni
               ,d_denominazione
               ,d_revisione
           from componenti
          where id_componente = p_id_componente;
      exception
         when others then
            if sqlcode between - 20999 and - 20900 then
               p_segnalazione := s_error_table(sqlcode);
            else
               p_segnalazione := sqlerrm;
            end if;
            raise d_errore;
      end;
      --
      if d_ni is not null then
         d_cognome_nome := soggetti_get_descr(p_soggetto_ni  => d_ni
                                             ,p_soggetto_dal => trunc(sysdate)
                                             ,p_colonna      => 'COGNOME E NOME');
      end if;
      --
      -- Se l'ottica non è gestita a revisioni oppure il componente è
      -- stato inserito con la revisione in corso di modifica oppure
      -- se si tratta di un componente spostato senza revisione, si
      -- elimina direttamente il record con tutti i suoi attributi
      --
      if p_revisione_cessazione is null or d_revisione = p_revisione_cessazione then
         begin
            del(p_id_componente);
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
         -- Se l'ottica è gestita a revisioni, si aggiorna il campo
         -- revisione_cessazione
         --
         begin
            update componenti
               set revisione_cessazione = p_revisione_cessazione
                   -- ,al                   = p_al  --#500
                  ,al_prec              = al --#533
                  ,data_aggiornamento   = p_data_aggiornamento
                  ,utente_aggiornamento = p_utente_aggiornamento
             where id_componente = p_id_componente;
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
         p_segnalazione           := 'Componente: ' ||
                                     nvl(d_denominazione, d_cognome_nome) || ' - ' ||
                                     p_segnalazione;
   end; -- componente.elimina_componente
   --------------------------------------------------------------------------------
   function verifica_ereditarieta
   (
      p_stringa_sudd registro.valore%type
     ,p_ottica       ottiche.ottica%type
     ,p_revisione    revisioni_struttura.revisione%type
     ,p_data         componenti.dal%type
     ,p_unita_orig   anagrafe_unita_organizzative.progr_unita_organizzativa%type
     ,p_unita_dest   anagrafe_unita_organizzative.progr_unita_organizzativa%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        verifica_ereditarieta
       DESCRIZIONE: Richiamata da sposta_componente: verifica se lo spostamento prevede
                    di ereditare i ruoli dall'assegnazione precedente
       PARAMETRI:   p_stringa_sudd   Stringa contenente l'elenco delle suddivisioni da
                                     trattare
                    p_ottica         Ottica di riferimento
                    p_data           Data di riferimento
                    p_unita_orig     Progr. unita' di provenienza
                    p_unita_dest     Progr. unita' di destinazione
       NOTE:        --
      ******************************************************************************/
      d_result          afc_error.t_error_number := 0;
      d_data_rev        revisioni_struttura.dal%type;
      d_data            date;
      d_num_elementi    number(4);
      d_inizio          number(4);
      d_lunghezza       number(4);
      d_id_suddivisione suddivisioni_struttura.id_suddivisione%type;
      d_radice          anagrafe_unita_organizzative.progr_unita_organizzativa%type;
      d_unita           anagrafe_unita_organizzative.progr_unita_organizzativa%type;
   begin
      --
      -- Se la data passata come parametro e' nulla, si determina la data di riferimento
      --
      if p_data is null then
         if p_revisione is null then
            d_data := trunc(sysdate);
         else
            d_data_rev := revisione_struttura.get_dal(p_ottica, p_revisione);
            d_data     := nvl(d_data_rev, trunc(sysdate));
         end if;
      else
         d_data := p_data;
      end if;
      --
      -- Per ogni suddivisione indicata nella tabella registro si verifica
      -- se l'unita' di provenienza ha un ascendente di quel tipo
      --
      d_num_elementi := afc.countoccurrenceof(p_stringa_sudd, ',');
      d_inizio       := 1;
      for d_indice in 1 .. d_num_elementi
      loop
         --#664
         d_lunghezza       := (instr(p_stringa_sudd, ',', 1, d_indice) - 1) - d_inizio + 1;
         d_id_suddivisione := substr(p_stringa_sudd, d_inizio, d_lunghezza);
         d_inizio          := d_inizio + d_lunghezza + 1; --
         -- Si ricerca tra gli ascendenti dell'unita' di provenienza un'unita' con
         -- suddivisione tra quelle indicate nella tabella registro
         --
         select /*+ first_rows */
          min(progr_unita_organizzativa)
           into d_radice
           from unita_organizzative
          where ottica = p_ottica
            and d_data between nvl(dal, d_data) and nvl(al, s_data_limite)
            and anagrafe_unita_organizzativa.get_id_suddivisione_corrente(progr_unita_organizzativa
                                                                         ,d_data) =
                d_id_suddivisione
         connect by prior id_unita_padre = progr_unita_organizzativa
                and ottica = p_ottica
                and d_data between nvl(dal, d_data) and nvl(al, s_data_limite)
          start with ottica = p_ottica
                 and progr_unita_organizzativa = p_unita_orig
                 and d_data between nvl(dal, d_data) and nvl(al, s_data_limite);
         --
         -- Se l'unita' viene trovata, si ricerca tra i discendenti di tale unita' per
         -- verificare se tra questi c'e' l'unita' di destinazione (in tal caso i ruoli
         -- possono essere ereditati)
         --
         if d_radice is not null then
            begin
               select /*+ first_rows */
                progr_unita_organizzativa
                 into d_unita
                 from unita_organizzative
                where ottica = p_ottica
                  and d_data between nvl(dal, d_data) and nvl(al, s_data_limite)
                  and progr_unita_organizzativa = p_unita_dest
               connect by prior progr_unita_organizzativa = id_unita_padre
                      and ottica = p_ottica
                      and d_data between nvl(dal, d_data) and nvl(al, s_data_limite)
                start with ottica = p_ottica
                       and progr_unita_organizzativa = d_radice
                       and d_data between nvl(dal, d_data) and nvl(al, s_data_limite);
            exception
               when no_data_found then
                  d_unita := to_number(null);
               when too_many_rows then
                  d_unita := to_number(null);
            end;
         else
            d_unita := to_number(null);
         end if;
         if d_unita is not null then
            d_result := afc_error.ok;
            exit;
         end if;
      end loop;
      --
      return d_result;
      --
   end; -- verifica_ereditarieta
   --------------------------------------------------------------------------------
   procedure sposta_componente
   (
      p_id_componente          in componenti.id_componente%type
     ,p_unita_org_dest         in componenti.progr_unita_organizzativa%type
     ,p_ottica                 in componenti.ottica%type
     ,p_revisione              in componenti.revisione_assegnazione%type default null
     ,p_dal                    in componenti.dal%type
     ,p_al                     in componenti.al%type
     ,p_data_aggiornamento     in componenti.data_aggiornamento%type
     ,p_utente_aggiornamento   in componenti.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        sposta_componente
       DESCRIZIONE: Sposta il componente nell'u.o. di destinazione
       PARAMETRI:   p_id_componente
                    p_unita_org_dest
                    p_ottica
                    p_revisione
                    p_al
                    p_data_aggiornamento
                    p_utente_aggiornamento
                    p_segnalazione_bloccante
                    p_segnalazione
       NOTE:        --
      ******************************************************************************/
      d_integr_gp4                  impostazioni.integr_gp4%type;
      d_obbligo_sefi                impostazioni.obbligo_sefi%type;
      d_obbligo_imbi                impostazioni.obbligo_imbi%type;
      d_eredita_ruoli               varchar2(1);
      d_progr_unor                  componenti.progr_unita_organizzativa%type;
      d_ni                          componenti.ni%type;
      d_ci                          componenti.ci%type;
      d_denominazione               componenti.denominazione%type;
      d_denominazione_al1           componenti.denominazione_al1%type;
      d_denominazione_al2           componenti.denominazione_al2%type;
      d_codice_fiscale              componenti.codice_fiscale%type;
      d_dal                         componenti.dal%type;
      d_new_dal                     componenti.dal%type;
      d_al                          componenti.al%type;
      d_wrk_al                      componenti.al%type;
      d_al_unor                     unita_organizzative.al%type;
      d_assegnazione_prevalente     attributi_componente.assegnazione_prevalente%type;
      d_assegnazione_prevalente_gps attributi_componente.assegnazione_prevalente%type;
      d_tipo_assegnazione           attributi_componente.tipo_assegnazione%type;
      d_stato                       componenti.stato%type;
      d_revisione                   componenti.revisione_assegnazione%type;
      d_revisione_cessazione        componenti.revisione_cessazione%type;
      d_revisione_modifica          componenti.revisione_cessazione%type := revisione_struttura.get_revisione_mod(p_ottica);
      d_data_revisione              revisioni_struttura.dal%type := so4_pkg.get_data_riferimento(p_ottica);
      d_id_componente               componenti.id_componente%type;
      d_new_id_componente           componenti.id_componente%type;
      d_cognome_nome                as4_anagrafe_soggetti.denominazione%type;
      d_ni_gp4                      componenti.ni%type;
      d_numero                      imputazioni_bilancio.numero%type;
      d_ottica_gest_rev             ottiche.gestione_revisioni%type;
      d_messaggio                   varchar2(100);
      d_stringa_sudd                registro.valore%type;
      d_area_orig                   componenti.progr_unita_organizzativa%type;
      d_area_dest                   componenti.progr_unita_organizzativa%type;
      d_contatore                   number;
      d_eredita_ruoli_globale       registro.valore%type := nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO'
                                                                                              ,'EreditaRuoli'
                                                                                              ,0)
                                                               ,'NO'); --#713
      d_id_ruco                     ruoli_componente.id_ruolo_componente%type;
      d_errore exception;
   begin
      componente.s_spostamento := 1; --#550
      --
      -- Si memorizza il parametro di integrazione con GP4
      --
      begin
         d_integr_gp4   := impostazione.get_integr_gp4(1);
         d_obbligo_sefi := impostazione.get_obbligo_sefi(1);
         d_obbligo_imbi := impostazione.get_obbligo_imbi(1);
         d_stringa_sudd := registro_utility.leggi_stringa('PRODUCTS/SI4SO/' || p_ottica
                                                         ,'Ereditarieta ruoli'
                                                         ,0);
      exception
         when others then
            if sqlcode between - 20999 and - 20900 then
               p_segnalazione := s_error_table(sqlcode);
            else
               p_segnalazione := sqlerrm;
            end if;
            raise d_errore;
      end;
      --
      -- Si selezionano i dati del componente da spostare
      --
      begin
         select progr_unita_organizzativa
               ,ni
               ,ci
               ,denominazione
               ,denominazione_al1
               ,denominazione_al2
               ,codice_fiscale
               ,c.revisione_assegnazione
               ,c.revisione_cessazione
               ,c.dal
               ,c.al
               ,tipo_assegnazione
               ,assegnazione_prevalente
           into d_progr_unor
               ,d_ni
               ,d_ci
               ,d_denominazione
               ,d_denominazione_al1
               ,d_denominazione_al2
               ,d_codice_fiscale
               ,d_revisione
               ,d_revisione_cessazione
               ,d_dal
               ,d_al
               ,d_tipo_assegnazione
               ,d_assegnazione_prevalente
           from componenti           c
               ,attributi_componente a
          where c.id_componente = a.id_componente
            and a.dal = (select max(b.dal)
                           from attributi_componente b
                          where b.id_componente = c.id_componente)
            and c.id_componente = p_id_componente;
      exception
         when no_data_found then
            select progr_unita_organizzativa
                  ,ni
                  ,ci
                  ,denominazione
                  ,denominazione_al1
                  ,denominazione_al2
                  ,codice_fiscale
                  ,c.revisione_assegnazione
                  ,c.revisione_cessazione
                  ,c.dal
                  ,c.al
                  ,tipo_assegnazione
                  ,assegnazione_prevalente
              into d_progr_unor
                  ,d_ni
                  ,d_ci
                  ,d_denominazione
                  ,d_denominazione_al1
                  ,d_denominazione_al2
                  ,d_codice_fiscale
                  ,d_revisione
                  ,d_revisione_cessazione
                  ,d_dal
                  ,d_al
                  ,d_tipo_assegnazione
                  ,d_assegnazione_prevalente
              from componenti           c
                  ,attributi_componente a
             where c.id_componente = a.id_componente
               and a.id_attr_componente =
                   (select max(b.id_attr_componente)
                      from attributi_componente b
                     where b.id_componente = c.id_componente)
               and c.id_componente = p_id_componente;
         when others then
            if sqlcode between - 20999 and - 20900 then
               p_segnalazione := s_error_table(sqlcode);
            else
               p_segnalazione := sqlerrm;
            end if;
            raise d_errore;
      end;
      --
      -- Si memorizzano i dati anagrafici del componente da spostare
      --
      if d_ni is not null then
         d_cognome_nome := soggetti_get_descr(p_soggetto_ni  => d_ni
                                             ,p_soggetto_dal => trunc(sysdate)
                                             ,p_colonna      => 'COGNOME E NOME');
      end if;
      --
      -- Valorizziamo la data della revisione: se lo spostamento avviene nell'ambito di una revisione
      -- retroattiva, si usa la data della revisione per determinare la fine della vecchia assegnazione.
      -- Valorizziamo (per quanto possibile) la data di fine dell'ultima assegnazione dell'individuo
      -- nell'ottica.
      -- Determiniamo la data di fine validita' dell'U.O. di destinazione per segnalazione non bloccante
      --
      if p_revisione is not null then
         set_tipo_revisione(p_ottica, p_revisione);
         if p_dal is null then
            if s_tipo_revisione = 'R' then
               d_data_revisione := nvl(revisione_struttura.get_dal(p_ottica, p_revisione)
                                      ,trunc(sysdate));
               select max(nvl(c.al, to_date(3333333, 'j')))
                 into d_al
                 from componenti           c
                     ,attributi_componente a
                where ni = d_ni
                  and nvl(c.ci, 0) = nvl(d_ci, 0)
                  and c.ottica = p_ottica
                  and a.id_componente = c.id_componente
                  and substr(d_assegnazione_prevalente, 1, 1) =
                      substr(a.assegnazione_prevalente, 1, 1)
                  and nvl(d_tipo_assegnazione, 'I') = nvl(a.tipo_assegnazione, 'I')
                  and a.dal = (select max(dal)
                                 from attributi_componente
                                where id_componente = c.id_componente);
               select max(nvl(u.al, to_date(3333333, 'j')))
                 into d_al_unor
                 from unita_organizzative u
                where u.ottica = p_ottica
                  and u.progr_unita_organizzativa = p_unita_org_dest;
               if d_al = to_date(3333333, 'j') then
                  d_al := to_date(null);
               end if;
            else
               d_data_revisione := to_date(null);
            end if;
         end if;
      end if;
      --
      if nvl(d_al, to_date(3333333, 'j')) < nvl(p_dal, d_data_revisione) then
         p_segnalazione := ' cessato in data antecedente all''assegnazione incarico';
         raise d_errore;
      end if;
      --
      -- Si memorizza l'attributo gestione_revisioni per l'ottica indicata
      --
      begin
         d_ottica_gest_rev := ottica.get_gestione_revisioni(p_ottica);
      exception
         when others then
            if sqlcode between - 20999 and - 20900 then
               p_segnalazione := s_error_table(sqlcode);
            else
               p_segnalazione := sqlerrm;
            end if;
            raise d_errore;
      end;
      --
      if d_ottica_gest_rev = 'NO' or d_revisione = p_revisione then
         --
         -- Se l'ottica non e' gestita a revisioni, si aggiorna direttamente
         -- il record del componente con la nuova unita' di destinazione
         --
         begin
            update componenti
               set progr_unita_organizzativa = p_unita_org_dest
                  ,utente_aggiornamento      = p_utente_aggiornamento
                  ,data_aggiornamento        = p_data_aggiornamento
             where id_componente = p_id_componente;
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
         --   Un componente cessato non può essere spostato
         --
         if nvl(d_revisione_cessazione, -1) = nvl(p_revisione, -2) then
            p_segnalazione := 'Non e'' possibile spostare i componenti cessati';
            raise d_errore;
         end if;
         --
         -- Si verifica se esiste lo stesso componente cessato nell'unita'
         -- di destinazione (con la stessa revisione o per lo stesso periodo
         -- di validita'
         --
         if s_tipo_revisione = 'N' or p_revisione is null then
            --#459
            begin
               select c.id_componente
                 into d_id_componente
                 from componenti           c
                     ,attributi_componente a
                where c.id_componente = a.id_componente
                  and c.ottica = p_ottica
                  and nvl(ni, -1) = nvl(d_ni, -1)
                  and nvl(ci, -1) = nvl(d_ci, -1)
                  and nvl(denominazione, '*') = nvl(d_denominazione, '*')
                  and progr_unita_organizzativa = p_unita_org_dest
                  and nvl(a.tipo_assegnazione, 'I') = nvl(d_tipo_assegnazione, 'I')
                  and nvl(a.assegnazione_prevalente, 0) =
                      nvl(d_assegnazione_prevalente, 0)
                  and ((p_revisione is not null and c.revisione_cessazione = p_revisione) or
                      (p_revisione is null and
                      (nvl(p_dal, d_data_revisione) <=
                      nvl(c.al, to_date('3333333', 'j')) and
                      nvl(p_al, to_date('3333333', 'j')) >= c.dal) or
                      (nvl(p_dal, d_data_revisione) =
                      nvl(c.al, to_date('3333333', 'j')) + 1)));
            exception
               when others then
                  d_id_componente := null;
            end;
         end if;
         --
         -- Se il componente esiste gia' nell'unita' di destinazione,
         -- con revisione di cessazione uguale a quella indicata,
         -- significa che si sta annullando uno spostamento
         --
         if d_id_componente is not null and d_id_componente <> p_id_componente then
            --#595
            --
            -- Si annulla la revisione di cessazione
            --
            begin
               update componenti
                  set revisione_cessazione = decode(revisione_cessazione
                                                   ,p_revisione
                                                   ,null
                                                   ,revisione_cessazione)
                     ,al                   = d_al
                     ,utente_aggiornamento = p_utente_aggiornamento
                     ,data_aggiornamento   = p_data_aggiornamento
                where id_componente = d_id_componente;
            exception
               when others then
                  if sqlcode between - 20999 and - 20900 then
                     p_segnalazione := s_error_table(sqlcode);
                  else
                     p_segnalazione := sqlerrm;
                  end if;
                  raise d_errore;
            end;
            --
            -- Si elimina il record inserito per lo spostamento
            --
            begin
               elimina_componente(p_id_componente
                                 ,p_revisione
                                 ,p_al
                                 ,p_data_aggiornamento
                                 ,p_utente_aggiornamento
                                 ,p_segnalazione_bloccante
                                 ,p_segnalazione);
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
            if nvl(d_id_componente, -1) <> p_id_componente then
               --#595
               --
               -- Spostamento componente: si inserisce la nuova assegnazione
               --
               if p_revisione is null and nvl(p_dal, d_data_revisione) = d_dal then
                  begin
                     componente.backup_componente(p_id_componente);
                  exception
                     when others then
                        if sqlcode between - 20999 and - 20900 then
                           p_segnalazione := s_error_table(sqlcode);
                        else
                           p_segnalazione := sqlerrm;
                        end if;
                        raise d_errore;
                  end;
               
                  --eliminazione logica del componente preesistente #313
                  begin
                     revisione_struttura.s_attivazione := 1;
                  
                     update componenti
                        set al                   = dal - 1
                           ,al_prec              = al
                           ,al_pubb              = least(nvl(al_pubb
                                                            ,to_date(3333333, 'j'))
                                                        ,trunc(sysdate))
                           ,utente_aggiornamento = p_utente_aggiornamento
                           ,data_aggiornamento   = p_data_aggiornamento
                      where id_componente = p_id_componente;

                     revisione_struttura.s_attivazione := 0;
                  exception
                     when others then
                        if sqlcode between - 20999 and - 20900 then
                           p_segnalazione := s_error_table(sqlcode);
                        else
                           p_segnalazione := sqlerrm;
                        end if;
                        raise d_errore;
                  end;
                  begin
                     d_messaggio := '(RUCO) - ';
                     ruolo_componente.elimina_ruoli(p_id_componente
                                                   ,p_segnalazione_bloccante
                                                   ,p_segnalazione);
                     d_messaggio := '(UBCO) - ';
                     ubicazione_componente.elimina_ubicazioni(p_id_componente
                                                             ,p_segnalazione_bloccante
                                                             ,p_segnalazione);
                     d_messaggio := '(IMBI) - ';
                     imputazione_bilancio.elimina_imputazioni(p_id_componente
                                                             ,p_segnalazione_bloccante
                                                             ,p_segnalazione);
                  exception
                     when others then
                        if sqlcode between - 20999 and - 20900 then
                           p_segnalazione := d_messaggio || ' ' || s_error_table(sqlcode);
                        else
                           p_segnalazione := d_messaggio || ' ' || sqlerrm;
                        end if;
                        raise d_errore;
                  end;
               else
                  begin
                     update componenti
                        set al_prec              = al
                           ,al                   = p_dal - 1 --nvl(p_dal, d_data_revisione) - 1  #459
                           ,revisione_cessazione = decode(p_revisione
                                                         ,null
                                                         ,decode(revisione_cessazione
                                                                ,d_revisione_modifica
                                                                ,null
                                                                ,revisione_cessazione)
                                                         ,p_revisione)
                           ,data_aggiornamento   = p_data_aggiornamento
                           ,utente_aggiornamento = p_utente_aggiornamento
                      where id_componente = p_id_componente;
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
               ----------------------------- Inizio Inserimento del nuovo componente
               d_new_id_componente := get_id_componente;
               d_stato             := 'D';
               /* determina la data di fine assegnazione, in funzione dell'AL indicato e della
                  data di fine validita' dell'U.O.
               */
               select decode(least(nvl(nvl(p_al, d_al), to_date(3333333, 'j'))
                                  ,nvl(d_al_unor, to_date(3333333, 'j')))
                            ,to_date(3333333, 'j')
                            ,to_date(null)
                            ,least(nvl(nvl(p_al, d_al), to_date(3333333, 'j'))
                                  ,nvl(d_al_unor, to_date(3333333, 'j'))))
                 into d_wrk_al
                 from dual;
               /* Nel caso preesista una assegnazione equivalente per ottica, assegnazione prevalente e tipo_assegnazione
                  con decorrenza precedente con dal <= d_wrk_al, la data di fine assegnazione viene fissata al
                  giorno precedente la decorrenza di tale assegnazione
               */
               if d_wrk_al is not null then
                  /* determina tipo_assegnazione ed assegnazione prevalente del componente
                     che stiamo per inserire
                  */
                  select a.tipo_assegnazione
                        ,a.assegnazione_prevalente
                    into d_tipo_assegnazione
                        ,d_assegnazione_prevalente
                    from attributi_componente a
                   where id_componente = p_id_componente
                     and dal = (select max(dal)
                                  from attributi_componente b
                                 where b.id_componente = p_id_componente);
                  /* Determina il termina del periodo da inserire (d_wrk_al) in funzione della decorrenza
                     dell'eventuale periodo di assegnazione successivo a parita' di tipo_assegnazione ed
                     assegnazione prevalente
                  */
                  select least(nvl(min(c.dal - 1), d_wrk_al), d_wrk_al)
                    into d_wrk_al
                    from componenti           c
                        ,attributi_componente a
                   where c.ni = d_ni
                     and nvl(c.ci, 0) = nvl(d_ci, 0)
                     and c.ottica = p_ottica
                     and a.id_componente = c.id_componente
                     and substr(d_assegnazione_prevalente, 1, 1) =
                         substr(a.assegnazione_prevalente, 1, 1)
                     and nvl(d_tipo_assegnazione, 'I') = nvl(a.tipo_assegnazione, 'I')
                     and a.dal = (select max(dal)
                                    from attributi_componente
                                   where id_componente = c.id_componente)
                     and c.dal > nvl(p_dal, d_data_revisione)
                     and c.id_componente <> p_id_componente --#574
                     and c.dal =
                         (select min(c1.dal)
                            from componenti           c1
                                ,attributi_componente a1
                           where c1.ni = d_ni
                             and nvl(c1.ci, 0) = nvl(d_ci, 0)
                             and c1.ottica = p_ottica
                             and a1.id_componente = c1.id_componente
                             and substr(d_assegnazione_prevalente, 1, 1) =
                                 substr(a1.assegnazione_prevalente, 1, 1)
                             and nvl(d_tipo_assegnazione, 'I') =
                                 nvl(a1.tipo_assegnazione, 'I')
                             and c1.dal > nvl(p_dal, d_data_revisione)
                             and a1.dal =
                                 (select max(dal)
                                    from attributi_componente
                                   where id_componente = c1.id_componente));
               end if;

               --determina la data di decorrenza del nuovo componente #533
               if d_dal >= so4_pkg.get_data_riferimento(p_ottica) then
                  d_new_dal := d_dal;
               else
                  d_new_dal := nvl(p_dal, d_data_revisione);
               end if;

               begin
                  componente.ins(p_id_componente             => d_new_id_componente
                                ,p_progr_unita_organizzativa => p_unita_org_dest
                                ,p_dal                       => d_new_dal --#533
                                ,p_al                        => d_wrk_al
                                ,p_ni                        => d_ni
                                ,p_ci                        => d_ci
                                ,p_codice_fiscale            => p_id_componente --#533
                                ,p_denominazione             => d_denominazione
                                ,p_denominazione_al1         => d_denominazione_al1
                                ,p_denominazione_al2         => d_denominazione_al2
                                ,p_stato                     => d_stato
                                ,p_ottica                    => p_ottica
                                ,p_revisione_assegnazione    => p_revisione
                                ,p_revisione_cessazione      => d_revisione_cessazione
                                ,p_utente_aggiornamento      => p_utente_aggiornamento
                                ,p_data_aggiornamento        => p_data_aggiornamento
                                ,p_dal_pubb                  => to_date('')
                                ,p_al_pubb                   => to_date(''));
                  if nvl(d_revisione_cessazione, -2) <> d_revisione_modifica then
                     d_revisione_cessazione := null;
                  end if;

                  --599
                  if so4_pkg.get_integrazione_gp = 'SI' and
                     so4gp_pkg.is_struttura_integrata('', p_ottica) = 'SI' then
                     revisione_struttura.s_attivazione := 1;
                     attributo_componente.duplica_attributi(p_id_componente
                                                           ,d_new_id_componente
                                                           ,p_revisione
                                                           ,d_revisione_cessazione
                                                           ,nvl(p_dal, d_data_revisione)
                                                           ,nvl(p_al, d_al)
                                                           ,p_data_aggiornamento
                                                           ,p_utente_aggiornamento
                                                           ,p_segnalazione_bloccante
                                                           ,p_segnalazione);
                     revisione_struttura.s_attivazione := 0;
                  else
                     attributo_componente.duplica_attributi(p_id_componente
                                                           ,d_new_id_componente
                                                           ,p_revisione
                                                           ,d_revisione_cessazione
                                                           ,nvl(p_dal, d_data_revisione)
                                                           ,nvl(p_al, d_al)
                                                           ,p_data_aggiornamento
                                                           ,p_utente_aggiornamento
                                                           ,p_segnalazione_bloccante
                                                           ,p_segnalazione);
                  end if;

                  if d_al_unor < nvl(nvl(p_al, d_al), to_date(3333333, 'j')) then
                     p_segnalazione           := 'Assegnazione a U.O. chiusa in data ' ||
                                                 to_char(d_al_unor, 'dd/mm/yyyy') ||
                                                 '; le eventuali assegnazioni successive del componente dovranno essere gestite extra revisione.';
                     p_segnalazione_bloccante := 'N';
                  end if;
               exception
                  when others then
                     if sqlcode between - 20999 and - 20900 then
                        p_segnalazione := s_error_table(sqlcode);
                     else
                        p_segnalazione := sqlerrm;
                     end if;
                     raise d_errore;
               end;
               begin
                  select a.tipo_assegnazione
                        ,a.assegnazione_prevalente
                    into d_tipo_assegnazione
                        ,d_assegnazione_prevalente_gps
                    from attributi_componente a
                   where a.id_componente = nvl(d_new_id_componente, p_id_componente)
                        --and trunc(sysdate) between a.dal and nvl(a.al, trunc(sysdate));
                        --#574
                     and nvl(d_wrk_al, to_date(3333333, 'j')) between a.dal and
                         nvl(a.al, to_date(3333333, 'j'));

               exception
                  when others then
                     d_tipo_assegnazione := null;
               end;
               -- eventuale ripristino dei ruoli applicativi del componente spostato #713
               if d_eredita_ruoli_globale = 'SI' then
                  for ruco in (select r.*
                                     ,greatest(p_dal, r.dal) dal_ruolo
                                     ,p_al al_ruolo
                                 from ruoli_componente r
                                where id_componente = p_id_componente
                                  and so4_pkg.check_ruolo_riservato(r.ruolo) = 0 --#30648
                                  and dal <= nvl(al, to_date(3333333, 'j'))
                                  and nvl(p_al, to_date(3333333, 'j')) >= r.dal
                                  and ruolo_componente.get_origine(r.id_ruolo_componente) in
                                      ('S', 'P')
                                order by r.ruolo
                                        ,r.dal)
                  loop
                     begin
                        select ruoli_componente_sq.nextval into d_id_ruco from dual;
                        ruolo_componente.ins(p_id_ruolo_componente  => d_id_ruco
                                            ,p_id_componente        => d_new_id_componente
                                            ,p_ruolo                => ruco.ruolo
                                            ,p_dal                  => ruco.dal_ruolo
                                            ,p_al                   => ruco.al_ruolo
                                            ,p_dal_pubb             => to_date('')
                                            ,p_al_pubb              => to_date('')
                                            ,p_utente_aggiornamento => p_utente_aggiornamento
                                            ,p_data_aggiornamento   => p_data_aggiornamento);
                     exception
                        when others then
                           null;
                     end;
                  end loop;
               end if;

               ---------------------- fine inserimento nuovo componente
               if d_assegnazione_prevalente_gps = '99' or --#550
                  d_assegnazione_prevalente_gps like '1%' then
                  --
                  -- Se l'unita' organizzativa e' associata ad una sola sede fisica, si inserisce
                  -- l'ubicazione del componente
                  -- #648 spostato in set_fi per tutte le operazioni di insert di assegnazioni istituzionali
                  null;

                  --
                  -- In presenza di integrazione con GP4, se all'unita' organizzativa e' associata
                  -- un'unica sede contabile, si inserisce la tabella IMPUTAZIONI_BILANCIO
                  --
                  if nvl(d_integr_gp4, 'NO') = 'SI' or so4gp_pkg.is_int_gps then
                     d_ni_gp4 := so4gp_pkg.get_ni_unor(p_unita_org_dest);
                     if d_ni_gp4 is not null then
                        if so4gp_pkg.is_int_gps then
                           --#594
                           -- se sono integrato con gps passo id_componente
                           d_ni_gp4 := nvl(d_new_id_componente, p_id_componente);
                        end if;
                        d_numero := so4gp_pkg.get_sede_unica(d_ni_gp4);
                        if d_numero > 0 then
                           imputazione_bilancio.ins(p_id_imputazione => null
                                                   ,p_id_componente  => nvl(d_new_id_componente
                                                                           ,p_id_componente)
                                                   ,p_numero         => d_numero
                                                   ,p_dal            => nvl(p_dal
                                                                           ,d_data_revisione)
                                                   ,p_al             => nvl(p_al, d_al)
                                                   ,p_utente_agg     => p_utente_aggiornamento
                                                   ,p_data_agg       => p_data_aggiornamento);
                        else
                           if d_obbligo_imbi = 'SI' then
                              p_segnalazione_bloccante := 'N';
                              p_segnalazione           := 'Indicare il ruolo paga per la nuova assegnazione';
                           end if;
                        end if;
                     end if;
                  end if;
               end if;
               --
               -- Gestione ruoli: se è prevista l'ereditarieta' dei ruoli nell'ambito della
               -- stessa "radice" si copiano i ruoli dall'assegnazione precedente
               --
               if d_stringa_sudd is not null and d_eredita_ruoli_globale <> 'SI' then
                  begin
                     d_eredita_ruoli := componente.verifica_ereditarieta(d_stringa_sudd
                                                                        ,p_ottica
                                                                        ,p_revisione
                                                                        ,nvl(p_dal
                                                                            ,d_data_revisione)
                                                                        ,d_progr_unor
                                                                        ,p_unita_org_dest);
                  exception
                     when others then
                        p_segnalazione := 'Verifica: ' || substr(sqlerrm, 1, 30000);
                        raise d_errore;
                  end;
                  if d_eredita_ruoli = afc_error.ok then
                     begin
                        ruolo_componente.duplica_ruoli(p_id_componente
                                                      ,d_new_id_componente
                                                      ,nvl(nvl(p_dal, d_data_revisione)
                                                          ,trunc(sysdate))
                                                      ,p_al
                                                      ,p_data_aggiornamento
                                                      ,p_utente_aggiornamento
                                                      ,p_segnalazione_bloccante
                                                      ,p_segnalazione);
                     exception
                        when others then
                           p_segnalazione := 'Duplica: ' || substr(sqlerrm, 1, 30000);
                           raise d_errore;
                     end;
                  end if;
               end if;
            end if;
         end if;
      end if;
      --
      if nvl(p_revisione, -2) <> revisione_struttura.get_revisione_mod(p_ottica) then
         if so4gp_pkg.is_int_gp4 then
            so4gp_pkg.ins_modifiche_assegnazioni(p_ottica            => p_ottica
                                                ,p_ni                => d_ni
                                                ,p_ci                => d_ci
                                                ,p_provenienza       => 'SO4'
                                                ,p_data_modifica     => p_dal
                                                ,p_revisione_so4     => p_revisione
                                                ,p_utente            => p_utente_aggiornamento
                                                ,p_data_acquisizione => to_date(null)
                                                ,p_data_cessazione   => to_date(null)
                                                ,p_data_eliminazione => to_date(null)
                                                ,p_funzionale        => null);
         elsif so4gp_pkg.is_int_gps then
            -- devo lanciare la funzione che fa lo spostamento su GPS
            so4gp_pkg.sposta_componente_gps(p_ci                        => d_ci
                                           ,p_progr_unita_organizzativa => p_unita_org_dest
                                           ,p_dal                       => p_dal
                                           ,p_al                        => d_wrk_al
                                           ,p_assegnazione_prevalente   => d_assegnazione_prevalente_gps
                                           ,p_amministrazione           => ottica.get_amministrazione(p_ottica)
                                           ,p_utente                    => p_utente_aggiornamento);
         end if;
      end if;
      --
      componente.s_spostamento := 0; --#550
   exception
      when d_errore then
         rollback;
         componente.s_spostamento := 0; --#550
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := substr('Componente: ' ||
                                            nvl(d_denominazione, d_cognome_nome) || ' - ' ||
                                            p_segnalazione || ' : ' || s_segnalazione
                                           ,1
                                           ,200);
   end; -- componente.sposta_componente
   --------------------------------------------------------------------------------
   procedure ripristina_componente
   (
      p_id_componente          in componenti.id_componente%type
     ,p_revisione              in componenti.revisione_assegnazione%type
     ,p_dal                    in componenti.dal%type
     ,p_al                     in componenti.al%type
     ,p_data_aggiornamento     in componenti.data_aggiornamento%type
     ,p_utente_aggiornamento   in componenti.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        ripristina_componente
       DESCRIZIONE: Ripristina il componente eliminato
       PARAMETRI:   p_id_componente
                    p_revisione
                    p_al
                    p_data_aggiornamento
                    p_utente_aggiornamento
                    p_segnalazione_bloccante
                    p_segnalazione
       NOTE:        --
      ******************************************************************************/
      d_ottica        componenti.ottica%type;
      d_ni            componenti.ni%type;
      d_ci            componenti.ci%type;
      d_denominazione componenti.denominazione%type;
      d_al            componenti.al%type;
      d_cognome_nome  as4_anagrafe_soggetti.denominazione%type;
      d_id_componente componenti.id_componente%type;
      d_errore exception;
   begin
      begin
         select ottica
               ,ni
               ,ci
               ,denominazione
               ,al_prec
           into d_ottica
               ,d_ni
               ,d_ci
               ,d_denominazione
               ,d_al
           from componenti
          where id_componente = p_id_componente;
      exception
         when others then
            if sqlcode between - 20999 and - 20900 then
               p_segnalazione := s_error_table(sqlcode);
            else
               p_segnalazione := sqlerrm;
            end if;
            raise d_errore;
      end;
      --
      if d_ni is not null then
         d_cognome_nome := soggetti_get_descr(p_soggetto_ni  => d_ni
                                             ,p_soggetto_dal => trunc(sysdate)
                                             ,p_colonna      => 'COGNOME E NOME');
      end if;
      --
      begin
         select id_componente
           into d_id_componente
           from componenti
          where ottica = d_ottica
            and nvl(ni, -1) = nvl(d_ni, -1)
            and nvl(ci, -1) = nvl(d_ci, -1)
            and nvl(denominazione, '*') = nvl(d_denominazione, '*')
            and revisione_assegnazione = p_revisione
            and codice_fiscale = to_char(p_id_componente); --#533
      exception
         when no_data_found then
            d_id_componente := null;
         when too_many_rows then
            d_id_componente := null;
         when others then
            if sqlcode between - 20999 and - 20900 then
               p_segnalazione := s_error_table(sqlcode);
            else
               p_segnalazione := sqlerrm;
            end if;
            raise d_errore;
      end;
      --
      if d_id_componente is not null then
         begin
            elimina_componente(d_id_componente
                              ,p_revisione
                              ,nvl(p_al, d_al)
                              ,p_data_aggiornamento
                              ,p_utente_aggiornamento
                              ,p_segnalazione_bloccante
                              ,p_segnalazione);
            componente.s_tipo_ripristino := 1; --#641
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
      --
      if nvl(p_segnalazione_bloccante, 'N') != 'Y' then
         begin
            update componenti
               set revisione_cessazione = null
                  ,al                   = nvl(p_al, d_al)
                  ,al_prec              = to_date(null)
                  ,utente_aggiornamento = p_utente_aggiornamento
                  ,data_aggiornamento   = p_data_aggiornamento
             where id_componente = p_id_componente;
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
         raise d_errore;
      end if;
      componente.s_tipo_ripristino := 0; --#641
   exception
      when d_errore then
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Componente: ' ||
                                     nvl(d_denominazione, d_cognome_nome) || ' - ' ||
                                     p_segnalazione;
   end; -- componente.ripristina_componente
   --------------------------------------------------------------------------------
   procedure annulla_spostamento
   (
      p_id_componente          in componenti.id_componente%type
     ,p_id_comp_prec           out componenti.id_componente%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        annulla_spostamento
       DESCRIZIONE: Annulla l'ultimo spostamento eseguito
       PARAMETRI:   p_id_componente
                    p_segnalazione_bloccante
                    p_segnalazione
       NOTE:        --
      ******************************************************************************/
      d_ottica         componenti.ottica%type;
      d_ni             componenti.ni%type;
      d_ci             componenti.ci%type;
      d_denominazione  componenti.denominazione%type;
      d_cognome_nome   as4_anagrafe_soggetti.denominazione%type;
      d_progr_unor     componenti.progr_unita_organizzativa%type;
      d_dal            componenti.dal%type;
      d_al             componenti.al%type;
      d_stato          componenti.stato%type;
      d_se_giuridico   anagrafe_unita_organizzative.se_giuridico%type;
      d_contatore      number;
      d_ass_prevalente attributi_componente.assegnazione_prevalente%type;
      d_id_componente  componenti.id_componente%type;
      d_errore exception;
      d_assegnazione_prevalente_gps attributi_componente.assegnazione_prevalente%type; --#550
      d_componente_annullabile      varchar2(2) := is_componente_annullabile(p_id_componente);
      d_componente_non_annullabile exception;
   begin
      componente.s_spostamento := 1; --#774
      begin
         select ottica
               ,ni
               ,ci
               ,denominazione
               ,progr_unita_organizzativa
               ,dal
               ,al
               ,stato
           into d_ottica
               ,d_ni
               ,d_ci
               ,d_denominazione
               ,d_progr_unor
               ,d_dal
               ,d_al
               ,d_stato
           from componenti
          where id_componente = p_id_componente;
      exception
         when no_data_found then
            p_segnalazione := 'Errore in lettura COMPONENTI (no_data_found) - ' ||
                              p_id_componente;
            raise d_errore;
         when too_many_rows then
            p_segnalazione := 'Errore in lettura COMPONENTI (too_many_rows) - ' ||
                              p_id_componente;
         when others then
            if sqlcode between - 20999 and - 20900 then
               p_segnalazione := s_error_table(sqlcode);
            else
               p_segnalazione := sqlerrm;
            end if;
            raise d_errore;
      end;
      --
      if d_ni is not null then
         d_cognome_nome := soggetti_get_descr(p_soggetto_ni  => d_ni
                                             ,p_soggetto_dal => trunc(sysdate)
                                             ,p_colonna      => 'COGNOME E NOME');
      end if;
      --
      if d_componente_annullabile <> 'SI' then
         --#572
         raise d_componente_non_annullabile;
      end if;
      --
      if d_stato = 'P' then
         d_se_giuridico := anagrafe_unita_organizzativa.get_se_giuridico(p_progr_unita_organizzativa => d_progr_unor
                                                                        ,p_dal                       => d_dal);
         if d_se_giuridico = 'SI' then
            p_segnalazione := 'Non e'' possibile annullare un''assegnazione giuridica';
            raise d_errore;
         end if;
      end if;
      --
      -- Si controlla se lo spostamento da annullare e' stato effettuato con
      -- un aggiornamento dell'unita' organizzativa
      --
      select count(*)
        into d_contatore
        from dup_comp
       where id_componente = p_id_componente;
      --
      -- Se il contatore e' > 0, significa che esiste un record backupato
      -- e quindi occorre ripristinarlo
      --
      if d_contatore > 0 then
         begin
            del(p_id_componente);
            componente.recupera_componente(p_id_componente);
            p_id_comp_prec := p_id_componente;
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
         d_ass_prevalente := attributo_componente.get_assegnazione_valida(p_id_componente
                                                                         ,d_dal
                                                                         ,d_ottica);
         begin
            del(p_id_componente);
         exception
            when others then
               dbms_output.put_line('sqlcode : ' || sqlcode);
               dbms_output.put_line('sqlcode : ' || s_error_table(sqlcode));

               if sqlcode between - 20999 and - 20900 then
                  p_segnalazione := s_error_table(sqlcode);
               else
                  p_segnalazione := sqlerrm;
               end if;
               raise d_errore;
         end;
         --
         begin
            select id_componente
              into d_id_componente
              from componenti
             where ottica = d_ottica
               and nvl(ni, -1) = nvl(d_ni, -1)
               and nvl(ci, -1) = nvl(d_ci, -1)
               and nvl(denominazione, '*') = nvl(d_denominazione, '*')
                  --#577
               and substr(nvl(attributo_componente.get_assegnazione_corrente(id_componente
                                                                            ,dal
                                                                            ,ottica)
                             ,0)
                         ,1
                         ,1) = substr(nvl(d_ass_prevalente, 0), 1, 1)
               and al = d_dal - 1;
         exception
            when no_data_found then
               d_id_componente := null;
            when too_many_rows then
               d_id_componente := null;
            when others then
               if sqlcode between - 20999 and - 20900 then
                  p_segnalazione := s_error_table(sqlcode);
               else
                  p_segnalazione := sqlerrm;
               end if;
               raise d_errore;
         end;
         --
         if d_id_componente is not null then
            begin
               update componenti
                  set al                 = d_al
                     ,data_aggiornamento = trunc(sysdate)
                where id_componente = d_id_componente;
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
         p_id_comp_prec := d_id_componente;
      end if;
      if so4gp_pkg.is_int_gps then
         --#550
         -- devo lanciare la funzione che fa la cancellazione del periodo su GPS
         select a.assegnazione_prevalente
           into d_assegnazione_prevalente_gps
           from attributi_componente a
          where a.id_componente = p_id_comp_prec;
         so4gp_pkg.ripristina_componente_gps(p_ci                      => d_ci
                                            ,p_dal                     => d_dal
                                            ,p_al                      => d_al
                                            ,p_assegnazione_prevalente => d_assegnazione_prevalente_gps
                                            ,p_utente                  => 'SO4');
      end if;

      componente.s_spostamento := 0; --#774

   exception
      when d_componente_non_annullabile then
         componente.s_spostamento := 0; --#774
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Componente: ' ||
                                     nvl(d_denominazione, d_cognome_nome) || ' - ' ||
                                     'Non eliminabile in assenza di predecessore';
      when d_errore then
         componente.s_spostamento := 0; --#774
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Componente: ' ||
                                     nvl(d_denominazione, d_cognome_nome) || ' - ' ||
                                     p_segnalazione;
   end;
   ---------------------------------------------------------------------------------------------
   -- procedure di aggiornamento della data di inizio e fine validità
   -- al momento dell'attivazione della revisione
   procedure update_comp
   (
      p_ottica    in componenti.ottica%type
     ,p_revisione in componenti.revisione_assegnazione%type
     ,p_data      in componenti.dal%type
   ) is
      d_fine_validita_revisione date;
      d_data_pubb               date := nvl(revisione_struttura.get_data_pubblicazione(p_ottica
                                                                                      ,p_revisione)
                                           ,p_data);
      d_al_padre                componenti.al%type;
      d_al_pubb_padre           componenti.al_pubb%type;
      d_rev_cess_padre          componenti.revisione_cessazione%type;
      d_contatore               number;
      d_dal                     date;
      d_al                      date;
      d_segnalazione_bloccante  varchar2(240);
      d_segnalazione            varchar2(240);
   begin
      set_tipo_revisione(p_ottica, p_revisione);
      if s_tipo_revisione = 'N' then
         -- revisione non retroattiva
         for sogg in (select distinct ni
                        from componenti
                       where ottica = p_ottica
                         and (revisione_assegnazione = p_revisione or
                             revisione_cessazione = p_revisione)
                       order by ni)
         loop
            for comp in (select *
                           from componenti
                          where ottica = p_ottica
                            and ni = sogg.ni
                            and (revisione_assegnazione = p_revisione or
                                revisione_cessazione = p_revisione)
                          order by decode(nvl(revisione_assegnazione, -1)
                                         ,p_revisione
                                         ,1
                                         ,2)
                                  ,id_componente)
            loop
               --#533
               update componenti
                  set dal            = nvl(dal, p_data)
                     ,dal_pubb       = greatest(nvl(dal, p_data), d_data_pubb)
                     ,al_pubb        = al
                     ,codice_fiscale = '' --#533
                where ottica = p_ottica
                  and revisione_assegnazione = p_revisione
                  and id_componente = comp.id_componente;
               update componenti
                  set al      = least(nvl(al, p_data - 1), (p_data - 1)) --#500
                     ,al_pubb = least(nvl(al_pubb, to_date(3333333, 'j'))
                                     ,(d_data_pubb - 1))
                where ottica = p_ottica
                  and revisione_cessazione = p_revisione
                  and id_componente = comp.id_componente;
            end loop;
            /*
              verifica, per il soggetto trattato, la presenza di componenti di tipo istituzionale prevalente
              anche parzialmente sovrapposti.
              I periodi di assegnazione non trattati nella revisione, vengono adattati alla nuova situazione
              creata dall'utente; se hanno ruoli applicativi, vengono eseguite cancellazioni logiche
              (totali o parziali) e preservati i ruoli applicativi per i periodi interessati.
            */
            select count(*)
                  ,min(dal)
              into d_contatore
                  ,d_dal
              from componenti c
             where ottica = p_ottica
               and ni = sogg.ni
               and dal <= nvl(al, to_date(3333333, 'j'))
               and exists (select 'x'
                      from attributi_componente
                     where id_componente = c.id_componente
                       and nvl(tipo_assegnazione, 'I') = 'I'
                       and substr(assegnazione_prevalente, 1, 1) = 1
                       and dal <= nvl(al, to_date(3333333, 'j')))
               and exists
             (select 'x'
                      from componenti c1
                     where ni = c.ni
                       and ottica = c.ottica
                       and dal <= nvl(al, to_date(3333333, 'j'))
                       and exists (select 'x'
                              from attributi_componente
                             where id_componente = c1.id_componente
                               and nvl(tipo_assegnazione, 'I') = 'I'
                               and substr(assegnazione_prevalente, 1, 1) = 1
                               and dal <= nvl(al, to_date(3333333, 'j')))
                       and id_componente <> c.id_componente
                       and dal <= nvl(c.al, to_date(3333333, 'j'))
                       and nvl(al, to_date(3333333, 'j')) >= c.dal);
         
            if d_contatore > 0 then
               for comp in (select c.*
                                  ,(select count(*)
                                      from ruoli_componente
                                     where id_componente = c.id_componente) num_ruoli
                              from componenti c
                             where ottica = p_ottica
                               and ni = sogg.ni
                               and dal <= nvl(al, to_date(3333333, 'j'))
                               and dal >= d_dal
                               and exists
                             (select 'x'
                                      from attributi_componente
                                     where id_componente = c.id_componente
                                       and nvl(tipo_assegnazione, 'I') = 'I'
                                       and substr(assegnazione_prevalente, 1, 1) = 1
                                       and dal <= nvl(al, to_date(3333333, 'j')))
                             order by dal
                                     ,id_componente)
               loop
                  if comp.revisione_assegnazione = p_revisione or
                     comp.revisione_cessazione = p_revisione then
                     /* periodo di assegnazione trattato nella revisione
                     */
                     null;
                  else
                     /* periodo di assegnazione non trattato nella revisione
                     */
                     select count(*)
                           ,min(dal)
                           ,max(nvl(al, to_date(3333333, 'j')))
                       into d_contatore
                           ,d_dal
                           ,d_al
                       from componenti c
                      where ottica = p_ottica
                        and ni = sogg.ni
                        and dal <= nvl(al, to_date(3333333, 'j'))
                        and revisione_assegnazione = p_revisione
                        and dal <= nvl(comp.al, to_date(3333333, 'j'))
                        and nvl(al, to_date(3333333, 'j')) >= comp.dal
                        and exists
                      (select 'x'
                               from attributi_componente
                              where id_componente = c.id_componente
                                and nvl(tipo_assegnazione, 'I') = 'I'
                                and substr(assegnazione_prevalente, 1, 1) = 1
                                and dal <= nvl(al, to_date(3333333, 'j')));
                     if d_contatore = 1 then
                        if comp.dal >= d_dal and
                           nvl(comp.al, to_date(3333333, 'j')) <= d_al then
                           /* periodo precedente compreso nel periodo trattato in revisione;
                              si esegue una cancellazione logica
                           */
                           if comp.num_ruoli = 0 then
                              --il componente non ha ruoli applicativi, può essere eliminato
                              delete from componenti
                               where id_componente = comp.id_componente;
                           else
                              --il componente non ha ruoli applicativi, eseguiamo una eliminazione logica
                              update componenti
                                 set al                   = dal - 1
                                    ,al_pubb              = least((d_data_pubb - 1) --#597
                                                                 ,nvl(al_pubb
                                                                     ,to_date(3333333
                                                                             ,'j'))
                                                                 ,trunc(sysdate))
                                    ,revisione_cessazione = p_revisione
                               where id_componente = comp.id_componente;
                              ruolo_componente.s_gestione_profili := 1;
                              ruolo_componente.s_ruoli_automatici := 1;
                              ruolo_componente.s_ruoli_automatici := 1;
                              for ruco in (select *
                                             from ruoli_componente
                                            where id_componente = comp.id_componente
                                              and dal <= nvl(al, to_date(3333333, 'j')))
                              loop
                                 ruolo_componente.eliminazione_logica_ruolo(ruco.id_ruolo_componente
                                                                           ,''
                                                                           ,''
                                                                           ,d_segnalazione_bloccante
                                                                           ,d_segnalazione);
                              end loop;
                              ruolo_componente.s_gestione_profili := 0;
                              ruolo_componente.s_ruoli_automatici := 0;
                              ruolo_componente.s_ruoli_automatici := 0;
                           end if;
                        else
                           update componenti c
                              set al                   = d_dal - 1
                                 ,al_pubb              = least((d_data_pubb - 1) --#597
                                                              ,nvl(al_pubb
                                                                  ,to_date(3333333, 'j'))
                                                              ,trunc(sysdate))
                                 ,revisione_cessazione = p_revisione
                            where id_componente = comp.id_componente;
                           ruolo_componente.s_gestione_profili    := 1;
                           ruolo_componente.s_eliminazione_logica := 1;
                           ruolo_componente.s_ruoli_automatici    := 1;
                           for ruco in (select *
                                          from ruoli_componente
                                         where id_componente = comp.id_componente
                                           and dal <= nvl(al, to_date(3333333, 'j'))
                                         order by id_ruolo_componente)
                           loop
                              update ruoli_componente
                                 set al      = d_dal - 1
                                    ,al_pubb = least((d_data_pubb - 1) --#597
                                                    ,nvl(al_pubb, to_date(3333333, 'j'))
                                                    ,trunc(sysdate))
                               where id_ruolo_componente = ruco.id_ruolo_componente;
                           end loop;
                           ruolo_componente.s_ruoli_automatici    := 0;
                           ruolo_componente.s_gestione_profili    := 0;
                           ruolo_componente.s_eliminazione_logica := 0;
                        end if;
                     else
                        null;
                     end if;
                  end if;
               end loop;
            end if;
         end loop;
      elsif s_tipo_revisione = 'R' then
         /* revisione con profondita' storica fino alla situazione Corrente
            elimina logicamente le registrazioni relative a componenti modificati
            che hanno decorrenza successiva alla data di decorrenza della nuova revisione
         */
         update componenti c
            set al                   = dal - 1 --(al minore del dal)
               ,al_pubb              = least((d_data_pubb - 1) --#597
                                            ,nvl(al_pubb, to_date(3333333, 'j'))
                                            ,trunc(sysdate))
               ,revisione_cessazione = p_revisione
          where ottica = p_ottica
            and nvl(revisione_assegnazione, -2) <> p_revisione
            and dal >= p_data
            and exists (select 'x'
                   from attributi_componente
                  where id_componente = c.id_componente
                    and nvl(tipo_assegnazione, 'I') = 'I')
            and exists
          (select 'x'
                   from componenti c1
                  where ((revisione_assegnazione = p_revisione /*and dal is null*/
                        ) or (revisione_cessazione = p_revisione /*and al is null*/
                        ))
                    and ottica = p_ottica
                    and ni = c.ni
                    and nvl(c1.ci, 0) = nvl(c.ci, 0)
                    and exists (select 'x'
                           from attributi_componente
                          where id_componente = c1.id_componente
                            and nvl(tipo_assegnazione, 'I') = 'I'))
            and exists
          (select 'x'
                   from componenti c2
                  where revisione_assegnazione = p_revisione
                    and ottica = p_ottica
                    and ni = c.ni
                    and nvl(c2.ci, 0) = nvl(c.ci, 0)
                    and c2.dal <= c.dal
                    and nvl(c2.al, to_date(3333333, 'j')) >=
                        nvl(c.al, to_date(3333333, 'j'))
                    and exists (select 'x'
                           from attributi_componente
                          where id_componente = c2.id_componente
                            and nvl(tipo_assegnazione, 'I') = 'I'));
         /* modifica la data di termine delle registrazioni relative a componenti modificati
            con termine successivo alla data di decorrenza della nuova revisione
         */
         update componenti c
            set al_prec = '' --al: all'attivazione della revisione l'al_prec non ha più utilita'
               ,al      = p_data - 1
               ,al_pubb = least((d_data_pubb - 1) --#597
                               ,nvl(al_pubb, to_date(3333333, 'j'))
                               ,trunc(sysdate))
          where ottica = p_ottica
            and nvl(revisione_assegnazione, -2) <> p_revisione
            and p_data between c.dal and nvl(c.al, to_date(3333333, 'j'))
            and exists (select 'x'
                   from attributi_componente
                  where id_componente = c.id_componente
                    and nvl(tipo_assegnazione, 'I') = 'I')
            and exists
          (select 'x'
                   from componenti c1
                  where revisione_assegnazione = p_revisione
                    and dal is null
                    and ottica = p_ottica
                    and ni = c.ni
                    and exists (select 'x'
                           from attributi_componente
                          where id_componente = c1.id_componente
                            and nvl(tipo_assegnazione, 'I') = 'I'
                               -- devo controllare che assegnazione sia prevalente
                            and assegnazione_prevalente like '1%'));
         for comp_set_dal in (select id_componente
                                    ,ni
                                    ,dal
                                    ,al
                                    ,progr_unita_organizzativa
                                    ,utente_aggiornamento
                                from componenti
                               where ottica = p_ottica
                                 and revisione_assegnazione = p_revisione)
         loop
            /* modifica la data di decorrenza dell'eventuale registrazione che comprende la data di
               termine della corrispondente assegnazione creata con la revisione
            */
            if comp_set_dal.al is not null then
               update componenti c
                  set dal = comp_set_dal.al + 1
                where ni = comp_set_dal.ni
                  and ottica = p_ottica
                  and nvl(revisione_assegnazione, -2) <> p_revisione
                  and comp_set_dal.al between c.dal and nvl(c.al, to_date(3333333, 'j'))
                  and exists (select 'x'
                         from attributi_componente
                        where id_componente = c.id_componente
                          and nvl(tipo_assegnazione, 'I') = 'I')
                  and exists
                (select 'x'
                         from componenti c1
                        where revisione_assegnazione = p_revisione
                          and dal is null
                          and ottica = p_ottica
                          and ni = c.ni
                          and exists
                        (select 'x'
                                 from attributi_componente
                                where id_componente = c1.id_componente
                                  and nvl(tipo_assegnazione, 'I') = 'I'));
            end if;
            if comp_set_dal.dal = p_data then
               ruolo_componente.aggiorna_ruoli(comp_set_dal.id_componente
                                              ,comp_set_dal.dal
                                              ,d_data_pubb
                                              ,trunc(sysdate)
                                              ,comp_set_dal.utente_aggiornamento
                                              ,d_segnalazione_bloccante
                                              ,d_segnalazione);
            end if;
            select al
                  ,revisione_cessazione
                  ,al_pubb
              into d_al_padre
                  ,d_rev_cess_padre
                  ,d_al_pubb_padre
              from unita_organizzative u
             where progr_unita_organizzativa = comp_set_dal.progr_unita_organizzativa
               and ottica = p_ottica
               and dal <= nvl(al, to_date(3333333, 'j')) --#786
               and nvl(dal, to_date(2222222, 'j')) =
                   (select max(nvl(dal, to_date(2222222, 'j')))
                      from unita_organizzative
                     where progr_unita_organizzativa = u.progr_unita_organizzativa
                       and dal <= nvl(al, to_date(3333333, 'j')) --#786
                       and ottica = p_ottica);
            if nvl(d_al_padre, to_date(3333333, 'j')) <
               nvl(comp_set_dal.al, to_date(3333333, 'j')) then
               update componenti
                  set dal                  = nvl(dal, p_data)
                     ,dal_pubb             = nvl(d_data_pubb, p_data)
                     ,al                   = decode(nvl(d_al_padre, to_date(3333333, 'j'))
                                                   ,to_date(3333333, 'j')
                                                   ,to_date(null)
                                                   ,nvl(d_al_padre, to_date(3333333, 'j')))
                     ,al_pubb              = d_al_pubb_padre
                     ,revisione_cessazione = d_rev_cess_padre
                where id_componente = comp_set_dal.id_componente;
            else
               update componenti
                  set dal      = nvl(dal, p_data)
                     ,dal_pubb = nvl(d_data_pubb, p_data)
                where id_componente = comp_set_dal.id_componente;
            end if;
         end loop;
         for comp_set_al in (select id_componente
                                   ,ni
                                   ,dal
                                   ,al
                               from componenti
                              where ottica = p_ottica
                                and revisione_cessazione = p_revisione
                             /*and al is null*/
                             )
         loop
            update componenti
               set al      = least(nvl(al, p_data - 1), p_data - 1)
                  ,al_pubb = d_data_pubb - 1 --#597
             where id_componente = comp_set_al.id_componente;
         end loop;
      end if;
   end;
   --------------------------------------------------------------------------------
   function conta_assegnazioni
   (
      p_ni  in componenti.ni%type
     ,p_dal in componenti.dal%type default null
     ,p_al  in componenti.al%type default null
   ) return number is
      d_conta number;
   begin
      select count(*)
        into d_conta
        from componenti c
       where ni = p_ni
         and dal <= nvl(p_al, to_date(3333333, 'j'))
         and nvl(decode(revisione_cessazione
                       ,revisione_struttura.get_revisione_mod(ottica)
                       ,to_date(null)
                       ,al)
                ,to_date(3333333, 'j')) >= nvl(p_dal, to_date(2222222, 'j'))
         and nvl(revisione_assegnazione, -1) <>
             revisione_struttura.get_revisione_mod(ottica);
      return d_conta;
   exception
      when no_data_found then
         null;
      when too_many_rows then
         null;
   end;
   --------------------------------------------------------------------------------
   procedure chiudi_assegnazioni
   (
      p_ni                     in componenti.ni%type
     ,p_data                   in componenti.al%type
     ,p_id_componente          in componenti.id_componente%type default null
     ,p_utente_aggiornamento   in componenti.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        chiudi_assegnazioni
       DESCRIZIONE: Chiude tutte le assegnazioni dell'individuo (p_id_componente nullo)
                    o la specifica assegnazione alla data indicata
       NOTE:        --
      ******************************************************************************/
      d_integr_gp4 impostazioni.integr_gp4%type := nvl(impostazione.get_integr_gp4(1)
                                                      ,'NO');
      d_nominativo as4_anagrafe_soggetti.denominazione%type := soggetti_get_descr(p_soggetto_ni  => p_ni
                                                                                 ,p_soggetto_dal => trunc(sysdate)
                                                                                 ,p_colonna      => 'COGNOME E NOME');
      d_errore exception;
   begin
      p_segnalazione_bloccante := 'N';
      p_segnalazione           := 'Elaborazione Completata per ' || d_nominativo;
      /* Chiude tutte le assegnazioni tranne quella istituzionale prevalente (se esiste
         integrazione con GP4).
         Elimina tutte le assegnazione che hanno decorrenza successiva la data
      */
      begin
         update componenti c
            set denominazione_al1    = '[OLD al]' ||
                                       nvl(to_char(al, 'dd/mm/yyyy'), 'null')
               ,al                   = p_data
               ,data_aggiornamento   = sysdate
               ,utente_aggiornamento = p_utente_aggiornamento
          where ni = p_ni
            and p_data between dal and nvl(al, to_date(3333333, 'j'))
            and id_componente = nvl(p_id_componente, id_componente)
            and ((not exists (select 'x'
                                from attributi_componente
                               where id_componente = c.id_componente
                                 and tipo_assegnazione = 'I'
                                 and assegnazione_prevalente in
                                     (1, 2, 3, 4, 5, 99, 11, 12, 13, 21, 22, 23)
                                 and p_data between dal and nvl(al, to_date(3333333, 'j'))) and
                 d_integr_gp4 = 'SI') or d_integr_gp4 = 'NO');
         update componenti c
            set denominazione_al1    = '[OLD dal-al]' ||
                                       nvl(to_char(dal, 'dd/mm/yyyy'), 'null') ||
                                       nvl(to_char(al, 'dd/mm/yyyy'), 'null')
               ,al                   = dal
               ,dal                  = nvl(al, to_date(3333333, 'j'))
               ,data_aggiornamento   = sysdate
               ,utente_aggiornamento = p_utente_aggiornamento
          where ni = p_ni
            and dal > p_data
            and p_id_componente is null
            and not exists
          (select 'x'
                   from attributi_componente
                  where id_componente = c.id_componente
                    and tipo_assegnazione = 'I'
                    and assegnazione_prevalente in
                        (1, 2, 3, 4, 5, 99, 11, 12, 13, 21, 22, 23)
                    and p_data between dal and nvl(al, to_date(3333333, 'j')));
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
      when no_data_found then
         null;
      when too_many_rows then
         null;
   end;
   --------------------------------------------------------------------------------
   procedure ripristina_assegnazioni
   (
      p_ni                     in componenti.ni%type
     ,p_data                   in componenti.al%type
     ,p_id_componente          in componenti.id_componente%type default null
     ,p_utente_aggiornamento   in componenti.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        ripristina_assegnazioni
       DESCRIZIONE: Ripristina tutte le assegnazioni dell'individuo (p_id_componente nullo)
                    o la specifica assegnazione alla data indicata se sono state chiuse con
                    la procedure chiudi_assegnazioni
       NOTE:        --
      ******************************************************************************/
      d_nominativo as4_anagrafe_soggetti.denominazione%type := soggetti_get_descr(p_soggetto_ni  => p_ni
                                                                                 ,p_soggetto_dal => trunc(sysdate)
                                                                                 ,p_colonna      => 'COGNOME E NOME');
      d_errore exception;
   begin
      p_segnalazione_bloccante := 'N';
      p_segnalazione           := 'Elaborazione Completata per ' || d_nominativo;
      /* ripristina tutte le assegnazioni con denominazione_al1 like '[OLD %'
      */
      for comp in (select c.*
                         ,instr(denominazione_al1, '[OLD al]') chiuso
                         ,instr(denominazione_al1, '[OLD dal-al]') cancellato
                         ,decode(instr(denominazione_al1, '[OLD al]'), 0, al, dal) old_dal
                         ,decode(instr(denominazione_al1, '[OLD al]')
                                ,1
                                ,decode(substr(denominazione_al1
                                              ,instr(denominazione_al1, ']') + 1
                                              ,4)
                                       ,'null'
                                       ,to_date(null)
                                       ,to_date(substr(denominazione_al1
                                                      ,instr(denominazione_al1, ']') + 1
                                                      ,10)
                                               ,'dd/mm/yyyy'))
                                ,dal) old_al
                     from componenti c
                    where ni = p_ni
                      and denominazione_al1 like '[OLD %'
                      and id_componente = nvl(p_id_componente, id_componente))
      loop
         begin
            update componenti c
               set denominazione_al1    = ''
                  ,dal                  = comp.old_dal
                  ,al                   = decode(comp.old_al
                                                ,to_date(3333333, 'j')
                                                ,to_date(null)
                                                ,comp.old_al)
                  ,data_aggiornamento   = sysdate
                  ,utente_aggiornamento = p_utente_aggiornamento
             where (p_data between comp.old_dal and
                   nvl(comp.old_al, to_date(3333333, 'j')) or p_data is null)
               and id_componente = comp.id_componente;
         exception
            when others then
               if sqlcode between - 20999 and - 20900 then
                  p_segnalazione := s_error_table(sqlcode);
               else
                  p_segnalazione := sqlerrm;
               end if;
               raise d_errore;
         end;
      end loop;
   exception
      when no_data_found then
         null;
      when too_many_rows then
         null;
   end;
   --------------------------------------------------------------------------------
   procedure elimina_assegnazione
   (
      p_id_componente          in componenti.id_componente%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        elimina_assegnazione
       DESCRIZIONE: Cancella fisicamente una assegnazione
       PARAMETRI:   p_id_componente
       NOTE:        --
      ******************************************************************************/
      d_integr_gp4 impostazioni.integr_gp4%type := nvl(impostazione.get_integr_gp4(1)
                                                      ,'NO');
      d_conta      number;
      errore_gp    exception;
      errore_ruoli exception;
   begin
      begin
         select 1
           into d_conta
           from attributi_componente a
          where id_componente = p_id_componente
            and tipo_assegnazione = 'I'
            and assegnazione_prevalente = 1
            and d_integr_gp4 = 'SI';
         raise too_many_rows;
      exception
         when no_data_found then
            null;
         when too_many_rows then
            raise errore_gp;
      end;
      begin
         select 1
           into d_conta
           from ruoli_componente r
          where id_componente = p_id_componente;
         raise too_many_rows;
      exception
         when no_data_found then
            null;
         when too_many_rows then
            raise errore_ruoli;
      end;
      componente.del(p_id_componente);
      /*      update componenti c
               set denominazione_al1    = '[ELIMINATA dal-al]' ||
                                          nvl(to_char(dal, 'dd/mm/yyyy'), 'null') ||
                                          nvl(to_char(al, 'dd/mm/yyyy'), 'null')
                  ,al                   = dal
                  ,dal                  = nvl(al, to_date(3333333, 'j'))
                  ,data_aggiornamento   = sysdate
                  ,utente_aggiornamento = p_utente_aggiornamento
             where id_componente = p_id_componente;
      */
   exception
      when errore_gp then
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Assegnazione Istituzionale Prevalente non Eliminabile';
      when errore_ruoli then
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := 'Esistono Ruoli: Assegnazione non Eliminabile ';
      when others then
         if sqlcode between - 20999 and - 20900 then
            p_segnalazione := s_error_table(sqlcode);
         else
            p_segnalazione := sqlerrm;
         end if;
   end;
   --------------------------------------------------------------------------------
   function conta_assegnazioni_ripr(p_ni in componenti.ni%type) return number is
      d_conta number;
   begin
      select count(*)
        into d_conta
        from componenti c
       where ni = p_ni
         and denominazione_al1 like '[OLD %'
         and trunc(sysdate) between
             decode(instr(denominazione_al1, '[OLD al]'), 0, al, dal) and
             nvl(decode(instr(denominazione_al1, '[OLD al]')
                       ,1
                       ,decode(substr(denominazione_al1
                                     ,instr(denominazione_al1, ']') + 1
                                     ,4)
                              ,'null'
                              ,to_date(null)
                              ,to_date(substr(denominazione_al1
                                             ,instr(denominazione_al1, ']') + 1
                                             ,10)
                                      ,'dd/mm/yyyy'))
                       ,dal)
                ,to_date(3333333, 'j'));
      return d_conta;
   exception
      when no_data_found then
         null;
      when too_many_rows then
         null;
   end;
   --------------------------------------------------------------------------------
   procedure ins_ass_singola
   (
      p_id_componente          in componenti.id_componente%type
     ,p_ottica                 in componenti.ottica%type
     ,p_dal                    in componenti.dal%type
     ,p_al                     in componenti.al%type
     ,p_stringa_unor_out       varchar2
     ,p_ruolo                  in ruoli_componente.ruolo%type
     ,p_utente_aggiornamento   in componenti.utente_aggiornamento%type
     ,p_data_aggiornamento     in componenti.data_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        ins_ass_singola
       DESCRIZIONE: Inserimento di un'assegnazione singola
       PARAMETRI:   p_id_componente
                    p_ottica
                    p_dal
                    p_al
                    p_stringa_unor_out
                    p_ruolo
                    p_data_aggiornamento
                    p_utente_aggiornamento
                    p_segnalazione_bloccante
                    p_segnalazione
       NOTE:        --
      ******************************************************************************/
      d_ni            componenti.ni%type;
      d_ci            componenti.ci%type;
      d_id_componente componenti.id_componente%type;
      d_progr_unor    componenti.progr_unita_organizzativa%type;
      d_inizio        number;
      d_lunghezza     number;
      d_errore exception;
   begin
      begin
         select ni
               ,ci
           into d_ni
               ,d_ci
           from componenti
          where id_componente = p_id_componente;
      exception
         when no_data_found then
            p_segnalazione := 'Assegnazione di provenienza ( ' || p_id_componente ||
                              ') non esistente';
            raise d_errore;
      end;
      --
      d_inizio                 := 0;
      d_lunghezza              := 0;
      p_segnalazione_bloccante := 'N'; --#655
      loop
         d_inizio     := d_inizio + d_lunghezza + 1;
         d_lunghezza  := instr(p_stringa_unor_out, ',', 1) - 1;
         d_progr_unor := substr(p_stringa_unor_out, d_inizio, d_lunghezza);
         if d_progr_unor is not null then
            begin
               select id_componente
                 into d_id_componente
                 from componenti
                where ottica = p_ottica
                  and progr_unita_organizzativa = d_progr_unor
                  and ni = d_ni
                  and nvl(ci, 0) = nvl(d_ci, 0)
                  and dal <= nvl(p_al, to_date(3333333, 'j'))
                  and nvl(al, to_date(3333333, 'j')) >= p_dal;
            exception
               when no_data_found then
                  d_id_componente := null;
               when too_many_rows then
                  d_id_componente := 1;
            end;
            --
            if d_id_componente is null then
               d_id_componente := componente.get_id_componente;
               --
               begin
                  --
                  --    Inserimento tabella COMPONENTI
                  --
                  componente.ins(p_id_componente             => d_id_componente
                                ,p_progr_unita_organizzativa => d_progr_unor
                                ,p_dal                       => p_dal
                                ,p_al                        => p_al
                                ,p_ni                        => d_ni
                                ,p_ci                        => '' --d_ci
                                ,p_stato                     => 'D'
                                ,p_ottica                    => p_ottica
                                ,p_utente_aggiornamento      => p_utente_aggiornamento
                                ,p_data_aggiornamento        => p_data_aggiornamento);
                  --
                  --   Forza a funzionale il tipo assegnazione del nuovo componente
                  --
                  update attributi_componente
                     set tipo_assegnazione       = 'F'
                        ,assegnazione_prevalente = 33
                   where id_componente = d_id_componente;
                  --
                  --   Inserimento tabella RUOLI_COMPONENTE
                  --
                  ruolo_componente.ins(p_id_componente        => d_id_componente
                                      ,p_ruolo                => p_ruolo
                                      ,p_dal                  => p_dal
                                      ,p_al                   => p_al
                                      ,p_utente_aggiornamento => p_utente_aggiornamento
                                      ,p_data_aggiornamento   => p_data_aggiornamento);
               exception
                  when others then
                     p_segnalazione := sqlerrm;
                     raise d_errore;
               end;
            end if;
         else
            exit;
         end if;
      end loop;
   exception
      when d_errore then
         rollback;
         p_segnalazione_bloccante := 'Y';
   end; -- componenti.ins_ass_singola;
   --------------------------------------------------------------------------------
   procedure ins_ass_funzionali
   (
      p_ottica                 in componenti.ottica%type
     ,p_stringa_unor_inp       in varchar2
     ,p_stringa_comp           in varchar2
     ,p_dal                    in componenti.dal%type
     ,p_al                     in componenti.al%type
     ,p_stringa_unor_out       in varchar2
     ,p_ruolo                  in ruoli_componente.ruolo%type
     ,p_data_aggiornamento     in componenti.data_aggiornamento%type
     ,p_utente_aggiornamento   in componenti.utente_aggiornamento%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        ins_ass_funzionali
       DESCRIZIONE: Inserimento di un'assegnazione funzionale partendo da un'altra
                    assegnazione, con relativo ruolo
       PARAMETRI:   p_ottica
                    p_stringa_unor_inp
                    p_stringa_comp
                    p_dal
                    p_al
                    p_stringa_unor_out
                    p_ruolo
                    p_data_aggiornamento
                    p_utente_aggiornamento
                    p_segnalazione_bloccante
                    p_segnalazione
       NOTE:        --
      ******************************************************************************/
      d_revisione_mod revisioni_struttura.revisione%type;
      d_id_componente componenti.id_componente%type;
      d_progr_unor    componenti.progr_unita_organizzativa%type;
      d_inizio        number;
      d_lunghezza     number;
      d_count         number; --#486
      d_errore exception;
   begin
      d_revisione_mod          := revisione_struttura.get_revisione_mod(p_ottica);
      d_inizio                 := 0;
      d_lunghezza              := 0;
      d_count                  := 1;
      p_segnalazione_bloccante := 'N'; --#655
      p_segnalazione           := 'Operazione completata';
      loop
         d_inizio     := d_inizio + d_lunghezza + 1;
         d_lunghezza  := to_number(instr(p_stringa_unor_inp, ',', 1, d_count) - 1) -
                         d_inizio + 1;
         d_progr_unor := to_number(substr(p_stringa_unor_inp, d_inizio, d_lunghezza));
         if d_progr_unor is not null then
            for comp in (select id_componente
                           from componenti
                          where ottica = p_ottica
                            and progr_unita_organizzativa = d_progr_unor
                            and nvl(revisione_assegnazione, -2) != d_revisione_mod
                            and p_dal between dal and
                                nvl(decode(nvl(revisione_cessazione, -2)
                                          ,d_revisione_mod
                                          ,to_date(null)
                                          ,al)
                                   ,to_date(3333333, 'j')))
            loop
               ins_ass_singola(comp.id_componente
                              ,p_ottica
                              ,p_dal
                              ,p_al
                              ,p_stringa_unor_out
                              ,p_ruolo
                              ,p_utente_aggiornamento
                              ,p_data_aggiornamento
                              ,p_segnalazione_bloccante
                              ,p_segnalazione);
            end loop;
            d_count := d_count + 1;
         else
            exit;
         end if;
      end loop;
      --
      d_inizio    := 0;
      d_lunghezza := 0;
      d_count     := 1;
      loop
         d_inizio        := d_inizio + d_lunghezza + 1;
         d_lunghezza     := to_number(instr(p_stringa_comp, ',', 1, d_count) - 1) -
                            d_inizio + 1;
         d_id_componente := to_number(substr(p_stringa_comp, d_inizio, d_lunghezza));
         if d_id_componente is not null then
            ins_ass_singola(d_id_componente
                           ,p_ottica
                           ,p_dal
                           ,p_al
                           ,p_stringa_unor_out
                           ,p_ruolo
                           ,p_utente_aggiornamento
                           ,p_data_aggiornamento
                           ,p_segnalazione_bloccante
                           ,p_segnalazione);
            d_count := d_count + 1;
         else
            exit;
         end if;
      end loop;
      if p_segnalazione_bloccante = 'Y' then
         --#655
         p_segnalazione := 'Operazione terminata con errori. ' || p_segnalazione;
      end if;
   exception
      when d_errore then
         rollback;
         p_segnalazione_bloccante := 'Y';
   end; -- componente.conferma_incarico;
   --------------------------------------------------------------------------------
   function attivazione_conferma_incarico(p_id_componente in componenti.id_componente%type)
      return varchar2 is
      d_attiva             varchar2(2) := 'SI';
      d_ottica             componenti.ottica%type;
      d_data_revisione_mod revisioni_struttura.dal%type;
   begin
      begin
         -- il registro deve essere attivo
         if nvl(registro_utility.leggi_stringa('PRODUCTS/SO4'
                                              ,'ConfermaIncarichiDirigenziali'
                                              ,0)
               ,'NO') = 'NO' then
            d_attiva := 'NO';
         end if;
         -- il componente deve essere presente
         if d_attiva = 'SI' and p_id_componente is null then
            d_attiva := 'NO';
         end if;
         -- deve esistere una revisione in modifica con decorrenza non nulla
         if d_attiva = 'SI' then
            d_ottica             := get_ottica(p_id_componente);
            d_data_revisione_mod := revisione_struttura.get_dal(d_ottica
                                                               ,revisione_struttura.get_revisione_mod(d_ottica));
            if d_data_revisione_mod is null then
               d_attiva := 'NO';
            end if;
         end if;
         -- il periodo di assegnazione comprende la data della revisione in modifica
         if d_attiva = 'SI' then
            if d_data_revisione_mod not between get_dal(p_id_componente) and
               nvl(get_al(p_id_componente), to_date(3333333, 'j')) or
               get_revisione_assegnazione(p_id_componente) =
               revisione_struttura.get_revisione_mod(d_ottica) then
               d_attiva := 'NO';
            end if;
         end if;
         -- il componente deve avere una assegnazione istituzionale
         if d_attiva = 'SI' and nvl(attributo_componente.get_tipo_assegnazione(attributo_componente.get_id_attr_componente(p_id_componente
                                                                                                                          ,get_dal(p_id_componente)))
                                   ,'I') <> 'I' then
            d_attiva := 'NO';
         end if;
         -- il componente deve avere un incarico di responsabile
         if d_attiva = 'SI' and nvl(tipo_incarico.get_responsabile(attributo_componente.get_incarico_valido(p_id_componente
                                                                                                           ,d_data_revisione_mod
                                                                                                           ,d_ottica))
                                   ,'NO') = 'NO' then
            d_attiva := 'NO';
         end if;
         return d_attiva;
      exception
         when others then
            return 'NO';
      end;
   end;
   --------------------------------------------------------------------------------
   procedure conferma_incarico
   (
      p_id_componente          in componenti.id_componente%type
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        conferma_incarico
       DESCRIZIONE: esegue una storicizzazione fittizia dell'incarico del componente
                    per creare una decorrenza alla revisione in modifica dell'ottica
       PARAMETRI:   p_id_componente
                    p_segnalazione_bloccante
                    p_segnalazione
       NOTE:        --
      ******************************************************************************/
      d_revisione_mod           revisioni_struttura.revisione%type;
      d_data_revisione_mod      revisioni_struttura.dal%type;
      d_ottica                  componenti.ottica%type := get_ottica(p_id_componente);
      d_al                      componenti.al%type := get_al(p_id_componente);
      d_id_componente           componenti.id_componente%type;
      d_atco                    attributi_componente%rowtype;
      d_assegnazione_prevalente attributi_componente.assegnazione_prevalente%type;
      d_errore exception;
   begin
      if attivazione_conferma_incarico(p_id_componente) = 'SI' then
         d_revisione_mod      := revisione_struttura.get_revisione_mod(d_ottica);
         d_data_revisione_mod := revisione_struttura.get_dal(d_ottica, d_revisione_mod);
         -- elimino i periodi di attributi_componente con decorrenza futura rispetto alla data di proroga
         delete from attributi_componente
          where id_componente = p_id_componente
            and dal > d_data_revisione_mod;
         -- chiudo il periodo di attributi_componente la data della revisione in modifica; in cascata vengono chiusi
         update attributi_componente
            set al                   = d_data_revisione_mod - 1
               ,revisione_cessazione = d_revisione_mod
          where id_componente = p_id_componente
            and d_data_revisione_mod between dal and nvl(al, to_date(3333333, 'j'));
         -- inserisco la conferma dell'incarico alla data della revisione in modifica
         select *
           into d_atco
           from attributi_componente
          where id_componente = p_id_componente
            and al = d_data_revisione_mod - 1;
         select decode(d_atco.assegnazione_prevalente, 1, 11, 12, 11, 2, 21, 22, 21)
           into d_assegnazione_prevalente
           from dual;
         -- inserisco ruoli_componente
         attributo_componente.ins(p_id_componente           => p_id_componente
                                 ,p_dal                     => d_data_revisione_mod
                                 ,p_incarico                => d_atco.incarico
                                 ,p_assegnazione_prevalente => d_assegnazione_prevalente
                                 ,p_tipo_assegnazione       => d_atco.tipo_assegnazione
                                 ,p_percentuale_impiego     => d_atco.percentuale_impiego
                                 ,p_ottica                  => d_atco.ottica
                                 ,p_revisione_assegnazione  => d_revisione_mod
                                 ,p_gradazione              => d_atco.gradazione
                                 ,p_voto                    => d_atco.voto);
         p_segnalazione           := 'Conferma dell''incarico eseguita alla data ' ||
                                     to_char(d_data_revisione_mod, 'dd/mm/yyyy');
         p_segnalazione_bloccante := 'N';
         commit;
      else
         p_segnalazione := 'Non sussistono le condizione per confermare l''incarico';
         raise d_errore;
      end if;
   exception
      when d_errore then
         rollback;
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := p_segnalazione || '; ' ||
                                     'Conferma incarico di respnsabilita'' fallita';
      when others then
         rollback;
         p_segnalazione_bloccante := 'Y';
         p_segnalazione           := p_segnalazione || '; ' ||
                                     'Conferma incarico di responsabilita'' fallita';
   end; -- componente.conferma_incarico;
   --------------------------------------------------------------------------------
   procedure attribuzione_ruoli
   (
      p_id_componente          in componenti.id_componente%type
     ,p_dal                    in date default null
     ,p_al                     in date default null
     ,p_tipo_variazione        in number default 1
     ,p_segnalazione_bloccante out varchar2
     ,p_segnalazione           out varchar2
   ) is
      /******************************************************************************
       NOME:        attribuzione_ruoli #634
       DESCRIZIONE: attribuisce i ruoli applicativi automatici in base alle regole definite
       NOTE:        p_tipo identifica la tipologia di modifica subita dal componente:
                    1 : inserimento o modifica su COMPONENTI
                    2 : inserimento o modifica su ATTRIBUTI_COMPONENTE
                    3 : modifiche a TIPI_INCARICO
                    4 : modifiche a ANAGRAFE_UNITA_ORGANIZZATIVE (codice_uo, suddivisione)
                    5 : modifiche a UNITA_ORGANIZZATIVE (relazioni gerarchiche)
      ******************************************************************************/
      d_codice_uo           anagrafe_unita_organizzative.codice_uo%type;
      d_progr               anagrafe_unita_organizzative.progr_unita_organizzativa%type;
      d_ottica              componenti.ottica%type;
      d_suddivisione        suddivisioni_struttura.suddivisione%type;
      d_id_componente       componenti.id_componente%type;
      d_id_ruolo_componente ruoli_componente.id_ruolo_componente%type;
      d_incarico            attributi_componente.incarico%type;
      d_tipo_assegnazione   attributi_componente.tipo_assegnazione%type;
      d_responsabile        tipi_incarico.responsabile%type;
      d_modulo              ad4_diritti_accesso.modulo%type;
      d_istanza             ad4_diritti_accesso.istanza%type;
      d_ruolo_accesso       ad4_diritti_accesso.ruolo%type;
      d_dal                 componenti.dal%type;
      d_al                  componenti.al%type;
      d_ci                  componenti.ci%type;
      is_dipendente         varchar2(2) := 'NO';
      d_oggi                date := trunc(sysdate);
      d_errore exception;
   begin
      ruolo_componente.s_ruoli_automatici := 1;
      p_segnalazione_bloccante            := 'N';
      -- determinazione degli attributi del componente per la verifica delle regole
      -- attributi del componente
      begin
         select c.progr_unita_organizzativa
               ,c.ottica
               ,greatest(nvl(p_dal, c.dal), c.dal)
               ,nvl(p_al, c.al)
               ,ci
           into d_progr
               ,d_ottica
               ,d_dal
               ,d_al
               ,d_ci
           from componenti c
          where c.id_componente = p_id_componente;
      exception
         when others then
            p_segnalazione_bloccante := 'Y';
            p_segnalazione           := 'Componente non determinabile';
      end;
      -- attributi dell'UO
      if p_segnalazione_bloccante = 'N' then
         begin
            select a.codice_uo
                  ,suddivisione_struttura.get_suddivisione(a.id_suddivisione) suddivisione --#45841
              into d_codice_uo
                  ,d_suddivisione
              from anagrafe_unita_organizzative a
             where a.progr_unita_organizzativa = d_progr
               and nvl(d_dal, d_oggi) between a.dal and nvl(a.al, to_date(3333333, 'j'))
               and a.ottica = d_ottica;
         exception
            when others then
               p_segnalazione_bloccante := 'Y';
               p_segnalazione           := 'UO non determinabile';
         end;
      end if;
      -- attributi dell'incarico
      if p_segnalazione_bloccante = 'N' then
         begin
            select a.incarico
                  ,nvl(i.responsabile, 'NO')
                  ,a.tipo_assegnazione
              into d_incarico
                  ,d_responsabile
                  ,d_tipo_assegnazione
              from attributi_componente a
                  ,tipi_incarico        i
             where a.id_componente = p_id_componente
               and a.dal <= nvl(a.al, to_date(3333333, 'j'))
               and nvl(d_dal, d_oggi) between a.dal and nvl(a.al, to_date(3333333, 'j'))
               and a.incarico = i.incarico;
         exception
            when no_data_found then
               begin
                  select a.incarico
                        ,nvl(i.responsabile, 'NO')
                    into d_incarico
                        ,d_responsabile
                    from attributi_componente a
                        ,tipi_incarico        i
                   where a.id_componente = p_id_componente
                     and a.dal <= nvl(a.al, to_date(3333333, 'j'))
                     and a.dal = (select max(dal)
                                    from attributi_componente
                                   where id_componente = p_id_componente
                                     and dal <= nvl(al, to_date(3333333, 'j')))
                     and a.incarico = i.incarico;
               exception
                  when others then
                     p_segnalazione_bloccante := 'Y';
                     p_segnalazione           := 'Incarico non determinabile';
               end;
            when others then
               p_segnalazione_bloccante := 'Y';
               p_segnalazione           := 'Incarico non determinabile';
         end;
      end if;
      if d_ci is not null and d_tipo_assegnazione like 'I%' then
         --#767
         is_dipendente := 'SI';
      end if;
      -- verifica quali regole possono essere interessate dalla variazione
      for reru in (select *
                     from relazioni_ruoli r
                    where r.data_eliminazione is null
                      and (p_tipo_variazione = 1 or
                          (p_tipo_variazione = 2 and
                          (incarico <> '%' or responsabile <> '%')) or
                          (p_tipo_variazione = 3 and responsabile <> '%') or
                          (p_tipo_variazione = 4 and
                          (r.codice_uo <> '%' or r.suddivisione <> '%')) or
                          (p_tipo_variazione = 5 and r.uo_discendenti = 'SI'))
                    order by r.id_relazione)
      loop
         -- verifica ed eventuale chiusura dei ruoli non piu' previsti per il componente
         begin
            for ruco in (select rc.id_ruolo_componente
                               ,rc.dal
                               ,rc.al
                               ,rd.id_relazione
                               ,rd.id_ruolo_derivato
                               ,rc.data_aggiornamento
                           from ruoli_componente rc
                               ,ruoli_derivati   rd
                          where rc.id_componente = p_id_componente
                            and rd.id_ruolo_componente = rc.id_ruolo_componente
                            and rd.id_relazione = reru.id_relazione
                            and rc.dal <= nvl(rc.al, to_date(3333333, 'j'))
                            and nvl(rc.al, to_date(3333333, 'j')) >= d_oggi
                            and not exists
                          (select 'x'
                                   from relazioni_ruoli rr
                                  where rr.id_relazione = rd.id_relazione
                                    and d_ottica like rr.ottica
                                    and ((d_codice_uo like rr.codice_uo and
                                        rr.uo_discendenti = 'NO') or
                                        ((select nvl(max('SI'), 'NO')
                                             from dual
                                            where exists (select 'x'
                                                     from relazioni_unita_organizzative
                                                    where progr_figlio = d_progr
                                                      and cod_padre like rr.codice_uo
                                                      and al_figlio >= d_oggi)) =
                                        rr.uo_discendenti and rr.uo_discendenti = 'SI'))
                                    and (d_suddivisione like rr.suddivisione or
                                        rr.suddivisione = '%') --#45841
                                    and d_incarico like rr.incarico
                                    and d_responsabile like rr.responsabile
                                       -- and <verifica su istanza, modulo e ruolo di accesso>
                                    and is_dipendente like rr.dipendente)
                          order by rc.id_ruolo_componente)
            loop
               if ruco.dal > d_oggi or ruco.data_aggiornamento = d_oggi then
                  --eliminiamo fisicamente i ruoli non piu' dovuti con decorrenza futura
                  delete from ruoli_componente
                   where id_ruolo_componente = ruco.id_ruolo_componente;
                  delete from ruoli_derivati
                   where id_ruolo_derivato = ruco.id_ruolo_derivato;
               else
                  --chiudiamo i ruoli non piu' dovuti alla data della modifica
                  update ruoli_componente
                     set al = d_oggi
                   where id_ruolo_componente = ruco.id_ruolo_componente;
               end if;
            end loop;
         exception
            when no_data_found then
               null;
            when too_many_rows then
               null;
         end;
         -- attribuzione dei ruoli al componente
         for ra in (select r.ruolo
                          ,r.id_relazione
                      from relazioni_ruoli r
                     where r.id_relazione = reru.id_relazione
                       and d_ottica like r.ottica
                       and ((d_codice_uo like r.codice_uo and r.uo_discendenti = 'NO') or
                           ((select nvl(max('SI'), 'NO')
                                from dual
                               where exists (select 'x'
                                        from relazioni_unita_organizzative
                                       where progr_figlio = d_progr
                                         and cod_padre like r.codice_uo
                                         and al_figlio >= d_oggi)) = r.uo_discendenti and
                           r.uo_discendenti = 'SI'))
                       and (d_suddivisione like r.suddivisione or r.suddivisione = '%') --#45841
                       and d_incarico like r.incarico
                       and d_responsabile like r.responsabile
                          -- and <verifica su istanza, modulo e ruolo di accesso>
                       and is_dipendente like r.dipendente
                       and not exists
                     (select 'x'
                              from ruoli_derivati rd
                             where rd.id_relazione = r.id_relazione
                               and exists
                             (select 'x'
                                      from ruoli_componente rc
                                     where id_componente = p_id_componente
                                       and id_ruolo_componente = rd.id_ruolo_componente
                                       and rc.dal <= nvl(rc.al, to_date(3333333, 'j')))))
         loop
            -- attribuzione dei ruoli in base alle regole definite
            begin
               select ruoli_componente_sq.nextval into d_id_ruolo_componente from dual;
               --inserimento del ruolo_componente
               ruolo_componente.ins(p_id_ruolo_componente => d_id_ruolo_componente
                                   ,p_id_componente       => p_id_componente
                                   ,p_ruolo               => ra.ruolo
                                   ,p_dal                 => d_dal
                                   ,p_al                  => d_al);
               --inserimento del ruolo derivato
               ruoli_derivati_tpk.ins(p_id_ruolo_derivato   => ''
                                     ,p_id_ruolo_componente => d_id_ruolo_componente
                                     ,p_id_relazione        => ra.id_relazione);
            exception
               when others then
                  p_segnalazione           := 'Attribuzione ruoli automatici terminata con errori ' ||
                                              sqlerrm;
                  p_segnalazione_bloccante := 'Y';
            end;
         end loop;
      end loop;
      ruolo_componente.s_ruoli_automatici := 0;
      if p_segnalazione_bloccante = 'N' then
         p_segnalazione := 'Attribuzione ruoli automatici terminata con successo';
      else
         p_segnalazione := 'Attribuzione ruoli automatici terminata con errori ' ||
                           sqlerrm;
         raise d_errore;
      end if;
   exception
      when d_errore then
         ruolo_componente.s_ruoli_automatici := 0;
         p_segnalazione_bloccante            := 'Y';
         p_segnalazione                      := p_segnalazione || '; ' ||
                                                'Attribuzione ruoli fallita (1) ' ||
                                                sqlerrm;
      when others then
         ruolo_componente.s_ruoli_automatici := 0;
         p_segnalazione_bloccante            := 'Y';
         p_segnalazione                      := p_segnalazione || '; ' ||
                                                'Attribuzione ruoli fallita (2) ' ||
                                                sqlerrm;
   end; -- componente.conferma_incarico;
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
   end; -- componente.set_tipo_revisione
   --------------------------------------------------------------------------------
   function is_componente_eliminabile(p_id_componente in componenti.id_componente%type)
      return varchar2 is
      d_attiva varchar2(2) := 'SI';
      d_ottica componenti.ottica%type;
   begin
      begin
         -- il registro deve essere attivo
         if impostazione.get_integr_gp4(1) = 'SI' and
            componente.get_ci(p_id_componente) is not null then
            -- L'integrazione con gp4 è attiva e il CI non è nullo
            begin
               select 'NO'
                 into d_attiva
                 from attributi_componente a
                where id_componente = p_id_componente
                  and nvl(tipo_assegnazione, 'I') = 'I'
                  and assegnazione_prevalente like '1%'
                  and (dal = (select max(dal)
                                from attributi_componente
                               where id_componente = p_id_componente
                                 and dal <= nvl(al, to_date(3333333, 'j'))) or
                      nvl(revisione_assegnazione, -2) =
                      revisione_struttura.get_revisione_mod(ottica));
            exception
               when no_data_found then
                  null;
               when others then
                  d_attiva := 'SI';
            end;
         else
            d_attiva := 'SI';
         end if;
         return d_attiva;
      exception
         when others then
            return 'SI';
      end;
   end;
   --------------------------------------------------------------------------------
   function get_desc_comp_tree
   (
      p_id_componente        in componenti.id_componente%type
     ,p_revisione_modifica   in revisioni_struttura.revisione%type
     ,p_data_riferimento     in date
     ,p_visualizza_incarichi in varchar2
   ) return varchar2 is
      d_result             varchar2(4000) := null;
      d_ni                 componenti.ni%type := componente.get_ni(p_id_componente);
      d_dal_comp           componenti.dal%type := componente.get_dal(p_id_componente);
      d_al_comp            componenti.al%type := componente.get_al(p_id_componente);
      d_data_riferimento   date := nvl(p_data_riferimento
                                      ,so4_pkg.get_data_riferimento(componente.get_ottica(p_id_componente)));
      d_revisione_modifica revisioni_struttura.revisione%type := nvl(p_revisione_modifica
                                                                    ,revisione_struttura.get_revisione_mod(componente.get_ottica(p_id_componente)));
      d_descr_incarico     varchar2(2000) := null;
      d_dummy              varchar2(1);
   begin
      if d_ni is null then
         d_result := componente.get_denominazione(p_id_componente);
      else
         d_result := soggetti_get_descr(d_ni
                                       ,nvl(d_dal_comp, d_data_riferimento)
                                       ,'COGNOME E NOME');
      end if;
      if nvl(componente.get_revisione_cessazione(p_id_componente), -2) =
         d_revisione_modifica then
         d_result := d_result || '<img src="images/SUST_DELETE.GIF">';
      else
         if nvl(componente.get_revisione_assegnazione(p_id_componente), -2) =
            d_revisione_modifica then
            d_result := d_result || '<img src="images/SUST_MODIFY.GIF">';
         end if;
      end if;

      if nvl(p_visualizza_incarichi, 'NO') != 'NO' then
         begin
            d_descr_incarico := componente.get_descr_incarico(p_id_componente
                                                             ,d_data_riferimento);
         exception
            when no_data_found then
               begin
                  select tipo_incarico.get_descrizione(incarico)
                    into d_descr_incarico
                    from attributi_componente
                   where id_componente = p_id_componente
                     and revisione_cessazione = d_revisione_modifica
                     and nvl(dal, to_date('2222222', 'j')) >=
                         nvl(al, to_date('3333333', 'j'));
               exception
                  when no_data_found then
                     --#446
                     select tipo_incarico.get_descrizione(incarico)
                       into d_descr_incarico
                       from attributi_componente
                      where id_componente = p_id_componente
                        and dal = (select min(dal)
                                     from attributi_componente
                                    where id_componente = p_id_componente);
                  when others then
                     d_descr_incarico := 'Non determinato';
               end;
         end;
         d_result := d_result || ' - ' ||
                     nvl(d_descr_incarico, 'Incarico non determinato');
         if componente.get_se_resp_valido(p_id_componente, d_data_riferimento) = 'SI' then
            d_result := d_result || ' (Resp.)';
         end if;
      end if;

      begin
         --#189
         select 'x'
           into d_dummy
           from attributi_componente a
          where a.id_componente = p_id_componente
            and nvl(a.revisione_assegnazione, -2) = d_revisione_modifica
            and exists (select 'x'
                   from attributi_componente
                  where id_componente = p_id_componente
                    and nvl(revisione_cessazione, -2) = d_revisione_modifica
                    and incarico <> a.incarico)
            and d_result not like '%img src%';
         raise too_many_rows;
      exception
         when no_data_found then
            null;
         when too_many_rows then
            d_result := d_result || '<img src="images/SUST_MODIFY.GIF">' ||
                        ' Nuovo incarico: ' ||
                        get_descr_incarico_mod(p_id_componente, d_revisione_modifica);
      end;

      if (d_data_riferimento < nvl(d_dal_comp, d_data_riferimento) and
         (nvl(d_dal_comp, d_data_riferimento) > d_data_riferimento /*trunc(sysdate)*/ --#446
         )) then
         /*
          d_result := d_result || ' - dal ' || to_char(d_dal_comp, 'dd/mm/yyyy') ||
                      afc.decode_value(d_al_comp
                                      ,null
                                      ,' a tutt''oggi'
                                      ,' al ' || to_char(d_al_comp, 'dd/mm/yyyy'));
         */
         d_result := d_result || ' - dal ' || to_char(d_dal_comp, 'dd/mm/yyyy'); -- feedback #446
         if d_al_comp is null then
            if d_dal_comp <= trunc(sysdate) then
               d_result := d_result || ' a tutt''oggi';
            end if;
         else
            d_result := d_result || ' al ' || to_char(d_al_comp, 'dd/mm/yyyy');
         end if;
      end if;

      --#533
      if not (d_data_riferimento < nvl(d_dal_comp, d_data_riferimento) and
          (nvl(d_dal_comp, d_data_riferimento) > d_data_riferimento)) and
         nvl(d_al_comp, to_date(3333333, 'j')) <= trunc(sysdate) then
         d_result := d_result || ' - fino al ' || to_char(d_al_comp, 'dd/mm/yyyy');
      end if;

      return d_result;
   end;
   --------------------------------------------------------------------------------

   function is_componente_annullabile(p_id_componente in componenti.id_componente%type)
      return varchar2 is
      d_result                  varchar2(2);
      d_ni                      componenti.ni%type;
      d_dal                     componenti.dal%type;
      d_ottica                  componenti.ottica%type;
      d_progr_uo                componenti.progr_unita_organizzativa%type;
      d_assegnazione_prevalente attributi_componente.assegnazione_prevalente%type;
      --#572
   begin
      select ni
            ,dal
            ,ottica
            ,progr_unita_organizzativa
            ,(select assegnazione_prevalente
               from attributi_componente
              where id_componente = c.id_componente
                and c.dal between dal and nvl(al, to_date(3333333, 'j')))
      --     ,attributo_componente.get_assegnazione_corrente(id_componente, dal, ottica)
        into d_ni
            ,d_dal
            ,d_ottica
            ,d_progr_uo
            ,d_assegnazione_prevalente
        from componenti c
       where id_componente = p_id_componente;
      begin
         select 'SI'
           into d_result
           from componenti c
          where c.ni = d_ni
            and c.al = d_dal - 1
            and c.dal <= nvl(c.al, to_date(3333333, 'j'))
            and c.progr_unita_organizzativa != d_progr_uo
            and ottica = d_ottica
            and substr(d_assegnazione_prevalente, 1, 1) =
                (select substr(assegnazione_prevalente, 1, 1)
                   from attributi_componente
                  where id_componente = c.id_componente
                    and dal <= nvl(al, to_date(3333333, 'j'))
                    and dal = (select max(dal)
                                 from attributi_componente
                                where id_componente = c.id_componente
                                  and dal <= nvl(al, to_date(3333333, 'j'))));
         raise too_many_rows;
      exception
         when no_data_found then
            d_result := 'NO';
         when too_many_rows then
            d_result := 'SI';
      end;
      return d_result;
   end;
   --------------------------------------------------------------------------------

begin
   -- inserimento degli errori nella tabella
   s_error_table(s_dal_al_errato_number) := s_dal_al_errato_msg;
   s_error_table(s_dal_errato_number) := s_dal_errato_msg;
   s_error_table(s_dal_errato_ins_number) := s_dal_errato_ins_msg;
   s_error_table(s_al_errato_number) := s_al_errato_msg;
   s_error_table(s_componenti_istituiti_number) := s_componenti_istituiti_msg;
   s_error_table(s_componenti_cessati_number) := s_componenti_cessati_msg;
   s_error_table(s_ass_prev_assente_number) := s_ass_prev_assente_msg;
   s_error_table(s_ass_prev_multiple_number) := s_ass_prev_multiple_msg;
   s_error_table(s_componente_non_ass_number) := s_componente_non_ass_msg;
   s_error_table(s_componente_gia_pres_number) := s_componente_gia_pres_msg;
   s_error_table(s_revisioni_errate_num) := s_revisioni_errate_msg;
   s_error_table(s_data_inizio_mancante_num) := s_data_inizio_mancante_msg;
   s_error_table(s_uo_non_valida_num) := s_uo_non_valida_msg;
   --   s_error_table(s_assegnazione_ripetuta_num) := s_assegnazione_ripetuta_msg;
   s_error_table(s_modifica_retroattiva_num) := s_modifica_retroattiva_msg;
   s_error_table(s_err_set_fi_num) := s_err_set_fi_msg;
end componente;
/

