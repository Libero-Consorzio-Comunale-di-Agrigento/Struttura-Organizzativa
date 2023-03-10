CREATE OR REPLACE package body attributi_unita_fisica_so_pkg is
   /******************************************************************************
    NOME:        attributi_unita_fisica_so_pkg
    DESCRIZIONE: Gestione tabella attributi_unita_fisica_so.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore      Descrizione.
    000   14/08/2012  mmonari     Generazione automatica 
    001   14/05/0213  adadamo     Aggiunta funzione per get dell'attributo
   ******************************************************************************/
   s_revisione_body constant afc.t_revision := '001 - 14/05/2013';
   --   /* SIAPKGen: generazione automatica */
   s_error_table  afc_error.t_error_table;
   s_error_detail afc_error.t_error_table;
   --
   s_dal_null date := to_date(2222222, 'j');
   s_al_null  date := to_date(3333333, 'j');
   s_dummy    varchar2(1);
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
   end versione; -- attributi_unita_fisica_so_pkg.versione
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
   end error_message; -- attributi_unita_fisica_so_pkg.error_message
   --------------------------------------------------------------------------------
   function is_dal_al_ok
   (
      p_dal in attributi_unita_fisica_so.dal%type
     ,p_al  in attributi_unita_fisica_so.al%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_dal_al_ok
       DESCRIZIONE: Controllo di congruenza tra data inizio e fine validit?
       PARAMETRI:   p_dal
                    p_al
       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number := afc_error.ok;
   begin
      if p_dal is null then
         d_result := s_dal_errato_num;
      end if;
      if d_result = afc_error.ok and nvl(p_dal, s_dal_null) > nvl(p_al, s_al_null) then
         dbms_output.put_line('verifica dal - al : ' || p_dal || ' ' || p_al);
         d_result := s_dal_al_errato_num;
      end if;
      dbc.post(not dbc.poston or d_result = afc_error.ok or d_result < 0
              ,'d_result = AFC_Error.ok or d_result < 0 on area_org_om.is_dal_al_ok');
      return d_result;
   end;
   --------------------------------------------------------------------------------
   function is_di_ok
   (
      p_dal in attributi_unita_fisica_so.dal%type
     ,p_al  in attributi_unita_fisica_so.al%type
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_DI_ok
       DESCRIZIONE: Function di gestione Data Integrity
       PARAMETRI:   is_dal_al_ok
                    is_tipo_assegnazione_ok
                    is_revisioni_ok
       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number := afc_error.ok;
   begin
      -- is_dal_al_ok
      d_result := is_dal_al_ok(p_dal, p_al);
      return d_result;
   end; -- attributo_componente.is_DI_ok
   --------------------------------------------------------------------------------
   procedure chk_di
   (
      p_dal in attributi_unita_fisica_so.dal%type
     ,p_al  in attributi_unita_fisica_so.al%type
   ) is
      /******************************************************************************
       NOME:        chk_DI.
       DESCRIZIONE: controllo integrita dati:
                    - dal < al
       RITORNA:     -
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
      d_result := is_di_ok(p_dal, p_al);
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, s_error_table(d_result));
      end if;
   end; -- attributo_componente.chk_DI
   --------------------------------------------------------------------------------
   function is_dal_ok
   (
      p_progr_uf  in attributi_unita_fisica_so.progr_unita_fisica%type
     ,p_attributo in attributi_unita_fisica_so.attributo%type
     ,p_new_dal   in attributi_unita_fisica_so.dal%type
     ,p_rowid     in rowid
     ,p_inserting in number
     ,p_updating  in number
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_dal_ok
       DESCRIZIONE: Controllo nuovo dal compreso nella storicita' di UF
       NOTE:        --
      ******************************************************************************/
      d_dal_uf            anagrafe_unita_fisiche.dal%type;
      d_trovato           number := 0;
      functionalnestlevel integer := integritypackage.getnestlevel;
      d_result            afc_error.t_error_number := afc_error.ok;
   begin
      -- controllo dal compreso in storicita' UF
      if p_new_dal is not null then
         d_dal_uf := anagrafe_unita_fisica.get_dal_min(p_progr_unita_fisica => p_progr_uf);
         if p_new_dal < d_dal_uf then
            d_result := s_dal_minore_num;
         end if;
      end if;
      -- controllo dal sovrapposto ad altri periodi di attributo
      if d_result = afc_error.ok then
         begin
         
            select count(*)
              into d_trovato
              from attributi_unita_fisica_so a
             where a.progr_unita_fisica = p_progr_uf
               and p_new_dal between nvl(a.dal, to_date(2222222, 'j')) and
                   nvl(a.al, to_date(3333333, 'j'))
               and attributo = p_attributo;
            if d_trovato > 1 then
               d_result := s_dal_sovrapposto_num;
            end if;
         
         end;
      
      end if;
      return d_result;
   end; -- attributo_componente.is_dal_ok
   --------------------------------------------------------------------------------
   function is_al_ok
   (
      p_progr_uf  in attributi_unita_fisica_so.progr_unita_fisica%type
     ,p_attributo in attributi_unita_fisica_so.attributo%type
     ,p_new_al    in attributi_unita_fisica_so.al%type
     ,p_rowid     in rowid
     ,p_inserting in number
     ,p_updating  in number
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
      d_al_uf             anagrafe_unita_fisiche.dal%type;
      functionalnestlevel integer := integritypackage.getnestlevel;
      d_trovato           number := 0;
      d_result            afc_error.t_error_number := afc_error.ok;
   begin
      -- controllo dal compreso in storicita' UF
      d_al_uf := anagrafe_unita_fisica.get_max_al(p_progr_unita_fisica => p_progr_uf);
      if nvl(p_new_al, to_date(3333333, 'j')) > nvl(d_al_uf, to_date(3333333, 'j')) then
         d_result := s_al_maggiore_num;
      end if;
      -- controllo dal sovrapposto ad altri periodi di attributo
      if d_result = afc_error.ok then
         begin
            select count(*)
              into d_trovato
              from attributi_unita_fisica_so a
             where a.progr_unita_fisica = p_progr_uf
               and nvl(p_new_al, to_date(3333333, 'j')) between
                   nvl(a.dal, to_date(2222222, 'j')) and nvl(al, s_al_null)
               and attributo = p_attributo;
            if d_trovato > 1 then
               d_result := s_al_sovrapposto_num;
            end if;
         
         end;
      
      end if;
      return d_result;
   end; -- attributo_componente.is_dal_ok
   --------------------------------------------------------------------------------
   function is_ri_ok
   (
      p_progr_uf  in attributi_unita_fisica_so.progr_unita_fisica%type
     ,p_attributo in attributi_unita_fisica_so.attributo%type
     ,p_old_dal   in attributi_unita_fisica_so.dal%type
     ,p_new_dal   in attributi_unita_fisica_so.dal%type
     ,p_old_al    in attributi_unita_fisica_so.al%type
     ,p_new_al    in attributi_unita_fisica_so.al%type
     ,p_rowid     in rowid
     ,p_inserting in number
     ,p_updating  in number
     ,p_deleting  in number
   ) return afc_error.t_error_number is
      /******************************************************************************
       NOME:        is_RI_ok.
       DESCRIZIONE: gestione della Referential Integrity:
                    - is_dal_ok
                    - is_al_ok
       PARAMETRI:   p_id_componente
                    p_old_dal
                    p_new_dal
                    p_old_al
                    p_new_al
                    p_rowid
                    p_inserting
                    p_updating
       RETURN:      1 se tutti i controlli danno esito positivo, l'error_code altrimenti
       NOTE:        --
      ******************************************************************************/
      d_result            afc_error.t_error_number := afc_error.ok;
      functionalnestlevel integer := integritypackage.getnestlevel;
   begin
      if p_deleting = 0 then
         -- is_dal_ok 
         d_result := is_dal_ok(p_progr_uf
                              ,p_attributo
                              ,p_new_dal
                              ,p_rowid
                              ,p_inserting
                              ,p_updating);
      
         -- is_al_ok 
         if d_result = afc_error.ok then
            d_result := is_al_ok(p_progr_uf
                                ,p_attributo
                                ,p_new_al
                                ,p_rowid
                                ,p_inserting
                                ,p_updating);
         end if;
      end if;
      return d_result;
   end; -- attributo_componente.is_RI_ok
   --------------------------------------------------------------------------------
   procedure chk_ri
   (
      p_progr_uf  in attributi_unita_fisica_so.progr_unita_fisica%type
     ,p_attributo in attributi_unita_fisica_so.attributo%type
     ,p_old_dal   in attributi_unita_fisica_so.dal%type
     ,p_new_dal   in attributi_unita_fisica_so.dal%type
     ,p_old_al    in attributi_unita_fisica_so.al%type
     ,p_new_al    in attributi_unita_fisica_so.al%type
     ,p_rowid     in rowid
     ,p_inserting in number
     ,p_updating  in number
     ,p_deleting  in number
   ) is
      /******************************************************************************
       NOME:        chk_RI.
       DESCRIZIONE: gestione della Referential Integrity:
                    - is_dal_ok
                    - is_al_ok
       PARAMETRI:   p_id_compoennte
                    p_old_dal
                    p_new_dal
                    p_old_al
                    p_new_al
                    p_rowid
                    p_inserting
                    p_updating
       NOTE:        --
      ******************************************************************************/
      d_result afc_error.t_error_number;
   begin
      d_result := is_ri_ok(p_progr_uf
                          ,p_attributo
                          ,p_old_dal
                          ,p_new_dal
                          ,p_old_al
                          ,p_new_al
                          ,p_rowid
                          ,p_inserting
                          ,p_updating
                          ,p_deleting);
      if not (d_result = afc_error.ok) then
         raise_application_error(d_result, s_error_table(d_result));
      end if;
   end; -- attributo_componente.chk_RI
   --------------------------------------------------------------------------------
   function get_valore_attributo
   (
      p_progr_unita_fisica in attributi_unita_fisica_so.progr_unita_fisica%type
     ,p_attributo          in attributi_unita_fisica_so.attributo%type
     ,p_data               in date
   ) return attributi_unita_fisica_so.valore%type is
      /* SLAVE_COPY */
      /******************************************************************************
       NOME:        get_valore
       DESCRIZIONE: Getter per attributo valore di riga identificata dalla chiave.
       PARAMETRI:   Attributi chiave.
       RITORNA:     ATTRIBUTI_UNITA_FISICA_SO.valore%type.
       NOTE:        La riga identificata deve essere presente.
      ******************************************************************************/
      d_result attributi_unita_fisica_so.valore%type;
   begin
      select valore
        into d_result
        from attributi_unita_fisica_so
       where progr_unita_fisica = p_progr_unita_fisica
         and attributo = p_attributo
         and p_data between dal and nvl(al, to_date(3333333, 'j'));

      return d_result;
   end get_valore_attributo; -- attributi_unita_fisica_so_tpk.get_valore

--------------------------------------------------------------------------------

begin
   -- inserimento degli errori nella tabella
   s_error_table(s_dal_al_errato_num) := s_dal_al_errato_msg;
   s_error_table(s_dal_errato_num) := s_dal_errato_msg;
   s_error_table(s_dal_sovrapposto_num) := s_dal_sovrapposto_msg;
   s_error_table(s_dal_minore_num) := s_dal_minore_msg;
   s_error_table(s_al_maggiore_num) := s_al_maggiore_msg;
   s_error_table(s_al_sovrapposto_num) := s_al_sovrapposto_msg;
end attributi_unita_fisica_so_pkg;
/

