CREATE OR REPLACE package deleghe_pkg is
   /******************************************************************************
    NOME:        DELEGHE_PKG
    DESCRIZIONE: Contiene funzioni di utilità per l'implementazione della logica
                 delle DELEGHE
    ANNOTAZIONI: 
    REVISIONI:   .
    <CODE>
    Rev.  Data        Autore      Descrizione. 
    00    23/01/2018  ADADAMO     Prima emissione. 
   ******************************************************************************/
   -- Revisione del Package
   s_revisione constant afc.t_revision := 'V1.0';

   function versione return varchar2;
   function get_id_applicativo return number;
   function get_id_competenza_delega return number;
   function get_id_delega return number;

end deleghe_pkg;
/

