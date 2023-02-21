CREATE OR REPLACE package so4_util_as4 is
   /******************************************************************************
    NOME:        SO4_UTIL_AS4.
    DESCRIZIONE: Raggruppa le funzioni relative all'anagrafe soggetti di AS4.
   
    ANNOTAZIONI: .
   
    REVISIONI: .
    <CODE>
    Rev.  Data        Autore  Descrizione.
    00    30/01/2007  VDAVALLI  Prima emissione.
    </CODE>
   ******************************************************************************/
   s_revisione constant varchar2(30) := 'V1.00';

   -- Public type declarations
   --   type s_<TypeName>_type is <Datatype>;

   -- Public constant declarations
   --   <CONSTANTNAME> constant <Datatype> := <Value>;

   -- Public variable declarations
   --   s_<VariableName> <Datatype>;

   -- Public function and procedure declarations
   function versione return varchar2;
   pragma restrict_references(versione, wnds, wnps);

   function get_dal_corrente
   (
      p_ni   in as4_anagrafe_soggetti.ni%type
     ,p_data in as4_anagrafe_soggetti.dal%type
   ) return as4_anagrafe_soggetti.dal%type;

   function get_indirizzo_web
   (
      p_ni   in as4_anagrafe_soggetti.ni%type
     ,p_data in as4_anagrafe_soggetti.dal%type
   ) return as4_anagrafe_soggetti.indirizzo_web%type;

end so4_util_as4;
/

