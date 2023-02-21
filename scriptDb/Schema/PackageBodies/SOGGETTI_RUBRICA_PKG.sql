CREATE OR REPLACE package body soggetti_rubrica_pkg is
   /******************************************************************************
    NOME:        SOGGETTI_RUBRICA_PKG
    DESCRIZIONE: Gestione dei contatti della rubrica
    ANNOTAZIONI: .
    REVISIONI:   .
    <CODE>
    Rev.   Data        Autore      Descrizione.
    000    17/02/2010  APASSUELLO Prima emissione.
    001    16/01/2012  VDAVALLI   Aggiunte funzioni di selezione della prima e
                                  della seconda occorrenza per tipo di contatto.
    002    02/07/2015  ADADAMO    Modificate funzioni di set per gestire il caso
                                  in cui non esista il record per il soggetto ed il
                                  tipo di contatto indicato (Bug#625)
    003    11/01/2016  ADADAMO    Aggiunte funzioni per gestione del TIPO_CONTATTO
                                  memorizzato su SO4_CODIFICHE e per gestione del
                                  tipo contatto EMAIL PEC (Feature#671)                                  
   ******************************************************************************/

   s_revisione_body constant afc.t_revision := '003 - 11/01/2016';
   s_error_table    afc_error.t_error_table;
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
   end; -- soggetti_rubrica_pkg.versione
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
   end; -- soggetti_rubrica.error_message
   --------------------------------------------------------------------------------

   function get_telefono_fisso(p_ni in soggetti_rubrica.ni%type)
      return soggetti_rubrica.contatto%type is
      /********************************************************************************
       NOME:        get_telefono_fisso
       DESCRIZIONE: Ritorna il contatto corrispondente al tipo_contatto=telefono_fisso,
                    progressivo=1 e NI passato come parametro.
       RITORNA:     campo soggetti_rubrica.contatto%type del soggetto corrispondente
       NOTE:
      ********************************************************************************/
   begin
   
      begin
         return soggetti_rubrica_tpk.get_contatto(p_ni            => p_ni
                                                 ,p_tipo_contatto => 10
                                                 ,p_progressivo   => 1);
      exception
         when no_data_found then
            return null;
      end;
   
   end; -- soggetti_rubrica_pkg.get_telefono_fisso

   ---------------------------------------------------------------------------------

   function get_cellulare(p_ni in soggetti_rubrica.ni%type)
      return soggetti_rubrica.contatto%type is
      /******************************************************************************
       NOME:        get_cellulare
       DESCRIZIONE: Ritorna il contatto corrispondente al tipo_contatto=cellulare,
                    progressivo=1 e NI passato come parametro.
       RITORNA:     campo soggetti_rubrica.contatto%type del soggetto corrispondente
       NOTE:
      ******************************************************************************/
   begin
   
      begin
         return soggetti_rubrica_tpk.get_contatto(p_ni            => p_ni
                                                 ,p_tipo_contatto => 20
                                                 ,p_progressivo   => 1);
      exception
         when no_data_found then
            return null;
      end;
   
   end; -- soggetti_rubrica_pkg.get_cellulare

   -------------------------------------------------------------------------------

   function get_numero_breve(p_ni in soggetti_rubrica.ni%type)
      return soggetti_rubrica.contatto%type is
      /******************************************************************************
       NOME:        get_numero_breve
       DESCRIZIONE: Ritorna il contatto corrispondente al tipo_contatto=numero_breve,
                    progressivo=1 e NI passato come parametro.
       RITORNA:     campo soggetti_rubrica.contatto%type del soggetto corrispondente
       NOTE:
      ******************************************************************************/
   begin
   
      begin
         return soggetti_rubrica_tpk.get_contatto(p_ni            => p_ni
                                                 ,p_tipo_contatto => 30
                                                 ,p_progressivo   => 1);
      exception
         when no_data_found then
            return null;
      end;
   
   end; -- soggetti_rubrica_pkg.get_numero_breve

   -------------------------------------------------------------------------------

   function get_email(p_ni in soggetti_rubrica.ni%type)
      return soggetti_rubrica.contatto%type is
      /******************************************************************************
       NOME:        get_email
       DESCRIZIONE: Ritorna il contatto corrispondente al tipo_contatto=email,
                    progressivo=1 e NI passato come parametro.
       RITORNA:     campo soggetti_rubrica.contatto%type del soggetto corrispondente
       NOTE:
      ******************************************************************************/
   begin
   
      begin
         return soggetti_rubrica_tpk.get_contatto(p_ni            => p_ni
                                                 ,p_tipo_contatto => 40
                                                 ,p_progressivo   => 1);
      exception
         when no_data_found then
            return null;
      end;
   
   end; -- soggetti_rubrica_pkg.get_email

   -------------------------------------------------------------------------------

   function get_fax(p_ni in soggetti_rubrica.ni%type) return soggetti_rubrica.contatto%type is
      /******************************************************************************
       NOME:        get_fax
       DESCRIZIONE: Ritorna il contatto corrispondente al tipo_contatto=fax,
                    progressivo=1 e NI passato come parametro.
       RITORNA:     campo soggetti_rubrica.contatto%type del soggetto corrispondente
       NOTE:
      ******************************************************************************/
   begin
   
      begin
         return soggetti_rubrica_tpk.get_contatto(p_ni            => p_ni
                                                 ,p_tipo_contatto => 50
                                                 ,p_progressivo   => 1);
      exception
         when no_data_found then
            return null;
      end;
   
   end; -- soggetti_rubrica_pkg.get_fax

   ------------------------------------------------------------------------------
   
   function get_email_pec(p_ni in soggetti_rubrica.ni%type) return soggetti_rubrica.contatto%type is
      /******************************************************************************
       NOME:        get_email_pec
       DESCRIZIONE: Ritorna il contatto corrispondente al tipo_contatto=mail pec
                    progressivo=1 e NI passato come parametro.
       RITORNA:     campo soggetti_rubrica.contatto%type del soggetto corrispondente
       NOTE:
      ******************************************************************************/
   begin
   
      begin
         return soggetti_rubrica_tpk.get_contatto(p_ni            => p_ni
                                                 ,p_tipo_contatto => 80
                                                 ,p_progressivo   => 1);
      exception
         when no_data_found then
            return null;
      end;
   
   end; -- soggetti_rubrica_pkg.get_fax   

   -------------------------------------------------------------------------------

   function get_primo_progr
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
   ) return soggetti_rubrica.progressivo%type is
      /******************************************************************************
       NOME:        get_primo_progr
       DESCRIZIONE: Ritorna il primo progressivo utilizzato per tipo contatto.
       RITORNA:     campo soggetti_rubrica.progressivo%type del soggetto corrispondente
       NOTE:
      ******************************************************************************/
      d_result soggetti_rubrica.progressivo%type;
   begin
      begin
         select min(progressivo)
           into d_result
           from soggetti_rubrica
          where ni = p_ni
            and tipo_contatto = p_tipo_contatto
          group by ni
                  ,tipo_contatto;
      exception
         when no_data_found then
            d_result := null;
      end;
   
      return d_result;
   end; -- soggetti_rubrica_pkg.get_primo_progr

   ------------------------------------------------------------------------------

   function get_secondo_progr
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
   ) return soggetti_rubrica.progressivo%type is
      /******************************************************************************
       NOME:        get_secondo_progr
       DESCRIZIONE: Ritorna il secondo progressivo utilizzato per tipo contatto.
       RITORNA:     campo soggetti_rubrica.progressivo%type del soggetto corrispondente
       NOTE:
      ******************************************************************************/
      d_primo_progr soggetti_rubrica.progressivo%type;
      d_result      soggetti_rubrica.progressivo%type;
   
   begin
      d_primo_progr := soggetti_rubrica_pkg.get_primo_progr(p_ni            => p_ni
                                                           ,p_tipo_contatto => p_tipo_contatto);
      if d_primo_progr is not null then
         begin
            select min(progressivo)
              into d_result
              from soggetti_rubrica
             where ni = p_ni
               and tipo_contatto = p_tipo_contatto
               and progressivo > d_primo_progr
             group by ni
                     ,tipo_contatto;
         exception
            when no_data_found then
               d_result := to_number(null);
         end;
      else
         d_result := to_number(null);
      end if;
   
      return d_result;
   end; -- soggetti_rubrica_pkg.get_secondo_progr

   ------------------------------------------------------------------------------

   function get_primo_contatto
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
   ) return soggetti_rubrica.contatto%type is
      /******************************************************************************
       NOME:        get_primo_contatto
       DESCRIZIONE: Ritorna la prima occorrenza per tipo contatto.
       RITORNA:     campo soggetti_rubrica.contatto%type del soggetto corrispondente
       NOTE:
      ******************************************************************************/
      d_primo_progr soggetti_rubrica.progressivo%type;
      d_result      soggetti_rubrica.contatto%type;
   
   begin
      d_primo_progr := soggetti_rubrica_pkg.get_primo_progr(p_ni            => p_ni
                                                           ,p_tipo_contatto => p_tipo_contatto);
      if d_primo_progr is not null then
         d_result := soggetti_rubrica_tpk.get_contatto(p_ni            => p_ni
                                                      ,p_tipo_contatto => p_tipo_contatto
                                                      ,p_progressivo   => d_primo_progr);
      else
         d_result := null;
      end if;
   
      return d_result;
   end; -- soggetti_rubrica_pkg.get_primo_contatto

   ------------------------------------------------------------------------------

   function get_secondo_contatto
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
   ) return soggetti_rubrica.contatto%type is
      /******************************************************************************
       NOME:        get_secondo_contatto
       DESCRIZIONE: Ritorna la secondo occorrenza per tipo contatto.
       RITORNA:     campo soggetti_rubrica.contatto%type del soggetto corrispondente
       NOTE:
      ******************************************************************************/
      d_secondo_progr soggetti_rubrica.progressivo%type;
      d_result        soggetti_rubrica.contatto%type;
   
   begin
      d_secondo_progr := soggetti_rubrica_pkg.get_secondo_progr(p_ni            => p_ni
                                                               ,p_tipo_contatto => p_tipo_contatto);
      if d_secondo_progr is not null then
         d_result := soggetti_rubrica_tpk.get_contatto(p_ni            => p_ni
                                                      ,p_tipo_contatto => p_tipo_contatto
                                                      ,p_progressivo   => d_secondo_progr);
      else
         d_result := null;
      end if;
   
      return d_result;
   end; -- soggetti_rubrica_pkg.get_secondo_contatto

   -------------------------------------------------------------------------------

   procedure set_telefono_fisso
   (
      p_ni     in soggetti_rubrica.ni%type
     ,p_value  in soggetti_rubrica.contatto%type
     ,p_utente in soggetti_rubrica.utente_agg%type default null
   ) is
      /******************************************************************************
       NOME:        set_telefono_fisso
       DESCRIZIONE: Setter per (tipo_contatto=telefono fisso) e (progressivo=1)
       PARAMETRI:   NI del soggetto e valore del contatto
       NOTE:
      ******************************************************************************/
   begin
   
      /*DbC.PRE ( not DbC.PreOn or  existsId ( p_ni => p_ni
                                   , p_tipo_contatto => p_tipo_contatto
                                   , p_progressivo => p_progressivo
                                   )
      , 'existsId on soggetti_rubrica_tpk.set_contatto'
      );*/
      if soggetti_rubrica_tpk.existsid(p_ni            => p_ni
                                      ,p_tipo_contatto => 10
                                      ,p_progressivo   => 1) then
         soggetti_rubrica_tpk.set_contatto(p_ni            => p_ni
                                          ,p_tipo_contatto => 10
                                          ,p_progressivo   => 1
                                          ,p_value         => p_value);
         soggetti_rubrica_tpk.set_utente_agg(p_ni            => p_ni
                                            ,p_tipo_contatto => 10
                                            ,p_progressivo   => 1
                                            ,p_value         => nvl(p_utente
                                                                   ,nvl(si4.utente, 'SO4')));
      else
         soggetti_rubrica_tpk.ins(p_ni            => p_ni
                                 ,p_tipo_contatto => 10
                                 ,p_progressivo   => 1
                                 ,p_contatto      => p_value
                                 ,p_pubblicabile  => 'S'
                                 ,p_utente_agg    => nvl(p_utente, nvl(si4.utente, 'SO4'))
                                 ,p_data_agg      => sysdate);
      end if;
   
   end set_telefono_fisso; -- soggetti_rubrica_pkg.set_telefono_fisso

   --------------------------------------------------------------------------------

   procedure set_cellulare
   (
      p_ni     in soggetti_rubrica.ni%type
     ,p_value  in soggetti_rubrica.contatto%type
     ,p_utente in soggetti_rubrica.utente_agg%type default null
   ) is
      /******************************************************************************
       NOME:        set_cellulare
       DESCRIZIONE: Setter per (tipo_contatto=cellulare) e (progressivo=1)
       PARAMETRI:   NI del soggetto e valore del contatto
       NOTE:
      ******************************************************************************/
   begin
   
      /*DbC.PRE ( not DbC.PreOn or  existsId ( p_ni => p_ni
                                   , p_tipo_contatto => p_tipo_contatto
                                   , p_progressivo => p_progressivo
                                   )
      , 'existsId on soggetti_rubrica_tpk.set_contatto'
      );*/
      if soggetti_rubrica_tpk.existsid(p_ni            => p_ni
                                      ,p_tipo_contatto => 20
                                      ,p_progressivo   => 1) then
         soggetti_rubrica_tpk.set_contatto(p_ni            => p_ni
                                          ,p_tipo_contatto => 20
                                          ,p_progressivo   => 1
                                          ,p_value         => p_value);
         soggetti_rubrica_tpk.set_utente_agg(p_ni            => p_ni
                                            ,p_tipo_contatto => 20
                                            ,p_progressivo   => 1
                                            ,p_value         => nvl(p_utente
                                                                   ,nvl(si4.utente, 'SO4')));
      else
         soggetti_rubrica_tpk.ins(p_ni            => p_ni
                                 ,p_tipo_contatto => 20
                                 ,p_progressivo   => 1
                                 ,p_contatto      => p_value
                                 ,p_pubblicabile  => 'S'
                                 ,p_utente_agg    => nvl(p_utente, nvl(si4.utente, 'SO4'))
                                 ,p_data_agg      => sysdate);
      end if;
   end set_cellulare; -- soggetti_rubrica_pkg.set_cellulare

   --------------------------------------------------------------------------------

   procedure set_numero_breve
   (
      p_ni     in soggetti_rubrica.ni%type
     ,p_value  in soggetti_rubrica.contatto%type
     ,p_utente in soggetti_rubrica.utente_agg%type default null
   ) is
      /******************************************************************************
       NOME:        set_numero_breve
       DESCRIZIONE: Setter per (tipo_contatto=numero_breve) e (progressivo=1)
       PARAMETRI:   NI del soggetto e valore del contatto
       NOTE:
      ******************************************************************************/
   begin
   
      /*DbC.PRE ( not DbC.PreOn or  existsId ( p_ni => p_ni
                                   , p_tipo_contatto => p_tipo_contatto
                                   , p_progressivo => p_progressivo
                                   )
      , 'existsId on soggetti_rubrica_tpk.set_contatto'
      );*/
      if soggetti_rubrica_tpk.existsid(p_ni            => p_ni
                                      ,p_tipo_contatto => 30
                                      ,p_progressivo   => 1) then
         soggetti_rubrica_tpk.set_contatto(p_ni            => p_ni
                                          ,p_tipo_contatto => 30
                                          ,p_progressivo   => 1
                                          ,p_value         => p_value);
         soggetti_rubrica_tpk.set_utente_agg(p_ni            => p_ni
                                            ,p_tipo_contatto => 30
                                            ,p_progressivo   => 1
                                            ,p_value         => nvl(p_utente
                                                                   ,nvl(si4.utente, 'SO4')));
      else
         soggetti_rubrica_tpk.ins(p_ni            => p_ni
                                 ,p_tipo_contatto => 30
                                 ,p_progressivo   => 1
                                 ,p_contatto      => p_value
                                 ,p_pubblicabile  => 'S'
                                 ,p_utente_agg    => nvl(p_utente, nvl(si4.utente, 'SO4'))
                                 ,p_data_agg      => sysdate);
      end if;
   
   end set_numero_breve; -- soggetti_rubrica_pkg.set_numero_breve

   --------------------------------------------------------------------------------

   procedure set_email
   (
      p_ni     in soggetti_rubrica.ni%type
     ,p_value  in soggetti_rubrica.contatto%type
     ,p_utente in soggetti_rubrica.utente_agg%type default null
   ) is
      /******************************************************************************
       NOME:        set_email
       DESCRIZIONE: Setter per (tipo_contatto=email) e (progressivo=1)
       PARAMETRI:   NI del soggetto e valore del contatto
       NOTE:
      ******************************************************************************/
   begin
   
      /*DbC.PRE ( not DbC.PreOn or  existsId ( p_ni => p_ni
                                   , p_tipo_contatto => p_tipo_contatto
                                   , p_progressivo => p_progressivo
                                   )
      , 'existsId on soggetti_rubrica_tpk.set_contatto'
      );*/
      if soggetti_rubrica_tpk.existsid(p_ni            => p_ni
                                      ,p_tipo_contatto => 40
                                      ,p_progressivo   => 1) then
         soggetti_rubrica_tpk.set_contatto(p_ni            => p_ni
                                          ,p_tipo_contatto => 40
                                          ,p_progressivo   => 1
                                          ,p_value         => p_value);
         soggetti_rubrica_tpk.set_utente_agg(p_ni            => p_ni
                                            ,p_tipo_contatto => 40
                                            ,p_progressivo   => 1
                                            ,p_value         => nvl(p_utente
                                                                   ,nvl(si4.utente, 'SO4')));
      else
         soggetti_rubrica_tpk.ins(p_ni            => p_ni
                                 ,p_tipo_contatto => 40
                                 ,p_progressivo   => 1
                                 ,p_contatto      => p_value
                                 ,p_pubblicabile  => 'S'
                                 ,p_utente_agg    => nvl(p_utente, nvl(si4.utente, 'SO4'))
                                 ,p_data_agg      => sysdate);
      end if;
   end set_email; -- soggetti_rubrica_pkg.set_email

   --------------------------------------------------------------------------------

   procedure set_fax
   (
      p_ni     in soggetti_rubrica.ni%type
     ,p_value  in soggetti_rubrica.contatto%type
     ,p_utente in soggetti_rubrica.utente_agg%type default null
   ) is
      /******************************************************************************
       NOME:        set_fax
       DESCRIZIONE: Setter per (tipo_contatto=fax) e (progressivo=1)
       PARAMETRI:   NI del soggetto e valore del contatto
       NOTE:
      ******************************************************************************/
   begin
   
      /*DbC.PRE ( not DbC.PreOn or  existsId ( p_ni => p_ni
                                   , p_tipo_contatto => p_tipo_contatto
                                   , p_progressivo => p_progressivo
                                   )
      , 'existsId on soggetti_rubrica_tpk.set_contatto'
      );*/
      if soggetti_rubrica_tpk.existsid(p_ni            => p_ni
                                      ,p_tipo_contatto => 50
                                      ,p_progressivo   => 1) then
         soggetti_rubrica_tpk.set_contatto(p_ni            => p_ni
                                          ,p_tipo_contatto => 50
                                          ,p_progressivo   => 1
                                          ,p_value         => p_value);
         soggetti_rubrica_tpk.set_utente_agg(p_ni            => p_ni
                                            ,p_tipo_contatto => 50
                                            ,p_progressivo   => 1
                                            ,p_value         => nvl(p_utente
                                                                   ,nvl(si4.utente, 'SO4')));
      else
         soggetti_rubrica_tpk.ins(p_ni            => p_ni
                                 ,p_tipo_contatto => 50
                                 ,p_progressivo   => 1
                                 ,p_contatto      => p_value
                                 ,p_pubblicabile  => 'S'
                                 ,p_utente_agg    => nvl(p_utente, nvl(si4.utente, 'SO4'))
                                 ,p_data_agg      => sysdate);
      end if;
   end set_fax; -- soggetti_rubrica_pkg.set_fax
