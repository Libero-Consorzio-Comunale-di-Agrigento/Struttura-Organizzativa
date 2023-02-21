CREATE OR REPLACE package body so4_pubblicazione_modifiche is
   /******************************************************************************
    NOME:        so4_pubblicazione_modifiche
    DESCRIZIONE: Metodi per la pubblicazione delle modifiche
    ANNOTAZIONI: .
    REVISIONI:   .
    <CODE>
    Rev.  Data        Autore       Descrizione.
    00    13/01/2014  MMONARI      Prima emissione.
    01    25/05/2015  MMONARI      #600
   ******************************************************************************/

   s_revisione_body constant afc.t_revision := '01';

   s_tipo_revisione revisioni_struttura.tipo_revisione%type;

   s_id number(10);

   s_note varchar2(200);

   s_data timestamp;

   s_dummy varchar2(1);

   s_count number(1);

   s_ultima_revisione revisioni_struttura.revisione%type;

   s_id_componente componenti.id_componente%type;

   --s_ottica componenti.ottica%type;

   s_revisione_cessazione componenti.revisione_cessazione%type;

   s_revisione_assegnazione componenti.revisione_assegnazione%type;

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

   procedure get_note is
   begin
      select substr('Nome Client: ' || sys_context('USERENV', 'TERMINAL') ||
                    '; Software applicativo: ' || sys_context('USERENV', 'MODULE') ||
                    '; Utente OS: ' || sys_context('USERENV', 'OS_USER') || '; Host:' ||
                    sys_context('USERENV', 'HOST')
                   ,1
                   ,200)
        into s_note
        from dual;
   end;

   --------------------------------------------------------------------------------

   procedure get_id is
   begin
      select modifiche_sq.nextval into s_id from dual;
      s_data := systimestamp;
   end;

   --------------------------------------------------------------------------------

   procedure get_ultima_revisione(p_ottica in varchar2) is
   begin
      select max(revisione)
        into s_ultima_revisione
        from revisioni_struttura
       where ottica = p_ottica;
   end;

   --------------------------------------------------------------------------------

   procedure notifica_eventi is
      d_statement afc.t_statement;
   begin
      for moduli in (select user_oracle
                           ,istanza modulo
                       from ad4_istanze
                      where istanza in (select distinct modulo
                                          from eventi_pubblicati e
                                         where nvl(notifica, 0) = 0
                                           and url_notifica is null))
      loop
         so4_pubblicazione_modifiche.s_notificato := 0;
         d_statement                              := 'begin ' ||
                                                     '   so4_pubblicazione_modifiche.s_notificato :=  ' ||
                                                     moduli.user_oracle ||
                                                     '.notifica_eventi_so4;' || 'end;';
         afc.sql_execute(d_statement);
      
         if so4_pubblicazione_modifiche.s_notificato = 1 then
            update iscrizioni_pubblicazione
               set notifica = 1
             where modulo = moduli.modulo;
         end if;
      end loop;
   
   end;

   --------------------------------------------------------------------------------

   procedure registra_evento
   (
      p_oggetto         in so4_eventi.oggetto%type
     ,p_id_modifica     in so4_eventi.id_modifica%type
     ,p_categoria       in so4_eventi.categoria%type
     ,p_tipo            in so4_eventi.tipo%type
     ,p_amministrazione in so4_eventi.amministrazione%type
     ,p_ottica          in so4_eventi.ottica%type
   ) is
      d_time timestamp := systimestamp;
   begin
      insert into so4_eventi
         (oggetto
         ,id_modifica
         ,categoria
         ,tipo
         ,amministrazione
         ,ottica
         ,time)
      values
         (p_oggetto
         ,p_id_modifica
         ,p_categoria
         ,p_tipo
         ,p_amministrazione
         ,p_ottica
         ,d_time);
   end;

   --------------------------------------------------------------------------------
   procedure set_tipo_evento
   (
      p_id_modifica in so4_eventi.id_modifica%type
     ,p_tipo        in so4_eventi.tipo%type
   ) is
   begin
      update so4_eventi
         set tipo = p_tipo
       where id_modifica = p_id_modifica
         and tipo is null;
   end;

   --------------------------------------------------------------------------------

   procedure set_inizio_acquisizione
   (
      p_modulo          in iscrizioni_pubblicazione.modulo%type
     ,p_time            in timestamp
     ,p_amministrazione in ottiche.amministrazione%type default null
     ,p_ottica          in ottiche.ottica%type default null
   ) is
   begin
      update iscrizioni_pubblicazione
         set data_inizio_acquisizione = p_time
            ,notifica                 = ''
       where modulo = p_modulo
         and (amministrazione = p_amministrazione or p_amministrazione is null)
         and (ottica = p_ottica or p_ottica is null);
   end;

   --------------------------------------------------------------------------------

   procedure pubblica_revisione
   (
      p_ottica    in revisioni_struttura.ottica%type
     ,p_revisione in revisioni_struttura.revisione%type
     ,p_data      in date
   ) is
      d_id_backup       number(10);
      d_amministrazione amministrazioni.codice_amministrazione%type := ottica.get_amministrazione(p_ottica);
      d_ottica          ottiche.ottica%type;
   begin
      --predisposizione delle informazioni dell'evento di attivazione
      select max(id_backup)
        into d_id_backup
        from revisioni_struttura_b b
       where revisione = p_revisione
         and ottica = p_ottica
         and b.operazione = 'AU'
      /* and contesto = 'T' */
      ;
   
      registra_evento('REVISIONI_STRUTTURA'
                     ,d_id_backup
                     ,'STRUTTURA_LOGICA'
                     ,3
                     ,d_amministrazione
                     ,p_ottica);
   
      update revisioni_struttura_b set contesto = 'R' where id_backup = d_id_backup;
   
      delete from so4_eventi
       where oggetto = 'REVISIONI_STRUTTURA'
         and id_modifica in (select id_backup
                               from revisioni_struttura_b
                              where revisione = p_revisione
                                and ottica = p_ottica
                                and contesto <> 'R');
   
      --analisi delle modifiche alla struttura determinate dalla nuova revisione
      ----------------- Anagrafe UO
      for anuo in (select *
                     from anagrafe_unita_organizzative
                    where ottica = p_ottica
                      and (revisione_istituzione = p_revisione or
                          revisione_cessazione = p_revisione)
                    order by progr_unita_organizzativa)
      loop
         if anuo.revisione_istituzione = p_revisione then
            begin
               select 'x'
                 into s_dummy
                 from anagrafe_unita_organizzative
                where ottica = p_ottica
                  and progr_unita_organizzativa = anuo.progr_unita_organizzativa
                  and revisione_cessazione = p_revisione;
            
               raise too_many_rows;
            exception
               when no_data_found then
                  --creazione di una nuova UO
                  select max(id_backup)
                    into d_id_backup
                    from anagrafe_unita_organizzative_b b
                   where progr_unita_organizzativa = anuo.progr_unita_organizzativa
                     and revisione_istituzione = p_revisione
                     and b.operazione in ('I', 'AU')
                     and dal_pubb is not null
                  /* and contesto = 'T' */
                  ;
               
                  registra_evento('ANAGRAFE_UNITA_ORGANIZZATIVE'
                                 ,d_id_backup
                                 ,'STRUTTURA_LOGICA'
                                 ,4
                                 ,anuo.amministrazione
                                 ,anuo.ottica);
               
                  update anagrafe_unita_organizzative_b
                     set contesto = 'R'
                   where id_backup = d_id_backup;
               when too_many_rows then
                  --storicizzazione di una nuova UO
                  select max(id_backup)
                    into d_id_backup
                    from anagrafe_unita_organizzative_b b
                   where progr_unita_organizzativa = anuo.progr_unita_organizzativa
                     and revisione_istituzione = p_revisione
                     and b.operazione in ('I', 'AU')
                  /* and contesto = 'T' */
                  ;
               
                  registra_evento('ANAGRAFE_UNITA_ORGANIZZATIVE'
                                 ,d_id_backup
                                 ,'STRUTTURA_LOGICA'
                                 ,7
                                 ,anuo.amministrazione
                                 ,anuo.ottica);
               
                  update anagrafe_unita_organizzative_b
                     set contesto = 'R'
                   where id_backup = d_id_backup;
            end;
         end if;
         if anuo.revisione_cessazione = p_revisione then
            begin
               select 'x'
                 into s_dummy
                 from anagrafe_unita_organizzative
                where ottica = p_ottica
                  and progr_unita_organizzativa = anuo.progr_unita_organizzativa
                  and revisione_istituzione = p_revisione;
            exception
               when no_data_found then
                  --eliminazione della UO
                  select max(id_backup)
                    into d_id_backup
                    from anagrafe_unita_organizzative_b b
                   where progr_unita_organizzativa = anuo.progr_unita_organizzativa
                     and revisione_cessazione = p_revisione
                     and b.operazione = 'AU'
                  /* and contesto = 'T' */
                  ;
               
                  registra_evento('ANAGRAFE_UNITA_ORGANIZZATIVE'
                                 ,d_id_backup
                                 ,'STRUTTURA_LOGICA'
                                 ,5
                                 ,anuo.amministrazione
                                 ,anuo.ottica);
               
                  update anagrafe_unita_organizzative_b
                     set contesto = 'R'
                   where id_backup = d_id_backup;
               
               when too_many_rows then
                  null;
            end;
         end if;
      end loop;
      ----------------- relazioni tra UO
      for unor in (select u.*
                         ,ottica.get_amministrazione(u.ottica) amministrazione
                     from unita_organizzative u
                    where ottica = p_ottica
                      and revisione = p_revisione
                    order by progr_unita_organizzativa)
      loop
         if unor.revisione = p_revisione then
         
            select count(*)
              into s_count
              from unita_organizzative
             where ottica = p_ottica
               and progr_unita_organizzativa = unor.progr_unita_organizzativa
               and revisione_cessazione = p_revisione;
         
            select max(id_backup)
              into d_id_backup
              from unita_organizzative_b b
             where progr_unita_organizzativa = unor.progr_unita_organizzativa
               and ottica = p_ottica
               and revisione = p_revisione
               and b.operazione in ('I', 'AU')
            /* and contesto = 'T' */
            ;
         
            if s_count <> 0 then
               registra_evento('UNITA_ORGANIZZATIVE'
                              ,d_id_backup
                              ,'STRUTTURA_LOGICA'
                              ,8
                              ,unor.amministrazione
                              ,unor.ottica);
            else
               registra_evento('UNITA_ORGANIZZATIVE'
                              ,d_id_backup
                              ,'STRUTTURA_LOGICA'
                              ,4
                              ,unor.amministrazione
                              ,unor.ottica);
            end if;
         
            update unita_organizzative_b
               set contesto = 'R'
             where id_backup = d_id_backup;
         
         end if;
      end loop;
      --analisi delle modifiche ai componenti determinate dalla nuova revisione
      ----------------- Componenti
      for comp in (select c.*
                         ,ottica.get_amministrazione(c.ottica) amministrazione
                     from componenti c
                    where ottica = p_ottica
                      and (revisione_assegnazione = p_revisione or
                          revisione_cessazione = p_revisione)
                    order by id_componente)
      loop
         if comp.revisione_assegnazione = p_revisione then
            begin
               select 'x'
                 into s_dummy
                 from componenti
                where ottica = p_ottica
                  and ni = comp.ni
                  and id_componente <> comp.id_componente;
            
               raise too_many_rows;
            exception
               when no_data_found then
                  --assegnazione di un nuovo soggetto
                  select max(id_backup)
                    into d_id_backup
                    from componenti_b b
                   where id_componente = comp.id_componente
                     and b.operazione in ('I', 'AU')
                  /* and contesto = 'T' */
                  ;
               
                  registra_evento('COMPONENTI'
                                 ,d_id_backup
                                 ,'COMPONENTI'
                                 ,1
                                 ,comp.amministrazione
                                 ,comp.ottica);
               
                  update componenti_b set contesto = 'R' where id_backup = d_id_backup;
               when too_many_rows then
                  --nuova assegnazione di soggetto preesistente
                  select max(id_backup)
                    into d_id_backup
                    from componenti_b b
                   where id_componente = comp.id_componente
                     and b.operazione in ('I', 'AU')
                  /* and contesto = 'T' */
                  ;
               
                  registra_evento('COMPONENTI'
                                 ,d_id_backup
                                 ,'COMPONENTI'
                                 ,2
                                 ,comp.amministrazione
                                 ,comp.ottica);
               
                  update componenti_b set contesto = 'R' where id_backup = d_id_backup;
            end;
         end if;
         if comp.revisione_cessazione = p_revisione then
            --cessazione di un componente
            select max(id_backup)
              into d_id_backup
              from componenti_b b
             where id_componente = comp.id_componente
               and b.operazione = 'AU'
            /* and contesto = 'T' */
            ;
         
            select count(*)
              into s_count
              from componenti
             where ni = comp.ni
               and ottica = p_ottica
               and nvl(al, to_date(3333333, 'j')) > comp.al;
         
            if s_count <> 0 then
               registra_evento('COMPONENTI'
                              ,d_id_backup
                              ,'COMPONENTI'
                              ,3
                              ,comp.amministrazione
                              ,comp.ottica);
            else
               registra_evento('COMPONENTI'
                              ,d_id_backup
                              ,'COMPONENTI'
                              ,4
                              ,comp.amministrazione
                              ,comp.ottica);
            end if;
            update componenti_b set contesto = 'R' where id_backup = d_id_backup;
         end if;
      end loop;
      ----------------- Attributi dei Componenti
      for atco in (select a.*
                         ,ottica.get_amministrazione(a.ottica) amministrazione
                     from attributi_componente a
                    where ottica = p_ottica
                      and (revisione_assegnazione = p_revisione or
                          revisione_cessazione = p_revisione)
                    order by id_attr_componente)
      loop
         if atco.revisione_assegnazione = p_revisione then
            --nuova attribuzione di incarico
            select max(id_backup)
              into d_id_backup
              from attributi_componente_b b
             where id_attr_componente = atco.id_attr_componente
               and b.operazione in ('I', 'AU')
            /* and contesto = 'T' */
            ;
         
            registra_evento('ATTRIBUTI_COMPONENTE'
                           ,d_id_backup
                           ,'COMPONENTI'
                           ,6
                           ,atco.amministrazione
                           ,atco.ottica);
         
            update attributi_componente_b
               set contesto = 'R'
             where id_backup = d_id_backup;
         end if;
         if atco.revisione_cessazione = p_revisione then
            --cessazione di un incarico
            select max(id_backup)
              into d_id_backup
              from attributi_componente_b b
             where id_attr_componente = atco.id_attr_componente
               and b.operazione = 'AU'
            /* and contesto = 'T' */
            ;
         
            registra_evento('ATTRIBUTI_COMPONENTE'
                           ,d_id_backup
                           ,'COMPONENTI'
                           ,18
                           ,atco.amministrazione
                           ,atco.ottica);
         
            update attributi_componente_b
               set contesto = 'R'
             where id_backup = d_id_backup;
         end if;
      end loop;
      ----------------- Ruoli applicativi dei Componenti
      for ruco in (select c.revisione_assegnazione
                         ,c.revisione_cessazione
                         ,c.ottica
                         ,ottica.get_amministrazione(c.ottica) amministrazione
                         ,r.*
                     from ruoli_componente r
                         ,componenti       c
                    where r.id_componente = c.id_componente
                      and c.ottica = p_ottica
                      and (c.revisione_assegnazione = p_revisione or
                          c.revisione_cessazione = p_revisione)
                    order by c.id_componente
                            ,r.id_ruolo_componente)
      loop
         if ruco.revisione_assegnazione = p_revisione then
            --nuova attribuzione di ruolo
            select max(id_backup)
              into d_id_backup
              from ruoli_componente_b b
             where id_ruolo_componente = ruco.id_ruolo_componente
               and b.operazione in ('I', 'AU')
            /* and contesto = 'T' */
            ;
         
            registra_evento('RUOLI_COMPONENTE'
                           ,d_id_backup
                           ,'COMPONENTI'
                           ,9
                           ,ruco.amministrazione
                           ,ruco.ottica);
         
            update ruoli_componente_b set contesto = 'R' where id_backup = d_id_backup;
         end if;
         if ruco.revisione_cessazione = p_revisione then
            --cessazione di un ruolo applicativo
            select max(id_backup)
              into d_id_backup
              from ruoli_componente_b b
             where id_ruolo_componente = ruco.id_ruolo_componente
               and b.operazione = 'AU'
            /* and contesto = 'T' */
            ;
         
            registra_evento('RUOLI_COMPONENTE'
                           ,d_id_backup
                           ,'COMPONENTI'
                           ,10
                           ,ruco.amministrazione
                           ,ruco.ottica);
         
            update ruoli_componente_b set contesto = 'R' where id_backup = d_id_backup;
         end if;
      end loop;
   end;

   --------------------------------------------------------------------------------

   procedure completa_eventi is
      d_revisione                 revisioni_struttura_b%rowtype;
      d_revisione_old             revisioni_struttura_b%rowtype;
      d_unita_organizzativa       unita_organizzative_b%rowtype;
      d_anagrafe_unita_org        anagrafe_unita_organizzative_b%rowtype;
      d_anagrafe_unita_org_old    anagrafe_unita_organizzative_b%rowtype;
      d_componente                componenti_b%rowtype;
      d_componente_old            componenti_b%rowtype;
      d_componente_rif            componenti%rowtype;
      d_attributo_componente      attributi_componente_b%rowtype;
      d_attributo_componente_old  attributi_componente_b%rowtype;
      d_ruolo_componente          ruoli_componente_b%rowtype;
      d_ruolo_componente_old      ruoli_componente_b%rowtype;
      d_imputazione_bilancio      imputazioni_bilancio_b%rowtype;
      d_unita_fisica              unita_fisiche_b%rowtype;
      d_anagrafe_unita_fisica     anagrafe_unita_fisiche_b%rowtype;
      d_anagrafe_unita_fisica_old anagrafe_unita_fisiche_b%rowtype;
      d_assegnazione_fisica       assegnazioni_fisiche_b%rowtype;
      d_assegnazione_fisica_old   assegnazioni_fisiche_b%rowtype;
      d_soggetto_rubrica          soggetti_rubrica_b%rowtype;
      d_fatto                     number(1);
   begin
      for categorie in (select distinct categoria
                                       ,modifica
                          from iscrizioni_pubblicazione
                         where sysdate between inizio and nvl(fine, to_date(3333333, 'j')))
      loop
         for eventi in (select e.*
                              ,e.id_modifica - 1 id_old
                          from so4_eventi e
                         where categoria = categorie.categoria
                           and tipo is null
                           and id_modifica is not null
                         order by id_evento)
         loop
            d_fatto := 0;
            if eventi.categoria = 'STRUTTURA_LOGICA' then
               if eventi.oggetto = 'REVISIONI_STRUTTURA' then
                  --preleva i dati della modifica
                  select *
                    into d_revisione
                    from revisioni_struttura_b b
                   where b.id_backup = eventi.id_modifica;
                  if d_revisione.operazione = 'AU' then
                     select *
                       into d_revisione_old
                       from revisioni_struttura_b b
                      where b.id_backup = eventi.id_old;
                  end if;
                  --verifica se stiamo attivando una revisione
                  if d_revisione.stato = 'A' and d_revisione_old.stato = 'M' then
                     --attivazione della revisione di struttura
                     pubblica_revisione(d_revisione.ottica
                                       ,d_revisione.revisione
                                       ,d_revisione.dal);
                  
                     set_tipo_evento(eventi.id_modifica, 3);
                     set_tipo_evento(eventi.id_old, 3);
                  elsif nvl(d_revisione.data_pubblicazione, to_date(3333333, 'j')) <>
                        nvl(d_revisione_old.data_pubblicazione, to_date(3333333, 'j')) and
                        d_revisione.stato = 'A' then
                     set_tipo_evento(eventi.id_modifica, 3);
                     set_tipo_evento(eventi.id_old, 3);
                  
                  end if;
               elsif eventi.oggetto = 'UNITA_ORGANIZZATIVE' then
                  null;
               elsif eventi.oggetto = 'ANAGRAFE_UNITA_ORGANIZZATIVE' then
                  --preleva i dati della modifica
                  select *
                    into d_anagrafe_unita_org
                    from anagrafe_unita_organizzative_b b
                   where b.id_backup = eventi.id_modifica;
                  --verifica se stiamo rettificando una UO
                  if d_anagrafe_unita_org.operazione = 'AU' then
                     select *
                       into d_anagrafe_unita_org_old
                       from anagrafe_unita_organizzative_b b
                      where b.id_backup = eventi.id_old;
                  
                     if d_anagrafe_unita_org.codice_uo <>
                        d_anagrafe_unita_org_old.codice_uo then
                        registra_evento('ANAGRAFE_UNITA_ORGANIZZATIVE'
                                       ,eventi.id_modifica
                                       ,'STRUTTURA_LOGICA'
                                       ,9
                                       ,d_anagrafe_unita_org.amministrazione
                                       ,d_anagrafe_unita_org.ottica);
                     end if;
                     if d_anagrafe_unita_org.descrizione <>
                        d_anagrafe_unita_org_old.descrizione then
                        registra_evento('ANAGRAFE_UNITA_ORGANIZZATIVE'
                                       ,eventi.id_modifica
                                       ,'STRUTTURA_LOGICA'
                                       ,10
                                       ,d_anagrafe_unita_org.amministrazione
                                       ,d_anagrafe_unita_org.ottica);
                     end if;
                     if nvl(d_anagrafe_unita_org.centro, 'xxx') <>
                        nvl(d_anagrafe_unita_org_old.centro, 'xxx') then
                        registra_evento('ANAGRAFE_UNITA_ORGANIZZATIVE'
                                       ,eventi.id_modifica
                                       ,'STRUTTURA_LOGICA'
                                       ,11
                                       ,d_anagrafe_unita_org.amministrazione
                                       ,d_anagrafe_unita_org.ottica);
                     end if;
                     if nvl(d_anagrafe_unita_org.aggregatore, 'xxx') <>
                        nvl(d_anagrafe_unita_org_old.aggregatore, 'xxx') then
                        registra_evento('ANAGRAFE_UNITA_ORGANIZZATIVE'
                                       ,eventi.id_modifica
                                       ,'STRUTTURA_LOGICA'
                                       ,12
                                       ,d_anagrafe_unita_org.amministrazione
                                       ,d_anagrafe_unita_org.ottica);
                     end if;
                     if nvl(d_anagrafe_unita_org.centro_responsabilita, 'XX') <>
                        nvl(d_anagrafe_unita_org_old.centro_responsabilita, 'XX') then
                        registra_evento('ANAGRAFE_UNITA_ORGANIZZATIVE'
                                       ,eventi.id_modifica
                                       ,'STRUTTURA_LOGICA'
                                       ,13
                                       ,d_anagrafe_unita_org.amministrazione
                                       ,d_anagrafe_unita_org.ottica);
                     end if;
                     if d_anagrafe_unita_org.codice_uo <>
                        d_anagrafe_unita_org_old.codice_uo or
                        d_anagrafe_unita_org.dal <> d_anagrafe_unita_org_old.dal or
                        nvl(d_anagrafe_unita_org.al, to_date(3333333, 'j')) <>
                        nvl(d_anagrafe_unita_org_old.al, to_date(3333333, 'j')) or
                        d_anagrafe_unita_org.descrizione <>
                        d_anagrafe_unita_org_old.descrizione or
                        d_anagrafe_unita_org.des_abb <> d_anagrafe_unita_org_old.des_abb or
                        d_anagrafe_unita_org.id_suddivisione <>
                        d_anagrafe_unita_org_old.id_suddivisione or
                        d_anagrafe_unita_org.progr_aoo <>
                        d_anagrafe_unita_org_old.progr_aoo or
                        nvl(d_anagrafe_unita_org.centro, 'XX') <>
                        nvl(d_anagrafe_unita_org_old.centro, 'XX') or
                        nvl(d_anagrafe_unita_org.centro_responsabilita, 'XX') <>
                        nvl(d_anagrafe_unita_org_old.centro_responsabilita, 'XX') or
                        nvl(d_anagrafe_unita_org.aggregatore, 'XX') <>
                        nvl(d_anagrafe_unita_org_old.aggregatore, 'XX') then
                        set_tipo_evento(eventi.id_modifica, 6);
                     end if;
                     if d_anagrafe_unita_org.dal <> d_anagrafe_unita_org_old.dal or
                        nvl(d_anagrafe_unita_org.al, to_date(3333333, 'j')) <>
                        nvl(d_anagrafe_unita_org_old.al, to_date(3333333, 'j')) then
                        set_tipo_evento(eventi.id_modifica, 14);
                     end if;
                  
                  end if;
                  --verifica se stiamo creando una nuova UO
                  if d_anagrafe_unita_org.operazione = 'I' then
                     select count(*)
                       into s_count
                       from anagrafe_unita_organizzative a
                      where progr_unita_organizzativa =
                            d_anagrafe_unita_org.progr_unita_organizzativa;
                  
                     if s_count = 1 then
                        set_tipo_evento(eventi.id_modifica, 4);
                     else
                        set_tipo_evento(eventi.id_modifica, 7);
                     end if;
                  
                  end if;
               end if;
            elsif eventi.categoria = 'COMPONENTI' then
               if eventi.oggetto = 'COMPONENTI' then
                  --preleva i dati della modifica
                  select *
                    into d_componente
                    from componenti_b b
                   where b.id_backup = eventi.id_modifica;
                  --Analizza il tipo di operazione realizzata creando un nuovo componente extra revisione
                  if d_componente.operazione = 'I' then
                     select count(*)
                       into s_count
                       from componenti a
                      where ni = d_componente.ni
                        and ottica = d_componente.ottica;
                  
                     if s_count = 1 then
                        set_tipo_evento(eventi.id_modifica, 1); --assegnazione di un nuovo soggetto
                     else
                        select count(*)
                          into s_count
                          from componenti a
                         where ni = d_componente.ni
                           and ottica = d_componente.ottica
                           and dal <= nvl(al, to_date(3333333, 'j'))
                           and al = d_componente.dal - 1
                           and progr_unita_organizzativa <>
                               d_componente.progr_unita_organizzativa;
                        if s_count = 1 then
                           set_tipo_evento(eventi.id_modifica, 5); --spostamento 
                        else
                           set_tipo_evento(eventi.id_modifica, 2); --nuova assegnazione
                        end if;
                     end if;
                  elsif d_componente.operazione = 'AU' then
                     --preleva i dati precedenti
                     select *
                       into d_componente_old
                       from componenti_b b
                      where b.id_backup = eventi.id_old;
                  
                     if d_componente.al is not null and d_componente_old.al is null then
                        select count(*)
                          into s_count
                          from componenti a
                         where ni = d_componente.ni
                           and ottica = d_componente.ottica
                           and dal <= nvl(al, to_date(3333333, 'j'))
                           and id_componente <> d_componente.id_componente
                           and nvl(al, to_date(3333333, 'j')) >
                               nvl(d_componente.al, to_date(3333333, 'j'));
                     
                        if s_count = 0 then
                           set_tipo_evento(eventi.id_modifica, 4); --cessazione di un indivisuo
                        else
                           set_tipo_evento(eventi.id_modifica, 3); --cessazione di un componente
                        end if;
                     else
                        set_tipo_evento(eventi.id_modifica, 14); --rettifica di un componente (dal, al, ...)
                     end if;
                  end if;
               elsif eventi.oggetto = 'ATTRIBUTI_COMPONENTE' then
                  --preleva i dati della modifica
                  select *
                    into d_attributo_componente
                    from attributi_componente_b b
                   where b.id_backup = eventi.id_modifica;
               
                  if d_attributo_componente.operazione = 'I' then
                     set_tipo_evento(eventi.id_modifica, 15); --inserimento di un nuovo incarico
                  elsif d_attributo_componente.operazione = 'AU' then
                     --preleva i dati precedenti
                     select *
                       into d_attributo_componente_old
                       from attributi_componente_b b
                      where b.id_backup = eventi.id_old;
                     if d_attributo_componente.incarico <>
                        d_attributo_componente_old.incarico then
                        set_tipo_evento(eventi.id_modifica, 6); --rettifica dell'incarico
                     elsif d_attributo_componente.tipo_assegnazione <>
                           d_attributo_componente_old.tipo_assegnazione then
                        set_tipo_evento(eventi.id_modifica, 7); --rettifica della tipologia di assegnazione
                     elsif d_attributo_componente.assegnazione_prevalente <>
                           d_attributo_componente_old.assegnazione_prevalente then
                        set_tipo_evento(eventi.id_modifica, 8); --rettifica dell'assegnazione prevalente
                     elsif d_attributo_componente.dal <> d_attributo_componente_old.dal or
                           nvl(d_attributo_componente.al, to_date(3333333, 'j')) <>
                           nvl(d_attributo_componente_old.al, to_date(3333333, 'j')) or
                           nvl(d_attributo_componente.percentuale_impiego, -1) <>
                           nvl(d_attributo_componente_old.percentuale_impiego, -1) then
                        set_tipo_evento(eventi.id_modifica, 17); --rettifica attributo componente
                     end if;
                  end if;
               
               elsif eventi.oggetto = 'RUOLI_COMPONENTE' then
                  --preleva i dati della modifica
                  select *
                    into d_ruolo_componente
                    from ruoli_componente_b b
                   where b.id_backup = eventi.id_modifica;
               
                  if d_ruolo_componente.operazione = 'I' then
                     set_tipo_evento(eventi.id_modifica, 9); --inserimento di un nuovo ruolo applicativo
                  elsif d_ruolo_componente.operazione = 'AU' then
                     --preleva i dati precedenti
                     select *
                       into d_ruolo_componente_old
                       from ruoli_componente_b b
                      where b.id_backup = eventi.id_old;
                     if d_ruolo_componente.ruolo <> d_ruolo_componente_old.ruolo or
                        d_ruolo_componente.dal <> d_ruolo_componente_old.dal then
                        set_tipo_evento(eventi.id_modifica, 16); --rettifica del ruolo
                     elsif (d_ruolo_componente.al is not null and
                           d_ruolo_componente_old.al is null) or
                           (d_ruolo_componente.al = d_ruolo_componente.dal - 1) then
                        set_tipo_evento(eventi.id_modifica, 10); --revoca di un ruolo
                     elsif nvl(d_ruolo_componente.al, to_date(3333333, 'j')) >
                           nvl(d_ruolo_componente_old.al, to_date(3333333, 'j')) then
                        set_tipo_evento(eventi.id_modifica, 11); --proroga di un ruolo
                     end if;
                  end if;
               elsif eventi.oggetto = 'IMPUTAZIONI_BILANCIO' then
                  null;
               end if;
            elsif eventi.categoria = 'STRUTTURA_FISICA' then
               if eventi.oggetto = 'UNITA_FISICHE' then
                  null;
               elsif eventi.oggetto = 'ANAGRAFE_UNITA_FISICHE' then
                  --preleva i dati della modifica
                  select *
                    into d_anagrafe_unita_fisica
                    from anagrafe_unita_fisiche_b b
                   where b.id_backup = eventi.id_modifica;
                  --Analizza il tipo di operazione realizzata creando un nuovo componente extra revisione
                  if d_componente.operazione = 'I' then
                     select count(*)
                       into s_count
                       from anagrafe_unita_fisiche_b a
                      where progr_unita_fisica =
                            d_anagrafe_unita_fisica.progr_unita_fisica;
                     if s_count = 1 then
                        set_tipo_evento(eventi.id_modifica, 2); --creazione nuova UF
                     else
                        set_tipo_evento(eventi.id_modifica, 4); --storicizzazione attributi UF
                     end if;
                  elsif d_componente.operazione = 'AU' then
                     --preleva i dati precedenti
                     select *
                       into d_anagrafe_unita_fisica_old
                       from anagrafe_unita_fisiche_b b
                      where b.id_backup = eventi.id_old;
                  
                     if d_anagrafe_unita_fisica.al is not null and
                        d_anagrafe_unita_fisica_old.al is null then
                        select count(*)
                          into s_count
                          from anagrafe_unita_fisiche a
                         where progr_unita_fisica =
                               d_anagrafe_unita_fisica.progr_unita_fisica
                           and nvl(al, to_date(3333333, 'j')) >
                               nvl(d_componente.al, to_date(3333333, 'j'));
                     
                        if s_count = 0 then
                           set_tipo_evento(eventi.id_modifica, 3); --eliminazione UF
                        end if;
                     else
                        set_tipo_evento(eventi.id_modifica, 5); --rettifica attributi UF
                     end if;
                  end if;
               end if;
            elsif eventi.categoria = 'ASSEGNAZIONI_FISICHE' then
               --preleva i dati della modifica
               select *
                 into d_assegnazione_fisica
                 from assegnazioni_fisiche_b b
                where b.id_backup = eventi.id_modifica;
               --Analizza il tipo di operazione realizzata creando un nuovo componente extra revisione
               if d_componente.operazione = 'I' then
                  select count(*)
                    into s_count
                    from assegnazioni_fisiche a
                   where ni = d_assegnazione_fisica.ni;
               
                  if s_count = 1 then
                     set_tipo_evento(eventi.id_modifica, 1); --assegnazione di un nuovo soggetto
                  else
                     select count(*)
                       into s_count
                       from assegnazioni_fisiche a
                      where ni = d_componente.ni
                        and amministrazione in
                            (select amministrazione
                               from anagrafe_unita_fisiche
                              where progr_unita_fisica =
                                    d_assegnazione_fisica.progr_unita_fisica)
                        and al = d_assegnazione_fisica.dal - 1
                        and progr_unita_fisica <>
                            d_assegnazione_fisica.progr_unita_fisica;
                     if s_count = 1 then
                        set_tipo_evento(eventi.id_modifica, 3); --spostamento 
                     else
                        set_tipo_evento(eventi.id_modifica, 4); --nuova assegnazione
                     end if;
                  end if;
               elsif d_componente.operazione = 'AU' then
                  --preleva i dati precedenti
                  select *
                    into d_assegnazione_fisica_old
                    from assegnazioni_fisiche_b b
                   where b.id_backup = eventi.id_old;
               
                  if d_assegnazione_fisica.al is not null and
                     d_assegnazione_fisica_old.al is null then
                     select count(*)
                       into s_count
                       from assegnazioni_fisiche a
                      where ni = d_assegnazione_fisica.ni
                        and amministrazione in
                            (select amministrazione
                               from anagrafe_unita_fisiche
                              where progr_unita_fisica =
                                    d_assegnazione_fisica.progr_unita_fisica)
                        and nvl(al, to_date(3333333, 'j')) >
                            nvl(d_assegnazione_fisica.al, to_date(3333333, 'j'));
                  
                     if s_count = 0 then
                        set_tipo_evento(eventi.id_modifica, 2); --cessazione di un indivisuo
                     else
                        set_tipo_evento(eventi.id_modifica, 5); --rettifica
                     end if;
                  else
                     set_tipo_evento(eventi.id_modifica, 5); --rettifica 
                  end if;
               end if;
            elsif eventi.categoria = 'RUBRICA_CONTATTI' then
               null;
            end if;
         end loop;
      end loop;
   
   end;

   --------------------------------------------------------------------------------

   procedure registra_ottica
   (
      p_new_ottica in ottiche_b%rowtype
     ,p_old_ottica in ottiche_b%rowtype
     ,p_operazione in varchar2
   ) is
      d_new_ottica ottiche_b%rowtype := p_new_ottica;
      d_old_ottica ottiche_b%rowtype := p_old_ottica;
   begin
      get_note;
   
      get_id;
   
      if p_operazione in ('I', 'U') then
         d_new_ottica.note_sessione   := s_note;
         d_new_ottica.data_operazione := s_data;
         d_new_ottica.contesto        := 'X';
         if p_operazione = 'I' then
            d_new_ottica.id_backup  := s_id;
            d_new_ottica.operazione := p_operazione;
            insert into ottiche_b values d_new_ottica;
            registra_evento('OTTICHE'
                           ,d_new_ottica.id_backup
                           ,'STRUTTURA_LOGICA'
                           ,2
                           ,d_new_ottica.ottica
                           ,d_new_ottica.amministrazione);
         end if;
      end if;
      if p_operazione = 'U' then
         d_new_ottica.operazione := 'AU';
         d_old_ottica.operazione := 'BU';
         d_old_ottica.id_backup  := s_id;
         get_id;
         d_new_ottica.id_backup := s_id;
         insert into ottiche_b values d_old_ottica;
         insert into ottiche_b values d_new_ottica;
      end if;
      if p_operazione = 'D' then
         d_old_ottica.operazione      := p_operazione;
         d_old_ottica.note_sessione   := s_note;
         d_old_ottica.data_operazione := s_data;
         d_old_ottica.id_backup       := s_id;
         d_old_ottica.contesto        := 'X';
         insert into ottiche_b values d_old_ottica;
      end if;
   
   end;

   --------------------------------------------------------------------------------

   procedure registra_amministrazione
   (
      p_new_amministrazione in amministrazioni_b%rowtype
     ,p_old_amministrazione in amministrazioni_b%rowtype
     ,p_operazione          in varchar2
   ) is
      d_new_amministrazione amministrazioni_b%rowtype := p_new_amministrazione;
      d_old_amministrazione amministrazioni_b%rowtype := p_old_amministrazione;
   begin
      get_note;
   
      get_id;
   
      if p_operazione in ('I', 'U') then
         d_new_amministrazione.note_sessione   := s_note;
         d_new_amministrazione.data_operazione := s_data;
         d_new_amministrazione.contesto        := 'X';
         if p_operazione = 'I' then
            d_new_amministrazione.id_backup  := s_id;
            d_new_amministrazione.operazione := p_operazione;
            insert into amministrazioni_b values d_new_amministrazione;
            registra_evento('AMMINISTRAZIONI'
                           ,d_new_amministrazione.id_backup
                           ,'STRUTTURA_LOGICA'
                           ,1
                           ,d_new_amministrazione.codice_amministrazione
                           ,'');
         end if;
      end if;
      if p_operazione = 'U' then
         d_new_amministrazione.operazione := 'AU';
         d_old_amministrazione.operazione := 'BU';
         d_old_amministrazione.id_backup  := s_id;
         get_id;
         d_new_amministrazione.id_backup := s_id;
         insert into amministrazioni_b values d_old_amministrazione;
         insert into amministrazioni_b values d_new_amministrazione;
      end if;
      if p_operazione = 'D' then
         d_old_amministrazione.operazione      := p_operazione;
         d_old_amministrazione.note_sessione   := s_note;
         d_old_amministrazione.data_operazione := s_data;
         d_old_amministrazione.id_backup       := s_id;
         d_old_amministrazione.contesto        := 'X';
         insert into amministrazioni_b values d_old_amministrazione;
      end if;
   
   end;

   --------------------------------------------------------------------------------

   procedure registra_revisione_struttura
   (
      p_new_revisione_struttura in revisioni_struttura_b%rowtype
     ,p_old_revisione_struttura in revisioni_struttura_b%rowtype
     ,p_operazione              in varchar2
   ) is
      d_new_revisione_struttura revisioni_struttura_b%rowtype := p_new_revisione_struttura;
      d_old_revisione_struttura revisioni_struttura_b%rowtype := p_old_revisione_struttura;
      d_amministrazione         ottiche.amministrazione%type := ottica.get_amministrazione(nvl(p_new_revisione_struttura.ottica
                                                                                              ,p_old_revisione_struttura.ottica));
   begin
      get_note;
   
      get_id;
   
      if p_operazione in ('I', 'U') then
         d_new_revisione_struttura.note_sessione   := s_note;
         d_new_revisione_struttura.data_operazione := s_data;
         d_new_revisione_struttura.contesto        := 'T';
         if p_operazione = 'I' then
            d_new_revisione_struttura.id_backup  := s_id;
            d_new_revisione_struttura.operazione := p_operazione;
            insert into revisioni_struttura_b values d_new_revisione_struttura;
         end if;
      end if;
      if p_operazione = 'U' then
         d_new_revisione_struttura.operazione := 'AU';
         d_old_revisione_struttura.operazione := 'BU';
         d_old_revisione_struttura.contesto   := 'T';
         d_old_revisione_struttura.id_backup  := s_id;
         get_id;
         d_new_revisione_struttura.id_backup := s_id;
         insert into revisioni_struttura_b values d_old_revisione_struttura;
         insert into revisioni_struttura_b values d_new_revisione_struttura;
      
         if d_old_revisione_struttura.stato = 'M' and
            d_new_revisione_struttura.stato = 'A' then
            -- registra l'evento dell'attivazione
            registra_evento('REVISIONI_STRUTTURA'
                           ,d_new_revisione_struttura.id_backup
                           ,'STRUTTURA_LOGICA'
                           ,''
                           ,d_amministrazione
                           ,d_new_revisione_struttura.ottica);
         end if;
      
      end if;
      if p_operazione = 'D' then
         d_old_revisione_struttura.operazione      := p_operazione;
         d_old_revisione_struttura.note_sessione   := s_note;
         d_old_revisione_struttura.data_operazione := s_data;
         d_old_revisione_struttura.id_backup       := s_id;
         d_old_revisione_struttura.contesto        := 'T';
         insert into revisioni_struttura_b values d_old_revisione_struttura;
      end if;
   
      /*      registra_evento('REVISIONI_STRUTTURA'
                           ,d_new_revisione_struttura.id_backup
                           ,'STRUTTURA_LOGICA'
                           ,''
                           ,d_amministrazione
                           ,d_new_revisione_struttura.ottica);
      */
   end;

   --------------------------------------------------------------------------------

   procedure registra_unita_organizzativa
   (
      p_new_unita_organizzativa in unita_organizzative_b%rowtype
     ,p_old_unita_organizzativa in unita_organizzative_b%rowtype
     ,p_operazione              in varchar2
   ) is
      d_new_unita_organizzativa unita_organizzative_b%rowtype := p_new_unita_organizzativa;
      d_old_unita_organizzativa unita_organizzative_b%rowtype := p_old_unita_organizzativa;
      d_amministrazione         ottiche.amministrazione%type := ottica.get_amministrazione(nvl(p_new_unita_organizzativa.ottica
                                                                                              ,p_old_unita_organizzativa.ottica));
   begin
      get_note;
   
      get_id;
   
      if p_operazione in ('I', 'U') then
         d_new_unita_organizzativa.note_sessione   := s_note;
         d_new_unita_organizzativa.data_operazione := s_data;
         d_new_unita_organizzativa.contesto        := 'T';
         if p_operazione = 'I' then
            d_new_unita_organizzativa.id_backup  := s_id;
            d_new_unita_organizzativa.operazione := p_operazione;
            insert into unita_organizzative_b values d_new_unita_organizzativa;
         end if;
      end if;
      if p_operazione = 'U' then
         d_new_unita_organizzativa.operazione := 'AU';
         d_old_unita_organizzativa.operazione := 'BU';
         d_old_unita_organizzativa.contesto   := 'T';
         d_old_unita_organizzativa.id_backup  := s_id;
         get_id;
         d_new_unita_organizzativa.id_backup := s_id;
         insert into unita_organizzative_b values d_old_unita_organizzativa;
         insert into unita_organizzative_b values d_new_unita_organizzativa;
      end if;
      if p_operazione = 'D' then
         d_old_unita_organizzativa.operazione      := p_operazione;
         d_old_unita_organizzativa.note_sessione   := s_note;
         d_old_unita_organizzativa.data_operazione := s_data;
         d_old_unita_organizzativa.id_backup       := s_id;
         d_old_unita_organizzativa.contesto        := 'T';
         insert into unita_organizzative_b values d_old_unita_organizzativa;
      end if;
   
      if nvl(d_new_unita_organizzativa.contesto, d_old_unita_organizzativa.contesto) = 'X' then
         registra_evento('UNITA_ORGANIZZATIVE'
                        ,d_new_unita_organizzativa.id_backup
                        ,'STRUTTURA_LOGICA'
                        ,''
                        ,d_amministrazione
                        ,d_new_unita_organizzativa.ottica);
      end if;
   
   end;

   --------------------------------------------------------------------------------

   procedure registra_anagrafe_unita_org
   (
      p_new_anagrafe_unita_org in anagrafe_unita_organizzative_b%rowtype
     ,p_old_anagrafe_unita_org in anagrafe_unita_organizzative_b%rowtype
     ,p_operazione             in varchar2
   ) is
      d_new_anagrafe_unita_org anagrafe_unita_organizzative_b%rowtype := p_new_anagrafe_unita_org;
      d_old_anagrafe_unita_org anagrafe_unita_organizzative_b%rowtype := p_old_anagrafe_unita_org;
      d_revisione_mod          revisioni_struttura.revisione%type := revisione_struttura.get_revisione_mod(p_new_anagrafe_unita_org.ottica);
   begin
      get_note;
   
      get_id;
   
      get_ultima_revisione(p_new_anagrafe_unita_org.ottica);
   
      if nvl(d_new_anagrafe_unita_org.revisione_istituzione, -2) = d_revisione_mod or
         nvl(d_new_anagrafe_unita_org.revisione_cessazione, -2) = d_revisione_mod then
         d_new_anagrafe_unita_org.contesto := 'T';
         d_new_anagrafe_unita_org.contesto := 'T';
      elsif (nvl(d_new_anagrafe_unita_org.revisione_istituzione, -2) = s_ultima_revisione or
            nvl(d_new_anagrafe_unita_org.revisione_cessazione, -2) = s_ultima_revisione) and
            ((d_new_anagrafe_unita_org.dal_pubb is not null and
            d_old_anagrafe_unita_org.dal_pubb is null) or
            (d_new_anagrafe_unita_org.al_pubb is not null and
            d_old_anagrafe_unita_org.al_pubb is null)) then
         d_new_anagrafe_unita_org.contesto := 'T';
         d_new_anagrafe_unita_org.contesto := 'T';
      else
         d_new_anagrafe_unita_org.contesto := 'X';
         d_new_anagrafe_unita_org.contesto := 'X';
      end if;
   
      if p_operazione in ('I', 'U') then
         d_new_anagrafe_unita_org.note_sessione   := s_note;
         d_new_anagrafe_unita_org.data_operazione := s_data;
         if p_operazione = 'I' then
            d_new_anagrafe_unita_org.id_backup  := s_id;
            d_new_anagrafe_unita_org.operazione := p_operazione;
            insert into anagrafe_unita_organizzative_b values d_new_anagrafe_unita_org;
         end if;
      end if;
      if p_operazione = 'U' then
         d_new_anagrafe_unita_org.operazione := 'AU';
         d_old_anagrafe_unita_org.operazione := 'BU';
         d_old_anagrafe_unita_org.id_backup  := s_id;
         get_id;
         d_new_anagrafe_unita_org.id_backup := s_id;
         insert into anagrafe_unita_organizzative_b values d_old_anagrafe_unita_org;
         insert into anagrafe_unita_organizzative_b values d_new_anagrafe_unita_org;
      end if;
      if p_operazione = 'D' then
         d_old_anagrafe_unita_org.operazione      := p_operazione;
         d_old_anagrafe_unita_org.note_sessione   := s_note;
         d_old_anagrafe_unita_org.data_operazione := s_data;
         d_old_anagrafe_unita_org.id_backup       := s_id;
         insert into anagrafe_unita_organizzative_b values d_old_anagrafe_unita_org;
      end if;
   
      if nvl(d_new_anagrafe_unita_org.contesto, d_old_anagrafe_unita_org.contesto) = 'X' then
         registra_evento('ANAGRAFE_UNITA_ORGANIZZATIVE'
                        ,d_new_anagrafe_unita_org.id_backup
                        ,'STRUTTURA_LOGICA'
                        ,''
                        ,p_new_anagrafe_unita_org.amministrazione
                        ,p_new_anagrafe_unita_org.ottica);
      end if;
   
   end;

   --------------------------------------------------------------------------------

   procedure registra_componente
   (
      p_new_componente in componenti_b%rowtype
     ,p_old_componente in componenti_b%rowtype
     ,p_operazione     in varchar2
   ) is
      d_new_componente  componenti_b%rowtype := p_new_componente;
      d_old_componente  componenti_b%rowtype := p_old_componente;
      d_revisione_mod   revisioni_struttura.revisione%type := revisione_struttura.get_revisione_mod(p_new_componente.ottica);
      d_amministrazione ottiche.amministrazione%type := ottica.get_amministrazione(p_new_componente.ottica);
   begin
      get_note;
   
      get_id;
   
      get_ultima_revisione(p_new_componente.ottica);
   
      if nvl(d_new_componente.revisione_assegnazione, -2) = d_revisione_mod or
         nvl(d_new_componente.revisione_cessazione, -2) = d_revisione_mod then
         d_new_componente.contesto := 'T';
         d_old_componente.contesto := 'T';
      elsif (nvl(d_new_componente.revisione_assegnazione, -2) = s_ultima_revisione or
            nvl(d_new_componente.revisione_cessazione, -2) = s_ultima_revisione) and
            (d_new_componente.dal_pubb is not null and d_old_componente.dal_pubb is null) or
            (d_new_componente.al_pubb is not null and d_old_componente.al_pubb is null) and
            (d_new_componente.progr_unita_organizzativa =
            d_old_componente.progr_unita_organizzativa and
            d_new_componente.dal = d_old_componente.dal and
            nvl(d_new_componente.al, to_date(3333333, 'j')) =
            nvl(d_old_componente.al, to_date(3333333, 'j'))) then
         d_new_componente.contesto := 'T';
         d_old_componente.contesto := 'T';
      else
         d_new_componente.contesto := 'X';
         d_old_componente.contesto := 'X';
      end if;
   
      if p_operazione in ('I', 'U') then
         d_new_componente.note_sessione   := s_note;
         d_new_componente.data_operazione := s_data;
      
         if p_operazione = 'I' then
            d_new_componente.id_backup  := s_id;
            d_new_componente.operazione := p_operazione;
            insert into componenti_b values d_new_componente;
         end if;
      end if;
      if p_operazione = 'U' then
         d_new_componente.operazione := 'AU';
         d_old_componente.operazione := 'BU';
         d_old_componente.id_backup  := s_id;
         get_id;
         d_new_componente.id_backup := s_id;
         insert into componenti_b values d_old_componente;
         insert into componenti_b values d_new_componente;
      end if;
      if p_operazione = 'D' then
         s_id_componente                  := d_old_componente.id_componente;
         s_revisione_assegnazione         := d_old_componente.revisione_assegnazione;
         s_revisione_cessazione           := d_old_componente.revisione_cessazione;
         d_old_componente.operazione      := p_operazione;
         d_old_componente.note_sessione   := s_note;
         d_old_componente.data_operazione := s_data;
         d_old_componente.id_backup       := s_id;
         insert into componenti_b values d_old_componente;
      end if;
   
      --registra l'evento della modifica se extra revisione
      if nvl(d_new_componente.contesto, d_old_componente.contesto) = 'X' then
         registra_evento('COMPONENTI'
                        ,d_new_componente.id_backup
                        ,'COMPONENTI'
                        ,''
                        ,d_amministrazione
                        ,p_new_componente.ottica);
      end if;
   
   end;

   --------------------------------------------------------------------------------

   procedure registra_attributo_componente
   (
      p_new_attributo_componente in attributi_componente_b%rowtype
     ,p_old_attributo_componente in attributi_componente_b%rowtype
     ,p_operazione               in varchar2
   ) is
      d_new_attributo_componente attributi_componente_b%rowtype := p_new_attributo_componente;
      d_old_attributo_componente attributi_componente_b%rowtype := p_old_attributo_componente;
      d_revisione_mod            revisioni_struttura.revisione%type := revisione_struttura.get_revisione_mod(nvl(p_new_attributo_componente.ottica
                                                                                                                ,p_old_attributo_componente.ottica));
      d_amministrazione          ottiche.amministrazione%type := ottica.get_amministrazione(nvl(p_new_attributo_componente.ottica
                                                                                               ,p_old_attributo_componente.ottica));
   
   begin
      get_note;
   
      get_id;
   
      if nvl(d_new_attributo_componente.revisione_assegnazione, -2) = d_revisione_mod or
         nvl(d_new_attributo_componente.revisione_cessazione, -2) = d_revisione_mod then
         d_new_attributo_componente.contesto := 'T';
         d_old_attributo_componente.contesto := 'T';
      else
         d_new_attributo_componente.contesto := 'X';
         d_old_attributo_componente.contesto := 'X';
      end if;
   
      if p_operazione in ('I', 'U') then
         d_new_attributo_componente.note_sessione   := s_note;
         d_new_attributo_componente.data_operazione := s_data;
      
         if p_operazione = 'I' then
            d_new_attributo_componente.id_backup  := s_id;
            d_new_attributo_componente.operazione := p_operazione;
            insert into attributi_componente_b values d_new_attributo_componente;
         end if;
      end if;
      if p_operazione = 'U' then
         d_new_attributo_componente.operazione := 'AU';
         d_old_attributo_componente.operazione := 'BU';
         d_old_attributo_componente.id_backup  := s_id;
         get_id;
         d_new_attributo_componente.id_backup := s_id;
         insert into attributi_componente_b values d_old_attributo_componente;
         insert into attributi_componente_b values d_new_attributo_componente;
      end if;
      if p_operazione = 'D' then
         d_old_attributo_componente.operazione      := p_operazione;
         d_old_attributo_componente.note_sessione   := s_note;
         d_old_attributo_componente.data_operazione := s_data;
         d_old_attributo_componente.id_backup       := s_id;
         insert into attributi_componente_b values d_old_attributo_componente;
      end if;
   
      if nvl(d_new_attributo_componente.contesto, d_old_attributo_componente.contesto) = 'X' then
         registra_evento('ATTRIBUTI_COMPONENTE'
                        ,d_new_attributo_componente.id_backup
                        ,'COMPONENTI'
                        ,''
                        ,d_amministrazione
                        ,p_new_attributo_componente.ottica);
      end if;
   
   end;

   --------------------------------------------------------------------------------

   procedure registra_ruolo_componente
   (
      p_new_ruolo_componente in ruoli_componente_b%rowtype
     ,p_old_ruolo_componente in ruoli_componente_b%rowtype
     ,p_operazione           in varchar2
   ) is
      d_new_ruolo_componente   ruoli_componente_b%rowtype := p_new_ruolo_componente;
      d_old_ruolo_componente   ruoli_componente_b%rowtype := p_old_ruolo_componente;
      d_revisione_mod          revisioni_struttura.revisione%type;
      d_revisione_assegnazione componenti.revisione_assegnazione%type;
      d_revisione_cessazione   componenti.revisione_cessazione%type;
      d_amministrazione        amministrazioni.codice_amministrazione%type;
      d_ottica                 ottiche.ottica%type;
   begin
      get_note;
   
      get_id;
   
      begin
         --#600
         select revisione_struttura.get_revisione_mod(ottica)
               ,revisione_assegnazione
               ,revisione_cessazione
               ,ottica.get_amministrazione(c.ottica)
               ,c.ottica
           into d_revisione_mod
               ,d_revisione_assegnazione
               ,d_revisione_cessazione
               ,d_amministrazione
               ,d_ottica
           from componenti c
          where id_componente = nvl(p_new_ruolo_componente.id_componente
                                   ,p_old_ruolo_componente.id_componente);
      exception
         when no_data_found then
            d_amministrazione        := ottica.get_amministrazione(s_ottica);
            d_revisione_mod          := revisione_struttura.get_revisione_mod(s_ottica);
            d_revisione_assegnazione := s_revisione_assegnazione;
            d_revisione_cessazione   := s_revisione_cessazione;
            d_ottica                 := s_ottica;
      end;
   
      if nvl(d_revisione_assegnazione, -2) = d_revisione_mod or
         nvl(d_revisione_cessazione, -2) = d_revisione_mod then
         d_new_ruolo_componente.contesto := 'T';
         d_old_ruolo_componente.contesto := 'T';
      else
         d_new_ruolo_componente.contesto := 'X';
         d_old_ruolo_componente.contesto := 'X';
      end if;
   
      if p_operazione in ('I', 'U') then
         d_new_ruolo_componente.note_sessione   := s_note;
         d_new_ruolo_componente.data_operazione := s_data;
      
         if p_operazione = 'I' then
            d_new_ruolo_componente.id_backup  := s_id;
            d_new_ruolo_componente.operazione := p_operazione;
            insert into ruoli_componente_b values d_new_ruolo_componente;
         end if;
      end if;
      if p_operazione = 'U' then
         d_new_ruolo_componente.operazione := 'AU';
         d_old_ruolo_componente.operazione := 'BU';
         d_old_ruolo_componente.id_backup  := s_id;
         get_id;
         d_new_ruolo_componente.id_backup := s_id;
         insert into ruoli_componente_b values d_old_ruolo_componente;
         insert into ruoli_componente_b values d_new_ruolo_componente;
      end if;
      if p_operazione = 'D' then
         d_old_ruolo_componente.operazione      := p_operazione;
         d_old_ruolo_componente.note_sessione   := s_note;
         d_old_ruolo_componente.data_operazione := s_data;
         d_old_ruolo_componente.id_backup       := s_id;
         insert into ruoli_componente_b values d_old_ruolo_componente;
      end if;
   
      if nvl(d_new_ruolo_componente.contesto, d_old_ruolo_componente.contesto) = 'X' then
         registra_evento('RUOLI_COMPONENTE'
                        ,d_new_ruolo_componente.id_backup
                        ,'COMPONENTI'
                        ,''
                        ,d_amministrazione
                        ,d_ottica);
      end if;
   
   end;

   --------------------------------------------------------------------------------

   procedure registra_imputazione_bilancio
   (
      p_new_imputazione_bilancio in imputazioni_bilancio_b%rowtype
     ,p_old_imputazione_bilancio in imputazioni_bilancio_b%rowtype
     ,p_operazione               in varchar2
   ) is
      d_new_imputazione_bilancio imputazioni_bilancio_b%rowtype := p_new_imputazione_bilancio;
      d_old_imputazione_bilancio imputazioni_bilancio_b%rowtype := p_old_imputazione_bilancio;
      d_revisione_mod            revisioni_struttura.revisione%type;
      d_revisione_assegnazione   componenti.revisione_assegnazione%type;
      d_revisione_cessazione     componenti.revisione_cessazione%type;
      d_amministrazione          amministrazioni.codice_amministrazione%type;
      d_ottica                   ottiche.ottica%type;
   begin
      get_note;
   
      get_id;
   
      begin
         --#600
         select revisione_struttura.get_revisione_mod(ottica)
               ,revisione_assegnazione
               ,revisione_cessazione
               ,ottica.get_amministrazione(c.ottica)
               ,c.ottica
           into d_revisione_mod
               ,d_revisione_assegnazione
               ,d_revisione_cessazione
               ,d_amministrazione
               ,d_ottica
           from componenti c
          where id_componente =
                nvl(p_new_imputazione_bilancio.id_componente
                   ,p_old_imputazione_bilancio.id_componente);
      exception
         when no_data_found then
            d_amministrazione        := ottica.get_amministrazione(s_ottica);
            d_revisione_mod          := revisione_struttura.get_revisione_mod(s_ottica);
            d_revisione_assegnazione := s_revisione_assegnazione;
            d_revisione_cessazione   := s_revisione_cessazione;
            d_ottica                 := s_ottica;
      end;
   
      if nvl(d_revisione_assegnazione, -2) = d_revisione_mod or
         nvl(d_revisione_cessazione, -2) = d_revisione_mod then
         d_new_imputazione_bilancio.contesto := 'T';
         d_old_imputazione_bilancio.contesto := 'T';
      else
         d_new_imputazione_bilancio.contesto := 'X';
         d_old_imputazione_bilancio.contesto := 'X';
      end if;
   
      if p_operazione in ('I', 'U') then
         d_new_imputazione_bilancio.note_sessione   := s_note;
         d_new_imputazione_bilancio.data_operazione := s_data;
      
         if p_operazione = 'I' then
            d_new_imputazione_bilancio.id_backup  := s_id;
            d_new_imputazione_bilancio.operazione := p_operazione;
            insert into imputazioni_bilancio_b values d_new_imputazione_bilancio;
         end if;
      end if;
      if p_operazione = 'U' then
         d_new_imputazione_bilancio.operazione := 'AU';
         d_old_imputazione_bilancio.operazione := 'BU';
         d_old_imputazione_bilancio.id_backup  := s_id;
         get_id;
         d_new_imputazione_bilancio.id_backup := s_id;
         insert into imputazioni_bilancio_b values d_old_imputazione_bilancio;
         insert into imputazioni_bilancio_b values d_new_imputazione_bilancio;
      end if;
      if p_operazione = 'D' then
         d_old_imputazione_bilancio.operazione      := p_operazione;
         d_old_imputazione_bilancio.note_sessione   := s_note;
         d_old_imputazione_bilancio.data_operazione := s_data;
         d_old_imputazione_bilancio.id_backup       := s_id;
         insert into imputazioni_bilancio_b values d_old_imputazione_bilancio;
      end if;
   
      if nvl(d_new_imputazione_bilancio.contesto, d_old_imputazione_bilancio.contesto) = 'X' then
         registra_evento('IMPUTAZIONI_BILANCIO'
                        ,d_new_imputazione_bilancio.id_backup
                        ,'COMPONENTI'
                        ,''
                        ,d_amministrazione
                        ,d_ottica);
      end if;
   
   end;

   --------------------------------------------------------------------------------

   procedure registra_ubicazione_componente
   (
      p_new_ubicazione_componente in ubicazioni_componente_b%rowtype
     ,p_old_ubicazione_componente in ubicazioni_componente_b%rowtype
     ,p_operazione                in varchar2
   ) is
      d_new_ubicazione_componente ubicazioni_componente_b%rowtype := p_new_ubicazione_componente;
      d_old_ubicazione_componente ubicazioni_componente_b%rowtype := p_old_ubicazione_componente;
      d_revisione_mod             revisioni_struttura.revisione%type;
      d_revisione_assegnazione    componenti.revisione_assegnazione%type;
      d_revisione_cessazione      componenti.revisione_cessazione%type;
   
   begin
      get_note;
   
      get_id;
   
      begin
         --#600
         select revisione_struttura.get_revisione_mod(ottica)
               ,revisione_assegnazione
               ,revisione_cessazione
           into d_revisione_mod
               ,d_revisione_assegnazione
               ,d_revisione_cessazione
           from componenti
          where id_componente =
                nvl(p_new_ubicazione_componente.id_componente
                   ,p_old_ubicazione_componente.id_componente);
      exception
         when no_data_found then
            d_revisione_mod          := revisione_struttura.get_revisione_mod(s_ottica);
            d_revisione_assegnazione := s_revisione_assegnazione;
            d_revisione_cessazione   := s_revisione_cessazione;
      end;
   
      if nvl(d_revisione_assegnazione, -2) = d_revisione_mod or
         nvl(d_revisione_cessazione, -2) = d_revisione_mod then
         d_new_ubicazione_componente.contesto := 'T';
         d_old_ubicazione_componente.contesto := 'T';
      else
         d_new_ubicazione_componente.contesto := 'X';
         d_old_ubicazione_componente.contesto := 'X';
      end if;
   
      if p_operazione in ('I', 'U') then
         d_new_ubicazione_componente.note_sessione   := s_note;
         d_new_ubicazione_componente.data_operazione := s_data;
      
         if p_operazione = 'I' then
            d_new_ubicazione_componente.id_backup  := s_id;
            d_new_ubicazione_componente.operazione := p_operazione;
            insert into ubicazioni_componente_b values d_new_ubicazione_componente;
         end if;
      end if;
      if p_operazione = 'U' then
         d_new_ubicazione_componente.operazione := 'AU';
         d_old_ubicazione_componente.operazione := 'BU';
         d_old_ubicazione_componente.id_backup  := s_id;
         get_id;
         d_new_ubicazione_componente.id_backup := s_id;
         insert into ubicazioni_componente_b values d_old_ubicazione_componente;
         insert into ubicazioni_componente_b values d_new_ubicazione_componente;
      end if;
      if p_operazione = 'D' then
         d_old_ubicazione_componente.operazione      := p_operazione;
         d_old_ubicazione_componente.note_sessione   := s_note;
         d_old_ubicazione_componente.data_operazione := s_data;
         d_old_ubicazione_componente.id_backup       := s_id;
         insert into ubicazioni_componente_b values d_old_ubicazione_componente;
      end if;
   end;

   --------------------------------------------------------------------------------

   procedure registra_unita_fisica
   (
      p_new_unita_fisica in unita_fisiche_b%rowtype
     ,p_old_unita_fisica in unita_fisiche_b%rowtype
     ,p_operazione       in varchar2
   ) is
      d_new_unita_fisica unita_fisiche_b%rowtype := p_new_unita_fisica;
      d_old_unita_fisica unita_fisiche_b%rowtype := p_old_unita_fisica;
   begin
      get_note;
   
      get_id;
   
      if p_operazione in ('I', 'U') then
         d_new_unita_fisica.note_sessione   := s_note;
         d_new_unita_fisica.data_operazione := s_data;
         d_new_unita_fisica.contesto        := 'X';
         if p_operazione = 'I' then
            d_new_unita_fisica.id_backup  := s_id;
            d_new_unita_fisica.operazione := p_operazione;
            insert into unita_fisiche_b values d_new_unita_fisica;
         end if;
      end if;
      if p_operazione = 'U' then
         d_new_unita_fisica.operazione := 'AU';
         d_old_unita_fisica.operazione := 'BU';
         d_old_unita_fisica.id_backup  := s_id;
         get_id;
         d_new_unita_fisica.id_backup := s_id;
         insert into unita_fisiche_b values d_old_unita_fisica;
         insert into unita_fisiche_b values d_new_unita_fisica;
      end if;
      if p_operazione = 'D' then
         d_old_unita_fisica.operazione      := p_operazione;
         d_old_unita_fisica.note_sessione   := s_note;
         d_old_unita_fisica.data_operazione := s_data;
         d_old_unita_fisica.id_backup       := s_id;
         d_old_unita_fisica.contesto        := 'X';
         insert into unita_fisiche_b values d_old_unita_fisica;
      end if;
   
      registra_evento('UNITA_FISICHE'
                     ,d_new_unita_fisica.id_backup
                     ,'STRUTTURA_FISICA'
                     ,''
                     ,d_new_unita_fisica.amministrazione
                     ,'');
   
   end;

   --------------------------------------------------------------------------------

   procedure registra_anagrafe_unita_fis
   (
      p_new_anagrafe_unita_fis in anagrafe_unita_fisiche_b%rowtype
     ,p_old_anagrafe_unita_fis in anagrafe_unita_fisiche_b%rowtype
     ,p_operazione             in varchar2
   ) is
      d_new_anagrafe_unita_fis anagrafe_unita_fisiche_b%rowtype := p_new_anagrafe_unita_fis;
      d_old_anagrafe_unita_fis anagrafe_unita_fisiche_b%rowtype := p_old_anagrafe_unita_fis;
   begin
      get_note;
   
      get_id;
   
      if p_operazione in ('I', 'U') then
         d_new_anagrafe_unita_fis.note_sessione   := s_note;
         d_new_anagrafe_unita_fis.data_operazione := s_data;
         d_new_anagrafe_unita_fis.contesto        := 'X';
         if p_operazione = 'I' then
            d_new_anagrafe_unita_fis.id_backup  := s_id;
            d_new_anagrafe_unita_fis.operazione := p_operazione;
            insert into anagrafe_unita_fisiche_b values d_new_anagrafe_unita_fis;
         end if;
      end if;
      if p_operazione = 'U' then
         d_new_anagrafe_unita_fis.operazione := 'AU';
         d_old_anagrafe_unita_fis.operazione := 'BU';
         d_old_anagrafe_unita_fis.id_backup  := s_id;
         get_id;
         d_new_anagrafe_unita_fis.id_backup := s_id;
         insert into anagrafe_unita_fisiche_b values d_old_anagrafe_unita_fis;
         insert into anagrafe_unita_fisiche_b values d_new_anagrafe_unita_fis;
      end if;
      if p_operazione = 'D' then
         d_old_anagrafe_unita_fis.operazione      := p_operazione;
         d_old_anagrafe_unita_fis.note_sessione   := s_note;
         d_old_anagrafe_unita_fis.data_operazione := s_data;
         d_old_anagrafe_unita_fis.id_backup       := s_id;
         d_old_anagrafe_unita_fis.contesto        := 'X';
         insert into anagrafe_unita_fisiche_b values d_old_anagrafe_unita_fis;
      end if;
   
      registra_evento('ANAGRAFE_UNITA_FISICHE'
                     ,d_new_anagrafe_unita_fis.id_backup
                     ,'STRUTTURA_FISICA'
                     ,''
                     ,d_new_anagrafe_unita_fis.amministrazione
                     ,'');
   
   end;

   --------------------------------------------------------------------------------

   procedure registra_ubicazione_unita
   (
      p_new_ubicazione_unita in ubicazioni_unita_b%rowtype
     ,p_old_ubicazione_unita in ubicazioni_unita_b%rowtype
     ,p_operazione           in varchar2
   ) is
      d_new_ubicazione_unita   ubicazioni_unita_b%rowtype := p_new_ubicazione_unita;
      d_old_ubicazione_unita   ubicazioni_unita_b%rowtype := p_old_ubicazione_unita;
      d_revisione_mod          revisioni_struttura.revisione%type;
      d_revisione_assegnazione componenti.revisione_assegnazione%type;
      d_revisione_cessazione   componenti.revisione_cessazione%type;
   
   begin
      get_note;
   
      get_id;
   
      select revisione_struttura.get_revisione_mod(a.ottica)
            ,a.revisione_istituzione
            ,a.revisione_cessazione
        into d_revisione_mod
            ,d_revisione_assegnazione
            ,d_revisione_cessazione
        from anagrafe_unita_organizzative a
       where progr_unita_organizzativa =
             nvl(p_new_ubicazione_unita.progr_unita_organizzativa
                ,p_old_ubicazione_unita.progr_unita_organizzativa)
         and dal = (select max(dal)
                      from anagrafe_unita_organizzative
                     where progr_unita_organizzativa = a.progr_unita_organizzativa);
   
      if nvl(d_revisione_assegnazione, -2) = d_revisione_mod or
         nvl(d_revisione_cessazione, -2) = d_revisione_mod then
         d_new_ubicazione_unita.contesto := 'T';
         d_old_ubicazione_unita.contesto := 'T';
      else
         d_new_ubicazione_unita.contesto := 'X';
         d_old_ubicazione_unita.contesto := 'X';
      end if;
   
      if p_operazione in ('I', 'U') then
         d_new_ubicazione_unita.note_sessione   := s_note;
         d_new_ubicazione_unita.data_operazione := s_data;
      
         if p_operazione = 'I' then
            d_new_ubicazione_unita.id_backup  := s_id;
            d_new_ubicazione_unita.operazione := p_operazione;
            insert into ubicazioni_unita_b values d_new_ubicazione_unita;
         end if;
      end if;
      if p_operazione = 'U' then
         d_new_ubicazione_unita.operazione := 'AU';
         d_old_ubicazione_unita.operazione := 'BU';
         d_old_ubicazione_unita.id_backup  := s_id;
         get_id;
         d_new_ubicazione_unita.id_backup := s_id;
         insert into ubicazioni_unita_b values d_old_ubicazione_unita;
         insert into ubicazioni_unita_b values d_new_ubicazione_unita;
      end if;
      if p_operazione = 'D' then
         d_old_ubicazione_unita.operazione      := p_operazione;
         d_old_ubicazione_unita.note_sessione   := s_note;
         d_old_ubicazione_unita.data_operazione := s_data;
         d_old_ubicazione_unita.id_backup       := s_id;
         insert into ubicazioni_unita_b values d_old_ubicazione_unita;
      end if;
   end;

   --------------------------------------------------------------------------------

   procedure registra_assegnazione_fisica
   (
      p_new_assegnazione_fisica in assegnazioni_fisiche_b%rowtype
     ,p_old_assegnazione_fisica in assegnazioni_fisiche_b%rowtype
     ,p_operazione              in varchar2
   ) is
      d_new_assegnazione_fisica assegnazioni_fisiche_b%rowtype := p_new_assegnazione_fisica;
      d_old_assegnazione_fisica assegnazioni_fisiche_b%rowtype := p_old_assegnazione_fisica;
      d_amministrazione         anagrafe_unita_fisiche.amministrazione%type;
   
   begin
      d_amministrazione := anagrafe_unita_fisica.get_amministrazione(nvl(p_new_assegnazione_fisica.progr_unita_fisica
                                                                        ,p_old_assegnazione_fisica.progr_unita_fisica)
                                                                    ,anagrafe_unita_fisica.get_dal_id(nvl(p_new_assegnazione_fisica.progr_unita_fisica
                                                                                                         ,p_old_assegnazione_fisica.progr_unita_fisica)
                                                                                                     ,nvl(p_new_assegnazione_fisica.dal
                                                                                                         ,p_old_assegnazione_fisica.dal)));
   
      get_note;
   
      get_id;
   
      if p_operazione in ('I', 'U') then
         d_new_assegnazione_fisica.note_sessione   := s_note;
         d_new_assegnazione_fisica.data_operazione := s_data;
         d_new_assegnazione_fisica.contesto        := 'X';
         if p_operazione = 'I' then
            d_new_assegnazione_fisica.id_backup  := s_id;
            d_new_assegnazione_fisica.operazione := p_operazione;
            insert into assegnazioni_fisiche_b values d_new_assegnazione_fisica;
         end if;
      end if;
      if p_operazione = 'U' then
         d_new_assegnazione_fisica.operazione := 'AU';
         d_old_assegnazione_fisica.operazione := 'BU';
         d_old_assegnazione_fisica.id_backup  := s_id;
         get_id;
         d_new_assegnazione_fisica.id_backup := s_id;
         insert into assegnazioni_fisiche_b values d_old_assegnazione_fisica;
         insert into assegnazioni_fisiche_b values d_new_assegnazione_fisica;
      end if;
      if p_operazione = 'D' then
         d_old_assegnazione_fisica.operazione      := p_operazione;
         d_old_assegnazione_fisica.note_sessione   := s_note;
         d_old_assegnazione_fisica.data_operazione := s_data;
         d_old_assegnazione_fisica.id_backup       := s_id;
         d_old_assegnazione_fisica.contesto        := 'X';
         insert into assegnazioni_fisiche_b values d_old_assegnazione_fisica;
      end if;
   
      registra_evento('ASSEGNAZIONI_FISICHE'
                     ,d_new_assegnazione_fisica.id_backup
                     ,'ASSEGNAZIONI_FISICHE'
                     ,''
                     ,d_amministrazione
                     ,'');
   
   end;

   --------------------------------------------------------------------------------

   procedure registra_soggetto_rubrica
   (
      p_new_soggetto_rubrica in soggetti_rubrica_b%rowtype
     ,p_old_soggetto_rubrica in soggetti_rubrica_b%rowtype
     ,p_operazione           in varchar2
   ) is
      d_new_soggetto_rubrica soggetti_rubrica_b%rowtype := p_new_soggetto_rubrica;
      d_old_soggetto_rubrica soggetti_rubrica_b%rowtype := p_old_soggetto_rubrica;
   begin
      get_note;
   
      get_id;
   
      if p_operazione in ('I', 'U') then
         d_new_soggetto_rubrica.note_sessione   := s_note;
         d_new_soggetto_rubrica.data_operazione := s_data;
         d_new_soggetto_rubrica.contesto        := 'X';
         if p_operazione = 'I' then
            d_new_soggetto_rubrica.id_backup  := s_id;
            d_new_soggetto_rubrica.operazione := p_operazione;
            insert into soggetti_rubrica_b values d_new_soggetto_rubrica;
         end if;
      end if;
      if p_operazione = 'U' then
         d_new_soggetto_rubrica.operazione := 'AU';
         d_old_soggetto_rubrica.operazione := 'BU';
         d_old_soggetto_rubrica.id_backup  := s_id;
         get_id;
         d_new_soggetto_rubrica.id_backup := s_id;
         insert into soggetti_rubrica_b values d_old_soggetto_rubrica;
         insert into soggetti_rubrica_b values d_new_soggetto_rubrica;
      end if;
      if p_operazione = 'D' then
         d_old_soggetto_rubrica.operazione      := p_operazione;
         d_old_soggetto_rubrica.note_sessione   := s_note;
         d_old_soggetto_rubrica.data_operazione := s_data;
         d_old_soggetto_rubrica.id_backup       := s_id;
         d_old_soggetto_rubrica.contesto        := 'X';
         insert into soggetti_rubrica_b values d_old_soggetto_rubrica;
      end if;
   
      registra_evento('SOGGETTI_RUBRICA'
                     ,d_new_soggetto_rubrica.id_backup
                     ,'RUBRICA_CONTATTI'
                     ,''
                     ,''
                     ,'');
   
   end;

--------------------------------------------------------------------------------

end so4_pubblicazione_modifiche;
/

