CREATE OR REPLACE package so4_flex_org_pkg is
   /******************************************************************************
    NOME:        SO4_FLEX_ORG_PKG.
    DESCRIZIONE: Procedure e Funzioni di utilita' comune per l'applicativo Cartellino Interattivo.
    ANNOTAZIONI: .
    REVISIONI:   .
    Rev.  Data        Autore  Descrizione.
    ----  ----------  ------  ---------------------------------------------------.
    00    14/04/2011  ADADAMO Prima emissione.
    01    13/09/2012  ADADAMO Modificata get_flex_ottiche per introduzione gestione
            competenze
   ******************************************************************************/
   s_revisione constant varchar2(30) := 'V1.01';
   function versione return varchar2;
   pragma restrict_references(versione, wnds, wnps);
   procedure get_flex_org
   (
      p_ottica      in unita_organizzative.ottica%type
     ,p_datarif     in varchar2
     ,p_progr_unita in unita_organizzative.progr_unita_organizzativa%type
     ,p_livello     in number
     ,p_revisione   in number
     ,p_list        out afc.t_ref_cursor
   );
   procedure get_flex_comp
   (
      p_datarif    in varchar2
     ,p_progr_unor in unita_organizzative.progr_unita_organizzativa%type
     ,p_list       out afc.t_ref_cursor
   );
   procedure get_flex_ottiche
   (
      p_utente in ad4_utenti.utente%type
     ,p_ruolo  in ad4_ruoli.ruolo%type
     ,p_list   out afc.t_ref_cursor
   );
   procedure get_flex_revisioni
   (
      p_ottica in unita_organizzative.ottica%type
     ,p_list   out afc.t_ref_cursor
   );
   procedure get_flex_unita
   (
      p_ottica    in unita_organizzative.ottica%type
     ,p_revisione in number
     ,p_datarif   in varchar2
     ,p_descr     in varchar2
     ,p_list      out afc.t_ref_cursor
   );
end so4_flex_org_pkg;
/

