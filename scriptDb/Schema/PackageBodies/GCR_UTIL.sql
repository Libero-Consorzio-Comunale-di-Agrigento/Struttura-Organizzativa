CREATE OR REPLACE package body GCR_UTIL is
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

    s_revisione_body      constant AFC.t_revision := '000';
    s_error_table         AFC_Error.t_error_table;

--------------------------------------------------------------------------------

  function versione
  return varchar2 is /* SLAVE_COPY */
/******************************************************************************
   NOME:        versione
   DESCRIZIONE: Versione e revisione di distribuzione del package.
   RITORNA:     varchar2 stringa contenente versione e revisione.
   NOTE:        Primo numero  : versione compatibilità del Package.
                Secondo numero: revisione del Package specification.
                Terzo numero  : revisione del Package body.
******************************************************************************/
  begin
     return AFC.version (s_revisione, s_revisione_body);
  end; -- gcr_util.versione

--------------------------------------------------------------------------------

  function gruppo_get_num_cons
    ( p_progr_unita_organizzativa              in anagrafe_unita_organizzative.progr_unita_organizzativa%type
    , p_data                                   in date
    ) return integer is
/******************************************************************************
   NOME:        gruppo_get_num_cons
   DESCRIZIONE: Ritorna il numero di consiglieri appartenenti al gruppo consiliare 
                indicato dal progressivo dell'unità organizzativa.
   RITORNA:     Un intero.
   NOTE:        
******************************************************************************/
    d_result             integer;

  begin
       
    begin
            
        select count(*)
          into d_result
          from componenti c
             , attributi_componente a
         where c.id_componente = a.id_componente
           and c.progr_unita_organizzativa = p_progr_unita_organizzativa
           and p_data between c.dal and nvl(decode(c.revisione_cessazione, revisione_struttura.get_revisione_mod(c.ottica), to_date(null), c.al), p_data)
           and nvl(c.revisione_assegnazione, -2) <> revisione_struttura.get_revisione_mod(c.ottica)
           and nvl(tipo_incarico.get_tipo_incarico(a.incarico), 'A') = 'P';
      
      exception
        when OTHERS then
          
          raise_application_error( s_err_select_number
                                 , s_err_select_msg
                                 );
      end;

    return d_result;

  end; -- gcr_util.gruppo_get_num_cons

--------------------------------------------------------------------------------

  function gruppo_get_num_donne
    ( p_progr_unita_organizzativa              in anagrafe_unita_organizzative.progr_unita_organizzativa%type
    , p_data                                   in date
    ) return integer is
/******************************************************************************
   NOME:        gruppo_get_num_donne
   DESCRIZIONE: Ritorna il numero di consiglieri di sesso femminile appartenenti 
                al gruppo consiliare indicato dal progressivo dell'unità organizzativa.
   RITORNA:     Un intero.
   NOTE:        
******************************************************************************/
    d_result             integer;

  begin
       
    begin
            
        select count(*)
          into d_result
          from componenti c
             , attributi_componente a
         where c.id_componente = a.id_componente
           and c.progr_unita_organizzativa = p_progr_unita_organizzativa
           and p_data between c.dal and nvl(decode(c.revisione_cessazione, revisione_struttura.get_revisione_mod(c.ottica), to_date(null), c.al), p_data)
           and nvl(c.revisione_assegnazione, -2) <> revisione_struttura.get_revisione_mod(c.ottica)
           and nvl(tipo_incarico.get_tipo_incarico(a.incarico), 'A') = 'P'
           and soggetti_get_descr(c.ni, p_data, 'SESSO') = 'F' ;
      
      exception
        when OTHERS then
          
          raise_application_error( s_err_select_number
                                 , s_err_select_msg
                                 );
      end;

    return d_result;

  end; -- gcr_util.gruppo_get_num_donne

--------------------------------------------------------------------------------
  begin

    -- inserimento degli errori nella tabella
    s_error_table(s_err_select_number) := s_err_select_msg;
    
  end GCR_UTIL;
/

