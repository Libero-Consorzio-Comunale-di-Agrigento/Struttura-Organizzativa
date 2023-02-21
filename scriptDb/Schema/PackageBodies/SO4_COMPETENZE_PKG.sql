CREATE OR REPLACE package body so4_competenze_pkg is
/******************************************************************************
 NOME:        so4_competenze_pkg
 DESCRIZIONE: Insieme delle funzioni di utilita' per la gestione delle competenze
 ANNOTAZIONI: .
 REVISIONI:   .
 Rev.  Data        Autore      Descrizione.
 000   07/05/2012  adadamo  Generazione automatica
******************************************************************************/
   s_revisione_body      constant AFC.t_revision := '000 - 07/05/2012';
   --   /* SIAPKGen: generazione automatica */
   s_error_table AFC_Error.t_error_table;
   s_error_detail AFC_Error.t_error_table;
   s_warning afc.t_statement;
--------------------------------------------------------------------------------
function versione
return varchar2 is
/******************************************************************************
 NOME:        versione
 DESCRIZIONE: Versione e revisione di distribuzione del package.
 RITORNA:     varchar2 stringa contenente versione e revisione.
 NOTE:        Primo numero  : versione compatibilita del Package.
              Secondo numero: revisione del Package specification.
              Terzo numero  : revisione del Package body.
******************************************************************************/
begin
   return AFC.version ( s_revisione, s_revisione_body );
end versione; -- so4_competenze_pkg.versione
--------------------------------------------------------------------------------
function error_message
( p_error_number  in AFC_Error.t_error_number
) return AFC_Error.t_error_msg is
/******************************************************************************
 NOME:        error_message
 DESCRIZIONE: Messaggio previsto per il numero di eccezione indicato.
 NOTE:        Restituisce il messaggio abbinato al numero indicato nella tabella
              s_error_table del Package. Se p_error_number non e presente nella
              tabella s_error_table viene lanciata l'exception -20011 (vedi AFC_Error)
******************************************************************************/
   d_result AFC_Error.t_error_msg;
   d_detail AFC_Error.t_error_msg;
begin
   if s_error_detail.exists( p_error_number )
   then
      d_detail := s_error_detail( p_error_number );
   end if;
   if s_error_table.exists( p_error_number )
   then
      d_result := s_error_table( p_error_number ) || d_detail;
      s_error_detail( p_error_number ) := '';
   else
      raise_application_error( AFC_Error.exception_not_in_table_number
                             , AFC_Error.exception_not_in_table_msg
                             );
   end if;
   return  d_result;
end error_message; -- so4_competenze_pkg.error_message
--------------------------------------------------------------------------------
function isCompetenzeAttive
return boolean
/******************************************************************************
 NOME:        isCompetenzeAttive
 DESCRIZIONE: Verifica se il flag che indica se si è scelto di attivare il
              sistema delle competenze è attivo o meno
 NOTE:        Restituisce true o false. Viene utilizzata dalle funzioni di DB
              perchè se non è stato attivato il sistema di controllo tutti i check
              risultino sempre verificati
******************************************************************************/
is
begin
    return nvl(REGISTRO_UTILITY.LEGGI_STRINGA('PRODUCTS/SI4SO','Gestione Competenze',0),'NO') = 'SI';
end;
--------------------------------------------------------------------------------
function is_Competenze_Attive
return number
/******************************************************************************
 NOME:        is_Competenze_Attive
 DESCRIZIONE: Verifica se il flag che indica se si è scelto di attivare il
              sistema delle competenze è attivo o meno
 NOTE:        Restituisce 1 o 0. Viene utilizzata dalle funzioni di DB
              perché se non è stato attivato il sistema di controllo tutti i check
              risultino sempre verificati
******************************************************************************/
is
begin
    return afc.to_number(isCompetenzeAttive);
end;
--------------------------------------------------------------------------------
function isCompetenzeDefinite
( p_oggetto_competenza  in varchar2
, p_utente in ad4_utenti.utente%type default null
)
return boolean
/******************************************************************************
 NOME:        isCompetenzeDefinite
 DESCRIZIONE: Verifica se per il tipo_oggetto indicato è stata definita almeno
              una competenza valida ad oggi, se l'utente è stato passato viene
              testato per l'utente specifico
 NOTE:        Wrapper numerico della funzione booleana
******************************************************************************/
IS
    dummy number(1);
