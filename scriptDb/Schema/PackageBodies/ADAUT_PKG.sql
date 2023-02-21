CREATE OR REPLACE PACKAGE BODY     adaut_pkg is
   /******************************************************************************
    NOME:        adaut_pkg
    DESCRIZIONE: Gestione flussi autorizzativi.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data       Autore     Descrizione.
    000   08/06/2015 ADADAMO    Prima emissione.
    001   22/06/2017 ADADAMO    Corretta determinazione del soggetto per codice
                                fiscale (Bug#22520)
    002   16/03/2018 ADADAMO    Corretta valorizzazione di p_prof_failed in caso di
                                errore in inserimento del soggetto o del componente
                                (Bug#27047)
    003   07/06/2018 ADADAMO    Corretta nuovamente gestione del vettore degli
                                identificativi dei dettagli da invalidare in caso di
                                fallimento nell'inserimento/aggiornamento del soggetto
                                o del componente
   ******************************************************************************/
   s_revisione_body constant afc.t_revision := '003';
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
   end; -- adaut_pkg.versione

   procedure create_as4_soggetto
   (p_nome     in varchar2
   ,p_cognome  in varchar2
   ,p_codice_fiscale in varchar2
   ,p_email    in varchar2
   )  is
    d_id_soggetto   ad4_soggetti.soggetto%type := NULL;
    d_data_nas      varchar2(10);
    d_provincia_nas ad4_soggetti.provincia_nas%type;
    d_comune_nas    ad4_soggetti.COMUNE_nas%type;
    D_SESSO         AD4_SOGGETTI.SESSO%TYPE;
    d_nominativo    ad4_utenti.nominativo%type;
    d_utente        ad4_utenti.utente%type;
    d_id_utente     ad4_utenti.id_utente%type;
   begin
       d_data_nas      := ad4_codice_fiscale.GET_DATA_NAS(P_CODICE_FISCALE);
       d_provincia_nas := ad4_codice_fiscale.GET_PROVINCIA_NAS(P_CODICE_FISCALE);
       d_comune_nas    := ad4_codice_fiscale.GET_COMUNE_NAS(P_CODICE_FISCALE);
       D_SESSO         := ad4_codice_fiscale.GET_SESSO(P_CODICE_FISCALE);

       begin
                AD4_SOGGETTO.INIT;
                AD4_SOGGETTO.SET_COGNOME(P_COGNOME);
                AD4_SOGGETTO.SET_NOME(P_NOME,0);
                AD4_SOGGETTO.SET_SESSO(D_SESSO);
                AD4_SOGGETTO.SET_DATA_NASCITA(d_data_nas);
                AD4_SOGGETTO.SET_PROVINCIA_NAS(d_PROVINCIA_nas);
                AD4_SOGGETTO.SET_COMUNE_NAS(d_COMUNE_nas);
                AD4_SOGGETTO.SET_CODICE_FISCALE(P_CODICE_FISCALE);
                ad4_soggetto.set_competenza('ADAUT');
                AD4_SOGGETTO.SET_INDIRIZZO_WEB(p_email);
                AD4_SOGGETTO.UPDATE_SOGGETTO ( p_soggetto => d_id_soggetto);
       exception when others then
                raise;
       end;
       d_nominativo := AD4_UTENTE.DETERMINA_NOMINATIVO(d_id_soggetto);
       begin
            AD4_UTENTE.INS( p_nominativo            => d_nominativo
                           , p_utente               => d_utente
                           , p_id_utente            => d_id_utente
                           , p_stato                => 'U'
                           , p_utente_aggiornamento => 'ADAUT'
                           , p_soggetto             => d_id_soggetto
                          );
            insert into ad4_utenti_gruppo (utente, gruppo) values (d_utente,'GRPLDAP');
        exception when others then
            raise;
        end;
   end;
   procedure authman_massive
   (p_nome                  in varchar2
   ,p_cognome               in varchar2
   ,P_CODICE_FISCALE        IN VARCHAR2
   ,p_email                 in varchar2
   ,p_lista_ruoli           in varchar2
   ,p_cod_amministrazione   in varchar2
   ,p_codice_uo             in varchar2
   ,p_error_code   out varchar2
   ,p_error_text   out clob
   ,p_prof_failed  out varchar2
   )
   is
     d_lista_ruoli varchar2(2000) := p_lista_ruoli;
     d_progr_uo             number;
     d_ottica               varchar2(18);
     d_xml_clob             clob;
     d_ruolo            varchar2(8);
     d_crea_soggetto        number;
   begin
    if substr(d_lista_ruoli,length(d_lista_ruoli)-1) != '#' then  -- aggiungo # finale se non indicato
        d_lista_ruoli := d_lista_ruoli||'#';
    end if;
    begin
        select ottica
          into d_ottica
          from ottiche
         where amministrazione = p_cod_amministrazione
           and ottica_istituzionale = 'SI'
           ;
    exception when others then RAISE ; end;
    begin
        select progr_unita_organizzativa
          into d_progr_uo
          from anagrafe_unita_organizzative
         where codice_uo = p_codice_uo
           and ottica = d_ottica
           and trunc(sysdate) between dal and nvl(al, to_date(3333333,'j'))
           ;
    exception when others then raise; end;
    dbms_lob.createtemporary(d_xml_clob, true, dbms_lob.session);
    dbms_lob.writeappend(d_xml_clob
                                        ,length('<AUTHORIZATIONS_LIST>')
                                        ,'<AUTHORIZATIONS_LIST>'
                                        );
    while instr(d_lista_ruoli,'#') != 0 loop
        d_ruolo := substr(d_lista_ruoli,1,instr(d_lista_ruoli,'#')-1);
        if d_ruolo is not null then
           dbms_lob.writeappend(d_xml_clob
                                        ,length('<AUTHORIZATION>')
                                        ,'<AUTHORIZATION>'
                                        );
           dbms_lob.writeappend(d_xml_clob
                                        ,length('<PROGR>'||d_progr_uo||'</PROGR>')
                                        ,'<PROGR>'||d_progr_uo||'</PROGR>'
                                        );
           dbms_lob.writeappend(d_xml_clob
                                        ,length('<OTTICA>'||d_OTTICA||'</OTTICA>')
                                        ,'<OTTICA>'||d_OTTICA||'</OTTICA>'
                                        );
           dbms_lob.writeappend(d_xml_clob
                                        ,length('<DAL>'||TO_CHAR(SYSDATE,'DD/MM/YYYY')||'</DAL>')
                                        ,'<DAL>'||TO_CHAR(SYSDATE,'DD/MM/YYYY')||'</DAL>'
                                        );
           dbms_lob.writeappend(d_xml_clob
                                        ,length('<PROFILO>'||d_RUOLO||'</PROFILO>')
                                        ,'<PROFILO>'||d_RUOLO||'</PROFILO>'
                                        );
           dbms_lob.writeappend(d_xml_clob
                                        ,length('<AUTHORIZATION_TYPE>A</AUTHORIZATION_TYPE>')
                                        ,'<AUTHORIZATION_TYPE>A</AUTHORIZATION_TYPE>'
                                        );
           dbms_lob.writeappend(d_xml_clob
                                        ,length('<DATA>'||TO_CHAR(SYSDATE,'DD/MM/YYYY')||'</DATA>')
                                        ,'<DATA>'||TO_CHAR(SYSDATE,'DD/MM/YYYY')||'</DATA>'
                                        );
           dbms_lob.writeappend(d_xml_clob
                                        ,length('<COD_AMM>'||p_cod_amministrazione||'</COD_AMM>')
                                        ,'<COD_AMM>'||p_cod_amministrazione||'</COD_AMM>'
                                        );
           dbms_lob.writeappend(d_xml_clob
                                        ,length('<ID_DETTAGLIO>0</ID_DETTAGLIO>')
                                        ,'<ID_DETTAGLIO>0</ID_DETTAGLIO>'
                                        );
           dbms_lob.writeappend(d_xml_clob
                                        ,length('</AUTHORIZATION>')
                                        ,'</AUTHORIZATION>'
                                        );
        end if;
        d_lista_ruoli := substr(d_lista_ruoli,instr(d_lista_ruoli,'#')+1);
    end loop;
    dbms_lob.writeappend(d_xml_clob
                                    ,length('</AUTHORIZATIONS_LIST>')
                                    ,'</AUTHORIZATIONS_LIST>'
                                    );
        select count(*)
          into d_crea_soggetto
          from as4_anagrafe_soggetti
         where codice_fiscale = p_codice_fiscale;
     if d_crea_soggetto = 0 then
         adaut_pkg.create_as4_soggetto (p_nome     => p_nome
                                       ,p_cognome  => p_cognome
                                       ,p_codice_fiscale => p_codice_fiscale
                                       ,p_email    => p_email
                                       );
     end if;
     ADAUT_PKG.authorization_management(P_NOME,P_COGNOME,P_CODICE_FISCALE,P_EMAIL, d_xml_clob, 'ADAUT',P_ERROR_CODE,P_ERROR_TEXT,P_PROF_FAILED);
   end;
   procedure authorization_management
   (p_nome     in varchar2
   ,p_cognome  in varchar2
   ,p_codice_fiscale in varchar2
   ,p_email    in varchar2
   ,p_authorization_list in clob
   ,p_utente    in ad4_utenti.utente%type
   ,p_error_code   out varchar2
   ,p_error_text   out clob
   ,p_prof_failed  out varchar2
   ) is
  /******************************************************************************
   NOME:        authorization_management
   DESCRIZIONE: Gestione delle autorizzazioni applicative
   RITORNA:
   NOTE:
  ******************************************************************************/
    d_id_soggetto   ad4_soggetti.soggetto%type;

    d_error_text    varchar2(32000);
    x_type          xmltype;
    d_id_componente componenti.id_componente%type;
    d_ID_RUOLO_COMPONENTE ruoli_componente.id_ruolo_componente%type;
    D_DECORRENZA_RUOLO  DATE;
    D_TERMINE_RUOLO  DATE;
    d_clob_error          clob;
    dummy           number;
   begin
        p_error_code := null;
        x_type := xmltype(p_authorization_list);
        dbms_lob.createtemporary(d_clob_error, true, dbms_lob.session);
        -- ricerca individuo per codice_fiscale
        begin
            select SOGG.soggetto
              into d_id_soggetto
              from ad4_soggetti SOGG, AD4_UTENTI_SOGGETTI UTSO, AD4_UTENTI UTEN
             where SOGG.codice_fiscale = p_codice_fiscale
               AND SOGG.SOGGETTO = UTSO.SOGGETTO
               AND UTSO.UTENTE = UTEN.UTENTE
             ;
        exception when no_data_found then
            d_id_soggetto := null;
            WHEN TOO_MANY_ROWS THEN
               p_error_code := 'E';
               d_error_text := sqlerrm;
               dbms_lob.writeappend(d_clob_error
                                        ,length('Impossibile identificare correttamente il soggetto in anagrafica: '||d_error_text)
                                        ,'Impossibile identificare correttamente il soggetto in anagrafica: '||d_error_text
                                        );
                /* aggiunta 07/06/2018 */
                FOR sel_rec IN (
                    SELECT ExtractValue(Value(p),'/AUTHORIZATION/ID_DETTAGLIO/text()') as ID_DETTAGLIO
                    FROM   TABLE(XMLSequence(Extract(X_TYPE,'/AUTHORIZATIONS_LIST/AUTHORIZATION'))) p
                ) LOOP
                    p_prof_failed := p_prof_failed||sel_rec.id_dettaglio||'@'; -- segnalo come se fosse fallito sul primo profilo
                end loop;
                /* aggiunta 07/06/2018 */
                raise;
        end;
        if d_id_soggetto is null then   -- soggetto non esistente o non trovato lo creo ex-novo
            begin
               create_as4_soggetto (p_nome
                                   ,p_cognome
                                   ,p_codice_fiscale
                                   ,p_email
                                   );
            select SOGG.soggetto
              into d_id_soggetto
              from ad4_soggetti SOGG, AD4_UTENTI_SOGGETTI UTSO, AD4_UTENTI UTEN
             where SOGG.codice_fiscale = p_codice_fiscale
