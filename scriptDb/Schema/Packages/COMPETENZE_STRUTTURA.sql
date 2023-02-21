CREATE OR REPLACE package COMPETENZE_STRUTTURA IS
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
   -- Revisione del Package
   s_revisione constant afc.t_revision := 'V1.00';
   -- Versione e revisione
   function versione /* SLAVE_COPY */
    return varchar2;

   FUNCTION esiste_in_struttura(p_soggetto           NUMBER,
                             p_ruolo              VARCHAR2,
                             p_tipo_competenza    VARCHAR2)
   RETURN NUMBER;
END COMPETENZE_STRUTTURA;
/