BEGIN
     select 1
       into dummy
       from SI4_competenze COMP,
            SI4_ABILITAZIONI ABIL,
            SI4_TIPI_OGGETTO TIOG
      WHERE COMP.ID_ABILITAZIONE = ABIL.ID_ABILITAZIONE
        AND ABIL.ID_TIPO_OGGETTO = TIOG.ID_TIPO_OGGETTO
        AND TIOG.TIPO_OGGETTO = p_oggetto_competenza
        AND SYSDATE BETWEEN DAL AND NVL(AL,TO_DATE(3333333,'J'))
        and utente = nvl(p_utente,utente);
        raise too_many_rows;
exception when too_many_rows THEN
    return true;
        when no_data_found then
    RETURN FALSE;
END;
function is_Competenze_Definite
( p_oggetto_competenza  in varchar2
, p_utente in ad4_utenti.utente%type default null
)
return number
/******************************************************************************
 NOME:        is_Competenze_Definite
 DESCRIZIONE: Verifica se per il tipo_oggetto indicato è stata definita almeno
              una competenzavalida ad oggi, se l'utente è stato passato viene
              testato per l'utente specifico
 NOTE:        Wrapper numerico della funzione booleana
******************************************************************************/
IS
BEGIN
    return afc.to_number(isCompetenzeDefinite(p_oggetto_competenza,p_utente));
END;
function check_comp_ins_amministrazione
/******************************************************************************
 NOME:        check_comp_ins_amministrazione
 DESCRIZIONE: Verifica competenze sull'inserimento delle amministrazioni
 NOTE:        Restituisce 1 se l'utente ha competenza sull'inserimento delle
              amministrazioni
******************************************************************************/
( p_ruolo in AD4_RUOLI.RUOLO%type
) return number
is
begin
    return afc.to_number(p_ruolo='SO4AMM');
end;
--------------------------------------------------------------------------------
function check_comp_amministrazione
( p_codice_amministrazione  in AMMINISTRAZIONI.CODICE_AMMINISTRAZIONE%type
, p_tipo_abilitazione       IN varchar2
, p_utente                  in AD4_UTENTI.UTENTE%type
, p_ruolo                   in AD4_RUOLI.RUOLO%type
) return number is
/******************************************************************************
 NOME:        check_comp_amministrazione
 DESCRIZIONE: Verifica competenze sulle amministrazioni
 NOTE:        Restituisce 1 se l'utente ha competenza sull'amministrazione
              indicata
******************************************************************************/
   d_result         number := 0;
   d_res_boolean    boolean := false;
begin
    if (p_ruolo = 'SO4AMM') or -- ruolo di amministrazione fisso
        not isCompetenzeAttive or -- flag di attivazione delle competenze spento
         not isCompetenzeDefinite('SO4AMM') -- nessuna competenza definita sull'oggetto SO4AMM
         then
        d_result := 1;
    else
        if (p_tipo_abilitazione = 'LE') then
            d_res_boolean := NVL(SI4_COMPETENZA.VERIFICA(1,'SO4AMM',P_CODICE_AMMINISTRAZIONE,'GE', P_UTENTE),0) = 1
                        OR NVL(SI4_COMPETENZA.VERIFICA(1,'SO4AMM', P_CODICE_AMMINISTRAZIONE,'LE', P_UTENTE),0) = 1;
        else
            d_res_boolean := NVL(SI4_COMPETENZA.VERIFICA(1,'SO4AMM',P_CODICE_AMMINISTRAZIONE,p_tipo_abilitazione, P_UTENTE),0) = 1 ;
        end if;
        d_result := AFC.TO_NUMBER(d_res_boolean);
    end if;
    return d_result;
end; -- so4_competenze_pkg.check_comp_amministrazione
--------------------------------------------------------------------------------
function check_comp_ottica
( p_ottica                  in OTTICHE.OTTICA%type
, p_tipo_abilitazione       IN varchar2
, p_utente                  in AD4_UTENTI.UTENTE%type
, p_ruolo                   in AD4_RUOLI.RUOLO%type
) return number is
/******************************************************************************
 NOME:        check_comp_ottica
 DESCRIZIONE: Verifica competenze sulle ottiche
 NOTE:        Restituisce 1 se l'utente ha competenza sull'ottica
              indicata
******************************************************************************/
   d_result             number := 0;
   d_res_boolean        boolean := false;
   d_amministrazione    AMMINISTRAZIONI.CODICE_AMMINISTRAZIONE%type;
   D_ISTITUZIONALE      OTTICHE.OTTICA_ISTITUZIONALE%TYPE;
