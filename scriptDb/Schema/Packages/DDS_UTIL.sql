CREATE OR REPLACE PACKAGE DDS_UTIL is

procedure SET_OWNER
/* Attua su DDS_OWNERS le modifiche ad una AMMINISTRAZIONE */
( in_codice_amministrazione in varchar2
 ,in_denominazione          in varchar2
);

procedure INITIALIZE_OWNERS
/* Popolamento iniziale della tabelle DDS_OWNERS con le amministrazioni interne di SO4 */
(in_clean_up in number default 0 -- se 1, elimina tutti gli owner preesistenti
);

function IS_MEMBER_ACTIVE
(in_user                in varchar2
,in_owner               in varchar2
) return number;

procedure SET_MEMBER
/* Attua su DDS_MEMBERS le modifiche ai componenti di SO4 */
( in_user   in varchar2
 ,in_owner  in varchar2
);

procedure SET_ROLE
/* Attua su DDS_ROLES le modifiche ai componenti/ruoli di SO4 */
( in_user     in varchar2
 ,in_project  in varchar2
 ,in_admin    in varchar2
 ,in_observer in varchar2
);

procedure INITIALIZE_MEMBERS
/* Popolamento iniziale della tabelle DDS_MEMBERS con i componenti di SO4 */
( in_clean_up    in number   default 0   -- se 1, elimina tutti gli owner preesistenti
 ,in_owner       in varchar2 default '%'
 ,in_active_only in number   default 1
);

procedure SET_USER
/* Attua su DDS_USERS le modifiche su AD4-AS4 */
( in_user in varchar2
 ,in_admin in varchar2 default 0
);

procedure INITIALIZE_USERS
/* Popolamento iniziale della tabelle DDS_OWNERS con le amministrazioni interne di SO4 */
(in_clean_up in number default 0 -- se 1, elimina tutti gli owner preesistenti
);

procedure RESET_GRANTS
/* Pulisce DDS_GRANTS per utente e table */
( in_user          in varchar2
 ,in_table         in varchar2
);

procedure SET_GRANTS
/* Attua su DDS_GRANTS le modifiche ai ruoli dei componenti di SO4 */
( in_user          in varchar2
 ,in_role          in varchar2
 ,in_owner         in varchar2
 ,in_project       in varchar2
 ,in_table         in varchar2
);

procedure ANALYZE_ROLE
/* Analisi della descrizione del ruolo per estrarre progetto,tabella e profilo di utilizzo */
( in_role        in     varchar2
 ,out_project    in out varchar2
 ,out_table      in out varchar2
 ,out_profile    in out varchar2
);
end;
/

