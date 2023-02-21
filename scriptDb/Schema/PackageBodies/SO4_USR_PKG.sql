CREATE OR REPLACE package body so4_usr_pkg is
   /******************************************************************************
    NOME:        SO4_USR_PKG.
    DESCRIZIONE: Procedure e Funzioni per integrazione con Vitrociset al CRV
   
    ANNOTAZIONI: .
   
    REVISIONI: .
    Rev.  Data        Autore  Descrizione.
    000    23/03/2010        Prima emissione.
    001    23/09/2010        Chiusura ruolo al giorno prima.
   ******************************************************************************/

   s_revisione_body constant varchar2(30) := '001';

   ----------------------------------------------------------------------------------

   s_error_table afc_error.t_error_table;

   function versione return varchar2 is
      /******************************************************************************
       NOME:        versione.
       DESCRIZIONE: Restituisce versione e revisione di distribuzione del package.
      
       RITORNA:     VARCHAR2 stringa contenente versione e revisione.
       NOTE:        Primo numero  : versione compatibilita del Package.
                    Secondo numero: revisione del Package specification.
                    Terzo numero  : revisione del Package body.
      ******************************************************************************/
   begin
      return s_revisione || '.' || s_revisione_body;
   end versione;

   procedure aggiorna_nominativo
   (
      p_ad4_utente     varchar2
     ,p_new_nominativo varchar2
   ) is
      pragma autonomous_transaction;
   begin
      ad4_utente.initialize(p_utente => p_ad4_utente);
      ad4_utente.set_nominativo(p_new_nominativo);
      ad4_utente.update_utente('N');
      commit;
   end;

   function nulla return varchar2 is
   begin
      return null;
   end;

   --------------------------------------------------------------------------------   

   procedure annulla_ruoli
   (
      p_ni        as4_anagrafe_soggetti.ni%type
     ,p_codice_uo anagrafe_unita_organizzative.codice_uo%type default null
     ,p_aoo       aoo.codice_aoo%type default null
   ) is
   
      --pragma autonomous_transaction;
   
      d_amministrazione amministrazioni.codice_amministrazione%type;
      d_ottica_ist      ottiche.ottica%type;
      d_rev_mod         revisioni_struttura.revisione%type;
      d_progr_uo        anagrafe_unita_organizzative.progr_unita_organizzativa%type;
      d_id_componente   componenti.id_componente%type;
   
   begin
      -- determina l'ottica istituzionale (o direttamente dalla tabella OTTICHE oppure determinando l'AMMINISTRAZIONE partendo dall'AOO) 
      if p_aoo is null then
      
         begin
         
            select min(o.ottica)
              into d_ottica_ist
              from ottiche o
             where o.ottica_istituzionale = 'SI';
         
         exception
            when others then
               raise_application_error(s_err_select_ott_number
                                      ,s_err_select_ott_msg
                                      ,true);
         end;
      
      else
      
         begin
         
            select a.codice_amministrazione
              into d_amministrazione
              from aoo a
             where a.codice_aoo = p_aoo
               and trunc(sysdate) between a.dal and nvl(a.al, trunc(sysdate));
         
         exception
            when others then
               raise_application_error(s_err_select_amm_number
                                      ,s_err_select_amm_msg
                                      ,true);
         end;
      
         d_ottica_ist := ottica.get_ottica_per_amm(d_amministrazione);
      
      end if;
   
      -- se il codice uo non è nullo annullo i ruoli del componente
      if p_codice_uo is not null then
      
         -- determina l'eventuale revisione in modifica
         d_rev_mod := revisione_struttura.get_revisione_mod(d_ottica_ist);
      
         -- determina il PROGRESSIVO dell'UO
         begin
         
            d_progr_uo := anagrafe_unita_organizzativa.get_progr_unor(p_ottica          => d_ottica_ist
                                                                     ,p_amministrazione => d_amministrazione
                                                                     ,p_codice_uo       => p_codice_uo
                                                                     ,p_utente_ad4      => null
                                                                     ,p_data            => trunc(sysdate));
         exception
            when others then
               raise_application_error(s_err_progr_uo_number, s_err_progr_uo_msg, true);
         end;
      
         -- determina l'ID COMPONENTE
         begin
         
            select c.id_componente
              into d_id_componente
              from componenti c
             where c.ni = p_ni
               and c.progr_unita_organizzativa = d_progr_uo
               and c.ottica = d_ottica_ist
               and trunc(sysdate) between c.dal and
                   nvl(decode(c.revisione_cessazione, d_rev_mod, to_date(null), c.al)
                      ,trunc(sysdate))
               and nvl(c.revisione_assegnazione, -2) <> d_rev_mod;
         
         exception
            when others then
               raise_application_error(s_err_id_comp_number, s_err_id_comp_msg, true);
         end;
      
         -- cancella i ruoli attivati oggi, non posso chiuderli a ieri,
         -- probabilmente era un errore in inserimento
         declare
            cursor c_ruol is
               select *
                 from ruoli_componente
                where dal = trunc(sysdate)
                  and id_componente = d_id_componente
                  for update;
         begin
            for v_ruol in c_ruol
            loop
               delete ruoli_componente where current of c_ruol;
            end loop;
         
         exception
            when others then
               raise_application_error(s_err_cancella_ruoli_number
                                      ,s_err_cancella_ruoli_msg
                                      ,true);
         end;
      
         -- aggiorna tutti i ruoli del componente
         begin
         
            update ruoli_componente r
               set r.al                   = trunc(sysdate) - 1
                  ,r.utente_aggiornamento = 'Aut.LDAP'
                  ,r.data_aggiornamento   = sysdate
             where r.id_componente = d_id_componente
               and trunc(sysdate) between r.dal and nvl(r.al, trunc(sysdate));
         
         exception
            when others then
               raise_application_error(s_err_annulla_ruoli_number
                                      ,s_err_annulla_ruoli_msg
                                      ,true);
         end;
      
      else
         --altrimenti annullo tutti i ruoli del soggetto     
      
         for d_id_componente in (select c.id_componente
                                   from componenti c
                                  where c.ni = p_ni
                                    and c.ottica = d_ottica_ist)
         loop
         
            -- cancella i ruoli attivati oggi, non posso chiuderli a ieri,
            -- probabilmente era un errore in inserimento
            declare
               cursor c_ruol is
                  select *
                    from ruoli_componente
                   where dal = trunc(sysdate)
                     and id_componente = d_id_componente.id_componente
                     for update;
            begin
               for v_ruol in c_ruol
               loop
                  delete ruoli_componente where current of c_ruol;
               end loop;
            
            exception
               when others then
                  raise_application_error(s_err_cancella_ruoli_number
                                         ,s_err_cancella_ruoli_msg
                                         ,true);
            end;
            -- aggiorna tutti i ruoli del soggetto
            begin
            
               update ruoli_componente r
                  set r.al                   = trunc(sysdate) - 1
                     ,r.utente_aggiornamento = 'Aut.LDAP'
                     ,r.data_aggiornamento   = sysdate
                where r.id_componente = d_id_componente.id_componente
                  and trunc(sysdate) between r.dal and nvl(r.al, trunc(sysdate));
            
            exception
               when others then
                  raise_application_error(s_err_annulla_ruoli_number
                                         ,s_err_annulla_ruoli_msg);
            end;
         
         end loop;
      
      end if;
   
   end; --so4_usr_pkg.annulla_ruoli

   --------------------------------------------------------------------------------   

   procedure assegna_ruolo
   (
      p_ni        as4_anagrafe_soggetti.ni%type
     ,p_codice_uo anagrafe_unita_organizzative.codice_uo%type
     ,p_aoo       aoo.codice_aoo%type default null
     ,p_ruolo     ruoli_componente.ruolo%type
   ) is
   
      --pragma autonomous_transaction;
   
      d_amministrazione amministrazioni.codice_amministrazione%type;
      d_ottica_ist      ottiche.ottica%type;
      d_rev_mod         revisioni_struttura.revisione%type;
      d_progr_uo        anagrafe_unita_organizzative.progr_unita_organizzativa%type;
      d_id_componente   componenti.id_componente%type;
      d_ruoli_row       ruoli_componente%rowtype;
   
   begin
      -- determina l'ottica istituzionale (o direttamente dalla tabella OTTICHE oppure determinando l'AMMINISTRAZIONE partendo dall'AOO) 
      if p_aoo is null then
      
         begin
         
            select min(o.ottica)
              into d_ottica_ist
              from ottiche o
             where o.ottica_istituzionale = 'SI';
         
         exception
            when others then
               raise_application_error(s_err_select_ott_number
                                      ,s_err_select_ott_msg
                                      ,true);
         end;
      
      else
      
         begin
         
            select a.codice_amministrazione
              into d_amministrazione
              from aoo a
             where a.codice_aoo = p_aoo
               and trunc(sysdate) between a.dal and nvl(a.al, trunc(sysdate));
         
         exception
            when others then
               raise_application_error(s_err_select_amm_number
                                      ,s_err_select_amm_msg
                                      ,true);
         end;
      
         d_ottica_ist := ottica.get_ottica_per_amm(d_amministrazione);
      
      end if;
   
      -- determina l'eventuale revisione in modifica
      d_rev_mod := revisione_struttura.get_revisione_mod(d_ottica_ist);
   
      -- determina il PROGRESSIVO dell'UO
      begin
      
         d_progr_uo := anagrafe_unita_organizzativa.get_progr_unor(p_ottica          => d_ottica_ist
                                                                  ,p_amministrazione => d_amministrazione
                                                                  ,p_codice_uo       => p_codice_uo
                                                                  ,p_utente_ad4      => null
                                                                  ,p_data            => trunc(sysdate));
      exception
         when others then
            raise_application_error(s_err_progr_uo_number, s_err_progr_uo_msg, true);
      end;
   
      -- determina l'ID COMPONENTE
      begin
      
         select c.id_componente
           into d_id_componente
           from componenti c
          where c.ni = p_ni
            and c.progr_unita_organizzativa = d_progr_uo
            and c.ottica = d_ottica_ist
            and trunc(sysdate) between c.dal and
                nvl(decode(c.revisione_cessazione, d_rev_mod, to_date(null), c.al)
                   ,trunc(sysdate))
            and nvl(c.revisione_assegnazione, -2) <> d_rev_mod;
      
      exception
         when others then
            raise_application_error(s_err_id_comp_number, s_err_id_comp_msg, true);
      end;
   
      -- estrae l'eventuale ruolo
      begin
      
         select r.*
           into d_ruoli_row
           from ruoli_componente r
          where r.id_componente = d_id_componente
            and r.ruolo = p_ruolo
            and nvl(r.al, trunc(sysdate) - 1) = trunc(sysdate) - 1;
      
      exception
         when no_data_found then
         
            -- se il ruolo non esiste lo inserisce
            begin
               ruolo_componente.ins(p_id_ruolo_componente  => null
                                   ,p_id_componente        => d_id_componente
                                   ,p_ruolo                => p_ruolo
                                   ,p_dal                  => trunc(sysdate)
                                   ,p_al                   => null
                                   ,p_dal_pubb             => trunc(sysdate)
                                   ,p_al_pubb              => null
                                   ,p_al_prec              => null
                                   ,p_utente_aggiornamento => 'Aut.LDAP'
                                   ,p_data_aggiornamento   => trunc(sysdate));
            exception
               when others then
                  raise_application_error(s_err_insert_ruolo_number
                                         ,s_err_insert_ruolo_msg
                                         ,true);
            end;
         
            dbms_output.put_line('Ruolo inserito');
         
            return;
         
         when others then
            raise_application_error(s_err_select_ruolo_number
                                   ,s_err_select_ruolo_msg
                                   ,true);
      end;
   
      -- se il ruolo esiste controlla la validità
      if d_ruoli_row.al = trunc(sysdate) - 1 then
      
         begin
            dbms_output.put_line('esiste');
            update ruoli_componente r
               set r.al                   = null
                  ,r.utente_aggiornamento = 'Aut.LDAP'
                  ,r.data_aggiornamento   = sysdate
             where r.id_componente = d_id_componente
               and r.id_ruolo_componente = d_ruoli_row.id_ruolo_componente;
         
         exception
            when others then
               raise_application_error(s_err_annulla_ruoli_number
                                      ,s_err_annulla_ruoli_msg
                                      ,true);
         end;
         dbms_output.put_line('Ruolo aggiornato');
      else
         -- già precedentemente aperto e con al nullo
         dbms_output.put_line('Niente');
         return;
      end if;
   
   end; --so4_usr_pkg.assegna_ruolo

   --------------------------------------------------------------------------------

   function get_telefono_fisso(p_ni in soggetti_rubrica.ni%type)
      return soggetti_rubrica.contatto%type is
   
   begin
   
      begin
         return soggetti_rubrica_tpk.get_contatto(p_ni            => p_ni
                                                 ,p_tipo_contatto => 10
                                                 ,p_progressivo   => 1);
      exception
         when no_data_found then
            return null;
      end;
   
   end; -- so4_usr_pkg.get_telefono_fisso

   ---------------------------------------------------------------------------------

   function get_cellulare(p_ni in soggetti_rubrica.ni%type)
      return soggetti_rubrica.contatto%type is
   
   begin
   
      begin
         return soggetti_rubrica_tpk.get_contatto(p_ni            => p_ni
                                                 ,p_tipo_contatto => 20
                                                 ,p_progressivo   => 1);
      exception
         when no_data_found then
            return null;
      end;
   
   end; -- so4_usr_pkg.get_cellulare

   ---------------------------------------------------------------------------------

   function get_email(p_ni in soggetti_rubrica.ni%type)
      return soggetti_rubrica.contatto%type is
   
   begin
   
      begin
         return soggetti_rubrica_tpk.get_contatto(p_ni            => p_ni
                                                 ,p_tipo_contatto => 40
                                                 ,p_progressivo   => 1);
      exception
         when no_data_found then
            return null;
      end;
   
   end; -- so4_usr_pkg.get_eamil

   ---------------------------------------------------------------------------------

   function get_fax(p_ni in soggetti_rubrica.ni%type) return soggetti_rubrica.contatto%type is
   
   begin
   
      begin
         return soggetti_rubrica_tpk.get_contatto(p_ni            => p_ni
                                                 ,p_tipo_contatto => 50
                                                 ,p_progressivo   => 1);
      exception
         when no_data_found then
            return null;
      end;
   
   end; -- so4_usr_pkg.get_fax

   ---------------------------------------------------------------------------------

   procedure set_telefono_fisso
   (
      p_ni    in soggetti_rubrica.ni%type
     ,p_value in soggetti_rubrica.contatto%type
   ) is
   
      d_result afc_error.t_error_number;
   
   begin
   
      d_result := soggetti_rubrica_tpk.exists_id(p_ni            => p_ni
                                                ,p_tipo_contatto => 10
                                                ,p_progressivo   => 1);
      if d_result = afc_error.ok then
         if p_value is not null then
            soggetti_rubrica_tpk.set_contatto(p_ni            => p_ni
                                             ,p_tipo_contatto => 10
                                             ,p_progressivo   => 1
                                             ,p_value         => p_value);
            soggetti_rubrica_tpk.set_pubblicabile(p_ni            => p_ni
                                                 ,p_tipo_contatto => 10
                                                 ,p_progressivo   => 1
                                                 ,p_value         => 'S');
         else
            soggetti_rubrica_tpk.del(p_check_old     => 0
                                    ,p_ni            => p_ni
                                    ,p_tipo_contatto => 10
                                    ,p_progressivo   => 1);
         end if;
      else
         if p_value is not null then
            soggetti_rubrica_tpk.ins(p_ni            => p_ni
                                    ,p_tipo_contatto => 10
                                    ,p_progressivo   => 1
                                    ,p_contatto      => p_value);
            soggetti_rubrica_tpk.set_pubblicabile(p_ni            => p_ni
                                                 ,p_tipo_contatto => 10
                                                 ,p_progressivo   => 1
                                                 ,p_value         => 'S');
         end if;
      end if;
   
   end set_telefono_fisso; -- so4_usr_pkg.set_telefono_fisso

   --------------------------------------------------------------------------------

   procedure set_cellulare
   (
      p_ni    in soggetti_rubrica.ni%type
     ,p_value in soggetti_rubrica.contatto%type
   ) is
   
      d_result afc_error.t_error_number;
   
   begin
   
      d_result := soggetti_rubrica_tpk.exists_id(p_ni            => p_ni
                                                ,p_tipo_contatto => 20
                                                ,p_progressivo   => 1);
   
      if d_result = afc_error.ok then
         if p_value is not null then
            soggetti_rubrica_tpk.set_contatto(p_ni            => p_ni
                                             ,p_tipo_contatto => 20
                                             ,p_progressivo   => 1
                                             ,p_value         => p_value);
            soggetti_rubrica_tpk.set_pubblicabile(p_ni            => p_ni
                                                 ,p_tipo_contatto => 20
                                                 ,p_progressivo   => 1
                                                 ,p_value         => 'S');
         else
            soggetti_rubrica_tpk.del(p_check_old     => 0
                                    ,p_ni            => p_ni
                                    ,p_tipo_contatto => 20
                                    ,p_progressivo   => 1);
         end if;
      else
         if p_value is not null then
            soggetti_rubrica_tpk.ins(p_ni            => p_ni
                                    ,p_tipo_contatto => 20
                                    ,p_progressivo   => 1
                                    ,p_contatto      => p_value);
            soggetti_rubrica_tpk.set_pubblicabile(p_ni            => p_ni
                                                 ,p_tipo_contatto => 20
                                                 ,p_progressivo   => 1
                                                 ,p_value         => 'S');
         end if;
      end if;
   
   end set_cellulare; -- so4_usr_pkg.set_cellulare

   --------------------------------------------------------------------------------

   procedure set_email
   (
      p_ni    in soggetti_rubrica.ni%type
     ,p_value in soggetti_rubrica.contatto%type
   ) is
   
      d_result afc_error.t_error_number;
   
   begin
   
      d_result := soggetti_rubrica_tpk.exists_id(p_ni            => p_ni
                                                ,p_tipo_contatto => 40
                                                ,p_progressivo   => 1);
   
      if d_result = afc_error.ok then
         if p_value is not null then
            soggetti_rubrica_tpk.set_contatto(p_ni            => p_ni
                                             ,p_tipo_contatto => 40
                                             ,p_progressivo   => 1
                                             ,p_value         => p_value);
            soggetti_rubrica_tpk.set_pubblicabile(p_ni            => p_ni
                                                 ,p_tipo_contatto => 40
                                                 ,p_progressivo   => 1
                                                 ,p_value         => 'S');
         
         else
            soggetti_rubrica_tpk.del(p_check_old     => 0
                                    ,p_ni            => p_ni
                                    ,p_tipo_contatto => 40
                                    ,p_progressivo   => 1);
         end if;
      else
         if p_value is not null then
            soggetti_rubrica_tpk.ins(p_ni            => p_ni
                                    ,p_tipo_contatto => 40
                                    ,p_progressivo   => 1
                                    ,p_contatto      => p_value);
            soggetti_rubrica_tpk.set_pubblicabile(p_ni            => p_ni
                                                 ,p_tipo_contatto => 40
                                                 ,p_progressivo   => 1
                                                 ,p_value         => 'S');
         end if;
      end if;
   
   end set_email; -- so4_usr_pkg.set_email

   --------------------------------------------------------------------------------

   procedure set_fax
   (
      p_ni    in soggetti_rubrica.ni%type
     ,p_value in soggetti_rubrica.contatto%type
   ) is
   
      d_result afc_error.t_error_number;
   
   begin
   
      d_result := soggetti_rubrica_tpk.exists_id(p_ni            => p_ni
                                                ,p_tipo_contatto => 50
                                                ,p_progressivo   => 1);
   
      if d_result = afc_error.ok then
         if p_value is not null then
            soggetti_rubrica_tpk.set_contatto(p_ni            => p_ni
                                             ,p_tipo_contatto => 50
                                             ,p_progressivo   => 1
                                             ,p_value         => p_value);
            soggetti_rubrica_tpk.set_pubblicabile(p_ni            => p_ni
                                                 ,p_tipo_contatto => 50
                                                 ,p_progressivo   => 1
                                                 ,p_value         => 'S');
         else
            soggetti_rubrica_tpk.del(p_check_old     => 0
                                    ,p_ni            => p_ni
                                    ,p_tipo_contatto => 50
                                    ,p_progressivo   => 1);
         end if;
      else
         if p_value is not null then
            soggetti_rubrica_tpk.ins(p_ni            => p_ni
                                    ,p_tipo_contatto => 50
                                    ,p_progressivo   => 1
                                    ,p_contatto      => p_value);
            soggetti_rubrica_tpk.set_pubblicabile(p_ni            => p_ni
                                                 ,p_tipo_contatto => 50
                                                 ,p_progressivo   => 1
                                                 ,p_value         => 'S');
         end if;
      end if;
   
   end set_fax; -- so4_usr_pkg.set_fax

--------------------------------------------------------------------------------

begin

   -- inserimento degli errori nella tabella
   s_error_table(s_err_progr_uo_number) := s_err_progr_uo_msg;
   s_error_table(s_err_id_comp_number) := s_err_id_comp_msg;
   s_error_table(s_err_annulla_ruoli_number) := s_err_annulla_ruoli_msg;
   s_error_table(s_err_select_ruolo_number) := s_err_select_ruolo_msg;
   s_error_table(s_err_insert_ruolo_number) := s_err_insert_ruolo_msg;
   s_error_table(s_err_select_amm_number) := s_err_select_amm_msg;
   s_error_table(s_err_select_ott_number) := s_err_select_ott_msg;

end so4_usr_pkg;
/