begin
    if (p_ruolo = 'SO4AMM') or -- ruolo di amministrazione fisso
        not isCompetenzeAttive or -- flag di attivazione delle competenze spento
         not isCompetenzeDefinite('SO4OTT') -- nessuna competenza definita sull'oggetto SO4OTT
         then
            if not isCompetenzeDefinite('SO4AMM') then -- non sono definte competenze nemmeno su amministrazioni
                d_result := 1;
            else
                d_amministrazione := OTTICA.GET_AMMINISTRAZIONE(p_ottica);
                D_RESULT := check_comp_amministrazione(D_AMMINISTRAZIONE, 'LE', P_UTENTE , P_RUOLO );
            END IF;
    else
        d_amministrazione := OTTICA.GET_AMMINISTRAZIONE(p_ottica);
        if (NVL(SI4_COMPETENZA.VERIFICA(1,'SO4AMM',D_AMMINISTRAZIONE,'GE', P_UTENTE),0) = 1) then
        -- se l'utente ha diritti in gestione sull'amministrazione dell'ottica in cascata eredita i diritti
        -- di gestione sulle ottiche dell'amministrazione stessa
            d_result := 1;
        else
            if (p_tipo_abilitazione = 'LE') then
                d_res_boolean := NVL(SI4_COMPETENZA.VERIFICA(1,'SO4OTT',P_OTTICA,'GE', P_UTENTE),0) = 1
                              OR NVL(SI4_COMPETENZA.VERIFICA(1,'SO4OTT', P_OTTICA,'LE', P_UTENTE),0) = 1;
            else
                d_res_boolean := NVL(SI4_COMPETENZA.VERIFICA(1,'SO4OTT',P_OTTICA,p_tipo_abilitazione, P_UTENTE),0) = 1 ;
            END IF;
            -- NON SONO STATE TROVATE COMPETENZE SPECIFICHE SULL'OTTICA INDICATA VERIFICO SE SONO STATE ATTRIBUITE COMPETENZE
            -- "FUNZIONALI" SULLE OTTICHE ISTITUZIONALI/NON ISTITUZIONALI
            if not d_res_boolean then
                D_ISTITUZIONALE := OTTICA.GET_OTTICA_ISTITUZIONALE(P_OTTICA);
                if d_istituzionale = 'SI' then
                -- l'ottica in esame e' di tipo istituzionale quindi verifico se ha la competenza funzionale sulle ottiche istituzionali
                    if p_tipo_abilitazione like 'L%' then
                        d_res_boolean := NVL(SI4_COMPETENZA.VERIFICA(1,'SO4TOTT','%','GI', P_UTENTE),0) = 1
                                      OR NVL(SI4_COMPETENZA.VERIFICA(1,'SO4TOTT','%','LI', P_UTENTE),0) = 1
                                      or NVL(SI4_COMPETENZA.VERIFICA(1,'SO4TOTT','%','LE', P_UTENTE),0) = 1
                                      or NVL(SI4_COMPETENZA.VERIFICA(1,'SO4TOTT','%','GE', P_UTENTE),0) = 1
                                      ;
                   else
                        d_res_boolean := NVL(SI4_COMPETENZA.VERIFICA(1,'SO4TOTT','%','GI', P_UTENTE),0) = 1
                                      or NVL(SI4_COMPETENZA.VERIFICA(1,'SO4TOTT','%','GE', P_UTENTE),0) = 1
                                      ;
                   end if;
                else
                -- l'ottica in esame e' di tipo non istituzionale quindi verifico se ha la competenza funzionale sulle ottiche non istituzionali
                    if p_tipo_abilitazione like 'L%' then
                        d_res_boolean := NVL(SI4_COMPETENZA.VERIFICA(1,'SO4TOTT','%','GN', P_UTENTE),0) = 1
                                      OR NVL(SI4_COMPETENZA.VERIFICA(1,'SO4TOTT','%','LN', P_UTENTE),0) = 1
                                      or NVL(SI4_COMPETENZA.VERIFICA(1,'SO4TOTT','%','LE', P_UTENTE),0) = 1
                                      or NVL(SI4_COMPETENZA.VERIFICA(1,'SO4TOTT','%','GE', P_UTENTE),0) = 1
                                      ;
                   else
                        d_res_boolean := NVL(SI4_COMPETENZA.VERIFICA(1,'SO4TOTT','%','GN', P_UTENTE),0) = 1
                                      or NVL(SI4_COMPETENZA.VERIFICA(1,'SO4TOTT','%','GE', P_UTENTE),0) = 1
                                      ;
                   end if;
                end if;
            END IF;
            d_result := AFC.TO_NUMBER(d_res_boolean);
        end if;
    end if;
    return d_result;
