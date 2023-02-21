CREATE OR REPLACE package body impostazione is
   /******************************************************************************
    NOME:        impostazione
    DESCRIZIONE: Gestione tabella impostazioni.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore     Descrizione.
    000   07/09/2009  VDAVALLI   Prima emissione.
    001   03/09/2009  VDAVALLI   Modifiche per configurazione master/slave
    002   07/09/2009  VDAVALLI   Aggiunti nuovi campi
    003   21/12/2009  APASSUELLO Aggiunto campo DATA_INIZIO_INTEGRAZIONE
    004   08/10/2010  AP         Modificato package per gestione campi OBBLIGO_IMBI, OBBLIGO_SEFI
    005   17/04/2013  ADADAMO    Redmine Bug #240
   ******************************************************************************/

   s_revisione_body constant afc.t_revision := '005';

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
   end versione; -- impostazione.versione

   --------------------------------------------------------------------------------

   function pk(p_id_parametri in impostazioni.id_parametri%type) return t_pk is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        PK
       DESCRIZIONE: Costruttore di un t_PK dati gli attributi della chiave
      ******************************************************************************/
      d_result t_pk;
   begin
   
      d_result.id_parametri := p_id_parametri;
   
      dbc.pre(not dbc.preon or canhandle(p_id_parametri => d_result.id_parametri)
             ,'canHandle on impostazione.PK');
      return d_result;
   
   end pk; -- impostazione.PK

   --------------------------------------------------------------------------------

   function can_handle(p_id_parametri in impostazioni.id_parametri%type) return number is
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
      if d_result = 1 and (p_id_parametri is null) then
         d_result := 0;
      end if;
   
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on impostazione.can_handle');
   
      return d_result;
   
   end can_handle; -- impostazione.can_handle

   --------------------------------------------------------------------------------

   function canhandle(p_id_parametri in impostazioni.id_parametri%type) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        canHandle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: true se la chiave è manipolabile, false altrimenti.
       NOTE:        Wrapper boolean di can_handle (cfr. can_handle).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(can_handle(p_id_parametri => p_id_parametri));
   begin
      return d_result;
   end canhandle; -- impostazione.canHandle

   --------------------------------------------------------------------------------

   function exists_id(p_id_parametri in impostazioni.id_parametri%type) return number is
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
   
      dbc.pre(not dbc.preon or canhandle(p_id_parametri => p_id_parametri)
             ,'canHandle on impostazione.exists_id');
   
      begin
         select 1 into d_result from impostazioni where id_parametri = p_id_parametri;
      exception
         when no_data_found then
            d_result := 0;
      end;
   
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on impostazione.exists_id');
   
      return d_result;
   end exists_id; -- impostazione.exists_id

   --------------------------------------------------------------------------------

   function existsid(p_id_parametri in impostazioni.id_parametri%type) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        existsId
       DESCRIZIONE: Esistenza riga con chiave indicata.
       NOTE:        Wrapper boolean di exists_id (cfr. exists_id).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(exists_id(p_id_parametri => p_id_parametri));
   begin
      return d_result;
   end existsid; -- impostazione.existsId

   --------------------------------------------------------------------------------

   procedure ins
   (
      p_id_parametri             in impostazioni.id_parametri%type
     ,p_integr_cg4               in impostazioni.integr_cg4%type default null
     ,p_integr_gp4               in impostazioni.integr_gp4%type default null
     ,p_integr_gs4               in impostazioni.integr_gs4%type default null
     ,p_assegnazione_definitiva  in impostazioni.assegnazione_definitiva%type default null
     ,p_procedura_nominativo     in impostazioni.procedura_nominativo%type default null
     ,p_visualizza_suddivisione  in impostazioni.visualizza_suddivisione%type default null
     ,p_visualizza_codice        in impostazioni.visualizza_codice%type default null
     ,p_agg_anagrafe_dipendenti  in impostazioni.agg_anagrafe_dipendenti%type default null
     ,p_data_inizio_integrazione in impostazioni.data_inizio_integrazione%type default null
     ,p_obbligo_imbi             in impostazioni.obbligo_imbi%type default null
     ,p_obbligo_sefi             in impostazioni.obbligo_sefi%type default null
   ) is
      /******************************************************************************
       NOME:        ins
       DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
       PARAMETRI:   Chiavi e attributi della table.
      ******************************************************************************/
   begin
   
      -- Check Mandatory on Insert
      dbc.pre(not dbc.preon or p_integr_cg4 is not null or /*default value*/
              'default null' is not null
             ,'p_integr_cg4 on impostazione.ins');
      dbc.pre(not dbc.preon or p_integr_gp4 is not null or /*default value*/
              'default null' is not null
             ,'p_integr_gp4 on impostazione.ins');
      dbc.pre(not dbc.preon or p_integr_gs4 is not null or /*default value*/
              'default null' is not null
             ,'p_integr_gs4 on impostazione.ins');
      dbc.pre(not dbc.preon or p_assegnazione_definitiva is not null or /*default value*/
              'default null' is not null
             ,'p_assegnazione_definitiva on impostazione.ins');
      dbc.pre(not dbc.preon or p_procedura_nominativo is not null or /*default value*/
              'default null' is not null
             ,'p_procedura_nominativo on impostazione.ins');
      dbc.pre(not dbc.preon or p_visualizza_suddivisione is not null or /*default value*/
              'default null' is not null
             ,'p_visualizza_suddivisione on impostazione.ins');
      dbc.pre(not dbc.preon or p_visualizza_codice is not null or /*default value*/
              'default null' is not null
             ,'p_visualizza_codice on impostazione.ins');
      dbc.pre(not dbc.preon or p_agg_anagrafe_dipendenti is not null or /*default value*/
              'default null' is not null
             ,'p_agg_anagrafe_dipendenti on impostazione.ins');
      dbc.pre(not dbc.preon or p_data_inizio_integrazione is not null or /*default value*/
              'default null' is not null
             ,'p_data_inizio_integrazione on impostazione.ins');
      dbc.pre(not dbc.preon or p_obbligo_imbi is not null or /*default value*/
              'default null' is not null
             ,'p_obbligo_imbi on impostazione.ins');
      dbc.pre(not dbc.preon or p_obbligo_sefi is not null or /*default value*/
              'default null' is not null
             ,'p_obbligo_sefi on impostazione.ins');
   
      dbc.pre(not dbc.preon or (p_id_parametri is null and /*default value*/
              '' is not null) -- PK nullable on insert
              or not existsid(p_id_parametri => p_id_parametri)
             ,'not existsId on impostazione.ins');
   
      insert into impostazioni
         (id_parametri
         ,integr_cg4
         ,integr_gp4
         ,integr_gs4
         ,assegnazione_definitiva
         ,procedura_nominativo
         ,visualizza_suddivisione
         ,visualizza_codice
         ,agg_anagrafe_dipendenti
         ,data_inizio_integrazione
         ,obbligo_imbi
         ,obbligo_sefi)
      values
         (p_id_parametri
         ,p_integr_cg4
         ,p_integr_gp4
         ,p_integr_gs4
         ,p_assegnazione_definitiva
         ,p_procedura_nominativo
         ,p_visualizza_suddivisione
         ,p_visualizza_codice
         ,p_agg_anagrafe_dipendenti
         ,p_data_inizio_integrazione
         ,p_obbligo_imbi
         ,p_obbligo_sefi);
   
   end ins; -- impostazione.ins

   --------------------------------------------------------------------------------

   function ins
   (
      p_id_parametri             in impostazioni.id_parametri%type
     ,p_integr_cg4               in impostazioni.integr_cg4%type default null
     ,p_integr_gp4               in impostazioni.integr_gp4%type default null
     ,p_integr_gs4               in impostazioni.integr_gs4%type default null
     ,p_assegnazione_definitiva  in impostazioni.assegnazione_definitiva%type default null
     ,p_procedura_nominativo     in impostazioni.procedura_nominativo%type default null
     ,p_visualizza_suddivisione  in impostazioni.visualizza_suddivisione%type default null
     ,p_visualizza_codice        in impostazioni.visualizza_codice%type default null
     ,p_agg_anagrafe_dipendenti  in impostazioni.agg_anagrafe_dipendenti%type default null
     ,p_data_inizio_integrazione in impostazioni.data_inizio_integrazione%type default null
     ,p_obbligo_imbi             in impostazioni.obbligo_imbi%type default null
     ,p_obbligo_sefi             in impostazioni.obbligo_sefi%type default null
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
      dbc.pre(not dbc.preon or p_integr_cg4 is not null or /*default value*/
              'default null' is not null
             ,'p_integr_cg4 on impostazione.ins');
      dbc.pre(not dbc.preon or p_integr_gp4 is not null or /*default value*/
              'default null' is not null
             ,'p_integr_gp4 on impostazione.ins');
      dbc.pre(not dbc.preon or p_integr_gs4 is not null or /*default value*/
              'default null' is not null
             ,'p_integr_gs4 on impostazione.ins');
      dbc.pre(not dbc.preon or p_assegnazione_definitiva is not null or /*default value*/
              'default null' is not null
             ,'p_assegnazione_definitiva on impostazione.ins');
      dbc.pre(not dbc.preon or p_procedura_nominativo is not null or /*default value*/
              'default null' is not null
             ,'p_procedura_nominativo on impostazione.ins');
      dbc.pre(not dbc.preon or p_visualizza_suddivisione is not null or /*default value*/
              'default null' is not null
             ,'p_visualizza_suddivisione on impostazione.ins');
      dbc.pre(not dbc.preon or p_visualizza_codice is not null or /*default value*/
              'default null' is not null
             ,'p_visualizza_codice on impostazione.ins');
      dbc.pre(not dbc.preon or p_agg_anagrafe_dipendenti is not null or /*default value*/
              'default null' is not null
             ,'p_agg_anagrafe_dipendenti on impostazione.ins');
      dbc.pre(not dbc.preon or p_data_inizio_integrazione is not null or /*default value*/
              'default null' is not null
             ,'p_data_inizio_integrazione on impostazione.ins');
      dbc.pre(not dbc.preon or p_obbligo_imbi is not null or /*default value*/
              'default null' is not null
             ,'p_obbligo_imbi on impostazione.ins');
      dbc.pre(not dbc.preon or p_obbligo_sefi is not null or /*default value*/
              'default null' is not null
             ,'p_obbligo_sefi on impostazione.ins');
   
      dbc.pre(not dbc.preon or (p_id_parametri is null and /*default value*/
              '' is not null) -- PK nullable on insert
              or not existsid(p_id_parametri => p_id_parametri)
             ,'not existsId on impostazione.ins');
   
      begin
         insert into impostazioni
            (id_parametri
            ,integr_cg4
            ,integr_gp4
            ,integr_gs4
            ,assegnazione_definitiva
            ,procedura_nominativo
            ,visualizza_suddivisione
            ,visualizza_codice
            ,agg_anagrafe_dipendenti
            ,data_inizio_integrazione
            ,obbligo_imbi
            ,obbligo_sefi)
         values
            (p_id_parametri
            ,p_integr_cg4
            ,p_integr_gp4
            ,p_integr_gs4
            ,p_assegnazione_definitiva
            ,p_procedura_nominativo
            ,p_visualizza_suddivisione
            ,p_visualizza_codice
            ,p_agg_anagrafe_dipendenti
            ,p_data_inizio_integrazione
            ,p_obbligo_imbi
            ,p_obbligo_sefi)
         returning id_parametri into d_result;
         if d_result < 0 then
            d_result := 0;
         end if;
      
      exception
         when others then
            d_result := sqlcode;
      end;
   
      return d_result;
   
   end ins; -- impostazione.ins

   --------------------------------------------------------------------------------

   procedure upd
   (
      p_check_old                    in integer default 0
     ,p_new_id_parametri             in impostazioni.id_parametri%type
     ,p_old_id_parametri             in impostazioni.id_parametri%type default null
     ,p_new_integr_cg4               in impostazioni.integr_cg4%type default null
     ,p_old_integr_cg4               in impostazioni.integr_cg4%type default null
     ,p_new_integr_gp4               in impostazioni.integr_gp4%type default null
     ,p_old_integr_gp4               in impostazioni.integr_gp4%type default null
     ,p_new_integr_gs4               in impostazioni.integr_gs4%type default null
     ,p_old_integr_gs4               in impostazioni.integr_gs4%type default null
     ,p_new_assegnazione_definitiva  in impostazioni.assegnazione_definitiva%type default null
     ,p_old_assegnazione_definitiva  in impostazioni.assegnazione_definitiva%type default null
     ,p_new_procedura_nominativo     in impostazioni.procedura_nominativo%type default null
     ,p_old_procedura_nominativo     in impostazioni.procedura_nominativo%type default null
     ,p_new_visualizza_suddivisione  in impostazioni.visualizza_suddivisione%type default null
     ,p_old_visualizza_suddivisione  in impostazioni.visualizza_suddivisione%type default null
     ,p_new_visualizza_codice        in impostazioni.visualizza_codice%type default null
     ,p_old_visualizza_codice        in impostazioni.visualizza_codice%type default null
     ,p_new_agg_anagrafe_dipendenti  in impostazioni.agg_anagrafe_dipendenti%type default null
     ,p_old_agg_anagrafe_dipendenti  in impostazioni.agg_anagrafe_dipendenti%type default null
     ,p_new_data_inizio_integrazione in impostazioni.data_inizio_integrazione%type default null
     ,p_old_data_inizio_integrazione in impostazioni.data_inizio_integrazione%type default null
     ,p_new_obbligo_imbi             in impostazioni.obbligo_imbi%type default null
     ,p_old_obbligo_imbi             in impostazioni.obbligo_imbi%type default null
     ,p_new_obbligo_sefi             in impostazioni.obbligo_sefi%type default null
     ,p_old_obbligo_sefi             in impostazioni.obbligo_sefi%type default null
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
                    Se p_check_old = 1, viene controllato se il record corrispondente a
                    tutti i campi passati come parametri esiste nella tabella.
                    Se p_check_old è NULL, viene controllato se il record corrispondente
                    ai soli campi passati come parametri esiste nella tabella.
      ******************************************************************************/
      d_key       t_pk;
      d_row_found number;
   begin
   
      dbc.pre(not dbc.preon or
              not ((p_old_integr_cg4 is not null or p_old_integr_gp4 is not null or
               p_old_integr_gs4 is not null or
               p_old_assegnazione_definitiva is not null or
               p_old_procedura_nominativo is not null or
               p_old_visualizza_suddivisione is not null or
               p_old_visualizza_codice is not null or
               p_old_agg_anagrafe_dipendenti is not null or
               p_old_data_inizio_integrazione is not null or
               p_old_obbligo_imbi is not null or p_old_obbligo_sefi is not null) and
               (nvl(p_check_old, -1) = 0))
             ,' "OLD values" is not null on impostazione.upd');
   
      d_key := pk(nvl(p_old_id_parametri, p_new_id_parametri));
   
      dbc.pre(not dbc.preon or existsid(p_id_parametri => d_key.id_parametri)
             ,'existsId on impostazione.upd');
   
      update impostazioni
         set id_parametri             = p_new_id_parametri
            ,integr_cg4               = p_new_integr_cg4
            ,integr_gp4               = p_new_integr_gp4
            ,integr_gs4               = p_new_integr_gs4
            ,assegnazione_definitiva  = p_new_assegnazione_definitiva
            ,procedura_nominativo     = p_new_procedura_nominativo
            ,visualizza_suddivisione  = p_new_visualizza_suddivisione
            ,visualizza_codice        = p_new_visualizza_codice
            ,agg_anagrafe_dipendenti  = p_new_agg_anagrafe_dipendenti
            ,data_inizio_integrazione = p_new_data_inizio_integrazione
            ,obbligo_imbi             = p_new_obbligo_imbi
            ,obbligo_sefi             = p_new_obbligo_sefi
       where id_parametri = d_key.id_parametri
         and (p_check_old = 0 or
             ((integr_cg4 = p_old_integr_cg4 or
             (p_old_integr_cg4 is null and (p_check_old is null or integr_cg4 is null))) and
             (integr_gp4 = p_old_integr_gp4 or
             (p_old_integr_gp4 is null and (p_check_old is null or integr_gp4 is null))) and
             (integr_gs4 = p_old_integr_gs4 or
             (p_old_integr_gs4 is null and (p_check_old is null or integr_gs4 is null))) and
             (assegnazione_definitiva = p_old_assegnazione_definitiva or
             (p_old_assegnazione_definitiva is null and
             (p_check_old is null or assegnazione_definitiva is null))) and
             (procedura_nominativo = p_old_procedura_nominativo or
             (p_old_procedura_nominativo is null and
             (p_check_old is null or procedura_nominativo is null))) and
             (visualizza_suddivisione = p_old_visualizza_suddivisione or
             (p_old_visualizza_suddivisione is null and
             (p_check_old is null or visualizza_suddivisione is null))) and
             (visualizza_codice = p_old_visualizza_codice or
             (p_old_visualizza_codice is null and
             (p_check_old is null or visualizza_codice is null))) and
             (agg_anagrafe_dipendenti = p_old_agg_anagrafe_dipendenti or
             (p_old_agg_anagrafe_dipendenti is null and
             (p_check_old is null or agg_anagrafe_dipendenti is null))) and
             (data_inizio_integrazione = p_old_data_inizio_integrazione or
             (p_old_data_inizio_integrazione is null and
             (p_check_old is null or data_inizio_integrazione is null))) and
             (obbligo_imbi = p_old_obbligo_imbi or
             (p_old_obbligo_imbi is null and
             (p_check_old is null or obbligo_imbi is null))) and
             (obbligo_sefi = p_old_obbligo_sefi or
             (p_old_obbligo_sefi is null and
             (p_check_old is null or obbligo_sefi is null)))));
      d_row_found := sql%rowcount;
   
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on impostazione.upd');
   
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   
   end upd; -- impostazione.upd

   --------------------------------------------------------------------------------

   procedure upd_column
   (
      p_id_parametri  in impostazioni.id_parametri%type
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
   
      dbc.pre(not dbc.preon or existsid(p_id_parametri => p_id_parametri)
             ,'existsId on impostazione.upd_column');
      dbc.pre(not dbc.preon or p_column is not null
             ,'p_column is not null on impostazione.upd_column');
      dbc.pre(not dbc.preon or afc_ddl.hasattribute(s_table_name, p_column)
             ,'AFC_DDL.HasAttribute on impostazione.upd_column');
      dbc.pre(p_literal_value in (0, 1) or p_literal_value is null
             ,'p_literal_value on impostazione.upd_column; p_literal_value = ' ||
              p_literal_value);
   
      if p_literal_value = 1 or p_literal_value is null then
         d_literal := '''';
      end if;
   
      d_statement := ' declare ' || '    d_row_found number; ' || ' begin ' ||
                     '    update impostazioni' || '       set ' || p_column || ' = ' ||
                     d_literal || p_value || d_literal || '     where 1 = 1 ' ||
                     nvl(afc.get_field_condition(' and ( id_parametri '
                                                ,p_id_parametri
                                                ,' )'
                                                ,0
                                                ,null)
                        ,' and ( id_parametri is null ) ') || '    ; ' ||
                     '    d_row_found := SQL%ROWCOUNT; ' || '    if d_row_found < 1 ' ||
                     '    then ' ||
                     '       raise_application_error ( AFC_ERROR.modified_by_other_user_number, AFC_ERROR.modified_by_other_user_msg ); ' ||
                     '    end if; ' || ' end; ';
   
      afc.sql_execute(d_statement);
   
   end upd_column; -- impostazione.upd_column

   --------------------------------------------------------------------------------

   procedure upd_column
   (
      p_id_parametri in impostazioni.id_parametri%type
     ,p_column       in varchar2
     ,p_value        in date
   ) is
      /******************************************************************************
       NOME:        upd_column
       DESCRIZIONE: Aggiornamento del campo p_column col valore p_value.
       
       NOTE:        Richiama se stessa con il parametro date convertito in stringa.
      ******************************************************************************/
      d_data varchar2(19);
   begin
      d_data := to_char(p_value, afc.date_format);
      upd_column(p_id_parametri  => p_id_parametri
                ,p_column        => p_column
                ,p_value         => 'to_date( ''' || d_data || ''', ''' ||
                                    afc.date_format || ''' )'
                ,p_literal_value => 0);
   end upd_column; -- impostazione.upd_column

   --------------------------------------------------------------------------------

   procedure del
   (
      p_check_old                in integer default 0
     ,p_id_parametri             in impostazioni.id_parametri%type
     ,p_integr_cg4               in impostazioni.integr_cg4%type default null
     ,p_integr_gp4               in impostazioni.integr_gp4%type default null
     ,p_integr_gs4               in impostazioni.integr_gs4%type default null
     ,p_assegnazione_definitiva  in impostazioni.assegnazione_definitiva%type default null
     ,p_procedura_nominativo     in impostazioni.procedura_nominativo%type default null
     ,p_visualizza_suddivisione  in impostazioni.visualizza_suddivisione%type default null
     ,p_visualizza_codice        in impostazioni.visualizza_codice%type default null
     ,p_agg_anagrafe_dipendenti  in impostazioni.agg_anagrafe_dipendenti%type default null
     ,p_data_inizio_integrazione in impostazioni.data_inizio_integrazione%type default null
     ,p_obbligo_imbi             in impostazioni.obbligo_imbi%type default null
     ,p_obbligo_sefi             in impostazioni.obbligo_sefi%type default null
      
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
                    Se p_check_old è NULL, viene controllato se il record corrispondente
                ai soli campi passati come parametri esiste nella tabella.
      ******************************************************************************/
      d_row_found number;
   begin
   
      dbc.pre(not dbc.preon or
              not
               ((p_integr_cg4 is not null or p_integr_gp4 is not null or
               p_integr_gs4 is not null or p_assegnazione_definitiva is not null or
               p_procedura_nominativo is not null or
               p_visualizza_suddivisione is not null or p_visualizza_codice is not null or
               p_agg_anagrafe_dipendenti is not null or
               p_data_inizio_integrazione is not null or p_obbligo_imbi is not null or
               p_obbligo_sefi is not null) and (nvl(p_check_old, -1) = 0))
             ,' "OLD values" is not null on impostazione.del');
   
      dbc.pre(not dbc.preon or existsid(p_id_parametri => p_id_parametri)
             ,'existsId on impostazione.del');
   
      delete from impostazioni
       where id_parametri = p_id_parametri
         and (p_check_old = 0 or
             ((integr_cg4 = p_integr_cg4 or
             (p_integr_cg4 is null and (p_check_old is null or integr_cg4 is null))) and
             (integr_gp4 = p_integr_gp4 or
             (p_integr_gp4 is null and (p_check_old is null or integr_gp4 is null))) and
             (integr_gs4 = p_integr_gs4 or
             (p_integr_gs4 is null and (p_check_old is null or integr_gs4 is null))) and
             (assegnazione_definitiva = p_assegnazione_definitiva or
             (p_assegnazione_definitiva is null and
             (p_check_old is null or assegnazione_definitiva is null))) and
             (procedura_nominativo = p_procedura_nominativo or
             (p_procedura_nominativo is null and
             (p_check_old is null or procedura_nominativo is null))) and
             (visualizza_suddivisione = p_visualizza_suddivisione or
             (p_visualizza_suddivisione is null and
             (p_check_old is null or visualizza_suddivisione is null))) and
             (visualizza_codice = p_visualizza_codice or
             (p_visualizza_codice is null and
             (p_check_old is null or visualizza_codice is null))) and
             (agg_anagrafe_dipendenti = p_agg_anagrafe_dipendenti or
             (p_agg_anagrafe_dipendenti is null and
             (p_check_old is null or agg_anagrafe_dipendenti is null))) and
             (data_inizio_integrazione = p_data_inizio_integrazione or
             (p_data_inizio_integrazione is null and
             (p_check_old is null or data_inizio_integrazione is null))) and
             (obbligo_imbi = p_obbligo_imbi or
             (p_obbligo_imbi is null and (p_check_old is null or obbligo_imbi is null))) and
             (obbligo_sefi = p_obbligo_sefi or
             (p_obbligo_sefi is null and (p_check_old is null or obbligo_sefi is null)))));
      d_row_found := sql%rowcount;
   
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on impostazione.del');
   
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   
      dbc.post(not dbc.poston or not existsid(p_id_parametri => p_id_parametri)
              ,'existsId on impostazione.del');
   
   end del; -- impostazione.del

   --------------------------------------------------------------------------------

   function get_integr_cg4(p_id_parametri in impostazioni.id_parametri%type)
      return impostazioni.integr_cg4%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_integr_cg4
       DESCRIZIONE: Getter per attributo integr_cg4 di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     impostazioni.integr_cg4%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result impostazioni.integr_cg4%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_parametri => p_id_parametri)
             ,'existsId on impostazione.get_integr_cg4');
   
      select integr_cg4
        into d_result
        from impostazioni
       where id_parametri = p_id_parametri;
   
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on impostazione.get_integr_cg4');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'integr_cg4')
                      ,' AFC_DDL.IsNullable on impostazione.get_integr_cg4');
      end if;
   
      return d_result;
   end get_integr_cg4; -- impostazione.get_integr_cg4

   --------------------------------------------------------------------------------

   function get_integr_gp4(p_id_parametri in impostazioni.id_parametri%type)
      return impostazioni.integr_gp4%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_integr_gp4
       DESCRIZIONE: Getter per attributo integr_gp4 di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     impostazioni.integr_gp4%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result impostazioni.integr_gp4%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_parametri => p_id_parametri)
             ,'existsId on impostazione.get_integr_gp4');
   
      select decode(SO4_PKG.GET_INTEGRAZIONE_GP,'SI','SI',integr_gp4)
        into d_result
        from impostazioni
       where id_parametri = p_id_parametri;
   
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on impostazione.get_integr_gp4');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'integr_gp4')
                      ,' AFC_DDL.IsNullable on impostazione.get_integr_gp4');
      end if;
   
      return d_result;
   end get_integr_gp4; -- impostazione.get_integr_gp4

   --------------------------------------------------------------------------------

   function get_integr_gs4(p_id_parametri in impostazioni.id_parametri%type)
      return impostazioni.integr_gs4%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_integr_gs4
       DESCRIZIONE: Getter per attributo integr_gs4 di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     impostazioni.integr_gs4%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result impostazioni.integr_gs4%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_parametri => p_id_parametri)
             ,'existsId on impostazione.get_integr_gs4');
   
      select integr_gs4
        into d_result
        from impostazioni
       where id_parametri = p_id_parametri;
   
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on impostazione.get_integr_gs4');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'integr_gs4')
                      ,' AFC_DDL.IsNullable on impostazione.get_integr_gs4');
      end if;
   
      return d_result;
   end get_integr_gs4; -- impostazione.get_integr_gs4

   --------------------------------------------------------------------------------

   function get_assegnazione_definitiva(p_id_parametri in impostazioni.id_parametri%type)
      return impostazioni.assegnazione_definitiva%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_assegnazione_definitiva
       DESCRIZIONE: Getter per attributo assegnazione_definitiva di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     impostazioni.assegnazione_definitiva%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result impostazioni.assegnazione_definitiva%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_parametri => p_id_parametri)
             ,'existsId on impostazione.get_assegnazione_definitiva');
   
      select assegnazione_definitiva
        into d_result
        from impostazioni
       where id_parametri = p_id_parametri;
   
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on impostazione.get_assegnazione_definitiva');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'assegnazione_definitiva')
                      ,' AFC_DDL.IsNullable on impostazione.get_assegnazione_definitiva');
      end if;
   
      return d_result;
   end get_assegnazione_definitiva; -- impostazione.get_assegnazione_definitiva

   --------------------------------------------------------------------------------

   function get_procedura_nominativo(p_id_parametri in impostazioni.id_parametri%type)
      return impostazioni.procedura_nominativo%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_procedura_nominativo
       DESCRIZIONE: Getter per attributo procedura_nominativo di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     impostazioni.procedura_nominativo%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result impostazioni.procedura_nominativo%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_parametri => p_id_parametri)
             ,'existsId on impostazione.get_procedura_nominativo');
   
      select procedura_nominativo
        into d_result
        from impostazioni
       where id_parametri = p_id_parametri;
   
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on impostazione.get_procedura_nominativo');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'procedura_nominativo')
                      ,' AFC_DDL.IsNullable on impostazione.get_procedura_nominativo');
      end if;
   
      return d_result;
   end get_procedura_nominativo; -- impostazione.get_procedura_nominativo

   --------------------------------------------------------------------------------

   function get_visualizza_suddivisione(p_id_parametri in impostazioni.id_parametri%type)
      return impostazioni.visualizza_suddivisione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_visualizza_suddivisione
       DESCRIZIONE: Getter per attributo visualizza_suddivisione di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     impostazioni.visualizza_suddivisione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result impostazioni.visualizza_suddivisione%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_parametri => p_id_parametri)
             ,'existsId on impostazione.get_visualizza_suddivisione');
   
      select visualizza_suddivisione
        into d_result
        from impostazioni
       where id_parametri = p_id_parametri;
   
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on impostazione.get_visualizza_suddivisione');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'visualizza_suddivisione')
                      ,' AFC_DDL.IsNullable on impostazione.get_visualizza_suddivisione');
      end if;
   
      return d_result;
   end get_visualizza_suddivisione; -- impostazione.get_visualizza_suddivisione

   --------------------------------------------------------------------------------

   function get_visualizza_codice(p_id_parametri in impostazioni.id_parametri%type)
      return impostazioni.visualizza_codice%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_visualizza_codice
       DESCRIZIONE: Getter per attributo visualizza_codice di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     impostazioni.visualizza_codice%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result impostazioni.visualizza_codice%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_parametri => p_id_parametri)
             ,'existsId on impostazione.get_visualizza_codice');
   
      select visualizza_codice
        into d_result
        from impostazioni
       where id_parametri = p_id_parametri;
   
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on impostazione.get_visualizza_codice');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'visualizza_codice')
                      ,' AFC_DDL.IsNullable on impostazione.get_visualizza_codice');
      end if;
   
      return d_result;
   end get_visualizza_codice; -- impostazione.get_visualizza_codice

   --------------------------------------------------------------------------------

   function get_agg_anagrafe_dipendenti(p_id_parametri in impostazioni.id_parametri%type)
      return impostazioni.agg_anagrafe_dipendenti%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_agg_anagrafe_dipendenti
       DESCRIZIONE: Getter per attributo agg_anagrafe_dipendenti di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     impostazioni.agg_anagrafe_dipendenti%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result impostazioni.agg_anagrafe_dipendenti%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_parametri => p_id_parametri)
             ,'existsId on impostazione.get_agg_anagrafe_dipendenti');
   
      select agg_anagrafe_dipendenti
        into d_result
        from impostazioni
       where id_parametri = p_id_parametri;
   
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on impostazione.get_agg_anagrafe_dipendenti');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'agg_anagrafe_dipendenti')
                      ,' AFC_DDL.IsNullable on impostazione.get_agg_anagrafe_dipendenti');
      end if;
   
      return d_result;
   end get_agg_anagrafe_dipendenti; -- impostazione.get_agg_anagrafe_dipendenti

   --------------------------------------------------------------------------------

   function get_data_inizio_integrazione(p_id_parametri in impostazioni.id_parametri%type)
      return impostazioni.data_inizio_integrazione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_data_inizio_integrazione
       DESCRIZIONE: Getter per attributo data_inizio_integrazione di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     impostazioni.data_inizio_integrazione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result impostazioni.data_inizio_integrazione%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_parametri => p_id_parametri)
             ,'existsId on impostazione.get_data_inizio_integrazione');
   
      select data_inizio_integrazione
        into d_result
        from impostazioni
       where id_parametri = p_id_parametri;
   
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on impostazione.get_data_inizio_integrazione');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'data_inizio_integrazione')
                      ,' AFC_DDL.IsNullable on impostazione.get_data_inizio_integrazione');
      end if;
   
      return d_result;
   end get_data_inizio_integrazione; -- impostazione.get_data_inizio_integrazione

   --------------------------------------------------------------------------------

   function get_obbligo_imbi(p_id_parametri in impostazioni.id_parametri%type)
      return impostazioni.obbligo_imbi%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_obbligo_imbi
       DESCRIZIONE: Getter per attributo obbligo_imbi di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     impostazioni.obbligo_imbi%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result impostazioni.obbligo_imbi%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_parametri => p_id_parametri)
             ,'existsId on impostazione.get_obbligo_imbi');
   
      select obbligo_imbi
        into d_result
        from impostazioni
       where id_parametri = p_id_parametri;
   
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on impostazione.get_obbligo_imbi');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'obbligo_imbi')
                      ,' AFC_DDL.IsNullable on impostazione.get_obbligo_imbi');
      end if;
   
      return d_result;
   end get_obbligo_imbi; -- impostazione.get_obbligo_imbi

   --------------------------------------------------------------------------------

   function get_obbligo_sefi(p_id_parametri in impostazioni.id_parametri%type)
      return impostazioni.obbligo_sefi%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_obbligo_sefi
       DESCRIZIONE: Getter per attributo obbligo_sefi di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     impostazioni.obbligo_sefi%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result impostazioni.obbligo_sefi%type;
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_parametri => p_id_parametri)
             ,'existsId on impostazione.get_obbligo_sefi');
   
      select obbligo_sefi
        into d_result
        from impostazioni
       where id_parametri = p_id_parametri;
   
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on impostazione.get_obbligo_sefi');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'obbligo_sefi')
                      ,' AFC_DDL.IsNullable on impostazione.get_obbligo_sefi');
      end if;
   
      return d_result;
   end get_obbligo_sefi; -- impostazione.get_obbligo_sefi

   --------------------------------------------------------------------------------

   procedure set_id_parametri
   (
      p_id_parametri in impostazioni.id_parametri%type
     ,p_value        in impostazioni.id_parametri%type default null
   ) is
      /******************************************************************************
       NOME:        set_id_parametri
       DESCRIZIONE: Setter per attributo id_parametri di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_parametri => p_id_parametri)
             ,'existsId on impostazione.set_id_parametri');
   
      update impostazioni set id_parametri = p_value where id_parametri = p_id_parametri;
   
   end set_id_parametri; -- impostazione.set_id_parametri

   --------------------------------------------------------------------------------

   procedure set_integr_cg4
   (
      p_id_parametri in impostazioni.id_parametri%type
     ,p_value        in impostazioni.integr_cg4%type default null
   ) is
      /******************************************************************************
       NOME:        set_integr_cg4
       DESCRIZIONE: Setter per attributo integr_cg4 di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_parametri => p_id_parametri)
             ,'existsId on impostazione.set_integr_cg4');
   
      update impostazioni set integr_cg4 = p_value where id_parametri = p_id_parametri;
   
   end set_integr_cg4; -- impostazione.set_integr_cg4

   --------------------------------------------------------------------------------

   procedure set_integr_gp4
   (
      p_id_parametri in impostazioni.id_parametri%type
     ,p_value        in impostazioni.integr_gp4%type default null
   ) is
      /******************************************************************************
       NOME:        set_integr_gp4
       DESCRIZIONE: Setter per attributo integr_gp4 di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_parametri => p_id_parametri)
             ,'existsId on impostazione.set_integr_gp4');
   
      update impostazioni set integr_gp4 = p_value where id_parametri = p_id_parametri;
   
   end set_integr_gp4; -- impostazione.set_integr_gp4

   --------------------------------------------------------------------------------

   procedure set_integr_gs4
   (
      p_id_parametri in impostazioni.id_parametri%type
     ,p_value        in impostazioni.integr_gs4%type default null
   ) is
      /******************************************************************************
       NOME:        set_integr_gs4
       DESCRIZIONE: Setter per attributo integr_gs4 di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_parametri => p_id_parametri)
             ,'existsId on impostazione.set_integr_gs4');
   
      update impostazioni set integr_gs4 = p_value where id_parametri = p_id_parametri;
   
   end set_integr_gs4; -- impostazione.set_integr_gs4

   --------------------------------------------------------------------------------

   procedure set_assegnazione_definitiva
   (
      p_id_parametri in impostazioni.id_parametri%type
     ,p_value        in impostazioni.assegnazione_definitiva%type default null
   ) is
      /******************************************************************************
       NOME:        set_assegnazione_definitiva
       DESCRIZIONE: Setter per attributo assegnazione_definitiva di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_parametri => p_id_parametri)
             ,'existsId on impostazione.set_assegnazione_definitiva');
   
      update impostazioni
         set assegnazione_definitiva = p_value
       where id_parametri = p_id_parametri;
   
   end set_assegnazione_definitiva; -- impostazione.set_assegnazione_definitiva

   --------------------------------------------------------------------------------

   procedure set_procedura_nominativo
   (
      p_id_parametri in impostazioni.id_parametri%type
     ,p_value        in impostazioni.procedura_nominativo%type default null
   ) is
      /******************************************************************************
       NOME:        set_procedura_nominativo
       DESCRIZIONE: Setter per attributo procedura_nominativo di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_parametri => p_id_parametri)
             ,'existsId on impostazione.set_procedura_nominativo');
   
      update impostazioni
         set procedura_nominativo = p_value
       where id_parametri = p_id_parametri;
   
   end set_procedura_nominativo; -- impostazione.set_procedura_nominativo

   --------------------------------------------------------------------------------

   procedure set_visualizza_suddivisione
   (
      p_id_parametri in impostazioni.id_parametri%type
     ,p_value        in impostazioni.visualizza_suddivisione%type default null
   ) is
      /******************************************************************************
       NOME:        set_visualizza_suddivisione
       DESCRIZIONE: Setter per attributo visualizza_suddivisione di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_parametri => p_id_parametri)
             ,'existsId on impostazione.set_visualizza_suddivisione');
   
      update impostazioni
         set visualizza_suddivisione = p_value
       where id_parametri = p_id_parametri;
   
   end set_visualizza_suddivisione; -- impostazione.set_visualizza_suddivisione

   --------------------------------------------------------------------------------

   procedure set_visualizza_codice
   (
      p_id_parametri in impostazioni.id_parametri%type
     ,p_value        in impostazioni.visualizza_codice%type default null
   ) is
      /******************************************************************************
       NOME:        set_visualizza_codice
       DESCRIZIONE: Setter per attributo visualizza_codice di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_parametri => p_id_parametri)
             ,'existsId on impostazione.set_visualizza_codice');
   
      update impostazioni
         set visualizza_codice = p_value
       where id_parametri = p_id_parametri;
   
   end set_visualizza_codice; -- impostazione.set_visualizza_codice

   --------------------------------------------------------------------------------

   procedure set_agg_anagrafe_dipendenti
   (
      p_id_parametri in impostazioni.id_parametri%type
     ,p_value        in impostazioni.agg_anagrafe_dipendenti%type default null
   ) is
      /******************************************************************************
       NOME:        set_agg_anagrafe_dipendenti
       DESCRIZIONE: Setter per attributo agg_anagrafe_dipendenti di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_parametri => p_id_parametri)
             ,'existsId on impostazione.set_agg_anagrafe_dipendenti');
   
      update impostazioni
         set agg_anagrafe_dipendenti = p_value
       where id_parametri = p_id_parametri;
   
   end set_agg_anagrafe_dipendenti; -- impostazione.set_agg_anagrafe_dipendenti

   --------------------------------------------------------------------------------

   procedure set_data_inizio_integrazione
   (
      p_id_parametri in impostazioni.id_parametri%type
     ,p_value        in impostazioni.data_inizio_integrazione%type default null
   ) is
      /******************************************************************************
       NOME:        set_data_inizio_integrazione
       DESCRIZIONE: Setter per attributo data_inizio_integrazione di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_parametri => p_id_parametri)
             ,'existsId on impostazione.set_data_inizio_integrazione');
   
      update impostazioni
         set data_inizio_integrazione = p_value
       where id_parametri = p_id_parametri;
   
   end set_data_inizio_integrazione; -- impostazione.set_data_inizio_integrazione

   --------------------------------------------------------------------------------

   procedure set_obbligo_imbi
   (
      p_id_parametri in impostazioni.id_parametri%type
     ,p_value        in impostazioni.obbligo_imbi%type default null
   ) is
      /******************************************************************************
       NOME:        set_obbligo_imbi
       DESCRIZIONE: Setter per attributo obbligo_imbi di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_parametri => p_id_parametri)
             ,'existsId on impostazione.set_obbligo_imbi');
   
      update impostazioni set obbligo_imbi = p_value where id_parametri = p_id_parametri;
   
   end set_obbligo_imbi; -- impostazione.set_obbligo_imbi

   --------------------------------------------------------------------------------

   procedure set_obbligo_sefi
   (
      p_id_parametri in impostazioni.id_parametri%type
     ,p_value        in impostazioni.obbligo_sefi%type default null
   ) is
      /******************************************************************************
       NOME:        set_obbligo_sefi
       DESCRIZIONE: Setter per attributo obbligo_sefi di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
   begin
   
      dbc.pre(not dbc.preon or existsid(p_id_parametri => p_id_parametri)
             ,'existsId on impostazione.set_obbligo_sefi');
   
      update impostazioni set obbligo_sefi = p_value where id_parametri = p_id_parametri;
   
   end set_obbligo_sefi; -- impostazione.set_obbligo_sefi

   --------------------------------------------------------------------------------

   function where_condition /* SLAVE_COPY */
   (
      p_qbe                      in number default 0
     ,p_other_condition          in varchar2 default null
     ,p_id_parametri             in varchar2 default null
     ,p_integr_cg4               in varchar2 default null
     ,p_integr_gp4               in varchar2 default null
     ,p_integr_gs4               in varchar2 default null
     ,p_assegnazione_definitiva  in varchar2 default null
     ,p_procedura_nominativo     in varchar2 default null
     ,p_visualizza_suddivisione  in varchar2 default null
     ,p_visualizza_codice        in varchar2 default null
     ,p_agg_anagrafe_dipendenti  in varchar2 default null
     ,p_data_inizio_integrazione in date default null
     ,p_obbligo_imbi             in varchar2 default null
     ,p_obbligo_sefi             in varchar2 default null
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
                    Chiavi e attributi della table
      
       RITORNA:     AFC.t_statement.
       NOTE:        Se p_QBE = 1 , ogni parametro deve contenere, nella prima parte,
                    l'operatore da utilizzare nella where-condition.
      ******************************************************************************/
      d_statement afc.t_statement;
   begin
   
      d_statement := ' where ( 1 = 1 ' ||
                     afc.get_field_condition(' and ( id_parametri '
                                            ,p_id_parametri
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( integr_cg4 '
                                            ,p_integr_cg4
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( integr_gp4 '
                                            ,p_integr_gp4
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( integr_gs4 '
                                            ,p_integr_gs4
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( assegnazione_definitiva '
                                            ,p_assegnazione_definitiva
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( procedura_nominativo '
                                            ,p_procedura_nominativo
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( visualizza_suddivisione '
                                            ,p_visualizza_suddivisione
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( visualizza_codice '
                                            ,p_visualizza_codice
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( agg_anagrafe_dipendenti '
                                            ,p_agg_anagrafe_dipendenti
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( data_inizio_integrazione '
                                            ,p_data_inizio_integrazione
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( obbligo_imbi '
                                            ,p_obbligo_imbi
                                            ,' )'
                                            ,p_qbe
                                            ,null) ||
                     afc.get_field_condition(' and ( obbligo_sefi '
                                            ,p_obbligo_sefi
                                            ,' )'
                                            ,p_qbe
                                            ,null) || ' ) ' || p_other_condition;
   
      return d_statement;
   
   end where_condition; --- impostazione.where_condition

   --------------------------------------------------------------------------------

   function get_rows
   (
      p_qbe                      in number default 0
     ,p_other_condition          in varchar2 default null
     ,p_order_by                 in varchar2 default null
     ,p_extra_columns            in varchar2 default null
     ,p_extra_condition          in varchar2 default null
     ,p_id_parametri             in varchar2 default null
     ,p_integr_cg4               in varchar2 default null
     ,p_integr_gp4               in varchar2 default null
     ,p_integr_gs4               in varchar2 default null
     ,p_assegnazione_definitiva  in varchar2 default null
     ,p_procedura_nominativo     in varchar2 default null
     ,p_visualizza_suddivisione  in varchar2 default null
     ,p_visualizza_codice        in varchar2 default null
     ,p_agg_anagrafe_dipendenti  in varchar2 default null
     ,p_data_inizio_integrazione in varchar2 default null
     ,p_obbligo_imbi             in varchar2 default null
     ,p_obbligo_sefi             in varchar2 default null
   ) return afc.t_ref_cursor is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_rows
       DESCRIZIONE: Ritorna il risultato di una query in base ai valori che passiamo. 
       PARAMETRI:   p_QBE 0: viene controllato se all'inizio di ogni attributo è presente
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
   
      d_statement := ' select impostazioni.* ' ||
                     afc.decode_value(p_extra_columns
                                     ,null
                                     ,null
                                     ,' , ' || p_extra_columns) || ' from impostazioni ' ||
                     where_condition(p_qbe                      => p_qbe
                                    ,p_other_condition          => p_other_condition
                                    ,p_id_parametri             => p_id_parametri
                                    ,p_integr_cg4               => p_integr_cg4
                                    ,p_integr_gp4               => p_integr_gp4
                                    ,p_integr_gs4               => p_integr_gs4
                                    ,p_assegnazione_definitiva  => p_assegnazione_definitiva
                                    ,p_procedura_nominativo     => p_procedura_nominativo
                                    ,p_visualizza_suddivisione  => p_visualizza_suddivisione
                                    ,p_visualizza_codice        => p_visualizza_codice
                                    ,p_agg_anagrafe_dipendenti  => p_agg_anagrafe_dipendenti
                                    ,p_data_inizio_integrazione => p_data_inizio_integrazione
                                    ,p_obbligo_imbi             => p_obbligo_imbi
                                    ,p_obbligo_sefi             => p_obbligo_sefi) || ' ' ||
                     p_extra_condition ||
                     afc.decode_value(p_order_by, null, null, ' order by ' || p_order_by);
   
      d_ref_cursor := afc_dml.get_ref_cursor(d_statement);
   
      return d_ref_cursor;
   
   end get_rows; -- impostazione.get_rows

   --------------------------------------------------------------------------------

   function count_rows
   (
      p_qbe                      in number default 0
     ,p_other_condition          in varchar2 default null
     ,p_id_parametri             in varchar2 default null
     ,p_integr_cg4               in varchar2 default null
     ,p_integr_gp4               in varchar2 default null
     ,p_integr_gs4               in varchar2 default null
     ,p_assegnazione_definitiva  in varchar2 default null
     ,p_procedura_nominativo     in varchar2 default null
     ,p_visualizza_suddivisione  in varchar2 default null
     ,p_visualizza_codice        in varchar2 default null
     ,p_agg_anagrafe_dipendenti  in varchar2 default null
     ,p_data_inizio_integrazione in varchar2 default null
     ,p_obbligo_imbi             in varchar2 default null
     ,p_obbligo_sefi             in varchar2 default null
   ) return integer is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        count_rows
       DESCRIZIONE: Ritorna il numero di righe della tabella gli attributi delle quali
                    rispettano i valori indicati.
       PARAMETRI:   p_QBE 0: viene controllato se all'inizio di ogni attributo è presente
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
   
      d_statement := ' select count( * ) from impostazioni ' ||
                     where_condition(p_qbe                      => p_qbe
                                    ,p_other_condition          => p_other_condition
                                    ,p_id_parametri             => p_id_parametri
                                    ,p_integr_cg4               => p_integr_cg4
                                    ,p_integr_gp4               => p_integr_gp4
                                    ,p_integr_gs4               => p_integr_gs4
                                    ,p_assegnazione_definitiva  => p_assegnazione_definitiva
                                    ,p_procedura_nominativo     => p_procedura_nominativo
                                    ,p_visualizza_suddivisione  => p_visualizza_suddivisione
                                    ,p_visualizza_codice        => p_visualizza_codice
                                    ,p_agg_anagrafe_dipendenti  => p_agg_anagrafe_dipendenti
                                    ,p_data_inizio_integrazione => p_data_inizio_integrazione
                                    ,p_obbligo_imbi             => p_obbligo_imbi
                                    ,p_obbligo_sefi             => p_obbligo_sefi);
   
      d_result := afc.sql_execute(d_statement);
   
      return d_result;
   end count_rows; -- impostazione.count_rows

--------------------------------------------------------------------------------

end impostazione;
/

