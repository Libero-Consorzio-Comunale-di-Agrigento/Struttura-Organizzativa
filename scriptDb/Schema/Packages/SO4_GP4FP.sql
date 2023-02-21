CREATE OR REPLACE package so4_gp4fp is
   /******************************************************************************
    NOME:        so4_gp4fp.
    DESCRIZIONE: Raggruppa le funzioni di supporto per l'applicativo GP4FP
    ANNOTAZIONI: Contiene la replica di alcuni metodi del package SO4_UTIL che
                 devono accedere ai dati mediante data effettiva di validita'
                 (e non data di pubblicazione)
    REVISIONI: .
    <CODE>
    Rev.  Data        Autore    Descrizione.
    00    07/01/2013  VDAVALLI  Prima emissione.
    </CODE>
   ******************************************************************************/
   s_revisione constant varchar2(30) := 'V1.0';

   function versione return varchar2;
   pragma restrict_references(versione, wnds, wnps);

   function set_ottica_default
   (
      p_ottica          ottiche.ottica%type default null
     ,p_amministrazione ottiche.amministrazione%type default null
   ) return ottiche.ottica%type;

   function set_data_default(p_data unita_organizzative.dal%type)
      return unita_organizzative.dal%type;

   function set_data_default(p_data varchar2) return unita_organizzative.dal%type;

   function comp_get_resp_gerarchia
   (
      p_progr_uo        componenti.progr_unita_organizzativa%type
     ,p_ruolo           ruoli_componente.ruolo%type
     ,p_ottica          componenti.ottica%type default null
     ,p_data            componenti.dal%type default null
     ,p_amministrazione amministrazioni.codice_amministrazione%type default null
   ) return afc.t_ref_cursor;

end so4_gp4fp;
/