end; -- so4_competenze_pkg.check_comp_ottica
--------------------------------------------------------------------------------
function check_comp_assegnazione
( p_id_componente           in COMPONENTI.ID_COMPONENTE%type
, p_tipo_abilitazione       IN varchar2
, p_utente                  in AD4_UTENTI.UTENTE%type
, p_ruolo                   in AD4_RUOLI.RUOLO%type
) return number is
/******************************************************************************
 NOME:        check_comp_assegnazione
 DESCRIZIONE: Verifica competenze sulle assegnazioni funzionali/istituzionali
 NOTE:        Restituisce 1 se l'utente ha competenza sul tipo_assegnazione della
              assegnazione indicata. Il tipo abilitazione è fisso perché non è
              previsto un tipo abilitazione differente da quello di gestione
******************************************************************************/
   d_result             number := 0;
   d_res_boolean        boolean := false;
   d_tipo_assegnazione  vista_componenti.tipo_assegnazione%type;
begin
    if (p_ruolo = 'SO4AMM') or -- ruolo di amministrazione fisso
         not isCompetenzeAttive or -- flag di attivazione delle competenze spento
         not isCompetenzeDefinite('SO4ASS') -- nessuna competenza definita sull'oggetto SO4ASS
         then
        d_result := 1;
    else
        select nvl(max(tipo_assegnazione),'I')
          into d_tipo_assegnazione
          from vista_componenti
         where id_componente = p_id_componente
            ;
        if d_tipo_assegnazione = 'I' then
            d_res_boolean := (( NVL(SI4_COMPETENZA.VERIFICA(1,'SO4ASS','%','GE', P_UTENTE),0) = 1
                          OR NVL(SI4_COMPETENZA.VERIFICA(1,'SO4ASS','%','GI', P_UTENTE),0) = 1
                          or NVL(SI4_COMPETENZA.VERIFICA(1,'SO4ASS','%','LE', P_UTENTE),0) = 1
                          OR NVL(SI4_COMPETENZA.VERIFICA(1,'SO4ASS','%','LI', P_UTENTE),0) = 1 ) and p_tipo_abilitazione like 'L%') or
                          (( NVL(SI4_COMPETENZA.VERIFICA(1,'SO4ASS','%','GE', P_UTENTE),0) = 1
                          OR NVL(SI4_COMPETENZA.VERIFICA(1,'SO4ASS','%','GI', P_UTENTE),0) = 1 ) and  p_tipo_abilitazione like 'G%')
                          ;
        else
            d_res_boolean := (( NVL(SI4_COMPETENZA.VERIFICA(1,'SO4ASS','%','GE', P_UTENTE),0) = 1
                          OR NVL(SI4_COMPETENZA.VERIFICA(1,'SO4ASS','%','GN', P_UTENTE),0) = 1
                          or NVL(SI4_COMPETENZA.VERIFICA(1,'SO4ASS','%','LE', P_UTENTE),0) = 1
                          OR NVL(SI4_COMPETENZA.VERIFICA(1,'SO4ASS','%','LI', P_UTENTE),0) = 1) and p_tipo_abilitazione like 'L%') or
                            (( NVL(SI4_COMPETENZA.VERIFICA(1,'SO4ASS','%','GE', P_UTENTE),0) = 1
                          OR NVL(SI4_COMPETENZA.VERIFICA(1,'SO4ASS','%','GN', P_UTENTE),0) = 1 ) and  p_tipo_abilitazione like 'G%')  ;
        end if;
        d_result := AFC.TO_NUMBER(d_res_boolean);
    end if;
    return d_result;
