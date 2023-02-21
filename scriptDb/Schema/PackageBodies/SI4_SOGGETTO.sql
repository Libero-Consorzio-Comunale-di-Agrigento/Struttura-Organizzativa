CREATE OR REPLACE PACKAGE BODY SI4_SOGGETTO IS

FUNCTION  VERSIONE
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione 
              del package.
******************************************************************************/
RETURN varchar2
IS
BEGIN
   RETURN '1.0';
END VERSIONE;

Function Get_Ruolo
/******************************************************************************
 NOME:        Get_Ruolo
 DESCRIZIONE: Ritorna l'incarico del soggetto all'interno del gruppo.
              Se non esiste l'integrazione con la struttura organizzativa dell'ente o con altre implementazioni
              ritorna sempre NULL.

 PARAMETRI:   Soggetto   IN VARCHAR2 
              Gruppo   IN VARCHAR2
 RITORNA:     VARCHAR2
 REVISIONE:   valberico - venerdì 23 gennaio 2004 10.46.39
 Rev.  Data        Autore  Descrizione
 ----  ----------  ------  ----------------------------------------------------
 0     __/__/____  __      Creazione.
******************************************************************************/
( Soggetto IN VARCHAR2
, Gruppo IN VARCHAR2)
RETURN VARCHAR2
IS
BEGIN
   return null;
END Get_Ruolo;

END SI4_SOGGETTO;
/

