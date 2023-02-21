CREATE OR REPLACE package so4_util_fis is
   /******************************************************************************
    NOME:        so4_util_fis.
    DESCRIZIONE: Raggruppa le funzioni di supporto per altri applicativi relative
                 alla struttura fisica
    ANNOTAZIONI: ATTENZIONE !!!! Per gestione master/slave l'ultima function del
                 package NON deve restituire un ref_cursor
    REVISIONI: .
    <CODE>
    Rev.  Data        Autore  Descrizione.
    00    04/05/2009  VDAVALLI  Prima emissione.
    01    26/09/2011  VDAVALLI  Nuova funzione GET_ASCENDENTI_SUDD
    02    06/10/2011  VDAVALLI  Nuova funzione GET_STRINGA_ASCENDENTI
    03    16/01/2012  VDAVALLI  Nuova funzione GET_AREA_UNITA
    04    09/01/2013  ADADAMO   Aggiunte funzioni unita_get_ramo e 
                                get_recapito_ascendenti (Redmine #142)
          11/01/2013  ADADAMO   Aggiunta funzione get_stringa_solo_ascendenti
                                (Redmine #144)                                
   ******************************************************************************/
   s_revisione constant varchar2(30) := 'V1.04';

   --
   function versione return varchar2;
   pragma restrict_references(versione, wnds, wnps);
   --
   function set_data_default(p_data unita_fisiche.dal%type) return unita_fisiche.dal%type;
   --
   function set_data_default(p_data varchar2) return unita_fisiche.dal%type;
   --
   function set_data_limite return unita_fisiche.dal%type;
   --
   function set_separatore_default
   (
      p_separatore      varchar2
     ,p_tipo_separatore number
   ) return varchar2;
   --
   function get_ordinamento
   (
      p_progr_unfi      unita_fisiche.progr_unita_fisica%type
     ,p_data            unita_fisiche.dal%type default null
     ,p_amministrazione unita_fisiche.amministrazione%type
   ) return varchar2;
   --
   function get_ascendenti
   (
      p_progr_unfi      unita_fisiche.progr_unita_fisica%type
     ,p_data            unita_fisiche.dal%type default null
     ,p_amministrazione unita_fisiche.amministrazione%type
   ) return afc.t_ref_cursor;
   --
   function get_ascendenti_sudd
   (
      p_progr_unfi unita_fisiche.progr_unita_fisica%type
     ,p_data       unita_fisiche.dal%type default null
   ) return afc.t_ref_cursor;
   --
   function get_stringa_ascendenti
   (
      p_progr_unfi      unita_fisiche.progr_unita_fisica%type
     ,p_data            unita_fisiche.dal%type default null
     ,p_amministrazione unita_fisiche.amministrazione%type
     ,p_direzione       number
   ) return varchar2;
   --
   function get_discendenti
   (
      p_progr_unfi      unita_fisiche.progr_unita_fisica%type
     ,p_data            unita_fisiche.dal%type default null
     ,p_amministrazione unita_fisiche.amministrazione%type
   ) return afc.t_ref_cursor;
   --
   function get_area_unita
   (
      p_progr_unfi      unita_fisiche.progr_unita_fisica%type
     ,p_data            unita_fisiche.dal%type default null
     ,p_id_suddivisione anagrafe_unita_fisiche.id_suddivisione%type
   ) return unita_fisiche.progr_unita_fisica%type;
   --
   function unita_get_ramo
   (
      p_progr_unfi      unita_fisiche.progr_unita_fisica%type
     ,p_amministrazione unita_fisiche.amministrazione%type
     ,p_data            unita_fisiche.dal%type
   ) return varchar2;

   function get_recapito_ascendenti
   (
      p_progr_unfi      unita_fisiche.progr_unita_fisica%type
     ,p_data            unita_fisiche.dal%type default null
     ,p_amministrazione unita_fisiche.amministrazione%type
   ) return varchar2;

   function get_stringa_solo_ascendenti
   (
      p_progr_unfi      unita_fisiche.progr_unita_fisica%type
     ,p_data            unita_fisiche.dal%type default null
     ,p_amministrazione unita_fisiche.amministrazione%type
   ) return varchar2;

end so4_util_fis;
/