/* aggiunta 04/06/2018 */
               AND SOGG.SOGGETTO = UTSO.SOGGETTO
               AND UTSO.UTENTE = UTEN.UTENTE
               AND UTEN.NOMINATIVO = AD4_UTENTE.DETERMINA_NOMINATIVO(UTSO.SOGGETTO);
/* aggiunta 04/06/2018 */
            exception when others then
                p_error_code := 'E';
                d_error_text := sqlerrm;
               dbms_lob.writeappend(d_clob_error
                                        ,length('Impossibile inserire soggetto in anagrafica: '||d_error_text)
                                        ,'Impossibile inserire soggetto in anagrafica: '||d_error_text
                                        );
                /* aggiunta 07/06/2018 */
                FOR sel_rec IN (
                    SELECT ExtractValue(Value(p),'/AUTHORIZATION/ID_DETTAGLIO/text()') as ID_DETTAGLIO
                    FROM   TABLE(XMLSequence(Extract(X_TYPE,'/AUTHORIZATIONS_LIST/AUTHORIZATION'))) p
                ) LOOP
                    p_prof_failed := p_prof_failed||sel_rec.id_dettaglio||'@'; -- segnalo come se fosse fallito sul primo profilo
                end loop;
                /* aggiunta 07/06/2018 */
                raise;
            end;
        end if;
        FOR sel_rec IN (
            SELECT ExtractValue(Value(p),'/AUTHORIZATION/PROGR/text()') as UO
                  ,ExtractValue(Value(p),'/AUTHORIZATION/OTTICA/text()') as OTTICA
                  ,ExtractValue(Value(p),'/AUTHORIZATION/DAL/text()') as DAL
                  ,ExtractValue(Value(p),'/AUTHORIZATION/PROFILO/text()') as PROFILO
                  ,ExtractValue(Value(p),'/AUTHORIZATION/AUTHORIZATION_TYPE/text()') as AUTHORIZATION_TYPE
                  ,ExtractValue(Value(p),'/AUTHORIZATION/DATA/text()') as DATA
                  ,ExtractValue(Value(p),'/AUTHORIZATION/COD_AMM/text()') as COD_AMM
                  ,ExtractValue(Value(p),'/AUTHORIZATION/ID_DETTAGLIO/text()') as ID_DETTAGLIO
            FROM   TABLE(XMLSequence(Extract(X_TYPE,'/AUTHORIZATIONS_LIST/AUTHORIZATION'))) p
        ) LOOP
             begin
                select id_componente
                  into d_id_componente
                  from componenti
                 where progr_unita_organizzativa = to_number(sel_rec.uo)
                   and ottica = sel_rec.ottica
                   and to_date(sel_rec.data,'dd/mm/yyyy') <= nvl(al,to_date(3333333,'j'))
                   and ni = d_id_soggetto;
             exception when no_data_found then --componente non presente sulla UO indicata
                 select COMPONENTI_SQ.NEXTVAL
                   into d_id_componente
                   from dual;
                 begin
                     componente.ins( P_ID_COMPONENTE                => d_id_componente
                                   , P_PROGR_UNITA_ORGANIZZATIVA    => to_number(sel_rec.uo)
                                   , P_DAL                          => to_date(sel_rec.data,'dd/mm/yyyy')
                                   , P_AL                           => null
                                   , P_NI                           => d_id_soggetto
                                   , P_CI                           => null
                                   , P_CODICE_FISCALE               => p_codice_fiscale
                                   , P_DENOMINAZIONE                => null
                                   , P_DENOMINAZIONE_AL1            => null
                                   , P_DENOMINAZIONE_AL2            => null
                                   , P_STATO                        => 'P'
                                   , P_OTTICA                       => sel_rec.ottica
                                   , P_REVISIONE_ASSEGNAZIONE       => null
                                   , P_REVISIONE_CESSAZIONE         => null
                                   , P_UTENTE_AGGIORNAMENTO         => nvl(p_utente,'ADAUT')
                                   , P_DATA_AGGIORNAMENTO           => trunc(sysdate)
                                   , P_DAL_PUBB                     => null
                                   , P_AL_PUBB                      => null
                                   );
                 exception when others then
                    p_error_code := 'E';
                    d_error_text := substr(sqlerrm,1,instr(sqlerrm,chr(10))-1);
                    d_error_text := substr(d_error_text,instr(d_error_text,'ORA-'));
                    d_error_text := substr(d_error_text,12);
                    dbms_lob.writeappend(d_clob_error
                                            ,length('Impossibile inserire utente in struttura organizzativa: '||d_error_text)
                                            ,'Impossibile inserire utente in struttura organizzativa: '||d_error_text
                                            );
                    p_prof_failed := p_prof_failed||sel_rec.ID_DETTAGLIO||'@';
                    raise;
                 end;
             when others then  -- errore inatteso
                p_error_code := 'E';
                d_error_text := sqlerrm;
                dbms_lob.writeappend(d_clob_error
                                        ,length('Impossibile inserire utente in struttura organizzativa: '||d_error_text)
                                        ,'Impossibile inserire utente in struttura organizzativa: '||d_error_text
                                        );
                p_prof_failed := p_prof_failed||sel_rec.ID_DETTAGLIO||'@';
                raise;
             end;
             SOGGETTI_RUBRICA_PKG.SET_EMAIL(d_id_soggetto, p_email,p_utente);
             IF SEL_REC.AUTHORIZATION_TYPE = 'A' THEN -- ASSEGNAZIONE DI UN RUOLO
                 select RUOLI_COMPONENTE_SQ.NEXTVAL
                   into d_ID_RUOLO_COMPONENTE
                   from dual;
                 SELECT GREATEST (TO_DATE(SEL_REC.DATA,'DD/MM/YYYY'),COMPONENTE.GET_DAL(D_ID_COMPONENTE))
                      , DECODE(LEAST    (NVL(COMPONENTE.GET_AL(D_ID_COMPONENTE),TO_DATE(3333333,'J')),TO_DATE(3333333,'J')),TO_DATE(3333333,'J'),NULL,COMPONENTE.GET_AL(D_ID_COMPONENTE))
                   INTO D_DECORRENZA_RUOLO
                      , D_TERMINE_RUOLO
                   FROM DUAL;
                 begin
                     RUOLO_COMPONENTE.INS( P_ID_RUOLO_COMPONENTE => d_ID_RUOLO_COMPONENTE
                                         , P_ID_COMPONENTE       => d_id_componente
                                         , P_RUOLO               => sel_rec.profilo
                                         , P_DAL                 => D_DECORRENZA_RUOLO
                                         , P_AL                  => D_TERMINE_RUOLO
                                         , P_DAL_PUBB            => null
                                         , P_AL_PUBB             => null
                                         , P_AL_PREC             => null
                                         , P_UTENTE_AGGIORNAMENTO=> nvl(p_utente,'ADAUT')
                                         , P_DATA_AGGIORNAMENTO  => trunc(sysdate)
                                         );
                 exception when others then
                        p_error_code := 'W';
                        d_error_text := substr(sqlerrm,1,instr(sqlerrm,chr(10))-1);
                        d_error_text := substr(d_error_text,instr(d_error_text,'ORA-'));
                        d_error_text := substr(d_error_text,12);
                        dbms_lob.writeappend(d_clob_error
                                                ,length(chr(10)||' Ruolo '||sel_rec.profilo||' non attribuito: '||d_error_text)
                                                ,chr(10)||' Ruolo '||sel_rec.profilo||' non attribuito: '||d_error_text
                                                );
                        p_prof_failed := p_prof_failed||sel_rec.ID_DETTAGLIO||'@';
                 end;
             ELSE -- REVOCA DI UN RUOLO
                begin
                    select id_ruolo_componente
                      into d_ID_RUOLO_COMPONENTE
                      from ruoli_componente
                     where id_componente = d_id_componente
                       and ruolo = sel_rec.profilo
                       and to_date(sel_rec.data,'dd/mm/yyyy') between dal and nvl(al,to_date(3333333,'j'));
                     begin
                        RUOLO_COMPONENTE.UPD_COLUMN(d_ID_RUOLO_COMPONENTE,'AL',to_date(sel_rec.data,'dd/mm/yyyy'));
                     exception when others then
                        p_error_code := 'W';
                        d_error_text := substr(sqlerrm,1,instr(sqlerrm,chr(10))-1);
                        d_error_text := substr(d_error_text,instr(d_error_text,'ORA-'));
                        d_error_text := substr(d_error_text,12);
                        dbms_lob.writeappend(d_clob_error
                                                ,length(chr(10)||' Ruolo '||sel_rec.profilo||' non revocato: '||d_error_text)
                                                ,chr(10)||' Ruolo '||sel_rec.profilo||' non revocato: '||d_error_text
                                                );
                        p_prof_failed := p_prof_failed||sel_rec.ID_DETTAGLIO||'@';
                     end;
                exception when no_data_found then
                    p_error_code := 'W';
                    dbms_lob.writeappend(d_clob_error
                                            ,length(chr(10)||' Ruolo '||sel_rec.profilo||' non revocato:  profilo non assegnato all''utente nel periodo indicato')
                                            ,chr(10)||' Ruolo '||sel_rec.profilo||' non revocato:  profilo non assegnato all''utente nel periodo indicato'
                                            );
                    p_prof_failed := p_prof_failed||sel_rec.ID_DETTAGLIO||'@';
                end;
             END IF;
        END LOOP;
        commit;
        dummy := ad4_utente.rigenera_so(so4_ags_pkg.comp_get_utente(componente.get_ni(d_id_componente)));
        if dummy != 0 then -- fallita la rigenera_so
            p_error_code := 'W';
            dbms_lob.writeappend(d_clob_error
                                    ,length(chr(10)||' Attenzione riattribuzione diritti accesso fallita: verificare tabella di log.')
                                    ,chr(10)||' Attenzione riattribuzione diritti accesso fallita: verificare tabella di log.'
                                    );
        end if;
        p_error_text := d_clob_error;
   exception when others then
         p_error_text := d_clob_error;
   end;  -- adaut_pkg.authorization_management

   procedure update_as4_soggetto
    (p_ni       in number
    ,p_nome     in varchar2
    ,p_cognome  in varchar2
    ,p_codice_fiscale in varchar2
    ,p_email    in varchar2
    ,p_telefono in varchar2
    ,p_utente_agg in varchar2
    ,p_error_code   out varchar2
    ,p_error_text   out clob
    ) is
        d_dal    date;
        d_ni    number;
        D_CODICE_FISCALE    VARCHAR2(16);
        d_clob_error          clob;
        d_data_nas      varchar2(10);
        d_provincia_nas ad4_soggetti.provincia_nas%type;
        d_comune_nas    ad4_soggetti.COMUNE_nas%type;
        D_SESSO         AD4_SOGGETTI.SESSO%TYPE;
        d_old_cognome   varchar2(80);
   begin
        p_error_code := null;
        dbms_lob.createtemporary(d_clob_error, true, dbms_lob.session);
        begin
            select ni, dal, cognome , CODICE_FISCALE
              into d_ni, d_dal, d_old_cognome, D_CODICE_FISCALE
              from as4_anagrafe_soggetti
             where ni = p_ni
               and trunc(sysdate) between dal and nvl(al, to_date('3333333','j'));
        exception when no_data_found then
            p_error_code := '-1';
            dbms_lob.writeappend(d_clob_error
                                    ,length('Attenzione soggetto non codificato nell''amministrazione corrente.')
                                    ,'Attenzione soggetto non codificato nell''amministrazione corrente.'
                                    );
        end;
        if p_error_code is null then -- soggetto trovato
            BEGIN
                d_data_nas      := ad4_codice_fiscale.GET_DATA_NAS(P_CODICE_FISCALE);
                d_provincia_nas := ad4_codice_fiscale.GET_PROVINCIA_NAS(P_CODICE_FISCALE);
                d_comune_nas    := ad4_codice_fiscale.GET_COMUNE_NAS(P_CODICE_FISCALE);
                D_SESSO         := ad4_codice_fiscale.GET_SESSO(P_CODICE_FISCALE);
                as4_anagrafe_soggetti_tpk.upd( p_check_OLD => 0
                                             , p_NEW_ni  => d_ni
                                             , p_OLD_ni  => d_ni
                                             , p_NEW_dal => d_dal
                                             , p_OLD_dal => d_dal
                                             , p_NEW_cognome  => p_cognome
                                             , p_old_cognome  => d_old_cognome
                                             , p_NEW_nome  => p_nome
                                             , p_NEW_denominazione  => p_cognome||'  '||p_nome
                                             , p_NEW_sesso  => d_sesso
                                             , p_NEW_data_nas => to_date(d_data_nas,'dd/mm/yyyy')
                                             , p_NEW_provincia_nas  => d_provincia_nas
                                             , p_NEW_comune_nas  => d_comune_nas
                                             , p_NEW_codice_fiscale => p_codice_fiscale
                                             , p_NEW_indirizzo_web  => p_email
                                             , p_new_tel_dom => p_telefono
                                             , p_new_utente => p_utente_agg
                                             , p_new_competenza => 'ADAUT'
                                           );
                SOGGETTI_RUBRICA_PKG.SET_EMAIL(d_ni, p_email,p_utente_agg);
                IF D_CODICE_FISCALE != P_CODICE_FISCALE THEN -- HO CAMBIATO IL CODICE FISCALE QUINDI DEVO CAMBIARE IL NOMINATIVO IN ad4
                    UPDATE AD4_UTENTI SET NOMINATIVO = P_CODICE_FISCALE
                    WHERE NOMINATIVO = D_CODICE_FISCALE;
                END IF;
            exception when others then
                p_error_code := -2;
                dbms_lob.writeappend(d_clob_error
                        ,length(sqlerrm)
                        ,sqlerrm
                        );
                rollback;
            end;
        end if;
        p_error_text := d_clob_error;
    end;

    procedure update_as4_soggetto_ws
    (p_codice_fiscale_old   in varchar2
    ,p_nome                 in varchar2
    ,p_cognome              in varchar2
    ,p_codice_fiscale       in varchar2
    ,p_email                in varchar2
    ,p_telefono             in varchar2
    ,p_utente_agg           in varchar2
    ,p_error_code           out varchar2
    ,p_error_text           out clob
    ) is
        d_ni    number;
    begin
        begin -- cerco soggetto che abbia un utente abbinato
            select ni
              into d_ni
              from as4_anagrafe_soggetti sogg, AD4_UTENTI_SOGGETTI UTSO, AD4_UTENTI UTEN
             where SOGG.codice_fiscale = p_codice_fiscale_old
               AND SOGG.ni = UTSO.SOGGETTO
               AND UTSO.UTENTE = UTEN.UTENTE
               and trunc(sysdate) between dal and nvl(al, to_date('3333333','j'));
        exception when no_data_found then
            d_ni := '-1';
        end;
        ADAUT_PKG.UPDATE_AS4_SOGGETTO(p_ni       => d_ni
                                     ,p_nome     => p_nome
                                     ,p_cognome  => p_cognome
                                     ,p_codice_fiscale => p_codice_fiscale
                                     ,p_email    => p_email
                                     ,p_telefono => p_telefono
                                     ,p_utente_agg => p_utente_agg
                                     ,p_error_code => p_error_code
                                     ,p_error_text => p_error_text
                                     );

    end;



end;
/