end; -- so4_competenze_pkg.check_comp_assegnazione
--------------------------------------------------------------------------------
function check_comp_anagrafica
( p_tipo_abilitazione       IN varchar2
, p_utente                  in AD4_UTENTI.UTENTE%type
, p_ruolo                   in AD4_RUOLI.RUOLO%type
) return number is
/******************************************************************************
 NOME:        check_comp_anagrafica
 DESCRIZIONE: Verifica competenze sulle anagrafiche.
 NOTE:        Restituisce 1 se l'utente ha competenza in modifica sulle anagrafiche
******************************************************************************/
   d_result             number := 0;
   d_res_boolean        boolean := false;
begin
    if (p_ruolo = 'SO4AMM') or -- ruolo di amministrazione fisso
        not isCompetenzeAttive or -- flag di attivazione delle competenze spento
        not isCompetenzeDefinite('SO4ANA') -- nessuna competenza definita sull'oggetto SO4ASS
         then
        d_result := 1;
    else
        d_result := NVL(SI4_COMPETENZA.VERIFICA(1,'SO4ANA','%',p_tipo_abilitazione, P_UTENTE),0);
    end if;
    return d_result;
end; -- so4_competenze_pkg.check_comp_assegnazione
--------------------------------------------------------------------------------
function check_comp_COMPONENTE
( p_NI      in COMPONENTI.NI%type
, p_utente                  in AD4_UTENTI.UTENTE%type
, p_ruolo                   in AD4_RUOLI.RUOLO%type
) return number is
/******************************************************************************
 NOME:        check_comp_COMPONENTE
 DESCRIZIONE: Verifica competenze sul componente analizzando le assegnazioni
              relative ad ottiche su cui l'utente è competente
 NOTE:        Restituisce 1 se l'utente ha competenza sull'ottica su cui il
              componente è assegnato
******************************************************************************/
   d_result         number := 0;
begin
    begin
        select 1
          into d_result
          from vista_assegnazioni
         where ni = p_ni
           and ottica in ( select ottica
                             from ottiche
                            where check_comp_ottica( ottica
                                 , 'LE'
                                 , p_utente
                                 , p_ruolo
                                 ) = 1 );
/*           and  ( select check_comp_ottica( ottica
                                 , 'LE'
                                 , p_utente
                                 , p_ruolo
                                 ) from dual) = 1; */
        raise too_many_rows;
    exception when too_many_rows then
        d_result := 1;
        when no_data_found then
        d_result := 0;
    end;
    return d_result;
end; -- so4_competenze_pkg.check_comp_amministrazione
--------------------------------------------------------------------------------
procedure upd_impostazioni_comp
( p_impostazione in varchar2
, p_valore       in varchar2
, p_ruolo        in AD4_RUOLI.RUOLO%type
) is
/******************************************************************************
 NOME:        upd_impostazioni_comp
 DESCRIZIONE: Procedure per l'aggiornamento delle impostazioni relative alle
              alle competenze
 NOTE:        Viene segnalato un errore se l'utente che esegue l'update non ha
              ruolo di amministratore
******************************************************************************/
begin
    if p_ruolo != 'SO4AMM' then -- verifico se utente ha diritti di amministratore
        raise_application_error(s_impostazione_non_mod_number, s_error_table(s_impostazione_non_mod_number));
    end if;
    if p_impostazione = 'Gestione Competenze' and p_valore not in ('SI','NO') then
        raise_application_error(s_valore_errato_number, s_error_table(s_valore_errato_number));
    end if;
    update registro set valore = p_valore
      where chiave = 'PRODUCTS/SI4SO'
        and stringa = p_impostazione;
end;
--------------------------------------------------------------------------------
function is_competenza_ok
( p_utente              in ad4_utenti.utente%type
, p_oggetto_competenza  in varchar2
, p_tipo_competenza     in varchar2
, p_valore_competenza   in varchar2
, p_dal                 in date
, p_al                  in date
) return  AFC_Error.t_error_number
/******************************************************************************
 NOME:        is_competenza_ok
 DESCRIZIONE: Function utilizzata dalle funzioni di inserimento e di aggiornamento
              delle competenze per controllare la congruenza delle competenze
              attribuite all'utente
 NOTE:        Ritorna il codice di errore se la competenza specificata non è
              congruente con le competenze già assegnate all'utente
******************************************************************************/
is
    d_result AFC_Error.t_error_number := AFC_ERROR.OK;
