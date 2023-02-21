CREATE OR REPLACE package soggetti_rubrica_pkg is
   /******************************************************************************
    NOME:        SOGGETTI_RUBRICA_PKG
    DESCRIZIONE: Gestione dei contatti della rubrica
    ANNOTAZIONI: .
    REVISIONI:   .
    <CODE>
    Rev.  Data        Autore      Descrizione.
    00    17/02/2010  APASSUELLO  Prima emissione.
    01    16/01/2012  VDAVALLI    Aggiunte funzioni di selezione della prima e
                                  della seconda occorrenza per tipo di contatto.
    02    02/07/2015  ADADAMO     Modificate funzioni di set per gestire il caso
                                  in cui non esista il record per il soggetto ed il
                                  tipo di contatto indicato (Bug#625)
    03    11/01/2016  ADADAMO     Aggiunte funzioni per gestione del TIPO_CONTATTO
                                  memorizzato su SO4_CODIFICHE e per gestione del
                                  tipo contatto EMAIL PEC (Feature#671)                                  
   ******************************************************************************/

   -- Revisione del Package
   s_revisione constant afc.t_revision := 'V1.03';

   ------------------------------------------------------------------------------

   TIPO_CONTATTO_erratO exception;
   pragma exception_init(TIPO_CONTATTO_erratO, -20901);
   s_TIPO_CONTATTO_erratO_num constant afc_error.t_error_number := -20901;
   s_TIPO_CONTATTO_erratO_msg constant afc_error.t_error_msg := 'Tipo Contatto non codificato';

   -- Versione e revisione
   function versione /* SLAVE_COPY */
    return varchar2;
   pragma restrict_references(versione, wnds);
   
   -- Messaggio previsto per il numero di eccezione indicato
   function error_message /* SLAVE_COPY */
   (p_error_number in afc_error.t_error_number) return afc_error.t_error_msg;
   pragma restrict_references(error_message, wnds);
   ------------------------------------------------------------------------------

   -- Getter per (tipo_contatto=telefono fisso) e (progressivo=1)
   function get_telefono_fisso(p_ni in soggetti_rubrica.ni%type)
      return soggetti_rubrica.contatto%type;
   pragma restrict_references(get_telefono_fisso, wnds);

   ------------------------------------------------------------------------------

   -- Getter per (tipo_contatto=cellulare) e (progressivo=1)
   function get_cellulare(p_ni in soggetti_rubrica.ni%type)
      return soggetti_rubrica.contatto%type;
   pragma restrict_references(get_cellulare, wnds);

   ------------------------------------------------------------------------------

   -- Getter per (tipo_contatto=numero breve) e (progressivo=1)
   function get_numero_breve(p_ni in soggetti_rubrica.ni%type)
      return soggetti_rubrica.contatto%type;
   pragma restrict_references(get_numero_breve, wnds);

   ------------------------------------------------------------------------------

   -- Getter per (tipo_contatto=email) e (progressivo=1)
   function get_email(p_ni in soggetti_rubrica.ni%type)
      return soggetti_rubrica.contatto%type;
   pragma restrict_references(get_email, wnds);

   ------------------------------------------------------------------------------

   -- Getter per (tipo_contatto=fax) e (progressivo=1)
   function get_fax(p_ni in soggetti_rubrica.ni%type) return soggetti_rubrica.contatto%type;
   pragma restrict_references(get_fax, wnds);
   -- Getter per (tipo_contatto=email pec) e (progressivo=1)
   function get_email_pec(p_ni in soggetti_rubrica.ni%type) return soggetti_rubrica.contatto%type;
   pragma restrict_references(get_email_pec, wnds);
   ------------------------------------------------------------------------------

   -- Getter min(progressivo) per ni / tipo_contatto
   function get_primo_progr
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
   ) return soggetti_rubrica.progressivo%type;
   pragma restrict_references(get_primo_progr, wnds);

   ------------------------------------------------------------------------------

   -- Getter progr. successivo per ni / tipo_contatto
   function get_secondo_progr
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
   ) return soggetti_rubrica.progressivo%type;
   pragma restrict_references(get_secondo_progr, wnds);

   ------------------------------------------------------------------------------

   -- Getter primo contatto per ni / tipo_contatto
   function get_primo_contatto
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
   ) return soggetti_rubrica.contatto%type;
   pragma restrict_references(get_primo_contatto, wnds);

   ------------------------------------------------------------------------------

   -- Getter secondo contatto per ni / tipo_contatto
   function get_secondo_contatto
   (
      p_ni            in soggetti_rubrica.ni%type
     ,p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
   ) return soggetti_rubrica.contatto%type;
   pragma restrict_references(get_secondo_contatto, wnds);

   ------------------------------------------------------------------------------

   -- Setter per (tipo_contatto=telefono fisso) e (progressivo=1)
   procedure set_telefono_fisso
   (
      p_ni     in soggetti_rubrica.ni%type
     ,p_value  in soggetti_rubrica.contatto%type
     ,p_utente in soggetti_rubrica.utente_agg%type default null
   );
   ------------------------------------------------------------------------------
   -- Setter per (tipo_contatto=cellulare) e (progressivo=1)
   procedure set_cellulare
   (
      p_ni     in soggetti_rubrica.ni%type
     ,p_value  in soggetti_rubrica.contatto%type
     ,p_utente in soggetti_rubrica.utente_agg%type default null
   );
   ------------------------------------------------------------------------------
   -- Setter per (tipo_contatto=numero_breve) e (progressivo=1)
   procedure set_numero_breve
   (
      p_ni     in soggetti_rubrica.ni%type
     ,p_value  in soggetti_rubrica.contatto%type
     ,p_utente in soggetti_rubrica.utente_agg%type default null
   );
   ------------------------------------------------------------------------------
   -- Setter per (tipo_contatto=email) e (progressivo=1)
   procedure set_email
   (
      p_ni     in soggetti_rubrica.ni%type
     ,p_value  in soggetti_rubrica.contatto%type
     ,p_utente in soggetti_rubrica.utente_agg%type default null
   );
   ------------------------------------------------------------------------------
   -- Setter per (tipo_contatto=fax) e (progressivo=1)
   procedure set_fax
   (
      p_ni     in soggetti_rubrica.ni%type
     ,p_value  in soggetti_rubrica.contatto%type
     ,p_utente in soggetti_rubrica.utente_agg%type default null
   );
   
   --------------------------------------------------------------------------------
   -- Setter per (tipo_contatto=email pec) e (progressivo=1)      
   procedure set_email_pec
   (
      p_ni     in soggetti_rubrica.ni%type
     ,p_value  in soggetti_rubrica.contatto%type
     ,p_utente in soggetti_rubrica.utente_agg%type default null
   );      
   function is_tipo_CONTATTO_ok
   (
      p_tipo_contatto       in soggetti_rubrica.tipo_contatto%type
   ) return afc_error.t_error_number ;
   function is_ri_ok
   ( p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
    ,p_inserting in number
    ,p_updating  in number
    ,p_deleting  in number   
   ) return afc_error.t_error_number;
   
    procedure chk_ri
   (
      p_tipo_contatto in soggetti_rubrica.tipo_contatto%type
     ,p_inserting in number
     ,p_updating  in number
     ,p_deleting  in number
   );
      
end soggetti_rubrica_pkg;
/

