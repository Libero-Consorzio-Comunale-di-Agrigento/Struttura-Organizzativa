CREATE OR REPLACE package body relazioni_ruoli_pkg is
   /******************************************************************************
    NOME:        relazioni_ruoli_pkg
    DESCRIZIONE: Gestione tabella RELAZIONI_RUOLI.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore      Descrizione.
    000   18/08/2015  mmonari  Generazione automatica 
   ******************************************************************************/
   s_revisione_body constant afc.t_revision := '000 - 18/08/2015';
   -- Variabili di appoggio per i parametri di ins, upd e del   /* SIAPKGen: generazione automatica */
   --   /* SIAPKGen: generazione automatica */
   s_error_table  afc_error.t_error_table;
   s_error_detail afc_error.t_error_table;
   --------------------------------------------------------------------------------
   function versione return varchar2 is
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
   end versione; -- relazioni_ruoli_pkg.versione
   --------------------------------------------------------------------------------
   function error_message(p_error_number in afc_error.t_error_number)
      return afc_error.t_error_msg is
      /******************************************************************************
       NOME:        error_message
       DESCRIZIONE: Messaggio previsto per il numero di eccezione indicato.
       NOTE:        Restituisce il messaggio abbinato al numero indicato nella tabella
                    s_error_table del Package. Se p_error_number non e presente nella
                    tabella s_error_table viene lanciata l'exception -20011 (vedi AFC_Error)
      ******************************************************************************/
      d_result afc_error.t_error_msg;
      d_detail afc_error.t_error_msg;
   begin
      if s_error_detail.exists(p_error_number) then
         d_detail := s_error_detail(p_error_number);
      end if;
      if s_error_table.exists(p_error_number) then
         d_result := s_error_table(p_error_number) || d_detail;
         s_error_detail(p_error_number) := '';
      else
         raise_application_error(afc_error.exception_not_in_table_number
                                ,afc_error.exception_not_in_table_msg);
      end if;
      return d_result;
   end error_message; -- relazioni_ruoli_pkg.error_message
   /*--------------------------------------------------------------------------------
   function is_<chk name>_ok
   ( p_<attributo>  in RELAZIONI_RUOLI.<attributo>%type
   , ...
   ) return AFC_Error.t_error_number
   \******************************************************************************
    NOME:        is_<chk name>_ok
    DESCRIZIONE: Controllo <chk name> ...
    PARAMETRI:   p_<attributo>
                 , ...
    NOTE:        --
   ******************************************************************************\
   is
      d_result AFC_Error.t_error_number := AFC_Error.ok;
   begin
      if <testo controllo>
      then
         d_result := AFC_Error.ok;
      else
         d_result := s_<exception_name>_num;
      end if;
      DbC.POST ( not DbC.PostOn or d_result = AFC_Error.ok or d_result < 0     
               , 'd_result = AFC_Error.ok or d_result < 0 on relazioni_ruoli_pkg.is_<chk name>_ok'
               );
      return d_result;
   end is_<chk name>_ok; -- relazioni_ruoli_pkg.is_<chk name>_ok
   --------------------------------------------------------------------------------
   function is_DI_ok
   ( p_<attributo> in RELAZIONI_RUOLI.<attributo>%type
   , ...
   ) return AFC_Error.t_error_number
   \******************************************************************************
    NOME:        is_DI_ok.
    DESCRIZIONE: Gestione della Data Integrity.
    PARAMETRI:   p_<attributo>
                 , ...
    RETURN:      1 se tutti i controlli danno esito positivo, l'error_code altrimenti
    NOTE:        --
   ******************************************************************************\
   is
      d_result AFC_Error.t_error_number := AFC_Error.ok;
   begin
      -- is_<chk name>_ok
      if( d_result = AFC_Error.ok )
      then
         d_result := is_<chk name>_ok ( p_<attributo>
                                      , ...
                                      );
      end if;
      DbC.POST ( not DbC.PostOn or d_result = AFC_Error.ok or d_result < 0 
               , 'd_result = AFC_Error.ok or d_result < 0 on relazioni_ruoli_pkg.is_DI_ok'
               );
      return d_result;
   end is_DI_ok; -- relazioni_ruoli_pkg.is_DI_ok
   --------------------------------------------------------------------------------
   procedure chk_DI
   ( p_<attributo> in RELAZIONI_RUOLI.<attributo>%type
   , ...
   ) is
   \******************************************************************************
    NOME:        chk_DI.
    DESCRIZIONE: Gestione della Data Integrity.
    PARAMETRI:  p_<attributo>
              , ...
    NOTE:        --
   ******************************************************************************\
      d_result AFC_Error.t_error_number := AFC_Error.ok;
      d_warning_num integer;
      d_warning_msg afc.t_statement;
      i integer := 1;
   begin
      -- Controllo degli eventuali contratti di DbC presenti nei metodi richiamati di seguito
      if not <condition>
      then
         d_result := s_<exception_name>_num;
      end if;
      -- check Data Integrity
      if d_result = AFC_Error.ok
      then
         d_result := is_DI_ok ( p_<attributo>
                              , ...
                              );
      end if;
      DbC.ASSERTION ( not DbC.AssertionOn or d_result = AFC_Error.ok or d_result < 0
                    , 'd_result = AFC_Error.ok or d_result < 0 on relazioni_ruoli_pkg.chk_DI'
                    );
      if not ( d_result = AFC_Error.ok )
      then
         raise_application_error ( d_result, error_message( d_result ) );
      elsif  d_result = AFC_Error.ok
      and    s_warning is not null
      then
         loop
            d_warning_num := substr( s_warning, i, 6 );
            if d_warning_num is null
            then
               exit;
            end if;
            d_warning_msg := d_warning_msg || chr(10) || '- ' || si4.GET_ERROR( error_message( d_warning_num ) );
            i := i + 6;
         end loop;
         s_warning := null;
         raise_application_error ( -20998, d_warning_msg );
      end if;
   end chk_DI; -- relazioni_ruoli_pkg.chk_DI
   --------------------------------------------------------------------------------
   function is_<chk name>_ok
   ( p_<attributo>  in RELAZIONI_RUOLI.<attributo>%type
   , ...
   ) return AFC_Error.t_error_number
   \******************************************************************************
    NOME:        is_<chk name>_ok
    DESCRIZIONE: Controllo <chk name> ...
    PARAMETRI:   p_<attributo>
                 , ...
    NOTE:        --
   ******************************************************************************\
   is
      d_result AFC_Error.t_error_number := AFC_Error.ok;
   begin
      if <testo controllo>
      then
         d_result := AFC_Error.ok;
      else
         d_result := s_<exception_name>_num;
      end if;
      DbC.POST ( not DbC.PostOn or d_result = AFC_Error.ok or d_result < 0     
               , 'd_result = AFC_Error.ok or d_result < 0 on relazioni_ruoli_pkg.is_<chk name>_ok'
               );
      return d_result;
   end is_<chk name>_ok; -- relazioni_ruoli_pkg.is_<chk name>_ok
   --------------------------------------------------------------------------------
   function is_RI_ok
   ( p_<attributo> in RELAZIONI_RUOLI.<attributo>%type
   , ...
   ) return AFC_Error.t_error_number
   \******************************************************************************
    NOME:        is_RI_ok.
    DESCRIZIONE: Gestione della Referential Integrity.
    PARAMETRI:   p_<attributo>
                 , ...
    RETURN:      1 se tutti i controlli danno esito positivo, l'error_code altrimenti
    NOTE:        --
   ******************************************************************************\
   is
      d_result AFC_Error.t_error_number := AFC_Error.ok;
   begin
      -- is_<chk name>_ok
      if( d_result = AFC_Error.ok )
      then
         d_result := is_<chk name>_ok ( p_<attributo>
                                      , ...
                                      );
      end if;
      DbC.POST ( not DbC.PostOn or d_result = AFC_Error.ok or d_result < 0 
               , 'd_result = AFC_Error.ok or d_result < 0 on relazioni_ruoli_pkg.is_RI_ok'
               );
      return d_result;
   end is_RI_ok; -- relazioni_ruoli_pkg.is_RI_ok
   --------------------------------------------------------------------------------
   procedure chk_RI
   ( p_<attributo> in RELAZIONI_RUOLI.<attributo>%type
   , ...
   ) is
   \******************************************************************************
    NOME:        chk_RI.
    DESCRIZIONE: Gestione della Referential Integrity.
    PARAMETRI:  p_<attributo>
                , ...
    NOTE:        --
   ******************************************************************************\
      d_result AFC_Error.t_error_number := AFC_Error.ok;
      d_warning_num integer;
      d_warning_msg afc.t_statement;
      i integer := 1;
   begin
      -- Controllo degli eventuali contratti di DbC presenti nei metodi richiamati di seguito
      if not <condition>
      then
         d_result := s_<exception_name>_num;
      end if;
      -- check Data Integrity
      if d_result = AFC_Error.ok
      then
         d_result := is_RI_ok ( p_<attributo>
                              , ...
                              );
      end if;
      DbC.ASSERTION ( not DbC.AssertionOn or d_result = AFC_Error.ok or d_result < 0
                    , 'd_result = AFC_Error.ok or d_result < 0 on relazioni_ruoli_pkg.chk_RI'
                    );
      if not ( d_result = AFC_Error.ok )
      then
         raise_application_error ( d_result, error_message( d_result ) );
      elsif  d_result = AFC_Error.ok
      and    s_warning is not null
      then
         loop
            d_warning_num := substr( s_warning, i, 6 );
            if d_warning_num is null
            then
               exit;
            end if;
            d_warning_msg := d_warning_msg || chr(10) || '- ' || si4.GET_ERROR( error_message( d_warning_num ) );
            i := i + 6;
         end loop;
         s_warning := null;
         raise_application_error ( -20998, d_warning_msg );
      end if;
   end chk_RI; -- relazioni_ruoli_pkg.chk_RI*/
   --------------------------------------------------------------------------------
   function get_numero_assegnazioni(p_id_relazione in relazioni_ruoli.id_relazione%type)
      return number is
      /******************************************************************************
       NOME:        get_numero_assegnazioni
       DESCRIZIONE: Calcola il numero di ruoli applicativi assegnati in basse alla regola indicata
      ******************************************************************************/
      d_result number(8);
   begin
      select count(distinct rc.id_componente)
        into d_result
        from ruoli_componente rc
            ,ruoli_derivati   rd
       where nvl(rc.al, to_date(3333333, 'j')) >= (select trunc(sysdate) from dual)
         and rc.id_ruolo_componente = rd.id_ruolo_componente
         and rd.id_relazione = p_id_relazione;
   
      return d_result;
   end get_numero_assegnazioni; -- relazioni_ruoli_pkg.get_numero_assegnazioni
   --------------------------------------------------------------------------------
   procedure set_fi
   (
      p_id_relazione       in relazioni_ruoli.id_relazione%type
     ,p_old_ottica         in relazioni_ruoli.ottica%type
     ,p_new_ottica         in relazioni_ruoli.ottica%type
     ,p_old_codice_uo      in relazioni_ruoli.codice_uo%type
     ,p_new_codice_uo      in relazioni_ruoli.codice_uo%type
     ,p_old_uo_discendenti in relazioni_ruoli.codice_uo%type
     ,p_new_uo_discendenti in relazioni_ruoli.codice_uo%type
     ,p_old_suddivisione   in relazioni_ruoli.suddivisione%type
     ,p_new_suddivisione   in relazioni_ruoli.suddivisione%type
     ,p_old_incarico       in relazioni_ruoli.incarico%type
     ,p_new_incarico       in relazioni_ruoli.incarico%type
     ,p_old_responsabile   in relazioni_ruoli.responsabile%type
     ,p_new_responsabile   in relazioni_ruoli.responsabile%type
     ,p_old_dipendente     in relazioni_ruoli.dipendente%type
     ,p_new_dipendente     in relazioni_ruoli.dipendente%type
     ,p_old_ruolo          in relazioni_ruoli.ruolo%type
     ,p_new_ruolo          in relazioni_ruoli.ruolo%type
     ,p_inserting          in number
     ,p_updating           in number
     ,p_deleting           in number
   ) is
      /******************************************************************************
       NOME:        set_FI.
       DESCRIZIONE: Impostazione functional integrity
       NOTE:        --
      ******************************************************************************/
      d_dummy                  varchar2(1);
      d_segnalazione_bloccante varchar2(2);
      d_segnalazione           varchar2(2000);
      d_contatore              number(8) := 0;
      d_id_ruolo_componente    ruoli_componente.id_ruolo_componente%type;
      d_al_ruolo               ruoli_componente.al%type;
      d_oggi                   date := trunc(sysdate);
   begin
      ruolo_componente.s_ruoli_automatici := 1;
      if nvl(registro_utility.leggi_stringa('PRODUCTS/SI4SO'
                                           ,'AttribuzioneAutomaticaRuoli'
                                           ,0)
            ,'NO') = 'SI' then
         if p_updating = 1 then
            for ruco in (select rc.id_ruolo_componente
                               ,rc.id_componente
                               ,rc.dal
                               ,rc.al
                               ,rd.id_ruolo_derivato
                               ,rc.data_aggiornamento
                           from ruoli_componente rc
                               ,ruoli_derivati   rd
                          where rd.id_ruolo_componente = rc.id_ruolo_componente
                            and rd.id_relazione = p_id_relazione
                            and rc.dal <= nvl(rc.al, to_date(3333333, 'j'))
                            and nvl(rc.al, to_date(3333333, 'j')) >= d_oggi
                          order by rc.id_componente
                                  ,rc.id_ruolo_componente)
            loop
               begin
                  select 'x'
                    into d_dummy
                    from assegnazioni_soggetti c
                   where id_componente = ruco.id_componente
                     and c.ottica like p_new_ottica
                        --
                        --and c.codice_uo like p_new_codice_uo
                     and ((c.codice_uo like p_new_codice_uo and
                         p_new_uo_discendenti = 'NO') or
                         ((select nvl(max('SI'), 'NO')
                              from dual
                             where exists
                             (select 'x'
                                      from relazioni_unita_organizzative
                                     where progr_figlio = c.progr_unita_organizzativa
                                       and cod_padre like p_new_codice_uo
                                       and al_figlio >= d_oggi)) = p_new_uo_discendenti and
                         p_new_uo_discendenti = 'SI'))
                        --
                     and c.suddivisione like p_new_suddivisione
                     and c.incarico like p_new_incarico
                     and c.responsabile like p_new_responsabile
                     and ((c.ci is not null and c.tipo_assegnazione = 'I' and
                         p_new_dipendente = 'SI') or p_new_dipendente = '%')
                     and nvl(c.al, to_date(3333333, 'j')) >= d_oggi
                     and p_old_ruolo = p_new_ruolo;
               exception
                  when no_data_found then
                     --il componente non corrisponde più alle nuove caratteristiche della regola; chiudiamo il ruolo
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
                  when too_many_rows then
                     null;
               end;
            end loop;
         end if;
      
         if p_inserting = 1 or p_updating = 1 then
            --attribuzione dei ruoli automatici ai componenti che corrispondono alle caratteristiche individuate dalla nuova regola         
            for comp in (select c.id_componente
                               ,c.dal
                               ,greatest(c.dal, d_oggi) dal_ruolo
                               ,c.al
                           from assegnazioni_soggetti c
                          where c.ottica like p_new_ottica
                               --    and c.codice_uo like p_new_codice_uo
                               --
                            and ((c.codice_uo like p_new_codice_uo and
                                p_new_uo_discendenti = 'NO') or
                                ((select nvl(max('SI'), 'NO')
                                     from dual
                                    where exists
                                    (select 'x'
                                             from relazioni_unita_organizzative
                                            where progr_figlio = c.progr_unita_organizzativa
                                              and cod_padre like p_new_codice_uo
                                              and al_figlio >= d_oggi)) =
                                p_new_uo_discendenti and p_new_uo_discendenti = 'SI'))
                               --
                            and c.suddivisione like p_new_suddivisione
                            and c.incarico like p_new_incarico
                            and c.responsabile like p_new_responsabile
                            and ((c.ci is not null and c.tipo_assegnazione = 'I' and
                                p_new_dipendente = 'SI') or p_new_dipendente = '%')
                            and nvl(c.al, to_date(3333333, 'j')) >= d_oggi
                            and not exists
                          (select 'x'
                                   from ruoli_derivati rd
                                  where rd.id_relazione = p_id_relazione
                                    and exists
                                  (select 'x'
                                           from ruoli_componente rc
                                          where id_componente = c.id_componente
                                            and id_ruolo_componente = rd.id_ruolo_componente
                                            and rc.dal <= nvl(rc.al, to_date(3333333, 'j'))))
                          order by 1)
            loop
               d_contatore := 0;
               begin
                  --verifica se il ruolo in fase di inserimento non sia già presente per il componente
                  select count(*)
                    into d_contatore
                    from ruoli_componente
                   where id_componente = comp.id_componente
                     and ruolo = p_new_ruolo
                     and dal <= nvl(comp.al, to_date(3333333, 'j'))
                     and nvl(al, to_date(3333333, 'j')) >= comp.dal_ruolo
                     and dal <= nvl(al, to_date(3333333, 'j'));
               
                  if d_contatore = 0 then
                     -- per il componente il ruolo non esiste, lo inseriamo
                     begin
                        select ruoli_componente_sq.nextval
                          into d_id_ruolo_componente
                          from dual;
                        --inserimento del ruolo_componente
                        ruolo_componente.ins(p_id_ruolo_componente => d_id_ruolo_componente
                                            ,p_id_componente       => comp.id_componente
                                            ,p_ruolo               => p_new_ruolo
                                            ,p_dal                 => greatest(comp.dal
                                                                              ,d_oggi)
                                            ,p_al                  => comp.al);
                     
                        ruoli_derivati_tpk.ins(p_id_ruolo_derivato   => ''
                                              ,p_id_ruolo_componente => d_id_ruolo_componente
                                              ,p_id_relazione        => p_id_relazione);
                     exception
                        when others then
                           d_segnalazione           := 'Attribuzione ruoli automatici terminata con errori';
                           d_segnalazione_bloccante := 'Y';
                     end;
                  else
                     /* inserisce gli eventuali spezzoni di periodo del ruolo che non sono gia' coperti da altre registrazioni
                        e relaziona i ruoli eeistenti alla nuova regola
                     */
                     begin
                        for ruco in (select id_ruolo_componente
                                           ,dal
                                           ,al
                                           ,(select count(*)
                                               from ruoli_derivati
                                              where id_ruolo_componente =
                                                    r1.id_ruolo_componente) ruolo_collettivo
                                       from ruoli_componente r1
                                      where id_componente = comp.id_componente
                                        and dal <= nvl(al, to_date(3333333, 'j'))
                                        and ruolo = p_new_ruolo
                                        and dal <= nvl(comp.al, to_date(3333333, 'j'))
                                        and nvl(al, to_date(3333333, 'j')) >=
                                            comp.dal_ruolo
                                     union
                                     select to_number(null)
                                           ,al + 1
                                           ,(select min(dal) - 1
                                              from ruoli_componente r1
                                             where id_componente = comp.id_componente
                                               and dal <= nvl(al, to_date(3333333, 'j'))
                                               and ruolo = p_new_ruolo
                                               and dal <=
                                                   nvl(comp.al, to_date(3333333, 'j'))
                                               and nvl(al, to_date(3333333, 'j')) >=
                                                   trunc(sysdate)
                                               and dal > r2.al + 1)
                                           ,to_number(null)
                                       from ruoli_componente r2
                                      where id_componente = comp.id_componente
                                        and dal <= nvl(al, to_date(3333333, 'j'))
                                        and ruolo = p_new_ruolo
                                        and dal <= nvl(comp.al, to_date(3333333, 'j'))
                                        and nvl(al, to_date(3333333, 'j')) >=
                                            comp.dal_ruolo
                                        and al is not null
                                        and not exists
                                      (select 'x'
                                               from ruoli_componente r3
                                              where id_componente = comp.id_componente
                                                and dal <= nvl(al, to_date(3333333, 'j'))
                                                and ruolo = p_new_ruolo
                                                and dal <=
                                                    nvl(comp.al, to_date(3333333, 'j'))
                                                and nvl(al, to_date(3333333, 'j')) >=
                                                    trunc(sysdate)
                                                and (r2.al + 1) between dal and
                                                    nvl(al, to_date(3333333, 'j')))
                                     union
                                     select to_number(null)
                                           ,greatest(comp.dal_ruolo, d_oggi)
                                           ,(select min(dal) - 1
                                              from ruoli_componente r1
                                             where id_componente = comp.id_componente
                                               and dal <= nvl(al, to_date(3333333, 'j'))
                                               and ruolo = p_new_ruolo
                                               and dal <=
                                                   nvl(comp.al, to_date(3333333, 'j'))
                                               and nvl(al, to_date(3333333, 'j')) >=
                                                   trunc(sysdate)
                                               and dal > trunc(sysdate))
                                           ,to_number(null)
                                       from dual
                                      where not exists
                                      (select 'x'
                                               from ruoli_componente
                                              where id_componente = comp.id_componente
                                                and dal <= nvl(al, to_date(3333333, 'j'))
                                                and ruolo = p_new_ruolo
                                                and dal <=
                                                    nvl(comp.al, to_date(3333333, 'j'))
                                                and dal = comp.dal_ruolo)
                                      order by 1)
                        loop
                           if ruco.id_ruolo_componente is not null and
                              ruco.ruolo_collettivo > 0 then
                              --inserimento del ruolo derivato per collegarlo anche alla nuova relazione
                              ruoli_derivati_tpk.ins(p_id_ruolo_derivato   => ''
                                                    ,p_id_ruolo_componente => ruco.id_ruolo_componente
                                                    ,p_id_relazione        => p_id_relazione);
                           elsif ruco.id_ruolo_componente is null then
                              --chiusura del ruolo preesistente 
                              update ruoli_componente r
                                 set al      = greatest(ruco.dal, d_oggi) - 1
                                    ,al_prec = al
                               where id_componente = comp.id_componente
                                 and ruolo = p_new_ruolo
                                 and greatest(ruco.dal, d_oggi) between dal and
                                     nvl(al, to_date(3333333, 'j'));
                           end if;
                           d_al_ruolo := ruco.al;
                           --inserimento del ruolo_componente
                           if ruco.id_ruolo_componente is null then
                              select ruoli_componente_sq.nextval
                                into d_id_ruolo_componente
                                from dual;
                           
                              ruolo_componente.ins(p_id_ruolo_componente => d_id_ruolo_componente
                                                  ,p_id_componente       => comp.id_componente
                                                  ,p_ruolo               => p_new_ruolo
                                                  ,p_dal                 => greatest(ruco.dal
                                                                                    ,d_oggi)
                                                  ,p_al                  => d_al_ruolo);
                           
                              ruoli_derivati_tpk.ins(p_id_ruolo_derivato   => ''
                                                    ,p_id_ruolo_componente => d_id_ruolo_componente
                                                    ,p_id_relazione        => p_id_relazione);
                           end if;
                           dbms_output.put_line(comp.id_componente || '------ ' ||
                                                ruco.dal || ' ------ ' || ruco.dal ||
                                                ' - ' || d_al_ruolo || '    :    ' ||
                                                ruco.id_ruolo_componente);
                        end loop;
                     end;
                  end if;
               end;
            
            end loop;
         end if;
      
         if p_deleting = 1 then
            --chiusura dei ruoli automatici relativi alla regola eliminata
            for ruco in (select rc.id_ruolo_componente
                               ,rc.id_componente
                               ,rc.dal
                               ,rc.al
                               ,rd.id_ruolo_derivato
                               ,rc.data_aggiornamento
                           from ruoli_componente rc
                               ,ruoli_derivati   rd
                          where rd.id_ruolo_componente = rc.id_ruolo_componente
                            and rd.id_relazione = p_id_relazione
                            and rc.dal <= nvl(rc.al, to_date(3333333, 'j'))
                            and nvl(rc.al, to_date(3333333, 'j')) >= d_oggi
                          order by rc.id_componente
                                  ,rc.id_ruolo_componente)
            loop
               ruolo_componente.eliminazione_logica_ruolo(ruco.id_ruolo_componente
                                                         ,d_oggi
                                                         ,'Del.Aut'
                                                         ,d_segnalazione_bloccante
                                                         ,d_segnalazione);
            end loop;
         end if;
      end if;
   
      ruolo_componente.s_ruoli_automatici := 0;
   
      if d_segnalazione_bloccante = 'Y' then
         null;
         --  raise_application_error(s_err_set_fi_num, d_segnalazione);
      end if;
   end;
   --------------------------------------------------------------------------------
   procedure chk_ri
   (
      p_id_relazione       in relazioni_ruoli.id_relazione%type
     ,p_old_ottica         in relazioni_ruoli.ottica%type
     ,p_new_ottica         in relazioni_ruoli.ottica%type
     ,p_old_codice_uo      in relazioni_ruoli.codice_uo%type
     ,p_new_codice_uo      in relazioni_ruoli.codice_uo%type
     ,p_old_uo_discendenti in relazioni_ruoli.uo_discendenti%type
     ,p_new_uo_discendenti in relazioni_ruoli.uo_discendenti%type
     ,p_old_suddivisione   in relazioni_ruoli.suddivisione%type
     ,p_new_suddivisione   in relazioni_ruoli.suddivisione%type
     ,p_old_incarico       in relazioni_ruoli.incarico%type
     ,p_new_incarico       in relazioni_ruoli.incarico%type
     ,p_old_responsabile   in relazioni_ruoli.responsabile%type
     ,p_new_responsabile   in relazioni_ruoli.responsabile%type
     ,p_old_dipendente     in relazioni_ruoli.dipendente%type
     ,p_new_dipendente     in relazioni_ruoli.dipendente%type
     ,p_old_ruolo          in relazioni_ruoli.ruolo%type
     ,p_new_ruolo          in relazioni_ruoli.ruolo%type
     ,p_inserting          in number
     ,p_updating           in number
     ,p_deleting           in number
   ) is
      /******************************************************************************
       NOME:        chk_RI
       DESCRIZIONE: function di controllo integrita' referenziale
       RITORNA:     afc_error.t_error_number
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
      /*d_result := is_ri_ok(p_id_componente
      ,p_old_dal
      ,p_new_dal
      ,p_old_al
      ,p_new_al
      ,p_rowid
      ,p_inserting
      ,p_updating
      ,p_deleting
      ,p_nest_level);*/
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, error_message(d_result));
      end if;
   end;
   --------------------------------------------------------------------------------
begin
   -- inserimento degli errori nella tabella
   s_error_table(s_errori_attr_ruoli_num) := s_errori_attr_ruoli_msg;
   -- s_error_table(s_dal_al_errato_number) := s_dal_al_errato_msg;
-- s_error_table(s_dal_errato_num) := s_dal_errato_msg;
-- s_error_table(s_dal_errato_ins_num) := s_dal_errato_ins_msg;
-- s_error_table(s_dal_fuori_periodo_num) := s_dal_fuori_periodo_msg;
-- s_error_table(s_al_errato_num) := s_al_errato_msg;
-- s_error_table(s_al_errato_ins_num) := s_al_errato_ins_msg;
-- s_error_table(s_al_fuori_periodo_num) := s_al_fuori_periodo_msg;
-- s_error_table(s_record_storico_num) := s_record_storico_msg;
end relazioni_ruoli_pkg;
/

