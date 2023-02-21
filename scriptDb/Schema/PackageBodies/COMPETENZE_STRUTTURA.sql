CREATE OR REPLACE package body COMPETENZE_STRUTTURA is
   /******************************************************************************
    NOME:        COMPETENZE_STRUTTURA
    DESCRIZIONE: Verifica della presenza in struttura della persona
                 con il ruolo previsto considerando anche il tipo di competenza
                 S=Posizione in struttura
                 A=Ascendente (si propaga verso l'alto)
                 D=Discendente (si propaga verso il basso)
    ANNOTAZIONI: .
    REVISIONI:   .
    <CODE>
    Rev.  Data        Autore    Descrizione.
    00   23/10/2014  SNegroni  Prima emissione.
   ******************************************************************************/
   s_revisione_body constant afc.t_revision := '000';
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
   end; -- ottica.versione   

   FUNCTION esiste_in_struttura (p_soggetto           NUMBER,
                              p_ruolo              VARCHAR2,
                              p_tipo_competenza    VARCHAR2)
   RETURN NUMBER
   IS
   v_trovato    NUMBER := 0;
   v_ruolo      VARCHAR2 (100) := SUBSTR (p_ruolo,1,INSTR (p_ruolo,'@@',1,1) - 1);
   v_stringa_uo VARCHAR2 (1000):= SUBSTR (p_ruolo,INSTR (p_ruolo,'@@',1,2)+ 2);
   v_ottica     VARCHAR2 (1000):= SUBSTR (p_ruolo,INSTR (p_ruolo,'@@',1,1) + 2,
                                         INSTR (p_ruolo, '@@',1,2)
                                       - INSTR (p_ruolo, '@@',1,1)- 2);
   v_uo number;
    BEGIN
     if  nvl(INSTR (v_stringa_uo, '['),0) = 0 then -- non è parametrica
          v_uo := to_number(v_stringa_uo);
       IF P_tipo_competenza = 'S'
       THEN      
                                            -- cerco posizione esatta
          SELECT 1
            INTO v_trovato
            from dual
          where exists (select 1
                          FROM UTENTI_RELAZIONI_STRUTTURA  ua 
                         WHERE UA.ni = P_SOGGETTO
                           AND (UA.OTTICA = v_ottica and v_ottica IS not NULL)
                           AND (UA.PROGR_FIGLIO = v_uo  and v_uo IS not NULL)
                           AND EXISTS
                                (SELECT 1
                                   FROM DUAL
                                  WHERE v_ruolo IS NULL
                                 UNION
                                 SELECT 1
                                   FROM ruoli_componente rc
                                  WHERE rC.ID_COMPONENTE = ua.ID_COMPONENTE
                                    AND ruolo = v_ruolo
                                    AND v_ruolo is not null
                                    AND TRUNC (SYSDATE) BETWEEN rc.dal
                                                            AND NVL (
                                                                   rc.al,
                                                                   TO_DATE (3333333,
                                                                            'j'))
                                 )
                         UNION
                         select 1
                          FROM UTENTI_RELAZIONI_STRUTTURA  ua 
                         WHERE UA.ni = P_SOGGETTO
                           AND (v_ottica IS  NULL)
                           AND (UA.PROGR_FIGLIO = v_uo  and v_uo IS not NULL)
                           AND EXISTS
                                (SELECT 1
                                   FROM DUAL
                                  WHERE v_ruolo IS NULL
                                 UNION
                                 SELECT 1
                                   FROM ruoli_componente rc
                                  WHERE rC.ID_COMPONENTE = ua.ID_COMPONENTE
                                    AND ruolo = v_ruolo
                                    AND v_ruolo is not null
                                    AND TRUNC (SYSDATE) BETWEEN rc.dal
                                                            AND NVL (
                                                                   rc.al,
                                                                   TO_DATE (3333333,
                                                                            'j'))
                                 )
                          UNION
                          select 1
                          FROM componenti_attuali  ua 
                         WHERE UA.ni = P_SOGGETTO
                           AND (UA.OTTICA = v_ottica and v_ottica IS not NULL)
                           AND ( v_uo IS  NULL)
                           AND EXISTS
                                (SELECT 1
                                   FROM DUAL
                                  WHERE v_ruolo IS NULL
                                 UNION
                                 SELECT 1
                                   FROM ruoli_componente rc
                                  WHERE rC.ID_COMPONENTE = ua.ID_COMPONENTE
                                    AND ruolo = v_ruolo
                                    AND v_ruolo is not null
                                    AND TRUNC (SYSDATE) BETWEEN rc.dal
                                                            AND NVL (
                                                                   rc.al,
                                                                   TO_DATE (3333333,
                                                                            'j'))
                                 )
                           UNION
                           select 1
                          FROM componenti_attuali  ua  
                         WHERE UA.ni = P_SOGGETTO
                           AND (v_ottica IS  NULL)
                           AND (v_uo IS  NULL)
                           AND EXISTS
                                (SELECT 1
                                   FROM DUAL
                                  WHERE v_ruolo IS NULL
                                 UNION
                                 SELECT 1
                                   FROM ruoli_componente rc
                                  WHERE rC.ID_COMPONENTE = ua.ID_COMPONENTE
                                    AND ruolo = v_ruolo
                                    AND v_ruolo is not null
                                    AND TRUNC (SYSDATE) BETWEEN rc.dal
                                                            AND NVL (
                                                                   rc.al,
                                                                   TO_DATE (3333333,
                                                                            'j'))
                                 )

                        )
             ;
       elsif p_tipo_competenza = 'D'  then
       -- verifica sui discendenti
         SELECT 1
            INTO v_trovato
            from dual
          where exists   (SELECT 1
                            FROM UTENTI_RELAZIONI_STRUTTURA ua 
                           WHERE UA.ni = P_SOGGETTO
                             AND (UA.OTTICA = v_ottica AND v_ottica IS NOT NULL)
                             AND (UA.PROGR_padre = v_uo AND v_uo IS NOT NULL) 
                             AND EXISTS
                                    (SELECT 1
                                       FROM DUAL
                                      WHERE v_ruolo IS NULL
                                     UNION
                                     SELECT 1
                                       FROM ruoli_componente rc
                                      WHERE rC.ID_COMPONENTE = ua.ID_COMPONENTE
                                        AND ruolo = v_ruolo
                                        AND TRUNC (SYSDATE) BETWEEN rc.dal
                                                                AND NVL (
                                                                       rc.al,
                                                                       TO_DATE (3333333,
                                                                                'j'))
                                     )
                          UNION
                           SELECT 1
                            FROM UTENTI_RELAZIONI_STRUTTURA ua 
                           WHERE UA.ni = P_SOGGETTO
                             AND (v_ottica IS  NULL)
                             AND (UA.PROGR_padre = v_uo AND v_uo IS NOT NULL) 
                             AND EXISTS
                                    (SELECT 1
                                       FROM DUAL
                                      WHERE v_ruolo IS NULL
                                     UNION
                                     SELECT 1
                                       FROM ruoli_componente rc
                                      WHERE rC.ID_COMPONENTE = ua.ID_COMPONENTE
                                        AND ruolo = v_ruolo
                                        AND TRUNC (SYSDATE) BETWEEN rc.dal
                                                                AND NVL (
                                                                       rc.al,
                                                                       TO_DATE (3333333,
                                                                                'j'))
                                     )
                          UNION
                           SELECT 1
                            FROM componenti_attuali ua 
                           WHERE UA.ni = P_SOGGETTO
                             AND (UA.OTTICA = v_ottica AND v_ottica IS NOT NULL)
                             AND ( v_uo IS  NULL) 
                             AND EXISTS
                                    (SELECT 1
                                       FROM DUAL
                                      WHERE v_ruolo IS NULL
                                     UNION
                                     SELECT 1
                                       FROM ruoli_componente rc
                                      WHERE rC.ID_COMPONENTE = ua.ID_COMPONENTE
                                        AND ruolo = v_ruolo
                                        AND TRUNC (SYSDATE) BETWEEN rc.dal
                                                                AND NVL (
                                                                       rc.al,
                                                                       TO_DATE (3333333,
                                                                                'j'))
                                     )
                          UNION
                           SELECT 1
                            FROM componenti_attuali ua 
                           WHERE UA.ni = P_SOGGETTO
                             AND (v_ottica IS  NULL)
                             AND (v_uo IS  NULL) 
                             AND EXISTS
                                    (SELECT 1
                                       FROM DUAL
                                      WHERE v_ruolo IS NULL
                                     UNION
                                     SELECT 1
                                       FROM ruoli_componente rc
                                      WHERE rC.ID_COMPONENTE = ua.ID_COMPONENTE
                                        AND ruolo = v_ruolo
                                        AND TRUNC (SYSDATE) BETWEEN rc.dal
                                                                AND NVL (
                                                                       rc.al,
                                                                       TO_DATE (3333333,
                                                                                'j'))
                                     )
                           )
             ;   
       ELSIF P_tipo_competenza = 'A' -- ascendente
       THEN      
          SELECT 1
            INTO v_trovato
            from dual
           where exists (select 1
                           from UTENTI_RELAZIONI_STRUTTURA_F rest  
                          where rest.ni = p_soggetto 
                            and (rest.progr_figlio = v_uo AND v_uo is not null)
                            and (rest.ottica = v_ottica AND v_ottica is not null)          
                            AND EXISTS
                                    (SELECT 1
                                       FROM DUAL
                                      WHERE v_ruolo IS NULL
                                     UNION
                                     SELECT 1
                                       FROM ruoli_componente rc
                                      WHERE rC.ID_COMPONENTE = rest.ID_COMPONENTE
                                        AND ruolo = v_ruolo
                                        AND v_ruolo is not null
                                        AND TRUNC (SYSDATE) BETWEEN rc.dal
                                                                AND NVL (
                                                                       rc.al,
                                                                       TO_DATE (3333333,
                                                                                'j'))
                                     )
                          UNION ALL
                          select 1
                           from UTENTI_RELAZIONI_STRUTTURA_F rest 
                          where rest.ni = p_soggetto 
                            and (rest.progr_figlio = v_uo AND v_uo is not null)
                            and ( v_ottica is null)          
                            AND EXISTS
                                    (SELECT 1
                                       FROM DUAL
                                      WHERE v_ruolo IS NULL
                                     UNION
                                     SELECT 1
                                       FROM ruoli_componente rc
                                      WHERE rC.ID_COMPONENTE = rest.ID_COMPONENTE
                                        AND ruolo = v_ruolo
                                        AND v_ruolo is not null
                                        AND TRUNC (SYSDATE) BETWEEN rc.dal
                                                                AND NVL (
                                                                       rc.al,
                                                                       TO_DATE (3333333,
                                                                                'j'))
                                     )
                          UNION ALL
                          select 1
                           from componenti_attuali rest 
                          where rest.ni = p_soggetto 
                            and ( v_uo is null)
                            and (rest.ottica = v_ottica AND v_ottica is not null)          
                            AND EXISTS
                                    (SELECT 1
                                       FROM DUAL
                                      WHERE v_ruolo IS NULL
                                     UNION
                                     SELECT 1
                                       FROM ruoli_componente rc
                                      WHERE rC.ID_COMPONENTE = rest.ID_COMPONENTE
                                        AND ruolo = v_ruolo
                                        AND v_ruolo is not null
                                        AND TRUNC (SYSDATE) BETWEEN rc.dal
                                                                AND NVL (
                                                                       rc.al,
                                                                       TO_DATE (3333333,
                                                                                'j'))
                                     )
                          UNION ALL
                          select 1
                           from componenti_attuali rest 
                          where rest.ni = p_soggetto 
                            and ( v_uo is null)
                            and ( v_ottica is null)          
                            AND EXISTS
                                    (SELECT 1
                                       FROM DUAL
                                      WHERE v_ruolo IS NULL
                                     UNION
                                     SELECT 1
                                       FROM ruoli_componente rc
                                      WHERE rC.ID_COMPONENTE = rest.ID_COMPONENTE
                                        AND ruolo = v_ruolo
                                        AND v_ruolo is not null
                                        AND TRUNC (SYSDATE) BETWEEN rc.dal
                                                                AND NVL (
                                                                       rc.al,
                                                                       TO_DATE (3333333,
                                                                                'j'))
                                     )
              );  
       END IF;
       else
          null; -- è parametrica in chiamata NON parametrica
       end if;

       RETURN v_trovato;
    exception
        when others then return -5;   
    END esiste_in_struttura;
    
END COMPETENZE_STRUTTURA;
/