begin
/* La funzione deve implementare tutti i controlli di congruenza delle competenze.
   Ad esempio non deve essere possibile assegnare all'utente competenze sulle ottiche
   non istituzionali e attribuire le competenze unicamente sulle assegnazioni istituzionali
*/ if p_oggetto_competenza = 'SO4OTT' then
-- inserisxo competenza su ottica, devo verificare che l'utente abbia competenza sull'amministrazione a cui fa
-- riferimento l'ottica
        if isCompetenzeDefinite('SO4AMM') and
            check_comp_amministrazione( OTTICA.GET_AMMINISTRAZIONE(p_valore_competenza), 'LE', p_utente, '') = 0 then
            d_result := s_manca_comp_amm_number;
        end if;
    elsif p_oggetto_competenza = 'SO4ASS' and p_tipo_competenza like '%I' then
-- inserisco competenza sulle assegnazioni istituzionali, devo verificare che l'utente abbia competenze su almeno
-- un ottica istituzionale o su tutte le ottiche istituzionali
        if  isCompetenzeDefinite('SO4OTT') then -- verifico se sono definite competenze sulle ottiche
            begin
               select afc_error.ok
                 into d_result
                 from si4_competenze comp,
                      SI4_ABILITAZIONI ABIL,
                      SI4_TIPI_OGGETTO TIOG
                WHERE COMP.ID_ABILITAZIONE = ABIL.ID_ABILITAZIONE
                  AND ABIL.ID_TIPO_OGGETTO = TIOG.ID_TIPO_OGGETTO
                  AND TIOG.TIPO_OGGETTO = 'SO4OTT'
                  and OTTICA.GET_OTTICA_ISTITUZIONALE(oggetto) = 'SI'
                  and utente = p_utente
                  and sysdate between dal and nvl(al,to_date(3333333,'j'))
                  ;
            exception when no_data_found then -- non ho trovato competenze su ottiche istituzionali
                                              -- guardo se e' competente sul tipo di ottica
                    if isCompetenzeDefinite('SO4TOTT') and
                        not (    NVL(SI4_COMPETENZA.VERIFICA(1,'SO4TOTT','%','GI', P_UTENTE),0) = 1
                              OR NVL(SI4_COMPETENZA.VERIFICA(1,'SO4TOTT','%','LI', P_UTENTE),0) = 1
                              or NVL(SI4_COMPETENZA.VERIFICA(1,'SO4TOTT','%','LE', P_UTENTE),0) = 1
                              or NVL(SI4_COMPETENZA.VERIFICA(1,'SO4TOTT','%','GE', P_UTENTE),0) = 1
                            ) THEN
                        d_result := s_manca_comp_ass_ist_number;
                    END IF;
                when too_many_rows then
                    NULL;
            end;
        elsif p_oggetto_competenza = 'SO4STRL' and p_tipo_competenza = 'GE' then -- se attribuisco competenza in gestione sulla
                                                                                 -- struttura logica verifico che abbia competenza
                                                                                 -- in gestione sulle assegnazioni
            if  isCompetenzeDefinite('SO4ASS') and
                not     (    NVL(SI4_COMPETENZA.VERIFICA(1,'SO4ASS','%','GE', P_UTENTE),0) = 1
                          OR NVL(SI4_COMPETENZA.VERIFICA(1,'SO4ASS','%','GF', P_UTENTE),0) = 1
                          or NVL(SI4_COMPETENZA.VERIFICA(1,'SO4ASS','%','GI', P_UTENTE),0) = 1
                        )     then
                d_result :=  s_manca_comp_ass_gest_number;
            end if;
        end if;
    elsif p_oggetto_competenza in ('SO4DIR','SO4STRF') then -- sto inserendo competenza di direzione o di struttura fisica
        if AD4_UTENTE.GET_TIPO_UTENTE(p_utente) != 'U' then -- se l'utente non è di tipo U segnalo l'errore
            d_result := s_utente_errato_number;
        end if;
    end if;
    if d_result = afc_error.ok and p_dal >= nvl(p_al,to_date(3333333,'j')) then
        d_result := s_date_incongruenti_number;
    end if;
    return d_result;
