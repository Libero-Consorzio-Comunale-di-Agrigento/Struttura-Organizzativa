CREATE OR REPLACE package body anagrafe_unita_fisica is
   /******************************************************************************
    NOME:        anagrafe_unita_fisica
    DESCRIZIONE: Gestione tabella anagrafe_unita_fisiche.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore    Descrizione.
    000   25/10/2007  VDAVALLI  Prima emissione.
    001   27/08/2009  VDAVALLI  Modifiche per configurazione master/slave
    002   13/08/2012  MMONARI   Revisione complessiva struttura fisica
    003   21/09/2012  VDAVALLI  Aggiunta gestione CHECK_DI
    004   02/01/2013  ADADAMO   Redmine Feature #145: Aggiunta get_uo_competenza
    005   19/02/2014  ADADAMO   Aggiunta funzione is_assegnabile_ok e modificate
                                chiamate a funzioni chk_ri e is_ri_ok Bug#387
          16/05/2014  MMONARI   Corretta is_ri_ok issue #450
          05/06/2014  ADADAMO   Aggiunta is_unita_in_struttura richiamata da
                                interfaccia per abilitare le assegnazioni fisiche
                                Bug#386                    
   ******************************************************************************/

   s_revisione_body constant afc.t_revision := '005';
   s_error_table afc_error.t_error_table;
   s_dummy       varchar2(1);

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
   end versione; -- anagrafe_unita_fisica.versione

   --------------------------------------------------------------------------------

   function pk
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return t_pk is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        PK
       DESCRIZIONE: Costruttore di un t_PK dati gli attributi della chiave
      ******************************************************************************/
      d_result t_pk;
   begin
   
      d_result.progr_unita_fisica := p_progr_unita_fisica;
      d_result.dal                := p_dal;
      dbc.pre(not dbc.preon or canhandle(d_result.progr_unita_fisica, d_result.dal)
             ,'canHandle on anagrafe_unita_fisica.PK');
      return d_result;
   
   end pk; -- end anagrafe_unita_fisica.PK

   --------------------------------------------------------------------------------

   function can_handle
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return number is
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
      if d_result = 1 and (p_progr_unita_fisica is null or p_dal is null) then
         d_result := 0;
      end if;
   
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on anagrafe_unita_fisica.can_handle');
   
      return d_result;
   
   end can_handle; -- anagrafe_unita_fisica.can_handle

   --------------------------------------------------------------------------------

   function canhandle
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        canHandle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: true se la chiave è manipolabile, false altrimenti.
       NOTE:        Wrapper boolean di can_handle (cfr. can_handle).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(can_handle(p_progr_unita_fisica, p_dal));
   begin
      return d_result;
   end canhandle; -- anagrafe_unita_fisica.canHandle

   --------------------------------------------------------------------------------

   function exists_id
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
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
   
      dbc.pre(not dbc.preon or canhandle(p_progr_unita_fisica, p_dal)
             ,'canHandle on anagrafe_unita_fisica.exists_id');
   
      begin
         select 1
           into d_result
           from anagrafe_unita_fisiche
          where progr_unita_fisica = p_progr_unita_fisica
            and dal = p_dal;
      exception
         when no_data_found then
            d_result := 0;
      end;
   
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on anagrafe_unita_fisica.exists_id');
   
      return d_result;
   end exists_id; -- anagrafe_unita_fisica.exists_id

   --------------------------------------------------------------------------------

   function existsid
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        existsId
       DESCRIZIONE: Esistenza riga con chiave indicata.
       NOTE:        Wrapper boolean di exists_id (cfr. exists_id).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(exists_id(p_progr_unita_fisica, p_dal));
   begin
      return d_result;
   end existsid; -- anagrafe_unita_fisica.existsId

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
   end; -- anagrafe_unita_fisica.error_message
   --------------------------------------------------------------------------------

   procedure ins
   (
      p_progr_unita_fisica   in anagrafe_unita_fisiche.progr_unita_fisica%type default null
     ,p_dal                  in anagrafe_unita_fisiche.dal%type
     ,p_codice_uf            in anagrafe_unita_fisiche.codice_uf%type
     ,p_denominazione        in anagrafe_unita_fisiche.denominazione%type
     ,p_denominazione_al1    in anagrafe_unita_fisiche.denominazione_al1%type default null
     ,p_denominazione_al2    in anagrafe_unita_fisiche.denominazione_al2%type default null
     ,p_des_abb              in anagrafe_unita_fisiche.des_abb%type default null
     ,p_des_abb_al1          in anagrafe_unita_fisiche.des_abb_al1%type default null
     ,p_des_abb_al2          in anagrafe_unita_fisiche.des_abb_al2%type default null
     ,p_indirizzo            in anagrafe_unita_fisiche.indirizzo%type default null
     ,p_cap                  in anagrafe_unita_fisiche.cap%type default null
     ,p_provincia            in anagrafe_unita_fisiche.provincia%type default null
     ,p_comune               in anagrafe_unita_fisiche.comune%type default null
     ,p_nota_indirizzo       in anagrafe_unita_fisiche.nota_indirizzo%type default null
     ,p_nota_indirizzo_al1   in anagrafe_unita_fisiche.nota_indirizzo_al1%type default null
     ,p_nota_indirizzo_al2   in anagrafe_unita_fisiche.nota_indirizzo_al2%type default null
     ,p_amministrazione      in anagrafe_unita_fisiche.amministrazione%type
     ,p_id_suddivisione      in anagrafe_unita_fisiche.id_suddivisione%type default null
     ,p_generico             in anagrafe_unita_fisiche.generico%type default null
     ,p_al                   in anagrafe_unita_fisiche.al%type default null
     ,p_utente_aggiornamento in anagrafe_unita_fisiche.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in anagrafe_unita_fisiche.data_aggiornamento%type default null
     ,p_capienza             in anagrafe_unita_fisiche.capienza%type default null
     ,p_assegnabile          in anagrafe_unita_fisiche.assegnabile%type default null
     ,p_note                 in anagrafe_unita_fisiche.note%type default null
     ,p_numero_civico        in anagrafe_unita_fisiche.numero_civico%type default null
     ,p_esponente_civico_1   in anagrafe_unita_fisiche.esponente_civico_1%type default null
     ,p_esponente_civico_2   in anagrafe_unita_fisiche.esponente_civico_2%type default null
     ,p_tipo_civico          in anagrafe_unita_fisiche.tipo_civico%type default null
     ,p_id_documento         in anagrafe_unita_fisiche.id_documento%type default null
     ,p_link_planimetria     in anagrafe_unita_fisiche.link_planimetria%type default null
   ) is
      /******************************************************************************
       NOME:        ins
       DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
       PARAMETRI:   Chiavi e attributi della table.
      ******************************************************************************/
   begin
   
      dbc.pre(not dbc.preon or p_codice_uf is not null or /*default value*/
              '' is not null
             ,'p_codice_uf on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_denominazione is not null or /*default value*/
              '' is not null
             ,'p_denominazione on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_denominazione_al1 is not null or /*default value*/
              'default' is not null
             ,'p_denominazione_al1 on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_denominazione_al2 is not null or /*default value*/
              'default' is not null
             ,'p_denominazione_al2 on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_des_abb is not null or /*default value*/
              'default' is not null
             ,'p_des_abb on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_des_abb_al1 is not null or /*default value*/
              'default' is not null
             ,'p_des_abb_al1 on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_des_abb_al2 is not null or /*default value*/
              'default' is not null
             ,'p_des_abb_al2 on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_indirizzo is not null or /*default value*/
              'default' is not null
             ,'p_indirizzo on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_cap is not null or /*default value*/
              'default' is not null
             ,'p_cap on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_provincia is not null or /*default value*/
              'default' is not null
             ,'p_provincia on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_comune is not null or /*default value*/
              'default' is not null
             ,'p_comune on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_nota_indirizzo is not null or /*default value*/
              'default' is not null
             ,'p_nota_indirizzo on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_nota_indirizzo_al1 is not null or /*default value*/
              'default' is not null
             ,'p_nota_indirizzo_al1 on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_nota_indirizzo_al2 is not null or /*default value*/
              'default' is not null
             ,'p_nota_indirizzo_al2 on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_amministrazione is not null or /*default value*/
              '' is not null
             ,'p_amministrazione on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_id_suddivisione is not null or /*default value*/
              'default' is not null
             ,'p_id_suddivisione on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_generico is not null or /*default value*/
              'default' is not null
             ,'p_generico on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_al is not null or /*default value*/
              'default' is not null
             ,'p_al on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_utente_aggiornamento is not null or /*default value*/
              'default' is not null
             ,'p_utente_aggiornamento on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_data_aggiornamento is not null or /*default value*/
              'default' is not null
             ,'p_data_aggiornamento on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_capienza is not null or /*default value*/
              'default' is not null
             ,'p_capienza on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_assegnabile is not null or /*default value*/
              'default' is not null
             ,'p_assegnabile on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_note is not null or /*default value*/
              'default' is not null
             ,'p_note on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_numero_civico is not null or /*default value*/
              'default' is not null
             ,'p_numero_civico on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_esponente_civico_1 is not null or /*default value*/
              'default' is not null
             ,'p_esponente_civico_1 on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_esponente_civico_2 is not null or /*default value*/
              'default' is not null
             ,'p_esponente_civico_2 on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_tipo_civico is not null or /*default value*/
              'default' is not null
             ,'p_tipo_civico on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_id_documento is not null or /*default value*/
              'default' is not null
             ,'p_id_documento on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_link_planimetria is not null or /*default value*/
              'default' is not null
             ,'p_link_planimetria on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or (p_progr_unita_fisica is null and /*default value*/
              'default null' is not null) -- PK nullable on insert
              or (p_dal is null and /*default value*/
              '' is not null) -- PK nullable on insert
              or
              not existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'not existsId on anagrafe_unita_fisica.ins');
      insert into anagrafe_unita_fisiche
         (progr_unita_fisica
         ,dal
         ,codice_uf
         ,denominazione
         ,denominazione_al1
         ,denominazione_al2
         ,des_abb
         ,des_abb_al1
         ,des_abb_al2
         ,indirizzo
         ,cap
         ,provincia
         ,comune
         ,nota_indirizzo
         ,nota_indirizzo_al1
         ,nota_indirizzo_al2
         ,amministrazione
         ,id_suddivisione
         ,generico
         ,al
         ,utente_aggiornamento
         ,data_aggiornamento
         ,capienza
         ,assegnabile
         ,note
         ,numero_civico
         ,esponente_civico_1
         ,esponente_civico_2
         ,tipo_civico
         ,id_documento
         ,link_planimetria)
      values
         (p_progr_unita_fisica
         ,p_dal
         ,p_codice_uf
         ,p_denominazione
         ,p_denominazione_al1
         ,p_denominazione_al2
         ,p_des_abb
         ,p_des_abb_al1
         ,p_des_abb_al2
         ,p_indirizzo
         ,p_cap
         ,p_provincia
         ,p_comune
         ,p_nota_indirizzo
         ,p_nota_indirizzo_al1
         ,p_nota_indirizzo_al2
         ,p_amministrazione
         ,p_id_suddivisione
         ,p_generico
         ,p_al
         ,p_utente_aggiornamento
         ,p_data_aggiornamento
         ,p_capienza
         ,p_assegnabile
         ,p_note
         ,p_numero_civico
         ,p_esponente_civico_1
         ,p_esponente_civico_2
         ,p_tipo_civico
         ,p_id_documento
         ,p_link_planimetria);
   end ins; -- anagrafe_unita_fisica.ins
   --------------------------------------------------------------------------------
   function ins
   (
      p_progr_unita_fisica   in anagrafe_unita_fisiche.progr_unita_fisica%type default null
     ,p_dal                  in anagrafe_unita_fisiche.dal%type
     ,p_codice_uf            in anagrafe_unita_fisiche.codice_uf%type
     ,p_denominazione        in anagrafe_unita_fisiche.denominazione%type
     ,p_denominazione_al1    in anagrafe_unita_fisiche.denominazione_al1%type default null
     ,p_denominazione_al2    in anagrafe_unita_fisiche.denominazione_al2%type default null
     ,p_des_abb              in anagrafe_unita_fisiche.des_abb%type default null
     ,p_des_abb_al1          in anagrafe_unita_fisiche.des_abb_al1%type default null
     ,p_des_abb_al2          in anagrafe_unita_fisiche.des_abb_al2%type default null
     ,p_indirizzo            in anagrafe_unita_fisiche.indirizzo%type default null
     ,p_cap                  in anagrafe_unita_fisiche.cap%type default null
     ,p_provincia            in anagrafe_unita_fisiche.provincia%type default null
     ,p_comune               in anagrafe_unita_fisiche.comune%type default null
     ,p_nota_indirizzo       in anagrafe_unita_fisiche.nota_indirizzo%type default null
     ,p_nota_indirizzo_al1   in anagrafe_unita_fisiche.nota_indirizzo_al1%type default null
     ,p_nota_indirizzo_al2   in anagrafe_unita_fisiche.nota_indirizzo_al2%type default null
     ,p_amministrazione      in anagrafe_unita_fisiche.amministrazione%type
     ,p_id_suddivisione      in anagrafe_unita_fisiche.id_suddivisione%type default null
     ,p_generico             in anagrafe_unita_fisiche.generico%type default null
     ,p_al                   in anagrafe_unita_fisiche.al%type default null
     ,p_utente_aggiornamento in anagrafe_unita_fisiche.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in anagrafe_unita_fisiche.data_aggiornamento%type default null
     ,p_capienza             in anagrafe_unita_fisiche.capienza%type default null
     ,p_assegnabile          in anagrafe_unita_fisiche.assegnabile%type default null
     ,p_note                 in anagrafe_unita_fisiche.note%type default null
     ,p_numero_civico        in anagrafe_unita_fisiche.numero_civico%type default null
     ,p_esponente_civico_1   in anagrafe_unita_fisiche.esponente_civico_1%type default null
     ,p_esponente_civico_2   in anagrafe_unita_fisiche.esponente_civico_2%type default null
     ,p_tipo_civico          in anagrafe_unita_fisiche.tipo_civico%type default null
     ,p_id_documento         in anagrafe_unita_fisiche.id_documento%type default null
     ,p_link_planimetria     in anagrafe_unita_fisiche.link_planimetria%type default null
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
   
      dbc.pre(not dbc.preon or p_codice_uf is not null or /*default value*/
              '' is not null
             ,'p_codice_uf on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_denominazione is not null or /*default value*/
              '' is not null
             ,'p_denominazione on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_denominazione_al1 is not null or /*default value*/
              'default' is not null
             ,'p_denominazione_al1 on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_denominazione_al2 is not null or /*default value*/
              'default' is not null
             ,'p_denominazione_al2 on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_des_abb is not null or /*default value*/
              'default' is not null
             ,'p_des_abb on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_des_abb_al1 is not null or /*default value*/
              'default' is not null
             ,'p_des_abb_al1 on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_des_abb_al2 is not null or /*default value*/
              'default' is not null
             ,'p_des_abb_al2 on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_indirizzo is not null or /*default value*/
              'default' is not null
             ,'p_indirizzo on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_cap is not null or /*default value*/
              'default' is not null
             ,'p_cap on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_provincia is not null or /*default value*/
              'default' is not null
             ,'p_provincia on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_comune is not null or /*default value*/
              'default' is not null
             ,'p_comune on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_nota_indirizzo is not null or /*default value*/
              'default' is not null
             ,'p_nota_indirizzo on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_nota_indirizzo_al1 is not null or /*default value*/
              'default' is not null
             ,'p_nota_indirizzo_al1 on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_nota_indirizzo_al2 is not null or /*default value*/
              'default' is not null
             ,'p_nota_indirizzo_al2 on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_amministrazione is not null or /*default value*/
              '' is not null
             ,'p_amministrazione on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_id_suddivisione is not null or /*default value*/
              'default' is not null
             ,'p_id_suddivisione on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_generico is not null or /*default value*/
              'default' is not null
             ,'p_generico on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_al is not null or /*default value*/
              'default' is not null
             ,'p_al on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_utente_aggiornamento is not null or /*default value*/
              'default' is not null
             ,'p_utente_aggiornamento on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_data_aggiornamento is not null or /*default value*/
              'default' is not null
             ,'p_data_aggiornamento on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_capienza is not null or /*default value*/
              'default' is not null
             ,'p_capienza on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_assegnabile is not null or /*default value*/
              'default' is not null
             ,'p_assegnabile on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_note is not null or /*default value*/
              'default' is not null
             ,'p_note on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_numero_civico is not null or /*default value*/
              'default' is not null
             ,'p_numero_civico on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_esponente_civico_1 is not null or /*default value*/
              'default' is not null
             ,'p_esponente_civico_1 on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_esponente_civico_2 is not null or /*default value*/
              'default' is not null
             ,'p_esponente_civico_2 on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_tipo_civico is not null or /*default value*/
              'default' is not null
             ,'p_tipo_civico on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_id_documento is not null or /*default value*/
              'default' is not null
             ,'p_id_documento on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or p_link_planimetria is not null or /*default value*/
              'default' is not null
             ,'p_link_planimetria on anagrafe_unita_fisica.ins');
      dbc.pre(not dbc.preon or (p_progr_unita_fisica is null and /*default value*/
              'default null' is not null) -- PK nullable on insert
              or (p_dal is null and /*default value*/
              '' is not null) -- PK nullable on insert
              or
              not existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'not existsId on anagrafe_unita_fisica.ins');
      insert into anagrafe_unita_fisiche
         (progr_unita_fisica
         ,dal
         ,codice_uf
         ,denominazione
         ,denominazione_al1
         ,denominazione_al2
         ,des_abb
         ,des_abb_al1
         ,des_abb_al2
         ,indirizzo
         ,cap
         ,provincia
         ,comune
         ,nota_indirizzo
         ,nota_indirizzo_al1
         ,nota_indirizzo_al2
         ,amministrazione
         ,id_suddivisione
         ,generico
         ,al
         ,utente_aggiornamento
         ,data_aggiornamento
         ,capienza
         ,assegnabile
         ,note
         ,numero_civico
         ,esponente_civico_1
         ,esponente_civico_2
         ,tipo_civico
         ,id_documento
         ,link_planimetria)
      values
         (p_progr_unita_fisica
         ,p_dal
         ,p_codice_uf
         ,p_denominazione
         ,p_denominazione_al1
         ,p_denominazione_al2
         ,p_des_abb
         ,p_des_abb_al1
         ,p_des_abb_al2
         ,p_indirizzo
         ,p_cap
         ,p_provincia
         ,p_comune
         ,p_nota_indirizzo
         ,p_nota_indirizzo_al1
         ,p_nota_indirizzo_al2
         ,p_amministrazione
         ,p_id_suddivisione
         ,p_generico
         ,p_al
         ,p_utente_aggiornamento
         ,p_data_aggiornamento
         ,p_capienza
         ,p_assegnabile
         ,p_note
         ,p_numero_civico
         ,p_esponente_civico_1
         ,p_esponente_civico_2
         ,p_tipo_civico
         ,p_id_documento
         ,p_link_planimetria);
      d_result := 0;
      return d_result;
   end ins; -- anagrafe_unita_fisica.ins
   -- anagrafe_unita_fisica.ins

   --------------------------------------------------------------------------------

   procedure upd
   (
      p_check_old                in integer default 0
     ,p_new_progr_unita_fisica   in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_old_progr_unita_fisica   in anagrafe_unita_fisiche.progr_unita_fisica%type default null
     ,p_new_dal                  in anagrafe_unita_fisiche.dal%type
     ,p_old_dal                  in anagrafe_unita_fisiche.dal%type default null
     ,p_new_codice_uf            in anagrafe_unita_fisiche.codice_uf%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.codice_uf')
     ,p_old_codice_uf            in anagrafe_unita_fisiche.codice_uf%type default null
     ,p_new_denominazione        in anagrafe_unita_fisiche.denominazione%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.denominazione')
     ,p_old_denominazione        in anagrafe_unita_fisiche.denominazione%type default null
     ,p_new_denominazione_al1    in anagrafe_unita_fisiche.denominazione_al1%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.denominazione_al1')
     ,p_old_denominazione_al1    in anagrafe_unita_fisiche.denominazione_al1%type default null
     ,p_new_denominazione_al2    in anagrafe_unita_fisiche.denominazione_al2%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.denominazione_al2')
     ,p_old_denominazione_al2    in anagrafe_unita_fisiche.denominazione_al2%type default null
     ,p_new_des_abb              in anagrafe_unita_fisiche.des_abb%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.des_abb')
     ,p_old_des_abb              in anagrafe_unita_fisiche.des_abb%type default null
     ,p_new_des_abb_al1          in anagrafe_unita_fisiche.des_abb_al1%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.des_abb_al1')
     ,p_old_des_abb_al1          in anagrafe_unita_fisiche.des_abb_al1%type default null
     ,p_new_des_abb_al2          in anagrafe_unita_fisiche.des_abb_al2%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.des_abb_al2')
     ,p_old_des_abb_al2          in anagrafe_unita_fisiche.des_abb_al2%type default null
     ,p_new_indirizzo            in anagrafe_unita_fisiche.indirizzo%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.indirizzo')
     ,p_old_indirizzo            in anagrafe_unita_fisiche.indirizzo%type default null
     ,p_new_cap                  in anagrafe_unita_fisiche.cap%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.cap')
     ,p_old_cap                  in anagrafe_unita_fisiche.cap%type default null
     ,p_new_provincia            in anagrafe_unita_fisiche.provincia%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.provincia')
     ,p_old_provincia            in anagrafe_unita_fisiche.provincia%type default null
     ,p_new_comune               in anagrafe_unita_fisiche.comune%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.comune')
     ,p_old_comune               in anagrafe_unita_fisiche.comune%type default null
     ,p_new_nota_indirizzo       in anagrafe_unita_fisiche.nota_indirizzo%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.nota_indirizzo')
     ,p_old_nota_indirizzo       in anagrafe_unita_fisiche.nota_indirizzo%type default null
     ,p_new_nota_indirizzo_al1   in anagrafe_unita_fisiche.nota_indirizzo_al1%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.nota_indirizzo_al1')
     ,p_old_nota_indirizzo_al1   in anagrafe_unita_fisiche.nota_indirizzo_al1%type default null
     ,p_new_nota_indirizzo_al2   in anagrafe_unita_fisiche.nota_indirizzo_al2%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.nota_indirizzo_al2')
     ,p_old_nota_indirizzo_al2   in anagrafe_unita_fisiche.nota_indirizzo_al2%type default null
     ,p_new_amministrazione      in anagrafe_unita_fisiche.amministrazione%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.amministrazione')
     ,p_old_amministrazione      in anagrafe_unita_fisiche.amministrazione%type default null
     ,p_new_id_suddivisione      in anagrafe_unita_fisiche.id_suddivisione%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.id_suddivisione')
     ,p_old_id_suddivisione      in anagrafe_unita_fisiche.id_suddivisione%type default null
     ,p_new_generico             in anagrafe_unita_fisiche.generico%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.generico')
     ,p_old_generico             in anagrafe_unita_fisiche.generico%type default null
     ,p_new_al                   in anagrafe_unita_fisiche.al%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.al')
     ,p_old_al                   in anagrafe_unita_fisiche.al%type default null
     ,p_new_utente_aggiornamento in anagrafe_unita_fisiche.utente_aggiornamento%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.utente_aggiornamento')
     ,p_old_utente_aggiornamento in anagrafe_unita_fisiche.utente_aggiornamento%type default null
     ,p_new_data_aggiornamento   in anagrafe_unita_fisiche.data_aggiornamento%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.data_aggiornamento')
     ,p_old_data_aggiornamento   in anagrafe_unita_fisiche.data_aggiornamento%type default null
     ,p_new_capienza             in anagrafe_unita_fisiche.capienza%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.capienza')
     ,p_old_capienza             in anagrafe_unita_fisiche.capienza%type default null
     ,p_new_assegnabile          in anagrafe_unita_fisiche.assegnabile%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.assegnabile')
     ,p_old_assegnabile          in anagrafe_unita_fisiche.assegnabile%type default null
     ,p_new_note                 in anagrafe_unita_fisiche.note%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.note')
     ,p_old_note                 in anagrafe_unita_fisiche.note%type default null
     ,p_new_numero_civico        in anagrafe_unita_fisiche.numero_civico%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.numero_civico')
     ,p_old_numero_civico        in anagrafe_unita_fisiche.numero_civico%type default null
     ,p_new_esponente_civico_1   in anagrafe_unita_fisiche.esponente_civico_1%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.esponente_civico_1')
     ,p_old_esponente_civico_1   in anagrafe_unita_fisiche.esponente_civico_1%type default null
     ,p_new_esponente_civico_2   in anagrafe_unita_fisiche.esponente_civico_2%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.esponente_civico_2')
     ,p_old_esponente_civico_2   in anagrafe_unita_fisiche.esponente_civico_2%type default null
     ,p_new_tipo_civico          in anagrafe_unita_fisiche.tipo_civico%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.tipo_civico')
     ,p_old_tipo_civico          in anagrafe_unita_fisiche.tipo_civico%type default null
     ,p_new_id_documento         in anagrafe_unita_fisiche.id_documento%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.id_documento')
     ,p_old_id_documento         in anagrafe_unita_fisiche.id_documento%type default null
     ,p_new_link_planimetria     in anagrafe_unita_fisiche.link_planimetria%type default afc.default_null('ANAGRAFE_UNITA_FISICHE.link_planimetria')
     ,p_old_link_planimetria     in anagrafe_unita_fisiche.link_planimetria%type default null
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
      d_key := pk(nvl(p_old_progr_unita_fisica, p_new_progr_unita_fisica)
                 ,nvl(p_old_dal, p_new_dal));
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => d_key.progr_unita_fisica
                      ,p_dal                => d_key.dal)
             ,'existsId on anagrafe_unita_fisica.upd');
      update anagrafe_unita_fisiche
         set progr_unita_fisica   = nvl(p_new_progr_unita_fisica
                                       ,decode(afc.is_default_null('ANAGRAFE_UNITA_FISICHE.progr_unita_fisica')
                                              ,1
                                              ,progr_unita_fisica
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_progr_unita_fisica
                                                            ,null
                                                            ,progr_unita_fisica
                                                            ,null))))
            ,dal                  = nvl(p_new_dal
                                       ,decode(afc.is_default_null('ANAGRAFE_UNITA_FISICHE.dal')
                                              ,1
                                              ,dal
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_dal, null, dal, null))))
            ,codice_uf            = nvl(p_new_codice_uf
                                       ,decode(afc.is_default_null('ANAGRAFE_UNITA_FISICHE.codice_uf')
                                              ,1
                                              ,codice_uf
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_codice_uf
                                                            ,null
                                                            ,codice_uf
                                                            ,null))))
            ,denominazione        = nvl(p_new_denominazione
                                       ,decode(afc.is_default_null('ANAGRAFE_UNITA_FISICHE.denominazione')
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
                                       ,decode(afc.is_default_null('ANAGRAFE_UNITA_FISICHE.denominazione_al1')
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
                                       ,decode(afc.is_default_null('ANAGRAFE_UNITA_FISICHE.denominazione_al2')
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
                                       ,decode(afc.is_default_null('ANAGRAFE_UNITA_FISICHE.des_abb')
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
                                       ,decode(afc.is_default_null('ANAGRAFE_UNITA_FISICHE.des_abb_al1')
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
                                       ,decode(afc.is_default_null('ANAGRAFE_UNITA_FISICHE.des_abb_al2')
                                              ,1
                                              ,des_abb_al2
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_des_abb_al2
                                                            ,null
                                                            ,des_abb_al2
                                                            ,null))))
            ,indirizzo            = nvl(p_new_indirizzo
                                       ,decode(afc.is_default_null('ANAGRAFE_UNITA_FISICHE.indirizzo')
                                              ,1
                                              ,indirizzo
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_indirizzo
                                                            ,null
                                                            ,indirizzo
                                                            ,null))))
            ,cap                  = nvl(p_new_cap
                                       ,decode(afc.is_default_null('ANAGRAFE_UNITA_FISICHE.cap')
                                              ,1
                                              ,cap
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_cap, null, cap, null))))
            ,provincia            = nvl(p_new_provincia
                                       ,decode(afc.is_default_null('ANAGRAFE_UNITA_FISICHE.provincia')
                                              ,1
                                              ,provincia
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_provincia
                                                            ,null
                                                            ,provincia
                                                            ,null))))
            ,comune               = nvl(p_new_comune
                                       ,decode(afc.is_default_null('ANAGRAFE_UNITA_FISICHE.comune')
                                              ,1
                                              ,comune
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_comune
                                                            ,null
                                                            ,comune
                                                            ,null))))
            ,nota_indirizzo       = nvl(p_new_nota_indirizzo
                                       ,decode(afc.is_default_null('ANAGRAFE_UNITA_FISICHE.nota_indirizzo')
                                              ,1
                                              ,nota_indirizzo
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_nota_indirizzo
                                                            ,null
                                                            ,nota_indirizzo
                                                            ,null))))
            ,nota_indirizzo_al1   = nvl(p_new_nota_indirizzo_al1
                                       ,decode(afc.is_default_null('ANAGRAFE_UNITA_FISICHE.nota_indirizzo_al1')
                                              ,1
                                              ,nota_indirizzo_al1
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_nota_indirizzo_al1
                                                            ,null
                                                            ,nota_indirizzo_al1
                                                            ,null))))
            ,nota_indirizzo_al2   = nvl(p_new_nota_indirizzo_al2
                                       ,decode(afc.is_default_null('ANAGRAFE_UNITA_FISICHE.nota_indirizzo_al2')
                                              ,1
                                              ,nota_indirizzo_al2
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_nota_indirizzo_al2
                                                            ,null
                                                            ,nota_indirizzo_al2
                                                            ,null))))
            ,amministrazione      = nvl(p_new_amministrazione
                                       ,decode(afc.is_default_null('ANAGRAFE_UNITA_FISICHE.amministrazione')
                                              ,1
                                              ,amministrazione
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_amministrazione
                                                            ,null
                                                            ,amministrazione
                                                            ,null))))
            ,id_suddivisione      = nvl(p_new_id_suddivisione
                                       ,decode(afc.is_default_null('ANAGRAFE_UNITA_FISICHE.id_suddivisione')
                                              ,1
                                              ,id_suddivisione
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_id_suddivisione
                                                            ,null
                                                            ,id_suddivisione
                                                            ,null))))
            ,generico             = nvl(p_new_generico
                                       ,decode(afc.is_default_null('ANAGRAFE_UNITA_FISICHE.generico')
                                              ,1
                                              ,generico
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_generico
                                                            ,null
                                                            ,generico
                                                            ,null))))
            ,al                   = nvl(p_new_al
                                       ,decode(afc.is_default_null('ANAGRAFE_UNITA_FISICHE.al')
                                              ,1
                                              ,al
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_al, null, al, null))))
            ,utente_aggiornamento = nvl(p_new_utente_aggiornamento
                                       ,decode(afc.is_default_null('ANAGRAFE_UNITA_FISICHE.utente_aggiornamento')
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
                                       ,decode(afc.is_default_null('ANAGRAFE_UNITA_FISICHE.data_aggiornamento')
                                              ,1
                                              ,data_aggiornamento
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_data_aggiornamento
                                                            ,null
                                                            ,data_aggiornamento
                                                            ,null))))
            ,capienza             = nvl(p_new_capienza
                                       ,decode(afc.is_default_null('ANAGRAFE_UNITA_FISICHE.capienza')
                                              ,1
                                              ,capienza
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_capienza
                                                            ,null
                                                            ,capienza
                                                            ,null))))
            ,assegnabile          = nvl(p_new_assegnabile
                                       ,decode(afc.is_default_null('ANAGRAFE_UNITA_FISICHE.assegnabile')
                                              ,1
                                              ,assegnabile
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_assegnabile
                                                            ,null
                                                            ,assegnabile
                                                            ,null))))
            ,note                 = nvl(p_new_note
                                       ,decode(afc.is_default_null('ANAGRAFE_UNITA_FISICHE.note')
                                              ,1
                                              ,note
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_note, null, note, null))))
            ,numero_civico        = nvl(p_new_numero_civico
                                       ,decode(afc.is_default_null('ANAGRAFE_UNITA_FISICHE.numero_civico')
                                              ,1
                                              ,numero_civico
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_numero_civico
                                                            ,null
                                                            ,numero_civico
                                                            ,null))))
            ,esponente_civico_1   = nvl(p_new_esponente_civico_1
                                       ,decode(afc.is_default_null('ANAGRAFE_UNITA_FISICHE.esponente_civico_1')
                                              ,1
                                              ,esponente_civico_1
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_esponente_civico_1
                                                            ,null
                                                            ,esponente_civico_1
                                                            ,null))))
            ,esponente_civico_2   = nvl(p_new_esponente_civico_2
                                       ,decode(afc.is_default_null('ANAGRAFE_UNITA_FISICHE.esponente_civico_2')
                                              ,1
                                              ,esponente_civico_2
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_esponente_civico_2
                                                            ,null
                                                            ,esponente_civico_2
                                                            ,null))))
            ,tipo_civico          = nvl(p_new_tipo_civico
                                       ,decode(afc.is_default_null('ANAGRAFE_UNITA_FISICHE.tipo_civico')
                                              ,1
                                              ,tipo_civico
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_tipo_civico
                                                            ,null
                                                            ,tipo_civico
                                                            ,null))))
            ,id_documento         = nvl(p_new_id_documento
                                       ,decode(afc.is_default_null('ANAGRAFE_UNITA_FISICHE.id_documento')
                                              ,1
                                              ,id_documento
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_id_documento
                                                            ,null
                                                            ,id_documento
                                                            ,null))))
            ,link_planimetria     = nvl(p_new_link_planimetria
                                       ,decode(afc.is_default_null('ANAGRAFE_UNITA_FISICHE.link_planimetria')
                                              ,1
                                              ,link_planimetria
                                              ,decode(p_check_old
                                                     ,0
                                                     ,null
                                                     ,decode(p_old_link_planimetria
                                                            ,null
                                                            ,link_planimetria
                                                            ,null))))
       where progr_unita_fisica = d_key.progr_unita_fisica
         and dal = d_key.dal
         and (p_check_old = 0 or
             (1 = 1 and
             (codice_uf = p_old_codice_uf or
             (p_old_codice_uf is null and (p_check_old is null or codice_uf is null))) and
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
             (indirizzo = p_old_indirizzo or
             (p_old_indirizzo is null and (p_check_old is null or indirizzo is null))) and
             (cap = p_old_cap or
             (p_old_cap is null and (p_check_old is null or cap is null))) and
             (provincia = p_old_provincia or
             (p_old_provincia is null and (p_check_old is null or provincia is null))) and
             (comune = p_old_comune or
             (p_old_comune is null and (p_check_old is null or comune is null))) and
             (nota_indirizzo = p_old_nota_indirizzo or
             (p_old_nota_indirizzo is null and
             (p_check_old is null or nota_indirizzo is null))) and
             (nota_indirizzo_al1 = p_old_nota_indirizzo_al1 or
             (p_old_nota_indirizzo_al1 is null and
             (p_check_old is null or nota_indirizzo_al1 is null))) and
             (nota_indirizzo_al2 = p_old_nota_indirizzo_al2 or
             (p_old_nota_indirizzo_al2 is null and
             (p_check_old is null or nota_indirizzo_al2 is null))) and
             (amministrazione = p_old_amministrazione or
             (p_old_amministrazione is null and
             (p_check_old is null or amministrazione is null))) and
             (id_suddivisione = p_old_id_suddivisione or
             (p_old_id_suddivisione is null and
             (p_check_old is null or id_suddivisione is null))) and
             (generico = p_old_generico or
             (p_old_generico is null and (p_check_old is null or generico is null))) and
             (al = p_old_al or
             (p_old_al is null and (p_check_old is null or al is null))) and
             (utente_aggiornamento = p_old_utente_aggiornamento or
             (p_old_utente_aggiornamento is null and
             (p_check_old is null or utente_aggiornamento is null))) and
             (data_aggiornamento = p_old_data_aggiornamento or
             (p_old_data_aggiornamento is null and
             (p_check_old is null or data_aggiornamento is null))) and
             (capienza = p_old_capienza or
             (p_old_capienza is null and (p_check_old is null or capienza is null))) and
             (assegnabile = p_old_assegnabile or
             (p_old_assegnabile is null and
             (p_check_old is null or assegnabile is null))) and
             (note = p_old_note or
             (p_old_note is null and (p_check_old is null or note is null))) and
             (numero_civico = p_old_numero_civico or
             (p_old_numero_civico is null and
             (p_check_old is null or numero_civico is null))) and
             (esponente_civico_1 = p_old_esponente_civico_1 or
             (p_old_esponente_civico_1 is null and
             (p_check_old is null or esponente_civico_1 is null))) and
             (esponente_civico_2 = p_old_esponente_civico_2 or
             (p_old_esponente_civico_2 is null and
             (p_check_old is null or esponente_civico_2 is null))) and
             (tipo_civico = p_old_tipo_civico or
             (p_old_tipo_civico is null and
             (p_check_old is null or tipo_civico is null))) and
             (id_documento = p_old_id_documento or
             (p_old_id_documento is null and
             (p_check_old is null or id_documento is null))) and
             (link_planimetria = p_old_link_planimetria or
             (p_old_link_planimetria is null and
             (p_check_old is null or link_planimetria is null)))));
      d_row_found := sql%rowcount;
      afc.default_null(null);
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on anagrafe_unita_fisica.upd');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   end upd; -- anagrafe_unita_fisica.upd
   -- anagrafe_unita_fisica.upd

   --------------------------------------------------------------------------------

   procedure upd_column
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
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
   
      dbc.pre(not dbc.preon or existsid(p_progr_unita_fisica, p_dal)
             ,'existsId on anagrafe_unita_fisica.upd_column');
      dbc.pre(not dbc.preon or p_column is not null
             ,'p_column is not null on anagrafe_unita_fisica.upd_column');
      dbc.pre(not dbc.preon or afc_ddl.hasattribute(s_table_name, p_column)
             ,'AFC_DDL.HasAttribute on anagrafe_unita_fisica.upd_column');
      dbc.pre(p_literal_value in (0, 1) or p_literal_value is null
             ,'p_literal_value on anagrafe_unita_fisica.upd_column; p_literal_value = ' ||
              p_literal_value);
   
      if p_literal_value = 1 or p_literal_value is null then
         d_literal := '''';
      end if;
   
      d_statement := 'begin ' || '   update anagrafe_unita_fisiche' || '   set    ' ||
                     p_column || ' = ' || d_literal || p_value || d_literal ||
                     '   where  progr_unita_fisica = ''' || p_progr_unita_fisica || '''' ||
                     '   and    dal = ''' || p_dal || '''' || '   ;' || 'end;';
   
      afc.sql_execute(d_statement);
   
   end upd_column; -- anagrafe_unita_fisica.upd_column

   --------------------------------------------------------------------------------

   procedure upd_column
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
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
      upd_column(p_progr_unita_fisica
                ,p_dal
                ,p_column
                ,'to_date( ''' || d_data || ''', ''' || afc.date_format || ''' )'
                ,0);
   end upd_column; -- anagrafe_unita_fisica.upd_column

   --------------------------------------------------------------------------------

   procedure del
   (
      p_check_old            in integer default 0
     ,p_progr_unita_fisica   in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                  in anagrafe_unita_fisiche.dal%type
     ,p_codice_uf            in anagrafe_unita_fisiche.codice_uf%type default null
     ,p_denominazione        in anagrafe_unita_fisiche.denominazione%type default null
     ,p_denominazione_al1    in anagrafe_unita_fisiche.denominazione_al1%type default null
     ,p_denominazione_al2    in anagrafe_unita_fisiche.denominazione_al2%type default null
     ,p_des_abb              in anagrafe_unita_fisiche.des_abb%type default null
     ,p_des_abb_al1          in anagrafe_unita_fisiche.des_abb_al1%type default null
     ,p_des_abb_al2          in anagrafe_unita_fisiche.des_abb_al2%type default null
     ,p_indirizzo            in anagrafe_unita_fisiche.indirizzo%type default null
     ,p_cap                  in anagrafe_unita_fisiche.cap%type default null
     ,p_provincia            in anagrafe_unita_fisiche.provincia%type default null
     ,p_comune               in anagrafe_unita_fisiche.comune%type default null
     ,p_nota_indirizzo       in anagrafe_unita_fisiche.nota_indirizzo%type default null
     ,p_nota_indirizzo_al1   in anagrafe_unita_fisiche.nota_indirizzo_al1%type default null
     ,p_nota_indirizzo_al2   in anagrafe_unita_fisiche.nota_indirizzo_al2%type default null
     ,p_amministrazione      in anagrafe_unita_fisiche.amministrazione%type default null
     ,p_id_suddivisione      in anagrafe_unita_fisiche.id_suddivisione%type default null
     ,p_generico             in anagrafe_unita_fisiche.generico%type default null
     ,p_al                   in anagrafe_unita_fisiche.al%type default null
     ,p_utente_aggiornamento in anagrafe_unita_fisiche.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in anagrafe_unita_fisiche.data_aggiornamento%type default null
     ,p_capienza             in anagrafe_unita_fisiche.capienza%type default null
     ,p_assegnabile          in anagrafe_unita_fisiche.assegnabile%type default null
     ,p_note                 in anagrafe_unita_fisiche.note%type default null
     ,p_numero_civico        in anagrafe_unita_fisiche.numero_civico%type default null
     ,p_esponente_civico_1   in anagrafe_unita_fisiche.esponente_civico_1%type default null
     ,p_esponente_civico_2   in anagrafe_unita_fisiche.esponente_civico_2%type default null
     ,p_tipo_civico          in anagrafe_unita_fisiche.tipo_civico%type default null
     ,p_id_documento         in anagrafe_unita_fisiche.id_documento%type default null
     ,p_link_planimetria     in anagrafe_unita_fisiche.link_planimetria%type default null
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
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.del');
      delete from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal
         and (p_check_old = 0 or
             (1 = 1 and
             (codice_uf = p_codice_uf or
             (p_codice_uf is null and (p_check_old is null or codice_uf is null))) and
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
             (indirizzo = p_indirizzo or
             (p_indirizzo is null and (p_check_old is null or indirizzo is null))) and
             (cap = p_cap or (p_cap is null and (p_check_old is null or cap is null))) and
             (provincia = p_provincia or
             (p_provincia is null and (p_check_old is null or provincia is null))) and
             (comune = p_comune or
             (p_comune is null and (p_check_old is null or comune is null))) and
             (nota_indirizzo = p_nota_indirizzo or
             (p_nota_indirizzo is null and
             (p_check_old is null or nota_indirizzo is null))) and
             (nota_indirizzo_al1 = p_nota_indirizzo_al1 or
             (p_nota_indirizzo_al1 is null and
             (p_check_old is null or nota_indirizzo_al1 is null))) and
             (nota_indirizzo_al2 = p_nota_indirizzo_al2 or
             (p_nota_indirizzo_al2 is null and
             (p_check_old is null or nota_indirizzo_al2 is null))) and
             (amministrazione = p_amministrazione or
             (p_amministrazione is null and
             (p_check_old is null or amministrazione is null))) and
             (id_suddivisione = p_id_suddivisione or
             (p_id_suddivisione is null and
             (p_check_old is null or id_suddivisione is null))) and
             (generico = p_generico or
             (p_generico is null and (p_check_old is null or generico is null))) and
             (al = p_al or (p_al is null and (p_check_old is null or al is null))) and
             (utente_aggiornamento = p_utente_aggiornamento or
             (p_utente_aggiornamento is null and
             (p_check_old is null or utente_aggiornamento is null))) and
             (data_aggiornamento = p_data_aggiornamento or
             (p_data_aggiornamento is null and
             (p_check_old is null or data_aggiornamento is null))) and
             (capienza = p_capienza or
             (p_capienza is null and (p_check_old is null or capienza is null))) and
             (assegnabile = p_assegnabile or
             (p_assegnabile is null and (p_check_old is null or assegnabile is null))) and
             (note = p_note or
             (p_note is null and (p_check_old is null or note is null))) and
             (numero_civico = p_numero_civico or
             (p_numero_civico is null and
             (p_check_old is null or numero_civico is null))) and
             (esponente_civico_1 = p_esponente_civico_1 or
             (p_esponente_civico_1 is null and
             (p_check_old is null or esponente_civico_1 is null))) and
             (esponente_civico_2 = p_esponente_civico_2 or
             (p_esponente_civico_2 is null and
             (p_check_old is null or esponente_civico_2 is null))) and
             (tipo_civico = p_tipo_civico or
             (p_tipo_civico is null and (p_check_old is null or tipo_civico is null))) and
             (id_documento = p_id_documento or
             (p_id_documento is null and (p_check_old is null or id_documento is null))) and
             (link_planimetria = p_link_planimetria or
             (p_link_planimetria is null and
             (p_check_old is null or link_planimetria is null)))));
      d_row_found := sql%rowcount;
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on anagrafe_unita_fisica.del');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
      dbc.post(not dbc.poston or
               not existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
              ,'existsId on anagrafe_unita_fisica.del');
   end del; -- anagrafe_unita_fisica.del
   -- anagrafe_unita_fisica.del

   --------------------------------------------------------------------------------

   function get_codice_uf
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.codice_uf%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_codice_uf
       DESCRIZIONE: Attributo codice_uf di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_fisiche.codice_uf%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.codice_uf%type;
      d_data   anagrafe_unita_fisiche.dal%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_progr_unita_fisica, p_dal)
             ,'existsId on anagrafe_unita_fisica.get_codice_uf');
   
      d_data := anagrafe_unita_fisica.get_dal_id(p_progr_unita_fisica, p_dal);
   
      select codice_uf
        into d_result
        from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = d_data;
   
      return d_result;
   end get_codice_uf; -- anagrafe_unita_fisica.get_codice_uf

   --------------------------------------------------------------------------------

   function get_denominazione
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.denominazione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_denominazione
       DESCRIZIONE: Attributo denominazione di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_fisiche.denominazione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.denominazione%type;
      d_data   anagrafe_unita_fisiche.dal%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_progr_unita_fisica, p_dal)
             ,'existsId on anagrafe_unita_fisica.get_denominazione');
   
      d_data := anagrafe_unita_fisica.get_dal_id(p_progr_unita_fisica, p_dal);
      select denominazione
        into d_result
        from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = d_data;
   
      return d_result;
   end get_denominazione; -- anagrafe_unita_fisica.get_denominazione

   --------------------------------------------------------------------------------

   function get_denominazione_al1
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.denominazione_al1%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_denominazione_al1
       DESCRIZIONE: Attributo denominazione_al1 di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_fisiche.denominazione_al1%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.denominazione_al1%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_progr_unita_fisica, p_dal)
             ,'existsId on anagrafe_unita_fisica.get_denominazione_al1');
   
      select denominazione_al1
        into d_result
        from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   
      return d_result;
   end get_denominazione_al1; -- anagrafe_unita_fisica.get_denominazione_al1

   --------------------------------------------------------------------------------

   function get_denominazione_al2
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.denominazione_al2%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_denominazione_al2
       DESCRIZIONE: Attributo denominazione_al2 di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_fisiche.denominazione_al2%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.denominazione_al2%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_progr_unita_fisica, p_dal)
             ,'existsId on anagrafe_unita_fisica.get_denominazione_al2');
   
      select denominazione_al2
        into d_result
        from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   
      return d_result;
   end get_denominazione_al2; -- anagrafe_unita_fisica.get_denominazione_al2

   --------------------------------------------------------------------------------

   function get_des_abb
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.des_abb%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_des_abb
       DESCRIZIONE: Attributo des_abb di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_fisiche.des_abb%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.des_abb%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_progr_unita_fisica, p_dal)
             ,'existsId on anagrafe_unita_fisica.get_des_abb');
   
      select des_abb
        into d_result
        from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   
      return d_result;
   end get_des_abb; -- anagrafe_unita_fisica.get_des_abb

   --------------------------------------------------------------------------------

   function get_des_abb_al1
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.des_abb_al1%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_des_abb_al1
       DESCRIZIONE: Attributo des_abb_al1 di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_fisiche.des_abb_al1%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.des_abb_al1%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_progr_unita_fisica, p_dal)
             ,'existsId on anagrafe_unita_fisica.get_des_abb_al1');
   
      select des_abb_al1
        into d_result
        from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   
      return d_result;
   end get_des_abb_al1; -- anagrafe_unita_fisica.get_des_abb_al1

   --------------------------------------------------------------------------------

   function get_des_abb_al2
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.des_abb_al2%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_des_abb_al2
       DESCRIZIONE: Attributo des_abb_al2 di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_fisiche.des_abb_al2%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.des_abb_al2%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_progr_unita_fisica, p_dal)
             ,'existsId on anagrafe_unita_fisica.get_des_abb_al2');
   
      select des_abb_al2
        into d_result
        from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   
      return d_result;
   end get_des_abb_al2; -- anagrafe_unita_fisica.get_des_abb_al2

   --------------------------------------------------------------------------------

   function get_indirizzo
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.indirizzo%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_indirizzo
       DESCRIZIONE: Attributo indirizzo di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_fisiche.indirizzo%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.indirizzo%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_progr_unita_fisica, p_dal)
             ,'existsId on anagrafe_unita_fisica.get_indirizzo');
   
      select indirizzo
        into d_result
        from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   
      return d_result;
   end get_indirizzo; -- anagrafe_unita_fisica.get_indirizzo

   --------------------------------------------------------------------------------

   function get_cap
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.cap%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_cap
       DESCRIZIONE: Attributo cap di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_fisiche.cap%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.cap%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_progr_unita_fisica, p_dal)
             ,'existsId on anagrafe_unita_fisica.get_cap');
   
      select cap
        into d_result
        from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   
      return d_result;
   end get_cap; -- anagrafe_unita_fisica.get_cap

   --------------------------------------------------------------------------------

   function get_provincia
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.provincia%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_provincia
       DESCRIZIONE: Attributo provincia di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_fisiche.provincia%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.provincia%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_progr_unita_fisica, p_dal)
             ,'existsId on anagrafe_unita_fisica.get_provincia');
   
      select provincia
        into d_result
        from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   
      return d_result;
   end get_provincia; -- anagrafe_unita_fisica.get_provincia

   --------------------------------------------------------------------------------

   function get_comune
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.comune%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_comune
       DESCRIZIONE: Attributo comune di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_fisiche.comune%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.comune%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_progr_unita_fisica, p_dal)
             ,'existsId on anagrafe_unita_fisica.get_comune');
   
      select comune
        into d_result
        from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   
      return d_result;
   end get_comune; -- anagrafe_unita_fisica.get_comune

   --------------------------------------------------------------------------------

   function get_nota_indirizzo
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.nota_indirizzo%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_nota_indirizzo
       DESCRIZIONE: Attributo nota_indirizzo di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_fisiche.nota_indirizzo%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.nota_indirizzo%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_progr_unita_fisica, p_dal)
             ,'existsId on anagrafe_unita_fisica.get_nota_indirizzo');
   
      select nota_indirizzo
        into d_result
        from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   
      return d_result;
   end get_nota_indirizzo; -- anagrafe_unita_fisica.get_nota_indirizzo

   --------------------------------------------------------------------------------

   function get_nota_indirizzo_al1
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.nota_indirizzo_al1%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_nota_indirizzo_al1
       DESCRIZIONE: Attributo nota_indirizzo_al1 di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_fisiche.nota_indirizzo_al1%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.nota_indirizzo_al1%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_progr_unita_fisica, p_dal)
             ,'existsId on anagrafe_unita_fisica.get_nota_indirizzo_al1');
   
      select nota_indirizzo_al1
        into d_result
        from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   
      return d_result;
   end get_nota_indirizzo_al1; -- anagrafe_unita_fisica.get_nota_indirizzo_al1

   --------------------------------------------------------------------------------

   function get_nota_indirizzo_al2
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.nota_indirizzo_al2%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_nota_indirizzo_al2
       DESCRIZIONE: Attributo nota_indirizzo_al2 di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_fisiche.nota_indirizzo_al2%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.nota_indirizzo_al2%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_progr_unita_fisica, p_dal)
             ,'existsId on anagrafe_unita_fisica.get_nota_indirizzo_al2');
   
      select nota_indirizzo_al2
        into d_result
        from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   
      return d_result;
   end get_nota_indirizzo_al2; -- anagrafe_unita_fisica.get_nota_indirizzo_al2

   --------------------------------------------------------------------------------

   function get_amministrazione
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.amministrazione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_amministrazione
       DESCRIZIONE: Attributo amministrazione di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_fisiche.amministrazione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.amministrazione%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_progr_unita_fisica, p_dal)
             ,'existsId on anagrafe_unita_fisica.get_amministrazione');
   
      select amministrazione
        into d_result
        from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   
      return d_result;
   end get_amministrazione; -- anagrafe_unita_fisica.get_amministrazione

   --------------------------------------------------------------------------------

   function get_id_suddivisione
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.id_suddivisione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_id_suddivisione
       DESCRIZIONE: Attributo id_suddivisione di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_fisiche.id_suddivisione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.id_suddivisione%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_progr_unita_fisica, p_dal)
             ,'existsId on anagrafe_unita_fisica.get_id_suddivisione');
   
      select id_suddivisione
        into d_result
        from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   
      return d_result;
   end get_id_suddivisione; -- anagrafe_unita_fisica.get_id_suddivisione

   --------------------------------------------------------------------------------

   function get_generico
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.generico%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_generico
       DESCRIZIONE: Attributo generico di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_fisiche.generico%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.generico%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_progr_unita_fisica, p_dal)
             ,'existsId on anagrafe_unita_fisica.get_generico');
   
      select generico
        into d_result
        from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   
      return d_result;
   end get_generico; -- anagrafe_unita_fisica.get_generico

   --------------------------------------------------------------------------------

   function get_al
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.al%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_al
       DESCRIZIONE: Attributo al di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_fisiche.al%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.al%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_progr_unita_fisica, p_dal)
             ,'existsId on anagrafe_unita_fisica.get_al');
   
      select al
        into d_result
        from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   
      return d_result;
   end get_al; -- anagrafe_unita_fisica.get_al

   --------------------------------------------------------------------------------

   function get_utente_aggiornamento
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.utente_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_utente_aggiornamento
       DESCRIZIONE: Attributo utente_aggiornamento di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_fisiche.utente_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.utente_aggiornamento%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_progr_unita_fisica, p_dal)
             ,'existsId on anagrafe_unita_fisica.get_utente_aggiornamento');
   
      select utente_aggiornamento
        into d_result
        from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   
      return d_result;
   end get_utente_aggiornamento; -- anagrafe_unita_fisica.get_utente_aggiornamento

   --------------------------------------------------------------------------------

   function get_data_aggiornamento
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.data_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_data_aggiornamento
       DESCRIZIONE: Attributo data_aggiornamento di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_fisiche.data_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.data_aggiornamento%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_progr_unita_fisica, p_dal)
             ,'existsId on anagrafe_unita_fisica.get_data_aggiornamento');
   
      select data_aggiornamento
        into d_result
        from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   
      return d_result;
   end get_data_aggiornamento; -- anagrafe_unita_fisica.get_data_aggiornamento

   --------------------------------------------------------------------------------

   function get_id_unita return anagrafe_unita_fisiche.progr_unita_fisica%type is
      /******************************************************************************
       NOME:        get_id_unita
       DESCRIZIONE: Attributo progr_unita_fisica per inserimento nuova riga.
       PARAMETRI:   Nessuno.
       RITORNA:     anagrafe_unita_fisiche.progr_unita_fisica%type.
       NOTE:
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.progr_unita_fisica%type;
   begin
      select nvl(max(progr_unita_fisica), 0) + 1
        into d_result
        from anagrafe_unita_fisiche;
      --
      return d_result;
   end; -- anagrafe_unita_fisiche.get_id_unita
   function get_capienza
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.capienza%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_capienza
       DESCRIZIONE: Getter per attributo capienza di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ANAGRAFE_UNITA_FISICHE.capienza%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.capienza%type;
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.get_capienza');
      select capienza
        into d_result
        from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   
      return d_result;
   end get_capienza; -- anagrafe_unita_fisica.get_capienza
   --------------------------------------------------------------------------------
   function get_assegnabile
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.assegnabile%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_assegnabile
       DESCRIZIONE: Getter per attributo assegnabile di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ANAGRAFE_UNITA_FISICHE.assegnabile%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.assegnabile%type;
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.get_assegnabile');
      select assegnabile
        into d_result
        from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   
      return d_result;
   end get_assegnabile; -- anagrafe_unita_fisica.get_assegnabile
   --------------------------------------------------------------------------------
   function get_note
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.note%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_note
       DESCRIZIONE: Getter per attributo note di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ANAGRAFE_UNITA_FISICHE.note%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.note%type;
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.get_note');
      select note
        into d_result
        from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   
      return d_result;
   end get_note; -- anagrafe_unita_fisica.get_note
   --------------------------------------------------------------------------------
   function get_numero_civico
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.numero_civico%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_numero_civico
       DESCRIZIONE: Getter per attributo numero_civico di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ANAGRAFE_UNITA_FISICHE.numero_civico%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.numero_civico%type;
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.get_numero_civico');
      select numero_civico
        into d_result
        from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   
      return d_result;
   end get_numero_civico; -- anagrafe_unita_fisica.get_numero_civico
   --------------------------------------------------------------------------------
   function get_esponente_civico_1
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.esponente_civico_1%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_esponente_civico_1
       DESCRIZIONE: Getter per attributo esponente_civico_1 di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ANAGRAFE_UNITA_FISICHE.esponente_civico_1%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.esponente_civico_1%type;
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.get_esponente_civico_1');
      select esponente_civico_1
        into d_result
        from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   
      return d_result;
   end get_esponente_civico_1; -- anagrafe_unita_fisica.get_esponente_civico_1
   --------------------------------------------------------------------------------
   function get_esponente_civico_2
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.esponente_civico_2%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_esponente_civico_2
       DESCRIZIONE: Getter per attributo esponente_civico_2 di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ANAGRAFE_UNITA_FISICHE.esponente_civico_2%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.esponente_civico_2%type;
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.get_esponente_civico_2');
      select esponente_civico_2
        into d_result
        from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   
      return d_result;
   end get_esponente_civico_2; -- anagrafe_unita_fisica.get_esponente_civico_2
   --------------------------------------------------------------------------------
   function get_tipo_civico
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.tipo_civico%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_tipo_civico
       DESCRIZIONE: Getter per attributo tipo_civico di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ANAGRAFE_UNITA_FISICHE.tipo_civico%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.tipo_civico%type;
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.get_tipo_civico');
      select tipo_civico
        into d_result
        from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   
      return d_result;
   end get_tipo_civico; -- anagrafe_unita_fisica.get_tipo_civico
   --------------------------------------------------------------------------------
   function get_id_documento
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.id_documento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_id_documento
       DESCRIZIONE: Getter per attributo id_documento di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ANAGRAFE_UNITA_FISICHE.id_documento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.id_documento%type;
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.get_id_documento');
      select id_documento
        into d_result
        from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
      return d_result;
   end get_id_documento; -- anagrafe_unita_fisica.get_id_documento
   --------------------------------------------------------------------------------
   function get_link_planimetria
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.link_planimetria%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_link_planimetria
       DESCRIZIONE: Getter per attributo link_planimetria di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ANAGRAFE_UNITA_FISICHE.link_planimetria%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.link_planimetria%type;
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.get_link_planimetria');
      select link_planimetria
        into d_result
        from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
      return d_result;
   end get_link_planimetria; -- anagrafe_unita_fisica.get_link_planimetria
   --------------------------------------------------------------------------------
   function get_immagine_planimetria
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.immagine_planimetria%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_immagine_planimetria
       DESCRIZIONE: Getter per attributo immagine_planimetria di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ANAGRAFE_UNITA_FISICHE.immagine_planimetria%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.immagine_planimetria%type;
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.get_immagine_planimetria');
      select immagine_planimetria
        into d_result
        from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
      return d_result;
   end get_immagine_planimetria; -- anagrafe_unita_fisica.get_immagine_planimetria
   --------------------------------------------------------------------------------
   procedure set_progr_unita_fisica
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.progr_unita_fisica%type default null
   ) is
      /******************************************************************************
       NOME:        set_progr_unita_fisica
       DESCRIZIONE: Setter per attributo progr_unita_fisica di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.set_progr_unita_fisica');
      update anagrafe_unita_fisiche
         set progr_unita_fisica = p_value
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   end set_progr_unita_fisica; -- anagrafe_unita_fisica.set_progr_unita_fisica
   --------------------------------------------------------------------------------
   procedure set_dal
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.dal%type default null
   ) is
      /******************************************************************************
       NOME:        set_dal
       DESCRIZIONE: Setter per attributo dal di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.set_dal');
      update anagrafe_unita_fisiche
         set dal = p_value
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   end set_dal; -- anagrafe_unita_fisica.set_dal
   --------------------------------------------------------------------------------
   procedure set_codice_uf
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.codice_uf%type default null
   ) is
      /******************************************************************************
       NOME:        set_codice_uf
       DESCRIZIONE: Setter per attributo codice_uf di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.set_codice_uf');
      update anagrafe_unita_fisiche
         set codice_uf = p_value
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   end set_codice_uf; -- anagrafe_unita_fisica.set_codice_uf
   --------------------------------------------------------------------------------
   procedure set_denominazione
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.denominazione%type default null
   ) is
      /******************************************************************************
       NOME:        set_denominazione
       DESCRIZIONE: Setter per attributo denominazione di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.set_denominazione');
      update anagrafe_unita_fisiche
         set denominazione = p_value
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   end set_denominazione; -- anagrafe_unita_fisica.set_denominazione
   --------------------------------------------------------------------------------
   procedure set_denominazione_al1
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.denominazione_al1%type default null
   ) is
      /******************************************************************************
       NOME:        set_denominazione_al1
       DESCRIZIONE: Setter per attributo denominazione_al1 di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.set_denominazione_al1');
      update anagrafe_unita_fisiche
         set denominazione_al1 = p_value
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   end set_denominazione_al1; -- anagrafe_unita_fisica.set_denominazione_al1
   --------------------------------------------------------------------------------
   procedure set_denominazione_al2
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.denominazione_al2%type default null
   ) is
      /******************************************************************************
       NOME:        set_denominazione_al2
       DESCRIZIONE: Setter per attributo denominazione_al2 di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.set_denominazione_al2');
      update anagrafe_unita_fisiche
         set denominazione_al2 = p_value
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   end set_denominazione_al2; -- anagrafe_unita_fisica.set_denominazione_al2
   --------------------------------------------------------------------------------
   procedure set_des_abb
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.des_abb%type default null
   ) is
      /******************************************************************************
       NOME:        set_des_abb
       DESCRIZIONE: Setter per attributo des_abb di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.set_des_abb');
      update anagrafe_unita_fisiche
         set des_abb = p_value
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   end set_des_abb; -- anagrafe_unita_fisica.set_des_abb
   --------------------------------------------------------------------------------
   procedure set_des_abb_al1
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.des_abb_al1%type default null
   ) is
      /******************************************************************************
       NOME:        set_des_abb_al1
       DESCRIZIONE: Setter per attributo des_abb_al1 di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.set_des_abb_al1');
      update anagrafe_unita_fisiche
         set des_abb_al1 = p_value
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   end set_des_abb_al1; -- anagrafe_unita_fisica.set_des_abb_al1
   --------------------------------------------------------------------------------
   procedure set_des_abb_al2
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.des_abb_al2%type default null
   ) is
      /******************************************************************************
       NOME:        set_des_abb_al2
       DESCRIZIONE: Setter per attributo des_abb_al2 di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.set_des_abb_al2');
      update anagrafe_unita_fisiche
         set des_abb_al2 = p_value
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   end set_des_abb_al2; -- anagrafe_unita_fisica.set_des_abb_al2
   --------------------------------------------------------------------------------
   procedure set_indirizzo
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.indirizzo%type default null
   ) is
      /******************************************************************************
       NOME:        set_indirizzo
       DESCRIZIONE: Setter per attributo indirizzo di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.set_indirizzo');
      update anagrafe_unita_fisiche
         set indirizzo = p_value
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   end set_indirizzo; -- anagrafe_unita_fisica.set_indirizzo
   --------------------------------------------------------------------------------
   procedure set_cap
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.cap%type default null
   ) is
      /******************************************************************************
       NOME:        set_cap
       DESCRIZIONE: Setter per attributo cap di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.set_cap');
      update anagrafe_unita_fisiche
         set cap = p_value
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   end set_cap; -- anagrafe_unita_fisica.set_cap
   --------------------------------------------------------------------------------
   procedure set_provincia
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.provincia%type default null
   ) is
      /******************************************************************************
       NOME:        set_provincia
       DESCRIZIONE: Setter per attributo provincia di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.set_provincia');
      update anagrafe_unita_fisiche
         set provincia = p_value
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   end set_provincia; -- anagrafe_unita_fisica.set_provincia
   --------------------------------------------------------------------------------
   procedure set_comune
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.comune%type default null
   ) is
      /******************************************************************************
       NOME:        set_comune
       DESCRIZIONE: Setter per attributo comune di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.set_comune');
      update anagrafe_unita_fisiche
         set comune = p_value
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   end set_comune; -- anagrafe_unita_fisica.set_comune
   --------------------------------------------------------------------------------
   procedure set_nota_indirizzo
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.nota_indirizzo%type default null
   ) is
      /******************************************************************************
       NOME:        set_nota_indirizzo
       DESCRIZIONE: Setter per attributo nota_indirizzo di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.set_nota_indirizzo');
      update anagrafe_unita_fisiche
         set nota_indirizzo = p_value
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   end set_nota_indirizzo; -- anagrafe_unita_fisica.set_nota_indirizzo
   --------------------------------------------------------------------------------
   procedure set_nota_indirizzo_al1
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.nota_indirizzo_al1%type default null
   ) is
      /******************************************************************************
       NOME:        set_nota_indirizzo_al1
       DESCRIZIONE: Setter per attributo nota_indirizzo_al1 di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.set_nota_indirizzo_al1');
      update anagrafe_unita_fisiche
         set nota_indirizzo_al1 = p_value
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   end set_nota_indirizzo_al1; -- anagrafe_unita_fisica.set_nota_indirizzo_al1
   --------------------------------------------------------------------------------
   procedure set_nota_indirizzo_al2
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.nota_indirizzo_al2%type default null
   ) is
      /******************************************************************************
       NOME:        set_nota_indirizzo_al2
       DESCRIZIONE: Setter per attributo nota_indirizzo_al2 di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.set_nota_indirizzo_al2');
      update anagrafe_unita_fisiche
         set nota_indirizzo_al2 = p_value
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   end set_nota_indirizzo_al2; -- anagrafe_unita_fisica.set_nota_indirizzo_al2
   --------------------------------------------------------------------------------
   procedure set_amministrazione
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.amministrazione%type default null
   ) is
      /******************************************************************************
       NOME:        set_amministrazione
       DESCRIZIONE: Setter per attributo amministrazione di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.set_amministrazione');
      update anagrafe_unita_fisiche
         set amministrazione = p_value
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   end set_amministrazione; -- anagrafe_unita_fisica.set_amministrazione
   --------------------------------------------------------------------------------
   procedure set_id_suddivisione
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.id_suddivisione%type default null
   ) is
      /******************************************************************************
       NOME:        set_id_suddivisione
       DESCRIZIONE: Setter per attributo id_suddivisione di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.set_id_suddivisione');
      update anagrafe_unita_fisiche
         set id_suddivisione = p_value
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   end set_id_suddivisione; -- anagrafe_unita_fisica.set_id_suddivisione
   --------------------------------------------------------------------------------
   procedure set_generico
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.generico%type default null
   ) is
      /******************************************************************************
       NOME:        set_generico
       DESCRIZIONE: Setter per attributo generico di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.set_generico');
      update anagrafe_unita_fisiche
         set generico = p_value
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   end set_generico; -- anagrafe_unita_fisica.set_generico
   --------------------------------------------------------------------------------
   procedure set_al
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.al%type default null
   ) is
      /******************************************************************************
       NOME:        set_al
       DESCRIZIONE: Setter per attributo al di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.set_al');
      update anagrafe_unita_fisiche
         set al = p_value
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   end set_al; -- anagrafe_unita_fisica.set_al
   --------------------------------------------------------------------------------
   procedure set_utente_aggiornamento
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.utente_aggiornamento%type default null
   ) is
      /******************************************************************************
       NOME:        set_utente_aggiornamento
       DESCRIZIONE: Setter per attributo utente_aggiornamento di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.set_utente_aggiornamento');
      update anagrafe_unita_fisiche
         set utente_aggiornamento = p_value
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   end set_utente_aggiornamento; -- anagrafe_unita_fisica.set_utente_aggiornamento
   --------------------------------------------------------------------------------
   procedure set_data_aggiornamento
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.data_aggiornamento%type default null
   ) is
      /******************************************************************************
       NOME:        set_data_aggiornamento
       DESCRIZIONE: Setter per attributo data_aggiornamento di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.set_data_aggiornamento');
      update anagrafe_unita_fisiche
         set data_aggiornamento = p_value
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   end set_data_aggiornamento; -- anagrafe_unita_fisica.set_data_aggiornamento
   --------------------------------------------------------------------------------
   procedure set_capienza
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.capienza%type default null
   ) is
      /******************************************************************************
       NOME:        set_capienza
       DESCRIZIONE: Setter per attributo capienza di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.set_capienza');
      update anagrafe_unita_fisiche
         set capienza = p_value
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   end set_capienza; -- anagrafe_unita_fisica.set_capienza
   --------------------------------------------------------------------------------
   procedure set_assegnabile
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.assegnabile%type default null
   ) is
      /******************************************************************************
       NOME:        set_assegnabile
       DESCRIZIONE: Setter per attributo assegnabile di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.set_assegnabile');
      update anagrafe_unita_fisiche
         set assegnabile = p_value
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   end set_assegnabile; -- anagrafe_unita_fisica.set_assegnabile
   --------------------------------------------------------------------------------
   procedure set_note
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.note%type default null
   ) is
      /******************************************************************************
       NOME:        set_note
       DESCRIZIONE: Setter per attributo note di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.set_note');
      update anagrafe_unita_fisiche
         set note = p_value
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   end set_note; -- anagrafe_unita_fisica.set_note
   --------------------------------------------------------------------------------
   procedure set_numero_civico
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.numero_civico%type default null
   ) is
      /******************************************************************************
       NOME:        set_numero_civico
       DESCRIZIONE: Setter per attributo numero_civico di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.set_numero_civico');
      update anagrafe_unita_fisiche
         set numero_civico = p_value
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   end set_numero_civico; -- anagrafe_unita_fisica.set_numero_civico
   --------------------------------------------------------------------------------
   procedure set_esponente_civico_1
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.esponente_civico_1%type default null
   ) is
      /******************************************************************************
       NOME:        set_esponente_civico_1
       DESCRIZIONE: Setter per attributo esponente_civico_1 di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.set_esponente_civico_1');
      update anagrafe_unita_fisiche
         set esponente_civico_1 = p_value
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   end set_esponente_civico_1; -- anagrafe_unita_fisica.set_esponente_civico_1
   --------------------------------------------------------------------------------
   procedure set_esponente_civico_2
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.esponente_civico_2%type default null
   ) is
      /******************************************************************************
       NOME:        set_esponente_civico_2
       DESCRIZIONE: Setter per attributo esponente_civico_2 di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.set_esponente_civico_2');
      update anagrafe_unita_fisiche
         set esponente_civico_2 = p_value
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   end set_esponente_civico_2; -- anagrafe_unita_fisica.set_esponente_civico_2
   --------------------------------------------------------------------------------
   procedure set_tipo_civico
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.tipo_civico%type default null
   ) is
      /******************************************************************************
       NOME:        set_tipo_civico
       DESCRIZIONE: Setter per attributo tipo_civico di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.set_tipo_civico');
      update anagrafe_unita_fisiche
         set tipo_civico = p_value
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   end set_tipo_civico; -- anagrafe_unita_fisica.set_tipo_civico
   --------------------------------------------------------------------------------
   procedure set_id_documento
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.id_documento%type default null
   ) is
      /******************************************************************************
       NOME:        set_id_documento
       DESCRIZIONE: Setter per attributo id_documento di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.set_id_documento');
      update anagrafe_unita_fisiche
         set id_documento = p_value
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   end set_id_documento; -- anagrafe_unita_fisica.set_id_documento
   --------------------------------------------------------------------------------
   procedure set_link_planimetria
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.link_planimetria%type default null
   ) is
      /******************************************************************************
       NOME:        set_link_planimetria
       DESCRIZIONE: Setter per attributo link_planimetria di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.set_link_planimetria');
      update anagrafe_unita_fisiche
         set link_planimetria = p_value
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   end set_link_planimetria; -- anagrafe_unita_fisica.set_link_planimetria
   --------------------------------------------------------------------------------
   procedure set_immagine_planimetria
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
     ,p_value              in anagrafe_unita_fisiche.immagine_planimetria%type default null
   ) is
      /******************************************************************************
       NOME:        set_immagine_planimetria
       DESCRIZIONE: Setter per attributo immagine_planimetria di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or
              existsid(p_progr_unita_fisica => p_progr_unita_fisica, p_dal => p_dal)
             ,'existsId on anagrafe_unita_fisica.set_immagine_planimetria');
      update anagrafe_unita_fisiche
         set immagine_planimetria = p_value
       where progr_unita_fisica = p_progr_unita_fisica
         and dal = p_dal;
   end set_immagine_planimetria; -- anagrafe_unita_fisica.set_immagine_planimetria
   --------------------------------------------------------------------------------
   function is_dal_al_ok
   (
      p_dal in anagrafe_unita_fisiche.dal%type
     ,p_al  in anagrafe_unita_fisiche.al%type
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
   end; -- anagrafe_unita_fisica.is_dal_al_ok
   --------------------------------------------------------------------------------
   -- function di gestione di Data Integrity
   function is_di_ok
   (
      p_dal in anagrafe_unita_fisiche.dal%type
     ,p_al  in anagrafe_unita_fisiche.al%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_DI_ok
       DESCRIZIONE: Controllo data integrity:
                    dal < al
       PARAMETRI:   p_dal
                    p_al
       RITORNA:     Afc_error.t_error_number
      ******************************************************************************/
      d_result afc_error.t_error_number := afc_error.ok;
   begin
      d_result := is_dal_al_ok(p_dal, p_al);
      return d_result;
   end; -- anagrafe_unita_fisica.is_DI_ok
   --------------------------------------------------------------------------------
   -- procedure di gestione di Data Integrity
   procedure chk_di
   (
      p_dal in anagrafe_unita_fisiche.dal%type
     ,p_al  in anagrafe_unita_fisiche.al%type
   ) is
      /******************************************************************************
       NOME:        chk_DI.
       DESCRIZIONE: controllo data integrity
       RITORNA:     -
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
      d_result := is_di_ok(p_dal => p_dal, p_al => p_al);
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, error_message(d_result));
      end if;
   end; -- Anagrafe_unita_fisica.chk_DI
   --------------------------------------------------------------------------------
   function is_dal_ok
   (
      p_progr_uf  in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_old_dal   in assegnazioni_fisiche.dal%type
     ,p_new_dal   in assegnazioni_fisiche.dal%type
     ,p_old_al    in assegnazioni_fisiche.al%type
     ,p_new_al    in assegnazioni_fisiche.al%type
     ,p_rowid     in rowid
     ,p_inserting in number
     ,p_updating  in number
     ,p_deleting  in number
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_dal_ok
       DESCRIZIONE: Controllo nuovo dal compreso nella storicita' di UF, UO e Componente
       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number := afc_error.ok;
   begin
      -- controllo dal sovrapposto ad altri periodi di definizione della UF
      if p_inserting = 1 then
         begin
            select 'x'
              into s_dummy
              from anagrafe_unita_fisiche a
             where a.progr_unita_fisica = p_progr_uf
               and p_new_dal between nvl(a.dal, to_date(2222222, 'j')) and
                   nvl(a.al, to_date(3333333, 'j'))
               and dal <> p_new_dal;
            raise too_many_rows;
         exception
            when no_data_found then
               d_result := afc_error.ok;
            when too_many_rows then
               d_result := s_dal_sovrapposto_num;
         end;
      elsif p_updating = 1 then
         begin
            select 'x'
              into s_dummy
              from anagrafe_unita_fisiche a
             where a.progr_unita_fisica = p_progr_uf
               and a.dal <> p_new_dal
               and p_new_dal between nvl(a.dal, to_date(2222222, 'j')) and
                   nvl(a.al, to_date(3333333, 'j'));
            raise too_many_rows;
         exception
            when no_data_found then
               d_result := afc_error.ok;
            when too_many_rows then
               d_result := s_dal_sovrapposto_num;
         end;
      end if;
      return d_result;
   end; -- assegnazioni_fisiche_pkg.is_dal_ok
   --------------------------------------------------------------------------------
   function is_al_ok
   (
      p_progr_uf  in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_old_dal   in assegnazioni_fisiche.dal%type
     ,p_new_dal   in assegnazioni_fisiche.dal%type
     ,p_old_al    in assegnazioni_fisiche.al%type
     ,p_new_al    in assegnazioni_fisiche.al%type
     ,p_rowid     in rowid
     ,p_inserting in number
     ,p_updating  in number
     ,p_deleting  in number
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_al_ok
       DESCRIZIONE: Controllo is_al_ok 
       NOTE:        --
      ******************************************************************************/
      /******************************************************************************
       NOME:        is_al_ok
       DESCRIZIONE: Controllo nuovo al compreso nella storicita' di UF
       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number := afc_error.ok;
   begin
      -- controllo al sovrapposto ad altri periodi di definizione della UF
      if p_inserting = 1 then
         begin
            select 'x'
              into s_dummy
              from anagrafe_unita_fisiche a
             where a.progr_unita_fisica = p_progr_uf
               and nvl(p_new_al, to_date(3333333, 'j')) between
                   nvl(a.dal, to_date(2222222, 'j')) and nvl(a.al, to_date(3333333, 'j'))
               and a.dal <> p_new_dal;
            raise too_many_rows;
         exception
            when no_data_found then
               d_result := afc_error.ok;
            when too_many_rows then
               d_result := s_al_sovrapposto_num;
         end;
      elsif p_updating = 1 then
         begin
            select 'x'
              into s_dummy
              from anagrafe_unita_fisiche a
             where a.progr_unita_fisica = p_progr_uf
               and nvl(p_new_al, to_date(3333333, 'j')) between
                   nvl(a.dal, to_date(2222222, 'j')) and nvl(a.al, to_date(3333333, 'j'))
               and a.dal <> p_new_dal;
            raise too_many_rows;
         exception
            when no_data_found then
               d_result := afc_error.ok;
            when too_many_rows then
               d_result := s_al_sovrapposto_num;
         end;
      end if;
      return d_result;
   end; -- assegnazioni_fisiche_pkg.is_dal_ok
   --------------------------------------------------------------------------------
   function is_capienza_ok
   (
      p_progr_uf in assegnazioni_fisiche.progr_unita_fisica%type
     ,p_capienza in anagrafe_unita_fisiche.capienza%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_capienza_ok
       DESCRIZIONE: Controlla sel e' stata superata la capienza massima prevista per la UF 
       NOTE:        --
      ******************************************************************************/
      d_num_assegnazioni number(4);
      d_data             date := trunc(sysdate);
      d_result           afc_error.t_error_number := afc_error.ok;
   begin
      select nvl(count(*), 0)
        into d_num_assegnazioni
        from assegnazioni_fisiche a
       where a.progr_unita_fisica = p_progr_uf
         and d_data between dal and nvl(al, to_date(3333333, 'j'));
   
      if d_num_assegnazioni > p_capienza then
         d_result := s_capienza_superata_number;
      end if;
   
      return d_result;
   
   end; -- assegnazioni_fisiche_pkg.is_dal_ok
   --------------------------------------------------------------------------------
   function is_assegnabile_ok(p_progr_uf in assegnazioni_fisiche.progr_unita_fisica%type)
      return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_assegnabile_ok
       DESCRIZIONE: Controlla che non vi siano assegnazioni aperte ad oggi sull'unita 
       NOTE:        --
      ******************************************************************************/
      d_data   date := trunc(sysdate);
      d_result afc_error.t_error_number := afc_error.ok;
   begin
      begin
         select s_assegnabile_errato_number
           into d_result
           from assegnazioni_fisiche
          where progr_unita_fisica = p_progr_uf
            and nvl(al, to_date(3333333, 'j')) >= d_data;
         raise too_many_rows;
      exception
         when no_data_found then
            d_result := afc_error.ok;
         when too_many_rows then
            d_result := s_assegnabile_errato_number;
      end;
      return d_result;
   end;
--------------------------------------------------------------------------------   
   function is_unita_in_struttura(p_progr_uf in assegnazioni_fisiche.progr_unita_fisica%type)
      return varchar2 is
      /******************************************************************************
       NOME:        is_unita_in_struttura
       DESCRIZIONE: Ritorna SI o NO in funzione del fatto che l'unità abbia almeno un
                    periodo in struttura fisica
       NOTE:        --
      ******************************************************************************/
      d_result varchar2(2);
   begin
     select nvl(max('SI'),'NO')
       into d_result
       from dual
      where exists (select 1 from unita_fisiche where progr_unita_fisica = p_progr_uf);
      return d_result;
   end;   
   --------------------------------------------------------------------------------
   function is_ri_ok
   (
      p_progr_uf        in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_codice_uf       in anagrafe_unita_fisiche.codice_uf%type
     ,p_capienza        in anagrafe_unita_fisiche.capienza%type
     ,p_denominazione   in anagrafe_unita_fisiche.denominazione%type
     ,p_amministrazione in anagrafe_unita_fisiche.amministrazione%type
     ,p_old_dal         in assegnazioni_fisiche.dal%type
     ,p_new_dal         in assegnazioni_fisiche.dal%type
     ,p_old_al          in assegnazioni_fisiche.al%type
     ,p_new_al          in assegnazioni_fisiche.al%type
     ,p_old_assegnabile in anagrafe_unita_fisiche.assegnabile%type
     ,p_new_assegnabile in anagrafe_unita_fisiche.assegnabile%type
     ,p_rowid           in rowid
     ,p_inserting       in number
     ,p_updating        in number
     ,p_deleting        in number
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_RI_ok.
       DESCRIZIONE: gestione della Referential Integrity:
                    - is_capienza_ok
                    - is_dal_ok
                    - is_al_ok
       RETURN:      1 se tutti i controlli danno esito positivo, l'error_code altrimenti
       NOTE:        --
      ******************************************************************************/
      d_result    afc_error.t_error_number := afc_error.ok;
      d_contatore number := 0;
   begin
      if p_deleting = 0 then
         if d_result = afc_error.ok and p_capienza is not null then
            d_result := is_capienza_ok(p_progr_uf, p_capienza);
         end if;
      
         -- is_dal_ok 
         if d_result = afc_error.ok then
            d_result := is_dal_ok(p_progr_uf
                                 ,p_old_dal
                                 ,p_new_dal
                                 ,p_old_al
                                 ,p_new_al
                                 ,p_rowid
                                 ,p_inserting
                                 ,p_updating
                                 ,p_deleting);
         end if;
         -- is_al_ok 
         if d_result = afc_error.ok then
            d_result := is_al_ok(p_progr_uf
                                ,p_old_dal
                                ,p_new_dal
                                ,p_old_al
                                ,p_new_al
                                ,p_rowid
                                ,p_inserting
                                ,p_updating
                                ,p_deleting);
         end if;
         -- controlla la sovrapposizione con altri periodi
         if d_result = afc_error.ok and p_progr_uf is not null and p_deleting = 0 then
            select count(*)
              into d_contatore
              from anagrafe_unita_fisiche a
             where a.progr_unita_fisica = p_progr_uf
               and nvl(p_new_al, to_date(3333333, 'j')) >=
                   nvl(a.dal, to_date(2222222, 'j'))
               and nvl(a.al, to_date(3333333, 'j')) >= p_new_dal;
            if d_contatore > 1 then
               d_result := s_periodi_sovrapposti_num;
            end if;
         end if;
      
         -- is_assegnabile_ok
         if d_result = afc_error.ok and p_updating = 1 and p_old_assegnabile = 'SI' and
            nvl(p_new_assegnabile, 'NO') = 'NO' then
            d_result := is_assegnabile_ok(p_progr_uf);
         end if;
      else
         -- verifica dell'integrita' storica su legami e assegnazioni
         begin
            select s_esistono_uf_num
              into d_result
              from dual
             where exists (select 'x'
                      from unita_fisiche u
                     where (progr_unita_fisica = p_progr_uf or
                           u.id_unita_fisica_padre = p_progr_uf)
                       and dal <= nvl(p_old_al, to_date(3333333, 'j'))
                       and nvl(al, to_date(3333333, 'j')) >= p_old_dal);
            raise too_many_rows;
         exception
            when no_data_found then
               begin
                  select s_esistono_assegnazioni_num
                    into d_result
                    from dual
                   where exists
                   (select 'x'
                            from assegnazioni_fisiche a
                           where progr_unita_fisica = p_progr_uf
                             and dal <= nvl(p_old_al, to_date(3333333, 'j'))
                             and nvl(al, to_date(3333333, 'j')) >= p_old_dal);
                  raise too_many_rows;
               exception
                  when no_data_found then
                     d_result := afc_error.ok;
                  when too_many_rows then
                     d_result := s_esistono_assegnazioni_num;
               end;
            when too_many_rows then
               d_result := s_esistono_uf_num;
         end;
         -- verifica dell'integrita' storica su attributi unita fisica
         if d_result = afc_error.ok then
            begin
               select s_esistono_attributi_num
                 into d_result
                 from dual
                where exists (select 'x'
                         from attributi_unita_fisica_so a
                        where a.progr_unita_fisica = p_progr_uf
                          and dal <= nvl(p_old_al, to_date(3333333, 'j'))
                          and nvl(al, to_date(3333333, 'j')) >= p_old_dal);
               raise too_many_rows;
            exception
               when no_data_found then
                  d_result := afc_error.ok;
               when too_many_rows then
                  d_result := s_esistono_attributi_num;
            end;
         end if;
      end if;
      if p_updating = 1 and d_result = afc_error.ok and --#450
         (p_new_dal > nvl(p_old_dal, to_date(2222222, 'j')) or
         nvl(p_new_al, to_date(3333333, 'j')) < nvl(p_old_al, to_date(3333333, 'j'))) then
      
         begin 
            select s_esistono_uf2_num
              into d_result
              from dual
             where exists (select 'x'
                      from unita_fisiche u
                     where u.progr_unita_fisica = p_progr_uf
                       and (dal < nvl(p_new_dal, to_date(2222222, 'j')) or
                           nvl(al, to_date(3333333, 'j')) >
                           nvl(p_new_al, to_date(3333333, 'j'))));
            raise too_many_rows;
         exception
            when no_data_found then
               d_result := afc_error.ok;
            when too_many_rows then
               d_result := s_esistono_uf2_num;
         end;
      
      end if;
      return d_result;
   end; -- assegnazioni_fisiche_pkg.is_RI_ok
   --------------------------------------------------------------------------------
   procedure chk_ri
   (
      p_progr_uf        in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_codice_uf       in anagrafe_unita_fisiche.codice_uf%type
     ,p_capienza        in anagrafe_unita_fisiche.capienza%type
     ,p_denominazione   in anagrafe_unita_fisiche.denominazione%type
     ,p_amministrazione in anagrafe_unita_fisiche.amministrazione%type
     ,p_old_dal         in assegnazioni_fisiche.dal%type
     ,p_new_dal         in assegnazioni_fisiche.dal%type
     ,p_old_al          in assegnazioni_fisiche.al%type
     ,p_new_al          in assegnazioni_fisiche.al%type
     ,p_old_assegnabile in anagrafe_unita_fisiche.assegnabile%type
     ,p_new_assegnabile in anagrafe_unita_fisiche.assegnabile%type
     ,p_rowid           in rowid
     ,p_inserting       in number
     ,p_updating        in number
     ,p_deleting        in number
   ) is
      /******************************************************************************
       NOME:        chk_RI.
       DESCRIZIONE: gestione della Referential Integrity:
                    - is_capienza_ok
                    - is_dal_ok
                    - is_al_ok
       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
      d_result := is_ri_ok(p_progr_uf
                          ,p_codice_uf
                          ,p_capienza
                          ,p_denominazione
                          ,p_amministrazione
                          ,p_old_dal
                          ,p_new_dal
                          ,p_old_al
                          ,p_new_al
                          ,p_old_assegnabile
                          ,p_new_assegnabile
                          ,p_rowid
                          ,p_inserting
                          ,p_updating
                          ,p_deleting);
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, s_error_table(d_result));
      end if;
   end; -- assegnazioni_fisiche_pkg.chk_RI
   --------------------------------------------------------------------------------
   procedure set_fi
   (
      p_progr_uf        in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_codice_uf       in anagrafe_unita_fisiche.codice_uf%type
     ,p_capienza        in anagrafe_unita_fisiche.capienza%type
     ,p_denominazione   in anagrafe_unita_fisiche.denominazione%type
     ,p_amministrazione in anagrafe_unita_fisiche.amministrazione%type
     ,p_old_dal         in assegnazioni_fisiche.dal%type
     ,p_new_dal         in assegnazioni_fisiche.dal%type
     ,p_old_al          in assegnazioni_fisiche.al%type
     ,p_new_al          in assegnazioni_fisiche.al%type
     ,p_rowid           in rowid
     ,p_inserting       in number
     ,p_updating        in number
     ,p_deleting        in number
   ) is
      /******************************************************************************
       NOME:        set_fi
       DESCRIZIONE: tiene allineata la tabella attributi_unita_fisiche_so
                    - se anticipo DAL, anticipa i dal degli attributi
                    - se ridardo DAL, ritarda i dal degli attributi
                    - se chiudo/modifico al...
                    - se riapro al, riapro gli attributi chiusi alla stessa old.al
       NOTE:        --
      ******************************************************************************/
      d_result  afc_error.t_error_number;
      d_min_dal date;
      d_max_al  date;
   begin
      if p_updating = 1 and
         (p_new_dal <> p_old_dal or
         nvl(p_new_al, to_date(3333333, 'j')) <> nvl(p_old_al, to_date(3333333, 'j'))) then
         if p_new_dal < p_old_dal then
            update attributi_unita_fisica_so a
               set dal = p_new_dal
             where a.progr_unita_fisica = p_progr_uf
               and a.dal = p_old_dal;
         end if;
         if p_new_dal > p_old_dal then
            update attributi_unita_fisica_so a
               set dal = greatest(p_new_dal, dal)
             where a.progr_unita_fisica = p_progr_uf
               and a.dal = p_old_dal;
         end if;
         if nvl(p_new_al, to_date(3333333, 'j')) > nvl(p_old_al, to_date(3333333, 'j')) then
            update attributi_unita_fisica_so a
               set al = p_new_al
             where a.progr_unita_fisica = p_progr_uf
               and a.dal = p_new_dal;
         end if;
         if nvl(p_new_al, to_date(3333333, 'j')) < nvl(p_old_al, to_date(3333333, 'j')) then
            update attributi_unita_fisica_so a
               set al = decode(least(nvl(p_new_al, to_date(3333333, 'j'))
                                    ,nvl(al, to_date(3333333, 'j')))
                              ,to_date(3333333, 'j')
                              ,to_date(null)
                              ,least(nvl(p_new_al, to_date(3333333, 'j'))
                                    ,nvl(al, to_date(3333333, 'j'))))
             where a.progr_unita_fisica = p_progr_uf
               and a.dal = p_new_dal;
         end if;
      
         d_min_dal := anagrafe_unita_fisica.get_dal_min(p_progr_uf);
         d_max_al  := anagrafe_unita_fisica.get_max_al(p_progr_uf);
      
         update attributi_unita_fisica_so a
            set al = decode(least(nvl(d_max_al, to_date(3333333, 'j'))
                                 ,nvl(al, to_date(3333333, 'j')))
                           ,to_date(3333333, 'j')
                           ,to_date(null)
                           ,least(nvl(d_max_al, to_date(3333333, 'j'))
                                 ,nvl(al, to_date(3333333, 'j'))))
          where progr_unita_fisica = p_progr_uf
            and dal = (select max(dal)
                         from attributi_unita_fisica_so
                        where progr_unita_fisica = a.progr_unita_fisica
                          and attributo = a.attributo);
      
         update attributi_unita_fisica_so a
            set dal = greatest(d_min_dal, a.dal)
          where progr_unita_fisica = p_progr_uf
            and dal = (select min(dal)
                         from attributi_unita_fisica_so
                        where progr_unita_fisica = a.progr_unita_fisica
                          and attributo = a.attributo);
      
      end if;
   
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, s_error_table(d_result));
      end if;
   end; -- assegnazioni_fisiche_pkg.chk_RI

   --------------------------------------------------------------------------------

   function where_condition /* SLAVE_COPY */
   (
      p_qbe                  in number default 0
     ,p_other_condition      in varchar2 default null
     ,p_progr_unita_fisica   in varchar2 default null
     ,p_dal                  in varchar2 default null
     ,p_codice_uf            in varchar2 default null
     ,p_denominazione        in varchar2 default null
     ,p_denominazione_al1    in varchar2 default null
     ,p_denominazione_al2    in varchar2 default null
     ,p_des_abb              in varchar2 default null
     ,p_des_abb_al1          in varchar2 default null
     ,p_des_abb_al2          in varchar2 default null
     ,p_indirizzo            in varchar2 default null
     ,p_cap                  in varchar2 default null
     ,p_provincia            in varchar2 default null
     ,p_comune               in varchar2 default null
     ,p_nota_indirizzo       in varchar2 default null
     ,p_nota_indirizzo_al1   in varchar2 default null
     ,p_nota_indirizzo_al2   in varchar2 default null
     ,p_amministrazione      in varchar2 default null
     ,p_id_suddivisione      in varchar2 default null
     ,p_generico             in varchar2 default null
     ,p_al                   in varchar2 default null
     ,p_utente_aggiornamento in varchar2 default null
     ,p_data_aggiornamento   in varchar2 default null
     ,p_capienza             in varchar2 default null
     ,p_assegnabile          in varchar2 default null
     ,p_note                 in varchar2 default null
     ,p_numero_civico        in varchar2 default null
     ,p_esponente_civico_1   in varchar2 default null
     ,p_esponente_civico_2   in varchar2 default null
     ,p_tipo_civico          in varchar2 default null
     ,p_id_documento         in varchar2 default null
     ,p_link_planimetria     in varchar2 default null
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
                     afc.get_field_condition(' and ( codice_uf '
                                            ,p_codice_uf
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
                     afc.get_field_condition(' and ( indirizzo '
                                            ,p_indirizzo
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( cap ', p_cap, ' )', p_qbe, null) ||
                     afc.get_field_condition(' and ( provincia '
                                            ,p_provincia
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( comune '
                                            ,p_comune
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( nota_indirizzo '
                                            ,p_nota_indirizzo
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( nota_indirizzo_al1 '
                                            ,p_nota_indirizzo_al1
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( nota_indirizzo_al2 '
                                            ,p_nota_indirizzo_al2
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( amministrazione '
                                            ,p_amministrazione
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( id_suddivisione '
                                            ,p_id_suddivisione
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( generico '
                                            ,p_generico
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
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
                                            ,afc.date_format) ||
                     afc.get_field_condition(' and ( capienza '
                                            ,p_capienza
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( assegnabile '
                                            ,p_assegnabile
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( note ', p_note, ' )', p_qbe, null) ||
                     afc.get_field_condition(' and ( numero_civico '
                                            ,p_numero_civico
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( esponente_civico_1 '
                                            ,p_esponente_civico_1
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( esponente_civico_2 '
                                            ,p_esponente_civico_2
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( tipo_civico '
                                            ,p_tipo_civico
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( id_documento '
                                            ,p_id_documento
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( link_planimetria '
                                            ,p_link_planimetria
                                            ,' )'
                                            ,p_qbe
                                            ,null) || ' ) ' || p_other_condition;
      return d_statement;
   end where_condition; --- anagrafe_unita_fisica.where_condition
   --- anagrafe_unita_fisica.where_condition

   --------------------------------------------------------------------------------

   function get_rows
   (
      p_qbe                  in number default 0
     ,p_other_condition      in varchar2 default null
     ,p_order_by             in varchar2 default null
     ,p_extra_columns        in varchar2 default null
     ,p_extra_condition      in varchar2 default null
     ,p_progr_unita_fisica   in varchar2 default null
     ,p_dal                  in varchar2 default null
     ,p_codice_uf            in varchar2 default null
     ,p_denominazione        in varchar2 default null
     ,p_denominazione_al1    in varchar2 default null
     ,p_denominazione_al2    in varchar2 default null
     ,p_des_abb              in varchar2 default null
     ,p_des_abb_al1          in varchar2 default null
     ,p_des_abb_al2          in varchar2 default null
     ,p_indirizzo            in varchar2 default null
     ,p_cap                  in varchar2 default null
     ,p_provincia            in varchar2 default null
     ,p_comune               in varchar2 default null
     ,p_nota_indirizzo       in varchar2 default null
     ,p_nota_indirizzo_al1   in varchar2 default null
     ,p_nota_indirizzo_al2   in varchar2 default null
     ,p_amministrazione      in varchar2 default null
     ,p_id_suddivisione      in varchar2 default null
     ,p_generico             in varchar2 default null
     ,p_al                   in varchar2 default null
     ,p_utente_aggiornamento in varchar2 default null
     ,p_data_aggiornamento   in varchar2 default null
     ,p_capienza             in varchar2 default null
     ,p_assegnabile          in varchar2 default null
     ,p_note                 in varchar2 default null
     ,p_numero_civico        in varchar2 default null
     ,p_esponente_civico_1   in varchar2 default null
     ,p_esponente_civico_2   in varchar2 default null
     ,p_tipo_civico          in varchar2 default null
     ,p_id_documento         in varchar2 default null
     ,p_link_planimetria     in varchar2 default null
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
      d_statement  := ' select ANAGRAFE_UNITA_FISICHE.* ' ||
                      afc.decode_value(p_extra_columns
                                      ,null
                                      ,null
                                      ,' , ' || p_extra_columns) ||
                      ' from ANAGRAFE_UNITA_FISICHE ' ||
                      where_condition(p_qbe                  => p_qbe
                                     ,p_other_condition      => p_other_condition
                                     ,p_progr_unita_fisica   => p_progr_unita_fisica
                                     ,p_dal                  => p_dal
                                     ,p_codice_uf            => p_codice_uf
                                     ,p_denominazione        => p_denominazione
                                     ,p_denominazione_al1    => p_denominazione_al1
                                     ,p_denominazione_al2    => p_denominazione_al2
                                     ,p_des_abb              => p_des_abb
                                     ,p_des_abb_al1          => p_des_abb_al1
                                     ,p_des_abb_al2          => p_des_abb_al2
                                     ,p_indirizzo            => p_indirizzo
                                     ,p_cap                  => p_cap
                                     ,p_provincia            => p_provincia
                                     ,p_comune               => p_comune
                                     ,p_nota_indirizzo       => p_nota_indirizzo
                                     ,p_nota_indirizzo_al1   => p_nota_indirizzo_al1
                                     ,p_nota_indirizzo_al2   => p_nota_indirizzo_al2
                                     ,p_amministrazione      => p_amministrazione
                                     ,p_id_suddivisione      => p_id_suddivisione
                                     ,p_generico             => p_generico
                                     ,p_al                   => p_al
                                     ,p_utente_aggiornamento => p_utente_aggiornamento
                                     ,p_data_aggiornamento   => p_data_aggiornamento
                                     ,p_capienza             => p_capienza
                                     ,p_assegnabile          => p_assegnabile
                                     ,p_note                 => p_note
                                     ,p_numero_civico        => p_numero_civico
                                     ,p_esponente_civico_1   => p_esponente_civico_1
                                     ,p_esponente_civico_2   => p_esponente_civico_2
                                     ,p_tipo_civico          => p_tipo_civico
                                     ,p_id_documento         => p_id_documento
                                     ,p_link_planimetria     => p_link_planimetria) || ' ' ||
                      p_extra_condition ||
                      afc.decode_value(p_order_by, null, null, ' order by ' || p_order_by);
      d_ref_cursor := afc_dml.get_ref_cursor(d_statement);
      return d_ref_cursor;
   end get_rows; -- anagrafe_unita_fisica.get_rows
   -- anagrafe_unita_fisica.get_rows

   --------------------------------------------------------------------------------

   function count_rows
   (
      p_qbe                  in number default 0
     ,p_other_condition      in varchar2 default null
     ,p_progr_unita_fisica   in varchar2 default null
     ,p_dal                  in varchar2 default null
     ,p_codice_uf            in varchar2 default null
     ,p_denominazione        in varchar2 default null
     ,p_denominazione_al1    in varchar2 default null
     ,p_denominazione_al2    in varchar2 default null
     ,p_des_abb              in varchar2 default null
     ,p_des_abb_al1          in varchar2 default null
     ,p_des_abb_al2          in varchar2 default null
     ,p_indirizzo            in varchar2 default null
     ,p_cap                  in varchar2 default null
     ,p_provincia            in varchar2 default null
     ,p_comune               in varchar2 default null
     ,p_nota_indirizzo       in varchar2 default null
     ,p_nota_indirizzo_al1   in varchar2 default null
     ,p_nota_indirizzo_al2   in varchar2 default null
     ,p_amministrazione      in varchar2 default null
     ,p_id_suddivisione      in varchar2 default null
     ,p_generico             in varchar2 default null
     ,p_al                   in varchar2 default null
     ,p_utente_aggiornamento in varchar2 default null
     ,p_data_aggiornamento   in varchar2 default null
     ,p_capienza             in varchar2 default null
     ,p_assegnabile          in varchar2 default null
     ,p_note                 in varchar2 default null
     ,p_numero_civico        in varchar2 default null
     ,p_esponente_civico_1   in varchar2 default null
     ,p_esponente_civico_2   in varchar2 default null
     ,p_tipo_civico          in varchar2 default null
     ,p_id_documento         in varchar2 default null
     ,p_link_planimetria     in varchar2 default null
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
      d_statement := ' select count( * ) from ANAGRAFE_UNITA_FISICHE ' ||
                     where_condition(p_qbe                  => p_qbe
                                    ,p_other_condition      => p_other_condition
                                    ,p_progr_unita_fisica   => p_progr_unita_fisica
                                    ,p_dal                  => p_dal
                                    ,p_codice_uf            => p_codice_uf
                                    ,p_denominazione        => p_denominazione
                                    ,p_denominazione_al1    => p_denominazione_al1
                                    ,p_denominazione_al2    => p_denominazione_al2
                                    ,p_des_abb              => p_des_abb
                                    ,p_des_abb_al1          => p_des_abb_al1
                                    ,p_des_abb_al2          => p_des_abb_al2
                                    ,p_indirizzo            => p_indirizzo
                                    ,p_cap                  => p_cap
                                    ,p_provincia            => p_provincia
                                    ,p_comune               => p_comune
                                    ,p_nota_indirizzo       => p_nota_indirizzo
                                    ,p_nota_indirizzo_al1   => p_nota_indirizzo_al1
                                    ,p_nota_indirizzo_al2   => p_nota_indirizzo_al2
                                    ,p_amministrazione      => p_amministrazione
                                    ,p_id_suddivisione      => p_id_suddivisione
                                    ,p_generico             => p_generico
                                    ,p_al                   => p_al
                                    ,p_utente_aggiornamento => p_utente_aggiornamento
                                    ,p_data_aggiornamento   => p_data_aggiornamento
                                    ,p_capienza             => p_capienza
                                    ,p_assegnabile          => p_assegnabile
                                    ,p_note                 => p_note
                                    ,p_numero_civico        => p_numero_civico
                                    ,p_esponente_civico_1   => p_esponente_civico_1
                                    ,p_esponente_civico_2   => p_esponente_civico_2
                                    ,p_tipo_civico          => p_tipo_civico
                                    ,p_id_documento         => p_id_documento
                                    ,p_link_planimetria     => p_link_planimetria);
      d_result    := afc.sql_execute(d_statement);
      return d_result;
   end count_rows; -- anagrafe_unita_fisica.count_rows
   -- anagrafe_unita_fisica.count_rows

   --------------------------------------------------------------------------------

   function get_dal_id
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_dal                in anagrafe_unita_fisiche.dal%type
   ) return anagrafe_unita_fisiche.dal%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_dal_id
       DESCRIZIONE: Attributo dal di riga con periodo di validità comprendente
                    la data indicata
       PARAMETRI:   Attributi chiave.
       RITORNA:     anagrafe_unita_fisiche.dal%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.dal%type;
   begin
      select dal
        into d_result
        from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and p_dal between dal and nvl(al, to_date('3333333', 'j'));
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_dal_id

   --------------------------------------------------------------------------------

   function get_progr_uf
   (
      p_amministrazione in anagrafe_unita_fisiche.amministrazione%type
     ,p_codice_uf       in anagrafe_unita_fisiche.codice_uf%type
     ,p_dal             in anagrafe_unita_fisiche.dal%type default null
   ) return anagrafe_unita_fisiche.progr_unita_fisica%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_progr_uf
       DESCRIZIONE: Attributo progressivo di riga identificata da amministrazione e
                    codice con periodo di validità comprendente la data indicata
       PARAMETRI:
       RITORNA:     anagrafe_unita_fisiche.progr_unita_fisica%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.progr_unita_fisica%type;
   begin
      begin
         select progr_unita_fisica
           into d_result
           from anagrafe_unita_fisiche
          where amministrazione = p_amministrazione
            and codice_uf = p_codice_uf
            and nvl(p_dal, trunc(sysdate)) between dal and
                nvl(al, to_date('3333333', 'j'));
      exception
         when others then
            d_result := null;
      end;
      --
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_progr_uf

   --------------------------------------------------------------------------------

   function get_dal_min(p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type)
      return anagrafe_unita_fisiche.dal%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_dal_min
       DESCRIZIONE: Primo dal dell'unità fisica
       PARAMETRI:   progressivo
       RITORNA:     anagrafe_unita_fisiche.dal%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.dal%type;
   begin
      select min(dal)
        into d_result
        from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_dal_min

   --------------------------------------------------------------------------------

   function get_max_al(p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type)
      return anagrafe_unita_fisiche.al%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_max_al
       DESCRIZIONE: Ultimo al dell'unità fisica
       PARAMETRI:   progressivo
       RITORNA:     anagrafe_unita_fisiche.al%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_fisiche.al%type;
   begin
      select max(nvl(al, to_date(3333333, 'j')))
        into d_result
        from anagrafe_unita_fisiche
       where progr_unita_fisica = p_progr_unita_fisica;
      return d_result;
   end; -- anagrafe_unita_organizzativa.get_max_al

   function get_uo_competenza
   (
      p_progr_unita_fisica in anagrafe_unita_fisiche.progr_unita_fisica%type
     ,p_amministrazione    in anagrafe_unita_fisiche.amministrazione%type
     ,p_data_riferimento   in date
   ) return anagrafe_unita_organizzative.progr_unita_organizzativa%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_uo_competenza
       DESCRIZIONE: Unita' organizzativa di competenza
       PARAMETRI:   progressivo
       RITORNA:     anagrafe_unita_organizzative.progr_unita_organizzativa%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result anagrafe_unita_organizzative.progr_unita_organizzativa%type;
      d_ni     componenti.ni%type;
   begin
      select min(ni)
        into d_ni
        from assegnazioni_fisiche
       where progr_unita_fisica = p_progr_unita_fisica
         and nvl(p_data_riferimento, sysdate) between dal and
             nvl(al, to_date(3333333, 'j'))
         and dal = (select min(dal)
                      from assegnazioni_fisiche
                     where progr_unita_fisica = p_progr_unita_fisica
                       and nvl(p_data_riferimento, sysdate) between dal and
                           nvl(al, to_date(3333333, 'j')));
      if d_ni is not null then
         begin
            select progr_unita_organizzativa
              into d_result
              from vista_componenti
             where ni = d_ni
               and nvl(p_data_riferimento, sysdate) between dal and
                   nvl(al, to_date(3333333, 'j'))
               and tipo_assegnazione = 'I'
               and assegnazione_prevalente = 1
               and ottica = (select ottica
                               from ottiche
                              where ottica_istituzionale = 'SI'
                                and amministrazione = p_amministrazione);
         exception
            when no_data_found then
               begin
                  select progr_unita_organizzativa
                    into d_result
                    from vista_componenti
                   where ni = d_ni
                     and nvl(p_data_riferimento, sysdate) between dal and
                         nvl(al, to_date(3333333, 'j'))
                     and tipo_assegnazione = 'F'
                     and ottica = (select ottica
                                     from ottiche
                                    where ottica_istituzionale = 'SI'
                                      and amministrazione = p_amministrazione)
                     and dal = (select min(dal)
                                  from vista_componenti
                                 where ni = d_ni
                                   and nvl(p_data_riferimento, sysdate) between dal and
                                       nvl(al, to_date(3333333, 'j'))
                                   and tipo_assegnazione = 'F');
               exception
                  when no_data_found then
                     d_result := null;
               end;
         end;
      end if;
      return d_result;
   end;

begin

   -- inserimento degli errori nella tabella

   s_error_table(s_dal_al_errato_num) := s_dal_al_errato_msg;
   s_error_table(s_capienza_superata_number) := s_capienza_superata_msg;
   s_error_table(s_dal_sovrapposto_num) := s_dal_sovrapposto_msg;
   s_error_table(s_al_sovrapposto_num) := s_al_sovrapposto_msg;
   s_error_table(s_esistono_uf_num) := s_esistono_uf_msg;
   s_error_table(s_esistono_uf2_num) := s_esistono_uf2_msg;
   s_error_table(s_esistono_assegnazioni_num) := s_esistono_assegnazioni_msg;
   s_error_table(s_esistono_attributi_num) := s_esistono_attributi_msg;
   s_error_table(s_periodi_sovrapposti_num) := s_periodi_sovrapposti_msg;
   s_error_table(s_assegnabile_errato_number) := s_assegnabile_errato_msg;

end anagrafe_unita_fisica;
/

