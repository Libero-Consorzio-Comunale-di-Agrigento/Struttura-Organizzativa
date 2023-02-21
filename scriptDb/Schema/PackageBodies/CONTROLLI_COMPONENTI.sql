CREATE OR REPLACE package body controlli_componenti is
   /******************************************************************************
   NOME:        controlli_componenti
   DESCRIZIONE: Raggruppa le funzioni di controllo dei dati caricati in so4 
                relative a componenti e tabelle dipendenti
   ANNOTAZIONI: 
   
   REVISIONI: .
   <CODE>
   Rev.  Data        Autore    Descrizione.
   00    15/11/2012  VDAVALLI  Prima emissione.
   01    27/05/2015  MMONARI   #122
   </CODE>
   ******************************************************************************/

   s_revisione_body constant varchar2(30) := '001';
   s_incarico    tipi_incarico.incarico%type := 'ASS';
   s_ottica      ottiche.ottica%type;
   s_data_limite date := to_date(3333333, 'j');
   s_dummy       varchar2(1);
   s_error_date  date := sysdate;
   s_error_user  varchar2(8) := 'CHK SO4';

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
   function get_nominativo(p_ni anagrafe_soggetti.ni%type) return varchar2 is
      d_nominativo varchar2(100);
   begin
      select cognome || ' ' || nome || ' (ni: ' || ni || ')'
        into d_nominativo
        from anagrafe_soggetti
       where ni = p_ni;
      return d_nominativo;
   end;
   -------------------------------------------------------------------------------
   procedure registra_errore
   (
      p_text     key_error_log.error_text%type
     ,p_usertext key_error_log.error_usertext%type
     ,p_session  key_error_log.error_session%type
   ) is
      /******************************************************************************
      NOME:        registra_errore.
      DESCRIZIONE: Registra un messaggio di errore nella tabella KEY_ERROR_LOG
      RITORNA:     //
      NOTE:        
      ******************************************************************************/
   begin
      key_error_log_tpk.ins(p_error_session  => p_session
                           ,p_error_date     => s_error_date
                           ,p_error_text     => p_text
                           ,p_error_user     => s_error_user
                           ,p_error_usertext => p_usertext
                           ,p_error_type     => 'B');
   end;
   -------------------------------------------------------------------------------
   procedure registra_info
   (
      p_text     key_error_log.error_text%type
     ,p_usertext key_error_log.error_usertext%type default null
     ,p_session  key_error_log.error_session%type
   ) is
      /******************************************************************************
      NOME:        registra_info.
      DESCRIZIONE: Registra una segnalazione informativa nella tabella KEY_ERROR_LOG
      RITORNA:     //
      NOTE:        
      ******************************************************************************/
   begin
      key_error_log_tpk.ins(p_error_session  => p_session
                           ,p_error_date     => s_error_date
                           ,p_error_text     => p_text
                           ,p_error_user     => s_error_user
                           ,p_error_usertext => p_usertext
                           ,p_error_type     => 'P');
   end;
   -------------------------------------------------------------------------------
   procedure chk_soggetti(p_tipo_elaborazione number) is
      /******************************************************************************
      NOME:        chk_soggetti.
      DESCRIZIONE: Verifica la correttezza dei dati salienti dei soggetti e
                   l'esistenza dell'utente AD4 associato al soggetto presente
                   nella tabella COMPONENTI
      RITORNA:     //
      NOTE:        
      ******************************************************************************/
      d_usertext key_error_log.error_usertext%type := 'CHK_SOGGETTI';
      d_session  key_error_log.error_session%type := 400001;
   begin
      registra_info(p_text    => d_usertext || ' - Inizio elaborazione: ' ||
                                 to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_session => d_session);
      --
      for sogg in (select distinct c.ni
                                  ,(select count(*)
                                      from ad4_utenti_soggetti u
                                     where u.soggetto = c.ni) utente
                                  ,(select codice_fiscale
                                      from anagrafe_soggetti
                                     where ni = c.ni) codice_fiscale
                                  ,(select count(*) from anagrafe_soggetti where ni = c.ni) numero
                                  ,get_nominativo(c.ni) nominativo
                     from componenti c
                         ,ottiche    o
                    where c.dal <= nvl(c.al, s_data_limite)
                      and o.ottica = c.ottica
                      and o.ottica_istituzionale = 'SI'
                    order by 1)
      loop
         if p_tipo_elaborazione = 1 then
            -- solo controllo
            if sogg.utente = 0 and sogg.numero > 0then
             registra_info(p_text     => 'Utente mancante: ' || sogg.nominativo
                            ,p_usertext => d_usertext
                            ,p_session  => d_session) ; elsif sogg.utente > 1 then
               registra_info(p_text     => 'Associazione utente-soggetto errata: ' ||
                                           sogg.nominativo
                            ,p_usertext => d_usertext
                            ,p_session  => d_session);
            end if;
            if sogg.codice_fiscale is null and sogg.numero > 0 then
               registra_info(p_text     => 'Codice Fiscale nullo: ' || sogg.nominativo
                            ,p_usertext => d_usertext
                            ,p_session  => d_session);
            end if;
            if sogg.numero = 0 then
               registra_info(p_text     => 'Soggetto non definito: ' || sogg.ni
                            ,p_usertext => d_usertext
                            ,p_session  => d_session);
            end if;
         end if;
      end loop;
      --
      registra_info(p_text    => d_usertext || ' - Fine elaborazione: ' ||
                                 to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_session => d_session);
      --
      --commit;
      dbms_output.put_line('Check soggetti - Fine');
      --
   end;
   -------------------------------------------------------------------------------
   procedure chk_incarichi(p_tipo_elaborazione number) is
      /******************************************************************************
      NOME:        incarichi_mancanti.
      DESCRIZIONE: Verifica l'esistenza di una riga di attributi_componente per ogni
                   riga di componenti
      RITORNA:     //
      NOTE:        
      ******************************************************************************/
      d_usertext key_error_log.error_usertext%type := 'INCARICHI_MANCANTI';
      d_session  key_error_log.error_session%type := 400002;
   begin
      registra_info(p_text    => d_usertext || ' - Inizio elaborazione: ' ||
                                 to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_session => d_session);
      --
      for comp in (select ottica
                         ,id_componente
                         ,progr_unita_organizzativa
                         ,ni
                         ,ci
                         ,dal
                         ,al
                         ,revisione_assegnazione
                         ,revisione_cessazione
                         ,(select count(*)
                             from attributi_componente a
                            where c.id_componente = a.id_componente) attributi
                         ,get_nominativo(c.ni) nominativo
                     from componenti c
                    where c.dal <= nvl(c.al, s_data_limite)
                    order by id_componente)
      loop
         if p_tipo_elaborazione = 1 then
            -- solo controllo
            if comp.attributi = 0 then
               registra_info(p_text     => 'Incarico mancante: ' || comp.nominativo
                            ,p_usertext => d_usertext
                            ,p_session  => d_session);
            end if;
         else
            begin
               if comp.attributi = 0 then
                  attributo_componente.ins(p_id_componente           => comp.id_componente
                                          ,p_dal                     => comp.dal
                                          ,p_al                      => comp.al
                                          ,p_incarico                => s_incarico
                                          ,p_assegnazione_prevalente => 1
                                          ,p_tipo_assegnazione       => 'I'
                                          ,p_percentuale_impiego     => 100
                                          ,p_ottica                  => comp.ottica
                                          ,p_revisione_assegnazione  => comp.revisione_assegnazione
                                          ,p_revisione_cessazione    => comp.revisione_cessazione
                                          ,p_utente_aggiornamento    => s_error_user
                                          ,p_data_aggiornamento      => trunc(sysdate));
               end if;
            exception
               when others then
                  registra_errore(p_text     => substr('Inserimento ATTRIBUTI_COMPONENTE: (' ||
                                                       comp.id_componente || ' ' ||
                                                       sqlerrm
                                                      ,1
                                                      ,2000)
                                 ,p_usertext => d_usertext
                                 ,p_session  => d_session);
            end;
            registra_info(p_text     => 'Inserito incarico mancante: ' ||
                                        comp.id_componente
                         ,p_usertext => d_usertext
                         ,p_session  => d_session);
         end if;
      end loop;
      --
      registra_info(p_text    => d_usertext || ' - Fine elaborazione: ' ||
                                 to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_session => d_session);
      --
      --commit;
      --
   end;
   -------------------------------------------------------------------------------
   procedure controllo_dipendenze(p_tipo_elaborazione number) is
      /******************************************************************************
      NOME:        controllo_dipendenze.
      DESCRIZIONE: Controlli di congruenza tra periodo di validita' assegnazioni
                   e periodo di validita' tabelle dipendenti
      RITORNA:     //
      NOTE:        
      ******************************************************************************/
      d_text         key_error_log.error_text%type;
      d_usertext     key_error_log.error_usertext%type := 'CONTROLLO_DIPENDENZE';
      d_session      key_error_log.error_session%type := 400003;
      d_conta_record number(4);
      d_al_prec      date;
      d_id_prec      attributi_componente.id_attr_componente%type;
   begin
      registra_info(p_text    => d_usertext || ' - Inizio elaborazione: ' ||
                                 to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_session => d_session);
      --
      for comp in (select ottica
                         ,id_componente
                         ,progr_unita_organizzativa
                         ,ni
                         ,ci
                         ,dal
                         ,al
                     from componenti c
                    where c.dal <= nvl(c.al, s_data_limite)
                    order by 1
                            ,2
                            ,6)
      loop
         --
         -- Trattamento incarichi
         --
         d_conta_record := 0;
         for atco in (select id_attr_componente
                            ,dal
                            ,al
                        from attributi_componente
                       where id_componente = comp.id_componente
                         and dal <= nvl(al, s_data_limite)
                       order by 2)
         loop
            d_conta_record := d_conta_record + 1;
         
            if d_conta_record = 1 then
               if atco.dal != comp.dal then
                  if p_tipo_elaborazione = 1 then
                     -- solo controllo
                     d_text := 'ATTRIBUTI - Primo DAL incongruente: ' ||
                               comp.id_componente || ' dal COMP. ' ||
                               to_char(comp.dal, 'dd/mm/yyyy') || ' dal ATCO. ' ||
                               to_char(atco.dal, 'dd/mm/yyyy');
                  else
                     begin
                        update attributi_componente
                           set dal                  = comp.dal
                              ,utente_aggiornamento = s_error_user
                              ,data_aggiornamento   = trunc(sysdate)
                         where id_attr_componente = atco.id_attr_componente;
                     exception
                        when others then
                           registra_errore(p_text     => substr('Update ATTRIBUTI_COMPONENTE: (' ||
                                                                atco.id_attr_componente || ' ' ||
                                                                sqlerrm
                                                               ,1
                                                               ,2000)
                                          ,p_usertext => d_usertext
                                          ,p_session  => d_session);
                     end;
                     --
                     d_text := 'ATTRIBUTI - Aggiornamento primo DAL: ' ||
                               atco.id_attr_componente || ' ' ||
                               to_char(atco.dal, 'dd/mm/yyyy') || ' -'||'> ' ||
                               to_char(comp.dal, 'dd/mm/yyyy');
                  end if;
                  --
                  registra_info(p_text     => d_text
                               ,p_usertext => d_usertext
                               ,p_session  => d_session);
               end if;
            else
               if atco.dal != nvl(d_al_prec, s_data_limite) + 1 then
                  if p_tipo_elaborazione = 1 then
                     -- solo controllo
                     d_text := 'ATTRIBUTI - Incongruenza periodi: ' || comp.id_componente ||
                               ' dal ATCO. ' || to_char(atco.dal, 'dd/mm/yyyy') ||
                               ' al prec. ' || to_char(d_al_prec, 'dd/mm/yyyy');
                  else
                     if d_al_prec is null then
                        begin
                           update attributi_componente
                              set al                   = atco.dal - 1
                                 ,utente_aggiornamento = s_error_user
                                 ,data_aggiornamento   = trunc(sysdate)
                            where id_attr_componente = d_id_prec;
                        exception
                           when others then
                              registra_errore(p_text     => substr('Update ATTRIBUTI_COMPONENTE: (' ||
                                                                   d_id_prec || ' ' ||
                                                                   sqlerrm
                                                                  ,1
                                                                  ,2000)
                                             ,p_usertext => d_usertext
                                             ,p_session  => d_session);
                        end;
                        --
                        d_text := 'ATTRIBUTI - Aggiornamento AL prec.: ' ||
                                  atco.id_attr_componente || ' ' ||
                                  to_char(d_al_prec, 'dd/mm/yyyy') || ' -'||'> ' ||
                                  to_char(atco.dal - 1, 'dd/mm/yyyy');
                     else
                        begin
                           update attributi_componente
                              set dal                  = d_al_prec + 1
                                 ,utente_aggiornamento = s_error_user
                                 ,data_aggiornamento   = trunc(sysdate)
                            where id_attr_componente = atco.id_attr_componente;
                        exception
                           when others then
                              registra_errore(p_text     => substr('Update ATTRIBUTI_COMPONENTE: (' ||
                                                                   atco.id_attr_componente || ' ' ||
                                                                   sqlerrm
                                                                  ,1
                                                                  ,2000)
                                             ,p_usertext => d_usertext
                                             ,p_session  => d_session);
                        end;
                        --
                        d_text := 'ATTRIBUTI - Aggiornamento DAL: ' ||
                                  atco.id_attr_componente || ' ' ||
                                  to_char(atco.dal, 'dd/mm/yyyy') || ' -'||'> ' ||
                                  to_char(d_al_prec + 1, 'dd/mm/yyyy');
                     end if;
                  end if;
                  --
                  registra_info(p_text     => d_text
                               ,p_usertext => d_usertext
                               ,p_session  => d_session);
               end if;
            end if;
            --
            d_al_prec := atco.al;
            d_id_prec := atco.id_attr_componente;
            --
         end loop;
         --
         -- Verifica e sistemazione AL dell'ultimo record di ATTRIBUTI_COMPONENTE   
         --
         if nvl(comp.al, s_data_limite) != nvl(d_al_prec, s_data_limite) then
            if p_tipo_elaborazione = 1 then
               -- solo controllo
               d_text := 'ATTRIBUTI - Ultimo AL incongruente: ' || comp.id_componente ||
                         ' al COMP. ' || to_char(comp.al, 'dd/mm/yyyy') || ' al ATCO. ' ||
                         to_char(d_al_prec, 'dd/mm/yyyy');
            else
               begin
                  update attributi_componente
                     set al                   = comp.al
                        ,utente_aggiornamento = s_error_user
                        ,data_aggiornamento   = trunc(sysdate)
                   where id_attr_componente = d_id_prec;
               exception
                  when others then
                     registra_errore(p_text     => substr('Update ATTRIBUTI_COMPONENTE: (' ||
                                                          d_id_prec || ' ' || sqlerrm
                                                         ,1
                                                         ,2000)
                                    ,p_usertext => d_usertext
                                    ,p_session  => d_session);
               end;
               --
               d_text := 'ATTRIBUTI - Aggiornamento ultimo AL: ' || d_id_prec || ' ' ||
                         to_char(d_al_prec, 'dd/mm/yyyy') || ' -'||'> ' ||
                         to_char(comp.al, 'dd/mm/yyyy');
            end if;
            --
            registra_info(p_text     => d_text
                         ,p_usertext => d_usertext
                         ,p_session  => d_session);
         end if;
         --
         -- Trattamento ubicazioni
         --
         d_conta_record := 0;
         for ubco in (select id_ubicazione_componente
                            ,dal
                            ,al
                        from ubicazioni_componente
                       where id_componente = comp.id_componente
                       order by 2)
         loop
            d_conta_record := d_conta_record + 1;
            if d_conta_record = 1 then
               if ubco.dal != comp.dal then
                  if p_tipo_elaborazione = 1 then
                     -- solo controllo
                     d_text := 'UBICAZIONI - Primo DAL incongruente: ' ||
                               comp.id_componente || ' dal COMP. ' ||
                               to_char(comp.dal, 'dd/mm/yyyy') || ' dal UBCO. ' ||
                               to_char(ubco.dal, 'dd/mm/yyyy');
                  else
                     begin
                        update ubicazioni_componente
                           set dal                  = comp.dal
                              ,utente_aggiornamento = s_error_user
                              ,data_aggiornamento   = trunc(sysdate)
                         where id_ubicazione_componente = ubco.id_ubicazione_componente;
                     exception
                        when others then
                           registra_errore(p_text     => substr('Update UBICAZIONI_COMPONENTE: (' ||
                                                                ubco.id_ubicazione_componente || ' ' ||
                                                                sqlerrm
                                                               ,1
                                                               ,2000)
                                          ,p_usertext => d_usertext
                                          ,p_session  => d_session);
                     end;
                     --
                     d_text := 'UBICAZIONI - Aggiornamento primo DAL: ' ||
                               ubco.id_ubicazione_componente || ' ' ||
                               to_char(ubco.dal, 'dd/mm/yyyy') || ' -'||'> ' ||
                               to_char(comp.dal, 'dd/mm/yyyy');
                  end if;
                  --
                  registra_info(p_text     => d_text
                               ,p_usertext => d_usertext
                               ,p_session  => d_session);
               end if;
            else
               if ubco.dal != nvl(d_al_prec, s_data_limite) + 1 then
                  if p_tipo_elaborazione = 1 then
                     -- solo controllo
                     d_text := 'UBICAZIONI - Incongruenza periodi: ' ||
                               comp.id_componente || ' dal UBCO. ' ||
                               to_char(ubco.dal, 'dd/mm/yyyy') || ' al prec. ' ||
                               to_char(d_al_prec, 'dd/mm/yyyy') || ' Id COMP. ' ||
                               comp.id_componente;
                  else
                     if d_al_prec is null then
                        begin
                           update ubicazioni_componente
                              set al                   = ubco.dal - 1
                                 ,utente_aggiornamento = s_error_user
                                 ,data_aggiornamento   = trunc(sysdate)
                            where id_ubicazione_componente = d_id_prec;
                        exception
                           when others then
                              registra_errore(p_text     => substr('Update UBICAZIONI_COMPONENTE: (' ||
                                                                   d_id_prec || ' ' ||
                                                                   sqlerrm
                                                                  ,1
                                                                  ,2000)
                                             ,p_usertext => d_usertext
                                             ,p_session  => d_session);
                        end;
                        --
                        d_text := 'UBICAZIONI - Aggiornamento AL prec.: ' || d_id_prec || ' ' ||
                                  to_char(d_al_prec, 'dd/mm/yyyy') || ' -'||'> ' ||
                                  to_char(ubco.dal - 1, 'dd/mm/yyyy');
                     else
                        begin
                           update ubicazioni_componente
                              set dal                  = d_al_prec + 1
                                 ,utente_aggiornamento = s_error_user
                                 ,data_aggiornamento   = trunc(sysdate)
                            where id_ubicazione_componente =
                                  ubco.id_ubicazione_componente;
                        exception
                           when others then
                              registra_errore(p_text     => substr('Update UBICAZIONI_COMPONENTE: (' ||
                                                                   ubco.id_ubicazione_componente || ' ' ||
                                                                   sqlerrm
                                                                  ,1
                                                                  ,2000)
                                             ,p_usertext => d_usertext
                                             ,p_session  => d_session);
                        end;
                        --
                        d_text := 'UBICAZIONI - Aggiornamento DAL: ' ||
                                  ubco.id_ubicazione_componente || ' ' ||
                                  to_char(ubco.dal, 'dd/mm/yyyy') || ' -'||'> ' ||
                                  to_char(d_al_prec + 1, 'dd/mm/yyyy');
                     end if;
                  end if;
                  --
                  registra_info(p_text     => d_text
                               ,p_usertext => d_usertext
                               ,p_session  => d_session);
               end if;
            end if;
            d_al_prec := ubco.al;
            d_id_prec := ubco.id_ubicazione_componente;
         end loop;
         --
         -- Verifica e sistemazione AL dell'ultimo record di UBICAZIONI_COMPONENTE   
         --
         if d_conta_record > 0 then
            if nvl(comp.al, s_data_limite) != nvl(d_al_prec, s_data_limite) then
               if p_tipo_elaborazione = 1 then
                  -- solo controllo
                  d_text := 'UBICAZIONI - Ultimo AL incongruente: ' || comp.id_componente ||
                            ' al COMP. ' || to_char(comp.al, 'dd/mm/yyyy') ||
                            ' al UBCO. ' || to_char(d_al_prec, 'dd/mm/yyyy');
               else
                  begin
                     update ubicazioni_componente
                        set al                   = comp.al
                           ,utente_aggiornamento = s_error_user
                           ,data_aggiornamento   = trunc(sysdate)
                      where id_ubicazione_componente = d_id_prec;
                  exception
                     when others then
                        registra_errore(p_text     => substr('Update UBICAZIONI_COMPONENTE: (' ||
                                                             d_id_prec || ' ' || sqlerrm
                                                            ,1
                                                            ,2000)
                                       ,p_usertext => d_usertext
                                       ,p_session  => d_session);
                  end;
                  --
                  d_text := 'UBICAZIONI - Aggiornamento ultimo AL: ' || d_id_prec || ' ' ||
                            to_char(d_al_prec, 'dd/mm/yyyy') || ' -'||'> ' ||
                            to_char(comp.al, 'dd/mm/yyyy');
               end if;
               --
               registra_info(p_text     => d_text
                            ,p_usertext => d_usertext
                            ,p_session  => d_session);
            end if;
         end if;
         --
         -- Trattamento imputazioni
         --
         d_conta_record := 0;
         for imbi in (select id_imputazione
                            ,dal
                            ,al
                        from imputazioni_bilancio
                       where id_componente = comp.id_componente
                       order by 2)
         loop
            d_conta_record := d_conta_record + 1;
            if d_conta_record = 1 then
               if imbi.dal != comp.dal then
                  if p_tipo_elaborazione = 1 then
                     -- solo controllo
                     d_text := 'IMPUTAZIONI - Primo DAL incongruente: ' ||
                               comp.id_componente || ' dal COMP. ' ||
                               to_char(comp.dal, 'dd/mm/yyyy') || ' dal IMBI. ' ||
                               to_char(imbi.dal, 'dd/mm/yyyy');
                  else
                     begin
                        update imputazioni_bilancio
                           set dal        = comp.dal
                              ,utente_agg = s_error_user
                              ,data_agg   = trunc(sysdate)
                         where id_imputazione = imbi.id_imputazione;
                     exception
                        when others then
                           registra_errore(p_text     => substr('Update IMPUTAZIONI_BILANCIO: (' ||
                                                                imbi.id_imputazione || ' ' ||
                                                                sqlerrm
                                                               ,1
                                                               ,2000)
                                          ,p_usertext => d_usertext
                                          ,p_session  => d_session);
                     end;
                     --
                     d_text := 'IMPUTAZIONI - Aggiornamento primo DAL: ' ||
                               imbi.id_imputazione || ' ' ||
                               to_char(imbi.dal, 'dd/mm/yyyy') || ' -'||'> ' ||
                               to_char(comp.dal, 'dd/mm/yyyy');
                  end if;
                  --
                  registra_info(p_text     => d_text
                               ,p_usertext => d_usertext
                               ,p_session  => d_session);
               end if;
            else
               if imbi.dal != nvl(d_al_prec, s_data_limite) + 1 then
                  if p_tipo_elaborazione = 1 then
                     -- solo controllo
                     d_text := 'IMPUTAZIONI - Incongruenza periodi: ' ||
                               comp.id_componente || ' dal IMBI. ' ||
                               to_char(imbi.dal, 'dd/mm/yyyy') || ' al prec. ' ||
                               to_char(d_al_prec, 'dd/mm/yyyy');
                  else
                     if d_al_prec is null then
                        begin
                           update imputazioni_bilancio
                              set al         = imbi.dal - 1
                                 ,utente_agg = s_error_user
                                 ,data_agg   = trunc(sysdate)
                            where id_imputazione = d_id_prec;
                        exception
                           when others then
                              registra_errore(p_text     => substr('Update IMPUTAZIONI_BILANCIO: (' ||
                                                                   d_id_prec || ' ' ||
                                                                   sqlerrm
                                                                  ,1
                                                                  ,2000)
                                             ,p_usertext => d_usertext
                                             ,p_session  => d_session);
                        end;
                        --
                        d_text := 'IMPUTAZIONI - Aggiornamento AL prec.: ' || d_id_prec || ' ' ||
                                  to_char(d_al_prec, 'dd/mm/yyyy') || ' -'||'> ' ||
                                  to_char(imbi.dal - 1, 'dd/mm/yyyy');
                     
                     else
                        begin
                           update imputazioni_bilancio
                              set dal        = d_al_prec + 1
                                 ,utente_agg = s_error_user
                                 ,data_agg   = trunc(sysdate)
                            where id_imputazione = imbi.id_imputazione;
                        exception
                           when others then
                              registra_errore(p_text     => substr('Update IMPUTAZIONI_BILANCIO: (' ||
                                                                   imbi.id_imputazione || ' ' ||
                                                                   sqlerrm
                                                                  ,1
                                                                  ,2000)
                                             ,p_usertext => d_usertext
                                             ,p_session  => d_session);
                        end;
                        --
                        d_text := 'IMPUTAZIONI - Aggiornamento DAL: ' ||
                                  imbi.id_imputazione || ' ' ||
                                  to_char(imbi.dal, 'dd/mm/yyyy') || ' -'||'> ' ||
                                  to_char(d_al_prec + 1, 'dd/mm/yyyy');
                     end if;
                  end if;
                  --
                  registra_info(p_text     => d_text
                               ,p_usertext => d_usertext
                               ,p_session  => d_session);
               end if;
            end if;
            d_al_prec := imbi.al;
            d_id_prec := imbi.id_imputazione;
         end loop;
         --
         -- Verifica e sistemazione AL dell'ultimo record di IMPUTAZIONI_BILANCIO   
         --
         if d_conta_record > 0 then
            if nvl(comp.al, s_data_limite) != nvl(d_al_prec, s_data_limite) then
               if p_tipo_elaborazione = 1 then
                  -- solo controllo
                  registra_info(p_text     => 'IMPUTAZIONI - Ultimo AL incongruente: ' ||
                                              comp.id_componente || ' al COMP. ' ||
                                              to_char(comp.al, 'dd/mm/yyyy') ||
                                              ' al IMBI. ' ||
                                              to_char(d_al_prec, 'dd/mm/yyyy')
                               ,p_usertext => d_usertext
                               ,p_session  => d_session);
               else
                  begin
                     update imputazioni_bilancio
                        set al         = comp.al
                           ,utente_agg = s_error_user
                           ,data_agg   = trunc(sysdate)
                      where id_imputazione = d_id_prec;
                  exception
                     when others then
                        registra_errore(p_text     => substr('Update IMPUTAZIONI_BILANCIO: (' ||
                                                             d_id_prec || ' ' || sqlerrm
                                                            ,1
                                                            ,2000)
                                       ,p_usertext => d_usertext
                                       ,p_session  => d_session);
                  end;
                  --
                  registra_info(p_text     => 'IMPUTAZIONI - Aggiornamento primo DAL: ' ||
                                              d_id_prec || ' ' ||
                                              to_char(d_al_prec, 'dd/mm/yyyy') || ' -'||'> ' ||
                                              to_char(comp.al, 'dd/mm/yyyy')
                               ,p_usertext => d_usertext
                               ,p_session  => d_session);
               end if;
            end if;
         end if;
         --
         -- Trattamento ruoli
         --
         for ruco in (select id_ruolo_componente
                            ,dal
                            ,al
                        from ruoli_componente
                       where id_componente = comp.id_componente
                         and dal <= nvl(al, s_data_limite)
                       order by 2)
         loop
            if ruco.dal < comp.dal or
               nvl(ruco.al, s_data_limite) > nvl(comp.al, s_data_limite) then
               if p_tipo_elaborazione = 1 then
                  -- solo controllo
                  d_text := 'RUOLI - Incongruenza periodi: ' || comp.id_componente ||
                            ' COMP. ' || to_char(comp.dal, 'dd/mm/yyyy') || ' ' ||
                            to_char(comp.al, 'dd/mm/yyyy') || ' ' || ' RUCO. ' ||
                            to_char(ruco.dal, 'dd/mm/yyyy') || ' ' ||
                            to_char(ruco.al, 'dd/mm/yyyy');
               else
                  d_al_prec := least(nvl(comp.al, s_data_limite)
                                    ,nvl(ruco.al, s_data_limite));
                  if d_al_prec = s_data_limite then
                     d_al_prec := to_date(null);
                  end if;
                  begin
                     update ruoli_componente
                        set dal                  = greatest(comp.dal, ruco.dal)
                           ,al                   = d_al_prec
                           ,utente_aggiornamento = s_error_user
                           ,data_aggiornamento   = trunc(sysdate)
                      where id_ruolo_componente = ruco.id_ruolo_componente;
                  exception
                     when others then
                        registra_errore(p_text     => substr('Update RUOLI_COMPONENTE: (' ||
                                                             ruco.id_ruolo_componente || ' ' ||
                                                             sqlerrm
                                                            ,1
                                                            ,2000)
                                       ,p_usertext => d_usertext
                                       ,p_session  => d_session);
                  end;
                  --
                  d_text := 'RUOLI - Aggiornamento date: ' || ruco.id_ruolo_componente || ' ' ||
                            to_char(ruco.dal, 'dd/mm/yyyy') || ' -'||'> ' ||
                            to_char(greatest(comp.dal, ruco.dal), 'dd/mm/yyyy') || ' ' ||
                            to_char(ruco.al, 'dd/mm/yyyy') || ' -'||'> ' ||
                            to_char(d_al_prec, 'dd/mm/yyyy');
               end if;
               --
               registra_info(p_text     => d_text
                            ,p_usertext => d_usertext
                            ,p_session  => d_session);
            end if;
         end loop;
      end loop;
      --
      registra_info(p_text    => d_usertext || ' - Fine elaborazione: ' ||
                                 to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_session => d_session);
      --
      --commit;
      --   
   end;
   -------------------------------------------------------------------------------
   procedure comp_controllo_1(p_tipo_elaborazione number) is
      /******************************************************************************
      NOME:        comp_controllo_1.
      DESCRIZIONE: COMPONENTI: controlla la congruenza tra data 
                   inizio validita' (DAL) e revisione assegnazione.
      RITORNA:     //
      NOTE:        Il controllo viene eseguito solo sui componenti assegnati
                   in ottiche gestite a revisione.
                   P_tipo_elaborazione = 1: si esegue solo il controllo;
                   P_tipo_elaborazione = 2: si esegue la rettifica dei dati.
      ******************************************************************************/
      d_usertext  key_error_log.error_usertext%type := 'COMP_CONTROLLO_1 - Congruenza revisione assegnazione e dal';
      d_session   key_error_log.error_session%type := 400004;
      d_dal       revisioni_struttura.dal%type;
      d_revisione revisioni_struttura.revisione%type;
   begin
      registra_info(p_text    => d_usertext || ' - Inizio elaborazione: ' ||
                                 to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_session => d_session);
      --
      for comp in (select id_componente
                         ,dal
                         ,c.ottica ottica
                         ,revisione_assegnazione
                     from componenti c
                         ,ottiche    o
                    where c.ottica = o.ottica
                      and o.ottica = s_ottica
                      and o.gestione_revisioni = 'SI'
                      and c.revisione_assegnazione is not null
                      and c.dal <= nvl(c.al, s_data_limite)
                      and not exists (select 'x'
                             from revisioni_struttura r
                            where r.ottica = c.ottica
                              and r.revisione = c.revisione_assegnazione
                              and r.dal = c.dal)
                    order by 1)
      loop
         d_dal := revisione_struttura.get_dal(p_ottica    => comp.ottica
                                             ,p_revisione => comp.revisione_assegnazione);
         if d_dal is null then
            registra_errore(p_text     => 'Revisione non presente: ' || comp.ottica || '/' ||
                                          comp.revisione_assegnazione || ' - Id. ' ||
                                          comp.id_componente
                           ,p_usertext => d_usertext
                           ,p_session  => d_session);
         else
            if p_tipo_elaborazione = 1 then
               -- solo controllo
               registra_info(p_text     => 'DAL incongruente: Id. ' || comp.id_componente ||
                                           ' Revisione nr. ' ||
                                           comp.revisione_assegnazione || ' ' ||
                                           to_char(comp.dal, 'dd/mm/yyyy') || ' ' ||
                                           to_char(d_dal, 'dd/mm/yyyy')
                            ,p_usertext => d_usertext
                            ,p_session  => d_session);
            else
               -- rettifica dati
               -- ricerca revisione alla data dell'assegnazione: se esiste, si aggiorna la revisione
               begin
                  select min(revisione)
                    into d_revisione
                    from revisioni_struttura
                   where ottica = comp.ottica
                     and dal = comp.dal
                   group by ottica
                           ,dal;
               exception
                  when no_data_found then
                     d_revisione := to_number(null);
               end;
               if d_revisione is not null then
                  begin
                     update componenti
                        set revisione_assegnazione = d_revisione
                           ,utente_aggiornamento   = s_error_user
                           ,data_aggiornamento     = trunc(sysdate)
                      where id_componente = comp.id_componente;
                  exception
                     when others then
                        registra_errore(p_text     => substr('Update COMPONENTI: (' ||
                                                             comp.id_componente || ') ' ||
                                                             sqlerrm
                                                            ,1
                                                            ,2000)
                                       ,p_usertext => d_usertext
                                       ,p_session  => d_session);
                  end;
                  registra_info(p_text     => 'Aggiornata revisione assegnazione componente: Id. ' ||
                                              comp.id_componente || ' ' ||
                                              comp.revisione_assegnazione || ' -'||'> ' ||
                                              d_revisione
                               ,p_usertext => d_usertext
                               ,p_session  => d_session);
               else
                  -- Se non esiste una revisione alla data AL + 1, si annulla
                  -- la revisione di cessazione
                  begin
                     update componenti
                        set revisione_assegnazione = to_number(null)
                           ,utente_aggiornamento   = s_error_user
                           ,data_aggiornamento     = trunc(sysdate)
                      where id_componente = comp.id_componente;
                  exception
                     when others then
                        registra_errore(p_text     => substr('Update COMPONENTI: (' ||
                                                             comp.id_componente || ' ' ||
                                                             to_char(comp.dal
                                                                    ,'dd/mm/yyyy') || ') ' ||
                                                             sqlerrm
                                                            ,1
                                                            ,2000)
                                       ,p_usertext => d_usertext
                                       ,p_session  => d_session);
                  end;
                  registra_info(p_text     => 'Annullata revisione assegnazione: Id. ' ||
                                              comp.id_componente
                               ,p_usertext => d_usertext
                               ,p_session  => d_session);
               end if;
            end if;
         end if;
      end loop;
      --
      registra_info(p_text    => d_usertext || ' - Fine elaborazione: ' ||
                                 to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_session => d_session);
      --
      --commit;
      --
   end;
   -------------------------------------------------------------------------------
   procedure comp_controllo_2(p_tipo_elaborazione number) is
      /******************************************************************************
      NOME:        comp_controllo_2.
      DESCRIZIONE: COMPONENTI: controlla la congruenza tra data 
                   fine validita' (AL) e revisione cessazione.
      RITORNA:     //
      NOTE:        Il controllo viene eseguito solo sui componenti assegnati
                   in ottiche gestite a revisione.
                   P_tipo_elaborazione = 1: si esegue solo il controllo;
                   P_tipo_elaborazione = 2: si esegue la rettifica dei dati.
      ******************************************************************************/
      d_usertext  key_error_log.error_usertext%type := 'COMP_CONTROLLO_2 - Congruenza revisione cessazione e al';
      d_session   key_error_log.error_session%type := 400005;
      d_dal       revisioni_struttura.dal%type;
      d_revisione revisioni_struttura.revisione%type;
   begin
      registra_info(p_text    => d_usertext || ' - Inizio elaborazione: ' ||
                                 to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_session => d_session);
      --
      for comp in (select id_componente
                         ,al
                         ,c.ottica ottica
                         ,revisione_cessazione
                     from componenti c
                         ,ottiche    o
                    where c.ottica = o.ottica
                      and o.ottica = s_ottica
                      and o.gestione_revisioni = 'SI'
                      and c.revisione_cessazione is not null
                      and c.dal <= nvl(c.al, s_data_limite)
                      and not exists
                    (select 'x'
                             from revisioni_struttura r
                            where r.ottica = c.ottica
                              and r.revisione = c.revisione_cessazione
                              and r.dal = nvl(c.al, s_data_limite) + 1)
                    order by 1)
      loop
         d_dal := revisione_struttura.get_dal(p_ottica    => comp.ottica
                                             ,p_revisione => comp.revisione_cessazione);
         if d_dal is null then
            registra_errore(p_text     => 'Revisione non presente: ' || comp.ottica || '/' ||
                                          comp.revisione_cessazione || ' - Id. ' ||
                                          comp.id_componente
                           ,p_usertext => d_usertext
                           ,p_session  => d_session);
         else
            if p_tipo_elaborazione = 1 then
               -- solo controllo
               registra_info(p_text     => 'AL incongruente: Id. ' || comp.id_componente ||
                                           ' Revisione nr. ' || comp.revisione_cessazione || ' ' ||
                                           to_char(comp.al, 'dd/mm/yyyy') || ' ' ||
                                           to_char(d_dal - 1, 'dd/mm/yyyy')
                            ,p_usertext => d_usertext
                            ,p_session  => d_session);
            else
               -- rettifica dati
               -- ricerca revisione alla data dell'unita': se esiste, si aggiorna la revisione
               begin
                  select min(revisione)
                    into d_revisione
                    from revisioni_struttura
                   where ottica = comp.ottica
                     and dal = nvl(comp.al, s_data_limite) + 1
                   group by ottica
                           ,dal;
               exception
                  when no_data_found then
                     d_revisione := to_number(null);
               end;
               if d_revisione is not null then
                  begin
                     update componenti
                        set revisione_cessazione = d_revisione
                           ,utente_aggiornamento = s_error_user
                           ,data_aggiornamento   = trunc(sysdate)
                      where id_componente = comp.id_componente;
                  exception
                     when others then
                        registra_errore(p_text     => substr('Update COMPONENTI: (' ||
                                                             comp.id_componente || ') ' ||
                                                             sqlerrm
                                                            ,1
                                                            ,2000)
                                       ,p_usertext => d_usertext
                                       ,p_session  => d_session);
                  end;
                  registra_info(p_text     => 'Aggiornata revisione cessazione componente: Id. ' ||
                                              comp.id_componente || ' ' ||
                                              comp.revisione_cessazione || ' -'||'> ' ||
                                              d_revisione
                               ,p_usertext => d_usertext
                               ,p_session  => d_session);
               else
                  -- Se non esiste una revisione alla data AL + 1, si annulla
                  -- la revisione di cessazione
                  begin
                     update componenti
                        set revisione_cessazione = to_number(null)
                           ,utente_aggiornamento = s_error_user
                           ,data_aggiornamento   = trunc(sysdate)
                      where id_componente = comp.id_componente;
                  exception
                     when others then
                        registra_errore(p_text     => substr('Update COMPONENTI: (' ||
                                                             comp.id_componente || ' ' ||
                                                             to_char(comp.al
                                                                    ,'dd/mm/yyyy') || ') ' ||
                                                             sqlerrm
                                                            ,1
                                                            ,2000)
                                       ,p_usertext => d_usertext
                                       ,p_session  => d_session);
                  end;
                  registra_info(p_text     => 'Annullata revisione cessazione: Id. ' ||
                                              comp.id_componente
                               ,p_usertext => d_usertext
                               ,p_session  => d_session);
               end if;
            end if;
         end if;
      end loop;
      --
      registra_info(p_text    => d_usertext || ' - Fine elaborazione: ' ||
                                 to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_session => d_session);
      --
      --commit;
      --
   end;
   -------------------------------------------------------------------------------
   procedure comp_controllo_3(p_tipo_elaborazione number) is
      /******************************************************************************
      NOME:        comp_controllo_3.
      DESCRIZIONE: COMPONENTI: controlla la congruenza tra dal e
                   dal_pubb.
      RITORNA:     //
      NOTE:        Il controllo viene eseguito sull'intera tabella.
                   P_tipo_elaborazione = 1: si esegue solo il controllo;
                   P_tipo_elaborazione = 2: si esegue la rettifica dei dati.
       REVISIONI:
       Rev.  Data        Autore   Descrizione
       ----  ----------  ------   ----------------------------------------------------
       0     07/10/2014  VDAVALLI Prima emissione.
      ******************************************************************************/
      d_usertext key_error_log.error_usertext%type := 'COMP_CONTROLLO_3 - Congruenza dal e dal_pubb';
      d_dal_pubb componenti.dal_pubb%type;
      d_session  key_error_log.error_session%type := 400006;
   begin
      registra_info(p_text    => d_usertext || ' - Inizio elaborazione: ' ||
                                 to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_session => d_session);
      --
      if p_tipo_elaborazione = 2 then
         --
         -- Disabilitazione triggers COMPONENTI
         --
         begin
            execute immediate 'alter trigger COMPONENTI_TIU disable';
         exception
            when others then
               raise_application_error(-20999
                                      ,'Disabilitazione triggers COMPONENTI - ' ||
                                       sqlerrm);
         end;
      end if;
      --
      -- Controllo componenti con dal non nullo e dal_pubb nullo
      -- (il controllo viene eseguito solo in assenza di revisioni in modifica)
      --
      for comp in (select id_componente
                         ,c.ottica
                         ,revisione_assegnazione
                     from componenti      c
                         ,ottiche         o
                         ,amministrazioni a
                    where c.ottica = o.ottica
                      and o.ottica = s_ottica
                      and o.amministrazione = a.codice_amministrazione
                      and a.ente = 'SI'
                      and c.dal is not null
                      and c.dal_pubb is null
                    order by 1)
      loop
         if p_tipo_elaborazione = 1 then
            -- solo controllo
            registra_info(p_text     => 'DAL_PUBB nullo: Id. ' || comp.id_componente
                         ,p_usertext => d_usertext
                         ,p_session  => d_session);
         else
            -- rettifica dati
            -- ricerca revisione assegnazione del componente: se esiste, si aggiorna 
            -- il dal_pubb con la data pubblicazione della revisione,
            -- altrimenti si usa il dal
            if comp.revisione_assegnazione is not null then
               begin
                  select data_pubblicazione
                    into d_dal_pubb
                    from revisioni_struttura
                   where ottica = comp.ottica
                     and revisione = comp.revisione_assegnazione;
               exception
                  when no_data_found then
                     d_dal_pubb := to_date(null);
               end;
            else
               d_dal_pubb := to_date(null);
            end if;
            begin
               update componenti
                  set dal_pubb             = nvl(d_dal_pubb, dal)
                     ,utente_aggiornamento = s_error_user
                     ,data_aggiornamento   = trunc(sysdate)
                where id_componente = comp.id_componente;
            exception
               when others then
                  registra_errore(p_text     => substr('Update COMPONENTI: (' ||
                                                       comp.id_componente || ') ' ||
                                                       sqlerrm
                                                      ,1
                                                      ,2000)
                                 ,p_usertext => d_usertext
                                 ,p_session  => d_session);
            end;
            registra_info(p_text     => 'Aggiornato dal pubblicazione componente: Id. ' ||
                                        comp.id_componente
                         ,p_usertext => d_usertext
                         ,p_session  => d_session);
         end if;
      end loop;
      --
      -- Controllo componenti con dal nullo e dal_pubb non nullo
      --
      for comp in (select id_componente
                         ,c.ottica
                     from componenti      c
                         ,ottiche         o
                         ,amministrazioni a
                    where c.ottica = o.ottica
                      and o.ottica = s_ottica
                      and o.amministrazione = a.codice_amministrazione
                      and a.ente = 'SI'
                      and c.dal is null
                      and c.dal_pubb is not null
                    order by 1)
      loop
         if p_tipo_elaborazione = 1 then
            -- solo controllo
            registra_info(p_text     => 'DAL nullo e DAL_PUBB non nullo: Id. ' ||
                                        comp.id_componente
                         ,p_usertext => d_usertext
                         ,p_session  => d_session);
         else
            -- rettifica dati
            -- si annulla il dal_pubb
            begin
               update componenti
                  set dal_pubb             = to_date(null)
                     ,utente_aggiornamento = s_error_user
                     ,data_aggiornamento   = trunc(sysdate)
                where id_componente = comp.id_componente;
            exception
               when others then
                  registra_errore(p_text     => substr('Update COMPONENTI: (' ||
                                                       comp.id_componente || ') ' ||
                                                       sqlerrm
                                                      ,1
                                                      ,2000)
                                 ,p_usertext => d_usertext
                                 ,p_session  => d_session);
            end;
            registra_info(p_text     => 'Annullato dal pubblicazione componente: Id. ' ||
                                        comp.id_componente
                         ,p_usertext => d_usertext
                         ,p_session  => d_session);
         end if;
      end loop;
      --
      if p_tipo_elaborazione = 2 then
         --
         -- Abilitazione triggers COMPONENTI
         --
         begin
            execute immediate 'alter trigger COMPONENTI_TIU enable';
         exception
            when others then
               raise_application_error(-20999
                                      ,'Abilitazione triggers COMPONENTI - ' || sqlerrm);
         end;
      end if;
      --
      registra_info(p_text    => d_usertext || ' - Fine elaborazione: ' ||
                                 to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_session => d_session);
      --
      --commit;
      --
   end;
   -------------------------------------------------------------------------------
   procedure comp_controllo_4(p_tipo_elaborazione number) is
      /******************************************************************************
      NOME:        comp_controllo_4.
      DESCRIZIONE: COMPONENTI: controlla la congruenza tra al e
                   al_pubb.
      RITORNA:     //
      NOTE:        Il controllo viene eseguito sull'intera tabella.
                   P_tipo_elaborazione = 1: si esegue solo il controllo;
                   P_tipo_elaborazione = 2: si esegue la rettifica dei dati.
       REVISIONI:
       Rev.  Data        Autore   Descrizione
       ----  ----------  ------   ----------------------------------------------------
       0     07/10/2014  VDAVALLI Prima emissione.
      ******************************************************************************/
      d_usertext key_error_log.error_usertext%type := 'COMP_CONTROLLO_4 - Congruenza al e al_pubb';
      d_dal_pubb componenti.dal_pubb%type;
      d_session  key_error_log.error_session%type := 400007;
   begin
      registra_info(p_text    => d_usertext || ' - Inizio elaborazione: ' ||
                                 to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_session => d_session);
      --
      if p_tipo_elaborazione = 2 then
         --
         -- Disabilitazione triggers COMPONENTI
         --
         begin
            execute immediate 'alter trigger COMPONENTI_TIU disable';
         exception
            when others then
               raise_application_error(-20999
                                      ,'Disabilitazione triggers COMPONENTI - ' ||
                                       sqlerrm);
         end;
      end if;
      --
      -- Controllo componenti con al non nullo e al_pubb nullo
      -- (il controllo viene eseguito solo in assenza di revisioni in modifica)
      --
      for comp in (select id_componente
                         ,c.ottica
                         ,revisione_cessazione
                     from componenti      c
                         ,ottiche         o
                         ,amministrazioni a
                    where c.ottica = o.ottica
                      and o.ottica = s_ottica
                      and o.amministrazione = a.codice_amministrazione
                      and a.ente = 'SI'
                      and c.al is not null
                      and c.al_pubb is null
                    order by 1)
      loop
         if p_tipo_elaborazione = 1 then
            -- solo controllo
            registra_info(p_text     => 'AL_PUBB nullo: Id. ' || comp.id_componente
                         ,p_usertext => d_usertext
                         ,p_session  => d_session);
         else
            -- rettifica dati
            -- ricerca revisione cessazione del componente: se esiste, si aggiorna 
            -- l'al_pubb con la data pubblicazione della revisione - 1,
            -- altrimenti si usa l'al
            if comp.revisione_cessazione is not null then
               begin
                  select data_pubblicazione
                    into d_dal_pubb
                    from revisioni_struttura
                   where ottica = comp.ottica
                     and revisione = comp.revisione_cessazione;
               exception
                  when no_data_found then
                     d_dal_pubb := to_date(null);
               end;
            else
               d_dal_pubb := to_date(null);
            end if;
            begin
               update componenti
                  set al_pubb              = decode(d_dal_pubb
                                                   ,to_date(null)
                                                   ,al
                                                   ,d_dal_pubb - 1)
                     ,utente_aggiornamento = s_error_user
                     ,data_aggiornamento   = trunc(sysdate)
                where id_componente = comp.id_componente;
            exception
               when others then
                  registra_errore(p_text     => substr('Update COMPONENTI: (' ||
                                                       comp.id_componente || ') ' ||
                                                       sqlerrm
                                                      ,1
                                                      ,2000)
                                 ,p_usertext => d_usertext
                                 ,p_session  => d_session);
            end;
            registra_info(p_text     => 'Aggiornato al pubblicazione componente: Id. ' ||
                                        comp.id_componente
                         ,p_usertext => d_usertext
                         ,p_session  => d_session);
         end if;
      end loop;
      --
      -- Controllo componenti con al nullo e al_pubb non nullo
      --
      for comp in (select id_componente
                         ,c.ottica
                     from componenti      c
                         ,ottiche         o
                         ,amministrazioni a
                    where c.ottica = o.ottica
                      and o.ottica = s_ottica
                      and o.amministrazione = a.codice_amministrazione
                      and a.ente = 'SI'
                      and c.al is null
                      and c.al_pubb is not null
                    order by 1)
      loop
         if p_tipo_elaborazione = 1 then
            -- solo controllo
            registra_info(p_text     => 'AL nullo e AL_PUBB non nullo: Id. ' ||
                                        comp.id_componente
                         ,p_usertext => d_usertext
                         ,p_session  => d_session);
         else
            -- rettifica dati
            -- si annulla il al_pubb
            begin
               update componenti
                  set al_pubb              = to_date(null)
                     ,utente_aggiornamento = s_error_user
                     ,data_aggiornamento   = trunc(sysdate)
                where id_componente = comp.id_componente;
            exception
               when others then
                  registra_errore(p_text     => substr('Update COMPONENTI: (' ||
                                                       comp.id_componente || ') ' ||
                                                       sqlerrm
                                                      ,1
                                                      ,2000)
                                 ,p_usertext => d_usertext
                                 ,p_session  => d_session);
            end;
            registra_info(p_text     => 'Annullato al pubblicazione componente: Id. ' ||
                                        comp.id_componente
                         ,p_usertext => d_usertext
                         ,p_session  => d_session);
         end if;
      end loop;
      --
      if p_tipo_elaborazione = 2 then
         --
         -- Abilitazione triggers COMPONENTI
         --
         begin
            execute immediate 'alter trigger COMPONENTI_TIU enable';
         exception
            when others then
               raise_application_error(-20999
                                      ,'Abilitazione triggers COMPONENTI - ' || sqlerrm);
         end;
      end if;
      --
      registra_info(p_text    => d_usertext || ' - ' || 'Fine elaborazione: ' ||
                                 to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_session => d_session);
      --
      --commit;
      --
   end;
   -------------------------------------------------------------------------------
   procedure atco_controllo_1(p_tipo_elaborazione number) is
      /******************************************************************************
      NOME:        atco_controllo_1.
      DESCRIZIONE: ATTRIBUTI_COMPONENTE: controlla la congruenza tra data 
                   inizio validita' (DAL) e revisione assegnazione.
      RITORNA:     //
      NOTE:        Il controllo viene eseguito solo sui componenti assegnati
                   in ottiche gestite a revisione.
                   P_tipo_elaborazione = 1: si esegue solo il controllo;
                   P_tipo_elaborazione = 2: si esegue la rettifica dei dati.
      ******************************************************************************/
      d_usertext  key_error_log.error_usertext%type := 'ATCO_CONTROLLO_1 - Congruenza revisione assegnazione e dal';
      d_session   key_error_log.error_session%type := 400008;
      d_dal       revisioni_struttura.dal%type;
      d_revisione revisioni_struttura.revisione%type;
   begin
      registra_info(p_text    => d_usertext || ' - Inizio elaborazione: ' ||
                                 to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_session => d_session);
      --
      for atco in (select id_attr_componente
                         ,dal
                         ,a.ottica ottica
                         ,revisione_assegnazione
                     from attributi_componente a
                         ,ottiche              o
                    where a.ottica = o.ottica
                      and o.ottica = s_ottica
                      and o.gestione_revisioni = 'SI'
                      and a.revisione_assegnazione is not null
                      and a.dal <= nvl(a.al, s_data_limite)
                      and not exists (select 'x'
                             from revisioni_struttura r
                            where r.ottica = a.ottica
                              and r.revisione = a.revisione_assegnazione
                              and r.dal = a.dal)
                    order by 1)
      loop
         d_dal := revisione_struttura.get_dal(p_ottica    => atco.ottica
                                             ,p_revisione => atco.revisione_assegnazione);
         if d_dal is null then
            registra_errore(p_text     => 'Revisione non presente: ' || atco.ottica || '/' ||
                                          atco.revisione_assegnazione || ' - Id. ' ||
                                          atco.id_attr_componente
                           ,p_usertext => d_usertext
                           ,p_session  => d_session);
         else
            if p_tipo_elaborazione = 1 then
               -- solo controllo
               registra_info(p_text     => 'DAL incongruente: Id. ' ||
                                           atco.id_attr_componente || ' Revisione nr. ' ||
                                           atco.revisione_assegnazione || ' ' ||
                                           to_char(atco.dal, 'dd/mm/yyyy') || ' ' ||
                                           to_char(d_dal, 'dd/mm/yyyy')
                            ,p_usertext => d_usertext
                            ,p_session  => d_session);
            else
               -- rettifica dati
               -- ricerca revisione alla data dell'assegnazione: se esiste, si aggiorna la revisione
               begin
                  select min(revisione)
                    into d_revisione
                    from revisioni_struttura
                   where ottica = atco.ottica
                     and dal = atco.dal
                   group by ottica
                           ,dal;
               exception
                  when no_data_found then
                     d_revisione := to_number(null);
               end;
               if d_revisione is not null then
                  begin
                     update attributi_componente
                        set revisione_assegnazione = d_revisione
                           ,utente_aggiornamento   = s_error_user
                           ,data_aggiornamento     = trunc(sysdate)
                      where id_attr_componente = atco.id_attr_componente;
                  exception
                     when others then
                        registra_errore(p_text     => substr('Update ATTRIBUTI_COMPONENTE: (' ||
                                                             atco.id_attr_componente || ') ' ||
                                                             sqlerrm
                                                            ,1
                                                            ,2000)
                                       ,p_usertext => d_usertext
                                       ,p_session  => d_session);
                  end;
                  registra_info(p_text     => 'Aggiornata revisione assegnazione componente: Id. ' ||
                                              atco.id_attr_componente || ' ' ||
                                              atco.revisione_assegnazione || ' -'||'> ' ||
                                              d_revisione
                               ,p_usertext => d_usertext
                               ,p_session  => d_session);
               else
                  -- Se non esiste una revisione alla data AL + 1, si annulla
                  -- la revisione di cessazione
                  begin
                     update attributi_componente
                        set revisione_assegnazione = to_number(null)
                           ,utente_aggiornamento   = s_error_user
                           ,data_aggiornamento     = trunc(sysdate)
                      where id_attr_componente = atco.id_attr_componente;
                  exception
                     when others then
                        registra_errore(p_text     => substr('Update ATTRIBUTI_COMPONENTE: (' ||
                                                             atco.id_attr_componente || ' ' ||
                                                             to_char(atco.dal
                                                                    ,'dd/mm/yyyy') || ') ' ||
                                                             sqlerrm
                                                            ,1
                                                            ,2000)
                                       ,p_usertext => d_usertext
                                       ,p_session  => d_session);
                  end;
                  registra_info(p_text     => 'Annullata revisione assegnazione: Id. ' ||
                                              atco.id_attr_componente
                               ,p_usertext => d_usertext
                               ,p_session  => d_session);
               end if;
            end if;
         end if;
      end loop;
      --
      registra_info(p_text    => d_usertext || ' - Fine elaborazione: ' ||
                                 to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_session => d_session);
      --
      --commit;
      --
   end;
   -------------------------------------------------------------------------------
   procedure atco_controllo_2(p_tipo_elaborazione number) is
      /******************************************************************************
      NOME:        atco_controllo_2.
      DESCRIZIONE: ATTRIBUTI_COMPONENTE: controlla la congruenza tra data 
                   fine validita' (AL) e revisione cessazione.
      RITORNA:     //
      NOTE:        Il controllo viene eseguito solo sui componenti assegnati
                   in ottiche gestite a revisione.
                   P_tipo_elaborazione = 1: si esegue solo il controllo;
                   P_tipo_elaborazione = 2: si esegue la rettifica dei dati.
      ******************************************************************************/
      d_usertext  key_error_log.error_usertext%type := 'ATCO_CONTROLLO_2 - Congruenza revisione cessazione e al';
      d_session   key_error_log.error_session%type := 400009;
      d_dal       revisioni_struttura.dal%type;
      d_revisione revisioni_struttura.revisione%type;
   begin
      registra_info(p_text    => d_usertext || ' - Inizio elaborazione: ' ||
                                 to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_session => d_session);
      --
      for atco in (select id_attr_componente
                         ,al
                         ,a.ottica ottica
                         ,revisione_cessazione
                     from attributi_componente a
                         ,ottiche              o
                    where a.ottica = o.ottica
                      and o.ottica = s_ottica
                      and o.gestione_revisioni = 'SI'
                      and a.revisione_cessazione is not null
                      and a.dal <= nvl(a.al, s_data_limite)
                      and not exists
                    (select 'x'
                             from revisioni_struttura r
                            where r.ottica = a.ottica
                              and r.revisione = a.revisione_cessazione
                              and r.dal = nvl(a.al, s_data_limite) + 1)
                    order by 1)
      loop
         d_dal := revisione_struttura.get_dal(p_ottica    => atco.ottica
                                             ,p_revisione => atco.revisione_cessazione);
         if d_dal is null then
            registra_errore(p_text     => 'Revisione non presente: ' || atco.ottica || '/' ||
                                          atco.revisione_cessazione || ' - Id. ' ||
                                          atco.id_attr_componente
                           ,p_usertext => d_usertext
                           ,p_session  => d_session);
         else
            if p_tipo_elaborazione = 1 then
               -- solo controllo
               registra_info(p_text     => 'AL incongruente: Id. ' ||
                                           atco.id_attr_componente || ' Revisione nr. ' ||
                                           atco.revisione_cessazione || ' ' ||
                                           to_char(atco.al, 'dd/mm/yyyy') || ' ' ||
                                           to_char(d_dal - 1, 'dd/mm/yyyy')
                            ,p_usertext => d_usertext
                            ,p_session  => d_session);
            else
               -- rettifica dati
               -- ricerca revisione alla data dell'unita': se esiste, si aggiorna la revisione
               begin
                  select min(revisione)
                    into d_revisione
                    from revisioni_struttura
                   where ottica = atco.ottica
                     and dal = nvl(atco.al, s_data_limite) + 1
                   group by ottica
                           ,dal;
               exception
                  when no_data_found then
                     d_revisione := to_number(null);
               end;
               if d_revisione is not null then
                  begin
                     update attributi_componente
                        set revisione_cessazione = d_revisione
                           ,utente_aggiornamento = s_error_user
                           ,data_aggiornamento   = trunc(sysdate)
                      where id_attr_componente = atco.id_attr_componente;
                  exception
                     when others then
                        registra_errore(p_text     => substr('Update ATTRIBUTI_COMPONENTE: (' ||
                                                             atco.id_attr_componente || ') ' ||
                                                             sqlerrm
                                                            ,1
                                                            ,2000)
                                       ,p_usertext => d_usertext
                                       ,p_session  => d_session);
                  end;
                  registra_info(p_text     => 'Aggiornata revisione cessazione componente: Id. ' ||
                                              atco.id_attr_componente || ' ' ||
                                              atco.revisione_cessazione || ' -'||'> ' ||
                                              d_revisione
                               ,p_usertext => d_usertext
                               ,p_session  => d_session);
               else
                  -- Se non esiste una revisione alla data AL + 1, si annulla
                  -- la revisione di cessazione
                  begin
                     update attributi_componente
                        set revisione_cessazione = to_number(null)
                           ,utente_aggiornamento = s_error_user
                           ,data_aggiornamento   = trunc(sysdate)
                      where id_attr_componente = atco.id_attr_componente;
                  exception
                     when others then
                        registra_errore(p_text     => substr('Update ATTRIBUTI_COMPONENTE: (' ||
                                                             atco.id_attr_componente || ' ' ||
                                                             to_char(atco.al
                                                                    ,'dd/mm/yyyy') || ') ' ||
                                                             sqlerrm
                                                            ,1
                                                            ,2000)
                                       ,p_usertext => d_usertext
                                       ,p_session  => d_session);
                  end;
                  registra_info(p_text     => 'Annullata revisione cessazione: Id. ' ||
                                              atco.id_attr_componente
                               ,p_usertext => d_usertext
                               ,p_session  => d_session);
               end if;
            end if;
         end if;
      end loop;
      --
      registra_info(p_text    => d_usertext || ' - Fine elaborazione: ' ||
                                 to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_session => d_session);
      --
      --commit;
      --
   end;
   -------------------------------------------------------------------------------
   procedure atco_controllo_3(p_tipo_elaborazione number) is
      /******************************************************************************
      NOME:        atco_controllo_3.
      DESCRIZIONE: ATTRIBUTI_COMPONENTE: controlla la congruenza tra dal e
                   dal_pubb.
      RITORNA:     //
      NOTE:        Il controllo viene eseguito sull'intera tabella.
                   P_tipo_elaborazione = 1: si esegue solo il controllo;
                   P_tipo_elaborazione = 2: si esegue la rettifica dei dati.
       REVISIONI:
       Rev.  Data        Autore   Descrizione
       ----  ----------  ------   ----------------------------------------------------
       0     07/10/2014  VDAVALLI Prima emissione.
      ******************************************************************************/
      d_usertext key_error_log.error_usertext%type := 'ATCO_CONTROLLO_3 - Congruenza dal e dal_pubb';
      d_dal_pubb componenti.dal_pubb%type;
      d_session  key_error_log.error_session%type := 400010;
   begin
      registra_info(p_text    => d_usertext || ' - Inizio elaborazione: ' ||
                                 to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_session => d_session);
      --
      if p_tipo_elaborazione = 2 then
         --
         -- Disabilitazione triggers ATTRIBUTI_COMPONENTE
         --
         begin
            execute immediate 'alter trigger ATTRIBUTI_COMPONENTE_TIU disable';
         exception
            when others then
               raise_application_error(-20999
                                      ,'Disabilitazione triggers ATTRIBUTI_COMPONENTE - ' ||
                                       sqlerrm);
         end;
      end if;
      --
      -- Controllo attributi_componente con dal non nullo e dal_pubb nullo
      -- (il controllo viene eseguito solo in assenza di revisioni in modifica)
      --
      for atco in (select id_attr_componente
                         ,c.ottica
                         ,revisione_assegnazione
                     from attributi_componente c
                         ,ottiche              o
                         ,amministrazioni      a
                    where c.ottica = o.ottica
                      and o.ottica = s_ottica
                      and o.amministrazione = a.codice_amministrazione
                      and a.ente = 'SI'
                      and c.dal is not null
                      and c.dal_pubb is null
                    order by 1)
      loop
         if p_tipo_elaborazione = 1 then
            -- solo controllo
            registra_info(p_text     => 'DAL_PUBB nullo: Id. ' || atco.id_attr_componente
                         ,p_usertext => d_usertext
                         ,p_session  => d_session);
         else
            -- rettifica dati
            -- ricerca revisione assegnazione dell'attributo_componente: 
            -- se esiste, si aggiorna il dal_pubb con la data pubblicazione 
            -- della revisione, altrimenti si usa il dal
            if atco.revisione_assegnazione is not null then
               begin
                  select data_pubblicazione
                    into d_dal_pubb
                    from revisioni_struttura
                   where ottica = atco.ottica
                     and revisione = atco.revisione_assegnazione;
               exception
                  when no_data_found then
                     d_dal_pubb := to_date(null);
               end;
            else
               d_dal_pubb := to_date(null);
            end if;
            begin
               update attributi_componente
                  set dal_pubb             = nvl(d_dal_pubb, dal)
                     ,utente_aggiornamento = s_error_user
                     ,data_aggiornamento   = trunc(sysdate)
                where id_attr_componente = atco.id_attr_componente;
            exception
               when others then
                  registra_errore(p_text     => substr('Update ATTRIBUTI_COMPONENTE: (' ||
                                                       atco.id_attr_componente || ') ' ||
                                                       sqlerrm
                                                      ,1
                                                      ,2000)
                                 ,p_usertext => d_usertext
                                 ,p_session  => d_session);
            end;
            registra_info(p_text     => 'Aggiornato dal pubblicazione attributo componente: Id. ' ||
                                        atco.id_attr_componente
                         ,p_usertext => d_usertext
                         ,p_session  => d_session);
         end if;
      end loop;
      --
      -- Controllo attributi_componente con dal nullo e dal_pubb non nullo
      --
      for atco in (select id_attr_componente
                         ,c.ottica
                     from attributi_componente c
                         ,ottiche              o
                         ,amministrazioni      a
                    where c.ottica = o.ottica
                      and o.ottica = s_ottica
                      and o.amministrazione = a.codice_amministrazione
                      and a.ente = 'SI'
                      and c.dal is null
                      and c.dal_pubb is not null
                    order by 1)
      loop
         if p_tipo_elaborazione = 1 then
            -- solo controllo
            registra_info(p_text     => 'DAL nullo e DAL_PUBB non nullo: Id. ' ||
                                        atco.id_attr_componente
                         ,p_usertext => d_usertext
                         ,p_session  => d_session);
         else
            -- rettifica dati
            -- si annulla il dal_pubb
            begin
               update attributi_componente
                  set dal_pubb             = to_date(null)
                     ,utente_aggiornamento = s_error_user
                     ,data_aggiornamento   = trunc(sysdate)
                where id_attr_componente = atco.id_attr_componente;
            exception
               when others then
                  registra_errore(p_text     => substr('Update ATTRIBUTI_COMPONENTE: (' ||
                                                       atco.id_attr_componente || ') ' ||
                                                       sqlerrm
                                                      ,1
                                                      ,2000)
                                 ,p_usertext => d_usertext
                                 ,p_session  => d_session);
            end;
            registra_info(p_text     => 'Anullato dal pubblicazione attributo componente: Id. ' ||
                                        atco.id_attr_componente
                         ,p_usertext => d_usertext
                         ,p_session  => d_session);
         end if;
      end loop;
      --
      if p_tipo_elaborazione = 2 then
         --
         -- Abilitazione triggers ATTRIBUTI_COMPONENTE
         --
         begin
            execute immediate 'alter trigger ATTRIBUTI_COMPONENTE_TIU enable';
         exception
            when others then
               raise_application_error(-20999
                                      ,'Abilitazione triggers ATTRIBUTI_COMPONENTE - ' ||
                                       sqlerrm);
         end;
      end if;
      --
      registra_info(p_text    => d_usertext || ' - Fine elaborazione: ' ||
                                 to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_session => d_session);
      --
      --commit;
      --
   end;
   -------------------------------------------------------------------------------
   procedure atco_controllo_4(p_tipo_elaborazione number) is
      /******************************************************************************
      NOME:        atco_controllo_4.
      DESCRIZIONE: ATTRIBUTI_COMPONENTE: controlla la congruenza tra al e
                   al_pubb.
      RITORNA:     //
      NOTE:        Il controllo viene eseguito sull'intera tabella.
                   P_tipo_elaborazione = 1: si esegue solo il controllo;
                   P_tipo_elaborazione = 2: si esegue la rettifica dei dati.
       REVISIONI:
       Rev.  Data        Autore   Descrizione
       ----  ----------  ------   ----------------------------------------------------
       0     07/10/2014  VDAVALLI Prima emissione.
      ******************************************************************************/
      d_usertext key_error_log.error_usertext%type := 'ATCO_CONTROLLO_4 - Congruenza al e al_pubb';
      d_dal_pubb componenti.dal_pubb%type;
      d_session  key_error_log.error_session%type := 400011;
   begin
      registra_info(p_text    => d_usertext || ' - Inizio elaborazione: ' ||
                                 to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_session => d_session);
      --
      if p_tipo_elaborazione = 2 then
         --
         -- Disabilitazione triggers ATTRIBUTI_COMPONENTE
         --
         begin
            execute immediate 'alter trigger ATTRIBUTI_COMPONENTE_TIU disable';
         exception
            when others then
               raise_application_error(-20999
                                      ,'Disabilitazione triggers ATTRIBUTI_COMPONENTE - ' ||
                                       sqlerrm);
         end;
      end if;
      --
      -- Controllo attributi_componente con al non nullo e al_pubb nullo
      -- (il controllo viene eseguito solo in assenza di revisioni in modifica)
      --
      for atco in (select id_attr_componente
                         ,c.ottica
                         ,revisione_cessazione
                     from attributi_componente c
                         ,ottiche              o
                         ,amministrazioni      a
                    where c.ottica = o.ottica
                      and o.ottica = s_ottica
                      and o.amministrazione = a.codice_amministrazione
                      and a.ente = 'SI'
                      and c.al is not null
                      and c.al_pubb is null
                    order by 1)
      loop
         if p_tipo_elaborazione = 1 then
            -- solo controllo
            registra_info(p_text     => 'AL_PUBB nullo: Id. ' || atco.id_attr_componente
                         ,p_usertext => d_usertext
                         ,p_session  => d_session);
         else
            -- rettifica dati
            -- ricerca revisione cessazione del componente: se esiste, si aggiorna 
            -- l'al_pubb con la data pubblicazione della revisione - 1,
            -- altrimenti si usa l'al
            if atco.revisione_cessazione is not null then
               begin
                  select data_pubblicazione
                    into d_dal_pubb
                    from revisioni_struttura
                   where ottica = atco.ottica
                     and revisione = atco.revisione_cessazione;
               exception
                  when no_data_found then
                     d_dal_pubb := to_date(null);
               end;
            else
               d_dal_pubb := to_date(null);
            end if;
            begin
               update attributi_componente
                  set al_pubb              = decode(d_dal_pubb
                                                   ,to_date(null)
                                                   ,al
                                                   ,d_dal_pubb - 1)
                     ,utente_aggiornamento = s_error_user
                     ,data_aggiornamento   = trunc(sysdate)
                where id_attr_componente = atco.id_attr_componente;
            exception
               when others then
                  registra_errore(p_text     => substr('Update ATTRIBUTI_COMPONENTE: (' ||
                                                       atco.id_attr_componente || ') ' ||
                                                       sqlerrm
                                                      ,1
                                                      ,2000)
                                 ,p_usertext => d_usertext
                                 ,p_session  => d_session);
            end;
            registra_info(p_text     => 'Aggiornato al pubblicazione attributo componente: Id. ' ||
                                        atco.id_attr_componente
                         ,p_usertext => d_usertext
                         ,p_session  => d_session);
         end if;
      end loop;
      --
      -- Controllo componenti con al nullo e al_pubb non nullo
      --
      for atco in (select id_attr_componente
                         ,c.ottica
                     from attributi_componente c
                         ,ottiche              o
                         ,amministrazioni      a
                    where c.ottica = o.ottica
                      and o.ottica = s_ottica
                      and o.amministrazione = a.codice_amministrazione
                      and a.ente = 'SI'
                      and c.al is null
                      and c.al_pubb is not null
                    order by 1)
      loop
         if p_tipo_elaborazione = 1 then
            -- solo controllo
            registra_info(p_text     => 'AL nullo e AL_PUBB non nullo: Id. ' ||
                                        atco.id_attr_componente
                         ,p_usertext => d_usertext
                         ,p_session  => d_session);
         else
            -- rettifica dati
            -- si annulla il al_pubb
            begin
               update attributi_componente
                  set al_pubb              = to_date(null)
                     ,utente_aggiornamento = s_error_user
                     ,data_aggiornamento   = trunc(sysdate)
                where id_attr_componente = atco.id_attr_componente;
            exception
               when others then
                  registra_errore(p_text     => substr('Update ATTRIBUTI_COMPONENTE: (' ||
                                                       atco.id_attr_componente || ') ' ||
                                                       sqlerrm
                                                      ,1
                                                      ,2000)
                                 ,p_usertext => d_usertext
                                 ,p_session  => d_session);
            end;
            registra_info(p_text     => 'Annullato al pubblicazione attributo componente: Id. ' ||
                                        atco.id_attr_componente
                         ,p_usertext => d_usertext
                         ,p_session  => d_session);
         end if;
      end loop;
      --
      if p_tipo_elaborazione = 2 then
         --
         -- Abilitazione triggers ATTRIBUTI_COMPONENTE
         --
         begin
            execute immediate 'alter trigger ATTRIBUTI_COMPONENTE_TIU enable';
         exception
            when others then
               raise_application_error(-20999
                                      ,'Abilitazione triggers ATTRIBUTI_COMPONENTE - ' ||
                                       sqlerrm);
         end;
      end if;
      --
      registra_info(p_text    => d_usertext || ' - Fine elaborazione: ' ||
                                 to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_session => d_session);
      --
      --commit;
      --
   end;
   -------------------------------------------------------------------------------
   procedure chk_fk(p_tipo_elaborazione number) is
      /******************************************************************************
      NOME:        chk_fk.
      DESCRIZIONE: Controlli generali sulle foreign keys non precedentemente trattate
      RITORNA:     //
      NOTE:        P_tipo_elaborazione = 1: si esegue solo il controllo;
                   P_tipo_elaborazione = 2: si esegue la rettifica dei dati.
       REVISIONI:
       Rev.  Data        Autore   Descrizione
       ----  ----------  ------   ----------------------------------------------------
       0     03/06/2015  MMONARI Prima emissione.
      ******************************************************************************/
      d_usertext key_error_log.error_usertext%type := 'CHK_FK - Integrita'' foreign keys';
      d_dal_unor unita_organizzative.dal%type;
      d_al_unor  unita_organizzative.al%type;
      d_session  key_error_log.error_session%type := 400012;
   begin
      registra_info(p_text    => d_usertext || ' - Inizio elaborazione: ' ||
                                 to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_session => d_session);
      --
      -- Table COMPONENTI
      --
      if p_tipo_elaborazione = 2 then
         --
         -- Disabilitazione triggers COMPONENTI
         --
         begin
            execute immediate 'alter trigger COMPONENTI_TIU disable';
         exception
            when others then
               raise_application_error(-20999
                                      ,'Disabilitazione triggers COMPONENTI - ' ||
                                       sqlerrm);
         end;
      end if;
      --
      -- Controllo UO
      --
      d_usertext := 'CHK FK Componenti';
      for comp in (select id_componente
                         ,dal
                         ,al
                         ,ottica
                         ,progr_unita_organizzativa
                         ,(select count(*)
                             from unita_organizzative
                            where progr_unita_organizzativa = c.progr_unita_organizzativa
                              and ottica = c.ottica
                              and dal <= nvl(c.al, to_date(3333333, 'j'))
                              and nvl(al, to_date(3333333, 'j')) >= c.dal) uo
                     from componenti c
                    where ottica = s_ottica
                      and dal <= nvl(al, to_date(3333333, 'j'))
                      and (not exists
                           (select 'x'
                              from unita_organizzative
                             where ottica = c.ottica
                               and progr_unita_organizzativa = c.progr_unita_organizzativa
                               and c.dal between dal and nvl(al, to_date(3333333, 'j'))) or
                           not exists
                           (select 'x'
                              from unita_organizzative
                             where ottica = c.ottica
                               and progr_unita_organizzativa = c.progr_unita_organizzativa
                               and nvl(c.al, to_date(3333333, 'j')) between dal and
                                   nvl(al, to_date(3333333, 'j'))))
                    order by 1)
      loop
         -- revisione_assegnazione
         if p_tipo_elaborazione = 1 then
            -- solo controllo
            if comp.uo = 0 then
               registra_info(p_text     => 'UO non presente in struttura Id. ' ||
                                           comp.id_componente || ' (progr. ' ||
                                           comp.progr_unita_organizzativa || ')'
                            ,p_usertext => d_usertext
                            ,p_session  => d_session);
            else
               registra_info(p_text     => 'UO non presente in struttura per l''intero periodo. Id. ' ||
                                           comp.id_componente || ' (progr. ' ||
                                           comp.progr_unita_organizzativa || ')'
                            ,p_usertext => d_usertext
                            ,p_session  => d_session);
            
            end if;
         else
            -- rettifica dati
            -- assesta gli estremi del periodo di componenti nel caso la presenza della UO in struttura
            -- intersechi il periodo di componenti
            if comp.uo > 0 then
               select min(dal)
                     ,max(al)
                 into d_dal_unor
                     ,d_al_unor
                 from unita_organizzative
                where ottica = comp.ottica
                  and progr_unita_organizzativa = comp.progr_unita_organizzativa;
               begin
                  update componenti c
                     set dal = greatest(c.dal, d_dal_unor)
                        ,al  = decode(least(nvl(c.al, to_date(3333333, 'j'))
                                           ,nvl(d_al_unor, to_date(3333333, 'j')))
                                     ,to_date(3333333, 'j')
                                     ,to_date(null)
                                     ,least(nvl(c.al, to_date(3333333, 'j'))
                                           ,nvl(d_al_unor, to_date(3333333, 'j'))))
                   where id_componente = comp.id_componente;
               
                  registra_info(p_text     => 'UO non presente in struttura per l''intero periodo. Aggiornato record COMPONENTI Id. ' ||
                                              comp.id_componente || ' (progr. ' ||
                                              comp.progr_unita_organizzativa || ')'
                               ,p_usertext => d_usertext
                               ,p_session  => d_session);
               exception
                  when others then
                     registra_errore(p_text     => substr('Update COMPONENTI: (' ||
                                                          comp.id_componente || ') ' ||
                                                          sqlerrm
                                                         ,1
                                                         ,2000)
                                    ,p_usertext => d_usertext
                                    ,p_session  => d_session);
               end;
            else
               registra_errore(p_text     => 'UO non presente in struttura, non e'' possibile correggere il componente. Id. ' ||
                                             comp.id_componente || ' (progr. ' ||
                                             comp.progr_unita_organizzativa || ')'
                              ,p_usertext => d_usertext
                              ,p_session  => d_session);
            end if;
         end if;
      end loop;
      --
      -- Controllo componenti con incarico nullo o non definito
      -- Rileva attributi componente che afferiscono a componenti inesistenti
      --
      d_usertext := 'CHK FK Attributi Componente';
      for atco in (select a.id_attr_componente
                         ,a.id_componente
                         ,(select count(*)
                             from componenti
                            where id_componente = a.id_componente) componente
                         ,a.ottica
                         ,a.incarico
                     from attributi_componente a
                    where ottica = s_ottica
                      and (incarico is null or not exists
                           (select 'x' from tipi_incarico i where i.incarico = a.incarico) or
                           not exists (select 'x'
                                         from componenti c
                                        where c.id_componente = a.id_componente))
                    order by 1)
      loop
         if p_tipo_elaborazione = 1 then
            -- solo controllo
            if atco.componente = 0 then
               registra_errore(p_text     => 'Attributo : Id. ' ||
                                             atco.id_attr_componente ||
                                             ' - Componente inesistente'
                              ,p_usertext => d_usertext
                              ,p_session  => d_session);
            else
               if atco.incarico is null then
                  registra_info(p_text     => 'Incarico nullo : Id. ' ||
                                              atco.id_attr_componente
                               ,p_usertext => d_usertext
                               ,p_session  => d_session);
               else
                  registra_info(p_text     => 'Incarico errato : Id. ' ||
                                              atco.id_attr_componente || ' - Incarico : ' ||
                                              atco.incarico
                               ,p_usertext => d_usertext
                               ,p_session  => d_session);
               end if;
            end if;
         else
            -- rettifica dati
            -- se l'incarico è nullo settiamo quello di default
            -- se l'incarico non è definito, settiamo quello di default e
            -- registriamo il precedente in un campo non utilizzato
            if atco.id_componente = 0 then
               -- id componente inesistente: eliminiamo la registrazione figlia di nessuno
               begin
                  delete from attributi_componente
                   where id_componente = atco.id_componente
                     and id_attr_componente = atco.id_attr_componente;
               
                  registra_info(p_text     => 'Attributo : Id. ' ||
                                              atco.id_attr_componente ||
                                              ' - Componente inesistente. Attributo eliminato.'
                               ,p_usertext => d_usertext
                               ,p_session  => d_session);
               exception
                  when others then
                     registra_errore(p_text     => substr('Delete ATTRIBUTI: (' ||
                                                          atco.id_attr_componente || ') ' ||
                                                          sqlerrm
                                                         ,1
                                                         ,2000)
                                    ,p_usertext => d_usertext
                                    ,p_session  => d_session);
               end;
            end if;
            if atco.incarico is null then
               begin
                  update attributi_componente
                     set incarico = s_incarico
                   where id_attr_componente = atco.id_attr_componente;
               exception
                  when others then
                     registra_errore(p_text     => substr('Update incarico nullo ATTRIBUTI_COMPONENTE: (' ||
                                                          atco.id_attr_componente || ') ' ||
                                                          sqlerrm
                                                         ,1
                                                         ,2000)
                                    ,p_usertext => d_usertext
                                    ,p_session  => d_session);
               end;
            else
               begin
                  update attributi_componente
                     set fax                  = fax || ' i.' || atco.incarico
                        ,incarico             = s_incarico
                        ,utente_aggiornamento = s_error_user
                        ,data_aggiornamento   = trunc(sysdate)
                   where id_attr_componente = atco.id_attr_componente;
               exception
                  when others then
                     registra_errore(p_text     => substr('Update incarico errato ATTRIBUTI_COMPONENTE: (' ||
                                                          atco.id_attr_componente || ') ' ||
                                                          sqlerrm
                                                         ,1
                                                         ,2000)
                                    ,p_usertext => d_usertext
                                    ,p_session  => d_session);
               end;
            end if;
         end if;
      end loop;
      --
      -- Controllo ruoli componente con ruolo errato o su componenti inesistenti
      --
      d_usertext := 'CHK FK Ruoli Componente';
      for ruco in (select r.id_ruolo_componente
                         ,r.ruolo
                         ,r.id_componente
                         ,(select count(*)
                             from componenti
                            where id_componente = r.id_componente) componente
                         ,decode(ruolo
                                ,upper(ruolo)
                                ,' Errato '
                                ,' con codice minuscolo ') errore
                     from ruoli_componente r
                    where (not exists (select 'x' from ad4_ruoli a where a.ruolo = r.ruolo) or
                           ruolo <> upper(ruolo) or not exists
                           (select 'x'
                              from componenti c
                             where c.id_componente = r.id_componente))
                      and exists (select 'x'
                             from componenti
                            where id_componente = r.id_componente
                              and ottica = s_ottica)
                    order by 1)
      loop
         if p_tipo_elaborazione = 1 then
            if ruco.componente = 0 then
               registra_errore(p_text     => 'Ruolo : Id. ' || ruco.id_ruolo_componente ||
                                             ' - Componente inesistente'
                              ,p_usertext => d_usertext
                              ,p_session  => d_session);
            else
               registra_info(p_text     => 'Ruolo' || ruco.errore || ' : Id. ' ||
                                           ruco.id_ruolo_componente || ' - Ruolo : ' ||
                                           ruco.ruolo
                            ,p_usertext => d_usertext
                            ,p_session  => d_session);
            end if;
         else
            -- rettifica dati non eseguibile
            if ruco.id_componente = 0 then
               -- id componente inesistente: eliminiamo la registrazione figlia di nessuno
               begin
                  delete from ruoli_componente
                   where id_componente = ruco.id_componente
                     and id_ruolo_componente = ruco.id_ruolo_componente;
               
                  registra_info(p_text     => 'Ruolo : Id. ' || ruco.id_ruolo_componente ||
                                              ' - Componente inesistente. Ruolo eliminato.'
                               ,p_usertext => d_usertext
                               ,p_session  => d_session);
               exception
                  when others then
                     registra_errore(p_text     => substr('Delete RUOLI: (' ||
                                                          ruco.id_ruolo_componente || ') ' ||
                                                          sqlerrm
                                                         ,1
                                                         ,2000)
                                    ,p_usertext => d_usertext
                                    ,p_session  => d_session);
               end;
            else
               registra_errore(p_text     => substr('Update Ruolo errato non eseguibile : (id. ' ||
                                                    ruco.id_ruolo_componente ||
                                                    ') ruolo : ' || ruco.ruolo
                                                   ,1
                                                   ,2000)
                              ,p_usertext => d_usertext
                              ,p_session  => d_session);
            end if;
         end if;
      end loop;
      --
      -- Controllo ubicazioni componente con ubicazione unita' errata o su componenti inesistenti
      --
      d_usertext := 'CHK FK Ubicazioni Componente';
      for ubco in (select u.id_ubicazione_componente
                         ,u.id_ubicazione_unita
                         ,u.id_componente
                         ,(select count(*)
                             from componenti
                            where id_componente = u.id_componente) componente
                     from ubicazioni_componente u
                    where (not exists
                           (select 'x'
                              from ubicazioni_unita uu
                             where uu.id_ubicazione = u.id_ubicazione_unita) or not exists
                           (select 'x'
                              from componenti c
                             where c.id_componente = u.id_componente))
                      and exists (select 'x'
                             from componenti
                            where id_componente = u.id_componente
                              and ottica = s_ottica)
                    order by 1)
      loop
         if p_tipo_elaborazione = 1 then
            --solo controlli
            if ubco.componente = 0 then
               registra_errore(p_text     => 'Ubicazione componente : Id. ' ||
                                             ubco.id_ubicazione_componente ||
                                             ' - Componente inesistente'
                              ,p_usertext => d_usertext
                              ,p_session  => d_session);
            else
               registra_info(p_text     => 'Ubicazione componente errata : Id. ' ||
                                           ubco.id_ubicazione_componente ||
                                           ' - Ubicazione unita'' : ' ||
                                           ubco.id_ubicazione_unita
                            ,p_usertext => d_usertext
                            ,p_session  => d_session);
            end if;
         else
            -- rettifica dati non eseguibile
            if ubco.componente = 0 then
               -- id componente inesistente: eliminiamo la registrazione figlia di nessuno
               begin
                  delete from ubicazioni_componente
                   where id_componente = ubco.id_componente
                     and id_ubicazione_componente = ubco.id_ubicazione_componente;
               
                  registra_info(p_text     => 'Ubicazione : Id. ' ||
                                              ubco.id_ubicazione_componente ||
                                              ' - Componente inesistente. Ubicazione eliminata.'
                               ,p_usertext => d_usertext
                               ,p_session  => d_session);
               exception
                  when others then
                     registra_errore(p_text     => substr('Delete UBICAZIONI : (' ||
                                                          ubco.id_ubicazione_componente || ') ' ||
                                                          sqlerrm
                                                         ,1
                                                         ,2000)
                                    ,p_usertext => d_usertext
                                    ,p_session  => d_session);
               end;
            else
               registra_errore(p_text     => substr('Update Ubicazione errata non eseguibile : (id. ' ||
                                                    ubco.id_ubicazione_componente ||
                                                    ') ubicazione : ' ||
                                                    ubco.id_ubicazione_unita
                                                   ,1
                                                   ,2000)
                              ,p_usertext => d_usertext
                              ,p_session  => d_session);
            end if;
         end if;
      end loop;
      --
      -- Controllo imputazioni componente su componenti inesistenti
      --
      d_usertext := 'CHK FK Imputazioni Bilancio';
      for imbi in (select i.id_imputazione
                         ,i.id_componente
                     from imputazioni_bilancio i
                    where not exists (select 'x'
                             from componenti c
                            where c.id_componente = i.id_componente)
                      and exists (select 'x'
                             from componenti
                            where id_componente = i.id_componente
                              and ottica = s_ottica)
                    order by 1)
      loop
         if p_tipo_elaborazione = 1 then
            --solo controlli
            registra_errore(p_text     => 'Impuzione bilancio : Id. ' ||
                                          imbi.id_imputazione ||
                                          ' - Componente inesistente'
                           ,p_usertext => d_usertext
                           ,p_session  => d_session);
         else
            begin
               delete from imputazioni_bilancio i
                where id_componente = imbi.id_componente
                  and id_imputazione = imbi.id_imputazione;
            
               registra_info(p_text     => 'Imputazione : Id. ' || imbi.id_componente ||
                                           ' - Componente inesistente. Imputazione eliminata.'
                            ,p_usertext => d_usertext
                            ,p_session  => d_session);
            exception
               when others then
                  registra_errore(p_text     => substr('Delete IMPUTAZIONI : (' ||
                                                       imbi.id_componente || ') ' ||
                                                       sqlerrm
                                                      ,1
                                                      ,2000)
                                 ,p_usertext => d_usertext
                                 ,p_session  => d_session);
            end;
         end if;
      end loop;
      if p_tipo_elaborazione = 2 then
         --
         -- Abilitazione triggers ATTRIBUTI_COMPONENTE
         --
         begin
            execute immediate 'alter trigger ATTRIBUTI_COMPONENTE_TIU enable';
         exception
            when others then
               raise_application_error(-20999
                                      ,'Abilitazione triggers ATTRIBUTI_COMPONENTE - ' ||
                                       sqlerrm);
         end;
      end if;
      --
      registra_info(p_text    => d_usertext || ' - Fine elaborazione: ' ||
                                 to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_session => d_session);
      --
      --commit;
      --
   end;
   -------------------------------------------------------------------------------
   procedure chk_fi(p_tipo_elaborazione number) is
      /******************************************************************************
      NOME:        chk_fi.
      DESCRIZIONE: -Controlli funzionali sui componenti
                   Assegnazioni prevalenti sovrapposte per soggetto
      RITORNA:     //
      NOTE:        P_tipo_elaborazione = 1: si esegue solo il controllo;
                   P_tipo_elaborazione = 2: si esegue la rettifica dei dati.
       REVISIONI:
       Rev.  Data        Autore   Descrizione
       ----  ----------  ------   ----------------------------------------------------
       0     03/06/2015  MMONARI Prima emissione.
      ******************************************************************************/
      d_usertext key_error_log.error_usertext%type := 'CHK_FI - Controlli funzionali sui componenti';
      d_dal_unfi unita_fisiche.dal%type;
      d_al_unfi  unita_fisiche.al%type;
      d_session  key_error_log.error_session%type := 400012;
   begin
      registra_info(p_text    => d_usertext || ' - Inizio elaborazione: ' ||
                                 to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_session => d_session);
      if p_tipo_elaborazione = 2 then
         --
         -- Disabilitazione triggers COMPONENTI
         --
         begin
            execute immediate 'alter trigger COMPONENTI_TIU disable';
         exception
            when others then
               raise_application_error(-20999
                                      ,'Disabilitazione triggers COMPONENTI - ' ||
                                       sqlerrm);
         end;
      end if;
      --
      -- Controllo
      --
      d_usertext := 'Assegnazioni Prevalenti sovrapposte per NI ';
      for asfi in (select a.id_asfi
                         ,a.id_ubicazione_componente
                         ,a.ni
                         ,a.progr_unita_fisica
                         ,dal
                         ,al
                         ,a.progr_unita_organizzativa
                         ,(select count(*)
                             from ubicazioni_componente
                            where id_ubicazione_componente = a.id_ubicazione_componente) ubicazione
                         ,(select count(*) from anagrafe_soggetti where ni = a.ni) soggetto
                         ,(select count(*)
                             from unita_fisiche
                            where progr_unita_fisica = a.progr_unita_fisica
                              and dal <= nvl(a.al, to_date(3333333, 'j'))
                              and nvl(al, to_date(3333333, 'j')) >= a.dal) uf
                         ,(select count(*)
                             from unita_fisiche
                            where progr_unita_fisica = a.progr_unita_fisica
                              and a.dal between dal and nvl(al, to_date(3333333, 'j'))) dal_uf
                         ,(select count(*)
                             from unita_fisiche
                            where progr_unita_fisica = a.progr_unita_fisica
                              and nvl(a.al, to_date(3333333, 'j')) between dal and
                                  nvl(al, to_date(3333333, 'j'))) al_uf
                         ,(select count(*)
                             from unita_organizzative
                            where progr_unita_organizzativa = a.progr_unita_organizzativa
                              and dal <= nvl(a.al, to_date(3333333, 'j'))
                              and nvl(al, to_date(3333333, 'j')) >= a.dal) uo
                     from assegnazioni_fisiche a
                    order by 1)
      loop
         if p_tipo_elaborazione = 1 then
            -- solo controllo
            -- soggetto
            if asfi.soggetto = 0 then
               registra_info(p_text     => 'Soggetto non presente in anagrafe Id. ' ||
                                           asfi.id_asfi || ' (NI. ' || asfi.ni || ')'
                            ,p_usertext => d_usertext
                            ,p_session  => d_session);
            end if;
            -- ubicazione
            if asfi.ubicazione = 0 then
               registra_info(p_text     => 'Ubicazione non presente Id. ' || asfi.id_asfi ||
                                           ' (Id ubicazione. ' || asfi.ubicazione || ')'
                            ,p_usertext => d_usertext
                            ,p_session  => d_session);
            end if;
            -- unita' fisica
            if asfi.uf = 0 then
               registra_info(p_text     => 'Unità fisica non definita per il periodo Id. ' ||
                                           asfi.id_asfi || ' (Progr. ' ||
                                           asfi.progr_unita_fisica || ')'
                            ,p_usertext => d_usertext
                            ,p_session  => d_session);
            elsif asfi.dal_uf = 0 or asfi.al_uf = 0 then
               registra_info(p_text     => 'Unità fisica definita solo in parte per il periodo Id. ' ||
                                           asfi.id_asfi || ' (Progr. ' ||
                                           asfi.progr_unita_fisica || ')'
                            ,p_usertext => d_usertext
                            ,p_session  => d_session);
            end if;
            -- unita' organizzativa
            if asfi.uf = 0 and asfi.progr_unita_organizzativa is not null then
               registra_info(p_text     => 'Unità organizzativa non definita per il periodo Id. ' ||
                                           asfi.id_asfi || ' (Progr. ' ||
                                           asfi.progr_unita_organizzativa || ')'
                            ,p_usertext => d_usertext
                            ,p_session  => d_session);
            end if;
         else
            -- rettifica dati
            -- soggetto
            if asfi.soggetto = 0 then
               registra_errore(p_text     => 'Soggetto non presente in anagrafe Id. ' ||
                                             asfi.id_asfi || ' (NI. ' || asfi.ni ||
                                             '). Correzione non possibile'
                              ,p_usertext => d_usertext
                              ,p_session  => d_session);
            end if;
            -- ubicazione
            if asfi.ubicazione = 0 then
               registra_errore(p_text     => 'Ubicazione non presente Id. ' ||
                                             asfi.id_asfi || ' (Id ubicazione. ' ||
                                             asfi.ubicazione ||
                                             '). Correzione non possibile'
                              ,p_usertext => d_usertext
                              ,p_session  => d_session);
            end if;
            -- unita' fisica
            if asfi.uf = 0 then
               registra_errore(p_text     => 'Unità fisica non definita per il periodo Id. ' ||
                                             asfi.id_asfi || ' (Progr. ' ||
                                             asfi.progr_unita_fisica ||
                                             '). Correzione non possibile'
                              ,p_usertext => d_usertext
                              ,p_session  => d_session);
            end if;
            -- unita' organizzativa
            if asfi.uf = 0 and asfi.progr_unita_organizzativa is not null then
               registra_errore(p_text     => 'Unità organizzativa non definita per il periodo Id. ' ||
                                             asfi.id_asfi || ' (Progr. ' ||
                                             asfi.progr_unita_organizzativa ||
                                             '). Correzione non possibile'
                              ,p_usertext => d_usertext
                              ,p_session  => d_session);
            end if;
            -- assesta gli estremi del periodo di componenti nel caso la presenza della UO in struttura
            -- intersechi il periodo di componenti
            if asfi.uf > 0 and (asfi.dal_uf = 0 or asfi.al_uf = 0) then
               select min(dal)
                     ,max(al)
                 into d_dal_unfi
                     ,d_al_unfi
                 from unita_fisiche
                where progr_unita_fisica = asfi.progr_unita_fisica;
               begin
                  update assegnazioni_fisiche a
                     set dal = greatest(a.dal, d_dal_unfi)
                        ,al  = decode(least(nvl(a.al, to_date(3333333, 'j'))
                                           ,nvl(d_al_unfi, to_date(3333333, 'j')))
                                     ,to_date(3333333, 'j')
                                     ,to_date(null)
                                     ,least(nvl(a.al, to_date(3333333, 'j'))
                                           ,nvl(d_al_unfi, to_date(3333333, 'j'))))
                   where id_asfi = asfi.id_asfi;
               
                  registra_info(p_text     => 'UF non presente in struttura per l''intero periodo. Aggiornato record ASSEGNAZIONI FISICHE Id. ' ||
                                              asfi.id_asfi || ' (progr. ' ||
                                              asfi.progr_unita_fisica || ')'
                               ,p_usertext => d_usertext
                               ,p_session  => d_session);
               exception
                  when others then
                     registra_errore(p_text     => substr('Update ASSEGNAZIONE FISICA: (' ||
                                                          asfi.id_asfi || ') ' || sqlerrm
                                                         ,1
                                                         ,2000)
                                    ,p_usertext => d_usertext
                                    ,p_session  => d_session);
               end;
            end if;
         end if;
      end loop;
      if p_tipo_elaborazione = 2 then
         --
         -- Abilitazione triggers ATTRIBUTI_COMPONENTE
         --
         begin
            execute immediate 'alter trigger ATTRIBUTI_COMPONENTE_TIU enable';
         exception
            when others then
               raise_application_error(-20999
                                      ,'Abilitazione triggers ATTRIBUTI_COMPONENTE - ' ||
                                       sqlerrm);
         end;
      end if;
      --
      registra_info(p_text    => d_usertext || ' - Fine elaborazione: ' ||
                                 to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_session => d_session);
      --
      --commit;
      --
   end;
   -------------------------------------------------------------------------------
   procedure chk_assegnazioni_fisiche(p_tipo_elaborazione number) is
      /******************************************************************************
      NOME:        chk_assegnazioni_fisiche.
      DESCRIZIONE: -Controlli generali sulle assegnazioni fisiche-
                   Esistenza del soggetto
                   Integrita' storica dell'unita' fisica
                   Integrita' storica dell'unita' organizzativa
                   Esistenza dell'eventuale id_ubicazione_componente
      RITORNA:     //
      NOTE:        P_tipo_elaborazione = 1: si esegue solo il controllo;
                   P_tipo_elaborazione = 2: si esegue la rettifica dei dati.
       REVISIONI:
       Rev.  Data        Autore   Descrizione
       ----  ----------  ------   ----------------------------------------------------
       0     03/06/2015  MMONARI Prima emissione.
      ******************************************************************************/
      d_usertext key_error_log.error_usertext%type := 'CHK_ASFI - Controlli assegnazioni fisiche';
      d_dal_unfi unita_fisiche.dal%type;
      d_al_unfi  unita_fisiche.al%type;
      d_dal_ubco ubicazioni_componente.dal%type;
      d_al_ubco  ubicazioni_componente.al%type;
      d_session  key_error_log.error_session%type := 400012;
   begin
      registra_info(p_text    => d_usertext || ' - Inizio elaborazione: ' ||
                                 to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_session => d_session);
      if p_tipo_elaborazione = 2 then
         --
         -- Disabilitazione triggers COMPONENTI
         --
         begin
            execute immediate 'alter trigger COMPONENTI_TIU disable';
         exception
            when others then
               raise_application_error(-20999
                                      ,'Disabilitazione triggers COMPONENTI - ' ||
                                       sqlerrm);
         end;
      end if;
      --
      -- Controllo
      --
      d_usertext := 'CHK Assegnazioni Fisiche';
      for asfi in (select a.id_asfi
                         ,a.id_ubicazione_componente
                         ,a.ni
                         ,a.progr_unita_fisica
                         ,dal
                         ,al
                         ,a.progr_unita_organizzativa
                         ,(select count(*)
                             from ubicazioni_componente
                            where id_ubicazione_componente = a.id_ubicazione_componente) ubicazione
                         ,(select count(*) from anagrafe_soggetti where ni = a.ni) soggetto
                         ,(select count(*)
                             from unita_fisiche
                            where progr_unita_fisica = a.progr_unita_fisica
                              and dal <= nvl(a.al, to_date(3333333, 'j'))
                              and nvl(al, to_date(3333333, 'j')) >= a.dal) uf
                         ,(select count(*)
                             from unita_fisiche
                            where progr_unita_fisica = a.progr_unita_fisica
                              and a.dal between dal and nvl(al, to_date(3333333, 'j'))) dal_uf
                         ,(select count(*)
                             from unita_fisiche
                            where progr_unita_fisica = a.progr_unita_fisica
                              and nvl(a.al, to_date(3333333, 'j')) between dal and
                                  nvl(al, to_date(3333333, 'j'))) al_uf
                         ,(select count(*)
                             from unita_organizzative
                            where progr_unita_organizzativa = a.progr_unita_organizzativa
                              and dal <= nvl(a.al, to_date(3333333, 'j'))
                              and nvl(al, to_date(3333333, 'j')) >= a.dal) uo
                     from assegnazioni_fisiche a
                    order by 1)
      loop
         if asfi.id_ubicazione_componente is not null then
            begin
               select 'x'
                 into s_dummy
                 from dual
                where exists
                (select 'x'
                         from ubicazioni_componente
                        where id_ubicazione_componente = asfi.id_ubicazione_componente
                          and dal = asfi.dal
                          and nvl(al, to_date(3333333, 'j')) =
                              nvl(asfi.al, to_date(3333333, 'j')));
            exception
               when no_data_found then
                  if p_tipo_elaborazione = 1 then
                     registra_info(p_text     => 'Periodo non congruente con l''ubicazione componente. Id. ' ||
                                                 asfi.id_asfi || ' (Id.ubicazione ' ||
                                                 asfi.id_ubicazione_componente || ')'
                                  ,p_usertext => d_usertext
                                  ,p_session  => d_session);
                  else
                     begin
                        select dal
                              ,al
                          into d_dal_ubco
                              ,d_al_ubco
                          from ubicazioni_componente
                         where id_ubicazione_componente = asfi.id_ubicazione_componente;
                     
                        update assegnazioni_fisiche a
                           set dal = d_dal_ubco
                              ,al  = d_al_ubco
                         where id_asfi = asfi.id_asfi;
                     
                        registra_info(p_text     => 'Assegnazione fisica non corrispondente a ubicazione componente. Aggiornato record ASSEGNAZIONI FISICHE Id. ' ||
                                                    asfi.id_asfi
                                     ,p_usertext => d_usertext
                                     ,p_session  => d_session);
                     exception
                        when others then
                           registra_errore(p_text     => substr('Update ASSEGNAZIONE FISICA: (' ||
                                                                asfi.id_asfi || ') ' ||
                                                                sqlerrm
                                                               ,1
                                                               ,2000)
                                          ,p_usertext => d_usertext
                                          ,p_session  => d_session);
                     end;
                  end if;
            end;
         end if;
         if p_tipo_elaborazione = 1 then
            -- solo controllo
            -- soggetto
            if asfi.soggetto = 0 then
               registra_info(p_text     => 'Soggetto non presente in anagrafe Id. ' ||
                                           asfi.id_asfi || ' (NI. ' || asfi.ni || ')'
                            ,p_usertext => d_usertext
                            ,p_session  => d_session);
            end if;
            -- ubicazione
            if asfi.ubicazione = 0 then
               registra_info(p_text     => 'Ubicazione non presente Id. ' || asfi.id_asfi ||
                                           ' (Id ubicazione. ' || asfi.ubicazione || ')'
                            ,p_usertext => d_usertext
                            ,p_session  => d_session);
            end if;
            -- unita' fisica
            if asfi.uf = 0 then
               registra_info(p_text     => 'Unità fisica non definita per il periodo Id. ' ||
                                           asfi.id_asfi || ' (Progr. ' ||
                                           asfi.progr_unita_fisica || ')'
                            ,p_usertext => d_usertext
                            ,p_session  => d_session);
            elsif asfi.dal_uf = 0 or asfi.al_uf = 0 then
               registra_info(p_text     => 'Unità fisica definita solo in parte per il periodo Id. ' ||
                                           asfi.id_asfi || ' (Progr. ' ||
                                           asfi.progr_unita_fisica || ')'
                            ,p_usertext => d_usertext
                            ,p_session  => d_session);
            end if;
            -- unita' organizzativa
            if asfi.uf = 0 and asfi.progr_unita_organizzativa is not null then
               registra_info(p_text     => 'Unità organizzativa non definita per il periodo Id. ' ||
                                           asfi.id_asfi || ' (Progr. ' ||
                                           asfi.progr_unita_organizzativa || ')'
                            ,p_usertext => d_usertext
                            ,p_session  => d_session);
            end if;
         else
            -- rettifica dati
            -- soggetto
            if asfi.soggetto = 0 then
               registra_errore(p_text     => 'Soggetto non presente in anagrafe Id. ' ||
                                             asfi.id_asfi || ' (NI. ' || asfi.ni ||
                                             '). Correzione non possibile'
                              ,p_usertext => d_usertext
                              ,p_session  => d_session);
            end if;
            -- ubicazione
            if asfi.ubicazione = 0 then
               registra_errore(p_text     => 'Ubicazione non presente Id. ' ||
                                             asfi.id_asfi || ' (Id ubicazione. ' ||
                                             asfi.ubicazione ||
                                             '). Correzione non possibile'
                              ,p_usertext => d_usertext
                              ,p_session  => d_session);
            end if;
            -- unita' fisica
            if asfi.uf = 0 then
               registra_errore(p_text     => 'Unità fisica non definita per il periodo Id. ' ||
                                             asfi.id_asfi || ' (Progr. ' ||
                                             asfi.progr_unita_fisica ||
                                             '). Correzione non possibile'
                              ,p_usertext => d_usertext
                              ,p_session  => d_session);
            end if;
            -- unita' organizzativa
            if asfi.uo = 0 and asfi.progr_unita_organizzativa is not null then
               registra_errore(p_text     => 'Unità organizzativa non definita per il periodo Id. ' ||
                                             asfi.id_asfi || ' (Progr. ' ||
                                             asfi.progr_unita_organizzativa ||
                                             '). Correzione non possibile'
                              ,p_usertext => d_usertext
                              ,p_session  => d_session);
            end if;
            -- assesta gli estremi del periodo di componenti nel caso la presenza della UO in struttura
            -- intersechi il periodo di componenti
            if asfi.uf > 0 and (asfi.dal_uf = 0 or asfi.al_uf = 0) then
               select min(dal)
                     ,max(al)
                 into d_dal_unfi
                     ,d_al_unfi
                 from unita_fisiche
                where progr_unita_fisica = asfi.progr_unita_fisica;
               begin
                  update assegnazioni_fisiche a
                     set dal = greatest(a.dal, d_dal_unfi)
                        ,al  = decode(least(nvl(a.al, to_date(3333333, 'j'))
                                           ,nvl(d_al_unfi, to_date(3333333, 'j')))
                                     ,to_date(3333333, 'j')
                                     ,to_date(null)
                                     ,least(nvl(a.al, to_date(3333333, 'j'))
                                           ,nvl(d_al_unfi, to_date(3333333, 'j'))))
                   where id_asfi = asfi.id_asfi;
               
                  registra_info(p_text     => 'UF non presente in struttura per l''intero periodo. Aggiornato record ASSEGNAZIONI FISICHE Id. ' ||
                                              asfi.id_asfi || ' (progr. ' ||
                                              asfi.progr_unita_fisica || ')'
                               ,p_usertext => d_usertext
                               ,p_session  => d_session);
               exception
                  when others then
                     registra_errore(p_text     => substr('Update ASSEGNAZIONE FISICA: (' ||
                                                          asfi.id_asfi || ') ' || sqlerrm
                                                         ,1
                                                         ,2000)
                                    ,p_usertext => d_usertext
                                    ,p_session  => d_session);
               end;
            end if;
         end if;
      end loop;
      if p_tipo_elaborazione = 2 then
         --
         -- Abilitazione triggers ATTRIBUTI_COMPONENTE
         --
         begin
            execute immediate 'alter trigger ATTRIBUTI_COMPONENTE_TIU enable';
         exception
            when others then
               raise_application_error(-20999
                                      ,'Abilitazione triggers ATTRIBUTI_COMPONENTE - ' ||
                                       sqlerrm);
         end;
      end if;
      --
      registra_info(p_text    => d_usertext || ' - Fine elaborazione: ' ||
                                 to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_session => d_session);
      --
      --commit;
      --
   end;
   -------------------------------------------------------------------------------
   procedure chk_rubrica(p_tipo_elaborazione number) is
      /******************************************************************************
      NOME:        chk_rubrica.
      DESCRIZIONE: Verifica la correttezza dei soggetti richiamati nella table soggetti_rubrica
      RITORNA:     //
      NOTE:        
      ******************************************************************************/
      d_usertext key_error_log.error_usertext%type := 'CHK_RUBRICA';
      d_session  key_error_log.error_session%type := 400001;
   begin
      registra_info(p_text    => d_usertext || ' - Inizio elaborazione: ' ||
                                 to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_session => d_session);
      --
      for sogg in (select distinct r.ni
                                  ,(select count(*) from anagrafe_soggetti where ni = r.ni) numero
                                  ,get_nominativo(r.ni) nominativo
                     from soggetti_rubrica r
                    order by ni)
      loop
         if p_tipo_elaborazione = 1 then
            -- solo controllo
            if sogg.numero = 0 then
               registra_info(p_text     => 'Soggetto non definito: ' || sogg.ni
                            ,p_usertext => d_usertext
                            ,p_session  => d_session);
            end if;
         else
            if sogg.numero = 0 then
               registra_info(p_text     => 'Soggetto non definito: ' || sogg.ni ||
                                           '; correzione non eseguibile'
                            ,p_usertext => d_usertext
                            ,p_session  => d_session);
            end if;
         end if;
      end loop;
      --
      registra_info(p_text    => d_usertext || ' - Fine elaborazione: ' ||
                                 to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_session => d_session);
      --
      --commit;
      dbms_output.put_line('Check soggetti - Fine');
      --
   end;
   -------------------------------------------------------------------------------
   procedure main
   (
      p_ottica            varchar2
     ,p_tipo_elaborazione number
   ) is
      /******************************************************************************
      NOME:        esegui_controlli.
      DESCRIZIONE: Esegue le procedure di controllo in sequenza.
      RITORNA:     //
      NOTE:        P_tipo_elaborazione = 1: si esegue solo il controllo;
                   P_tipo_elaborazione = 2: si esegue la rettifica dei dati.
      ******************************************************************************/
      d_usertext  key_error_log.error_usertext%type := 'CONTROLLI_COMPONENTI';
      d_session   key_error_log.error_session%type := 400000;
      d_errore    number(1);
      d_messaggio varchar2(32767);
   begin
      s_ottica := p_ottica;
      -- Controllo inserimento parametro tipo_elaborazione
      begin
         select 1 into d_errore from dual where p_tipo_elaborazione is null;
         raise too_many_rows;
      exception
         when no_data_found then
            null;
         when too_many_rows then
            d_messaggio := 'Inserire il parametro tipo_elaborazione';
            raise;
      end;
      -- Verifica l'esistenza di revisioni in modifica
      begin
         select 1 into d_errore from revisioni_struttura where stato = 'M';
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
          where error_session between 400000 and 499999
            and trunc(error_date) <= trunc(sysdate);
      exception
         when others then
            d_messaggio := 'Delete KEY_ERROR_LOG: ' || sqlerrm;
            raise;
      end;
      --
      --commit;
      --
      registra_info(p_text    => d_usertext || ' - ' || 'Inizio elaborazione: ' ||
                                 to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_session => d_session);
      --commit;
      --
      chk_soggetti(p_tipo_elaborazione => p_tipo_elaborazione);
      chk_incarichi(p_tipo_elaborazione => p_tipo_elaborazione);
      controllo_dipendenze(p_tipo_elaborazione => p_tipo_elaborazione);
      comp_controllo_1(p_tipo_elaborazione => p_tipo_elaborazione);
      comp_controllo_2(p_tipo_elaborazione => p_tipo_elaborazione);
      comp_controllo_3(p_tipo_elaborazione => p_tipo_elaborazione);
      comp_controllo_4(p_tipo_elaborazione => p_tipo_elaborazione);
      atco_controllo_1(p_tipo_elaborazione => p_tipo_elaborazione);
      atco_controllo_2(p_tipo_elaborazione => p_tipo_elaborazione);
      atco_controllo_3(p_tipo_elaborazione => p_tipo_elaborazione);
      atco_controllo_4(p_tipo_elaborazione => p_tipo_elaborazione);
      chk_fk(p_tipo_elaborazione => p_tipo_elaborazione);
      chk_assegnazioni_fisiche(p_tipo_elaborazione => p_tipo_elaborazione);
      chk_rubrica(p_tipo_elaborazione => p_tipo_elaborazione);
      --
      registra_info(p_text    => d_usertext || ' - ' || 'Fine elaborazione: ' ||
                                 to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
                   ,p_session => d_session);
      --commit;
      --
   exception
      when others then
         dbms_output.put_line(d_messaggio);
   end;
end controlli_componenti;
/

