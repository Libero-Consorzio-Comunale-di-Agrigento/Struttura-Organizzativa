CREATE OR REPLACE package body so4_util_as4 is
   /******************************************************************************
    NOME:        SO4_UTIL_AS4.
    DESCRIZIONE: Raggruppa le funzioni relative all'anagrafe soggetti di AS4.
   
    ANNOTAZIONI: .
   
    REVISIONI: .
    Rev.  Data        Autore  Descrizione.
    000   30/01/2007  VDAVALLI  Prima emissione.
   ******************************************************************************/
   s_revisione_body constant varchar2(30) := '000';

   -- Private type declarations
   --   type d_<TypeName>_type is <Datatype>;

   -- Private constant declarations
   --   <CONSTANTNAME> constant <Datatype> := <Value>;

   -- Private variable declarations
   --   d_<VariableName> <Datatype>;

   -- Function and procedure implementations

   function versione return varchar2 is
      /******************************************************************************
      NOME:        versione.
      DESCRIZIONE: Restituisce versione e revisione di distribuzione del package.
      
      RITORNA:     VARCHAR2 stringa contenente versione e revisione.
      NOTE:        Primo numero  : versione compatibilità del Package.
                   Secondo numero: revisione del Package specification.
                   Terzo numero  : revisione del Package body.
      ******************************************************************************/
   begin
      return s_revisione || '.' || s_revisione_body;
   end versione;

   --------------------------------------------------------------------------------

   function get_dal_corrente
   (
      p_ni   in as4_anagrafe_soggetti.ni%type
     ,p_data in as4_anagrafe_soggetti.dal%type
   ) return as4_anagrafe_soggetti.dal%type is
      /******************************************************************************
      NOME:        get_dal_corrente
      DESCRIZIONE: Restituisce il valore del campo "dal" del periodo di validità
                   che comprende la data passata
      
      PARAMETRI:   
      
      RITORNA:     
      
      REVISIONI:
      Rev.  Data        Autore  Descrizione
      ----  ----------  ------  ----------------------------------------------------
      000   30/01/2007  VDAVALLI  Prima emissione.
      ******************************************************************************/
      d_result as4_anagrafe_soggetti.dal%type;
   begin
      select dal
        into d_result
        from as4_anagrafe_soggetti
       where ni = p_ni
         and p_data between dal and nvl(al, to_date('3333333', 'j'));
   
      return d_result;
   
   end; -- so4_util_as4.get_dal_corrente

   --------------------------------------------------------------------------------

   function get_indirizzo_web
   (
      p_ni   in as4_anagrafe_soggetti.ni%type
     ,p_data in as4_anagrafe_soggetti.dal%type
   ) return as4_anagrafe_soggetti.indirizzo_web%type is
      /******************************************************************************
      NOME:        get_indirizzo_web
      DESCRIZIONE: Restituisce il valore del campo "indirizzo_web" del soggetto
                   valido alla data indicata
      
      PARAMETRI:   
      
      RITORNA:     
      
      REVISIONI:
      Rev.  Data        Autore  Descrizione
      ----  ----------  ------  ----------------------------------------------------
      000   30/01/2007  VDAVALLI  Prima emissione.
      ******************************************************************************/
      d_result as4_anagrafe_soggetti.indirizzo_web%type;
   begin
      select indirizzo_web
        into d_result
        from as4_anagrafe_soggetti
       where ni = p_ni
         and p_data between dal and nvl(al, to_date('3333333', 'j'));
   
      return d_result;
   
   end; -- so4_util_as4.get_indirizzo_web

-- begin
-- Initialization
--   <Statement>;
end so4_util_as4;
/

