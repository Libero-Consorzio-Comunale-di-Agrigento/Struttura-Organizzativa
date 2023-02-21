CREATE OR REPLACE PACKAGE     adaut_pkg is
/******************************************************************************
NOME:        adaut_pkg
DESCRIZIONE: Gestione flussi autorizzativi.
ANNOTAZIONI: .
REVISIONI:   .
Rev.  Data       Autore     Descrizione.
00    08/06/2015 ADADAMO    Prima emissione.
******************************************************************************/
-- Revisione del Package
s_revisione constant afc.t_revision := 'V1.00';
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
);
procedure create_as4_soggetto
(p_nome     in varchar2
,p_cognome  in varchar2
,p_codice_fiscale in varchar2
,p_email    in varchar2
);

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
   );

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
    );


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
    );
end;
/

