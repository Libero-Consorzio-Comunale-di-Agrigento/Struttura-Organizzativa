CREATE OR REPLACE package body controlli_unita_organizzative is
   /******************************************************************************
   NOME:        controlli_unita_organizzative
   DESCRIZIONE: Raggruppa le funzioni di controllo dei dati caricati in so4.
   ANNOTAZIONI: 
   
   REVISIONI: .
   <CODE>
   Rev.  Data        Autore    Descrizione.
   00    13/11/2012  VDAVALLI  Prima emissione.
   01    09/06/2015  MMONARI   Isue #122.
   </CODE>
   ******************************************************************************/

   s_revisione_body constant varchar2(30) := '001';
   s_error_date date := sysdate;
   s_error_user varchar2(8) := 'CHK SO4';
   s_ottica     ottiche.ottica%type;
   s_data_limite constant date := to_date(3333333, 'j');
   s_dummy             varchar2(1);
   s_tipo_elaborazione varchar2(1);

   function versione return varchar2 is
      /******************************************************************************
      NOME:        versione.
      DESCRIZIONE: Restituisce versione e revisione di distribuzione del package.
      RITORNA:     VARCHAR2 stringa contenente versione e revisione.
      NOTE:        Primo numero  : versione compatibilità del Package.
                   Secondo numero: revisione del Package specification.
                   Terzo numero  : revisione del Package body.
      ******************************************************************************/
   begin
      return s_revisione || '.' || s_revisione_body;
   end;
   -------------------------------------------------------------------------------
   procedure registra_errore
   (
      p_text     varchar2
     ,p_usertext varchar2
   ) is
      /******************************************************************************
      NOME:        registra_errore.
      DESCRIZIONE: Registra un messaggio di errore nella tabella KEY_ERROR_LOG
      RITORNA:     //
      NOTE:        
      ******************************************************************************/
      d_session key_error_log.error_session%type;
   begin
      if p_usertext like 'ANUO%' then
         d_session := 200001;
      elsif p_usertext like 'UNOR%' then
         d_session := 200002;
      elsif p_usertext like 'CONTROLLI%' then
         d_session := 200003;
      end if;
      --
      begin
         key_error_log_tpk.ins(p_error_session  => d_session
                              ,p_error_date     => s_error_date
                              ,p_error_text     => p_text
                              ,p_error_user     => s_error_user
                              ,p_error_usertext => p_usertext
                              ,p_error_type     => 'B');
      exception
         when others then
            dbms_output.put_line('KEY_ERROR_LOG - ' || sqlerrm);
            raise;
      end;
   end;
   -------------------------------------------------------------------------------
   procedure registra_info
   (
      p_text     varchar2
     ,p_usertext varchar2 default null
   ) is
      /******************************************************************************
      NOME:        registra_info.
      DESCRIZIONE: Registra una segnalazione informativa nella tabella KEY_ERROR_LOG
      RITORNA:     //
      NOTE:        
      ******************************************************************************/
      d_session key_error_log.error_session%type;
   begin
      if p_usertext is null then
         d_session := 200000;
      elsif p_usertext like 'ANUO%' then
         d_session := 200001;
      elsif p_usertext like 'UNOR%' then
         d_session := 200002;
      elsif p_usertext like 'CONTROLLI%' then
         d_session := 200003;
      end if;
      --
      begin
         key_error_log_tpk.ins(p_error_session  => d_session
                              ,p_error_date     => s_error_date
                              ,p_error_text     => p_text
                              ,p_error_user     => s_error_user
                              ,p_error_usertext => p_usertext
                              ,p_error_type     => 'P');
      exception
         when others then
            dbms_output.put_line('KEY_ERROR_LOG - ' || sqlerrm);
            raise;
      end;
   end;
   -------------------------------------------------------------------------------
   procedure anuo_controllo_01(p_tipo_elaborazione number) is
      /******************************************************************************
      NOME:        anuo_controllo_01.
      DESCRIZIONE: ANAGRAFE_UNITA_ORGANIZZATIVE: controlla la presenza dell'ottica
      RITORNA:     //
      NOTE:        Il controllo viene eseguito sull'intera tabella.
                   P_tipo_elaborazione = 1: si esegue solo il controllo;
                   P_tipo_elaborazione = 2: si esegue la rettifica dei dati.
                   N.B. Al momento il tipo elaborazione 2 è gestito solo per
                        ottica non congruente con l'amministrazione.
       REVISIONI:
       Rev.  Data        Autore   Descrizione
       ----  ----------  ------   ----------------------------------------------------
       0     01/10/2014  VDAVALLI Prima emissione.
      ******************************************************************************/
      d_usertext        key_error_log.error_usertext%type := 'ANUO_CONTROLLO_01 - Controllo ottica';
      d_amministrazione ottiche.amministrazione%type;
      d_ottica          ottiche.ottica%type;
   begin
      registra_info(p_text => d_usertext || ' - Inizio elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      for ana in (select progr_unita_organizzativa progr_uo
                        ,dal
                        ,ottica
                        ,amministrazione
                    from anagrafe_unita_organizzative a
                   where ottica is null
                      or not exists
                   (select 'x' from ottiche o where o.ottica = a.ottica)
                   order by 1
                           ,2)
      loop
         if p_tipo_elaborazione = 1 then
            -- solo controllo
            if ana.ottica is null then
               registra_info(p_text     => 'OTTICA non presente: ' || ana.progr_uo || ' ' ||
                                           to_char(ana.dal, 'dd/mm/yyyy')
                            ,p_usertext => d_usertext);
            else
               registra_info(p_text     => 'OTTICA non codificata: ' || ana.progr_uo || ' ' ||
                                           to_char(ana.dal
                                                  ,'dd/mm/yyyy' || ' - ' || ana.ottica)
                            ,p_usertext => d_usertext);
            end if;
         else
            -- rettifica dati:
            -- se per l'amministrazione dell'unità esiste solo un'ottica, si
            -- valorizza il campo con quel valore
            if ana.amministrazione is not null then
               begin
                  select a.ottica
                    into d_ottica
                    from ottiche a
                   where a.amministrazione = ana.amministrazione
                     and not exists (select 'x'
                            from ottiche b
                           where b.amministrazione = ana.amministrazione
                             and b.ottica != a.ottica);
               exception
                  when others then
                     d_ottica := null;
               end;
            end if;
            if d_ottica is not null then
               begin
                  update anagrafe_unita_organizzative
                     set ottica = d_ottica
                   where progr_unita_organizzativa = ana.progr_uo
                     and dal = ana.dal;
               exception
                  when others then
                     registra_errore(p_text     => substr('Update ANAGRAFE_UNITA_ORGANIZZATIVE: (' ||
                                                          ana.progr_uo || ' ' ||
                                                          to_char(ana.dal, 'dd/mm/yyyy') || ') ' ||
                                                          sqlerrm
                                                         ,1
                                                         ,2000)
                                    ,p_usertext => d_usertext);
               end;
               registra_info(p_text     => 'Aggiornata ottica anagrafica: Progr. UO ' ||
                                           ana.progr_uo || ' ' ||
                                           to_char(ana.dal, 'dd/mm/yyyy') || ', Ottica ' ||
                                           ana.ottica || ' -'||'> ' || d_ottica
                            ,p_usertext => d_usertext);
            end if;
         end if;
      end loop;
      --
      for ana in (select progr_unita_organizzativa progr_uo
                        ,dal
                        ,ottica
                        ,amministrazione
                    from anagrafe_unita_organizzative a
                   where ottica is not null
                     and not (ottica = 'EXTRAISTITUZIONALE' or revisione_istituzione = -1)
                     and not exists
                   (select 'x'
                            from ottiche o
                           where o.ottica = a.ottica
                             and o.amministrazione = a.amministrazione)
                   order by 1
                           ,2)
      loop
         if p_tipo_elaborazione = 1 then
            -- solo controllo
            registra_info(p_text     => 'Incongruenze OTTICA/AMMINISTRAZIONE: ' ||
                                        ana.progr_uo || ' ' ||
                                        to_char(ana.dal, 'dd/mm/yyyy') || ' - ' ||
                                        ana.ottica || '/' || ana.amministrazione
                         ,p_usertext => d_usertext);
         else
            -- rettifica dati:
            -- si seleziona l'amministrazione relativa all'ottica
            d_amministrazione := ottica.get_amministrazione(ana.ottica);
            begin
               update anagrafe_unita_organizzative
                  set amministrazione = d_amministrazione
                where progr_unita_organizzativa = ana.progr_uo
                  and dal = ana.dal;
            exception
               when others then
                  registra_errore(p_text     => substr('Update ANAGRAFE_UNITA_ORGANIZZATIVE: (' ||
                                                       ana.progr_uo || ' ' ||
                                                       to_char(ana.dal, 'dd/mm/yyyy') || ') ' ||
                                                       sqlerrm
                                                      ,1
                                                      ,2000)
                                 ,p_usertext => d_usertext);
            end;
            registra_info(p_text     => 'Aggiornata amministrazione anagrafica: Progr. UO ' ||
                                        ana.progr_uo || ' ' ||
                                        to_char(ana.dal, 'dd/mm/yyyy') ||
                                        ', Codice amministrazione ' ||
                                        ana.amministrazione || ' -'||'> ' ||
                                        d_amministrazione
                         ,p_usertext => d_usertext);
         end if;
      end loop;
      --
      registra_info(p_text => d_usertext || ' - Fine elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      --commit;
      --
   end;
   -------------------------------------------------------------------------------
   procedure anuo_controllo_02(p_tipo_elaborazione number) is
      /******************************************************************************
      NOME:        anuo_controllo_02.
      DESCRIZIONE: ANAGRAFE_UNITA_ORGANIZZATIVE: controlla la presenza 
                   dell'amministrazione
      RITORNA:     //
      NOTE:        Il controllo viene eseguito sull'intera tabella.
                   P_tipo_elaborazione = 1: si esegue solo il controllo;
                   P_tipo_elaborazione = 2: si esegue la rettifica dei dati.
                   N.B. La rettifica viene eseguita solo se in base all'ottica
                        è possibile determinare l'amministrazione.
       REVISIONI:
       Rev.  Data        Autore   Descrizione
       ----  ----------  ------   ----------------------------------------------------
       0     01/10/2014  VDAVALLI Prima emissione.
      ******************************************************************************/
      d_usertext        key_error_log.error_usertext%type := 'ANUO_CONTROLLO_02 - Controllo amministrazione';
      d_amministrazione ottiche.amministrazione%type;
   begin
      registra_info(p_text => d_usertext || ' - Inizio elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      for ana in (select progr_unita_organizzativa progr_uo
                        ,dal
                        ,ottica
                        ,amministrazione
                    from anagrafe_unita_organizzative anuo
                   where amministrazione is null
                      or not exists
                   (select 'x'
                            from amministrazioni amm
                           where amm.codice_amministrazione = anuo.amministrazione)
                   order by 1
                           ,2)
      loop
         if p_tipo_elaborazione = 1 then
            -- solo controllo
            if ana.amministrazione is null then
               registra_info(p_text     => 'AMMINISTRAZIONE non presente: ' ||
                                           ana.progr_uo || ' ' ||
                                           to_char(ana.dal, 'dd/mm/yyyy')
                            ,p_usertext => d_usertext);
            else
               registra_info(p_text     => 'AMMINISTRAZIONE non codificata: ' ||
                                           ana.progr_uo || ' ' ||
                                           to_char(ana.dal
                                                  ,'dd/mm/yyyy' || ' - ' ||
                                                   ana.amministrazione)
                            ,p_usertext => d_usertext);
            end if;
         else
            -- rettifica dati
            -- se è presente l'ottica si seleziona la relativa amministrazione
            if ana.ottica is not null then
               d_amministrazione := ottica.get_amministrazione(ana.ottica);
            else
               d_amministrazione := null;
            end if;
            if d_amministrazione is not null then
               begin
                  update anagrafe_unita_organizzative
                     set amministrazione = d_amministrazione
                   where progr_unita_organizzativa = ana.progr_uo
                     and dal = ana.dal;
               exception
                  when others then
                     registra_errore(p_text     => substr('Update ANAGRAFE_UNITA_ORGANIZZATIVE: (' ||
                                                          ana.progr_uo || ' ' ||
                                                          to_char(ana.dal, 'dd/mm/yyyy') || ') ' ||
                                                          sqlerrm
                                                         ,1
                                                         ,2000)
                                    ,p_usertext => d_usertext);
               end;
               registra_info(p_text     => 'Aggiornata amministrazione anagrafica: Progr. UO ' ||
                                           ana.progr_uo || ' ' ||
                                           to_char(ana.dal, 'dd/mm/yyyy') ||
                                           ', Codice amministrazione ' ||
                                           ana.amministrazione || ' -'||'> ' ||
                                           d_amministrazione
                            ,p_usertext => d_usertext);
            end if;
         end if;
      end loop;
      --
      registra_info(p_text => d_usertext || ' - Fine elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      --commit;
      --
   end;
   -------------------------------------------------------------------------------
   procedure anuo_controllo_03(p_tipo_elaborazione number) is
      /******************************************************************************
      NOME:        anuo_controllo_03.
      DESCRIZIONE: ANAGRAFE_UNITA_ORGANIZZATIVE: controlla la presenza 
                   dell'AOO nelle unità appartenenti alle ottiche istituzionali.
      RITORNA:     //
      NOTE:        Il controllo viene eseguito sull'intera tabella.
                   P_tipo_elaborazione = 1: si esegue solo il controllo;
                   P_tipo_elaborazione = 2: si esegue la rettifica dei dati.
                   N.B. La rettifica viene eseguita solo se per l'amministrazione
                        esiste una sola AOO.
       REVISIONI:
       Rev.  Data        Autore   Descrizione
       ----  ----------  ------   ----------------------------------------------------
       0     01/10/2014  VDAVALLI Prima emissione.
      ******************************************************************************/
      d_usertext  key_error_log.error_usertext%type := 'ANUO_CONTROLLO_03 - Controllo AOO';
      d_progr_aoo aoo.progr_aoo%type;
   begin
      registra_info(p_text => d_usertext || ' - Inizio elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      for ana in (select progr_unita_organizzativa progr_uo
                        ,dal
                        ,amministrazione
                    from anagrafe_unita_organizzative anuo
                   where ottica.get_ottica_istituzionale(ottica) = 'SI'
                     and progr_aoo is null
                   order by 1
                           ,2)
      loop
         if p_tipo_elaborazione = 1 then
            -- solo controllo
            registra_info(p_text     => 'AOO non presente: ' || ana.progr_uo || ' ' ||
                                        to_char(ana.dal, 'dd/mm/yyyy')
                         ,p_usertext => d_usertext);
         else
            -- rettifica dati:
            -- se esiste solo una AOO afferente all'amministrazione si valorizza
            -- il campo con tale valore
            begin
               select a.progr_aoo
                 into d_progr_aoo
                 from aoo a
                where a.codice_amministrazione = ana.amministrazione
                  and a.al is null
                  and not exists
                (select 'x'
                         from aoo x
                        where x.codice_amministrazione = ana.amministrazione
                          and x.progr_aoo != a.progr_aoo);
            exception
               when others then
                  d_progr_aoo := to_number(null);
            end;
            if d_progr_aoo is not null then
               begin
                  update anagrafe_unita_organizzative
                     set progr_aoo = d_progr_aoo
                   where progr_unita_organizzativa = ana.progr_uo
                     and dal = ana.dal;
               exception
                  when others then
                     registra_errore(p_text     => substr('Update ANAGRAFE_UNITA_ORGANIZZATIVE: (' ||
                                                          ana.progr_uo || ' ' ||
                                                          to_char(ana.dal, 'dd/mm/yyyy') || ') ' ||
                                                          sqlerrm
                                                         ,1
                                                         ,2000)
                                    ,p_usertext => d_usertext);
               end;
               registra_info(p_text     => 'Aggiornata AOO anagrafica: Progr. UO ' ||
                                           ana.progr_uo || ' ' ||
                                           to_char(ana.dal, 'dd/mm/yyyy') ||
                                           ', Progr. AOO ' || d_progr_aoo
                            ,p_usertext => d_usertext);
            end if;
         end if;
      end loop;
      --
      for ana in (select progr_unita_organizzativa progr_uo
                        ,dal
                        ,amministrazione
                        ,ottica
                        ,progr_aoo
                    from anagrafe_unita_organizzative anuo
                   where amministrazione is not null
                     and progr_aoo is not null
                     and dal <= nvl(al, to_date(3333333, 'j'))
                     and not exists
                   (select 'x'
                            from aoo
                           where aoo.codice_amministrazione = anuo.amministrazione
                             and aoo.progr_aoo = anuo.progr_aoo)
                   order by 1
                           ,2)
      loop
         if p_tipo_elaborazione = 1 then
            -- solo controllo
            registra_info(p_text     => 'Incongruenza AMMINISTRAZIONE/AOO: ' ||
                                        ana.progr_uo || ' ' ||
                                        to_char(ana.dal, 'dd/mm/yyyy') || ' - ' ||
                                        ana.amministrazione || '/' || ana.progr_aoo
                         ,p_usertext => d_usertext);
         else
            -- se l'amministrazione e' coerente con l'ottica 
            -- e l'AOO è univoca nell'amministrazione correggiamo l'AOO
            begin
               select (select progr_aoo
                         from aoo
                        where codice_amministrazione = ana.amministrazione)
                 into d_progr_aoo
                 from ottiche
                where ottica = ana.ottica
                  and amministrazione = ana.amministrazione
                  and 1 = (select count(*)
                             from aoo
                            where codice_amministrazione = ana.amministrazione);
            
               update anagrafe_unita_organizzative
                  set progr_aoo = d_progr_aoo
                where progr_unita_organizzativa = ana.progr_uo
                  and dal = ana.dal;
            exception
               when others then
                  registra_errore(p_text     => 'Errore in correzione AOO AMMINISTRAZIONE/AOO: ' ||
                                                ana.progr_uo || ' ' ||
                                                to_char(ana.dal, 'dd/mm/yyyy') || ' - ' ||
                                                ana.amministrazione || '/' || d_progr_aoo
                                 ,p_usertext => d_usertext);
            end;
         end if;
      end loop;
      --
      registra_info(p_text => d_usertext || ' - Fine elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      --commit;
      --
   end;
   -------------------------------------------------------------------------------
   procedure anuo_controllo_04(p_tipo_elaborazione number) is
      /******************************************************************************
      NOME:        anuo_controllo_04.
      DESCRIZIONE: ANAGRAFE_UNITA_ORGANIZZATIVE: controlla la presenza della
                   suddivisione.
      RITORNA:     //
      NOTE:        Il controllo viene eseguito solo sulle unità afferenti agli
                   enti gestiti direttamente in SO4 (attributo ente = 'SI' su
                   record tabella AMMINISTRAZIONI).
                   P_tipo_elaborazione = 1: si esegue solo il controllo;
                   P_tipo_elaborazione = 2: si esegue la rettifica dei dati.
                   N.B. Il tipo elaborazione 2 è utilizzabile solo se si valorizza
                        la variabile d_id_suddivisione con una costante.
       REVISIONI:
       Rev.  Data        Autore   Descrizione
       ----  ----------  ------   ----------------------------------------------------
       0     13/11/2012  VDAVALLI Prima emissione.
       1     01/10/2014  VDAVALLI Controlla solo le unità relative ad amministrazioni
                                  gestite in SO4
      ******************************************************************************/
      d_usertext        key_error_log.error_usertext%type := 'ANUO_CONTROLLO_04 - Controllo suddivisione';
      d_id_suddivisione suddivisioni_struttura.id_suddivisione%type;
   begin
      registra_info(p_text => d_usertext || ' - Inizio elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      for ana in (select progr_unita_organizzativa progr_uo
                        ,dal
                        ,id_suddivisione
                    from anagrafe_unita_organizzative a
                        ,amministrazioni              m
                   where a.amministrazione = m.codice_amministrazione
                     and a.ottica = s_ottica
                     and m.ente = 'SI'
                     and (a.id_suddivisione is null or not exists
                          (select 'x'
                             from suddivisioni_struttura s
                            where s.id_suddivisione = a.id_suddivisione))
                   order by 1)
      loop
         if p_tipo_elaborazione = 1 then
            -- solo controllo
            if ana.id_suddivisione is null then
               registra_info(p_text     => 'SUDDIVISIONE non presente: ' || ana.progr_uo || ' ' ||
                                           to_char(ana.dal, 'dd/mm/yyyy')
                            ,p_usertext => d_usertext);
            else
               registra_info(p_text     => 'SUDDIVISIONE non codificata: ' ||
                                           ana.progr_uo || ' ' ||
                                           to_char(ana.dal, 'dd/mm/yyyy') || ' - ' ||
                                           ana.id_suddivisione
                            ,p_usertext => d_usertext);
            end if;
         else
            begin
               update anagrafe_unita_organizzative
                  set id_suddivisione = d_id_suddivisione
                where progr_unita_organizzativa = ana.progr_uo
                  and dal = ana.dal;
            exception
               when others then
                  registra_errore(p_text     => substr('Update ANAGRAFE_UNITA_ORGANIZZATIVE: (' ||
                                                       ana.progr_uo || ' ' ||
                                                       to_char(ana.dal, 'dd/mm/yyyy') || ') ' ||
                                                       sqlerrm
                                                      ,1
                                                      ,2000)
                                 ,p_usertext => d_usertext);
            end;
            registra_info(p_text     => 'Aggiornata suddivisione anagrafica: Progr. UO ' ||
                                        ana.progr_uo || ' ' ||
                                        to_char(ana.dal, 'dd/mm/yyyy') || ' ' ||
                                        ana.id_suddivisione || ' -'||'> ' ||
                                        d_id_suddivisione
                         ,p_usertext => d_usertext);
         end if;
      end loop;
      --
      for ana in (select progr_unita_organizzativa progr_uo
                        ,dal
                        ,ottica
                        ,id_suddivisione
                    from anagrafe_unita_organizzative a
                   where a.ottica is not null
                     and a.ottica = s_ottica
                     and a.id_suddivisione is not null
                     and not exists (select 'x'
                            from suddivisioni_struttura s
                           where s.id_suddivisione = a.id_suddivisione
                             and s.ottica = a.ottica)
                   order by 1)
      loop
         if p_tipo_elaborazione = 1 then
            -- solo controllo
            registra_info(p_text     => 'Incongruenza OTTICA/SUDDIVISIONE: ' ||
                                        ana.progr_uo || ' ' ||
                                        to_char(ana.dal, 'dd/mm/yyyy') || ' - ' ||
                                        ana.ottica || '/' || ana.id_suddivisione
                         ,p_usertext => d_usertext);
         end if;
      end loop;
      --
      registra_info(p_text => d_usertext || ' - Fine elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      --commit;
      --
   end;
   -------------------------------------------------------------------------------
   procedure anuo_controllo_05(p_tipo_elaborazione number) is
      /******************************************************************************
      NOME:        anuo_controllo_05.
      DESCRIZIONE: ANAGRAFE_UNITA_ORGANIZZATIVE: controlla la presenza del
                   centro di costo.
      RITORNA:     //
      NOTE:        Il controllo viene eseguito solo sulle unità afferenti agli
                   enti gestiti direttamente in SO4 (attributo ente = 'SI' su
                   record tabella AMMINISTRAZIONI).
                   P_tipo_elaborazione = 1: si esegue solo il controllo;
                   P_tipo_elaborazione = 2: si esegue la rettifica dei dati.
                   N.B. Il tipo elaborazione 2 è utilizzabile solo se si valorizza
                        la variabile d_centro con una costante.
       REVISIONI:
       Rev.  Data        Autore   Descrizione
       ----  ----------  ------   ----------------------------------------------------
       0     01/10/2014  VDAVALLI Prima emissione.
      ******************************************************************************/
      d_usertext key_error_log.error_usertext%type := 'ANUO_CONTROLLO_05 - Controllo centro di costo';
      d_centro   anagrafe_unita_organizzative.centro%type;
   begin
      registra_info(p_text => d_usertext || ' - Inizio elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      for ana in (select progr_unita_organizzativa progr_uo
                        ,dal
                        ,centro
                    from anagrafe_unita_organizzative a
                        ,amministrazioni              m
                   where a.amministrazione = m.codice_amministrazione
                     and a.ottica = s_ottica
                     and m.ente = 'SI'
                     and a.centro is not null
                     and not exists
                   (select 'x' from centri c where c.centro = a.centro)
                   order by 1)
      loop
         if p_tipo_elaborazione = 1 then
            -- solo controllo
            registra_info(p_text     => 'CENTRO DI COSTO non codificato: ' ||
                                        ana.progr_uo || ' ' ||
                                        to_char(ana.dal, 'dd/mm/yyyy') || ' - ' ||
                                        ana.centro
                         ,p_usertext => d_usertext);
         else
            begin
               update anagrafe_unita_organizzative
                  set centro = d_centro
                where progr_unita_organizzativa = ana.progr_uo
                  and dal = ana.dal;
            exception
               when others then
                  registra_errore(p_text     => substr('Update ANAGRAFE_UNITA_ORGANIZZATIVE: (' ||
                                                       ana.progr_uo || ' ' ||
                                                       to_char(ana.dal, 'dd/mm/yyyy') || ') ' ||
                                                       sqlerrm
                                                      ,1
                                                      ,2000)
                                 ,p_usertext => d_usertext);
            end;
            registra_info(p_text     => 'Aggiornato centro anagrafica: Progr. UO ' ||
                                        ana.progr_uo || ' ' ||
                                        to_char(ana.dal, 'dd/mm/yyyy') || ' ' ||
                                        ana.centro || ' -'||'> ' || d_centro
                         ,p_usertext => d_usertext);
         end if;
      end loop;
      --
      registra_info(p_text => d_usertext || ' - Fine elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      --commit;
      --
   end;
   -------------------------------------------------------------------------------
   procedure anuo_controllo_06(p_tipo_elaborazione number) is
      /******************************************************************************
      NOME:        anuo_controllo_06.
      DESCRIZIONE: ANAGRAFE_UNITA_ORGANIZZATIVE: controlla la presenza 
                   dell'aggregatore.
      RITORNA:     //
      NOTE:        Il controllo viene eseguito solo sulle unità afferenti agli
                   enti gestiti direttamente in SO4 (attributo ente = 'SI' su
                   record tabella AMMINISTRAZIONI).
                   P_tipo_elaborazione = 1: si esegue solo il controllo;
                   P_tipo_elaborazione = 2: si esegue la rettifica dei dati.
                   N.B. Il tipo elaborazione 2 è utilizzabile solo se si valorizza
                        la variabile d_aggregatore con una costante.
       REVISIONI:
       Rev.  Data        Autore   Descrizione
       ----  ----------  ------   ----------------------------------------------------
       0     01/10/2014  VDAVALLI Prima emissione.
      ******************************************************************************/
      d_usertext    key_error_log.error_usertext%type := 'ANUO_CONTROLLO_06 - Controllo aggregatore';
      d_aggregatore anagrafe_unita_organizzative.aggregatore%type;
   begin
      registra_info(p_text => d_usertext || ' - Inizio elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      for ana in (select progr_unita_organizzativa progr_uo
                        ,dal
                        ,aggregatore
                    from anagrafe_unita_organizzative a
                        ,amministrazioni              m
                   where a.amministrazione = m.codice_amministrazione
                     and a.ottica = s_ottica
                     and m.ente = 'SI'
                     and a.aggregatore is not null
                     and not exists
                   (select 'x' from aggregatori c where c.aggregatore = a.aggregatore)
                   order by 1)
      loop
         if p_tipo_elaborazione = 1 then
            -- solo controllo
            registra_info(p_text     => 'AGGREGATORE non codificato: ' || ana.progr_uo || ' ' ||
                                        to_char(ana.dal, 'dd/mm/yyyy') || ' - ' ||
                                        ana.aggregatore
                         ,p_usertext => d_usertext);
         else
            begin
               update anagrafe_unita_organizzative
                  set aggregatore = d_aggregatore
                where progr_unita_organizzativa = ana.progr_uo
                  and dal = ana.dal;
            exception
               when others then
                  registra_errore(p_text     => substr('Update ANAGRAFE_UNITA_ORGANIZZATIVE: (' ||
                                                       ana.progr_uo || ' ' ||
                                                       to_char(ana.dal, 'dd/mm/yyyy') || ') ' ||
                                                       sqlerrm
                                                      ,1
                                                      ,2000)
                                 ,p_usertext => d_usertext);
            end;
            registra_info(p_text     => 'Aggiornato aggregatore anagrafica: Progr. UO ' ||
                                        ana.progr_uo || ' ' ||
                                        to_char(ana.dal, 'dd/mm/yyyy') || ' ' ||
                                        ana.aggregatore || ' -'||'> ' || d_aggregatore
                         ,p_usertext => d_usertext);
         end if;
      end loop;
      --
      registra_info(p_text => d_usertext || ' - Fine elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      --commit;
      --
   end;
   -------------------------------------------------------------------------------
   procedure anuo_controllo_07(p_tipo_elaborazione number) is
      /******************************************************************************
      NOME:        anuo_controllo_07.
      DESCRIZIONE: ANAGRAFE_UNITA_ORGANIZZATIVE: controlla la presenza 
                   dell'incarico responsabile.
      RITORNA:     //
      NOTE:        Il controllo viene eseguito solo sulle unità afferenti agli
                   enti gestiti direttamente in SO4 (attributo ente = 'SI' su
                   record tabella AMMINISTRAZIONI).
                   P_tipo_elaborazione = 1: si esegue solo il controllo;
                   P_tipo_elaborazione = 2: si esegue la rettifica dei dati.
                   N.B. Il tipo elaborazione 2 è utilizzabile solo se si valorizza
                        la variabile d_incarico_resp con una costante.
       REVISIONI:
       Rev.  Data        Autore   Descrizione
       ----  ----------  ------   ----------------------------------------------------
       0     01/10/2014  VDAVALLI Prima emissione.
      ******************************************************************************/
      d_usertext      key_error_log.error_usertext%type := 'ANUO_CONTROLLO_07 - Controllo incarico resp.';
      d_incarico_resp anagrafe_unita_organizzative.incarico_resp%type;
   begin
      registra_info(p_text => d_usertext || ' - Inizio elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      for ana in (select progr_unita_organizzativa progr_uo
                        ,dal
                        ,incarico_resp
                    from anagrafe_unita_organizzative a
                        ,amministrazioni              m
                   where a.amministrazione = m.codice_amministrazione
                     and a.ottica = s_ottica
                     and m.ente = 'SI'
                     and a.incarico_resp is not null
                     and not exists (select 'x'
                            from tipi_incarico i
                           where i.incarico = a.incarico_resp)
                   order by 1)
      loop
         if p_tipo_elaborazione = 1 then
            -- solo controllo
            registra_info(p_text     => 'INCARICO non codificato: ' || ana.progr_uo || ' ' ||
                                        to_char(ana.dal, 'dd/mm/yyyy') || ' - ' ||
                                        ana.incarico_resp
                         ,p_usertext => d_usertext);
         else
            begin
               update anagrafe_unita_organizzative
                  set incarico_resp = d_incarico_resp
                where progr_unita_organizzativa = ana.progr_uo
                  and dal = ana.dal;
            exception
               when others then
                  registra_errore(p_text     => substr('Update ANAGRAFE_UNITA_ORGANIZZATIVE: (' ||
                                                       ana.progr_uo || ' ' ||
                                                       to_char(ana.dal, 'dd/mm/yyyy') || ') ' ||
                                                       sqlerrm
                                                      ,1
                                                      ,2000)
                                 ,p_usertext => d_usertext);
            end;
            registra_info(p_text     => 'Aggiornato incarico resp. anagrafica: Progr. UO ' ||
                                        ana.progr_uo || ' ' ||
                                        to_char(ana.dal, 'dd/mm/yyyy') || ' ' ||
                                        ana.incarico_resp || ' -'||'> ' || d_incarico_resp
                         ,p_usertext => d_usertext);
         end if;
      end loop;
      --
      registra_info(p_text => d_usertext || ' - Fine elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      --commit;
      --
   end;
   -------------------------------------------------------------------------------
   procedure anuo_controllo_08(p_tipo_elaborazione number) is
      /******************************************************************************
      NOME:        anuo_controllo_08.
      DESCRIZIONE: ANAGRAFE_UNITA_ORGANIZZATIVE: controlla la presenza 
                   dell'utente ad4.
      RITORNA:     //
      NOTE:        Il controllo viene eseguito solo sulle unità appartenenti
                   a ottiche istituzionali.
                   P_tipo_elaborazione = 1: si esegue solo il controllo;
                   P_tipo_elaborazione = 2: si esegue la rettifica dei dati.
                   N.B. Per il tipo elaborazione 2: 
                        se utente_ad4 è nullo, si ricalcola e si inserisce l'utente
                        se utente
       REVISIONI:
       Rev.  Data        Autore   Descrizione
       ----  ----------  ------   ----------------------------------------------------
       0     01/10/2014  VDAVALLI Prima emissione.
      ******************************************************************************/
      d_usertext   key_error_log.error_usertext%type := 'ANUO_CONTROLLO_08 - Controllo utente AD4';
      d_utente     ad4_utenti.utente%type;
      d_nominativo ad4_utenti.nominativo%type;
   begin
      registra_info(p_text => d_usertext || ' - Inizio elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      for ana in (select progr_unita_organizzativa progr_uo
                        ,dal
                        ,des_abb
                        ,progr_aoo
                        ,utente_ad4
                        ,decode(progr_aoo
                               ,null
                               ,null
                               ,aoo_pkg.get_codice_aoo(progr_aoo, trunc(sysdate))) codice_aoo
                    from anagrafe_unita_organizzative a
                   where al is null
                     and a.ottica = s_ottica
                     and ottica.get_ottica_istituzionale(ottica) = 'SI'
                   order by 1
                           ,2)
      loop
         if ana.utente_ad4 is null then
            if p_tipo_elaborazione = 1 then
               -- solo controllo
               registra_info(p_text     => 'UTENTE AD4 non presente: ' || ana.progr_uo || ' ' ||
                                           to_char(ana.dal, 'dd/mm/yyyy')
                            ,p_usertext => d_usertext);
            else
               begin
                  anagrafe_unita_organizzativa.set_gruppo_ad4(p_progr_unita_organizzativa => ana.progr_uo
                                                             ,p_dal                       => ana.dal
                                                             ,p_progr_aoo                 => ana.progr_aoo
                                                             ,p_des_abb                   => ana.des_abb
                                                             ,p_utente_ad4                => ana.utente_ad4);
               exception
                  when others then
                     registra_errore(p_text     => substr('Update ANAGRAFE_UNITA_ORGANIZZATIVE: (' ||
                                                          ana.progr_uo || ' ' ||
                                                          to_char(ana.dal, 'dd/mm/yyyy') || ') ' ||
                                                          sqlerrm
                                                         ,1
                                                         ,2000)
                                    ,p_usertext => d_usertext);
               end;
               registra_info(p_text     => 'Aggiornato utente AD4 anagrafica: Progr. UO ' ||
                                           ana.progr_uo || ' ' ||
                                           to_char(ana.dal, 'dd/mm/yyyy')
                            ,p_usertext => d_usertext);
            end if;
         else
            begin
               select nominativo
                 into d_nominativo
                 from ad4_utenti
                where utente = ana.utente_ad4;
            exception
               when others then
                  d_nominativo := null;
            end;
            if p_tipo_elaborazione = 1 then
               if d_nominativo is null then
                  -- solo controllo
                  registra_info(p_text     => 'UTENTE AD4 non codificato: ' ||
                                              ana.progr_uo || ' ' ||
                                              to_char(ana.dal, 'dd/mm/yyyy') || ' - ' ||
                                              ana.utente_ad4
                               ,p_usertext => d_usertext);
               
               elsif d_nominativo <> ana.des_abb || '-' || ana.codice_aoo then
                  registra_info(p_text     => 'UTENTE AD4 incongruente: ' || ana.progr_uo || ' ' ||
                                              to_char(ana.dal, 'dd/mm/yyyy') || ' - ' ||
                                              ana.des_abb || '-' || ana.codice_aoo
                               ,p_usertext => d_usertext);
               end if;
            else
               begin
                  select utente
                    into d_utente
                    from ad4_utenti
                   where nominativo = ana.des_abb || '-' || ana.codice_aoo;
               exception
                  when others then
                     d_utente := null;
               end;
               if d_utente is null then
                  begin
                     anagrafe_unita_organizzativa.set_gruppo_ad4(p_progr_unita_organizzativa => ana.progr_uo
                                                                ,p_dal                       => ana.dal
                                                                ,p_progr_aoo                 => ana.progr_aoo
                                                                ,p_des_abb                   => ana.des_abb
                                                                ,p_utente_ad4                => ana.utente_ad4);
                  exception
                     when others then
                        registra_errore(p_text     => substr('Update ANAGRAFE_UNITA_ORGANIZZATIVE: (' ||
                                                             ana.progr_uo || ' ' ||
                                                             to_char(ana.dal
                                                                    ,'dd/mm/yyyy') || ') ' ||
                                                             sqlerrm
                                                            ,1
                                                            ,2000)
                                       ,p_usertext => d_usertext);
                  end;
                  registra_info(p_text     => 'Aggiornato utente AD4 anagrafica: Progr. UO ' ||
                                              ana.progr_uo || ' ' ||
                                              to_char(ana.dal, 'dd/mm/yyyy')
                               ,p_usertext => d_usertext);
               else
                  if d_utente <> ana.utente_ad4 then
                     begin
                        update anagrafe_unita_organizzative
                           set utente_ad4 = d_utente
                         where progr_unita_organizzativa = ana.progr_uo
                           and dal = ana.dal;
                     exception
                        when others then
                           registra_errore(p_text     => substr('Update ANAGRAFE_UNITA_ORGANIZZATIVE: (' ||
                                                                ana.progr_uo || ' ' ||
                                                                to_char(ana.dal
                                                                       ,'dd/mm/yyyy') || ') ' ||
                                                                sqlerrm
                                                               ,1
                                                               ,2000)
                                          ,p_usertext => d_usertext);
                     end;
                     registra_info(p_text     => 'Aggiornato utente AD4 anagrafica: Progr. UO ' ||
                                                 ana.progr_uo || ' ' ||
                                                 to_char(ana.dal, 'dd/mm/yyyy') ||
                                                 ana.utente_ad4 || ' -'||'> ' || d_utente
                                  ,p_usertext => d_usertext);
                  end if;
               end if;
            end if;
         end if;
      end loop;
      --
      registra_info(p_text => d_usertext || ' - Fine elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      --commit;
      --
   end;
   -------------------------------------------------------------------------------
   procedure anuo_controllo_09(p_tipo_elaborazione number) is
      /******************************************************************************
      NOME:        anuo_controllo_09.
      DESCRIZIONE: ANAGRAFE_UNITA_ORGANIZZATIVE: controlla la congruenza tra data 
                   inizio validita' (DAL) e revisione istituzione.
      RITORNA:     //
      NOTE:        Il controllo viene eseguito solo sulle unità appartenenti
                   a ottiche gestite a revisione.
                   P_tipo_elaborazione = 1: si esegue solo il controllo;
                   P_tipo_elaborazione = 2: si esegue la rettifica dei dati.
       REVISIONI:
       Rev.  Data        Autore   Descrizione
       ----  ----------  ------   ----------------------------------------------------
       0     13/11/2012  VDAVALLI Prima emissione.
      ******************************************************************************/
      d_usertext  key_error_log.error_usertext%type := 'ANUO_CONTROLLO_09 - Congruenza revisione istituzione e dal';
      d_dal       revisioni_struttura.dal%type;
      d_revisione revisioni_struttura.revisione%type;
   begin
      registra_info(p_text => d_usertext || ' - Inizio elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      for ana in (select progr_unita_organizzativa progr_uo
                        ,dal
                        ,a.ottica                  ottica
                        ,revisione_istituzione
                    from anagrafe_unita_organizzative a
                        ,ottiche                      o
                   where a.ottica = o.ottica
                     and a.ottica = s_ottica
                     and o.gestione_revisioni = 'SI'
                     and a.revisione_istituzione is not null
                     and not exists (select 'x'
                            from revisioni_struttura r
                           where r.ottica = a.ottica
                             and r.revisione = a.revisione_istituzione
                             and r.dal = a.dal)
                   order by 1)
      loop
         d_dal := revisione_struttura.get_dal(p_ottica    => ana.ottica
                                             ,p_revisione => ana.revisione_istituzione);
         if d_dal is null then
            registra_errore(p_text     => 'Revisione non presente: ' || ana.ottica || '/' ||
                                          ana.revisione_istituzione || ' - Progr.UO ' ||
                                          ana.progr_uo
                           ,p_usertext => d_usertext);
         else
            if p_tipo_elaborazione = 1 then
               -- solo controllo
               registra_info(p_text     => 'DAL incongruente: Progr. UO ' || ana.progr_uo || ' ' ||
                                           to_char(ana.dal, 'dd/mm/yyyy') || ', Rev. ' ||
                                           ana.revisione_istituzione || ' ' ||
                                           to_char(d_dal, 'dd/mm/yyyy')
                            ,p_usertext => d_usertext);
            else
               -- rettifica dati
               -- ricerca revisione alla data dell'unita': se esiste, si aggiorna la revisione
               -- (e non la data)
               begin
                  select min(revisione)
                    into d_revisione
                    from revisioni_struttura
                   where ottica = ana.ottica
                     and dal = ana.dal
                   group by ottica
                           ,dal;
               exception
                  when no_data_found then
                     d_revisione := to_number(null);
               end;
               if d_revisione is not null then
                  begin
                     update anagrafe_unita_organizzative
                        set revisione_istituzione = d_revisione
                      where progr_unita_organizzativa = ana.progr_uo
                        and dal = ana.dal;
                  exception
                     when others then
                        registra_errore(p_text     => substr('Update ANAGRAFE_UNITA_ORGANIZZATIVE: (' ||
                                                             ana.progr_uo || ' ' ||
                                                             to_char(ana.dal
                                                                    ,'dd/mm/yyyy') || ') ' ||
                                                             sqlerrm
                                                            ,1
                                                            ,2000)
                                       ,p_usertext => d_usertext);
                  end;
                  registra_info(p_text     => 'Aggiornata revisione istituzione anagrafica: Progr. UO' ||
                                              ana.progr_uo || ' ' ||
                                              to_char(ana.dal, 'dd/mm/yyyy') || ' ' ||
                                              ana.revisione_istituzione || ' -'||'> ' ||
                                              d_revisione
                               ,p_usertext => d_usertext);
               else
                  begin
                     update anagrafe_unita_organizzative
                        set dal = d_dal
                      where progr_unita_organizzativa = ana.progr_uo
                        and dal = ana.dal;
                  exception
                     when others then
                        registra_errore(p_text     => substr('Update ANAGRAFE_UNITA_ORGANIZZATIVE: (' ||
                                                             ana.progr_uo || ' ' ||
                                                             to_char(ana.dal
                                                                    ,'dd/mm/yyyy') || ') ' ||
                                                             sqlerrm
                                                            ,1
                                                            ,2000)
                                       ,p_usertext => d_usertext);
                  end;
                  registra_info(p_text     => 'Aggiornata decorrenza anagrafica: Progr. UO' ||
                                              ana.progr_uo || ' ' ||
                                              to_char(ana.dal, 'dd/mm/yyyy') || ' -'||'> ' ||
                                              to_char(d_dal, 'dd/mm/yyyy')
                               ,p_usertext => d_usertext);
               end if;
            end if;
         end if;
      end loop;
      --
      registra_info(p_text => d_usertext || ' - Fine elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      --commit;
      --
   end;
   -------------------------------------------------------------------------------
   procedure anuo_controllo_10(p_tipo_elaborazione number) is
      /******************************************************************************
      NOME:        anuo_controllo_10.
      DESCRIZIONE: ANAGRAFE_UNITA_ORGANIZZATIVE: controlla la congruenza tra data fine 
                   validita' (AL) e revisione cessazione.
      RITORNA:     //
      NOTE:        Il controllo viene eseguito solo sulle unità appartenenti
                   a ottiche gestite a revisione.
                   P_tipo_elaborazione = 1: si esegue solo il controllo;
                   P_tipo_elaborazione = 2: si esegue la rettifica dei dati.
       REVISIONI:
       Rev.  Data        Autore   Descrizione
       ----  ----------  ------   ----------------------------------------------------
       0     13/11/2012  VDAVALLI Prima emissione.
      ******************************************************************************/
      d_usertext  key_error_log.error_usertext%type := 'ANUO_CONTROLLO_10 - Congruenza revisione cessazione e al';
      d_dal       revisioni_struttura.dal%type;
      d_al        anagrafe_unita_organizzative.al%type;
      d_revisione revisioni_struttura.revisione%type;
   begin
      registra_info(p_text => d_usertext || ' - Inizio elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      for ana in (select progr_unita_organizzativa progr_uo
                        ,dal
                        ,al
                        ,a.ottica                  ottica
                        ,revisione_cessazione
                    from anagrafe_unita_organizzative a
                        ,ottiche                      o
                   where a.ottica = o.ottica
                     and a.ottica = s_ottica
                     and o.gestione_revisioni = 'SI'
                     and a.revisione_cessazione is not null
                     and not exists
                   (select 'x'
                            from revisioni_struttura r
                           where r.ottica = a.ottica
                             and r.revisione = a.revisione_cessazione
                             and r.dal = nvl(a.al, s_data_limite) + 1)
                   order by 1)
      loop
         d_dal := revisione_struttura.get_dal(p_ottica    => ana.ottica
                                             ,p_revisione => ana.revisione_cessazione);
         if d_dal is null then
            registra_errore(p_text     => 'Revisione non presente: ' || ana.ottica || ' ' ||
                                          ana.revisione_cessazione || ' ' || ana.progr_uo
                           ,p_usertext => d_usertext);
         else
            d_al := d_dal - 1;
            if p_tipo_elaborazione = 1 then
               -- solo controllo
               registra_info(p_text     => 'AL incongruente: ' || ana.progr_uo || ' ' ||
                                           to_char(ana.al, 'dd/mm/yyyy') || ' ' ||
                                           to_char(d_al, 'dd/mm/yyyy')
                            ,p_usertext => d_usertext);
            else
               -- rettifica dati
               -- ricerca revisione alla data dell'unita': se esiste, si aggiorna la revisione
               -- (e non la data)
               begin
                  select min(revisione)
                    into d_revisione
                    from revisioni_struttura
                   where ottica = ana.ottica
                     and dal = ana.al + 1
                   group by ottica
                           ,dal;
               exception
                  when no_data_found then
                     d_revisione := to_number(null);
               end;
               if d_revisione is not null then
                  begin
                     update anagrafe_unita_organizzative
                        set revisione_cessazione = d_revisione
                      where progr_unita_organizzativa = ana.progr_uo
                        and dal = ana.dal;
                  exception
                     when others then
                        registra_errore(p_text     => substr('Update ANAGRAFE_UNITA_ORGANIZZATIVE: (' ||
                                                             ana.progr_uo || ' ' ||
                                                             to_char(ana.dal
                                                                    ,'dd/mm/yyyy') || ') ' ||
                                                             sqlerrm
                                                            ,1
                                                            ,2000)
                                       ,p_usertext => d_usertext);
                  end;
                  registra_info(p_text     => 'Aggiornata revisione cessazione anagrafica: Progr. UO ' ||
                                              ana.progr_uo || ' ' ||
                                              ana.revisione_cessazione || ' -'||'> ' ||
                                              d_revisione
                               ,p_usertext => d_usertext);
               else
                  begin
                     update anagrafe_unita_organizzative
                        set al = d_al
                      where progr_unita_organizzativa = ana.progr_uo
                        and dal = ana.dal;
                  exception
                     when others then
                        registra_errore(p_text     => substr('Update ANAGRAFE_UNITA_ORGANIZZATIVE: (' ||
                                                             ana.progr_uo || ' ' ||
                                                             to_char(ana.dal
                                                                    ,'dd/mm/yyyy') || ') ' ||
                                                             sqlerrm
                                                            ,1
                                                            ,2000)
                                       ,p_usertext => d_usertext);
                  end;
                  registra_info(p_text     => 'Aggiornato fine validita anagrafica: ' ||
                                              ana.progr_uo || ' ' ||
                                              to_char(ana.al, 'dd/mm/yyyy') || ' -'||'> ' ||
                                              to_char(d_al, 'dd/mm/yyyy')
                               ,p_usertext => d_usertext);
               end if;
            end if;
         end if;
      end loop;
      --
      registra_info(p_text => d_usertext || ' - Fine elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      --commit;
      --
   end;
   -------------------------------------------------------------------------------
   procedure anuo_controllo_11 is
      /******************************************************************************
      NOME:        anuo_controllo_11.
      DESCRIZIONE: ANAGRAFE_UNITA_ORGANIZZATIVE: controlla l'esistenza di periodi 
                   sovrapposti
      RITORNA:     //
      NOTE:        Il controllo viene eseguito sull'intera tabella.
      REVISIONI:
      Rev.  Data        Autore   Descrizione
      ----  ----------  ------   ----------------------------------------------------
      0     01/10/2014  VDAVALLI Prima emissione.
      ******************************************************************************/
      d_usertext key_error_log.error_usertext%type := 'ANUO_CONTROLLO_11 - Periodi sovrapposti';
   begin
      registra_info(p_text => d_usertext || ' - Inizio elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      for ana in (select progr_unita_organizzativa progr_uo
                        ,dal
                    from anagrafe_unita_organizzative a
                   where a.dal < nvl(a.al, s_data_limite)
                     and a.ottica = s_ottica
                     and (exists
                          (select 'x'
                             from anagrafe_unita_organizzative b
                            where b.progr_unita_organizzativa = a.progr_unita_organizzativa
                              and b.dal between a.dal and nvl(a.al, s_data_limite)
                              and dal <= nvl(al, to_date(3333333, 'j'))
                              and b.rowid != a.rowid) or exists
                          (select 'x'
                             from anagrafe_unita_organizzative b
                            where b.progr_unita_organizzativa = a.progr_unita_organizzativa
                              and nvl(b.al, s_data_limite) between a.dal and
                                  nvl(a.al, s_data_limite)
                              and dal <= nvl(al, to_date(3333333, 'j'))
                              and b.rowid != a.rowid))
                   order by 1)
      loop
         -- solo controllo
         registra_info(p_text     => 'Periodi sovrapposti: ' || ana.progr_uo || ' ' ||
                                     to_char(ana.dal, 'dd/mm/yyyy')
                      ,p_usertext => d_usertext);
      end loop;
      --
      registra_info(p_text => d_usertext || ' - Fine elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      --commit;
      --
   end;
   -------------------------------------------------------------------------------
   procedure anuo_controllo_12(p_tipo_elaborazione number) is
      /******************************************************************************
      NOME:        anuo_controllo_12.
      DESCRIZIONE: ANAGRAFE_UNITA_ORGANIZZATIVE: controlla la congruenza tra dal e
                   dal_pubb.
      RITORNA:     //
      NOTE:        Il controllo viene eseguito solo sulle unità afferenti agli
                   enti gestiti direttamente in SO4 (attributo ente = 'SI' su
                   record tabella AMMINISTRAZIONI).
                   P_tipo_elaborazione = 1: si esegue solo il controllo;
                   P_tipo_elaborazione = 2: si esegue la rettifica dei dati.
       REVISIONI:
       Rev.  Data        Autore   Descrizione
       ----  ----------  ------   ----------------------------------------------------
       0     02/10/2014  VDAVALLI Prima emissione.
      ******************************************************************************/
      d_usertext key_error_log.error_usertext%type := 'ANUO_CONTROLLO_12 - Congruenza dal e dal_pubb';
      d_dal_pubb anagrafe_unita_organizzative.dal_pubb%type;
   
   begin
      registra_info(p_text => d_usertext || ' - Inizio elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      if p_tipo_elaborazione = 2 then
         --
         -- Disabilitazione triggers ANAGRAFE_UNITA_ORGANIZZATIVE
         --
         begin
            execute immediate 'alter table ANAGRAFE_UNITA_ORGANIZZATIVE disable all triggers';
         exception
            when others then
               raise_application_error(-20999
                                      ,'Disabilitazione triggers ANAGRAFE_UNITA_ORGANIZZATIVE - ' ||
                                       sqlerrm);
         end;
      end if;
      --
      -- Controllo unità organizzative con dal non nullo e dal_pubb nullo
      -- (il controllo viene eseguito in assenza di revisioni in modifica)
      --
      for ana in (select progr_unita_organizzativa progr_uo
                        ,dal
                        ,revisione_istituzione
                        ,a.ottica
                    from anagrafe_unita_organizzative a
                        ,amministrazioni              m
                   where a.amministrazione = m.codice_amministrazione
                     and a.ottica = s_ottica
                     and m.ente = 'SI'
                     and a.dal is not null
                     and a.dal_pubb is null
                   order by 1)
      loop
         if p_tipo_elaborazione = 1 then
            -- solo controllo
            registra_info(p_text     => 'DAL_PUBB nullo: ' || ana.progr_uo || ' ' ||
                                        to_char(ana.dal, 'dd/mm/yyyy')
                         ,p_usertext => d_usertext);
         else
            -- rettifica dati
            -- ricerca revisione istituzione dell'unita': se esiste, si aggiorna 
            -- il dal_pubb con la data pubblicazione della revisione,
            -- altrimenti si usa il dal
            if ana.revisione_istituzione is not null then
               begin
                  select data_pubblicazione
                    into d_dal_pubb
                    from revisioni_struttura
                   where ottica = ana.ottica
                     and revisione = ana.revisione_istituzione;
               exception
                  when no_data_found then
                     d_dal_pubb := to_date(null);
               end;
            else
               d_dal_pubb := to_date(null);
            end if;
            begin
               update anagrafe_unita_organizzative
                  set dal_pubb = nvl(d_dal_pubb, dal)
                where progr_unita_organizzativa = ana.progr_uo
                  and dal = ana.dal;
            exception
               when others then
                  registra_errore(p_text     => substr('Update ANAGRAFE_UNITA_ORGANIZZATIVE: (' ||
                                                       ana.progr_uo || ' ' ||
                                                       to_char(ana.dal, 'dd/mm/yyyy') || ') ' ||
                                                       sqlerrm
                                                      ,1
                                                      ,2000)
                                 ,p_usertext => d_usertext);
            end;
            registra_info(p_text     => 'Aggiornato dal pubblicazione anagrafica: Progr. UO ' ||
                                        ana.progr_uo || ' ' ||
                                        to_char(ana.dal, 'dd/mm/yyyy')
                         ,p_usertext => d_usertext);
         end if;
      end loop;
      --
      -- Non si esegue il controllo sulle unità con dal nullo e dal_pubb non nullo
      -- perchè il dal fa parte della primary key e quindi non può essere nullo
      --
      if p_tipo_elaborazione = 2 then
         --
         -- Abilitazione triggers ANAGRAFE_UNITA_ORGANIZZATIVE
         --
         begin
            execute immediate 'alter table ANAGRAFE_UNITA_ORGANIZZATIVE enable all triggers';
         exception
            when others then
               raise_application_error(-20999
                                      ,'Abilitazione triggers ANAGRAFE_UNITA_ORGANIZZATIVE - ' ||
                                       sqlerrm);
         end;
      end if;
      --
      registra_info(p_text => d_usertext || ' - Fine elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      --commit;
      --
   end;
   -------------------------------------------------------------------------------
   procedure anuo_controllo_13(p_tipo_elaborazione number) is
      /******************************************************************************
      NOME:        anuo_controllo_13.
      DESCRIZIONE: ANAGRAFE_UNITA_ORGANIZZATIVE: controlla la congruenza tra al e
                   al_pubb.
      RITORNA:     //
      NOTE:        Il controllo viene eseguito solo sulle unità afferenti agli
                   enti gestiti direttamente in SO4 (attributo ente = 'SI' su
                   record tabella AMMINISTRAZIONI).
                   P_tipo_elaborazione = 1: si esegue solo il controllo;
                   P_tipo_elaborazione = 2: si esegue la rettifica dei dati.
       REVISIONI:
       Rev.  Data        Autore   Descrizione
       ----  ----------  ------   ----------------------------------------------------
       0     03/10/2014  VDAVALLI Prima emissione.
      ******************************************************************************/
      d_usertext key_error_log.error_usertext%type := 'ANUO_CONTROLLO_13 - Congruenza al e al_pubb';
      d_dal_pubb anagrafe_unita_organizzative.al_pubb%type;
   begin
      registra_info(p_text => d_usertext || ' - Inizio elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      if p_tipo_elaborazione = 2 then
         --
         -- Disabilitazione triggers ANAGRAFE_UNITA_ORGANIZZATIVE
         --
         begin
            execute immediate 'alter table ANAGRAFE_UNITA_ORGANIZZATIVE disable all triggers';
         exception
            when others then
               raise_application_error(-20999
                                      ,'Disabilitazione triggers ANAGRAFE_UNITA_ORGANIZZATIVE - ' ||
                                       sqlerrm);
         end;
      end if;
      --
      -- Controllo unità organizzative con al non nullo e al_pubb nullo
      -- (il controllo viene eseguito in assenza di revisioni in modifica)
      --
      for ana in (select progr_unita_organizzativa progr_uo
                        ,dal
                        ,al
                        ,ottica
                        ,revisione_cessazione
                    from anagrafe_unita_organizzative a
                        ,amministrazioni              m
                   where a.amministrazione = m.codice_amministrazione
                     and a.ottica = s_ottica
                     and m.ente = 'SI'
                     and a.al is not null
                     and a.al_pubb is null
                   order by 1)
      loop
         if p_tipo_elaborazione = 1 then
            -- solo controllo
            registra_info(p_text     => 'AL_PUBB nullo: ' || ana.progr_uo || ' ' ||
                                        to_char(ana.al, 'dd/mm/yyyy')
                         ,p_usertext => d_usertext);
         else
            -- rettifica dati
            -- ricerca revisione istituzione dell'unita': se esiste, si aggiorna 
            -- il dal_pubb con la data pubblicazione della revisione,
            -- altrimenti si usa il dal
            if ana.revisione_cessazione is not null then
               begin
                  select data_pubblicazione
                    into d_dal_pubb
                    from revisioni_struttura
                   where ottica = ana.ottica
                     and revisione = ana.revisione_cessazione;
               exception
                  when no_data_found then
                     d_dal_pubb := to_date(null);
               end;
            else
               d_dal_pubb := to_date(null);
            end if;
            begin
               update anagrafe_unita_organizzative
                  set dal_pubb = decode(d_dal_pubb, to_date(null), al, d_dal_pubb - 1)
                where progr_unita_organizzativa = ana.progr_uo
                  and dal = ana.dal;
            exception
               when others then
                  registra_errore(p_text     => substr('Update ANAGRAFE_UNITA_ORGANIZZATIVE: (' ||
                                                       ana.progr_uo || ' ' ||
                                                       to_char(ana.dal, 'dd/mm/yyyy') || ') ' ||
                                                       sqlerrm
                                                      ,1
                                                      ,2000)
                                 ,p_usertext => d_usertext);
            end;
            registra_info(p_text     => 'Aggiornato al pubblicazione anagrafica: Progr. UO ' ||
                                        ana.progr_uo || ' ' ||
                                        to_char(ana.dal, 'dd/mm/yyyy')
                         ,p_usertext => d_usertext);
         end if;
      end loop;
      --
      -- Controllo unità organizzative con al nullo e al_pubb non nullo
      --
      for ana in (select progr_unita_organizzativa progr_uo
                        ,dal
                        ,ottica
                    from anagrafe_unita_organizzative a
                        ,amministrazioni              m
                   where a.amministrazione = m.codice_amministrazione
                     and a.ottica = s_ottica
                     and m.ente = 'SI'
                     and a.al is null
                     and a.al_pubb is not null
                   order by 1)
      loop
         if p_tipo_elaborazione = 1 then
            -- solo controllo
            registra_info(p_text     => 'AL nullo e AL_PUBB non nullo: ' || ana.progr_uo || ' ' ||
                                        to_char(ana.dal, 'dd/mm/yyyy')
                         ,p_usertext => d_usertext);
         else
            -- rettifica dati
            -- si annulla l'al_pubb
            begin
               update anagrafe_unita_organizzative
                  set al_pubb = to_date(null)
                where progr_unita_organizzativa = ana.progr_uo
                  and dal = ana.dal;
            exception
               when others then
                  registra_errore(p_text     => substr('Update ANAGRAFE_UNITA_ORGANIZZATIVE: (' ||
                                                       ana.progr_uo || ' ' ||
                                                       to_char(ana.dal, 'dd/mm/yyyy') || ') ' ||
                                                       sqlerrm
                                                      ,1
                                                      ,2000)
                                 ,p_usertext => d_usertext);
            end;
            registra_info(p_text     => 'Annullato al pubblicazione anagrafica: Progr. UO ' ||
                                        ana.progr_uo || ' ' ||
                                        to_char(ana.dal, 'dd/mm/yyyy')
                         ,p_usertext => d_usertext);
         end if;
      end loop;
      --
      if p_tipo_elaborazione = 2 then
         --
         -- Abilitazione triggers ANAGRAFE_UNITA_ORGANIZZATIVE
         --
         begin
            execute immediate 'alter table ANAGRAFE_UNITA_ORGANIZZATIVE enable all triggers';
         exception
            when others then
               raise_application_error(-20999
                                      ,'Disabilitazione triggers ANAGRAFE_UNITA_ORGANIZZATIVE - ' ||
                                       sqlerrm);
         end;
      end if;
      --
      registra_info(p_text => d_usertext || ' - Fine elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      --commit;
      --
   end;
   -------------------------------------------------------------------------------
   procedure anuo_controllo_14 is
      /******************************************************************************
      NOME:        anuo_controllo_14.
      DESCRIZIONE: ANAGRAFE_UNITA_ORGANIZZATIVE: controlla l'esistenza di periodi 
                   sovrapposti per date di pubblicazione
      RITORNA:     //
      NOTE:        Il controllo viene eseguito sull'intera tabella.
      REVISIONI:
      Rev.  Data        Autore   Descrizione
      ----  ----------  ------   ----------------------------------------------------
      0     06/10/2014  VDAVALLI Prima emissione.
      ******************************************************************************/
      d_usertext key_error_log.error_usertext%type := 'ANUO_CONTROLLO_14 - Periodi sovrapposti per date pubblicazione';
   begin
      registra_info(p_text => d_usertext || ' - Inizio elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      for ana in (select progr_unita_organizzativa progr_uo
                        ,dal_pubb
                    from anagrafe_unita_organizzative a
                   where a.dal_pubb is not null
                     and a.dal_pubb < nvl(a.al_pubb, s_data_limite)
                     and a.ottica = s_ottica
                     and (exists
                          (select 'x'
                             from anagrafe_unita_organizzative b
                            where b.progr_unita_organizzativa = a.progr_unita_organizzativa
                              and b.dal_pubb is not null
                              and b.dal_pubb between a.dal_pubb and
                                  nvl(a.al_pubb, s_data_limite)
                              and b.rowid != a.rowid) or exists
                          (select 'x'
                             from anagrafe_unita_organizzative c
                            where c.progr_unita_organizzativa = a.progr_unita_organizzativa
                              and c.dal_pubb is not null
                              and nvl(c.al_pubb, s_data_limite) between a.dal_pubb and
                                  nvl(a.al_pubb, s_data_limite)
                              and c.rowid != a.rowid))
                   order by 1)
      loop
         -- solo controllo
         registra_info(p_text     => 'Periodi sovrapposti: ' || ana.progr_uo || ' ' ||
                                     to_char(ana.dal_pubb, 'dd/mm/yyyy')
                      ,p_usertext => d_usertext);
      end loop;
      --
      registra_info(p_text => d_usertext || ' - Fine elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      --commit;
      --
   end;
   -------------------------------------------------------------------------------
   procedure unor_controllo_1(p_tipo_elaborazione number) is
      /******************************************************************************
      NOME:        unor_controllo_1.
      DESCRIZIONE: UNITA_ORGANIZZATIVE: controlla l'esistenza delle unita' organizzative
                   in ANAGRAFE_UNITA_ORGANIZZATIVE.
      RITORNA:     //
      NOTE:        Il controllo viene eseguito sull'intera tabella.
                   P_tipo_elaborazione = 1: si esegue solo il controllo;
                   P_tipo_elaborazione = 2: si esegue la rettifica dei dati.
      ******************************************************************************/
      d_usertext key_error_log.error_usertext%type := 'UNOR_CONTROLLO_1 - Esistenza unita in anagrafe';
   begin
      registra_info(p_text => d_usertext || ' - Inizio elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      -- Trattamento unita' figlie
      for unor in (select id_elemento
                         ,progr_unita_organizzativa progr_uo
                     from unita_organizzative u
                    where not exists
                    (select 'x'
                             from anagrafe_unita_organizzative a
                            where a.progr_unita_organizzativa = u.progr_unita_organizzativa)
                      and u.ottica = s_ottica
                    order by 1)
      loop
         if p_tipo_elaborazione = 1 then
            -- solo controllo
            registra_info(p_text     => 'Progr. U.O. assente: ' || unor.progr_uo
                         ,p_usertext => d_usertext);
         else
            -- rettifica dati
            -- si elimina logicamente il record
            begin
               update unita_organizzative
                  set al = dal - 1
                where id_elemento = unor.id_elemento;
            exception
               when others then
                  registra_errore(p_text     => substr('Delete UNITA_ORGANIZZATIVE: (' ||
                                                       unor.id_elemento || ') ' ||
                                                       sqlerrm
                                                      ,1
                                                      ,2000)
                                 ,p_usertext => d_usertext);
            end;
            registra_info(p_text     => 'Eliminato legame: ' || unor.id_elemento
                         ,p_usertext => d_usertext);
         end if;
      end loop;
      --
      --commit;
      -- Trattamento unita' padri
      for unor in (select id_elemento
                         ,id_unita_padre progr_uo
                     from unita_organizzative u
                    where id_unita_padre is not null
                      and u.ottica = s_ottica
                      and not exists
                    (select 'x'
                             from anagrafe_unita_organizzative a
                            where a.progr_unita_organizzativa = u.id_unita_padre)
                    order by 1)
      loop
         if p_tipo_elaborazione = 1 then
            -- solo controllo
            registra_errore(p_text     => 'Progr. U.O. padre assente con U.O. figlie: ' ||
                                          unor.progr_uo || ' - Legame non eliminato'
                           ,p_usertext => d_usertext);
         else
            -- rettifica dati (annulla unità padre)
            begin
               update unita_organizzative
                  set id_unita_padre = to_number(null)
                where id_elemento = unor.id_elemento;
            exception
               when others then
                  registra_errore(p_text     => substr('Update UNITA_ORGANIZZATIVE: (' ||
                                                       unor.id_elemento || ') ' ||
                                                       sqlerrm
                                                      ,1
                                                      ,2000)
                                 ,p_usertext => d_usertext);
            end;
            registra_info(p_text     => 'Annullata unita'' padre: ' || unor.id_elemento
                         ,p_usertext => d_usertext);
         end if;
      end loop;
      --
      registra_info(p_text => d_usertext || ' - Fine elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      --commit;
      --
   end;
   -------------------------------------------------------------------------------
   procedure unor_controllo_2(p_tipo_elaborazione number) is
      /******************************************************************************
      NOME:        unor_controllo_2.
      DESCRIZIONE: UNITA_ORGANIZZATIVE: controlla la congruenza tra data inizio 
                   validita' (DAL) e revisione istituzione.
      RITORNA:     //
      NOTE:        Il controllo viene eseguito sull'intera tabella.
                   P_tipo_elaborazione = 1: si esegue solo il controllo;
                   P_tipo_elaborazione = 2: si esegue la rettifica dei dati.
      ******************************************************************************/
      d_usertext  key_error_log.error_usertext%type := 'UNOR_CONTROLLO_2 - Congruenza revisione istituzione e dal';
      d_dal       revisioni_struttura.dal%type;
      d_revisione revisioni_struttura.revisione%type;
   begin
      registra_info(p_text => d_usertext || ' - Inizio elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      for unor in (select id_elemento
                         ,progr_unita_organizzativa progr_uo
                         ,dal
                         ,u.ottica                  ottica
                         ,revisione
                     from unita_organizzative u
                         ,ottiche             o
                    where u.ottica = o.ottica
                      and u.ottica = s_ottica
                      and o.gestione_revisioni = 'SI'
                      and u.revisione is not null
                      and not exists (select 'x'
                             from revisioni_struttura r
                            where r.ottica = u.ottica
                              and r.revisione = u.revisione
                              and r.dal = u.dal)
                    order by 2)
      loop
         d_dal := revisione_struttura.get_dal(p_ottica    => unor.ottica
                                             ,p_revisione => unor.revisione);
         if d_dal is null then
            registra_errore(p_text     => 'Revisione non presente: ' || unor.ottica || '/' ||
                                          unor.revisione || ' - ' || unor.id_elemento
                           ,p_usertext => d_usertext);
         else
            if p_tipo_elaborazione = 1 then
               -- solo controllo
               registra_info(p_text     => 'DAL incongruente: Progr. UO ' || unor.ottica || '/' ||
                                           unor.progr_uo || ' ' ||
                                           to_char(unor.dal, 'dd/mm/yyyy') || ' ' ||
                                           to_char(d_dal, 'dd/mm/yyyy')
                            ,p_usertext => d_usertext);
            else
               -- rettifica dati
               -- ricerca revisione alla data dell'unita': se esiste, si aggiorna la revisione
               -- (e non la data)
               begin
                  select min(revisione)
                    into d_revisione
                    from revisioni_struttura
                   where ottica = unor.ottica
                     and dal = unor.dal
                   group by ottica
                           ,dal;
               exception
                  when no_data_found then
                     d_revisione := to_number(null);
               end;
               if d_revisione is not null then
                  begin
                     update unita_organizzative
                        set revisione = d_revisione
                      where id_elemento = unor.id_elemento;
                  exception
                     when others then
                        registra_errore(p_text     => substr('Update UNITA_ORGANIZZATIVE: (' ||
                                                             unor.id_elemento || ') ' ||
                                                             sqlerrm
                                                            ,1
                                                            ,2000)
                                       ,p_usertext => d_usertext);
                  end;
                  registra_info(p_text     => 'Aggiornata revisione istituzione legame: Progr. UO ' ||
                                              unor.ottica || '/' || unor.progr_uo || ' ' ||
                                              unor.revisione || ' -'||'> ' || d_revisione
                               ,p_usertext => d_usertext);
               else
                  begin
                     update unita_organizzative
                        set dal = d_dal
                      where id_elemento = unor.id_elemento;
                  exception
                     when others then
                        registra_errore(p_text     => substr('Update UNITA_ORGANIZZATIVE: (' ||
                                                             unor.id_elemento || ') ' ||
                                                             sqlerrm
                                                            ,1
                                                            ,2000)
                                       ,p_usertext => d_usertext);
                  end;
                  registra_info(p_text     => 'Aggiornata decorrenza legame: Progr. UO ' ||
                                              unor.ottica || '/' || unor.progr_uo || ' ' ||
                                              to_char(unor.dal, 'dd/mm/yyyy') || ' -'||'> ' ||
                                              to_char(d_dal, 'dd/mm/yyyy')
                               ,p_usertext => d_usertext);
               end if;
            end if;
         end if;
      end loop;
      --
      registra_info(p_text => d_usertext || ' - Fine elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      --commit;
      --
   end;
   -------------------------------------------------------------------------------
   procedure unor_controllo_3(p_tipo_elaborazione number) is
      /******************************************************************************
      NOME:        unor_controllo_2.
      DESCRIZIONE: UNITA_ORGANIZZATIVE: controlla la congruenza tra data fine 
                   validita' (AL) e revisione cessazione.
      RITORNA:     //
      NOTE:        Il controllo viene eseguito sull'intera tabella.
                   P_tipo_elaborazione = 1: si esegue solo il controllo;
                   P_tipo_elaborazione = 2: si esegue la rettifica dei dati.
      ******************************************************************************/
      d_usertext  key_error_log.error_usertext%type := 'UNOR_CONTROLLO_3 - Congruenza revisione cessazione e al';
      d_dal       revisioni_struttura.dal%type;
      d_al        unita_organizzative.al%type;
      d_revisione revisioni_struttura.revisione%type;
   begin
      registra_info(p_text => d_usertext || ' - Inizio elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      for unor in (select id_elemento
                         ,progr_unita_organizzativa progr_uo
                         ,al
                         ,u.ottica
                         ,revisione_cessazione
                     from unita_organizzative u
                         ,ottiche             o
                    where u.ottica = o.ottica
                      and u.ottica = s_ottica
                      and o.gestione_revisioni = 'SI'
                      and u.revisione_cessazione is not null
                      and not exists
                    (select 'x'
                             from revisioni_struttura r
                            where r.ottica = u.ottica
                              and r.revisione = u.revisione_cessazione
                              and r.dal = nvl(u.al, s_data_limite) + 1)
                    order by 1)
      loop
         d_dal := revisione_struttura.get_dal(p_ottica    => unor.ottica
                                             ,p_revisione => unor.revisione_cessazione);
         if d_dal is null then
            registra_errore(p_text     => 'Revisione non presente: ' || unor.ottica || ' ' ||
                                          unor.revisione_cessazione || ' - ' ||
                                          unor.id_elemento
                           ,p_usertext => d_usertext);
         else
            d_al := d_dal - 1;
            if p_tipo_elaborazione = 1 then
               -- solo controllo
               registra_info(p_text     => 'AL incongruente: Progr. UO ' || unor.ottica || '/' ||
                                           unor.progr_uo || ' ' ||
                                           to_char(unor.al, 'dd/mm/yyyy') || ' ' ||
                                           to_char(d_al, 'dd/mm/yyyy')
                            ,p_usertext => d_usertext);
            else
               -- rettifica dati
               -- ricerca revisione alla data AL - 1 dell'unita': se esiste, si aggiorna la revisione
               -- (e non la data)
               begin
                  select min(revisione)
                    into d_revisione
                    from revisioni_struttura
                   where ottica = unor.ottica
                     and dal = nvl(unor.al, s_data_limite) + 1
                   group by ottica
                           ,dal;
               exception
                  when no_data_found then
                     d_revisione := to_number(null);
               end;
               if d_revisione is not null then
                  begin
                     update unita_organizzative
                        set revisione_cessazione = d_revisione
                      where id_elemento = unor.id_elemento;
                  exception
                     when others then
                        registra_errore(p_text     => substr('Update UNITA_ORGANIZZATIVE: (' ||
                                                             unor.id_elemento || ') ' ||
                                                             sqlerrm
                                                            ,1
                                                            ,2000)
                                       ,p_usertext => d_usertext);
                  end;
                  registra_info(p_text     => 'Aggiornata revisione cessazione legame: Progr. UO ' ||
                                              unor.ottica || '/' || unor.progr_uo || ' ' ||
                                              unor.revisione_cessazione || ' -'||'> ' ||
                                              d_revisione
                               ,p_usertext => d_usertext);
               else
                  begin
                     update unita_organizzative
                        set al = d_al
                      where id_elemento = unor.id_elemento;
                     registra_info(p_text     => 'Aggiornato fine validita legame: ' ||
                                                 unor.progr_uo || ' ' ||
                                                 to_char(unor.al, 'dd/mm/yyyy') || ' -'||'> ' ||
                                                 to_char(d_al, 'dd/mm/yyyy')
                                  ,p_usertext => d_usertext);
                  exception
                     when others then
                        registra_errore(p_text     => substr('Update UNITA_ORGANIZZATIVE: (' ||
                                                             unor.id_elemento || ') ' ||
                                                             sqlerrm
                                                            ,1
                                                            ,2000)
                                       ,p_usertext => d_usertext);
                  end;
               end if;
            end if;
         end if;
      end loop;
      --
      registra_info(p_text => d_usertext || ' - Fine elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      --commit;
   end;
   -------------------------------------------------------------------------------
   procedure unor_controllo_4 is
      /******************************************************************************
      NOME:        unor_controllo_4.
      DESCRIZIONE: UNITA_ORGANIZZATIVE: controlla se ci sono periodi sovrapposti
      RITORNA:     //
      NOTE:        Il controllo viene eseguito sull'intera tabella.
      ******************************************************************************/
      d_usertext key_error_log.error_usertext%type := 'UNOR_CONTROLLO_4 - Periodi sovrapposti';
   begin
      registra_info(p_text => d_usertext || ' - Inizio elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      for unor in (select ottica
                         ,progr_unita_organizzativa progr_uo
                         ,dal
                     from unita_organizzative u
                    where u.dal < nvl(u.al, s_data_limite)
                      and u.ottica = s_ottica
                      and (exists
                           (select 'x'
                              from unita_organizzative b
                             where b.ottica = u.ottica
                               and b.progr_unita_organizzativa = u.progr_unita_organizzativa
                               and b.dal between u.dal and nvl(u.al, s_data_limite)
                               and dal <= nvl(al, to_date(3333333, 'j'))
                               and b.ottica = s_ottica
                               and b.rowid != u.rowid) or exists
                           (select 'x'
                              from unita_organizzative b
                             where b.ottica = u.ottica
                               and b.progr_unita_organizzativa = u.progr_unita_organizzativa
                               and nvl(b.al, s_data_limite) between u.dal and
                                   nvl(u.al, s_data_limite)
                               and dal <= nvl(al, to_date(3333333, 'j'))
                               and b.ottica = s_ottica
                               and b.rowid != u.rowid))
                    order by 1)
      loop
         -- solo controllo
         registra_info(p_text     => 'Periodi sovrapposti: ' || unor.ottica || '/' ||
                                     unor.progr_uo || ' ' ||
                                     to_char(unor.dal, 'dd/mm/yyyy')
                      ,p_usertext => d_usertext);
      end loop;
      --
      registra_info(p_text => d_usertext || ' - Fine elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      --commit;
      --
   end;
   -------------------------------------------------------------------------------
   procedure unor_controllo_5(p_tipo_elaborazione number) is
      /******************************************************************************
      NOME:        unor_controllo_5.
      DESCRIZIONE: UNITA_ORGANIZZATIVE: controlla la congruenza tra dal e
                   dal_pubb.
      RITORNA:     //
      NOTE:        Il controllo viene eseguito solo sulle unità afferenti agli
                   enti gestiti direttamente in SO4 (attributo ente = 'SI' su
                   record tabella AMMINISTRAZIONI).
                   P_tipo_elaborazione = 1: si esegue solo il controllo;
                   P_tipo_elaborazione = 2: si esegue la rettifica dei dati.
       REVISIONI:
       Rev.  Data        Autore   Descrizione
       ----  ----------  ------   ----------------------------------------------------
       0     02/10/2014  VDAVALLI Prima emissione.
      ******************************************************************************/
      d_usertext key_error_log.error_usertext%type := 'UNOR_CONTROLLO_5 - Congruenza dal e dal_pubb';
      d_dal_pubb anagrafe_unita_organizzative.dal_pubb%type;
   
   begin
      registra_info(p_text => d_usertext || ' - Inizio elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      if p_tipo_elaborazione = 2 then
         --
         -- Disabilitazione triggers UNITA_ORGANIZZATIVE
         --
         begin
            execute immediate 'alter table UNITA_ORGANIZZATIVE disable all triggers';
         exception
            when others then
               raise_application_error(-20999
                                      ,'Disabilitazione triggers UNITA_ORGANIZZATIVE - ' ||
                                       sqlerrm);
         end;
      end if;
      --
      -- Controllo unità organizzative con dal non nullo e dal_pubb nullo
      -- (il controllo viene eseguito in assenza di revisioni in modifica)
      --
      for unor in (select id_elemento
                         ,progr_unita_organizzativa progr_uo
                         ,dal
                         ,revisione
                         ,u.ottica
                     from unita_organizzative u
                         ,ottiche             o
                         ,amministrazioni     m
                    where u.ottica = o.ottica
                      and u.ottica = s_ottica
                      and o.amministrazione = m.codice_amministrazione
                      and m.ente = 'SI'
                      and u.dal is not null
                      and u.dal_pubb is null
                    order by 1)
      loop
         if p_tipo_elaborazione = 1 then
            -- solo controllo
            registra_info(p_text     => 'DAL_PUBB nullo: ' || unor.ottica || ' ' ||
                                        unor.progr_uo || ' ' ||
                                        to_char(unor.dal, 'dd/mm/yyyy')
                         ,p_usertext => d_usertext);
         else
            -- rettifica dati
            -- ricerca revisione istituzione dell'unita': se esiste, si aggiorna 
            -- il dal_pubb con la data pubblicazione della revisione,
            -- altrimenti si usa il dal
            if unor.revisione is not null then
               begin
                  select data_pubblicazione
                    into d_dal_pubb
                    from revisioni_struttura
                   where ottica = unor.ottica
                     and revisione = unor.revisione;
               exception
                  when no_data_found then
                     d_dal_pubb := to_date(null);
               end;
            else
               d_dal_pubb := to_date(null);
            end if;
            begin
               update unita_organizzative
                  set dal_pubb = nvl(d_dal_pubb, dal)
                where id_elemento = unor.id_elemento;
            exception
               when others then
                  registra_errore(p_text     => substr('Update UNITA_ORGANIZZATIVE: (' ||
                                                       unor.id_elemento || ') ' ||
                                                       sqlerrm
                                                      ,1
                                                      ,2000)
                                 ,p_usertext => d_usertext);
            end;
            registra_info(p_text     => 'Aggiornato dal pubblicazione legame: ' ||
                                        unor.ottica || ' ' || unor.progr_uo || ' ' ||
                                        to_char(unor.dal, 'dd/mm/yyyy') || ' -'||'> ' ||
                                        to_char(nvl(d_dal_pubb, unor.dal), 'dd/mm/yyyy')
                         ,p_usertext => d_usertext);
         end if;
      end loop;
      --
      -- Controllo unità organizzative con dal nullo e dal_pubb non nullo
      --
      for unor in (select id_elemento
                         ,progr_unita_organizzativa progr_uo
                         ,dal
                     from unita_organizzative u
                         ,ottiche             o
                         ,amministrazioni     m
                    where u.ottica = o.ottica
                      and u.ottica = s_ottica
                      and o.amministrazione = m.codice_amministrazione
                      and m.ente = 'SI'
                      and u.dal is null
                      and u.dal_pubb is not null
                    order by 1)
      loop
         if p_tipo_elaborazione = 1 then
            -- solo controllo
            registra_info(p_text     => 'DAL nullo e DAL_PUBB non nullo: Id. ' ||
                                        unor.id_elemento
                         ,p_usertext => d_usertext);
         else
            -- rettifica dati
            -- si annulla il dal_pubb
            begin
               update unita_organizzative
                  set dal_pubb = to_date(null)
                where id_elemento = unor.id_elemento;
            exception
               when others then
                  registra_errore(p_text     => substr('Update UNITA_ORGANIZZATIVE: (' ||
                                                       unor.id_elemento || ') ' ||
                                                       sqlerrm
                                                      ,1
                                                      ,2000)
                                 ,p_usertext => d_usertext);
            end;
            registra_info(p_text     => 'Annullato dal pubblicazione legame: Id. ' ||
                                        unor.id_elemento
                         ,p_usertext => d_usertext);
         end if;
      end loop;
      --
      if p_tipo_elaborazione = 2 then
         --
         -- Abilitazione triggers UNITA_ORGANIZZATIVE
         --
         begin
            execute immediate 'alter table UNITA_ORGANIZZATIVE enable all triggers';
         exception
            when others then
               raise_application_error(-20999
                                      ,'Abilitazione triggers UNITA_ORGANIZZATIVE - ' ||
                                       sqlerrm);
         end;
      end if;
      --
      registra_info(p_text => d_usertext || ' - Fine elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      --commit;
      --
   end;
   -------------------------------------------------------------------------------
   procedure unor_controllo_6(p_tipo_elaborazione number) is
      /******************************************************************************
      NOME:        unor_controllo_6.
      DESCRIZIONE: UNITA_ORGANIZZATIVE: controlla la congruenza tra al e
                   al_pubb.
      RITORNA:     //
      NOTE:        Il controllo viene eseguito solo sulle unità afferenti agli
                   enti gestiti direttamente in SO4 (attributo ente = 'SI' su
                   record tabella AMMINISTRAZIONI).
                   P_tipo_elaborazione = 1: si esegue solo il controllo;
                   P_tipo_elaborazione = 2: si esegue la rettifica dei dati.
       REVISIONI:
       Rev.  Data        Autore   Descrizione
       ----  ----------  ------   ----------------------------------------------------
       0     03/10/2014  VDAVALLI Prima emissione.
      ******************************************************************************/
      d_usertext key_error_log.error_usertext%type := 'UNOR_CONTROLLO_6 - Congruenza al e al_pubb';
      d_dal_pubb anagrafe_unita_organizzative.al_pubb%type;
   begin
      registra_info(p_text => d_usertext || ' - Inizio elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      if p_tipo_elaborazione = 2 then
         --
         -- Disabilitazione triggers UNITA_ORGANIZZATIVE
         --
         begin
            execute immediate 'alter table UNITA_ORGANIZZATIVE disable all triggers';
         exception
            when others then
               raise_application_error(-20999
                                      ,'Disabilitazione triggers UNITA_ORGANIZZATIVE - ' ||
                                       sqlerrm);
         end;
      end if;
      --
      for unor in (select id_elemento
                         ,progr_unita_organizzativa progr_uo
                         ,al
                         ,u.ottica
                         ,revisione_cessazione
                     from unita_organizzative u
                         ,ottiche             o
                         ,amministrazioni     m
                    where u.ottica = o.ottica
                      and u.ottica = s_ottica
                      and o.amministrazione = m.codice_amministrazione
                      and m.ente = 'SI'
                      and u.al is not null
                      and u.al_pubb is null
                    order by 1)
      loop
         if p_tipo_elaborazione = 1 then
            -- solo controllo
            registra_info(p_text     => 'AL_PUBB nullo: ' || unor.ottica || ' ' ||
                                        unor.progr_uo || ' ' ||
                                        to_char(unor.al, 'dd/mm/yyyy')
                         ,p_usertext => d_usertext);
         else
            -- rettifica dati
            -- ricerca revisione istituzione dell'unita': se esiste, si aggiorna 
            -- il dal_pubb con la data pubblicazione della revisione,
            -- altrimenti si usa il dal
            if unor.revisione_cessazione is not null then
               begin
                  select data_pubblicazione
                    into d_dal_pubb
                    from revisioni_struttura
                   where ottica = unor.ottica
                     and revisione = unor.revisione_cessazione;
               exception
                  when no_data_found then
                     d_dal_pubb := to_date(null);
               end;
            else
               d_dal_pubb := to_date(null);
            end if;
            begin
               update unita_organizzative
                  set dal_pubb = decode(d_dal_pubb, to_date(null), al, d_dal_pubb - 1)
                where id_elemento = unor.id_elemento;
            exception
               when others then
                  registra_errore(p_text     => substr('Update UNITA_ORGANIZZATIVE: (' ||
                                                       unor.id_elemento || ') - ' ||
                                                       sqlerrm
                                                      ,1
                                                      ,2000)
                                 ,p_usertext => d_usertext);
            end;
            registra_info(p_text     => 'Aggiornato al pubblicazione anagrafica: ' ||
                                        unor.ottica || ' ' || unor.progr_uo
                         ,p_usertext => d_usertext);
         end if;
      end loop;
      --
      if p_tipo_elaborazione = 2 then
         --
         -- Abilitazione triggers UNITA_ORGANIZZATIVE
         --
         begin
            execute immediate 'alter table UNITA_ORGANIZZATIVE enable all triggers';
         exception
            when others then
               raise_application_error(-20999
                                      ,'Disabilitazione triggers UNITA_ORGANIZZATIVE - ' ||
                                       sqlerrm);
         end;
      end if;
      --
      registra_info(p_text => d_usertext || ' - Fine elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      --commit;
      --
   end;
   -------------------------------------------------------------------------------
   procedure unor_controllo_7 is
      /******************************************************************************
      NOME:        unor_controllo_7.
      DESCRIZIONE: UNITA_ORGANIZZATIVE: controlla se ci sono periodi sovrapposti
                   per date di pubblicazione
      RITORNA:     //
      NOTE:        Il controllo viene eseguito sull'intera tabella.
      ******************************************************************************/
      d_usertext key_error_log.error_usertext%type := 'UNOR_CONTROLLO_7 - Periodi sovrapposti per date di pubblicazione';
   begin
      registra_info(p_text => d_usertext || ' - Inizio elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      for unor in (select ottica
                         ,progr_unita_organizzativa progr_uo
                         ,dal_pubb
                     from unita_organizzative u
                    where u.dal_pubb is not null
                      and u.dal_pubb < nvl(u.al_pubb, s_data_limite)
                      and u.ottica = s_ottica
                      and (exists
                           (select 'x'
                              from unita_organizzative b
                             where b.ottica = u.ottica
                               and b.progr_unita_organizzativa = u.progr_unita_organizzativa
                               and b.dal_pubb is not null
                               and b.dal_pubb between u.dal_pubb and
                                   nvl(u.al_pubb, s_data_limite)
                               and b.ottica = s_ottica
                               and b.rowid != u.rowid) or exists
                           (select 'x'
                              from unita_organizzative c
                             where c.ottica = u.ottica
                               and c.progr_unita_organizzativa = u.progr_unita_organizzativa
                               and c.dal_pubb is not null
                               and nvl(c.al_pubb, s_data_limite) between u.dal_pubb and
                                   nvl(u.al_pubb, s_data_limite)
                               and c.ottica = s_ottica
                               and c.rowid != u.rowid))
                    order by 1)
      loop
         -- solo controllo
         registra_info(p_text     => 'Periodi sovrapposti: ' || unor.ottica || '/' ||
                                     unor.progr_uo || ' ' ||
                                     to_char(unor.dal_pubb, 'dd/mm/yyyy')
                      ,p_usertext => d_usertext);
      end loop;
      --
      registra_info(p_text => d_usertext || ' - Fine elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      --commit;
      --
   end;
   -------------------------------------------------------------------------------
   procedure controlli_incrociati_1 is
      /******************************************************************************
      NOME:        controlli_incrociati_1.
      DESCRIZIONE: Controlli incrociati tra ANAGRAFE_UNITA_ORGANIZZATIVE e 
                   UNITA_ORGANIZZATIVE.
      RITORNA:     //
      NOTE:        
      ******************************************************************************/
      d_usertext key_error_log.error_usertext%type := 'CONTROLLI_INCROCIATI_1';
      d_dal      unita_organizzative.dal%type;
      d_al       unita_organizzative.al%type;
   begin
      registra_info(p_text => d_usertext || ' - Inizio elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      for unor in (select u.ottica
                         ,u.progr_unita_organizzativa progr_uo
                         ,min(u.dal) dal
                         ,max(nvl(u.al, s_data_limite)) al
                     from unita_organizzative u
                    where u.ottica = s_ottica
                      and dal <= nvl(al, to_date(3333333, 'j'))
                    group by u.ottica
                            ,u.progr_unita_organizzativa
                   union
                   select u.ottica
                         ,u.id_unita_padre progr_uo
                         ,min(u.dal) dal
                         ,max(nvl(u.al, s_data_limite)) al
                     from unita_organizzative u
                    where u.id_unita_padre is not null
                      and u.ottica = s_ottica
                      and dal <= nvl(al, to_date(3333333, 'j'))
                    group by u.ottica
                            ,u.id_unita_padre
                    order by 1
                            ,2)
      loop
         begin
            select min(dal)
                  ,max(nvl(al, s_data_limite))
              into d_dal
                  ,d_al
              from anagrafe_unita_organizzative
             where progr_unita_organizzativa = unor.progr_uo
               and dal <= nvl(al, to_date(3333333, 'j'))
             group by progr_unita_organizzativa;
         exception
            when no_data_found then
               registra_errore(p_text     => 'Selezione date - Unita'' non esistente ' ||
                                             unor.progr_uo
                              ,p_usertext => d_usertext);
            when others then
               registra_errore(p_text     => substr('Selezione date: (' || unor.progr_uo || ') ' ||
                                                    sqlerrm
                                                   ,1
                                                   ,2000)
                              ,p_usertext => d_usertext);
         end;
         --
         if d_dal is not null and d_al is not null then
            if unor.dal < d_dal or unor.al > d_al then
               registra_errore(p_text     => 'Incongruenza periodi di validita - Progr.U.O. ' ||
                                             unor.progr_uo || ' - UNOR ' || unor.ottica || ' ' ||
                                             to_char(unor.dal, 'dd/mm/yyyy') || ' ' ||
                                             to_char(unor.al, 'dd/mm/yyyy') || ' - ANUO ' ||
                                             to_char(d_dal, 'dd/mm/yyyy') || ' ' ||
                                             to_char(d_al, 'dd/mm/yyyy')
                              ,p_usertext => d_usertext);
            end if;
            --
         end if;
      end loop;
      --
      registra_info(p_text => d_usertext || ' - Fine elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --commit;
   end;
   -------------------------------------------------------------------------------
   procedure controlli_incrociati_2 is
      /******************************************************************************
      NOME:        controlli_incrociati_1.
      DESCRIZIONE: Controlli incrociati tra periodi di validita' dei padri e dei figli
      RITORNA:     //
      NOTE:        
      ******************************************************************************/
      d_usertext key_error_log.error_usertext%type := 'CONTROLLI_INCROCIATI_2';
      d_dal      unita_organizzative.dal%type;
      d_al       unita_organizzative.al%type;
   begin
      registra_info(p_text => d_usertext || ' - Inizio elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --
      -- Controllo periodo di validita' padri compreso nel periodo di validita'
      -- della loro presenza in struttura
      --
      for unor in (select ottica
                         ,id_unita_padre progr_padre
                         ,min(dal) dal
                         ,max(nvl(al, s_data_limite)) al
                     from unita_organizzative
                    where id_unita_padre is not null
                      and ottica = s_ottica
                    group by ottica
                            ,id_unita_padre
                    order by ottica
                            ,id_unita_padre)
      loop
         begin
            select min(dal)
                  ,max(nvl(al, s_data_limite)) al
              into d_dal
                  ,d_al
              from unita_organizzative
             where ottica = unor.ottica
               and progr_unita_organizzativa = unor.progr_padre
             group by ottica
                     ,progr_unita_organizzativa;
         exception
            when no_data_found then
               registra_errore(p_text     => 'Selezione date - Unita'' padre (come figlio) non esistente ' ||
                                             unor.ottica || '/' || unor.progr_padre
                              ,p_usertext => d_usertext);
            when others then
               registra_errore(p_text     => substr('Selezione date: (' || unor.ottica || '/' ||
                                                    unor.progr_padre || ') ' || sqlerrm
                                                   ,1
                                                   ,2000)
                              ,p_usertext => d_usertext);
         end;
         --
         if d_dal is not null and d_al is not null then
            if unor.dal < d_dal or unor.al > d_al then
               registra_errore(p_text     => 'Incongruenza periodi di validita'' - Padre ' ||
                                             unor.ottica || ' ' || unor.progr_padre ||
                                             ' - ' || to_char(unor.dal, 'dd/mm/yyyy') || ' ' ||
                                             to_char(unor.al, 'dd/mm/yyyy') ||
                                             ' - Figlio ' || to_char(d_dal, 'dd/mm/yyyy') || ' ' ||
                                             to_char(d_al, 'dd/mm/yyyy')
                              ,p_usertext => d_usertext);
            end if;
         end if;
      end loop;
      --
      --commit;
      -- Controllo periodi di validita' figli rispetto a periodi di validita' padre      
      for unor in (select ottica
                         ,id_unita_padre progr_padre
                         ,progr_unita_organizzativa progr_figlio
                         ,dal
                         ,nvl(al, s_data_limite) al
                     from unita_organizzative
                    where id_unita_padre is not null
                      and ottica = s_ottica
                    order by ottica
                            ,id_unita_padre)
      loop
         begin
            select min(dal)
                  ,max(nvl(al, s_data_limite)) al
              into d_dal
                  ,d_al
              from unita_organizzative
             where ottica = unor.ottica
               and progr_unita_organizzativa = unor.progr_padre
             group by ottica
                     ,progr_unita_organizzativa;
         exception
            when no_data_found then
               registra_errore(p_text     => 'Selezione date - Unita'' padre non esistente ' ||
                                             unor.ottica || '/' || unor.progr_padre
                              ,p_usertext => d_usertext);
            when others then
               registra_errore(p_text     => substr('Selezione date: (' || unor.ottica || '/' ||
                                                    unor.progr_padre || ') ' || sqlerrm
                                                   ,1
                                                   ,2000)
                              ,p_usertext => d_usertext);
         end;
         --
         if d_dal is not null and d_al is not null then
            if unor.dal < d_dal or unor.al > d_al then
               registra_errore(p_text     => 'Incongruenza periodi di validita'' - Padre ' ||
                                             unor.ottica || ' ' || unor.progr_padre ||
                                             ' - ' || to_char(unor.dal, 'dd/mm/yyyy') || ' ' ||
                                             to_char(unor.al, 'dd/mm/yyyy') ||
                                             ' - Figlio' || unor.progr_figlio || ' ' ||
                                             to_char(d_dal, 'dd/mm/yyyy') || ' ' ||
                                             to_char(d_al, 'dd/mm/yyyy')
                              ,p_usertext => d_usertext);
            end if;
         end if;
      end loop;
      --
      registra_info(p_text => d_usertext || ' - Fine elaborazione: ' ||
                              to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
      --commit;
   end;
   -------------------------------------------------------------------------------
   procedure main
   (
      p_ottica            varchar2
     ,p_tipo_elaborazione number
   ) is
      /******************************************************************************
      NOME:        main.
      DESCRIZIONE: Esegue le procedure di controllo in sequenza.
      RITORNA:     //
      NOTE:        P_tipo_elaborazione = 1: si esegue solo il controllo;
                   P_tipo_elaborazione = 2: si esegue la rettifica dei dati.
      ******************************************************************************/
      d_usertext  key_error_log.error_usertext%type := 'CONTROLLI_UNITA_ORGANIZZATIVE';
      d_errore    number(1);
      d_messaggio varchar2(32767);
   begin
      s_ottica            := p_ottica;
      s_tipo_elaborazione := p_tipo_elaborazione;
      -- Controllo inserimento parametro tipo_elaborazione
      begin
         select 1
           into d_errore
           from dual
          where p_tipo_elaborazione is null
             or s_ottica is null;
         raise too_many_rows;
      exception
         when no_data_found then
            null;
         when too_many_rows then
            d_messaggio := 'Inserire i parametri ottica e tipo_elaborazione';
            raise;
      end;
      -- Verifica l'esistenza di revisioni in modifica
      begin
         select 1
           into d_errore
           from revisioni_struttura
          where stato = 'M'
            and ottica = s_ottica;
         raise too_many_rows;
      exception
         when no_data_found then
            null;
         when too_many_rows then
            d_messaggio := 'Esistono revisioni in modifica - Impossibile procedere';
            raise;
      end;
      -- Eliminazione messaggi elaborazioni precedenti
      begin
         delete from key_error_log
          where error_user = 'CHK SO4'
            and trunc(error_date) <= trunc(sysdate);
      exception
         when others then
            d_messaggio := 'Delete KEY_ERROR_LOG: ' || sqlerrm;
            raise;
      end;
      --
      --commit;
      --
      registra_info(p_text     => d_usertext || ' - ' || 'Inizio elaborazione: ' ||
                                  to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_usertext => null);
      --commit;
      --
      anuo_controllo_01(p_tipo_elaborazione => p_tipo_elaborazione);
      anuo_controllo_02(p_tipo_elaborazione => p_tipo_elaborazione);
      anuo_controllo_03(p_tipo_elaborazione => p_tipo_elaborazione);
      anuo_controllo_04(p_tipo_elaborazione => p_tipo_elaborazione);
      anuo_controllo_05(p_tipo_elaborazione => p_tipo_elaborazione);
      anuo_controllo_06(p_tipo_elaborazione => p_tipo_elaborazione);
      anuo_controllo_07(p_tipo_elaborazione => p_tipo_elaborazione);
      anuo_controllo_08(p_tipo_elaborazione => p_tipo_elaborazione);
      anuo_controllo_09(p_tipo_elaborazione => p_tipo_elaborazione);
      anuo_controllo_10(p_tipo_elaborazione => p_tipo_elaborazione);
      anuo_controllo_11;
      anuo_controllo_12(p_tipo_elaborazione => p_tipo_elaborazione);
      anuo_controllo_13(p_tipo_elaborazione => p_tipo_elaborazione);
      anuo_controllo_14;
      --
      unor_controllo_1(p_tipo_elaborazione => p_tipo_elaborazione);
      unor_controllo_2(p_tipo_elaborazione => p_tipo_elaborazione);
      unor_controllo_3(p_tipo_elaborazione => p_tipo_elaborazione);
      unor_controllo_4;
      unor_controllo_5(p_tipo_elaborazione => p_tipo_elaborazione);
      unor_controllo_6(p_tipo_elaborazione => p_tipo_elaborazione);
      unor_controllo_7;
      --
      controlli_incrociati_1;
      controlli_incrociati_2;
      --
      registra_info(p_text     => d_usertext || ' - ' || 'Fine elaborazione: ' ||
                                  to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_usertext => null);
      --commit;
      --
   exception
      when others then
         dbms_output.put_line(d_messaggio);
   end;
end controlli_unita_organizzative;
/