end;
--------------------------------------------------------------------------------
function get_id_competenza
return SI4_COMPETENZE.ID_COMPETENZA%type
/******************************************************************************
 NOME:        get_id_competenza
 DESCRIZIONE: Function utilizzata dall'interfaccia In.De. per determinare la
              chiave della tabella si4_competenze
 NOTE:        Ritorna la chiave numerica determinata dalla sequence
******************************************************************************/
is
    d_ret_value SI4_COMPETENZE.ID_COMPETENZA%type;
begin
    begin
         SELECT COMP_SQ.NEXTVAL
           INTO d_ret_value
           FROM dual;
    exception when others then
        null;
    end;
    return d_ret_value;
end;
--------------------------------------------------------------------------------
procedure ins_competenza
( p_ID_COMPETENZA           in SI4_COMPETENZE.ID_COMPETENZA%type
, p_UTENTE                  in SI4_COMPETENZE.utente%type
, p_oggetto_competenza      in varchar2
, p_tipo_competenza         in varchar2
, p_valore_competenza       in si4_competenze.oggetto%type
, p_DAL                     in si4_competenze.dal%type  default sysdate
, p_AL                      in si4_competenze.al%type   default null
, P_UTENTE_AGGIORNAMENTO    in si4_competenze.utente_aggiornamento%type default null
)
/******************************************************************************
 NOME:        ins_competenza
 DESCRIZIONE: Procedure utilizzata dall'interfaccia In.De. per inserire la
              competenza per l'utente, il tipo_oggetto e il tipo_abilitazione
              indicati
 NOTE:        Esegue una serie di controlli di correttezza sui valori di
              competenza
******************************************************************************/
is
    d_id_tipo_oggetto       SI4_TIPI_OGGETTO.ID_TIPO_OGGETTO%type;
    d_id_tipo_abilitazione  SI4_TIPI_ABILITAZIONE.ID_TIPO_ABILITAZIONE%type;
    d_id_abilitazione       SI4_ABILITAZIONI.ID_ABILITAZIONE%type;
    d_result                AFC_Error.t_error_number := AFC_ERROR.OK;
begin
    begin
        select id_tipo_oggetto
          into d_id_tipo_oggetto
          from SI4_TIPI_OGGETTO
         where tipo_oggetto = p_oggetto_competenza
         ;
    exception when no_data_found then
        d_result := s_ogg_comp_errato_number;
    end;
    begin
        select id_tipo_abilitazione
          into d_id_tipo_abilitazione
          from SI4_TIPI_abilitazione
         where tipo_abilitazione = p_tipo_competenza
         ;
    exception when no_data_found then
        d_result := s_tipo_comp_errata_number;
    end;
    begin
        select id_abilitazione
          into d_id_abilitazione
          from SI4_ABILITAZIONI
         where id_tipo_abilitazione = d_id_tipo_abilitazione
           and id_tipo_oggetto = d_id_tipo_oggetto
         ;
    exception when no_data_found then
        d_result := s_tipo_abil_errata_number;
    end;
    /* aggiungere tutti i controlli per inserimenti non congruenti delle competenze */
    if d_result = AFC_ERROR.ok then
        d_result := is_competenza_ok( p_utente
                                    , p_oggetto_competenza
                                    , p_tipo_competenza
                                    , p_valore_competenza
                                    , p_dal
                                    , p_al
                                    );
    end if;
    if not ( d_result = AFC_Error.ok )
       then
          raise_application_error ( d_result, error_message( d_result ) );
    end if;
    insert into si4_competenze ( ID_COMPETENZA
                               , ID_ABILITAZIONE
                               , UTENTE
                               , OGGETTO
                               , ACCESSO
                               , RUOLO
                               , DAL
                               , AL
                               , DATA_AGGIORNAMENTO
                               , UTENTE_AGGIORNAMENTO
                               ) values
                               ( p_id_competenza
                               , d_id_abilitazione
                               , p_utente
                               , p_valore_competenza
                               , 'S'
                               , null
                               , nvl(p_dal,sysdate)
                               , p_al
                               , sysdate
                               , p_utente_aggiornamento
                               )
                               ;
