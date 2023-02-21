CREATE OR REPLACE package body aoo_pkg is
   /******************************************************************************
    NOME:        aoo_pkg
    DESCRIZIONE: Gestione tabella aoo.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore  Descrizione.
    000   21/07/2006  VDAVALLI  Prima emissione.
    001   02/09/2009  VDAVALLI  Modifiche per configurazione master/slave
    002   16/06/2011  VDAVALLI  Modificata funzione TROVA per lentezza: al posto
                                della function su INDIRIZZI_TELEMATICI viene usata
                                la join
    003   14/02/2014  ADADAMO   Aggiunta is_codice_aoo_ok e modificate chk_di e is_di_ok
                                Bug#365                                
    004   16/05/2014  MMONARI   Modificate is_dal_ok e is_al_ok Bug#410   
          28/05/2014  MMONARI   Bug #453                             
    005   28/04/2017  MMONARI   #761 Inibito controllo is_descrizione_ok su richiesta delivery Aff.Gen.
    006   12/05/2017  ADADAMO   Modifica per gestione aggiornamento automatico codici IPA Bug#773   
    007   03/11/2021  MMONARI   Nuovo campo codice_IPA #52548
          09/12/2021  MMONARI   #53989 conversione campo p_dal in upd_column
   ******************************************************************************/
   s_revisione_body   constant afc.t_revision := '007';
   s_table_name       constant afc.t_object_name := 'aoo';
   s_desc_column_name constant afc.t_object_name := 'descrizione';
   s_error_table afc_error.t_error_table;
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
   end; -- aoo_pkg.versione
   --------------------------------------------------------------------------------
   function pk
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return t_pk is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        PK
       DESCRIZIONE: Costruttore di un t_PK dati gli attributi della chiave
      ******************************************************************************/
      d_result t_pk;
   begin
      d_result.progr_aoo := p_progr_aoo;
      d_result.dal       := p_dal;
      dbc.pre(not dbc.preon or canhandle(d_result.progr_aoo, d_result.dal)
             ,'canHandle on aoo.PK');
      return d_result;
   end; -- end aoo_pkg.PK
   --------------------------------------------------------------------------------
   function can_handle
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
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
      if d_result = 1 and (p_progr_aoo is null or p_dal is null) then
         d_result := 0;
      end if;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on aoo.can_handle');
      return d_result;
   end; -- aoo_pkg.can_handle
   --------------------------------------------------------------------------------
   function canhandle
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        canHandle
       DESCRIZIONE: La chiave specificata rispetta tutti i requisiti sugli attributi componenti.
       PARAMETRI:   Attributi chiave.
       RITORNA:     number: true se la chiave e manipolabile, false altrimenti.
       NOTE:        Wrapper boolean di can_handle (cfr. can_handle).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(can_handle(p_progr_aoo, p_dal));
   begin
      return d_result;
   end; -- aoo_pkg.canHandle
   --------------------------------------------------------------------------------
   function exists_id
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
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
      dbc.pre(not dbc.preon or canhandle(p_progr_aoo, p_dal)
             ,'canHandle on aoo.exists_id');
      begin
         select 1
           into d_result
           from aoo
          where progr_aoo = p_progr_aoo
            and dal = p_dal;
      exception
         when no_data_found then
            d_result := 0;
      end;
      dbc.post(d_result = 1 or d_result = 0
              ,'d_result = 1  or  d_result = 0 on aoo.exists_id');
      return d_result;
   end; -- aoo_pkg.exists_id
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
         --  else
         --     raise_application_error( afc_error.exception_not_in_table_number
         --                            , afc_error.exception_not_in_table_msg );
      end if;
      return d_result;
   end error_message; -- anagrafe_unita_organizzativa.error_message
   --------------------------------------------------------------------------------
   function existsid
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return boolean is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        existsId
       DESCRIZIONE: Esistenza riga con chiave indicata.
       NOTE:        Wrapper boolean di exists_id (cfr. exists_id).
      ******************************************************************************/
      d_result constant boolean := afc.to_boolean(exists_id(p_progr_aoo, p_dal));
   begin
      return d_result;
   end; -- aoo_pkg.existsId
   --------------------------------------------------------------------------------
   procedure ins
   (
      p_progr_aoo              in aoo.progr_aoo%type
     ,p_dal                    in aoo.dal%type
     ,p_codice_amministrazione in aoo.codice_amministrazione%type
     ,p_codice_aoo             in aoo.codice_aoo%type
     ,p_descrizione            in aoo.descrizione%type
     ,p_descrizione_al1        in aoo.descrizione_al1%type default null
     ,p_descrizione_al2        in aoo.descrizione_al2%type default null
     ,p_des_abb                in aoo.des_abb%type default null
     ,p_des_abb_al1            in aoo.des_abb_al1%type default null
     ,p_des_abb_al2            in aoo.des_abb_al2%type default null
     ,p_indirizzo              in aoo.indirizzo%type default null
     ,p_cap                    in aoo.cap%type default null
     ,p_provincia              in aoo.provincia%type default null
     ,p_comune                 in aoo.comune%type default null
     ,p_telefono               in aoo.telefono%type default null
     ,p_fax                    in aoo.fax%type default null
     ,p_al                     in aoo.al%type default null
     ,p_utente_aggiornamento   in aoo.utente_aggiornamento%type default null
     ,p_data_aggiornamento     in aoo.data_aggiornamento%type default null
     ,p_codice_ipa             in aoo.codice_ipa%type default null--#52548
   ) is
      /******************************************************************************
       NOME:        ins
       DESCRIZIONE: Inserimento di una riga con chiave e attributi indicati.
       PARAMETRI:   Chiavi e attributi della table.
      ******************************************************************************/
   begin
      dbc.pre(not dbc.preon or p_codice_amministrazione is not null
             ,'p_codice_amministrazione on aoo.ins');
      dbc.pre(not dbc.preon or p_codice_aoo is not null, 'p_codice_aoo on aoo.ins');
      dbc.pre(not dbc.preon or p_descrizione is not null, 'p_descrizione on aoo.ins');
      dbc.pre(not dbc.preon or not existsid(p_progr_aoo, p_dal)
             ,'not existsId on aoo.ins');
      insert into aoo
         (progr_aoo
         ,dal
         ,codice_amministrazione
         ,codice_aoo
         ,descrizione
         ,descrizione_al1
         ,descrizione_al2
         ,des_abb
         ,des_abb_al1
         ,des_abb_al2
         ,codice_ipa      --#52548
         ,indirizzo
         ,cap
         ,provincia
         ,comune
         ,telefono
         ,fax
         ,al
         ,utente_aggiornamento
         ,data_aggiornamento)
      values
         (p_progr_aoo
         ,p_dal
         ,upper(p_codice_amministrazione)
         ,upper(p_codice_aoo)
         ,p_descrizione
         ,p_descrizione_al1
         ,p_descrizione_al2
         ,p_des_abb
         ,p_des_abb_al1
         ,p_des_abb_al2
         ,p_codice_ipa      --#52548
         ,p_indirizzo
         ,p_cap
         ,p_provincia
         ,p_comune
         ,p_telefono
         ,p_fax
         ,p_al
         ,p_utente_aggiornamento
         ,p_data_aggiornamento);
   end; -- aoo_pkg.ins
   --------------------------------------------------------------------------------
   procedure upd
   (
      p_new_progr_aoo              in aoo.progr_aoo%type
     ,p_new_dal                    in aoo.dal%type
     ,p_new_codice_amministrazione in aoo.codice_amministrazione%type
     ,p_new_codice_aoo             in aoo.codice_aoo%type
     ,p_new_descrizione            in aoo.descrizione%type
     ,p_new_descrizione_al1        in aoo.descrizione_al1%type
     ,p_new_descrizione_al2        in aoo.descrizione_al2%type
     ,p_new_des_abb                in aoo.des_abb%type
     ,p_new_des_abb_al1            in aoo.des_abb_al1%type
     ,p_new_des_abb_al2            in aoo.des_abb_al2%type
     ,p_new_indirizzo              in aoo.indirizzo%type default null
     ,p_new_cap                    in aoo.cap%type default null
     ,p_new_provincia              in aoo.provincia%type default null
     ,p_new_comune                 in aoo.comune%type default null
     ,p_new_telefono               in aoo.telefono%type default null
     ,p_new_fax                    in aoo.fax%type default null
     ,p_new_al                     in aoo.al%type
     ,p_new_utente_aggiornamento   in aoo.utente_aggiornamento%type
     ,p_new_data_aggiornamento     in aoo.data_aggiornamento%type
     ,p_old_progr_aoo              in aoo.progr_aoo%type default null
     ,p_old_dal                    in aoo.dal%type default null
     ,p_old_codice_amministrazione in aoo.codice_amministrazione%type default null
     ,p_old_codice_aoo             in aoo.codice_aoo%type default null
     ,p_old_descrizione            in aoo.descrizione%type default null
     ,p_old_descrizione_al1        in aoo.descrizione_al1%type default null
     ,p_old_descrizione_al2        in aoo.descrizione_al2%type default null
     ,p_old_des_abb                in aoo.des_abb%type default null
     ,p_old_des_abb_al1            in aoo.des_abb_al1%type default null
     ,p_old_des_abb_al2            in aoo.des_abb_al2%type default null
     ,p_old_indirizzo              in aoo.indirizzo%type default null
     ,p_old_cap                    in aoo.cap%type default null
     ,p_old_provincia              in aoo.provincia%type default null
     ,p_old_comune                 in aoo.comune%type default null
     ,p_old_telefono               in aoo.telefono%type default null
     ,p_old_fax                    in aoo.fax%type default null
     ,p_old_al                     in aoo.al%type default null
     ,p_old_utente_aggiornamento   in aoo.utente_aggiornamento%type default null
     ,p_old_data_aggiornamento     in aoo.data_aggiornamento%type default null
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
              not
               ((p_old_codice_amministrazione is not null or p_old_codice_aoo is not null or
               p_old_descrizione is not null or p_old_descrizione_al1 is not null or
               p_old_descrizione_al2 is not null or p_old_des_abb is not null or
               p_old_des_abb_al1 is not null or p_old_des_abb_al2 is not null or
               p_old_indirizzo is not null or p_old_cap is not null or
               p_old_provincia is not null or p_old_comune is not null or
               p_old_telefono is not null or p_old_fax is not null or
               p_old_al is not null or p_old_utente_aggiornamento is not null or
               p_old_data_aggiornamento is not null) and p_check_old = 0)
             ,' <OLD values> is not null on aoo.upd');
      dbc.pre(not dbc.preon or p_check_old is not null
             ,'p_check_OLD is not null on aoo.upd');
      d_key := pk(nvl(p_old_progr_aoo, p_new_progr_aoo), nvl(p_old_dal, p_new_dal));
      dbc.pre(not dbc.preon or existsid(d_key.progr_aoo, d_key.dal)
             ,'existsId on aoo.upd');
      update aoo
         set progr_aoo              = p_new_progr_aoo
            ,dal                    = p_new_dal
            ,codice_amministrazione = p_new_codice_amministrazione
            ,codice_aoo             = p_new_codice_aoo
            ,descrizione            = p_new_descrizione
            ,descrizione_al1        = p_new_descrizione_al1
            ,descrizione_al2        = p_new_descrizione_al2
            ,des_abb                = p_new_des_abb
            ,des_abb_al1            = p_new_des_abb_al1
            ,des_abb_al2            = p_new_des_abb_al2
            ,indirizzo              = p_new_indirizzo
            ,cap                    = p_new_cap
            ,provincia              = p_new_provincia
            ,comune                 = p_new_comune
            ,telefono               = p_new_telefono
            ,fax                    = p_new_fax
            ,al                     = p_new_al
            ,utente_aggiornamento   = p_new_utente_aggiornamento
            ,data_aggiornamento     = p_new_data_aggiornamento
       where progr_aoo = d_key.progr_aoo
         and dal = d_key.dal
         and (p_check_old = 0 or
             p_check_old = 1 and
             (codice_amministrazione = p_old_codice_amministrazione or
             codice_amministrazione is null and p_old_codice_amministrazione is null) and
             (codice_aoo = p_old_codice_aoo or
             codice_aoo is null and p_old_codice_aoo is null) and
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
             (indirizzo = p_old_indirizzo or
             indirizzo is null and p_old_indirizzo is null) and
             (cap = p_old_cap or cap is null and p_old_cap is null) and
             (provincia = p_old_provincia or
             provincia is null and p_old_provincia is null) and
             (comune = p_old_comune or comune is null and p_old_comune is null) and
             (telefono = p_old_telefono or telefono is null and p_old_telefono is null) and
             (fax = p_old_fax or fax is null and p_old_fax is null) and
             (al = p_old_al or al is null and p_old_al is null) and
             (utente_aggiornamento = p_old_utente_aggiornamento or
             utente_aggiornamento is null and p_old_utente_aggiornamento is null) and
             (data_aggiornamento = p_old_data_aggiornamento or
             data_aggiornamento is null and p_old_data_aggiornamento is null));
      d_row_found := sql%rowcount;
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on aoo.upd');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
   end; -- aoo_pkg.upd
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_progr_aoo     in aoo.progr_aoo%type
     ,p_dal           in aoo.dal%type
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
      dbc.pre(not dbc.preon or existsid(p_progr_aoo, p_dal)
             ,'existsId on aoo.upd_column');
      dbc.pre(not dbc.preon or p_column is not null
             ,'p_column is not null on aoo.upd_column');
      dbc.pre(not dbc.preon or afc_ddl.hasattribute(s_table_name, p_column)
             ,'AFC_DDL.HasAttribute on aoo.upd_column');
      dbc.pre(p_literal_value in (0, 1)
             ,'p_literal_value in ( 0, 1 ) on aoo.upd_column; p_literal_value = ' ||
              p_literal_value);
      if p_literal_value = 1 then
         d_literal := '''';
      end if;
      d_statement := 'begin ' || '   update aoo' || '   set    ' || p_column || ' = ' ||
                     d_literal || p_value || d_literal || '   where  progr_aoo = ''' ||
                     p_progr_aoo || '''' || '   and    dal = to_Date(''' || to_char(p_dal,'DD/MM/YYYY') || ''', ''DD/MM/YYYY'')' || --#53989
                     '   ;' || 'end;';
      execute immediate d_statement;
   end; -- aoo_pkg.upd_column
   --------------------------------------------------------------------------------
   procedure upd_column
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
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
      d_data := to_char(p_value, 'dd/mm/yyyy hh24:mi:ss');
      upd_column(p_progr_aoo
                ,p_dal
                ,p_column
                ,'to_date( ''' || d_data || ''', ''dd/mm/yyyy hh24:mi:ss'')'
                ,0);
   end; -- aoo_pkg.upd_column
   --------------------------------------------------------------------------------
   procedure del
   (
      p_progr_aoo              in aoo.progr_aoo%type
     ,p_dal                    in aoo.dal%type
     ,p_codice_amministrazione in aoo.codice_amministrazione%type default null
     ,p_codice_aoo             in aoo.codice_aoo%type default null
     ,p_descrizione            in aoo.descrizione%type default null
     ,p_descrizione_al1        in aoo.descrizione_al1%type default null
     ,p_descrizione_al2        in aoo.descrizione_al2%type default null
     ,p_des_abb                in aoo.des_abb%type default null
     ,p_des_abb_al1            in aoo.des_abb_al1%type default null
     ,p_des_abb_al2            in aoo.des_abb_al2%type default null
     ,p_indirizzo              in aoo.indirizzo%type default null
     ,p_cap                    in aoo.cap%type default null
     ,p_provincia              in aoo.provincia%type default null
     ,p_comune                 in aoo.comune%type default null
     ,p_telefono               in aoo.telefono%type default null
     ,p_fax                    in aoo.fax%type default null
     ,p_al                     in aoo.al%type default null
     ,p_utente_aggiornamento   in aoo.utente_aggiornamento%type default null
     ,p_data_aggiornamento     in aoo.data_aggiornamento%type default null
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
               ((p_codice_amministrazione is not null or p_codice_aoo is not null or
               p_descrizione is not null or p_descrizione_al1 is not null or
               p_descrizione_al2 is not null or p_des_abb is not null or
               p_des_abb_al1 is not null or p_des_abb_al2 is not null or
               p_indirizzo is not null or p_cap is not null or p_provincia is not null or
               p_comune is not null or p_telefono is not null or p_fax is not null or
               p_al is not null or p_utente_aggiornamento is not null or
               p_data_aggiornamento is not null))
             ,' <OLD values> is not null on aoo.del');
      dbc.pre(not dbc.preon or existsid(p_progr_aoo, p_dal), 'existsId on aoo.upd');
      delete from aoo
       where progr_aoo = p_progr_aoo
         and dal = p_dal
         and (p_check_old = 0 or
             p_check_old = 1 and
             (codice_amministrazione = p_codice_amministrazione or
             codice_amministrazione is null and p_codice_amministrazione is null) and
             (codice_aoo = p_codice_aoo or codice_aoo is null and p_codice_aoo is null) and
             (descrizione = p_descrizione or
             descrizione is null and p_descrizione is null) and
             (descrizione_al1 = p_descrizione_al1 or
             descrizione_al1 is null and p_descrizione_al1 is null) and
             (descrizione_al2 = p_descrizione_al2 or
             descrizione_al2 is null and p_descrizione_al2 is null) and
             (des_abb = p_des_abb or des_abb is null and p_des_abb is null) and
             (des_abb_al1 = p_des_abb_al1 or
             des_abb_al1 is null and p_des_abb_al1 is null) and
             (des_abb_al2 = p_des_abb_al2 or
             des_abb_al2 is null and p_des_abb_al2 is null) and
             (indirizzo = p_indirizzo or indirizzo is null and p_indirizzo is null) and
             (cap = p_cap or cap is null and p_cap is null) and
             (provincia = p_provincia or provincia is null and p_provincia is null) and
             (comune = p_comune or comune is null and p_comune is null) and
             (telefono = p_telefono or telefono is null and p_telefono is null) and
             (fax = p_fax or fax is null and p_fax is null) and
             (al = p_al or al is null and p_al is null) and
             (utente_aggiornamento = p_utente_aggiornamento or
             utente_aggiornamento is null and p_utente_aggiornamento is null) and
             (data_aggiornamento = p_data_aggiornamento or
             data_aggiornamento is null and p_data_aggiornamento is null));
      d_row_found := sql%rowcount;
      dbc.assertion(not dbc.assertionon or d_row_found <= 1
                   ,'d_row_found <= 1 on aoo.del');
      if d_row_found < 1 then
         raise_application_error(afc_error.modified_by_other_user_number
                                ,afc_error.modified_by_other_user_msg);
      end if;
      dbc.post(not dbc.poston or not existsid(p_progr_aoo, p_dal), 'existsId on aoo.del');
   end; -- aoo_pkg.del
   --------------------------------------------------------------------------------
   function get_dal_id
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return aoo.dal%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_dal_corrente
       DESCRIZIONE: Attributo dal di riga con periodo di validità comprendente
                    la data indicata
       PARAMETRI:   Progr.AOO
                    Data
       RITORNA:     aoo.dal%type.
       NOTE:
      ******************************************************************************/
      d_result aoo.dal%type;
   begin
      select dal
        into d_result
        from aoo
       where progr_aoo = p_progr_aoo
         and p_dal between dal and nvl(al, to_date('3333333', 'j'));
      dbc.post(not dbc.preon or existsid(p_progr_aoo, p_dal)
              ,'existsId on aoo.get_dal_corrente');
      return d_result;
   end; -- aoo_pkg.get_dal_corrente
   --------------------------------------------------------------------------------
   function get_descrizione
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return aoo.descrizione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_descrizione
       DESCRIZIONE: Attributo descrizione di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     aoo.descrizione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result aoo.descrizione%type;
      d_data   aoo.dal%type;
   begin
      d_data := get_dal_id(p_progr_aoo => p_progr_aoo, p_dal => p_dal);
      select descrizione
        into d_result
        from aoo
       where progr_aoo = p_progr_aoo
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on aoo_pkg.get_descrizione');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'amministrazione')
                      ,' AFC_DDL.IsNullable on aoo_pkg.get_descrizione');
      end if;
      return d_result;
   end; -- aoo_pkg.get_descrizione
   --------------------------------------------------------------------------------
   function get_codice_amministrazione
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return aoo.codice_amministrazione%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_codice_amministrazione
       DESCRIZIONE: Attributo codice_amministrazione di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     aoo.codice_amministrazione%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result aoo.codice_amministrazione%type;
      d_data   aoo.dal%type;
   begin
      d_data := get_dal_id(p_progr_aoo => p_progr_aoo, p_dal => p_dal);
      select codice_amministrazione
        into d_result
        from aoo
       where progr_aoo = p_progr_aoo
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on aoo_pkg.get_codice_amministrazione');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or
                       afc_ddl.isnullable(s_table_name, 'amministrazione')
                      ,' AFC_DDL.IsNullable on aoo_pkg.get_codice_amministrazione');
      end if;
      return d_result;
   end; -- aoo_pkg.get_codice_amministrazione
   --------------------------------------------------------------------------------
   function get_codice_aoo
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return aoo.codice_aoo%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_codice_aoo
       DESCRIZIONE: Attributo codice_aoo di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     aoo.codice_aoo%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result aoo.codice_aoo%type;
      d_data   aoo.dal%type;
   begin
      d_data := get_dal_id(p_progr_aoo => p_progr_aoo, p_dal => p_dal);
      select codice_aoo
        into d_result
        from aoo
       where progr_aoo = p_progr_aoo
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on aoo_pkg.get_codice_aoo');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'aoo')
                      ,' AFC_DDL.IsNullable on aoo_pkg.get_codice_aoo');
      end if;
      return d_result;
   end; -- aoo_pkg.get_codice_aoo
   --------------------------------------------------------------------------------
   function get_codice_ipa --#52548
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return aoo.codice_ipa%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_codice_ipa
       DESCRIZIONE: Attributo codice_aoo di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     aoo.codice_aoo%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result aoo.codice_ipa%type;
      d_data   aoo.dal%type;
   begin
      d_data := get_dal_id(p_progr_aoo => p_progr_aoo, p_dal => p_dal);
      select codice_ipa
        into d_result
        from aoo
       where progr_aoo = p_progr_aoo
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on aoo_pkg.get_codice_aoo');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'aoo')
                      ,' AFC_DDL.IsNullable on aoo_pkg.get_codice_aoo');
      end if;
      return d_result;
   end; -- aoo_pkg.get_codice_ipa
   --------------------------------------------------------------------------------
   function get_des_abb
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return aoo.des_abb%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_des_abb
       DESCRIZIONE: Attributo des_abb di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     aoo.des_abb%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result aoo.des_abb%type;
      d_data   aoo.dal%type;
   begin
      d_data := get_dal_id(p_progr_aoo => p_progr_aoo, p_dal => p_dal);
      select des_abb
        into d_result
        from aoo
       where progr_aoo = p_progr_aoo
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on aoo_pkg.get_des_abb');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'aoo')
                      ,' AFC_DDL.IsNullable on aoo_pkg.get_des_abb');
      end if;
      return d_result;
   end; -- aoo_pkg.get_des_abb
   --------------------------------------------------------------------------------
   function get_indirizzo
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return aoo.indirizzo%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_indirizzo
       DESCRIZIONE: Attributo indirizzo di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     aoo.indirizzo%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result aoo.indirizzo%type;
      d_data   aoo.dal%type;
   begin
      d_data := get_dal_id(p_progr_aoo => p_progr_aoo, p_dal => p_dal);
      select indirizzo
        into d_result
        from aoo
       where progr_aoo = p_progr_aoo
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on aoo_pkg.get_indirizzo');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'aoo')
                      ,' AFC_DDL.IsNullable on aoo_pkg.get_indirizzo');
      end if;
      return d_result;
   end; -- aoo_pkg.get_indirizzo
   --------------------------------------------------------------------------------
   function get_cap
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return aoo.cap%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_cap
       DESCRIZIONE: Attributo cap di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     aoo.cap%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result aoo.cap%type;
      d_data   aoo.dal%type;
   begin
      d_data := get_dal_id(p_progr_aoo => p_progr_aoo, p_dal => p_dal);
      select cap
        into d_result
        from aoo
       where progr_aoo = p_progr_aoo
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on aoo_pkg.get_cap');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'aoo')
                      ,' AFC_DDL.IsNullable on aoo_pkg.get_cap');
      end if;
      return d_result;
   end; -- aoo_pkg.get_cap
   --------------------------------------------------------------------------------
   function get_comune
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return aoo.comune%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_comune
       DESCRIZIONE: Attributo comune di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     aoo.comune%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result aoo.comune%type;
      d_data   aoo.dal%type;
   begin
      d_data := get_dal_id(p_progr_aoo => p_progr_aoo, p_dal => p_dal);
      select comune
        into d_result
        from aoo
       where progr_aoo = p_progr_aoo
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on aoo_pkg.get_comune');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'aoo')
                      ,' AFC_DDL.IsNullable on aoo_pkg.get_comune');
      end if;
      return d_result;
   end; -- aoo_pkg.get_comune
   --------------------------------------------------------------------------------
   function get_provincia
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return aoo.provincia%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_provincia
       DESCRIZIONE: Attributo provincia di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     aoo.provincia%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result aoo.provincia%type;
      d_data   aoo.dal%type;
   begin
      d_data := get_dal_id(p_progr_aoo => p_progr_aoo, p_dal => p_dal);
      select provincia
        into d_result
        from aoo
       where progr_aoo = p_progr_aoo
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on aoo_pkg.get_provincia');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'aoo')
                      ,' AFC_DDL.IsNullable on aoo_pkg.get_provincia');
      end if;
      return d_result;
   end; -- aoo_pkg.get_provincia
   --------------------------------------------------------------------------------
   function get_telefono
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return aoo.telefono%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_telefono
       DESCRIZIONE: Attributo telefono di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     aoo.telefono%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result aoo.telefono%type;
      d_data   aoo.dal%type;
   begin
      d_data := get_dal_id(p_progr_aoo => p_progr_aoo, p_dal => p_dal);
      select telefono
        into d_result
        from aoo
       where progr_aoo = p_progr_aoo
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on aoo_pkg.get_telefono');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'aoo')
                      ,' AFC_DDL.IsNullable on aoo_pkg.get_telefono');
      end if;
      return d_result;
   end; -- aoo_pkg.get_telefono
   --------------------------------------------------------------------------------
   function get_fax
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return aoo.fax%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_fax
       DESCRIZIONE: Attributo fax di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     aoo.fax%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result aoo.fax%type;
      d_data   aoo.dal%type;
   begin
      d_data := get_dal_id(p_progr_aoo => p_progr_aoo, p_dal => p_dal);
      select fax
        into d_result
        from aoo
       where progr_aoo = p_progr_aoo
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on aoo_pkg.get_fax');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'aoo')
                      ,' AFC_DDL.IsNullable on aoo_pkg.get_fax');
      end if;
      return d_result;
   end; -- aoo_pkg.get_fax
   --------------------------------------------------------------------------------
   function get_al
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return aoo.al%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_al
       DESCRIZIONE: Attributo al di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     aoo.al%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result aoo.al%type;
      d_data   aoo.dal%type;
   begin
      d_data := get_dal_id(p_progr_aoo => p_progr_aoo, p_dal => p_dal);
      select al
        into d_result
        from aoo
       where progr_aoo = p_progr_aoo
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on aoo_pkg.get_al');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'aoo')
                      ,' AFC_DDL.IsNullable on aoo_pkg.get_al');
      end if;
      return d_result;
   end; -- aoo_pkg.get_al
   --------------------------------------------------------------------------------
   function get_utente_aggiornamento
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return aoo.utente_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_utente_aggiornamento
       DESCRIZIONE: Attributo utente_aggiornamento di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     aoo.utente_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result aoo.utente_aggiornamento%type;
      d_data   aoo.dal%type;
   begin
      d_data := get_dal_id(p_progr_aoo => p_progr_aoo, p_dal => p_dal);
      select utente_aggiornamento
        into d_result
        from aoo
       where progr_aoo = p_progr_aoo
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on aoo_pkg.get_utente_aggiornamento');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'aoo')
                      ,' AFC_DDL.IsNullable on aoo_pkg.get_utente_aggiornamento');
      end if;
      return d_result;
   end; -- aoo_pkg.get_utente_aggiornamento
   --------------------------------------------------------------------------------
   function get_data_aggiornamento
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) return aoo.data_aggiornamento%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_data_aggiornamento
       DESCRIZIONE: Attributo data_aggiornamento di riga esistente identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     aoo.data_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result aoo.data_aggiornamento%type;
      d_data   aoo.dal%type;
   begin
      d_data := get_dal_id(p_progr_aoo => p_progr_aoo, p_dal => p_dal);
      select data_aggiornamento
        into d_result
        from aoo
       where progr_aoo = p_progr_aoo
         and dal = d_data;
      -- Check Mandatory Attribute on Table
      if (false) -- is Mandatory on Table ?
       then
         -- Result must be not null
         dbc.post(not dbc.poston or d_result is not null
                 ,'d_result is not null on aoo_pkg.get_data_aggiornamento');
      else
         -- Column must nullable on table
         dbc.assertion(not dbc.assertionon or afc_ddl.isnullable(s_table_name, 'aoo')
                      ,' AFC_DDL.IsNullable on aoo_pkg.get_data_aggiornamento');
      end if;
      return d_result;
   end; -- aoo_pkg.get_data_aggiornamento
   --------------------------------------------------------------------------------
   function get_id_area return aoo.progr_aoo%type is
      /******************************************************************************
       NOME:        get_data_aggiornamento
       DESCRIZIONE: Determinazione del progressivo in inserimento di nuova
                    area organizzativa omogenea
       PARAMETRI:   Attributi chiave.
       RITORNA:     aoo.data_aggiornamento%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result aoo.progr_aoo%type;
   begin
      select nvl(max(progr_aoo), 0) + 1 into d_result from aoo;
      return d_result;
   end; -- aoo_pkg.get_id_area
   --------------------------------------------------------------------------------
   function get_dal_corrente
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_data      in aoo.dal%type
   ) return aoo.dal%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_dal_corrente
       DESCRIZIONE: Restituisce un'unico DAL per l'unita organizzativa indicata
                    - Se l'U.O. non esiste piu, viene restituito il max
                    - Se l'U.O. e valida, viene restituito il dal valido alla data passata
                    - Se l'U.O. ha validita futura, viene restituito il min
       PARAMETRI:   p_progr_aoo
                    p_data
       RITORNA:     AOO.dal%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result aoo.dal%type;
   begin
      begin
         select dal
           into d_result
           from aoo
          where progr_aoo = p_progr_aoo
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
              from aoo
             where progr_aoo = p_progr_aoo
               and dal < p_data;
         end;
      end if;
      --
      -- Se il risultato e ancora nullo, significa che la U.O. ha validita
      -- futura; si ricerca il record con inizio validità più vicino
      --
      if d_result is null then
         begin
            select min(dal)
              into d_result
              from aoo
             where progr_aoo = p_progr_aoo
               and dal > p_data;
         end;
      end if;
      --
      -- Se il risultato e ancora nullo, e un errore !
      --
      if d_result is null then
         raise_application_error(-20999
                                ,'Errore in determinazione data validita AOO - Progr. ' ||
                                 p_progr_aoo);
      end if;
      --
      return d_result;
   end; -- aoo_pkg.get_dal_corrente
   --------------------------------------------------------------------------------
   function get_rows
   (
      p_progr_aoo              in varchar2 default null
     ,p_dal                    in varchar2 default null
     ,p_codice_amministrazione in varchar2 default null
     ,p_codice_aoo             in varchar2 default null
     ,p_descrizione            in varchar2 default null
     ,p_descrizione_al1        in varchar2 default null
     ,p_descrizione_al2        in varchar2 default null
     ,p_des_abb                in varchar2 default null
     ,p_des_abb_al1            in varchar2 default null
     ,p_des_abb_al2            in varchar2 default null
     ,p_indirizzo              in varchar2 default null
     ,p_cap                    in varchar2 default null
     ,p_provincia              in varchar2 default null
     ,p_comune                 in varchar2 default null
     ,p_telefono               in varchar2 default null
     ,p_fax                    in varchar2 default null
     ,p_al                     in varchar2 default null
     ,p_utente_aggiornamento   in varchar2 default null
     ,p_data_aggiornamento     in varchar2 default null
     ,p_order_condition        in varchar2 default null
     ,p_qbe                    in number default 0
   ) return afc.t_ref_cursor is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_rows
       DESCRIZIONE: Ritorna il risultato di una query in base ai valori che passiamo.
       PARAMETRI:   Chiavi e attributi della table
                    p_order_condition
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
      d_statement := ' select * from aoo ' || ' where 1 = 1 ' ||
                     afc.get_field_condition(' and ( progr_aoo '
                                            ,p_progr_aoo
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( dal '
                                            ,p_dal
                                            ,' )'
                                            ,p_qbe
                                            ,afc.date_format) ||
                     afc.get_field_condition(' and ( codice_amministrazione '
                                            ,p_codice_amministrazione
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( codice_aoo '
                                            ,p_codice_aoo
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
                     afc.get_field_condition(' and ( indirizzo '
                                            ,p_indirizzo
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( cap ', p_cap, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( comune ', p_comune, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( provincia '
                                            ,p_provincia
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( telefono ', p_telefono, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( fax ', p_fax, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( al '
                                            ,p_al
                                            ,' )'
                                            ,p_qbe
                                            ,afc.date_format) ||
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
   end; -- aoo_pkg.get_rows
   --------------------------------------------------------------------------------
   function count_rows
   (
      p_progr_aoo              in varchar2 default null
     ,p_dal                    in varchar2 default null
     ,p_codice_amministrazione in varchar2 default null
     ,p_codice_aoo             in varchar2 default null
     ,p_descrizione            in varchar2 default null
     ,p_descrizione_al1        in varchar2 default null
     ,p_descrizione_al2        in varchar2 default null
     ,p_des_abb                in varchar2 default null
     ,p_des_abb_al1            in varchar2 default null
     ,p_des_abb_al2            in varchar2 default null
     ,p_indirizzo              in varchar2 default null
     ,p_cap                    in varchar2 default null
     ,p_provincia              in varchar2 default null
     ,p_comune                 in varchar2 default null
     ,p_telefono               in varchar2 default null
     ,p_fax                    in varchar2 default null
     ,p_al                     in varchar2 default null
     ,p_utente_aggiornamento   in varchar2 default null
     ,p_data_aggiornamento     in varchar2 default null
     ,p_qbe                    in number default 0
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
      d_statement := ' select count( * ) from aoo ' || ' where 1 = 1 ' ||
                     afc.get_field_condition(' and ( progr_aoo '
                                            ,p_progr_aoo
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( dal '
                                            ,p_dal
                                            ,' )'
                                            ,p_qbe
                                            ,afc.date_format) ||
                     afc.get_field_condition(' and ( codice_amministrazione '
                                            ,p_codice_amministrazione
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( codice_aoo '
                                            ,p_codice_aoo
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
                     afc.get_field_condition(' and ( indirizzo '
                                            ,p_indirizzo
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( cap ', p_cap, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( comune ', p_comune, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( provincia '
                                            ,p_provincia
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( telefono ', p_telefono, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( fax ', p_fax, ' )', p_qbe) ||
                     afc.get_field_condition(' and ( al '
                                            ,p_al
                                            ,' )'
                                            ,p_qbe
                                            ,afc.date_format) ||
                     afc.get_field_condition(' and ( utente_aggiornamento '
                                            ,p_utente_aggiornamento
                                            ,' )'
                                            ,p_qbe) ||
                     afc.get_field_condition(' and ( data_aggiornamento '
                                            ,p_data_aggiornamento
                                            ,' )'
                                            ,p_qbe
                                            ,afc.date_format);
      d_result    := afc.sql_execute(d_statement);
      return d_result;
   end; -- aoo_pkg.count_rows
   --------------------------------------------------------------------------------
   function is_codice_aoo_ok(p_codice_aoo in aoo.codice_aoo%type)
      return afc_error.t_error_number
   /******************************************************************************
       NOME:        is_codice_aoo_ok
       DESCRIZIONE: Controllo sull'uso dei caratteri # e [ nel codice della AOO
       PARAMETRI:   p_codice_aoo
       NOTE:        --
      ******************************************************************************/
    is
      d_result afc_error.t_error_number;
   begin
      if instr(p_codice_aoo, '#') != 0 or instr(p_codice_aoo, '[') != 0 then
         d_result := s_carattere_non_consent_number;
      else
         d_result := afc_error.ok;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on aoo_pkg.is_codice_aoo_ok');
      return d_result;
   end; -- aoo_pkg.is_codice_aoo_ok
   --------------------------------------------------------------------------------   
   --------------------------------------------------------------------------------
   function is_dal_al_ok
   (
      p_dal in aoo.dal%type
     ,p_al  in aoo.al%type
   ) return afc_error.t_error_number
   /******************************************************************************
       NOME:        is_dal_al_ok
       DESCRIZIONE: Controllo di congruenza tra data inizio e fine validità
       PARAMETRI:   p_dal
                    p_al
       NOTE:        --
      ******************************************************************************/
    is
      d_result afc_error.t_error_number;
   begin
      if nvl(p_dal, to_date('01011800', 'ddmmyyyy')) >
         nvl(p_al, to_date('31122200', 'ddmmyyyy')) then
         d_result := s_dal_al_errato_number;
      else
         d_result := afc_error.ok;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on aoo_pkg.is_dal_al_ok');
      return d_result;
   end; -- aoo_pkg.is_dal_al_ok
   --------------------------------------------------------------------------------
   function is_di_ok
   (
      p_codice_aoo in aoo.codice_aoo%type
     ,p_dal        in aoo.dal%type
     ,p_al         in aoo.al%type
   ) return afc_error.t_error_number
   /******************************************************************************
       NOME:        is_DI_ok.
       DESCRIZIONE: gestione della Data Integrity:
                    - is_dal_al_ok
       PARAMETRI:   p_dal
                    p_al
       RETURN:      1 se tutti i controlli danno esito positivo, l'error_code altrimenti
       NOTE:        --
      ******************************************************************************/
    is
      d_result afc_error.t_error_number := afc_error.ok;
   begin
      -- is_codice_ok
      if d_result = afc_error.ok then
         d_result := is_codice_aoo_ok(p_codice_aoo);
      end if;
   
      -- is_dal_al_ok
      if d_result = afc_error.ok then
         d_result := is_dal_al_ok(p_dal, p_al);
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on aoo_pkg.is_DI_ok');
      return d_result;
   end; -- aoo_pkg.is_DI_ok
   --------------------------------------------------------------------------------
   procedure chk_di
   (
      p_codice_aoo in aoo.codice_aoo%type
     ,p_dal        in aoo.dal%type
     ,p_al         in aoo.al%type
   ) is
      /******************************************************************************
       NOME:        chk_DI.
       DESCRIZIONE: gestione della Data Integrity:
                    - is_chk_di_ok
       PARAMETRI:  p_dal
                 , p_al
       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
      d_result := is_di_ok(p_codice_aoo, p_dal, p_al);
      dbc.assertion(not dbc.assertionon or d_result = afc_error.ok or d_result < 0
                   ,'d_result = AFC_Error.ok or d_result < 0 on aoo_pkg.chk_DI');
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, error_message(d_result));
      end if;
   end; -- aoo_pkg.chk_DI
   --------------------------------------------------------------------------------
   function is_last_record(p_progr_aoo in aoo.progr_aoo%type)
      return afc_error.t_error_number is
      d_result        afc_error.t_error_number;
      d_select_result number;
   begin
      -- Si controlla quanti record esistono per l'AOO da eliminare
      begin
         select count(*) into d_select_result from aoo where progr_aoo = p_progr_aoo;
      exception
         when others then
            d_select_result := 0;
      end;
      --
      -- Se non esistono altri record della stessa AOO oltre a quello che si
      -- sta cancellando, si verifica che non esistano referenze alla AOO
      -- sull'anagrafe dell'unita' organizzativa e sulla tabella degli indirizzi
      -- telematici (in questo caso l'AOO non e' eliminabile)
      --
      if d_select_result > 0 then
         d_result := afc_error.ok;
      else
         begin
            select count(*)
              into d_select_result
              from anagrafe_unita_organizzative
             where progr_aoo = p_progr_aoo;
         exception
            when others then
               d_select_result := 1;
         end;
         if d_select_result > 0 then
            d_result := s_aoo_non_eliminabile_1_number;
         else
            d_result := afc_error.ok;
         end if;
         if d_result = afc_error.ok then
            begin
               select count(*)
                 into d_select_result
                 from indirizzi_telematici
                where tipo_entita = 'AO'
                  and id_aoo = p_progr_aoo;
            exception
               when others then
                  d_select_result := 1;
            end;
            if d_select_result > 0 then
               d_result := s_aoo_non_eliminabile_2_number;
            else
               d_result := afc_error.ok;
            end if;
         end if;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0);
      return d_result;
   end; -- aoo_pkg.is_last_record
   --------------------------------------------------------------------------------
   function is_dal_ok
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_old_dal   in aoo.dal%type
     ,p_new_dal   in aoo.dal%type
     ,p_old_al    in aoo.al%type
     ,p_rowid     in rowid
     ,p_inserting in number
     ,p_updating  in number
   ) return afc_error.t_error_number
   /******************************************************************************
       NOME:        is_dal_ok
       DESCRIZIONE: Controllo nuovo dal compreso in periodo immediatamente
                    precedente
       PARAMETRI:   p_progr_aoo
                    p_old_dal
                    p_new_dal
                    p_old_al
                    p_rowid
                    p_inserting
                    p_updating
       NOTE:        --
      ******************************************************************************/
    is
      d_periodo afc_periodo.t_periodo;
      d_result  afc_error.t_error_number;
      d_dummy   varchar2(1);
   begin
      --#410
      if p_inserting = 1 and p_updating = 0 then
         begin
            select dal
                  ,al
              into d_periodo.dal
                  ,d_periodo.al
              from aoo
             where progr_aoo = p_progr_aoo
               and dal <> p_new_dal
               and dal = (select max(dal)
                            from aoo
                           where progr_aoo = p_progr_aoo
                             and dal < p_new_dal);
            raise too_many_rows;
         exception
            when no_data_found then
               d_result := afc_error.ok;
            when too_many_rows then
               if d_periodo.dal < p_new_dal and
                  (d_periodo.al is null or d_periodo.al = p_new_dal - 1) then
                  d_result := afc_error.ok;
               else
                  d_result := s_dal_errato_ins_number;
               end if;
         end;
      end if;
   
      if p_inserting = 0 and p_updating = 1 then
         begin
            select dal
                  ,al
              into d_periodo.dal
                  ,d_periodo.al
              from aoo
             where progr_aoo = p_progr_aoo
               and dal <> p_new_dal
               and dal = (select max(dal)
                            from aoo
                           where progr_aoo = p_progr_aoo
                             and dal < p_new_dal);
            raise too_many_rows;
         exception
            when no_data_found then
               d_result := afc_error.ok;
            when too_many_rows then
               if nvl(d_periodo.al, to_date(3333333, 'j')) < p_new_dal then
                  d_result := afc_error.ok;
               else
                  d_result := s_dal_errato_ins_number;
               end if;
         end;
      end if;
   
      return d_result;
   end; -- aoo_pkg.is_dal_ok
   --------------------------------------------------------------------------------
   function is_al_ok
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_old_dal   in aoo.dal%type
     ,p_old_al    in aoo.al%type
     ,p_new_al    in aoo.al%type
     ,p_rowid     in rowid
     ,p_inserting in number
     ,p_updating  in number
   ) return afc_error.t_error_number
   /******************************************************************************
       NOME:        is_al_ok
       DESCRIZIONE: Controllo is_al_ok
       PARAMETRI:   p_progr_aoo
                    p_old_dal
                    p_old_al
                    p_new_al
       NOTE:        --
      ******************************************************************************/
    is
      d_periodo afc_periodo.t_periodo;
      d_result  afc_error.t_error_number;
      d_count   number;
   begin
      --#410
      select count(*)
        into d_count
        from aoo
       where p_progr_aoo = progr_aoo
         and nvl(p_new_al, to_date(3333333, 'j')) between dal and
             nvl(al, to_date(3333333, 'j'));
   
      if d_count = 1 then
         d_result := afc_error.ok;
      else
         d_result := s_al_errato_number;
      end if;
   
      return d_result;
   end; -- aoo_pkg.is_al_ok
   --------------------------------------------------------------------------------
   function is_dal_al_amministrazione_ok
   (
      p_dal_aoo                in aoo.dal%type
     ,p_al_aoo                 in aoo.al%type
     ,p_codice_amministrazione in aoo.codice_amministrazione%type
   ) return afc_error.t_error_number is
      d_result afc_error.t_error_number;
   begin
      begin
         select afc_error.ok
           into d_result
           from amministrazioni
          where codice_amministrazione = p_codice_amministrazione
            and nvl(data_istituzione, to_date(2222222, 'j')) <= p_dal_aoo
            and nvl(data_soppressione, to_date(3333333, 'j')) >=
                nvl(p_al_aoo, to_date(3333333, 'j'));
      exception
         when no_data_found then
            d_result := s_dal_al_ammi_errato_number;
      end;
      return d_result;
   end;
   --------------------------------------------------------------------------------
   function is_codice_ok
   (
      p_progr_aoo              in aoo.progr_aoo%type
     ,p_codice_aoo             in aoo.codice_aoo%type
     ,p_codice_amministrazione in aoo.codice_amministrazione%type
   ) return afc_error.t_error_number is
      d_result        afc_error.t_error_number;
      d_select_result number;
   begin
      -- Si controlla che non esistano record di altre AOO con
      -- lo stesso codice
      begin
         select count(*)
           into d_select_result
           from aoo
          where progr_aoo <> p_progr_aoo
            and codice_aoo = p_codice_aoo
            and codice_amministrazione = p_codice_amministrazione;
      exception
         when others then
            d_select_result := 1;
      end;
      if d_select_result = 0 then
         d_result := afc_error.ok;
      else
         d_result := s_codice_errato_number;
      end if;
      return d_result;
   end; -- aoo_pkg.is_codice_ok
   --------------------------------------------------------------------------------
   function is_descrizione_ok
   (
      p_progr_aoo              in aoo.progr_aoo%type
     ,p_descrizione            in aoo.descrizione%type
     ,p_codice_amministrazione in aoo.codice_amministrazione%type
   ) return afc_error.t_error_number is
      d_result        afc_error.t_error_number;
      d_select_result number;
   begin
      -- Si controlla che non esistano record di altre AOO con
      -- la stessa descrizione
      begin
         select count(*)
           into d_select_result
           from aoo
          where progr_aoo <> p_progr_aoo
            and descrizione = p_descrizione
            and codice_amministrazione = p_codice_amministrazione;
      exception
         when others then
            d_select_result := 1;
      end;
      if d_select_result = 0 then
         d_result := afc_error.ok;
      else
         d_result := s_descrizione_errata_number;
      end if;
      return d_result;
   end; -- aoo_pkg.is_descrizione_ok
   --------------------------------------------------------------------------------
   function is_ri_ok
   (
      p_progr_aoo              in aoo.progr_aoo%type
     ,p_codice_aoo             in aoo.codice_aoo%type
     ,p_descrizione            in aoo.descrizione%type
     ,p_codice_amministrazione in aoo.codice_amministrazione%type
     ,p_old_dal                in aoo.dal%type
     ,p_new_dal                in aoo.dal%type
     ,p_old_al                 in aoo.al%type
     ,p_new_al                 in aoo.al%type
     ,p_rowid                  in rowid
     ,p_inserting              in number
     ,p_updating               in number
     ,p_deleting               in number
   ) return afc_error.t_error_number
   /******************************************************************************
       NOME:        is_RI_ok.
       DESCRIZIONE: gestione della Referential Integrity:
                    - is_last_record
                    - is_dal_ok
                    - is_al_ok
       PARAMETRI:   p_progr_aoo
                    p_old_dal
                    p_new_dal
                    p_old_al
                    p_new_al
       RETURN:      1 se tutti i controlli danno esito positivo, l'error_code altrimenti
       NOTE:        --
      ******************************************************************************/
    is
      d_result afc_error.t_error_number := afc_error.ok;
   begin
      if p_deleting = 1 then
         d_result := is_last_record(p_progr_aoo => p_progr_aoo);
      else
         -- is_dal_ok
         if nvl(p_old_dal, to_date('3333333', 'j')) <>
            nvl(p_new_dal, to_date('3333333', 'j')) then
            d_result := is_dal_ok(p_progr_aoo
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
               d_result := is_al_ok(p_progr_aoo
                                   ,p_old_dal
                                   ,p_old_al
                                   ,p_new_al
                                   ,p_rowid
                                   ,p_inserting
                                   ,p_updating);
            end if;
         end if;
         -- is_dal_al_amministrazione_ok
         if d_result = afc_error.ok then
            d_result := is_dal_al_amministrazione_ok(p_new_dal
                                                    ,p_new_al
                                                    ,p_codice_amministrazione);
         end if;
         -- is_codice_ok
         if d_result = afc_error.ok then
            d_result := is_codice_ok(p_progr_aoo, p_codice_aoo, p_codice_amministrazione);
         end if;
         -- is_descrizione_ok
         --#761 inibito il controllo is_descrizione_ok
         /*if d_result = afc_error.ok then
            d_result := is_descrizione_ok(p_progr_aoo
                                         ,p_descrizione
                                         ,p_codice_amministrazione);
         end if;*/
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on aoo_pkg.is_RI_ok');
      return d_result;
   end; -- aoo_pkg.is_RI_ok
   --------------------------------------------------------------------------------
   procedure chk_ri
   (
      p_progr_aoo              in aoo.progr_aoo%type
     ,p_codice_aoo             in aoo.codice_aoo%type
     ,p_descrizione            in aoo.descrizione%type
     ,p_codice_amministrazione in aoo.codice_amministrazione%type
     ,p_old_dal                in aoo.dal%type
     ,p_new_dal                in aoo.dal%type
     ,p_old_al                 in aoo.al%type
     ,p_new_al                 in aoo.al%type
     ,p_rowid                  in rowid
     ,p_inserting              in number
     ,p_updating               in number
     ,p_deleting               in number
   ) is
      /******************************************************************************
       NOME:        chk_RI.
       DESCRIZIONE: gestione della Referential Integrity:
                    - is_dal_ok
                    - is_al_ok
       PARAMETRI:  p_progr_aoo
                    p_old_dal
                    p_new_dal
                    p_old_al
                    p_new_al
       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
      d_result := is_ri_ok(p_progr_aoo
                          ,p_codice_aoo
                          ,p_descrizione
                          ,p_codice_amministrazione
                          ,p_old_dal
                          ,p_new_dal
                          ,p_old_al
                          ,p_new_al
                          ,p_rowid
                          ,p_inserting
                          ,p_updating
                          ,p_deleting);
      dbc.assertion(not dbc.assertionon or d_result = afc_error.ok or d_result < 0
                   ,'d_result = AFC_Error.ok or d_result < 0 on aoo_pkg.chk_RI');
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, error_message(d_result));
      end if;
   end; -- aoo_pkg.chk_RI
   --------------------------------------------------------------------------------
   procedure set_data_al
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
   ) is
      /******************************************************************************
       NOME:        set_data_al.
       DESCRIZIONE: Aggiornamento data fine validità periodo precedente
       PARAMETRI:   p_progr_aoo
                    p_dal
       NOTE:        --
      ******************************************************************************/
      d_periodo afc_periodo.t_periodo;
   begin
      d_periodo := afc_periodo.get_seguente(p_tabella            => 'AOO'
                                           ,p_nome_dal           => 'DAL'
                                           ,p_nome_al            => 'AL'
                                           ,p_dal                => p_dal
                                           ,p_al                 => null
                                           ,p_campi_controllare  => '#PROGR_AOO#'
                                           ,p_valori_controllare => '#' || p_progr_aoo || '#');
      if d_periodo.dal is not null then
         update aoo --#453
            set al = d_periodo.dal - 1
          where progr_aoo = p_progr_aoo
            and dal = p_dal;
      end if;
   end; -- aoo_pkg.set_data_al
   --------------------------------------------------------------------------------
   procedure set_periodo_precedente
   (
      p_progr_aoo in aoo.progr_aoo%type
     ,p_dal       in aoo.dal%type
     ,p_al        in aoo.al%type
   ) is
      /******************************************************************************
       NOME:        set_periodo_precedente.
       DESCRIZIONE: Aggiornamento data fine validità periodo precedente
       PARAMETRI:   p_progr_aoo
                    p_dal
                    p_al
       NOTE:        --
      ******************************************************************************/
   begin
      update aoo
         set al                   = p_al
            ,data_aggiornamento   = sysdate
            ,utente_aggiornamento = si4.utente
       where progr_aoo = p_progr_aoo
         and nvl(al, to_date('2222222', 'j')) != nvl(p_al, to_date('2222222', 'j'))
         and dal = (select max(dal)
                      from aoo
                     where progr_aoo = p_progr_aoo
                       and dal < p_dal);
   end; -- aoo_pkg.set_periodo_precedente
   --------------------------------------------------------------------------------
   -- Impostazione integrita' funzionale
   procedure set_fi
   (
      p_progr_aoo     in aoo.progr_aoo%type
     ,p_old_progr_aoo in aoo.progr_aoo%type
     ,p_dal           in aoo.dal%type
     ,p_old_dal       in aoo.dal%type
     ,p_al            in aoo.al%type
     ,p_old_al        in aoo.al%type
     ,p_inserting     in number
     ,p_updating      in number
     ,p_deleting      in number
   ) is
      /******************************************************************************
       NOME:        set_FI.
       DESCRIZIONE: impostazione integrita funzionale:
                    -
       RITORNA:     -
      ******************************************************************************/
   begin
      if p_inserting = 1 and p_updating = 0 and p_deleting = 0 then
         -- determinazione della data AL del record inserito
         set_data_al(p_progr_aoo, p_dal);
         -- impostazione periodo precedente al record inserito
         set_periodo_precedente(p_progr_aoo, p_dal, p_dal - 1);
      elsif p_inserting = 0 and p_updating = 1 and p_deleting = 0 then
         if p_al < p_old_al then
            -- impostazione periodo successivo
            update aoo
               set dal                  = p_al + 1
                  ,data_aggiornamento   = sysdate
                  ,utente_aggiornamento = si4.utente
             where progr_aoo = p_progr_aoo
               and dal = (select min(dal)
                            from aoo
                           where progr_aoo = p_progr_aoo
                             and dal > p_dal);
         
         else
            -- impostazione periodo precedente
            set_periodo_precedente(p_progr_aoo, p_dal, p_dal - 1);
         end if;
      elsif p_inserting = 0 and p_updating = 0 and p_deleting = 1 then
         -- impostazione periodo precedente
         set_periodo_precedente(p_old_progr_aoo, p_old_dal, p_old_al);
      end if;
   end; -- aoo_pkg.set_FI
   --------------------------------------------------------------------------------
   function trova
   (
      p_codice_amministrazione in amministrazioni.codice_amministrazione%type
     ,p_codice_aoo             in aoo.codice_aoo%type
     ,p_ni                     in aoo.progr_aoo%type
     ,p_denominazione          in aoo.descrizione%type
     ,p_indirizzo              in aoo.indirizzo%type
     ,p_cap                    in aoo.cap%type
     ,p_citta                  in varchar2
     ,p_provincia              in varchar2
     ,p_regione                in varchar2
     ,p_sito_istituzionale     as4_anagrafe_soggetti.indirizzo_web%type
     ,p_indirizzo_telematico   indirizzi_telematici.indirizzo%type
     ,p_data_riferimento       aoo.dal%type default trunc(sysdate)
   ) return afc.t_ref_cursor is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        TROVA
       DESCRIZIONE: Trova le AOO che soddisfano le condizioni di ricerca passate.
                    Lavora su AOO valide alla data di riferimento.
       PARAMETRI:   p_codice_amministrazione  IN AMMINISTRAZIONI.CODICE_AMMINISTRAZIONE%TYPE
                    p_codice_aoo              IN AOO.CODICE_AOO%TYPE
                    p_ni                      IN AOO.PROGR_AOO%TYPE
                    p_denominazione           IN AOO.DESCRIZIONE%TYPE
                    p_indirizzo               IN AOO.INDIRIZZO%TYPE
                    p_cap                     IN AOO.CAP%TYPE
                    p_citta                   IN VARCHAR2
                    p_provincia               IN VARCHAR2
                    p_regione                 in varchar2
                    p_indirizzo_telematico    IN INDIRIZZI_TELEMATICI.INDIRIZZO%TYPE
                    p_data_riferimento        IN AOO.DAL%TYPE
       RITORNA:     Restituisce i record trovati in AOO.
       NOTE:
       REVISIONI:
       Rev. Data        Autore      Descrizione
       ---- ----------  ------      ------------------------------------------------------
       0    28/02/2006   SC          A14999. Per J-Protocollo.
      ******************************************************************************/
      p_aoo_rc               afc.t_ref_cursor;
      ddatariferimento       date;
      ddataal                date;
      dsiglaprovincia        ad4_province.sigla%type;
      dcodiceprovincia       ad4_province.provincia%type;
      dcodiceregione         ad4_regioni.regione%type;
      dcodicecomune          ad4_comuni.comune%type;
      dcap                   ad4_comuni.cap%type;
      dtempcap               ad4_comuni.cap%type;
      ddenominazione         varchar2(32000);
      dindirizzo             varchar2(32000);
      dsitoistituzionale     varchar2(32000);
      dindirizzotelematico   varchar2(32000);
      dcodiceamministrazione varchar2(32000);
      dcodiceaoo             varchar2(32000);
      dsql                   varchar2(32767);
      dwhere                 varchar2(32767) := 'where 1=1 ';
      ddatarifdal            varchar2(100);
      ddatarifal             varchar2(100);
   begin
      ddenominazione         := upper(p_denominazione);
      dindirizzo             := upper(p_indirizzo);
      dsitoistituzionale     := upper(p_sito_istituzionale);
      dindirizzotelematico   := upper(p_indirizzo_telematico);
      dcodiceamministrazione := upper(p_codice_amministrazione);
      dcodiceaoo             := upper(p_codice_aoo);
      ddatariferimento       := nvl(p_data_riferimento, trunc(sysdate));
      dcap                   := p_cap;
      dsiglaprovincia        := upper(p_provincia);
      ddataal                := trunc(sysdate);
      if ddatariferimento > ddataal then
         ddataal := ddatariferimento;
      end if;
      ddatarifdal := ' to_date(''' || to_char(ddatariferimento, 'dd/mm/yyyy') ||
                     ''', ''dd/mm/yyyy'')';
      ddatarifal  := ' to_date(''' || to_char(ddataal, 'dd/mm/yyyy') ||
                     ''', ''dd/mm/yyyy'')';
      dsql        := 'select aoo.progr_aoo, aoo.dal from aoo, ad4_province, ad4_regioni ';
      dwhere      := dwhere || 'and' || ddatarifdal ||
                     ' between aoo.dal and nvl(aoo.al, ' || ddatarifal || ') ' ||
                     ' and ad4_province.provincia (+) = aoo.provincia ' ||
                     ' and ad4_regioni.regione (+) = ad4_province.regione ';
      if dcodiceaoo is not null then
         dcodiceaoo := dcodiceaoo || '%';
         dwhere     := dwhere || 'and upper(aoo.codice_aoo) like ''' || dcodiceaoo ||
                       ''' ';
      end if;
      if dcodiceamministrazione is not null then
         dcodiceamministrazione := dcodiceamministrazione || '%';
         dwhere                 := dwhere ||
                                   'and upper(aoo.codice_amministrazione) like ''' ||
                                   dcodiceamministrazione || ''' ';
      end if;
      if dindirizzo is not null then
         dindirizzo := dindirizzo || '%';
         dwhere     := dwhere || 'and upper(aoo.indirizzo) like ''' || dindirizzo ||
                       ''' ';
      end if;
      /*   if dSitoIstituzionale is not null then
         dSitoIstituzionale := dSitoIstituzionale||'%';
        dWhere := dWhere||'and upper(sogg.INDIRIZZO_WEB) like '''||dSitoIstituzionale||''' ';
      end if;*/
      if ddenominazione is not null then
         ddenominazione := ddenominazione || '%';
         dwhere         := dwhere || 'and aoo.descrizione like ''' || ddenominazione ||
                           ''' ';
      end if;
      /*   if dIndirizzoTelematico is not null then
         dIndirizzoTelematico := dIndirizzoTelematico||'%';
         dWhere := dWhere||'and upper(INDIRIZZO_TELEMATICO.GET_INDIRIZZO'
                         ||'(INDIRIZZO_TELEMATICO.GET_CHIAVE(''AO'','''','
                         ||'aoo.progr_aoo,'''', ''I''))) like '''||dIndirizzoTelematico||''' ';
      end if;*/
      if dindirizzotelematico is not null then
         dsql                 := dsql || ', indirizzi_telematici inte ';
         dindirizzotelematico := dindirizzotelematico || '%';
         dwhere               := dwhere || 'and upper(inte.INDIRIZZO) LIKE upper(''' ||
                                 dindirizzotelematico ||
                                 ''') and inte.TIPO_ENTITA = ''AO'' and inte.TIPO_INDIRIZZO = ''I'' and inte.ID_AOO = aoo.progr_aoo ';
      end if;
      if p_citta is not null then
         -- NON passa dCap a questa funzione per non sovrascrivere l'eventuale cap
         -- passato. Se anche fosse stato passato nullo, e' sbagliato sovrascriverlo
         -- in ricerca perche' passare null significa che vanno bene tutti.
         /*      dCodiceComune := ad4_comune.get_comune( p_denominazione => p_citta
         , p_cap => dTempCap
         , p_sigla_provincia => dSiglaProvincia
         , p_provincia => dCodiceProvincia);*/
         dcodicecomune := ad4_comune.get_comune(p_denominazione   => p_citta
                                               ,p_sigla_provincia => dsiglaprovincia
                                               ,p_soppresso       => ad4_comune.is_soppresso(p_denominazione   => p_citta
                                                                                            ,p_sigla_provincia => dsiglaprovincia));
      end if;
      if dsiglaprovincia is not null then
         dsql := dsql || ', ad4_provincie prov ';
         dsql := dsql || dwhere;
         dsql := dsql || 'and aoo.PROVINCIA = prov.PROVINCIA ';
         dsql := dsql || 'and prov.SIGLA = ''' || dsiglaprovincia || ''' ';
      else
         dsql := dsql || dwhere;
      end if;
      if p_regione is not null then
         dcodiceregione := ad4_regione.get_regione(p_denominazione => p_regione);
      end if;
      if dcodicecomune is not null then
         dsql := dsql || 'and aoo.COMUNE = ''' || dcodicecomune || ''' ';
      end if;
      if dcodiceprovincia is not null then
         dsql := dsql || 'and aoo.PROVINCIA = ''' || dcodiceprovincia || ''' ';
      end if;
      if dcodiceregione is not null then
         dsql := dsql || 'and ad4_regione.regione = ''' || dcodiceregione || ''' ';
      end if;
      if dcap is not null then
         dsql := dsql || 'and aoo.cap = ''' || dcap || ''' ';
      end if;
      if nvl(p_ni, 0) > 0 then
         dsql := dsql || ' and aoo.progr_aoo = ' || p_ni;
      end if;
      --dbms_output.put_line(substr(dSql, 1, 255));
      --dbms_output.put_line(substr(dSql, 256, 255));
      --dbms_output.put_line(substr(dSql, 511, 255));
      open p_aoo_rc for dsql;
      return p_aoo_rc;
   end trova;
   --------------------------------------------------------------------------------
   -- Aggiornamento dati da scarico IPA
   procedure agg_automatico
   (
      p_codice_amministrazione in aoo.codice_amministrazione%type
     ,p_codice_aoo             in aoo.codice_aoo%type
     ,p_descrizione            in aoo.descrizione%type
     ,p_codice_ipa             in aoo.codice_ipa%type  --#52548
     ,p_indirizzo              in aoo.indirizzo%type
     ,p_cap                    in aoo.cap%type
     ,p_localita               in varchar2
     ,p_provincia              in varchar2
     ,p_telefono               in aoo.telefono%type
     ,p_fax                    in aoo.fax%type
     ,p_mail_istituzionale     in indirizzi_telematici.indirizzo%type
     ,p_data_istituzione       in aoo.dal%type
     ,p_data_soppressione      in aoo.al%type
     ,p_utente_aggiornamento   in aoo.utente_aggiornamento%type
     ,p_data_aggiornamento     in aoo.data_aggiornamento%type
   ) is
      /******************************************************************************
       NOME:        agg_automatico
       DESCRIZIONE: Verifica se i dati passati sono stati modificati;
                    in caso affermativo si esegue una storicizzazione
                    altrimenti non si esegue alcuna operazione
                    Se i dati non esistevano vengono inseriti
                    -
       RITORNA:     -
      ******************************************************************************/
      d_codice_amm       aoo.codice_amministrazione%type;
      d_ente             amministrazioni.ente%type;
      d_codice_comune    aoo.comune%type;
      d_codice_provincia aoo.provincia%type;
      d_progr_aoo        aoo.progr_aoo%type;
      d_dal              aoo.dal%type;
      d_al               aoo.al%type;
      d_aggiornamento    number(1);
      uscita exception;
      pragma autonomous_transaction;
   begin
      begin
         select codice_amministrazione
               ,ente
           into d_codice_amm
               ,d_ente
           from amministrazioni
          where codice_amministrazione = upper(rtrim(ltrim(p_codice_amministrazione)));
      exception
         when no_data_found then
            raise_application_error(-20999
                                   ,'Amministrazione ' || p_codice_amministrazione ||
                                    ' non caricata - Impossibile procedere');
         when others then
            raise_application_error(-20999
                                   ,'Errore in lettura amministrazione ' ||
                                    p_codice_amministrazione || ' - ' || sqlerrm);
      end;
      --
      -- Se i dati si riferiscono ad una AOO di un ente proprietario
      -- non si esegue nessuna operazione
      --
      if d_ente = 'SI' then
         raise uscita;
      end if;
      --
      -- Ricerca codice comune
      --
      begin
         select comu.comune
               ,comu.provincia_stato
           into d_codice_comune
               ,d_codice_provincia
           from ad4_comuni    comu
               ,ad4_provincie prov
          where comu.denominazione = upper(rtrim(ltrim(p_localita)))
            and comu.provincia_stato = prov.provincia
            and prov.sigla = nvl(upper(rtrim(ltrim(p_provincia))), prov.sigla)
            and comu.data_soppressione is null
            and comu.provincia_fusione is null
            and comu.comune_fusione is null;
      exception
         when others then
            d_codice_comune    := null;
            d_codice_provincia := null;
      end;
      --
      -- Ricerca codice provincia
      --
      if d_codice_provincia is null then
         begin
            select prov.provincia
              into d_codice_provincia
              from ad4_provincie prov
             where prov.sigla = upper(rtrim(ltrim(p_provincia)));
         exception
            when others then
               d_codice_provincia := null;
         end;
      end if;
      --
      -- Si verifica se i dati sono stati modificati
      --
      begin
         select a1.progr_aoo
               ,a1.dal
               ,a1.al
           into d_progr_aoo
               ,d_dal
               ,d_al
           from aoo a1
          where a1.codice_amministrazione = upper(rtrim(ltrim(p_codice_amministrazione)))
            and a1.codice_aoo = upper(rtrim(ltrim(p_codice_aoo)))
            and nvl(a1.al, to_date('3333333', 'j')) =
                (select max(nvl(a2.al, to_date('3333333', 'j')))
                   from aoo a2
                  where a2.codice_amministrazione =
                        upper(rtrim(ltrim(p_codice_amministrazione)))
                    and a2.codice_aoo = upper(rtrim(ltrim(p_codice_aoo))));
      exception
         when others then
            d_progr_aoo := null;
            d_dal       := null;
            d_al        := null;
      end;
      --
      if d_progr_aoo is null then
         d_progr_aoo := aoo_pkg.get_id_area;
         aoo_pkg.ins(p_progr_aoo              => d_progr_aoo
                    ,p_dal                    => nvl(p_data_istituzione, trunc(sysdate))
                    ,p_codice_amministrazione => upper(rtrim(ltrim(p_codice_amministrazione)))
                    ,p_codice_aoo             => upper(rtrim(ltrim(p_codice_aoo)))
                    ,p_descrizione            => upper(rtrim(ltrim(p_descrizione)))
                    ,p_indirizzo              => upper(rtrim(ltrim(p_indirizzo)))
                    ,p_codice_ipa             => upper(rtrim(ltrim(p_codice_aoo))) --#52548
                    ,p_cap                    => p_cap
                    ,p_provincia              => d_codice_provincia
                    ,p_comune                 => d_codice_comune
                    ,p_telefono               => p_telefono
                    ,p_fax                    => p_fax
                    ,p_al                     => p_data_soppressione
                    ,p_utente_aggiornamento   => p_utente_aggiornamento
                    ,p_data_aggiornamento     => p_data_aggiornamento);
         indirizzo_telematico.ins(p_tipo_entita          => 'AO'
                                 ,p_id_indirizzo         => null
                                 ,p_tipo_indirizzo       => 'I'
                                 ,p_id_aoo               => d_progr_aoo
                                 ,p_indirizzo            => rtrim(ltrim(p_mail_istituzionale))
                                 ,p_utente_aggiornamento => p_utente_aggiornamento
                                 ,p_data_aggiornamento   => p_data_aggiornamento);
      else
         indirizzo_telematico.agg_automatico(p_tipo_entita          => 'AO'
                                            ,p_id_aoo               => d_progr_aoo
                                            ,p_tipo_indirizzo       => 'I'
                                            ,p_indirizzo            => rtrim(ltrim(p_mail_istituzionale))
                                            ,p_utente_aggiornamento => p_utente_aggiornamento
                                            ,p_data_aggiornamento   => p_data_aggiornamento);
         begin
            select 1
              into d_aggiornamento
              from aoo
             where progr_aoo = d_progr_aoo
               and dal = d_dal
               and (upper(descrizione) != upper(rtrim(ltrim(p_descrizione))) or
                   nvl(upper(indirizzo), ' ') !=
                   nvl(upper(rtrim(ltrim(p_indirizzo))), ' ') or
                   nvl(cap, 0) != nvl(p_cap, 0) or
                   nvl(provincia, 0) != nvl(d_codice_provincia, 0) or
                   nvl(comune, 0) != nvl(d_codice_comune, 0) or
                   nvl(telefono, ' ') != nvl(p_telefono, ' ') or
                   nvl(fax, ' ') != nvl(p_fax, ' '));
         exception
            when others then
               d_aggiornamento := 0;
         end;
         if d_aggiornamento = 1 then
            aoo_pkg.ins(p_progr_aoo              => d_progr_aoo
                       ,p_dal                    => trunc(sysdate)
                       ,p_codice_amministrazione => upper(rtrim(ltrim(p_codice_amministrazione)))
                       ,p_codice_aoo             => upper(rtrim(ltrim(p_codice_aoo)))
                       ,p_descrizione            => upper(rtrim(ltrim(p_descrizione)))
                       ,p_codice_ipa             => upper(rtrim(ltrim(p_codice_ipa))) --#52548
                       ,p_indirizzo              => upper(rtrim(ltrim(p_indirizzo)))
                       ,p_cap                    => p_cap
                       ,p_provincia              => d_codice_provincia
                       ,p_comune                 => d_codice_comune
                       ,p_telefono               => p_telefono
                       ,p_fax                    => p_fax
                       ,p_al                     => p_data_soppressione
                       ,p_utente_aggiornamento   => p_utente_aggiornamento
                       ,p_data_aggiornamento     => p_data_aggiornamento);
         else
            if p_data_soppressione is not null and
               p_data_soppressione <> nvl(d_al, to_date('3333333', 'j')) then
               aoo_pkg.upd_column(p_progr_aoo => d_progr_aoo
                                 ,p_dal       => d_dal
                                 ,p_column    => 'AL'
                                 ,p_value     => p_data_soppressione);
            end if;
         end if;
      end if;
      /* modifica #773 */
      BEGIN
         codici_ipa_tpk.del(p_tipo_entita => 'AO', p_progressivo => d_progr_aoo);
      EXCEPTION
      WHEN AFC_ERROR.MODIFIED_BY_OTHER_USER THEN
         NULL;
      END;
         
      codici_ipa_tpk.ins('AO', d_progr_aoo, LTRIM (RTRIM (p_codice_aoo)));        
      commit;
      --
   exception
      when uscita then
         commit;
      when others then
         rollback;
   end; -- aoo_pkg.agg_automatico
--------------------------------------------------------------------------------
begin
   -- inserimento degli errori nella tabella
   s_error_table(s_dal_al_errato_number) := s_dal_al_errato_msg;
   s_error_table(s_dal_errato_number) := s_dal_errato_msg;
   s_error_table(s_dal_errato_ins_number) := s_dal_errato_ins_msg;
   s_error_table(s_al_errato_number) := s_al_errato_msg;
   s_error_table(s_aoo_non_eliminabile_1_number) := s_aoo_non_eliminabile_1_msg;
   s_error_table(s_aoo_non_eliminabile_2_number) := s_aoo_non_eliminabile_2_msg;
   s_error_table(s_codice_errato_number) := s_codice_errato_msg;
   s_error_table(s_descrizione_errata_number) := s_descrizione_errata_msg;
   s_error_table(s_carattere_non_consent_number) := s_carattere_non_consent_msg;
   s_error_table(s_dal_al_ammi_errato_number) := s_dal_al_ammi_errato_msg;
end aoo_pkg;
/