--------------------------------------------------------------------------------

   procedure set_email_pec
   (
      p_ni     in soggetti_rubrica.ni%type
     ,p_value  in soggetti_rubrica.contatto%type
     ,p_utente in soggetti_rubrica.utente_agg%type default null
   ) is
      /******************************************************************************
       NOME:        set_fax
       DESCRIZIONE: Setter per (tipo_contatto=fax) e (progressivo=1)
       PARAMETRI:   NI del soggetto e valore del contatto
       NOTE:
      ******************************************************************************/
   begin

      if soggetti_rubrica_tpk.existsid(p_ni            => p_ni
                                      ,p_tipo_contatto => 80
                                      ,p_progressivo   => 1) then
         soggetti_rubrica_tpk.set_contatto(p_ni            => p_ni
                                          ,p_tipo_contatto => 80
                                          ,p_progressivo   => 1
                                          ,p_value         => p_value);
         soggetti_rubrica_tpk.set_utente_agg(p_ni            => p_ni
                                            ,p_tipo_contatto => 80
                                            ,p_progressivo   => 1
                                            ,p_value         => nvl(p_utente
                                                                   ,nvl(si4.utente, 'SO4')));
      else
         soggetti_rubrica_tpk.ins(p_ni            => p_ni
                                 ,p_tipo_contatto => 80
                                 ,p_progressivo   => 1
                                 ,p_contatto      => p_value
                                 ,p_pubblicabile  => 'S'
                                 ,p_utente_agg    => nvl(p_utente, nvl(si4.utente, 'SO4'))
                                 ,p_data_agg      => sysdate);
      end if;
   end set_email_pec; -- soggetti_rubrica_pkg.set_email_pec
