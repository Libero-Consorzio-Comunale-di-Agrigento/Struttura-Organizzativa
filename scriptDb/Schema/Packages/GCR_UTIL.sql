CREATE OR REPLACE package GCR_UTIL is
/******************************************************************************
 NOME:        GCR_UTIL
 DESCRIZIONE: Contiene funzioni utilizzate per l'integrazione con GCR
 ANNOTAZIONI: .
 REVISIONI:   .
 <CODE>
 Rev.  Data        Autore      Descrizione.
 00    16/04/2010  APASSUELLO  Prima emissione.
 </CODE>
******************************************************************************/

  -- Revisione del Package
  s_revisione constant AFC.t_revision := 'V1.00';
  
------------------------------------------------------------------------------

  -- Exceptions
  err_select exception;
  pragma exception_init( err_select, -20901 );
  s_err_select_number constant AFC_Error.t_error_number := -20901;
  s_err_select_msg    constant AFC_Error.t_error_msg := 'Errore durante l''esecuzione della query';
   
------------------------------------------------------------------------------
  
  -- Versione e revisione
  function versione /* SLAVE_COPY */
  return varchar2;
  pragma restrict_references( versione, WNDS );
   
------------------------------------------------------------------------------

  -- Ritorna il numero di consiglieri appartenenti al gruppo consiliare 
  -- indicato dal progressivo dell'unità organizzativa.
  function gruppo_get_num_cons
  ( p_progr_unita_organizzativa              in anagrafe_unita_organizzative.progr_unita_organizzativa%type
  , p_data                                   in date
  ) return integer;
  
------------------------------------------------------------------------------

  -- Ritorna il numero di consiglieri di sesso femminile appartenenti al gruppo  
  -- consiliare indicato dal progressivo dell'unità organizzativa.
  function gruppo_get_num_donne
  ( p_progr_unita_organizzativa              in anagrafe_unita_organizzative.progr_unita_organizzativa%type
  , p_data                                   in date
  ) return integer;
  
------------------------------------------------------------------------------
end GCR_UTIL;
/

