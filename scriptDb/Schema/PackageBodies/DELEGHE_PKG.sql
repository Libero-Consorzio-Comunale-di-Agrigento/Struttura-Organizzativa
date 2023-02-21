CREATE OR REPLACE package body deleghe_pkg is

   /******************************************************************************
    NOME:        DELEGHE_PKG
    DESCRIZIONE: Contiene funzioni di utilità per l'implementazione della logica
                 delle DELEGHE
    ANNOTAZIONI: 
    REVISIONI:   .
    <CODE>
    Rev.  Data        Autore      Descrizione. 
    001   23/01/2018  ADADAMO     Prima emissione. 
   ******************************************************************************/

   s_revisione_body varchar2(30) := '001 - 23/02/2018';

   function versione return varchar2 is /* SLAVE_COPY */
      /******************************************************************************
          NOME:  versione
          DESCRIZIONE: Versione e revisione di distribuzione del package.
          RITORNA:  varchar2 stringa contenente versione e revisione.
          NOTE:  Primo numero  : versione compatibilità del Package.
           Secondo numero: revisione del Package specification.
           Terzo numero  : revisione del Package body.
      ******************************************************************************/
   begin
      return s_revisione || '.' || s_revisione_body;
   end; -- deleghe_pkg.versione

   function get_id_applicativo return number is
      d_id_applicativo applicativi.id_applicativo%type;
   begin
      select applicativi_sq.nextval into d_id_applicativo from dual;
      return d_id_applicativo;
   end;
   function get_id_competenza_delega return number is
      d_id_competenza_delega competenze_delega.id_competenza_delega%type;
   begin
      select competenze_delega_sq.nextval into d_id_competenza_delega from dual;
      return d_id_competenza_delega;
   end;
   function get_id_delega return number is
      d_id_delega deleghe.id_delega%type;
   begin
      select deleghe_sq.nextval into d_id_delega from dual;
      return d_id_delega;
   end;

end deleghe_pkg;
/