--------------------------------------------------------------------------------

   function is_tipo_CONTATTO_ok
   (
      p_tipo_contatto       in soggetti_rubrica.tipo_contatto%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_tipo_CONTATTO_ok
       DESCRIZIONE: Controllo di correttezza sul valore di tipo_contatto
       PARAMETRI:   p_tipo_contatto
       NOTE:        --
      ******************************************************************************/
      d_result     afc_error.t_error_number;
   begin
    begin
        select afc_error.ok
          into d_result
          from so4_codifiche
         where dominio = 'SOGGETTI_RUBRICA.TIPO_CONTATTO'
           AND VALORE =  p_tipo_contatto;
    EXCEPTION WHEN OTHERS THEN
        d_result := s_TIPO_CONTATTO_erratO_num;
    END;
    --
    dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
          ,'d_result = AFC_Error.ok or d_result < 0 on area_org_om.is_dal_al_ok');
    return d_result;
   end; -- attributo_componente.is_tipo_assegnazione_ok
   
   function is_ri_ok
   ( p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
    ,p_inserting in number
    ,p_updating  in number
    ,p_deleting  in number   
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_RI_ok.
       DESCRIZIONE: gestione della Referential Integrity:
                    - is_tipo_contatto_ok
       RETURN:      1 se tutti i controlli danno esito positivo, l'error_code altrimenti
       NOTE:        --
      ******************************************************************************/
      d_result            afc_error.t_error_number := afc_error.ok;
   begin
      if p_deleting = 0 then
         -- is_dal_ok 
         d_result := is_tipo_contatto_ok(p_tipo_contatto);
      end if;
      return d_result;
   end; -- attr_assegnazione_fisica_pkg.is_RI_ok
   --------------------------------------------------------------------------------
   procedure chk_ri
   (
      p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_inserting in number
     ,p_updating  in number
     ,p_deleting  in number
   ) is
      /******************************************************************************
       NOME:        chk_RI.
       DESCRIZIONE: gestione della Referential Integrity:
                    - is_tipo_contatto_ok
       PARAMETRI:   p_tipo_contatto
       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
      d_result := is_ri_ok(p_tipo_contatto
                          ,p_inserting
                          ,p_updating
                          ,p_deleting);
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, s_error_table(d_result));
      end if;
   end; -- attr_assegnazione_fisica_pkg.chk_RI   
   
begin   
-- inserimento degli errori nella tabella
   -- s_error_table( s_<exception_name>_number ) := s_<exception_name>_msg;
   s_error_table(s_TIPO_CONTATTO_erratO_num) := s_TIPO_CONTATTO_erratO_msg;
end soggetti_rubrica_pkg;
/

