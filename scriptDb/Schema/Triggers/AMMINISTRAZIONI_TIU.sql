CREATE OR REPLACE TRIGGER AMMINISTRAZIONI_TIU
/******************************************************************************
    NOME:        AMMINISTRAZIONI_TIU
    DESCRIZIONE: Trigger for Check / Set DATA Integrity
                             Check FUNCTIONAL Integrity
                               Set FUNCTIONAL Integrity
                          at INSERT or UPDATE or DELETE on Table amministrazioni
   ******************************************************************************/
   before insert or update or delete ON AMMINISTRAZIONI
   for each row
declare
   integrity_error exception;
   errno  integer;
   errmsg char(200);
   dummy  integer;
   d_codice_amministrazione AMMINISTRAZIONI.CODICE_AMMINISTRAZIONE%type;
begin
   /***************************************************************************
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ---------------------------------------------------
    0    07/06/2018 MM     #28708
   ***************************************************************************/
   if inserting or updating then -- ipotizzo che da scarico IPA mi venga passato il codice così come è
        d_codice_amministrazione := :new.codice_amministrazione;
        :new.codice_amministrazione := upper(:new.codice_amministrazione);
   end if;      
   if :new.ente = 'SI' then
      if inserting then
         insert into codici_ipa
            (tipo_entita
            ,progressivo
            ,codice_originale)
         values
            ('AM'
            ,:new.ni
            ,:new.codice_amministrazione);
      elsif updating then
         begin
            select 1
              into dummy
              from codici_ipa
             where tipo_entita = 'AM'
               and progressivo = :new.ni;
            raise too_many_rows;
         exception
            when no_data_found then
               insert into codici_ipa
                  (tipo_entita
                  ,progressivo
                  ,codice_originale)
               values
                  ('AM'
                  ,:new.ni
                  ,:new.codice_amministrazione);
            when too_many_rows then
               update codici_ipa
                  set codice_originale = :new.codice_amministrazione
                where tipo_entita = 'AM'
                  and progressivo = :new.ni;
         end;
      end if;
   ELSE -- ENTE = NO   
      IF INSERTING THEN  -- lo inserisco ed in caso di scarico IPA verrà cancellato ed inserito nuovamente
         insert into codici_ipa
            (tipo_entita
            ,progressivo
            ,codice_originale)
         values
            ('AM'
            ,:new.ni
            ,d_codice_amministrazione);
      END IF;
   end if;
   declare
       d_statement  varchar2(4000);
   begin
       if nvl(so4_pkg.get_integrazione_as4new,'NO') = 'SI' and inserting then
            d_statement := 'begin so4as4_pkg.allinea_amm(:p_ni_as4,:p_codice_amm); end; ';
            execute immediate d_statement using in :new.ni,d_codice_amministrazione;
       end if;     
    exception
          when others then
                           key_error_log_tpk.ins(p_error_id       => ''
                                     ,p_error_session  => userenv('sessionid')
                                     ,p_error_date     => trunc(sysdate)
                                     ,p_error_text     => 'Errore in allineamento su anagrafica centralizzata per Amministrazione '||:new.codice_amministrazione
                                     ,p_error_user     => :new.utente_aggiornamento
                                     ,p_error_usertext => sqlerrm
                                     ,p_error_type     => 'E'); 
    end;                                              
exception
   when integrity_error then
      integritypackage.initnestlevel;
      raise_application_error(errno, errmsg);
   when others then
      integritypackage.initnestlevel;
      raise;
end;
/