end;
--------------------------------------------------------------------------------
procedure upd_competenza
( p_ID_COMPETENZA           in SI4_COMPETENZE.ID_COMPETENZA%type
, p_UTENTE                  in SI4_COMPETENZE.utente%type
, p_oggetto_competenza      in varchar2
, p_tipo_competenza         in varchar2
, p_valore_competenza       in si4_competenze.oggetto%type
, p_DAL                     in si4_competenze.dal%type  default sysdate
, p_AL                      in si4_competenze.al%type   default null
, P_UTENTE_AGGIORNAMENTO    in si4_competenze.utente_aggiornamento%type default null
)
/******************************************************************************
 NOME:        upd_competenza
 DESCRIZIONE: Procedure utilizzata dall'interfaccia In.De. per aggiornare la
              competenza
 NOTE:        Esegue una serie di controlli di correttezza sui valori di
              competenza
******************************************************************************/
is
    d_id_tipo_oggetto       SI4_TIPI_OGGETTO.ID_TIPO_OGGETTO%type;
    d_id_tipo_abilitazione  SI4_TIPI_ABILITAZIONE.ID_TIPO_ABILITAZIONE%type;
    d_id_abilitazione       SI4_ABILITAZIONI.ID_ABILITAZIONE%type;
    d_result                AFC_Error.t_error_number := AFC_ERROR.OK;
begin
    begin
        select id_tipo_oggetto
          into d_id_tipo_oggetto
          from SI4_TIPI_OGGETTO
         where tipo_oggetto = p_oggetto_competenza
         ;
    exception when no_data_found then
        d_result := s_ogg_comp_errato_number;
    end;
    begin
        select id_tipo_abilitazione
          into d_id_tipo_abilitazione
          from SI4_TIPI_abilitazione
         where tipo_abilitazione = p_tipo_competenza
         ;
    exception when no_data_found then
        d_result := s_tipo_comp_errata_number;
    end;
    begin
        select id_abilitazione
          into d_id_abilitazione
          from SI4_ABILITAZIONI
         where id_tipo_abilitazione = d_id_tipo_abilitazione
           and id_tipo_oggetto = d_id_tipo_oggetto
         ;
    exception when no_data_found then
        d_result := s_tipo_abil_errata_number;
    end;
    /* aggiungere tutti i controlli per inserimenti non congruenti delle competenze */
    if d_result = AFC_ERROR.ok then
        d_result := is_competenza_ok( p_utente
                                    , p_oggetto_competenza
                                    , p_tipo_competenza
                                    , p_valore_competenza
                                    , p_dal
                                    , p_al
                                    );
    end if;
    if not ( d_result = AFC_Error.ok )
       then
          raise_application_error ( d_result, error_message( d_result ) );
    end if;
    update si4_competenze set id_abilitazione   = d_id_abilitazione
                            , utente            = p_utente
                            , oggetto           = p_valore_competenza
                            , dal               = p_dal
                            , al                = p_al
                            , data_aggiornamento = sysdate
                            , utente_aggiornamento = p_utente_aggiornamento
     where id_competenza = p_id_competenza
    ;
end;
--------------------------------------------------------------------------------
procedure delete_competenza
( p_ID_COMPETENZA           in SI4_COMPETENZE.ID_COMPETENZA%type
)
is
begin
    update si4_COMPETENZE SET AL = SYSDATE
     WHERE ID_COMPETENZA = P_ID_COMPETENZA
       and al is null
    ;
    if sql%rowcount = 0 then
        delete si4_COMPETENZE WHERE ID_COMPETENZA = P_ID_COMPETENZA;
    end if;
end;
--------------------------------------------------------------------------------
begin
   -- inserimento degli errori nella tabella
  s_error_table(s_impostazione_non_mod_number) := s_impostazione_non_mod_msg;
  s_error_table(s_valore_errato_number) := s_valore_errato_msg;
  s_error_table(s_ogg_comp_errato_number) := s_ogg_comp_errato_msg;
  s_error_table(s_tipo_comp_errata_number) := s_tipo_comp_errata_msg;
  s_error_table(s_tipo_abil_errata_number) := s_tipo_abil_errata_msg;
  s_error_table(s_manca_comp_amm_number) := s_manca_comp_amm_msg;
  s_error_table(s_manca_comp_ass_ist_number) := s_manca_comp_ass_ist_msg;
  s_error_table(s_manca_comp_ass_gest_number) := s_manca_comp_ass_gest_msg;
  s_error_table(s_utente_errato_number) := s_utente_errato_msg;
  s_error_table(s_date_incongruenti_number) := s_date_incongruenti_msg;
end so4_competenze_pkg;
/

